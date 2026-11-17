# SCP0033 Shipment Semi Dept Day — 화면설계서

> 근거: Fact Pack(SCP0033)의 controls.csv, props.csv, events.csv, grid_code.csv, grid_effective.csv
> 사실이 없는 항목은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0033 |
| 화면 명칭(Form Text) | `SCP0033_Shipment_semi_dept_day` (Designer.cs:310) |
| 시트명 | `Shipment Semi Dept Day` |
| 메뉴 위치 | **확인 필요**(TB_FX_MenuItemInfo 1행, 내용 미포함) |
| 화면 유형 | 조회조건 + 단일 그리드 마스터 편집(조회·행추가·저장) |

## 2. 화면 레이아웃

### 2-1. 분할 구조 판정
- props.csv에는 **SplitContainer가 없습니다**(Orientation·SplitterDistance 속성 0건). 화면은 Dock만으로 나뉩니다.
- parent 체인(controls.csv):
  - `this` → `usrConditionPanel1` (Dock Top, 1168×48, UsrPanelType HidePanel)
    - → `usrLayoutControl2` (Dock Fill, 1168×48, Text "usrLayoutControl2")
      - → `txtItemId`, `cboValidYN`, `clbDivision`
  - `this` → `spdMain` (Dock Fill, 1168×544) → 시트 `spdMain_Sheet1`(SheetView, parent 미기재)
  - `usrLayoutControl1` (Dock Fill, 657×184): **parent 빈값이라 트리 위치는 확인 필요**. layoutControlGroup1(657×184)도 같음
- 상/하 비율(Designer 크기 기준): 48 : 544 = **약 8.1% : 91.9%**

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────── this (SCP0033_Shipment_semi_dept_day) 1168 × 592 ───────────────────────────┐
│ usrConditionPanel1 [Dock Top · 1168×48 · HidePanel]                                         ≈ 8.1 %  │
│ └ usrLayoutControl2 [Dock Fill · 1168×48] / layoutControlGroup2 1168×48                               │
│   ┌ Model (239×28) ┐┌──── emptySpaceItem3 (473×28) ────┐┌ Valid (189×28) ┐┌ Division (247×28) ┐     │
│   │ txtItemId      ││                                  ││ cboValidYN     ││ clbDivision        │     │
│   └────────────────┘└──────────────────────────────────┘└────────────────┘└────────────────────┘     │
│   ※ 배치 순서 = Designer 선언 순서. 실제 Location 좌표는 확인 필요                                    │
├──────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ spdMain [FpSpread · Dock Fill · 1168×544]                                                  ≈ 91.9 %  │
│ └ spdMain_Sheet1 → 시트 "Shipment Semi Dept Day"                                                       │
│   | Division* | Model* | Nick Name | Operation Group | Departure day | Valid | Created By | ...        │
└──────────────────────────────────────────────────────────────────────────────────────────────────────┘
 (트리 위치 미확인: usrLayoutControl1 / layoutControlGroup1 657×184, imageList1)
 버튼 영역: 화면 Designer 에 버튼 컨트롤 없음 — Find/Save/Insert/Edit 는 프레임워크 공통 툴바 오버라이드(FindButton/SaveButton/InsertButton/EditButton)
 팝업: Fact Pack 에 없음
```

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수여부 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrLayoutControl1 | GSCM UsrLayoutControl (Dock Fill, 657×184) | - | - | - | - | 확인 필요(트리 위치 미확인) |
| usrConditionPanel1 | GSCM UsrConditionPanel (Dock Top, 1168×48, HidePanel) | - | - | - | - | 공통 조회조건 패널 |
| usrLayoutControl2 | GSCM UsrLayoutControl (Dock Fill, 1168×48) | `usrLayoutControl2` (컨트롤 Text, 화면 라벨 아님) | - | - | - | 조회조건 레이아웃(공통) |
| txtItemId | TextBox (198×24) | `Model` (layoutControlItem13) | 확인 필요 | 확인 필요 | - | 텍스트 입력 |
| cboValidYN | GSCM UsrCombo (155×20) | `Valid` (layoutControlItem3) | 확인 필요 | 확인 필요 | - | Wijmo ComboBox. 항목 소스는 확인 필요(`biz:CommonData.YesOrNo` 후보, 바인딩 미확인) |
| clbDivision | GSCM UsrCheckedList (199×21) | `Division` (layoutControlItem4) | 확인 필요 | 확인 필요 | 조회 시 GetCheckedListValue(CODE) | Wijmo MultiSelect |
| spdMain | FarPoint FpSpread (Dock Fill, 1168×544) | - | - | - | CellClick → `SpdMain_CellClick`, KeyPress → `SpdMain_KeyPress`, TopChange → `SpdMain_TopChange` | Wijmo FlexGrid |
| spdMain_Sheet1 | FarPoint SheetView | - (시트명 `Shipment Semi Dept Day`) | - | - | - | FlexGrid 컬럼 정의(메타) |

참고(보조 컨트롤): layoutControlGroup1, layoutControlGroup2, layoutControlItem13, layoutControlItem3, layoutControlItem4, emptySpaceItem3(473×28 여백), imageList1(용도 확인 필요)

## 4. 그리드 명세 — 시트 `Shipment Semi Dept Day`

- 구성: META(`SetSheetHeaderColumn`@InitSpread:161, 컬럼 헤더 1행) + 코드 보정(InsertButton:204 DIVISION_ID Combo, Designer 270~273 헤더 스타일)
- 시트 생성 인자: `AddSheet(spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30)` (CreateSpread:147)

| 컬럼 | 헤더(메타 원문) | 타입 | 출처 | division별 표시(40 / 81계열 / 82 / EE계열) | 편집 가능 |
|---|---|---|---|---|---|
| DIVISION_ID | Division* | 행 추가 시 Combo(BLUtils.GetDivision(false,"")). 기존 행은 확인 필요 | META (+코드) | 기본 / 기본 / 기본 / 기본 | 신규 행 콤보 선택. 기존 행은 확인 필요 |
| ITEM_ID | Model* | 확인 필요 | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| NICK_NAME | Nick Name | 확인 필요 | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| OPERATION_GROUP | Operation Group | 확인 필요 | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| DEPARTURE_DAY | Departure day | 확인 필요(LookupCommon 콤보 후보, 미확인) | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| VALID_YN | Valid | 확인 필요(YesOrNo 콤보 후보, 미확인) | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| S_VALID_YN | S_VALID_YN | 확인 필요 | META | 숨김 / 숨김 / 숨김 / 숨김 | - |
| CREATED_BY | Created By | 확인 필요 | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| CREATION_DATE | Creation Date | 확인 필요 | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |
| LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 기본 / 기본 / 기본 / 기본 | 확인 필요 |

- 81계열 = 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC / EE계열 = EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC. 모든 division에서 표시 10컬럼으로 같습니다.
- 표의 행 순서는 실제 컬럼 순서가 아닙니다. 순서, 폭, 정렬, 셀 타입, 편집 여부는 SCM_MST_SHEET_COLUMNS 원문(11행) 확인이 필요합니다.
- 헤더 스타일: HorizontalAlignment·VerticalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced` (Designer.cs 270~273)

## 5. 액션 명세

| 버튼/이벤트 | 핸들러/메서드 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|
| 화면 로드 | `Form_Load` (.ctor:83) | 본문 확인 필요. 시트 생성은 CreateSpread(AddSheet/GetSheetInfo/ChangeSheet), 컬럼은 InitSpread(InitSheet/SetSheetHeaderColumn) | 확인 필요 | 시트 `Shipment Semi Dept Day` 구성 |
| (필드 초기화 43줄) | `<field:dtDepartureDay>` | 공통 Lookup 조회. 진입점 미연결 | `biz:CommonData.CommonDataList` [code=LookupCommon] | 바인딩 대상 확인 필요 |
| (필드 초기화 44줄) | `<field:dtYesOrNo>` | Y/N 공통 데이터. 진입점 미연결 | `biz:CommonData.YesOrNo` | 바인딩 대상 확인 필요 |
| 조회 | FindButton → FindData_Main(258) | GetCheckedListValue(241·242·244) 후 조회 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` (SP SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY) | spdMain 바인딩 |
| 저장 | SaveButton → SaveData_Main(380) → FindData_Main | 변경 행 저장 후 재조회 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` (SP SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY) → `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | 재조회 결과 표시 |
| 행 추가 | InsertButton(204) | 조건 충족 시 DIVISION_ID 셀 Combo 설정(BLUtils.GetDivision(false,"")) | 없음 | 신규 행 Division 콤보 |
| 편집 | EditButton(219) | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex). 상세 확인 필요 | 없음 | 확인 필요 |
| 셀 클릭 | `SpdMain_CellClick` (.ctor:84) | 본문 확인 필요 | 확인 필요 | 확인 필요 |
| 키 입력 | `SpdMain_KeyPress` (.ctor:85) | 본문 확인 필요 | 확인 필요 | 확인 필요 |
| 스크롤(Top 변경) | `SpdMain_TopChange` (InitEvent:107) | 본문 확인 필요 | 확인 필요 | 확인 필요 |
| 삭제 | 확인 필요 | Fact Pack에 없음 | 확인 필요 | - |

## 6. 검증·메시지

| 항목 | 사실 |
|---|---|
| 필수 표시 | 그리드 헤더 `Division*`, `Model*` (메타 라벨) |
| 행 추가 조건 | `fps.Name == "spdMain"` && `siMain != null && siMain.IsLock(siMain.SheetName) == false` && `siMain.SheetName == "Shipment Semi Dept Day"` |
| 저장 전 검증·메시지 문구 | **확인 필요**(Fact Pack에 메시지 사실 없음) |
| 조회 결과 0건과 오류 응답 처리 | **확인 필요** |

## 7. 권한 (C/R/U/D)

- TB_FX_GroupMenuAuth 11행이 있습니다. 그룹별 C/R/U/D 값은 **확인 필요**입니다.
- 코드에서 확인되는 것은 시트 잠금 조건(`IsLock == false`)일 때만 행 추가 Combo를 설정한다는 점뿐입니다. 권한과 연동되는지는 확인 필요입니다.

## 8. To-Be 전환 메모

| 영역 | AS-IS | To-Be(Wijmo·Oracle) |
|---|---|---|
| 조회조건 패널 | UsrConditionPanel + DevExpress LayoutControl | 공통 조회조건 컴포넌트. 라벨은 Model / Valid / Division 원문 유지 |
| Division 다중선택 | UsrCheckedList, GetCheckedListValue(CODE) | Wijmo MultiSelect. CODE 값을 그대로 전달 |
| 그리드 | FpSpread + SetSheetHeaderColumn(SCM_MST_SHEET_COLUMNS) | Wijmo FlexGrid + 메타 기반 컬럼 동적 구성(같은 메타 컬럼 속성) |
| 신규 행 Division 콤보 | SetCellTypeCombo(BLUtils.GetDivision(false,"")) | FlexGrid DataMap(사용자 Division 목록) |
| 다중값 파라미터 | GET SP가 `STRING_SPLIT`(MSSQL) 참조, SAVE SP가 `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL` 참조 | Oracle 19c에는 STRING_SPLIT이 없으므로 분해 함수나 REGEXP 방식으로 바꿔야 함. 구체 구현은 SP 원문 확인 후 결정 |
| 저장 | SP 1회 호출 후 재조회 | Oracle PKG 저장 프로시저 + 이력(_H)·로그(SCM_SYS_LOG_BATCH) 동등 처리 + 재조회 |
| 공통 데이터 | biz:CommonData.CommonDataList / YesOrNo | 공통 코드 API. 바인딩 대상은 확인 후 매핑 |

## 9. 미확정

1. 메뉴 위치와 화면 업무 명칭
2. 이벤트 핸들러 4종(`Form_Load`, `SpdMain_CellClick`, `SpdMain_KeyPress`, `SpdMain_TopChange`) 본문
3. usrLayoutControl1(657×184)과 imageList1의 트리 위치·용도
4. 조회조건 실제 좌표와 순서(Location 미추출), 초기값, 필수 여부
5. cboValidYN 항목 소스와 그리드 DEPARTURE_DAY·VALID_YN 셀 타입
6. 컬럼 순서·폭·정렬·편집 가능 여부(SCM_MST_SHEET_COLUMNS 원문)
7. 삭제 기능과 저장 검증 메시지
8. 권한 상세
