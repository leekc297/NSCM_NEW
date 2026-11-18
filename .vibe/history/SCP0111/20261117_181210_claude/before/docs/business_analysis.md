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
