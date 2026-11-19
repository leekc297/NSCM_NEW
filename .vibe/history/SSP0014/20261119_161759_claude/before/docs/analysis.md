# SSP0014 Shipment Model PIC — As-is 분석

> 출처: AsisFacts 정적 추출(Fact Pack SSP0014). 이 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0014 |
| 클래스 | `SSP0014_ShipmentModelPIC` |
| 폼 Text | `SSP0014_ShipmentModelPIC` (Designer.cs:546) |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) |
| 메타 시트 | `Shipment Model PIC` (SCM_MST_SHEET_COLUMNS 21행) |
| 메뉴/프로그램 메타 | TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_GroupMenuAuth 13행, TB_FX_Favorite 56행, TB_FX_SearchCondition 112행, SCM_ADM_DB_SCRIPT_BACKUP 5행 |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs | GSCM.SSP.Plan.UIL.csproj | 864 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 596 |
| shared | 없음 (Fact Pack에 없음) | – | – |
| legacy | 없음 (variant 전부 `only`) | – | – |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 호출 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| FindButton (조회) | FindButton > FindData_Main | 329 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | MATCH | SSP0014_GET_SHIPMENT_MODEL_PIC |
| SaveButton (저장) | SaveButton > SaveData > GetUserIDChk | 562 | `SSP.SSP0014_GET_USER_ID_CHECK` | MATCH | SSP0014_GET_USER_ID_CHECK |
| SaveButton (저장) | SaveButton > SaveData | 497 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | MATCH | SSP0014_SAVE_SHIPMENT_MODEL_PIC |
| SaveButton (저장 후 재조회) | SaveButton > SaveData > FindData_Main | 329 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | MATCH | SSP0014_GET_SHIPMENT_MODEL_PIC |
| (진입점 미연결) | `<field:dtYesOrNo>` | 54 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – (Data.Common[Type.YesOrNo] > Data.CallBizData) |

- SaveData 안에서 GetUserIDChk(562)·SAVE(497)·재조회(329)가 **어떤 순서로, 어떤 조건에서** 실행되는지는 Fact Pack에 없습니다 → **확인 필요**. 위 표의 순서는 흐름 행을 나열한 것이고 실행 순서를 확인한 것이 아닙니다.
- 조회 파라미터 구성: FindData_Main 310~313줄에서 `CString.GetCheckedListValue`(CODE)를 4회 호출합니다. 어느 컨트롤의 값인지는 **확인 필요**입니다(체크리스트 컨트롤은 `clbFromSite` 1개뿐).

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블/객체 (EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | – | – |
| `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | MATCH | 1 | SSP0014_GET_SHIPMENT_MODEL_PIC | SELECT: SCM_MST_SITE_ITEM, SCM_MST_SITE, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_ITEM_SN / REF: FN_GET_ITEM_NICKNAME, STRING_SPLIT |
| `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | MATCH | 1 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | MERGE: SSP_MST_MODEL_USER / INSERT: SCM_SYS_LOG_BATCH / EXEC: PR_SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `SSP.SSP0014_GET_USER_ID_CHECK` | MATCH | 1 | SSP0014_GET_USER_ID_CHECK | SELECT: TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION / REF: STRING_SPLIT |

- 주석 처리된 호출: 0건.
- 확인 필요 행(Fact Pack §7): 0건.

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:110 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:240 |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:241 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:242 |
| btnItemId | Click | `btnItemId_Click` | InitEvent:243 |

- `btnItemId_Click`: 857줄에서 `txtItemId.Text = sItemId`로 값을 넣습니다. `sItemId`를 어디서 얻는지(팝업 여부 등)는 **확인 필요**입니다.
- `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `CboDivision_SelectedIndexChanged`, `Form_Load`의 본문 동작은 Fact Pack에 없습니다 → **확인 필요**.

## 5. 초기화·메타 소비 메서드

| 메서드 | 줄 | 내용 |
|---|---|---|
| SetChangeControl | 137~138 | `Filter` 의 GROUP_ID, USER_ID 를 읽고 `UserInfoContext.Current.NowGroupID` 를 참조 |
| SetChangeControl | 144, 149 | `DataService.GetSSPInnerTable` 호출. 읽는 메타 컬럼: CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| InitControls | 170, 173 | `DataService.FP_Log2` 호출 (LOGTYPE, NOTE, USER_ID) |
| InitControls | 184~185 | `insertRow["CODE"]`, `insertRow["NAME"]` 로 행 추가. 어느 콤보에 넣는지는 **확인 필요** |
| SetChangedControl | 197 | `CString.GetCheckedListValue` (CODE). SetChangeControl 과 이름이 다른 메서드로 추출되었으므로 **확인 필요** |
| CreateSpread | 208~211 | AddSheet("Shipment Model PIC", 1, 1, 30) → GetSheetInfo(spdMain.Name, 0) → ChangeSheet |
| InitSpread | 220~233 | InitSheet → `SpreadInfo.SetSheetHeaderColumn(spdInfo, 1)` → 이미지 CellType 지정 8회 |
| EditButton | 271 | `if(fps.Name == "spdMain")` 일 때 GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| SaveButton | 285 | `SaveData` 호출. 추출기는 이 호출을 `PersonalSettingPopup.SaveData` 로 해석했지만, 이 화면 클래스의 SaveData(497줄 SAVE 호출)일 수 있습니다 → **확인 필요** |

## 6. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

- 시트 `Shipment Model PIC` 1개. 연결 규칙은 `META+코드연결`입니다(코드가 AddSheet 로 메타 시트명을 사용).
- 컬럼은 `SetSheetHeaderColumn`(InitSpread:222)이 SCM_MST_SHEET_COLUMNS 메타 21행으로 만듭니다.
- 코드 변경: InitSpread 225·226·227·229·230·231·232·233줄에서 `CellType = cellTypeImage`를 지정합니다(8건). 어느 컬럼에 적용되는지는 추출되지 않았습니다 → **확인 필요**.
- Designer.cs 411~414줄: 컬럼헤더 스타일(HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General).

### Division별 차이
- 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 등 **모든 division에서 21컬럼, 모두 '기본'**(필수+기본 21 / 선택 0)입니다. division별 차이는 **없습니다**.
- 코드 분기 중 division 판단 불가 건: 0건.
- 실제 SP 실행 결과와 맞춘 시트 매칭은 미실행입니다(Fact Pack 기재) → **확인 필요**.

## 7. 확인 필요 항목

1. SaveData 안에서 GetUserIDChk·SAVE·재조회가 실행되는 순서와 조건
2. SaveButton:285 의 SaveData 해석(PersonalSettingPopup.SaveData 로 추출됨)이 맞는지
3. `biz:CommonData.YesOrNo`(dtYesOrNo, 54줄)를 쓰는 컨트롤 — 진입점 미연결로 추출되었습니다. cboValidYN 과의 연결은 추정이므로 확인 필요
4. FindData_Main 310~313 의 GetCheckedListValue 4회가 각각 어느 컨트롤 값인지
5. InitSpread 이미지 CellType 8건의 대상 컬럼
6. 각 이벤트 핸들러 본문(TopChange, CellDoubleClick, Division 변경, Form_Load)
7. `usrButton1`(parent 없음, 75×23) 사용 여부
8. Add/Delete 등 행 편집 버튼 존재 여부 (Fact Pack에는 FindButton, SaveButton, EditButton 만 있음)
