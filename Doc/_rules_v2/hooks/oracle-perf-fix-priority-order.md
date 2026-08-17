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

### §0.2 추가 지시 (2026-08-15 — DMF0082 조회 튜닝 중)

> "제가 원하는 것은 먼저 **각 세션의 시간을 측정해 2초 이상 시간이 소요되는 부분을 확인해서
> 튜닝대상으로 선정**합니다. 튜닝의 우선순위는 **SELECT COLUMN 절에 FUNCTION, SELECT 문이 있으면
> FROM 절에 JOIN 하는 것으로 변환하는 것이 1순위**, 그 이후 **INDEX 가능한데 INDEX 수행 못 하고
> 있으면 INDEX 수행되도록**, 그다음은 **필요 시 INDEX 추가**, 그다음이 현재의 튜닝 절차입니다."

⇒ 두 가지가 다시 추가된다.
1. **착수 게이트가 정량화**된다 — 병목을 "감"으로 고르지 않고 **호출별 시간을 전수 측정한 뒤
   `>= 2초` 인 호출만** 대상으로 삼는다(§0.4).
2. **인덱스 추가가 독립 순위(3순위)로 분리**되고 **힌트가 4순위로 밀린다**(§1).
   기존에는 "SARGable 화" 다음이 곧 힌트였는데, 그 사이에 **없는 인덱스를 만드는 선택지**가 들어간다.

---

## §0.4. 착수 게이트 — 호출별 시간 전수 측정 후 **2초 이상**만 대상 (2026-08-15)

⛔ **화면 1회 조회는 여러 호출(시트/세션)로 나뉜다. 전부 재보고 `>= 2초` 인 것만 대상으로 삼는다.**
한 호출이 느리다고 화면 전체를 뒤지지 않고, 빠른 호출은 이번 범위에서 제외한다.

**측정 방법 — 화면과 동일한 경로로**

- FE 가 실제로 쏘는 **시트별 `call-proc` 을 각각 계측**한다(SP 직접 호출이 아니라 HTTP 경로).
  SP 만 재면 **결과 직렬화·BE 왕복**이 빠져 화면 체감과 어긋난다.
- 파라미터는 **FE 스토어 원문에서 확보**한다(추정 금지). 실측 계보(DMF0082):
  미선택 필터 = `'ALL'` 이 아니라 **빈 문자열**, `userGroup` = 권한 CMBO 미등록 시 **userId fallback**.
  이 두 개를 틀리면 **0행이 빠르게 돌아와** 병목이 재현되지 않는다.
- 도구 정본: `_artifacts/_diagnostics/_0082_measure.py` (시트별 elapsed + 결과 건수 동시 출력).

**판정**

| 시간 | 처리 |
|---|---|
| `>= 2초` | **튜닝 대상**. §0.5 병목 선식별 → §1 순위대로 |
| `< 2초` | 이번 범위 **제외**. 보고서에 시간만 남긴다 |

⚠ **결과 0행인데 시간이 걸리는 호출**은 특히 의심한다 — 필터가 안 걸려 헛도는 신호다
(DMF0082 실측: `futurePriceInfo` 0행에 6.35초 / `savePriceData` 0행에 2.83초).

⚠ **0행으로 빠르게 끝난 측정치를 "빠르다" 로 결론내지 않는다.** 데이터가 실리는 조건에서
다시 재야 한다. 재현이 안 되면 **재현 실패를 그대로 보고**하고 추정으로 대체하지 않는다(#126).

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
| **0-a** | **호출별 시간 전수 측정 → `>= 2초` 만 대상 선정** (§0.4) | 착수조건 |
| **0-b** | **병목 구간 실측 특정** — ASH/SQL Monitor. 병목 아닌 곳은 손대지 않는다 (§0.5) | 착수조건 |
| **1** | **SELECT 목록의 함수 호출 + 스칼라 서브쿼리 제거** — 원본을 열어 **등가 JOIN/선계산**으로 치환 | 근본 |
| **2** | **WHERE/FROM 절의 테이블 함수를 GTT 선적재로 치환** — `TABLE(UF_FX_String_SplitForIN(…))` 계열 (§3.0) | 근본 |
| **3** | **기존 인덱스를 타도록 구문 변경** (SARGable 화) — 컬럼을 함수로 감싸지 말고 상수 쪽을 변환 | 근본 |
| **4** | **인덱스 추가** — 3순위로도 탈 인덱스가 **아예 없을 때만**. 아래 조건 충족 필수 | 근본 |
| **5** | **힌트 추가** (`LEADING` / `USE_HASH` / `NO_PUSH_PRED` / `DYNAMIC_SAMPLING` 등) | 대증 |

⛔ **1·2·3·4 를 검토하지 않고 5 부터 손대는 것 금지.** 힌트는 옵티마이저 판단만 바꿀 뿐,
행별 함수 호출·인덱스 미사용이라는 **실제 작업량은 그대로**다.
⛔ 힌트로 "개선됐다"고 보고하면서 1~4 미검토 사실을 안 적는 것도 위반(#126 정직성).

### §1.1 4순위 — 인덱스 추가 조건 (2026-08-15 신설)

인덱스 추가는 **되돌리기 쉬운 대신 전역 부작용**(DML 부하·저장공간·다른 플랜 변화)이 있다.
아래를 모두 만족할 때만 제안하고, **DDL 은 사용자 승인 후** 적용한다.

1. 3순위(SARGable 화)로도 **탈 수 있는 인덱스가 존재하지 않음**을 `ALL_IND_COLUMNS` 로 실측
2. 대상 컬럼의 **선택도**를 실측(`COUNT(DISTINCT col)/COUNT(*)`) — 저선택도면 인덱스가 답이 아니다
3. 해당 테이블의 **DML 빈도**를 확인(적재 배치 대상이면 부하 증가를 명시)
4. **기존 인덱스 선두 컬럼과 중복되지 않는지** 확인(중복 인덱스 생성 금지)
5. GTT 는 원칙적으로 제외 — 세션 데이터라 통계가 없어 인덱스가 선택되지 않는 경우가 많다

⚠ GTT 가 관련된 느린 구간은 4순위가 아니라 **5순위(힌트로 조인순서·방식 고정)** 가 정답인 경우가 많다.
   실계보(DMF0082 2026-08-15): GTT 3개 추정 카디널리티가 1 로 굳어 `MERGE JOIN CARTESIAN` +
   대형 테이블 행별 NL 조회 → `buffer_gets 5,364만 / 결과 0행`. 인덱스는 이미 있었고(PK), 문제는
   **인덱스를 5,364만 번 탄 것**이었다. 이런 경우 인덱스 추가는 무효이고 조인순서 고정이 유효하다.

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

---

## §3.0. 2순위 — WHERE/FROM 절의 **테이블 함수 → GTT 선적재** (2026-08-15 신설)

> 사용자 지시(2026-08-15): "`UF_FX_String_SplitForIn` 이 있으면 GT/GTT Temp Table 에 **사전 넣어서**
> 사용 시에는 Function 을 사용하지 않고 **Temp Table 을 사용**하도록 보완. 이것도 튜닝 Rule 의
> **2단계**로 넣어서 적용되도록."

### §3.0.1 대상

`FROM TABLE(<함수>(…))` / `IN (SELECT … FROM TABLE(<함수>(…)))` 형태의 **PIPELINED 테이블 함수**.
대표 = `UF_FX_String_SplitForIN(p_x, ',')` — 콤마 문자열을 IN 절용 행집합으로 쪼개는 함수.

### §3.0.2 왜 2순위인가 (1순위 바로 다음)

- 테이블 함수는 **카디널리티 추정이 기본값으로 고정**된다(8168 등). 조인 순서·방식이 통째로 어긋난다.
- `IN (SELECT … TABLE(f(:b)))` 는 **서브쿼리마다 함수를 다시 실행**할 수 있다. 같은 파라미터를
  N 곳에서 쓰면 N 번 파이프라인이 돈다(DMF0082 실측: 한 패키지 안 **19곳**).
- `UF_FX_String_SplitForIN` 은 내부가 **재귀 CTE + PIPELINED** 라 호출당 비용이 작지 않다.
- 1순위(SELECT 목록)와 성격이 같다 — **행별/반복 함수 실행을 없애는 근본 조치**다.

### §3.0.3 치환 절차

1. **GTT 준비** — `(PARAM_NM, TOKEN)` 2컬럼. `ON COMMIT PRESERVE ROWS` + `PARAM_NM` 인덱스.
   ⚠ 이관 패키지에 **GTT DDL 을 자급**해야 한다(룰 — 기존재 가정 금지).
2. **선적재 1회** — 프로시저 진입 후 파라미터가 확정된 지점에서 **파라미터별 1회만** 쪼개 넣는다.
   ```sql
   DELETE FROM GT_..._PARAM_TOKEN;
   INSERT INTO GT_..._PARAM_TOKEN (PARAM_NM, TOKEN)
   SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_plant_site_id, ','));
   -- … 사용하는 파라미터 전부
   ```
3. **호출부 치환** — `TABLE(f(p_x,','))` → `(SELECT TOKEN FROM GT_..._PARAM_TOKEN WHERE PARAM_NM='p_x')`
   - 별칭을 쓰던 자리(`FROM TABLE(...) P` + `P.COLUMN_VALUE`)는 **컬럼명이 TOKEN 으로 바뀐다** — 함께 고칠 것
4. **검증** — 치환 전후 **결과 행수·값 동일** 실측. 함수 잔존 0건 grep.

### §3.0.4 주의

⚠ **선적재 위치가 조건 블록 안에 들어가면 안 된다.** `IF p_x <> 'ALL' THEN` 안에 넣으면
  일반 조회에서 통째로 건너뛰어 **토큰이 비고 조회 결과가 전멸**한다.
  (2026-08-15 DMF0082 실패 계보 — 센티널 패치를 `IF p_team_id <> 'ALL'` 안에 넣어 미실행)
⚠ **빈 문자열/ALL 의미론을 바꾸지 말 것.** 원본이 `p_x = 'ALL'` 일 때 필터를 건너뛰었다면
  치환 후에도 동일해야 한다. 토큰 0건이 곧 "전건 탈락" 이 되면 조회가 비어버린다.
⚠ GTT 는 세션 스코프다 — **같은 세션에서 선적재 → 사용** 이어야 한다.

## §3. 3순위 — **기존** 인덱스를 타게 하는 구문 변경 (SARGable)

| ⛔ 인덱스 못 탐 | ✅ 탈 수 있게 |
|---|---|
| `WHERE SUBSTR(YYYYMMDD,1,6) = :ym` | `WHERE YYYYMMDD >= :ym\|\|'01' AND YYYYMMDD < …` |
| `WHERE TO_CHAR(D,'YYYYMMDD') = :s` | `WHERE D >= TO_DATE(:s,'YYYYMMDD') AND D < …+1` |
| `WHERE UPPER(C) = :v` | 상수를 맞추거나 **FBI**(`CREATE INDEX … (UPPER(C))`) |
| `WHERE NVL(C,'-') = :v` | `WHERE (C = :v OR (C IS NULL AND :v='-'))` 또는 컬럼을 센티널로 정규화 |
| 암묵 형변환(`VARCHAR2` 컬럼 = 숫자 바인드) | 타입 일치([[feedback_oracle_nls_implicit_conversion]]) |

- 인덱스 존재 확인은 실측으로: `ALL_IND_COLUMNS` 로 **선두 컬럼**을 보고 판단한다.
- 인덱스 **신설**이 필요하다고 판단되면 **제안만** 하고 임의 생성 금지(운영 DDL — 사용자 승인 대상).

## §4. 5순위 — 힌트

1~4 를 적용(또는 부적용 사유를 명시)하고도 옵티마이저가 계획을 잘못 고를 때만. 반드시 **왜 필요한지 실측 근거**와 함께.

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

---

## §8. fetch 축 — **SP 밖(직렬화·왕복) 비용**은 별도 체계로 (2026-08-15 신설)

한 번의 조회 시간은 두 덩어리다. **합산만 재면 어느 쪽을 고칠지 판단할 수 없다.**

| 구간 | 무엇 | 튜닝 수단 |
|---|---|---|
| **SP** | 서버가 결과를 **만드는** 시간 | §1 의 ①~④ |
| **fetch** | 만든 결과를 클라이언트로 **옮기는** 시간 | **SQL 튜닝으로 안 줄어듦** — 본 §8 |

`fetch` = **왕복 횟수(행수/arraysize) × 행당 직렬화량(컬럼수 × 평균길이)** + LOB 추가 왕복.

### §8.1 판정

| 조건 | 처리 |
|---|---|
| fetch `>= 2초` | **별도 대상**(SP 튜닝과 독립 진행) |
| fetch 가 합계의 **30% 이상** | SP 보다 **fetch 를 먼저** 본다 |

### §8.2 감축 순서 (SQL 순위와 별개 체계)

| 순위 | 조치 | 성격 |
|---:|---|---|
| **F1** | **전부 NULL 인 컬럼 제거** — 내려도 화면이 못 쓰는 데이터 | 근본(작업량 자체 축소) |
| **F2** | **fetchSize/arraysize 조정** | 대증(같은 양을 효율적으로) |
| **F3** | **행수 축소** — 중복 제거·서버측 집계 | 근본 |
| **F4** | **LOB 회피** — LOB 는 행당 추가 왕복 | 근본 |

F1 이 먼저인 이유는 §1 과 같은 논리다 — **작업량 자체를 줄이는 조치가 먼저**고, F2 는 대증이다.

### §8.3 실측 계보 (DMF0082 40 division, 2026-08-15)

```
행 17,482 · 컬럼 419 · LOB 0 · 전체 직렬화량 약 6.5 MB
arraysize=100    fetch 15.03s  왕복 175회
arraysize=1000   fetch  6.12s  왕복  18회   ← 최적
arraysize=5000   fetch  8.36s  왕복   4회   ← 오히려 악화
컬럼 419 중 값이 하나라도 있는 것 142 / **전부 NULL 277(66%)**
```

⚠ **arraysize 는 크다고 좋지 않다.** 버퍼가 커지면 메모리 할당·복사가 왕복 절감을 상쇄한다.
   **측정해서 정하고 추정으로 키우지 말 것**(위 5000 실측 반례).
⚠ **SP 시간은 실행마다 흔들린다**(위 계보 27~37초 — 버퍼 캐시 상태). fetch 를 비교할 때
   SP 시간은 통제 변수가 아니므로 **같은 조건 3회 이상 재서 중앙값**으로 본다.
⚠ 측정 도구는 **SP 와 fetch 를 분리 출력**해야 한다 — 정본 `_diagnostics/_0082_fetch_profile.py`.

---

## §9. 조회 쿼리 **참조 모델** — 정본 = DMF0082 (2026-08-15)

> 사용자 지시: "DMF0082 의 튜닝내용을 RULE 로 정리해서 **조회 QUERY 에 대한 참조 모델**로 사용."

화면 조회 SP 는 대개 **① 마스터/필터를 GTT 에 모으고 → ② 대형 원장과 조인해 스테이징 GTT 를 만들고
→ ③ PIVOT 으로 최종 커서를 연다** 는 3단 파이프라인이다. 아래는 그 구조에서 반복적으로 나오는
증상 → 원인 → 처방 카탈로그다. **증상이 같으면 원인도 같을 가능성이 높다.**

### §9.1 증상별 처방표

| # | 증상 | 실측 지표 | 원인 | 처방 |
|---:|---|---|---|---|
| **R1** | 조회가 끝나지 않음 / 수십 분 | `buffer_gets` 수천만인데 **결과 0행** · `latch: cache buffers chains` | GTT 추정 카디널리티 **1** → `MERGE JOIN CARTESIAN` + 대형표 **행별 NL** | 5순위 `LEADING(대형표) USE_HASH(GTT…)` 로 **조인순서 고정** |
| **R2** | 조인 하나가 배수로 작용 | 플랜에 `MERGE JOIN CARTESIAN`, 등가 조건이 **1개뿐**인 조인 | 조인이 아니라 **필터**인데 조인으로 써서 곱집합 배수 발생 | 2순위 **EXISTS 세미조인** 전환 (⚠ 대상이 `DISTINCT` 적재라 유일함을 **실측 확인** 후) |
| **R3** | 동일 항목이 N 벌로 표시 | 정적 컬럼 1개만 다른 행이 N 개 · 버킷값 **100% 동일** | 센티널 표기 분열 (`NULL`/`''`/`' '`/`'-'`/`'--'`/`CHR(0)`) | 스테이징에서 **정규화 + dedup 한 쌍** (§9.2) |
| **R4** | 파라미터 쪼개는 함수가 반복 실행 | `TABLE(f(:b))` 가 한 패키지에 수십 곳 | PIPELINED 함수 재실행 + 카디널리티 고정 추정 | 2순위 **GTT 선적재**(§3.0) |
| **R5** | SP 는 빨라졌는데 화면은 느림 | `fetch` 가 합계의 30%↑ | 행수 × 컬럼수 직렬화 + 왕복 | §8 fetch 축 (F1 전NULL 컬럼 → F2 arraysize → F3 행수) |

### §9.2 R3 — 센티널 분열은 **정규화 단독 금지**

⛔ 정규화만 하면 **값이 N 배가 된다.** 최종 SELECT 가 `PIVOT(SUM)` + `GROUP BY … 그 컬럼` 이면,
갈라져 있던 N 행이 한 그룹으로 합쳐지며 **합산**된다.

```sql
-- ① 정규화
UPDATE <스테이징 GTT> SET <컬럼> = '-'
 WHERE <컬럼> IS NULL
    OR TRIM(REPLACE(<컬럼>, CHR(0), '')) IS NULL
    OR TRIM(REPLACE(<컬럼>, CHR(0), '')) IN ('-', '--');

-- ② dedup (ROW_NUMBER — 상관 서브쿼리 금지)
DELETE FROM <스테이징 GTT>
 WHERE ROWID IN (SELECT RID FROM (
         SELECT ROWID RID, ROW_NUMBER() OVER (PARTITION BY <키 전량> ORDER BY QTY DESC NULLS LAST, ROWID) RN
         FROM <스테이징 GTT>) WHERE RN > 1);
```

**적용 전 필수 검증** — 중복 그룹의 값이 실제로 같은가.
```sql
SELECT COUNT(*) 중복그룹, SUM(CASE WHEN MN<>MX THEN 1 ELSE 0 END) 값상이그룹
  FROM (SELECT COUNT(*) CNT, MIN(QTY) MN, MAX(QTY) MX FROM <GTT> GROUP BY <정규화 키> HAVING COUNT(*)>1);
```
값이 다른 그룹이 있으면 **어느 값을 남길지는 업무 판단**이다. 임의로 정하지 말고 확인한다.
(DMF0082 실측: 중복 134,304 그룹 중 **16,395 그룹이 값 상이** — SUM/MAX/최신 중 사용자가 MAX 선택)

### §9.3 원장을 고치려 하지 말 것 (PK 충돌)

센티널을 **원장 UPDATE 로** 통일하려 하면 PK 충돌이 난다. DMF0082 실측:

```
DM_PLN_CFM_SELLING_PRICE   정규화 시 PK 충돌 360,735건 / 1,037,559행
DM_PLN_MKT_FCST                            184,434건 /   501,947행
DM_PLN_CFM_MKT_DEMAND_PLAN                  71,656건 /   324,319행
```
⇒ **조회 시점 정규화**(스테이징 GTT)가 정답이다. 원장 정리는 별건으로 분리한다.

### §9.4 배치 위치 3원칙 (실패 계보)

1. **조회조건 필터 뒤** — 앞에 두면 `p_x NOT IN (…)` 필터가 정규화된 값과 비교되어 조회 의미가 바뀐다.
2. **어떤 `IF` 블록에도 넣지 않는다** — `IF p_team_id <> 'ALL' THEN` 안에 넣어 일반 조회에서
   통째로 건너뛴 사고(2026-08-15). **배포 성공(errors=0)인데 결과 불변**이면 이걸 의심한다.
3. **적용 확인은 결과가 아니라 스테이징으로** — 결과만 보면 "안 먹었다" 까지만 알 수 있다.
   `같은 세션에서` GTT 를 직접 세면 어느 단계까지 갔는지 즉시 드러난다.

### §9.5 재현이 최우선 — 파라미터는 **로그가 정본**

조회 SP 는 파라미터 하나가 달라도 **0행이 빠르게 돌아와** 병목이 재현되지 않는다.
FE 스토어 코드에서 추정하지 말고 **SP 입력 로그**(`SCM_SYS_LOG_BATCH.IN_PARA_DATA`)에서 가져온다.

DMF0082 재현 실패 2회 계보:
- 1차 — `p_item_id` 를 `'ALL'` 로 넣음 (실제 **NULL**)
- 2차 — 필터를 `''`, `userGroup` 을 userId 로 넣음 (실제 **`'ALL'`** / **`'ADMIN'`**)

### §9.6 정본 산출물

```
이관 패키지  _artifacts/_deploy_packages/DMF0082_PERF_CLOUD_20260815/
사내 적용분  _artifacts/_apply_corporate/DMF0082_PERF_20260815/   (백업 4본 + 적용 SQL 5본)
측정 도구    _diagnostics/_0082_measure.py       (시트별 elapsed — §0.4)
             _diagnostics/_0082_ash_break.py     (SQL_ID 귀속 — §0.5)
             _diagnostics/_0082_fetch_profile.py (fetch 분해 — §8)
             _diagnostics/_0082_triple.py        (중복 컬럼 기여도 — §9.1 R3)
```

**성과**: 25분 미완 → **SP 12.9s + fetch 2.6s**, 결과 17,482행(중복 3벌) → **7,090행**.

---

## §10. **저장 SP** 참조 모델 — 정본 = DMF0003 P_DMF0003_SAVE_MKT_FCST (2026-08-15)

§9 는 조회(GET) 참조 모델이다. 저장(SAVE)은 원장 DELETE→INSERT 가 중심이라 병목 계보가 다르다.
**실측: 12.62s → 2.0~3.1s** (호출 8회 평균 ↔ 정정 후 3구간 실측 평균).

### §10.1 R-S1 — 날짜/기간 조건이 **EXISTS 안**에 있으면 아우터는 전수 스캔이다 ⭐ 1순위

```sql
-- ⛔ 구본: 날짜가 EXISTS 안 → 아우터 접근조건이 못 된다
DELETE FROM 원장 WHERE EXISTS (
  SELECT 1 FROM GTT T WHERE 원장.K1=T.K1 ... AND 원장.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD'));
-- 플랜: INDEX FAST FULL SCAN PK(1,387,787행) → 행마다 GTT TABLE ACCESS FULL. cost 2,780,377

-- ✅ 정정: ①아우터로 승격(등가) ②함수는 1회 계산 변수 ③작은 GTT 를 빌드로 쓰는 세미조인 고정
v_cut := TO_CHAR(FN_NEXT_DAY(SYSDATE,'MON')-7,'YYYYMMDD');
DELETE FROM 원장 WHERE 원장.YYYYMMDD >= v_cut
  AND EXISTS (SELECT /*+ HASH_SJ DYNAMIC_SAMPLING(T 2) */ 1 FROM GTT T WHERE 원장.K1=T.K1 ...);
```

**등가 근거**: EXISTS 안의 조건이 **아우터 컬럼만** 참조하면 `EXISTS(A ∧ c) ≡ c ∧ EXISTS(A)`.
(상관 컬럼이 섞인 조건은 승격 금지 — 반드시 참조 컬럼을 먼저 확인할 것.)

**실측**: buffer gets/실행 **2,016,609 → 7**, 누적 59.34s → 0.01s.

### §10.2 R-S2 — 검증 probe 가 거대 뷰를 먼저 만들게 두지 말 것

`SELECT ... INTO ... WHERE ... AND ROWNUM=1` 형태의 **존재 검증** 한 방이 실행당 5.65s / 55,000 gets.
원인은 §9 와 같은 계보 — **GTT 추정 카디널리티 1** 이라 옵티마이저가 큰 뷰(SCM_ITEM_M 642,256행 ×2 스캔,
조인 추정 11억행)를 먼저 만들고 작은 GTT 를 나중에 붙인다.
→ `/*+ LEADING(A) DYNAMIC_SAMPLING(A 2) */` 로 **작은 GTT 를 드라이빙**으로 고정 (실측 45.66s → 2.36s).
⚠ `PUSH_PRED` 는 뷰 안 GROUP BY 때문에 효과 없음(42.45s) — **추정하지 말고 변형별로 실측**할 것.

### §10.3 R-S3 — 저장 튜닝의 **등가 증명은 대칭차집합**으로

저장은 틀리면 원장이 깨진다. "빨라졌다"만으로 채택 금지. 구본/정정본 **양방향 MINUS = 0** 을 증명한다.

```sql
SELECT COUNT(*) FROM ( (SELECT ROWID FROM 원장 WHERE <구본 술어>
                        MINUS SELECT ROWID FROM 원장 WHERE <정정 술어>)
                       UNION ALL
                       (SELECT ROWID FROM 원장 WHERE <정정 술어>
                        MINUS SELECT ROWID FROM 원장 WHERE <구본 술어>) );  -- 0 이어야 채택
```
DMF0003 실측: 대상 2,547행 동일 / 대칭차집합 **0행** / 같은 표본에서 112.43s → 5.25s.
추가로 **E2E 저장 왕복**(M 저장 → 재조회 확인 → 원복 → 재조회 확인)까지 통과해야 완료.

### §10.4 산출물

```
백업      _artifacts/_backup/DMF0003_SAVE_PERF_20260815/PKG_DMF0003_BODY_BEFORE.sql
적용      _artifacts/_apply_corporate/PKG_DMF0003_SAVE_PERF_20260815.sql   (R-S1, 마커 E20260815-SAVEPERF)
          _artifacts/_apply_corporate/PKG_DMF0003_SAVE_PERF2_20260815.sql  (R-S2, 마커 E20260815-SAVEPERF2)
```
⚠ 패키지 본문 추출/재배포 시 **CRLF 보존**(`open(..., newline='')`) — 텍스트모드로 쓰면 `\r\r\n` 이 되어
앵커가 전부 어긋난다(2026-08-15 실착). 사내 적용 완료 / **클라우드 미적용**.
