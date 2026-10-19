/*
 * Program ID   : PR_SSP_XIF_MES_WIP_LOT_8X_R
 * Description  : 소형MES LOT 재고 정보 I/F 수신 반영(Every 10 min)  
 * OutTable     : XIF_MES_WIP_LOT_R --> SSP_DNM_GMES_STOCK_8X
 * Execute      : 
 * Program History
 *===================================================================================================
 * Date         In Charge      Description
 *===================================================================================================
 * 20210901     SSP Pjt.       Create. 
 * 20230829     jilee          MODEL_ID 사용을 위해 ATTRIBUTE5 저장
 * 20241001     KHJ            NERP_SSP
 * 20260804		강주용		   [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_MES_WIP_LOT_8X_R]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_MES_WIP_LOT_8X_R';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SSP_DNM_GMES_STOCK_8X'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SSP_DNM_GMES_STOCK_8X INSERT LOGIC';
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
--	set @v_sum_date = '20210825'

	-- NERP 매핑코드
    DECLARE @v_G182 NVARCHAR(20);
	SET @v_G182 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_XIF_MES_WIP_LOT_8X_R'  ,'G182');


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

	DECLARE @XIF_MES_WIP_BOXLOT_R TABLE ( 
		[IF_SEQ] [nvarchar](50) NOT NULL,
		[IF_TYPE] [nvarchar](1) NOT NULL,
		[IF_ID] [nvarchar](50) NOT NULL,
		[IF_RCV_DATE] [datetime] NOT NULL,
		[PROC_FLAG] [nvarchar](1) NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[MASTER_IF_SEQ] [nvarchar](50) NOT NULL,
		[SUM_DATE] [nvarchar](50) NULL,
		[DB_TYPE] [nvarchar](50) NULL,
		[SUM_ID] [nvarchar](300) NULL,
		[BOXID] [nvarchar](50) NULL,
		[ASSY_LOTID] [nvarchar](50) NULL,
		[LOTQTY] [decimal](18, 5) NULL,
		[SUM_COUNT] [int] NULL,
		[SUM_ITEM_SEQNO] [int] NULL,
		[SUM_ITEM_SUB_SEQNO] [int] NULL,
		[SUM_DTTM] [datetime] NULL,
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
							, COUNT(*)				AS RCV_CNT
						 FROM XIF_MES_WIP_LOT_R_SN AS A  WITH(NOLOCK)
						 	  JOIN SCM_MST_FACTORY_SN AS B WITH(NOLOCK)
			               ON B.PLANT_ID   = A.SHOPID
		                  AND B.FACTORY_ID = A.AREAID	
						WHERE 1 = 1
						  AND A.SUM_DATE				= @v_sum_date
						  AND A.DB_TYPE IN ('CELL', 'FORM', 'PACK')
--						  AND (B.DIVISION_ID != '40' OR (B.DIVISION_ID = '40' AND A.SHOPID = 'G182' AND IF_ID LIKE 'CMS1%'))
						  AND (B.DIVISION_ID != '40' OR (B.DIVISION_ID = '40' AND A.SHOPID = dbo.FN_GET_LOOKUP_DETAIL('NERP_HARD_CODE_PLANT'  ,'G182' ,null,'ASIS') AND IF_ID LIKE 'CMS1%'))
				          AND B.SHOP_GROUP_ID IN ('A', 'P')
						  AND A.COMPANY_CODE NOT IN (SELECT A.SEGMENT4
			                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			                                        WHERE 1 = 1
			                                          AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
			                                          AND A.SEGMENT1		= 'PLAN_AUTO'
			                                          AND A.SEGMENT2		= 'MES_W'
			                                          AND A.SEGMENT3		= '81_82'
			                                          AND A.SEGMENT5		= @v_sum_date
			                                          AND A.ATTRIBUTE1		= 'Y'
			                                       )
						GROUP BY 
						      A.COMPANY_CODE
							 ,A.IF_ID
							 ,A.SUM_COUNT
						UNION ALL
						SELECT B.COMPANY_ID			AS COMPANY_ID
							 , A.IF_ID				AS GROUP_SEQ
							 , 1					AS SND_CNT
							 , 1					AS RCV_CNT
						  FROM XIF_MES_WIP_LOT_R_SN AS A  WITH(NOLOCK)
							   JOIN (SELECT TOKEN + '_OSCM_SCM_WIP_LOT' AS IF_ID
										  , SEGMENT4    AS COMPANY_ID
									   FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
										    CROSS APPLY DBO.STRING_SPLIT(ATTRIBUTE2, ',')
									  WHERE 1 = 1
									    AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
									    AND A.SEGMENT1			= 'PLAN_AUTO'
									    AND A.SEGMENT2			= 'MES_W'
									    AND A.SEGMENT3			= '81_82'
										AND A.SEGMENT5		!= @v_sum_date
									    AND A.ATTRIBUTE1		= 'Y'
								    ) AS B
						   ON A.IF_ID = B.IF_ID
						WHERE 1 = 1
						  AND A.SUM_DATE	= @v_sum_date
						  AND A.PROC_FLAG	= 'N'
						  AND A.DB_TYPE		IN ('CELL', 'FORM', 'PACK')
						  AND A.SUM_COUNT = 0
						  AND A.COMPANY_CODE IS NULL
						GROUP BY B.COMPANY_ID, A.IF_ID
					   ) X
                ) A
		  WHERE 1 = 1
		  GROUP BY 
		        COMPANY_ID
		;
*/
/* INF-R 적용 이후 */
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
							, COUNT(*)				AS RCV_CNT
						 FROM	(	
									SELECT    ISNULL(X1.NEW_VALUE1, A.SHOPID) AS SHOPID
											, ISNULL(X2.NEW_VALUE1, A.COMPANY_CODE) AS COMPANY_CODE
											, A.AREAID, A.IF_ID, A.SUM_COUNT
											, A.SUM_DATE, A.DB_TYPE
									FROM XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK)
									LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
									ON  X1.CODETYPE = 'PLANT_ID'
									AND A.SHOPID = X1.OLD_VALUE1 
									AND X1.ATTRIBUTE5 in ('1ST','2ND')
									LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
									ON  X2.CODETYPE = 'COMPANY_ID'
									AND A.COMPANY_CODE = X2.OLD_VALUE1 
									AND X2.ATTRIBUTE5 in ('1ST','2ND')
								) AS A  
						 	  JOIN SCM_MST_FACTORY_SN AS B WITH(NOLOCK)
			               ON B.PLANT_ID   = A.SHOPID
		                  AND B.FACTORY_ID = A.AREAID	
						WHERE 1 = 1
						  AND A.SUM_DATE				= @v_sum_date
						  AND A.DB_TYPE IN ('CELL', 'FORM', 'PACK')
--						  AND (B.DIVISION_ID != '40' OR (B.DIVISION_ID = '40' AND A.SHOPID = 'G182' AND IF_ID LIKE 'CMS1%'))
						  AND (B.DIVISION_ID != '40' OR (B.DIVISION_ID = '40' AND A.SHOPID = @v_G182 AND IF_ID LIKE 'CMS1%') OR (IF_ID LIKE 'OMS4%'))
				          AND B.SHOP_GROUP_ID IN ('A', 'P')
						  AND A.COMPANY_CODE NOT IN (SELECT A.SEGMENT4
			                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
			                                        WHERE 1 = 1
			                                          AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
			                                          AND A.SEGMENT1		= 'PLAN_AUTO'
			                                          AND A.SEGMENT2		= 'MES_W'
			                                          AND A.SEGMENT3		= '81_82'
			                                          AND A.SEGMENT5		= @v_sum_date
			                                          AND A.ATTRIBUTE1		= 'Y'
			                                       )
						GROUP BY 
						      A.COMPANY_CODE
							 ,A.IF_ID
							 ,A.SUM_COUNT
						UNION ALL
						SELECT B.COMPANY_ID			AS COMPANY_ID
							 , A.IF_ID				AS GROUP_SEQ
							 , 1					AS SND_CNT
							 , 1					AS RCV_CNT
						  FROM	(
									SELECT    A.IF_ID, A.SUM_DATE, A.PROC_FLAG, A.DB_TYPE, A.SUM_COUNT
											, ISNULL(X1.NEW_VALUE1, A.COMPANY_CODE) AS COMPANY_CODE
									FROM XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK)
									LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
									ON  X1.CODETYPE = 'COMPANY_ID'
									AND A.COMPANY_CODE = X1.OLD_VALUE1 
									AND X1.ATTRIBUTE5 in ('1ST','2ND')
								) AS A  
							   JOIN (
									SELECT TOKEN + '_OSCM_SCM_WIP_LOT' AS IF_ID
										  , SEGMENT4    AS COMPANY_ID
									   FROM SCM_ADM_LOOKUP_MASTER_DETAIL  A WITH(NOLOCK)
										    CROSS APPLY DBO.STRING_SPLIT(ATTRIBUTE2, ',')
									  WHERE 1 = 1
									    AND A.LOOKUP_TYPE		= 'IF_STOCK_CHECK'
									    AND A.SEGMENT1			= 'PLAN_AUTO'
									    AND A.SEGMENT2			= 'MES_W'
									    AND A.SEGMENT3			= '81_82'
										AND A.SEGMENT5		!= @v_sum_date
									    AND A.ATTRIBUTE1		= 'Y'
								    ) AS B
						   ON A.IF_ID = B.IF_ID
						WHERE 1 = 1
						  AND A.SUM_DATE	= @v_sum_date
						  AND A.PROC_FLAG	= 'N'
						  AND A.DB_TYPE		IN ('CELL', 'FORM', 'PACK')
						  AND A.SUM_COUNT = 0
						  AND A.COMPANY_CODE IS NULL
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
			   AND A.SEGMENT1		= 'PLAN_AUTO'
			   AND A.SEGMENT2		= 'MES_W'
			   AND A.SEGMENT3		= '81_82'
			   AND A.SEGMENT4		= @company_id
			   AND A.SEGMENT5		= @v_sum_date
			   AND A.ATTRIBUTE1     = 'Y'
			;

			IF @stock_cnt = 0 AND @v_count = 0
			BEGIN

				DELETE FROM @XIF_MES_WIP_LOT_R


/* INF-R 적용 이전
				INSERT INTO @XIF_MES_WIP_LOT_R
				SELECT X.*
				  FROM	dbo.XIF_MES_WIP_LOT_R_SN AS X WITH(NOLOCK) 
                       JOIN SCM_MST_FACTORY_SN AS A WITH(NOLOCK)
			        ON A.PLANT_ID   = X.SHOPID
		           AND A.FACTORY_ID = X.AREAID	
				 WHERE 1 = 1
				   AND X.PROC_FLAG		= 'N' 
				   AND X.COMPANY_CODE	= @company_id
				   AND X.SUM_DATE		= @v_sum_date
				   AND X.DB_TYPE		IN ('CELL', 'FORM', 'PACK')
				   AND X.PRODID			NOT LIKE 'APC%'
				   AND A.DIVISION_ID	!= '40' 
				   AND A.SHOP_GROUP_ID IN ('A', 'P')
				 ORDER BY 
				       X.IF_SEQ
*/

/* INF-R 적용 이후*/ 
				INSERT INTO @XIF_MES_WIP_LOT_R
				SELECT X.*
				  FROM	(	
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
							FROM dbo.XIF_MES_WIP_LOT_R_SN A WITH(NOLOCK) 
							LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
							ON  X1.CODETYPE = 'COMPANY_ID'
							AND A.COMPANY_CODE = X1.OLD_VALUE1 
							AND X1.ATTRIBUTE5 in ('1ST','2ND')
							LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
							ON  X2.CODETYPE = 'STORAGE_ID'
							AND A.SHOPID = X2.OLD_VALUE1
							AND A.SLOC_ID = X2.OLD_VALUE2
							AND X2.ATTRIBUTE5 in ('1ST','2ND')
							LEFT OUTER JOIN  NERP_CONV_MASTER X3 WITH(NOLOCK)
							ON  X3.CODETYPE = 'STORAGE_ID'
							AND A.SHOPID = X3.OLD_VALUE1
							AND A.TO_SLOC_ID = X3.OLD_VALUE2
							AND X3.ATTRIBUTE5 in ('1ST','2ND')
						)AS X 
                       JOIN SCM_MST_FACTORY_SN AS A WITH(NOLOCK)
			        ON A.PLANT_ID   = X.SHOPID
		           AND A.FACTORY_ID = X.AREAID	
				 WHERE 1 = 1
				   AND X.PROC_FLAG		= 'N' 
				   AND X.COMPANY_CODE	= @company_id
				   AND X.SUM_DATE		= @v_sum_date
				   AND X.DB_TYPE		IN ('CELL', 'FORM', 'PACK')
				   AND X.PRODID			NOT LIKE 'APC%'
				   AND A.DIVISION_ID	!= '40' 
				   AND A.SHOP_GROUP_ID IN ('A', 'P')
				 ORDER BY 
				       X.IF_SEQ
				;


				DELETE FROM @XIF_MES_WIP_BOXLOT_R

				INSERT INTO @XIF_MES_WIP_BOXLOT_R
				SELECT Y.*
				  FROM dbo.XIF_MES_WIP_BOXLOT_R_SN AS Y WITH(NOLOCK)
				       INNER JOIN @XIF_MES_WIP_LOT_R AS X
					ON Y.MASTER_IF_SEQ = X.IF_SEQ


				MERGE INTO SSP_DNM_GMES_STOCK_81_82 M
				USING
				(
				    --OPERATION_GROUP        = 'A': 조립
					SELECT 
						   C.DIVISION_ID					AS DIVISION_ID      --   
						  ,C.COMPANY_ID						AS COMPANY_ID       --
						  ,C.SCM_SITE_ID					AS FROM_SITE        --    
						  ,X.SUM_DATE						AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.OQC_JUDG_VALUE) = 'Y' AND MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'Y'
						        ELSE 'N' END				AS AVAILABLE_YN
						  ,MAX(X.SHOPID)					AS PLANT_ID   
						  ,MAX(X.AREAID)					AS AREAID
						  ,MAX(X.EQSGID)					AS EQSGID
						  ,'-'								AS EQSGNAME
						  ,X.BOXID   						AS BOXID            --
						  ,'-'								AS MDLLOT_ID
						  ,X.PRODID							AS ITEM_ID          --
						  -- jilee 20230829
						  ,X.MODLID                         AS MODEL_ID
						  ,'-'								AS PRODNAME
						  ,MAX(X.PRJT_NAME)					AS PRJT_NAME           
						  ,MAX(X.WIPQTY2)					AS TOTAL_QTY    
						  ,MAX(X.BOXSTAT)					AS RCV_ISS_STAT_CODE
						  ,'-'								AS RCV_ISS_STAT_NAME
						  ,MAX(X.SHIPTO_ID)					AS SHIPTO_ID
						  ,MAX(X.SHIPTO_NAME)				AS SHIPTO_NAME
						  ,MAX(X.PACK_NOTE)					AS PACK_NOTE
						  ,MAX(X.OQC_JUDG_VALUE)			AS OQC_INSP_RESULT
						  ,SUBSTRING(Y.ASSY_LOTID,1,8)	    AS LOTID
						  ,SUM(Y.LOTQTY)                    AS LOT_QTY
						  ,MAX(X.PROD_DATE)					AS PROD_DATE
						  ,MIN(X.VLD_DATE)					AS PROD_VALID_DATE
						  ,'-'								AS EXP_INSP_JUDGE_DATE
						  ,'-'								AS EXP_INSP_VALID_DATE
						  ,'-'								AS EXP_INSP_RESULT
						  ,'-'								AS PROD_INSP_RESULT
						  ,'-'								AS MEASR_INSP_RESULT
						  ,'-'								AS LOW_VOLT_INSP_RESULT
						  ,MAX(X.PROD_HOLD_FLAG)			AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)			AS QMS_HOLD_YN  
						  ,'-'								AS SUBLOT_HOLD_YN
						  ,'-'								AS PACK_HOLD_YN
						  ,'-'								AS RTN_RCV_FLAG
						  ,'-'								AS RCV_BOXSTAT_NAME
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE)		AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE)		AS QMS_HOLD_RELEASE
						  ,@v_batch_user					AS CREATED_BY          
						  ,getdate()						AS CREATION_DATE       
						  ,@v_batch_user					AS LAST_UPDATED_BY     
						  ,getdate()						AS LAST_UPDATE_DATE 
						  ,MAX(X.LONG_TERM_STCK_FLAG)       AS ATTRIBUTE8            --장기재고 flag For FP
						  ,MAX(X.PROCID)                    AS ATTRIBUTE1            --OPERATION ID
						  ,MAX(X.BOX_WIP_STAT_CODE)         AS ATTRIBUTE2            --BOX_WIP_STAT_CODE
					  FROM @XIF_MES_WIP_LOT_R AS X 
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
				       AND C.OPERATION_GROUP        = 'A'
					       INNER JOIN @XIF_MES_WIP_BOXLOT_R AS Y
						ON X.IF_SEQ = Y.MASTER_IF_SEQ
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.BOXID
						  ,X.PRODID
						  -- jilee 20230829
						  ,X.MODLID
						  ,SUBSTRING(Y.ASSY_LOTID,1,8)
					-- START [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용 - 가상플렌트 복사
					UNION ALL
					   SELECT 
						   V.DIVISION_ID					AS DIVISION_ID      --   
						  ,C.COMPANY_ID						AS COMPANY_ID       --
						  ,V.SCM_SITE_ID					AS FROM_SITE        --    
						  ,X.SUM_DATE						AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.OQC_JUDG_VALUE) = 'Y' AND MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'Y'
						        ELSE 'N' END				AS AVAILABLE_YN
						  ,MAX(V.PLANT_ID)					AS PLANT_ID   
						  ,MAX(X.AREAID)					AS AREAID
						  ,MAX(X.EQSGID)					AS EQSGID
						  ,'-'								AS EQSGNAME
						  ,X.BOXID   						AS BOXID            --
						  ,'-'								AS MDLLOT_ID
						  ,X.PRODID							AS ITEM_ID          --
						  -- jilee 20230829
						  ,X.MODLID                         AS MODEL_ID
						  ,'-'								AS PRODNAME
						  ,MAX(X.PRJT_NAME)					AS PRJT_NAME           
						  ,MAX(X.WIPQTY2)					AS TOTAL_QTY    
						  ,MAX(X.BOXSTAT)					AS RCV_ISS_STAT_CODE
						  ,'-'								AS RCV_ISS_STAT_NAME
						  ,MAX(X.SHIPTO_ID)					AS SHIPTO_ID
						  ,MAX(X.SHIPTO_NAME)				AS SHIPTO_NAME
						  ,MAX(X.PACK_NOTE)					AS PACK_NOTE
						  ,MAX(X.OQC_JUDG_VALUE)			AS OQC_INSP_RESULT
						  ,SUBSTRING(Y.ASSY_LOTID,1,8)	    AS LOTID
						  ,SUM(Y.LOTQTY)                    AS LOT_QTY
						  ,MAX(X.PROD_DATE)					AS PROD_DATE
						  ,MIN(X.VLD_DATE)					AS PROD_VALID_DATE
						  ,'-'								AS EXP_INSP_JUDGE_DATE
						  ,'-'								AS EXP_INSP_VALID_DATE
						  ,'-'								AS EXP_INSP_RESULT
						  ,'-'								AS PROD_INSP_RESULT
						  ,'-'								AS MEASR_INSP_RESULT
						  ,'-'								AS LOW_VOLT_INSP_RESULT
						  ,MAX(X.PROD_HOLD_FLAG)			AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)			AS QMS_HOLD_YN  
						  ,'-'								AS SUBLOT_HOLD_YN
						  ,'-'								AS PACK_HOLD_YN
						  ,'-'								AS RTN_RCV_FLAG
						  ,'-'								AS RCV_BOXSTAT_NAME
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE)		AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE)		AS QMS_HOLD_RELEASE
						  ,@v_batch_user					AS CREATED_BY          
						  ,getdate()						AS CREATION_DATE       
						  ,@v_batch_user					AS LAST_UPDATED_BY     
						  ,getdate()						AS LAST_UPDATE_DATE 
						  ,MAX(X.LONG_TERM_STCK_FLAG)       AS ATTRIBUTE8            --장기재고 flag For FP
						  ,MAX(X.PROCID)                    AS ATTRIBUTE1            --OPERATION ID
						  ,MAX(X.BOX_WIP_STAT_CODE)         AS ATTRIBUTE2            --BOX_WIP_STAT_CODE
					  FROM @XIF_MES_WIP_LOT_R AS X 
				           INNER JOIN SCM_MST_FACTORY_SN		AS A WITH(NOLOCK)
				        ON A.PLANT_ID		= X.SHOPID
				       AND A.FACTORY_ID		= X.AREAID 
				       --    INNER JOIN SCP_MST_FINAL_ITEM		AS B WITH(NOLOCK)
				       -- ON B.DIVISION_ID	= A.DIVISION_ID
				       --AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
						ON C.PLANT_ID				= A.PLANT_ID 
					   AND C.SITE_TYPE				= 'PLANT'
					   AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID	
				       AND C.OPERATION_GROUP        = 'A'
					       INNER JOIN @XIF_MES_WIP_BOXLOT_R AS Y
						ON X.IF_SEQ = Y.MASTER_IF_SEQ
						INNER JOIN SCM_MST_SITE AS V WITH(NOLOCK)
						ON C.SCM_SITE_ID = V.ATTRIBUTE9
						AND V.SITE_TYPE	= 'PLANT'
						AND V.VALID_YN	= 'Y'
						--INNER JOIN SCP_MST_FINAL_ITEM		AS FI WITH(NOLOCK)
				  --      ON FI.DIVISION_ID	= V.DIVISION_ID
				  --     AND FI.ITEM_ID		= X.PRODID
					   -- END [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
					 GROUP BY
						   V.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,V.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.BOXID
						  ,X.PRODID
						  -- jilee 20230829
						  ,X.MODLID
						  ,SUBSTRING(Y.ASSY_LOTID,1,8)
					-- END [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용 - 가상플렌트 복사

                    --OPERATION_GROUP        = 'P': 팩
					UNION ALL
					SELECT 
						   C.DIVISION_ID					AS DIVISION_ID      --   
						  ,C.COMPANY_ID						AS COMPANY_ID       --
						  ,C.SCM_SITE_ID					AS FROM_SITE        --    
						  ,X.SUM_DATE						AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.OQC_JUDG_VALUE) = 'Y' AND MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'Y'
						        ELSE 'N' END				AS AVAILABLE_YN
						  ,MAX(X.SHOPID)					AS PLANT_ID   
						  ,MAX(X.AREAID)					AS AREAID
						  ,MAX(X.EQSGID)					AS EQSGID
						  ,'-'								AS EQSGNAME
						  ,ISNULL(X.BOXID, X.LOTID)			AS BOXID            --
						  ,'-'								AS MDLLOT_ID
						  ,X.PRODID							AS ITEM_ID          --
						  -- jilee 20230829
						  ,X.MODLID                         AS MODEL_ID
						  ,'-'								AS PRODNAME
						  ,MAX(X.PRJT_NAME)					AS PRJT_NAME           
						  ,MAX(X.WIPQTY2)					AS TOTAL_QTY    
						  ,MAX(X.BOXSTAT)					AS RCV_ISS_STAT_CODE
						  ,'-'								AS RCV_ISS_STAT_NAME
						  ,MAX(X.SHIPTO_ID)					AS SHIPTO_ID
						  ,MAX(X.SHIPTO_NAME)				AS SHIPTO_NAME
						  ,MAX(X.PACK_NOTE)					AS PACK_NOTE
						  ,MAX(X.OQC_JUDG_VALUE)			AS OQC_INSP_RESULT
						  ,X.LOTID							AS LOTID
						  ,MAX(X.WIPQTY2) 		            AS LOT_QTY
						  ,MAX(X.PROD_DATE)					AS PROD_DATE
						  ,MIN(X.VLD_DATE)					AS PROD_VALID_DATE
						  ,'-'								AS EXP_INSP_JUDGE_DATE
						  ,'-'								AS EXP_INSP_VALID_DATE
						  ,'-'								AS EXP_INSP_RESULT
						  ,'-'								AS PROD_INSP_RESULT
						  ,'-'								AS MEASR_INSP_RESULT
						  ,'-'								AS LOW_VOLT_INSP_RESULT
						  ,MAX(X.PROD_HOLD_FLAG)			AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)			AS QMS_HOLD_YN  
						  ,'-'								AS SUBLOT_HOLD_YN
						  ,'-'								AS PACK_HOLD_YN
						  ,'-'								AS RTN_RCV_FLAG
						  ,'-'								AS RCV_BOXSTAT_NAME
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE)		AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE)		AS QMS_HOLD_RELEASE
						  ,@v_batch_user					AS CREATED_BY          
						  ,getdate()						AS CREATION_DATE       
						  ,@v_batch_user					AS LAST_UPDATED_BY     
						  ,getdate()						AS LAST_UPDATE_DATE 
						  ,MAX(X.LONG_TERM_STCK_FLAG)       AS ATTRIBUTE8
						  ,MAX(X.PROCID)                    AS ATTRIBUTE1            --OPERATION ID
						  ,MAX(X.BOX_WIP_STAT_CODE)         AS ATTRIBUTE2            --BOX_WIP_STAT_CODE
					  FROM @XIF_MES_WIP_LOT_R AS X 
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
				       AND C.OPERATION_GROUP        = 'P'
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
					 GROUP BY
					       C.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,C.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.BOXID
						  ,X.PRODID
						  -- jilee 20230829
						  ,X.MODLID
						  ,X.LOTID
					-- START [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용 - 가상플렌트 복사
					UNION ALL
					SELECT 
						   V.DIVISION_ID					AS DIVISION_ID      --   
						  ,C.COMPANY_ID						AS COMPANY_ID       --
						  ,V.SCM_SITE_ID					AS FROM_SITE        --    
						  ,X.SUM_DATE						AS YYYYMMDD         --
						  ,CASE WHEN MAX(X.OQC_JUDG_VALUE) = 'Y' AND MAX(X.PROD_HOLD_FLAG) = 'N' AND MAX(X.QLTY_HOLD_FLAG) = 'N' THEN 'Y'
						        ELSE 'N' END				AS AVAILABLE_YN
						  ,MAX(V.PLANT_ID)					AS PLANT_ID   
						  ,MAX(X.AREAID)					AS AREAID
						  ,MAX(X.EQSGID)					AS EQSGID
						  ,'-'								AS EQSGNAME
						  ,ISNULL(X.BOXID, X.LOTID)			AS BOXID            --
						  ,'-'								AS MDLLOT_ID
						  ,X.PRODID							AS ITEM_ID          --
						  -- jilee 20230829
						  ,X.MODLID                         AS MODEL_ID
						  ,'-'								AS PRODNAME
						  ,MAX(X.PRJT_NAME)					AS PRJT_NAME           
						  ,MAX(X.WIPQTY2)					AS TOTAL_QTY    
						  ,MAX(X.BOXSTAT)					AS RCV_ISS_STAT_CODE
						  ,'-'								AS RCV_ISS_STAT_NAME
						  ,MAX(X.SHIPTO_ID)					AS SHIPTO_ID
						  ,MAX(X.SHIPTO_NAME)				AS SHIPTO_NAME
						  ,MAX(X.PACK_NOTE)					AS PACK_NOTE
						  ,MAX(X.OQC_JUDG_VALUE)			AS OQC_INSP_RESULT
						  ,X.LOTID							AS LOTID
						  ,MAX(X.WIPQTY2) 		            AS LOT_QTY
						  ,MAX(X.PROD_DATE)					AS PROD_DATE
						  ,MIN(X.VLD_DATE)					AS PROD_VALID_DATE
						  ,'-'								AS EXP_INSP_JUDGE_DATE
						  ,'-'								AS EXP_INSP_VALID_DATE
						  ,'-'								AS EXP_INSP_RESULT
						  ,'-'								AS PROD_INSP_RESULT
						  ,'-'								AS MEASR_INSP_RESULT
						  ,'-'								AS LOW_VOLT_INSP_RESULT
						  ,MAX(X.PROD_HOLD_FLAG)			AS MES_HOLD_YN   
						  ,MAX(X.QLTY_HOLD_FLAG)			AS QMS_HOLD_YN  
						  ,'-'								AS SUBLOT_HOLD_YN
						  ,'-'								AS PACK_HOLD_YN
						  ,'-'								AS RTN_RCV_FLAG
						  ,'-'								AS RCV_BOXSTAT_NAME
						  ,MAX(X.PROD_UNHOLD_SCHD_DATE)		AS MES_HOLD_RELEASE
						  ,MAX(X.QLTY_UNHOLD_SCHD_DATE)		AS QMS_HOLD_RELEASE
						  ,@v_batch_user					AS CREATED_BY          
						  ,getdate()						AS CREATION_DATE       
						  ,@v_batch_user					AS LAST_UPDATED_BY     
						  ,getdate()						AS LAST_UPDATE_DATE 
						  ,MAX(X.LONG_TERM_STCK_FLAG)       AS ATTRIBUTE8
						  ,MAX(X.PROCID)                    AS ATTRIBUTE1            --OPERATION ID
						  ,MAX(X.BOX_WIP_STAT_CODE)         AS ATTRIBUTE2            --BOX_WIP_STAT_CODE
					  FROM @XIF_MES_WIP_LOT_R AS X 
				           INNER JOIN SCM_MST_FACTORY_SN		AS A WITH(NOLOCK)
				        ON A.PLANT_ID		= X.SHOPID
				       AND A.FACTORY_ID		= X.AREAID 
				       --    INNER JOIN SCP_MST_FINAL_ITEM		AS B WITH(NOLOCK)
				       -- ON B.DIVISION_ID	= A.DIVISION_ID
				       --AND B.ITEM_ID		= X.PRODID
                           JOIN SCM_MST_SITE					AS C WITH(NOLOCK) 
						ON C.PLANT_ID				= A.PLANT_ID 
					   AND C.SITE_TYPE				= 'PLANT'
					   AND C.OPERATION_GROUP		= A.SHOP_GROUP_ID					       
				       AND C.OPERATION_GROUP        = 'P'
						INNER JOIN SCM_MST_SITE AS V WITH(NOLOCK)
						ON C.SCM_SITE_ID = V.ATTRIBUTE9
						AND V.SITE_TYPE	= 'PLANT'
						AND V.VALID_YN	= 'Y'
						--INNER JOIN SCP_MST_FINAL_ITEM		AS FI WITH(NOLOCK)
				  --      ON FI.DIVISION_ID	= V.DIVISION_ID
				  --     AND FI.ITEM_ID		= X.PRODID
					 WHERE 1 = 1 
					   AND X.SUM_COUNT <> '0'
					 GROUP BY
					       V.DIVISION_ID
						  ,C.COMPANY_ID	
						  ,V.SCM_SITE_ID
						  ,X.SUM_DATE
						  ,X.BOXID
						  ,X.PRODID
						  -- jilee 20230829
						  ,X.MODLID
						  ,X.LOTID
					-- END [E20260811-000711] JV법인 ESS 혼용 생산 시스템 개선 SSP 재고 적용 - 가상플렌트 복사
					       
				) F
					ON F.DIVISION_ID   = M.DIVISION_ID       
				   AND F.COMPANY_ID    = M.COMPANY_ID       
				   AND F.FROM_SITE     = M.FROM_SITE      
				   AND F.YYYYMMDD      = M.YYYYMMDD  
				   AND F.BOXID         = M.BOXID
				   AND F.ITEM_ID       = M.ITEM_ID         
				   AND F.LOTID         = M.LOTID            
				WHEN MATCHED THEN
				UPDATE
				   SET 
					   M.AVAILABLE_YN			=  F.AVAILABLE_YN
					  ,M.PLANT_ID				=  F.PLANT_ID   
					  ,M.AREAID					=  F.AREAID
					  ,M.EQSGID					=  F.EQSGID
					  ,M.EQSGNAME				=  F.EQSGNAME
					  ,M.MDLLOT_ID				=  F.MDLLOT_ID
					  ,M.ITEM_ID				=  F.ITEM_ID          
					  ,M.PRODNAME				=  F.PRODNAME
					  ,M.PRJT_NAME				=  F.PRJT_NAME           
					  ,M.TOTAL_QTY				=  F.TOTAL_QTY    
					  ,M.RCV_ISS_STAT_CODE		=  F.RCV_ISS_STAT_CODE
					  ,M.RCV_ISS_STAT_NAME		=  F.RCV_ISS_STAT_NAME
					  ,M.SHIPTO_ID				=  F.SHIPTO_ID
					  ,M.SHIPTO_NAME			=  F.SHIPTO_NAME
					  ,M.PACK_NOTE				=  F.PACK_NOTE
					  ,M.OQC_INSP_RESULT		=  F.OQC_INSP_RESULT
					  ,M.LOT_QTY				=  F.LOT_QTY
					  ,M.PROD_DATE				=  F.PROD_DATE
					  ,M.PROD_VALID_DATE		=  F.PROD_VALID_DATE
					  ,M.EXP_INSP_JUDGE_DATE	=  F.EXP_INSP_JUDGE_DATE
					  ,M.EXP_INSP_VALID_DATE	=  F.EXP_INSP_VALID_DATE
					  ,M.EXP_INSP_RESULT		=  F.EXP_INSP_RESULT
					  ,M.PROD_INSP_RESULT		=  F.PROD_INSP_RESULT
					  ,M.MEASR_INSP_RESULT		=  F.MEASR_INSP_RESULT
					  ,M.LOW_VOLT_INSP_RESULT	=  F.LOW_VOLT_INSP_RESULT
					  ,M.MES_HOLD_YN			=  F.MES_HOLD_YN   
					  ,M.QMS_HOLD_YN			=  F.QMS_HOLD_YN  
					  ,M.SUBLOT_HOLD_YN			=  F.SUBLOT_HOLD_YN
					  ,M.PACK_HOLD_YN			=  F.PACK_HOLD_YN
					  ,M.RTN_RCV_FLAG			=  F.RTN_RCV_FLAG
					  ,M.RCV_BOXSTAT_NAME		=  F.RCV_BOXSTAT_NAME
					  ,M.MES_HOLD_RELEASE		=  F.MES_HOLD_RELEASE
					  ,M.QMS_HOLD_RELEASE		=  F.QMS_HOLD_RELEASE
					  ,M.LAST_UPDATED_BY        =  F.LAST_UPDATED_BY      
					  ,M.LAST_UPDATE_DATE       =  F.LAST_UPDATE_DATE   
					  ,M.ATTRIBUTE8             =  F.ATTRIBUTE8
					  ,M.ATTRIBUTE1             =  F.ATTRIBUTE1
					  ,M.ATTRIBUTE2             =  F.ATTRIBUTE2
					  -- jilee 20230829
					  ,M.ATTRIBUTE5             =  F.MODEL_ID
				WHEN NOT MATCHED THEN 
				INSERT (
					   DIVISION_ID      
					  ,COMPANY_ID       
					  ,FROM_SITE        
					  ,YYYYMMDD         
					  ,AVAILABLE_YN
					  ,PLANT_ID   
					  ,AREAID
					  ,EQSGID
					  ,EQSGNAME
					  ,BOXID            
					  ,MDLLOT_ID
					  ,ITEM_ID          
					  ,PRODNAME
					  ,PRJT_NAME           
					  ,TOTAL_QTY    
					  ,RCV_ISS_STAT_CODE
					  ,RCV_ISS_STAT_NAME
					  ,SHIPTO_ID
					  ,SHIPTO_NAME
					  ,PACK_NOTE
					  ,OQC_INSP_RESULT
					  ,LOTID            
					  ,LOT_QTY
					  ,PROD_DATE
					  ,PROD_VALID_DATE
					  ,EXP_INSP_JUDGE_DATE
					  ,EXP_INSP_VALID_DATE
					  ,EXP_INSP_RESULT
					  ,PROD_INSP_RESULT
					  ,MEASR_INSP_RESULT
					  ,LOW_VOLT_INSP_RESULT
					  ,MES_HOLD_YN   
					  ,QMS_HOLD_YN  
					  ,SUBLOT_HOLD_YN
					  ,PACK_HOLD_YN
					  ,RTN_RCV_FLAG
					  ,RCV_BOXSTAT_NAME
					  ,MES_HOLD_RELEASE
					  ,QMS_HOLD_RELEASE
					  ,CREATED_BY
					  ,CREATION_DATE
					  ,LAST_UPDATED_BY
					  ,LAST_UPDATE_DATE
					  ,ATTRIBUTE8
					  ,ATTRIBUTE1
					  ,ATTRIBUTE2
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
					  ,F.AREAID
					  ,F.EQSGID
					  ,F.EQSGNAME
					  ,F.BOXID            
					  ,F.MDLLOT_ID
					  ,F.ITEM_ID          
					  ,F.PRODNAME
					  ,F.PRJT_NAME           
					  ,F.TOTAL_QTY    
					  ,F.RCV_ISS_STAT_CODE
					  ,F.RCV_ISS_STAT_NAME
					  ,F.SHIPTO_ID
					  ,F.SHIPTO_NAME
					  ,F.PACK_NOTE
					  ,F.OQC_INSP_RESULT
					  ,F.LOTID            
					  ,F.LOT_QTY
					  ,F.PROD_DATE
					  ,F.PROD_VALID_DATE
					  ,F.EXP_INSP_JUDGE_DATE
					  ,F.EXP_INSP_VALID_DATE
					  ,F.EXP_INSP_RESULT
					  ,F.PROD_INSP_RESULT
					  ,F.MEASR_INSP_RESULT
					  ,F.LOW_VOLT_INSP_RESULT
					  ,F.MES_HOLD_YN   
					  ,F.QMS_HOLD_YN  
					  ,F.SUBLOT_HOLD_YN
					  ,F.PACK_HOLD_YN
					  ,F.RTN_RCV_FLAG
					  ,F.RCV_BOXSTAT_NAME
					  ,F.MES_HOLD_RELEASE
					  ,F.QMS_HOLD_RELEASE
					  ,F.CREATED_BY
					  ,F.CREATION_DATE
					  ,F.LAST_UPDATED_BY
					  ,F.LAST_UPDATE_DATE
					  ,F.ATTRIBUTE8
					  ,F.ATTRIBUTE1
					  ,F.ATTRIBUTE2
					  -- jilee 20230829
					  ,F.MODEL_ID
					  )
					  ;
				------------------------------------------------------------------------

				-- 인터페이스 테이블 처리 완료 UPDATE
				UPDATE X 
				   SET PROC_FLAG            = 'Y'
				     , PROC_DATE            = GETDATE()   
				     , PROC_MSG             = 'S'
				  FROM dbo.XIF_MES_WIP_LOT_R_SN AS X WITH(NOLOCK) 
				       INNER JOIN @XIF_MES_WIP_LOT_R AS Y
				    ON X.IF_SEQ				= Y.IF_SEQ
				;

				UPDATE X 
				   SET PROC_FLAG            = 'Y'
				     , PROC_DATE            = GETDATE()   
				     , PROC_MSG             = 'S'
				  FROM dbo.XIF_MES_WIP_BOXLOT_R_SN AS X WITH(NOLOCK) 
				       INNER JOIN @XIF_MES_WIP_BOXLOT_R AS Y
				    ON X.IF_SEQ				= Y.IF_SEQ

				IF [dbo].[FN_GET_SSP_IF_GMES_STOCK_CHECK]('8X', @company_id, CONVERT(CHAR(8), getdate(), 112)) = 'Y'
				BEGIN

					UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
					   SET SEGMENT5		    = @v_sum_date
						 , ATTRIBUTE1       = 'Y'
						 , LAST_UPDATED_BY	= @v_batch_user
						 , LAST_UPDATE_DATE = getdate()
					 WHERE 1 = 1
					   AND LOOKUP_TYPE		= 'IF_STOCK_CHECK'
					   AND SEGMENT1			= 'PLAN_AUTO'
					   AND SEGMENT2			= 'MES_W'
					   AND SEGMENT3			= '81_82'
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

		DELETE FROM XIF_MES_WIP_BOXLOT_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 30
		;

		-- data  삭제 (3개월  이전 데이터 삭제) 
		DELETE FROM dbo.SSP_DNM_GMES_STOCK_81_82
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
