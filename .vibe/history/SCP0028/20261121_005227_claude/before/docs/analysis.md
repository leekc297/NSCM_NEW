# SCP0028 Shipment Lot Size — AS-IS 분석

> 출처: AsisFacts 정적 추출 Fact Pack(SCP0028). Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0028 |
| 클래스 | `SCP0028_Shipment_Lot_Size` |
| 폼 Text | `SCP0028_Shipment_Lot_Size` (Designer.cs:724) |
| 도메인 | SCP (경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\…`) |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0028_Shipment_Lot_Size\SCP0028_Shipment_Lot_Size.csproj` |
| 업무 성격 | Master 폴더에 있는 화면. 저장 SP가 `SCP_MST_SHIPMENT_LOT_SIZE`를 MERGE/DELETE함(§3) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `…\SCP0028_Shipment_Lot_Size\Properties\AssemblyInfo.cs` | 37 |
| current | `…\SCP0028_Shipment_Lot_Size\SCP0028_Shipment_Lot_Size.cs` | 784 |
| current | `…\SCP0028_Shipment_Lot_Size\SCP0028_Shipment_Lot_Size.Designer.cs` | 792 |
| shared | 없음 (Fact Pack에 shared 파일 없음) | – |
| legacy | 본문 표에는 없음 (legacy 사본이 있는지는 CSV 원본에서 **확인 필요**) | – |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| `this.Load` | `Form_Load` > `InitControls` | 135 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – |
| `this.Load` | `Form_Load` > `InitControls` | 137 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| `this.Load` | `Form_Load` > `InitControls` > `SetChangedControl` | 166 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | – |
| `this.Load` | `Form_Load` > `InitControls` > `SetChangedControl` | 169 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | – |
| `cboDivision.SelectedIndexChanged` | `ClbDivision_SelectedIndexChanged` > `SetChangedControl` | 166 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | – |
| `cboDivision.SelectedIndexChanged` | `ClbDivision_SelectedIndexChanged` > `SetChangedControl` | 169 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | – |
| FindButton(프레임워크 버튼) | `FindButton` > `FindData` | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE |
| SaveButton(프레임워크 버튼) | `SaveButton` > `SaveData` | 659 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_SAVE_SHIPMENT_LOT_SIZE |
| SaveButton(프레임워크 버튼) | `SaveButton` > `SaveData` > `FindData` (저장 후 재조회) | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE |
| `this.btnInput.Click` | `btnInput_Click` > `FindInput` | 417 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT |
| `this.btnDelete.Click` | `btnDelete_Click` > `FindDelete` | 511 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_SAVE_SHIPMENT_LOT_SIZE |
| `this.btnDelete.Click` | `btnDelete_Click` > `FindDelete` > `FindData` (삭제 후 재조회) | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE |
| (진입점 미연결) | `<field:dtTransMode>` 필드 초기화 | 44 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| (진입점 미연결) | `<field:dtYesOrNo>` 필드 초기화 | 46 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – |

- 정리하면, 삭제(`btnDelete_Click`)는 별도 삭제 SP를 쓰지 않고 저장 SP `SCP0028_SAVE_SHIPMENT_LOT_SIZE`를 호출합니다(511줄). 이때 넘기는 구분 인자(삭제 플래그 등)는 Fact Pack에 없으므로 **확인 필요**입니다.
- `btnInput_Click`(265줄)과 `btnDelete_Click`(293줄)은 `CString.GetCheckedListValue`를 호출합니다(§4-2).

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체 (EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | 1 | (코드분기) UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | 1 | (코드분기) UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 2 | (코드분기) UP_FX_GetCommonDataList | SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 2 | – (DB 보강 없음) | – |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | 1 | SCP0028_GET_SHIPMENT_LOT_SIZE | REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_SITE |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | MATCH | 1 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, #TBLDYNAMIC_SCP0028IN_DIV/OPER/FROM/TO/ITEM/INPUT (INSERT/SELECT), REF:UF_FX_STRING_SPLIT, REF:FN_GET_LOOKUP_CODE_DESC, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_BOD, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE |
| `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | MATCH | 2 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST, MERGE:SCP_MST_SHIPMENT_LOT_SIZE, DELETE:SCP_MST_SHIPMENT_LOT_SIZE, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_SHIPMENT_LOT_SIZE_H |

- FromSiteByDivision과 ToSiteByDivision 호출에서는 `UserInfoContext.Current.NowGroupID`를 읽습니다(SetChangedControl 166/169줄, meta_reads.csv).
- 주석 처리된 호출은 0건입니다(commented_calls.csv 0행).

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 연결 엔드포인트 |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:95 | YesOrNo, LookupCommon, FromSite/ToSiteByDivision |
| this.btnInput | Click | `btnInput_Click` | InitEvent:117 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| this.btnDelete | Click | `btnDelete_Click` | InitEvent:118 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:120 | 없음 (본문 동작은 **확인 필요**) |
| dsdm | Changed | `spdMain_Change` | InitEvent:124 | 없음 (`dsdm` 객체의 정체와 본문 동작은 **확인 필요**) |
| cboDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitControls:144 | FromSiteByDivision, ToSiteByDivision |
| this.btnItemId | Click | `btnItemId_Click` | InitControls:146 | 없음. 256줄에서 `txtItemId.Text = sItemId`를 설정함 (팝업 호출 여부는 **확인 필요**) |

## 5. Grid 구성 방식

- 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)**
- 시트는 1개 `Shipment Lot Size`이며 연결 규칙은 `META+코드연결`입니다.
  - `CreateSpread:176`에서 `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30)`을 호출합니다.
  - `CreateSpread:177`의 `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)`와 `CreateSpread:178`의 `ChangeSheet`가 이어집니다.
  - `InitSpread:185`의 `InitSheet(siMain.SheetName)`와 `InitSpread:186`의 `SetSheetHeaderColumn(siMain, 1)`이 메타로 컬럼을 생성합니다(헤더 1행).
- 코드 override는 Designer.cs 633~636줄의 컬럼헤더 스타일(`HorizontalAlignment=General`, `NoteIndicatorColor=Red`, `Parent=ColumnHeaderDefaultEnhanced`, `VerticalAlignment=General`)뿐이며 컬럼을 추가하거나 숨기지 않습니다.
- 메타는 `SCM_MST_SHEET_COLUMNS` 18행이고, 이 중 표시 15개(모두 '기본'), 숨김 3개(FROM_SITE, TO_SITE, TRANS_MODE_CODE)입니다.

### 5-1. Division별 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Lot Size | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

- 14개 division 모두 15개 컬럼으로 같습니다. division 분기 코드 0건, 판단 불가 분기 0건입니다.

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---|---|---|
| 1 | `<field:dtTransMode>`(44)와 `<field:dtYesOrNo>`(46)가 "진입점 미연결"로 분류된 이유. 필드 초기화 시점 호출인지, `InitControls` 135/137 호출과 중복인지 | flow.csv unreached |
| 2 | LookupCommon(137)이 바인딩되는 컨트롤. `clbTransMode`일 것으로 보이나 Fact Pack에는 연결이 명시되지 않음 | endpoints.csv 137 |
| 3 | FromSite/ToSiteByDivision(166/169) 결과가 `clbFromSite`/`clbToSite`에 바인딩되는지 | 바인딩 대상 미추출 |
| 4 | `cboOperationGroup`의 데이터 소스. 바인딩 엔드포인트가 추출되지 않음 | endpoints.csv에 없음 |
| 5 | §4-2에서 `SaveData`(SaveButton:207)를 `PersonalSettingPopup.SaveData`로 해석한 부분. 화면 자체 `SaveData`(659)와 이름이 같아 정적 해석이 섞였을 수 있음 | Fact Pack §4-2 |
| 6 | `EditButton` 메서드(231줄, `GetSheetInfo` 호출)의 역할과 진입점 | grid_code.csv |
| 7 | `FindDelete`가 저장 SP에 넘기는 삭제 구분값 | endpoints.csv 511 |
| 8 | `SpdMain_TopChange`와 `spdMain_Change`(dsdm.Changed)의 본문 동작 | events.csv |
| 9 | 메타 18개 컬럼의 표시 순서. grid_effective.csv는 정렬 기준이 명시되지 않음 | grid_effective.csv |
| 10 | `usrLayoutControl1`(657×184, parent 미지정)의 실제 배치 위치와 용도 | controls.csv, props.csv |
