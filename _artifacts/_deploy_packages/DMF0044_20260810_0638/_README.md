# DMF0044 (Sales Reports / MDF Reports) 클라우드 이관 패키지 — 2026-08-10 06:38

> **목적**: 2026-08-09~10 사내(OCGSCMD_P01) 적용·검증 완료분의 **증분 이관**.
> **원천**: 사내 live 덤프(`PKG_DMF0044` BODY 2026-08-10 04:56 · `SCM_ADM_CMBO_SQL_M` 2026-08-09 21:07).
> **검증 상태**: 완료 게이트 9섹션 **전 항목 PASS** + 권한별 15계정 HTTP E2E **종합 PASS(FAIL 0/WARN 0)**.
> ⚠️ **클라우드 DB 적용물은 QA·DEV 2곳 동시 적용 의무** (`feedback_cloud_be_build_out_of_sync_diagnosis`)

---

## 0. 선행(PREREQ) — 미적용 시 본 패키지보다 먼저

본 패키지는 **증분**이다. 아래가 적용된 상태를 전제로 한다.

| 선행 | 내용 | 확인 |
|---|---|---|
| `DMF0042_44_49_CLOUD_APPLY_ORDER_20260805.md` §1 **1~9** | PKG 취합 3UI → `DBWORK_7UI` Step 3~8 → COMBO_ASIS_ALIGN | `00_PRECHECK.sql` [1][2][3] |
| 동 순서서 §2 **F1** 공용 `versionModal/` | 본 패키지 FE 는 이를 import 한다 | 클라우드 FE 경로 존재 확인 |

### ⛔ 실행 금지 (2026-08-10 갱신)

| 파일 | 사유 |
|---|---|
| `DMF0044_MERGE_ON_KEYS_FIX_20260805_PKG_BODY.sql` | **AUTHUNION 적용 이전** BODY 기반(마커 0건). 실행하면 AUTHUNION 이 유실된다. → 본 패키지 `01_PKG_DMF0044_BODY.sql` 이 MERGE ON 3키를 **이미 포함**한 최신 live 스냅샷이므로 그것만 쓴다. (구 순서서 §1 **10번 항목은 폐기**) |
| `DMF0044_0049_PKG_FIX_20260730/02_DB_SP/*` | 구 순서서 §0 판정 유지 — `DBWORK_7UI` BODY 가 superset |

---

## 1. 적용 순서

| # | 파일 | 내용 | 비고 |
|---:|---|---|---|
| 0 | `00_PRECHECK.sql` | 전제 6항목 — 한 항목이라도 어긋나면 **중단** | QA·DEV 각각 |
| 1 | (권장) 클라우드 BE 정지 | library cache pin 방지. `ALTER SESSION SET DDL_LOCK_TIMEOUT=120` | |
| 2 | `01_PKG_DMF0044_BODY.sql` | 사내 live BODY **9,767행** — AUTHUNION(08-09) + MERGE ON 3키(08-09) + **PIVOT SELECT 정정(08-10)** + **PRODUCT_DETAIL NOT NULL 정정(08-10, 3곳)** 누적 | SPEC 무변경(07-23 이후 동일) |
| 3 | `02_CMBO_ROW_COMBOS.sql` | 신규 CMBO 2종 — **INSERT-only 멱등(NOT EXISTS)**, 감사컬럼 `'admin'` | ⛔ MERGE INTO·DELETE 금지 (hook #98 §9) |
| 4 | 클라우드 BE 재기동 | | |
| 5 | `90_VERIFY.sql` | 10항목 — QA·DEV 각각 전 항목 기대값 일치 | §3 |
| 6 | `fe/sales-reports/` | FE 스냅샷 — **폴더 통째 교체** | §4 |

---

## 2. 변경 요약 (사내 검증 실측)

### ⭐ D-② 차단급 — 조회 PIVOT 셀 값이 컬럼명 문자열 (2026-08-10 신규 발견·정정)

`P_DMF0044_GET_SALES_REPORTS_DATA` 가 동적 셀 `M_yyyymm` 의 값으로 수량이 아니라
`"M_202501"` 같은 **컬럼명 문자열**을 반환했다. div=40 187행 / div=82 535행 — **전 행**.

원인 = 단일 변수 `V_PROD` 를 성격이 다른 두 자리에 재사용:

| 위치 | 필요한 형태 | 수정 전 |
|---|---|---|
| `PIVOT (SUM(QTY) FOR YYYYMM IN (…))` | 리터럴+별칭 `'M_202501' AS "M_202501"` | ✅ |
| 바깥 SELECT 목록 | 식별자만 `"M_202501"` | ⛔ 리터럴 → **상수 컬럼이 PIVOT 산출을 덮음** |

정본 = 자매 패키지 2본 모두 2변수 분리(`PKG_DMF0042` `v_Prod`/`v_Prod_in` · `PKG_DMF0049` `V_COLS`/`V_PROD`)
→ 동일 절차 계열인 **DMF0049 의 `V_COLS` 패턴을 그대로 이식**(신규 발명 0, +7행).

⚠️ **컴파일 VALID · 조회 HTTP 200 · 행수/컬럼수 정상**이라 정적 검증으로는 잡히지 않는다.
`90_VERIFY.sql` [4] + [10] 을 **반드시** 수행할 것.

적용 후 사내 실증: div40 첫행 `{'M_202507': 3.648, 'M_202508': 24.506408}` · 비0 수치셀 551 / div82 1,017.

### ⭐ 2026-08-10 추가 반영 — PRODUCT_DETAIL NOT NULL (DMF0049 E2E 로 발각)

`P_DMF0044_SALES_REPORT_PRODUCT_CREATE` / `..._DEPT_CREATE` 가 `DM_MOBILE_REPORT_*` 의 **NOT NULL** 컬럼에
`NVL(x,'')` · `ELSE ''` 로 값을 만든다. **Oracle 에서 `''` 는 NULL** 이라 ORA-01400 으로 항상 실패했다
(MSSQL 원문은 `''` 가 빈 문자열이라 통과). 실측: 원천 45,285행 중 **31,319행(69%)** 이 NULL 산출.

영향 = **DMF0044·DMF0049 양쪽의 `unitedVersion` TRANSFER 버튼** + DMF0049 SAVE(내부 호출).

정정 3곳(센티널 `'-'` — 같은 BODY L149·L677 이 이미 쓰는 값):
① `PRODUCT_CREATE` SELECT ② 동 **GROUP BY**(①만 고치면 ORA-00979) ③ `DEPT_CREATE` INSERT SELECT NOT NULL 5컬럼.
적용기 `diagnostics/dmf0044_product_detail_notnull_apply.py` (멱등 · SELECT↔GROUP BY 쌍 일치 단언).

**회귀 검증**: 본 변경 후 DMF0044 게이트 9/9 PASS + E2E 종합 PASS 재실행 확인
(`diagnostics/DMF0044_http_e2e_20260810_1003.md`).

### ⭐ 2026-08-10 (2차) — 그리드 헤더 1단 + Column Set 버튼 숨김 (FE 단독, 사용자 지시)

| # | 내용 | 근거 |
|---|---|---|
| H-1 | 동적 컬럼 헤더 **2단 → 1단 평면**, 라벨 `2025-01` | AS-IS `DMF0044_Sales_Reports.cs:235~236` = `iColumnHeaderRowCount = **1**` (2단 화면 DMF0072/0074 는 `2`) |
| H-2 | MergeManager **연도 가로 머지 제거** | 상위 헤더 행 자체가 없다 |
| H-3 | **Grid Column Set 버튼 숨김** | 사용자 지시. BTN_MPG 메타·모달·배선 **무변경**(FE 주석 블록으로 보존 — 되살릴 때 import 도 함께) |

> ⚠ 종전 2단은 **오구성**이었다 — SP 가 동적 컬럼의 LARGE/SMALL/COLUMN_LABEL_NAME 을 모두 `2025-01`
> 동일값으로 주어, 상위가 `2025`(연도)가 아니라 `2025-01` 이 되며 **1:1 그룹 12개**가 생겼다.
> DB 변경 없음 — `fe/sales-reports/` 폴더 교체만으로 반영된다.

### D-① MERGE ON 키 3개 파리티 복원 (2026-08-09)

AS-IS `DMF0044_SAVE_SALES_PLAN_REPORT_C` ON 절 19키 중 3키가 변환 시 누락 —
`DOM_EXP` / `FORECAST_INFO_CELL_MODEL`↔`CELL_MODEL_INFO` / `ATTRIBUTE3`↔`CELL_MODEL`.
영향 = QTY 오갱신 · ORA-30926. 센티널 정규화(hook #119 §1.5) 형태로 복원.

### AUTHUNION (2026-08-09)

편집 권한 판정을 **보유 그룹 합집합**으로 확장(2026-08-04 사용자 확정 정책).
사내 실측: `ADMIN` 유지 / `bpark416`(USER_ID 직전달) 0→1 해소 / W/S·Viewer 0→0 = **과권한 0**.

### 신규 CMBO 2종 — DEPT_ID cascade 이관 (2026-08-09)

AS-IS `.cs` 런타임 `SetCellTypeCombo` 3분기(L990 / L1180 / L1195)를 이관.
메타(SHEET_COLUMNS)에는 AS-IS 에도 이 컬럼이 없어, TO-BE 는 화면 단위로 원천 콤보를 받아
`beginningEdit` 에서 행 컨텍스트로 골라 스왑한다(hook #59 §5-G).

| SQL_ID | 원천 | 사내 행수 |
|---|---|---:|
| `DMF0044_DEPARTMENT_TEAM` | `SCM_MST_SSO_DEPT_INFO`(부모키 `UPPER_DEPT_ID` 동반) | 9,626 |
| `DMF0044_ETC_SALE_RESULT_TYPE_40` | lookup `DMF0044_ETC_SALE_RESULT_TYPE_40` VALID_YN='Y' | 1 |

> lookup 원본 9행 중 유효 1행('기타')뿐인 것이 **AS-IS 와 동일**하다(2026-08-10 AS-IS DB 직접 대조).

### FE — 셀 콤보 파라미터 + ETC SAVE 파리티

- 메타 셀 콤보에 `param1`(division)·`param2`(ATTRIBUTE1) 전달 + `comboSig` 에 division 포함
  (미포함 시 division 전환 후 행수가 같으면 이전 dataMap 잔존)
- ⭐ `buildEtcSaveRows` AS-IS 파리티 3건 정정(`.cs` SaveData L552~694):
  한 셀 변경 = **2 엔트리**(행 i / i+1 의 measure·수량) / `cellModelInfo`·`cellModel` = **행 i 의 동명 컬럼**
  (짝 행 MEASURE·수량 아님 — 틀리면 MERGE ON 3키가 어긋나 UPDATE 대신 중복 INSERT)

---

## 3. 검증 (`90_VERIFY.sql` — QA·DEV 각각)

| # | 항목 | 기대 |
|---|---|---|
| 1 | PKG 컴파일 | PACKAGE VALID / PACKAGE BODY VALID |
| 2 | 컴파일 에러 | 0행 |
| 3 | 적용 마커 4종 | AUTHUNION=1 / MERGE_ON=1 / PIVOTSEL=1 / **PRODUCTDETAIL=2** · BODY_LINES=**9,767** |
| 4 | ⭐ PIVOT 변수 분리 | IN_WITH_PROD=1 / SEL_WITH_COLS=1 / PROD_NON_IN=**1** |
| 4-1 | V_PROD·V_COLS 원문 | 선언 2 · 초기화 2 · 루프 축적 2 · RTRIM 2 · 바깥 SELECT=V_COLS 1 · PIVOT IN=V_PROD 1 |
| 5 | MERGE ON 센티널 키 | **5행**(선행 2 + 복원 3) |
| 6 | AUTHUNION 판정식 | 1행(`SCM_ADM_USER_GR_MPG_M` 서브쿼리 포함) |
| 7 | CMBO 2종 | 2행 · `CREATED_BY='admin'` |
| 8 | CMBO 실행 행수 | DEPT_TEAM=9,626 / ETC=1 |
| 9 | PROC_M(무변경 확인) | GET **11** / SAVE_C **22** / SAVE_C_CF **24** |
| 10 | ⭐ **화면 실증** | 조회 후 `M_yyyymm` 값이 **숫자**여야 함. `"M_202501": "M_202501"` 이면 즉시 원복 |

---

## 4. FE 스냅샷 (`fe/`)

| 경로 | 반영 위치 | 파일 |
|---|---|---:|
| `fe/sales-reports/` | `nscm-fe/features/demand/src/pages/sales-reports/` | 23 |

> ⚠️ **폴더 통째 교체 의무** — 파일 단위 덮어쓰기 금지 (`feedback_cloud_shell_generation_mismatch`).

이번 변경 파일(참고): `SalesReports.tsx` · `components/SalesReportsGrid.tsx` ·
`utils/sales-reports.{gridCombos,api,editLock,save,merge}.ts` · `SalesReportsUtils.test.ts`(신규 27 tests).
(2026-08-10 2차: 헤더 1단 전환 · Column Set 버튼 숨김 · 아이콘 순서 환율/컬럼/메저 포함)

- 전제: 공용 `features/demand/src/components/versionModal/` = 구 순서서 F1 로 기적용.
- ⚠️ **lint·type-check 는 클라우드 셸에서 사용자가 실행**(로컬 실행 금지 룰) — `tsc --noEmit`(demand·web) 0 / eslint 0 확인 후 화면 진입.

---

## 5. MSG / LBL / MNU / BTN·API 4분류 감사 (동봉 의무 — `feedback_deploy_package_msg_lbl_mnu_omission`)

| 분류 | 신규/변경 | 판정 근거 |
|---|---|---|
| MSG_M | **0** | 신규 메시지 없음. `MSG00429`(Department 필수) 등 전부 기존 키 재사용 |
| LBL_M / locales | **0** | 신규 라벨 없음(LBL00794~800·00844~851 은 2026-07-30 분 — 구 순서서 F6 소관) |
| MNU_M | **0** | 메뉴·라우팅 무변경 |
| BTN_MPG / API_M | **0** | SEARCH/SAVE/SAVE_CF 기존 배선 그대로 — PROC_M 시그니처 무변경 |
| CMBO | **2 (신규)** | `02_CMBO_ROW_COMBOS.sql` — §2 참조 |

> `SCM_ADM_LOOKUP_MASTER(_DETAIL)` 는 **무변경**(기존 이관분 그대로 사용). `00_PRECHECK` [3] 으로 존재만 확인한다.
> 사내 `GET_ADMIN_GROUP` 의 `minyonglee1|ALL` 행은 **테스트 행이므로 이관 대상 아님**.

---

## 6. 원복

1. 적용 전 `00_PRECHECK.sql` [6] 의 SPOOL 로 **BODY 원본 확보**(필수).
2. CMBO 는 신규 INSERT 뿐이므로 원복 = 해당 2행 DELETE.
   ```sql
   DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
    WHERE SQL_ID IN ('DMF0044_DEPARTMENT_TEAM','DMF0044_ETC_SALE_RESULT_TYPE_40');
   COMMIT;
   ```
3. FE 는 이전 커밋의 `sales-reports/` 폴더로 통째 되돌린다.

---

## 7. 근거 자료 (`diagnostics/`)

| 파일 | 내용 |
|---|---|
| `2026-08-10_DMF0044_gate_closure.md` | 종결 보고서(기준선→결과·결함·오탐·도구 회귀) |
| `DMF0044_20260810_0612.md` | 완료 게이트 9섹션 — **종합 PASS** |
| `DMF0044_http_e2e_20260810_0526.md` | 15계정 HTTP E2E — **종합 PASS(FAIL 0/WARN 0)** |
| `COMBO_CALLSITE_PARITY_DMF0044_20260810_0612.md` | 콤보 호출지점 대사 FAIL 0 / WARN 0 / PASS 6 |
| `dmf0044_pivot_select_apply.py` | PIVOT SELECT 적용기(dump/patch/deploy + 선행 마커 잔존 검증) |
| `dmf0044_merge_keys_apply.py` · `authunion_apply.py` | 각 증분 적용기 |
| `ui_gate_runner.py` · `ui_http_e2e.py` · `combo_callsite_parity.py` · `asis_mapping_gate.py` · `wiring_chain_check.py` | 게이트 도구 스냅샷(클라우드 적용 후 재검증용) |
