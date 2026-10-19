# PKG_DMF0052 이식 메모

프로시저 7개. As-is T-SQL → Oracle PL/SQL 이식 완료(2026-10-19). 각 PROC 뒤의 ASIS 원문은 `/* ZZZ_DELETE_ME_* ... */` 블록 코멘트로 비활성화(check-pkg P00 통과) — 컴파일에 영향 없으나 추후 완전 삭제 권장.

## 이식 매핑

- **P_DMF0052_GET_SUMMARY_DATA**: XIF_ERP_EDI_CALLOFF_ITEM_R_SN FULL OUTER JOIN(GSCM 수 vs ERP 수). `ISNUMERIC(x)>0` → `VALIDATE_CONVERSION(x AS NUMBER)=1`. 컬럼: YYYYMMDD/SEND_CNT/RCV_CNT/STATUS.
- **P_DMF0052_GET_PJT_DATA**: `#T_GSCM_DATA`·`#T_ERP_DATA` → **WITH CTE** 2개(스칼라 서브쿼리로 참조). `WITH ROLLUP` → `GROUP BY ROLLUP(...)`. `GROUPING()` 동일. `STRING_SPLIT(x,',')` → `TABLE(FN_SPLITSTRING(x,','))` → `VALUE` 컬럼.
- **P_DMF0052_GET_STATUS_DATA**: `CONVERT(FLOAT,x)` → 암묵 숫자 산술, `CONVERT(NVARCHAR,ROUND(...)) + '%'` → `TO_CHAR(ROUND(...)) || '%'`, 0-분모 보호 `NULLIF(SUM_QTY,0)` 추가.
- **P_DMF0052_GET_DETAIL_DATA**: `#T_EDI` → **WITH T_EDI CTE**. SELECT DISTINCT 의 ORDER BY CASE 식은 SELECT 리스트에 포함(SORT_KEY, PROJECT_CODE 로 참조).
- **P_DMF0052_GET_ERP_DATA**: `#T_EDI` → **WITH T_EDI CTE**. `IIF(ATTRIBUTE9='WRONG_DEMANDDATE','WRONG_DATE',ATTRIBUTE9)` → CASE 중첩.
- **P_DMF0052_GET_SPREAD_TITLE**: `SELECT @v = COUNT(*)` → `SELECT COUNT(*) INTO V_USER_COL_CNT`. IF/ELSE 두 분기 모두 `O_RC1` 로 OPEN. 시그니처 상 **O_RC2 는 동일 22컬럼 shape 의 빈 커서**(1 row=0; CAST(NULL AS ...) 로 타입 고정) — As-is 는 1 result set 이지만 harness 가 2개 생성 → 호환 유지 위해 shaped empty 커서로 처리.
- **P_DMF0052_GET_SITE_POPUP**: As-is IF/ELSE 두 분기(스키마 상이) → **O_RC1 = CHECK_SALES_SITE 분기**(P_POPUP_TYPE='CHECK_SALES_SITE' 조건), **O_RC2 = ELSE 분기**(≠ CHECK_SALES_SITE 조건). 런타임에 둘 중 하나만 실데이터 반환.

## 치환 결정

- **FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID)**: Oracle 포팅 함수 미확인 → 스칼라 서브쿼리 `(SELECT MAX(I.NICK_NAME) FROM SCM_MST_ITEM_SN I WHERE DIVISION_ID=... AND ITEM_ID=...)` 로 대체, 빈값은 `NVL(..., '-')` 로 표시. 분석서(analysis.md)가 SCM_MST_ITEM_SN 을 원천 테이블로 명시.
- **센티널**: 빈값 비교·키 매칭은 **`'/'`**(사용자 10-15 지시, memory `feedback_oracle_nvl_sentinel_slash.md`). 표시 문자(`'-'`, `'Fault'` 등)는 As-is 원문 그대로.
- **`'ALL'` 처리**: `(P_X = 'ALL' OR col IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_X,','))))` 선례.
- **빈 파라미터 처리**: Oracle `''`=NULL — As-is 의 `@p_X = ''` 분기 → `P_X IS NULL`.
- **NOLOCK**: 전부 제거.

## 미완/확인 필요

- Oracle `FN_GET_ITEM_NICKNAME` 포팅 함수가 별도로 존재한다면 스칼라 서브쿼리 → 함수 호출로 교체 검토.
- `DM_DNM_EDI_CALLOFF_ITEM.CREATE_DATE` 가 DATE 형이면 VARCHAR 파라미터와의 BETWEEN 비교에서 NLS 암묵 변환 위험(#109) — AS-IS 는 nvarchar(8) 로 비교하므로 Oracle 측 컬럼이 VARCHAR2(8) 또는 CHAR(8) 이라고 가정. 다르면 `TO_DATE(P_FROM_YYYYMMDD,'YYYYMMDD')` 로 조정 필요.
- `GET_SPREAD_TITLE` O_RC2 는 harness 생성 시그니처 유지용 shaped-empty 커서. FE 가 O_RC2 를 소비하지 않는지 재확인.
