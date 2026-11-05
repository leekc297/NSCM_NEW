=== FILE: business_analysis.md ===
# SCP0041 업무분석서 (As-is: `SCP0041_StockOSP`, 폼 Text `"Plant Qty"`)

> 이 문서는 AsisFacts 정적 추출 Fact Pack과 1차 분석서(analysis / web_components / tobe_design)만 근거로 작성했습니다. Fact Pack에 없는 업무 의미는 지어내지 않고 **확인 필요**로 표기했습니다.
> 함께 보는 문서: 화면설계서(screen_design.md) §5 액션 명세, 단위테스트(unit_test.md) 근거 열. 세 문서는 엔드포인트 이름을 똑같이 씁니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SCP0041 / `SCP0041_StockOSP` | 파일 구성 |
| 폼 표시명 | `"Plant Qty"` | props.csv Designer:765 |
| 도메인 | SCP (`GSCM.SCP.Forms.UIL\Master`) | 파일 경로 |
| 다루는 데이터 | ① OSP 재고(`Osp Stock` 시트, 원천 `SCM_DNM_STOCK_OSP`) ② Pack Hold 재고(`Pack Hold Stock` 시트, 원천 `SCM_DNM_STOCK_LOT_CONTROL`) | endpoints.csv objects |
| 범위(현행 기능) | 조회조건 초기화, 시트별 조회, `Pack Hold Stock` 저장(UPDATE) 후 재조회, 시트 탭 전환, 모델 검색 팝업, 엑셀 업로드·양식 다운로드 버튼 | flow.csv, events.csv |
| 범위 밖(미도달) | `SaveData` → `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA`. 어떤 진입점에도 연결되지 않습니다. 현행 기능으로 보지 않으며, TO-BE로 옮길지는 **확인 필요**입니다 | flow.csv unreached |
| 업무상 목적 문구(OSP 의미, Hold 사유 등) | Fact Pack에 없음 → **확인 필요** | - |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---:|---|---|---|---|
| S1 | 화면 열기 | `Form_Load` > InitControls > GetLookupData → `SCM.SCM0001_GET_LOOKUP_VALUES` 호출 / InitControls > setPeriod → `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] 호출 / InitSpread에서 시트 0 활성화 | 룩업 값 로드(어느 컨트롤에 바인딩되는지는 **확인 필요**). 기간 기본값은 결과 1행의 `FROM_VALUE`·`TO_VALUE`로 설정. 처음 활성 시트는 `Osp Stock` | flow.csv, meta_reads.csv, grid_code.csv InitSpread:195~196 |
| S2 | 시트 탭 클릭 | `SpdMain_SheetTabClick` > SetSelectMenu > setPeriod → `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] | 기간 기본값을 다시 설정. 조회조건 표시가 바뀌는지는 **확인 필요** | flow.csv |
| S3 | 모델 버튼(btnItemId) 클릭 | `BtnItemId_Click` | `txtItemId.Text = sItemId` (팝업 종류는 **확인 필요**) | props.csv :882 |
| S4 | Division 변경 | `CboDivision_SelectedIndexChanged` | 엔드포인트가 추출되지 않음. 처리 내용 **확인 필요** | events.csv |
| S5 | 조회(공통 툴바 Find) | FindButton > FindData_Main → `SCP.SCP0041_GET_STOCK_OSP` / FindButton > FindData_Pack → `SCP.SCP0041_GET_PACK_HOLD_STOCK` | 해당 시트 그리드에 결과 표시. 활성 시트에 따라 한쪽만 호출하는지 둘 다 호출하는지는 **확인 필요** | flow.csv |
| S6 | 편집(공통 툴바 Edit) | EditButton: `iFocusTabIndex == 1` ⟫ spdMain·fps 이름 일치일 때만 GetSheetInfo | 편집 모드 진입(Pack Hold Stock 대상으로 추정되나 **확인 필요**) | grid_code.csv EditButton:268 |
| S7 | 셀 수정 | `SpdMain_EditChange`, `ActiveSheet_CellChanged` | 엔드포인트 없음. 변경 표시 등 처리 내용 **확인 필요** | events.csv |
| S8 | 저장(공통 툴바 Save) | SaveButton > SaveDataPacker → `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` → FindData_Pack → `SCP.SCP0041_GET_PACK_HOLD_STOCK` | `SCM_DNM_STOCK_LOT_CONTROL` UPDATE, `SCM_SYS_LOG_BATCH` 로그 INSERT 후 `Pack Hold Stock` 재조회 | flow.csv, endpoints.csv |
| S9 | Upload 버튼 클릭 | `btnExcelUpload_Click` | 엔드포인트가 추출되지 않음. 대상 시트·저장 SP **확인 필요** (`SCM_ADM_EXCEL_COLUMNS` 1행 존재) | events.csv, dbmeta |
| S10 | Excel Form 버튼 클릭 | `btnExcelFormDownload_Click` | 엔드포인트가 추출되지 않음. 양식 내용 **확인 필요** | events.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 진입]
  └─ Form_Load
       ├─ InitControls > GetLookupData ──▶ SCM.SCM0001_GET_LOOKUP_VALUES
       ├─ InitControls > setPeriod ──────▶ biz:CommonData.CommonDataList [PERIOD_DEFAULT] → FROM_VALUE/TO_VALUE
       └─ CreateSpread(AddSheet: Osp Stock, Pack Hold Stock) → InitSpread(활성 시트 0 = Osp Stock)
            └─ SetSpreadInit → SetSheetHeaderColumn(메타 SCM_MST_SHEET_COLUMNS)
[조회조건 입력]  Division* · Plant Site · Model(+btnItemId) · Period* · Inspection · Status · Cutoff Date
  ├─ (탭 전환) SpdMain_SheetTabClick > SetSelectMenu > setPeriod ──▶ biz:CommonData.CommonDataList
  ├─ (모델 검색) BtnItemId_Click → txtItemId.Text
  └─ (Division 변경) CboDivision_SelectedIndexChanged → 처리 확인 필요
[조회] FindButton
  ├─ FindData_Main ──▶ SCP.SCP0041_GET_STOCK_OSP ──▶ Osp Stock 시트
  └─ FindData_Pack ──▶ SCP.SCP0041_GET_PACK_HOLD_STOCK ──▶ Pack Hold Stock 시트
     (둘 중 하나만인지, 둘 다인지는 확인 필요)
[편집] EditButton (iFocusTabIndex == 1) → SpdMain_EditChange / ActiveSheet_CellChanged
[저장] SaveButton > SaveDataPacker ──▶ SCP.SCP0041_SAVE_PACKER_HOLD_STOCK
       └─ FindData_Pack ──▶ SCP.SCP0041_GET_PACK_HOLD_STOCK (재조회)
[미도달] SaveData ──▶ SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA (진입점 없음 → 현행 흐름 아님)
```

## 4. 업무 규칙 (Fact Pack에 있는 사실만)

| # | 규칙 | 근거 | 비고 |
|---:|---|---|---|
| R1 | 필수 조회조건 표기: `Division*`, `Period*` (라벨 끝 `*`) | props.csv :519, :605 | 실제 필수 검증 코드·메시지는 **확인 필요** |
| R2 | Plant Site는 체크 목록 값을 `CODE` 기준으로 모아 전달 (`GetCheckedListValue`) | 메타 소비 메서드: SetChangedControl:520, FindData_Main:639/640, FindData_Pack:712/713/718 | FindData_Pack은 3곳(712/713/718)에서 사용. 718의 대상 컨트롤은 **확인 필요** |
| R3 | 기간 기본값 = `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] 결과 1행의 `FROM_VALUE`·`TO_VALUE` | meta_reads.csv setPeriod:558/559 | 적용 대상(dCalendar / dCalendarCutoff)은 **확인 필요**. 공통 SP `UP_FX_GetCommonDataList`가 `SCM_SYS_CALENDAR_M`, `FN_MULTY_TIME`을 참조 |
| R4 | 기간 기본값은 화면 진입 때와 시트 탭 전환 때 모두 다시 설정 | flow.csv (Form_Load, SpdMain_SheetTabClick 두 경로) | |
| R5 | 시트 초기화 분기: `sheetName.Equals("Osp Stock")`이면 시트 0, 아니면 시트 1을 ChangeSheet/InitSheet 한 뒤 메타로 헤더 생성 | grid_code.csv SetSpreadInit:203~211 | |
| R6 | 처음 활성 시트 = 0 (`Osp Stock`) | grid_code.csv InitSpread:195~196 | |
| R7 | 편집 진입 조건: `iFocusTabIndex == 1` ⟫ `spdMain != null` ⟫ `this.fps != null` ⟫ `fps.Name.Equals(spdMain.Name)` | grid_code.csv EditButton:268 | 인덱스 1의 의미(시트/탭)는 **확인 필요** |
| R8 | 저장 후 `Pack Hold Stock` 재조회 (SaveDataPacker > FindData_Pack) | flow.csv | |
| R9 | 저장 SP는 배열 분해 함수 `SCM_ARR_SPL_CNT`·`SCM_ARR_SPL_VAL`로 여러 행을 받아 `SCM_DNM_STOCK_LOT_CONTROL`을 UPDATE하고, `PR_SCM_SYS_LOG_BATCH`로 `SCM_SYS_LOG_BATCH`에 로그를 INSERT | endpoints.csv | 갱신 컬럼·키·검증 분기는 SP 원문 **확인 필요** |
| R10 | 조회 SP는 `STRING_SPLIT`로 다중값 조건을 분해하고, 모델 Nick Name은 `FN_GET_ITEM_NICKNAME`으로 구함 (Pack Hold는 사용자명 `FN_GET_USER_NAME`도 사용) | endpoints.csv | 분해 대상 파라미터는 **확인 필요** |
| R11 | 날짜·버킷 규칙(주/월 버킷 등) | Fact Pack에 없음 | **확인 필요** |
| R12 | SP 내부 IF 분기 조건 | Fact Pack에 없음(객체 참조만 추출됨) | **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| # | 엔드포인트 | SP | 호출 위치 | 읽기(SELECT/REF) | 쓰기 | 현행 여부 |
|---:|---|---|---|---|---|---|
| D1 | `SCM.SCM0001_GET_LOOKUP_VALUES` | `SCM0001_GET_LOOKUP_VALUES` | GetLookupData:165 (Form_Load) | SCM_ADM_LOOKUP_MASTER_DETAIL | - | 현행 |
| D2 | `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] | (Biz 공통) UP_FX_GetCommonDataList 코드분기 | setPeriod:549 (Form_Load, SpdMain_SheetTabClick) | SCM_SYS_CALENDAR_M, FN_MULTY_TIME | - | 현행 |
| D3 | `SCP.SCP0041_GET_STOCK_OSP` | `SCP0041_GET_STOCK_OSP` | FindData_Main:662 (FindButton) | SCM_DNM_STOCK_OSP, SCM_MST_SITE, SCM_MST_ITEM_SN, FN_GET_ITEM_NICKNAME, STRING_SPLIT | - | 현행 |
| D4 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | `SCP0041_GET_PACK_HOLD_STOCK` | FindData_Pack:740 (FindButton, SaveButton 후 재조회) | SCM_DNM_STOCK_LOT_CONTROL, SCM_MST_SITE, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO, FN_GET_ITEM_NICKNAME, FN_GET_USER_NAME, STRING_SPLIT | - | 현행 |
| D5 | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` | `SCP0041_SAVE_PACKER_HOLD_STOCK` | SaveDataPacker:469 (SaveButton) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | UPDATE SCM_DNM_STOCK_LOT_CONTROL / INSERT SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH) | 현행 |
| D6 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | `SCP0040_SAVE_CHARACTERISTIC_CAPA` | SaveData:354 (**진입점 미연결**) | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | MERGE SCP_MST_CHAR_CAPA / INSERT SCP_MST_CHAR_CAPA_H, SCM_SYS_LOG_BATCH (EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_MST_CHARACTERISTIC_HIST) | **미도달 — 현행 아님** |

## 6. Division·권한별 변형

| 항목 | 사실 | 근거 |
|---|---|---|
| Grid 컬럼 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 `Osp Stock` 14컬럼, `Pack Hold Stock` 15컬럼으로 같음. 선택 컬럼 0, 코드 분기 0건 | grid_effective.csv, Fact Pack §10·§12 |
| 코드 내 division 분기 | 추출 0건 | Fact Pack §12 |
| Division 변경 시 처리 | `CboDivision_SelectedIndexChanged` 내용 **확인 필요** | events.csv |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 9행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 (행 내용 **확인 필요**) | dbmeta |
| C/R/U/D | R: FindButton / U: SaveButton(UPDATE SCM_DNM_STOCK_LOT_CONTROL) / 편집 진입: EditButton / C·D: 업무 테이블 INSERT·DELETE 추출 없음(INSERT는 로그 SCM_SYS_LOG_BATCH뿐) | flow.csv, endpoints.csv |

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 연계(IF/RFC/파일 전송)는 없습니다.
- 엑셀 업로드·양식 다운로드(`btnExcelUpload_Click`, `btnExcelFormDownload_Click`)는 사용자 파일 입출력이며, 서버 처리 경로는 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---:|---|---|
| U1 | FindButton이 활성 시트에 따라 `SCP.SCP0041_GET_STOCK_OSP`·`SCP.SCP0041_GET_PACK_HOLD_STOCK` 중 하나만 부르는지, 둘 다 부르는지 | flow.csv 두 경로 |
| U2 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA`(`SCP0040_SAVE_CHARACTERISTIC_CAPA`, SaveData:354)를 TO-BE로 옮기지 않아도 되는지 | flow.csv unreached |
| U3 | 엑셀 업로드/양식 다운로드의 대상 시트·SP와 `SCM_ADM_EXCEL_COLUMNS` 1행의 관계 | events.csv, dbmeta |
| U4 | `CboDivision_SelectedIndexChanged` 처리(Plant Site 재조회 여부 등) | events.csv |
| U5 | `SCM.SCM0001_GET_LOOKUP_VALUES` 결과를 받는 컨트롤(cboStatus 여부) | GetLookupData:165 |
| U6 | PERIOD_DEFAULT 기본값 적용 대상(dCalendar / dCalendarCutoff) | meta_reads.csv |
| U7 | SetSelectMenu에서 시트별 조회조건 표시를 바꾸는지 | flow.csv |
| U8 | 저장 SP의 갱신 컬럼·키·검증 메시지 | endpoints.csv(객체만) |
| U9 | Inspection 라벨의 런타임 문구(`DefPackLabel.INSEPECTION_ID`) | props.csv InitControls:156 |
| U10 | TB_FX_SearchCondition 34행, TB_FX_GroupMenuAuth 9행의 내용 | dbmeta |
| U11 | TO-BE Oracle 전환 때 `STRING_SPLIT`(MSSQL 함수) 대체 방식 | endpoints.csv REF:STRING_SPLIT |

=== FILE: screen_design.md ===
# SCP0041 화면설계서 (As-is `SCP0041_StockOSP` → TO-BE React + Wijmo + Oracle)

> 근거: Fact Pack(controls.csv, props.csv, events.csv, flow.csv, grid_effective.csv, grid_code.csv)과 1차 분석서. 없는 사실은 **확인 필요**로 표기했습니다.
> 엔드포인트 이름은 업무분석서 §5와 같고, 컨트롤명은 단위테스트 절차 열에서 그대로 씁니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0041 |
| 화면 명칭(폼 Text) | `Plant Qty` (Designer:765) |
| 클래스 | `SCP0041_StockOSP` |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 존재) |
| 시트 | `Osp Stock`(인덱스 0, 처음 활성), `Pack Hold Stock`(인덱스 1) |
| Grid 구성 방식 | META(프레임워크, SCM_MST_SHEET_COLUMNS) + 코드 표시 변경(ColumnHeader 기본 스타일) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv + controls.csv parent 체인)

- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 0건). 화면은 Dock으로 위아래로 나뉩니다.
- 높이 비율: 조회조건 48 / 그리드 554, 합계 602 → **상 8% : 하 92%**.

```
this (SCP0041_StockOSP, Text "Plant Qty")
├─ [상] usrConditionPanel1  (UsrConditionPanel, Dock=Top, 1469×48, UsrPanelType=HidePanel)   ≈ 8%
│    └─ usrLayoutControl2   (UsrLayoutControl, Dock=Fill, 1469×48, Text "usrLayoutControl2")
│         └─ layoutControlGroup2 (1469×49)  ※ 아래 항목의 parent는 controls.csv에서 공란 — 그룹 소속은 Designer 관례상 추정
│              ├─ Division            75×29  → cboDivision     "Division*"
│              ├─ layoutControlItem7 172×29  → clbPlantSite    "Plant Site"
│              ├─ emptySpaceItem1     12×29
│              ├─ lblItemId          141×29  → txtItemId       "Model"
│              ├─ layoutControlItem4  43×29  → btnItemId       (Text 없음)
│              ├─ layoutControlItem1 103×29  → btnExcelUpload  (버튼 Text "Upload")
│              ├─ layoutControlItem2 103×29  → formDown        (버튼 Text "Excel Form", 항목 Text "layoutControlItem1")
│              ├─ layoutControlItem5 260×29  → dCalendar       "Period*"
│              ├─ layoutInspection   166×29  → txtInspection   "Inspection" (런타임 DefPackLabel.INSEPECTION_ID)
│              ├─ layStatus          114×29  → cboStatus       "Status"
│              └─ layoutCutoffDate   260×29  → dCalendarCutoff "Cutoff Date"
├─ [하] spdMain  (FpSpread, Dock=Fill, 1469×554)                                               ≈ 92%
│    ├─ 시트 탭 0: Osp Stock        (AddSheet SpdSheet.shtMain)
│    ├─ 시트 탭 1: Pack Hold Stock  (AddSheet SpdSheet.shtPacker)
│    └─ spdMain_Sheet1 (SheetView, Designer 기본 시트)
└─ (부모 없음) usrButton1 (UsrButton, 75×23) — 화면에 배치되지 않음, 용도 확인 필요
```

- 항목 너비 합계는 75+172+12+141+43+103+103+260+166+114+260 = 1449로, 그룹 너비 1469 안에 한 줄로 들어갑니다. 실제 좌표(Location)와 배치 순서는 Fact Pack에 없어 **확인 필요**입니다(위 순서는 controls.csv 선언 순서). 높이 29 한 줄은 패널 높이 48과 맞습니다.

### 2-2. 텍스트 와이어프레임

```
┌───────────────────────────────────────────────────────────────────────────────────────────────┐
│ [조회조건 usrConditionPanel1 · HidePanel · 8%]                                               │
│ Division*[cboDivision▼] Plant Site[clbPlantSite▼] Model[txtItemId][btnItemId]                │
│ [Upload] [Excel Form] Period*[dCalendar ~ ] Inspection[txtInspection] Status[cboStatus▼]     │
│ Cutoff Date[dCalendarCutoff ~ ]          (※ 실제 순서·줄바꿈 확인 필요)                     │
├───────────────────────────────────────────────────────────────────────────────────────────────┤
│ [그리드 spdMain · 92%]                                                                        │
│  ┌ Osp Stock ┐┌ Pack Hold Stock ┐                                                           │
│  │ 메타 컬럼 14 / 15개                                                                        │
│  └────────────────────────────────────────────────────────────────────────────────────────── │
└───────────────────────────────────────────────────────────────────────────────────────────────┘
[툴바(공통)] Find · Save · Edit  (오버라이드 FindButton / SaveButton / EditButton)
[팝업] btnItemId → 모델 검색 팝업(종류 확인 필요)
```

## 3. 컨트롤 명세

| # | 컨트롤명 | 타입 | 라벨 (props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---:|---|---|---|---|---|---|---|
| 1 | `usrConditionPanel1` | UsrConditionPanel | - | HidePanel, Dock Top | - | - | 공용 조회조건 영역 |
| 2 | `usrLayoutControl2` | UsrLayoutControl | `"usrLayoutControl2"` | Dock Fill | - | - | 조회조건 레이아웃(공용) |
| 3 | `cboDivision` | UsrCombo | `"Division*"` (Division 항목) | 확인 필요 | Y (`*`) | `CboDivision_SelectedIndexChanged` | 공용 Division 콤보 |
| 4 | `clbPlantSite` | UsrCheckedList | `"Plant Site"` (layoutControlItem7) | 확인 필요 | N | (GetCheckedListValue CODE) | 공용 멀티선택 콤보 |
| 5 | `txtItemId` | UsrMultiLineEditor | `"Model"` (lblItemId) | 공란(확인 필요) | N | `BtnItemId_Click` 결과 반영(:882) | 멀티라인 입력 |
| 6 | `btnItemId` | UsrButton | (Text 없음, layoutControlItem4) | - | - | `BtnItemId_Click` | 모델 검색 팝업 버튼 |
| 7 | `btnExcelUpload` | UsrButton | `"Upload"` | - | - | `btnExcelUpload_Click` | 엑셀 업로드 버튼 |
| 8 | `formDown` | UsrButton | `"Excel Form"` (항목 Text `"layoutControlItem1"`) | - | - | `btnExcelFormDownload_Click` | 엑셀 양식 다운로드 버튼 |
| 9 | `dCalendar` | UsrDateRangePicker3 | `"Period*"` (layoutControlItem5) | PERIOD_DEFAULT FROM/TO(적용 대상 확인 필요) | Y (`*`) | (setPeriod) | 공용 기간 컨트롤 |
| 10 | `txtInspection` | UsrMultiLineEditor | `"Inspection"` → 런타임 `DefPackLabel.INSEPECTION_ID` | 확인 필요 | N | - | 멀티라인 입력 |
| 11 | `cboStatus` | UsrCombo | `"Status"` (layStatus) | 확인 필요 | N | - | 공용 콤보 |
| 12 | `dCalendarCutoff` | UsrDateRangePicker3 | `"Cutoff Date"` (layoutCutoffDate) | 확인 필요 | N | (setPeriod 대상 여부 확인 필요) | 공용 기간 컨트롤 |
| 13 | `spdMain` | FpSpread | - | 활성 시트 0 (`Osp Stock`) | - | `SpdMain_SheetTabClick`, `SpdMain_EditChange`, `ActiveSheet_CellChanged`(siMain.ActiveSheet) | Wijmo FlexGrid + 시트 탭 |
| 14 | `spdMain_Sheet1` | SheetView | - | Designer 기본 시트 | - | - | (FlexGrid 내부, 별도 컴포넌트 없음) |
| 15 | `usrButton1` | UsrButton | (Text 없음, Size 75×23) | - | - | 없음 | 없음(부모 미지정 → 용도 확인 필요) |

## 4. 그리드 명세

공통: 모든 컬럼은 `SetSheetHeaderColumn`(SetSpreadInit:211)이 메타 `SCM_MST_SHEET_COLUMNS`로 생성합니다(출처 META). 14개 division 모두 `기본` 표시이며 division마다 다르지 않습니다. 타입·편집 가능 여부·폭·정렬은 메타 컬럼(CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE 등) 원문이 Fact Pack에 없어 **확인 필요**입니다.

### 4-1. `Osp Stock` (14컬럼, 조회 `SCP.SCP0041_GET_STOCK_OSP`)

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | ATTRIBUTE1 | Valuation Type | 확인 필요 | META | 14개 전부 표시 | 확인 필요 |
| 2 | ATTRIBUTE2 | Cell From Site | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 3 | ATTRIBUTE3 | Box | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 4 | COMMENT | Comment | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 5 | CREATED_BY | Created By | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 6 | CREATION_DATE | Creation Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 7 | DIVISION_ID | Division* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 8 | ITEM_ID | Model* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 9 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 10 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 11 | NICK_NAME | Nick Name | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 12 | QTY | Qty* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 13 | SITE_DESCRIPTION | Plant Site* | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 14 | YYYYMMDD | Date* | 확인 필요 | META | 전부 표시 | 확인 필요 |

※ 순서는 grid_effective.csv 행 순서입니다. 실제 표시 순서는 메타 원문 **확인 필요**. 현행 경로에는 이 시트의 저장 경로가 없습니다.

### 4-2. `Pack Hold Stock` (15컬럼, 조회 `SCP.SCP0041_GET_PACK_HOLD_STOCK` / 저장 `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK`)

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 |
|---:|---|---|---|---|---|---|
| 1 | CREATION_DATE | Create Date | 확인 필요 | META | 14개 전부 표시 | 확인 필요 |
| 2 | CUTOFF_DATE | Cutoff Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 3 | DATE_FINISH_REAL | 실제 완료일 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 4 | DATE_FORECAST_FINISH | 예상 완료일 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 5 | DATE_FORECAST_START | 예상 시작일 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 6 | DIR | Status | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 7 | INSPECTION_ID | 관리번호 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 8 | MODIFIER | 수정자 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 9 | MODIFIER_DATE | Change Date | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 10 | NICK_NAME | Nick Name | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 11 | PLANT_ID | PLANT | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 12 | PROD_ID | Model | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 13 | QTY | 수량 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 14 | REQUSET_USER | 변경점 신청자 | 확인 필요 | META | 전부 표시 | 확인 필요 |
| 15 | SITE_DESCRIPTION | Plant Site | 확인 필요 | META | 전부 표시 | 확인 필요 |

※ `REQUSET_USER`는 메타 원문 표기를 그대로 옮겼습니다. 헤더에 한국어와 영어가 섞여 있습니다(메타 원문).

### 4-3. 코드로 바꾸는 표시 (HARDCODED/EXPR, Designer)

| 줄 | 속성 | 값 | 범위 |
|---:|---|---|---|
| 665 | HorizontalAlignment | General | ColumnHeader 기본 스타일 |
| 666 | NoteIndicatorColor | Red | ColumnHeader 기본 스타일 |
| 667 | Parent | ColumnHeaderDefaultEnhanced | ColumnHeader 기본 스타일 |
| 668 | VerticalAlignment | General | ColumnHeader 기본 스타일 |

## 5. 액션 명세

| # | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---:|---|---|---|---|---|
| A1 | 화면 Load | `Form_Load` | InitControls > GetLookupData | `SCM.SCM0001_GET_LOOKUP_VALUES` | 룩업 바인딩(대상 컨트롤 확인 필요) |
| A2 | 화면 Load | `Form_Load` | InitControls > setPeriod (PERIOD_DEFAULT) | `biz:CommonData.CommonDataList` | FROM_VALUE/TO_VALUE를 기간 컨트롤에 설정 |
| A3 | 시트 탭 클릭 | `SpdMain_SheetTabClick` | SetSelectMenu > setPeriod | `biz:CommonData.CommonDataList` | 기간 기본값 다시 설정. 조회조건 표시 전환 확인 필요 |
| A4 | 툴바 Find | FindButton (오버라이드) | FindData_Main | `SCP.SCP0041_GET_STOCK_OSP` | `Osp Stock` 시트 바인딩 |
| A5 | 툴바 Find | FindButton (오버라이드) | FindData_Pack | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | `Pack Hold Stock` 시트 바인딩 (A4·A5 분기 방식 확인 필요) |
| A6 | 툴바 Save | SaveButton (오버라이드) | SaveDataPacker → FindData_Pack | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` → `SCP.SCP0041_GET_PACK_HOLD_STOCK` | 저장 후 `Pack Hold Stock` 재조회 |
| A7 | 툴바 Edit | EditButton (오버라이드) | `iFocusTabIndex == 1`일 때 GetSheetInfo | 없음 | 편집 모드 |
| A8 | btnItemId 클릭 | `BtnItemId_Click` | 모델 검색 → `txtItemId.Text = sItemId` | 없음(추출 안 됨) | txtItemId 값 설정 |
| A9 | cboDivision 변경 | `CboDivision_SelectedIndexChanged` | 확인 필요 | 추출 안 됨 | 확인 필요 |
| A10 | btnExcelUpload 클릭 | `btnExcelUpload_Click` | 확인 필요 | 추출 안 됨 | 확인 필요 |
| A11 | formDown 클릭 | `btnExcelFormDownload_Click` | 확인 필요 | 추출 안 됨 | 확인 필요 |
| A12 | spdMain 셀 편집 | `SpdMain_EditChange` | 확인 필요 | 없음 | 확인 필요 |
| A13 | ActiveSheet 셀 변경 | `ActiveSheet_CellChanged` | 확인 필요 | 없음 | 확인 필요 |
| A14 | (진입점 없음) | SaveData | 미도달 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | **현행 UI 액션 아님** — TO-BE 이관 제외 후보(확인 필요) |

## 6. 검증·메시지

| 항목 | 사실 |
|---|---|
| 필수 표기 | `Division*`, `Period*` (라벨). 검증 코드·메시지 ID는 **확인 필요** |
| 그리드 필수 표기 | `Osp Stock` 헤더 `Division*`, `Model*`, `Qty*`, `Plant Site*`, `Date*` (메타 라벨). 검증 로직은 **확인 필요** |
| 저장 성공/실패 메시지 | Fact Pack에 없음 → **확인 필요** |
| 빈 결과 메시지 | Fact Pack에 없음 → **확인 필요** |

## 7. 권한 (C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R | FindButton 오버라이드 → `SCP.SCP0041_GET_STOCK_OSP`, `SCP.SCP0041_GET_PACK_HOLD_STOCK` |
| U | SaveButton 오버라이드 → `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` (UPDATE SCM_DNM_STOCK_LOT_CONTROL) |
| 편집 진입 | EditButton 오버라이드 (`iFocusTabIndex == 1`) |
| C / D | 업무 테이블 INSERT/DELETE 경로 추출 없음 |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 9행 (내용 **확인 필요**) |

## 8. To-Be 전환 메모 (Wijmo·Oracle 관점)

| # | 항목 | As-is | To-Be 메모 |
|---:|---|---|---|
| M1 | 그리드 | FpSpread `spdMain` + 시트 2개 | Wijmo FlexGrid + 탭 2개(`Osp Stock`, `Pack Hold Stock`). 컬럼은 메타 기반 공통 구성 사용 |
| M2 | 조회조건 | UsrConditionPanel(HidePanel) + LayoutControl | 공용 조회조건 영역. Radio/Check 없음 |
| M3 | 다중값 분해 | SP 내부 `STRING_SPLIT`(MSSQL) | Oracle에는 같은 함수가 없음 → PKG 안에서 대체 구현 필요(방식은 프로젝트 공통 규칙에 따름) |
| M4 | 배열 분해 | `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL` | Oracle 대응 객체 존재 여부 **확인 필요** |
| M5 | 기간 기본값 | `biz:CommonData.CommonDataList` PERIOD_DEFAULT | 공용 기간 컨트롤 기본값 API로 옮김 |
| M6 | 미도달 코드 | SaveData → `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | 현행 UI 액션이 아니므로 화면 기능으로 구현하지 않음(확정 전 확인 필요) |
| M7 | 엑셀 | `btnExcelUpload`, `formDown` | 업로드 대상·SP를 확인한 뒤 설계 |
| M8 | 다국어 | 헤더 한국어/영어 혼재, `DefPackLabel.INSEPECTION_ID` | LBL 매핑 필요 |

## 9. 미확정

1. FindButton 시트 분기 방식(A4·A5).
2. `btnExcelUpload_Click`·`btnExcelFormDownload_Click`·`CboDivision_SelectedIndexChanged`·`SpdMain_EditChange`·`ActiveSheet_CellChanged`의 처리 내용.
3. `BtnItemId_Click` 팝업 종류.
4. `SCM.SCM0001_GET_LOOKUP_VALUES` 결과 바인딩 컨트롤.
5. PERIOD_DEFAULT 적용 대상(`dCalendar` / `dCalendarCutoff`).
6. 조회조건 항목의 실제 배치 순서·좌표와 시트별 표시 전환.
7. 그리드 컬럼 타입·편집 가능 여부·순서(메타 원문).
8. `usrButton1` 용도, `spdMain_Sheet1`과 AddSheet 시트의 관계.
9. `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` 이관 제외 확정.

=== FILE: unit_test.md ===
# SCP0041 단위테스트 케이스

> 컨트롤명은 화면설계서 §3, 엔드포인트는 업무분석서 §5와 화면설계서 §5와 같은 이름을 씁니다. Fact Pack에 없는 기대값은 "확인 필요"로 적었습니다. 주석 처리된 호출은 0건이라 대상이 없습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0041-001 | 초기화 | 사용자 로그인, 메뉴 권한 있음 | 화면을 연다 | - | `SCM.SCM0001_GET_LOOKUP_VALUES` 1회 호출, 룩업 값 로드(바인딩 컨트롤 확인 필요) | `Form_Load` > GetLookupData:165 / `SCM.SCM0001_GET_LOOKUP_VALUES` / SP `SCM0001_GET_LOOKUP_VALUES` |
| TC-SCP0041-002 | 초기화 | 공통데이터 PERIOD_DEFAULT 존재 | 화면을 열고 `dCalendar`·`dCalendarCutoff` 값을 확인한다 | - | 기간 컨트롤에 PERIOD_DEFAULT 결과 1행의 FROM_VALUE~TO_VALUE가 설정됨(적용 대상 확인 필요) | `Form_Load` > setPeriod:549 / `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] |
| TC-SCP0041-003 | 초기화 | - | 화면을 열고 `spdMain`의 활성 탭을 확인한다 | - | 탭 `Osp Stock`, `Pack Hold Stock` 2개가 보이고 활성 탭은 `Osp Stock` | InitSpread:195~196 / `Form_Load` / 시트 `Osp Stock`, `Pack Hold Stock` |
| TC-SCP0041-004 | 초기화 | - | 조회조건 라벨을 확인한다 | - | `cboDivision`="Division*", `clbPlantSite`="Plant Site", `txtItemId`="Model", `dCalendar`="Period*", `txtInspection`=DefPackLabel.INSEPECTION_ID 문구(확인 필요), `cboStatus`="Status", `dCalendarCutoff`="Cutoff Date", `btnExcelUpload`="Upload", `formDown`="Excel Form" | props.csv / `Form_Load` |
| TC-SCP0041-005 | 그리드 | 활성 탭 `Osp Stock` | `spdMain` 헤더를 확인한다 | - | 14컬럼: Valuation Type, Cell From Site, Box, Comment, Created By, Creation Date, Division*, Model*, Last Update Date, Last Updated By, Nick Name, Qty*, Plant Site*, Date* (순서는 메타 원문 확인 필요) | 시트 `Osp Stock` / SetSheetHeaderColumn@SetSpreadInit:211 |
| TC-SCP0041-006 | 그리드 | 탭 `Pack Hold Stock` 선택 | `spdMain` 헤더를 확인한다 | - | 15컬럼: Create Date, Cutoff Date, 실제 완료일, 예상 완료일, 예상 시작일, Status, 관리번호, 수정자, Change Date, Nick Name, PLANT, Model, 수량, 변경점 신청자, Plant Site | 시트 `Pack Hold Stock` / SetSheetHeaderColumn@SetSpreadInit:211 |
| TC-SCP0041-007 | 조회 | 활성 탭 `Osp Stock`, 데이터 있음 | `cboDivision` 선택, `clbPlantSite` 체크, `dCalendar` 기간 입력 후 툴바 Find | Division=테스트 Division, Plant Site 1건 이상 | `SCP.SCP0041_GET_STOCK_OSP` 호출, Plant Site는 CODE 값으로 전달, `Osp Stock` 시트에 결과 표시 | FindButton > FindData_Main:662 / `SCP.SCP0041_GET_STOCK_OSP` / SP `SCP0041_GET_STOCK_OSP` / 시트 `Osp Stock` |
| TC-SCP0041-008 | 조회 | 탭 `Pack Hold Stock`, 데이터 있음 | `cboDivision`, `clbPlantSite`, `txtInspection`, `cboStatus`, `dCalendarCutoff` 입력 후 툴바 Find | Inspection·Status·Cutoff 값 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` 호출, `Pack Hold Stock` 시트에 결과 표시 | FindButton > FindData_Pack:740 / `SCP.SCP0041_GET_PACK_HOLD_STOCK` / SP `SCP0041_GET_PACK_HOLD_STOCK` / 시트 `Pack Hold Stock` |
| TC-SCP0041-009 | 조회 | 탭별로 각각 실행 | 툴바 Find 한 번 실행 후 호출된 엔드포인트를 기록한다 | - | 활성 시트 엔드포인트만 호출되는지, 두 엔드포인트가 모두 호출되는지 기록(As-is 기대값 확인 필요) | FindButton / `SCP.SCP0041_GET_STOCK_OSP`, `SCP.SCP0041_GET_PACK_HOLD_STOCK` |
| TC-SCP0041-010 | 조회 | 해당 조건 데이터 없음 | `Osp Stock` 탭에서 결과가 없는 조건으로 Find | 데이터 없는 기간 | 그리드 0행, 오류 없음(빈 결과 메시지 확인 필요) | `SCP.SCP0041_GET_STOCK_OSP` / 시트 `Osp Stock` |
| TC-SCP0041-011 | 조회 | 해당 조건 데이터 없음 | `Pack Hold Stock` 탭에서 결과가 없는 조건으로 Find | 존재하지 않는 `txtInspection` 값 | 그리드 0행, 오류 없음(메시지 확인 필요) | `SCP.SCP0041_GET_PACK_HOLD_STOCK` / 시트 `Pack Hold Stock` |
| TC-SCP0041-012 | 조회 | SP 오류 유도(권한 회수 등) | 툴바 Find | - | 오류 메시지 표시, 그리드 기존 상태 유지(메시지 원문 확인 필요) | `SCP.SCP0041_GET_STOCK_OSP` / `SCP.SCP0041_GET_PACK_HOLD_STOCK` (오류 응답) |
| TC-SCP0041-013 | 조회 | 필수 조회조건 비움 | `cboDivision` 또는 `dCalendar`를 비우고 Find | Division 빈값 / Period 빈값 | 필수값 검증 동작(메시지·차단 여부 확인 필요) | 라벨 `Division*`, `Period*` / FindButton |
| TC-SCP0041-014 | 저장 | `Pack Hold Stock` 조회 완료, 편집 모드 | 셀 값 수정 후 툴바 Save | 수정 행 1건 이상 | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` 호출 → SCM_DNM_STOCK_LOT_CONTROL UPDATE, SCM_SYS_LOG_BATCH 로그 1건 이상 → `SCP.SCP0041_GET_PACK_HOLD_STOCK`로 재조회되어 수정값 표시 | SaveButton > SaveDataPacker:469 > FindData_Pack:740 / SP `SCP0041_SAVE_PACKER_HOLD_STOCK` / 시트 `Pack Hold Stock` |
| TC-SCP0041-015 | 저장 | 저장 SP 오류 유도 | Save | 잘못된 값(검증 대상은 SP 원문 확인 필요) | 오류 메시지 표시, 데이터 변경 없음, 재조회 안 함(확인 필요) | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` (오류 응답) |
| TC-SCP0041-016 | 저장 | 수정 없음 | 아무것도 바꾸지 않고 Save | - | 저장 대상 없음 처리(메시지 확인 필요), UPDATE 0건 | SaveButton / `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` |
| TC-SCP0041-017 | 저장 | 화면의 모든 버튼·탭·툴바 조작 | Find/Save/Edit, 탭 전환, 모든 버튼을 실행하며 호출 로그를 확인한다 | - | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA`(`SCP0040_SAVE_CHARACTERISTIC_CAPA`)가 한 번도 호출되지 않음(미도달 확인용 음성 테스트) | SaveData:354 unreached / `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` |
| TC-SCP0041-018 | 이벤트 | 화면 열림 | `spdMain`에서 `Pack Hold Stock` 탭 클릭 → 다시 `Osp Stock` 탭 클릭 | - | 탭을 클릭할 때마다 `biz:CommonData.CommonDataList`(PERIOD_DEFAULT)가 호출되어 기간 기본값이 다시 설정됨. 조회조건 표시 전환 여부 기록(확인 필요) | `SpdMain_SheetTabClick` > SetSelectMenu > setPeriod:549 / `biz:CommonData.CommonDataList` / 시트 `Osp Stock`, `Pack Hold Stock` |
| TC-SCP0041-019 | 이벤트 | 화면 열림 | `btnItemId` 클릭 → 팝업에서 모델 선택 | 모델 1건 이상 | `txtItemId.Text`에 선택 모델(sItemId)이 들어감 | `BtnItemId_Click` :882 |
| TC-SCP0041-020 | 이벤트 | 화면 열림 | `cboDivision` 값을 바꾼다 | Division A → B | 처리 결과 기록(`clbPlantSite` 목록이 바뀌는지 등 확인 필요), 오류 없음 | `CboDivision_SelectedIndexChanged` (InitEvent:220) |
| TC-SCP0041-021 | 이벤트 | 화면 열림 | `btnExcelUpload` 클릭 → 파일 선택 | 엑셀 양식 파일 | 업로드 처리(대상 시트·저장 SP 확인 필요), 오류 없음 | `btnExcelUpload_Click` (InitializeComponent:380) |
| TC-SCP0041-022 | 이벤트 | 화면 열림 | `formDown` 클릭 | - | 엑셀 양식 파일이 내려받아짐(양식 컬럼 확인 필요) | `btnExcelFormDownload_Click` (InitializeComponent:419) |
| TC-SCP0041-023 | 이벤트 | `Pack Hold Stock` 조회·편집 모드 | `spdMain` 셀에 값을 입력한다(편집 중) | 임의 값 | 편집 중 처리 동작 기록(변경 표시 등 확인 필요) | `SpdMain_EditChange` (InitEvent:223) / 시트 `Pack Hold Stock` |
| TC-SCP0041-024 | 이벤트 | `Pack Hold Stock` 조회·편집 모드 | 셀 값을 바꾸고 포커스를 옮긴다 | 임의 값 | 셀 변경 처리 동작 기록(행 상태 표시 등 확인 필요) | `ActiveSheet_CellChanged` (InitEvent:224) |
| TC-SCP0041-025 | 권한 | 탭 `Pack Hold Stock` (iFocusTabIndex == 1) | 툴바 Edit | - | 편집 모드 진입(GetSheetInfo 수행) | EditButton:268 / 시트 `Pack Hold Stock` |
| TC-SCP0041-026 | 권한 | 탭 `Osp Stock` | 툴바 Edit | - | `iFocusTabIndex == 1` 조건이 아니면 GetSheetInfo를 하지 않음(화면상 결과 확인 필요) | EditButton:268 / 시트 `Osp Stock` |
| TC-SCP0041-027 | 권한 | 조회 전용 권한 그룹 사용자 | 화면을 열고 툴바 버튼 노출을 확인한다 | - | TB_FX_GroupMenuAuth 설정에 따름(기대값 확인 필요) | TB_FX_GroupMenuAuth 9행 / SaveButton / `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` |
| TC-SCP0041-028 | division | Division 40, 81, 82, EE 사용자(또는 선택) | 각 Division으로 `Osp Stock` 조회 | Division=40/81/82/EE | 모든 Division에서 14컬럼 구성이 같음 | grid_effective.csv / 시트 `Osp Stock` / `SCP.SCP0041_GET_STOCK_OSP` |
| TC-SCP0041-029 | division | Division 40, 81, 82, EE | 각 Division으로 `Pack Hold Stock` 조회 | Division=40/81/82/EE | 모든 Division에서 15컬럼 구성이 같음 | grid_effective.csv / 시트 `Pack Hold Stock` / `SCP.SCP0041_GET_PACK_HOLD_STOCK` |
| TC-SCP0041-030 | division | 81 하위(81_HD 등)·EE 하위 Division | 하위 Division으로 두 시트를 조회한다 | Division=81_HD, EE_UC 등 | 컬럼 수 `Osp Stock` 14 / `Pack Hold Stock` 15 그대로 | grid_effective.csv (14개 division 공통) |

## 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001~004 |
| | `SpdMain_SheetTabClick` | 018 |
| | `BtnItemId_Click` | 019 |
| | `CboDivision_SelectedIndexChanged` | 020 |
| | `btnExcelUpload_Click` | 021 |
| | `btnExcelFormDownload_Click` | 022 |
| | `SpdMain_EditChange` | 023 |
| | `ActiveSheet_CellChanged` | 024 |
| 엔드포인트 | `SCM.SCM0001_GET_LOOKUP_VALUES` | 001 |
| | `biz:CommonData.CommonDataList` | 002, 018 |
| | `SCP.SCP0041_GET_STOCK_OSP` | 007, 010, 012, 028 |
| | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | 008, 011, 012, 014, 029 |
| | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` | 014, 015, 016 |
| | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | 017 (미도달 음성 테스트) |
| 시트 | `Osp Stock` | 003, 005, 007, 010, 028 |
| | `Pack Hold Stock` | 003, 006, 008, 011, 014, 029 |
| 빈 결과 / 오류 응답 | | 010, 011 / 012, 015 |
