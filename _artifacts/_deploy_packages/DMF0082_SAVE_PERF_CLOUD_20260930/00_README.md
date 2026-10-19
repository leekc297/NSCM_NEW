> ⛔ **2026-09-30 대체됨** — 누적본 [`DMF0082_QRYPERF_CLOUD_20260930`](../DMF0082_QRYPERF_CLOUD_20260930/00_README.md) 가 이 패키지 내용(SPEC·BODY·PROC_M)을 모두 포함한다. **클라우드에는 그 패키지만 적용**.

# DMF0082 화면 저장 속도개선 (클라우드 이관)

> 마커 `[E20260929-DMF0082SAVEPERF]` (속도개선) · 선행 `[E20260929-DMF0082SAVETXN]` (IN CLOB · 원자화) 동봉

| 항목 | 값 |
|---|---|
| 패키지 | `DMF0082_SAVE_PERF_CLOUD_20260930` |
| 대상 화면 | **DMF0082 — FCST & Price Mgmt** / [Save] (`FcstNPrice/SAVE/call-proc`) |
| 범위 | **DB 전용** — `PKG_DMF0082` SPEC · BODY + `SCM_ADM_PROC_M` 18행. FE / BE / API_M / 신규 MSG·LBL·MNU **없음** · BE 재기동 **불요** |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1 / SCM_MGR — SAVETXN 2026-09-29 20:54:14 · SAVEPERF 22:12:35) |
| 클라우드 | **미적용** · ⚠ **QA·DEV 2곳 모두** |
| 원문 | 사내 USER_SOURCE 재추출 2026-09-30 00:14 (FRESH-GATE 통과 · 24h 초과 시 `python _build.py` 재빌드) |
| ⚠ 중복 패키지 | [`DMF0082_SAVE_TXN_CLOUD_20260929`](../DMF0082_SAVE_TXN_CLOUD_20260929/00_README.md) 와 **내용 동일**(같은 사내 상태에서 추출, 파일 머리 추출시각만 다름) — **둘 중 하나만 적용** |

## 1. 왜 SPEC·PROC_M 까지 함께인가

속도개선은 BODY 의 저장 SP 파싱부만 바꾸지만, 그 BODY 는 저장 SP 파라미터가 **CLOB** 인 상태(SAVETXN)를 전제로 한다.
클라우드가 아직 VARCHAR2 SPEC 이면 BODY 만 넣을 경우 컴파일 오류(SPEC·BODY 선언 불일치)가 나므로 **SPEC(10) · BODY(11) · PROC_M(20) 을 한 묶음**으로 싣는다.
이미 SAVETXN 이 들어간 클라우드라면 PRECHECK 가 SPEC 을 `AFTER`, BODY 를 `SAVETXN_0929` 로 판정한다 → **11 만 적용**, 10 SKIP, 20 은 멱등이라 재실행 무해.

## 2. 속도개선 내용 · 사내 실측

| 구간 (32,240건 대량 저장) | 개선 전 (09-29 21:37) | 개선 후 (09-30 00:00) | 사유 |
|---|---:|---:|---|
| `^` 파싱 루프 | 148초 | **6초** | **코드 개선** — 행마다 CLOB 17개 잔여 재할당(O(n²)) → 위치 이동(`f_next_token`) · 행별 로그(A00E) → 요약 1행 |
| 검증 | 13초 | 40초 | 무관 — L12502 판가 테이블 전체 읽기(27,471블록) 디스크 편차 |
| 판가 반영 | 163초 | 4초 | 코드 무변경 — 같은 키 재저장(행 모임·캐시) 효과 |
| FUTURE_PRICE 동기화 | 334초 | 4초 | 코드 무변경 — 같은 키 재저장 효과 |
| 매출계획 금액(공용 PR) | 161초 | 48초 | 코드 무변경 — 캐시 효과 |
| **합계** | **약 14.4분** | **약 1분 52초** | 코드 효과로 확정된 몫 = 파싱 약 142초 |

- 동일성: GTT 벤치 32,240행(빈 토큰 포함) 종전/신규 파서 적재 결과 17컬럼 완전 일치.
- 차이 1건: 종전 파서는 끝 공백 토큰(`'AB '`)에서 이후 값이 밀림 → 신규는 정상. 실데이터 끝 공백 키 0건 확인.
- 선행 SAVETXN 내용(IN 17종 CLOB 로 32,767B 한도 해제 · 영구 DML 이후 DBMS_STATS 제거로 저장 본체 원자화)은 [SAVE_TXN 패키지 README §1](../DMF0082_SAVE_TXN_CLOUD_20260929/00_README.md) 참조.
- 검토 후 **미적용**: FUTURE_PRICE DELETE 인덱스 경로 강제 — 현행이 GT 3만 건 이하에서 이미 PK NESTED LOOP 선택, 대량 시 강제해도 절감 ≤ 약 18초·캐시 상태에서 역효과 (실측).

## 3. 작업 ↔ 파일 대조표 (적용 순서 · SCM_MGR 접속)

| 순서 | 파일 | 내용 | 전제 / 판정 |
|---|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | READ-ONLY 선판정 | 아래 판정표 |
| 2 | [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) | 클라우드 현 원문 → `BAK_SRC_DMF0082_SAVEPERF` · PROC_M → `BAK_PROCM_DMF0082_SAVEPERF` (비파괴 · 멱등) | CREATE TABLE 권한 |
| 3 | [A_DB/10_PKG_DMF0082_SPEC.sql](A_DB/10_PKG_DMF0082_SPEC.sql) | SPEC 전체 (SAVE 선언 CLOB) | [H1] `BEFORE` → 적용 / `AFTER` → SKIP |
| 4 | [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) | BODY 전체 (속도개선 + SAVETXN + 선행 09-22/09-23 회차) | [A]·[L] 0행 · [H2] ≠ `UNKNOWN`·`AFTER` → 적용 |
| 5 | [A_DB/20_SCM_ADM_PROC_M.sql](A_DB/20_SCM_ADM_PROC_M.sql) | PROC_M 18행 MERGE (IN 17 CLOB) · 멱등 | **3·4 이후** |
| 6 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 VALID/ERR 0 · V2 지문 · V3 SP 인자 CLOB 17 · V4 PROC_M CLOB 17 · V5 원자성 · V6 GRANT | V1~V5 PASS |
| 7 (선택) | [A_DB/91_SMOKE_BIG_PAYLOAD.sql](A_DB/91_SMOKE_BIG_PAYLOAD.sql) | 2,501행(약 40KB) 호출 → `RESULT_CODE=F`(복수 Division) 면 PASS | 데이터 무변경 · 로그 1행 |

롤백 전용 — **순서: PROC_M → SPEC → BODY**
- [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) — 2번 보관 클라우드 고유 상태로 복원 (권장)
- [A_DB/99_ROLLBACK_PROC_M.sql](A_DB/99_ROLLBACK_PROC_M.sql) → [A_DB/99_ROLLBACK_PKG_DMF0082_SPEC.sql](A_DB/99_ROLLBACK_PKG_DMF0082_SPEC.sql) → [A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql](A_DB/99_ROLLBACK_PKG_DMF0082_BODY.sql) — 사내 09-23 XLSUPQTY 상태

### PRECHECK 판정표

| 구획 | 기대 | 다르면 |
|---|---|---|
| `[A]` 의존 객체 136종 부재 | 0행 | **중단** |
| `[L]` GTT 68본 통계 잠금 | 0행 | **중단** — 제시된 `UNLOCK_TABLE_STATS` 후 진행 |
| `[H1]` SPEC | `BEFORE` (110, 7163) → 3 적용 | `AFTER` (111, 7173) → SKIP · `⚠ UNKNOWN` → **중단**(diff) |
| `[H2]` BODY | 아래 라벨 → 4 적용 | `AFTER` → SKIP · `⚠ UNKNOWN` → **중단**(클라우드 고유 변경 가능) |

`[H2]` BODY 지문 (USER_SOURCE LINE>1 행수, 문자합):

| 판정 | (행, 문자) | 상태 |
|---|---|---|
| `XLSFORM_ASIS_0921` | (16063, 821274) | 09-21 Excel Form AS-IS 파리티 |
| `TMAINFIX_0922` | (16063, 821978) | 09-22 TMAINFIX |
| `MSGUNDERSCORE_0922` | (16064, 822001) | 09-22 MSG_UNDERSCORE |
| `XLSFORM_MEAS_0923` ~ `XLSFORM_CURCHAIN_0923` | (16070, 822585) · (16070, 822931) · (16074, 823234) · (16108, 825500) | 09-23 XLSFORM 중간 단계 |
| `XLSFORM_MEASUREOFF_0923` | (16110, 825764) | `DMF0082_XLSFORM_MEASURE_CLOUD_20260923` 적용 상태 |
| `XLSUPQTY_0923` | (16147, 828780) | `DMF0082_XLSUP_QTY_CLOUD_20260923` 적용 상태 |
| `SAVETXN_0929` | (16157, 829856) | SAVETXN 만 적용(1차 SAVE_TXN 패키지 초판) → **11 만 적용** |
| `AFTER` | (16162, 827568) | 적용 완료 → SKIP |

사내 실측(2026-09-30 00:14 · 읽기 전용): `[A]` 0 · `[L]` 0 · `[H1]` AFTER · `[H2]` AFTER · V1~V5 PASS · 20 MERGE 구문 확인(EXPLAIN PLAN).

## 4. 적용 후 화면 확인 (클라우드)

1. DMF0082 조회 → 셀 1건 수정 → [Save] → 성공 토스트·재조회 반영 (소량 회귀)
2. 대량(수천~수만 건) 수정 후 [Save] → 성공 · 소요 확인. 구간 소요는 `SCM_SYS_LOG_BATCH`(PROGRAM_NAME='PKG_DMF0082') 의 `A00D`→`A00E`(파싱) 간격으로 확인 가능
3. 오류 시 같은 로그의 LOG_TYPE='ERROR' SQL_ERR_MSG 공유

## 5. 사내 원복

```
cd _artifacts/_apply_corporate/DMF0082_SAVE_PERF_20260929 && python apply_saveperf.py restore   # 속도개선만 (먼저)
cd _artifacts/_apply_corporate/DMF0082_SAVE_TXN_20260929  && python apply_savetxn.py restore    # SPEC·BODY·PROC_M
```

## 6. 사내 실행 작업 ↔ 파일

| 사내 작업 | 스크립트 / 산출물 | 이 패키지 반영 |
|---|---|---|
| PKG_DMF0082 SPEC·BODY SAVETXN 적용 (09-29 20:54:14) | `_apply_corporate/DMF0082_SAVE_TXN_20260929/apply_savetxn.py` | 10 · 11 |
| SCM_ADM_PROC_M 17행 VARCHAR→CLOB (09-29 20:54) | 동일 (`01_APPLY/02_SCM_ADM_PROC_M.SAVETXN.sql`) | 20 (MERGE 일반화) |
| PKG_DMF0082 BODY SAVEPERF 적용 (09-29 22:12:35) | `_apply_corporate/DMF0082_SAVE_PERF_20260929/apply_saveperf.py` | 11 |
| 저장 소요 분해·계획 분석 (로그·V$SQL·ASH 조회) | scratchpad `save_timeline.py` 등 | — (조회) |
| 파서·FUTURE_PRICE DELETE 벤치 (GTT/DML → 매 회 ROLLBACK) | scratchpad `parse_bench2.py` · `fp_*_bench*.py` | — (영구 데이터 변경 없음) |
| 권한·시노님 | 변경 없음 (CREATE OR REPLACE — GRANT 유지, V6) | — |
