/*
 * Program ID   : PR_SSP_XIF_MES_WIP_LOT_40_R
 * Description  : 소형MES LOT 재고 정보 I/F 수신 반영(Every 10 min)  
 * OutTable     : XIF_MES_WIP_LOT_R --> SSP_DNM_GMES_STOCK_40
 * Execute      : 
 * Program History
 *===================================================================================================
 * Date         In Charge      Description
 *===================================================================================================
 * 20210901     SSP Pjt.       Create. 
 * 20220816     SSP Pjt.       소형 팩 로직 추가
 * 20230829     jilee          MODEL_ID 사용을 위해 ATTRIBUTE5 저장
 * 20241001     KHJ            NERP_SSP
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_MES_WIP_LOT_40_R]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_MES_WIP_LOT_40_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_GMES_STOCK_40'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_GMES_STOCK_40 INSERT LOGIC';
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
	--set @v_sum_date = '20210904'

	-- NERP 매핑코드
    DECLARE @v_G184 NVARCHAR(20);
	SELECT @v_G184 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_XIF_MES_WIP_LOT_40_R'  ,'G184');


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
					   SELECT A.COMPANY_CODE		AS COMPANY_ID
							, A.IF_ID				AS GROUP_SEQ
							, A.SUM_COUNT			AS SND_CNT
							, COUNT(*)			AS RCV_CNT
						 FROM XIF_MES_WIP_LOT_R_SN AS A  WITH(NOLOCK)
						 	  JOIN SCM_MST_FACTORY_SN AS B WITH(NOLOCK)
			               ON B.PLANT_ID   = A.SHOPID
		                  AND B.FACTORY_ID = A.AREAID
						WHERE 1 = 1
						  AND A.SUM_DATE				= @v_sum_date
						  AND A.DB_TYPE IN ('CELL', 'FORM', 'PACK')
						  --AND B.DIVISION_ID	= CASE WHEN A.SHOPID = 'G184' THEN '82' ELSE '40' END
--						  AND (B.DIVISION_ID	= '40' OR (B.DIVISION_ID = '82' AND A.SHOPID = 'G184' AND IF_ID LIKE 'CMS1%'))
						  AND (B.DIVISION_ID	= '40' OR (B.DIVISION_ID = '82' AND A.SHOPID = dbo.FN_GET_LOOKUP_DETAIL('NERP_HARD_CODE_PLANT'  ,'G184' ,null,'ASIS') AND IF_ID LIKE 'CMS1%'))
				          AND B.SHOP_GROUP_ID IN ('A', 'P')
						  AND A.COMPANY_CODE NOT IN (SELECT A.SEGMENT4
			                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			                                        WHERE 1 = 1
			                                          AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
			                                          AND A.SEGMENT1		= 'PLAN_40'
			                                          AND A.SEGMENT2		IN ('MES_W', 'MES_F')
			                                          AND A.SEGMENT3		= '40'
			                                          AND A.SEGMENT5		= @v_sum_date
			                                          AND A.ATTRIBUTE1		= 'Y'
			                                       )
--						  AND A.COMPANY_CODE IN ('C100', 'G180')
						  AND A.COMPANY_CODE IN (select VALUE from dbo.FN_GET_LOOKUP_DETAIL('NERP_HARD_CODE_COMPANY','ESOC_ESNJ',null,'ASIS'))
						GROUP BY 
						      A.COMPANY_CODE
							 ,A.IF_ID
							 ,A.SUM_COUNT
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
					   SELECT A.COMPANY_CODE		AS COMPANY_ID
							, A.IF_ID				AS GROUP_SEQ
							, A.SUM_COUNT			AS SND_CNT
							, COUNT(*)			AS RCV_CNT
						 FROM	(
									SELECT    ISNULL (X1.NEW_VALUE1, COMPANY_CODE) AS COMPANY_CODE
											, A.IF_ID, A.SUM_COUNT
											, ISNULL (X2.NEW_VALUE1, SHOPID) AS SHOPID
											, A.AREAID, A.SUM_DATE, A.DB_TYPE
									FROM XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK) 
									LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
									ON  X1.CODETYPE = 'COMPANY_ID'
									AND A.COMPANY_CODE = X1.OLD_VALUE1 
									AND X1.ATTRIBUTE5 = '1ST'
									LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
									ON  X2.CODETYPE = 'PLANT_ID'
									AND A.SHOPID = X2.OLD_VALUE1 
									AND X2.ATTRIBUTE5 = '1ST'
								) AS A  
						 	  JOIN SCM_MST_FACTORY_SN AS B WITH(NOLOCK)
			               ON B.PLANT_ID   = A.SHOPID
		                  AND B.FACTORY_ID = A.AREAID
						WHERE 1 = 1
						  AND A.SUM_DATE				= @v_sum_date
						  AND A.DB_TYPE IN ('CELL', 'FORM', 'PACK')
						  --AND B.DIVISION_ID	= CASE WHEN A.SHOPID = 'G184' THEN '82' ELSE '40' END
--						  AND (B.DIVISION_ID	= '40' OR (B.DIVISION_ID = '82' AND A.SHOPID = 'G184' AND IF_ID LIKE 'CMS1%'))
						  AND (B.DIVISION_ID	= '40' OR (B.DIVISION_ID = '82' AND A.SHOPID = @v_G184 AND IF_ID LIKE 'CMS1%'))
				          AND B.SHOP_GROUP_ID IN ('A', 'P')
						  AND A.COMPANY_CODE NOT IN (SELECT A.SEGMENT4
			                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			                                        WHERE 1 = 1
			                                          AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
			                                          AND A.SEGMENT1		= 'PLAN_40'
			                                          AND A.SEGMENT2		IN ('MES_W', 'MES_F')
			                                          AND A.SEGMENT3		= '40'
			                                          AND A.SEGMENT5		= @v_sum_date
			                                          AND A.ATTRIBUTE1		= 'Y'
			                                       )
--						  AND A.COMPANY_CODE IN ('C100', 'G180')
						  AND A.COMPANY_CODE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('PR_SSP_XIF_MES_WIP_LOT_40_R','ESOC_ESNJ'))
						GROUP BY 
						      A.COMPANY_CODE
							 ,A.IF_ID
							 ,A.SUM_COUNT
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
			   AND A.SEGMENT1		= 'PLAN_40'
			   AND A.SEGMENT2		IN ('MES_W', 'MES_F')
			   AND A.SEGMENT3		= '40'
			   AND A.SEGMENT4		= @company_id
			   AND A.SEGMENT5		= @v_sum_date
			   AND A.ATTRIBUTE1     = 'Y'
			;

			IF @stock_cnt = 0 AND @v_count = 0
			BEGIN

			    ------------------------------------------------------------------------
				-- LOOKUP 자동 추가
				------------------------------------------------------------------------

				-- LOOKUP : MES_POUCH_OPERATION
/* INF-R 적용 이전 
				-- LOOKUP : MES_POUCH_OPERATION
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
					   LOOKUP_TYPE
					  ,SEGMENT1     -- CELL_TYPE   
					  ,SEGMENT2     -- OPERATION_ID
					  ,SEGMENT3
					  ,SEGMENT4
					  ,SEGMENT5
					  ,ATTRIBUTE1
					  ,DISPLAY_SEQ
					  ,VALID_YN
					  ,DESCRIPTION
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  )
				SELECT 'MES_POUCH_OPERATION'		AS LOOKUP_TYPE
					  ,ISNULL(D.SEGMENT3, '')		AS CELL_TYPE
					  ,A.PROCID                     AS OPERATION_ID
					  ,E.OPERATION_NAME
					  ,'-'
					  ,'-'
					  ,'-'
					  ,10   AS DISPLAY_SEQ
					  ,'Y'  AS VALID_YN
					  ,'System Auto Create'			AS DESCRIPTION
					  ,@v_batch_user				AS CREATED_BY   
					  ,getdate()					AS CREATION_DATE
					  ,@v_batch_user				AS LAST_UPDATED_BY  
					  ,getdate()					AS LAST_UPDATE_DATE
				  FROM XIF_MES_WIP_LOT_R_SN  A WITH(NOLOCK)
					   JOIN SCM_MST_FACTORY_SN  B WITH(NOLOCK)
					ON B.PLANT_ID		= A.SHOPID
				   AND B.FACTORY_ID		= A.AREAID
					   JOIN SCP_MST_FINAL_ITEM  C WITH(NOLOCK)
					ON C.DIVISION_ID	= B.DIVISION_ID
				   AND C.ITEM_ID		= A.PRODID
					   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON D.SEGMENT3		= 'P'
				   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
				   AND D.VALID_YN		= 'Y' 
				   AND D.SEGMENT1		= C.CELL_TYPE_GROUP_CODE
					   JOIN SCM_MST_OPERATION_SN  E WITH(NOLOCK)
					ON E.OPERATION_ID	= A.PROCID
				 WHERE 1 = 1 
				   AND A.SUM_DATE		= @v_sum_date
				   AND A.COMPANY_CODE	= @company_id
				   AND A.DB_TYPE		IN ('CELL', 'FORM')
				   AND A.SHOPID IS NOT NULL
				   AND B.DIVISION_ID	= '40'
				   AND ISNULL(C.CELL_TYPE_GROUP_CODE, '') = 'P'
				   AND NOT EXISTS (
								  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
									 AND B.LOOKUP_TYPE = 'MES_STOCK_EXCEPT_OPERATION'
									 AND B.VALID_YN    = 'Y' 
									 AND B.SEGMENT1    =  A.PROCID 
								  )
				   AND NOT EXISTS (
								  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
									 AND B.LOOKUP_TYPE = 'MES_POUCH_OPERATION'
									 AND B.SEGMENT1    =  ISNULL(C.CELL_TYPE_GROUP_CODE, '')
									 AND B.SEGMENT2    = A.PROCID 
								  )
				GROUP BY 
					  ISNULL(D.SEGMENT3, '')
					, A.PROCID
					, E.OPERATION_NAME
				;
*/
/* INF-R 적용 이후*/ 
				-- LOOKUP : MES_POUCH_OPERATION
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
					   LOOKUP_TYPE
					  ,SEGMENT1     -- CELL_TYPE   
					  ,SEGMENT2     -- OPERATION_ID
					  ,SEGMENT3
					  ,SEGMENT4
					  ,SEGMENT5
					  ,ATTRIBUTE1
					  ,DISPLAY_SEQ
					  ,VALID_YN
					  ,DESCRIPTION
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  )
				SELECT 'MES_POUCH_OPERATION'		AS LOOKUP_TYPE
					  ,ISNULL(D.SEGMENT3, '')		AS CELL_TYPE
					  ,A.PROCID                     AS OPERATION_ID
					  ,E.OPERATION_NAME
					  ,'-'
					  ,'-'
					  ,'-'
					  ,10   AS DISPLAY_SEQ
					  ,'Y'  AS VALID_YN
					  ,'System Auto Create'			AS DESCRIPTION
					  ,@v_batch_user				AS CREATED_BY   
					  ,getdate()					AS CREATION_DATE
					  ,@v_batch_user				AS LAST_UPDATED_BY  
					  ,getdate()					AS LAST_UPDATE_DATE
				  FROM (
							SELECT    A.PROCID
									, ISNULL(X1.NEW_VALUE1, COMPANY_CODE) AS COMPANY_CODE
									, A.AREAID, A.PRODID, A.SUM_DATE
									, ISNULL(X2.NEW_VALUE1, SHOPID) AS SHOPID
									, A.DB_TYPE
							FROM XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'COMPANY_ID'
							AND A.COMPANY_CODE = X1.OLD_VALUE1 
							AND X1.ATTRIBUTE5 = '1ST'
							LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
							ON  X2.CODETYPE = 'PLANT_ID'
							AND A.SHOPID = X2.OLD_VALUE1 
							AND X2.ATTRIBUTE5 = '1ST'
					   ) A 
					   JOIN SCM_MST_FACTORY_SN  B WITH(NOLOCK)
					ON B.PLANT_ID		= A.SHOPID
				   AND B.FACTORY_ID		= A.AREAID
					   JOIN SCP_MST_FINAL_ITEM  C WITH(NOLOCK)
					ON C.DIVISION_ID	= B.DIVISION_ID
				   AND C.ITEM_ID		= A.PRODID
					   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON D.SEGMENT3		= 'P'
				   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
				   AND D.VALID_YN		= 'Y' 
				   AND D.SEGMENT1		= C.CELL_TYPE_GROUP_CODE
					   JOIN SCM_MST_OPERATION_SN  E WITH(NOLOCK)
					ON E.OPERATION_ID	= A.PROCID
				 WHERE 1 = 1 
				   AND A.SUM_DATE		= @v_sum_date
				   AND A.COMPANY_CODE	= @company_id
				   AND A.DB_TYPE		IN ('CELL', 'FORM')
				   AND A.SHOPID IS NOT NULL
				   AND B.DIVISION_ID	= '40'
				   AND ISNULL(C.CELL_TYPE_GROUP_CODE, '') = 'P'
				   AND NOT EXISTS (
								  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
									 AND B.LOOKUP_TYPE = 'MES_STOCK_EXCEPT_OPERATION'
									 AND B.VALID_YN    = 'Y' 
									 AND B.SEGMENT1    =  A.PROCID 
								  )
				   AND NOT EXISTS (
								  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
									 AND B.LOOKUP_TYPE = 'MES_POUCH_OPERATION'
									 AND B.SEGMENT1    =  ISNULL(C.CELL_TYPE_GROUP_CODE, '')
									 AND B.SEGMENT2    = A.PROCID 
								  )
				GROUP BY 
					  ISNULL(D.SEGMENT3, '')
					, A.PROCID
					, E.OPERATION_NAME
				;

/* INF-R 적용 이전 
				-- LOOKUP : POUCH_WH_IN_DAY
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
					   LOOKUP_TYPE
					  ,SEGMENT1     -- CELL_TYPE   
					  ,SEGMENT2     -- OPERATION_ID
					  ,SEGMENT3
					  ,SEGMENT4
					  ,SEGMENT5
					  ,DISPLAY_SEQ
					  ,VALID_YN
					  ,DESCRIPTION
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  )
				SELECT 'POUCH_WH_IN_DAY'       AS LOOKUP_TYPE
					  ,SUBSTRING(A.PRODID, 1, 3)  AS SEGMENT1 -- POUCH_ITEM_GROUP
					  ,CASE WHEN SUBSTRING(A.PRODID, 1, 3) IN ('MDP','MIP','MTP') THEN '3'
							ELSE '2' END            AS SEGMENT2  -- WH_IN_DAY
					  ,'-'   AS SEGMENT3
					  ,'-'   AS SEGMENT4
					  ,'-'   AS SEGMENT5
					  ,10    AS DISPLAY_SEQ
					  ,'Y'   AS VALID_YN
					  ,'System Auto Create'   AS DESCRIPTION
					  ,'System'
					  ,getdate()        AS CREATION_DATE
					  ,'System'
					  ,getdate()        AS LAST_UPDATE_DATE
				  FROM XIF_MES_WIP_LOT_R_SN  A WITH(NOLOCK)
					   JOIN SCM_MST_FACTORY_SN  B WITH(NOLOCK)
					ON B.PLANT_ID		= A.SHOPID
				   AND B.FACTORY_ID		= A.AREAID
					   JOIN SCP_MST_FINAL_ITEM  C WITH(NOLOCK)
					ON C.DIVISION_ID	= B.DIVISION_ID
				   AND C.ITEM_ID		= A.PRODID
					   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON D.SEGMENT3		= 'P'
				   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
				   AND D.VALID_YN		= 'Y' 
				   AND D.SEGMENT1		= C.CELL_TYPE_GROUP_CODE
					   JOIN SCM_MST_OPERATION_SN  E WITH(NOLOCK)
					ON E.OPERATION_ID	= A.PROCID
				 WHERE 1 = 1 
				   AND A.SUM_DATE		= @v_sum_date
				   AND A.COMPANY_CODE	= @company_id
				   AND A.DB_TYPE		IN ('CELL', 'FORM')
				   AND A.SHOPID IS NOT NULL
				   AND B.DIVISION_ID	= '40'
				   AND NOT EXISTS (
								  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
									 AND B.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
									 AND B.VALID_YN    = 'Y' 
									 AND B.SEGMENT1    =  SUBSTRING(A.PRODID, 1, 3)
								  )
				GROUP BY 
					  SUBSTRING(A.PRODID, 1, 3)
				;
*/


/* INF-R 적용 이후*/ 
				-- LOOKUP : POUCH_WH_IN_DAY
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
					   LOOKUP_TYPE
					  ,SEGMENT1     -- CELL_TYPE   
					  ,SEGMENT2     -- OPERATION_ID
					  ,SEGMENT3
					  ,SEGMENT4
					  ,SEGMENT5
					  ,DISPLAY_SEQ
					  ,VALID_YN
					  ,DESCRIPTION
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  )
				SELECT 'POUCH_WH_IN_DAY'       AS LOOKUP_TYPE
					  ,SUBSTRING(A.PRODID, 1, 3)  AS SEGMENT1 -- POUCH_ITEM_GROUP
					  ,CASE WHEN SUBSTRING(A.PRODID, 1, 3) IN ('MDP','MIP','MTP') THEN '3'
							ELSE '2' END            AS SEGMENT2  -- WH_IN_DAY
					  ,'-'   AS SEGMENT3
					  ,'-'   AS SEGMENT4
					  ,'-'   AS SEGMENT5
					  ,10    AS DISPLAY_SEQ
					  ,'Y'   AS VALID_YN
					  ,'System Auto Create'   AS DESCRIPTION
					  ,'System'
					  ,getdate()        AS CREATION_DATE
					  ,'System'
					  ,getdate()        AS LAST_UPDATE_DATE
				  FROM (
							SELECT    A.PROCID
									, ISNULL(X1.NEW_VALUE1, COMPANY_CODE) AS COMPANY_CODE
									, ISNULL(X2.NEW_VALUE1, SHOPID) AS SHOPID
									, A.AREAID, A.PRODID, A.SUM_DATE
									, A.DB_TYPE
							FROM XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'COMPANY_ID'
							AND A.COMPANY_CODE = X1.OLD_VALUE1 
							AND X1.ATTRIBUTE5 = '1ST'
							LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
							ON  X2.CODETYPE = 'PLANT_ID'
							AND A.SHOPID = X2.OLD_VALUE1 
							AND X2.ATTRIBUTE5 = '1ST'
					   ) A 
					   JOIN SCM_MST_FACTORY_SN  B WITH(NOLOCK)
					ON B.PLANT_ID		= A.SHOPID
				   AND B.FACTORY_ID		= A.AREAID
					   JOIN SCP_MST_FINAL_ITEM  C WITH(NOLOCK)
					ON C.DIVISION_ID	= B.DIVISION_ID
				   AND C.ITEM_ID		= A.PRODID
					   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) 
					ON D.SEGMENT3		= 'P'
				   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
				   AND D.VALID_YN		= 'Y' 
				   AND D.SEGMENT1		= C.CELL_TYPE_GROUP_CODE
					   JOIN SCM_MST_OPERATION_SN  E WITH(NOLOCK)
					ON E.OPERATION_ID	= A.PROCID
				 WHERE 1 = 1 
				   AND A.SUM_DATE		= @v_sum_date
				   AND A.COMPANY_CODE	= @company_id
				   AND A.DB_TYPE		IN ('CELL', 'FORM')
				   AND A.SHOPID IS NOT NULL
				   AND B.DIVISION_ID	= '40'
				   AND NOT EXISTS (
								  SELECT 1
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
									 AND B.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
									 AND B.VALID_YN    = 'Y' 
									 AND B.SEGMENT1    =  SUBSTRING(A.PRODID, 1, 3)
								  )
				GROUP BY 
					  SUBSTRING(A.PRODID, 1, 3)
				;

				------------------------------------------------------------------------

				DELETE FROM @XIF_MES_WIP_LOT_R

/* INF-R 적용 이전
				INSERT INTO @XIF_MES_WIP_LOT_R
				SELECT X.*
				  FROM dbo.XIF_MES_WIP_LOT_R_SN AS X WITH(NOLOCK) 
                       JOIN SCM_MST_FACTORY_SN AS A WITH(NOLOCK)
			        ON A.PLANT_ID   = X.SHOPID
		           AND A.FACTORY_ID = X.AREAID	
				 WHERE 1 = 1
				   AND X.PROC_FLAG		= 'N' 
				   AND X.COMPANY_CODE	= @company_id
				   AND X.SUM_DATE		= @v_sum_date
				   AND X.DB_TYPE		IN ('CELL', 'FORM', 'PACK')
				   AND X.PRODID			NOT LIKE 'APC%'
				   AND A.DIVISION_ID	= '40' 
				   AND A.SHOP_GROUP_ID  IN ('A', 'P')		-- 소형 셀/책
				 ORDER BY 
				       X.IF_SEQ
*/ 

/* INF-R 적용 이후*/ 
				INSERT INTO @XIF_MES_WIP_LOT_R
				SELECT X.*
				  FROM  (
							SELECT   IF_SEQ,IF_TYPE,IF_ID,IF_RCV_DATE,PROC_FLAG
									,PROC_DATE,PROC_MSG,SUM_DATE,DB_TYPE,SUM_ID,PRODID
									,UNIT_CODE,MODLID,PRJT_NAME,WOID,WO_DETL_ID
									,ISNULL(X1.NEW_VALUE1, A.COMPANY_CODE) AS COMPANY_CODE
									,ISNULL(X2.NEW_VALUE1, A.SHOPID) AS SHOPID
									,AREAID,PROCID,EQSGID,EQPTID
									,WIPSTAT,WIP_TYPE_CODE
									,ISNULL(X2.NEW_VALUE2, A.SLOC_ID) AS SLOC_ID
									,EQPT_FLOOR_NO
									,COATING_AREAID,COATING_EQSGID,COATING_EQPTID
									,COATING_SIDE_TYPE_CODE,LOTTYPE
									,LANE_QTY,MKT_TYPE_CODE,MOVE_TYPE_CODE
									,TO_PROCID,TO_EQSGID
									,ISNULL(X3.NEW_VALUE2, A.TO_SLOC_ID) AS TO_SLOC_ID
									,CURR_WIP_QLTY_TYPE_CODE,FCS_RWK_FALG
									,FINL_2ND_OCV_INSP_SEQS,FINL_2ND_OCV_INSP_END_DTTM,PROD_HOLD_FLAG
									,QLTY_HOLD_FLAG,PROC_HOLD_FLAG,TOTL_QLTY_HOLD_FLAG,QLTY_NO_INSP_FLAG,LONG_TERM_STCK_FLAG
									,WIPQTY,WIPQTY_IN,WIPQTY_ST,WIPQTY_ED,WIPQTY2,WIPQTY2_IN,WIPQTY2_ST,WIPQTY2_ED
									,LOTID,BOXID,LOTID_RT,PROD_VER_CODE,PROD_DATE,VLD_DATE,COATING_PROD_DATE
									,PACKDTTM,UNPACKDTTM,BOXSTAT,BOXTYPE
									,SHIPTO_ID,SHIPTO_NAME,PACK_NOTE,WH_ID
									,OQC_JUDG_VALUE,BOX_WIP_STAT_CODE,PROD_HOLD_DATE
									,PROD_HOLD_NOTE,PROD_HOLD_CODE,PROD_HOLD_USERID
									,PROD_UNHOLD_SCHD_DATE,PROD_UNHOLD_DATE,PROD_UNHOLD_NOTE,PROD_UNHOLD_CODE,PROD_UNHOLD_USERID
									,QLTY_HOLD_DATE,QLTY_HOLD_NOTE,QLTY_HOLD_CODE,QLTY_HOLD_USERID
									,QLTY_UNHOLD_SCHD_DATE,QLTY_UNHOLD_DATE,QLTY_UNHOLD_NOTE,QLTY_UNHOLD_CODE,QLTY_UNHOLD_USERID
									,PROC_HOLD_DATE,PROC_HOLD_NOTE,PROC_HOLD_CODE,PROC_HOLD_USERID
									,PROC_UNHOLD_SCHD_DATE,PROC_UNHOLD_DATE,PROC_UNHOLD_NOTE,PROC_UNHOLD_CODE,PROC_UNHOLD_USERID
									,TOTL_QLTY_HOLD_DATE,TOTL_QLTY_HOLD_NOTE,TOTL_QLTY_HOLD_CODE,TOTL_QLTY_HOLD_USERID
									,TOTL_QLTY_UNHOLD_SCHD_DATE,TOTL_QLTY_UNHOLD_DATE,TOTL_QLTY_UNHOLD_NOTE,TOTL_QLTY_UNHOLD_CODE,TOTL_QLTY_UNHOLD_USERID
									,QLTY_NO_INSP_NOTE
									,SUM_COUNT,SUM_ITEM_SEQNO,SUM_DTTM,IF_DETAIL_CNT
									,ATTR_01,ATTR_02,ATTR_03,ATTR_04,ATTR_05
									,ATTR_06,ATTR_07,ATTR_08,ATTR_09,ATTR_10
							FROM XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK)
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'COMPANY_ID'
							AND A.COMPANY_CODE = X1.OLD_VALUE1 
							AND X1.ATTRIBUTE5 = '1ST'
							LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
							ON  X2.CODETYPE = 'STORAGE_ID'
							AND A.SHOPID = X2.OLD_VALUE1 
							AND A.SLOC_ID = X2.OLD_VALUE2 
							AND X2.ATTRIBUTE5 = '1ST'
							LEFT OUTER JOIN  NERP_CONV_MASTER X3 WITH(NOLOCK)
							ON  X3.CODETYPE = 'STORAGE_ID'
							AND A.SHOPID = X3.OLD_VALUE1 
							AND A.TO_SLOC_ID = X3.OLD_VALUE2 
							AND X3.ATTRIBUTE5 = '1ST'
						) AS X 
                       JOIN SCM_MST_FACTORY_SN AS A WITH(NOLOCK)
			        ON A.PLANT_ID   = X.SHOPID
		           AND A.FACTORY_ID = X.AREAID	
				 WHERE 1 = 1
				   AND X.PROC_FLAG		= 'N' 
				   AND X.COMPANY_CODE	= @company_id
				   AND X.SUM_DATE		= @v_sum_date
				   AND X.DB_TYPE		IN ('CELL', 'FORM', 'PACK')
				   AND X.PRODID			NOT LIKE 'APC%'
				   AND A.DIVISION_ID	= '40' 
				   AND A.SHOP_GROUP_ID  IN ('A', 'P')		-- 소형 셀/책
				 ORDER BY 
				       X.IF_SEQ



				MERGE INTO SSP_DNM_GMES_STOCK_40 M
				USING
				(
				    --40 셀:원/각
					SELECT 
						   C.DIVISION_ID				AS DIVISION_ID      --   
						  ,C.COMPANY_ID					AS COMPANY_ID       --
						  ,C.SCM_SITE_ID				AS FROM_SITE        --    
						  ,X.SUM_DATE					AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.PROD_HOLD_FLAG) = 'Y' OR MAX(X.QLTY_HOLD_FLAG) = 'Y' THEN 'N'
						        ELSE 'Y' END AS AVAILABLE_YN
						  ,MAX(X.SHOPID)				AS PLANT_ID       
						  ,X.PRODID						AS ITEM_ID          --
						  -- jilee 20230829
						  ,X.MODLID                     AS MODEL_ID
						  ,MAX(X.PRJT_NAME)				AS NICK_NAME           
						  ,X.LOTID_RT					AS LOT_ID           --
						  ,MAX(ISNULL(F.ATTRIBUTE1, X.LOTTYPE))               
						                                AS LOT_TYPE
						  ,SUM(X.WIPQTY2)			    AS LOT_QTY    
						  ,MAX(X.PROD_HOLD_FLAG)		AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)		AS QMS_HOLD_YN  
						  ,MAX(X.LONG_TERM_STCK_FLAG)   AS LONGTERM_HOLD_YN
						  ,MIN(X.VLD_DATE)				AS JUDG_VLD_DATE     
						  ,MAX(X.PROD_HOLD_DATE)		AS HOLD_DATE       
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE) AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE) AS QMS_HOLD_RELEASE
						  ,SUM(CASE WHEN X.CURR_WIP_QLTY_TYPE_CODE = 'N' THEN CONVERT(DECIMAL, X.WIPQTY) ELSE 0 END) AS DFCT_QTY
						  ,@v_batch_user				AS CREATED_BY          
						  ,getdate()					AS CREATION_DATE       
						  ,@v_batch_user				AS LAST_UPDATED_BY     
						  ,getdate()					AS LAST_UPDATE_DATE
					  FROM @XIF_MES_WIP_LOT_R X 
				           INNER JOIN SCM_MST_FACTORY_SN	AS A WITH(NOLOCK)
				        ON A.PLANT_ID		= X.SHOPID
				       AND A.FACTORY_ID		= X.AREAID 
				           INNER JOIN SCP_MST_FINAL_ITEM	AS B WITH(NOLOCK)
				        ON B.DIVISION_ID	= A.DIVISION_ID
				       AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE				AS C WITH(NOLOCK) 
						ON C.PLANT_ID				= A.PLANT_ID 
					   AND C.SITE_TYPE				= 'PLANT'
					   AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID
					       INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS D WITH(NOLOCK) 
					    ON D.SEGMENT3		<> 'P'
					   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
					   AND D.VALID_YN		= 'Y' 
					   AND D.SEGMENT1		= B.CELL_TYPE_GROUP_CODE  --C:Cylindrical, R:Prismatic
					       LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS F WITH(NOLOCK) 
					    ON F.LOOKUP_TYPE	= 'MES_LOTTYPE' 
					   AND F.VALID_YN		= 'Y' 
					   AND F.SEGMENT1		= X.LOTTYPE	
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
					   AND X.PROCID NOT IN (SELECT SEGMENT1 
					                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
				                             WHERE LOOKUP_TYPE = 'MES_STOCK_EXCEPT_OPERATION' 
				                               AND VALID_YN    = 'Y'
										   )
                       AND A.SHOP_GROUP_ID  = 'A'
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.PRODID
						  -- jilee 20230829
						  ,X.MODLID
						  ,X.LOTID_RT

				    --40 셀:파우치
					UNION ALL
					SELECT 
						   C.DIVISION_ID				AS DIVISION_ID      --   
						  ,C.COMPANY_ID					AS COMPANY_ID       --
						  ,C.SCM_SITE_ID				AS FROM_SITE        --    
						  ,X.SUM_DATE					AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'Y'
						        ELSE 'N' END AS AVAILABLE_YN
						  ,MAX(X.SHOPID)				AS PLANT_ID       
						  ,X.PRODID						AS ITEM_ID          --
						  -- jilee 20230829
						  ,X.MODLID                     AS MODEL_ID
						  ,MAX(X.PRJT_NAME)				AS NICK_NAME           
						  ,X.LOTID_RT		            AS LOT_ID
						  ,MAX(ISNULL(F.ATTRIBUTE1, X.LOTTYPE))               
						                                AS LOT_TYPE
						  ,SUM(X.WIPQTY2)	            AS LOT_QTY						  
						  ,MAX(X.PROD_HOLD_FLAG)		AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)		AS QMS_HOLD_YN  
						  ,MAX(X.LONG_TERM_STCK_FLAG)   AS LONGTERM_HOLD_YN
						  ,MIN(X.VLD_DATE)				AS JUDG_VLD_DATE     
						  ,MAX(X.PROD_HOLD_DATE)		AS HOLD_DATE       
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE) AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE) AS QMS_HOLD_RELEASE
						  ,SUM(CASE WHEN X.CURR_WIP_QLTY_TYPE_CODE = 'N' THEN CONVERT(DECIMAL, X.WIPQTY) ELSE 0 END) AS DFCT_QTY
						  ,@v_batch_user				AS CREATED_BY          
						  ,getdate()					AS CREATION_DATE       
						  ,@v_batch_user				AS LAST_UPDATED_BY     
						  ,getdate()					AS LAST_UPDATE_DATE
					  FROM @XIF_MES_WIP_LOT_R X 
				           INNER JOIN SCM_MST_FACTORY_SN		AS A WITH(NOLOCK)
				        ON A.PLANT_ID		= X.SHOPID
				       AND A.FACTORY_ID		= X.AREAID 
				           INNER JOIN SCP_MST_FINAL_ITEM		AS B WITH(NOLOCK)
				        ON B.DIVISION_ID	= A.DIVISION_ID
				       AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
						ON C.PLANT_ID				= A.PLANT_ID 
					   AND C.SITE_TYPE				= 'PLANT'
					   AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID
					       INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS D WITH(NOLOCK) 
					    ON D.SEGMENT3		= 'P'
					   AND D.LOOKUP_TYPE	= 'CELL_TYPE_CODE' 
					   AND D.VALID_YN		= 'Y' 
					   AND D.SEGMENT1		= B.CELL_TYPE_GROUP_CODE   --P:Pouch
					       LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS F WITH(NOLOCK) 
					    ON F.LOOKUP_TYPE	= 'MES_LOTTYPE' 
					   AND F.VALID_YN		= 'Y' 
					   AND F.SEGMENT1		= X.LOTTYPE	
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
					   AND X.PROCID NOT IN (SELECT SEGMENT1 
					                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)  
				                             WHERE LOOKUP_TYPE = 'MES_STOCK_EXCEPT_OPERATION' 
				                               AND VALID_YN    = 'Y'
										   )
                       AND EXISTS (
								  SELECT 1
								    FROM SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK)
								   WHERE 1 = 1
								     AND B.LOOKUP_TYPE = 'MES_POUCH_OPERATION'
								     AND B.VALID_YN    = 'Y' 
								     AND B.SEGMENT1    =  ISNULL(D.SEGMENT3, '')
								     AND B.SEGMENT2    = X.PROCID 
							      )
                       AND A.SHOP_GROUP_ID  = 'A'
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.PRODID
						  -- jilee 20230829
						  ,X.MODLID
						  ,X.LOTID_RT

				    --40 팩
					UNION ALL
					SELECT 
						   C.DIVISION_ID				AS DIVISION_ID      --   
						  ,C.COMPANY_ID					AS COMPANY_ID       --
						  ,C.SCM_SITE_ID				AS FROM_SITE        --    
						  ,X.SUM_DATE					AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'Y'
						        ELSE 'N' END AS AVAILABLE_YN
						  ,MAX(X.SHOPID)				AS PLANT_ID       
						  ,X.PRODID						AS ITEM_ID          --
						  -- jilee 20230829
						  ,X.MODLID                     AS MODEL_ID
						  ,MAX(X.PRJT_NAME)				AS NICK_NAME           
						  ,X.LOTID_RT		            AS LOT_ID
						  ,MAX(ISNULL(F.ATTRIBUTE1, X.LOTTYPE))               
						                                AS LOT_TYPE
						  ,SUM(X.WIPQTY2)	            AS LOT_QTY						  
						  ,MAX(X.PROD_HOLD_FLAG)		AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)		AS QMS_HOLD_YN  
						  ,MAX(X.LONG_TERM_STCK_FLAG)   AS LONGTERM_HOLD_YN
						  ,MIN(X.VLD_DATE)				AS JUDG_VLD_DATE     
						  ,MAX(X.PROD_HOLD_DATE)		AS HOLD_DATE       
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE) AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE) AS QMS_HOLD_RELEASE
						  ,SUM(CASE WHEN X.CURR_WIP_QLTY_TYPE_CODE = 'N' THEN CONVERT(DECIMAL, X.WIPQTY) ELSE 0 END) AS DFCT_QTY
						  ,@v_batch_user				AS CREATED_BY          
						  ,getdate()					AS CREATION_DATE       
						  ,@v_batch_user				AS LAST_UPDATED_BY     
						  ,getdate()					AS LAST_UPDATE_DATE
					  FROM @XIF_MES_WIP_LOT_R X 
				           INNER JOIN SCM_MST_FACTORY_SN		AS A WITH(NOLOCK)
				        ON A.PLANT_ID		= X.SHOPID
				       AND A.FACTORY_ID		= X.AREAID 
				           INNER JOIN SCP_MST_FINAL_ITEM		AS B WITH(NOLOCK)
				        ON B.DIVISION_ID	= A.DIVISION_ID
				       AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
						ON C.PLANT_ID				= A.PLANT_ID 
					   AND C.SITE_TYPE				= 'PLANT'
					   AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID
					       LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS F WITH(NOLOCK) 
					    ON F.LOOKUP_TYPE	= 'MES_LOTTYPE' 
					   AND F.VALID_YN		= 'Y' 
					   AND F.SEGMENT1		= X.LOTTYPE	
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
                       AND A.SHOP_GROUP_ID  = 'P'
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.PRODID
						  -- jilee 20230829
						  ,X.MODLID
						  ,X.LOTID_RT
						  
				) F
					ON F.DIVISION_ID   = M.DIVISION_ID       
				   AND F.COMPANY_ID    = M.COMPANY_ID       
				   AND F.FROM_SITE     = M.FROM_SITE      
				   AND F.YYYYMMDD      = M.YYYYMMDD         
				   AND F.ITEM_ID       = M.ITEM_ID         
				   AND F.LOT_ID        = M.LOT_ID            
				WHEN MATCHED THEN
				UPDATE
				   SET M.AVAILABLE_YN		  =  F.AVAILABLE_YN	 
					  ,M.PLANT_ID			  =  F.PLANT_ID       	 
					  ,M.NICK_NAME			  =  F.NICK_NAME       	 
					  ,M.LOT_TYPE			  =  F.LOT_TYPE	 
					  ,M.LOT_QTY			  =  F.LOT_QTY    	 
					  ,M.MES_HOLD_YN		  =  F.MES_HOLD_YN   	 
					  ,M.QMS_HOLD_YN		  =  F.QMS_HOLD_YN  	 
					  ,M.LONGTERM_HOLD_YN	  =  F.LONGTERM_HOLD_YN	 
					  ,M.JUDG_VLD_DATE		  =  F.JUDG_VLD_DATE   	 
					  ,M.HOLD_DATE			  =  F.HOLD_DATE       	 
					  ,M.MES_HOLD_RELEASE	  =  F.MES_HOLD_RELEASE	 
					  ,M.QMS_HOLD_RELEASE	  =  F.QMS_HOLD_RELEASE	 
					  ,M.LAST_UPDATED_BY      =  F.LAST_UPDATED_BY      
					  ,M.LAST_UPDATE_DATE     =  F.LAST_UPDATE_DATE     
					  ,M.ATTRIBUTE4           =  F.DFCT_QTY
					  -- jilee 20230829
					  ,M.ATTRIBUTE5           =  F.MODEL_ID
				WHEN NOT MATCHED THEN 
				INSERT (
					   DIVISION_ID      
					  ,COMPANY_ID  
					  ,FROM_SITE        
					  ,YYYYMMDD
					  ,AVAILABLE_YN
					  ,PLANT_ID       
					  ,ITEM_ID          
					  ,NICK_NAME        
					  ,LOT_ID
					  ,LOT_TYPE
					  ,LOT_QTY    
					  ,MES_HOLD_YN   
					  ,QMS_HOLD_YN  
					  ,LONGTERM_HOLD_YN
					  ,JUDG_VLD_DATE    
					  ,HOLD_DATE       
					  ,MES_HOLD_RELEASE
					  ,QMS_HOLD_RELEASE
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  ,ATTRIBUTE1
					  ,ATTRIBUTE4
					  -- jilee 20230829
					  ,ATTRIBUTE5
					  ) 
			   VALUES (
					   F.DIVISION_ID      
					  ,F.COMPANY_ID  
					  ,F.FROM_SITE        
					  ,F.YYYYMMDD
					  ,F.AVAILABLE_YN
					  ,F.PLANT_ID       
					  ,F.ITEM_ID          
					  ,F.NICK_NAME        
					  ,F.LOT_ID
					  ,F.LOT_TYPE
					  ,F.LOT_QTY    
					  ,F.MES_HOLD_YN   
					  ,F.QMS_HOLD_YN  
					  ,F.LONGTERM_HOLD_YN
					  ,F.JUDG_VLD_DATE    
					  ,F.HOLD_DATE       
					  ,F.MES_HOLD_RELEASE
					  ,F.QMS_HOLD_RELEASE
					  ,F.CREATED_BY
					  ,F.CREATION_DATE
					  ,F.LAST_UPDATED_BY
					  ,F.LAST_UPDATE_DATE
					  ,'Cylindrical'
					  ,F.DFCT_QTY
					  -- jilee 20230829
					  ,F.MODEL_ID
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

				UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
				   SET SEGMENT5		    = @v_sum_date
				     , ATTRIBUTE1       = 'Y'
					 , LAST_UPDATED_BY	= @v_batch_user
					 , LAST_UPDATE_DATE = getdate()
				 WHERE 1 = 1
				   AND LOOKUP_TYPE		= 'IF_STOCK_CHECK'
				   AND SEGMENT1			= 'PLAN_40'
				   AND SEGMENT2			IN ('MES_W', 'MES_F')
				   AND SEGMENT3			= '40'
				   AND SEGMENT4			= @company_id
				;

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
		DELETE FROM [dbo].[SSP_DNM_GMES_STOCK_40]
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
