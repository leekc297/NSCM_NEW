
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP_MST_CAPA_SPEED_PLAN_NEW_V
 * Description  : Line Assign 에서 데이터 변경이 있을때 Result + Meausre 기준 셋트를 기준으로 Speed Plan 에 추가
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/02   chaan        V1.1.0                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/08/12   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PPM 조회 방식을 Speed Plan 저장된 값으로 대체
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용
*/

----DROP VIEW [dbo].[SCP_MST_CAPA_SPEED_PLAN_NEW_V];
--CREATE VIEW [dbo].[SCP_MST_CAPA_SPEED_PLAN_NEW_V] AS
CREATE VIEW [dbo].[SCP_MST_CAPA_SPEED_PLAN_NEW_V] AS
    WITH tblVersion AS
    (
        SELECT    DIVISION_ID
                , MAX(VER_ID)          AS VER_ID
                , MAX(VER_SEQ)         AS VER_SEQ
                , CONVERT(NVARCHAR(6), DATEADD(MM, -1, CONVERT(DATETIME, MAX(VER_ID) + '01')), 112) AS RESULT_TO_YYYYMM
        FROM    SCP_MST_CAPA_VERSION A WITH(NOLOCK)
        WHERE   1=1
            --AND VER_ID  = CAST(CONVERT(NVARCHAR(6), GETDATE(), 112) AS INT)
            AND PROG_STAT = '0'
            AND VER_ID    <> '-'
        GROUP BY  DIVISION_ID
    )
    ,
    tbl_OPERATION_ELECTRODE_TYPE AS
	(
        SELECT    A.SEGMENT1		AS DIVISION_ID
                , A.SEGMENT2		AS OPERATION_ID 
                , A.SEGMENT3		AS ELTR_LN_TP_CD
                , A.ATTRIBUTE1		AS EQP_SPED_UNIT_CD
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
			--AND SEGMENT1 = 'SCP'
            AND A.LOOKUP_TYPE  = 'OPERATION_ELECTRODE_TYPE'
            AND A.VALID_YN  = 'Y'
	)
    ,
    tbl_SPEED_UNIT_ALL AS
	(
        SELECT    A.SEGMENT1        AS UNIT_GROUP
                , A.SEGMENT2        AS OPERATION_ID
                , A.SEGMENT3        AS MSR_TP_CD
                , A.SEGMENT4        AS LINE_TYPE
                , A.SEGMENT5        AS UNIT_GROUP_SEQ
                , A.DISPLAY_SEQ
        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
			--AND SEGMENT1 = 'SCP'
            AND A.LOOKUP_TYPE  = 'OPERATION_SPEED_UNIT'
            AND A.VALID_YN  = 'Y'
	),
	tbl_SPEED_UNIT_GROUP_MSR AS
	(
        SELECT    A.UNIT_GROUP
                , A.MSR_TP_CD
                , MIN(A.DISPLAY_SEQ)      AS DISPLAY_SEQ
                , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
        FROM    tbl_SPEED_UNIT_ALL A
        WHERE   1=1
            AND MSR_TP_CD <> 'M'
        GROUP BY  A.UNIT_GROUP
                , A.MSR_TP_CD
        --ORDER BY MIN(A.UNIT_GROUP_SEQ)
	)
    ,
	tbl_SPEED_UNIT_GROUP AS
	(
        SELECT    A.UNIT_GROUP
                , MAX(A.UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
        FROM    tbl_SPEED_UNIT_ALL A
        GROUP BY  A.UNIT_GROUP
        --ORDER BY MIN(A.DISPLAY_SEQ)
	)
    ,
	tblSCP0104_CODE_ALL AS
	(
		SELECT  *
		FROM    SCP_MST_CAPA_LINE WITH(NOLOCK)
		WHERE   VALID_YN = 'Y'
	)
	,
	tblSCP0104_SITE AS
	(
		SELECT    SITE_ID
				, SITE_NAME
	    FROM    tblSCP0104_CODE_ALL
		GROUP BY  SITE_ID
				, SITE_NAME
	)
    ,
    tblSCP0104_COMPANY AS
	(
		SELECT    COMPANY_ID
				, COMPANY_NAME
		FROM    tblSCP0104_CODE_ALL
		GROUP BY  COMPANY_ID
				, COMPANY_NAME
	)
    ,
    tblSCP0104_PLANT AS
	(
		SELECT    PLANT_ID
				, PLANT_NAME
	    FROM    tblSCP0104_CODE_ALL
		GROUP BY  PLANT_ID
				, PLANT_NAME
	)
    ,
    tblSCP0104_FACTORY AS
	(
		SELECT    FACTORY_ID
				, FACTORY_NAME
		FROM    tblSCP0104_CODE_ALL
		GROUP BY  FACTORY_ID
				, FACTORY_NAME
	)
    ,
    tblSCP0104_LINE AS
	(
		SELECT    LINE_ID
				, LINE_NAME
		FROM    tblSCP0104_CODE_ALL
		GROUP BY  LINE_ID
				, LINE_NAME
	)
    ,
    tbl_DUMMY_CODE_NICK_NAME AS
	(
		SELECT  DISTINCT 
				NICK_NAME
		FROM    FN_SCM0002_GET_CAPA_ITEM_POPUP('', '')
	    WHERE   1<>1
		    AND ISNULL(NICK_NAME, '') <> ''
	)
    ,
    tbl_DAY_CNT AS
    (
		SELECT    DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELTR_LN_TP_CD
				, SOP_DT
				, SOP_YM			AS YYYYMM
				, SOP_DDN			AS DAY_CNT
		FROM    SCP_MST_CAPA_LINE_SOP WITH(NOLOCK)
		WHERE   1=1
			AND VALID_YN        = 'Y'
    ),
	-- 실적 #################################################################################################
	tbl_RESULT AS
	(
        SELECT    A.DIVISION_ID                             AS DIVISION_ID
                , A.COMPANY_ID                              AS COMPANY_ID
                , A.SITE_ID                                 AS SITE_ID
                , A.PLANT_ID                                AS PLANT_ID
                , A.FACTORY_ID                              AS FACTORY_ID
                , A.LINE_ID                                 AS LINE_ID
                , A.OPERATION_ID                            AS OPERATION_ID
                , A.ELTR_LN_TP_CD                           AS ELTR_LN_TP_CD
                , A.MDL_NM                                  AS NICK_NAME
                , B.UNIT_GROUP                              AS SPEED_UNIT_GROUP
                , UPPER(A.EQP_SPED_UNIT_CD)                 AS EQP_SPED_UNIT_CD
                --, AVG(A.EQP_NBU)                            AS EQP_NBU
                --, AVG(A.EQP_SPED)                           AS EQP_SPED
                , A.EQP_NBU                                 AS EQP_NBU
                , A.EQP_SPED                                AS EQP_SPED
		        , CONVERT(FLOAT, A.ATTRIBUTE1)	AS PPM
        FROM    SCM_DNM_EQP_SPED_MMLY A WITH(NOLOCK)
                LEFT JOIN (
                                SELECT    UNIT_GROUP
                                        , MSR_TP_CD
                                FROM    tbl_SPEED_UNIT_ALL
                                WHERE   1=1
                                GROUP BY UNIT_GROUP
                                        , MSR_TP_CD
                            ) B ON
                        A.EQP_SPED_UNIT_CD  = MSR_TP_CD
                INNER JOIN (    
                                SELECT    DIVISION_ID
                                        , RESULT_TO_YYYYMM
                                FROM    tblVersion
                            ) V ON
                A.DIVISION_ID       = V.DIVISION_ID
            AND A.PFRSLT_YM			= V.RESULT_TO_YYYYMM                            
        WHERE   1=1
            AND A.PERD_DIVS_CD		= '3'
        --GROUP BY  A.DIVISION_ID XXXX
        --        , A.COMPANY_ID
        --        , A.SITE_ID
        --        , A.PLANT_ID
        --        , A.FACTORY_ID
        --        , A.LINE_ID
        --        , A.OPERATION_ID
        --        , A.ELTR_LN_TP_CD
        --        , A.MDL_NM
        --        , B.UNIT_GROUP
        --        , A.EQP_SPED_UNIT_CD
	),
	-- BASE #################################################################################################
	tbl_BASE AS
	(
        SELECT    A.DIVISION_ID                 AS DIVISION_ID
                , A.COMPANY_ID                  AS COMPANY_ID
                , A.SITE_ID                     AS SITE_ID
                , A.PLANT_ID                    AS PLANT_ID
                , A.FACTORY_ID                  AS FACTORY_ID
                , A.LINE_ID                     AS LINE_ID
                , A.OPERATION_ID                AS OPERATION_ID
                , A.MDL_NM                      AS NICK_NAME
                , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
                , B.UNIT_GROUP                  AS SPEED_UNIT_GROUP
                , UPPER(A.EQP_SPED_UNIT_CD)     AS MSR_TP_CD
                , A.EQP_NBU
                , A.EQP_SPED
                , A.UI_UPD_YN
        FROM    SCP_MST_MDL_EQP_SPED A WITH(NOLOCK)
                LEFT JOIN (
                                SELECT    UNIT_GROUP
                                        , MSR_TP_CD
                                FROM    tbl_SPEED_UNIT_ALL
                                WHERE   1=1
                                GROUP BY UNIT_GROUP
                                        , MSR_TP_CD
                            ) B ON
                        A.EQP_SPED_UNIT_CD  = MSR_TP_CD
        WHERE   1=1
            AND A.USE_YN = 'Y'
	),
	-- UI_UPD_YN #################################################################################################
	tbl_BASE_UI_UPD_YN AS
	(
        SELECT    DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , MAX(UI_UPD_YN)    AS UI_UPD_YN
        FROM    tbl_BASE
        WHERE   1=1
        GROUP BY  DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
	),
	-- CF #################################################################################################
	tbl_CF AS
	(
        SELECT    A.NICK_NM                         AS NICK_NAME
                , A.ELTR_LN_TP_CD
                , CONVERT(FLOAT, A.ELTR_QTY)        AS ELTR_QTY
                , CONVERT(FLOAT, A.ELTR_PCH_LEN)    AS ELTR_PCH_LEN
        FROM    SCP_MST_MDL_ELTR_QTY A WITH(NOLOCK)
        WHERE   1=1
            AND USE_YN = 'Y'
	),
	-- ASSIGN #################################################################################################
	tbl_LINE_ASSIGN AS
	(
		SELECT	  V.VER_ID
				, V.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.YYYYMM
				, A.DUMMY_YN
				, A.ASSIGN_PRIORITY
		FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
                LEFT JOIN tblVersion V ON
                        A.DIVISION_ID = V.DIVISION_ID
		WHERE   1=1
			AND A.VALID_YN = 'Y'
            AND ISNULL(A.ASSIGN_PRIORITY, 0) <> 0
	)
    ,
	tbl_RAW_ALL_TEMP AS
	(
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, ISNULL(B.MSR_TP_CD, 'EQP_NBU')      AS MSR_TP_CD
				, A.YYYYMM
				, NULL                                AS PFRSLT_QTY
				, B.BASE_QTY
				, B.QTY
	            , B.REMARK
	            , B.CREATED_BY
	            , B.CREATION_DATE
	            , B.LAST_UPDATED_BY
	            , B.LAST_UPDATE_DATE
		FROM	tbl_LINE_ASSIGN A
				LEFT JOIN SCP_MST_CAPA_SPEED_PLAN B WITH(NOLOCK) ON
							A.DIVISION_ID		= B.DIVISION_ID
						AND A.COMPANY_ID		= B.COMPANY_ID
						AND A.SITE_ID			= B.SITE_ID
						AND A.PLANT_ID			= B.PLANT_ID
						AND A.FACTORY_ID		= B.FACTORY_ID
						AND A.LINE_ID			= B.LINE_ID
						AND A.OPERATION_ID		= B.OPERATION_ID
						AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
						AND A.NICK_NAME         = B.NICK_NAME
						AND A.YYYYMM            = B.YYYYMM
	        WHERE	1=1
	)
    ,
	tbl_RAW_ALL AS
	(
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, G.UNIT_GROUP									AS SPEED_UNIT_GROUP
                , G.UNIT_GROUP_SEQ
                --, G.DISPLAY_SEQ
				--, U.EQP_SPED_UNIT_CD                            AS MSR_TP_CD
				, CASE
					WHEN G.UNIT_GROUP = 'EQP_SPED' THEN
						CASE
							WHEN (A.OPERATION_ID = 'A5000')									                                THEN 'MMS'
							WHEN (A.OPERATION_ID = 'A7000')	 OR (A.OPERATION_ID = 'A7400')	                                THEN 'CPM'
							WHEN (A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding') OR (A.OPERATION_ID = 'A8400')	THEN 'PPM_AVG'
							ELSE 'TTT'
						END
					WHEN G.UNIT_GROUP = 'PPM' THEN 'PPM'
					ELSE A.MSR_TP_CD
    			    END AS MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_QTY                                  AS PFRSLT_QTY
				, A.BASE_QTY
				, A.QTY
	            , A.REMARK
	            , A.CREATED_BY
	            , A.CREATION_DATE
	            , A.LAST_UPDATED_BY
	            , A.LAST_UPDATE_DATE
		FROM	tbl_RAW_ALL_TEMP A
				INNER JOIN tbl_SPEED_UNIT_GROUP_MSR G ON 1=1
				--LEFT JOIN tbl_SPEED_UNIT_GROUP G ON 1=1
				--LEFT JOIN tbl_SPEED_UNIT_GROUP_MSR G ON
                        --A.MSR_TP_CD = G.MSR_TP_CD
				LEFT JOIN tbl_OPERATION_ELECTRODE_TYPE U ON
						A.DIVISION_ID   = U.DIVISION_ID
					AND A.OPERATION_ID  = U.OPERATION_ID
					AND A.ELTR_LN_TP_CD = U.ELTR_LN_TP_CD
        WHERE   1=1

	        --AND A.DIVISION_ID		= N'81'
	        --AND A.SITE_ID			= N'A001'
	        --AND A.PLANT_ID  		= N'A040'
	        --AND A.FACTORY_ID		= N'A2'
	        --AND A.LINE_ID			= N'A2A10'
	        --AND A.OPERATION_ID		= N'A5000'
            --   AND A.NICK_NAME		    = N'F2'
	        ------AND A.ELTR_LN_TP_CD		= N'-'
            --   AND A.YYYYMM			= '202412'
    )
    ,
    -- RAW KEYS #################################################################################################
	tbl_RAW_KEYS AS
	(
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.SPEED_UNIT_GROUP
				, A.MSR_TP_CD
				, A.YYYYMM
		FROM	tbl_RAW_ALL A
		WHERE   1=1
				----AND ((A.SPEED_UNIT_GROUP  = 'EQP_NBU'    AND A.MSR_TP_CD IN ('EQP_NBU')) OR
				----	 (A.SPEED_UNIT_GROUP  = 'PPM'        AND A.MSR_TP_CD IN ('PPM')) OR
				----	 (A.SPEED_UNIT_GROUP  = 'EQP_SPED'   AND A.MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT')))

	        --AND A.DIVISION_ID		= N'81'
	        --AND A.SITE_ID			= N'A001'
	        --AND A.PLANT_ID  		= N'A040'
	        --AND A.FACTORY_ID		= N'A2'
	        --AND A.LINE_ID			= N'A2A10'
	        --AND A.OPERATION_ID		= N'A5000'
            --   AND A.NICK_NAME		    = N'F2'
	        --------AND A.ELTR_LN_TP_CD		= N'-'
            --   AND A.YYYYMM			= '202412'
		GROUP BY  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.SPEED_UNIT_GROUP
				, A.MSR_TP_CD
				, A.YYYYMM
	)
    ,
    -- RAW TEMP #################################################################################################
    tbl_RAW_TEMP AS
	(
		SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.SPEED_UNIT_GROUP
				, A.MSR_TP_CD
				, A.YYYYMM
				, X.BASE_QTY
				, R.EQP_NBU                                                 AS R_PFRSLT_QTY
				, B.EQP_NBU                                                 AS B_BASE_QTY
				, R.EQP_SPED                                                AS R_PFRSLT_SPEED
				, R.PPM                                                     AS R_PPM
				, B.EQP_SPED                                                AS B_BASE_SPEED
				, CONVERT(FLOAT, Q.ELTR_QTY)                                AS ELTR_QTY
				, CONVERT(FLOAT, Q.ELTR_PCH_LEN)                            AS ELTR_PCH_LEN
				, CONVERT(FLOAT, Q.ELTR_QTY * Q.ELTR_PCH_LEN)               AS MMS_CF
				, X.QTY
				, ISNULL(BU.UI_UPD_YN, 'Y')                 AS UI_UPD_YN
	            , X.REMARK
	            , X.CREATED_BY
	            , X.CREATION_DATE
	            , X.LAST_UPDATED_BY
	            , X.LAST_UPDATE_DATE
		FROM	tbl_RAW_KEYS A
				LEFT JOIN tbl_RAW_ALL X ON
						A.VER_ID				= X.VER_ID
					AND A.VER_SEQ				= X.VER_SEQ
					AND A.DIVISION_ID			= X.DIVISION_ID
					AND A.COMPANY_ID			= X.COMPANY_ID
					AND A.SITE_ID				= X.SITE_ID
					AND A.PLANT_ID				= X.PLANT_ID
					AND A.FACTORY_ID			= X.FACTORY_ID
					AND A.LINE_ID				= X.LINE_ID
					AND A.OPERATION_ID			= X.OPERATION_ID
					AND A.ELTR_LN_TP_CD			= X.ELTR_LN_TP_CD
					AND A.ITEM_ID				= X.ITEM_ID
					AND A.NICK_NAME				= X.NICK_NAME
					AND A.SPEED_UNIT_GROUP		= X.SPEED_UNIT_GROUP
					AND A.MSR_TP_CD				= X.MSR_TP_CD
					AND A.YYYYMM				= X.YYYYMM
				LEFT JOIN tbl_RESULT R ON
						A.DIVISION_ID		                            = R.DIVISION_ID
					AND A.COMPANY_ID		                            = R.COMPANY_ID
					AND A.SITE_ID			                            = R.SITE_ID
					AND A.PLANT_ID			                            = R.PLANT_ID
					AND A.FACTORY_ID		                            = R.FACTORY_ID
					AND A.LINE_ID			                            = R.LINE_ID
					AND A.OPERATION_ID		                            = R.OPERATION_ID
					AND A.ELTR_LN_TP_CD	                                = R.ELTR_LN_TP_CD
				LEFT JOIN tbl_BASE B ON
						A.DIVISION_ID		                            = B.DIVISION_ID
					AND A.COMPANY_ID		                            = B.COMPANY_ID
					AND A.SITE_ID			                            = B.SITE_ID
					AND A.PLANT_ID			                            = B.PLANT_ID
					AND A.FACTORY_ID		                            = B.FACTORY_ID
					AND A.LINE_ID			                            = B.LINE_ID
					AND A.OPERATION_ID		                            = B.OPERATION_ID
					AND A.NICK_NAME                                     = B.NICK_NAME
					AND A.ELTR_LN_TP_CD	                                = B.ELTR_LN_TP_CD
				LEFT JOIN tbl_CF Q ON
						A.NICK_NAME                                     = Q.NICK_NAME
					AND A.ELTR_LN_TP_CD = Q.ELTR_LN_TP_CD
				LEFT JOIN tbl_BASE_UI_UPD_YN BU ON
						A.DIVISION_ID		                            = BU.DIVISION_ID
					AND A.COMPANY_ID		                            = BU.COMPANY_ID
					AND A.SITE_ID			                            = BU.SITE_ID
					AND A.PLANT_ID			                            = BU.PLANT_ID
					AND A.FACTORY_ID		                            = BU.FACTORY_ID
					AND A.LINE_ID			                            = BU.LINE_ID
					AND A.OPERATION_ID		                            = BU.OPERATION_ID
					AND A.NICK_NAME                                     = BU.NICK_NAME
					AND A.ELTR_LN_TP_CD	                                = BU.ELTR_LN_TP_CD
            WHERE   1=1
	        --AND A.DIVISION_ID		= N'81'
	        --AND A.SITE_ID			= N'A001'
	        --AND A.PLANT_ID  		= N'A040'
	        --AND A.FACTORY_ID		= N'A2'
	        --AND A.LINE_ID			= N'A2A10'
	        --AND A.OPERATION_ID		= N'A5000'
            --   AND A.NICK_NAME		    = N'F2'
	        --------AND A.ELTR_LN_TP_CD		= N'-'
            --   AND A.YYYYMM			= '202412'
    )
    ,
    -- 서브 쿼리 - QTY #################################################################################################
	tbl_RAW_TEMP_QTY AS
	(
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.SPEED_UNIT_GROUP
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.R_PFRSLT_QTY
				, A.B_BASE_QTY
				, A.R_PFRSLT_SPEED
				, A.B_BASE_SPEED
				, A.ELTR_QTY
				, A.ELTR_PCH_LEN
				, A.MMS_CF
				, A.QTY
				, A.UI_UPD_YN
		FROM    tbl_RAW_TEMP A
		WHERE   1=1
			AND A.SPEED_UNIT_GROUP = 'EQP_NBU'
	)
    ,
    -- 서브 쿼리 - SPEED #################################################################################################
	tbl_RAW_TEMP_SPEED AS
	(
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.SPEED_UNIT_GROUP
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.R_PFRSLT_QTY
				, A.B_BASE_QTY
				, A.R_PFRSLT_SPEED
				, A.R_PPM
				, A.B_BASE_SPEED
				, A.ELTR_QTY
				, A.ELTR_PCH_LEN
				, A.MMS_CF
				--, ISNULL(A.QTY, B_BASE_SPEED)                             AS SPEED
				, IIF(A.UI_UPD_YN = 'Y', A.QTY, B_BASE_SPEED)              AS SPEED --XXX
				, A.UI_UPD_YN
		FROM    tbl_RAW_TEMP A
		WHERE   1=1
			AND A.SPEED_UNIT_GROUP = 'EQP_SPED'
	)
    ,
    -- 실적 PPM 조회 대상 변경 => 기존모델별에서 Line 별로 변경
	tbl_SPEED_RESULT_PPM AS
	(
        SELECT	  A.DIVISION_ID
		        , A.COMPANY_ID
		        , A.SITE_ID
		        , A.PLANT_ID
		        , A.FACTORY_ID
		        , A.LINE_ID
		        , A.OPERATION_ID
		        , A.ELTR_LN_TP_CD
		        , CONVERT(FLOAT, A.ATTRIBUTE1)	AS PPM
        FROM	SCM_DNM_EQP_SPED_MMLY A  WITH(NOLOCK)
                LEFT JOIN (    
                                SELECT    DIVISION_ID
                                        , RESULT_TO_YYYYMM
                                FROM    tblVersion
                            ) V ON
                A.DIVISION_ID       = V.DIVISION_ID
            AND A.PFRSLT_YM			= V.RESULT_TO_YYYYMM                            
        WHERE	1=1
	        AND A.PERD_DIVS_CD	= '3'
    )
    ,
	tbl_RAW_TEMP1 AS
	(
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.SPEED_UNIT_GROUP
				, A.MSR_TP_CD
				, A.YYYYMM
				, CASE
					WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN CONVERT(FLOAT, A.R_PFRSLT_SPEED)
					WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN CONVERT(FLOAT, A.R_PFRSLT_QTY)
					----ELSE P.PPM
					ELSE A.R_PPM
					END AS PFRSLT_QTY
				, CASE --UI_UPD_YN = 'Y'이면 Speed Plan 저장된 값, 아니면  실시간 조회값
					WHEN A.UI_UPD_YN = 'Y' THEN A.BASE_QTY
					ELSE
						CASE
							WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN CONVERT(FLOAT, A.B_BASE_SPEED)
							WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN CONVERT(FLOAT, A.B_BASE_QTY)
							ELSE --PPM
								CASE
									WHEN (A.OPERATION_ID = 'A5000') THEN                                                                --'MMS'
										CONVERT(FLOAT, IIF(A.MMS_CF * A.B_BASE_QTY = 0, 0, A.B_BASE_SPEED * 60.0 / A.MMS_CF * A.B_BASE_QTY))
									WHEN (A.OPERATION_ID = 'A7000')	 OR (A.OPERATION_ID = 'A7400') THEN                                 --'CPM'
										CONVERT(FLOAT, IIF(A.ELTR_QTY *  A.B_BASE_QTY = 0, 0, A.B_BASE_SPEED / A.ELTR_QTY *  A.B_BASE_QTY))
									WHEN (A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding') OR (A.OPERATION_ID = 'A8400')  THEN --'PPM_AVG'
										CONVERT(FLOAT, A.B_BASE_SPEED * A.B_BASE_QTY)
									ELSE                                                                                                --'TTT'
										CONVERT(FLOAT, IIF(A.B_BASE_SPEED * A.B_BASE_QTY = 0, 0, 60.0 / A.B_BASE_SPEED * A.B_BASE_QTY))
								END
						END
					END AS BASE_QTY
				, CASE --UI_UPD_YN = 'Y'이면 Speed Plan 저장된 값, 아니면  실시간 조회값
					WHEN A.UI_UPD_YN = 'Y' THEN A.QTY
					ELSE
						CASE --UI_UPD_YN = 'Y'이면 Speed Plan 저장된 값, 아니면  실시간 조회값
							WHEN A.SPEED_UNIT_GROUP = 'EQP_SPED' THEN CONVERT(FLOAT, S.SPEED)
							WHEN A.SPEED_UNIT_GROUP = 'EQP_NBU'  THEN CONVERT(FLOAT, Q.QTY)
							ELSE --PPM
								CASE
									WHEN (A.OPERATION_ID = 'A5000') THEN                                                                --'MMS'
										CONVERT(FLOAT, IIF(A.MMS_CF * Q.QTY = 0, 0, S.SPEED * 60.0 / A.MMS_CF * Q.QTY))
									WHEN (A.OPERATION_ID = 'A7000')	 OR (A.OPERATION_ID = 'A7400') THEN                                 --'CPM'
										CONVERT(FLOAT, IIF(A.ELTR_QTY * Q.QTY = 0, 0, S.SPEED / A.ELTR_QTY * Q.QTY))
									WHEN (A.OPERATION_ID = 'A8000' AND A.ELTR_LN_TP_CD = 'Folding') OR (A.OPERATION_ID = 'A8400')  THEN --'PPM_AVG'
										S.SPEED * Q.QTY
									ELSE                                                                 --'TTT'
										CONVERT(FLOAT, IIF(S.SPEED * Q.QTY = 0, 0, 60.0 / S.SPEED * Q.QTY))
								END
						END
					END AS QTY
				, A.ELTR_QTY
				, A.MMS_CF
				--, S.SPEED
				, Q.QTY         AS EQP_NBU
				, A.UI_UPD_YN
	            , A.REMARK
	            , A.CREATED_BY
	            , A.CREATION_DATE
	            , A.LAST_UPDATED_BY
	            , A.LAST_UPDATE_DATE
		FROM    tbl_RAW_TEMP A
				LEFT JOIN tbl_RAW_TEMP_QTY Q ON
						A.VER_ID		    = Q.VER_ID
					AND A.VER_SEQ		    = Q.VER_SEQ
					AND A.DIVISION_ID		= Q.DIVISION_ID
					AND A.COMPANY_ID		= Q.COMPANY_ID
					AND A.SITE_ID			= Q.SITE_ID
					AND A.PLANT_ID			= Q.PLANT_ID
					AND A.FACTORY_ID		= Q.FACTORY_ID
					AND A.LINE_ID			= Q.LINE_ID
					AND A.OPERATION_ID		= Q.OPERATION_ID
					AND A.ELTR_LN_TP_CD	    = Q.ELTR_LN_TP_CD
					AND A.NICK_NAME	        = Q.NICK_NAME
                    AND A.MSR_TP_CD         = Q.MSR_TP_CD
					AND A.YYYYMM	        = Q.YYYYMM
				LEFT JOIN tbl_RAW_TEMP_SPEED S ON
						A.VER_ID		    = S.VER_ID
					AND A.VER_SEQ		    = S.VER_SEQ
					AND A.DIVISION_ID		= S.DIVISION_ID
					AND A.COMPANY_ID		= S.COMPANY_ID
					AND A.SITE_ID			= S.SITE_ID
					AND A.PLANT_ID			= S.PLANT_ID
					AND A.FACTORY_ID		= S.FACTORY_ID
					AND A.LINE_ID			= S.LINE_ID
					AND A.OPERATION_ID		= S.OPERATION_ID
					AND A.ELTR_LN_TP_CD	    = S.ELTR_LN_TP_CD
					AND A.NICK_NAME	        = S.NICK_NAME
                    AND A.MSR_TP_CD         = S.MSR_TP_CD
					AND A.YYYYMM	        = S.YYYYMM
				--LEFT JOIN tbl_SPEED_RESULT_PPM P ON
				--		A.DIVISION_ID		= P.DIVISION_ID
				--	AND A.COMPANY_ID		= P.COMPANY_ID
				--	AND A.SITE_ID			= P.SITE_ID
				--	AND A.PLANT_ID			= P.PLANT_ID
				--	AND A.FACTORY_ID		= P.FACTORY_ID
				--	AND A.LINE_ID			= P.LINE_ID
				--	AND A.OPERATION_ID		= P.OPERATION_ID
				--	AND A.ELTR_LN_TP_CD	    = P.ELTR_LN_TP_CD
        WHERE   1=1

	        --AND A.DIVISION_ID		= N'81'
	        --AND A.SITE_ID			= N'A001'
	        --AND A.PLANT_ID  		= N'A040'
	        --AND A.FACTORY_ID		= N'A2'
	        --AND A.LINE_ID			= N'A2A10'
	        --AND A.OPERATION_ID		= N'A5000'
            --   AND A.NICK_NAME		    = N'F2'
	        ----AND A.ELTR_LN_TP_CD		= N'Anode'
            --   AND A.YYYYMM			= '202412'
	)
    ,
	tbl_RAW_TEMP2 AS
	(
		SELECT	  A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.COMPANY_ID
				, A.SITE_ID
				, A.PLANT_ID
				, A.FACTORY_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.ITEM_ID
				, A.NICK_NAME
				, A.SPEED_UNIT_GROUP
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.UI_UPD_YN
				, ISNULL(A.PFRSLT_QTY, 0.0)		                        AS PFRSLT_QTY
				, ISNULL(A.BASE_QTY, 0.0)		                        AS BASE_QTY
				, IIF(ISNULL(A.QTY, 0.0) = 0.0, A.BASE_QTY, A.QTY)		AS QTY
				, ISNULL(A.ELTR_QTY, 0.0)		                        AS ELTR_QTY
				, ISNULL(A.MMS_CF, 0.0)			                        AS MMS_CF
	            , A.REMARK
	            , A.CREATED_BY
	            , A.CREATION_DATE
	            , A.LAST_UPDATED_BY
	            , A.LAST_UPDATE_DATE
		FROM    tbl_RAW_TEMP1 A
        WHERE   1=1
            AND (   (A.SPEED_UNIT_GROUP = 'EQP_NBU'  AND A.MSR_TP_CD IN ('EQP_NBU')) OR
                    (A.SPEED_UNIT_GROUP = 'EQP_SPED' AND A.MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT')) OR
                    (A.SPEED_UNIT_GROUP = 'PPM'      AND A.MSR_TP_CD IN ('PPM')))

	        --AND A.DIVISION_ID		= N'81'
	        --AND A.SITE_ID			= N'A001'
	        --AND A.PLANT_ID  		= N'A040'
	        --AND A.FACTORY_ID		= N'A2'
	        --AND A.LINE_ID			= N'A2A10'
	        --AND A.OPERATION_ID		= N'A5000'
            --   AND A.NICK_NAME		    = N'F2'
	        --------AND A.ELTR_LN_TP_CD		= N'-'
            --   AND A.YYYYMM			= '202412'
	)
    ,
	tbl_RAW AS
    (
		SELECT	  A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
                , A.SPEED_UNIT_GROUP
			    , A.MSR_TP_CD
			    , A.YYYYMM
                , A.PFRSLT_QTY
                , A.BASE_QTY
                , A.QTY
                , A.ELTR_QTY
                , A.MMS_CF
                , A.UI_UPD_YN
			    --, CONVERT(NVARCHAR(2), @p_prog_stat) AS PROG_STAT
                , ISNULL(C.ASSIGN_PRIORITY, 0)       AS ASSIGN_PRIORITY
                , C.DUMMY_YN
			    , CASE
                    WHEN LEN(A.YYYYMM) = 4 THEN DATEDIFF(DAY, CAST(A.YYYYMM AS VARCHAR) + '0101', CAST(A.YYYYMM AS VARCHAR) + '1231') + 1   -- 연도별
                    ELSE 
					    CASE
						    WHEN ISNULL(DC.DAY_CNT, 0) = 0 THEN DAY(EOMONTH(CONVERT(DATE, A.YYYYMM + '01')))                                -- 월별 & SOP 없을때
						    ELSE DC.DAY_CNT                                                                                                 -- 월별 & SOP 존재
					    END
                    END AS DAY_CNT
                , CONVERT(NVARCHAR(2), 0) AS PROG_STAT --CURRENT 고정
	            , A.REMARK
	            , A.CREATED_BY
	            , A.CREATION_DATE
	            , A.LAST_UPDATED_BY
	            , A.LAST_UPDATE_DATE
        FROM    tbl_RAW_TEMP2 A
				LEFT JOIN tbl_LINE_ASSIGN C ON
					    A.DIVISION_ID		= C.DIVISION_ID
					AND A.COMPANY_ID		= C.COMPANY_ID
					AND A.SITE_ID			= C.SITE_ID
					AND A.PLANT_ID			= C.PLANT_ID
					AND A.FACTORY_ID		= C.FACTORY_ID
					AND A.LINE_ID			= C.LINE_ID
					AND A.OPERATION_ID		= C.OPERATION_ID
					AND A.ELTR_LN_TP_CD	    = C.ELTR_LN_TP_CD
					AND A.NICK_NAME         = C.NICK_NAME
					AND A.YYYYMM            = C.YYYYMM
                LEFT JOIN tbl_DAY_CNT DC ON
						A.DIVISION_ID		= DC.DIVISION_ID
					AND A.COMPANY_ID		= DC.COMPANY_ID
					AND A.SITE_ID			= DC.SITE_ID
					AND A.PLANT_ID			= DC.PLANT_ID
					AND A.FACTORY_ID		= DC.FACTORY_ID
					AND A.LINE_ID			= DC.LINE_ID
					AND A.OPERATION_ID		= DC.OPERATION_ID
					AND A.ELTR_LN_TP_CD		= DC.ELTR_LN_TP_CD
					AND A.YYYYMM			= DC.YYYYMM
        WHERE   1=1
    )
    ,
    tbl_RAW_Final AS
    (
		SELECT	  A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
                , A.SPEED_UNIT_GROUP
			    , A.MSR_TP_CD
			    , A.YYYYMM
                , MAX(A.PFRSLT_QTY)					AS PFRSLT_QTY
                , MAX(A.BASE_QTY)					AS BASE_QTY
                , MAX(A.QTY)						AS QTY
                , MAX(A.ELTR_QTY)					AS ELTR_QTY
                , MAX(A.MMS_CF)						AS MMS_CF
                , MAX(A.UI_UPD_YN)					AS UI_UPD_YN
                , MAX(A.ASSIGN_PRIORITY)			AS ASSIGN_PRIORITY
                , MAX(A.DUMMY_YN)                   AS DUMMY_YN
                , MAX(A.DAY_CNT)					AS DAY_CNT
                , MAX(A.PROG_STAT)					AS PROG_STAT
	            , MAX(A.REMARK)						AS REMARK
	            , MAX(A.CREATED_BY)					AS CREATED_BY
	            , MAX(A.CREATION_DATE)				AS CREATION_DATE
	            , MAX(A.LAST_UPDATED_BY)			AS LAST_UPDATED_BY
	            , MAX(A.LAST_UPDATE_DATE)			AS LAST_UPDATE_DATE
        FROM    tbl_RAW A
        WHERE   1=1
        GROUP BY  A.VER_ID
			    , A.VER_SEQ
			    , A.DIVISION_ID
			    , A.COMPANY_ID
			    , A.SITE_ID
			    , A.PLANT_ID
			    , A.FACTORY_ID
			    , A.LINE_ID
			    , A.OPERATION_ID
			    , A.ELTR_LN_TP_CD
			    , A.ITEM_ID
			    , A.NICK_NAME
                , A.SPEED_UNIT_GROUP
			    , A.MSR_TP_CD
			    , A.YYYYMM
    )
        SELECT  *
        FROM    tbl_RAW_Final A
        --WHERE   1=1
	       -- AND A.DIVISION_ID		= N'81'
	       -- AND A.SITE_ID			= N'A001'
	       -- AND A.PLANT_ID  		= N'A040'
	       -- AND A.FACTORY_ID		= N'A2'
	       -- AND A.LINE_ID			= N'A2A10'
	       -- AND A.OPERATION_ID		= N'A5000'
        --       AND A.NICK_NAME		= N'LV15A'
	       -- AND A.ELTR_LN_TP_CD		= N'Anode'
        --       AND A.YYYYMM			= '202409'

