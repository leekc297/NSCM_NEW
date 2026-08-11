# 카테고리 09 — SP·DB 변환·성능 / SP & DB Conversion, Performance

> **연다: 언제?** MSSQL→Oracle SP 변환/신규 SP/성능 튜닝/저장 로직을 다룰 때.
> **단일 진입점**: #30 `oracle-db-workflow` (작업 타입 8종 분기 + 증상→원인) 를 항상 먼저.

## A. 진입·작성 원칙
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 30 | [oracle-db-workflow](../hooks/oracle-db-workflow.md) | ⭐⭐ | **진입점** — SP/DB 작업 8타입 분기 + 증상→원인 매핑 |
| 55 | [sp-body-minimal-change](../hooks/sp-body-minimal-change.md) | ⭐ | SP body 원본 1바이트 임의 변경 금지 + 3축 검증 |
| 59 | [sp-no-fake-data-extraction](../hooks/sp-no-fake-data-extraction.md) | ⭐⭐ | 가짜 구현 18종 금지 — 실추출로만 |
| 56 | [sp-dual-cursor-pattern](../hooks/sp-dual-cursor-pattern.md) | ⭐ | GET SP = `O_RC`+`O_RESULT_CURSOR` dual OUT |
| 57 | [sp-exception-handler-debug-friendly](../hooks/sp-exception-handler-debug-friendly.md) | ⭐ | EXCEPTION OTHERS — 개발=SQLERRM 명시 |
| 62 | [sp-utl-call-stack-safety](../hooks/sp-utl-call-stack-safety.md) | ⭐ | UTL_CALL_STACK `.COUNT>=N` 안전체크 |
| 4 | [be-infrastructure-reuse](../hooks/be-infrastructure-reuse.md) | ⭐⭐ | 신규 BE 작성 전 동적 SP 인프라 재사용 검색 (BE Java 무변경 원칙) |

## B. MSSQL→Oracle 변환 함정 (조용히 틀리는 것들)
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 119 | [oracle-null-sentinel-and-notnull-default](../hooks/oracle-null-sentinel-and-notnull-default.md) | ⭐⭐ | `ISNULL(x,'')` 두 의도 모두 깨짐 — 센티널 `'-'` 통일 / JOIN=양변 NVL / NOT NULL INSERT 기본값 / DATE=SYSDATE |
| 118 | [mssql-ci-collation-parity](../hooks/mssql-ci-collation-parity.md) | ⭐⭐ | CI collation 등가 상실 — 리터럴 비교 `UPPER()` + 전 오브젝트 sweep / '.0' 사문 REPLACE=의도 복원 |
| 116 | [sp-parallel-dml-txn-guard](../hooks/sp-parallel-dml-txn-guard.md) | ⭐⭐ | 도입부 ALTER SESSION PARALLEL DML = 내부 호출 시 ORA-12841 → 허용 가드 |
| 61 | [sp-substr-zero-index-audit](../hooks/sp-substr-zero-index-audit.md) | ⭐ | `SUBSTR(s,0,n)`≡`(s,1,n)` 정규화 결함 audit |
| 32 | [pivot-dynamic-column-nvl](../hooks/pivot-dynamic-column-nvl.md) | ⭐⭐ | PIVOT 동적컬럼 NVL wrap (NULL 키 누락) |
| 110 | [sp-multiselect-filter-and-conversion-pitfalls](../hooks/sp-multiselect-filter-and-conversion-pitfalls.md) | ⭐⭐ | 멀티선택 필터=GTT+skip(`=''`는 전행 탈락) + 변환 3대 폭발(카테시안/조인키 부재/INSERT 오정렬) |
| 58 | [sp-json-table-array-pattern](../hooks/sp-json-table-array-pattern.md) | ⭐⭐ | SAVE SP `'$[*]'` + cursor + entry/HIST 동시 fix |
| 107 | [sp-hang-runaway-loop-diagnosis](../hooks/sp-hang-runaway-loop-diagnosis.md) | ⭐⭐ | GTT TRUNCATE mutex hang→DELETE / `@@FETCH_STATUS` 무한루프→`%NOTFOUND` 재할당 / pin=재배포 차단 |

## C. 성능
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 31 | [oracle-sp-perf-anti-patterns](../hooks/oracle-sp-perf-anti-patterns.md) | ⭐⭐ | 6 성능 룰 — REGEXP split JOIN/MASTER lookup/GT INDEX/SARGable |
| 111 | [oracle-sp-perf-correlated-setbased-and-live-redeploy](../hooks/oracle-sp-perf-correlated-setbased-and-live-redeploy.md) | ⭐⭐ | 상관쿼리→set-based(MERGE/KEEP DENSE_RANK/물리 GTT) + V$SQL 귀속 진단 + 라이브 재배포(BE 종료+DDL_LOCK_TIMEOUT) |
| 85 | [sp-inline-function-gtt-mandatory](../hooks/sp-inline-function-gtt-mandatory.md) | ⭐ | 행별 스칼라 함수 → GTT 사전 적재 |
| 106 | [oracle-bulk-clob-buffer](../hooks/oracle-bulk-clob-buffer.md) | ⭐⭐ | 대량 조회/저장 = CLOB 버퍼 (ORA-06502/40478) |

## D. 저장(SAVE)·계약
| # | Hook | 강도 | 계율 1줄 |
|---:|---|:--:|---|
| 99 | [oracle-save-payload-integrity](../hooks/oracle-save-payload-integrity.md) | ⭐⭐ | 편집='M'/신규='I' + dedup 키=SP GROUP BY 일치 + NOT NULL placeholder + 근본원인=BE 로그+USER_SOURCE |
| 104 | [sp-side-effect-test-gate](../hooks/sp-side-effect-test-gate.md) | ⭐⭐ | 저장 SP 임의 실행 전 3단 실측 — 메일·연쇄·본테이블 UPDATE = 임의 실행 금지 |
| 60 | [sp-patch-file-deploy](../hooks/sp-patch-file-deploy.md) | ⭐⭐ | patch 종결자 `END;`+별행 `/` + 의존순서 |
| 29 | [oracle-cmbo-varname-quote](../hooks/oracle-cmbo-varname-quote.md) | ⭐ | CMBO `@varName` TO_CHAR wrap |
| 80 | [sp-cursor-name-response-key](../hooks/sp-cursor-name-response-key.md) | ⭐⭐⭐ | cursor 이름 ↔ FE key fallback chain (카테고리 06 공유) |

## Cross-ref
- 파이프라인: `Doc/_analysis/db_migration/01`(변환 룰 + 부록 C 함정) + `02`(6-Stage) · 룰 32(Oracle 직결 도구)
- 메모리: `feedback_sp_*` 계열 다수 / `feedback_oracle_*` 계열 / `feedback_gtt_unprefixed_correlated_subquery_wipe` / `feedback_sp_empty_filter_null_like_join_wipe` / `feedback_ui_pkg_no_standalone_sp`(UI별 PKG 원칙)

- ⭐⭐⭐ **#127 `oracle-nvl-null-antipattern`** (2026-08-10) — `NVL(x, NULL)` 금지. 표현식 → `NVL(x,'-')` / 술어 → NVL 제거. 신규 변환 + **기 변환분 보완 시 PKG 단위 전량**. ORA-00979 실사고(DMF0044 Version Create). `hooks/oracle-nvl-null-antipattern.md`
- ⭐⭐⭐ **#128 `auth-by-userid-not-groupid`** (2026-08-10) — 권한 판정은 UI 가 넘긴 GROUP_ID 가 아니라 **USER_ID 로 `SCM_ADM_USER_GR_MPG_M` 을 조회한 보유 그룹 합집합**. `GET_ADMIN_GROUP` 룩업 단일 소스, 그룹명 하드코딩 금지. 검증 = 다중그룹·무권한 2축 실측. `hooks/auth-by-userid-not-groupid.md`
- ⭐⭐⭐ **#129 `oracle-perf-fix-priority-order`** (2026-08-10) — 속도 개선 순서 = **①SELECT 목록 함수 제거(JOIN 치환) ②인덱스 SARGable 구문 ③힌트**. 힌트 우선 금지, 보고는 3순위 각각. `hooks/oracle-perf-fix-priority-order.md`
- ⭐⭐⭐ **#131 `ui-save-idempotent-readback`** (2026-08-11) — **저장 멱등성**: PIVOT 조회 화면은 암묵 GROUP BY=SELECT 목록 전 컬럼 → 저장이 컬럼 하나만 원장과 다르게 써도 **유령 행**(행수 증가). 센티널은 **컬럼별 원장 분포로 결정**(`''`=Oracle NULL 방언·PROJECT_NAME 반례) / 마스터 덮어쓰기 파생컬럼(DEPT_NAME)은 원장 정규화 / PIVOT 표시값 되쓰기 금지(`modify_safe:False`). 완료 게이트 = **저장 전후 조회 행수 동일+식별자 중복 0 실측**. `hooks/ui-save-idempotent-readback.md`
