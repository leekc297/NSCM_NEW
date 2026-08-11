# DMF0042 / DMF0044 / DMF0049 (+DMF0082 FE) — 클라우드 이관 적용 순서서 (2026-08-10 배치)

> ⭐ **2026-08-10 2차 갱신** — DMF0049 UI 보완 완료분 + `PKG_DMF0044` PRODUCT_DETAIL 정정 +
> 아이콘 버튼 순서 재정렬(hook #120 — **환율 → Column → Measure** 최종 확정)이 추가됐다.

> 2026-08-09~10 사내(OCGSCMD_P01) 적용·검증 완료분의 **증분** 3패키지를 한 배치로 이관한다.
> 구 순서서 `DMF0042_44_49_CLOUD_APPLY_ORDER_20260805.md` 의 **후속**이다 — 그 순서서 §1 1~9 가
> 적용된 상태를 전제로 하며, **§1 10번 항목은 본 순서서로 폐기·대체**된다(아래 §0).
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2 DB 동시 적용 의무** (`feedback_cloud_be_build_out_of_sync_diagnosis` §0)

---

## 0. 실행 금지 / 정본 확정

| 항목 | 판정 |
|---|---|
| `_apply_corporate/DMF0044_MERGE_ON_KEYS_FIX_20260805_PKG_BODY.sql` | ⛔ **실행 금지 (신규 판정)** — **AUTHUNION 적용 이전** BODY 기반(마커 0건, 9,750행). 실행하면 AUTHUNION 이 유실된다. 구 순서서 §1 **10번은 폐기**. 대체 = `DMF0044_20260810_0638/01_PKG_DMF0044_BODY.sql`(3건 누적 포함 9,759행) |
| `DMF0044_0049_PKG_FIX_20260730/02_DB_SP/*` | ⛔ 실행 금지 (구 판정 유지 — `DBWORK_7UI` BODY 가 superset) |
| `DBWORK_7UI_.../02_DB_SP/08·10·12` (0042/0044/0049 BODY) | ⚠️ **본 배치 적용 시 구본** — 반드시 본 배치의 `01_PKG_*_BODY.sql` 로 마무리할 것 |

---

## 1. 적용 순서 (DB — SCM_MGR)

| 순서 | 대상 | 비고 |
|---:|---|---|
| 0 | 구 순서서 §1 **1~9** 미적용분 | 본 배치는 **증분**. 각 패키지 `00_PRECHECK`/`90_VERIFY` [1] 로 전제 확인 |
| 1 | **클라우드 BE 정지** | library cache pin 방지. `ALTER SESSION SET DDL_LOCK_TIMEOUT = 120` |
| 2 | 각 패키지 원복본 SPOOL | `PKG_DMF0042/0044/0049` BODY 3본 (필수) |
| 3 | `DMF0044_20260810_0638/00_PRECHECK.sql` | 6항목 — 하나라도 어긋나면 **중단** |
| 4 | `DMF0044_20260810_0638/01_PKG_DMF0044_BODY.sql` | **9,767행** — AUTHUNION + MERGE ON 3키 + PIVOT SELECT 정정 + **PRODUCT_DETAIL NOT NULL 정정(3곳)** ⭐ 이게 없으면 DMF0049 SAVE 와 양 화면 TRANSFER 가 **100% 실패** |
| 5 | `DMF0044_20260810_0638/02_CMBO_ROW_COMBOS.sql` | 신규 CMBO 2종 (INSERT-only 멱등, 감사컬럼 `'admin'`) |
| 6 | `DMF0042_20260810_0638/01_PKG_DMF0042_BODY.sql` | 6,600행 — AUTHUNION |
| 7 | `DMF0049_20260810_0638/01_PKG_DMF0049_BODY.sql` | 1,201행 — AUTHUNION. ⛔ **반드시 DMF0044 이후**(SAVE 가 `PKG_DMF0044.P_DMF0044_MOBILE_REPORT_CREATE` 를 내부 호출) |
| 8 | **클라우드 BE 재기동** | |
| 9 | 각 패키지 `90_VERIFY.sql` ×3 | QA·DEV 각각 전 항목 기대값 일치 |
| 10 | FE 반영 (§2) | |
| 11 | 화면 E2E (§3) | 저장 SP **직접 실행 금지**(hook #104 — 클라우드는 화면 경유) |

---

## 2. FE 동시 이관

> 원칙: 파일 단위 덮어쓰기 금지 — **폴더 전체 교체** (`feedback_cloud_shell_generation_mismatch`).

| # | 대상 | 출처 | 비고 |
|---|---|---|---|
| F1 | `features/demand/src/pages/sales-reports/` (23파일) | `DMF0044_20260810_0638/fe/sales-reports/` | 셀 콤보 파라미터 + DEPT_ID cascade + **ETC SAVE 파리티 3건** + 단위테스트 27 |
| F2 | `features/demand/src/pages/business-plan/` (26파일) | `DMF0042_20260810_0638/fe/business-plan/` | 셀 콤보 파라미터 배선 |
| F3 | `features/demand/src/pages/etc-sales-reports/` (21파일) | `DMF0049_20260810_0638/fe/etc-sales-reports/` | 셀 콤보 파라미터 + sEditMeasure quoting + DEPT_ID cascade + 단위테스트 42 + **아이콘 순서** |
| F3b | `features/demand/src/pages/forecast-price/` (28파일) | `DMF0082_ICONORDER_20260810_0638/fe/forecast-price/` | **아이콘 순서만** (DB 변경 없음) |
| F4 | 공용 `features/demand/src/components/versionModal/` | — | **변경 없음**(구 순서서 F1 로 기적용 전제) |
| F5 | `configs/types/procedures.d.ts` · `public/locales/*.json` | — | **변경 없음**(구 순서서 F5·F6 소관) |

> ⭐ **아이콘 버튼 순서 (hook #120 최종 확정 2026-08-10)** — 4화면 전부 **환율 → Column Set → Measure** 로 정렬됐다.
> 검사: 각 화면 파일에서 `IcExchangeRate />` < `IcGridColumnSetup />` < `IcMeasureSelect />` 등장 라인 오름차순.
> DMF0020(2026-07-01 확정 순서)도 **본 룰과 일치**하므로 무변경 — 종전 '보류' 항목 해소.

검증: 클라우드 셸에서 `tsc --noEmit`(demand·web) 0 + eslint 0 → 화면 진입.
⚠️ **lint·type-check 는 사용자가 클라우드에서 실행**(로컬 실행 금지 룰).

---

## 3. 적용 후 E2E 최소 세트

- **DMF0044** ⭐ 최우선: 조회(40 DataType=2 / 82) 후 **동적 셀 `M_yyyymm` 값이 숫자**인지 확인.
  `"M_202501": "M_202501"` 처럼 컬럼명 문자열이 보이면 4번 적용이 잘못된 것 → **즉시 원복**.
  이어서 DEPT_ID 콤보 3분기(미입력/'기타'/부서 선택) · ETC 저장 왕복 · United Version · Exchange · Textbox(82).
- **DMF0042**: 조회(81/82/40) → `FCST_TYPE` 셀 콤보에 값이 보이는지 → 편집 잠금 스팟 → ColumnSet/Measure 저장 → 재조회.
- **DMF0049** ⭐: 조회 → **셀 콤보(BIZ_TYPE/ITEM_ID/ITEM_USE)에 값이 보이는지**(CODE raw 아님) →
  DEPT_ID cascade 3분기 → **저장(HTTP 200 · 오류 토스트 없음)** → **Insert/Delete(C 축 육안 필수)**.
- **DMF0044/0049 공통**: `unitedVersion` **TRANSFER 버튼** — 정정 전에는 ORA-01400 으로 항상 실패했다.
- **권한 회귀(3UI 공통)**: 관리자·DM Planner (W/S)·Viewer 3계정으로 편집 가능 범위가
  사내 실측과 동일한지 확인(AUTHUNION 과권한 0).

---

## 4. 사내 검증 근거

| 화면 | 게이트 | E2E |
|---|---|---|
| DMF0044 | 9섹션 **전 항목 PASS** (`DMF0044_20260810_0612.md`) | 15계정 **종합 PASS** (FAIL 0 / WARN 0) |
| DMF0042 | FAIL 0 (섹션 3·7 WARN 2 = 본 증분 이전부터의 기존 상태) | 15계정 **종합 PASS** (FAIL 0 / WARN 0) |
| DMF0049 | 게이트 **FAIL 0** (PASS 8 / WARN 1 — I/D 왕복 의도적 생략) | 15계정 **FAIL 0** (WARN 1) |

상세: `Doc/_archive/work_reports/2026-08-10_DMF0044_gate_closure.md` ·
`Doc/_archive/work_reports/2026-08-09_DMF0042_gate_closure.md`

---

## 5. 이월

- AUTHUNION 전사 미적용 잔여 **26 객체 + 혼재 1**. 최우선 4객체/2화면 =
  `PKG_DMF0020`+`DMF0020_GET_OWNER_DATA` × `PriceBatchInputModal.tsx` /
  `PKG_DMF0048`+`DMF0048_GET_DM_PLN_SALES_MONITORING` × `useSalesMonitoringStore.ts`.
  이 4건 해소 전까지 `GET_ADMIN_GROUP` 의 `minyonglee1|ALL` 테스트 행은 **제거 불가**.
- 타 UI staleness 경고(구 순서서 §1 말미) 유효: `PKG_DMF0003` / `PKG_DMF0021` / `PKG_DMF0082` 는
  `DBWORK_7UI` 판을 적용하면 구본으로 회귀한다 — 해당 UI 최신 패키지로 마무리할 것.
