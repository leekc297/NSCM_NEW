# SCP0107 CAPA TEEP Report — AS-IS ↔ TO-BE 매핑 매트릭스

> `convert-react` iter-1 산출(2026-09-25) + **iter-2 개정**(2026-09-25 — `react-gap-audit` iter-1 issues
> R-02·R-03·R-04·R-05·R-06·R-07 반영. 개정 지점은 본문에 `iter-2 R-xx` 로 표기).
> AS-IS 백본 항목 **100% 매핑**이 게이트다(convert-core §2.1 #11).
> 근거 표기 — `cs:` = `06.UIL/GSCM.SCP.Forms.UIL/Report/SCP0107_CAPA_TEEP_Report/SCP0107_CAPA_TEEP_Report.cs`(1,780행) ·
> `dsn:` = 동 `.Designer.cs`(949행) · `BaseForm:`/`SpreadInfo:`/`DataUtil:` = `01.Framework/GSCM.Windows.Forms` ·
> `BL:`/`capa:` = `GSCM.SCP.Common.UIL/Class/ScpCapaBL.cs`·`ScpCapa.cs` · `blu:` = `GSCM.Utils/BLUtils.cs` ·
> `si:`/`su:` = SVN pristine 프레임워크(`SpreadInfo`/`SheetUtils`).
> 설계 원문 — `design/00_checklist.md`(백본) · `01_layout.md`(L-xx) · `02_search-combo.md`(C-xx/A-x) ·
> `03_grid-columns.md`(G-xx/V-xx) · `convert-flow/goal.md`(S-xx/D-x/E-x).

| 축 | AS-IS n | 매핑 n | 이식 | 미이식(사유 기재) |
|---|--:|--:|--:|--:|
| controls | 37 | 37 | 32 | 5 |
| events | 10 | 10 | 10 | 0 |
| validations | 1 | 1 | 1 | 0 |
| spCalls (+ 백본밖 1) | 1 (+1) | 2 | 2 | 0 |
| popups | 1 | 1 | 1 | 0 |
| comboCalls | 4 | 4 | 2 | 2 |
| filterCalls | 5 | 5 | 5 | 0 |
| buttonGuards | 5 | 5 | 2 | 3 |
| gridSignals | 12 | 12 | 5 | 7 |
| entryPoints | 13 | 13 | 13 | 0 |
| 백본 밖 편입 | 22 그룹 | 22 | 15 | 7 |

---

## 1. controls 37건

### 1-1. 조회조건 컨트롤 (영역2)

| # | AS-IS | dsn | TO-BE | 비고 |
|--:|---|--:|---|---|
| 8 | `clbDivision` (UsrCheckedList, ALL_VIEW) | 482~518 | `CapaTeepReportForm.tsx` Div. `CustomDropdown multiple allOption` | **다중선택**이다. 자매 SCP0105/0106/0108 은 단일 — 복사 금지 |
| 6 | `cboVersion` (UsrCombo) | 370~392 | 동 Plan Month `CustomDropdown` | 후보 = `PROG_STAT='2'` 버전만(C2) |
| 7 | `cboVersionSeq` (UsrCombo) | 436~469 | 동 Ver. `CustomDropdown` | 값/표시 둘 다 `VER_SEQ` |
| 34 | `txtPlanType` (읽기전용) | 471~478 | 동 `InputField readOnly` (라벨 없음) | `Enabled=false`+`TabStop=false` -> `readOnly` |
| 31 | `rgrpDivisionType` (RadioGroup 3항목) | 520~532 | 동 Operation group `CustomDropdown` (라벨 `LBL00027` — iter-2 R-02) | 공용 RadioGroup 부재 -> 단일선택 드롭다운(자매 5화면 동일 판단). 값은 화면 상수 = AS-IS 원천도 Designer 리터럴이라 hook #87 §L 미해당 |
| 14 | `clbSite` | 319~355 | 동 Site `CustomDropdown multiple allOption` | |
| 13 | `clbPlant` | 279~315 | 동 Plant | |
| 10 | `clbFactory` | 239~275 | 동 **Building**(LBL00008) | 컨트롤명은 Factory 지만 표기는 Building |
| 11 | `clbLine` | 159~195 | 동 Line | `_C`/`_A` 쌍 재정렬 포함 |
| 12 | `clbOperation` (조건부 가시) | 199~235 | 동 Operation (`extraConditions`, `showOperation`) | L-01 |
| 9 | `clbElectrodeType` (조건부 가시) | 394~432 | 동 Line Type (`extraConditions`, `showElectrodeType`) | L-02 |
| 1 | `Division` (LayoutControlItem 라벨슬롯) | 601~614 | `FormItem label={t(LBL_DIVISION)}`(=**LBL00001** "Div.") | iter-2 R-03 — AS-IS 문자열 `Division`(LBL00641) 이 아니라 카탈로그 확정값 `LBL00001`. 02 §4.5.1 이 LBL00641 을 "rename 규칙상 미채택"으로 판정했고 설계 문서 충돌 시 카탈로그가 정본이다(hook #112 §4-1) |
| 2 | `Division1` (Text "Plan Month") | 616~630 | `FormItem label={t('LBL00053')}` | Name 은 복사 잔재 |
| 4 | `VersionSeq` (Text "Version") | 632~646 | `FormItem label={t(LBL_VERSION)}`(=LBL00606) | 카탈로그 `Ver.` 는 LBL 미등록 -> 별도 상신(D-4) |
| 3 | `PlanType` (TextVisible=false) | 648~662 | `FormItem label=''` | |
| 27 | `layoutControlItem8` (Site) | 672~686 | `FormItem label={t('LBL00015')}` | |
| 24 | `layoutControlItem2` (Plant) | 688~701 | `FormItem label={t('LBL00030')}` | |
| 25 | `layoutControlItem4` (Building) | 703~716 | `FormItem label={t('LBL00008')}` | |
| 26 | `layoutControlItem6` (Line) | 718~731 | `FormItem label={t('LBL00010')}` | |
| 30 | `lciOperation` | 733~746 | `FormItem label={t('LBL00009')}` + 조건부 렌더 | L-01 |
| 29 | `lciElectrodeType` | 748~762 | `FormItem label={t('LBL00056')}` + 조건부 렌더 | L-02 |
| 28 | `lciDivisionType` (TextVisible=false) | 560~569 | `FormItem label={t('LBL00027')}`(="Operation group") | iter-2 R-02 — AS-IS 는 라벨 미표시지만 카탈로그 정본(02 §5.1 #1)이 명칭 `Operation group` 을 확정했고 충돌 시 카탈로그가 승한다(hook #112 §4-1). 선택지 라벨 `LBL00038`("Electrode")을 필드명으로 쓰면 3지선다 앞에 "Electrode" 가 찍히므로 그것은 여전히 오답이다 |
| 35 | `usrConditionPanel1` (HidePanel) | 124~132 | `SearchArea` + `MainTitle.openSearchArea` 토글 | 화면이 토글 핸들러를 만들지 않는다(hook #63) |
| 37 | `usrLayoutControl2` | 134~155 | `SearchArea` 1개 + 권한 0건 시 `disabled` prop 1개 | 필드별 disabled 산포 금지(L-04) |
| 22 | `layoutControlGroup2` (Root, Items 16) | 534~558 | `SearchArea` 내부 12-column Grid (`@shared/mui` `Grid`) | 별도 그룹 컴포넌트 신설 금지(L-03). 전 `FormItem` 에 `commonStyles.formItem`(hook #121) |
| – | `emptySpaceItem1/2/5/12` | 583~599, 664~670, 764~773 | Grid 여백(전용 컴포넌트 생성 없음) | DevExpress 여백 아이템 |

### 1-2. 그리드 · 버튼 · 리소스 (영역3 / 영역1)

| # | AS-IS | dsn/cs | TO-BE | 비고 |
|--:|---|---|---|---|
| 32 | `spdMain` (FpSpread, 2시트) | dsn:775~784 / cs:1188~1191 | `CapaTeepReportGrid.tsx` 공용 `DataGrid` 1개 + `sheetName` 스위치 | `TabStripPolicy=Never` -> 탭 UI 생성 금지(G-01) |
| 5 | `btnColumn` (UsrButton 24x24) | dsn:828~863 / cs:1765~1778 | `SubTitle customButtons` `IcGridColumnSetup` -> `CapaTeepReportColumnModal` | 조회영역에서 SubTitle 로 이동(L-20 / hook #120) |
| 23 | `layoutControlItem1` (btnColumn 슬롯) | dsn:571~581 | (슬롯 미이식 — 버튼이 SubTitle 로 이동) | L-20 |
| – | `imageList1` (edit.png) | dsn:118~122 | (미이식) | 비가시 리소스. TO-BE 아이콘은 `@foundation/assets` |
| – | Form `SCP0107_CAPA_TEEP_Report` | dsn:869~875 | `CapaTeepReport.tsx` (프래그먼트 반환) | **페이지 최상위 래퍼 div 금지**(셸 소유, hook #132 §1-2) |

### 1-3. 미이식 controls 5건 (전건 사유)

| # | AS-IS | 사유 | 근거 |
|--:|---|---|---|
| 36 | `usrLayoutControl1` | **사장 노드** — `Form.Controls` 미추가 + `cs` 참조 0건. 이식하면 빈 레이아웃 컨테이너가 하나 더 생겨 hook #132 §1-2 위반 | L-05 / V-14 |
| 21 | `layoutControlGroup1` | **사장 노드** — Root 지정만 되고 `Items.AddRange` 0건. L-05 와 한 쌍 | L-06 / V-14 |
| 33 | `spdMain_Sheet1` | Designer 초기 시트. 런타임 `AddSheet` 2시트로 대체되는 잔재 | G-01 / 03 §7.1 |
| 23 | `layoutControlItem1` | btnColumn 이 SubTitle 로 이동해 조회영역 슬롯이 사라진다 | L-20 |
| – | `imageList1` | 비가시 리소스(아이콘 소스가 TO-BE 에서 `@foundation/assets`) | – |

---

## 2. events 10건 (cascade 의존 그래프)

| # | AS-IS 핸들러 | cs | TO-BE | 비대칭 재현 |
|--:|---|--:|---|---|
| 4 | `clbDivision_SelectedIndexChanged` | 1634 | `CapaTeepReportForm` Div. `onChange` -> `setSearchParamsWithLineTypeRefresh({ verId:'', verSeq:'', ...resetAllAxes })` + `useCapaTeepReportConditionEffects` 가 그리드 비움·헤더 갱신 | `BeforeFindData` 4트리거 중 1 |
| 3 | `cboVersion_SelectedIndexChanged` | 1644 | 동 Plan Month `onChange` (verSeq 비움 + 6축 리셋) | 동 |
| 2 | `cboVersionSeq_SelectedIndexChanged` | 1653 | 동 Ver. `onChange` (6축 리셋) | 동 |
| 10 | `rgrpDivisionType_SelectedIndexChanged` | 1661 | 동 Operation group `onChange` — `comboId` 스위치로 **마스터 콤보 자체 교체**(재조회) + 6축 리셋 | 동. `refetch()` 직접 호출 0건(S-5) |
| 9 | `clbSite_SelectedIndexChanged` | 1676 | 동 Site `onChange` -> Plant/Building/Line/Operation 만 `ALL` 리셋 | **Line Type 미갱신**(비대칭 1) · **그리드 미비움**(비대칭 2) |
| 8 | `clbPlant_SelectedIndexChanged` | 1684 | 동 Plant `onChange` -> Building/Line/Operation 리셋 | 동 |
| 5 | `clbFactory_SelectedIndexChanged` | 1691 | 동 Building `onChange` -> Line/Operation 리셋 | 동 |
| 6 | `clbLine_SelectedIndexChanged` | 1697 | 동 Line `onChange` -> Operation 리셋 | 동 |
| 7 | `clbOperation_SelectedIndexChanged` | 1702 | 동 Operation `onChange` -> `setSearchParamsWithLineTypeRefresh({ electrodeType:'ALL' })` | Line Type **만** 갱신(cascade 말단 직전) |
| 1 | `btnColumn_Click` | 1765 | `SubTitle customButtons.action` -> 모달 open. OK 시 `applyColumnLayout` + `clearFilters`(자동 재조회 없음) | V-12 / V-34 |

`clbElectrodeType` 은 AS-IS 도 배선 0건(cascade 말단) — TO-BE 도 아무것도 트리거하지 않는다(02 §3.2).

---

## 3. validations 1건

| AS-IS | cs | TO-BE |
|---|--:|---|
| `_currVersionProgressStatus != _2ND_CUTOFF` -> `MSG00423` 후 return | 1340~1345 | `CapaTeepReport.tsx#handleSearch` -> `MSG.PROG_STAT_BLOCKED`(**`MSG01410`**) alert 후 return. `{0}` = **AS-IS 인자 리터럴 원문** `'2`nd Cut-off'`(cs:1342 `new object[] { "'2`nd Cut-off'" }` — 홑따옴표·하이픈 포함, iter-2 R-04). iter-1 은 원문 미확인 상태에서 lookup `CAPA_PROG_STAT` 표시문구(`2`nd Cut off`)를 썼다 |

**AS-IS 번호 `MSG00423` 을 쓰지 않는다** — TO-BE 미등록이고 문구 일치본이 `MSG01410` 이다(hook #114).
필수 조회조건(`*` 라벨) 검사는 AS-IS 도 **사문**이다(`LayoutControlItem.Text` 에 `*` 0건) — TO-BE 도 만들지 않는다.

---

## 4. SP / 진입점

### 4-1. spCalls 1 + 백본밖 1

| AS-IS | TO-BE | 상태 |
|---|---|---|
| `SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdTitle` cs:1200~1223) | `SHEETS.SPREAD_TITLE` 쿼리 + `API_ID='P_SCP0107_TITLE'` -> `PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE` | **SP 미배포** — 메타만 등록 |
| `SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\|ELTR}` (동적 QueryId, cs:1598 — Roslyn 미추출분) | `SHEETS.ASSEMBLY`/`ELTR` 쿼리 + `API_ID='P_SCP0107_GET_ASSEMBLY'`/`_GET_ELTR` | **SP 미배포** — 메타만 등록 |

`p_from_yyyymm` = `_version` **+1개월**(`toFromYyyymm`) — 자매 SCP0106 과 다른 이 화면 고유 사양(S-9).
GET IN 13개 중 FE 는 12건을 싣는다(`p_user_id` 는 BE `@LoginUser`). `p_prog_stat`·`p_nick_name` 없음.
SAVE SP 는 존재하지 않는다 — `DIC_SAVE_CAPA_LOSS_PLAN_MODEL`/`_LINE` QueryDics 등록 2종은 **소비처 0건 데드**(SCP0106 복사 잔재)라 이식하지 않는다.

### 4-2. entryPoints 13건

| # | AS-IS | TO-BE |
|--:|---|---|
| 1 | `btnColumn_Click` | `customButtons.action` |
| 2~5 | `cboVersionSeq`/`cboVersion`/`clbDivision`/`rgrpDivisionType_SelectedIndexChanged` | Form `onChange` + `useCapaTeepReportConditionEffects` |
| 6 | `FindButton` (override 실동작) | `hotkeyConfig.search = hasButton('SEARCH') ? handleSearch : false` |
| 7 | `InsertButton` (본문 빈 `{}`) | `hotkeyConfig.insert` = **`MSG01044` alert 핸들러**(D-2 확정). `false`·키 생략 둘 다 오답 |
| 8 | `DeleteButton` (도달 불가) | `hotkeyConfig.delete` = **`MSG01045` alert 핸들러**(D-2 확정) |
| 9~13 | `clbFactory`/`clbLine`/`clbOperation`/`clbPlant`/`clbSite_SelectedIndexChanged` | Form `onChange` (클라 cascade) |

**override 미존재 = 기본 동작**: `SaveButton`·`EditButton`·`ExcelButton`·`UploadButton`·`ManualButton` 0건 ->
`save/manual/upload = false`, Excel 은 공용 `SubTitle`, **Edit 는 `customButtons` 에도 만들지 않는다**(편집모드 부재).

---

## 5. popups 1건

| AS-IS | TO-BE |
|---|---|
| `SCM002_CAPAColumnPopup("SCP0107", _division_type_name, true)` (cs:1767) | 공용 `ColumnLayoutModal`(`@shared/components`) + `saveTitleSet`. `sheetName`=ASSEMBLY/ELTR, `columnType='C'` |

**화면 사본 금지**(hook #20/#132 §2-1). 3번째 인자 `isColumn=true` 뿐이라 **Measure 타입(`'M'`) 호출은 AS-IS 에 0건**이다 — 그래서 Measure Setting 아이콘은 이번 회차 미노출(04 리포트 "확인 필요").

---

## 6. comboCalls 4건 (이식 2 / 미이식 2)

| # | AS-IS | TO-BE SQL_ID | 이식 | 사유 |
|--:|---|---|:--:|---|
| 1 | `BLUtils.GetDivisionWithoutEE(false,"")` (cs:44) | `Division_SCP` + FE `ATTRIBUTE3 !== 'EE'` | O | 5층 의미 대조 완료. `MyDivision`/`Division`/`DivisionByUser` 재사용 금지(SCP0006 실사고) |
| 4 | `Data_SCP.CommonAll(OperationElectrodeType)` (cs:903) | `OperationElectrodeType_SCP_ALL` + FE `OPERATION_ID === 'E2000'` | O | Line Type ELTR 경로 원천 |
| 2 | `Data_SCP.CommonAll(YearFromThisYear)` (cs:69) | `YearFromThisYear_SCP_ALL` | **X** | 선언 외 참조 0건 + 짝 컨트롤 `cboFromYYYY` 가 **Designer 에 없다** -> dead 확정(배선 누락 아님). AS-IS 에서 조회할 수 없는 조건을 TO-BE 에 신설하는 것은 임의 추가 |
| 3 | `Data.Common(YesOrNo)` (cs:70) | `YesOrNo` | **X** | 선언 외 참조 0건 + Y/N 콤보가 화면에 없다 -> dead 확정 |

**백본 밖 콤보 공급**(Roslyn 패턴 미포착 — `ScpCapaBL.*`):

| AS-IS | TO-BE | 이식 |
|---|---|:--:|
| `ScpCapaBL.GetVersionAll()` (cs:46) | `CapaVersion_SCP_ALL` 1건에서 4파생(Plan Month / Ver. / Plan Type / 조회 게이트값) | O |
| `ScpCapaBL.GetCapaLineMasterAll(divisionType)` (cs:799, 1152) | `CapaLineMaster_SCP_ALL` ↔ `CapaLineMasterEE_SCP_ALL` **comboId 스위치** + ASSEMBLY 경로 `SHOP_GROUP_ID='A'\|'P'` 선필터 | O |
| `ScpCapaBL.GetPlanType(...)` (cs:297) | `derivePlanType` (`BIZ_PLAN_USE_YN='Y'` -> BP / else RP) | O |
| `ScpCapaBL.GetProgressStatusAll()` (cs:49) | `CapaProgressStatus_SCP_ALL` | **X** — `dtProgressStatusAll`/`dtProgressStatus` 참조 0건. 이 화면에 Status 콤보가 없다 |

---

## 7. filterCalls 5건 (전건 이식)

| # | AS-IS | TO-BE |
|--:|---|---|
| 1 | `GetElectrodeOperationFilter(_division_type)` (cs:909) | `matchesElectrodeOperationPrefix` — ELTR `OPERATION_ID==='E2000'` / CELL `'A'` 접두 / MODULE_PACK `'P'` 접두 |
| 2 | VersionSeq cascade 필터 (cs:953) | `buildVersionSeqOptions` (Division + Plan Month -> `VER_SEQ` distinct) |
| 3 | 현재 버전 `PROG_STAT` 추출 (cs:975) | `deriveCurrProgressStatus` (0행이면 `'0'`) |
| 4 | `GetFilterOperation(...)` + **CELL `AND CODE<>'AFFFF'`** (cs:1087~1096) | `buildOperationOptions` — **ELTR+CELL 제외 / Module·Pack 포함**. 자매(ELTR 만 제외)와 다름 |
| 5 | `GetFilterElectrodeType(...)` (cs:1111) | `buildLineTypeOptions` — `DIVISION_ID`+`OPERATION_ID` 축만(shop group·`CODE<>'-'` 없음) |

**백본 밖 필터·정렬 유틸 전건 재현**(`utils/capaTeepReport.combos.ts`):
`GetAndFilterString`(빈 축은 절 미생성) · `Filter`(빈 필터 = 무필터) · `GetDistinctedCode`(`(CODE,NAME)` distinct) ·
`GetSortedCode`(`DMY_` 후치, Site/Plant/Building/Line 4축만) · `DeleteEmptyName`(Line Type 만 `isCodeIsName=true`) ·
Line `_C`/`_A` 쌍 재정렬 · `ChangeColumnNameToCodeName`(축별 CODE/NAME 매핑 — `buildComboOptions` 를 그대로
쓰면 옵션 0건, S-8) · 축별 distinct 컬럼 조합 6종(Operation 만 `SITE_ID` 없음).

**AS-IS 결함 1건 교정(기능 축소 아님)**: Line 재정렬의 `CopyToDataTable()`(cs:1044, 1076) 0행 미방어 ->
`InvalidOperationException`. TO-BE `reorderLinePairs` 는 **빈 배열을 그대로 반환**해 예외만 제거한다(A-5 / S-17).

---

## 8. buttonGuards 5건 (이식 2 / 미이식 3)

| # | AS-IS | cs | 이식 | TO-BE / 사유 |
|--:|---|--:|:--:|---|
| 1 | `FindButton` 진행상태 가드 | 1340~1345 | O | `handleSearch` -> `MSG01410` |
| 2 | `FindButton` `checkRequiredOfSearch` | 1347 | O(부분) | 실효는 **Division 권한 0건 차단 1건뿐**(`*` 라벨 0건이라 필수검사는 사문) -> `noDivisionAuth` 게이트 + `MSG00667` |
| 3 | `DeleteButton` `spdMain == null` | 1359~1360 | **X** | 베이스 `CheckValidation(Delete)` 가 `IsLock==true` 로 먼저 차단(L-12)해 **도달 불가**. 이식하면 AS-IS 에 없는 "선택 행이 있으면 삭제됨" 경로가 생긴다 |
| 4 | `DeleteButton` `RowCount == 0` | 1362~1363 | **X** | 동 |
| 5 | `DeleteButton` `ActiveRow == null` | 1365~1366 | **X** | 동 |

**베이스 게이트(백본 밖 9건)** — 화면 소스만 읽으면 통째로 빠지는 구간이며 이 화면의 Insert/Delete 최종 동작을 결정한다:

| ID | AS-IS | TO-BE |
|---|---|---|
| L-10/L-13/L-15 | `SecurityContext.CanDelete/CanInsert/CanSelect == false` -> `MSG00096` | `useTabBtnPermissions().hasButton()` (버튼 비노출) |
| `L-11` | `CheckValidation` `fps == null` -> `MSG00007` | 미이식 — TO-BE 에 `fps`(활성 spread 선택) 개념이 없다. 문구 일치본은 `MSG01043` |
| **L-12** | Delete + `IsLock==true` -> **`MSG00009`** 후 차단 | `handleDelete` = **`MSG01045`** alert (D-2) |
| **L-14** | Insert + `IsLock==true` -> **`MSG00008`** 후 차단 | `handleInsert` = **`MSG01044`** alert (D-2) |
| `L-16` | Search + `IsChange==true` -> `MSG00127` 확인 | 미이식 — 편집 경로가 없어 **조건 미발생** |
| `L-17` | Search 시 `IsEditMode/IsSort/IsSortChange=false` 강제 | 실효는 정렬 리셋뿐 — 공용 `SubTitle`/`DataGrid` 소관 |
| `L-18` | `SetFilterALLCancel` + `ReadOnlySheetList` | 미이식 — `ReadOnlySheetList` 는 **읽기전용과 무관**(필터 전체해제 스킵용)이고 Wijmo 에 대응 개념이 없다 |

---

## 9. gridSignals 12건 (이식 5 / 미이식 7)

| ID | AS-IS | cs | 이식 | TO-BE / 사유 |
|---|---|--:|:--:|---|
| `G-01` | `Sheets[i].Visible = (i == _sheet_idx)` | 1229~1232 | **O** | `sheetName` 파생 1개로 `DataGrid` 1개 스위치. 탭·CSS 숨김 금지 |
| `G-02` | `ColumnHeaderSpan(0,…)` (`MergeKeyColumns`) | 1265 | **X** | **데드** — `MergeKeyColumns` 참조 0건(SCP0106 은 호출). 이식하면 AS-IS 에 없는 키컬럼 헤더 가로병합이 생긴다 |
| `G-03` | `ColumnHeaderSpan(1,…)` | 1266 | **X** | 동 |
| `G-04` | `ColumnHeaderSpan(2,…)` | 1267 | **X** | 동. 헤더 3단 근거는 이 데드 코드가 아니라 G-05 + `RefreshSpreadDateColumn` |
| `G-05` | `SetSheetHeaderColumnSCP(_si,3,…, "BASE_QTY")` | 1279 | **메타** | `staticColumns`(admin fetch) + `dynamicColumns`(spreadTitle) 2축. 컬럼명 배열 코드 상수 0건(hook #130) |
| `G-06` | `_si.Delete()` | 1369~1374 | **X** | 도달 불가(L-12). `hotkeyConfig.delete` = alert 핸들러 |
| `G-07` | `_si.Query(ds)` | 1506 | **O(일부)** | 데이터 바인딩만 재현. `_tblOriginal` 스냅샷은 **이식 금지**(유일 소비처 `CheckChangedValues` 참조 0건 데드 + 저장 경로 부재) |
| `G-08` | `LockColumn(0,max,true)` | 1510 | **메타** | `INPUT_TP_CD='S'` 50행 전건 -> 공용 판정만으로 AS-IS 일치. **화면 고유 `canEdit` 오버라이드 0건**(V-28) |
| `G-09` | `Set_MeasureColor` (`MEASURE_NAME` 문자열 19종) | 1523~1575 | **O(코드 기준 변환)** | `MEASURE_COLOR_BY_CODE` 19종 4색 + SCSS Module. `MEASURE_NAME` 열 ~ 행 끝. NBSP 함정 원천 제거 |
| `G-10` | `ToggleMerge(sheet,true)` | 1581 | **O** | `AllowMerging.All` 상시(편집모드 부재) |
| `G-11` | `SmartColMerge()` | 1582 | **O** | 공용 `CustomMergeManager` sticky(hook #69) — 스크롤 핸들러 미작성 |
| `G-12` | `SetValue(...)` (`SetBaseToDateColumns`) | 1760 | **X** | **데드** — 참조 0건 + 내부 가드마저 주석 처리. 이식하면 조회값을 `BASE_QTY` 로 전부 덮어쓰는 데이터 파괴 버그 |

**백본 밖 7건**:

| ID | AS-IS | 이식 | TO-BE / 사유 |
|---|---|:--:|---|
| `G-13` | 행 단위 소수 자릿수(`SetNumericColumnFormat`, measure 5종 -> 0자리) | **O** | `CapaTeepReportGrid#formatItem`. `DATA_SCALE_NUMBER` 50행 전건 NULL 이라 메타로 못 푼다 |
| `G-14` | `SetColumAutosize` | **X** | AS-IS **주석 처리**. 폭은 메타·상수 고정 |
| `G-15` | 숨김 컬럼 코드 배열 13종(`SetVisibleSheetColumn`) | **메타** | `colWth===0 \|\| visible===false` 이중 판정(store). 배열 이식 금지(hook #130) |
| `G-16` | 기간 목록 `ASSIGN_PRIORITY` 제외 | **X(무효)** | TVF 가 SCP0107 에 그 컬럼을 0건 생성 -> 항상 무동작. 이식하면 죽은 코드 |
| `G-17` | `SetSearchCount(ds)` | **O** | `SubTitle dataCount={rows.length}` |
| `G-18` | freeze(`FIXED_FLAG` **마지막** 'Y' 기준) | **O** | 공용 `DataGrid` 가 `findLastIndex(_fixed)+1` 로 계산 -> `BASE_QTY` 까지 전부. **개수 기반 금지**(TO-BE 메타 2건 드리프트) |
| `G-19` | Action 컬럼(index 0, 헤더 "A") | **X(TO-BE 대체)** | CRUD 마킹이 없고 rowHeader 'No.' 가 그 자리를 대체(hook #108) |

---

## 10. 백본 밖 편입 — 기타

| 항목 | 이식 | TO-BE / 사유 |
|---|:--:|---|
| `Form_Load` 초기화 순서(cs:913~926, 생성자 배선) | **O(구조 변환)** | 파생 state + `useCapaTeepReportConditionEffects` mount effect. **진입 자동 조회 없음**(AS-IS 도 `FindData()` 호출 0건) |
| `InitEvent()` 가 `InitControls()` 뒤 | **O** | 단일 콤보 기본선택을 한 effect 에서 일괄 결정(마운트 중 cascade 연쇄 방지) |
| `rgrpDivisionType` 초기 `-1` (L-19) | **X(사용자 확정 해소)** | `DEFAULT_DIVISION_TYPE = ELTR`(**D-1**). AS-IS 헤더/시트 축 불일치를 단일 파생으로 해소 |
| `POPUP/SCP0107_CAPAReportPopup.cs`(479행) | **X** | `.csproj` 에 `<Compile Include>` 없음 = **컴파일 대상 아님** + 인스턴스화 0건 + 타 화면 SP(`SCP0083_GET_DIO_REPORT_H`) 호출. 이식하면 AS-IS 에 없던 리포트 팝업 + SCP0083 의존이 따라온다(L-22 / V-14) |
| 데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY_` / `spdMain_ClipboardPasted`) | **X** | 대응 컨트롤이 Designer 에 없다 |
| 데드 메서드 4종(`MergeKeyColumns` / `SetBaseToDateColumns` / `CheckChangedValues` / `ClearUsrCheckedList`) | **X** | 참조 0건 |
| 선언만 존재 필드(`_editableMeasures`/`_currMeasureSet`/`_selComboMode`/`_curr_*` 12종) | **X** | 참조 0건 |
| `DefColumns` 29종 중 SP 미반환 4종(`NICK_NAME`/`MSR_NVL`/`DAY_CNT`/`SPEED_PPM`) | **X** | 그리드 컬럼이 아니다. 특히 `SPEED_PPM` 은 숨김 배열에 있으나 컬럼·데이터 자체가 없다 |
| Designer `tabIndex` 숫자(5/7/8/9/30/48/50/52) | **X** | AS-IS 도 시각 순서와 어긋난다. TO-BE 는 DOM 순서(V-16). `Select()`/`Focus()` 0건이라 autofocus 없음 |
| 비율 measure `×100` | **X(서버 담당)** | GET SP 가 이미 곱해 보낸다 — FE 재계산·`%` 서식 추가 금지(V-26) |
| SP 서버 정렬(`ORDER BY` 4단) | **O(신뢰)** | FE 재정렬 0건(03 §4.3) |
| 조회 결과 0건 시 색칠 미수행(cs:1519) | **O** | `formatItem` 이 행 없으면 호출되지 않아 자연 등가(V-37) |
| `spreadTitle` 시트명 규약 | **O** | 자매 SCP0104/0105 실등록 선례를 `SCM_ADM_MNU_BTN_MPG_M` 에 미러 |
| 라디오 -> 드롭다운 전환 | **O(규약 확장)** | 카탈로그 지시 "선택·단일" + 공용 RadioGroup 부재. AS-IS 원천이 Designer 리터럴이라 hook #87 §L 미해당 |
| Insert/Delete **메시지 재현** | **O(규약 확장)** | 무동작 함수만 두면 클릭 체감이 AS-IS 와 다르다. **D-2 사용자 확정**으로 alert 채택 |
| 숨겨진 Operation/Line Type 값 유지 | **O** | AS-IS 는 `Visibility` 만 바꾸고 값을 비우지 않는다 -> GET 파라미터에 계속 실린다(**D-6 기본안**) |
| `DAY_CODE`/`SORT_ORDER_NO`(헤더 SP 반환) | **X(표시 미사용)** | `DAY_CODE` 는 TVF 가 항상 `''`, `SORT_ORDER_NO` 는 정렬 전용(문자열 정렬로 사용) |

---

## 11. 미이식 총괄 (조용히 빼지 않았음을 증명하는 목록)

1. 사장 노드 2건 — `usrLayoutControl1` / `layoutControlGroup1` (L-05/L-06)
2. Designer 초기 시트 `spdMain_Sheet1` (G-01)
3. `POPUP/SCP0107_CAPAReportPopup` (L-22)
4. Delete 가드 3건 — L-07/L-08/L-09 (도달 불가, L-12)
5. 데드 gridSignals 4건 — G-02/G-03/G-04/G-12 + 도달불가 1건 G-06
6. 무효 1건 — G-16(`ASSIGN_PRIORITY` 대상 컬럼 0건) / 주석처리 1건 — G-14
7. TO-BE 대체 1건 — G-19(Action 컬럼 -> rowHeader 'No.')
8. 미사용 콤보 3종 — `CapaProgressStatus_SCP_ALL` / `YearFromThisYear_SCP_ALL` / `YesOrNo`
9. 데드 핸들러 3종 · 데드 메서드 4종 · 선언만 필드 다수
10. `ReadOnlySheetList` (읽기전용과 무관 — L-18)
11. AS-IS `tabIndex` 숫자 (V-16)
12. `_tblOriginal` 스냅샷 (G-07)
13. SAVE QueryDics 2종 (`DIC_SAVE_CAPA_LOSS_PLAN_*` — 소비처 0건)

## 12. AS-IS 대비 의도적 차이 (전건 근거 있음)

| # | 차이 | 근거 |
|--:|---|---|
| 1 | `rgrpDivisionType` 기본값 `-1` -> **`ELTR` 명시** | 사용자 확정 **D-1**. AS-IS 헤더/시트 축 불일치(L-19) 및 `shop_group='P'` 잠재 결함(02 §4.3) 해소 |
| 2 | Insert/Delete 가 alert 를 띄운다 | 사용자 확정 **D-2**. AS-IS 베이스 게이트가 실제로 `MSG00008`/`MSG00009` 를 띄우므로 오히려 파리티다 |
| 3 | ~~Division 권한 0건 안내가 **Load 1회**~~ -> **철회(iter-2 R-05)**. Load 1회 + **Search 클릭마다** 안내 둘 다 띄운다 = AS-IS 파리티 | AS-IS `checkRequiredOfSearch`(cs:1347 -> `DataUtil:390~416`)가 클릭마다 안내한다. 조용한 early-return 은 "조회가 먹지 않는 화면" 이 되어 V-06 미충족이었다. **의도적 차이가 아니라 결함이었고 해소함** |
| 4 | Line 후보 0건에서 예외 대신 빈 목록 | AS-IS 결함 교정(**A-5 / S-17**) — 예외만 제거, 기능 축소 아님 |
| 5 | 헤더 SP `p_sheet_name` 을 `divisionType` **단일 파생**으로 통일 | AS-IS ternary(`SelectedIndex==0?ELTR:ASSEMBLY`)와 `_sheet_name` 이 미선택에서 갈리던 불일치 해소(03 §6-3) |
| 6 | 3단 헤더 총높이 **48px**(AS-IS 20x3=60) | TO-BE 표준 hook #93 |
| 7 | `@mnuId` 가 콤보 요청에 실린다 — **조건부 후보 축소 가능, 미입증**(iter-2 R-07 문구 정정) | 공용 훅 `useCustomQueryClient.ts:60` 이 자동 주입하고 FE 화면 계층에서 회피 불가(Hard Boundary 밖) -> **코드 변경 0**. iter-1 의 "후보 축소 없음" 단정은 반증됐다: `Division_SCP` WHERE 가 `USER_GR_ID IN (SELECT … WHERE MNU_ID=@mnuId)` 게이트를 갖고, ora.py 실측 `UNIT_TP_CD='D'` 권한 보유 21그룹 ↔ SCP0107 메뉴권한 7그룹이라 **미등록 그룹 아래 division 권한만 가진 사용자는 후보 0건**이 될 수 있다. 공용 훅 정책 과제로 상신(**D-7** 기본안 "미전달" 은 이 구조에서 달성 불가) |
| 8 | AS-IS 권한그룹 `CAPA Planner` 미이관 | 사용자 확정 **D-5**(제외 + 보고). TO-BE `SCM_ADM_USER_GR_M` 19그룹에 부재(실측) |
| 9 | Measure Setting 아이콘 **미노출 확정** | **사용자 확정 2026-09-25(iter-2 R-06)** — "확인 필요" 아님. AS-IS 툴바에 Measure 버튼 0건(`SCM002_CAPAColumnPopup(…, isColumn:true)` = TitleSet `'C'` 뿐, `'M'` 호출 0건 cs:1765~1778) + 공용 `MeasureSelectModal` 이 `features/demand` 전용이라 supply import 는 Hard Boundary 위반. 설계 L-20 / 01 V-11 / 03 V-35 의 "Measure 메타 56행 보유라 노출" 은 TO-BE 표준 확장 제안이었고 이 화면에서는 미채택. `packages/shared` 승격은 **별도 과제 상신**. 이후 회차에서 재차 갭으로 올리지 않는다 |
| 10 | Div. 라벨 = **`LBL00001`("Div.")** — AS-IS Designer 문자열은 `Division` | iter-2 R-03. TO-BE 조회조건 카탈로그 확정값 우선(02 §4.5.1 / §5.1 #3 / hook #112 §4-1). `LBL00641`("Division")도 실재하나 rename 규칙상 미채택 |
| 11 | Operation group 라벨 **노출**(`LBL00027`) — AS-IS `lciDivisionType.TextVisible=false` | iter-2 R-02. 설계 01 §1.1(AS-IS 미표시) ↔ 02 §5.1 #1(카탈로그 명칭 확정) 충돌 시 카탈로그 정본(hook #112 §4-1). 자매 SCP0108 도 라벨이 비어 있으나 그 화면 회차에서 고치지 않고 **보고만** 한다(Hard Boundary) |
| 12 | `handleSearch` 가드 **평가 순서가 AS-IS 와 반대** — AS-IS 는 진행상태(`MSG00423`) -> 권한(`MSG00097`), TO-BE 는 권한(`MSG00667`) -> 진행상태(`MSG01410`) | iter-2 감사 **G-06**(저위험, 현 순서 유지 결정). 권한 0건 사용자는 Version 후보도 0건이라 `deriveCurrProgressStatus` 가 `'0'` 을 돌려주므로(`utils/capaTeepReport.combos.ts:151~157`) **두 가드가 동시 성립**한다 — 그 경우 AS-IS 는 `MSG00423`, TO-BE 는 `MSG00667` 이 뜬다. 설계 `01 §4 V-06`("Search 를 눌러도 동일 메시지 `MSG00667`")이 권한 안내를 요구하므로 설계 준거로는 현 순서가 정답이고, 사용자에게도 "권한이 없다"가 "컷오프 전이다"보다 정확한 안내다. 근거: `CapaTeepReport.tsx:194~213` 주석(이전 "순서 그대로" 문구는 사실과 달라 정정) |

---

## 13. design 번호 1:1 대사표 (asis_mapping_gate.py --check 기계 판정 축)

> **gap-resolve iter-1 신설(2026-09-25).** §1~§12 는 사람이 읽는 서술형 매핑이고, 이 절은
> `_artifacts/_diagnostics/asis_mapping_gate.py` 가 파싱하는 **기계 판정 양식**(`D{문서}-{섹션}-{행}` 5열)이다.
> iter-1/iter-2 는 이 절이 없어 게이트가 대사 행 **0건**으로 돌았고(두 회차 모두 승인 차단으로 실행조차 못 해
> 드러나지 않았다), 축별 카운트는 전부 수동 대조 결과였다. 이 절이 그 공백을 닫는다.
> ID 원천은 `design/00_checklist.md` 의 §1 controls 37 / §2 events 10 / §3 gridSignals 12 /
> §4b comboCalls 4 / §4c filterCalls 5 / §4d buttonGuards 5 / §4e popups 1 = **74행**
> (`--init` 드라이런 실측 추출 건수와 동일) + 모달 2 + UI 공통 7.
> 상태 허용값: 구현(위치 필수) / 제외·해당없음(사유 필수).
> 각 행의 상세 근거는 위 §1~§11 의 같은 항목이며 여기서는 위치·사유만 적는다.

### 13-1. §1 controls 37

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=`LBL_DIVISION`(LBL00001) |  | 구현 |
| D00-1-002 | §1 Division1 / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00053(Plan Month) |  | 구현 |
| D00-1-003 | §1 PlanType / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label 공백 + `InputField` readOnly |  | 구현 |
| D00-1-004 | §1 VersionSeq / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=`LBL_VERSION`(LBL00606) |  | 구현 |
| D00-1-005 | §1 btnColumn / UsrButton | CapaTeepReport.tsx `customButtons` IcGridColumnSetup -> components/modals/CapaTeepReportColumnModal.tsx |  | 구현 |
| D00-1-006 | §1 cboVersion / UsrCombo | components/CapaTeepReportForm.tsx Plan Month CustomDropdown + hooks/useCapaTeepReportCombos.ts `buildVersionOptions` |  | 구현 |
| D00-1-007 | §1 cboVersionSeq / UsrCombo | components/CapaTeepReportForm.tsx Ver. CustomDropdown + utils/capaTeepReport.combos.ts `buildVersionSeqOptions` |  | 구현 |
| D00-1-008 | §1 clbDivision / UsrCheckedList | components/CapaTeepReportForm.tsx Div. CustomDropdown multiple + utils/capaTeepReport.combos.ts `buildDivisionOptions` |  | 구현 |
| D00-1-009 | §1 clbElectrodeType / UsrCheckedList | components/CapaTeepReportForm.tsx extraConditions Line Type + `showElectrodeType` 조건부 렌더 |  | 구현 |
| D00-1-010 | §1 clbFactory / UsrCheckedList | components/CapaTeepReportForm.tsx Building CustomDropdown + utils/capaTeepReport.combos.ts `buildBuildingOptions` |  | 구현 |
| D00-1-011 | §1 clbLine / UsrCheckedList | components/CapaTeepReportForm.tsx Line CustomDropdown + utils/capaTeepReport.combos.ts `buildLineOptions` · `reorderLinePairs` |  | 구현 |
| D00-1-012 | §1 clbOperation / UsrCheckedList | components/CapaTeepReportForm.tsx extraConditions Operation + `showOperation` 조건부 렌더 |  | 구현 |
| D00-1-013 | §1 clbPlant / UsrCheckedList | components/CapaTeepReportForm.tsx Plant CustomDropdown + utils/capaTeepReport.combos.ts `buildPlantOptions` |  | 구현 |
| D00-1-014 | §1 clbSite / UsrCheckedList | components/CapaTeepReportForm.tsx Site CustomDropdown + utils/capaTeepReport.combos.ts `buildSiteOptions` |  | 구현 |
| D00-1-015 | §1 components / Container |  | Designer 비가시 컴포넌트 컨테이너 — DOM 대응물이 없다(§1-3) | 제외 |
| D00-1-016 | §1 emptySpaceItem1 / EmptySpaceItem | components/CapaTeepReportForm.tsx 12-column Grid 여백(전용 컴포넌트 미생성) |  | 구현 |
| D00-1-017 | §1 emptySpaceItem12 / EmptySpaceItem | components/CapaTeepReportForm.tsx 12-column Grid 여백 |  | 구현 |
| D00-1-018 | §1 emptySpaceItem2 / EmptySpaceItem | components/CapaTeepReportForm.tsx 12-column Grid 여백 |  | 구현 |
| D00-1-019 | §1 emptySpaceItem5 / EmptySpaceItem | components/CapaTeepReportForm.tsx 12-column Grid 여백 |  | 구현 |
| D00-1-020 | §1 imageList1 / ImageList |  | 비가시 리소스(edit.png). TO-BE 아이콘 원천은 foundation assets 라 이식 대상이 아니다(§1-3) | 제외 |
| D00-1-021 | §1 layoutControlGroup1 / LayoutControlGroup |  | 사장 노드 — Items.AddRange 0건. 이식하면 빈 컨테이너가 생겨 hook #132 §1-2 위반(L-06 / §1-3) | 제외 |
| D00-1-022 | §1 layoutControlGroup2 / LayoutControlGroup | components/CapaTeepReportForm.tsx SearchArea 내부 12-column Grid 1개 |  | 구현 |
| D00-1-023 | §1 layoutControlItem1 / LayoutControlItem |  | btnColumn 이 SubTitle 로 이동(L-20)해 조회영역 슬롯 자체가 사라진다(§1-3) | 제외 |
| D00-1-024 | §1 layoutControlItem2 / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00030(Plant) |  | 구현 |
| D00-1-025 | §1 layoutControlItem4 / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00008(Building) |  | 구현 |
| D00-1-026 | §1 layoutControlItem6 / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00010(Line) |  | 구현 |
| D00-1-027 | §1 layoutControlItem8 / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00015(Site) |  | 구현 |
| D00-1-028 | §1 lciDivisionType / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00027(Operation group, iter-2 R-02) |  | 구현 |
| D00-1-029 | §1 lciElectrodeType / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00056 + `showElectrodeType`(L-02) |  | 구현 |
| D00-1-030 | §1 lciOperation / LayoutControlItem | components/CapaTeepReportForm.tsx `FormItem` label=LBL00009 + `showOperation`(L-01) |  | 구현 |
| D00-1-031 | §1 rgrpDivisionType / RadioGroup | components/CapaTeepReportForm.tsx Operation group CustomDropdown + capa-teep-report.constants.ts `DEFAULT_DIVISION_TYPE` |  | 구현 |
| D00-1-032 | §1 spdMain / FpSpread | components/CapaTeepReportGrid.tsx 공용 DataGrid 1개 + sheetName 스위치 |  | 구현 |
| D00-1-033 | §1 spdMain_Sheet1 / SheetView |  | Designer 초기 시트 잔재. 런타임은 AddSheet 2시트(ASSEMBLY/ELTR)로 대체된다(§1-3 / 03 §7.1) | 제외 |
| D00-1-034 | §1 txtPlanType / TextBox | components/CapaTeepReportForm.tsx `InputField` readOnly + hooks/useCapaTeepReportCombos.ts `derivePlanType` |  | 구현 |
| D00-1-035 | §1 usrConditionPanel1 / UsrConditionPanel | components/CapaTeepReportForm.tsx SearchArea (토글은 공용 MainTitle 소관, hook #63) |  | 구현 |
| D00-1-036 | §1 usrLayoutControl1 / UsrLayoutControl |  | 사장 노드 — Form.Controls 미추가 + cs 참조 0건(L-05 / §1-3) | 제외 |
| D00-1-037 | §1 usrLayoutControl2 / UsrLayoutControl | CapaTeepReport.tsx `noDivisionAuth` + components/CapaTeepReportForm.tsx SearchArea disabled 1개(L-04) |  | 구현 |

### 13-2. §2 events 10

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-2-001 | §2 btnColumn / Click | CapaTeepReport.tsx `customButtons` -> components/modals/CapaTeepReportColumnModal.tsx `applyColumnLayout` + `clearFilters` |  | 구현 |
| D00-2-002 | §2 cboVersion / SelectedIndexChanged | components/CapaTeepReportForm.tsx Plan Month onChange + hooks/useCapaTeepReportConditionEffects.ts |  | 구현 |
| D00-2-003 | §2 cboVersionSeq / SelectedIndexChanged | components/CapaTeepReportForm.tsx Ver. onChange + hooks/useCapaTeepReportConditionEffects.ts |  | 구현 |
| D00-2-004 | §2 clbDivision / SelectedIndexChanged | components/CapaTeepReportForm.tsx Div. onChange -> `setSearchParamsWithLineTypeRefresh` |  | 구현 |
| D00-2-005 | §2 clbFactory / SelectedIndexChanged | components/CapaTeepReportForm.tsx Building onChange (Line/Operation 만 리셋 — 비대칭 1) |  | 구현 |
| D00-2-006 | §2 clbLine / SelectedIndexChanged | components/CapaTeepReportForm.tsx Line onChange (Operation 리셋) |  | 구현 |
| D00-2-007 | §2 clbOperation / SelectedIndexChanged | components/CapaTeepReportForm.tsx Operation onChange -> `setSearchParamsWithLineTypeRefresh` |  | 구현 |
| D00-2-008 | §2 clbPlant / SelectedIndexChanged | components/CapaTeepReportForm.tsx Plant onChange (Building/Line/Operation 리셋) |  | 구현 |
| D00-2-009 | §2 clbSite / SelectedIndexChanged | components/CapaTeepReportForm.tsx Site onChange (Plant/Building/Line/Operation 리셋) |  | 구현 |
| D00-2-010 | §2 rgrpDivisionType / SelectedIndexChanged | components/CapaTeepReportForm.tsx Operation group onChange + hooks/useCapaTeepReportCombos.ts comboId 스위치(마스터 재조회) |  | 구현 |

### 13-3. §3 gridSignals 12

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-3-001 | §3 Visible= / 시트별 표시 스위치 | CapaTeepReport.tsx sheetName 파생 -> components/CapaTeepReportGrid.tsx DataGrid 1개 스위치 |  | 구현 |
| D00-3-002 | §3 ColumnHeaderSpan / 1단 |  | 데드 — MergeKeyColumns 참조 0건(§9 G-02). 이식하면 AS-IS 에 없는 키컬럼 헤더 가로병합이 생긴다 | 제외 |
| D00-3-003 | §3 ColumnHeaderSpan / 2단 |  | 동 데드(§9 G-03) | 제외 |
| D00-3-004 | §3 ColumnHeaderSpan / 3단 |  | 동 데드(§9 G-04). 3단 헤더 근거는 SetSheetHeaderColumnSCP + RefreshSpreadDateColumn 쪽이다 | 제외 |
| D00-3-005 | §3 SetSheetHeaderColumnSCP / 컬럼 골격 생성 | useCapaTeepReportStore.ts `fetchStaticColumns` + utils/capaTeepReport.dateColumns.ts `buildPeriodColumns`(메타 2축) |  | 구현 |
| D00-3-006 | §3 Delete / 행 제거 |  | 도달 불가 — 베이스 CheckValidation(Delete) 가 IsLock==true 로 먼저 차단(L-12). `handleDelete` alert 로 대체(§9 G-06) | 제외 |
| D00-3-007 | §3 Query / 데이터 바인딩 | useCapaTeepReportStore.ts filters -> `useTabProcQuery` 바인딩(_tblOriginal 스냅샷은 데드라 미이식) |  | 구현 |
| D00-3-008 | §3 LockColumn / 전열 잠금 | 메타 INPUT_TP_CD='S' 50/50 위임 + utils/capaTeepReport.dateColumns.ts isReadOnly true(화면 고유 canEdit 0건) |  | 구현 |
| D00-3-009 | §3 SetBGColor / Measure 행 배경색 | capa-teep-report.constants.ts `MEASURE_COLOR_BY_CODE` + components/CapaTeepReportGrid.tsx `formatItem` + components/CapaTeepReportGrid.module.scss |  | 구현 |
| D00-3-010 | §3 ToggleMerge / 셀 병합 ON | components/CapaTeepReportGrid.tsx allowMerging(편집모드 부재 -> 상시 ON) |  | 구현 |
| D00-3-011 | §3 SmartColMerge / 컬럼 병합 | components/CapaTeepReportGrid.tsx 공용 DataGrid 병합(sticky) + utils/capaTeepReport.dateColumns.ts 기간컬럼 allowMerging false |  | 구현 |
| D00-3-012 | §3 SetValue / BASE_QTY 일괄 기입 |  | 데드 — SetBaseToDateColumns 참조 0건이고 내부 가드마저 주석 처리. 이식하면 조회값을 BASE_QTY 로 덮어쓰는 데이터 파괴(§9 G-12) | 제외 |

### 13-4. §4b comboCalls 4 / §4c filterCalls 5 / §4d buttonGuards 5 / §4e popups 1

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-4b-001 | §4b BLUtils.GetDivisionWithoutEE / dtDivision | hooks/useCapaTeepReportCombos.ts Division_SCP + utils/capaTeepReport.combos.ts `buildDivisionOptions`(ATTRIBUTE3 EE 제외) |  | 구현 |
| D00-4b-002 | §4b Data_SCP.CommonAll / YearFromThisYear / dtFromYYYY |  | 데드 — 선언 외 참조 0건 + 짝 컨트롤 cboFromYYYY 가 Designer 에 없다. AS-IS 에서 조회할 수 없는 조건을 TO-BE 에 신설하는 것은 임의 추가(§6 #2) | 제외 |
| D00-4b-003 | §4b Data.Common / YesOrNo / dtYesOrNo |  | 데드 — 선언 외 참조 0건 + Y/N 콤보가 화면에 없다(§6 #3) | 제외 |
| D00-4b-004 | §4b Data_SCP.CommonAll / OperationElectrodeType | hooks/useCapaTeepReportCombos.ts OperationElectrodeType_SCP_ALL + utils/capaTeepReport.combos.ts `buildLineTypeOptions`(OPERATION_ID E2000) |  | 구현 |
| D00-4c-001 | §4c DBUtils.Filter / tbl -> dtElectrodeAll | utils/capaTeepReport.combos.ts `matchesElectrodeOperationPrefix` |  | 구현 |
| D00-4c-002 | §4c DBUtils.Filter / dtVersionAll (VersionSeq cascade) | utils/capaTeepReport.combos.ts `buildVersionSeqOptions` |  | 구현 |
| D00-4c-003 | §4c DBUtils.Filter / dtVersionAll (PROG_STAT 추출) | utils/capaTeepReport.combos.ts `deriveCurrProgressStatus` |  | 구현 |
| D00-4c-004 | §4c DBUtils.Filter / dtOperationAll | utils/capaTeepReport.combos.ts `buildOperationOptions`(ELTR+CELL AFFFF 제외) |  | 구현 |
| D00-4c-005 | §4c DBUtils.Filter / dtElectrodeAll | utils/capaTeepReport.combos.ts `buildLineTypeOptions`(DIVISION_ID+OPERATION_ID 축만) |  | 구현 |
| D00-4d-001 | §4d FindButton / Search (진행상태 가드) | CapaTeepReport.tsx `handleSearch` -> MSG01410 + capa-teep-report.constants.ts `REQUIRED_PROG_STAT_LABEL` |  | 구현 |
| D00-4d-002 | §4d FindButton / Search (checkRequiredOfSearch) | CapaTeepReport.tsx `handleSearch` -> `noDivisionAuth` -> MSG00667 (평가 순서 차이는 §12 #12) |  | 구현 |
| D00-4d-003 | §4d DeleteButton / Delete (spdMain null 가드) |  | 도달 불가 — 베이스 CheckValidation(Delete) 가 IsLock==true 로 먼저 차단. 이식하면 AS-IS 에 없는 "선택 행이 있으면 삭제" 경로가 생긴다(§8 #3) | 제외 |
| D00-4d-004 | §4d DeleteButton / Delete (RowCount 0 가드) |  | 동 도달 불가(§8 #4) | 제외 |
| D00-4d-005 | §4d DeleteButton / Delete (ActiveRow null 가드) |  | 동 도달 불가(§8 #5) | 제외 |
| D00-4e-001 | §4e SCM002_CAPAColumnPopup / ShowDialog | components/modals/CapaTeepReportColumnModal.tsx (공용 ColumnLayoutModal + saveTitleSet, columnType C) |  | 구현 |

### 13-5. CRUD·모달 매트릭스

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:CapaTeepReportColumnModal | FE 실존 모달 — AS-IS SCM002_CAPAColumnPopup(cs:1767) 대응 | components/modals/CapaTeepReportColumnModal.tsx |  | 구현 |
| MODAL:ShowDialog | AS-IS 팝업(분석 md) — TO-BE 모달 구현 위치 | components/modals/CapaTeepReportColumnModal.tsx (동일 팝업. POPUP/SCP0107_CAPAReportPopup 은 csproj 미포함 = 컴파일 대상 아님 -> 미이식, L-22) |  | 구현 |

### 13-6. UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록(keepRowVisibleUnderFilter) |  | 행 추가 경로가 없다 — AS-IS InsertButton 본문이 빈 중괄호이고 베이스가 IsLock 으로 차단한다. TO-BE hotkeyConfig.insert 는 MSG01044 alert 이며 addRow 를 호출하지 않는다(§4-2 #7 / 03 V-30) | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = MSG00703 confirm |  | 편집·저장 경로가 0건이다(INPUT_TP_CD='S' 50/50 · SAVE SP 0건 · EditTracker/useProcMutation 미사용) -> dirty 상태가 생기지 않는다. 그리드는 excludeFromDirtyCheck 로 명시 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외 적용 시 기존 조회 데이터 Reset 후 재조회 유도(hook #132 §2-2) | components/modals/CapaTeepReportColumnModal.tsx `applyColumnLayout` + `clearFilters`(그리드 비움·자동 재조회 없음) + CapaTeepReport.tsx `fetchStaticColumns`/`fetchStaticMeasures` Search 시 refetch |  | 구현 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 |  | CRUD 완료 이벤트가 없다(조회 전용 — Save/Insert/Delete 실동작 0건). 화면이 띄우는 alert 는 AS-IS 베이스 게이트 메시지(MSG01044/MSG01045/MSG01410/MSG00667) 재현이며 CRUD 완료 알림이 아니다 | 해당없음 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼이 Code 아닌 Name 으로 출력 |  | 그리드 셀 콤보 0건(CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox' 0/50 · CELL_COMBO_DATA_TYPE NOT NULL 0/50 — ora.py 2026-09-25 재실측) -> dataMap 승계 대상 컬럼이 없다. 엑셀은 공용 SubTitle excelFileName 경로 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 |  | 자유입력(Key-in) 조회조건이 0건이다 — 9필드 전부 콤보·라디오·읽기전용 파생표시이고 Plan Type 은 readOnly(01 §3 / 02 §4.4). 다중선택 축은 CustomDropdown multiple + CSV 직렬화로 이미 전건 조회를 만족한다 | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용(rebindFilterColumns) | components/CapaTeepReportGrid.tsx 공용 DataGrid 위임(화면 고유 필터 초기화 코드 0건) + CapaTeepReport.tsx `handleSearch` 는 `setFilters` 참조 교체만 한다(refetch 직접 호출 0건) |  | 구현 |
