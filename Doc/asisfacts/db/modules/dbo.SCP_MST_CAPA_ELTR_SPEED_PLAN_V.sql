



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP_MST_CAPA_SPEED_PLAN_V
 * Description  : 
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/02   chaan        V1.1.0                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용
 * 2024/12/09   chaan        V1.1.9                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Pre Version 누락 추가
 * 2025/04/08   hrkim		 V1.1.7                PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - CPS 소형 확산
*/

--DROP VIEW [dbo].[SCP_MST_CAPA_ELTR_SPEED_PLAN_V];
CREATE VIEW [dbo].[SCP_MST_CAPA_ELTR_SPEED_PLAN_V] AS
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
		tblSCP0105_SPEED_UNIT_ALL AS
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
				AND A.LOOKUP_TYPE  = 'OPERATION_SPEED_ELTR_UNIT'
				AND A.VALID_YN  = 'Y'
		)
		,
		tblSCP0105_SPEED_UNIT_GROUP AS
		(
			SELECT    A.UNIT_GROUP
					, MIN(A.DISPLAY_SEQ)    AS DISPLAY_SEQ
					, MAX(UNIT_GROUP_SEQ)   AS UNIT_GROUP_SEQ
			FROM    tblSCP0105_SPEED_UNIT_ALL A
			GROUP BY A.UNIT_GROUP
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
		    FROM    SCP_MST_CAPA_ELTR_LINE_SOP WITH(NOLOCK)
		    WHERE   1=1
			    AND VALID_YN        = 'Y'
        )
	    ,
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
		tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT AS
	-- 실적 #################################################################################################
		(
			SELECT    A.DIVISION_ID                 AS DIVISION_ID
					, A.COMPANY_ID                  AS COMPANY_ID
					, A.SITE_ID                     AS SITE_ID
					, A.PLANT_ID                    AS PLANT_ID
					, A.FACTORY_ID                  AS FACTORY_ID
					, A.LINE_ID                     AS LINE_ID
					, A.OPERATION_ID                AS OPERATION_ID
					, A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
					, A.MDL_NM                      AS ITEM_ID
					, '-'                           AS NICK_NAME
					, B.UNIT_GROUP                  AS SPEED_UNIT_GROUP
					, UPPER(A.EQP_SPED_UNIT_CD)     AS EQP_SPED_UNIT_CD
					, AVG(A.EQP_NBU)                AS EQP_NBU
					, AVG(A.EQP_SPED)               AS EQP_SPED
			FROM    SCM_DNM_ELTR_EQP_SPED_MMLY A WITH(NOLOCK)
                    LEFT JOIN (
                                    SELECT    UNIT_GROUP
                                            , MSR_TP_CD
                                    FROM    tblSCP0105_SPEED_UNIT_ALL
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
			GROUP BY  A.DIVISION_ID
					, A.COMPANY_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.ELTR_LN_TP_CD
					, A.MDL_NM
					, B.UNIT_GROUP
					, A.EQP_SPED_UNIT_CD
        )
        ,
		tblSCP0104_EQPUIPMENT_TEMP AS
		(
			SELECT	  A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, B.BOM_ITEM_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.WIDE_ROLL_ENABLE_FLAG
					, CONVERT(NVARCHAR(30), IIF(A.WIDE_ROLL_ENABLE_FLAG = 'Y', 'W', 'S'))      AS ELTR_LN_TP_CD
					, B.EQP_SPED
					, B.UPDATE_TIME				AS SPEED_UPDATE_TIME
					, A.UPDATE_TIME				AS EQPT_UPDATE_TIME
					, ROW_NUMBER() OVER (PARTITION BY 
													A.DIVISION_ID
												, A.SITE_ID
												, A.COMPANY_ID
												, A.PLANT_ID
												, A.LINE_ID
												, A.OPERATION_ID
												, B.BOM_ITEM_ID
											ORDER BY 
													B.UPDATE_TIME DESC
												, A.UPDATE_TIME DESC) AS RN 
			FROM	SCM_MST_EQUIPMENT_SN A WITH(NOLOCK)
					INNER JOIN SCM_MMD_EQPT_PRDT_SPEED_SN B WITH(NOLOCK) ON 
							B.EQP_ID = A.EQUIPMENT_ID
			WHERE	1=1
				-- 2025.04.08 소형 확산 AND A.DIVISION_ID      != '40'		-- 소형제외
				AND A.OPERATION_ID LIKE 'E2000%'	-- 전극 Coating 공정 (현재는 E2000 공정 하나만 대상)  
				AND A.EQUIPMENT_TYPE   = 'M'		-- Main 설비
				AND A.ACTIVE_FLAG      = 'Y'
        )
        ,
		tblSCP0104_EQPUIPMENT AS
		(
			SELECT    A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.ELTR_LN_TP_CD
					, A.BOM_ITEM_ID                     AS ITEM_ID
					, CONVERT(FLOAT, NULL)              AS EQP_NBU
					, AVG(A.EQP_SPED)                   AS EQP_SPED
			FROM    tblSCP0104_EQPUIPMENT_TEMP A
			WHERE   1=1
				AND A.RN = 1
			GROUP BY  A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
					, A.ELTR_LN_TP_CD
					, A.BOM_ITEM_ID
        )
        ,
		tblSCP0104_EQPUIPMENT_LINE AS
		(
			SELECT    A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
			FROM    tblSCP0104_EQPUIPMENT A
			WHERE   1=1
			GROUP BY  A.COMPANY_ID
					, A.DIVISION_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.OPERATION_ID
					, A.EQUIPMENT_ID
					, A.EQUIPMENT_NAME
        )
        ,
        tblDummyLine AS
        (
            SELECT    DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, MAX(ATTRIBUTE2)	AS DUMMY_YN
            FROM    SCP_MST_CAPA_ELTR_LINE WITH(NOLOCK)
            WHERE   1=1
                AND LINE_ID <> '-'
            GROUP BY  DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
        )
        ,
	-- BASE #################################################################################################
		tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE AS
		(
		    SELECT    A.DIVISION_ID                 AS DIVISION_ID
				    , A.COMPANY_ID                  AS COMPANY_ID
				    , A.SITE_ID                     AS SITE_ID
				    , A.PLANT_ID                    AS PLANT_ID
				    , A.FACTORY_ID                  AS FACTORY_ID
				    , A.LINE_ID                     AS LINE_ID
				    , A.OPERATION_ID                AS OPERATION_ID
				    , A.ITEM_ID                     AS ITEM_ID
				    , '-'                           AS NICK_NAME
				    , A.ELTR_LN_TP_CD               AS ELTR_LN_TP_CD
				    , 'EQP_SPED'                    AS SPEED_UNIT_GROUP
				    , 'EQP_SPED'                    AS MSR_TP_CD
				    , A.EQP_SPED                    AS EQP_SPED
				    , 'N'                           AS UI_UPD_YN
		    FROM    tblSCP0104_EQPUIPMENT A WITH(NOLOCK)
		    WHERE   1=1
        )
        ,
		tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN AS
		(
			SELECT    DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, OPERATION_ID
					, ELTR_LN_TP_CD
					, ITEM_ID
					, '-'                           AS NICK_NAME
					, MAX(UI_UPD_YN)                AS UI_UPD_YN
			FROM    tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE
			WHERE   1=1
			GROUP BY  DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, OPERATION_ID
					, ELTR_LN_TP_CD
					, ITEM_ID
        )
        ,
		tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN AS
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
					, A.ASSIGN_PRIORITY
			FROM    SCP_MST_CAPA_ELTR_LINE_ASSIGN A WITH(NOLOCK)
                    LEFT JOIN tblVersion V ON
                            A.DIVISION_ID = V.DIVISION_ID
			WHERE   1=1
				AND VALID_YN = 'Y'
        )
        ,
		tblSCP0105_RAW_ALL_TEMP AS
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
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.BASE_QTY                                AS PFRSLT_QTY
					, A.BASE_QTY
					, A.QTY
					, B.ASSIGN_PRIORITY
	                , A.REMARK
	                , A.CREATED_BY
	                , A.CREATION_DATE
	                , A.LAST_UPDATED_BY
	                , A.LAST_UPDATE_DATE
			FROM	SCP_MST_CAPA_ELTR_SPEED_PLAN A WITH(NOLOCK)
					JOIN tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN B ON
								A.DIVISION_ID		= B.DIVISION_ID
							AND A.COMPANY_ID		= B.COMPANY_ID
							AND A.SITE_ID			= B.SITE_ID
							AND A.PLANT_ID			= B.PLANT_ID
							AND A.FACTORY_ID		= B.FACTORY_ID
							AND A.LINE_ID			= B.LINE_ID
							AND A.OPERATION_ID		= B.OPERATION_ID
							AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
							AND A.ITEM_ID           = B.ITEM_ID
							AND A.NICK_NAME         = B.NICK_NAME
							AND A.YYYYMM            = B.YYYYMM
					LEFT JOIN tblVersion V ON
                            A.DIVISION_ID = V.DIVISION_ID
			WHERE	1=1
				AND ISNULL(B.ASSIGN_PRIORITY, 0) <> 0
        )
        ,
		tblSCP0105_RAW_ALL AS
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
					, G.UNIT_GROUP                              AS SPEED_UNIT_GROUP
					, A.MSR_TP_CD
					, A.YYYYMM
					, A.PFRSLT_QTY                              AS PFRSLT_QTY
					, A.BASE_QTY
					, A.QTY
					, A.ASSIGN_PRIORITY
	                , A.REMARK
	                , A.CREATED_BY
	                , A.CREATION_DATE
	                , A.LAST_UPDATED_BY
	                , A.LAST_UPDATE_DATE
			FROM	tblSCP0105_RAW_ALL_TEMP A
					JOIN tblSCP0105_SPEED_UNIT_GROUP G ON
							1=1
        )
        ,
		tblSCP0105_RAW_KEYS AS
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
			FROM	tblSCP0105_RAW_ALL A
			WHERE   1=1
					AND A.SPEED_UNIT_GROUP  = 'EQP_SPED'   AND A.MSR_TP_CD = 'EQP_SPED'
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
		tblSCP0105_RAW_TEMP AS
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
					, R.EQP_SPED                                            AS PFRSLT_QTY
					, IIF(X.BASE_QTY IS NULL, B.EQP_SPED, X.BASE_QTY)       AS BASE_QTY
					, X.QTY                                                 AS QTY
					, ISNULL(BU.UI_UPD_YN, 'Y')                             AS UI_UPD_YN
					, X.ASSIGN_PRIORITY
	                , X.REMARK
	                , X.CREATED_BY
	                , X.CREATION_DATE
	                , X.LAST_UPDATED_BY
	                , X.LAST_UPDATE_DATE
			FROM	tblSCP0105_RAW_KEYS A
					LEFT JOIN tblSCP0105_RAW_ALL_TEMP X ON
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
						AND A.MSR_TP_CD				= X.MSR_TP_CD
						AND A.YYYYMM				= X.YYYYMM
					LEFT JOIN tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_RESULT R ON
							A.DIVISION_ID		                            = R.DIVISION_ID
						AND A.COMPANY_ID		                            = R.COMPANY_ID
						AND A.SITE_ID			                            = R.SITE_ID
						AND A.PLANT_ID			                            = R.PLANT_ID
						AND A.FACTORY_ID		                            = R.FACTORY_ID
						AND A.LINE_ID			                            = R.LINE_ID
						AND A.OPERATION_ID		                            = R.OPERATION_ID
						AND A.ELTR_LN_TP_CD	                                = R.ELTR_LN_TP_CD
					LEFT JOIN tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE B ON
							A.DIVISION_ID		                            = B.DIVISION_ID
						AND A.COMPANY_ID		                            = B.COMPANY_ID
						AND A.SITE_ID			                            = B.SITE_ID
						AND A.PLANT_ID			                            = B.PLANT_ID
						AND A.FACTORY_ID		                            = B.FACTORY_ID
						AND A.LINE_ID			                            = B.LINE_ID
						AND A.OPERATION_ID		                            = B.OPERATION_ID
						AND A.ITEM_ID                                       = B.ITEM_ID
						AND A.NICK_NAME                                     = B.NICK_NAME
						AND A.ELTR_LN_TP_CD	                                = B.ELTR_LN_TP_CD
						--AND A.SPEED_UNIT_GROUP                              = B.SPEED_UNIT_GROUP
						--AND A.MSR_TP_CD                                     = B.MSR_TP_CD
					LEFT JOIN tblSCP0105_CHECK_CAPA_SPEED_PLAN_ELTR_BY_ASSIGN_BASE_UI_UPD_YN BU ON
							A.DIVISION_ID		                            = BU.DIVISION_ID
						AND A.COMPANY_ID		                            = BU.COMPANY_ID
						AND A.SITE_ID			                            = BU.SITE_ID
						AND A.PLANT_ID			                            = BU.PLANT_ID
						AND A.FACTORY_ID		                            = BU.FACTORY_ID
						AND A.LINE_ID			                            = BU.LINE_ID
						AND A.OPERATION_ID		                            = BU.OPERATION_ID
						AND A.ITEM_ID                                       = BU.ITEM_ID
						AND A.NICK_NAME                                     = BU.NICK_NAME
						AND A.ELTR_LN_TP_CD	                                = BU.ELTR_LN_TP_CD
        )
        ,
		tblSCP0105_RAW_TEMP2 AS
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
					, MAX(A.UI_UPD_YN)                  AS UI_UPD_YN
					, MAX(A.ASSIGN_PRIORITY)            AS ASSIGN_PRIORITY
					, AVG(ISNULL(A.PFRSLT_QTY, 0.0))    AS PFRSLT_QTY
					, AVG(ISNULL(A.BASE_QTY, 0.0))      AS BASE_QTY
					, AVG(ISNULL(A.QTY, 0.0))           AS QTY
	                , MAX(A.REMARK)                     AS REMARK
	                , MAX(A.CREATED_BY)                 AS CREATED_BY
	                , MAX(A.CREATION_DATE)              AS CREATION_DATE
	                , MAX(A.LAST_UPDATED_BY)            AS LAST_UPDATED_BY
	                , MAX(A.LAST_UPDATE_DATE)           AS LAST_UPDATE_DATE
			FROM    tblSCP0105_RAW_TEMP A
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
					, L.DUMMY_YN                        AS UI_UPD_YN
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
					, CONVERT(NVARCHAR(2),'0')                      AS PROG_STAT
					, ISNULL(C.ASSIGN_PRIORITY, 0)                  AS ASSIGN_PRIORITY
                    , Z.EQUIPMENT_ID
                    , ISNULL(Z.EQUIPMENT_NAME, '-')                 AS EQUIPMENT_NAME
	                , A.REMARK
	                , A.CREATED_BY
	                , A.CREATION_DATE
	                , A.LAST_UPDATED_BY
	                , A.LAST_UPDATE_DATE
			FROM    tblSCP0105_RAW_TEMP2 A
					LEFT JOIN tblSCP0105_SCP_MST_CAPA_ELTR_LINE_ASSIGN C ON
							A.DIVISION_ID		= C.DIVISION_ID
						AND A.COMPANY_ID		= C.COMPANY_ID
						AND A.SITE_ID			= C.SITE_ID
						AND A.PLANT_ID			= C.PLANT_ID
						AND A.FACTORY_ID		= C.FACTORY_ID
						AND A.LINE_ID			= C.LINE_ID
						AND A.OPERATION_ID		= C.OPERATION_ID
						AND A.ELTR_LN_TP_CD	    = C.ELTR_LN_TP_CD
						AND A.ITEM_ID           = C.ITEM_ID
						AND A.NICK_NAME         = C.NICK_NAME
						AND A.YYYYMM            = C.YYYYMM
                    LEFT JOIN tblSCP0104_EQPUIPMENT_LINE Z ON
				            A.DIVISION_ID		= Z.DIVISION_ID
				        AND A.COMPANY_ID		= Z.COMPANY_ID
				        AND A.SITE_ID			= Z.SITE_ID
				        AND A.PLANT_ID			= Z.PLANT_ID
				        AND A.FACTORY_ID		= Z.FACTORY_ID
				        AND A.LINE_ID			= Z.LINE_ID
				        AND A.OPERATION_ID		= Z.OPERATION_ID
				    LEFT JOIN tbl_DAY_CNT DC ON
						    A.DIVISION_ID		= DC.DIVISION_ID
					    AND A.COMPANY_ID		= DC.COMPANY_ID
					    AND A.SITE_ID			= DC.SITE_ID
					    AND A.PLANT_ID			= DC.PLANT_ID
					    AND A.FACTORY_ID		= DC.FACTORY_ID
					    AND A.LINE_ID			= DC.LINE_ID
					    AND A.OPERATION_ID		= DC.OPERATION_ID
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
                    LEFT JOIN tblDummyLine L ON
						    A.DIVISION_ID		= L.DIVISION_ID
					    AND A.COMPANY_ID		= L.COMPANY_ID
					    AND A.SITE_ID			= L.SITE_ID
					    AND A.PLANT_ID			= L.PLANT_ID
					    AND A.FACTORY_ID		= L.FACTORY_ID
					    AND A.LINE_ID			= L.LINE_ID
			WHERE   1=1

	            --AND A.DIVISION_ID		= '81'
	            --AND A.COMPANY_ID		= 'G380'
	            --AND A.ITEM_ID			= 'APCCA2740A'
	            --AND A.SITE_ID			= 'A003'
	            --AND A.PLANT_ID		    = 'G383'
	            --AND A.FACTORY_ID		= 'ES'
	            --AND A.LINE_ID			IN('DMY_TE_ELR_L1','DMY_TE_ELR_L2')
	            --AND A.OPERATION_ID	    = 'E2000'
	            --AND A.MSR_TP_CD		    = 'EQP_SPED'
             --   AND A.YYYYMM            = '202409'


