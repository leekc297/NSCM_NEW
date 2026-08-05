# GTT 프로그램ID 접두 재명명 — **실측 기반 플랜** (미적용 / 검토용)

> 요청: `GT_` / `GTT_` 로 시작하는 TEMP TABLE 을 `GT_{PROGRAM_ID}_` 형태로 변환 (예 DMF0020 → `GT_DMF0020_`)
> 목적(사용자): **동일 명칭 TEMP TABLE 을 여러 사용자가 동시 사용할 때 LOCK 최소화**
> 대상: DMF0020 / DMF0003 / DMF0021 / DMF0042 / DMF0044 / DMF0049 (+ DMF0082 현황 확인 요청)

---

## §1. ⚠️ 먼저 보고 — DMF0082 는 "적용 완료"가 아니라 **부분 적용**

`ALL_DEPENDENCIES` 실측 (PKG_DMF0082 가 참조하는 GTT **56종**):

| 구분 | 개수 | 예 |
|---|---:|---|
| ✅ `GT_DMF0082_*` 접두 적용 | **26** | `GT_DMF0082_MF_SP`, `GT_DMF0082_TEMP_SITE_ITEM`, `GT_DMF0082_T_VERSION` … |
| ⛔ **미적용** | **30** | `GTT_*` 21종(`GTT_MF_SP`, `GTT_TEMPSITEITEM`, `GTT_PLAN_DATA`, `GTT_SALES_SITE_MODEL` …) + `GT_PRDM1_*` 9종(`GT_PRDM1_T_MAIN`, `GT_PRDM1_T_FCST`, `GT_PRDM1_T_PRICE` …) |

→ **DMF0082 도 잔여 30종 작업이 필요합니다.** 특히 `GTT_MF_SP` ↔ `GT_DMF0082_MF_SP` 처럼
**구/신 이름이 동시에 존재**하는 케이스가 있어, 어느 쪽이 실사용 경로인지 확인이 필요합니다.

---

## §2. ⚠️ 핵심 사실 — GTT 는 이미 세션별로 격리되어 있습니다 (LOCK 원인 재확인)

`ALL_TABLES.DURATION` 실측: `SYS$SESSION` **1,988** / `SYS$TRANSACTION` **382** — 전 GTT 가 세션(또는 트랜잭션) 단위 격리.
즉 **여러 사용자가 같은 GTT 이름을 써도 데이터 락은 발생하지 않습니다.** 각 세션이 별도 temp segment 를 씁니다.

### 그럼 실제 경합 원인은 무엇인가 → **`TRUNCATE TABLE` (DDL)**
| 오브젝트 | `TRUNCATE TABLE` 잔존 |
|---|---:|
| `PKG_DMF0003` | **20** |
| `PKG_DMF0082` | **19** |
| `PKG_DMF0042` | **16** |
| `PKG_DMF0020` | **10** |
| `PKG_DMF0044` | **10** |
| `PKG_DMF0021` | **6** |
| **합계** | **81** |

이는 이미 사내 실사고로 룰화된 항목입니다 — **hook #107 `sp-hang-runaway-loop-diagnosis`**:
> "GTT `TRUNCATE`(DDL) 동시세션 **library cache·cursor·row cache mutex 경합 hang** → 전량 `DELETE FROM` 치환 + 잔존 0 검증"
> (DMF0014 Excel Upload 무반응 실사고. 메모리 `feedback_sp_gtt_truncate_mutex_contention`)

### 두 방안의 비교 (같은 목적, 비용·위험 차이 큼)

| | **방안 ①: `TRUNCATE` → `DELETE` 치환** | **방안 ②: GTT 접두 재명명** |
|---|---|---|
| 경합 해소 | **근본 해소** (DDL 자체 제거 → mutex 경합 소멸) | 완화 (경합 대상이 이름별로 분산) |
| 변경 규모 | **81 라인** (단순·기계적) | GTT **102종** + 소스 참조 **2,435 라인** + **신규 DDL 102본** + GRANT/SYNONYM |
| 위험 | 낮음 (`DELETE` 는 세션 데이터만 삭제 — GTT 라 동일 결과) | **높음** (§3 참조) |
| 선례 | 사내 실적 有 (DMF0014·DMF0082 일부) | 없음 (DMF0082 부분 적용이 유일, 미완) |
| 부수 효과 | ⚠️ 대량 행 시 `DELETE` 가 `TRUNCATE` 보다 느릴 수 있음 → 측정 필요 | 통계·커서 분산 |

> **권고: ①을 먼저 하고, 그 뒤 실측(V$SESSION event)으로 경합이 남는지 확인한 다음 ② 필요성을 판단**하는 순서가 비용·위험 대비 효과가 가장 큽니다. ②를 배제하는 것이 아니라 **순서**의 문제입니다.

---

## §3. 방안 ② 를 진행할 경우의 위험 4종 (실측 근거)

### R1. **동적 SQL 참조는 의존성 뷰로 안 잡힘** — 최대 위험
`ALL_DEPENDENCIES` 는 `EXECUTE IMMEDIATE` / `OPEN cur FOR V_SQL` 안의 테이블명을 **인식하지 못합니다.**
DMF0003·0082 는 동적 PIVOT SQL 을 대량 사용합니다(문자열 안에 GTT 명이 리터럴로 들어감).
→ 반드시 **소스 텍스트 전수 치환**이어야 하며, 의존성 기준만 쓰면 **런타임에서만 터지는 누락**이 남습니다.

**소스 텍스트 기준 참조 라인 실측 (총 2,435 라인)**
| 오브젝트 | GT_/GTT_ 참조 라인 |
|---|---:|
| `PKG_DMF0003` | 709 |
| `PKG_DMF0082` | 584 |
| `PKG_DMF0021` | 302 |
| `PKG_DMF0044` | 294 |
| `PKG_DMF0042` | 211 |
| `PKG_DMF0020` | 88 |
| `DMF0020_SAVE_..._POPUP` | 81 |
| `DMF0020_GET_SCM_MST_FUTURE_PRICE` | 77 |
| `PKG_DMF0049` | 51 |
| `DMF0020_SAVE_..._ALL` | 38 |

### R2. **공유 GTT 10종** — 한쪽만 바꾸면 데이터 전달이 끊김
| GTT | 사용 오브젝트 | 판정 |
|---|---|---|
| `GT_D000_RESULTS` | `PKG_DMF0000` + `DMF0000_SAVE_EXCHANGE_POPUP_DATA` + **`PKG_DMF0020`** | ⛔ **공용 환율 PKG 와 공유 → 재명명 시 별건 승인 필요** |
| `GT_F020_EXCEL_UPLOAD` / `_EXCH` / `_UPLOAD_MASTER_FINAL` / `_STEP1` / `_STEP2` / `_WITH_ITEM` | `PKG_DMF0020` + `DMF0020_EXCEL_UPLOAD` | ✅ 같은 화면 내 → 함께 바꾸면 안전 |
| `GT_F020_CFM_SELLING_PRICE_TEMP2` / `_FUTURE_PRICE_TEMP2` | `PKG_DMF0020` + `DMF0020_SAVE_..._CONVERSION` | ✅ 동일 |
| `GT_F020_EXCHANGE_RATE` | `PKG_DMF0020` + `DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL` | ✅ 동일 |

### R3. **이름 불일치로 데이터 전달이 no-op 되는 실사고 선례**
메모리 `feedback_div81_table_branch_conventions` 기록:
> `PR_DM_PLN_CFM_TO_MKT_FCST` 는 **`GT_PRDM_T_MAIN`**(무 '1') 을 읽는데 DMF0082 SAVE 는 **`GT_PRDM1_T_MAIN`** 에 적재
> → **별개 GTT = 40 전파가 사실상 no-op 인 잠재결함**

즉 **이름 한 글자 차이로 이미 기능이 죽어 있는 사례가 실존**합니다. 재명명은 이 유형의 결함을 대량 생산할 수 있습니다.

### R4. 부수 작업 (누락 시 -9994 / ORA-00942)
- **신규 GTT DDL 102본** 생성 (컬럼·타입·ON COMMIT 속성 원본 동일 복제)
- **GRANT + SYNONYM** (`SCMD_APP` — hook #44 `scmd-app-grant-mandatory`, 누락 시 `-9994`)
- 클라우드 이관 패키지 동봉 (룰 22)
- 구 GTT 정리 시점 판단 (다른 화면이 아직 쓰는지 재확인 후)

---

## §4. 방안 ② 진행 시 상세 플랜 (승인 시)

### Phase 0 — 원장 확보 (누락 0의 전제)
1. **소스 텍스트 전수 추출** — 6화면+0082 의 `GT_`/`GTT_` 토큰 전량 (정적 SQL + **동적 SQL 문자열 내부** + 주석 구분)
2. 토큰별 **실존 오브젝트 검증** (`ALL_TABLES.TEMPORARY='Y'`) — 오탐(변수명·컬럼명·주석) 배제
3. **소유 화면 판정** — 단독 사용(재명명 가능) / 화면 내 공유(함께) / **화면 간 공유(제외 또는 별건)**
4. GTT 별 **DDL 덤프**(컬럼·타입·`DURATION`) 확보

### Phase 1 — 신규 GTT DDL 생성 (멱등)
- `CREATE GLOBAL TEMPORARY TABLE GT_{PGM}_{원본명 접미} ... ON COMMIT {원본과 동일}`
- `-955`(이미 존재) skip 가드 + GRANT/SYNONYM 동반

### Phase 2 — 오브젝트별 소스 치환 (화면 1개씩)
- 토큰 경계 정확 치환(`\bGTT?_NAME\b`) — 부분 문자열 오치환 금지
- **주석 라인 보호** / **동적 SQL 문자열 내부도 치환**
- assert: 토큰별 기대 건수 · **라인수 불변** · 잔존 구명칭 0

### Phase 3 — 배포·검증 (오브젝트 단위)
- BE 정지 → `DDL_LOCK_TIMEOUT` → 배포 → `VALID`/`USER_ERRORS 0`
- **조회 회귀**(행수·result cursor 동일) — 동적 SQL 누락은 여기서만 드러남
- 저장은 화면 E2E 위임(hook #104)

### Phase 4 — 경합 실측 (효과 검증)
- 동시 세션 2+ 로 동일 화면 저장 → `V$SESSION` event / `V$SQL` 대기 비교 (전·후)
- **효과가 측정되지 않으면 잔여 화면 진행 중단** 판단

### 권장 순서
`DMF0049`(51라인, 최소) → `DMF0020`(4 오브젝트, 화면 내 공유 학습) → `DMF0021` → `DMF0042` → `DMF0044` → `DMF0003`(709) → `DMF0082 잔여 30종`

---

## §5. 확정 요청

| # | 항목 | 선택 |
|---:|---|---|
| **Q1** | 진행 방식 | **ⓐ 방안①(TRUNCATE→DELETE 81건) 먼저 + 경합 실측 후 ② 판단 (권장)** / ⓑ 방안② GTT 재명명 바로 진행 / ⓒ ①②동시 |
| **Q2** | `GT_D000_RESULTS`(공용 환율 PKG 공유) | 제외 / 별건 승인 후 포함 |
| **Q3** | DMF0082 잔여 30종 (`GTT_*` 21 + `GT_PRDM1_*` 9) | 이번 범위 포함 / 별건 |
| **Q4** | 구 GTT 오브젝트 | 유지(안전) / 전환 검증 후 DROP |
| **Q5** | 접미 명명 규칙 | `GT_DMF0020_` + **원본 접미 유지**(`GTT_MF_SP`→`GT_DMF0020_MF_SP`) / 별도 규칙 |

> ⚠️ 어느 방안이든 **동적 SQL 내부 문자열까지 소스 텍스트 전수 치환**이 필수입니다.
> 의존성 뷰(`ALL_DEPENDENCIES`)만 신뢰하면 DMF0003·0082 의 동적 PIVOT 경로에서 **런타임 `ORA-00942`** 가 남습니다.
