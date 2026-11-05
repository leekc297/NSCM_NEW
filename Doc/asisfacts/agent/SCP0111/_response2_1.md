=== FILE: business_analysis.md ===
# SCP0111 Integration PSI — 업무분석서

> 근거는 AsisFacts 정적 추출 Fact Pack(`endpoints.csv`, `flow.csv`, `events.csv`, `controls.csv`, `props.csv`, `grid_*.csv`, `meta_reads.csv`)과 1차 분석서(analysis / web_components / tobe_design)입니다. 이 묶음에 없는 내용은 **확인 필요**로 적었습니다.
> 주석 처리된 호출(commented_calls)은 0건입니다. 그래서 현행 기능에서 제외한 항목이 없습니다.

---

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 명칭 | SCP0111 / `Integration PSI` | Designer.cs:905 `this.Text` |
| 도메인 | SCP (`GSCM.SCP.Forms.UIL\Analysis`) | 파일 경로 |
| 클래스 | `SCP0111_IntegrationPSI` | controls.csv |
| 업무 목적 | 통합 PSI(`SCP_ANL_PSI_INTEGRATION`)를 조회하고, 편집 모드에서 수정한 뒤 저장합니다. 업무 정의(PSI 각 항목의 의미, 사용 부서)는 Fact Pack에 없어 **확인 필요**입니다. | 엔드포인트·테이블 사실 |
| 범위 — 조회 | `SCP.SCP0111_GET_INTEGRATION_PSI` (SP `SCP0111_GET_INTEGRATION_PSI`) | flow.csv FindButton |
| 범위 — 저장 | `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` (SP `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`), `SCP.SCP0111_SAVE_INTEGRATION_PSI` (SP `SCP0111_SAVE_INTEGRATION_PSI`) | flow.csv SaveButton |
| 범위 — 기준정보 | `SCP.SCP0111_GET_ESS_PACK_LINE` (SP `SCP0111_GET_ESS_PACK_LINE`), `DM.DM0003_GET_BUCKET_TYPE_CODE` (SP `DM0003_GET_BUCKET_TYPE_CODE`), `biz:CommonData.CommonDataList` [code=CalendarMonth] / [code=LookupCommon] | flow.csv Form_Load·EditButton·SaveData |
| 범위 밖 | 삭제(Delete): 관련 버튼 오버라이드나 엔드포인트 사실이 없습니다. | flow.csv에 Find/Edit/Save만 있음 |

---

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 (핸들러 > 메서드:줄) | 엔드포인트 | 결과 |
|---|---|---|---|---|
| S1 | 화면을 엽니다. | `Form_Load` > `GetEssPackLineAll`:490 | `SCP.SCP0111_GET_ESS_PACK_LINE` | Line 목록을 가져옵니다. 이 결과가 `spdMain_CellClick`에서 쓰는 `dtLine`인지는 **확인 필요**입니다. |
| S1 | (계속) | `Form_Load` > `InitControls` > `GetBucketType`:1095 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | Bucket Type 코드를 가져옵니다. 어디에 쓰는지는 **확인 필요**입니다. |
| S1 | (계속) | `Form_Load` > `InitControls` > `SetChangedPeriod`:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period From/To 콤보(cmbFromMonth/cmbToMonth)에 값을 채웁니다(DataBind:290/291). |
| S1 | (계속) | `Form_Load` > `CreateSpread` > `InitSpread` > `SetCalendar`:345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | 시트 `Integration PSI`를 만들고 월 컬럼을 동적으로 추가합니다. |
| S2 | Division을 바꿉니다. | `CboDivision_SelectedIndexChanged` > `SetChangedPeriod`:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period From/To를 다시 채웁니다. |
| S3 | Plan-date를 바꿉니다. | `CboPlanDate_SelectedIndexChanged` > `SetChangedPeriod`:287/288, `InitSpread` > `SetCalendar`:345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period를 다시 채우고, 그리드 월 컬럼을 다시 만듭니다. |
| S4 | Plan-type을 바꿉니다. 이 콤보는 Designer에서 Visible=false입니다. | `CboPlanType_SelectedIndexChanged` > `SetChangedPeriod`:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period를 다시 채웁니다. |
| S5 | 기본 데이터 모델이 바뀝니다. | `_defaultDataModel_Changed`:1980 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | CalendarMonth를 다시 가져옵니다. 이벤트가 발생하는 시점은 **확인 필요**입니다. |
| S6 | Nick Name 버튼을 누릅니다. | `BtnNickName_Click`:1887 | (없음) | `txtNickName.Text = sNickName`. 값 원천(팝업 등)은 **확인 필요**입니다. |
| S7 | Model 버튼을 누릅니다. | `BtnItemId_Click`:1926 | (없음) | `txtItemId.Text = sItemId`. 값 원천은 **확인 필요**입니다. |
| S8 | 조회(Find)를 누릅니다. | `FindButton` > `FindData_Main`:874 (> `InitSpread` > `SetCalendar`:345) | `SCP.SCP0111_GET_INTEGRATION_PSI`, `biz:CommonData.CommonDataList` [code=CalendarMonth] | 시트 `Integration PSI`에 결과를 표시합니다. |
| S9 | 편집(Edit)을 누릅니다. | `EditButton`:554 / 622 | `biz:CommonData.CommonDataList` [code=CalendarMonth], [code=LookupCommon] | 편집 모드에서 SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE가 보입니다(SetVisibleSheetColumns:1069~1073). |
| S10 | 셀을 클릭합니다. | `spdMain_CellClick`:1781~1786 | (없음) | `dtLine`/`drLine`의 CODE·NAME을 참조합니다. 셀에 무엇을 반영하는지는 **확인 필요**입니다. |
| S11 | 셀을 더블클릭하거나 스크롤합니다. | `SpdMain_CellDoubleClick` / `SpdMain_TopChange` | (없음) | 내부 동작은 **확인 필요**입니다. |
| S12 | 저장(Save)을 누릅니다. | `SaveButton` > `SaveData` (1154, 1205, 1242, 1511 → 1379 / 1637) > `FindData_Main`:874 | `biz:CommonData.CommonDataList` [code=CalendarMonth]·[code=LookupCommon] → `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` 또는 `SCP.SCP0111_SAVE_INTEGRATION_PSI` → `SCP.SCP0111_GET_INTEGRATION_PSI` | 저장한 뒤 다시 조회합니다. ADMIN과 일반 중 어느 쪽을 타는지(분기 조건)는 **확인 필요**입니다. |

---

## 3. 업무 흐름도 (텍스트)

```
[화면 진입] Form_Load
  ├─ GetEssPackLineAll ─────────────▶ SCP.SCP0111_GET_ESS_PACK_LINE   (SP SCP0111_GET_ESS_PACK_LINE)
  ├─ InitControls
  │    ├─ GetBucketType ────────────▶ DM.DM0003_GET_BUCKET_TYPE_CODE  (SP DM0003_GET_BUCKET_TYPE_CODE)
  │    └─ SetChangedPeriod ─────────▶ biz:CommonData.CommonDataList [code=CalendarMonth] ×2 → cmbFromMonth / cmbToMonth
  └─ CreateSpread > InitSpread
       ├─ AddSheet/InitSheet("Integration PSI") → SetSheetHeaderColumn (META)
       ├─ SetSpreadColumn (Tag D_/W_ 숨김, M_ 표시)
       └─ SetCalendar ──────────────▶ biz:CommonData.CommonDataList [code=CalendarMonth] → 월 컬럼 AddNumColumn

[조건 변경] CboDivision_ / CboPlanDate_ / CboPlanType_SelectedIndexChanged, _defaultDataModel_Changed
  └─ SetChangedPeriod (+ CboPlanDate 는 InitSpread > SetCalendar) ─▶ biz:CommonData.CommonDataList [code=CalendarMonth]

[조회] FindButton > FindData_Main ─▶ SCP.SCP0111_GET_INTEGRATION_PSI → InitSpread > SetCalendar → 그리드 표시

[편집] EditButton ─▶ biz:CommonData.CommonDataList [code=CalendarMonth] / [code=LookupCommon]
  └─ SetVisibleSheetColumns (IsEditMode = true → SEQ_FLAG·MEASURE·PLANT_ID·TO_SITE 표시)

[저장] SaveButton > SaveData
  ├─ biz:CommonData.CommonDataList [code=CalendarMonth] (1154, 1242, 1511) / [code=LookupCommon] (1205)
  ├─ (분기 조건 확인 필요) ─▶ SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN (1379)
  ├─ (분기 조건 확인 필요) ─▶ SCP.SCP0111_SAVE_INTEGRATION_PSI (1637)
  └─ FindData_Main ─▶ SCP.SCP0111_GET_INTEGRATION_PSI (재조회)
```

---

## 4. 업무 규칙 (사실 근거만)

| # | 규칙 | 근거 | 비고 |
|---|---|---|---|
| R1 | Division과 Plan-date는 필수로 표시됩니다(라벨 끝 `*`). | props.csv `Division*`(lblCombo1:602), `Plan-date*`(PlanDate:632) | 필수값을 검사하는 코드와 메시지 원문은 **확인 필요** |
| R2 | Plan-type 콤보는 처음에 숨겨져 있습니다. | props.csv cboPlanType Visible=false (Designer:450) | 코드가 다시 표시하는지는 **확인 필요** |
| R3 | Division / Plan-date / Plan-type이 바뀌면 Period From/To를 CalendarMonth로 다시 채웁니다. | flow.csv SetChangedPeriod:287/288, DataBind:290/291 | |
| R4 | Period를 계산할 때 `dtPeriod.Rows[0]["CODE"]`(258)와 `dtScpPlanPeriod.Rows[0]["HORIZON_END_DATE"]`(273)를 읽습니다. | meta_reads.csv | `dtPeriod`는 필드 초기화(66)에서 `biz:CommonData.CommonDataList` [code=LookupCommon]으로 만들어지는 것으로 추출되었지만, 진입점과 연결되지 않았습니다(unreached). `dtScpPlanPeriod`의 원천 엔드포인트는 Fact Pack에 없습니다. 둘 다 **확인 필요** |
| R5 | 버킷/월 규칙: 그리드 월 컬럼은 CalendarMonth 결과 행마다 하나씩 추가합니다(헤더 `YYYYMM_NAME`, 필드 `YYYYMM`, 숫자, 폭 75). | grid_code.csv SetCalendar:354 | |
| R6 | 버킷 표시 규칙: 컬럼 Tag가 `D_` 또는 `W_`로 시작하면 숨기고, `M_`로 시작하면 표시합니다. | grid_code.csv SetSpreadColumn:392/396 | Tag를 붙이는 쪽(GET SP 동적 SQL인지)은 **확인 필요** |
| R7 | `DM.DM0003_GET_BUCKET_TYPE_CODE` 결과를 어디에 쓰는지(R6과의 관계 포함) | flow.csv GetBucketType:1095 | **확인 필요** |
| R8 | 편집 모드가 아니면 SEQ_FLAG·MEASURE를 숨기고(폭 0, false), PLANT_ID·TO_SITE는 폭 0으로 둡니다(visible=true). 편집 모드면 SEQ_FLAG 60·MEASURE 80·PLANT_ID 65·TO_SITE 75로 표시합니다. | grid_code.csv SetVisibleSheetColumns:1069~1082 | |
| R9 | 저장 SP는 `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`(1379)과 `SCP0111_SAVE_INTEGRATION_PSI`(1637) 두 가지입니다. | flow.csv | 분기 조건은 **확인 필요**. SaveData:1159에서 `NowGroupID`를 읽는 사실만 있습니다. |
| R10 | 저장 전에 SaveData가 CalendarMonth(1154/1242/1511)와 LookupCommon(1205)을 조회하고, `dtTemp.Rows[0].CODE`(1213), `dtToMonth.Rows[k].CODE`(1247/1516), `dtMonth.Rows[k].CODE`(1298/1332/1587)를 읽습니다. | endpoints.csv, meta_reads.csv | 각 값이 저장 범위(월)를 정하는 데 쓰이는지는 **확인 필요** |
| R11 | 저장한 뒤 `FindData_Main`으로 다시 조회합니다. | flow.csv SaveButton > SaveData > FindData_Main | |
| R12 | 조회 SP는 `STRING_SPLIT`을 참조하고 동적 SQL을 씁니다. | endpoints.csv `REF:STRING_SPLIT`, `DYNAMIC@SCP0111_GET_INTEGRATION_PSI` | 다건 입력 조건(Model 등)을 분해하는지, 구분자가 무엇인지는 **확인 필요** |
| R13 | `Qty < 0` 체크(chkQty)가 조회 조건에 어떻게 반영되는지 | props.csv chkQty Text | **확인 필요** |
| R14 | 저장 SP 두 개 모두 `PR_SCM_SYS_LOG_BATCH`를 실행하고 `SCM_SYS_LOG_BATCH`에 INSERT합니다. | endpoints.csv | 배치 로그를 남깁니다. |

---

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 읽기 (SELECT/REF) | 쓰기 (INSERT/UPDATE/CREATE) | 호출 위치 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` [code=CalendarMonth] | (UP_FX_GetCommonDataList 코드 분기, DB 보강) | SCM_SYS_CALENDAR_M | - | SetChangedPeriod:287/288, SetCalendar:345, EditButton:554, SaveData:1154/1242/1511, _defaultDataModel_Changed:1980 (8회) |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | (UP_FX_GetCommonDataList 코드 분기, DB 보강) | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | - | EditButton:622, SaveData:1205, `<field:dtPeriod>`:66(진입점 미연결) (3회) |
| `SCP.SCP0111_GET_ESS_PACK_LINE` | `SCP0111_GET_ESS_PACK_LINE` | SCM_MST_LINE_OSP, SCM_MST_SITE | - | GetEssPackLineAll:490 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | `DM0003_GET_BUCKET_TYPE_CODE` | SCM_ADM_LOOKUP_MASTER_DETAIL | - | GetBucketType:1095 |
| `SCP.SCP0111_GET_INTEGRATION_PSI` | `SCP0111_GET_INTEGRATION_PSI` | SCP_ANL_PSI_INTEGRATION, SCP_MST_FINAL_ITEM, SCM_MST_ITEM_SN, STRING_SPLIT(REF), 동적 SQL | #SCP_ANL_PSI_INTEGRATION_ITEM (임시) | FindData_Main:874 |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | `SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | SCP_ANL_PSI_INTEGRATION, SCM_ARR_SPL_CNT(REF), SCM_ARR_SPL_VAL(REF) | **SCP_ANL_PSI_INTEGRATION (UPDATE·INSERT)**, SCM_SYS_LOG_BATCH (INSERT), EXEC PR_SCM_SYS_LOG_BATCH | SaveData:1379 |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI` | `SCP0111_SAVE_INTEGRATION_PSI` | SCP_ANL_PSI_INTEGRATION, SCM_MST_SITE, SCP_MST_BOM_ELEC, SCM_MST_YIELD_VER_H_V, SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_CELL_PROD_ASSY_MAP, SCP_MST_FINAL_ITEM, SCP_MST_FORMATION, SCP_MST_FORMATION_V, SCM_MST_MODEL_FINAL_ITEM_BOM_V, SCM_MST_BOM_EFFECTIVE_SN_V, SCM_MST_ITEM_SN, SCP_MST_TACT_TIME_OSP, SCM_CODE_LOOKUP_VALUE, FN_GET_LOOKUP_VALUE(REF), SCM_ARR_SPL_CNT/VAL(REF) | **SCP_ANL_PSI_INTEGRATION (INSERT·UPDATE)**, `UPDATE:X`(별칭 — 실제 대상 **확인 필요**), SCM_SYS_LOG_BATCH (INSERT), EXEC PR_SCM_SYS_LOG_BATCH, 임시 테이블 18종(#ELEC_PLANT, #CELL_ELEC_PLANT_MAPPING, #TMP_SCP_ANL_PSI_INTEGRATION_230/_CELL/_530, #TMP_PSI_INTEGRATION_YIELD_VER_H_V(_230), #TMP_YIELD_VER_H_V_A, #TMP_TCO_NO_CA2_ITEM_PROD, #TMP_PSI_INTEGRATION_750_SMALL/_350_SMALL/_230_ITEM_SMALL/_SMALL_230/_SMALL_330, #TEM_SCP_ANL_PSI_INTEGRATION_350) | SaveData:1637 |

> 이 표의 엔드포인트 이름은 화면설계서 §5 액션 명세, 단위테스트 '근거' 열과 같습니다.

---

## 6. Division·권한별 변형

| 구분 | 사실 | 근거 |
|---|---|---|
| Division — 그리드 메타 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 모두 SHEET_COLUMNS 22/0, SHEET_MEASURE 7/0으로 같습니다. | Fact Pack §10 |
| Division — 코드 분기 | division 값을 비교하는 분기가 없습니다(판단 불가 0건). | Fact Pack §12 |
| Division — 최종 표시 | division마다 22컬럼입니다. 동적 월 컬럼과 IsEditMode에 따른 숨김은 반영하지 않은 수치입니다. | grid_effective.csv |
| 권한 — 그룹 | `FoxUserInfoContext.Current.NowGroupID`를 EditButton:559, InsertRow:960, SaveData:1159에서 읽습니다. 그룹별로 동작이 어떻게 다른지는 **확인 필요**입니다. | meta_reads.csv |
| 권한 — 저장 SP | `_ADMIN` / 일반 저장 SP 두 가지가 있습니다. NowGroupID로 나뉘는지는 **확인 필요**입니다. | flow.csv |
| 권한 — 메타 | TB_FX_GroupMenuAuth 4행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있습니다. C/R/U/D 플래그 값은 **확인 필요**입니다. | Fact Pack §8 |

---

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 연계(I/F) 사실은 **없습니다**.
- 저장 SP 두 개가 `PR_SCM_SYS_LOG_BATCH`를 실행하고 `SCM_SYS_LOG_BATCH`에 기록합니다. 이것은 내부 배치 로그이며, 외부 인터페이스인지는 **확인 필요**입니다.

---

## 8. 미확정·확인 필요

1. `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`(1379)과 `SCP0111_SAVE_INTEGRATION_PSI`(1637)의 분기 조건, NowGroupID와의 관계.
2. 저장 SP 안의 `UPDATE:X` 별칭이 실제로 어느 테이블인지.
3. `DM.DM0003_GET_BUCKET_TYPE_CODE` 결과를 쓰는 곳.
4. `dtScpPlanPeriod`(HORIZON_END_DATE)와 `dtPlanTypeFN`(PLANDATE, RefreshPlanDate:418/422)의 원천 엔드포인트. Fact Pack에 없습니다.
5. Division 콤보, Plan-date/Plan-type/Plan-seq 콤보(RefreshPlanDate/RefreshPlanType/RefreshPlanSeq)의 원천.
6. `<field:dtPeriod>`:66 LookupCommon 호출은 진입점과 연결되지 않았습니다. 필드 초기화 때 실행되는지 확인해야 합니다.
7. `BtnNickName_Click` / `BtnItemId_Click`가 가져오는 값의 원천(팝업 여부).
8. `SpdMain_CellDoubleClick`, `SpdMain_TopChange`의 내부 동작.
9. `InsertRow`(960)의 진입점(버튼·이벤트).
10. 조회조건(Nick Name, Model, Cell Model, Qty < 0, Period)이 GET SP 파라미터로 어떻게 넘어가는지, 다건 입력의 구분자.
11. Fact Pack 4-2장의 SaveButton:816 → `PersonalSettingPopup.SaveData`가 화면 로컬 SaveData를 잘못 해석한 것인지.
12. 필수값·저장 결과 메시지의 원문.
13. 메타 TB_FX_SearchCondition 19행, SCM_MST_TITLESET_USER 7행, SCM_MST_SHEET_MEASURE 7행의 내용.

=== FILE: screen_design.md ===
# SCP0111 Integration PSI — 화면설계서

> 근거는 Fact Pack(controls.csv / props.csv / events.csv / flow.csv / grid_*.csv)입니다. 없는 내용은 **확인 필요**로 적었습니다. 주석 처리된 호출은 0건입니다.

---

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0111 |
| 화면 명칭 | `Integration PSI` (Designer.cs:905) |
| 도메인 / 분류 | SCP / Analysis |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행이 있지만 값이 Fact Pack에 없음) |
| 시트 | `Integration PSI` 1개 (`spdMain` / `spdMain_Sheet1`) |
| 공통 버튼 | Find(조회) / Edit(편집) / Save(저장). Fact Pack의 버튼 오버라이드 기준입니다. |

---

## 2. 화면 레이아웃

### 2-1. 분할 구조 (props.csv + controls.csv parent 체인)
- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 사실 0건). 그래서 화면은 Dock으로 위/아래 2단 구성입니다.
- parent 체인:
  - `this` → `pnlCondition` (UsrConditionPanel, Dock=Top, 2021×112, PanelType.HidePanel) → `usrLayoutControl2` (Dock=Fill, 2021×112) → 조회조건 컨트롤 13개
  - `this` → `spdMain` (FpSpread, Dock=Fill, 2021×865) — 시트 `spdMain_Sheet1`(parent 미추출)
  - `usrButton1`: parent가 비어 있습니다(75×23). 화면에 배치되는지는 **확인 필요**입니다.
- 높이 비율(전체 977 = 112 + 865): 조회조건 **약 11.5%**, 그리드 **약 88.5%**.

### 2-2. 텍스트 와이어프레임

```
┌──────────────────────────── this : "Integration PSI" (2021 × 977) ───────────────────────────┐
│ [공통 툴바] Find · Edit · Save                                                                 │
├─ pnlCondition (Dock Top, 112px ≈ 11.5%, HidePanel) ────────────────────────────────────────────┤
│  usrLayoutControl2 / layoutControlGroup2 (Fill 2021×112)                                       │
│   Division* [cboDivision ▼]        Plan-date* [cboPlanDate ▼]      (Plan-type [cboPlanType ▼] 숨김) │
│   Period [cmbFromMonth ▼] ~ [cmbToMonth ▼]                         [☐ Qty < 0  (chkQty)]         │
│   Nick Name [txtNickName ⋯][btnNickName]  Model [txtItemId ⋯][btnItemId]                        │
│   Cell Model [txtCellItemId ⋯](btnCellItem_Id 숨김)                                              │
│   ※ 행/열 배치 순서는 좌표가 추출되지 않아 확인 필요. 위 그림은 항목 목록이며 순서를 보장하지 않습니다. │
├─ spdMain (Dock Fill, 865px ≈ 88.5%) ────────────────────────────────────────────────────────────┤
│  시트: Integration PSI (spdMain_Sheet1)                                                         │
│  │메타 컬럼(22 표시/2 숨김)│ M_ 월 컬럼(YYYYMM_NAME, 폭 75) × CalendarMonth 행 수 │              │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
팝업: Nick Name / Model 값 선택 수단(BtnNickName_Click / BtnItemId_Click) — 팝업 폼명 확인 필요
```

### 2-3. 레이아웃 아이템 크기 (props.csv 원문)
| LayoutControlItem | 연결 컨트롤 | Size | Text |
|---|---|---|---|
| lblCombo1 | cboDivision | 300×38 | `Division*` |
| PlanDate | cboPlanDate | 300×44 | `Plan-date*` |
| PlanType | cboPlanType | 290×44 | `Plan-type` |
| layoutControlItem2 | cmbFromMonth | 161×44 | `Period` |
| layoutControlItem5 | cmbToMonth | 161×44 | ` ~` |
| lblNickName | txtNickName | 322×38 | `Nick Name` |
| layoutControlItem3 | btnNickName | 43×29 | (Text 없음) |
| lblItemId | txtItemId | 350×38 | `Model` |
| layoutControlItem1 | btnItemId | 43×29 | `layoutControlItem3` |
| lblCellItem | txtCellItemId | 315×38 | `Cell Model` |
| layoutControlItem4 | btnCellItem_Id | 43×29 | (Text 없음) |
| layoutControlItem6 | chkQty | 315×44 | (Text 없음 — 컨트롤 Text `Qty < 0`) |

EmptySpaceItem 11개(emptySpaceItem1~11)가 있지만 좌표가 없어 위치는 **확인 필요**입니다.

---

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨 (props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트(후보) |
|---|---|---|---|---|---|---|
| `pnlCondition` | UsrConditionPanel | (없음) | Dock=Top, HidePanel | - | - | 공용 조회조건 영역 |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` | Dock=Fill | - | - | 조회조건 Grid 레이아웃 |
| `cboDivision` | UsrCombo | `Division*` (lblCombo1) | 확인 필요 | Y (`*`) | SelectedIndexChanged → `CboDivision_SelectedIndexChanged` | 공용 Division 콤보 |
| `cboPlanDate` | UsrCombo | `Plan-date*` (PlanDate) | 확인 필요 | Y (`*`) | SelectedIndexChanged → `CboPlanDate_SelectedIndexChanged` | 공용 콤보 |
| `cboPlanType` | UsrCombo | `Plan-type` (PlanType) | **Visible=false** | - | SelectedIndexChanged → `CboPlanType_SelectedIndexChanged` | 숨김 처리 — 노출 여부 확인 필요 |
| `cmbFromMonth` | UsrComboBox | `Period` (layoutControlItem2) | SetChangedPeriod DataBind:290 | 확인 필요 | - | 기간 From 콤보 |
| `cmbToMonth` | UsrComboBox | ` ~` (layoutControlItem5) | SetChangedPeriod DataBind:291 | 확인 필요 | - | 기간 To 콤보 |
| `txtNickName` | UsrMultiLineEditor | `Nick Name` (lblNickName) | 빈값(확인 필요) | - | - | 멀티라인 입력 |
| `btnNickName` | UsrButton | (layoutControlItem3 Text 없음) | 표시 | - | Click → `BtnNickName_Click` | 입력 옆 선택 버튼 |
| `txtItemId` | UsrMultiLineEditor | `Model` (lblItemId) | 빈값(확인 필요) | - | - | 멀티라인 입력 |
| `btnItemId` | UsrButton | `layoutControlItem3` (layoutControlItem1) | 표시 | - | Click → `BtnItemId_Click` | 입력 옆 선택 버튼 |
| `txtCellItemId` | UsrMultiLineEditor | `Cell Model` (lblCellItem) | 빈값(확인 필요) | - | - | 멀티라인 입력 |
| `btnCellItem_Id` | UsrButton | (layoutControlItem4 Text 없음) | **Visible=false** | - | (배선 없음) | 미노출 |
| `chkQty` | UsrCheckBox | `Qty < 0` | 확인 필요 | - | - | CheckBox |
| `usrButton1` | UsrButton | (없음) | parent 없음, 75×23 | - | (배선 없음) | 사용 여부 확인 필요 |
| `spdMain` | FpSpread | (없음) | Dock=Fill | - | CellDoubleClick → `SpdMain_CellDoubleClick` / TopChange → `SpdMain_TopChange` / CellClick → `spdMain_CellClick` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | (props Text 없음 — 시트명 `Integration PSI`는 AddSheet:299 인자) | - | - | - | FlexGrid 단일 시트 |

비 UI 이벤트: `_defaultDataModel` Changed → `_defaultDataModel_Changed`(InitEvent:374). 폼: `this` Load → `Form_Load`(.ctor:167).

---

## 4. 그리드 명세 — 시트 `Integration PSI`

생성 순서는 AddSheet(`Integration PSI`, 1, 1, 35):299 → InitSheet:312 → SetSheetHeaderColumn(spdInfo, 1):333 → SetSpreadColumn:336 → SetCalendar:354입니다. 인자 `1, 1, 35`의 의미는 **확인 필요**입니다.

### 4-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS, 출처 META)
| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 (14개 공통) | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | BOH_QTY | BOH | 확인 필요 | META | 기본 | 확인 필요 |
| 2 | CELL_CF | Cell Coversion Factor | 확인 필요 | META | 기본 | 확인 필요 |
| 3 | CELL_ITEM_ID | Cell Model | 확인 필요 | META | 기본 | 확인 필요 |
| 4 | CELL_MODEL_NICK_NAME | Cell Model Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 5 | COMPANY_ID | Company | 확인 필요 | META | 기본 | 확인 필요 |
| 6 | DIVISION_ID | Division | 확인 필요 | META | 기본 | 확인 필요 |
| 7 | INCOTERMS | Incoterms | 확인 필요 | META | 기본 | 확인 필요 |
| 8 | ITEM_ID | Model | 확인 필요 | META | 기본 | 확인 필요 |
| 9 | LINE_ID | Line | 확인 필요 | META | 기본 | 확인 필요 (spdMain_CellClick이 dtLine을 참조) |
| 10 | MEASURE | MEASURE | 확인 필요 | META | 기본 → 조회 모드 숨김(1079), 편집 모드 폭 80(1070) | 확인 필요 |
| 11 | MEASURE_COLOR | MEASURE_COLOR | 확인 필요 | META | 숨김 | - |
| 12 | MEASURE_LABEL | Measure | 확인 필요 | META | 기본 | 확인 필요 |
| 13 | MEASURE_ORDER_NO | MEASURE_ORDER_NO | 확인 필요 | META | 숨김 | - |
| 14 | NICK_NAME | Nick Name | 확인 필요 | META | 기본 | 확인 필요 |
| 15 | OPERATION_GROUP | Operation | 확인 필요 | META | 기본 | 확인 필요 |
| 16 | PLAN_TYPE | Plan Type | 확인 필요 | META | 기본 | 확인 필요 |
| 17 | PLANT_ID | Plant | 확인 필요 | META | 기본 → 조회 모드 폭 0(1081), 편집 모드 폭 65(1072) | 확인 필요 |
| 18 | PLANT_ID_DESCRIPTION | Plant | 확인 필요 | META | 기본 | 확인 필요 |
| 19 | SEQ_FLAG | SEQ_FLAG | 확인 필요 | META | 기본 → 조회 모드 숨김(1078), 편집 모드 폭 60(1069) | 확인 필요 |
| 20 | TO_PRODUCT | To Product | 확인 필요 | META | 기본 | 확인 필요 |
| 21 | TO_SITE | To Site | 확인 필요 | META | 기본 → 조회 모드 폭 0(1082), 편집 모드 폭 75(1073) | 확인 필요 |
| 22 | TO_SITE_DESCRIPTION | To Site | 확인 필요 | META | 기본 | 확인 필요 |
| 23 | UOM | UOM | 확인 필요 | META | 기본 | 확인 필요 |
| 24 | VALUE_TYPE | Valuation Type | 확인 필요 | META | 기본 | 확인 필요 |

- `Cell Coversion Factor`는 메타 원문 철자를 그대로 옮겼습니다.
- 타입과 편집 가능 여부는 메타의 CELL_CONTROL_OBJECT_TYPE_CODE 등에서 정해지지만, 값이 Fact Pack에 없어 **확인 필요**입니다.
- SCM_MST_SHEET_MEASURE 7행(Measure 행 정의)의 값도 **확인 필요**입니다.

### 4-2. 코드 컬럼 (출처 HARDCODED / DB_DRIVEN)
| 구분 | 위치 | 컬럼·헤더 | 타입 | 출처 | 표시 | 편집 |
|---|---|---|---|---|---|---|
| 월 동적 컬럼 | SetCalendar:354 | 헤더 `YYYYMM_NAME` / 필드 `YYYYMM`, CalendarMonth 행마다 1개 | Num | DB_DRIVEN (`biz:CommonData.CommonDataList` [code=CalendarMonth]) | 표시, 폭 75, 병합 None | 확인 필요 |
| Tag 규칙 | SetSpreadColumn:392/396 | Tag `D_`·`W_` 접두 | - | HARDCODED | 숨김 | - |
| Tag 규칙 | SetSpreadColumn:396 | Tag `M_` 접두 | - | HARDCODED | 표시 | - |
| 헤더 스타일 | Designer:858~861 | ColumnHeaderDefaultEnhanced 상속, NoteIndicatorColor=Red, 정렬 General | - | HARDCODED | - | - |

### 4-3. Division별 표시
- 14개 division 모두 22컬럼으로 같습니다. 코드에 division 분기가 없습니다(grid_effective.csv).

---

## 5. 액션 명세

| 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|
| 화면 Load | `Form_Load` | GetEssPackLineAll:490 | `SCP.SCP0111_GET_ESS_PACK_LINE` | Line 목록 보관(dtLine인지 확인 필요) |
| 화면 Load | `Form_Load` | InitControls > GetBucketType:1095 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | 사용처 확인 필요 |
| 화면 Load | `Form_Load` | InitControls > SetChangedPeriod:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | cmbFromMonth / cmbToMonth DataBind |
| 화면 Load | `Form_Load` | CreateSpread > InitSpread > SetCalendar:345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | 시트 `Integration PSI` 생성, 월 컬럼 추가 |
| cboDivision 변경 | `CboDivision_SelectedIndexChanged` | SetChangedPeriod:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period 재바인딩 |
| cboPlanDate 변경 | `CboPlanDate_SelectedIndexChanged` | SetChangedPeriod:287/288, InitSpread > SetCalendar:345 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period 재바인딩, 월 컬럼 재생성 |
| cboPlanType 변경 | `CboPlanType_SelectedIndexChanged` | SetChangedPeriod:287/288 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | Period 재바인딩 |
| 데이터모델 변경 | `_defaultDataModel_Changed` | 1980 | `biz:CommonData.CommonDataList` [code=CalendarMonth] | 반영 대상 확인 필요 |
| btnNickName 클릭 | `BtnNickName_Click` | 1887 | (없음) | `txtNickName.Text = sNickName` |
| btnItemId 클릭 | `BtnItemId_Click` | 1926 | (없음) | `txtItemId.Text = sItemId` |
| 그리드 셀 클릭 | `spdMain_CellClick` | 1781~1786 dtLine/drLine CODE·NAME | (없음) | 셀 반영 내용 확인 필요 |
| 그리드 더블클릭 | `SpdMain_CellDoubleClick` | 확인 필요 | (없음) | 확인 필요 |
| 그리드 스크롤 | `SpdMain_TopChange` | 확인 필요 | (없음) | 확인 필요 |
| Find | FindButton | FindData_Main:874 → InitSpread > SetCalendar:345 | `SCP.SCP0111_GET_INTEGRATION_PSI`, `biz:CommonData.CommonDataList` [code=CalendarMonth] | 시트 `Integration PSI`에 결과 바인딩 |
| Edit | EditButton | 554 / 622, SetVisibleSheetColumns | `biz:CommonData.CommonDataList` [code=CalendarMonth], [code=LookupCommon] | 편집 모드에서 SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE 표시 |
| Save | SaveButton | SaveData 1154/1205/1242/1511 → 1379 또는 1637 → FindData_Main:874 | `biz:CommonData.CommonDataList` [code=CalendarMonth]·[code=LookupCommon], `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, `SCP.SCP0111_SAVE_INTEGRATION_PSI`, `SCP.SCP0111_GET_INTEGRATION_PSI` | 저장 후 재조회. ADMIN/일반 분기 조건 확인 필요 |

---

## 6. 검증·메시지

| 항목 | 사실 | 비고 |
|---|---|---|
| 필수 조건 | `Division*`, `Plan-date*` 라벨에 `*`가 붙어 있습니다. | 검사 코드와 메시지 ID/문구는 **확인 필요** |
| 저장 성공/실패 메시지 | Fact Pack에 없습니다. | **확인 필요** (TO-BE는 문구로 TO-BE MSG ID를 찾아 매핑) |
| 조회 결과 0건 메시지 | Fact Pack에 없습니다. | **확인 필요** |

---

## 7. 권한 (C/R/U/D)

| 구분 | 사실 |
|---|---|
| R (조회) | FindButton → `SCP.SCP0111_GET_INTEGRATION_PSI` |
| U/C (편집·저장) | EditButton, SaveButton → `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` / `SCP.SCP0111_SAVE_INTEGRATION_PSI`. 저장 SP가 SCP_ANL_PSI_INTEGRATION에 UPDATE·INSERT합니다. |
| D (삭제) | 사실 없음 |
| 그룹 판정 | EditButton:559, InsertRow:960, SaveData:1159에서 `NowGroupID`를 읽습니다. 조건은 **확인 필요**입니다. |
| 메타 | TB_FX_GroupMenuAuth 4행. 플래그 값은 **확인 필요**입니다. |

---

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 관점 | AS-IS 사실 | To-Be 고려점 |
|---|---|---|
| 그리드 | FpSpread, META(SetSheetHeaderColumn) + CalendarMonth 동적 월 컬럼 | Wijmo FlexGrid: 메타 컬럼과 동적 월 컬럼을 합쳐서 구성합니다. 월 컬럼은 조회할 때마다 다시 만들어야 합니다(CboPlanDate 변경 시 포함). |
| 표시 전환 | IsEditMode에 따라 SEQ_FLAG/MEASURE/PLANT_ID/TO_SITE 폭·표시 전환 | 편집 모드 상태에 따라 컬럼 visible/width를 바꿔야 합니다. |
| Tag 규칙 | D_/W_ 숨김, M_ 표시 | 동적 컬럼의 접두 규칙을 그대로 옮겨야 합니다. 접두를 누가 붙이는지는 확인 필요입니다. |
| SP — MSSQL 잔존 | GET SP가 `STRING_SPLIT`을 참조하고, 동적 SQL을 씁니다. | Oracle에는 STRING_SPLIT이 없으므로 대체 구현이 필요합니다. |
| 임시 테이블 | GET 1종, SAVE 18종의 `#` 임시 테이블 | Oracle GTT 등으로 바꿔야 합니다. 저장 전 초기화 여부를 확인해야 합니다. |
| 배열 분해 | SAVE SP가 `SCM_ARR_SPL_CNT`/`SCM_ARR_SPL_VAL`을 참조합니다. | Oracle 대응 함수가 있어야 합니다. |
| 공통데이터 | `biz:CommonData.CommonDataList` CalendarMonth/LookupCommon (UP_FX_GetCommonDataList) | TO-BE 공통 콤보/코드 API에 매핑해야 합니다. |
| 숨김 컨트롤 | cboPlanType, btnCellItem_Id Visible=false, usrButton1 parent 없음 | 노출하지 않는 대상인지 확인해야 합니다. |

---

## 9. 미확정

1. 조회조건 실제 배치 순서와 좌표.
2. ADMIN/일반 저장 분기 조건.
3. Nick Name / Model 선택 팝업 폼, 값 원천.
4. `SpdMain_CellDoubleClick` / `SpdMain_TopChange` 동작, `spdMain_CellClick`이 셀에 반영하는 내용.
5. 메타 컬럼 타입·편집 가능 여부, SHEET_MEASURE 7행 내용.
6. AddSheet 인자 `1, 1, 35`의 의미.
7. `InsertRow` 진입점.
8. 검증·결과 메시지 원문.
9. 메뉴 위치.

=== FILE: unit_test.md ===
# SCP0111 Integration PSI — 단위테스트

> 근거 열에는 엔드포인트·SP·핸들러·시트 이름을 원문 그대로 적었습니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 주석 처리된 호출은 0건이라 그로부터 만든 테스트 케이스는 없습니다. 기대결과 중 AS-IS 동작이 확인되지 않은 부분은 "확인 필요"로 적었고, AS-IS와 대조해서 판정합니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SCP0111-001 | 초기화 | 메뉴 권한이 있는 사용자 | 화면을 엽니다. | - | 오류 없이 진입합니다. Line 목록을 조회합니다. | `Form_Load` > GetEssPackLineAll:490, `SCP.SCP0111_GET_ESS_PACK_LINE`, SP `SCP0111_GET_ESS_PACK_LINE` |
| TC-SCP0111-002 | 초기화 | TC-001 | 진입 직후 Bucket Type 호출 여부를 확인합니다. | - | Bucket Type 코드를 조회합니다(사용처 확인 필요). | `Form_Load` > InitControls > GetBucketType:1095, `DM.DM0003_GET_BUCKET_TYPE_CODE`, SP `DM0003_GET_BUCKET_TYPE_CODE` |
| TC-SCP0111-003 | 초기화 | TC-001 | `cmbFromMonth`, `cmbToMonth` 목록을 엽니다. | - | CalendarMonth 결과(CODE/NAME)가 바인딩되어 있습니다. | `Form_Load` > InitControls > SetChangedPeriod:287/288, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-004 | 초기화 | TC-001 | 조회조건 영역을 확인합니다. | - | `cboPlanType`, `btnCellItem_Id`는 보이지 않습니다. `cboDivision`(`Division*`)과 `cboPlanDate`(`Plan-date*`)는 필수로 표시됩니다. | props.csv Visible=false(305, 450), `Form_Load` |
| TC-SCP0111-005 | 초기화 | TC-001 | 그리드 `spdMain`을 확인합니다. | - | 시트 `Integration PSI`가 생성되고, 메타 컬럼과 월 컬럼이 만들어져 있습니다. | `Form_Load` > CreateSpread > InitSpread > SetCalendar:345, 시트 `Integration PSI`, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-006 | 초기화 | ESS Pack Line 데이터가 0건인 환경 | 화면을 엽니다. | - | 빈 결과여도 예외 없이 진입합니다. 이후 `spdMain_CellClick`에서 dtLine을 참조할 때 오류가 없어야 합니다(AS-IS 동작 확인 필요). | `SCP.SCP0111_GET_ESS_PACK_LINE`, SP `SCP0111_GET_ESS_PACK_LINE`, `spdMain_CellClick` |
| TC-SCP0111-007 | 이벤트 | TC-001 | `cboDivision` 값을 바꿉니다. | Division 다른 값 | `cmbFromMonth`/`cmbToMonth`를 다시 바인딩합니다. | `CboDivision_SelectedIndexChanged` > SetChangedPeriod:287/288, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-008 | 이벤트 | TC-001 | `cboPlanDate` 값을 바꿉니다. | Plan-date 다른 값 | Period를 다시 바인딩하고, 그리드 월 컬럼을 CalendarMonth 결과대로 다시 만듭니다. | `CboPlanDate_SelectedIndexChanged` > SetChangedPeriod:287/288, InitSpread > SetCalendar:345, `biz:CommonData.CommonDataList` [code=CalendarMonth], 시트 `Integration PSI` |
| TC-SCP0111-009 | 이벤트 | `cboPlanType`이 노출되거나 값이 바뀌는 조건(확인 필요) | `cboPlanType` 값을 바꿉니다. | Plan-type 다른 값 | Period를 다시 바인딩합니다. | `CboPlanType_SelectedIndexChanged` > SetChangedPeriod:287/288, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-010 | 이벤트 | TC-001 | 기본 데이터 모델을 바꾸는 동작을 합니다(발생 조건 확인 필요). | - | CalendarMonth를 다시 조회합니다(반영 대상 확인 필요). | `_defaultDataModel_Changed`:1980, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-011 | 이벤트 | TC-001 | `btnNickName`을 누르고 값을 선택합니다. | Nick Name 1건 이상 | 선택한 값이 `txtNickName`에 들어갑니다. | `BtnNickName_Click`:1887 (`txtNickName.Text = sNickName`) |
| TC-SCP0111-012 | 이벤트 | TC-001 | `btnItemId`를 누르고 값을 선택합니다. | Model 1건 이상 | 선택한 값이 `txtItemId`에 들어갑니다. | `BtnItemId_Click`:1926 (`txtItemId.Text = sItemId`) |
| TC-SCP0111-013 | 그리드 | 조회 결과 1건 이상, 편집 모드 | `spdMain`의 셀(LINE_ID 등)을 클릭합니다. | - | dtLine의 CODE/NAME을 참조해 처리합니다(셀 반영 내용 확인 필요). 오류가 없어야 합니다. | `spdMain_CellClick`:1781~1786, 시트 `Integration PSI` |
| TC-SCP0111-014 | 그리드 | 조회 결과 1건 이상 | `spdMain` 셀을 더블클릭합니다. | - | AS-IS와 같은 동작을 합니다(내부 동작 확인 필요). 오류가 없어야 합니다. | `SpdMain_CellDoubleClick`, 시트 `Integration PSI` |
| TC-SCP0111-015 | 그리드 | 조회 결과가 화면보다 많음 | `spdMain`을 세로로 스크롤합니다. | - | AS-IS와 같은 동작을 합니다(내부 동작 확인 필요). 오류가 없어야 합니다. | `SpdMain_TopChange`, 시트 `Integration PSI` |
| TC-SCP0111-016 | 조회 | 필수 조건 입력 | `cboDivision`, `cboPlanDate`, `cmbFromMonth`~`cmbToMonth`를 고르고 Find를 누릅니다. | 유효 Division/Plan-date/Period | 결과가 시트 `Integration PSI`에 표시되고, 월 컬럼이 다시 만들어집니다. | FindButton > FindData_Main:874, `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI`, SetCalendar:345 `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-017 | 조회 | 데이터가 없는 조건 | Find를 누릅니다. | 결과 0건 조건 | 그리드 0행, 오류 없음. 0건 안내 메시지 여부는 확인 필요입니다. | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-018 | 조회 | SP 오류를 유도할 수 있는 환경 | Find를 누릅니다. | SP 오류 응답 | 오류 메시지를 표시하고, 그리드에 잘못된 결과를 남기지 않습니다(메시지 원문 확인 필요). | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-019 | 조회 | TC-001 | `cboDivision` 또는 `cboPlanDate`를 비우고 Find를 누릅니다. | 필수값 빈값 | 필수값 검증으로 조회를 막습니다(검증 코드·메시지 확인 필요). | `Division*`/`Plan-date*` 라벨(props.csv 602/632), `SCP.SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-020 | 조회 | TC-016 조건 | `txtItemId`, `txtNickName`, `txtCellItemId`에 여러 줄 값을 넣고 Find를 누릅니다. | 2건 이상 멀티라인 | 입력한 모든 값으로 필터링됩니다(파라미터 매핑·구분자 확인 필요). | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI`(REF:STRING_SPLIT) |
| TC-SCP0111-021 | 조회 | TC-016 조건 | `chkQty`(`Qty < 0`)를 체크하고 Find를 누릅니다. | 체크 ON/OFF | 체크 여부에 따라 결과가 AS-IS와 같습니다(반영 방식 확인 필요). | `SCP.SCP0111_GET_INTEGRATION_PSI`, SP `SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-022 | 그리드 | 조회 완료(조회 모드) | 시트 `Integration PSI`의 컬럼 헤더를 확인합니다. | - | 메타 표시 22컬럼(BOH, Cell Coversion Factor, Cell Model, Cell Model Nick Name, Company, Division, Incoterms, Model, Line, MEASURE, Measure, Nick Name, Operation, Plan Type, Plant, Plant, SEQ_FLAG, To Product, To Site, To Site, UOM, Valuation Type)이 정의되어 있고, MEASURE_COLOR와 MEASURE_ORDER_NO는 숨겨져 있습니다. | 시트 `Integration PSI`, SCM_MST_SHEET_COLUMNS, InitSpread SetSheetHeaderColumn:333 |
| TC-SCP0111-023 | 그리드 | 조회 완료(조회 모드) | SEQ_FLAG, MEASURE, PLANT_ID, TO_SITE를 확인합니다. | - | SEQ_FLAG·MEASURE는 숨김(폭 0), PLANT_ID·TO_SITE는 폭 0입니다. | 시트 `Integration PSI`, SetVisibleSheetColumns:1078~1082 |
| TC-SCP0111-024 | 그리드 | 조회 완료 | 월 컬럼 수와 헤더를 확인합니다. | Period 범위 | CalendarMonth 결과 행 수만큼 숫자 컬럼(헤더 YYYYMM_NAME, 폭 75)이 있습니다. Tag가 `D_`/`W_`인 컬럼은 숨기고 `M_`인 컬럼만 표시합니다. | 시트 `Integration PSI`, SetCalendar:354, SetSpreadColumn:392/396, `biz:CommonData.CommonDataList` [code=CalendarMonth] |
| TC-SCP0111-025 | 이벤트 | 조회 완료 | Edit를 누릅니다. | - | 편집 모드로 바뀌고, SEQ_FLAG(60), MEASURE(80), PLANT_ID(65), TO_SITE(75)가 보입니다. | EditButton:554/622, `biz:CommonData.CommonDataList` [code=CalendarMonth], `biz:CommonData.CommonDataList` [code=LookupCommon], SetVisibleSheetColumns:1069~1073, 시트 `Integration PSI` |
| TC-SCP0111-026 | 저장 | 편집 모드, ADMIN 분기 조건 충족(조건 확인 필요) | 값을 수정하고 Save를 누릅니다. | 수정 1행 이상 | ADMIN 저장 SP가 실행되어 SCP_ANL_PSI_INTEGRATION에 UPDATE/INSERT되고 SCM_SYS_LOG_BATCH에 기록됩니다. 이어서 다시 조회합니다. | SaveButton > SaveData:1379, `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, SP `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, FindData_Main:874 `SCP.SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-027 | 저장 | 편집 모드, 일반 분기 조건 충족(조건 확인 필요) | 값을 수정하고 Save를 누릅니다. | 수정 1행 이상 | 일반 저장 SP가 실행되어 SCP_ANL_PSI_INTEGRATION에 INSERT/UPDATE되고 SCM_SYS_LOG_BATCH에 기록됩니다. 이어서 다시 조회합니다. | SaveButton > SaveData:1637, `SCP.SCP0111_SAVE_INTEGRATION_PSI`, SP `SCP0111_SAVE_INTEGRATION_PSI`, FindData_Main:874 `SCP.SCP0111_GET_INTEGRATION_PSI` |
| TC-SCP0111-028 | 저장 | 편집 모드 | Save를 누릅니다. | - | 저장 전에 CalendarMonth(1154/1242/1511)와 LookupCommon(1205)을 조회하고, 그 결과(dtTemp/dtToMonth/dtMonth CODE)로 저장 범위를 구성합니다(사용 방식 확인 필요). | SaveData, `biz:CommonData.CommonDataList` [code=CalendarMonth], `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SCP0111-029 | 저장 | 편집 모드, 수정 없음 | Save를 누릅니다. | 변경 0건 | 저장 SP를 호출하지 않거나 안내합니다(AS-IS 동작 확인 필요). | `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, `SCP.SCP0111_SAVE_INTEGRATION_PSI` |
| TC-SCP0111-030 | 저장 | SP 오류를 유도할 수 있는 환경 | Save를 누릅니다. | SP 오류 응답 | 오류 메시지를 표시하고 데이터가 부분 반영되지 않습니다(메시지 원문·롤백 동작 확인 필요). | SP `SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, SP `SCP0111_SAVE_INTEGRATION_PSI` |
| TC-SCP0111-031 | 권한 | 그룹이 다른 사용자 2명(NowGroupID 상이) | 각각 Edit와 Save를 실행합니다. | - | 그룹에 따라 편집/저장 동작(저장 SP 분기 포함)이 AS-IS와 같습니다(조건 확인 필요). | EditButton:559, SaveData:1159 NowGroupID, TB_FX_GroupMenuAuth, `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN`, `SCP.SCP0111_SAVE_INTEGRATION_PSI` |
| TC-SCP0111-032 | division | 대표 division 사용자(40, 81, 82, EE 계열) | 각 division으로 Find를 실행하고 컬럼을 비교합니다. | Division 40 / 81 / 82 / EE | 14개 division 모두 메타 표시 컬럼 22개가 같습니다(division 변형 없음). | 시트 `Integration PSI`, grid_effective.csv, `SCP.SCP0111_GET_INTEGRATION_PSI` |

### 커버리지 점검
| 대상 | TC |
|---|---|
| `Form_Load` | 001~006 |
| `BtnNickName_Click` | 011 |
| `BtnItemId_Click` | 012 |
| `SpdMain_CellDoubleClick` | 014 |
| `SpdMain_TopChange` | 015 |
| `spdMain_CellClick` | 006, 013 |
| `CboDivision_SelectedIndexChanged` | 007 |
| `CboPlanDate_SelectedIndexChanged` | 008 |
| `CboPlanType_SelectedIndexChanged` | 009 |
| `_defaultDataModel_Changed` | 010 |
| `biz:CommonData.CommonDataList` | 003, 005, 007~010, 016, 024, 025, 028 |
| `SCP.SCP0111_GET_ESS_PACK_LINE` | 001, 006 |
| `SCP.SCP0111_GET_INTEGRATION_PSI` | 016~021, 026, 027, 032 |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | 002 |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI_ADMIN` | 026, 029~031 |
| `SCP.SCP0111_SAVE_INTEGRATION_PSI` | 027, 029~031 |
| 시트 `Integration PSI` | 005, 008, 013~015, 022~025, 032 |
| 빈 결과 / 오류 응답 | 006, 017 / 018, 030 |
