-- CMBO_TeambyDivision2_FULLCONV_20260812.sql — UP_FX 'TeambyDivision2' IF/ELSE 3분기 완전 변환 (사내 적용 완료분)
-- 배경: 구 등재본은 가드 없는 합집합 재작성본 — ALL분기 owner부 40/42/44 제한·SALES부 권한 필터·division 분기 전부 탈락(파라미터 무시 148행 고정).
--   원문 3분기(ALL/40/기타) 상호배타 가드 복원. 권한 축은 TB_FX→UNIT_AUTH_MPG 대체(TeambyDivision 선례 동일). @langCd NAME=TO-BE 확장 유지.
-- 실측(사내 2026-08-12, minyonglee1): 무파라미터·ALL=29 · 81=5 · 40=17(TeambyDivision 정본 40 실측과 일치) · '81,82'=11.
--   AS-IS EXEC 81=30행 대비 적은 것은 SCM_MST_SITE 데이터 결핍 계보(SALES 81 부서 AS-IS 30 vs Oracle 6 — TeambyDivision 정본 문서화 동일)이며 쿼리 파리티는 동구조.
-- ⚠ SQL_DTL_CTN = VARCHAR2(4000 BYTE) — 본 SQL 2664바이트 (여유 확인됨).
-- ⭐ v2 (2026-08-12 클라우드 -9994 정정): FN_STRING_SPLIT → SCM_MGR. 접두 명시 (무접두 = BE 세션 스키마 따라 ORA-904)
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = '--[E20260812-TEAMBYDIVISION2-V2] AS-IS UP_FX ''TeambyDivision2'' IF/ELSE 3분기 원문보존 변환 (가드=@divisionId ALL/40/기타 상호배타. @langCd NAME=TO-BE 확장 유지)
SELECT CODE, NAME FROM (
-- ══ ALL 분기① (원문 IF @Param1=''ALL'' — owner 기반, DIVISION 40/42/44) — 원문 1:1 ══
SELECT DISTINCT C.DEPT_ID AS CODE
	 , CASE @langCd WHEN ''EN'' THEN C.DEPT_NAME_EN WHEN ''CN'' THEN C.DEPT_NAME_CN ELSE C.DEPT_NAME_KO END AS NAME
  FROM SCM_MST_SITE_ITEM A
	 , SCM_MST_SSO_USER_INFO B
	 , SCM_MST_SSO_DEPT_INFO C
 WHERE A.OWNER = B.USER_ID
   AND B.DEPT_ID = C.DEPT_ID
   AND A.DIVISION_ID IN (''40'', ''42'', ''44'')  -- 20190124
   AND NVL(@divisionId,''ALL'') = ''ALL''  -- 원문 IF @Param1='''' → ''ALL'' 전처리 포함
UNION ALL
-- ══ ALL 분기② (SALES 배정 부서 + 권한) — 원문 1:1 ══
SELECT DISTINCT B.DEPT_ID AS CODE
	 , CASE @langCd WHEN ''EN'' THEN B.DEPT_NAME_EN WHEN ''CN'' THEN B.DEPT_NAME_CN ELSE B.DEPT_NAME_KO END AS NAME
  FROM SCM_MST_SITE          A
	 , SCM_MST_SSO_DEPT_INFO B
 WHERE A.SITE_TYPE = ''SALES''
   AND A.DEPT_ID = B.DEPT_ID
   AND A.DIVISION_ID IN (SELECT UNIT_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
						  WHERE USER_ID = @sesUserId AND UNIT_TP_CD = ''D'' AND USE_YN = ''Y'')  -- 원문 TB_FX_UserGroupAuthExtention(AuthType=''D'') = TO-BE 권한 체계 대체(TeambyDivision 선례 동일)
   AND NVL(@divisionId,''ALL'') = ''ALL''
UNION ALL
-- ══ 40 분기 (원문 ELSE IF @Param1=''40'' — 소형 owner 기반) — 원문 1:1 ══
SELECT DISTINCT C.DEPT_ID AS CODE
	 , CASE @langCd WHEN ''EN'' THEN C.DEPT_NAME_EN WHEN ''CN'' THEN C.DEPT_NAME_CN ELSE C.DEPT_NAME_KO END AS NAME
  FROM SCM_MST_SITE_ITEM A
	 , SCM_MST_SSO_USER_INFO B
	 , SCM_MST_SSO_DEPT_INFO C
 WHERE A.OWNER = B.USER_ID
   AND B.DEPT_ID = C.DEPT_ID
   AND A.DIVISION_ID = ''40''
   AND NVL(@divisionId,''ALL'') = ''40''
UNION ALL
-- ══ ELSE 분기 (특정 division CSV — SALES 배정 부서 + 권한) — 원문 1:1 ══
SELECT DISTINCT B.DEPT_ID AS CODE
	 , CASE @langCd WHEN ''EN'' THEN B.DEPT_NAME_EN WHEN ''CN'' THEN B.DEPT_NAME_CN ELSE B.DEPT_NAME_KO END AS NAME
  FROM SCM_MST_SITE          A
	 , SCM_MST_SSO_DEPT_INFO B
 WHERE A.SITE_TYPE = ''SALES''
   AND A.DEPT_ID = B.DEPT_ID
   AND A.DIVISION_ID IN ( SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(NVL(@divisionId,''ALL''),'','')) )  -- 원문 CASE..IN String_Split(@Param1)
   AND A.DIVISION_ID IN (SELECT UNIT_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
						  WHERE USER_ID = @sesUserId AND UNIT_TP_CD = ''D'' AND USE_YN = ''Y'')
   AND NVL(@divisionId,''ALL'') NOT IN (''ALL'',''40'')
) ORDER BY NAME, CODE  -- 원문 ALL분기 ORDER BY NAME, CODE (단일문 통합 제약으로 전분기 공통)'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'TeambyDivision2';
COMMIT;

-- VERIFY: 저장 길이 = 2422 자 기대
SELECT SQL_ID, LENGTH(SQL_DTL_CTN) AS LEN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'TeambyDivision2';
