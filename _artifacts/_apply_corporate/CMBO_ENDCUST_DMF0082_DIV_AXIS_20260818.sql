-- CMBO_ENDCUST_DMF0082_DIV_AXIS_20260818.sql
--   DMF0082 그리드 End Customer 셀 콤보 — **division 축 분기 정정** (40 전용 → 40/81/82 공용)
--
-- 신고: 그리드 End Customer 가 명칭이 아니라 코드로 보이고, Insert 행에서도 명칭으로 못 고른다.
--       (UI Category Setup 확인 결과 40 전용 End Customer 콤보가 걸려 있었음)
--
-- 원인: `EndCustomerByDivisionDMF0082` 의 ② 분기가 @divisionId 만 있으면 **division 무관하게**
--       SCM_MST_SITE_ITEM.PROJECT_CODE 를 UNION 한다. 40 은 PROJECT_CODE 가 곧 End Customer 라
--       우연히 맞지만, 81/82 는 축이 다르다.
--       실측(2026-08-18): div 81 콤보 반환 = 'A15AI4002','A15AI4005' …(프로젝트 코드)
--                        div 81 원장 END_CUSTOMER = 'Volvo'(39) 'FCA'(34) 'Ford'(29) 'HKMC'(26) …
--       ⇒ 셀 값이 dataMap 목록에 없어 wijmo 가 원시값을 그대로 출력하고,
--          Insert 행 드롭다운에는 프로젝트 코드가 뜬다.
--       비교: 조회조건용 `EndCustomer` 는 `CASE WHEN DIVISION_ID='40' THEN PROJECT_CODE
--             ELSE END_CUSTOMER END` 로 division 분기가 있다. 그리드 콤보에만 빠졌다.
--
-- 조치: ② 를 40 전용으로 좁히고, 81/82 용 ③ SCM_MST_SITE.END_CUSTOMER 축을 신설.
--       명칭은 END_CUSTOMER 룩업(SEGMENT2=원장값 / SEGMENT3=명칭) 에서 가져오되 없으면 원장값 폴백.
--       ⚠ 실측: div 81 룩업 216행 중 **별도 명칭 보유 0행** — 즉 81 은 값 자체가 이미 명칭이다
--         (Volvo/BMW/HKMC). 이번 수정의 효과는 "명칭으로 치환"이 아니라
--         **매핑 성립(정상 표시) + Insert 행에서 올바른 후보 선택**이다.
--
-- 영향: 이 콤보는 이름 그대로 **DMF0082 전용** — 다른 화면 영향 없음
--       (오늘 별도 적용한 공유 `EndCustomer` ORDER BY 변경과는 무관).

UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = 'SELECT DISTINCT CODE, NAME FROM (
  /* [E20260814-ENDCUST] No.64 — (1) END_CUSTOMER 룩업 축 (division 상별) */
  SELECT L.SEGMENT2 AS CODE, NVL(L.SEGMENT3, L.SEGMENT2) AS NAME
  FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = ''END_CUSTOMER''
  AND    L.VALID_YN = ''Y''
  AND    L.SEGMENT2 <> ''-''
  AND    ( NVL(TRIM(@divisionId), ''-'') = ''-'' OR L.SEGMENT1 = TRIM(@divisionId) )
  UNION ALL
  /* (2) 40 전용 — SITE_ITEM owner→부서 축 (AS-IS EndCustomerByDivision40 원문) */
  SELECT A.PROJECT_CODE AS CODE, NVL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
  FROM   SCM_MGR.SCM_MST_SITE_ITEM A
  JOIN   SCM_MGR.SCM_MST_SSO_USER_INFO B ON B.USER_ID = TRIM(REGEXP_SUBSTR(A.OWNER, ''[^,]+'', 1, 1))
  JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON C.DEPT_ID = B.DEPT_ID
  LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
         ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2
        AND D.LOOKUP_TYPE = ''END_CUSTOMER'' AND D.VALID_YN = ''Y''
  WHERE  A.VALID_YN = ''Y''
  AND    NVL(TRIM(@divisionId), ''-'') <> ''-''
  AND    A.DIVISION_ID = TRIM(@divisionId)
  AND    TRIM(@divisionId) = ''40''
  UNION ALL
  /* [E20260818-ENDCUST81] (3) 81/82 — SCM_MST_SITE.END_CUSTOMER 축 (조회조건 EndCustomer 와 동일 규약) */
  SELECT S.END_CUSTOMER AS CODE, NVL(D.SEGMENT3, S.END_CUSTOMER) AS NAME
  FROM   SCM_MGR.SCM_MST_SITE S
  LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
         ON D.SEGMENT1 = S.DIVISION_ID AND D.SEGMENT2 = S.END_CUSTOMER
        AND D.LOOKUP_TYPE = ''END_CUSTOMER'' AND D.VALID_YN = ''Y''
  WHERE  S.END_CUSTOMER IS NOT NULL
  AND    NVL(TRIM(@divisionId), ''-'') <> ''-''
  AND    S.DIVISION_ID = TRIM(@divisionId)
  AND    TRIM(@divisionId) <> ''40''
) ORDER BY NAME',
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'EndCustomerByDivisionDMF0082';

COMMIT;

-- 검증: 마커 2종 존재 + 길이 4000 이내
SELECT SQL_ID, USE_YN, LENGTH(SQL_DTL_CTN) LEN,
       CASE WHEN SQL_DTL_CTN LIKE '%E20260818-ENDCUST81%' THEN 'OK' ELSE 'NG' END AS DIV81_AXIS,
       CASE WHEN SQL_DTL_CTN LIKE '%TRIM(@divisionId) = ''40''%' THEN 'OK' ELSE 'NG' END AS DIV40_GUARD
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID = 'EndCustomerByDivisionDMF0082';
