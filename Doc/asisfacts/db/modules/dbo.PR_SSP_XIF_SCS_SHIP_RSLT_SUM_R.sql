

/*
 * Program ID   : PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R
 * Description  : Packer 출하실적 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.07.31   KSG            Initial Release [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선]
 * 2021.07.01   SSP Pjt.       Grouping by division_id, scm_site_id, to_site, item_id, ship_date 
 * 2021.11.26   SMS            외주 Packer(SCS) I/F 항목 추가 
 * 2022.03.18   SMS            Group by confirm_id(ATTR_05) 추가 
 * 2024.10.01   KHJ            NERP_SSP
 */

CREATE PROCEDURE [dbo].[PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user		NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name		NVARCHAR(150) = 'PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
	DECLARE @v_if_seq			NVARCHAR(30); 
	DECLARE @n_history_seq		BIGINT;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	DECLARE @TAB_XIF_SCS_SHIP_RSLT_SUM_R TABLE
	(
		[IF_SEQ] [nvarchar](50) NOT NULL,
		[IF_TYPE] [nvarchar](1) NOT NULL,
		[IF_ID] [nvarchar](50) NOT NULL,
		[IF_RCV_DATE] [datetime] NULL,
		[PROC_FLAG] [nvarchar](1) NOT NULL,
		[PROC_DATE] [datetime] NULL,
		[PROC_MSG] [nvarchar](1000) NULL,
		[PACKER_CODE] [nvarchar](30) NULL,
		[DIVISION_ID] [nvarchar](10) NULL,
		[SHIP_DATE] [nvarchar](8) NULL,
		[TO_SITE] [nvarchar](50) NULL,
		[PACK_MODEL_CODE] [nvarchar](50) NULL,
		[SHIP_QTY] [numeric](20, 10) NULL,
		[ATTR_01] [nvarchar](200) NULL,
		[ATTR_02] [nvarchar](200) NULL,
		[ATTR_03] [nvarchar](200) NULL,
		[ATTR_04] [nvarchar](200) NULL,
		[ATTR_05] [nvarchar](200) NULL,
		[ATTR_06] [nvarchar](200) NULL,
		[ATTR_07] [nvarchar](200) NULL,
		[ATTR_08] [nvarchar](200) NULL,
		[ATTR_09] [nvarchar](200) NULL,
		[ATTR_10] [nvarchar](200) NULL
	) 


    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY

/*INF-R 적용 이전			
		INSERT INTO @TAB_XIF_SCS_SHIP_RSLT_SUM_R
				   ([IF_SEQ]
				   ,[IF_TYPE]
				   ,[IF_ID]
				   ,[IF_RCV_DATE]
				   ,[PROC_FLAG]
				   ,[PROC_DATE]
				   ,[PROC_MSG]
				   ,[PACKER_CODE]
				   ,[DIVISION_ID]
				   ,[SHIP_DATE]
				   ,[TO_SITE]
				   ,[PACK_MODEL_CODE]
				   ,[SHIP_QTY]
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
				   )
			 SELECT 
			        R.[IF_SEQ]
			       ,R.[IF_TYPE]
			       ,R.[IF_ID]
			       ,R.[IF_RCV_DATE]
			       ,R.[PROC_FLAG]
			       ,R.[PROC_DATE]
			       ,R.[PROC_MSG]
			       ,R.[PACKER_CODE]
			       ,R.[DIVISION_ID]
			       ,R.[SHIP_DATE]
			       ,R.[TO_SITE]
			       ,R.[PACK_MODEL_CODE]
			       ,R.[SHIP_QTY]
			       ,R.[ATTR_01]
			       ,R.[ATTR_02]
			       ,R.[ATTR_03]
			       ,R.[ATTR_04]
			       ,R.[ATTR_05]
			       ,R.[ATTR_06]
			       ,R.[ATTR_07]
			       ,R.[ATTR_08]
			       ,R.[ATTR_09]
			       ,R.[ATTR_10]
               FROM (
			        SELECT S.[IF_SEQ]
				          ,S.[IF_TYPE]
				          ,S.[IF_ID]
				          ,S.[IF_RCV_DATE]
				          ,S.[PROC_FLAG]
				          ,S.[PROC_DATE]
				          ,S.[PROC_MSG]
				          ,S.[PACKER_CODE]
				          ,S.[DIVISION_ID]
				          ,S.[SHIP_DATE]
				          ,S.[TO_SITE]
				          ,S.[PACK_MODEL_CODE]
				          ,S.[SHIP_QTY]
				          ,S.[ATTR_01]
				          ,S.[ATTR_02]
				          ,S.[ATTR_03]
				          ,S.[ATTR_04]
				          ,S.[ATTR_05]
				          ,S.[ATTR_06]
				          ,S.[ATTR_07]
				          ,S.[ATTR_08]
				          ,S.[ATTR_09]
				          ,S.[ATTR_10]
				          ,RANK() OVER(PARTITION BY S.PACKER_CODE, S.DIVISION_ID, S.SHIP_DATE, S.TO_SITE, S.PACK_MODEL_CODE, S.ATTR_05, S.ATTR_01 ORDER BY S.IF_SEQ DESC) AS RANK
			          FROM [dbo].[XIF_SCS_SHIP_RSLT_SUM_R_SN] AS S WITH(NOLOCK)
			               JOIN ( SELECT PACKER_CODE, DIVISION_ID, SHIP_DATE, TO_SITE, PACK_MODEL_CODE, ATTR_05
				                    FROM [dbo].[XIF_SCS_SHIP_RSLT_SUM_R_SN] WITH(NOLOCK)
						           WHERE 1 = 1
			                         AND ISNULL(PROC_FLAG,	'N') = 'N'
			                         AND IF_RCV_DATE <= dateadd(minute, -5, getdate())  --interface 잘리는 현상 방지
						           GROUP BY 
						                 PACKER_CODE, DIVISION_ID, SHIP_DATE, TO_SITE, PACK_MODEL_CODE, ATTR_05
						        ) AS T
				        ON T.PACKER_CODE		= S.PACKER_CODE
			           AND T.DIVISION_ID		= S.DIVISION_ID
			           AND T.SHIP_DATE			= S.SHIP_DATE
			           AND T.TO_SITE			= S.TO_SITE
			           AND T.PACK_MODEL_CODE	= S.PACK_MODEL_CODE
			           AND T.ATTR_05			= S.ATTR_05
			         WHERE 1 = 1
                    ) AS R
              WHERE R.RANK = 1
			  ORDER BY 
			        IF_SEQ
				;
*/
/*INF-R 적용 이후*/ 			
		WITH TEMP_XIF_SCS_SHIP_RSLT_SUM_R AS (
			SELECT IF_SEQ,IF_TYPE,IF_ID,IF_RCV_DATE,PROC_FLAG,PROC_DATE,PROC_MSG
					,ISNULL (X1.NEW_VALUE1, PACKER_CODE) AS PACKER_CODE
					,DIVISION_ID,SHIP_DATE
					,ISNULL (X2.NEW_VALUE1, TO_SITE) AS TO_SITE
					,PACK_MODEL_CODE,SHIP_QTY
					,ATTR_01,ATTR_02,ATTR_03,ATTR_04,ATTR_05
					,ATTR_06,ATTR_07,ATTR_08,ATTR_09,ATTR_10
			FROM [dbo].[XIF_SCS_SHIP_RSLT_SUM_R_SN] A WITH(NOLOCK)
			LEFT OUTER JOIN  NERP_CONV_MASTER X1 WITH(NOLOCK)
			ON  X1.CODETYPE = 'SCP_SITE_ID'
			AND A.PACKER_CODE = X1.OLD_VALUE1
			AND X1.ATTRIBUTE5 = '1ST'
			LEFT OUTER JOIN  NERP_CONV_MASTER X2 WITH(NOLOCK)
			ON  X2.CODETYPE = 'END_CUSTOMER_ID'
			AND A.TO_SITE = X2.OLD_VALUE1
			AND X2.ATTRIBUTE5 = '1ST'
		) 
		INSERT INTO @TAB_XIF_SCS_SHIP_RSLT_SUM_R
				   ([IF_SEQ]
				   ,[IF_TYPE]
				   ,[IF_ID]
				   ,[IF_RCV_DATE]
				   ,[PROC_FLAG]
				   ,[PROC_DATE]
				   ,[PROC_MSG]
				   ,[PACKER_CODE]
				   ,[DIVISION_ID]
				   ,[SHIP_DATE]
				   ,[TO_SITE]
				   ,[PACK_MODEL_CODE]
				   ,[SHIP_QTY]
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
				   )
 
			 SELECT 
			        R.[IF_SEQ]
			       ,R.[IF_TYPE]
			       ,R.[IF_ID]
			       ,R.[IF_RCV_DATE]
			       ,R.[PROC_FLAG]
			       ,R.[PROC_DATE]
			       ,R.[PROC_MSG]
			       ,R.[PACKER_CODE]
			       ,R.[DIVISION_ID]
			       ,R.[SHIP_DATE]
			       ,R.[TO_SITE]
			       ,R.[PACK_MODEL_CODE]
			       ,R.[SHIP_QTY]
			       ,R.[ATTR_01]
			       ,R.[ATTR_02]
			       ,R.[ATTR_03]
			       ,R.[ATTR_04]
			       ,R.[ATTR_05]
			       ,R.[ATTR_06]
			       ,R.[ATTR_07]
			       ,R.[ATTR_08]
			       ,R.[ATTR_09]
			       ,R.[ATTR_10]
               FROM (
			        SELECT S.[IF_SEQ]
				          ,S.[IF_TYPE]
				          ,S.[IF_ID]
				          ,S.[IF_RCV_DATE]
				          ,S.[PROC_FLAG]
				          ,S.[PROC_DATE]
				          ,S.[PROC_MSG]
				          ,S.[PACKER_CODE]
				          ,S.[DIVISION_ID]
				          ,S.[SHIP_DATE]
				          ,S.[TO_SITE]
				          ,S.[PACK_MODEL_CODE]
				          ,S.[SHIP_QTY]
				          ,S.[ATTR_01]
				          ,S.[ATTR_02]
				          ,S.[ATTR_03]
				          ,S.[ATTR_04]
				          ,S.[ATTR_05]
				          ,S.[ATTR_06]
				          ,S.[ATTR_07]
				          ,S.[ATTR_08]
				          ,S.[ATTR_09]
				          ,S.[ATTR_10]
				          ,RANK() OVER(PARTITION BY S.PACKER_CODE, S.DIVISION_ID, S.SHIP_DATE, S.TO_SITE, S.PACK_MODEL_CODE, S.ATTR_05, S.ATTR_01 ORDER BY S.IF_SEQ DESC) AS RANK
			          FROM TEMP_XIF_SCS_SHIP_RSLT_SUM_R AS S WITH(NOLOCK)
			               JOIN ( SELECT PACKER_CODE, DIVISION_ID, SHIP_DATE, TO_SITE, PACK_MODEL_CODE, ATTR_05
				                    FROM TEMP_XIF_SCS_SHIP_RSLT_SUM_R WITH(NOLOCK)
						           WHERE 1 = 1
			                         AND ISNULL(PROC_FLAG,	'N') = 'N'
			                         AND IF_RCV_DATE <= dateadd(minute, -5, getdate())  --interface 잘리는 현상 방지
						           GROUP BY 
						                 PACKER_CODE, DIVISION_ID, SHIP_DATE, TO_SITE, PACK_MODEL_CODE, ATTR_05
						        ) AS T
				        ON T.PACKER_CODE		= S.PACKER_CODE
			           AND T.DIVISION_ID		= S.DIVISION_ID
			           AND T.SHIP_DATE			= S.SHIP_DATE
			           AND T.TO_SITE			= S.TO_SITE
			           AND T.PACK_MODEL_CODE	= S.PACK_MODEL_CODE
			           AND T.ATTR_05			= S.ATTR_05
			         WHERE 1 = 1
                    ) AS R
              WHERE R.RANK = 1
			  ORDER BY 
			        IF_SEQ
				;
					
            MERGE INTO SCM_DNM_SCS_SHIP_RESULT AS A
			USING (
                  SELECT /* PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R */ 
                         V.DIVISION_ID
                       , V.CUTOFF_DATE
                       , V.SCM_SITE_ID
                       , dbo.FN_GET_PACKER_PLAN_ITEM_ID(V.DIVISION_ID, V.PACK_MODEL_CODE) AS ITEM_ID
                       , V.PACKER_CODE
                       , V.SHIP_DATE
                       , V.TO_SITE
                       , V.PACK_MODEL_CODE
                       , V.SHIP_QTY  
					   , V.CNFM_ID
					   , V.SHIP_TO
					   , V.TRANS_MODE
					   , V.INCOTERMS
                    FROM (
                         SELECT 
                                DIVISION_ID           
                              , CONVERT(CHAR(8), GETDATE()-1, 112)  AS CUTOFF_DATE -- 실제로는 의미 없음
                              , PACKER_CODE							AS SCM_SITE_ID
                              , PACKER_CODE             
                              , SHIP_DATE        
                              , TO_SITE            
                              , PACK_MODEL_CODE
                              , SUM(ISNULL(SHIP_QTY, '0'))          AS SHIP_QTY
							  , ATTR_05								AS CNFM_ID
							  , MAX(ATTR_04)                        AS SHIP_TO		-- 기존 I/F 되던 항목이었음. 빠져서 추가
							  , MAX(ATTR_08)                        AS TRANS_MODE	
							  , MAX(ATTR_09)                        AS INCOTERMS	
                           FROM @TAB_XIF_SCS_SHIP_RSLT_SUM_R 
                          WHERE 1 = 1
							AND ISNULL(PACKER_CODE     , '') != ''
							AND ISNULL(DIVISION_ID	   , '') != ''
							AND ISNULL(SHIP_DATE	   , '') != ''
							AND ISNULL(TO_SITE		   , '') != ''
							AND ISNULL(PACK_MODEL_CODE , '') != ''
						  GROUP BY 
						        PACKER_CODE
							  , DIVISION_ID
							  , SHIP_DATE
							  , TO_SITE
							  , PACK_MODEL_CODE 
							  , ATTR_05
                         ) V              
		          ) B
			   ON A.DIVISION_ID			= B.DIVISION_ID
			  AND A.SCM_SITE_ID			= B.SCM_SITE_ID
			  AND A.PACK_MODEL_CODE		= B.PACK_MODEL_CODE -- ORIGIN ITEM ID
			  AND A.SHIP_DATE			= B.SHIP_DATE
			  AND A.TO_SITE				= B.TO_SITE
			  AND A.ATTRIBUTE5          = B.CNFM_ID
			WHEN MATCHED THEN
				 UPDATE 
				    SET A.CUTOFF_DATE	    =  B.CUTOFF_DATE
					   ,A.SHIP_QTY			=  B.SHIP_QTY
					   ,A.ITEM_ID			=  B.ITEM_ID
					   ,A.LAST_UPDATED_BY	=  @v_batch_user
					   ,A.LAST_UPDATE_DATE	=  getdate()
					   ,A.ATTRIBUTE4        =  B.SHIP_TO
					   ,A.ATTRIBUTE8        =  B.TRANS_MODE
					   ,A.ATTRIBUTE9        =  B.INCOTERMS
			WHEN NOT MATCHED THEN
			INSERT (  
                   DIVISION_ID
                 , CUTOFF_DATE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , PACKER_CODE
                 , SHIP_DATE
                 , TO_SITE
                 , PACK_MODEL_CODE
                 , SHIP_QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
				 , ATTRIBUTE5
				 , ATTRIBUTE4
				 , ATTRIBUTE8
				 , ATTRIBUTE9
                   )
			VALUES (   
                   B.DIVISION_ID
                 , B.CUTOFF_DATE
                 , B.SCM_SITE_ID
                 , B.ITEM_ID
                 , B.PACKER_CODE
                 , B.SHIP_DATE
                 , B.TO_SITE
                 , B.PACK_MODEL_CODE
                 , B.SHIP_QTY
				 , @v_batch_user
				 , getdate()
				 , @v_batch_user
				 , getdate() 
				 , B.CNFM_ID
				 , B.SHIP_TO
				 , B.TRANS_MODE
				 , B.INCOTERMS
			       )
			;

		SET @n_log_count = @@ROWCOUNT;

		-----------------------------------------------------------
        -- INSERT LOG
        -----------------------------------------------------------
        --SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = 'APPEND';
        SET @v_log_message = 'INSERT INTO scm_dnm_scs_ship_result';
        SET @v_description = 'if_seq = ' + @v_if_seq;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        -----------------------------------------------------------
		
		-- 처리된 row 마킹
		UPDATE T
		   SET T.PROC_FLAG = 'Y'
		      ,T.PROC_DATE = getdate()
		  FROM XIF_SCS_SHIP_RSLT_SUM_R_SN	AS T 
		       JOIN @TAB_XIF_SCS_SHIP_RSLT_SUM_R AS F
		    ON T.IF_SEQ = F.IF_SEQ
		   AND F.PROC_FLAG = 'N'


		-- IF data  삭제 (90일 이전 데이터 삭제) 
		DELETE 
		  FROM XIF_SCS_SHIP_RSLT_SUM_R_SN 
		 WHERE IF_RCV_DATE < GETDATE() - 90


    END TRY

    BEGIN CATCH
	  --IF @@TRANCOUNT > 0
		 -- BEGIN
   --         ROLLBACK;
		 -- END;

		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
