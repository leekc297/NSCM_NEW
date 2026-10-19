# DMF0082 FCST&Price — 81 계획구간 MKT FCST 금액(MKT_AMT_KRW / MKT_AMT_LOC) 조회 (DB 단, 클라우드 이관 · 누적본)

> 마커 `[E20261002-DMF0082-81MKTAMT]` — `PKG_DMF0082` BODY 조회 SP 2본 (`P_DMF0082_GET_MAIN_DATA` Current·MF·SF / `P_DMF0082_GET_MAIN_DATA_CURRENT`)

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0082` BODY 삽입 6곳(이력 주석 2 + 금액 조회 블록 4). 기존 문장 무수정. SPEC·FE·BE·메타·테이블 변경 없음 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-10-02 15:09:41, 기반 = FXZERO 누적본) — [`_apply_corporate/DMF0082_81MKTAMT_20261002/apply_81mktamt.py`](../../_apply_corporate/DMF0082_81MKTAMT_20261002/apply_81mktamt.py) |
| 클라우드 | **적용 완료** (사용자 확인 2026-10-02 — 수정본 전달 후 직접 이관, "클라우드에서 잘 보입니다") |
| 전제 | 클라우드 BODY = [`DMF0082_FXZERO_CLOUD_20260930`](../DMF0082_FXZERO_CLOUD_20260930/00_README.md) 적용본 (지문 `16390/847373`). PRECHECK `[H]` 로 판정 |
| BE 재기동 | 불요 |

## 1. 현상 · 원인 (사용자 지시 2026-10-02 "클라우드, DMF0082, 81 DIVISION — MKT_AMT_KRW, MKT_AMT_LOC 2개 메저의 데이터가 생성되고 조회되기를")

- 81 에서 MKT_AMT 메저를 선택해도 계획 구간이 빈칸. `PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_MKT_FCST_SAVE` 를 적용해도 동일.
- 원인: 동기화 SP 는 금액을 `DM_PLN_SALES_PLAN` 에 쓰는데 `PKG_DMF0082` 는 그 테이블을 읽지 않는다. 81 계획구간 원천 `DM_PLN_MKT_FCST` 에는 금액 행이 0건 (저장 SP 의 MKT_AMT 파생은 `v_is_81 = 'N'` 게이트 — AS-IS `DMF0082_SAVE_MAIN_DATA` 도 `@V_DIVISION_ID = '40'` 고정, 40 전용).
- 저장 시 `DM_PLN_MKT_FCST` 에 금액을 넣는 안은 **불가**: `DM_PLN_MKT_FCST.QTY NUMBER(20,10)` (정수부 10자리) < 81 금액 최대 13자리. 사내 실측 초과 KRW 1,823행(126키) / LOC 188행 → ORA-01438. (40 = `DM_PLN_CFM_MKT_DEMAND_PLAN.QTY NUMBER(25,10)`, Sales Plan = `NUMBER(30,10)`) → 사용자 확정 "1. 조회 SP 변경".

## 2. 변경 (12 파일 = 삽입 블록 전문)

81 수요 arm 바로 뒤에 금액 arm 을 추가한다 (`IF p_division_id LIKE '81%'` — 82 제외).

| 위치 | 원천 | 비고 |
|---|---|---|
| `P_DMF0082_GET_MAIN_DATA` Current | `DM_PLN_SALES_PLAN` | 기간·SITE_ITEM·WS FCST_TYPE 게이트 = 81 수요 arm 동일 |
| `P_DMF0082_GET_MAIN_DATA` MF / SF | `DM_PLN_SALES_PLAN_C` | 버전 매핑 = 같은 블록 실적 금액 arm 과 동일(선택 버전과 같은 주의 SP 버전 `SP_VERSION_NO`) |
| `P_DMF0082_GET_MAIN_DATA_CURRENT` | `DM_PLN_SALES_PLAN` | |

- 셀생산지는 81 규약 `'-'` 로 합산, CURRENCY 는 수요 arm 과 같은 표기(하단 통화 보완이 LOC 통화로 채움), `QTY <> 0`.
- **사용자가 금액 메저를 선택한 경우만** 적재 — 강제 포함(`DM_ADMIN`)분은 실적 Unit Price 계산 전용이라 제외.
- 계획 구간(당주 월요일 이후)만. 실적 구간 금액은 기존 arm(`DM_PLN_SALES_PLAN_RESULT`) 그대로.

## 3. 사내 검증

| 항목 | 결과 |
|---|---|
| 원천 값 | 81 계획구간 `DM_PLN_SALES_PLAN` MKT_AMT_LOC vs `MKT_FCST × LOC 판가` 9,391행 — 일치 9,391 / 차이 0 / 누락 0 / 초과 0 |
| 사전 컴파일 | 임시 복제 패키지 `PKG_DMF0082_T81` VALID · 오류 0 → 81 조회 금액 행 0 → 262 확인 후 DROP |
| 적용 | FRESH-GATE 통과 · VALID · 오류 0 · 적용본 == DB 원문 · 의존 INVALID 0 · `SCMP_APP` EXECUTE 유지 |
| 전후 대조 (11 케이스 · 전 커서 전 행) | **예상 밖 변경 0** — 40·82·금액 미선택 사용자 전 커서 동일 / 81 금액 선택 사용자만 RC1 에 금액 행 추가 |

전후 대조 상세 (`v01_equiv.py diff before after`):

| 케이스 | RC1 행 | 변화 |
|---|---|---|
| MAIN / minyonglee1 / 40·81 | 2,099 · 2,383 | 동일 |
| MAIN / k0101 / 81 (9메저, 금액 미선택) | 7,648 | 동일 |
| MAIN / eunah.koo / 40 · 82 | 3,721 · 2,894 | 동일 |
| MAIN / eunah.koo / 81 | 2,772 → 3,034 | MKT_AMT_KRW +131 · MKT_AMT_LOC +131 |
| MAIN / eunah.koo / 81_UC | 74 → 80 | +3 · +3 |
| MAIN / yooah.chung / 81 (KRW 금액만 선택) | 5,072 → 5,203 | MKT_AMT_KRW +131 |
| MAIN / eunah.koo / 81 / MF_W_20260930_V001 | 622 → 884 | +131 · +131 |
| CURRENT / eunah.koo / 40 | 7,626 | 동일 |
| CURRENT / eunah.koo / 81 | 0 | 동일 (이 사용자·조건에서 본문 0행 — 금액 arm 미실행 경로) |

⚠ `P_DMF0082_GET_MAIN_DATA_CURRENT` 의 81 금액 블록은 컴파일만 검증됐고 데이터로는 실행 확인하지 못했다(위 케이스가 본문 0행).

## 4. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — `[H]` BODY 지문 `적용`(16390/847373) / `SKIP`(16662/864802) / `⚠` → §5 · `[D1]` 원천 금액 행 · `[D2]` 메저 메타 · `[D3]` 선택 사용자 · `[D4]` 동기화 SP 81 분기
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 SPEC+BODY → `BAK_SRC_DMF0082_81MKTAMT`
3. [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) — BODY 전체본 (사내 15:09:41 원문, FXZERO 까지의 09-30 회차 누적)
4. [A_DB/13_RECOMPILE_DEPENDENTS.sql](A_DB/13_RECOMPILE_DEPENDENTS.sql) — 의존 INVALID 재컴파일 안전망 (사내 의존 0)
5. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID / V2 금액 블록 4 · 원천 읽기 4 / V3 GRANT / V4 의존 INVALID 0 (사내 실행 전부 PASS)

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) → 13

## 5. 지문이 다르면 수동 반영

[A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql): 6개 삽입분. 각 `-- L##### 앞에 삽입 (다음 줄 원문: …)` 의 줄 번호는 사내 기준이므로 **다음 줄 원문**으로 위치를 찾는다.

## 6. 값이 안 보일 때

- `[D1]` 이 0 이면 표시할 값이 없다 — 저장한 키만 동기화 SP 가 채우고, 나머지는 야간 배치(`PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW`)가 돌아야 생긴다.
- `[D2]` 메저 메타 `DIVISION_ID` 에 81 계열이 없으면 화면 선택 목록에 안 나온다. **사내는 아직 `'40'` 단독** (메타 미변경 — 사용자 결정 대기).
- `[D4]` 가 0 이면 저장 직후 갱신이 안 된다 → `DMF0082_81SALESPLAN_CLOUD_20260930` 선행.

## 7. 잔여

- DMF0003(수량)·DMF0020(판가) 저장도 같은 `DM_PLN_SALES_PLAN` 을 갱신하므로 별도 조치 불요.
- 사내 메저 메타(DMF0082 MKT_AMT) 81 확장 — 미결.
