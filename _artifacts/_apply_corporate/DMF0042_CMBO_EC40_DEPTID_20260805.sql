-- =====================================================================================
-- DMF0042 F-3 — CMBO 'EndCustomerByDivision40' DEPT_ID 컬럼 확장 (2026-08-05, ⏸승인 대기)
-- 근거  : AS-IS UP_FX_GetCommonDataList 'EndCustomerByDivision40'(SP10 L13630) 는 @PARAM2(team)
--         로 owner 1토큰 사용자 부서(B.DEPT_ID)를 서버 필터. TO-BE 등록본은 DEPT_ID 미반환·team 미지원
--         → 조회조건(40 EC)·grid cascade(DEPT_ID40→EC40) 의 Team 반영이 불가능했음.
-- 방식  : TO-BE 확립 규약(카탈로그 EndCustomerField)대로 **DEPT_ID 컬럼 반환 + FE 클라 필터**.
--         FE 는 2026-08-05 선반영 완료(BusinessPlanForm toOptions deptIds / GRID_CASCADE_FILTERS
--         END_CUSTOMER40 DEPT_ID40 키 — DEPT_ID 컬럼이 생기는 즉시 발효, 없는 동안은 관대 통과).
--         lookup UNION 행은 DEPT_ID NULL(공란=통과 규약 — AS-IS 는 team 선택 시 숨김 Δ, §3-Δ⑤ 기록).
-- 검증  : 적용 후 SELECT 로 DEPT_ID 채움 확인 + DMF0042 화면 40 Team 선택 → EC 목록 축소 확인.
-- 소비자 : FE 전수 grep(2026-08-05) — business-plan Form·grid 셀콤보 / sales-plan Form(DMF0021 —
--          동일 CODE/NAME 소비라 컬럼 추가 무해. 0021 도 40 EC team 필터 동일 누락 가족 — 확장 시 함께 발효
--          가능하나 0021 FE 필터 반영은 별도 작업) / mock columnSample. DEPT_ID 는 additive — 파손 소비자 0.
-- 원복  : 하단 주석의 기존 SQL_DTL_CTN 전문으로 UPDATE.
-- =====================================================================================
UPDATE SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN =
'SELECT DISTINCT C.DEPT_ID, A.PROJECT_CODE AS CODE, NVL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
FROM SCM_MGR.SCM_MST_SITE_ITEM A
JOIN SCM_MGR.SCM_MST_SSO_USER_INFO B ON B.USER_ID = TRIM(CASE WHEN INSTR(A.OWNER, '','') > 0 THEN SUBSTR(A.OWNER, 1, INSTR(A.OWNER, '','') - 1) ELSE A.OWNER END)
JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON C.DEPT_ID = B.DEPT_ID
LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = ''END_CUSTOMER'' AND D.VALID_YN = ''Y''
WHERE A.DIVISION_ID = ''40'' AND A.VALID_YN = ''Y''
UNION
SELECT NULL AS DEPT_ID, SEGMENT2, SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE LOOKUP_TYPE = ''END_CUSTOMER'' AND SEGMENT1 = ''40'' AND SEGMENT2 <> ''-'' AND VALID_YN = ''Y''
ORDER BY 2'
     , LAST_UPDATED_BY = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'EndCustomerByDivision40'
   AND USE_YN = 'Y';

COMMIT;

-- 검증 (기대: 1행 갱신 + DEPT_ID 값 존재)
-- SELECT SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='EndCustomerByDivision40';

-- ── 원복용 기존 본문 (2026-08-05 실측 백업) ─────────────────────────────────────────
-- SELECT DISTINCT A.PROJECT_CODE AS CODE, NVL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
-- FROM SCM_MGR.SCM_MST_SITE_ITEM A
-- JOIN SCM_MGR.SCM_MST_SSO_USER_INFO B ON B.USER_ID = TRIM(CASE WHEN INSTR(A.OWNER, ',') > 0 THEN SUBSTR(A.OWNER, 1, INSTR(A.OWNER, ',') - 1) ELSE A.OWNER END)
-- JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON C.DEPT_ID = B.DEPT_ID
-- LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
-- WHERE A.DIVISION_ID = '40' AND A.VALID_YN = 'Y'
-- UNION
-- SELECT SEGMENT2, SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
-- WHERE LOOKUP_TYPE = 'END_CUSTOMER' AND SEGMENT1 = '40' AND SEGMENT2 <> '-' AND VALID_YN = 'Y'
-- ORDER BY 1
