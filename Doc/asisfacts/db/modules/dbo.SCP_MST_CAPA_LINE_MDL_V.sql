
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP_MST_CAPA_LINE_MDL_V
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/22   chaan        V1.1.0                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/10/11   chaan        V1.1.8                PJ20239037 LGES CPS VOE 반영 및 고도화                     - Dummy 대상 테이블 변경
 */

--CREATE VIEW [dbo].[SCP_MST_CAPA_LINE_MDL_V] AS
CREATE VIEW [dbo].[SCP_MST_CAPA_LINE_MDL_V] AS
	WITH tbl_CODE_ALL AS
	(
		
		SELECT    DIVISION_ID
				, SITE_ID
				, COMPANY_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, SHOP_GROUP_ID
				, MAX(SITE_NAME)			AS SITE_NAME
				, MAX(COMPANY_NAME)			AS COMPANY_NAME
				, MAX(PLANT_NAME)			AS PLANT_NAME
				, MAX(FACTORY_NAME)			AS FACTORY_NAME
				, MAX(LINE_NAME)			AS LINE_NAME
				, MAX(DUMMY_YN)				AS DUMMY_YN
				, MAX(VALID_YN)				AS VALID_YN
		FROM	(
					SELECT    DIVISION_ID
							, SITE_ID
							, COMPANY_ID
							, PLANT_ID
							, FACTORY_ID
							, LINE_ID
							, SITE_NAME
							, COMPANY_NAME
							, PLANT_NAME
							, FACTORY_NAME
							, LINE_NAME
							, ATTRIBUTE1		AS SHOP_GROUP_ID
							, ATTRIBUTE2		AS DUMMY_YN
							, VALID_YN
					FROM    SCP_MST_CAPA_LINE WITH(NOLOCK)
					WHERE   VALID_YN = 'Y'
					UNION ALL
					SELECT    DIVISION_ID
							, SITE_ID
							, COMPANY_ID
							, PLANT_ID
							, FACTORY_ID
							, LINE_ID
							, SITE_NAME
							, COMPANY_NAME
							, PLANT_NAME
							, FACTORY_NAME
							, LINE_NAME
							, VALID_YN
							, ATTRIBUTE1		AS SHOP_GROUP_ID
							, ATTRIBUTE2		AS DUMMY_YN
					FROM    SCP_MST_CAPA_ELTR_LINE WITH(NOLOCK)
					WHERE   VALID_YN = 'Y'
			) A
		GROUP BY  DIVISION_ID
				, SITE_ID
				, COMPANY_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, SHOP_GROUP_ID
	)
	,
	tbl_SITE AS
	(
		SELECT    SITE_ID
				, SITE_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  SITE_ID
				, SITE_NAME
	)
    ,
    tbl_COMPANY AS
	(
		SELECT    COMPANY_ID
				, COMPANY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  COMPANY_ID
				, COMPANY_NAME
	)
    ,
    tbl_PLANT AS
	(
		SELECT    PLANT_ID
				, PLANT_NAME
	    FROM    tbl_CODE_ALL
		GROUP BY  PLANT_ID
				, PLANT_NAME
	)
    ,
    tbl_FACTORY AS
	(
		SELECT    FACTORY_ID
				, FACTORY_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  FACTORY_ID
				, FACTORY_NAME
	)
    ,
    tbl_LINE AS
	(
		SELECT    LINE_ID
				, LINE_NAME
		FROM    tbl_CODE_ALL
		GROUP BY  LINE_ID
				, LINE_NAME
	)
	,
	SHOP_GROUP AS
	(
		SELECT    DIVISION_ID
				, SITE_ID
				, PLANT_ID
				, SHOP_GROUP_ID
				, OPERATION_GROUP   AS SHOP_GROUP_NAME
		FROM    SCM_SITE_HIERARCHY_V_SN WITH(NOLOCK)
		WHERE   1=1
		GROUP BY  DIVISION_ID
				, SITE_ID
				, PLANT_ID
				, SHOP_GROUP_ID
				, OPERATION_GROUP
	)
	,
	OPERATION AS
	(
		SELECT    OPERATION_ID 
				, OPERATION_NAME
		FROM	[dbo].SCM_MST_OPERATION_SN WITH(NOLOCK)
		GROUP BY  OPERATION_ID 
				, OPERATION_NAME
	)
    ,
    ASSIGN_ALL AS
    (
    	SELECT    A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.DUMMY_YN
		FROM    SCP_MST_CAPA_LINE_MDL A WITH(NOLOCK)
        UNION ALL
    	SELECT    A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.DUMMY_YN
		FROM    SCP_MST_CAPA_ELTR_LINE_MDL A WITH(NOLOCK)
    )
		SELECT    A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.DUMMY_YN
				, dbo.FN_GET_DIVISION_NAME(A.DIVISION_ID)                       AS DIVISION_NAME
				, S.SITE_NAME
				, C.COMPANY_NAME
				, P.PLANT_NAME
				, F.FACTORY_NAME
				, L.LINE_NAME
				, ISNULL(H.SHOP_GROUP_ID, SUBSTRING(A.OPERATION_ID, 1, 1))      AS SHOP_GROUP_ID
				, H.SHOP_GROUP_NAME
				, O.OPERATION_NAME
				, A.ELTR_LN_TP_CD                                               AS ELTR_LN_TP_NM
		FROM    ASSIGN_ALL A
				LEFT JOIN tbl_SITE  S ON
						A.SITE_ID			= S.SITE_ID
				LEFT JOIN tbl_COMPANY  C ON
						A.COMPANY_ID		= C.COMPANY_ID
				LEFT JOIN tbl_PLANT P ON
						A.PLANT_ID			= P.PLANT_ID
				LEFT JOIN tbl_FACTORY F ON
						A.FACTORY_ID		= F.FACTORY_ID
				LEFT JOIN tbl_LINE L ON
						A.LINE_ID			= L.LINE_ID
				LEFT JOIN SHOP_GROUP H ON
						A.DIVISION_ID   = H.DIVISION_ID
					AND A.SITE_ID		= H.SITE_ID
					AND A.PLANT_ID		= H.PLANT_ID
				LEFT JOIN OPERATION O ON
						A.OPERATION_ID = O.OPERATION_ID

