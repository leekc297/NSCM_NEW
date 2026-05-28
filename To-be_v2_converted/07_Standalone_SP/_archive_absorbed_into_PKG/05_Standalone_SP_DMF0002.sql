-- ============================================================================
-- ABSORBED: 다음 SP들은 PKG_DMF0002에 P_* prefix로 흡수됨 (2026-05-13)
-- 원본 파일은 컴파일 대상에서 제외. 이력 관리용 보관.
-- ============================================================================

/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0002.sql
 * Description  : Standalone Procedures — DMF0002 화면 (3개)
 *              : 향후 PKG_DMF0002로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0002_GET_ITEM_BY_SMALLDIVISION_POPUPEx
(
  p_division_id   VARCHAR2,
  p_dept_id        VARCHAR2,	--Department
  p_end_customer   VARCHAR2,	--Endcustomer
  p_project_code  VARCHAR2,
  p_scm_site_id   VARCHAR2,
  p_item_id       VARCHAR2,
  p_item_type     VARCHAR2
)
AS
BEGIN

    /*
  SELECT I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY

  FROM   (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN='Y') AS  I
       LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
	   ON I.DIVISION_ID  = D.DIVISION_ID
       LEFT JOIN (SELECT * FROM SCM_MST_PROJECT ) AS A
	   ON D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN='Y') S
	   ON D.SCM_SITE_ID  = S.SCM_SITE_ID
	   --LEFT JOIN SCM_MST_ITEM_SN     T
	   LEFT JOIN DM_MST_ITEM_SINGLE_V     T
	   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
	   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C
	   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
	   LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
	   ON C.DEPT_ID = TEAM.DEPT_ID
	   LEFT JOIN (
					SELECT  LOOKUP_CODE AS CODE, DESCRIPTION AS NAME
					FROM SCM_ADM_LOOKUP_VALUES
					WHERE;
					VALID_YN ='Y'
					AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
	   )  AS ITEM_TYPE_CODE
	   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE


WHERE;
        CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID
			END IN (
					Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
					(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
	               )
		AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID
			END IN (
					Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
					(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	               )
		AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE NVL(C.END_CUSTOMER, NULL)
			END IN (
					Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
					(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
	               )

		AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE S.SCM_SITE_ID
			END IN (
					Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
					(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
		--AND CASE WHEN p_project_code IS NULL THEN ''
		--   		 ELSE A.PROJECT_CODE
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_project_code,',') as P Where
		--			(CASE WHEN p_project_code IS NULL THEN '' ELSE A.PROJECT_CODE END) = P.data
	 --              )
		--AND CASE WHEN p_project_code IS NULL THEN ''
		--   		 ELSE A.PROJECT_NAME
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_project_code,',') as P Where
		--			(CASE WHEN p_project_code IS NULL THEN '' ELSE A.PROJECT_NAME END) = P.data
	 --              )

		--AND CASE WHEN p_item_id IS NULL THEN ''
		--   		 ELSE D.ITEM_ID
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_item_id,',') as P Where
		--			(CASE WHEN p_item_id IS NULL THEN '' ELSE D.ITEM_ID END) = P.data
	 --              )
		--AND CASE WHEN p_item_id IS NULL THEN ''
		--   		 ELSE T.ITEM_NAME
		--	END IN (
		--			Select * from UF_FX_String_SplitForIN (p_item_id,',') as P Where
		--			(CASE WHEN p_item_id IS NULL THEN '' ELSE T.ITEM_NAME END) = P.data
	 --              )
	 AND (;
		 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (;
		 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where D.ITEM_ID LIKE P.token +'%')
	     OR
		 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
		 )
	 --AND    (   A.PROJECT_CODE LIKE '%'+ p_project_code + '%'
		--  OR A.PROJECT_NAME LIKE '%'+ p_project_code + '%'
		-- )

  --   AND    (   D.ITEM_ID   LIKE '%' + p_item_id + '%'
  --        OR T.ITEM_NAME LIKE '%' + p_item_id + '%' )


  GROUP BY;
		I.DIVISION_ID
     , I.DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY

  ORDER BY I.DIVISION_ID
         , D.PROJECT_CODE
         , A.PROJECT_NAME
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , D.ITEM_ID
	     , T.ITEM_NAME
*/

  if p_division_id <> '40' THEN
	  SELECT DISTINCT I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
		 , D.PROJECT_CODE
		 , A.PROJECT_NAME
		 , S.SCM_SITE_ID
		 , S.SITE_DESCRIPTION
		 , D.ITEM_ID
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME
		 , TEAM.DEPT_ID
		 , TEAM.DEPT_NAME_KO
		 , C.END_CUSTOMER
		 , D.CURRENCY

	  FROM   (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN='Y') AS  I
		   LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
		   ON I.DIVISION_ID  = D.DIVISION_ID
		   LEFT JOIN (SELECT * FROM SCM_MST_PROJECT ) AS A
		   ON D.PROJECT_CODE = A.PROJECT_CODE
		   LEFT JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN='Y') S
		   ON D.SCM_SITE_ID  = S.SCM_SITE_ID
		   --LEFT JOIN SCM_MST_ITEM_SN     T
		   LEFT JOIN DM_MST_ITEM_SINGLE_V     T
		   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
		   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C
		   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID

		   --[PJ2024-50461] Team Mapping------------------------------------
		   --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
		   --ON C.DEPT_ID = TEAM.DEPT_ID
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
				FROM SCM_MST_SSO_USER_INFO B
				INNER JOIN SCM_MST_SSO_DEPT_INFO C
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
			ON              TEAM.USER_ID   IN (SELECTtoken FROM TABLE(fn_string_split(D.owner, ',')))
		   --[PJ2024-50461] Team Mapping------------------------------------
		   LEFT JOIN (
FETCH FIRST 1 ROWS ONLY
						 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
						 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
						WHERE;
						VALID_YN ='Y'
						AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		   )  AS ITEM_TYPE_CODE
		   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE

	WHERE   I.DIVISION_ID = '81'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
	  AND   SITE_TYPE = 'SALES'
	  AND   CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE NVL(C.END_CUSTOMER, NULL)
				END IN (
						Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
						(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
					   )

			AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
						(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where D.PROJECT_CODE LIKE P.token  || '%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token  || '%')
			 )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where D.ITEM_ID LIKE P.token  || '%')
			 --OR
			 --Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.NICK_NAME LIKE P.token  || '%')
			 )	 --20181205 nick name 조회요청으로 수정

	UNION

	  SELECT DISTINCT I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
		 , D.PROJECT_CODE
		 , A.PROJECT_NAME
		 , S.SCM_SITE_ID
		 , S.SITE_DESCRIPTION
		 , T.ITEM_ID
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME
		 , TEAM.DEPT_ID
		 , TEAM.DEPT_NAME_KO
		 , C.END_CUSTOMER
		 , A.CURRENCY

	  FROM   (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN='Y') AS  I
	  --[PJ2024-50461] Team Mapping------------------------------------
		   --LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
		   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE,owner FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
		--[PJ2024-50461] Team Mapping------------------------------------
		ON I.DIVISION_ID  = D.DIVISION_ID
		   LEFT OUTER JOIN (SELECT * FROM SCM_MST_PROJECT ) AS A
		ON D.PROJECT_CODE = A.PROJECT_CODE
		   LEFT JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN='Y') S
		ON D.SCM_SITE_ID  = S.SCM_SITE_ID

		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V     T

		ON I.DIVISION_ID  = T.DIVISION_ID AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
		LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C
		ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID

		--[PJ2024-50461] Team Mapping------------------------------------
		--LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
		--ON C.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (
			SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
			FROM SCM_MST_SSO_USER_INFO B
			INNER JOIN SCM_MST_SSO_DEPT_INFO C
			ON B.DEPT_ID = C.DEPT_ID
		) AS TEAM
		ON              TEAM.USER_ID   IN (SELECTtoken FROM TABLE(fn_string_split(D.owner, ',')))
		--[PJ2024-50461] Team Mapping------------------------------------


		LEFT JOIN (
FETCH FIRST 1 ROWS ONLY
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		 WHERE;
		 VALID_YN ='Y'
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE

	WHERE   I.DIVISION_ID = '82'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
	  AND   SITE_TYPE = 'SALES'
	--  AND   D.PROJECT_CODE = 'DC-17-001'


	  AND   CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE NVL(C.END_CUSTOMER, NULL)
				END IN (
						Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
						(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
					   )

			AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
						(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where D.PROJECT_CODE LIKE P.token  || '%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token  || '%')
			 )
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_ID LIKE P.token  || '%')
			 --OR
			 --Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.NICK_NAME LIKE P.token  || '%')
			 )	 --20181205 nick name 조회요청으로 수정
		ORDER BY I.DIVISION_ID
		, D.PROJECT_CODE
		, A.PROJECT_NAME
		, S.SCM_SITE_ID
		, S.SITE_DESCRIPTION
		, D.ITEM_ID
		, T.ITEM_NAME
	ELSE  --40
		--DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
 	  SELECT  T.DIVISION_ID
		 , T.DIVISION_ID  AS DIVISION_NAME
		 , '' AS PROJECT_CODE
		 , '' AS PROJECT_NAME
		 , '' AS SCM_SITE_ID
		 , '' AS SITE_DESCRIPTION
		 , T.ITEM_ID
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME	--model type
		 , '' AS DEPT_ID
		 , '' AS DEPT_NAME_KO
		 , '' AS END_CUSTOMER
		 , '' AS CURRENCY
	  FROM DM_MST_ITEM_SINGLE_V	T
		LEFT JOIN (
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		 WHERE;
		 VALID_YN ='Y'
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	WHERE  T.division_id = '40'
		 AND (;
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_ID LIKE P.token  || '%')
			 --OR
			 --Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			 OR
			 Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.NICK_NAME LIKE P.token  || '%')
			 )	 --20181205 nick name 조회요청으로 수정
		AND T.ITEM_TYPE  IN (
						 Select * from UF_FX_String_SplitForIN (p_item_type,',') as P Where (CASE WHEN p_item_type IS NULL THEN '' ELSE T.ITEM_TYPE END) = P.data
						)
	  ORDER BY T.ITEM_ID

	  /*
	  SELECT DISTINCT top 1000 I.DIVISION_ID
		 , I.DIVISION_ID  AS DIVISION_NAME
		 , '' AS PROJECT_CODE
		 , '' AS PROJECT_NAME
		 , '' AS SCM_SITE_ID
		 , '' AS SITE_DESCRIPTION
		 , T.ITEM_ID
		 , T.ITEM_NAME
		 , T.ITEM_TYPE
		 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
		 , T.NICK_NAME
		 , T.ITEM_CLASS_NAME	--model type
		 , '' AS DEPT_ID
		 , '' AS DEPT_NAME_KO
		 , '' AS END_CUSTOMER
		 , '' AS CURRENCY

	  FROM   (SELECT * FROM SCM_MST_DIVISION  WHERE VALID_YN='Y') AS  I
		   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE FROM SCM_MST_SITE_ITEM  WHERE VALID_YN='Y') AS D
		ON I.DIVISION_ID  = D.DIVISION_ID
		   LEFT OUTER JOIN (SELECT * FROM SCM_MST_PROJECT ) AS A
		ON D.PROJECT_CODE = A.PROJECT_CODE
		   LEFT JOIN (SELECT * FROM SCM_MST_SITE  WHERE VALID_YN='Y') S
		ON D.SCM_SITE_ID  = S.SCM_SITE_ID

		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V     T

		ON I.DIVISION_ID  = T.DIVISION_ID ------AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
		LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE  WHERE VALID_YN = 'Y') AS C
		ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
		LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO  WHERE VALID_YN = 'Y')  AS TEAM
		ON C.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (
		 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
		 WHERE;
		 VALID_YN ='Y'
		 AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
		)  AS ITEM_TYPE_CODE
		ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE

	WHERE I.DIVISION_ID = '40'  -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
	 AND   SITE_TYPE = 'SALES'
	  AND   CASE WHEN p_division_id = 'ALL' THEN 'ALL'
		   			 ELSE I.DIVISION_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_division_id,',') as P Where
						(CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
					   )
			AND CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		   			 ELSE TEAM.DEPT_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_dept_id,',') as P Where
						(CASE WHEN p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
					   )
			--AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
			--   		 ELSE NVL(C.END_CUSTOMER, NULL)
			--	END IN (
			--			Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
			--			(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(C.END_CUSTOMER, NULL) END) = P.data
		 --              )
			  AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
		   			 ELSE NVL(
						CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
					 , NULL)
				END IN (
						Select * from UF_FX_String_SplitForIN (p_end_customer,',') as P Where
						(CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(
							CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE D.PROJECT_CODE END
						, NULL) END) = P.data
			)
			AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL'
		   			 ELSE S.SCM_SITE_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_scm_site_id,',') as P Where
						(CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
					   )
	--***
		 ----AND (
			---- Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where D.PROJECT_CODE LIKE P.token +'%')
		 ----    OR
			---- Exists (Select * from TABLE(fn_string_split(p_project_code,',')) as P Where A.PROJECT_NAME LIKE P.token +'%')
			---- )
	--***
		 ------AND (
			------ Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_ID LIKE P.token +'%')
		 ------    OR
			------ Exists (Select * from TABLE(fn_string_split(p_item_id,',')) as P Where T.ITEM_NAME LIKE P.token +'%')
			------ )

				AND CASE WHEN p_item_id IS NULL THEN ''
		   			 ELSE T.ITEM_ID
				END IN (
						Select * from UF_FX_String_SplitForIN (p_item_id,',') as P Where
						(CASE WHEN p_item_id IS NULL THEN '' ELSE T.ITEM_ID END) = P.data
					   )
				AND CASE WHEN p_item_type IS NULL THEN ''
		   			 ELSE T.ITEM_TYPE
				END IN (
						Select * from UF_FX_String_SplitForIN (p_item_type,',') as P Where
						(CASE WHEN p_item_type IS NULL THEN '' ELSE T.ITEM_TYPE END) = P.data
					   )

		----AND (T.ITEM_TYPE  = 'H' OR T.ITEM_TYPE  = 'P' OR T.ITEM_TYPE  = 'R' OR T.ITEM_TYPE  = 'Q')	--*****
	  ORDER BY I.DIVISION_ID
			 --, D.PROJECT_CODE
			 --, A.PROJECT_NAME
			 --, S.SCM_SITE_ID
			 --, S.SITE_DESCRIPTION
			 , T.ITEM_ID
			 , T.ITEM_NAME
	 --DIVISION_ID, DIVISION_NAME, ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
	 */
	END IF;

END;
/
