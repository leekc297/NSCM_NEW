# Hook #129 — oracle-perf-fix-priority-order (SP/PKG 속도 개선은 **정해진 순서**로 — 힌트는 마지막)

> **Trigger**: T06 (SP 변환) / T07 (사내 DB 적용) / T10 (DB 오류·이상치) / T19 (MSSQL→Oracle 변환) — **속도 이슈가 보고된 모든 SP/PKG 작업**
> **PR 차단 강도**: ⭐⭐⭐ (순서 위반 = 근본원인을 덮은 채 증상만 가림)
> **신설일**: 2026-08-10 (사용자 명시)
> **계보**: #51 `oracle-sp-perf-anti-patterns`(무엇이 느린가) ↔ 본 룰(**무엇부터 고치는가**)

---

## §0. 사용자 원문 (2026-08-10)

> "HINT 을 줘서 속도개선하는것은 **제일 먼저해야할 일이 아닙니다.**
> SELECT 문에서 FUNCTION 을 사용하므로써 속도에 문제가 되는 케이스가 많이 있으므로,
> **이를 근본적으로 해석해서 보완하는 것이 첫번째** 입니다.
> **두번째는 INDEX 가 있는 경우에는 INDEX 을 수행할 수 있도록 SYNTAX 을 변경**하는 것이 두번째 입니다.
> **세번째로 힌트의 추가**하는 것 입니다."
>
> "SELECT COLUMN 에 FUNCTION 을 사용하는 경우에 속도를 담보할 수 없으니, 가능하면
> **FUNCTION 의 근본 소스를 확인해서 JOIN TABLE 로 변경**하는 방식으로 속도 개선을 진행해주세요."

### §0.1 추가 지시 (2026-08-10 저녁 — DMF0044 TRANSFER 튜닝 중)

> "속도개선작업을 할 때, **어디가 병목인지를 먼저 확인해서 병목구간에 대해서만**
> 1, 2, 3 순위별 작업을 진행해주세요. 그리고 **SELECT COLUMN절에 SELECT 문장이 있는것은
> 1순위 FUNCTION 과 동급으로 대체 대상**입니다."

⇒ 두 가지가 룰에 추가된다: **0순위 = 병목 선식별**(§0.5), **1순위에 스칼라 서브쿼리 편입**(§2).

---

## §0.5. 0순위 — 병목 구간을 먼저 가른다 (착수 조건)

⛔ **병목을 실측으로 특정하기 전에 1·2·3 순위 작업을 시작하지 않는다.**
"느려 보이는 곳"을 고치면 대개 병목이 아닌 곳을 고치게 되고, 진짜 병목은 그대로 남는다.

**실측 도구 (추측 금지 — 이 중 최소 1개의 직접 근거를 남긴다)**

```sql
-- (a) 지금 도는 세션이 어느 플랜 라인에서 타고 있나 — 가장 강한 증거
SELECT sql_plan_line_id, NVL(event,'ON CPU') event, COUNT(*) samples,
       ROUND(RATIO_TO_REPORT(COUNT(*)) OVER ()*100,1) pct
  FROM v$active_session_history
 WHERE session_id=:sid AND session_serial#=:serial AND sql_id=:sqlid
 GROUP BY sql_plan_line_id, event ORDER BY samples DESC;

-- (b) 플랜 라인별 실제 수행량 (starts / output_rows 로 "행마다 반복" 을 잡는다)
SELECT plan_line_id, plan_operation||' '||plan_options op, plan_object_name,
       plan_cardinality est_rows, output_rows, starts
  FROM v$sql_plan_monitor WHERE sid=:sid AND sql_id=:sqlid ORDER BY plan_line_id;

-- (c) 같은 SQL 이 늘 그 플랜이었나, 가끔이었나 (일회성 vs 구조적 판별)
SELECT plan_hash_value, SUM(executions_delta) execs,
       ROUND(SUM(elapsed_time_delta)/1e6,1) elapsed_s
  FROM dba_hist_sqlstat WHERE sql_id=:sqlid GROUP BY plan_hash_value;
```

**판정 규칙**
- ASH 가 한 플랜 라인에 몰려 있으면 **그 라인이 병목**이다. 다른 구간은 이번 범위가 아니다.
- `output_rows = 0` 인 하위 노드는 **아직 도달조차 못 한 구간** — 병목이 아니다(고치지 말 것).
- `starts` 가 구동행 수만큼 크면 **행별 반복**(함수/스칼라 서브쿼리/PUSHED PREDICATE) 신호.
- `dba_hist_sqlstat` 의 plan_hash 가 **1개뿐**이면 일회성 나쁜 플랜이 아니라 **그 형태의 구조적 결과**다.

⚠ **단독 재현 성적을 근거로 삼지 말 것.** 문장을 떼어내 리터럴로 돌리면 붕괴가 재현되지 않는 일이 흔하다
(§7 실사고 참조). 재현은 **원래 형태 그대로**(INSERT 포함, 바인드 포함) 하거나, 실행 없이 `EXPLAIN PLAN` 으로 비교한다.

---

## §1. 결론 — 개선 순서 (이 순서를 건너뛰지 않는다)

| 순위 | 조치 | 성격 |
|---:|---|---|
| **0** | **병목 구간 실측 특정** — ASH/SQL Monitor. 병목 아닌 곳은 손대지 않는다 | 착수조건 |
| **1** | **SELECT 목록의 함수 호출 + 스칼라 서브쿼리 제거** — 원본을 열어 **등가 JOIN/선계산**으로 치환 | 근본 |
| **2** | **인덱스를 타도록 구문 변경** (SARGable 화) — 컬럼을 함수로 감싸지 말고 상수 쪽을 변환 | 근본 |
| **3** | **힌트 추가** (`USE_HASH` / `NO_PUSH_PRED` / `DYNAMIC_SAMPLING` 등) | 대증 |

⛔ **1·2 를 검토하지 않고 3 부터 손대는 것 금지.** 힌트는 옵티마이저 판단만 바꿀 뿐,
행별 함수 호출·인덱스 미사용이라는 **실제 작업량은 그대로**다.
⛔ 힌트로 "개선됐다"고 보고하면서 1·2 미검토 사실을 안 적는 것도 위반(#126 정직성).

---

## §2. 1순위 — SELECT 목록의 **함수 호출 + 스칼라 서브쿼리** (둘 다 동급)

> **2026-08-10 확장**: 사용자 명시 — "SELECT COLUMN절에 SELECT 문장이 있는것은
> 1순위 FUNCTION 과 동급으로 대체 대상". 아래 §2 는 두 형태를 **같은 절차**로 다룬다.

### §2.0 대상 2형태

| 형태 | 예 | 왜 같은 급인가 |
|---|---|---|
| 함수 호출 | `SELECT FN_X(a) FROM T` | 함수 안 SQL 이 행마다 재실행 |
| **스칼라 서브쿼리** | `SELECT (SELECT c FROM L WHERE L.k=T.k) FROM T` | **문법만 다를 뿐 같은 행별 SQL 재실행** |
| 비상관 스칼라 서브쿼리 | `SELECT (SELECT MAX(c) FROM V WHERE V.id=:b) FROM T` | 캐시되긴 하나 **GROUP BY 문장에선 조인으로 빼는 편이 안전·명확** |
| 뷰 안에 숨은 형태 | 뷰 정의가 셀프조인/상관 집계 | 호출부엔 안 보인다 — **뷰 원문을 반드시 열어볼 것** |

⚠ **뷰 뒤에 숨은 것을 놓치지 말 것.** 호출부 SELECT 목록이 깨끗해도, 참조하는 **뷰 정의 안에**
셀프조인·상관 집계가 있으면 옵티마이저가 `VIEW PUSHED PREDICATE` 로 전개해 행별 반복으로 바꾼다(§7).

### §2.1 왜 치명적인가
`SELECT FN_X(a) FROM T` 는 **결과 행 수만큼** 함수를 호출한다. 함수 안에 SQL 이 있으면
그 SQL 이 행마다 재실행된다(= 숨은 N+1). 실측 계보: DMF0005 **300초 → 3.6초**
([[feedback_dmf0005_perf_scalar_fn_fbi_and_view_dedup]]).
스칼라 서브쿼리도 동일하다 — Oracle 의 스칼라 서브쿼리 캐싱은 **보장이 아니라 최적화**이며,
상관 서브쿼리는 키 카디널리티가 높으면 캐시가 거의 듣지 않는다.

### §2.1-b 스칼라 서브쿼리 → JOIN 치환 시 필수 확인 3가지

1. **유일성 실측** — `SELECT k, COUNT(*) … GROUP BY k HAVING COUNT(*)>1` 이 0건이어야
   LEFT JOIN 이 행을 증식시키지 않는다. 원본이 `ROWNUM = 1` 로 임의 1행을 뽑고 있었다면
   **1:N 일 수 있다는 뜻**이므로 반드시 실측하고, 1:N 이면 집계 인라인뷰(`GROUP BY k`)로 1행을 보장한다.
2. **미매치 시 값 보존** — 반드시 `LEFT OUTER JOIN`. `NVL(subq,'')` 는 Oracle 에서 `'' = NULL` 이라
   **항등식**이므로 그대로 NULL 이 남아야 한다. 바깥에서 `IS NULL` 분기·`ORDER BY`·`GROUP BY` 가
   그 NULL 을 보고 있으면 임의로 센티널로 바꾸면 **정렬/그룹이 바뀐다**.
3. **GROUP BY 동반** — 치환 대상 문장에 `GROUP BY` 가 있으면, 조인해 온 컬럼은 문법상 GROUP BY 에
   추가해야 한다. 1행 인라인뷰라 값이 단일이면 **그룹 구성은 불변**이다(그 사실을 주석으로 남길 것).

### §2.2 절차
1. **인벤토리** — 대상 PKG/SP 의 SELECT 목록에서 함수 호출 전수 추출:
   ```sql
   SELECT NAME, LINE, TEXT FROM ALL_SOURCE
    WHERE OWNER='SCM_MGR' AND NAME=:pkg AND TYPE='PACKAGE BODY'
      AND REGEXP_LIKE(TEXT, '(FN_|UF_|PKG_[A-Z0-9_]+\.)[A-Z0-9_]+\s*\(', 'i')
      AND LTRIM(TEXT) NOT LIKE '--%'
    ORDER BY LINE;
   ```
2. **함수 원본 열람** — `ALL_SOURCE` 로 본문을 읽어 **무엇을 조회하는지** 확인한다(추측 금지).
3. **판정** — 3분류:
   | 분류 | 조치 |
   |---|---|
   | 단일 테이블 lookup (키로 1행 조회) | **LEFT OUTER JOIN 으로 치환** |
   | 집계/문자열 조립 (예: 콤마 목록 → 이름 연결) | 원천을 **선계산 인라인뷰/GTT** 로 1회 산출 후 JOIN |
   | 순수 계산 (SQL 없음, 상수 시간) | **유지 가능** — 단, `DETERMINISTIC` 여부 확인 |
4. **치환 후 행 집합 불변 검증** — 치환 전/후 결과를 **MINUS 양방향** 으로 대조해 0행을 증명한다.
   ⚠ LEFT JOIN 치환은 **1:N 이면 행이 늘어난다**. 원천 키 유일성을 먼저 실측하라
   (`SELECT k, COUNT(*) … GROUP BY k HAVING COUNT(*)>1` = 0건).

### §2.3 실측 후보 (PKG_DMF0044, 2026-08-10)
`FN_GET_DM_MKT_OWNER_NAME(B.OWNER, ',', 'KO')` — L8273(div40 INSERT) / L9075(ETC INSERT) 등
결과 행마다 호출된다. 소유자 콤마목록을 이름으로 바꾸는 함수라 **§2.2 두 번째 분류**(선계산 후 JOIN) 대상.

## §3. 2순위 — 인덱스를 타게 하는 구문 변경 (SARGable)

| ⛔ 인덱스 못 탐 | ✅ 탈 수 있게 |
|---|---|
| `WHERE SUBSTR(YYYYMMDD,1,6) = :ym` | `WHERE YYYYMMDD >= :ym\|\|'01' AND YYYYMMDD < …` |
| `WHERE TO_CHAR(D,'YYYYMMDD') = :s` | `WHERE D >= TO_DATE(:s,'YYYYMMDD') AND D < …+1` |
| `WHERE UPPER(C) = :v` | 상수를 맞추거나 **FBI**(`CREATE INDEX … (UPPER(C))`) |
| `WHERE NVL(C,'-') = :v` | `WHERE (C = :v OR (C IS NULL AND :v='-'))` 또는 컬럼을 센티널로 정규화 |
| 암묵 형변환(`VARCHAR2` 컬럼 = 숫자 바인드) | 타입 일치([[feedback_oracle_nls_implicit_conversion]]) |

- 인덱스 존재 확인은 실측으로: `ALL_IND_COLUMNS` 로 **선두 컬럼**을 보고 판단한다.
- 인덱스 **신설**이 필요하다고 판단되면 **제안만** 하고 임의 생성 금지(운영 DDL — 사용자 승인 대상).

## §4. 3순위 — 힌트

1·2 를 적용하고도 옵티마이저가 계획을 잘못 고를 때만. 반드시 **왜 필요한지 실측 근거**와 함께.

- ⚠ **별칭 충돌 주의**: 인라인뷰 별칭과 내부 테이블 별칭이 같으면 힌트가 **다른 쿼리블록으로 해석되어 무시**된다.
  실사고(2026-08-10 PKG_DMF0044 LOC 메저 문장): `SELECT /*+ LEADING(A B) USE_HASH(B) NO_PUSH_PRED(B) */`
  를 넣었는데 커서 텍스트엔 힌트가 있고 플랜엔 **`VIEW PUSHED PREDICATE` 가 그대로** 남았다
  (내부 `FROM DM_PLN_SALES_PLAN_REPORT_C A` 와 바깥 인라인뷰 `A` 가 충돌). ⇒ `QB_NAME` 으로 쿼리블록을 명시하라.
- ⚠ 힌트를 넣었으면 **플랜으로 적용 여부를 확인**한다(`V$SQL_PLAN_MONITOR` EST vs ACT). 텍스트에 들어간 것 ≠ 먹은 것.
- ⛔ SP 본문에서 `DBMS_STATS` 호출 금지 — 단일 트랜잭션 SP 에서 부분 커밋 위험.

## §5. 보고 양식 (의무)

속도 개선을 보고할 때 **세 순위를 각각 적는다**. 검토 안 했으면 "미검토"라고 쓴다(#126).

| 순위 | 검토 | 조치/사유 | 실측 |
|---|---|---|---|
| **0 병목 특정** | ASH/Monitor 근거 | 어느 플랜 라인 / 몇 % | 샘플수·라인ID |
| 1 SELECT 함수·스칼라 서브쿼리 | N개 발견 / 0개 | 치환 or 유지 사유 | 전/후 초 |
| 2 인덱스 SARGable | 대상 M개 / 없음 | 구문 변경 내역 | 전/후 초 |
| 3 힌트 | 적용/미적용 | 1·2 로 부족했던 근거 | 플랜 확인 결과 |

⛔ "힌트 넣어서 빨라졌습니다" 단독 보고 금지.
⛔ **병목 근거 없이 1·2·3 을 보고하는 것도 금지** — 0순위 칸이 비면 미착수로 간주한다.

## §6. POST-WRITE grep

```sql
-- 대상 PKG 의 SELECT 목록 함수 호출 잔존 (0 이 목표, 불가피분은 §5 에 사유 기재)
SELECT LINE, TEXT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME=:pkg AND TYPE='PACKAGE BODY'
   AND REGEXP_LIKE(TEXT, '(FN_|UF_)[A-Z0-9_]+\s*\(', 'i')
   AND LTRIM(TEXT) NOT LIKE '--%' ORDER BY LINE;

-- 선택목록 스칼라 서브쿼리 잔존 (1차 스크리닝 — 정규식은 오탐/누락이 있으니 §6.1 파서로 확정)
SELECT LINE, TEXT FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND NAME=:pkg AND TYPE='PACKAGE BODY'
   AND REGEXP_LIKE(TEXT, '(,|NVL\(|COALESCE\()\s*\(\s*SELECT', 'i')
   AND LTRIM(TEXT) NOT LIKE '--%' ORDER BY LINE;
```

### §6.1 정규식만으로는 부족하다 — 선택목록 파서 (anti-simplification)

정규식 1개로 "SELECT 목록 안의 서브쿼리"를 판정하면 **줄바꿈으로 갈라진 것**과
**FROM 절/WHERE 절의 서브쿼리(대상 아님)** 를 가르지 못한다. 다음 절차를 쓴다:

1. 주석(`--`, `/* */`)과 문자열 리터럴을 **먼저 마스킹**한다(오탐 제거).
2. 각 `SELECT` 키워드부터 **괄호 깊이 0 에서 만나는 첫 `FROM`** 까지를 선택목록 구간으로 자른다.
3. 그 구간 안에서만 `(\s*SELECT` 와 함수 호출을 찾는다.
4. 프로시저 경계로 귀속시킬 때 **중첩 프로시저(로컬 PROCEDURE)** 주의 — 가장 가까운
   `PROCEDURE` 선언에 붙이면 부모가 아니라 로컬 프로시저로 잘못 귀속된다.

구현 정본: `_artifacts/_diagnostics/_tmp_t44_scan_selectlist_subq.py` (PKG_DMF0044 실사용).

---

## §7. 실사고 계보 — PKG_DMF0044 TRANSFER (2026-08-10)

**증상**: Transfer 버튼 → 52분 무응답. SID 512 / SQL_ID `5dchxk6z8k7hg`
(`INSERT INTO DM_MOBILE_REPORT_PRODUCT … WITH ISV … SELECT`),
elapsed 4,909초 / **CPU 4,900초** / buffer_gets 2.63억 / **처리행 0**.

**0순위 병목 특정**: ASH 3,183 샘플 **전량(100%)** 이 플랜 L11 `INDEX SKIP SCAN PK_SCM_ITEM_M`.
상위는 `L6 VIEW PUSHED PREDICATE (starts 35,238)` ← `L5 INDEX FULL SCAN (443,488행 구동)`.
`dba_hist_sqlstat` 상 이 SQL_ID 의 plan_hash 는 **237589406 단 하나**(8회, 누적 10,489초)
⇒ 일회성 나쁜 플랜이 아니라 **그 문장 형태의 구조적 결과**.

**근원**: 호출부엔 함수도 서브쿼리도 없었다. 병목은 **뷰 `DM_MST_ITEM_SINGLE_V` 정의 안**에 있었다 —
`SCM_MST_ITEM_SN` 을 `SUBSTR(ITEM_ID,1,12)` 로 집계한 인라인뷰와 **셀프조인**. 옵티마이저가
이 인라인뷰에 술어를 밀어넣으면(PUSHED PREDICATE) GROUP BY 뷰가 **행별 상관 집계**로 전개되고,
비-SARGable `SUBSTR` 필터의 SKIP SCAN 이 구동행 수만큼 반복된다.

**⛔ 실패한 선행 조치 (기록으로 남긴다)**: 같은 날 앞 세션이 `/*+ MATERIALIZE */` 를 넣었다(TUNE-M).
리터럴 재현에서 0.7초가 나와 채택했으나, **실사용에서는 붕괴가 사라진 게 아니라
"실체화하는 그 문장" 안으로 옮겨갔을 뿐**이었다. 교훈 2가지:
- 힌트/변환 지시로 **옵티마이저의 판단**을 바꾸는 것은, 나쁜 판단을 **불가능하게** 만드는 것과 다르다.
- **단독 재현(리터럴)의 성적을 채택 근거로 쓰지 말 것.** 실제로 OLD 문장을 INSERT 만 떼고 돌리면
  0.85초였다 — 즉 그 측정으로는 이 사고를 영원히 못 잡는다. `EXPLAIN PLAN` 을 **원래 형태 그대로**
  걸어야 COST 320,767,161 / EST 32,144,199 / `VIEW PUSHED PREDICATE` 가 드러난다.

**채택 조치 (1순위 · 구조)**: 뷰를 버리고 **셀프조인 자체를 제거** — 단일 패스 + 분석함수.
```sql
SELECT DIVISION_ID, ITEM_ID,
       MAX(MAX(FORECAST_INFO_BIZ_TYPE))
           OVER (PARTITION BY DIVISION_ID, SUBSTR(ITEM_ID,1,12)) AS FORECAST_INFO_BIZ_TYPE, …
  FROM SCM_MST_ITEM_SN WHERE DIVISION_ID = :d GROUP BY DIVISION_ID, ITEM_ID
```
등가 근거: 인라인뷰 T2 는 **같은 테이블을 같은 키로 집계**한 것이라 T1 의 모든 행이 반드시
자기 그룹과 매칭된다(inner join 이 행을 떨구지 않음) ⇒ "T1 그룹별 MAX(T2.col)"
= "SUBSTR12 파티션 전체의 MAX(col)". 이 형태에는 밀어넣을 인라인뷰가 없으므로
**PUSHED PREDICATE 가 성립 불가능**하다.

**2순위**: 위 치환으로 `SUBSTR` 조인 술어 자체가 사라져 비-SARGable 문제 동시 소멸 → 인덱스 신설 불요.
**3순위**: 불요. (`MATERIALIZE` 는 ISV 가 UNION ALL 두 갈래에서 참조되므로 **중복 산출 방지 목적**으로만 유지)

**실측** (EXPLAIN PLAN, 원래 INSERT 형태):

| 문장 | COST | 최대 EST 행 | `VIEW PUSHED PREDICATE` |
|---|---:|---:|---|
| PRODUCT_CREATE OLD | 320,767,161 | 32,144,199 | 있음 (L6) |
| PRODUCT_CREATE NEW | **22,867** | **71,362** | 없음 |
| DEPT_CREATE GTT OLD | 222,992 | 32,144,199 | 없음(HASH JOIN) |
| DEPT_CREATE GTT NEW | **16,758** | **71,362** | 없음 |

행 집합 불변 증명: 변경된 4개 문장 전부 OLD/NEW **행 다중집합 완전일치**
(DATE 컬럼은 SYSDATE 라 비교 제외). ISV 단독으로도 MINUS 양방향 0행.
