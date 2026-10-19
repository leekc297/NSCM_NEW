


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP_MST_CAPA_LOSS_PLAN_MDL_V
 * Description  :
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/08/03   chaan        V1.1.0                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/08/29   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - DAY_CNT 로직 수정 - SOP 적용
 * 2024/12/09   chaan        V1.1.9                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Pre Version 누락 추가
 * 2025/02/10   mrchois      V1.1.10               PJ20249346  LGES SCP 개선과제 이행	 - Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
 */

--DROP VIEW [dbo].[SCP_MST_CAPA_LOSS_PLAN_MDL_V];
CREATE VIEW [dbo].[SCP_MST_CAPA_LOSS_PLAN_MDL_V] AS
	WITH tblVersion AS
	(
		SELECT    DIVISION_ID
				, VER_ID
				, VER_SEQ
				, CONVERT(NVARCHAR(6), DATEADD(MM, -1, CONVERT(DATETIME, VER_ID + '01')), 112) AS RESULT_TO_YYYYMM
    		FROM    SCP_MST_CAPA_VERSION
		WHERE   1=1
			--AND VER_ID  = CAST(CONVERT(NVARCHAR(6), GETDATE(), 112) AS INT)
			--AND PROG_STAT = '0'
            AND PROG_STAT IN ('-',  '0') -- Pre, Current
		GROUP BY  DIVISION_ID
				, VER_ID
				, VER_SEQ
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
	tblSCP0106_MEASURE_ALL AS
	(
        SELECT    A.ATTRIBUTE3        AS LOSS_GR_CD
                , A.SEGMENT1          AS LOSS_CD
                , A.ATTRIBUTE6        AS LOSS_GR_NM_KO
                , A.ATTRIBUTE7        AS LOSS_GR_NM_EN
                , A.ATTRIBUTE4        AS LOSS_NM_KO
                , A.ATTRIBUTE5        AS LOSS_NM_EN
                , A.ATTRIBUTE13		  AS TARGET_YN	--@p_sheet_name = = 'CURRENT_TARGET_YN'
                --, A.ATTRIBUTE8        AS TARGET_YN  --@p_sheet_name = 'CUTOFF_MODEL'     --MODEL_TARGET_YN
                --, A.ATTRIBUTE14       AS TARGET_YN  --@p_sheet_name = '1ST_CUTOFF_LINE'  --1ST_LINE_TARGET_YN
                --, A.ATTRIBUTE9        AS TARGET_YN  --@p_sheet_name = '2ND_CUTOFF_LINE'  --2ND_LINE_TARGET_YN
                , A.DISPLAY_SEQ

				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
                --, A.ATTRIBUTE10			AS IPRV_GOL_TP
                --, A.ATTRIBUTE11			AS IPRV_GOL_TP_NM_EN
                --, A.ATTRIBUTE12			AS IPRV_GOL_TP_NM_KO
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END

        FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
        WHERE   1=1
            AND A.LOOKUP_TYPE  = 'SCP_CAPA_LOSS_MEASURE'
            AND A.VALID_YN  = 'Y'
	)
	,
	tblSCP0106_MEASURE_VISIBLE AS
	(
        SELECT  COLUMN_NAME AS MEASURE
        FROM    SCM_MST_SHEET_MEASURE WITH(NOLOCK)
        WHERE   1=1
            AND PROGRAM_ID    = 'SCP0106'
            AND SHEET_NAME    = 'CURRENT_ASSEMBLY'
            AND VALID_YN      = 'Y'
	)
	,
	tblSCP0106_SPEED_PLAN_PPM AS
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
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.BASE_QTY
				, A.QTY
		FROM	SCP_MST_CAPA_SPEED_PLAN_V A
        WHERE   1=1
            AND A.MSR_TP_CD = 'PPM'
	)
	,
    tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN_NICK_NAME AS
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
		FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
				LEFT JOIN tblVersion V ON
						A.DIVISION_ID = V.DIVISION_ID
		WHERE   1=1
			AND ISNULL(VALID_YN, '') <> 'N'
		GROUP BY  V.VER_ID
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
	)
	,
    tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN AS
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
        FROM    SCP_MST_CAPA_LINE_ASSIGN A WITH(NOLOCK)
				LEFT JOIN tblVersion V ON
						A.DIVISION_ID = V.DIVISION_ID
		WHERE   1=1
			AND ISNULL(VALID_YN, '') <> 'N'
    )
    ,
    tblSCP0106_RAW_TEMP AS
	(
		SELECT	  B.VER_ID
				, B.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				--, A.IPRV_GOL_DIVS_CD
				--, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, A.MSR_GR_CD
				, A.MSR_NVL
		FROM	SCP_MST_CAPA_LOSS_PLAN_MDL A WITH(NOLOCK)
				JOIN tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN_NICK_NAME B ON
							A.DIVISION_ID		= B.DIVISION_ID
						AND A.COMPANY_ID		= B.COMPANY_ID
						AND A.SITE_ID			= B.SITE_ID
						AND A.PLANT_ID			= B.PLANT_ID
						AND A.FACTORY_ID		= B.FACTORY_ID
						AND A.LINE_ID			= B.LINE_ID
						AND A.OPERATION_ID		= B.OPERATION_ID
						AND A.ELTR_LN_TP_CD	    = B.ELTR_LN_TP_CD
						AND A.MDL_NM            = B.NICK_NAME
	)
	,
    tblSCP0106_RAW_ALL AS
	(
		SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				--, A.IPRV_GOL_DIVS_CD
				--, A.IPRV_GOL_RT		-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois)
				, A.MSR_GR_CD
				, A.MSR_NVL
				, M.LOSS_NM_EN
				, M.LOSS_GR_NM_EN
				, M.DISPLAY_SEQ                             AS SORT_ORDER_NO
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
                , DAY(EOMONTH(CONVERT(DATETIME, A.VER_ID + '01', 112))) - DAY(CONVERT(DATETIME, A.VER_ID + '01', 112)) + 1      AS DAY_CNT_BASE
				, PP.QTY						            AS SPEED_PPM
				, PP.BASE_QTY					            AS SPEED_BASE_PPM
                , IIF(V.MEASURE IS NOT NULL, 'Y', 'N')      AS MEASURE_VISIBLE
		FROM	tblSCP0106_RAW_TEMP A
				LEFT JOIN tblSCP0106_MEASURE_ALL M ON
						A.MSR_TP_CD				= M.LOSS_CD
                LEFT JOIN tblSCP0106_MEASURE_VISIBLE V ON
					A.MSR_TP_CD				= V.MEASURE
				LEFT JOIN tblSCP0106_SPEED_PLAN_PPM PP ON
						A.VER_ID            = PP.VER_ID
					AND A.VER_SEQ           = PP.VER_SEQ
					AND A.DIVISION_ID		= PP.DIVISION_ID
					AND A.COMPANY_ID		= PP.COMPANY_ID
					AND A.SITE_ID			= PP.SITE_ID
					AND A.PLANT_ID			= PP.PLANT_ID
					AND A.FACTORY_ID		= PP.FACTORY_ID
					AND A.LINE_ID			= PP.LINE_ID
					AND A.OPERATION_ID		= PP.OPERATION_ID
					AND A.ELTR_LN_TP_CD		= PP.ELTR_LN_TP_CD
					AND A.MDL_NM			= PP.NICK_NAME
					AND A.YYYYMM			= PP.YYYYMM
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
					AND A.ELTR_LN_TP_CD		= DY.ELTR_LN_TP_CD
					AND A.YYYYMM			= DY.YYYY
        --WHERE   1=1
        --    AND A.DIVISION_ID		= N'81'
        --    AND A.SITE_ID			= N'A001'
        --    AND A.PLANT_ID  		= N'A040'
        --    AND A.FACTORY_ID		= N'A2'
        --    AND A.LINE_ID			= N'A2A13'
        --    AND A.OPERATION_ID	    = N'A9000'
        --    --AND A.ELTR_LN_TP_CD 	= N'Anode'
        --    AND A.MDL_NM            = 'E52A'
        --    AND A.YYYYMM            = N'202410'
        --    AND A.MSR_TP_CD         IN ('PROD_CAPA_M', 'PROD_CAPA_D')
	)
	,
	tblSCP0106_RAW3 AS
	(
		SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, CASE
					WHEN MSR_TP_CD IN (   'PROD_CAPA_M'
										, 'PROD_CAPA_D'
										, 'THRY_CAPA_D') THEN NULL --실적에서 CAPA 제외
					WHEN MSR_TP_CD IN (   'SCP_PROD_PLAN'
										, 'SCP_PROD_PLAN_DDN'
										, 'SD_RT'
										, 'WT_RT'
										, 'TD_RT'
										, 'MC_RT') THEN PFRSLT_NVL --일수 or EA
					ELSE PFRSLT_NVL * 100.0 --비율로 표시
				  END AS PFRSLT_NVL
				, CASE
					WHEN MSR_TP_CD IN (   'SCP_PROD_PLAN'
										, 'PROD_CAPA_M'
										, 'PROD_CAPA_D'
										, 'SCP_PROD_PLAN_DDN'
										, 'THRY_CAPA_D'
										, 'SD_RT'
										, 'WT_RT'
										, 'TD_RT'
										, 'MC_RT') THEN BASE_NVL --일수 or EA
					ELSE BASE_NVL * 100.0 --비율로 표시
				  END AS BASE_NVL
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
				--, A.IPRV_GOL_DIVS_CD
				--, CASE
				--	WHEN MSR_TP_CD IN (   'SCP_PROD_PLAN'
				--						, 'PROD_CAPA_M'
				--						, 'PROD_CAPA_D'
				--						, 'SCP_PROD_PLAN_DDN'
				--						, 'THRY_CAPA_D'
				--						, 'SD_RT'
				--						, 'WT_RT'
				--						, 'TD_RT'
				--						, 'MC_RT') THEN IPRV_GOL_RT --일수 or EA
				--	ELSE IPRV_GOL_RT * 100.0 --비율로 표시
				--  END AS IPRV_GOL_RT
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END
				, A.MSR_GR_CD
				, CASE
					WHEN MSR_TP_CD IN (   'SCP_PROD_PLAN'
										, 'PROD_CAPA_M'
										, 'PROD_CAPA_D'
										, 'SCP_PROD_PLAN_DDN'
										, 'THRY_CAPA_D'
										, 'SD_RT'
										, 'WT_RT'
										, 'TD_RT'
										, 'MC_RT') THEN MSR_NVL --일수 or EA
					ELSE MSR_NVL * 100.0 --비율로 표시
				  END AS MSR_NVL
				, A.LOSS_NM_EN
				, A.LOSS_GR_NM_EN
				, A.SORT_ORDER_NO
				, A.DAY_CNT
				, A.DAY_CNT_BASE
				, A.SPEED_PPM
				, A.SPEED_BASE_PPM
                , A.MEASURE_VISIBLE
		FROM    tblSCP0106_RAW_ALL A
	)
		SELECT    A.VER_ID
				, A.VER_SEQ
				, A.DIVISION_ID
				, A.MDL_NM
				, A.PLANT_ID
				, A.LINE_ID
				, A.OPERATION_ID
				, A.ELTR_LN_TP_CD
				, A.COMPANY_ID
				, A.SITE_ID
				, A.FACTORY_ID
				, A.MSR_TP_CD
				, A.YYYYMM
				, A.PFRSLT_NVL
				, A.BASE_NVL
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) START
				--, A.IPRV_GOL_DIVS_CD
				--, CASE
				--	WHEN ISNULL(B.ASSIGN_PRIORITY, 0) = 0 THEN NULL --우선순위가 없으면 클리어
				--	ELSE A.IPRV_GOL_RT
				--  END AS IPRV_GOL_RT
				-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-10 mrchois) END
				, A.MSR_GR_CD
				, CASE
					WHEN ISNULL(B.ASSIGN_PRIORITY, 0) = 0 THEN NULL --우선순위가 없으면 클리어
					ELSE A.MSR_NVL
				  END AS MSR_NVL
				, A.LOSS_NM_EN
				, A.LOSS_GR_NM_EN
				, A.SORT_ORDER_NO
			    , A.DAY_CNT
			    , A.DAY_CNT_BASE
			    , A.SPEED_PPM
				, A.SPEED_BASE_PPM
                , B.ASSIGN_PRIORITY
                , A.MEASURE_VISIBLE
		FROM    tblSCP0106_RAW3 A
				LEFT JOIN tblSCP0105_SCP_MST_CAPA_LINE_ASSIGN B ON
						A.DIVISION_ID		= B.DIVISION_ID
					AND A.COMPANY_ID		= B.COMPANY_ID
					AND A.SITE_ID			= B.SITE_ID
					AND A.PLANT_ID			= B.PLANT_ID
					AND A.FACTORY_ID		= B.FACTORY_ID
					AND A.LINE_ID			= B.LINE_ID
					AND A.OPERATION_ID		= B.OPERATION_ID
					AND A.ELTR_LN_TP_CD		= B.ELTR_LN_TP_CD
					AND A.MDL_NM			= B.NICK_NAME
					AND A.YYYYMM			= B.YYYYMM

		WHERE   1=1
            ----AND A.MSR_GR_CD <> 'NAV'            -- Current 는 비조업 제외
            ----AND A.MSR_TP_CD <> 'SCP_PROD_PLAN'  -- Current 는 Final Production Plan 제외


            --AND A.VER_ID  = '202410'
            --AND A.VER_SEQ = 2

            ----AND A.DIVISION_ID         = '81'
            ----AND A.SITE_ID             = 'A002'
            ----AND A.PLANT_ID            = 'G451'
            ----AND A.FACTORY_ID          = 'A3'
            --AND A.LINE_ID             = 'A7A21'
            ----AND A.OPERATION_ID        = 'AFFFF'
            --AND A.YYYYMM              = '2029'
            --AND A.MSR_TP_CD           IN ('PROD_CAPA_D', 'PROD_CAPA_M')

