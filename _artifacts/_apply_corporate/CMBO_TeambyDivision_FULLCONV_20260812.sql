-- CMBO_TeambyDivision_FULLCONV_20260812.sql — UP_FX 'TeambyDivision' IF/ELSE 2분기 완전 변환 (사내 적용 완료분)
-- 배경: 구 등재본은 SCM_MST_SITE_ITEM.DEPT_ID 원천 재작성본(AS-IS 스키마에 그 컬럼 자체가 없음 — 실측)이라
--   비40 분기(SITE_TYPE='SALES' 배정 부서)가 미변환 → 81 기준 90팀 과다(AS-IS 30팀). 원문 2분기 복원.
-- 실측(사내 2026-08-12, minyonglee1): 81=5·82=6·40(owner 경로)=17·ALL=12·멀티 '81,82'=11.
--   ⚠ 81 이 AS-IS 30 대비 적은 것은 로직이 아니라 **사내/클라우드 Oracle SCM_MST_SITE 데이터 결핍**
--   (SALES·81 부서: AS-IS 32 vs Oracle 8 — SITE 마스터 이관 누락 계보. 쿼리 파리티는 동구조 실측으로 확인).
-- ⭐ v2 (2026-08-12 클라우드 -9994 정정): FN_STRING_SPLIT → SCM_MGR. 접두 명시 (무접두 = BE 세션 스키마 따라 ORA-904)
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = '--[E20260812-TEAMBYDIVISION-V2] AS-IS UP_FX ''TeambyDivision'' IF/ELSE 2분기 원문보존 변환 (가드=@divisionId ''40'' 여부 상호배타)
-- ══ 비40 분기 (원문 IF @Param1 <> ''40'' — SITE_TYPE=''SALES'' 배정 부서) — 원문 1:1 ══
SELECT DISTINCT
	   A.DIVISION_ID AS DIVISION_ID
	 , B.DEPT_ID       AS CODE
	 , CASE @langCd WHEN ''EN'' THEN B.DEPT_NAME_EN
	                WHEN ''CN'' THEN B.DEPT_NAME_CN
	                ELSE B.DEPT_NAME_KO
	                END AS NAME
FROM   SCM_MST_SITE          A
	 , SCM_MST_SSO_DEPT_INFO B
WHERE  A.SITE_TYPE = ''SALES''
AND    A.DEPT_ID  = B.DEPT_ID
AND    CASE WHEN NVL(@divisionId,''ALL'') = ''ALL'' THEN ''ALL''
	   ELSE A.DIVISION_ID
	   END  IN ( SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(NVL(@divisionId,''ALL''),'','')) )
AND    A.DIVISION_ID IN (SELECT UNIT_ID
		FROM   SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
		WHERE  USER_ID = @sesUserId
		AND    UNIT_TP_CD = ''D''
		AND    USE_YN = ''Y'')  -- 원문 TB_FX_UserGroupAuthExtention(AuthType=''D'') = TO-BE 권한 체계 대체(UserTeamByDivision 선례 동일)
AND    NVL(@divisionId,''ALL'') <> ''40''  -- 원문 IF @Param1<>''40'' (''''→''ALL'' 전처리 포함 — Oracle ''''=NULL→NVL)
UNION ALL
-- ══ 40 분기 (원문 ELSE — site_item OWNER 1번 토큰 사용자의 부서) — 원문 1:1 ══
SELECT DISTINCT
	   A.DIVISION_ID AS DIVISION_ID
	 , C.DEPT_ID AS CODE
	 , CASE @langCd WHEN ''EN'' THEN C.DEPT_NAME_EN
	                WHEN ''CN'' THEN C.DEPT_NAME_CN
	                ELSE C.DEPT_NAME_KO
	                END AS NAME
FROM   SCM_MST_SITE_ITEM     A
	 , SCM_MST_SSO_USER_INFO B
	 , SCM_MST_SSO_DEPT_INFO C
WHERE  B.USER_ID = TRIM(REGEXP_SUBSTR(A.OWNER, ''[^,]+'', 1, 1))  -- 원문 top 1 token String_Split(a.owner)
AND    B.DEPT_ID = C.DEPT_ID
AND    A.DIVISION_ID = ''40''
AND    NVL(@divisionId,''ALL'') = ''40''  -- 원문 ELSE 분기
ORDER BY 3, 2  -- 원문 ORDER BY NAME, CODE (DIVISION_ID 컬럼 추가로 3=NAME, 2=CODE)'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'TeambyDivision';
COMMIT;

-- VERIFY: 저장 길이 = 1753 자 기대
SELECT SQL_ID, LENGTH(SQL_DTL_CTN) AS LEN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'TeambyDivision';
