# DMF0043_01 (ContributeView) 보완 클라우드 적용 패키지 — 2026-06-11

> DMF0043 의 1번째 sub-screen (Contribute View — 기여매출 목록 조회). 메인 화면 DMF0043 와 별개.

## 사고 + Fix 요약

| # | 사고 | Root cause | Fix |
|---|---|---|---|
| 1 | 조회 시 "데이터 없음" 표시 (silent) | EXCEPTION 핸들러가 v_sql_text 의 ORA-00904 를 catch 후 빈 cursor (`SELECT NULL AS DUMMY FROM DUAL WHERE 1=0`) 로 fallback → BE 가 정상 응답으로 인식 | EXCEPTION 핸들러 silent fail 대신 _DEBUG_VSQL 진단 테이블 사용 + ORDER BY A. 패턴 정정 |
| 2 | ORDER BY A.YYYYMM, ..., A.DM_BIZ_TYPE → ORA-00904 | Oracle UNION ALL 의 끝 ORDER BY 는 table alias 불가 (MSSQL 에서는 허용) | v_orderby 구성에서 'A.' prefix 제거 |
| 3 | 조회 5+ 분 hang | UF_FX_STRING_SPLIT (PIPELINED PL/SQL) 가 36K plan row × row 마다 context switch + collection allocation. CARDINALITY=1 (GTT 통계 부재) 로 NESTED LOOPS 5단계 | inline TRIM(SUBSTR(I.OWNER, 1, NVL(NULLIF(INSTR(I.OWNER, ','), 0) - 1, LENGTH(I.OWNER)))) + LEADING/USE_HASH/DYNAMIC_SAMPLING 힌트 |
| 4 | SAVE 후 cell NULL 표시 | SITE_ITEM 의 PG = '' (사내 schema dropped column 회피) vs RATIO 의 PG 실값 → LEFT JOIN 0 match | PRODUCT_GROUP 하드코딩 '' → 'N' (FE save default 와 align). 추가 cloud data 활용 위해 INNER JOIN 의 PG 조건 제거 |

## 배포 파일

| 파일 | 내용 |
|---|---|
| `01_SP_BODY/050_DMF0043_GET_CONTRIBUTION_SALES_LIST_Body.sql` | SP body (5축 fix 통합본) |

## 적용 순서

1. 백업: `SELECT DBMS_METADATA.GET_DDL('PROCEDURE','DMF0043_GET_CONTRIBUTION_SALES_LIST') FROM DUAL;`
2. 본 파일 실행 (CREATE OR REPLACE)
3. STATUS=VALID 확인
4. 실 데이터 검증 — DMF0043_01 진입 → Year=2024 + Version popup 의 Period 시작 2026-01-01 이전 → R_S_20260128_V002_C 선택 → 조회 → 데이터 표시 + 빠른 응답

## 합격 기준

| 항목 | 기준 |
|---|---|
| STATUS | VALID |
| 응답 시간 | 수십 초 이내 (이전 5+ 분 → HASH JOIN + DYNAMIC_SAMPLING) |
| Row 수 | 조회 row 수 > 0 (cloud 데이터 활용으로 풍부) |

## 추가 동봉 (필요 시) — 사내 적용된 인덱스

본 SP 의 성능 fix 와 별개로 사내 Oracle 측에 다음 3 인덱스 적용:

| 인덱스 | 컬럼 | 효과 |
|---|---|---|
| IDX01_DM_MST_CONTRIBUTE_RATIO_DTL | VER_SEQ + 6 join keys + YYYYMM (COMPRESS 4) | DTL JOIN 의 INDEX RANGE SCAN |
| IDX_DM_PLN_SALES_PLAN_REPORT_C_VMD | VERSION_NO, MEASURE, DIVISION_ID, YYYYMMDD | PK 16-col 우회 |
| FBI_SCM_MST_SITE_ITEM_OWNER_TOKEN1 | REGEXP_SUBSTR(OWNER, '[^,]+', 1, 1) | (이 SP 에서는 직접 안 씀 — 다른 SP 호환) |

> 클라우드 측 동일 인덱스 부재 시 추가 등록 권장. 본 패키지에 별도 SQL 미포함 — DBA 결정 사항.

## 룰 보강

- `Doc/_rules_v2/hooks/sp-no-fake-data-extraction.md` — DUMMY cursor / NVL NULL / bare != 'Y' / ORDER BY A. / UF_FX_STRING_SPLIT / SUBSTR pos=0 등 18 패턴 절대 금지
- 메모리 `feedback_sp_no_fake_extraction.md` / `feedback_dropped_column_get_save_alignment.md`

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-11 | **본 패키지 초기 작성** (DMF0043_01 silent 0 rows + 속도 사고 종합 fix) |
