

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP_MST_CAPA_SPEED_PLAN_V
 * Description  : Speed Plan 조회시 사용, Line Assing 신규 추가시에는 SCP_MST_CAPA_SPEED_PLAN_NEW_V 사용!!!
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/02   chaan        V1.1.0                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/08/12   chaan        V1.1.6                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - PPM 조회 방식을 Speed Plan 저장된 값으로 대체
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용
 * 2024/12/09   chaan        V1.1.9                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Pre Version 누락 추가
*/

--DROP VIEW [dbo].[SCP_MST_CAPA_SPEED_PLAN_V];
CREATE VIEW [dbo].[SCP_MST_CAPA_SPEED_PLAN_V] AS
    WITH tblVersion AS
    (
        SELECT    DIVISION_ID
                , MAX(VER_ID)          AS VER_ID
                , MAX(VER_SEQ)         AS VER_SEQ
                , CONVERT(NVARCHAR(6), DATEADD(MM, -1, CONVERT(DATETIME, MAX(VER_ID) + '01')), 112) AS RESULT_TO_YYYYMM
        FROM    SCP_MST_CAPA_VERSION A
        WHERE   1=1
            --AND VER_ID  = CAST(CONVERT(NVARCHAR(6), GETDATE(), 112) AS INT)
            --AND PROG_STAT = '0'
            AND PROG_STAT IN ('-',  '0') -- Pre, Current
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
	    tbl_DAY_CNT_YEAR AS
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
				    , SUBSTRING(YYYYMM, 1, 4)			AS YYYY
				    , CASE
                        WHEN ISNULL(YYYYMM, '') <> '' THEN  DATEDIFF(DAY, SOP_DT,                           SUBSTRING(YYYYMM, 1, 4) + '1231') + 1 -- SOP 적용 일수
                        ELSE                                DATEDIFF(DAY, SUBSTRING(YYYYMM, 1, 4) + '0101', SUBSTRING(YYYYMM, 1, 4) + '1231') + 1 -- 연간총일수
                      END               AS DAY_CNT
		    FROM    tbl_DAY_CNT
		    WHERE   1=1
	    )
        ,

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
                , A.EQP_NBU                                 AS EQP_NBU
                , A.EQP_SPED                                AS EQP_SPED
		        , CONVERT(FLOAT, A.ATTRIBUTE1)	            AS PPM
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
			AND VALID_YN = 'Y'
	)
    ,
	tbl_RAW AS
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
				, G.UNIT_GROUP						                        AS SPEED_UNIT_GROUP
                , G.UNIT_GROUP_SEQ
				, A.MSR_TP_CD
				, A.YYYYMM
                , CASE
					WHEN A.MSR_TP_CD IN ('MMS', 'CPM', 'PPM_AVG', 'TTT') THEN R.EQP_SPED
                    WHEN A.MSR_TP_CD IN ('PPM') THEN R.PPM
                    ELSE R.EQP_NBU
                    END                                                       AS PFRSLT_QTY
				, A.BASE_QTY
				, CONVERT(FLOAT, Q.ELTR_QTY)                                AS ELTR_QTY
				, CONVERT(FLOAT, Q.ELTR_PCH_LEN)                            AS ELTR_PCH_LEN
				, CONVERT(FLOAT, Q.ELTR_QTY * Q.ELTR_PCH_LEN)               AS MMS_CF
				, A.QTY
				, A.UI_UPD_YN
                , S.ASSIGN_PRIORITY
                , S.DUMMY_YN
			    , CASE
                    WHEN LEN(A.YYYYMM) = 4 THEN
					    CASE
						    WHEN DY.DIVISION_ID IS NULL THEN DATEDIFF(DAY, SUBSTRING(A.YYYYMM, 1, 4) + '0101', SUBSTRING(A.YYYYMM, 1, 4) + '1231') + 1   -- 연도별 & SOP 없을때
						    ELSE DY.DAY_CNT                                                                                                                 -- 연도별 & SOP 존재
					    END
                    ELSE 
					    CASE
						    WHEN DC.DIVISION_ID IS NULL THEN DAY(EOMONTH(CONVERT(DATE, A.YYYYMM + '01')))                                -- 월별 & SOP 없을때
						    ELSE DC.DAY_CNT                                                                                                 -- 월별 & SOP 존재
					    END
                    END                                                                                                           AS DAY_CNT
                , CONVERT(NVARCHAR(2), 0) AS PROG_STAT --CURRENT 고정
	            , A.REMARK
	            , A.CREATED_BY
	            , A.CREATION_DATE
	            , A.LAST_UPDATED_BY
	            , A.LAST_UPDATE_DATE
		FROM	SCP_MST_CAPA_SPEED_PLAN A WITH(NOLOCK)
                LEFT JOIN tblVersion V ON
                        A.DIVISION_ID = V.DIVISION_ID
				JOIN tbl_LINE_ASSIGN S ON
							A.DIVISION_ID		= S.DIVISION_ID
						AND A.COMPANY_ID		= S.COMPANY_ID
						AND A.SITE_ID			= S.SITE_ID
						AND A.PLANT_ID			= S.PLANT_ID
						AND A.FACTORY_ID		= S.FACTORY_ID
						AND A.LINE_ID			= S.LINE_ID
						AND A.OPERATION_ID		= S.OPERATION_ID
						AND A.ELTR_LN_TP_CD	    = S.ELTR_LN_TP_CD
						AND A.NICK_NAME         = S.NICK_NAME
						AND A.YYYYMM            = S.YYYYMM
				LEFT JOIN tbl_SPEED_UNIT_GROUP_MSR G ON
                        A.MSR_TP_CD = G.MSR_TP_CD
				LEFT JOIN tbl_RESULT R ON
						A.DIVISION_ID		    = R.DIVISION_ID
					AND A.COMPANY_ID		    = R.COMPANY_ID
					AND A.SITE_ID			    = R.SITE_ID
					AND A.PLANT_ID			    = R.PLANT_ID
					AND A.FACTORY_ID		    = R.FACTORY_ID
					AND A.LINE_ID			    = R.LINE_ID
					AND A.OPERATION_ID		    = R.OPERATION_ID
					AND A.ELTR_LN_TP_CD	        = R.ELTR_LN_TP_CD
					----AND A.MSR_TP_CD	            = R.EQP_SPED_UNIT_CD
				LEFT JOIN tbl_BASE B ON
						A.DIVISION_ID		    = B.DIVISION_ID
					AND A.COMPANY_ID		    = B.COMPANY_ID
					AND A.SITE_ID			    = B.SITE_ID
					AND A.PLANT_ID			    = B.PLANT_ID
					AND A.FACTORY_ID		    = B.FACTORY_ID
					AND A.LINE_ID			    = B.LINE_ID
					AND A.OPERATION_ID		    = B.OPERATION_ID
					AND A.NICK_NAME             = B.NICK_NAME
					AND A.ELTR_LN_TP_CD	        = B.ELTR_LN_TP_CD
				LEFT JOIN tbl_CF Q ON
						A.NICK_NAME             = Q.NICK_NAME
					AND A.ELTR_LN_TP_CD = Q.ELTR_LN_TP_CD
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
				    LEFT JOIN tbl_DAY_CNT_YEAR DY ON
						    A.DIVISION_ID		= DY.DIVISION_ID
					    AND A.COMPANY_ID		= DY.COMPANY_ID
					    AND A.SITE_ID			= DY.SITE_ID
					    AND A.PLANT_ID			= DY.PLANT_ID
					    AND A.FACTORY_ID		= DY.FACTORY_ID
					    AND A.LINE_ID			= DY.LINE_ID
					    AND A.OPERATION_ID		= DY.OPERATION_ID
					    AND A.YYYYMM			= DY.YYYY
	        WHERE	1=1
                AND ISNULL(S.ASSIGN_PRIORITY, 0) <> 0
    )
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
                , A.PFRSLT_QTY					AS PFRSLT_QTY
                , A.BASE_QTY					AS BASE_QTY
                , A.QTY						    AS QTY
                , A.ELTR_QTY					AS ELTR_QTY
                , A.MMS_CF						AS MMS_CF
                , A.UI_UPD_YN					AS UI_UPD_YN
                , A.ASSIGN_PRIORITY			    AS ASSIGN_PRIORITY
                , A.DUMMY_YN                    AS DUMMY_YN
                , A.DAY_CNT					    AS DAY_CNT
                , A.PROG_STAT					AS PROG_STAT
	            , A.REMARK						AS REMARK
	            , A.CREATED_BY					AS CREATED_BY
	            , A.CREATION_DATE				AS CREATION_DATE
	            , A.LAST_UPDATED_BY			    AS LAST_UPDATED_BY
	            , A.LAST_UPDATE_DATE			AS LAST_UPDATE_DATE
        FROM    tbl_RAW A
        WHERE   1=1
            --AND A.RN = 1

	        --AND A.DIVISION_ID		= N'81'
	        --AND A.SITE_ID			= N'A001'
	        --AND A.PLANT_ID  		= N'A040'
	        --AND A.FACTORY_ID		= N'A2'
	        --AND A.LINE_ID			= N'A2A10'
	        --AND A.OPERATION_ID		= N'A5000'
            --   AND A.NICK_NAME		    = N'F2'
	        --AND A.ELTR_LN_TP_CD		= N'Anode'
            --   AND A.YYYYMM			= '202412'

