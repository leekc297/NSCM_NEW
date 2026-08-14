-- CMBO_MktFcstEditMeasure_FULLCONV_20260812.sql — UP_FX 'MktFcstEditMeasure' 전분기 완전 변환 (사내 적용 완료분)
-- 배경: 구 등재본 = 일반 메저 1블록 축소본(변환 미완) — ①82+@measure 지정 분기 ②SEGMENT4='Y'(INSERT_YN) 필터
--   ③VMI 분기(@scmSiteId→SCM_MST_SITE.VMI_YN) ④CUST_FCST UNION ⑤TMM UNION(TMM_MEASURE_ADMIN 게이트) 전부 누락.
-- 실측(사내 2026-08-12): div만 40=2/81=2(AS-IS EXEC 동수 일치·구본 3행은 INSERT_YN='N' 메저 과다노출 결함) · 82+measure 1행(AS-IS 일치)
--   · 40+VMI사이트(Dell_NL_TLB) 3행(AS-IS 일치·VMI 메저 개방) · TMM 삼중키(81,'-',bgyoon) 3행(TMM_FCST 노출).
-- ⚠ 데이터 격차(로직 아님): TO-BE 룩업 82 ATTRIBUTE2='Y' 4건(AS-IS는 전부 '') → 82 BNPIn 미노출(구본도 동일 미노출). 메타 정정은 별도 결정 사항.
-- ⚠ FE 후속: DMF0003 MEASURE 콤보는 현재 divisionId만 전달 — @scmSiteId/@projectCode 전달 시 VMI·CUST_FCST·TMM 분기 활성(서버측 준비 완료).
-- ⚠ SQL_DTL_CTN = VARCHAR2(4000 BYTE) — 본 SQL 2571바이트 (여유 확인됨).
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = '--[E20260812-MKTFCSTEDITMEASURE-V2] AS-IS UP_FX ''MktFcstEditMeasure'' 전분기 원문보존 변환 (82+@measure 지정분기 / 일반=INSERT_YN+VMI(@scmSiteId) / CUST_FCST / TMM(@projectCode+@sesUserId) — 상호배타 가드)
SELECT CODE, NAME FROM (
-- ══ 82 지정메저 분기 (원문 IF @PARAM1=''82'' AND ISNULL(@PARAM5,'''')<>'''') ══
SELECT SEGMENT2 AS CODE, SEGMENT3 AS NAME, 0 AS DISPLAY_SEQ
FROM SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE LOOKUP_TYPE = ''MKT_FCST_MEASURE''
  AND SEGMENT1 = @divisionId
  AND SEGMENT2 = @measure
  AND NVL(@divisionId,''-'') = ''82'' AND @measure IS NOT NULL
UNION ALL
-- ══ ELSE: TMM 제외 일반 MEASURE (원문 1:1 — VMI_YN = SCM_MST_SITE(@divisionId,@scmSiteId)) ══
SELECT L.SEGMENT2 AS CODE, L.SEGMENT3 AS NAME, L.DISPLAY_SEQ
FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
WHERE 1=1
  AND L.LOOKUP_TYPE = ''MKT_FCST_MEASURE''
  AND L.VALID_YN = ''Y''
  AND L.ATTRIBUTE2 <> ''Y''  -- TMM Measure여부
  AND L.SEGMENT1 = @divisionId
  AND L.SEGMENT4 = ''Y''     -- INSERT_YN 여부
  --[C20201015-000200]
  AND ( ( NVL((SELECT S.VMI_YN FROM SCM_MST_SITE S WHERE S.DIVISION_ID=@divisionId AND S.SCM_SITE_ID=@scmSiteId),''N'') = ''N'' AND L.ATTRIBUTE1 <> ''Y'' )
     OR ( NVL((SELECT S.VMI_YN FROM SCM_MST_SITE S WHERE S.DIVISION_ID=@divisionId AND S.SCM_SITE_ID=@scmSiteId),''N'') = ''Y'' ) )
  AND ( NVL(@divisionId,''-'') <> ''82'' OR @measure IS NULL )
UNION ALL
-- ══ ELSE: CUST_FCST MEASURE (원문 1:1) ══
SELECT T.CODE, T.NAME, ROW_NUMBER() OVER (ORDER BY T.CODE) + 900 AS DISPLAY_SEQ
FROM (SELECT DISTINCT CF.MEASURE AS CODE, '' └ '' || CF.MEASURE AS NAME
	  FROM DM_MST_CUSTOMER_FCST CF
	  WHERE CF.VALID_YN = ''Y''
		AND CF.MEASURE_GROUP = ''CUST_FCST''
		AND CF.DIVISION_ID = @divisionId
		AND CF.SCM_SITE_ID = @scmSiteId) T
WHERE ( NVL(@divisionId,''-'') <> ''82'' OR @measure IS NULL )
UNION ALL
-- ══ ELSE: TMM Measure (원문 1:1 — TMM_MEASURE_ADMIN 게이트 TOP1=ROWNUM) ══
SELECT L.SEGMENT2, L.SEGMENT3, L.DISPLAY_SEQ
FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
INNER JOIN (SELECT VALID_YN, SEGMENT1, SEGMENT2, SEGMENT4
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE LOOKUP_TYPE = ''TMM_MEASURE_ADMIN''
			  AND VALID_YN = ''Y''
			  AND SEGMENT1 = @divisionId
			  AND SEGMENT2 = @projectCode
			  AND SEGMENT4 = @sesUserId
			  AND ROWNUM = 1) T
  ON ( L.SEGMENT1 = T.SEGMENT1
   AND L.VALID_YN = T.VALID_YN
   AND L.LOOKUP_TYPE = ''MKT_FCST_MEASURE''
   AND L.VALID_YN = ''Y''
   AND L.SEGMENT1 = @divisionId
   AND L.ATTRIBUTE2 = ''Y''
   AND L.SEGMENT4 = ''Y'' )
WHERE ( NVL(@divisionId,''-'') <> ''82'' OR @measure IS NULL )
) ORDER BY DISPLAY_SEQ'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'MktFcstEditMeasure';
COMMIT;

-- VERIFY: 저장 길이 = 2439 자 기대
SELECT SQL_ID, LENGTH(SQL_DTL_CTN) AS LEN, LENGTHB(SQL_DTL_CTN) AS BYTES
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'MktFcstEditMeasure';
