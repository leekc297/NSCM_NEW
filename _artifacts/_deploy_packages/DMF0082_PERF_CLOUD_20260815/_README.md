# DMF0082 조회 튜닝 — 클라우드 이관 (2026-08-15)

## 적용 순서

```
A_DB/00_PRECHECK.sql                     ← 먼저 실행. 의존 객체 누락 확인
A_DB/01_DDL_GT_DMF0082_PARAM_TOKEN.sql   ← 신설 GTT (이미 있으면 ORA-00955 → 무시)
A_DB/02_PKG_DMF0082_SPEC.sql
A_DB/03_PKG_DMF0082_BODY.sql
A_DB/90_VERIFY.sql                       ← 적용 후. 전 항목 확인
```

**FE/BE 변경 없음** — 이번 이관은 DB 단독이다.

## 변경 내용 (4건)

| 마커 | 조치 | 실측 효과 |
|---|---|---|
| `E20260815-PERF` | `TEMP_FCST_N_PRICE` INSERT — `T_WS_FCST` 조인 → **EXISTS 세미조인**(곱집합 14배 제거) + `LEADING(A) USE_HASH(B) USE_HASH(C)` | **170s → 1s** |
| `E20260815-PERF2` | `T_LAST_DATA_SETUP_PRICE` INSERT — `LEADING(A) USE_HASH(C)` | **14s → 소멸** |
| `E20260815-SENTINEL` | `PLANT_SITE_ID` 센티널 통일(`NULL`/`' '`/`'-'`/`'--'`/`CHR(0)` → `'-'`) + `ROW_NUMBER` dedup(QTY 최대) | **17,482 → 7,090행** |
| `E20260815-SPLIT2GTT` | `UF_FX_String_SplitForIN` **19곳** → `GT_DMF0082_PARAM_TOKEN` 선적재 치환 | 반복 파이프라인 호출 제거 |

## 근본 원인 (공통)

GTT(`GT_DMF0082_TEMP_SITE_ITEM`)는 세션 데이터라 통계가 없어 **추정 카디널리티가 1** 로 굳는다
(실제 14,879). 그 결과 옵티마이저가 GTT 들을 `MERGE JOIN CARTESIAN` 으로 묶어 대형 테이블
(`DM_PLN_CFM_SELLING_PRICE`, div40 103만행)을 **행별 인덱스 조회**했다.

```
buffer_gets 53,643,522 / 결과 0행 / 25분 경과 후에도 미완
ASH: ON CPU 100% → latch: cache buffers chains
```

인덱스는 이미 있었다(PK). 문제는 **그 인덱스를 5,364만 번 탄 것**이다.

## 성능 실측

| 시점 | SP | fetch | 결과 |
|---|---:|---:|---:|
| 튜닝 전 | 25분 미완(강제 종료) | — | — |
| 튜닝 후 | **12.9s** | **2.6s** | **7,090행** |

## ⚠ 적용 시 주의

1. **패키지 재컴파일은 조회 세션이 없을 때** — 실행 중이면 `library cache pin` 으로 대기하다
   `ORA-04021` 로 실패한다(사내 실사고). `DDL_LOCK_TIMEOUT` 을 넉넉히 주거나 조회 종료 후 적용.
2. **`GT_DMF0082_PARAM_TOKEN` 이 없으면 패키지가 컴파일되지 않는다** — 01 을 먼저 적용할 것.
3. 센티널 dedup 은 **QTY 최대 채택**(사용자 확정 B). 값이 같은 그룹(88%)은 원값 유지,
   다른 그룹(실측 16,395)만 최대값이 남는다. ⛔ SUM 은 채택하지 않았다 — 동일 복제본이 다수라
   합산하면 그만큼 값이 부풀어 오른다.

## 메타 이관 없음 (기계 확인)

`SCM_ADM_*` 전 테이블 × 문자형 컬럼을 `'DMF0082'` 로 스윕한 결과 13개 축이 존재하나,
**이번 변경은 SP 본문 단독**이라 메타 행은 바뀌지 않았다. 따라서 메타 INSERT/UPDATE 없음.

```
   SCM_ADM_API_M
   SCM_ADM_CMBO_SQL_M
   SCM_ADM_EXCEL_COLUMNS
   SCM_ADM_EXCEL_UPLOAD
   SCM_ADM_LOOKUP_MASTER_DETAIL
   SCM_ADM_MNU_BTN_MPG_M
   SCM_ADM_MNU_M
   SCM_ADM_MSG_M
   SCM_ADM_PROC_M
   SCM_ADM_PROC_M_BAK_20260612_153917
   SCM_ADM_PROGRAM
   SCM_ADM_USER_GR_MNU_BTN_MPG_M
   SCM_ADM_USER_GR_MNU_MPG_M
```

## 롤백

`99_ROLLBACK_안내.md` 참조. 적용 직전 **클라우드 본문을 먼저 백업**할 것.
