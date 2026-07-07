# Hook — sp-hang-runaway-loop-diagnosis (SP hang·폭주 진단 + FETCH_STATUS 무한루프 + GTT TRUNCATE mutex) ⭐ 2026-07-08 신설

> **트리거**: "업로드/저장 무반응" / "OK 클릭 반응 없음" / BE 무응답 / SP hang / 세션 kill / ORA-00026 / ORA-01031 / library cache pin / `CREATE OR REPLACE` 가 안 끝남
> **사고**: DMF0014 Excel Upload Lock (2026-07-08) — 10건 업로드에 SP 가 영원히 실행. 원인 **2중**: ① GTT TRUNCATE(DDL) 동시세션 mutex 경합 ② `@@FETCH_STATUS` 변환 누락 무한루프. ①을 풀자 ②가 드러남 — **1건 fix 후 종료 금지** (anti-simplification).
> **상위**: `oracle-db-workflow.md` §3 (증상→원인) / 부록 C-2·C-10 (`db_migration/01` )

---

## §1 증상 3분류 (V$SESSION 먼저 — 추측 금지)

```sql
SELECT s.SID, s.SERIAL#, s.STATUS, s.LAST_CALL_ET, s.BLOCKING_SESSION,
       s.EVENT, SUBSTR(q.SQL_TEXT,1,60) SQLTXT
  FROM V$SESSION s LEFT JOIN V$SQL q ON s.SQL_ID = q.SQL_ID
 WHERE s.TYPE='USER' AND s.STATUS='ACTIVE' AND s.LAST_CALL_ET > 20
   AND s.EVENT NOT LIKE 'SQL*Net%';
```

| EVENT 패턴 | 분류 | 조치 |
|---|---|---|
| `library cache: mutex X` / `cursor: mutex X` / `row cache mutex` + SQL 이 `TRUNCATE TABLE GT_*` | **A. GTT DDL mutex 경합** | §2 |
| I/O·CPU 계열인데 `SECONDS_IN_WAIT` 계속 증가 + 동일 SQL_ID 고정 + V$SQL EXECUTIONS 폭증 | **B. 무한 루프 폭주** | §3 |
| `enq: TX - row lock contention` + `BLOCKING_SESSION` 有 | **C. 정상 락 대기** (블로커를 추적 — 블로커가 A/B 인 경우 다수) | 블로커 먼저 |

⚠️ **BE 로그 "파일 수신·파싱 정상" ≠ 업로드 정상** — 검증 SP 가 hang 이면 FE 는 영원히 무반응. FE/BE 를 의심하기 전에 위 SQL 1방 먼저.

## §2 GTT TRUNCATE(DDL) → mutex 경합 hang (부록 C-2 확장)

- SP 내부 `EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_X'` 는 **DDL** → 동시 세션이 같은 GTT 를 비우면 library cache/cursor/row cache **mutex 직렬화·경합** → 수 시간 hang (권한 문제 없어도 발생).
- ✅ 대상이 `ALL_TABLES.TEMPORARY='Y'`(세션전용 GTT) 임을 실측 후 **전량 `DELETE FROM GT_X;`(DML) 치환** — 기능 동등 + 경합 제거. 1곳만 고치고 종료 금지 (DMF0014 SP 는 8곳).
- 치환 검증: `DBA_SOURCE ... LIKE '%TRUNCATE TABLE%'` **잔존 0** + STATUS VALID.

## §3 `@@FETCH_STATUS` 변환 누락 → WHILE 무한 루프 (부록 C-10)

MSSQL `@@FETCH_STATUS` 는 FETCH 마다 **자동 갱신**. Oracle 변수로 옮기면 **수동 갱신 의무** — 누락 시:

```
V_FETCH_STATUS INTEGER := 0;          -- 선언만 있고
WHILE V_FETCH_STATUS = 0 LOOP ...     -- 재할당이 어디에도 없음 → 항상 참 → 무한 루프
```

- **컴파일 통과 + 소량 테스트도 통과처럼 보임** (행이 있으면 계속 돎) → 실행에서만 폭발. DMF0014: 10건 업로드에 내부 INSERT **12,786,821회** 실행 (V$SQL 실측).
- ✅ **모든 `FETCH cur INTO ...;` 직후** 등가문 의무:
  ```sql
  V_FETCH_STATUS := CASE WHEN CUR_X%NOTFOUND THEN 1 ELSE 0 END;
  ```
- ✅ 변환/리뷰 grep 게이트: `WHILE.*FETCH_STATUS` 존재 시 → **할당(`:=`) 수 = FETCH 수** (초기화 제외) 확인. 불일치 = 무한 루프 확정.
- 진단 확정법: `SELECT EXECUTIONS, ROWS_PROCESSED, BUFFER_GETS FROM V$SQL WHERE SQL_ID='...'` — **EXECUTIONS 가 입력 행수 대비 자릿수 단위로 크면** 루프 폭주 (EXECUTIONS≈ROWS_PROCESSED = row-by-row 루프 내 실행).

## §4 배포 차단 함정 — 멈춘 세션이 library cache pin 보유

- hang/폭주 세션이 SP 를 물고 있으면 `CREATE OR REPLACE` 가 **`library cache pin` 대기로 무한 hang** (배포 세션이 stuck 세션에 BLOCKING 당함). 배포 후 `LAST_DDL_TIME` 미변경 = 미반영 신호.
- ✅ 순서: **① stuck 세션 전수 식별 → ② DBA kill → ③ 재배포 → ④ VALID + 변경문 반영 실측**.
- ✅ **race 방지 기법**: kill 반복 경쟁 상황(요청이 계속 재유입)에서는 **배포를 먼저 백그라운드로 걸어 pin 대기열에 세운 뒤 kill** → kill 즉시 DDL 자동 완료.
- ⚠️ `SCM_MGR` 은 `ALTER SYSTEM KILL SESSION` 불가(**ORA-01031**) → DBA 실행. SERIAL# 은 **kill 직전 재조회** (stale 값 = **ORA-00026**).
- ⚠️ 구버전 SP 가 남아있는 동안 **사용자 재시도 금지 안내** — 시도마다 새 폭주 세션이 생겨 배포를 또 막는다.

## §5 자기 점검

```
✅ V$SESSION 분류(§1)로 시작했나? (FE/BE 추측 선행 금지)
✅ TRUNCATE GT_* 전량 치환 + 잔존 0 검증했나? (1곳 fix 후 종료 = 위반)
✅ WHILE ...FETCH_STATUS 패턴이면 할당 수 = FETCH 수 확인했나?
✅ 배포 후 LAST_DDL_TIME + 변경문(DELETE/CASE) 반영을 DBA_SOURCE 로 실측했나?
✅ 원본 백업 + 조치 SQL 을 _artifacts 이관 패키지에 보존했나? (04/05_SP_*.sql)
```

---

> Cross-ref: `oracle-db-workflow.md` §3 | `db_migration/01` 부록 C-2/C-10 | `sp-body-minimal-change.md` (최소 변경) | 메모리 `feedback_sp_gtt_truncate_mutex_contention`
> 사고 원본: `_artifacts/_deploy_packages/_dmf0014_artifacts/sql/04·05_SP_PR_DM_PLN_*.sql` + `_README.md §4`
