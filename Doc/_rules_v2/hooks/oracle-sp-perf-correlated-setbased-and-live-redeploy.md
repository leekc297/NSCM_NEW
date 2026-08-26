# hook: Oracle 조회 SP 성능 최적화(상관→set-based) + 라이브 PKG 재배포 운영

> 트리거: 조회 SP/PKG hang·스피너·느림 / 상관 UPDATE·DELETE·LATERAL / 라이브 PKG 재배포 / GTT 정밀도
> 계보: DMF0082 조회(P_DMF0082_GET_MAIN_DATA) + SavePricePeriod 최적화 (2026-07-13)
> 상위 진입: `oracle-db-workflow.md`, `feedback_sp_perf_tuning_methodology`, `sp-multiselect-filter-and-conversion-pitfalls.md`

---

## §A. 상관(correlated) → set-based 변환 — 조회 SP 성능 1순위 패턴

변환 SP 성능사고의 대표 원인은 **행별 상관 서브쿼리**다. 큰 중간결과에 행별로 재평가되어 O(n²)·PGA 폭증(`Free private memory to OS` 대기)·hang.

| 안티패턴 (변환 잔재) | 증상 | set-based 교체 |
|---|---|---|
| 상관 `UPDATE t SET c=(SELECT MAX.. WHERE 다중키=t.키 ..)` | 행별 재스캔, 넓은범위서 hang | **MERGE** + 사전집계(`SELECT 키, MAX(c) GROUP BY 키`) hash join |
| `LEFT JOIN LATERAL (SELECT.. ORDER BY d DESC FETCH FIRST 1) ON 1=1` | 행별 lateral(VW_LAT_+COUNT STOPKEY), MERGE JOIN OUTER 고비용 | **`LEFT JOIN (SELECT 키, MAX(d) d, MAX(v) KEEP (DENSE_RANK LAST ORDER BY d) v FROM src GROUP BY 키)`** — 최신 d와 짝 v 보존, 의미동일 |
| 상관 `IN (SELECT tok FROM TABLE(split(t.col)))` | decorrelate 카테시안 | 물리 GTT 사전실현 (→ `sp-multiselect-filter-and-conversion-pitfalls §B-1`) |

**의미보존 필수**: `MAX(v) KEEP (DENSE_RANK LAST ORDER BY d)` = 최신 d 행의 v (FETCH FIRST 1 등가). 소스가 이미 키별 1행이면 GROUP BY는 no-op(무해). 교체 후 **행수·주요값 불변 회귀검증**.

> ⚠️ diminishing returns 주의(§E): 상관 1곳 잡으면 다음 문장(DELETE/병렬INSERT)이 최대가 됨. **전체 문장 프로파일 후 우선순위**.

## §B. 진단 방법론 (문장별 귀속 = 정본)

1. `V$SQL` (PARSING_SCHEMA_NAME + SQL_TEXT LIKE, `elapsed_time/executions` per-exec) → **병목 문장 특정**. call_timeout 중단 후에도 누적치 잔존.
2. `DBMS_XPLAN.DISPLAY_CURSOR(sql_id,child,'BASIC +ROWS +COST')` → `MERGE JOIN OUTER`/`VW_LAT_`/`SORT UNIQUE`/카테시안 Rows 확인.
3. `DBMS_SQLTUNE.REPORT_SQL_MONITOR(sql_id)` → 바인드 전개 SQL + 연산별 실시간.
4. **hang 진단**: `V$SESSION` event=`Free private memory to OS`(PGA 폭증) / `latch: cache buffers chains` / blocking_session. `seconds_in_wait` 증가 = 진행중 상관쿼리.

## §C. 라이브 PKG/SP 재배포 운영 (사내 공유 DB)

- **`CREATE OR REPLACE PACKAGE BODY`는 라이브러리 캐시 배타락 필요** → **실행중 세션이 있으면 블로킹(ORA-04021/타임아웃)**. 조회가 느리면 세션이 오래 락을 잡아 재배포 불가.
- **SCM_MGR는 `ALTER SYSTEM KILL SESSION` 권한 없음(ORA-01031)** → DB 세션 직접 종료 불가.
  - 세션 = 로컬 BE의 JDBC(machine=사용자 PC, `JDBC Thin Client`). → **BE 프로세스 종료**(`Get-NetTCPConnection -LocalPort 8080 | Stop-Process`)로 전 세션 일괄 해제.
- **락 대기 재배포 기법**: `ALTER SESSION SET DDL_LOCK_TIMEOUT=280;` 후 재배포를 백그라운드로 띄우면, 세션 종료 즉시 락을 잡아 배포 완료. (사용자에게 "BE 종료 + 재조회 멈춤" 안내 → 즉시 배포)
- 재배포 전 **원본 백업**(`_backup/`), 후 **STATUS=VALID + errors=0 + 변경마커 grep + 행수 회귀** 검증.

### §C.1 ⛔ 배포 대기 중 "확인차 조회"를 하지 않는다 (2026-08-21 신설 — 사용자 지적)

> 사용자(2026-08-20): "**작업 진행 중인데 실행해보는 건 좋은 방법은 아니네요**.. 클라우드에서 계속 스피너 돌고 있습니다."

조회를 한 번 더 돌리면 **그 세션이 패키지를 새로 물어** 배포가 다시 무한 대기에 들어간다.
진행 상황이 궁금해서 재조회하는 행위가 **배포를 막는 원인 그 자체**가 된다.

**순서 (뒤집으면 영원히 안 끝난다)**
1. 배포를 **먼저** `DDL_LOCK_TIMEOUT` 걸어 대기열에 올린다 (백그라운드)
2. **그 다음** 물고 있는 세션을 해제한다 (BE 종료 / 사용자 조회 중단)
3. 배포 완료 확인 후에야 조회한다

절차 정본: `_artifacts/_deploy_packages/DMF0035_CLOUD_20260820/A_DB/97_REDEPLOY_LOCKED.sql`

⚠ 검증 스크립트도 같은 함정이다 — 대기 중인 배포가 있는 상태에서 무거운 진단 SQL 을 돌리면
그 세션이 다시 락 대기열에 끼어 **"검증이 끝나지 않는다"** 로 보인다(2026-08-20 실사고).

## §D. GTT/집계 NUMBER 정밀도 — 수량/금액 = `NUMBER(30,10)` 표준 (⭐ 2026-07-22 사용자 확정 룰)

- ⭐⭐ **수량(QTY)/금액(AMT)/율 파생 계열 컬럼의 GTT·중간테이블 SIZE 는 `NUMBER(30,10)` 로 지정한다. `NUMBER(20,10)` 신규 지정 금지.**
  (20,10) = 정수부 10자리 → 금액 10^10(약 백억) 이상 유입 시 즉시 ORA-01438. 실측: DMF0082 클라우드 61,840,867,037.6 (11자리) 사고.
- 소스 `NUMBER(30,10)` → 집계 대상 GTT `NUMBER(20,10)` 로 좁으면 큰 금액(≥10^10, MKT_AMT 등) 유입 시 **ORA-01438 → 조회 실패 → grid 전체 빈**(데이터 의존적, 간헐).
- 집계·PIVOT 경유 컬럼 폭은 **소스와 동일 이상**. `ALTER TABLE gtt MODIFY (col NUMBER(30,10))` (GTT는 타세션 사용 중이면 ORA-14450 → 유휴 재시도).
- ⭐ **이관 -955 skip 맹점 (2026-07-22 DMF0082 클라우드 사고)**: GTT DDL 을 "기존재 시 ORA-00955 skip" 멱등으로 이관하면, **대상 DB 에 구판(20,10) GTT 가 이미 있을 때 교정본(30,10)이 반영되지 않고 조용히 잔존** → 데이터 의존 ORA-01438 재발. 정밀도 교정이 포함된 이관에는 **DROP→재생성 REBUILD 파일**(`00A_GTT_REBUILD_<ID>.sql` — 미존재 -942 skip / 사용중 -14452 시 BE 재기동 안내) 동봉 + 배포 후 `all_tab_columns` 로 `data_precision=30` 검증 쿼리 명기. 정본: `_deploy_packages/DMF0082_20260722_1050/sp/00A_GTT_REBUILD_DMF0082.sql`.
- **PRE-WRITE grep 의무**: GTT/TABLE DDL 작성·이관 직전 `grep -nE "NUMBER\(20,10\)" <ddl>.sql` → 수량/금액 계열 검출 시 (30,10) 교정 후 진행.

## §E. 와이드 범위 = 큰 중간결과 = diminishing returns

- 미래/장기 범위는 **일자(daily) 버킷 중간결과를 거대하게** 만든 뒤 최종 grain(주/월)으로 collapse. 동일 출력행수라도 중간결과가 4~5배 → 파이프라인 전 문장이 비례해 느림.
- 개별 상관쿼리 최적화는 **whack-a-mole**(하나 잡으면 다음이 최대). 남은 무거운 문장(단순 DELETE/병렬INSERT)은 **안티패턴이 아니라 중간결과 크기 탓** → 더 손대면 diminishing returns + 고위험.
- **실효적 우선순위**: ① 상관쿼리 set-based 교체(고효과·저위험) → ② FE 기본 조회범위 축소(중간결과 축소, 저위험) → ③ 파이프라인 재설계(중간결과를 최종 grain으로, 필터를 INSERT 단계 선반영 — 고위험, 신중). 변동폭 큰 측정치는 **공유DB 경합** 포함 감안.

## §F. FE 연계 함정 (조회 화면)

- **BE boolean vs FE 문자열 'Y' 비교**: `GridColumn/GridMeasure` DTO는 `display/visible/personalizable`를 **boolean 직렬화**. FE가 `=== 'Y'` 로 비교하면 `true === 'Y'`=false → **전량 필터아웃(Visible 그리드 0개)**. FE 타입=boolean, 비교=truthy. (DataGrid는 `c.display` truthy라 OK, 개별 모달의 `=== 'Y'`가 사고.)
- **정적 컬럼은 division-반응형 메타 fetch**: `PR_GET_SHEET_COLUMN_LIST(userId,mnuId,sheetNm,divisionId)`가 division 필터. FE는 **현재 divisionId로 division 변경마다 재조회**. 하드코딩 FALLBACK 목록 의존 금지(division 무관 고정 사고).
- **컬럼 폭 0 = 숨김**: `colWth: c.colWth ?? 80` 에서 메타 WIDTH=0이면 `0 ?? 80`=0 → 폭0 컬럼 비표시. 메타 WIDTH 실측.
- **컬럼 순서 = titleset SORT_ORDER_NO(USER_SORT)**. 임의 상수 금지, SHEET_COLUMNS 설계값에 정렬(→ `feedback_no_arbitrary_meta_value_derive_from_authority`).

> 정본: `_artifacts/_apply_corporate/PKG_DMF0082_body_sheetname_FcstNPrice_20260713.sql` (MERGE+LATERAL set-based) / `DMF0082_MF_SP_QTY_precision_fix_20260713.sql` / `DMF0082_measure_titleset_sort_last_20260713.sql`
