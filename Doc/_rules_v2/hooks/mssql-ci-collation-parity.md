# Hook #118 — MSSQL 암묵 등가(CI collation·숫자 표기) 상실 함정 (Oracle 1:1 변환 시)

> **트리거**: MSSQL→Oracle 변환 SP에서 문자열 리터럴 비교(IN/=/DELETE WHERE) 존재 · `REPLACE(숫자컬럼, '.0', ...)` 류 표기 의존 로직 · "AS-IS는 되는데 Oracle만 중복/순서 동률/필터 미작동"
>
> 위반 시: 원문 1바이트 무수정 이식이 오히려 결함이 됨 — MSSQL이 암묵으로 보정해주던 등가가 Oracle에서 사라진다.

작성: 2026-07-24 (DMF0003 종속 메저 사고 계보 3건 — 사용자 룰화 요구)
관련 메모리: `feedback_sp_multiselect_filter_and_conversion_pitfalls.md` (+2026-07-23/24 추가분)

---

## §1. 유형 A — CI collation 등가 상실 (대소문자)

MSSQL 기본 collation 은 대소문자 무시(CI) — `'VMI_IN_PLAN' = 'VMI_In_Plan'` 참. Oracle 은 구분(CS).
**원문 그대로 복사한 리터럴 비교가 조용히 미매칭** → DELETE 미작동(중복), 필터 전멸, 조인 누락.

| 실사례 | 결과 |
|---|---|
| DMF0003 VMI 강제추가 `DELETE ... MEASURE IN ('VMI_IN_PLAN',...)` (실코드 'VMI_In_Plan') | 기존행 미삭제 + 재삽입 = 중복 |
| 배치 MAKE_CUST_FCST `MEASURE IN ('Customer Fcst',...)` (실데이터 'Customer FCST') | EXCEL 업로드분 상위(CUST_FCST) 통합 통째 누락 — "└ EXCEL 만 표시" |

**fix 표준**: `UPPER(col) IN ('대문자값',...)` (CI 등가). 값 다양성 주의(UPPER 충돌 검사).
**sweep 표준**: 의심 리터럴을 전 오브젝트 검색 — `SELECT name,type,line FROM user_source WHERE text LIKE '%''리터럴''%'` (⚠ 주석 내부 매칭 오탐 — `TRIM(text) NOT LIKE '--%'` + `/* */` 블록 수동 배제. [Org.] 서브메저 7종을 "누락"으로 오탐한 선례 — **주석 내부 regex 매칭 금지**).

## §2. 유형 B — 숫자→문자 표기 차이로 사문화된 로직 ('.0')

MSSQL `CONVERT(varchar, numeric(x,1))`='70.0' 전제의 `REPLACE(sort,'.0',key)` 가
원천이 int 이거나 Oracle `TO_CHAR(2)`='2' 라 **'.0' 이 존재하지 않아 no-op** → 설계 의도(.1~.4/.9 정렬 부여) 전체 무효 = 동률 정렬·순서 뒤죽박죽.

| 실사례 | fix |
|---|---|
| DMF0003 Div82 RP 종속 SORT `.1~.4`/RP `.9` 부여 실패(전부 동률) | `CASE WHEN INSTR(sort,'.')=0 THEN sort||key ELSE REPLACE(sort,'.0',key) END` |

**판정 원칙**: 원문 로직이 **AS-IS 에서도 사문**(원천 타입 실측으로 확인)이면, 무수정 이식이 아니라 **주석에 남은 설계 의도([C20201103] 등)를 복원**하는 것이 정본. 근거(원천 타입·주석 의도) README 명시.

## §3. 공통 검증 규격
1. fix 전 재현 실측(중복/동률 관찰) → fix 후 동일 파라미터 재실행 대비.
2. 치환은 **비주석 라인만** (문자열 count 는 주석 오탐 — DMF0003 6매칭 중 live 2 선례).
3. 유형 A/B 는 함께 다닌다 — 하나 발견 시 같은 SP 의 다른 리터럴 비교·REPLACE 도 sweep.
