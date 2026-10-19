# DMF0068 조회 SQL ERROR(ORA-01403 버전 미존재) 보완 — 클라우드 이관

> 마커 `[E20261009-VERNODATA]` — `SCM_MGR.PKG_DMF0068` PACKAGE BODY 1 객체 (SPEC 무변경)

| 항목 | 값 |
|---|---|
| 증상 | DMF0068 조회 시 `ORA-20001: [PKG_DMF0068.P_DMF0068_GET_ORDERLIST] SQLCODE=100 / SQLERRM=ORA-01403: no data found / … line 429 / P_VERSION_NO=R_S_20260902_V005` |
| 원인 | L429 `SELECT ORI_CUTOFF_VERSION_NO INTO V_ORI_VERSION_NO FROM DM_MDF_VERSION …` 가 없는 버전(F6 저장조건 복원 등)에서 NO_DATA_FOUND. AS-IS `SET @V = (SELECT TOP 1 …)` 는 NULL 로 넘어감 |
| 변경 | 그 SELECT 를 `BEGIN … EXCEPTION WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL; END;` 로 감쌈 (+7줄, SELECT 9줄 무변경). 없는 버전 = 오류 대신 PLAN 구간 0건(AS-IS 동일), 있는 버전 = 결과 동일 |
| 범위 | **DB 전용** — 데이터·메타·FE·BE 변경 없음. BE 재기동 불요 |
| 사내 적용 | **완료 · VALID** (ZIOUI1, 2026-10-09 14:37:46, 1483줄) — [APPLIED_OPERATIONS.md](../../_apply_corporate/DMF0068_VERNODATA_20261009/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 전제 | 클라우드 BODY 가 사내 변경 직전 판(2026-10-08 16:02, 1476줄, SUM(LENGTH)=68313)과 같을 것 — 00 PRECHECK 가 판정. 오류 메시지의 `line 429` 가 사내와 같아 동일 판일 가능성이 높다 |

## 실행 순서 (SCM_MGR, QA → DEV, 각 파일 전체 F5)

| # | 작업 | 파일 | 판정 |
|---|---|---|---|
| 1 | 선판정 | A_DB/00_PRECHECK_CLOUD.sql | H-APPLIED 0 · H-LINES 1476 · H-LEN 68313 · H-TARGET 1 · H-GUARD 0 이면 2~5 진행. H-APPLIED >0 이면 SKIP. H-LINES/H-LEN 이 다르면 10 대신 **12 수동 반영** |
| 2 | 보관 | A_DB/05_BACKUP_CLOUD_SOURCE.sql | `BAK_SRC_DMF0068_VERNODATA` 1476 lines |
| 3 | 적용 | A_DB/10_PKG_DMF0068_BODY.sql | 전체본 — 1 의 지문이 일치할 때만 |
| 4 | 컴파일·의존 | A_DB/13_RECOMPILE_DEPENDENTS.sql | VALID · all_errors 0행 |
| 5 | 검증 | A_DB/90_VERIFY.sql | V1 VALID · V2 3 · V3 1 · V4 1483 · V5 0 · V6 블록이 오류 없이 종료(DBMS_OUTPUT `V6 없는 버전 호출 OK — RESULT CODE=0`) |

판본이 다르면 [12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt) 의 diff(헤더 1줄 + L429 앞 3줄 + L437 뒤 3줄)를 수동 반영한 뒤 4~5.

롤백: A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql → 13. (사내에서 05→10→98→10 왕복 리허설 완료, 오류 0)

## 화면 확인
DMF0068 진입 → 저장조건에 남아 있던 버전으로 조회해도 SQL ERROR 없이 수주 목록이 나온다(계획 메저는 0). 버전 팝업에서 현재 버전을 다시 선택·저장(F6)하면 계획 값도 채워진다.
