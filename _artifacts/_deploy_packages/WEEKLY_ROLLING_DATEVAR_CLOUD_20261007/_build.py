"""클라우드 이관 패키지 생성 — [E20261007-DATEVAR] PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING 날짜 경계 변수화 (DB 전용, 1 객체)
사내 적용본(_apply_corporate/WEEKLY_ROLLING_DATEVAR_20261007/01_*.sql) + 변경 전 원문(00_BACKUP) 으로 생성.
"""
import os, re, difflib, hashlib, json, datetime
HERE = os.path.dirname(os.path.abspath(__file__))
SRC = r"C:\Projects\NSCM\_artifacts\_apply_corporate\WEEKLY_ROLLING_DATEVAR_20261007"
A = os.path.join(HERE, "A_DB"); os.makedirs(A, exist_ok=True)
before = open(os.path.join(SRC, "00_BACKUP_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql"), encoding="utf-8").read()
after = open(os.path.join(SRC, "01_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql"), encoding="utf-8").read()
st = json.load(open(os.path.join(SRC, "_fresh_state.json"), encoding="utf-8")); ap = json.load(open(os.path.join(SRC, "_apply_result.json"), encoding="utf-8"))
body_before = before[len("CREATE OR REPLACE "):].rsplit("\n/", 1)[0]
body_after = after[len("CREATE OR REPLACE "):].rsplit("\n/", 1)[0]
assert hashlib.md5(body_before.encode("utf-8")).hexdigest() == st["md5"]

# FRESH-GATE (#152): 패키지에 담을 10 전체본 = 지금 사내 DB 에 실제로 적용돼 있는 원문과 같아야 한다 — ALL_SOURCE 를 다시 읽어 대조
import sys; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
_u, _p, _d = conn_info(); _cur = oracledb.connect(user=_u, password=_p, dsn=_d).cursor()
_cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND OBJECT_TYPE='PROCEDURE'")
fresh_ddl = _cur.fetchone()[0]
_cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND TYPE='PROCEDURE' ORDER BY LINE")
fresh_body = "".join(t for (t,) in _cur); fresh_md5 = hashlib.md5(fresh_body.encode("utf-8")).hexdigest()
assert fresh_md5 == ap["md5_after"] and fresh_body == body_after, f"FRESH-GATE 실패: 사내 원문이 적용본과 다름 (DB {fresh_ddl} md5 {fresh_md5} vs 적용 {ap['last_ddl']} {ap['md5_after']}) — 재병합 필요"
SOURCE_FRESH = f"SOURCE-FRESH: 사내 ZIOUI1 ALL_SOURCE {fresh_ddl} (md5 {fresh_md5}) 재조회 {datetime.datetime.now():%Y-%m-%d %H:%M:%S} — 적용본과 일치"
print(SOURCE_FRESH)

open(os.path.join(A, "00_PRECHECK_CLOUD.sql"), "w", encoding="utf-8").write(f"""/* 00_PRECHECK — 조회 전용. 클라우드 PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING 판본 판정
 * [H-APPLIED] 마커 수 >0 → SKIP(이미 적용)
 * [H-PATTERN] 치환 대상 패턴 수 = 54w 2 / 1w 9 → 12 변경 블록 수동 반영 가능 (전체본 10 은 [H-MD5] 가 일치할 때만)
 * [H-MD5]     줄 수·지문이 사내 변경 직전 판({st['last_ddl']}, {st['lines']}줄, md5 {st['md5']})과 같으면 10 전체본 적용 가능 */
SELECT 'H-APPLIED' AS chk, COUNT(*) AS cnt, CASE WHEN COUNT(*) > 0 THEN 'SKIP — 이미 적용됨' ELSE '미적용' END AS judge
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%E20261007-DATEVAR%'
UNION ALL
SELECT 'H-PATTERN-54W', COUNT(*), CASE WHEN COUNT(*) = 2 THEN 'OK' ELSE '⚠ 기대 2 — 12 수동 반영 시 위치 확인' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%TO_CHAR(FN_NEXT_DAY(SYSDATE, ''MON'') - 7*54, ''YYYYMMDD'')%'
UNION ALL
SELECT 'H-PATTERN-1W', COUNT(*), CASE WHEN COUNT(*) = 9 THEN 'OK' ELSE '⚠ 기대 9 — 12 수동 반영 시 위치 확인' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%TO_CHAR(FN_NEXT_DAY(SYSDATE, ''MON'') - 7, ''YYYYMMDD'')%'
UNION ALL
SELECT 'H-LINES', MAX(line), CASE WHEN MAX(line) = {st['lines']} THEN '사내 판과 줄 수 일치 → 10 전체본 가능성' ELSE '⚠ 줄 수 다름 → 10 전체본 금지, 12 수동 반영' END
  FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE'
UNION ALL
SELECT 'H-DDL', NULL, '현재 LAST_DDL = ' || TO_CHAR(last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || status
  FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND object_type = 'PROCEDURE';
""")

open(os.path.join(A, "05_BACKUP_CLOUD_SOURCE.sql"), "w", encoding="utf-8").write("""/* 05_BACKUP — 클라우드 현재 원문 보관 (있으면 건너뜀). 롤백 98 이 읽는다 */
DECLARE n NUMBER; BEGIN
  SELECT COUNT(*) INTO n FROM all_tables WHERE owner = 'SCM_MGR' AND table_name = 'BAK_SRC_WR_DATEVAR';
  IF n = 0 THEN EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.BAK_SRC_WR_DATEVAR AS SELECT name, type, line, text, SYSDATE AS bak_dt FROM all_source WHERE owner = ''SCM_MGR'' AND name = ''PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING'' AND type = ''PROCEDURE'''; END IF;
END;
/
SELECT COUNT(*) AS backed_lines, MAX(bak_dt) FROM SCM_MGR.BAK_SRC_WR_DATEVAR;
""")

open(os.path.join(A, "10_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql"), "w", encoding="utf-8").write(
    f"-- 10 전체본 — [H-MD5]/[H-LINES] 일치할 때만. 사내 적용본 {ap['last_ddl']} (md5 {ap['md5_after']}, 마커 {ap['markers']})\n-- {SOURCE_FRESH}\n" + after)

diff = list(difflib.unified_diff(body_before.splitlines(), body_after.splitlines(), "cloud_before", "after", lineterm="", n=2))
open(os.path.join(A, "12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt"), "w", encoding="utf-8").write(
    "[E20261007-DATEVAR] 변경 블록 — 판본이 다르면 이 diff 를 클라우드 원문에 수동 반영. '-' 줄을 '+' 줄로. @@ 줄번호는 사내 기준.\n"
    "규칙: ① 선언부 끝(V_DUMMY_CUR 다음) 선언 추가 ② V_DELIMITER := '^'; 다음 대입 2줄 ③ TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7*54,'YYYYMMDD') 전부(2곳) → V_FROM_54W ④ … - 7, … 전부(9곳) → V_FROM_1W\n"
    "주의: 대입문 2줄 자체는 치환하지 않는다. MSSQL 주석 블록의 dbo.FN_NEXT_DAY(GETDATE()…) 는 대상 아님.\n\n" + "\n".join(diff) + "\n")

open(os.path.join(A, "13_RECOMPILE_DEPENDENTS.sql"), "w", encoding="utf-8").write("""/* 13 — 본체 컴파일 확인 + 의존 객체 재컴파일 (사내 의존 0) */
ALTER PROCEDURE SCM_MGR.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING COMPILE;
SELECT object_name, object_type, status FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING';
SELECT line, position, text FROM all_errors WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' ORDER BY sequence;
BEGIN
  FOR r IN (SELECT owner, name, type FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND owner = 'SCM_MGR') LOOP
    BEGIN EXECUTE IMMEDIATE 'ALTER ' || CASE r.type WHEN 'PACKAGE BODY' THEN 'PACKAGE' ELSE r.type END || ' SCM_MGR.' || r.name || ' COMPILE' || CASE r.type WHEN 'PACKAGE BODY' THEN ' BODY' END; EXCEPTION WHEN OTHERS THEN NULL; END;
  END LOOP;
END;
/
""")

open(os.path.join(A, "20_STATS_GATHER_OPTIONAL.sql"), "w", encoding="utf-8").write("""/* 20 (선택·DBA) — 대상 테이블 통계 갱신. 클라우드 10-07 기준 DM_PLN_CFM_MKT_DEMAND_PLAN stale 150%, DM_PLN_MKT_FCST 19%.
 * 매일 DELETE+INSERT 전량 재작성 뒤 야간 자동 통계가 돌기 전에 배치가 먼저 도는 구조라, 배치 직전 시점 갱신이 가장 효과적.
 * 사내 소요: DM_PLN_MKT_FCST 285s · DM_PLN_CFM_MKT_DEMAND_PLAN 161s (degree 4) */
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'DM_PLN_MKT_FCST', cascade => TRUE, degree => 4);
  DBMS_STATS.GATHER_TABLE_STATS(ownname => 'SCM_MGR', tabname => 'DM_PLN_CFM_MKT_DEMAND_PLAN', cascade => TRUE, degree => 4);
END;
/
SELECT table_name, num_rows, TO_CHAR(last_analyzed, 'YYYY-MM-DD HH24:MI:SS') FROM all_tables WHERE owner = 'SCM_MGR' AND table_name IN ('DM_PLN_MKT_FCST', 'DM_PLN_CFM_MKT_DEMAND_PLAN');
""")

open(os.path.join(A, "90_VERIFY.sql"), "w", encoding="utf-8").write("""/* 90 VERIFY — 조회 전용 */
SELECT 'V1 VALID' AS chk, status AS val FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND object_type = 'PROCEDURE'
UNION ALL SELECT 'V2 마커 14', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND text LIKE '%E20261007-DATEVAR%'
UNION ALL SELECT 'V3 술어 안 함수 잔존 0', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE'
                 AND text LIKE '%TO_CHAR(FN_NEXT_DAY(SYSDATE, ''MON'')%' AND text NOT LIKE '%V_FROM_%'
UNION ALL SELECT 'V4 대입문 2', TO_CHAR(COUNT(*)) FROM all_source WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND type = 'PROCEDURE' AND REGEXP_LIKE(text, '^\\s*V_FROM_(1W|54W)\\s+:=')
UNION ALL SELECT 'V5 의존 INVALID 0', TO_CHAR(COUNT(*)) FROM all_objects o WHERE o.owner = 'SCM_MGR' AND o.status = 'INVALID'
                 AND o.object_name IN (SELECT name FROM all_dependencies WHERE referenced_owner = 'SCM_MGR' AND referenced_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING');
/* V6 동치(선택, 조회 전용·사내 40 기준 191,466행 함수형 58.9s → 바인드형 0.8s): 함수 술어 vs 리터럴 날짜 건수 비교 */
SELECT 'V6 함수형' AS chk, COUNT(*) AS cnt, SUM(F.QTY) AS qty FROM SCM_MGR.DM_PLN_MKT_FCST F, SCM_MGR.SCM_MST_SITE_ITEM T2
 WHERE F.DIVISION_ID = T2.DIVISION_ID AND F.PROJECT_CODE = T2.PROJECT_CODE AND F.SCM_SITE_ID = T2.SCM_SITE_ID AND F.ITEM_ID = T2.ITEM_ID AND T2.VALID_YN = 'Y' AND F.DIVISION_ID = '40'
   AND F.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
   AND F.MEASURE NOT IN ('CUST_FCST_EDI_ORG','Immidiate[Org.]','Planning_Forecast[Org.]','Commercial_Agreement[Org.]','Firm_Temp[Org.]','Manumacturing_Material_Temp[Org.]','Material_Temp[Org.]','Backorder[Org.]');
/* 다음 주 월요일 15:00 이후: dfrascwsp66jy 의 phv·elapsed 가 바뀌었는지 (03_root_block_measure.sql Q13 / DBA_HIST_SQLBIND 한 줄 쿼리) */
""")

open(os.path.join(A, "98_ROLLBACK_FROM_CLOUD_BACKUP.sql"), "w", encoding="utf-8").write("""/* 98 ROLLBACK — 05 가 보관한 클라우드 원문으로 복원 */
DECLARE v CLOB; BEGIN
  DBMS_LOB.CREATETEMPORARY(v, TRUE);
  FOR r IN (SELECT text FROM SCM_MGR.BAK_SRC_WR_DATEVAR WHERE type = 'PROCEDURE' ORDER BY line) LOOP DBMS_LOB.WRITEAPPEND(v, LENGTH(r.text), r.text); END LOOP;
  EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v;
END;
/
SELECT status FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING' AND object_type = 'PROCEDURE';
""")

open(os.path.join(HERE, "00_README.md"), "w", encoding="utf-8").write(f"""# WEEKLY_ROLLING 날짜 경계 변수화 (DB 단, 클라우드 이관) — 배치 속도개선 방법 2

> 마커 `[E20261007-DATEVAR]` — `PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING` 1 객체

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — 프로시저 1개. 데이터·메타·FE·BE 변경 없음. (선택) 통계 갱신 2 테이블 |
| 사내 적용 | **완료 · VALID** (ZIOUI1, {ap['last_ddl']}) — [APPLIED_OPERATIONS.md](../../_apply_corporate/WEEKLY_ROLLING_DATEVAR_20261007/APPLIED_OPERATIONS.md) |
| 클라우드 | **미적용** |
| 전제 | 클라우드 원문에 치환 패턴이 54w 2곳 / 1w 9곳 있고 마커가 없을 것 — 00 PRECHECK 가 판정. 사내 변경 직전 판 = {st['last_ddl']} {st['lines']}줄 md5 `{st['md5']}` |
| BE 재기동 | 불요 |

## 1. 변경
술어 안 `TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON') - 7, 'YYYYMMDD')`(9곳)·`- 7*54`(2곳)를 시작 때 1회 계산한 변수 `V_FROM_1W`/`V_FROM_54W` 로 바꾼다. 선언 2줄 + 대입 2줄 + 치환 11곳 = +7줄(913→920). 결과 행은 같다(같은 식을 미리 계산). 힌트·인덱스 없음.

왜: 클라우드 AWR(10-05 15:00, 40/MF_W) 에서 L384 `INSERT DM_PLN_MKT_FCST_C`(sql_id `dfrascwsp66jy`) 가 65초 — 함수 술어 때문에 선택도 추정 2,618행(실제 423,068) → `IDX_DM_PLN_MKT_FCST_N1` 범위탐색 + ROWID 단일블록 읽기. 게다가 81/82 로 파싱된 계획을 40 이 공유(DBA_HIST_SQLBIND). 리터럴 날짜면 추정 362K·풀스캔.

## 2. 사내 검증
- VALID · 마커 14 · 술어 안 함수 잔존 0 · 의존 객체 0
- 동치(조회): L384 첫 갈래 SELECT 건수·합계 — 40 191,466 / 81 114,236 / 82 131,053 전부 함수형 = 바인드형. 소요 함수형 58.9s·11.3s·5.1s → 바인드형 0.8s·0.6s·0.5s (캐시 통제 재측정 = `_cache_control_result.json`)
- 통계 갱신: DM_PLN_MKT_FCST(285s) · DM_PLN_CFM_MKT_DEMAND_PLAN(161s)
- 배치 본체(WEEKLY_ROLLING 전체) 는 사내에서 실행하지 않음 — 버전 생성·Sales Plan 동기화를 수반하므로. 클라우드 다음 주 월요일 15:00 실행 결과(AWR phv·elapsed)로 효과 확인.

## 3. 작업 ↔ 파일 (SCM_MGR, QA → DEV)
| # | 작업 | 파일 | 비고 |
|---|---|---|---|
| 1 | 선판정 | A_DB/00_PRECHECK_CLOUD.sql | H-APPLIED / H-PATTERN / H-LINES |
| 2 | 보관 | A_DB/05_BACKUP_CLOUD_SOURCE.sql | `BAK_SRC_WR_DATEVAR` |
| 3 | 적용 | A_DB/10_PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING.sql | 전체본 — H-LINES 일치 때만. 다르면 §4 |
| 4 | 안전망 | A_DB/13_RECOMPILE_DEPENDENTS.sql | |
| 5 | (선택·DBA) 통계 | A_DB/20_STATS_GATHER_OPTIONAL.sql | 배치 직전 시점 권장 |
| 6 | 검증 | A_DB/90_VERIFY.sql | V1~V6 |

## 4. 판본이 다르면
[12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt) 의 diff 를 수동 반영(규칙 4개는 파일 머리에). 반영 뒤 90 의 V2=14·V3=0·V4=2 면 된다.

## 5. 효과 확인 (다음 주 월요일 15:00 뒤)
`BATCH_PERF_WEEKLY_ROLLING_20261007/03_root_block_measure.sql` Q13 또는 DBA_HIST_SQLBIND 한 줄 쿼리로 `dfrascwsp66jy` 의 phv·elapsed 확인. 여전히 인덱스 계획이면 방법 1(40 전용 문장 분리)로.

롤백: A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql → 13.
""")
print("built", HERE, "diff lines", len(diff))
