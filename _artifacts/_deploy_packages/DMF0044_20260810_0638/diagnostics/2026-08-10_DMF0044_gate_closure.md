# DMF0044 (Sales Reports / MDF Reports) 완료 게이트 종결 보고서

- **일자**: 2026-08-10
- **범위**: DMF0044 UI 보완·검증 (사용자 승인 플랜 Phase 0~7)
- **결론**: **완료 게이트 9섹션 종합 PASS** / **HTTP 셀프 E2E 15계정 종합 PASS (FAIL 0 / WARN 0)**
- **최종 리포트**
  - 게이트: `_artifacts/_gate_reports/DMF0044_20260810_0612.md`
  - E2E: `_artifacts/_gate_reports/DMF0044_http_e2e_20260810_0526.md`
  - 콤보 호출지점: `_artifacts/_gate_reports/COMBO_CALLSITE_PARITY_DMF0044_20260810_0612.md`

---

## 0. 기준선 → 결과

| 섹션 | 기준선 (2026-08-09 Phase 0) | 최종 |
|---|---|---|
| 1. 실행 hook (G-A~G-G) | PASS | **PASS** (20파일 · BLOCK 0 / WARN 0) |
| 2. EID 1:1 대사표 | **FAIL** (구 서술형 76행, EID 0) | **PASS** 148/148 |
| 3. FE→BE→SP 배선 체인 | FAIL | **PASS** |
| 4. 메타 값 단언 | PASS | **PASS** (CTRL 위반 0 / 전면-IM 0) |
| 5. CRUD·모달 매트릭스 | FAIL | **PASS** 14/14 |
| 6. HTTP 셀프 E2E | **FAIL** (시나리오 미등록) | **PASS** (FAIL 0 / WARN 0) |
| 7. UP_FX 콤보 파라미터 | FAIL | **PASS** (셀 콤보 14종 FAIL 0 / WARN 0) |
| 8. 콤보 호출지점 대사 | WARN 5 | **PASS** (FAIL 0 / WARN 0 / PASS 6) |
| 9. 단위테스트 | **FAIL** (0건) | **PASS** (27 tests) |

> 종합: **FAIL 4 / WARN 4 / PASS 2 → 전 섹션 PASS**

---

## 1. 실제 결함 (수정 적용분)

### D-① `PKG_DMF0044` MERGE ON 키 3개 누락 — 적용 (2026-08-09)
AS-IS `DMF0044_SAVE_SALES_PLAN_REPORT_C` 의 ON 절 19키 중 3키가 변환 시 누락.
`DOM_EXP` / `FORECAST_INFO_CELL_MODEL`↔`CELL_MODEL_INFO` / `ATTRIBUTE3`↔`CELL_MODEL`.
영향 = QTY 오갱신 · ORA-30926(비결정적 MERGE).

- 적용기: `_artifacts/_diagnostics/dmf0044_merge_keys_apply.py`
- ⛔ 08-05 패치본 직접 배포 금지(AUTHUNION 유실) → live 재덤프 후 3키 hunk 재적용
- 검증: 배포 후 `AUTHUNION 2026-08-09` 마커 1건 잔존 확인

### D-② 조회 PIVOT 셀 값이 **컬럼명 문자열** — 적용 (2026-08-10) ⭐ 차단급
`P_DMF0044_GET_SALES_REPORTS_DATA` 가 반환하는 동적 셀 `M_yyyymm` 의 값이 수량이 아니라
`"M_202501"` 같은 **컬럼명 문자열**. div=40 187행 / div=82 535행 **전 행**.

원인 = 단일 변수 `V_PROD` 를 성격이 다른 두 자리에 재사용:

| 위치 | 필요한 형태 | 실제 |
|---|---|---|
| BODY L1619 `PIVOT (SUM(QTY) FOR YYYYMM IN (…))` | 리터럴+별칭 `'M_202501' AS "M_202501"` | ✅ 맞음 |
| BODY L1602 바깥 SELECT 목록 | 식별자만 `"M_202501"` | ⛔ 리터럴이 들어가 **상수 컬럼**이 PIVOT 산출을 덮어씀 |

2026-07-30 "별칭이 없으면 PIVOT 결과 컬럼명에 따옴표가 포함된다" 정정 때 IN 절만 보고
SELECT 목록 재사용을 놓친 것.

**정본 근거 (자매 패키지 2본 — 둘 다 2변수 분리)**
- `PKG_DMF0042` L1730~1731 `v_Prod`(식별자) / `v_Prod_in`(IN 절) → L2733 / L2741
- `PKG_DMF0049` L297~298 `V_COLS`(식별자) / `V_PROD`(IN 절) → L607 / L612

⇒ 동일 절차 계열인 **DMF0049 의 `V_COLS` 패턴을 그대로 이식**(신규 발명 0).

- 적용기: `_artifacts/_diagnostics/dmf0044_pivot_select_apply.py` (`--dump`/`--patch`/`--deploy`)
- 백업: `_artifacts/_apply_corporate/BACKUP_PKG_DMF0044_BODY_pre_pivotsel_20260810.sql` (9,752행)
- 배포본: `PKG_DMF0044_BODY_PIVOT_SELECT_20260810.sql` (9,759행, +7)
- 배포 결과: PACKAGE / PACKAGE BODY **VALID**, 선행 마커 2종(AUTHUNION · MERGE-ON) 각 1건 잔존
- 실증(적용 후): div=40 첫행 `{'M_202507': 3.648, 'M_202508': 24.506408}` · 비0 수치셀 551
  / div=82 `{'M_202506': 468}` · 1,017

### D-③ FE 셀 콤보 파라미터 미전달 — 적용 (2026-08-09)
`SalesReportsGrid.tsx` 가 `comboId` 만 넘겨 `DM_LOOKUP_DIV` 계열이 **조용히 0행**.
DMF0042 선례 1:1 로 `param1`(division) / `param2`(ATTRIBUTE1) 전달 + `comboSig` 에 division 포함.

### D-④ DEPT_ID cascade 전체 미이관 — 적용 (2026-08-09, 사용자 선택 "전체 이관")
AS-IS `.cs` 런타임 `SetCellTypeCombo` 3분기(L990/L1180/L1195)가 TO-BE 에 없었음.
- CMBO 2종 신규 등록: `DMF0044_DEPARTMENT_TEAM`(9,626행) · `DMF0044_ETC_SALE_RESULT_TYPE_40`(1행)
- `ROW_COMBO_IDS` + `resolveDeptIdRows` + `beginningEdit` dataMap 스왑 + `DEPARTMENT_CHANGE_CLEAR` 5컬럼

### D-⑤ `buildEtcSaveRows` AS-IS 파리티 결함 3건 — 적용 (2026-08-10) ⭐
AS-IS `SaveData` L552~694 원문 재대조로 확인:

| # | TO-BE(수정 전) | AS-IS 원문 | 영향 |
|---|---|---|---|
| 1 | 한 셀 변경 → **1 엔트리** | L601 `measure=GetValue(i,…)`·`qty=sQty` + L638 `measure=GetValue(i+1,…)`·`qty=sQty2` = **2 엔트리** | 세트 한쪽 수량이 **영구 미저장** |
| 2 | `cellModelInfo = pair.MEASURE` | L607·L643 `GetValue(i, CELL_MODEL_INFO)` | MERGE ON `FORECAST_INFO_CELL_MODEL` 불일치 → UPDATE 대신 **중복 INSERT** |
| 3 | `cellModel = pair[binding]`(수량) | L608·L644 `GetValue(i, CELL_MODEL)` | 동상 (`ATTRIBUTE3` 키) |

호출측(`SalesReports.tsx`)도 `pairOf` → `setInfoOf`(pair + **isSetHead**)로 교체 —
AS-IS 는 identity·activeFlag 를 **양쪽 모두 짝수행(i) 값**으로 채우기 때문.

---

## 2. 오탐 / 판정 확정 (코드 변경 없음, 근거 등재)

| 항목 | 판정 | 근거 |
|---|---|---|
| `DM_LOOKUP_DIV@BIZ_TYPE` 0행 | **AS-IS 파리티** | AS-IS `SCM_MST_SHEET_COLUMNS` 의 `ATTRIBUTE1='40'`·`DIVISION_ID='40'` 이 TO-BE 와 동일 → `LOOKUP_TYPE='40'` 조회인데 `SCM_ADM_LOOKUP_MASTER` 에 '40' 은 AS-IS 0건·TO-BE 0건. 게다가 GET SP 가 `BIZ_TYPE` 컬럼 자체를 반환하지 않음(반환은 `BIZ_TYPE_NAME40` ← `DmBizType` 3행) = **legacy 잔존 메타** |
| div82 `wonqthanq` EDIT_FLAG 전 행 'N' | **AS-IS 파리티** | div82 원장에 `DATA_TYPE='2'` 0건 → 시나리오가 DataType=1(Cutoff)로 조회. Cutoff 분기 EDIT_FLAG = `(V_GROUP_ID='ADMIN') AND (DATA_TYPE='2')` (BODY L1361) ⇒ DATA_TYPE='1' 행은 **정의상 전부 'N'**. AS-IS `DMF0044_GET_SALES_REPORTS_DATA` 동일 문자열 확인 |
| `DMF0044_MDF_ENDCUST_REPORT` 미식별 | **개명(별칭 등재)** | ① `.cs` L1224~1230 이 `END_CUST_REPORT` 컬럼에 적용(파라미터 없음=전량 동일 목록) ② AS-IS SHEET_COLUMNS 의 그 컬럼 = `FPComboBox`/`CELL_COMBO_DATA_TYPE='END_CUST_REPORT'` ③ AS-IS LOOKUP 에 END_CUST 계열은 `END_CUST_REPORT`(780행) 하나뿐(TO-BE 765행). ⚠ 한계: AS-IS 콤보 SQL 자체는 BizService(서버측)라 본 저장소에서 읽을 수 없음 — 위 3축 정황 판정 |

---

## 3. 구조적 발견 — ETC 저장 반영은 **화면 재조회로 관찰 불가**

SP 원문 실측(2026-08-10):

| 축 | 대상 표 |
|---|---|
| ETC 조회 (`P_DATA_TYPE<>'1'`, BODY L1459~1513) | `DM_PLN_SALES_ETC_REPORT_C` |
| ETC 저장 (`P_DMF0044_SAVE_SALES_PLAN_REPORT_C`) | `DM_PLN_SALES_PLAN_REPORT_C` |

**읽는 표와 쓰는 표가 다르다.** 같은 조건으로 재조회하면 저장 반영이 구조적으로 보이지 않는다.
AS-IS 도 동일 구조(ON 절 19키에 `FORECAST_INFO_CELL_MODEL` 포함 — AS-IS DB 원문 확인).

부수 실측: 버전 `R_S_20260128_V002_C`/div40 기준 ETC 그리드 식별자 482건 중
**450건은 원장(plan report)에 대응 행이 아예 없고**, 대응이 있는 32건은 전부 `CELL_MODEL_INFO` 가 불일치.

⇒ E2E 는 **원장 직접 검증** 경로(`save_mode: "insert_first"`)를 신설해
`I(MERGE NOT MATCHED) → M(MERGE MATCHED) → D` 를 **우리가 만든 행 위에서** 돌린다.
기존 행 무손상 + MERGE 3분기 전부 실증 + 잔존 0.

```
PASS | INSERT(MERGE NOT MATCHED) activeFlag='I' HTTP 200 → 원장 QTY = 7.0 (기대 7)
PASS | UPDATE(MERGE MATCHED)     activeFlag='M' HTTP 200 → 원장 QTY = 9.0 (기대 9)
PASS | DELETE                    activeFlag='D' HTTP 200 → 원장 QTY = 0.0 (기대 0)
PASS | 테스트 잔존 정리 0건
```

---

## 4. 도구 보완 (전 화면 회귀 대조 포함)

| 도구 | 보완 | 사유 |
|---|---|---|
| `ui_http_e2e.fetch_cell_combos` | CMBO 단위 → **컬럼 단위** 수집 + `meta_cell_params()` | 같은 CMBO 를 쓰는 컬럼들이 서로 다른 파라미터를 갖는 경우를 전역 1세트로 뭉뚱그려 판정 뒤집힘 (DMF0044 `DM_LOOKUP_DIV` 2컬럼) |
| 〃 | `SHEET_COLUMNS.DIVISION_ID` **다중값**(`'40,81,81_UC,…'`) 처리 | 그대로 넣으면 SEGMENT1 매칭이 깨져 조용히 0행 (DMF0042 `FCST_TYPE` 실측) |
| 〃 | `cell_combo_zero_ok` 신설 | 0행이 AS-IS 파리티임을 **실증한 컬럼만** 통과. 일반 note 로는 못 가림 |
| 〃 | `save_roundtrip.search_filters` / `save_mode: insert_first` + `ledger_probe`/`cleanup` | 조회 조건과 저장 관찰 조건이 다른 화면(§3) |
| `combo_callsite_parity.const_id_maps` | `const X = {…} as const` 콤보 ID 맵 인식 | 콤보 ID 를 상수 맵에 모아 `Object.values()` 로 넘기는 표준 배선을 통째로 '미식별 WARN' 처리 |
| 〃 `row_swap_combo_ids` | `beginningEdit` 본문의 `MAP.KEY` 참조 인식 | 메타에 컬럼이 없는 `.cs` 런타임 콤보는 `GRID_CASCADE_FILTERS` 경로로 영원히 인정 불가 |
| 〃 | `beginningEdit` 파라미터의 인라인 객체 타입 건너뛰기 | `e: { cancel: boolean }` 의 `{` 를 본문으로 오인 |
| `asis_mapping_gate --init` | 방언 판정을 md **세트** → **파일 단위** | 이벤트 축 29행 유실 (DMF0044) |

### 회귀 대조 — `combo_callsite_parity` (HEAD ↔ 현재)

| 화면 | HEAD (세션 전) | 현재 | 판정 |
|---|---|---|---|
| DMF0042 | FAIL 5 / WARN 5 / PASS 3 | **FAIL 0 / WARN 0 / PASS 13** | 개선 |
| DMF0044 | FAIL 0 / WARN 6 / PASS 0 | **FAIL 0 / WARN 0 / PASS 6** | 개선 |
| DMF0049 | FAIL 2 / WARN 5 / PASS 1 | **FAIL 1 / WARN 4 / PASS 3** | 개선 (잔여는 범위 밖) |
| DMF0082 | FAIL 0 / WARN 0 / PASS 14 | FAIL 0 / WARN 0 / PASS 14 | **동일** |
| DMF0003 | FAIL 1 / WARN 10 / PASS 7 | FAIL 0 / WARN 9 / PASS 9 | 개선 |

**회귀 0.**

---

## 5. 단위테스트 (27) — 효능 증명 포함

`nscm-fe/features/demand/src/pages/sales-reports/SalesReportsUtils.test.ts`

- `dynKindOf` / `evalSalesReportCell` 4변수 매트릭스(게이트0·EDIT_FLAG=Y·LOC·RTF·Business_Plan·기타×division)
- `insertStaticEditable` 잠금 12 / `existingStaticEditable` 전량 잠금
- `resolveDeptIdRows` 3분기 (미입력 / '기타' / 부모키 필터)
- `buildEtcSaveRows` **세트 2엔트리** + 중복 전송 방지 / `buildCutoffSaveRows` / `buildBulkPayload` / `isEtc`

효능 증명(2026-08-09): 결함 2건 주입(`editLock` RTF 분기 `d40`→`true`, `gridCombos` '기타' 분기 제거)
→ **정확히 그 2 테스트만 실패** → 원복 후 전량 통과.

---

## 6. 이월 / 범위 밖

- FE **lint·type-check 는 클라우드에서 사용자 실행** (룰 — 로컬 실행 금지). 변경 파일:
  - `features/demand/src/pages/sales-reports/SalesReports.tsx`
  - `features/demand/src/pages/sales-reports/components/SalesReportsGrid.tsx`
  - `features/demand/src/pages/sales-reports/utils/sales-reports.{gridCombos,api,editLock,save}.ts`
  - `features/demand/src/pages/sales-reports/SalesReportsUtils.test.ts` (신규)
  - (DMF0042 분) `features/demand/src/pages/business-plan/components/BusinessPlanGrid.tsx`
- **브라우저 육안 확인은 사용자 몫** — 본 보고서는 HTTP·원장 레벨 실증까지 담당
- **클라우드 이관 패키지 갱신은 범위 밖** — 오늘 사내 적용분(`PKG_DMF0044` PIVOT SELECT)은
  순서서 `DMF0042_44_49_CLOUD_APPLY_ORDER_20260805.md` 에 **추가 반영 필요**
- DMF0049 잔여 FAIL 1 / WARN 4 = 해당 화면 작업 시점 처리 (현재 범위 아님)
- AUTHUNION 미적용 잔여 26 객체 + 혼재 1 (다른 화면 — 범위 밖)
