=== FILE: business_analysis.md ===
# SCP0033 Shipment Semi Dept Day — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SCP0033)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)
> Fact Pack에 없는 내용은 모두 **확인 필요**로 적었습니다. SP 본문, 핸들러 본문, 메타 행 내용은 이 문서의 근거에 들어 있지 않습니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID | SCP0033 | Fact Pack §1 |
| 클래스 / Form Text | `SCP0033_Shipment_semi_dept_day` | Designer.cs:310 |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) | 파일 경로 |
| 관리 대상 | `SCP_MST_SHIPMENT_SEMI_DEPT_DAY` 테이블 데이터를 조회하고 저장(UPDATE/INSERT)함 | endpoints.csv objects |
| 업무 목적(업무 언어 기준) | **확인 필요.** 메뉴명과 업무 설명이 TB_FX_MenuItemInfo·TB_FX_ProgramInfo 행에 있지만, Fact Pack에는 그 내용이 없음 |  |
| 범위 | 조회(Find), 저장(Save, 저장 후 재조회), 행 추가(Insert, DIVISION_ID 콤보 설정), 편집(Edit, 시트 정보 확인) | flow.csv, grid_code.csv |
| 범위 외 / 미확인 | 삭제(Delete) 기능이 있는지는 **확인 필요**. 흐름에는 Find·Save만 있고 grid_code에는 Insert·Edit만 있음 |  |

- 그리드 컬럼 이름 `DEPARTURE_DAY`(라벨 `Departure day`)와 `OPERATION_GROUP` 등을 보면 Model(ITEM_ID)별 출발 요일을 관리하는 마스터로 볼 수 있습니다. 다만 업무 정의는 **확인 필요**입니다(컬럼명에서 해석한 것이고 문서로 확인한 사실은 아님).

## 2. 사용자 시나리오

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---|---|---|---|
| S1 | 화면을 엶 | `Form_Load` 실행(.ctor:83 배선). `CreateSpread`에서 `AddSheet`(147) → `GetSheetInfo`(148) → `ChangeSheet`(149)로 시트 `Shipment Semi Dept Day`를 만들고, `InitSpread`에서 `InitSheet`(156) → `SetSheetHeaderColumn`(161)으로 SCM_MST_SHEET_COLUMNS 메타를 읽어 컬럼을 구성함. Form_Load 본문은 **확인 필요** | 조회조건(Model / Valid / Division)과 빈 그리드가 표시됨 |
| S2 | 조회조건 입력(Model, Valid, Division) 후 조회 | FindButton → FindData_Main(258) → `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` → SP `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`. FindData_Main 241·242·244줄에서 `GetCheckedListValue`(CODE)를 호출함 | 그리드에 조회 결과가 표시됨 |
| S3 | 행 추가 | InsertButton(204): 조건을 만족하면 새 행의 `DIVISION_ID` 셀을 Combo로 바꾸고 데이터는 `BLUtils.GetDivision(false, "")`를 씀 | 새 행에서 Division을 콤보로 선택함 |
| S4 | 셀 편집 후 저장 | SaveButton → SaveData_Main(380) → `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` → SP `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, 이어서 FindData_Main → `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`로 재조회 | 테이블 반영 후 그리드가 다시 조회됨 |
| S5 | 그리드 셀 클릭, 키 입력, 스크롤 | `SpdMain_CellClick`(.ctor:84), `SpdMain_KeyPress`(.ctor:85), `SpdMain_TopChange`(InitEvent:107) | 처리 내용은 **확인 필요**(본문 미추출) |
| S6 | 편집 모드 | EditButton(219): `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` | 상세 로직은 **확인 필요** |

## 3. 업무 흐름도 (텍스트)

```
[화면 열기]
  └─ Form_Load
       ├─ CreateSpread : AddSheet → GetSheetInfo → ChangeSheet   (시트: Shipment Semi Dept Day)
       └─ InitSpread   : InitSheet → SetSheetHeaderColumn(메타 SCM_MST_SHEET_COLUMNS)
  (필드 초기화 43·44줄: biz:CommonData.CommonDataList [code=LookupCommon] → dtDepartureDay
                       biz:CommonData.YesOrNo → dtYesOrNo  ※ 진입점 미연결, 바인딩 대상 확인 필요)

[조회]
  조회조건(txtItemId / cboValidYN / clbDivision)
   → FindButton → FindData_Main(GetCheckedListValue ×3)
   → SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY
   → SP SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY
   → 그리드(spdMain / Shipment Semi Dept Day) 바인딩

[행 추가]
  InsertButton → (fps.Name=="spdMain" && siMain!=null && IsLock==false && SheetName=="Shipment Semi Dept Day")
   → DIVISION_ID 셀 Combo(BLUtils.GetDivision(false,""))

[저장]
  SaveButton → SaveData_Main
   → SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY → SP SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY
       (PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST, PR_SCM_SYS_LOG_BATCH 실행)
   → FindData_Main → SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (재조회)
```

## 4. 업무 규칙

| # | 규칙 | 상태 | 근거 |
|---|---|---|---|
| R1 | 저장이 끝나면 같은 조회 경로(FindData_Main)로 재조회함 | 사실 | flow.csv `SaveButton > SaveData_Main > FindData_Main` |
| R2 | 행 추가 시 `DIVISION_ID` 셀 Combo 설정은 4개 조건을 모두 만족할 때만 적용됨: `fps.Name == "spdMain"`, `siMain != null`, `siMain.IsLock(siMain.SheetName) == false`, `siMain.SheetName == "Shipment Semi Dept Day"` | 사실 | grid_code.csv InsertButton:204 conditions |
| R3 | 새 행 Division 콤보의 데이터는 `BLUtils.GetDivision(false, "")`(변수 dtMyDivision)임 | 사실 | grid_code.csv InsertButton:204 |
| R4 | 조회조건 Division은 체크리스트의 CODE 값으로 SP에 넘어감 | 사실(호출만 확인). 241·242·244줄의 대상 컨트롤과 파라미터 매핑은 **확인 필요** | Fact Pack §4-2 GetCheckedListValue |
| R5 | GET SP는 `STRING_SPLIT`, `FN_GET_DIVISION_DIV`를 참조하고 `SCM_MST_DIVISION`, `SCM_MST_ITEM_SN`, `SCP_MST_SHIPMENT_SEMI_DEPT_DAY`를 SELECT함 | 사실(참조 객체만) | endpoints.csv |
| R6 | SP 분기 조건(파라미터별 WHERE, Valid 필터 방식 등) | **확인 필요**(SP 본문 없음) |  |
| R7 | SAVE SP는 `SCP_MST_SHIPMENT_SEMI_DEPT_DAY`를 UPDATE와 INSERT 두 방식으로 처리함. 이력 프로시저 `PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST` 실행, `SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H` INSERT, `PR_SCM_SYS_LOG_BATCH` 실행과 `SCM_SYS_LOG_BATCH` INSERT, 배열 분해 객체 `SCM_ARR_SPL_CNT`·`SCM_ARR_SPL_VAL` 참조 | 사실(참조 객체만). UPDATE와 INSERT를 가르는 기준(키 존재 여부 등)은 **확인 필요** | endpoints.csv |
| R8 | 필수값: 그리드 메타 라벨 `Division*`, `Model*`에 '*'가 붙어 있음 | 라벨 사실. 저장 전 필수 검증 로직이 있는지는 **확인 필요** | grid_effective.csv |
| R9 | 날짜·버킷 규칙 | 해당 사실 없음. `DEPARTURE_DAY` 값 체계(LookupCommon 코드 여부)는 **확인 필요** |  |
| R10 | `S_VALID_YN` 컬럼은 모든 division에서 숨김 | 사실. 용도(저장 전 원본 Valid 값 보관 여부)는 **확인 필요** | grid_effective.csv |

## 5. 데이터 흐름 표

| 엔드포인트 | 호출 위치 | SP | 읽기(SELECT/REF) | 쓰기(INSERT/UPDATE/EXEC) |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | `<field:dtDepartureDay>`:43 (진입점 미연결) | - (Biz, 코드분기 UP_FX_GetCommonDataList) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| `biz:CommonData.YesOrNo` | `<field:dtYesOrNo>`:44 (진입점 미연결) | - (Biz) | **확인 필요** | - |
| `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | FindData_Main:258 (FindButton, SaveButton 재조회) | `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | SCM_MST_ITEM_SN, SCP_MST_SHIPMENT_SEMI_DEPT_DAY, SCM_MST_DIVISION / REF FN_GET_DIVISION_DIV, STRING_SPLIT | - |
| `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | SaveData_Main:380 (SaveButton) | `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | UPDATE·INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY, INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H, INSERT SCM_SYS_LOG_BATCH, EXEC PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST, EXEC PR_SCM_SYS_LOG_BATCH |

- 주석 처리된 호출(commented_calls): 0건
- 이 엔드포인트 이름은 화면설계서 §5 액션 명세와 단위테스트 근거 열에서도 똑같이 씁니다.

## 6. Division·권한별 변형

| 구분 | 사실 |
|---|---|
| Grid 컬럼 | 40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC 모두 메타 10/0(필수 10/선택 0)이고 최종 표시는 10컬럼임. **division별 차이 없음** |
| 숨김 | `S_VALID_YN`은 모든 division에서 숨김 |
| 코드 분기 | division 변수 비교 분기 0건(분기 판단불가 0건) |
| 데이터 범위 | GET SP가 `FN_GET_DIVISION_DIV`, `SCM_MST_DIVISION`을 참조함. 사용자 소속 division으로 필터하는 방식은 **확인 필요** |
| 권한 | TB_FX_GroupMenuAuth 11행이 있음. 그룹별 C/R/U/D 값은 **확인 필요** |
| 시트 잠금 | `siMain.IsLock(siMain.SheetName) == false`일 때만 행 추가 시 Division 콤보를 설정함. 잠금을 결정하는 주체(권한 연동 여부)는 **확인 필요** |

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스(I/F) 사실은 없습니다.
- 내부 공통 객체로 `PR_SCM_SYS_LOG_BATCH`/`SCM_SYS_LOG_BATCH`(로그)와 `PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST`(이력)를 씁니다. 외부 I/F는 아닙니다.

## 8. 미확정·확인 필요

1. 업무 명칭, 메뉴 위치, 업무 목적(TB_FX_MenuItemInfo/TB_FX_ProgramInfo 내용)
2. `Form_Load`, `SpdMain_CellClick`, `SpdMain_KeyPress`, `SpdMain_TopChange` 본문
3. `biz:CommonData.CommonDataList`(LookupCommon) 결과 dtDepartureDay와 `biz:CommonData.YesOrNo` 결과 dtYesOrNo의 바인딩 대상(그리드 DEPARTURE_DAY·VALID_YN 콤보, cboValidYN 등), 그리고 Lookup 코드값
4. FindData_Main 241·242·244줄 GetCheckedListValue 3회의 대상 컨트롤과 SP 파라미터 매핑(조회조건 UsrCheckedList는 clbDivision 1개뿐)
5. GET/SAVE SP의 파라미터, 분기 조건, 저장 키, UPDATE·INSERT 판정 기준
6. 삭제 기능이 있는지
7. 권한 11행과 조회조건 메타(TB_FX_SearchCondition 2행)의 내용. 컨트롤 3개와 개수가 다른 원인
8. 실제 SP 실행 결과와 시트를 대조하지 못함(Fact Pack §10: "매칭되는 시트가 없습니다")

=== FILE: screen_design.md ===
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

=== FILE: unit_test.md ===
# SCP0033 Shipment Semi Dept Day — 단위테스트

> 근거 열에는 엔드포인트, SP, 핸들러, 시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 본문이 추출되지 않은 핸들러는 기대결과에 "오류 없이 처리됨 + 상세 동작 확인 필요"로 적었습니다. 주석 처리된 호출은 0건이라 테스트 대상에서 제외한 것이 없습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0033-001 | 초기화 | 권한 있는 사용자로 로그인 | 1. SCP0033 화면을 연다 | - | 화면 로드 시 오류가 없음. usrConditionPanel1(상단)·usrLayoutControl2 안에 txtItemId(Model)·cboValidYN(Valid)·clbDivision(Division)이 표시되고 하단에 spdMain이 표시됨. 핸들러 상세 동작은 확인 필요 | `Form_Load` (.ctor:83) |
| TC-SCP0033-002 | 초기화 | TC-001 | 1. spdMain 시트를 확인한다 | - | spdMain_Sheet1에 시트 `Shipment Semi Dept Day`가 생성되고 메타 기반 컬럼 헤더 1행이 구성됨 | 시트 `Shipment Semi Dept Day`, CreateSpread:147~149, SetSheetHeaderColumn@InitSpread:161 |
| TC-SCP0033-003 | 그리드 | TC-001, 조회 결과 1건 이상 | 1. 조회한다 2. spdMain 헤더를 확인한다 | - | 표시 컬럼 10개: Division*, Model*, Nick Name, Operation Group, Departure day, Valid, Created By, Creation Date, Last Updated By, Last Update Date. 컬럼 순서는 SCM_MST_SHEET_COLUMNS 원문과 대조 | 시트 `Shipment Semi Dept Day`, grid_effective.csv |
| TC-SCP0033-004 | 그리드 | TC-003 | 1. spdMain에서 S_VALID_YN 컬럼 표시 여부를 확인한다 | - | `S_VALID_YN` 컬럼이 숨김 상태임 | 시트 `Shipment Semi Dept Day`, grid_effective.csv S_VALID_YN=숨김 |
| TC-SCP0033-005 | 그리드 | TC-001 | 1. spdMain 컬럼 헤더 스타일을 확인한다 | - | 헤더 정렬 General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced와 동등함 | 시트 `Shipment Semi Dept Day`, InitializeComponent:270~273 |
| TC-SCP0033-006 | 조회 | TC-001, 데이터 존재 | 1. txtItemId에 Model 입력 2. cboValidYN 선택 3. clbDivision 체크 4. 조회(FindButton) | Model=조회 가능한 ITEM_ID, Valid=임의 값, Division=사용자 Division | 조건에 맞는 행이 spdMain에 표시됨 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, FindData_Main:258 |
| TC-SCP0033-007 | 조회 | TC-001 | 1. clbDivision에서 여러 Division을 체크 2. 조회 | Division 2개 이상 | 체크한 Division의 CODE 값이 전달되고 해당 Division 행만 조회됨 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, GetCheckedListValue@FindData_Main:241/242/244 |
| TC-SCP0033-008 | 조회 | TC-001 | 1. txtItemId에 없는 Model 입력 2. 조회 | Model=존재하지 않는 값 | 오류 없이 spdMain이 0건으로 표시됨(0건 안내 메시지는 확인 필요) | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-009 | 조회 | DB 연결 차단 또는 SP 오류를 유발할 수 있는 환경 | 1. 조회 | - | 오류 응답이 사용자에게 표시되고 화면이 멈추지 않음(메시지 문구는 확인 필요) | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-010 | 그리드 | 시트 잠금 아님, 활성 시트 `Shipment Semi Dept Day` | 1. 행 추가(InsertButton) 2. 새 행의 DIVISION_ID 셀을 확인한다 | - | DIVISION_ID 셀이 Combo이고 항목은 사용자 Division 목록(BLUtils.GetDivision(false,""))임 | 시트 `Shipment Semi Dept Day`, InsertButton:204 |
| TC-SCP0033-011 | 권한 | 시트가 잠금 상태(IsLock=true) | 1. 행 추가 시도 | - | DIVISION_ID Combo 설정이 적용되지 않음. 행 추가 자체가 가능한지는 확인 필요 | 시트 `Shipment Semi Dept Day`, InsertButton:204 조건 `IsLock == false` |
| TC-SCP0033-012 | 저장 | TC-010 | 1. 새 행에 Division*, Model* 및 나머지 값 입력 2. 저장(SaveButton) | Division=콤보 값, Model=유효 ITEM_ID, Departure day/Valid=유효 값 | SCP_MST_SHIPMENT_SEMI_DEPT_DAY에 INSERT되고 이력(_H)·로그가 기록됨. 이후 자동 재조회로 새 행이 표시됨 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, 재조회 `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-013 | 저장 | TC-006 조회 결과 있음 | 1. 기존 행의 편집 가능 셀 수정 2. 저장 | 수정 값 | SCP_MST_SHIPMENT_SEMI_DEPT_DAY가 UPDATE되고 PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST가 실행됨. 재조회 결과에 수정 값이 반영됨 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, SP `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-014 | 저장 | TC-010 | 1. 새 행에서 Model*을 비운 채 저장 | Model=빈값 | 필수 오류로 저장이 거부되거나 SP 오류가 응답됨(검증 위치와 문구는 확인 필요). 데이터 미반영 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY`, 시트 `Shipment Semi Dept Day` 라벨 `Model*` |
| TC-SCP0033-015 | 저장 | 저장 SP 오류를 유발할 수 있는 환경 | 1. 변경 후 저장 | - | 오류 응답이 표시되고 테이블은 변경되지 않음 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |
| TC-SCP0033-016 | 이벤트 | TC-006 | 1. spdMain 임의 셀을 클릭한다 | - | 오류 없이 처리됨. 상세 동작은 확인 필요 | `SpdMain_CellClick` (.ctor:84) |
| TC-SCP0033-017 | 이벤트 | TC-006 | 1. spdMain 셀에 포커스를 두고 키를 입력한다 | 영문·숫자 키 | 오류 없이 처리됨. 상세 동작은 확인 필요 | `SpdMain_KeyPress` (.ctor:85) |
| TC-SCP0033-018 | 이벤트 | 화면 높이를 넘는 행 수의 조회 결과 | 1. spdMain을 세로 스크롤한다 | - | 상단 행 변경 시 오류 없이 처리됨. 상세 동작은 확인 필요 | `SpdMain_TopChange` (InitEvent:107) |
| TC-SCP0033-019 | 초기화 | TC-001 | 1. 화면 초기화 시 공통 Lookup 데이터 호출을 확인한다 | code=LookupCommon | 호출이 성공함. 바인딩 대상(그리드 DEPARTURE_DAY 등)은 확인 필요 | `biz:CommonData.CommonDataList` [code=LookupCommon], `<field:dtDepartureDay>`:43 |
| TC-SCP0033-020 | 초기화 | TC-001 | 1. 화면 초기화 시 Y/N 공통 데이터 호출을 확인한다 | - | 호출이 성공함. 바인딩 대상(cboValidYN 또는 그리드 VALID_YN)은 확인 필요 | `biz:CommonData.YesOrNo`, `<field:dtYesOrNo>`:44 |
| TC-SCP0033-021 | division | Division 40 사용자 | 1. 조회 2. spdMain 컬럼 수 확인 | Division=40 | 표시 10컬럼, S_VALID_YN 숨김 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(40) |
| TC-SCP0033-022 | division | Division 81계열 사용자(81, 81_HD/HG/HM/ST/UC) | 1. 조회 2. spdMain 컬럼 수 확인 | Division=81계열 | 표시 10컬럼, 40과 같음 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(81계열) |
| TC-SCP0033-023 | division | Division 82 사용자 | 1. 조회 2. spdMain 컬럼 수 확인 | Division=82 | 표시 10컬럼, 40과 같음 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(82) |
| TC-SCP0033-024 | division | Division EE계열 사용자(EE, EE_HD/HG/HM/ST/UC) | 1. 조회 2. spdMain 컬럼 수 확인 | Division=EE계열 | 표시 10컬럼, 40과 같음 | 시트 `Shipment Semi Dept Day`, grid_effective.csv(EE계열) |
| TC-SCP0033-025 | 권한 | 권한 그룹별 계정(TB_FX_GroupMenuAuth 11행 기준) | 1. 그룹별로 화면 열기, 조회, 저장 시도 | 그룹별 계정 | 그룹별 C/R/U/D 설정대로 동작함(기대값은 권한 행 확인 후 확정 — 확인 필요) | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY`, `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |

## 커버리지 점검

| 대상 | TC |
|---|---|
| `Form_Load` | 001 |
| `SpdMain_CellClick` | 016 |
| `SpdMain_KeyPress` | 017 |
| `SpdMain_TopChange` | 018 |
| `biz:CommonData.CommonDataList` | 019 |
| `biz:CommonData.YesOrNo` | 020 |
| `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | 006, 007, 008, 009, 012, 025 |
| `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | 012, 013, 014, 015, 025 |
| 시트 `Shipment Semi Dept Day` | 002, 003, 004, 005, 010, 011, 021~024 |
| 빈 결과 / 오류 응답 | 008 / 009, 015 |
| division별 | 021(40), 022(81계열), 023(82), 024(EE계열). 변형은 없고 동일성만 확인 |
