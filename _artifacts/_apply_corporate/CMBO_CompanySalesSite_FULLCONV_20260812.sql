-- CMBO_CompanySalesSite_FULLCONV_20260812.sql — UP_FX 'CompanySalesSite' IF/ELSE 2분기 완전 변환 (사내 적용 완료분)
-- 배경: 구 등재본 가드 오변환 2중 결함 — ①IF가드 첫 항이 @scmSiteId 아닌 @divisionId IS NULL(오배치)
--   ②ELSE가드 @scmSiteId <> '' 직역(Oracle ''=NULL → 항상 UNKNOWN = ELSE 분기 전멸). division만 전달 시 0행 실사고 재현됨.
-- 실측(사내 2026-08-12): 무파라미터 17행(구본 동일=회귀0) · 81만 0→17행(결함 해소, AS-IS EXEC 17행 일치) · 40+Dell_NL_TLB 0→1행(HQ00 — AS-IS EXEC 1행 일치) · site단독 17→1행(구본 오류 정정).
-- ⚠ SQL_DTL_CTN = VARCHAR2(4000 BYTE) — 본 SQL 854바이트 (여유 확인됨).
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = '--[E20260812-COMPANYSALESSITE-V2] AS-IS UP_FX ''CompanySalesSite'' IF/ELSE 2분기 원문보존 변환 (가드=@scmSiteId 빈값 상호배타 — 구본 @divisionId 오가드 + <>'''' 직역 사장 분기 정정)
SELECT A.COMPANY_ID AS CODE
	 , A.COMPANY_ID AS NAME
  FROM SCM_MST_COMPANY_SN A
 WHERE ( @scmSiteId IS NULL OR @scmSiteId = '''' )  -- 원문 IF @PARAM2 IS NULL OR LEN(@PARAM2)=0 OR @PARAM2='''' (Oracle ''''=NULL 수렴)
UNION ALL
-- ══ ELSE 분기 (@PARAM2[SCM_SITE_ID] 존재) — 원문 1:1 ══
SELECT A.COMPANY_ID AS CODE
	 , A.COMPANY_ID AS NAME
  FROM SCM_MST_SITE A
 WHERE (( @divisionId IS NULL OR @divisionId='''' ) OR A.DIVISION_ID = @divisionId)
   AND (( @scmSiteId IS NULL OR @scmSiteId='''' ) OR A.SCM_SITE_ID = @scmSiteId)
   AND @scmSiteId IS NOT NULL  -- 원문 ELSE — ''''=NULL 방언(<>'''' 직역은 항상 UNKNOWN=분기 전멸)'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'CompanySalesSite';
COMMIT;

-- VERIFY: 저장 길이 = 736 자 기대
SELECT SQL_ID, LENGTH(SQL_DTL_CTN) AS LEN, LENGTHB(SQL_DTL_CTN) AS BYTES
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'CompanySalesSite';
