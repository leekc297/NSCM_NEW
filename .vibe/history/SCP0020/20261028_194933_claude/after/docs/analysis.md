# SCP0020 Tact Time — As-is 분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SCP0020)에 있는 사실만 썼습니다. Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 | 근거 |
|---|---|---|
| 화면 ID | SCP0020 | 클래스 `SCP0020_TactTime` |
| 도메인 | SCP (Master) | 경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime` |
| 폼 Text | `Tac Time` (원문 철자 그대로) | props.csv `this.Text` (Designer.cs:609) |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.csproj` | 파일 구성 |
| Grid 구성 방식 | `META(프레임워크) (+코드 표시/라벨 변경)` | Fact Pack §11 |
| 메뉴/프로그램 메타 | TB_FX_ProgramInfo 1행, TB_FX_MenuItemInfo 1행, TB_FX_GroupMenuAuth 13행, TB_FX_SearchCondition 255행, TB_FX_Favorite 21행 | Fact Pack §8 |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs` | 2909 |
| current | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs` | 672 |
| current | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\Properties\AssemblyInfo.cs` | 37 |
| shared | 없음(Fact Pack에 shared 행 없음) | - |
| legacy | 없음(Fact Pack에 legacy 행 없음) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| Form Load (`Form_Load`) | Form_Load > DefineProperty | 199 | `biz:CommonData.CommonDataList` [code=LineByOperation] | BIZ_MATCH | - |
| Form Load (`Form_Load`) | Form_Load > InitControls | 218 | `biz:CommonData.YesOrNo` | BIZ_MATCH | - |
| Form Load (`Form_Load`) | Form_Load > InitControls | 220 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | - |
| 조회(FindButton) | FindButton > Find_Data > Find_Packer | 980 | `SCP.SCP0020_GET_TACT_TIME_OSP` | MATCH | SCP0020_GET_TACT_TIME_OSP |
| 조회(FindButton) | FindButton > Find_Data > FindData_Main | 1041 | `biz:CommonData.CommonDataList` [code=LineByOperation] | BIZ_MATCH | - |
| 조회(FindButton) | FindButton > Find_Data > FindData_Main | 1067 | `SCP.SCP0020_GET_TACT_TIME` | MATCH | SCP0020_GET_TACT_TIME |
| 저장(SaveButton) | SaveButton > SaveData_Packer | 1560 | `SCP.SCP0020_SAVE_TACT_TIME_OSP` | MATCH | SCP0020_SAVE_TACT_TIME_OSP |
| 저장(SaveButton) | SaveButton > SaveData_Packer > Find_Packer (저장 후 재조회) | 980 | `SCP.SCP0020_GET_TACT_TIME_OSP` | MATCH | SCP0020_GET_TACT_TIME_OSP |
| 저장(SaveButton) | SaveButton > SaveData_Main | 1797 | `SCP.SCP0020_SAVE_TACT_TIME` | MATCH | SCP0020_SAVE_TACT_TIME |
| 저장(SaveButton) | SaveButton > SaveData_Main > FindData_Main (재조회) | 1041 | `biz:CommonData.CommonDataList` [code=LineByOperation] | BIZ_MATCH | - |
| 저장(SaveButton) | SaveButton > SaveData_Main > FindData_Main (재조회) | 1067 | `SCP.SCP0020_GET_TACT_TIME` | MATCH | SCP0020_GET_TACT_TIME |
| 저장(SaveButton) | SaveButton > SaveData_Except_Packer | 2023 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` | MATCH | SCP0020_SAVE_TACT_TIME_EXCEPT_OSP |
| 저장(SaveButton) | SaveButton > SaveData_Except_Packer > FindData_Except_Packer (재조회) | 1321 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | MATCH | SCP0020_GET_TACT_TIME_EXCEPT_OSP |
| 저장(SaveButton) | SaveButton > SaveData_Except | 2227 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` | MATCH | SCP0020_SAVE_TACT_TIME_EXCEPT |
| 저장(SaveButton) | SaveButton > SaveData_Except > FindData_Except (재조회) | 1397 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | MATCH | SCP0020_GET_TACT_TIME_EXCEPT |
| spdMain 더블클릭 (`SpdMain_CellDoubleClick`) | SpdMain_CellDoubleClick > FindData_Except_Packer | 1321 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | MATCH | SCP0020_GET_TACT_TIME_EXCEPT_OSP |
| spdMain 더블클릭 (`SpdMain_CellDoubleClick`) | SpdMain_CellDoubleClick > FindData_Except | 1397 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | MATCH | SCP0020_GET_TACT_TIME_EXCEPT |
| (진입점 미연결) | `<field:dtValidYN>` 필드 초기화 | 57 | `biz:CommonData.YesOrNo` | BIZ_MATCH | - |
| (진입점 미연결) | `<field:dtYesOrNo>` 필드 초기화 | 58 | `biz:CommonData.YesOrNo` | BIZ_MATCH | - |

흐름 요약(사실로 확인된 범위):
- **조회**: `Find_Data`에서 `Find_Packer`(Packer 시트, OSP 계열)와 `FindData_Main`(Plant 시트, 일반 계열)으로 경로가 나뉩니다. 두 경로를 고르는 분기 조건(활성 시트 등)은 Fact Pack에 없으므로 **확인 필요**입니다.
- **저장**: 저장 메서드는 시트별로 4개(Packer/Plant/Except Packer/Except)이고, 각각 저장 후 같은 계열의 조회 메서드를 다시 부릅니다. 어떤 저장 메서드가 실행될지 정하는 분기(활성 그리드·시트)는 **확인 필요**입니다.
- **Except(하단) 조회**: FindButton 경로에는 나타나지 않습니다. `SpdMain_CellDoubleClick`과 Except 저장 후 재조회에서만 호출됩니다.
- **필드 초기화 YesOrNo**: 57·58줄 필드 선언에서 생성되고 연결된 진입점은 없습니다(클래스 생성 시점 실행으로 추정되나 **확인 필요**).

## 3. 엔드포인트 전체 표

| # | 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블/객체 (EXEC 전이 포함) |
|---:|---|---|---:|---|---|
| 1 | `biz:CommonData.YesOrNo` | BIZ_MATCH | 3 | - | DB 보강 정보 없음 (Data.CallBizData) |
| 2 | `biz:CommonData.CommonDataList` [code=LineByOperation] | BIZ_MATCH | 2 | (UP_FX_GetCommonDataList 코드분기) | SCM_MST_LINE_SN, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT |
| 2' | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | (UP_FX_GetCommonDataList 코드분기) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| 3 | `SCP.SCP0020_GET_TACT_TIME_OSP` | MATCH | 1 | SCP0020_GET_TACT_TIME_OSP | SCM_MST_PLAN, SCP_OPMZ_LOOKUP_MASTER_DETAIL, DM_PLN_MKT_FCST, SCM_MST_SITE, SCM_MST_BOM_SN_V, SCM_MST_ITEM_SN, SCM_MST_FINAL_ITEM_V, SCP_MST_FINAL_ITEM, SCP_MST_TACT_TIME_EXCEPT_OSP, SCP_MST_TACT_TIME_OSP, SCM_MST_SITE_ITEM_PRIORITY, SCM_MST_PLANT_SN / #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_TMP1 / FN_NEXT_DAY, STRING_SPLIT, FN_GET_ITEM_OPERATION_GROUP, FN_SCM_SPLIT |
| 4 | `SCP.SCP0020_GET_TACT_TIME` | MATCH | 1 | SCP0020_GET_TACT_TIME | DM_PLN_MKT_FCST, SCM_MST_SITE, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCP_MST_FINAL_ITEM, SCP_MST_TACT_TIME_EXCEPT, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_SN, SCP_MST_TACT_TIME, SCM_MST_ITEM_SN, SCM_MST_PLANT_SN, SCP_MST_LOSS_TIME, SCM_MST_SITE_ITEM_PRIORITY, SCP_MST_TACT_TIME_BIG / #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_TMP1 / FN_NEXT_DAY, STRING_SPLIT, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_OPERATION_GROUP, FN_SCM_SPLIT |
| 5 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` | MATCH | 1 | SCP0020_GET_TACT_TIME_EXCEPT_OSP | SCM_MST_ITEM_SN, SCP_MST_TACT_TIME_OSP, SCP_MST_TACT_TIME_EXCEPT_OSP, SCM_MST_SITE / FN_GET_SCM_SITE_DESCRIPTION |
| 6 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` | MATCH | 1 | SCP0020_GET_TACT_TIME_EXCEPT | SCP_MST_TACT_TIME, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_TACT_TIME_EXCEPT, SCM_MST_SITE, SCM_MST_ITEM_SN / FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_NICKNAME |
| 7 | `SCP.SCP0020_SAVE_TACT_TIME_OSP` | MATCH | 1 | SCP0020_SAVE_TACT_TIME_OSP | SELECT/INSERT/UPDATE(A) SCP_MST_TACT_TIME_OSP, INSERT SCP_MST_TACT_TIME_OSP_H, SELECT SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT SCP_MST_TACT_TIME_EXCEPT_OSP_H, DELETE:A, INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_SAVE_TMP / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 8 | `SCP.SCP0020_SAVE_TACT_TIME` | MATCH | 1 | SCP0020_SAVE_TACT_TIME | SELECT/UPDATE/INSERT/DELETE SCP_MST_TACT_TIME, INSERT SCP_MST_TACT_TIME_H, SELECT/DELETE SCP_MST_TACT_TIME_EXCEPT, INSERT SCP_MST_TACT_TIME_EXCEPT_H, INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, EXEC PR_SCP_MST_TACT_TIME_HIST / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 9 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` | MATCH | 1 | SCP0020_SAVE_TACT_TIME_EXCEPT_OSP | SELECT/INSERT SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT SCP_MST_TACT_TIME_EXCEPT_OSP_H, DELETE:A, UPDATE:A, INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / #TBLDYNAMIC_SCP0020 / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| 10 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` | MATCH | 1 | SCP0020_SAVE_TACT_TIME_EXCEPT | SELECT/INSERT SCP_MST_TACT_TIME_EXCEPT, INSERT SCP_MST_TACT_TIME_EXCEPT_H, DELETE:A, UPDATE:A, INSERT SCM_SYS_LOG_BATCH / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN / #TBLDYNAMIC_SCP0020 / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |

- 서로 다른 엔드포인트 키는 10개입니다. `biz:CommonData.CommonDataList`는 code 값(LineByOperation, LookupCommon) 두 가지로 호출됩니다.
- 주석 처리된 호출(commented_calls)은 **0건**이고, 위 표는 모두 현재 동작하는 호출입니다.

### 3-1. 저장 결과 처리
- 저장 메서드 4개 모두 `dtErr.Rows[0]["ERR_MESSAGE"]`를 읽습니다. SaveData_Packer:1622, SaveData_Main:1874, SaveData_Except_Packer:2094, SaveData_Except:2297입니다.
- ERR_MESSAGE를 어떤 조건에서 판정하는지, 어떤 메시지 ID를 쓰는지는 **확인 필요**입니다.

## 4. 이벤트 배선

| # | 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---:|---|---|---|---|
| 1 | this.btnItemId | Click | `btnItemId_Click` | Designer.cs InitializeComponent:271 |
| 2 | this.spdMain | EditModeOff | `SpdMain_EditModeOff` | Designer.cs InitializeComponent:505 |
| 3 | this.spdMain | EditChange | `SpdMain_EditChange` | Designer.cs InitializeComponent:506 |
| 4 | this.spdExcept | EditModeOff | `spdExcept_EditModeOff` | Designer.cs InitializeComponent:558 |
| 5 | this.spdExcept | EditChange | `spdExcept_EditChange` | Designer.cs InitializeComponent:559 |
| 6 | this | Load | `Form_Load` | .cs .ctor:179 |
| 7 | cboDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | .cs InitEvent:460 |
| 8 | clbPlantSite | SelectedIndexChanged | `ClbPlantSite_SelectedIndexChanged` | .cs InitEvent:461 |
| 9 | spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | .cs InitEvent:463 |
| 10 | spdMain | TopChange | `SpdMain_TopChange` | .cs InitEvent:464 |
| 11 | spdMain | CellClick | `SpdMain_CellClick` | .cs InitEvent:465 |
| 12 | spdExcept | TopChange | `SpdExcept_TopChange` | .cs InitEvent:467 |
| 13 | dsdmMain | Changed | `SpdMain_Changed` | .cs InitEvent:471 |
| 14 | dsdmMainPacker | Changed | `SpdMain_Changed_Packer` | .cs InitEvent:474 |
| 15 | spdMain | ClipboardPasted | `SpdMain_ClipboardPasted` | .cs InitEvent:476 |
| 16 | this.spdMain | ActiveSheetChanged | `SpdMain_ActiveSheetChanged` | .cs InitEvent:479 |
| 17 | dsdmExcept | Changed | `SpdExcept_Changed` | .cs InitEvent:482 |

핸들러별로 확인된 동작:
- `btnItemId_Click`: 2560줄에서 `txtItemId.Text = sItemId`를 설정합니다. sItemId를 어디서 얻는지(팝업 여부)는 **확인 필요**입니다.
- `SpdMain_CellDoubleClick`: `FindData_Except_Packer` 또는 `FindData_Except`를 호출해 하단 Tact Time Except 그리드를 조회합니다. 두 메서드 중 하나를 고르는 분기 조건은 **확인 필요**입니다.
- `SpdMain_CellClick`: 2583줄에서 `SetCellTypeCombo`로 LINE_ID 셀 콤보를 구성합니다. 조건은 `siMain.IsLock("Plant") == false`, 셀 잠금 아님, 활성 시트 `Plant`, `e.Column == LINE_ID`입니다. 콤보 데이터는 `dtLineByOperationOfSpdAll`을 `DIVISION_ID`·`FACTORY_ID`·OP…로 필터한 값 또는 `Data.Common(Data.Type.LineByOperation, false, division, …)`입니다.
- `SpdMain_ClipboardPasted`: 2769~2770줄에서 CODE·NAME을 읽고, 2773줄에서 붙여넣기 범위의 LINE_ID 셀에 `SetCellTypeCombo`(dtLine)를 적용합니다.
- `SpdMain_ActiveSheetChanged`: `Plant` 시트면 `ChangeSheet/ChangeActiveSheet(SpdSheet.shtMain)`를(2792~2793줄), `Packer` 시트면 `SpdSheet.shtPacker`를(2799~2800줄) 적용합니다.
- 나머지 `SpdMain_EditModeOff`, `SpdMain_EditChange`, `spdExcept_EditModeOff`, `spdExcept_EditChange`, `ClbDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged`, `SpdMain_TopChange`, `SpdExcept_TopChange`, `SpdMain_Changed`, `SpdMain_Changed_Packer`, `SpdExcept_Changed`는 Fact Pack에 내부 동작이 없어 **확인 필요**입니다. 4-2장의 `RefreshPlantSiteByDivision`, `RefreshLineByOperation`, `RefreshLineByOperationOfSpd`, `RefreshLineByPlantPacker` 메서드가 이 핸들러들과 연결될 가능성이 있지만 연결 근거는 없습니다.

## 5. 버튼(프레임워크 공통 버튼) 관련 사실
- FindButton과 SaveButton은 2장 흐름에서 확인했습니다.
- EditButton은 563·607·673줄에서 `GetSheetInfo`를, 636~637줄에서 CODE·NAME을, 641줄에서 LINE_ID `SetCellTypeCombo`를 씁니다. 641줄의 조건은 `INPUT_STATUS == "I"`입니다.
- InsertButton은 859~860줄에서 CODE·NAME을 읽고, 864줄에서 Packer 시트 LINE_ID `SetCellTypeCombo`를 적용합니다. 조건은 `siMain.SheetName == "Packer"`입니다.
- DeleteButton 등 다른 공통 버튼의 존재 여부는 **확인 필요**입니다.

## 6. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

- 메타 원천은 `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SCP0020, 111행)이고, `SpreadInfo.SetSheetHeaderColumn`으로 헤더를 만듭니다. 호출 위치는 InitSpread:406, SetSpreadInit:438, SetSpreadInit:449입니다.
- 읽는 메타 컬럼: ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG.
- 코드에서 만드는 시트(CreateSpread):
  - spdMain: `Plant`(SpdSheet.shtMain, 374줄), `Packer`(SpdSheet.shtPacker, 377줄)
  - spdExcept: `Tact Time Except`(SpdSheet.shtExcept, 384줄)
- 메타에만 있는 시트: `Tact Time`. 메타 33행이 정의돼 있지만 코드에서 참조하지 않습니다(미사용 가능).
- 코드에서 표시를 바꾸는 부분(InitSpread, `spreadInfo.SheetName == "Tact Time Except"`일 때):
  - spdMain 활성 시트가 `Plant`이면 DAILY_CAPACITY를 숨기고 OPERATION_NAME을 표시합니다(410·411줄).
  - 그 외(Packer)이면 DAILY_CAPACITY를 표시하고 OPERATION_NAME을 숨깁니다(415·416줄).
- SetSpreadInit:442에서 `siMain.ActiveSheet.Visible = false`를 설정합니다. 어느 분기에 속하는지는 **확인 필요**입니다(438줄 Plant 분기와 446줄 else 분기 사이).
- Designer 522~525, 575~578줄은 컬럼헤더 기본 스타일(General 정렬, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced)입니다.

### 6-1. Division별 차이

| 시트 | 연결 규칙 | 최종 표시 컬럼 수 (40·81·81_HD·81_HG·81_HM·81_ST·81_UC·82·EE·EE_HD·EE_HG·EE_HM·EE_ST·EE_UC) |
|---|---|---|
| Packer | META+코드연결 | 전 division 14 |
| Plant | META+코드연결 | 전 division 23 |
| Tact Time | 메타 정의만, 코드 미참조(미사용 가능) | 전 division 23 |
| Tact Time Except | META+코드연결 | 전 division 16 (메타 17 − 코드 숨김 1) |

- 메타 행에 division별로 다른 정의가 없어 14개 division 모두 같습니다. 코드 분기도 division 변수로 나뉘지 않습니다(분기 판단 불가 0건).
- Tact Time Except의 16개 컬럼 구성은 spdMain 활성 시트(Plant/Packer)에 따라 DAILY_CAPACITY와 OPERATION_NAME 중 하나만 보이는 식으로 달라집니다. 개수는 어느 쪽이든 16입니다.

## 7. 확인 필요 항목

| # | 항목 | 사유 |
|---:|---|---|
| 1 | `Find_Data`의 Packer/Main 분기 조건 | Fact Pack에 분기 조건 없음 |
| 2 | SaveButton이 4개 저장 메서드 중 무엇을 실행하는지(활성 그리드·시트 기준 여부) | 경로만 추출됨 |
| 3 | `SpdMain_CellDoubleClick`의 Except_Packer/Except 분기 조건 | 동일 |
| 4 | InitControls:220 LookupCommon 결과가 바인딩되는 컨트롤(cboOperationGroup/cboDivision) | 대상 컨트롤 미추출 |
| 5 | DefineProperty:199 LineByOperation 결과의 용도(clbLine 또는 Grid 콤보 캐시) | 미추출 |
| 6 | `btnItemId_Click`의 sItemId 획득 방식(팝업 여부) | 2560줄 대입만 확인 |
| 7 | 내부 동작이 미추출된 이벤트 핸들러 11개(4장) | 미추출 |
| 8 | `<field:dtValidYN>`·`<field:dtYesOrNo>` 실행 시점 | 진입점 미연결 |
| 9 | grid_effective의 Packer `OPERATION_NAME` CODE_ONLY_CHANGE 행 | 코드 변경 대상은 Tact Time Except인데 Packer로 귀속됨. 파서 귀속 오류 가능성 |
| 10 | SetSpreadInit:442 `ActiveSheet.Visible=false`의 분기 귀속 | 미추출 |
| 11 | 실제 SP 실행 결과와 시트 매칭 | Fact Pack: "매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치)" |
| 12 | 권한(TB_FX_GroupMenuAuth 13행)의 C/R/U/D 값 | 행 수만 확인, 값 미제공 |
