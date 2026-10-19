> ⛔ **2026-09-30 대체됨** — 누적본 [`DMF0082_QRYPERF_CLOUD_20260930`](../DMF0082_QRYPERF_CLOUD_20260930/00_README.md) 가 이 패키지 내용(SPEC·BODY·PROC_M)을 모두 포함한다. **클라우드에는 그 패키지만 적용**.

# DMF0082 화면 저장 — 대용량 한도 해제 + 저장 본체 트랜잭션 원자화 (클라우드 이관)

> 마커 `[E20260929-DMF0082SAVETXN]` · **rev2 `[E20260929-DMF0082SAVEPERF]`** (저장 파싱 루프 선형화 — BODY 만, 같은 11 파일에 포함)

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_SAVE_TXN_CLOUD_20260929` |
| ⚠ 중복 패키지 | [`DMF0082_SAVE_PERF_CLOUD_20260930`](../DMF0082_SAVE_PERF_CLOUD_20260930/00_README.md) 와 **내용 동일**(09-30 00:14 재추출본) — **둘 중 하나만 적용** |
| 대상 화면 | **DMF0082 — FCST & Price Mgmt** / [Save] (그리드 저장 · `FcstNPrice/SAVE/call-proc`) |
| 범위 | **DB 전용** — `PKG_DMF0082` SPEC · BODY + `SCM_ADM_PROC_M` 18행. FE / BE / API_M / BTN / 신규 MSG·LBL·MNU **없음** |
| 사내 적용 | **완료 · VALID · 오류 0** (222.110.191.243:2521/ZIOUI1 / SCM_MGR, SAVETXN 2026-09-29 20:54:14 · SAVEPERF 22:12:35) |
| 클라우드 | **미적용** · ⚠ **QA·DEV 2곳 모두 적용** |
| 원문 | 사내 USER_SOURCE 재추출 2026-09-29 22:13 (10·11 1행 `SOURCE-FRESH` · 24h 초과 시 `python _build.py` 로 재빌드 — FRESH-GATE 내장) |
| 선행 회차 포함 | `11_PKG_DMF0082_BODY.sql` 은 BODY 전체본 — 클라우드 미적용 상태일 수 있는 `DMF0082_XLSFORM_MEASURE_CLOUD_20260923` · `DMF0082_XLSUP_QTY_CLOUD_20260923` 의 **DB 변경분도 함께 반영**됨 (그 두 패키지의 A_DB 는 따로 적용할 필요 없음. XLSUP_QTY 의 **B_FE 는 별도**) |
| BE 재기동 | **불요** (PKG_DMF0082 무상태 — `[E20260901-STATELESS]` · PROC_M 은 BE 캐시 없음, 즉시 반영) |

---

## 1. 무엇이 바뀌나

**점검 결과 (사내 실측)**

| # | 항목 | 결과 |
|---|---|---|
| 1 | FE→BE→SP 전달 | 분할 없이 1회 호출 (`^` 로 이은 17개 파라미터) |
| 2 | 크기 한도 | SP IN 이 VARCHAR2 → **32,767B 초과 시 저장 전체 실패** (32,768B = ORA-06502 · 3,001행 = 바인드 실패). 실키 길이 기준 약 1,000~2,000건(행×일자) |
| 3 | 암묵 COMMIT | PRESERVE ROWS GTT 대상 `DBMS_STATS.GATHER/SET/DELETE_TABLE_STATS` · GTT `TRUNCATE` 모두 커밋 (LOCAL_TRANSACTION_ID 소멸 실측) |
| 4 | 부분저장 창 (40) | RMA→`RTF_SYS_RP` DELETE/INSERT 직후 GATHER 에서 확정 → 이후 판가·수요 런타임 오류 시 `RTF_SYS_RP` 변경만 남음 |

**변경 (`P_DMF0082_SAVE_MAIN_DATA` 한정)**

| 코드 | 내용 |
|---|---|
| SPEC/BODY | IN 17종 VARCHAR2 → **CLOB** (로그 요약 `SUBSTR` → `DBMS_LOB.SUBSTR`) |
| BODY | 첫 영구 DML 이후 `DBMS_STATS.GATHER_TABLE_STATS` 3건 제거 (GT_PRDM1_TEMP_EXCH 1 · GT_PRDM1_T_MAIN 2) |
| BODY | GTT 초기화 직후(영구 DML 이전) `DELETE_TABLE_STATS(GT_PRDM1_TEMP_EXCH)` — 세션 잔존 통계 제거 → `optimizer_dynamic_sampling=2`(기존 설정) 위임 |
| BODY | 40 경로 CFM→MKT_FCST 전파 호출 직전 **명시 COMMIT** — 저장 본체(RTF_SYS_RP·판가·수요·_H) 원자 확정 경계 |
| PROC_M | SAVE IN 17행 `DATA_TP_CD` VARCHAR → **CLOB** (BE `BaseService.makeProcedure` CLOB IN 바인딩 — 사내 191개 프로시저 선례) |

**rev2 — 저장 속도 [E20260929-DMF0082SAVEPERF]** (사내 32,240행 저장 863s 실측 분해 후 로직 낭비만 제거)

| 구간 (32,240행) | 소요 | 원인 (V$SQL·ASH) | 조치 |
|---|---:|---|---|
| '^' 파싱 루프 | 148s | 행마다 CLOB 17개 잔여 재할당(O(n²)) + 행마다 자율 트랜잭션 로그 | **위치 이동 파싱(f_next_token) + 요약 로그 1행** — GTT 벤치 189s → 8s, 적재 결과 17컬럼 동일 |
| 판가/수요 MERGE | 163s / 35s | 신규 행 INSERT 의 PK·IDX07 인덱스 갱신 (단일블록 읽기) | 없음 — 실변경분(값 동일 0건) |
| FUTURE_PRICE DELETE | 323s | 대상 행이 흩어진 테이블 블록 읽기 | 없음 — UPDATE 로 바꿔도 같은 블록을 읽음 |
| 매출계획 금액 PR | 160s | 공용 PR (배치·타 화면 9곳) | 범위 밖 |

차이 1건: 종전 파서는 끝 공백 토큰('AB ')에서 이후 토큰이 밀렸으나 신규는 정상 분리 — 실데이터 끝 공백 키 0건 확인.

**남은 한계 (미변경)**: 40 경로 2단계(전파 PR → 공용 `PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE`, 배치 JOB 공유)는 공용 PR 내부 DBMS_STATS 26회가 커밋하므로 원자 불가. 2단계 실패 시 본체는 저장된 상태로 오류 메시지 표시 — **종전과 동일**(종전에도 전파 PR 첫 TRUNCATE 에서 확정).

---

## 2. 작업 ↔ 파일 대조표 (적용 순서 · SCM_MGR 접속)

| 순서 | 파일 | 내용 | 전제 / 판정 |
|---|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | READ-ONLY 선판정 | 아래 판정표 |
| 2 | [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) | 클라우드 현 원문 → `BAK_SRC_DMF0082_SAVETXN` · PROC_M → `BAK_PROCM_DMF0082_SAVETXN` (비파괴 CTAS · 멱등) | CREATE TABLE 권한 |
| 3 | [A_DB/10_PKG_DMF0082_SPEC.sql](A_DB/10_PKG_DMF0082_SPEC.sql) | SPEC 전체 (SAVE 선언 CLOB) | [A] 0행 · [H1] BEFORE (AFTER 면 SKIP) |
| 4 | [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) | BODY 전체 (이번 변경 + 선행 09-22/09-23 회차) | [A] 0행 · [L] 0행 · [H2] ≠ UNKNOWN (AFTER 면 SKIP) · **3 과 반드시 함께** |
| 5 | [A_DB/20_SCM_ADM_PROC_M.sql](A_DB/20_SCM_ADM_PROC_M.sql) | PROC_M 18행 MERGE (IN 17 CLOB) · 멱등 | **3·4 이후** (순서 역전 시 BE CLOB 바인딩 ↔ SP VARCHAR2 구간 발생) |
| 6 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 VALID/ERR 0 · V2 지문 · V3 SP 인자 CLOB 17 · V4 PROC_M CLOB 17 · V5 원자성 정적 점검 · V6 GRANT | 조회 전용 · V1~V5 전부 PASS |
| 7 (선택) | [A_DB/91_SMOKE_BIG_PAYLOAD.sql](A_DB/91_SMOKE_BIG_PAYLOAD.sql) | 2,501행(ITEM 파라미터 약 40KB) 호출 → `RESULT_CODE=F`(복수 Division) 로 끝나면 PASS | **데이터 무변경** (영구 DML 전 종료) · 로그 약 2,500행 기록 |

롤백 전용 (평소 실행 안 함) — **순서: PROC_M → SPEC → BODY**
- [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) — 2번에서 보관한 **클라우드 고유 상태**(PROC_M + SPEC + BODY)로 복원 (권장)
- [A_DB/99_ROLLBACK_PROC_M.sql](A_DB/99_ROLLBACK_PROC_M.sql) → [A_DB/99_ROLLBACK_PKG_DMF0082_SPEC.sql](A_DB/99_ROLLBACK_PKG_DMF0082_SPEC.sql) → [A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql](A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql) — **사내** 이번 적용 직전본(09-23 XLSUPQTY 상태)

### PRECHECK 판정표

| 구획 | 기대 | 다르면 |
|---|---|---|
| `[A]` 의존 객체 136종 부재 | 0행 | **중단** — 부재 객체(GTT·테이블·PR) 선이관 필요 |
| `[A2]` 의존 객체 INVALID | 참고 | 4 적용 후 재컴파일 |
| `[L]` GTT 68본 통계 잠금 | 0행 | **중단** — 행마다 제시된 `UNLOCK_TABLE_STATS` 실행 후 진행 (잠금 시 저장 SP 의 DBMS_STATS 가 ORA-20005) |
| `[H1]` SPEC 지문 | `BEFORE` → 3 적용 | `AFTER` → SKIP · `⚠ UNKNOWN` → **중단**, 클라우드 SPEC diff 후 재병합 |
| `[H2]` BODY 지문 | 아래 라벨 → 4 적용 | `AFTER` → SKIP · `⚠ UNKNOWN` → **중단**, 클라우드 고유 변경 가능 |
| `[H3]` 마커 | 적용 전 0 | — |
| `[H4]` SP 인자 | 적용 전 VARCHAR2 17 | — |
| `[M]` PROC_M | 적용 전 IN 17 = VARCHAR · 18행 | 행 수가 다르면 5 가 MERGE 로 보정 |

`[H2]` BODY 지문 (USER_SOURCE LINE>1 의 행수, 문자합):

| 판정 | (행, 문자) | 상태 |
|---|---|---|
| `XLSFORM_ASIS_0921` | (16063, 821274) | 09-21 Excel Form AS-IS 파리티 (클라우드 DB 적용 보고분) = 09-22 TMAINFIX 직전 |
| `TMAINFIX_0922` | (16063, 821978) | 09-22 TMAINFIX |
| `MSGUNDERSCORE_0922` | (16064, 822001) | 09-22 MSG_UNDERSCORE |
| `XLSFORM_MEAS_0923` | (16070, 822585) | 09-23 XLSFORM measure |
| `XLSFORM_CURRENCY_0923` | (16070, 822931) | 09-23 CURRENCY |
| `XLSFORM_SORT_0923` | (16074, 823234) | 09-23 SORT |
| `XLSFORM_CURCHAIN_0923` | (16108, 825500) | 09-23 CURCHAIN |
| `XLSFORM_MEASUREOFF_0923` | (16110, 825764) | = `DMF0082_XLSFORM_MEASURE_CLOUD_20260923` 적용 상태 |
| `XLSUPQTY_0923` | (16147, 828780) | = `DMF0082_XLSUP_QTY_CLOUD_20260923` 적용 상태 = 사내 SAVETXN 직전 |
| `SAVETXN_0929` | (16157, 829856) | 이 패키지 1차(SAVETXN)만 적용된 상태 → 11 적용 (rev2 반영) |
| `AFTER` | (16162, 827568) | SAVETXN + SAVEPERF 적용 → SKIP |

`[H1]` SPEC: `BEFORE` (110, 7163) → 3 적용 / `AFTER` (111, 7173) → SKIP.

사내 실측 (적용 후 · 2026-09-29 22:13): `[A]` 0 · `[L]` 0 · `[H1]` AFTER · `[H2]` AFTER · V1~V5 PASS · V6 `SCMP_APP EXECUTE` · `RL_SCM_DML EXECUTE/DEBUG` · 20 MERGE 구문 확인(EXPLAIN PLAN).

---

## 3. 사내 검증 실측

| 항목 | 결과 |
|---|---|
| 컴파일 | SPEC/BODY VALID · USER_ERRORS 0 · 적용본 == DB 원문 · PKG_DMF0082 외부 의존 객체 0 |
| 적용 전 기준선 (3,001행) | 실패 (바인드 단계) |
| 원자성 정적 점검 (V5) | 첫 영구 DML L13361 ~ 1단계 COMMIT L14874 사이 COMMIT·DBMS_STATS·EXECUTE IMMEDIATE·TRUNCATE **0건** |
| CLOB 파싱 부하 (GTT 벤치) | 1,000행 0.3s · 3,000행 0.9s · 6,000행 2.4s |
| **적용 후 SP 실행 (91 스모크 · 실저장 재저장)** | **미실행** — 도구 권한 차단. 클라우드/사내 첫 실행 결과 확인 필요 |
| BE HTTP 경유 화면 저장 | 미실행 |

## 4. 적용 후 화면 확인 (클라우드)

1. DMF0082 조회 → 셀 1건 수정 → [Save] → 성공 토스트 · 재조회 값 반영 (소량 회귀)
2. 가능하면 기간·행을 넓혀 2,000건(행×일자) 이상 수정 후 [Save] → 종전 실패하던 규모가 저장되는지 확인
3. 오류 시 `SCM_SYS_LOG_BATCH` (PROGRAM_NAME='PKG_DMF0082', LOG_TYPE='ERROR') 의 SQL_ERR_MSG 공유

## 5. 주의

- **통계 방식 변경**: 저장 중 `GT_PRDM1_TEMP_EXCH` / `GT_PRDM1_T_MAIN`(후반부) 통계 수집을 동적 샘플링으로 대체했다. 대용량 저장에서 속도 변화가 보이면 공유 요망 (사내 실저장 시간 측정 미실시).
- **로그 증가**: 파싱 루프가 행마다 로그 1행(A00E)을 남기는 기존 동작은 그대로 — 대용량 저장 시 `SCM_SYS_LOG_BATCH` 행수 증가.
- **40 경로 2단계**(MKT_FCST 전파·밸런스) 원자성은 이번 범위 밖 (§1 남은 한계).

## 6. 사내 원복

```
cd _artifacts/_apply_corporate/DMF0082_SAVE_PERF_20260929 && python apply_saveperf.py restore   # rev2 만 되돌림 (먼저)`ncd _artifacts/_apply_corporate/DMF0082_SAVE_TXN_20260929  && python apply_savetxn.py restore    # SPEC·BODY·PROC_M 일괄 (SAVEPERF 원복 후)
```

## 7. 사내 실행 작업 ↔ 파일

| 사내 작업 (2026-09-29) | 스크립트 / 산출물 | 이 패키지 반영 |
|---|---|---|
| PKG_DMF0082 BODY SAVEPERF 적용 22:12:35 (파싱 선형화) | `_apply_corporate/DMF0082_SAVE_PERF_20260929/apply_saveperf.py` | 11 |
| 저장 소요 분해 (SCM_SYS_LOG_BATCH·V$SQL·ASH 조회) · 파서 OLD/NEW GTT 벤치(ROLLBACK) | scratchpad `save_timeline.py` · `parse_bench2.py` | — (영구 데이터 변경 없음) |
| PKG_DMF0082 SPEC·BODY SAVETXN 적용 20:54:14 | `_apply_corporate/DMF0082_SAVE_TXN_20260929/apply_savetxn.py` (01_APPLY) | 10 · 11 |
| SCM_ADM_PROC_M 17행 VARCHAR→CLOB (UPDATE · COMMIT) | 동일 (`01_APPLY/02_SCM_ADM_PROC_M.SAVETXN.sql`) | 20 (MERGE 로 일반화) |
| 암묵 COMMIT 실측 프로브 (GTT 1행 INSERT → DBMS_STATS/TRUNCATE → ROLLBACK·정리) | scratchpad `txn_probe*.py` | — (DDL·영구 데이터 변경 없음 · GTT 통계만 변동) |
| CLOB 파싱 벤치 (GTT INSERT → ROLLBACK·DELETE) | scratchpad `parse_bench.py` | — (영구 데이터 변경 없음) |
| 적용 전 기준선 호출 (3,001행 — 바인드 실패) | `_apply_corporate/.../test_savetxn.py big` | — (SP 미진입) |
| 권한·시노님 | 변경 없음 (CREATE OR REPLACE — 기존 GRANT 유지, V6 확인) | — |
