/*
 * Program ID   : PR_SSP_XIF_MES_WIP_LOT_EE_R
 * Description  : 전극 MES LOT 재고 정보 I/F 수신 반영(Every 10 min)  
 * OutTable     : XIF_MES_WIP_LOT_EE_R_SN --> SSP_DNM_GMES_STOCK_EE
 * Execute      : 
 * Program History
 *===================================================================================================
 * Date         In Charge      Description
 *===================================================================================================
 * 20210901     SSP Pjt.       Create. 
 * 20241001     KHJ            NERP_SSP
 * 
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_MES_WIP_LOT_EE_R]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_MES_WIP_LOT_EE_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_GMES_STOCK_EE'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_GMES_STOCK_EE INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

	DECLARE @v_count          INT  = 0 ;
	declare @v_sum_date     nvarchar(8) = convert(nvarchar, getdate(), 112);
	--set @v_sum_date = '20210825'


	DECLARE @XIF_MES_WIP_LOT_R TABLE (
		[IF_SEQ] [nvarchar](50) NOT NULL,
		[IF_TYPE] [nvarchar](1) NOT NULL,
		[IF_ID] [nvarchar](50) NOT NULL,
		[IF_RCV_DATE] [datetime] NOT NULL,
		[PROC_FLAG] [nvarchar](1) NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[SUM_DATE] [nvarchar](50) NULL,
		[DB_TYPE] [nvarchar](50) NULL,
		[SUM_ID] [nvarchar](300) NULL,
		[PRODID] [nvarchar](50) NULL,
		[UNIT_CODE] [nvarchar](50) NULL,
		[MODLID] [nvarchar](50) NULL,
		[PRJT_NAME] [nvarchar](200) NULL,
		[WOID] [nvarchar](50) NULL,
		[WO_DETL_ID] [nvarchar](50) NULL,
		[COMPANY_CODE] [nvarchar](50) NULL,
		[SHOPID] [nvarchar](50) NULL,
		[AREAID] [nvarchar](50) NULL,
		[PROCID] [nvarchar](50) NULL,
		[EQSGID] [nvarchar](50) NULL,
		[EQPTID] [nvarchar](50) NULL,
		[WIPSTAT] [nvarchar](50) NULL,
		[WIP_TYPE_CODE] [nvarchar](50) NULL,
		[SLOC_ID] [nvarchar](50) NULL,
		[EQPT_FLOOR_NO] [nvarchar](50) NULL,
		[COATING_AREAID] [nvarchar](50) NULL,
		[COATING_EQSGID] [nvarchar](50) NULL,
		[COATING_EQPTID] [nvarchar](50) NULL,
		[COATING_SIDE_TYPE_CODE] [nvarchar](50) NULL,
		[LOTTYPE] [nvarchar](50) NULL,
		[LANE_QTY] [int] NULL,
		[MKT_TYPE_CODE] [nvarchar](50) NULL,
		[MOVE_TYPE_CODE] [nvarchar](50) NULL,
		[TO_PROCID] [nvarchar](50) NULL,
		[TO_EQSGID] [nvarchar](50) NULL,
		[TO_SLOC_ID] [nvarchar](50) NULL,
		[CURR_WIP_QLTY_TYPE_CODE] [nvarchar](50) NULL,
		[FCS_RWK_FALG] [nvarchar](50) NULL,
		[FINL_2ND_OCV_INSP_SEQS] [int] NULL,
		[FINL_2ND_OCV_INSP_END_DTTM] [nvarchar](50) NULL,
		[PROD_HOLD_FLAG] [nvarchar](1) NULL,
		[QLTY_HOLD_FLAG] [nvarchar](1) NULL,
		[PROC_HOLD_FLAG] [nvarchar](1) NULL,
		[TOTL_QLTY_HOLD_FLAG] [nvarchar](1) NULL,
		[QLTY_NO_INSP_FLAG] [nvarchar](1) NULL,
		[LONG_TERM_STCK_FLAG] [nvarchar](1) NULL,
		[WIPQTY] [decimal](18, 5) NULL,
		[WIPQTY_IN] [decimal](18, 5) NULL,
		[WIPQTY_ST] [decimal](18, 5) NULL,
		[WIPQTY_ED] [decimal](18, 5) NULL,
		[WIPQTY2] [decimal](18, 5) NULL,
		[WIPQTY2_IN] [decimal](18, 5) NULL,
		[WIPQTY2_ST] [decimal](18, 5) NULL,
		[WIPQTY2_ED] [decimal](18, 5) NULL,
		[LOTID] [nvarchar](50) NULL,
		[BOXID] [nvarchar](50) NULL,
		[LOTID_RT] [nvarchar](50) NULL,
		[PROD_VER_CODE] [nvarchar](50) NULL,
		[PROD_DATE] [nvarchar](8) NULL,
		[VLD_DATE] [nvarchar](8) NULL,
		[COATING_PROD_DATE] [nvarchar](8) NULL,
		[PACKDTTM] [datetime] NULL,
		[UNPACKDTTM] [datetime] NULL,
		[BOXSTAT] [nvarchar](50) NULL,
		[BOXTYPE] [nvarchar](50) NULL,
		[SHIPTO_ID] [nvarchar](50) NULL,
		[SHIPTO_NAME] [nvarchar](1000) NULL,
		[PACK_NOTE] [nvarchar](1000) NULL,
		[WH_ID] [nvarchar](50) NULL,
		[OQC_JUDG_VALUE] [nvarchar](50) NULL,
		[BOX_WIP_STAT_CODE] [nvarchar](50) NULL,
		[PROD_HOLD_DATE] [nvarchar](8) NULL,
		[PROD_HOLD_NOTE] [nvarchar](1000) NULL,
		[PROD_HOLD_CODE] [nvarchar](50) NULL,
		[PROD_HOLD_USERID] [nvarchar](50) NULL,
		[PROD_UNHOLD_SCHD_DATE] [nvarchar](8) NULL,
		[PROD_UNHOLD_DATE] [nvarchar](8) NULL,
		[PROD_UNHOLD_NOTE] [nvarchar](1000) NULL,
		[PROD_UNHOLD_CODE] [nvarchar](50) NULL,
		[PROD_UNHOLD_USERID] [nvarchar](50) NULL,
		[QLTY_HOLD_DATE] [nvarchar](8) NULL,
		[QLTY_HOLD_NOTE] [nvarchar](1000) NULL,
		[QLTY_HOLD_CODE] [nvarchar](50) NULL,
		[QLTY_HOLD_USERID] [nvarchar](50) NULL,
		[QLTY_UNHOLD_SCHD_DATE] [nvarchar](8) NULL,
		[QLTY_UNHOLD_DATE] [nvarchar](8) NULL,
		[QLTY_UNHOLD_NOTE] [nvarchar](1000) NULL,
		[QLTY_UNHOLD_CODE] [nvarchar](50) NULL,
		[QLTY_UNHOLD_USERID] [nvarchar](50) NULL,
		[PROC_HOLD_DATE] [nvarchar](8) NULL,
		[PROC_HOLD_NOTE] [nvarchar](1000) NULL,
		[PROC_HOLD_CODE] [nvarchar](50) NULL,
		[PROC_HOLD_USERID] [nvarchar](50) NULL,
		[PROC_UNHOLD_SCHD_DATE] [nvarchar](8) NULL,
		[PROC_UNHOLD_DATE] [nvarchar](8) NULL,
		[PROC_UNHOLD_NOTE] [nvarchar](1000) NULL,
		[PROC_UNHOLD_CODE] [nvarchar](50) NULL,
		[PROC_UNHOLD_USERID] [nvarchar](50) NULL,
		[TOTL_QLTY_HOLD_DATE] [nvarchar](8) NULL,
		[TOTL_QLTY_HOLD_NOTE] [nvarchar](1000) NULL,
		[TOTL_QLTY_HOLD_CODE] [nvarchar](50) NULL,
		[TOTL_QLTY_HOLD_USERID] [nvarchar](50) NULL,
		[TOTL_QLTY_UNHOLD_SCHD_DATE] [nvarchar](8) NULL,
		[TOTL_QLTY_UNHOLD_DATE] [nvarchar](8) NULL,
		[TOTL_QLTY_UNHOLD_NOTE] [nvarchar](1000) NULL,
		[TOTL_QLTY_UNHOLD_CODE] [nvarchar](50) NULL,
		[TOTL_QLTY_UNHOLD_USERID] [nvarchar](50) NULL,
		[QLTY_NO_INSP_NOTE] [nvarchar](1000) NULL,
		[SUM_COUNT] [int] NULL,
		[SUM_ITEM_SEQNO] [int] NULL,
		[SUM_DTTM] [datetime] NULL,
		[IF_DETAIL_CNT] [int] NULL,
		[ATTR_01] [nvarchar](1000) NULL,
		[ATTR_02] [nvarchar](1000) NULL,
		[ATTR_03] [nvarchar](1000) NULL,
		[ATTR_04] [nvarchar](1000) NULL,
		[ATTR_05] [nvarchar](1000) NULL,
		[ATTR_06] [nvarchar](1000) NULL,
		[ATTR_07] [nvarchar](1000) NULL,
		[ATTR_08] [nvarchar](1000) NULL,
		[ATTR_09] [nvarchar](1000) NULL,
		[ATTR_10] [nvarchar](1000) NULL
	) 

    BEGIN TRY

        BEGIN TRAN TX_SH

		DECLARE @stock_cnt INTEGER, 
			    @company_id VARCHAR(30) 

		-- COMPANY 별 I/F 건수와 전송 대상 건수 체크
		DECLARE CUR_MES_STOCK CURSOR 
		FOR  
/* INF-R 적용 이전 
		 SELECT COMPANY_ID
		      , SUM(CHECK_CNT) AS STOCK_CNT
		   FROM (
				SELECT COMPANY_ID
					 , GROUP_SEQ
					 , SND_CNT
					 , RCV_CNT
					 , CASE WHEN SND_CNT = 0 THEN 0
					 	    WHEN SND_CNT IS NULL THEN 1
					   ELSE CASE WHEN RCV_CNT <> SND_CNT THEN 1 ELSE 0 END 
					   END   AS CHECK_CNT
				  FROM (
					   SELECT COMPANY_CODE		AS COMPANY_ID
							, IF_ID				AS GROUP_SEQ
							, SUM_COUNT			AS SND_CNT
							, COUNT(*)			AS RCV_CNT
						 FROM XIF_MES_WIP_LOT_R_SN  WITH(NOLOCK)
						WHERE 1 = 1
						  AND SUM_DATE				= @v_sum_date
						  AND DB_TYPE IN ('ELTR', 'CELL')
						  AND COMPANY_CODE NOT IN (SELECT A.SEGMENT4
			                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			                                        WHERE 1 = 1
			                                          AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
			                                          AND A.SEGMENT1		= 'PLAN_EE'
			                                          AND A.SEGMENT2		= 'MES'
			                                          AND A.SEGMENT3		= 'EE'
			                                          AND A.SEGMENT5		= @v_sum_date
			                                          AND A.ATTRIBUTE1		= 'Y'
			                                       )
						GROUP BY 
						      COMPANY_CODE
							 ,IF_ID
							 ,SUM_COUNT
						UNION ALL
						SELECT B.COMPANY_ID			AS COMPANY_ID
							 , A.IF_ID				AS GROUP_SEQ
							 , 1					AS SND_CNT
							 , 1					AS RCV_CNT
						  FROM XIF_MES_WIP_LOT_R_SN AS A  WITH(NOLOCK)
							   JOIN (SELECT TOKEN + '_OSCM_SCM_WIP_LOT' AS IF_ID
										  , SEGMENT4    AS COMPANY_ID
									   FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
										    CROSS APPLY STRING_SPLIT(ATTRIBUTE2, ',')
									  WHERE 1 = 1
									    AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
									    AND A.SEGMENT1			= 'PLAN_EE'
									    AND A.SEGMENT2			= 'MES'
									    AND A.SEGMENT3			= 'EE'
										AND A.SEGMENT5			!= @v_sum_date
									    AND A.ATTRIBUTE1		= 'Y'
								    ) AS B
						   ON A.IF_ID = B.IF_ID
						WHERE 1 = 1
						  AND A.SUM_DATE		= @v_sum_date
						  AND A.PROC_FLAG		= 'N'
						  AND A.DB_TYPE			= 'ELTR'
						  AND A.SUM_COUNT		= 0
						  AND A.COMPANY_CODE	IS NULL
						GROUP BY B.COMPANY_ID, A.IF_ID
					   ) X
                ) A
		  WHERE 1 = 1
		  GROUP BY 
		        COMPANY_ID
		;
*/
/* INF-R 적용 이후*/ 
		 SELECT COMPANY_ID
		      , SUM(CHECK_CNT) AS STOCK_CNT
		   FROM (
				SELECT COMPANY_ID
					 , GROUP_SEQ
					 , SND_CNT
					 , RCV_CNT
					 , CASE WHEN SND_CNT = 0 THEN 0
					 	    WHEN SND_CNT IS NULL THEN 1
					   ELSE CASE WHEN RCV_CNT <> SND_CNT THEN 1 ELSE 0 END 
					   END   AS CHECK_CNT
				  FROM (
					   SELECT ISNULL (X1.NEW_VALUE1, COMPANY_CODE)		AS COMPANY_ID
							, IF_ID				AS GROUP_SEQ
							, SUM_COUNT			AS SND_CNT
							, COUNT(*)			AS RCV_CNT
						FROM XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'COMPANY_ID'
							AND A.COMPANY_CODE = X1.OLD_VALUE1 
							AND X1.ATTRIBUTE5 = '1ST'
						WHERE 1 = 1
						  AND SUM_DATE				= @v_sum_date
						  AND DB_TYPE IN ('ELTR', 'CELL')
						  AND COMPANY_CODE NOT IN (SELECT A.SEGMENT4
			                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			                                        WHERE 1 = 1
			                                          AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
			                                          AND A.SEGMENT1		= 'PLAN_EE'
			                                          AND A.SEGMENT2		= 'MES'
			                                          AND A.SEGMENT3		= 'EE'
			                                          AND A.SEGMENT5		= @v_sum_date
			                                          AND A.ATTRIBUTE1		= 'Y'
			                                       )
						GROUP BY 
						      COMPANY_CODE
							 ,IF_ID
							 ,SUM_COUNT
							 ,X1.NEW_VALUE1
						UNION ALL
						SELECT B.COMPANY_ID		AS COMPANY_ID
							 , A.IF_ID				AS GROUP_SEQ
							 , 1					AS SND_CNT
							 , 1					AS RCV_CNT
						  FROM XIF_MES_WIP_LOT_R_SN AS A  WITH(NOLOCK)
							   JOIN (SELECT TOKEN + '_OSCM_SCM_WIP_LOT' AS IF_ID
										  , SEGMENT4    AS COMPANY_ID
									   FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
										    CROSS APPLY STRING_SPLIT(ATTRIBUTE2, ',')
									  WHERE 1 = 1
									    AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
									    AND A.SEGMENT1			= 'PLAN_EE'
									    AND A.SEGMENT2			= 'MES'
									    AND A.SEGMENT3			= 'EE'
										AND A.SEGMENT5			!= @v_sum_date
									    AND A.ATTRIBUTE1		= 'Y'
								    ) AS B
						   ON A.IF_ID = B.IF_ID
						WHERE 1 = 1
						  AND A.SUM_DATE		= @v_sum_date
						  AND A.PROC_FLAG		= 'N'
						  AND A.DB_TYPE			= 'ELTR'
						  AND A.SUM_COUNT		= 0
						  AND A.COMPANY_CODE	IS NULL
						GROUP BY B.COMPANY_ID, A.IF_ID
					   ) X
                ) A
		  WHERE 1 = 1
		  GROUP BY 
		        COMPANY_ID
		;
		OPEN CUR_MES_STOCK; 

		FETCH NEXT FROM CUR_MES_STOCK 
		INTO @company_id ,@stock_cnt

		WHILE(@@FETCH_STATUS = 0) 
		BEGIN

			-- COMPANY별 수행여부 체크
			SELECT @v_count = COUNT(*)
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			 WHERE 1 = 1
			   AND A.LOOKUP_TYPE	= 'IF_STOCK_CHECK'
			   AND A.SEGMENT1		= 'PLAN_EE'
			   AND A.SEGMENT2		= 'MES'
			   AND A.SEGMENT3		= 'EE'
			   AND A.SEGMENT4		= @company_id
			   AND A.SEGMENT5		= @v_sum_date
			   AND A.ATTRIBUTE1     = 'Y'
			;

			IF @stock_cnt = 0 AND @v_count = 0
			BEGIN

				DELETE FROM @XIF_MES_WIP_LOT_R

/*
				INSERT INTO @XIF_MES_WIP_LOT_R
				SELECT *
				  FROM dbo.XIF_MES_WIP_LOT_R_SN WITH(NOLOCK) 
				 WHERE 1 = 1
				   AND PROC_FLAG	= 'N' 
				   AND COMPANY_CODE = @company_id
				   AND SUM_DATE		= @v_sum_date
				   AND DB_TYPE		IN ('ELTR', 'CELL')
				   AND PRODID		LIKE 'APC%'
				 ORDER BY 
				       IF_SEQ
*/

				INSERT INTO @XIF_MES_WIP_LOT_R
				SELECT [IF_SEQ]
					  ,[IF_TYPE]
					  ,[IF_ID]
					  ,[IF_RCV_DATE]
					  ,[PROC_FLAG]
					  ,[PROC_DATE]
					  ,[PROC_MSG]
					  ,[SUM_DATE]
					  ,[DB_TYPE]
					  ,[SUM_ID]
					  ,[PRODID]
					  ,[UNIT_CODE]
					  ,[MODLID]
					  ,[PRJT_NAME]
					  ,[WOID]
					  ,[WO_DETL_ID]
					  ,ISNULL(X1.NEW_VALUE1 ,A.COMPANY_CODE)		AS [COMPANY_CODE]
					  ,ISNULL(X2.NEW_VALUE1 ,A.SHOPID)				AS [SHOPID]
					  ,[AREAID]
					  ,[PROCID]
					  ,[EQSGID]
					  ,[EQPTID]
					  ,[WIPSTAT]
					  ,[WIP_TYPE_CODE]
					  ,ISNULL(X3.NEW_VALUE2 ,A.SLOC_ID)				AS [SLOC_ID]
					  ,[EQPT_FLOOR_NO]
					  ,[COATING_AREAID]
					  ,[COATING_EQSGID]
					  ,[COATING_EQPTID]
					  ,[COATING_SIDE_TYPE_CODE]
					  ,[LOTTYPE]
					  ,[LANE_QTY]
					  ,[MKT_TYPE_CODE]
					  ,[MOVE_TYPE_CODE]
					  ,[TO_PROCID]
					  ,[TO_EQSGID]
					  ,[TO_SLOC_ID]
					  ,[CURR_WIP_QLTY_TYPE_CODE]
					  ,[FCS_RWK_FALG]
					  ,[FINL_2ND_OCV_INSP_SEQS]
					  ,[FINL_2ND_OCV_INSP_END_DTTM]
					  ,[PROD_HOLD_FLAG]
					  ,[QLTY_HOLD_FLAG]
					  ,[PROC_HOLD_FLAG]
					  ,[TOTL_QLTY_HOLD_FLAG]
					  ,[QLTY_NO_INSP_FLAG]
					  ,[LONG_TERM_STCK_FLAG]
					  ,[WIPQTY]
					  ,[WIPQTY_IN]
					  ,[WIPQTY_ST]
					  ,[WIPQTY_ED]
					  ,[WIPQTY2]
					  ,[WIPQTY2_IN]
					  ,[WIPQTY2_ST]
					  ,[WIPQTY2_ED]
					  ,[LOTID]
					  ,[BOXID]
					  ,[LOTID_RT]
					  ,[PROD_VER_CODE]
					  ,[PROD_DATE]
					  ,[VLD_DATE]
					  ,[COATING_PROD_DATE]
					  ,[PACKDTTM]
					  ,[UNPACKDTTM]
					  ,[BOXSTAT]
					  ,[BOXTYPE]
					  ,[SHIPTO_ID]
					  ,[SHIPTO_NAME]
					  ,[PACK_NOTE]
					  ,[WH_ID]
					  ,[OQC_JUDG_VALUE]
					  ,[BOX_WIP_STAT_CODE]
					  ,[PROD_HOLD_DATE]
					  ,[PROD_HOLD_NOTE]
					  ,[PROD_HOLD_CODE]
					  ,[PROD_HOLD_USERID]
					  ,[PROD_UNHOLD_SCHD_DATE]
					  ,[PROD_UNHOLD_DATE]
					  ,[PROD_UNHOLD_NOTE]
					  ,[PROD_UNHOLD_CODE]
					  ,[PROD_UNHOLD_USERID]
					  ,[QLTY_HOLD_DATE]
					  ,[QLTY_HOLD_NOTE]
					  ,[QLTY_HOLD_CODE]
					  ,[QLTY_HOLD_USERID]
					  ,[QLTY_UNHOLD_SCHD_DATE]
					  ,[QLTY_UNHOLD_DATE]
					  ,[QLTY_UNHOLD_NOTE]
					  ,[QLTY_UNHOLD_CODE]
					  ,[QLTY_UNHOLD_USERID]
					  ,[PROC_HOLD_DATE]
					  ,[PROC_HOLD_NOTE]
					  ,[PROC_HOLD_CODE]
					  ,[PROC_HOLD_USERID]
					  ,[PROC_UNHOLD_SCHD_DATE]
					  ,[PROC_UNHOLD_DATE]
					  ,[PROC_UNHOLD_NOTE]
					  ,[PROC_UNHOLD_CODE]
					  ,[PROC_UNHOLD_USERID]
					  ,[TOTL_QLTY_HOLD_DATE]
					  ,[TOTL_QLTY_HOLD_NOTE]
					  ,[TOTL_QLTY_HOLD_CODE]
					  ,[TOTL_QLTY_HOLD_USERID]
					  ,[TOTL_QLTY_UNHOLD_SCHD_DATE]
					  ,[TOTL_QLTY_UNHOLD_DATE]
					  ,[TOTL_QLTY_UNHOLD_NOTE]
					  ,[TOTL_QLTY_UNHOLD_CODE]
					  ,[TOTL_QLTY_UNHOLD_USERID]
					  ,[QLTY_NO_INSP_NOTE]
					  ,[SUM_COUNT]
					  ,[SUM_ITEM_SEQNO]
					  ,[SUM_DTTM]
					  ,[IF_DETAIL_CNT]
					  ,[ATTR_01]
					  ,[ATTR_02]
					  ,[ATTR_03]
					  ,[ATTR_04]
					  ,[ATTR_05]
					  ,[ATTR_06]
					  ,[ATTR_07]
					  ,[ATTR_08]
					  ,[ATTR_09]
					  ,[ATTR_10]
				FROM dbo.XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK) 
					LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
					ON  X1.CODETYPE = 'COMPANY_ID'
					AND A.COMPANY_CODE = X1.OLD_VALUE1 
					AND X1.ATTRIBUTE5 = '1ST'
					LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
					ON  X2.CODETYPE = 'PLANT_ID'
					AND A.SHOPID = X2.OLD_VALUE1 
					AND X2.ATTRIBUTE5 = '1ST'
					LEFT OUTER JOIN  NERP_CONV_MASTER X3 WITH(NOLOCK)
					ON  X3.CODETYPE = 'STORAGE_ID'
					AND A.SHOPID = X3.OLD_VALUE1 
					AND A.SLOC_ID = X3.OLD_VALUE2 
					AND X3.ATTRIBUTE5 = '1ST'
				 WHERE 1 = 1
				   AND PROC_FLAG	= 'N' 
				   AND COMPANY_CODE = @company_id
				   AND SUM_DATE		= @v_sum_date
				   AND DB_TYPE		IN ('ELTR', 'CELL')
				   AND PRODID		LIKE 'APC%'
				 ORDER BY 
				       IF_SEQ
				;

				MERGE INTO SSP_DNM_GMES_STOCK_EE M
				USING
				(
					SELECT 
						   S.DIVISION_ID				AS DIVISION_ID         
						  ,S.COMPANY_ID					AS COMPANY_ID    --      
						  ,S.SCM_SITE_ID				AS FROM_SITE           
						  ,X.SUM_DATE					AS YYYYMMDD   --         
						  ,CASE WHEN X.DB_TYPE = 'ELTR' THEN 'E' ELSE 'A' END					
						                                AS INSTANCE_TYPE       
						  ,X.SHOPID						AS PLANT_ID  --          
						  ,X.LOTID						AS LOT_ID   --           
						  ,X.PRODID						AS ITEM_ID  --           
						  ,max(X.MODLID)				AS MODEL_ID            
						  ,max(X.PRJT_NAME)				AS PRJT_NAME           
						  ,NULL							AS NOW_FACTORY         
						  ,max(X.AREAID)				AS PROD_FACTORY        
						  ,max(X.PROD_VER_CODE)			AS ELECTRODE_VERSION   --
						  ,max(X.LANE_QTY)				AS LANE     --           
						  ,max(X.UNIT_CODE)				AS UOM      --           
						  ,max(X.WIPQTY2)				AS STOCK_QTY   --        
						  ,NULL							AS STOCK_QTY_PC_M         
						  ,min(X.VLD_DATE)				AS EXPIRATION_DATE     
						  ,max(X.COATING_PROD_DATE)		AS COATING_PROD_DATE   
						  ,max(X.PROCID)				AS OPERATION_ID        
						  ,max(X.EQSGID)				AS LINE_ID             
						  ,max(X.PROD_HOLD_FLAG)		AS MES_HOLD      --      
						  ,max(X.QLTY_HOLD_FLAG)		AS QMS_HOLD      --      
						  ,NULL							AS MES_HOLD_DATE       
						  ,NULL							AS QMS_HOLD_DATE       
						  ,NULL							AS MES_UNHOLD_SCHD_DATE
						  ,NULL							AS QMS_UNHOLD_SCHD_DATE
						  ,NULL							AS STORAGE_ID_MES      
						  ,max(X.SLOC_ID)				AS STORAGE_ID_ERP      
						  ,max(X.WIPSTAT)				AS STOCK_STATUS        
						  ,max(X.MOVE_TYPE_CODE)		AS STOCK_TYPE          
						  ,max(X.LOTTYPE)				AS PROD_TYPE           
						  ,max(X.MKT_TYPE_CODE)			AS DOMESTIC_TYPE       
						  ,max(X.IF_ID)					AS CREATED_BY          
						  ,max(X.IF_RCV_DATE)			AS CREATION_DATE       
						  ,max(X.IF_ID)					AS LAST_UPDATED_BY     
						  ,GETDATE()					AS LAST_UPDATE_DATE  
						  ,max(X.IF_SEQ)				AS ATTRIBUTE1	
						  ,max(X.ATTR_02)				AS ATTRIBUTE2  
						  ,max(X.ATTR_03)				AS ATTRIBUTE3  
						  ,max(X.ATTR_04)				AS ATTRIBUTE4  
						  ,max(X.ATTR_05)				AS ATTRIBUTE5  
						  ,max(X.ATTR_06)				AS ATTRIBUTE6  
						  ,max(X.ATTR_07)				AS ATTRIBUTE7  
						  ,max(X.ATTR_08)				AS ATTRIBUTE8  
						  ,max(X.ATTR_09)				AS ATTRIBUTE9  
						  ,max(X.ATTR_10)				AS ATTRIBUTE10   
					  FROM @XIF_MES_WIP_LOT_R X 
						   JOIN SCM_MST_SITE AS S WITH(NOLOCK) 
						ON S.PLANT_ID				= X.SHOPID 
					   AND S.SITE_TYPE				= 'PLANT'
					   AND S.OPERATION_GROUP		= CASE WHEN X.DB_TYPE = 'ELTR' THEN 'E' ELSE 'A' END  -- A:조립 ,E:전극 
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
					 group by
						   S.DIVISION_ID  
						 , S.COMPANY_ID   
						 , S.SCM_SITE_ID    
						 , X.SUM_DATE     
						 , X.DB_TYPE
						 , X.SHOPID     
						 , X.LOTID       
						 , X.PRODID     				       
				) F
					 ON F.DIVISION_ID   = M.DIVISION_ID       
					AND F.COMPANY_ID    = M.COMPANY_ID       
					AND F.FROM_SITE     = M.FROM_SITE      
					AND F.YYYYMMDD      = M.YYYYMMDD         
					AND F.INSTANCE_TYPE = M.INSTANCE_TYPE    
					AND F.PLANT_ID      = M.PLANT_ID         
					AND F.LOT_ID        = M.LOT_ID            
					AND F.ITEM_ID       = M.ITEM_ID         
				WHEN MATCHED THEN
				UPDATE
				   SET 
					   M.MODEL_ID             =  F.MODEL_ID             
					  ,M.PRJT_NAME            =  F.PRJT_NAME            
					  ,M.NOW_FACTORY          =  F.NOW_FACTORY          
					  ,M.PROD_FACTORY         =  F.PROD_FACTORY         
					  ,M.ELECTRODE_VERSION    =  F.ELECTRODE_VERSION    
					  ,M.LANE                 =  F.LANE                 
					  ,M.UOM                  =  F.UOM                  
					  ,M.STOCK_QTY            =  F.STOCK_QTY            
					  ,M.STOCK_QTY_PC_M       =  F.STOCK_QTY_PC_M          
					  ,M.EXPIRATION_DATE      =  F.EXPIRATION_DATE      
					  ,M.COATING_PROD_DATE    =  F.COATING_PROD_DATE    
					  ,M.OPERATION_ID         =  F.OPERATION_ID         
					  ,M.LINE_ID              =  F.LINE_ID              
					  ,M.MES_HOLD             =  F.MES_HOLD             
					  ,M.QMS_HOLD             =  F.QMS_HOLD             
					  ,M.MES_HOLD_DATE        =  F.MES_HOLD_DATE        
					  ,M.QMS_HOLD_DATE        =  F.QMS_HOLD_DATE        
					  ,M.MES_UNHOLD_SCHD_DATE =  F.MES_UNHOLD_SCHD_DATE 
					  ,M.QMS_UNHOLD_SCHD_DATE =  F.QMS_UNHOLD_SCHD_DATE 
					  ,M.STORAGE_ID_MES       =  F.STORAGE_ID_MES       
					  ,M.STORAGE_ID_ERP       =  F.STORAGE_ID_ERP       
					  ,M.STOCK_STATUS         =  F.STOCK_STATUS         
					  ,M.STOCK_TYPE           =  F.STOCK_TYPE           
					  ,M.PROD_TYPE            =  F.PROD_TYPE            
					  ,M.DOMESTIC_TYPE        =  F.DOMESTIC_TYPE        
					  ,M.CREATED_BY           =  F.CREATED_BY           
					  ,M.CREATION_DATE        =  F.CREATION_DATE        
					  ,M.LAST_UPDATED_BY      =  F.LAST_UPDATED_BY      
					  ,M.LAST_UPDATE_DATE     =  F.LAST_UPDATE_DATE     
					  ,M.ATTRIBUTE1           =  F.ATTRIBUTE1           
					  ,M.ATTRIBUTE2           =  F.ATTRIBUTE2           
					  ,M.ATTRIBUTE3           =  F.ATTRIBUTE3           
					  ,M.ATTRIBUTE4           =  F.ATTRIBUTE4           
					  ,M.ATTRIBUTE5           =  F.ATTRIBUTE5           
					  ,M.ATTRIBUTE6           =  F.ATTRIBUTE6           
					  ,M.ATTRIBUTE7           =  F.ATTRIBUTE7           
					  ,M.ATTRIBUTE8           =  F.ATTRIBUTE8           
					  ,M.ATTRIBUTE9           =  F.ATTRIBUTE9           
					  ,M.ATTRIBUTE10          =  F.ATTRIBUTE10     
				WHEN NOT MATCHED THEN 
				INSERT (
					   DIVISION_ID
					  ,COMPANY_ID
					  ,FROM_SITE
					  ,YYYYMMDD
					  ,INSTANCE_TYPE
					  ,PLANT_ID
					  ,LOT_ID
					  ,ITEM_ID
					  ,MODEL_ID
					  ,PRJT_NAME
					  ,NOW_FACTORY
					  ,PROD_FACTORY
					  ,ELECTRODE_VERSION
					  ,LANE
					  ,UOM
					  ,STOCK_QTY
					  ,STOCK_QTY_PC_M
					  ,EXPIRATION_DATE
					  ,COATING_PROD_DATE
					  ,OPERATION_ID
					  ,LINE_ID
					  ,MES_HOLD
					  ,QMS_HOLD
					  ,MES_HOLD_DATE
					  ,QMS_HOLD_DATE
					  ,MES_UNHOLD_SCHD_DATE
					  ,QMS_UNHOLD_SCHD_DATE
					  ,STORAGE_ID_MES
					  ,STORAGE_ID_ERP
					  ,STOCK_STATUS
					  ,STOCK_TYPE
					  ,PROD_TYPE
					  ,DOMESTIC_TYPE
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  ,ATTRIBUTE1
					  ,ATTRIBUTE2
					  ,ATTRIBUTE3
					  ,ATTRIBUTE4
					  ,ATTRIBUTE5
					  ,ATTRIBUTE6
					  ,ATTRIBUTE7
					  ,ATTRIBUTE8
					  ,ATTRIBUTE9
					  ,ATTRIBUTE10
					  ) 
			   VALUES (
					   F.DIVISION_ID
					  ,F.COMPANY_ID
					  ,F.FROM_SITE
					  ,F.YYYYMMDD
					  ,F.INSTANCE_TYPE
					  ,F.PLANT_ID
					  ,F.LOT_ID
					  ,F.ITEM_ID
					  ,F.MODEL_ID
					  ,F.PRJT_NAME
					  ,F.NOW_FACTORY
					  ,F.PROD_FACTORY
					  ,F.ELECTRODE_VERSION
					  ,F.LANE
					  ,F.UOM
					  ,F.STOCK_QTY
					  ,F.STOCK_QTY_PC_M
					  ,F.EXPIRATION_DATE
					  ,F.COATING_PROD_DATE
					  ,F.OPERATION_ID
					  ,F.LINE_ID
					  ,F.MES_HOLD
					  ,F.QMS_HOLD
					  ,F.MES_HOLD_DATE
					  ,F.QMS_HOLD_DATE
					  ,F.MES_UNHOLD_SCHD_DATE
					  ,F.QMS_UNHOLD_SCHD_DATE
					  ,F.STORAGE_ID_MES
					  ,F.STORAGE_ID_ERP
					  ,F.STOCK_STATUS
					  ,F.STOCK_TYPE
					  ,F.PROD_TYPE
					  ,F.DOMESTIC_TYPE
					  ,F.CREATED_BY
					  ,F.CREATION_DATE
					  ,F.LAST_UPDATED_BY
					  ,F.LAST_UPDATE_DATE
					  ,F.ATTRIBUTE1
					  ,F.ATTRIBUTE2
					  ,F.ATTRIBUTE3
					  ,F.ATTRIBUTE4
					  ,F.ATTRIBUTE5
					  ,F.ATTRIBUTE6
					  ,F.ATTRIBUTE7
					  ,F.ATTRIBUTE8
					  ,F.ATTRIBUTE9
					  ,F.ATTRIBUTE10
					  )
					  ;
		
				-- 인터페이스 테이블 처리 완료 UPDATE
				UPDATE X 
				   SET PROC_FLAG            = 'Y'
				     , PROC_DATE            = GETDATE()   
				     , PROC_MSG             = 'S'
				  FROM dbo.XIF_MES_WIP_LOT_R_SN AS X WITH(NOLOCK) 
				       INNER JOIN @XIF_MES_WIP_LOT_R AS Y
				    ON X.IF_SEQ				= Y.IF_SEQ
				;

				IF [dbo].[FN_GET_SSP_IF_GMES_STOCK_CHECK]('EE', @company_id, CONVERT(CHAR(8), getdate(), 112)) = 'Y'
				BEGIN

					UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
					   SET SEGMENT5		    = @v_sum_date
						 , ATTRIBUTE1       = 'Y'
						 , LAST_UPDATED_BY	= @v_batch_user
						 , LAST_UPDATE_DATE = GETDATE()
					 WHERE 1 = 1
					   AND LOOKUP_TYPE		= 'IF_STOCK_CHECK'
					   AND SEGMENT1			= 'PLAN_EE'
					   AND SEGMENT2			= 'MES'
					   AND SEGMENT3			= 'EE'
					   AND SEGMENT4			= @company_id
					;
				END

			END 

			FETCH NEXT FROM CUR_MES_STOCK 
		    INTO @company_id ,@stock_cnt

		END; 

		CLOSE CUR_MES_STOCK; 
		DEALLOCATE CUR_MES_STOCK;

		-- IF data  삭제 (30일 이전 데이터 삭제) 
		DELETE FROM XIF_MES_WIP_LOT_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 30
		;

		-- data  삭제 (3개월  이전 데이터 삭제) 
		DELETE FROM dbo.SSP_DNM_GMES_STOCK_EE
		 WHERE YYYYMMDD < CONVERT(VARCHAR, DATEADD(M, -3, GETDATE()) ,112)
		;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
        BEGIN
			COMMIT TRAN TX_SH;
        END;       


        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      


    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
        BEGIN
			ROLLBACK TRAN TX_SH

			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_MES_STOCK')
			BEGIN
				CLOSE CUR_MES_STOCK ;
				DEALLOCATE CUR_MES_STOCK ;
			END


        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
--      PRINT @@ERROR
		return -1
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@v_program_name+'][' + @v_exec_time + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

END; 
