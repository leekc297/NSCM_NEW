# DMF0082 CUST_FCST 하위 'Customer FCST' → ' └ EXCEL' 표기 (AS-IS 로직 이식) + 81/82 조회 타임아웃 해소 누적본 (클라우드 이관)

> 마커 `[E20260930-DMF0082CUSTEXCEL]` (+ 누적 `[E20260930-DMF0082ONEREAD]`) — `P_DMF0082_GET_MAIN_DATA` (화면 [Search])

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0082` BODY 1본 (누적). SPEC·PROC_M·FE·BE·콤보·메타 변경 없음 · 힌트 추가 0 |
| 누적 내용 | ① 81SALESPLAN(12:07) ② 타 작업자 AJS 09-30 사용자테이블 수정(15:46, `TB_FX_USER`→`SCM_ADM_USER_M`) ③ ONEREAD(15:48) ④ CUSTEXCEL(17:18) |
| 전제 | 클라우드 BODY 가 ①·①+②·③ 중 어느 상태든 PRECHECK `[H]` 가 `적용` 판정 · 공용 SP 81SP 적용본(`886/59771`) |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 17:18:49) — [`_apply_corporate/DMF0082_CUSTEXCEL_20260930`](../../_apply_corporate/DMF0082_CUSTEXCEL_20260930/apply_custexcel.py) (교체 6줄, [`_diff_preview.txt`](../../_apply_corporate/DMF0082_CUSTEXCEL_20260930/_diff_preview.txt)) |
| 클라우드 | **미적용** · ⚠ **QA · DEV 2곳 모두** |
| BE 재기동 | 불요 |

## 1. CUSTEXCEL — 원인과 조치 (AS-IS 1:1, 강제 치환 아님)

**증상:** DMF0014 Excel Upload 한 Customer FCST 가 DMF0082 CUST_FCST 하위에 ` └ EXCEL` 이 아니라 원장 값 `Customer FCST` 그대로 표기.

**AS-IS (살아있는 AS-IS DB 원문 확인):** `DMF0003_GET_MKT_FCST_DATA` Block 1-C [E20241126-000426] — 원장 `MEASURE='Customer FCST'` 행을 **수정자(LAST_UPDATED_BY)가 `%robot` 이면 `Cust.FCST_RPA[P+P]`, 아니면 `Cust.FCST_EXCEL[P+P]`** 로 내보내고, 공용 콤보 `Measure` 가 그 코드를 ` └ RPA` / ` └ EXCEL` 로 표시. AS-IS 원장 실측: 81 `Customer FCST` 6,082행 중 robot 1,739 / 사용자 업로드 4,343. TO-BE `PKG_DMF0003` L7474(계획)·L8225(실적)는 동일 이식되어 있었고, **DMF0082 만 08-25 CUSTSUB 이식 시 이 분기가 빠져** 있었다. 콤보는 DMF0082 에 대해 `Customer FCST` 코드를 매핑하지 않아(DMF0003/0035 한정) 코드 문자열이 그대로 보였다.

**조치 (교체 6줄):**

| 위치 | 변경 | 근거 |
|---|---|---|
| Current 계획 arm 81/82 (`DM_PLN_MKT_FCST`) L1415·L1459 | MEASURE = AS-IS CASE(수정자 robot 여부) · LAST_UPDATED_BY = 수정자 `_RPA`/`_EXCEL` 접미사 (그 외 행 기존 LD 값) | AS-IS Block 1-C |
| Current 계획 arm 40 (`DM_PLN_CFM_MKT_DEMAND_PLAN`) L1518·L1562 | 동일 | AS-IS Block 1-C (division 무관) |
| Current 실적 arm 종속메저 (`DM_PLN_MKT_FCST_RESULT`) L2034·L2078 | MEASURE = 동일 CASE(LAST_UPDATED_BY 기준) · LAST_UPDATED_BY = CREATED_BY 접미사 (그 외 행 기존 NULL) | TO-BE `PKG_DMF0003` R-3 L8225~8257 |

- 비교는 `UPPER(MEASURE) = 'CUSTOMER FCST'` — AS-IS MSSQL 의 대소문자 무시 비교와 등가 (사내 마스터 `DM_MST_CUSTOMER_FCST` 에 `Customer Fcst` 296행 실존 — 사용자 지적 반영).
- Cutoff(`_C`) arm 은 AS-IS 도 분기하지 않아 무변경. 하류 메저 조인(L3931·L4034)은 편집권한 판정용이라 행이 걸러지지 않음 (변환 행 = 조회 전용, AS-IS 동일).

**사내 검증:** 아래 §4.

## 2. ONEREAD — 81/82 조회 타임아웃 (클라우드 C07 실측 15:15)

- 타임아웃 조회 SP 1,009초 중 `3d2xnx839ksnt`(81/82 최신 판가 키 적재) 1,000초(99%) · CPU · 1회 버퍼읽기 4,100만. 계획 = GTT 1행 추정 NL → 행마다 `IDX02` 날짜범위 재스캔.
- 원인 = 09-30 QRYPERF 에서 넣은 `INDEX(A IDX02_SCM_MST_FUTURE_PRICE)` 힌트 2곳 (1~4순위 검토 없이 삽입) + 같은 판가 원장(1.4GB)을 두 번 읽는 구조.
- 조치 = 판가 원장 1회 읽기(윈도 MAX)로 통합 · **IDX02 힌트 2곳 철회(사용자 지시)**. 상세: [`DMF0082_ONEREAD_CLOUD_20260930/00_README.md`](../DMF0082_ONEREAD_CLOUD_20260930/00_README.md) (그 패키지는 본 패키지로 **대체** — 적용하지 말 것).
- ⚠ 사내에서 통합 문장은 PK 인덱스 경유 랜덤읽기로 1회 약 186초 (타임아웃은 아님). 클라우드(Exadata) 소요는 적용 후 C05/C07 실측 필요.

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY. `[H]` BODY **`적용`**(또는 SKIP) · 공용 SP **`PASS`** / `[U]` 3행 PASS / `[C]` PASS. `⚠ 중단` 이면 결과 회신
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 BODY → `BAK_SRC_DMF0082_CUSTEXCEL` (비파괴 · 멱등)
3. [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) — BODY 전체본 (`SHOW ERRORS` 0)
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID·오류 0 / V2 지문 `16375/843903`·마커 CUSTEXCEL 6·ONEREAD 3·활성 IDX02 0 / V3 GRANT
5. 화면: 81 에서 CUST_FCST 선택 후 Search → DMF0014 업로드 건이 ` └ EXCEL` 로, RPA 건이 ` └ RPA` 로 표기되는지 · 81/82 조회가 타임아웃 없이 끝나는지 확인

롤백 (평소 실행 안 함): [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 4. 사내 검증 (2026-09-30)

- PRECHECK / VERIFY 를 사내에서 읽기전용 실행: `[H]` SKIP(=사내 최종본) · `[U]` 3 PASS · `[C]` PASS · V1~V3 PASS.
- 콤보 `Measure`(DMF0082/FcstNPrice) 실행: `Cust.FCST_EXCEL[P+P]` → `' └ EXCEL'` · `Cust.FCST_RPA[P+P]` → `' └ RPA'` 매핑 확인.
- 81/k0101 조회 실행 후 스테이징 GTT·결과 커서의 메저 분포 — 결과는 본 README 하단 "검증 결과" 갱신 예정.

## 5. 유의

- **AJS 09-30 수정 동봉** — 사용자 지시(원복 계획 없음·무시)에 따라 BODY 에 그대로 실린다. `[U]` 는 그 참조 컬럼 존재 확인.
- 남은 힌트 2곳(09-30 CLOUDPERF `2nysu9tbng9v4` L1943 · `7mrzdbpupw3b9` L1229)은 이번 범위 밖 — 근본원인 재검토 후 철회 여부 사용자 결정 대기.
