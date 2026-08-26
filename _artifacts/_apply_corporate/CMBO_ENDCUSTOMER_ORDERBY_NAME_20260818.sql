-- CMBO_ENDCUSTOMER_ORDERBY_NAME_20260818.sql
--   공유 콤보 `EndCustomer` 정렬 키 변경 — 팀(DEPT_ID) 우선 → **이름(NAME)** 우선
--
-- 신고: DMF0082 조회조건 End Customer 에 Sort 가 안 먹는다.
-- 원인: ORDER BY 의 **선두 키가 DEPT_ID** 라 "팀별로 묶고 팀 안에서만 코드순"으로 반환된다.
--       조회조건 드롭다운은 팀 구분 없이 한 줄로 펼쳐지므로 정렬이 안 된 것처럼 보인다.
--       (div 81 실측 503행: ESMI(AS), FCA, BMW, JLR, LGESDJ … Shanghai Feixiang, VW, Audi, Porsche …)
--       ⚠ 표시명/코드 불일치는 아니다 — 503행 전부 CODE = NAME.
--
-- 조치: ORDER BY DIVISION_ID, DEPT_ID, CODE  →  ORDER BY DIVISION_ID, NAME, CODE
--       · DEPT_ID 는 SELECT 목록에 그대로 둔다 — FE cascade(팀 필터)가 이 컬럼을 소비한다.
--       · NAME 은 SELECT 의 별칭(NVL(D.SEGMENT3, …)) 이라 SELECT DISTINCT + ORDER BY 별칭 조합에 적법.
--
-- ⚠ 공유 콤보다. 소비 화면(FE grep, BACKUP 폴더 제외 18개):
--     demand: forecast-price / sales-plan / mkt-fcst / business-plan / sales-monitoring /
--             customer-fcst-upload
--     master: searchFields(공용 EndCustomerField) / customer-model-mapping /
--             sales-site-project-model / customer-forecast-master /
--             projectByDivisionModal / ownerByDivisionModal
--     sdm   : project-reg (constants + Tab1Grid)
--   전 화면이 동일하게 이름순으로 바뀐다(팀 순서에 의존하던 화면은 없음 — 드롭다운 표시용 축).

UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN     = REPLACE(SQL_DTL_CTN,
                                 'ORDER BY DIVISION_ID, DEPT_ID, CODE',
                                 'ORDER BY DIVISION_ID, NAME, CODE'),
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'EndCustomer'
   AND SQL_DTL_CTN LIKE '%ORDER BY DIVISION_ID, DEPT_ID, CODE%';

COMMIT;

-- 검증 ①: 1행이 바뀌고, 새 ORDER BY 가 들어갔는가
SELECT SQL_ID, USE_YN,
       CASE WHEN SQL_DTL_CTN LIKE '%ORDER BY DIVISION_ID, NAME, CODE%' THEN 'OK' ELSE 'NG' END AS ORDERBY_NAME,
       CASE WHEN SQL_DTL_CTN LIKE '%DEPT_ID,%' THEN 'SELECT 목록 유지' ELSE '⚠ DEPT_ID 소실' END AS DEPT_COL,
       LENGTH(SQL_DTL_CTN) AS LEN   -- VARCHAR2(4000 BYTE) 한도 확인
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID = 'EndCustomer';

-- 검증 ②: 실제 반환 순서가 이름순인가 (division 은 환경에 맞게 교체)
--   기대: A→Z 오름차순으로 나열된다.
