-- CMBO_SalesPlant_FULLCONV_20260812.sql — UP_FX 'SalesPlant' IF/ELSE 2분기 완전 변환 (사내 적용 완료분)
-- 배경: 구 등재본은 ELSE(ITEM 기반) 분기가 주석 보존 상태로 활성 SQL 에서 누락(변환 미완).
--   원문 구조 보존 + 상호배타 가드(@itemId 빈값) 단일문 통합. ELSE 가드는 Oracle ''=NULL 방언 등가(IS NOT NULL).
-- 실측(사내 2026-08-12): IF분기 전체 46/81 11/40 10행(구본 동일) · ELSE분기 40 3행/82 6행/item단독 13행.
-- ⚠ SQL_DTL_CTN = VARCHAR2(4000 BYTE) — 본 SQL 3789바이트 (여유 확인됨).
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = '--[E20260812-SALESPLANT-V2] AS-IS UP_FX ''SalesPlant'' IF/ELSE 2분기 원문보존 변환 (가드=@itemId 빈값 상호배타. 상세: Doc/화면분석서)
SELECT DISTINCT
	   S.DIVISION_ID AS DIVISION_ID
	 , CASE WHEN OSP_YN = ''Y'' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS CODE
	 , CASE WHEN OSP_YN = ''Y'' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS NAME
FROM   SCM_MST_SITE S
WHERE  1 = 1
AND    SITE_TYPE = ''PLANT''
--AND    OSP_YN    <> ''Y''
AND    (@companyId IS NULL OR @companyId='''' OR S.COMPANY_ID=@companyId)
AND    (@divisionId IS NULL OR @divisionId='''' OR S.DIVISION_ID=@divisionId)
AND    ( @itemId IS NULL OR @itemId = '''' )  -- 원문 IF ISNULL(@Param4,'''')='''' 직역
UNION ALL
SELECT DISTINCT
	   S.DIVISION_ID AS DIVISION_ID
	 , PLANT_ID AS CODE
	 , PLANT_ID AS NAME
FROM   SCM_MST_SITE S
WHERE  1 = 1
AND    SITE_TYPE = ''CORP''
AND    (@companyId IS NULL OR @companyId='''' OR S.COMPANY_ID=@companyId)
AND    (@divisionId IS NULL OR @divisionId='''' OR S.DIVISION_ID=@divisionId)
AND    ( @itemId IS NULL OR @itemId = '''' )  -- 원문 IF ISNULL(@Param4,'''')='''' 직역
-- ══ ELSE 분기 (@Param4 존재 — ITEM 기반) — 원문 1:1 ══
UNION ALL
SELECT DISTINCT
	   S.DIVISION_ID AS DIVISION_ID
	 , CASE WHEN OSP_YN = ''Y'' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS CODE
	 , CASE WHEN OSP_YN = ''Y'' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS NAME
FROM   SCM_MST_SITE S
INNER JOIN (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328] SalesCompany 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
			FROM   SCM_MST_PROJECT_ITEM SI
			INNER JOIN SCM_MST_ITEM_SN I
			ON     SI.ITEM_ID = I.ITEM_ID
			--AND    SCP_OPERATION_GROUP IS NOT NULL --[C20200608-000328]
			WHERE  1=1 --si.valid_yn = ''Y'' --[C20200818-000264] Project_Item Master Valid 조건 제외, Item Master Valid 조건 추가
			AND    I.ACTIVE_FLAG = ''Y''
			AND    (I.DIVISION_ID LIKE ''81%'' OR I.DIVISION_ID = ''82'')
			AND    I.ITEM_TYPE IS NOT NULL --[C20200626-000172] SalesCompany, SalesPlant 에 Item Type is not null 조건 추가
			AND    (@divisionId IS NULL OR @divisionId='''' OR SI.DIVISION_ID=@divisionId)
			AND    (@projectCode IS NULL OR @projectCode='''' OR SI.PROJECT_CODE=@projectCode)
			AND    (@itemId IS NULL OR @itemId='''' OR SI.ITEM_ID=@itemId)
			UNION ALL
			SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP --[C20200608-000328]
			FROM   SCM_MST_ITEM_SN I
			WHERE  1=1
			AND    I.ACTIVE_FLAG = ''Y'' --[C20200818-000264]
			AND    I.DIVISION_ID IN (''40'')
			AND    I.ITEM_TYPE IS NOT NULL --[C20200626-000172]
			AND    (@divisionId IS NULL OR @divisionId='''' OR I.DIVISION_ID=@divisionId)
			AND    (@itemId IS NULL OR @itemId='''' OR I.ITEM_ID=@itemId)
			) SS
ON  S.DIVISION_ID = SS.DIVISION_ID
AND S.OPERATION_GROUP = NVL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)
AND S.COMPANY_ID = SS.COMPANY_ID --'
 || '[C20200608-000328] SalesPlant 콤보는 Item Master의 Company ID, Operation Group 기준으로 조회
WHERE  1 = 1
AND    SITE_TYPE = ''PLANT''
--AND    OSP_YN    <> ''Y''
AND    (@companyId IS NULL OR @companyId='''' OR S.COMPANY_ID=@companyId)
AND    (@divisionId IS NULL OR @divisionId='''' OR S.DIVISION_ID=@divisionId)
AND    @itemId IS NOT NULL  -- 원문 ELSE(ISNULL(@Param4,'''')<>'''') Oracle 등가 — ''''=NULL 방언이라 <>'''' 직역은 항상 UNKNOWN
UNION ALL
SELECT DISTINCT
	   S.DIVISION_ID AS DIVISION_ID
	 , PLANT_ID AS CODE
	 , PLANT_ID AS NAME
FROM   SCM_MST_SITE S
WHERE  1 = 1
AND    SITE_TYPE = ''CORP''
AND    (@companyId IS NULL OR @companyId='''' OR S.COMPANY_ID=@companyId)
AND    (@divisionId IS NULL OR @divisionId='''' OR S.DIVISION_ID=@divisionId)
AND    @itemId IS NOT NULL  -- 원문 ELSE(ISNULL(@Param4,'''')<>'''') Oracle 등가 — ''''=NULL 방언이라 <>'''' 직역은 항상 UNKNOWN
ORDER BY 2,3'
     , LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID = 'SalesPlant';
COMMIT;

-- VERIFY: 저장 길이 = 3577 자 기대
SELECT SQL_ID, LENGTH(SQL_DTL_CTN) AS LEN, LENGTHB(SQL_DTL_CTN) AS BYTES
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'SalesPlant';
