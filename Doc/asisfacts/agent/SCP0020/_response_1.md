[LITE]

=== FILE: analysis.md ===
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

=== FILE: source_links.md ===
# SCP0020 소스 링크 표

> 기준 루트: AS-IS GSCM 소스. 경로 약칭은 다음과 같습니다.
> - `CS` = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.cs`
> - `DES` = `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0020_TactTime\SCP0020_TactTime.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtValidYN>` | 57 | `biz:CommonData.YesOrNo` (Data.Common → Data.CallBizData) |
| CS | `<field:dtYesOrNo>` | 58 | `biz:CommonData.YesOrNo` |
| CS | DefineProperty | 199 | `biz:CommonData.CommonDataList` [code=LineByOperation] (Data.CallBizCommonData) |
| CS | InitControls | 218 | `biz:CommonData.YesOrNo` (UsrComboBox.DataBind) |
| CS | InitControls | 220 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| CS | Find_Packer | 980 | `SCP.SCP0020_GET_TACT_TIME_OSP` → SP SCP0020_GET_TACT_TIME_OSP |
| CS | FindData_Main | 1041 | `biz:CommonData.CommonDataList` [code=LineByOperation] |
| CS | FindData_Main | 1067 | `SCP.SCP0020_GET_TACT_TIME` → SP SCP0020_GET_TACT_TIME |
| CS | FindData_Except_Packer | 1321 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT_OSP` → SP SCP0020_GET_TACT_TIME_EXCEPT_OSP |
| CS | FindData_Except | 1397 | `SCP.SCP0020_GET_TACT_TIME_EXCEPT` → SP SCP0020_GET_TACT_TIME_EXCEPT |
| CS | SaveData_Packer | 1560 | `SCP.SCP0020_SAVE_TACT_TIME_OSP` → SP SCP0020_SAVE_TACT_TIME_OSP |
| CS | SaveData_Main | 1797 | `SCP.SCP0020_SAVE_TACT_TIME` → SP SCP0020_SAVE_TACT_TIME |
| CS | SaveData_Except_Packer | 2023 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → SP SCP0020_SAVE_TACT_TIME_EXCEPT_OSP |
| CS | SaveData_Except | 2227 | `SCP.SCP0020_SAVE_TACT_TIME_EXCEPT` → SP SCP0020_SAVE_TACT_TIME_EXCEPT |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| DES | InitializeComponent | 271 | `this.btnItemId.Click += btnItemId_Click` |
| DES | InitializeComponent | 505 | `this.spdMain.EditModeOff += SpdMain_EditModeOff` |
| DES | InitializeComponent | 506 | `this.spdMain.EditChange += SpdMain_EditChange` |
| DES | InitializeComponent | 558 | `this.spdExcept.EditModeOff += spdExcept_EditModeOff` |
| DES | InitializeComponent | 559 | `this.spdExcept.EditChange += spdExcept_EditChange` |
| CS | .ctor | 179 | `this.Load += Form_Load` |
| CS | InitEvent | 460 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| CS | InitEvent | 461 | `clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged` |
| CS | InitEvent | 463 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| CS | InitEvent | 464 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 465 | `spdMain.CellClick += SpdMain_CellClick` |
| CS | InitEvent | 467 | `spdExcept.TopChange += SpdExcept_TopChange` |
| CS | InitEvent | 471 | `dsdmMain.Changed += SpdMain_Changed` |
| CS | InitEvent | 474 | `dsdmMainPacker.Changed += SpdMain_Changed_Packer` |
| CS | InitEvent | 476 | `spdMain.ClipboardPasted += SpdMain_ClipboardPasted` |
| CS | InitEvent | 479 | `this.spdMain.ActiveSheetChanged += SpdMain_ActiveSheetChanged` |
| CS | InitEvent | 482 | `dsdmExcept.Changed += SpdExcept_Changed` |

## 3. Grid 정의 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 374 | AddSheet spdMain `SpdSheet.shtMain` = `Plant` |
| CS | CreateSpread | 375 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| CS | CreateSpread | 377 | AddSheet spdMain `SpdSheet.shtPacker` = `Packer` |
| CS | CreateSpread | 378 / 380 | GetSheetInfo / ChangeSheet (Packer) |
| CS | CreateSpread | 384 | AddSheet spdExcept `SpdSheet.shtExcept` = `Tact Time Except` |
| CS | CreateSpread | 385 / 386 | GetSheetInfo / ChangeSheet (Tact Time Except) |
| CS | InitSpread | 395 | InitSheet(spreadInfo.SheetName), 조건 `SheetName == "Tact Time Except"` |
| CS | InitSpread | 406 | `SetSheetHeaderColumn(spreadInfo, 1)` |
| CS | InitSpread | 410 / 411 | Plant 활성 시: DAILY_CAPACITY Visible=false / OPERATION_NAME Visible=true |
| CS | InitSpread | 415 / 416 | 그 외: DAILY_CAPACITY Visible=true / OPERATION_NAME Visible=false |
| CS | InitSpread | 425 / 426 | else 분기: ChangeSheet(1) / ChangeActiveSheet(SpdSheet.shtPacker) |
| CS | SetSpreadInit | 435 / 436 / 438 | `sheetName.Equals("Plant")`: ChangeSheet(0)·InitSheet(0)·SetSheetHeaderColumn(siMain,1) |
| CS | SetSpreadInit | 442 | `siMain.ActiveSheet.Visible = false` |
| CS | SetSpreadInit | 446 / 447 / 449 | else: ChangeSheet(1)·InitSheet(1)·SetSheetHeaderColumn(siMain,1) |
| CS | EditButton | 563 / 607 / 673 | GetSheetInfo (spdMain 시트0 / 시트1 / spdExcept) |
| CS | EditButton | 641 | SetCellTypeCombo LINE_ID (INPUT_STATUS == "I") |
| CS | InsertButton | 864 | SetCellTypeCombo LINE_ID (SheetName == "Packer") |
| CS | Find_Packer | 961 | ChangeSheet(SpdSheet.shtPacker) |
| CS | FindData_Main | 1045 | ChangeSheet(SpdSheet.shtMain) |
| CS | SpdMain_CellClick | 2583 | SetCellTypeCombo LINE_ID (Plant 시트) |
| CS | SpdMain_ClipboardPasted | 2773 | SetCellTypeCombo LINE_ID (붙여넣기 범위) |
| CS | SpdMain_ActiveSheetChanged | 2792 / 2793 | ChangeSheet / ChangeActiveSheet(SpdSheet.shtMain) |
| CS | SpdMain_ActiveSheetChanged | 2799 / 2800 | ChangeSheet / ChangeActiveSheet(SpdSheet.shtPacker) |
| DES | InitializeComponent | 522~525 | spdMain 컬럼헤더 스타일 (General/Red/ColumnHeaderDefaultEnhanced/General) |
| DES | InitializeComponent | 575~578 | spdExcept 컬럼헤더 스타일 (동일) |

## 4. 메타/데이터 컬럼 읽기 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | DefineProperty | 198 | GetCheckedListValue (CODE) |
| CS | RefreshPlantSiteByDivision | 292 | GetCheckedListValue (CODE) |
| CS | RefreshLineByOperation | 301, 302 | GetCheckedListValue (CODE) |
| CS | RefreshLineByOperationOfSpd | 315, 316 | GetCheckedListValue (CODE) |
| CS | RefreshLineByPlantPacker | 327, 328 | GetCheckedListValue (CODE) |
| CS | SetChangedControl_Osp | 362 / 363 | drRow/dr `CODE` / `NAME` |
| CS | EditButton | 636 / 637 | drRow/dr `CODE` / `NAME` |
| CS | InsertButton | 859 / 860 | drRow/dr `CODE` / `NAME` |
| CS | SaveData_Packer | 1622 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SaveData_Main | 1874 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SaveData_Except_Packer | 2094 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SaveData_Except | 2297 | dtErr.Rows[0] `ERR_MESSAGE` |
| CS | SpdMain_ClipboardPasted | 2769 / 2770 | drRow/dr `CODE` / `NAME` |
| CS | btnItemId_Click | 2560 | `txtItemId.Text = sItemId` |

## 5. 컨트롤 선언 지점 (DES)

| 컨트롤 | 유형 | 선언 줄 | 주요 속성 줄 |
|---|---|---:|---|
| usrConditionPanel1 | UsrConditionPanel | 34 | Dock Top 106, Size 109, UsrPanelType HidePanel 111 |
| usrLayoutControl2 | UsrLayoutControl | 35 | Dock Fill 123, Size 127 |
| cboOperationGroup | UsrCombo | 36 | Size 163, 라벨 472 |
| cboDivision | UsrCombo | 37 | Size 199, 라벨 399 |
| txtItemId | UsrMultiLineEditor | 38 | Size 233, 라벨 429 |
| btnItemId | UsrButton | 39 | Size 266 |
| cboValid | UsrComboBox | 40 | Size 280, 라벨 452 |
| clbLine | UsrCheckedList | 41 | Size 315, 라벨 410 |
| clbPlantSite | UsrCheckedList | 42 | Size 354, 라벨 388 |
| splitContainer2 | SplitContainer | 53 | Dock 479, Orientation 482, Size 491, SplitterDistance 492 |
| spdMain | FpSpread | 54 | Dock 498, Size 503 |
| spdExcept | FpSpread | 56 | Dock 551, Size 556 |
| this | Form | - | Text "Tac Time" 609 |

=== FILE: web_components.md ===
# SCP0020 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 → React/Wijmo 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨(원문) | 필수 표시 | TO-BE 컴포넌트 후보 | 데이터 원천(사실) |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | * | 단일 선택 콤보 (Wijmo ComboBox 계열) | **확인 필요**. LookupCommon(InitControls:220) 대상인지 미확정 |
| clbPlantSite | UsrCheckedList | `Plant Site` | - | 멀티 선택 체크리스트 (Wijmo MultiSelect 계열) | RefreshPlantSiteByDivision:292 (GetCheckedListValue CODE) |
| cboOperationGroup | UsrCombo | `Operation Group*` | * | 단일 선택 콤보 | **확인 필요** |
| clbLine | UsrCheckedList | `Line` | - | 멀티 선택 체크리스트 | RefreshLineByOperation:301·302, RefreshLineByPlantPacker:327·328 / LineByOperation(DefineProperty:199) 관련 가능성은 **확인 필요** |
| txtItemId | UsrMultiLineEditor | `Model` | - | 다중 행 입력(멀티라인 텍스트) | 사용자 입력. btnItemId_Click에서 값 설정 |
| btnItemId | UsrButton | (LayoutControlItem4 Text 없음) | - | 입력칸 옆 아이콘 버튼 | `btnItemId_Click` → txtItemId.Text = sItemId. 팝업 여부는 **확인 필요** |
| cboValid | UsrComboBox | `Valid` | - | 단일 선택 콤보 | `biz:CommonData.YesOrNo` (InitControls:218 DataBind CODE/NAME) |
| spdMain | FpSpread | 시트 `Plant` / `Packer` | - | Wijmo FlexGrid + 시트 탭 | SCP0020_GET_TACT_TIME / SCP0020_GET_TACT_TIME_OSP |
| spdExcept | FpSpread | 시트 `Tact Time Except` | - | Wijmo FlexGrid | SCP0020_GET_TACT_TIME_EXCEPT / SCP0020_GET_TACT_TIME_EXCEPT_OSP |

## 2. 화면 배치

| 영역 | 컨트롤 | 원문 속성 | 해석 |
|---|---|---|---|
| 조회조건 | usrConditionPanel1 | Dock=Top, Size(1093, 68), UsrPanelType=HidePanel | 상단 고정 조회 영역, 접기 가능한 패널 유형 |
| 조회조건 내부 | usrLayoutControl2 / layoutControlGroup2 | Dock=Fill, Size(1093, 68) / Group Size(1093, 73) | 레이아웃 아이템이 2줄로 배치됨(아이템 높이 25·28 기준) |
| 그리드 영역 | splitContainer2 | Dock=Fill, **Orientation=Horizontal**, Size(1093, 506), **SplitterDistance=392** | **상/하 분할** |
| 상단(Panel1) | spdMain | Dock=Fill, Size(1093, 392) | 392/506 ≈ **77.5%** |
| 하단(Panel2) | spdExcept | Dock=Fill, Size(1093, 110) | 110/506 ≈ **21.7%** (나머지 4px은 분할선) |

조회조건 아이템 크기(LayoutControlItem Size):
- 1줄(높이 25): Plant Site(337×25), Division*(262×25), Operation Group*(259×25), emptySpaceItem3(215×25)
- 2줄(높이 28): Line(262×28), Model(294×28), btnItemId(43×28), Valid(259×28), emptySpaceItem1(215×28)
- 줄별 아이템의 좌우 순서는 Location 값이 Fact Pack에 없어 **확인 필요**입니다. 위 분류는 높이만 기준으로 했습니다.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

공통 사항:
- 메타 원천은 `SCM_MST_SHEET_COLUMNS`(PROGRAM_ID=SCP0020)입니다.
- division 14종(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 같습니다. **division별 표시 차이는 없습니다.**
- "기본" = VISIBLE_FLAG·VALID_YN='Y'이고 DEFAULT_FLAG='Y'인 컬럼, "숨김" = 메타 숨김입니다.
- 아래 순서는 grid_effective.csv 행 순서(컬럼명 알파벳순)입니다. 실제 표시 순서는 메타 정렬 컬럼 원문으로 **확인 필요**입니다.

### 3-1. `Packer` (spdMain 시트 2, SpdSheet.shtPacker) — 표시 14 / 메타 18

| 컬럼 | 라벨 | 상태 |
|---|---|---|
| CREATED_BY | Created By | 기본 |
| CREATION_DATE | Creation Date | 기본 |
| DAILY_CAPACITY | Daily Capacity* | 기본 |
| DIVISION_ID | Division* | 기본 |
| ITEM_ID | Model* | 기본 |
| LAST_UPDATE_DATE | Last Update Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| LINE_ID | Line* | 기본 (셀 콤보: InsertButton:864) |
| NICK_NAME | Nick Name | 기본 |
| OSP_YN | OSP_YN | 기본 |
| PRIORITY | Priority* | 기본 |
| SITE_DESCRIPTION | Plant Site* | 기본 |
| TACT_TIME | Tact Time* | 기본 |
| YIELD | Yield(%)* | 기본 |
| EXCEPT_YN | EXCEPT_YN | 숨김 |
| INPUT_STATUS | INPUT_STATUS | 숨김 |
| OPERATION_ID | OPERATION_ID | 숨김 |
| PLANT_SITE_ID | PLANT_SITE_ID | 숨김 |
| (OPERATION_NAME) | - | CODE_ONLY_CHANGE. 메타 행 없음. 귀속은 **확인 필요**(analysis.md §7 #9) |

### 3-2. `Plant` (spdMain 시트 1, SpdSheet.shtMain) — 표시 23 / 메타 33

| 컬럼 | 라벨 | 상태 |
|---|---|---|
| ACTUAL_CAPACITY | Actual Capacity | 기본 |
| BIG_LAST_UPDATE_DATE | Big Last Update Date | 기본 |
| BIG_TACT_TIME | Big Tact Time | 기본 |
| BOM_MIN_DUE_DATE | Due Date | 기본 |
| CREATED_BY | Created By | 기본 |
| CREATION_DATE | Creation Date | 기본 |
| DAILY_CAPACITY | Daily Capacity | 기본 |
| DIVISION_ID | Division | 기본 |
| ITEM_ID | Model | 기본 |
| ITEM_UOM | Item UOM | 기본 |
| JUMBO_MIN | Jumbo / Min | 기본 |
| LANE_QTY | Slitting Lane | 기본 |
| LAST_UPDATE_DATE | Last Update Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| LINE_ID | Line* | 기본 (셀 콤보: SpdMain_CellClick:2583, EditButton:641, ClipboardPasted:2773) |
| MODEL_SITE | Model Site | 기본 |
| NICK_NAME | Nick Name | 기본 |
| OPERATION_NAME | Operation | 기본 |
| PLANT_SITE_NAME | Plant Site | 기본 |
| PRIORITY | Priority* | 기본 |
| TACT_TIME | Tact Time* | 기본 |
| UOM_CONVERT_VALUE | UOM Convert | 기본 |
| YIELD | Yield(%)* | 기본 |
| ACTUAL_OUTPUT | Actual Output | 숨김 |
| EFFECTIVE_DATA_COUNT | Effective Data Count | 숨김 |
| EXCEPT_YN | EXCEPT_YN | 숨김 |
| FROM_ACTUAL_CAPACITY | From Actual Capacity | 숨김 |
| INPUT_STATUS | INPUT_STATUS | 숨김 |
| OPERATION_GROUP_ID | OPERATION_GROUP_ID | 숨김 |
| OPERATION_ID | OPERATION_ID | 숨김 |
| PLANT_SITE_ID | PLANT_SITE_ID | 숨김 |
| TO_ACTUAL_CAPACITY | To Actual Capacity | 숨김 |
| VALID_YN | Valid* | 숨김 |

### 3-3. `Tact Time` — 메타 정의만, 코드 미참조(미사용 가능) — 표시 23 / 메타 33

- 컬럼과 라벨, 상태는 `Plant` 시트와 **같습니다**(33행 동일 구성: 기본 23, 숨김 10).
- 코드(CreateSpread·ChangeSheet·SetSheetHeaderColumn)는 이 시트명을 쓰지 않습니다. TO-BE 구현 대상이 아니며 폐기 후보입니다. 최종 판단은 **확인 필요**입니다.

### 3-4. `Tact Time Except` (spdExcept, SpdSheet.shtExcept) — 표시 16 / 메타 27(메타 표시 17)

| 컬럼 | 라벨 | 상태 |
|---|---|---|
| CREATED_BY | Created By | 기본 |
| CREATION_DATE | Creation Date | 기본 |
| DAILY_CAPACITY | Daily Capacity | 기본 → 코드로 바뀜(아래 규칙) |
| DIVISION_ID | Division | 기본 |
| EXCEPT_COMMENT | Comment | 기본 |
| ITEM_ID | Model | 기본 |
| LAST_UPDATE_DATE | Last Update Date | 기본 |
| LAST_UPDATED_BY | Last Updated By | 기본 |
| LINE_ID | Line | 기본 |
| NICK_NAME | Nick Name | 기본 |
| OPERATION_NAME | Operation | 기본 → 코드로 바뀜(아래 규칙) |
| PLANT_SITE_NAME | Plant Site | 기본 |
| TACT_TIME | Tact Time* | 기본 |
| TACT_TIME_END_DATE | End Date* | 기본 |
| TACT_TIME_START_DATE | Start Date* | 기본 |
| USE_YN | Product YN | 기본 |
| YIELD | Yield(%)* | 기본 |
| INPUT_STATUS | INPUT_STATUS | 숨김 |
| OPERATION_ID | OPERATION_ID | 숨김 |
| ORG_DIVISION_ID | ORG_DIVISION_ID | 숨김 |
| ORG_ITEM_ID | ORG_ITEM_ID | 숨김 |
| ORG_LINE_ID | ORG_LINE_ID | 숨김 |
| ORG_OPERATION_ID | ORG_OPERATION_ID | 숨김 |
| ORG_PLANT_SITE_ID | ORG_PLANT_SITE_ID | 숨김 |
| ORG_TACT_TIME_END_DATE | ORG_TACT_TIME_END_DATE | 숨김 |
| ORG_TACT_TIME_START_DATE | ORG_TACT_TIME_START_DATE | 숨김 |
| PLANT_SITE_ID | PLANT_SITE_ID | 숨김 |

코드 표시 변경 규칙(InitSpread:410~416):

| spdMain 활성 시트 | DAILY_CAPACITY | OPERATION_NAME | 표시 수 |
|---|---|---|---:|
| `Plant` | 숨김(410) | 표시(411) | 16 |
| 그 외(`Packer`) | 표시(415) | 숨김(416) | 16 |

## 4. 시트 연결 규칙

| 시트 | 그리드 | 연결 규칙 | 코드 근거 |
|---|---|---|---|
| `Plant` | spdMain(시트 인덱스 0) | META+코드연결 | AddSheet:374, ChangeSheet FindData_Main:1045, SetSpreadInit:435~438, ActiveSheetChanged:2792~2793 |
| `Packer` | spdMain(시트 인덱스 1) | META+코드연결 | AddSheet:377, ChangeSheet Find_Packer:961, InitSpread:425~426, SetSpreadInit:446~449, ActiveSheetChanged:2799~2800 |
| `Tact Time Except` | spdExcept | META+코드연결 | AddSheet:384~386, InitSpread:395~416 |
| `Tact Time` | (없음) | 메타 정의만, 코드 미참조(미사용 가능) | - |

- 상단 spdMain은 시트 탭 2개(Plant/Packer)를 바꿔 가며 씁니다. 하단 spdExcept는 단일 시트입니다.
- 상단 활성 시트에 따라 조회·저장 SP 계열(일반/OSP)과 하단 Except 컬럼 표시가 바뀝니다. 다만 SP 계열 분기 조건 원문은 **확인 필요**입니다.
- 하단 Except 조회는 상단 `SpdMain_CellDoubleClick`에서 시작합니다(마스터→디테일 연결).

=== FILE: oracle_migration.md ===
# SCP0020 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| # | SP | 용도 | 호출 메서드(줄) | 쓰기 대상 | 읽기 대상 | 임시/함수/EXEC 체인 |
|---:|---|---|---|---|---|---|
| 1 | `SCP0020_GET_TACT_TIME_OSP` | Packer 시트 조회 | Find_Packer(980) | - | SCM_MST_PLAN, SCP_OPMZ_LOOKUP_MASTER_DETAIL, DM_PLN_MKT_FCST, SCM_MST_SITE, SCM_MST_BOM_SN_V, SCM_MST_ITEM_SN, SCM_MST_FINAL_ITEM_V, SCP_MST_FINAL_ITEM, SCP_MST_TACT_TIME_EXCEPT_OSP, SCP_MST_TACT_TIME_OSP, SCM_MST_SITE_ITEM_PRIORITY, SCM_MST_PLANT_SN | #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_TMP1 / FN_NEXT_DAY, STRING_SPLIT, FN_GET_ITEM_OPERATION_GROUP, FN_SCM_SPLIT |
| 2 | `SCP0020_GET_TACT_TIME` | Plant 시트 조회 | FindData_Main(1067) | - | DM_PLN_MKT_FCST, SCM_MST_SITE, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCP_MST_FINAL_ITEM, SCP_MST_TACT_TIME_EXCEPT, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_LINE_SN, SCP_MST_TACT_TIME, SCM_MST_ITEM_SN, SCM_MST_PLANT_SN, SCP_MST_LOSS_TIME, SCM_MST_SITE_ITEM_PRIORITY, SCP_MST_TACT_TIME_BIG | #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_TMP1 / FN_NEXT_DAY, STRING_SPLIT, FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_OPERATION_GROUP, FN_SCM_SPLIT |
| 3 | `SCP0020_GET_TACT_TIME_EXCEPT_OSP` | Except(Packer) 조회 | FindData_Except_Packer(1321) | - | SCM_MST_ITEM_SN, SCP_MST_TACT_TIME_OSP, SCP_MST_TACT_TIME_EXCEPT_OSP, SCM_MST_SITE | FN_GET_SCM_SITE_DESCRIPTION |
| 4 | `SCP0020_GET_TACT_TIME_EXCEPT` | Except(Plant) 조회 | FindData_Except(1397) | - | SCP_MST_TACT_TIME, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_TACT_TIME_EXCEPT, SCM_MST_SITE, SCM_MST_ITEM_SN | FN_GET_SCM_SITE_DESCRIPTION, FN_GET_ITEM_NICKNAME |
| 5 | `SCP0020_SAVE_TACT_TIME_OSP` | Packer 저장 | SaveData_Packer(1560) | INSERT/UPDATE(A) SCP_MST_TACT_TIME_OSP, INSERT SCP_MST_TACT_TIME_OSP_H, INSERT SCP_MST_TACT_TIME_EXCEPT_OSP_H, DELETE:A, INSERT SCM_SYS_LOG_BATCH | SCP_MST_TACT_TIME_OSP, SCP_MST_TACT_TIME_EXCEPT_OSP | #TBLDYNAMICPIVOT_SCP0020_TMP, #TBLDYNAMICPIVOT_SCP0020_SAVE_TMP / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 6 | `SCP0020_SAVE_TACT_TIME` | Plant 저장 | SaveData_Main(1797) | UPDATE/INSERT/DELETE SCP_MST_TACT_TIME, INSERT SCP_MST_TACT_TIME_H, DELETE SCP_MST_TACT_TIME_EXCEPT, INSERT SCP_MST_TACT_TIME_EXCEPT_H, INSERT SCM_SYS_LOG_BATCH | SCP_MST_TACT_TIME, SCP_MST_TACT_TIME_EXCEPT | SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN, EXEC PR_SCP_MST_TACT_TIME_HIST |
| 7 | `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` | Except(Packer) 저장 | SaveData_Except_Packer(2023) | INSERT SCP_MST_TACT_TIME_EXCEPT_OSP, INSERT SCP_MST_TACT_TIME_EXCEPT_OSP_H, DELETE:A, UPDATE:A, INSERT SCM_SYS_LOG_BATCH | SCP_MST_TACT_TIME_EXCEPT_OSP | #TBLDYNAMIC_SCP0020 / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| 8 | `SCP0020_SAVE_TACT_TIME_EXCEPT` | Except(Plant) 저장 | SaveData_Except(2227) | INSERT SCP_MST_TACT_TIME_EXCEPT, INSERT SCP_MST_TACT_TIME_EXCEPT_H, DELETE:A, UPDATE:A, INSERT SCM_SYS_LOG_BATCH | SCP_MST_TACT_TIME_EXCEPT | #TBLDYNAMIC_SCP0020 / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL / EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN |

EXEC 체인(SP 내부 전이):
- `SCP0020_SAVE_TACT_TIME` → `PR_SCP_MST_TACT_TIME_HIST`, `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`
- `SCP0020_SAVE_TACT_TIME_OSP` / `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` / `SCP0020_SAVE_TACT_TIME_EXCEPT` → `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`
- 조회 SP 4종은 Fact Pack상 외부 PR EXEC가 없습니다(자기 EXEC만 있음).

## 2. 공통코드 분기 (UP_FX_GetCommonDataList)

| 엔드포인트 | code | 참조 테이블 | 호출 위치 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` | LineByOperation | SCM_MST_LINE_SN, SCM_MST_SITE, SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT | DefineProperty:199, FindData_Main:1041 |
| `biz:CommonData.CommonDataList` | LookupCommon | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | InitControls:220 |
| `biz:CommonData.YesOrNo` | (Type.YesOrNo) | Fact Pack에 DB 보강 없음(Data.CallBizData) | 57, 58, InitControls:218 |

- LineByOperation 분기는 `STRING_SPLIT`(MSSQL 함수)을 참조합니다. 공통 SP를 전환할 때 같이 처리해야 합니다.
- LookupCommon의 LOOKUP 코드값(어느 LOOKUP_TYPE을 조회하는지)은 **확인 필요**입니다.
- YesOrNo가 DB를 읽는지 Biz 내부 고정값인지는 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접호출 SP
- 화면이 직접 부르는 SP 8개는 모두 `MATCH` 상태(FoxQuery `SCP.*` 키와 SP가 매칭됨)입니다. **미등록 또는 직접 SQL 호출은 0건**입니다.
- Fact Pack §7 확인 필요 0건, §9 주석 처리된 호출 0건입니다.
- SP 내부에서 EXEC로 부르는 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `PR_SCP_MST_TACT_TIME_HIST`는 화면 FoxQuery 키가 아닙니다. 공용 PR로 Oracle에 있는지 **확인 필요**입니다.

## 4. Oracle 전환 확인 포인트 (Fact Pack 근거만)

| # | 포인트 | 해당 SP | 근거 |
|---:|---|---|---|
| 1 | `STRING_SPLIT`(MSSQL 전용 함수) 대체 필요 | SCP0020_GET_TACT_TIME_OSP, SCP0020_GET_TACT_TIME, UP_FX_GetCommonDataList(LineByOperation) | REF:STRING_SPLIT |
| 2 | `#` 로컬 임시 테이블 → GTT 등으로 대체 필요 | GET_TACT_TIME_OSP, GET_TACT_TIME, SAVE_TACT_TIME_OSP (#TBLDYNAMICPIVOT_*), SAVE_TACT_TIME_EXCEPT_OSP, SAVE_TACT_TIME_EXCEPT (#TBLDYNAMIC_SCP0020) | CREATE:#… |
| 3 | 임시 테이블 이름에 `DYNAMICPIVOT`이 들어 있어 동적 PIVOT 구성 가능성 | GET_TACT_TIME_OSP, GET_TACT_TIME, SAVE_TACT_TIME_OSP | 이름 기준 추정. 실제 동적 SQL·PIVOT 여부는 SP 원문으로 **확인 필요** |
| 4 | 별칭 대상 `UPDATE:A` / `DELETE:A` (MSSQL `UPDATE A … FROM` 형식 가능성) → Oracle MERGE·상관 서브쿼리 전환 검토 | SAVE_TACT_TIME_OSP, SAVE_TACT_TIME_EXCEPT_OSP, SAVE_TACT_TIME_EXCEPT | DELETE:A, UPDATE:A. 원문 문법은 **확인 필요** |
| 5 | 배열 분해 함수 `SCM_ARR_SPL_CNT`·`SCM_ARR_SPL_VAL`의 Oracle 대응 함수가 있는지 | SAVE 4종 | REF |
| 6 | 사용자 함수 `FN_NEXT_DAY`, `FN_SCM_SPLIT`, `FN_GET_ITEM_OPERATION_GROUP`, `FN_GET_SCM_SITE_DESCRIPTION`, `FN_GET_ITEM_NICKNAME`의 Oracle 대응 객체가 있는지 | GET 4종 | REF |
| 7 | 이력 테이블 동시 기록(_H) 순서와 트랜잭션 경계 | SAVE 4종 (SCP_MST_TACT_TIME_H, SCP_MST_TACT_TIME_EXCEPT_H, SCP_MST_TACT_TIME_OSP_H, SCP_MST_TACT_TIME_EXCEPT_OSP_H) | INSERT:*_H |
| 8 | `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` 호출과 SCM_SYS_LOG_BATCH 기록(트랜잭션 내 로그) | SAVE 4종 | EXEC/INSERT |
| 9 | Plant 저장이 Except 테이블까지 삭제·이력 처리 (SCP_MST_TACT_TIME_EXCEPT DELETE + _H INSERT) | SCP0020_SAVE_TACT_TIME | DELETE:SCP_MST_TACT_TIME_EXCEPT |
| 10 | Packer 저장이 Except_OSP 이력 기록 (SCP_MST_TACT_TIME_EXCEPT_OSP_H INSERT) | SCP0020_SAVE_TACT_TIME_OSP | INSERT:SCP_MST_TACT_TIME_EXCEPT_OSP_H |
| 11 | 저장 결과 `ERR_MESSAGE` 컬럼 반환 계약 유지 | SAVE 4종 | dtErr.Rows[0]["ERR_MESSAGE"] (1622/1874/2094/2297) |
| 12 | View 의존: SCM_MST_BOM_SN_V, SCM_MST_FINAL_ITEM_V, SCM_MST_MODEL_FINAL_ITEM_BOM_V가 Oracle에 있는지 | GET_TACT_TIME_OSP, GET_TACT_TIME | SELECT:*_V |

## 5. 난이도 (참조 객체 수와 MSSQL 전용 요소 기준)

| SP | 참조 객체 수(Fact Pack 항목) | MSSQL 전용 요소 | 난이도 |
|---|---:|---|---|
| SCP0020_GET_TACT_TIME | 25 | # 임시 2, STRING_SPLIT, 사용자 함수 4 | 높음 |
| SCP0020_GET_TACT_TIME_OSP | 23 | # 임시 2, STRING_SPLIT, 사용자 함수 3 | 높음 |
| SCP0020_SAVE_TACT_TIME_OSP | 18 | # 임시 2, 별칭 UPDATE/DELETE, 배열 분해 함수 | 높음 |
| SCP0020_SAVE_TACT_TIME | 14 | 배열 분해 함수, EXEC 2 | 중간 |
| SCP0020_SAVE_TACT_TIME_EXCEPT_OSP | 13 | # 임시 1, 별칭 UPDATE/DELETE, 배열 분해 함수 | 중간 |
| SCP0020_SAVE_TACT_TIME_EXCEPT | 13 | # 임시 1, 별칭 UPDATE/DELETE, 배열 분해 함수 | 중간 |
| SCP0020_GET_TACT_TIME_EXCEPT | 8 | 사용자 함수 2 | 낮음 |
| SCP0020_GET_TACT_TIME_EXCEPT_OSP | 6 | 사용자 함수 1 | 낮음 |

> 난이도는 Fact Pack의 참조 객체 항목 수와 MSSQL 전용 요소 유무로만 매겼습니다. SP 원문 줄 수와 동적 SQL 여부는 Fact Pack에 없어 반영하지 못했습니다(**확인 필요**).

=== FILE: tobe_design.md ===
# SCP0020 TO-BE 설계 입력 (사실 기반)

## 1. 조회조건 (컨트롤 기준)

| 순번(추정) | 조건 라벨(원문) | AS-IS 컨트롤 | 유형 | 필수 | 연동 |
|---:|---|---|---|---|---|
| - | `Division*` | cboDivision | 단일 콤보 | Y(라벨 *) | `ClbDivision_SelectedIndexChanged` → Plant Site 갱신 가능성(RefreshPlantSiteByDivision:292). 연결은 **확인 필요** |
| - | `Plant Site` | clbPlantSite | 멀티 체크리스트 | - | `ClbPlantSite_SelectedIndexChanged` → Line 갱신 가능성(RefreshLineByPlantPacker:327). 연결은 **확인 필요** |
| - | `Operation Group*` | cboOperationGroup | 단일 콤보 | Y(라벨 *) | Line 갱신 가능성(RefreshLineByOperation:301). **확인 필요** |
| - | `Line` | clbLine | 멀티 체크리스트 | - | LineByOperation 공통코드 관련 가능성. **확인 필요** |
| - | `Model` | txtItemId (+btnItemId) | 멀티라인 입력 + 버튼 | - | `btnItemId_Click` → txtItemId 값 설정 |
| - | `Valid` | cboValid | 단일 콤보 | - | `biz:CommonData.YesOrNo` |

- 조건의 표시 순서는 Location이 추출되지 않아 **확인 필요**입니다.
- SCP 화면은 TO-BE 기준표(search_cond.csv) 정의를 따라야 합니다. 그 기준표와 대조하는 작업은 이 문서 범위 밖입니다(**확인 필요**).
- TB_FX_SearchCondition에 255행이 있습니다(저장된 조회조건). 내용은 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 진입점 | 조건(사실) | 호출 API 후보(TO-BE) |
|---|---|---|---|
| 화면 진입 | `Form_Load` | - | 공통코드: YesOrNo(Valid 콤보), CommonDataList LookupCommon, CommonDataList LineByOperation |
| 조회 | FindButton → Find_Data | Packer 시트 | `SCP0020_GET_TACT_TIME_OSP` |
| 조회 | FindButton → Find_Data | Plant 시트 | `SCP0020_GET_TACT_TIME` (+ LineByOperation 재조회 1041) |
| 상단 행 더블클릭 | `SpdMain_CellDoubleClick` | Packer 계열 | `SCP0020_GET_TACT_TIME_EXCEPT_OSP` → 하단 Except 그리드 |
| 상단 행 더블클릭 | `SpdMain_CellDoubleClick` | Plant 계열 | `SCP0020_GET_TACT_TIME_EXCEPT` → 하단 Except 그리드 |
| 저장 | SaveButton → SaveData_Packer | Packer | `SCP0020_SAVE_TACT_TIME_OSP` → 재조회 `SCP0020_GET_TACT_TIME_OSP` |
| 저장 | SaveButton → SaveData_Main | Plant | `SCP0020_SAVE_TACT_TIME` → 재조회 `SCP0020_GET_TACT_TIME` |
| 저장 | SaveButton → SaveData_Except_Packer | Except(Packer) | `SCP0020_SAVE_TACT_TIME_EXCEPT_OSP` → 재조회 `SCP0020_GET_TACT_TIME_EXCEPT_OSP` |
| 저장 | SaveButton → SaveData_Except | Except(Plant) | `SCP0020_SAVE_TACT_TIME_EXCEPT` → 재조회 `SCP0020_GET_TACT_TIME_EXCEPT` |
| 행 추가 | InsertButton | Packer 시트일 때 LINE_ID 셀 콤보(864) | 클라이언트 처리 + 콤보 데이터 |
| 편집 | EditButton | INPUT_STATUS == "I" 행의 LINE_ID 셀 콤보(641) | 클라이언트 처리 |
| 셀 클릭 | `SpdMain_CellClick` | Plant 시트 LINE_ID, 잠금 아님 | LineByOperation 데이터(division·FACTORY_ID·OP 필터) |
| 붙여넣기 | `SpdMain_ClipboardPasted` | LINE_ID 범위 | LINE 콤보 데이터 재적용 |
| 시트 전환 | `SpdMain_ActiveSheetChanged` | Plant ↔ Packer | 시트 정보 전환. 하단 Except 컬럼 표시 규칙(DAILY_CAPACITY/OPERATION_NAME) 재적용 |

- 액션별로 어떤 SP를 고르는지(Packer/Plant, Except Packer/Except)의 분기 조건 원문은 **확인 필요**입니다. 위 "조건"은 메서드명과 시트명으로 대응시킨 것입니다.
- 저장 SP 4종은 `ERR_MESSAGE`를 돌려줍니다. 이 값을 성공·실패 판정과 메시지 표시에 써야 합니다.

## 3. Division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 | division 차이 | 코드 변형 |
|---|---:|---|---|
| Plant (상단 탭 1) | 23 | 없음(14종 동일) | LINE_ID 셀 콤보 |
| Packer (상단 탭 2) | 14 | 없음 | LINE_ID 셀 콤보(Insert) |
| Tact Time Except (하단) | 16 | 없음 | 상단 Plant 활성 시 OPERATION_NAME 표시·DAILY_CAPACITY 숨김, Packer 활성 시 반대 |
| Tact Time | 23 | 없음 | 코드 미참조. 구현 제외 후보(**확인 필요**) |

- division에 따른 Grid 분기는 메타와 코드 어디에도 없습니다.

## 4. 권한(C/R/U/D) 관련 사실
- `TB_FX_GroupMenuAuth`에 SCP0020 관련 행이 13개 있습니다. 그룹별 C/R/U/D 값은 Fact Pack에 없어 **확인 필요**입니다.
- 코드에서 확인된 공통 버튼은 FindButton(조회), SaveButton(저장), InsertButton(추가), EditButton(편집)입니다. Delete 계열 버튼은 Fact Pack에 없습니다(**확인 필요**).
- 저장 SP 중 `SCP0020_SAVE_TACT_TIME`에는 DELETE:SCP_MST_TACT_TIME이, EXCEPT 계열 저장 SP에는 DELETE:A가 있습니다. 즉 저장 SP 안에서 삭제가 일어납니다. 이것이 행 삭제 상태(INPUT_STATUS 등)로 일어나는지는 **확인 필요**입니다.
- 그리드 편집 잠금 판정에 `siMain.IsLock("Plant")`, `siMain.IsLockCell(...)`, `siMain.IsLock(siMain.SheetName)`이 쓰입니다(2583·864·2773줄). 잠금 기준이 권한인지 상태인지는 **확인 필요**입니다.

## 5. 미확정 사항

| # | 항목 |
|---:|---|
| 1 | 조회·저장·더블클릭의 Packer/Plant 분기 조건 원문 |
| 2 | 조회조건 컨트롤의 배치 순서와 각 콤보의 데이터 원천(cboDivision, cboOperationGroup, clbLine, clbPlantSite) |
| 3 | `btnItemId_Click`의 Model 선택 방식(팝업 여부) |
| 4 | 내부 동작이 미추출된 이벤트 핸들러 11개: `SpdMain_EditModeOff`, `SpdMain_EditChange`, `spdExcept_EditModeOff`, `spdExcept_EditChange`, `ClbDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged`, `SpdMain_TopChange`, `SpdExcept_TopChange`, `SpdMain_Changed`, `SpdMain_Changed_Packer`, `SpdExcept_Changed` |
| 5 | `Tact Time` 메타 시트 폐기 여부 |
| 6 | grid_effective의 Packer OPERATION_NAME(CODE_ONLY_CHANGE) 귀속 오류 여부 |
| 7 | 권한 13행의 C/R/U/D 값과 Delete 버튼 유무 |
| 8 | 그리드 컬럼 표시 순서(메타 정렬 컬럼 원문) |
| 9 | 실제 SP 실행 결과와 시트 매칭(grid 단계 미실행) |
| 10 | 저장 SP 내부 PR(`PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `PR_SCP_MST_TACT_TIME_HIST`)이 Oracle에 있는지 |
