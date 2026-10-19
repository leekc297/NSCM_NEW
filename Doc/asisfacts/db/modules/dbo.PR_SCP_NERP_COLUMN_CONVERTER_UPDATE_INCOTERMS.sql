


/*
 * Program ID   : PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_INCOTERMS
 * Description  : NERP Batch conversion Incoterms Table
 * OutTable     :
 * Execute      : EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_INCOTERMS

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024-07-03   vadabi5           Initial Release       NERP) 생성
 * 2024-07-24   vadabi5           NERP) 우선순위 정책 반영
 * 2024-10-06   vadabi5           NERP) 통테3차 개선
 * 2024-10-10   vadabi5           NERP) SCP_MST_BOD 체크
 ----------------------------------------------------------------------------------------------------

 EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_INCOTERMS

-----------------------------------------------------------------------------------------------------
 1, PK- INCOTERMS 실제 중복 발생하지는 않음
-----------------------------------------------------------------------------------------------------
 SCP_ANL_DIO_REPORT_DETAIL		
 SCP_ANL_SHIPMENT_PLAN_FG_N		
 SCP_PLN_SHIPMENT_PLAN_PEGGING	
 SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM
 SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW

-----------------------------------------------------------------------------------------------------
 DELETE 									
 	from NERP_CONV_SCP_DATA 	 			
 	where TABLE_NAME ='SCP_XLS_BOH' 	
 	and column_name1 = 'CONV_INCOTERMS'	
 	 ;										


-----------------------------------------------------------------------------------------------------
 	INSERT INTO NERP_CONV_SCP_DATA																						
 	( TABLE_NAME																										
 	, COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3, COLUMN_NAME4, COLUMN_NAME5												
 	, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4																	
 	, NEW_VALUE1																										
 	)																													
 	select 																												
 	   'SCP_XLS_BOH'																								
 	   ,'CONV_INCOTERMS', 'SCM_SITE_ID','COUNTRY','INCOTERMS'	,'CNT'										
 	   ,SCM_SITE_ID, COUNTRY, INCOTERMS, CNT																			
 	,  CASE WHEN INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04')	THEN 'DAP'					
 			WHEN INCOTERMS IN ('A02', 'S32', 'S33')					THEN 'EXW'								
 			WHEN INCOTERMS IN ('DAT')										THEN 'DPU'								
 			WHEN COUNTRY = 'KR' AND INCOTERMS IN ('Z01')					THEN 'EXW'							
 			WHEN COUNTRY = 'KR' AND INCOTERMS IN ('Z02')					THEN 'DAP'							
 			WHEN COUNTRY != 'KR' AND INCOTERMS IN ('Z01')					THEN 'DAP'							
 			WHEN COUNTRY != 'KR' AND INCOTERMS IN ('Z02')					THEN 'EXW'							
 			WHEN (SCM_SITE_ID LIKE 'A%' OR SCM_SITE_ID LIKE 'F%') AND INCOTERMS IN ('Z01') THEN 'EXW'				
 			WHEN (SCM_SITE_ID LIKE 'A%' OR SCM_SITE_ID LIKE 'F%') AND INCOTERMS IN ('Z02') THEN 'DAP'				
 			WHEN (SCM_SITE_ID NOT LIKE 'A%' AND SCM_SITE_ID NOT LIKE 'F%') AND INCOTERMS IN ('Z01') THEN 'DAP'		
 			WHEN (SCM_SITE_ID NOT LIKE 'A%' AND SCM_SITE_ID NOT LIKE 'F%') AND INCOTERMS IN ('Z02') THEN 'EXW'		
				WHEN INCOTERMS IN ('Z01') THEN 'DAP'																	
 			WHEN INCOTERMS IN ('Z02') THEN 'EXW'																	
 			ELSE INCOTERMS																								
 		END  INCOTERMS_TOBE																								
 	FROM 																												
 	( 																													
 	select 																												
 	   A.SCM_SITE_ID																									
 	 , B.COUNTRY AS COUNTRY																								
 	 , INCOTERMS																										
 	 , COUNT(*) AS CNT																									
 	 FROM SCP_XLS_BOH A with (nolock)																				
 	--LEFT JOIN (  select scm_site_id, country from SCM_MST_SITE ) B ON A.SCM_SITE_ID = B.scm_site_id	
	 LEFT JOIN ( SELECT OLD_VALUE1 as scm_site_id, OLD_VALUE2 as country from NERP_CONV_MASTER  WHERE CODETYPE = 'SCP_INCOTERMS' AND ATTRIBUTE5 = '1ST' ) B ON A.SCM_SITE_ID = B.scm_site_id				
 	
 	 WHERE INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID') 					
 	 GROUP BY A.SCM_SITE_ID, B.COUNTRY,INCOTERMS																		
 	 ) LIST																												
 	 ;	
-----------------------------------------------------------------------------------------------------	 
 UPDATE SCP_XLS_BOH																			
    SET SCP_XLS_BOH.INCOTERMS	= B.INCOTERMS_TOBE											
  FROM .SCP_XLS_BOH AS A, 																	
 (																								
 SELECT OLD_VALUE1 AS SCM_SITE_ID															
      , OLD_VALUE2 AS COUNTRY																	
 	 , OLD_VALUE3 AS INCOTERMS 																	
 	 , NEW_VALUE1 AS INCOTERMS_TOBE 															
 FROM NERP_CONV_SCP_DATA 																		
 WHERE COLUMN_NAME1='CONV_INCOTERMS' 															
 and TABLE_NAME = 'SCP_XLS_BOH'															
 ) AS B																							
 WHERE A.SCM_SITE_ID = B.SCM_SITE_ID														
   and A.INCOTERMS = B.INCOTERMS																	
   and A.INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID')
 	 ;																							

 */

CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_INCOTERMS]
AS
BEGIN
	DECLARE @ACT_YN NVARCHAR(2) = 'Y'
	DECLARE @TABLE_NAME   NVARCHAR(150) = N''; 
	DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N''; 
	DECLARE @COL_INFO   NVARCHAR(150) = N''; 
	DECLARE @MAPPING_RESULT NVARCHAR(2);

	DECLARE @CNT INT;
	DECLARE @ACT_CNT INT;

	DECLARE @SELECT_COL NVARCHAR(MAX);
	DECLARE @mEXEC NVARCHAR(MAX);
	DECLARE @BACKUP_START_TIME  NVARCHAR(50) = N''; 
	DECLARE @BACKUP_END_TIME  NVARCHAR(50) = N''; 
	DECLARE @MAPPING_START_TIME  NVARCHAR(50) = N''; 
	DECLARE @MAPPING_END_TIME  NVARCHAR(50) = N''; 
	DECLARE @COLUMN_NAME  NVARCHAR(50) = N''; 
	DECLARE @MAPPING_COLUMN  NVARCHAR(50) = N''; 

	DECLARE  @mDisQuery NVARCHAR(MAX) = '';
	DECLARE  @mSubQuery NVARCHAR(MAX) = '';
	DECLARE  @mUpdateQuery NVARCHAR(MAX) = '';
	DECLARE  @mUpdateWhereQuery NVARCHAR(MAX) = '';
	DECLARE  @mTableQuery NVARCHAR(MAX) = '';
	DECLARE  @message NVARCHAR(MAX) = '';

	DECLARE @USE_BACKUP  NVARCHAR(50) = N''; 
	DECLARE @USE_MAPPING  NVARCHAR(50) = 'N'; 
	DECLARE @USE_MAPPING_TEST  NVARCHAR(50) = 'Y'; 


	declare @isCompany nvarchar(2)
	declare @isDOM_EXP nvarchar(2)
	declare @USE_COLUMN nvarchar(200)

	DECLARE @BATCH_START_TIME  NVARCHAR(50) = N''; 
	DECLARE @MAPPING_TIME  BIGINT = 0; 
	DECLARE @START_TIME DATETIME;
	DECLARE @RUN nvarchar(2) = 'Y'
	DECLARE @WORK_SECOND INT;

	--###########################################################################################################
	-- LOG 용 변수 설정
	--###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_INCOTERMS';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

	set @BATCH_START_TIME = getdate();
    SET @d_event_date = SYSDATETIME();
	set @START_TIME = getdate();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'START', 0, '0', '', @START_TIME;


--################################################################################################################
--STEP 4. 최종 업데이트 쿼리 적용
--################################################################################################################
			IF OBJECT_ID('tempdb..#TMP_CODELIST') IS NOT NULL
			BEGIN
			DROP TABLE #TMP_CODELIST
			END

				SELECT DISTINCT OLD_VALUE1 
				INTO #TMP_CODELIST
				FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID'
				-- 검증 편의 위해 추가
				--print 'SELECT DISTINCT OLD_VALUE1 INTO #TMP_CODELIST FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'''

BEGIN TRY

		    DECLARE CURSOR_BATCH CURSOR FOR


				/*
				USE_COLUMN (INCOTERMS 국내/해외 구분 방법)
				------------------------------------------
				FROM_SITE		- 14개 (제외 = SCP_MST_BOD)
				COMPANY_ID		- 10개 5분25초
				DOM_EXP			- 6개  7분44초
				NO_MATCH
				*/
				SELECT distinct program_id AS TABLE_NAME
				              , DEV_DETAIL AS COLUMN_NAME
				              , DEV_REMARK AS USE_COLUMN
							  --, MAPPING_COLUMN
							  --, MAPPING_USE
							  , PROD_TABLE_CNT AS CNT
				FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
				where DEV_TYPE = 'Batch_Conversion'
				and mapping_use in ('IC')
				and mapping_column = 'INCOTERMS'
				and ISNULL(STATUS,'') != 'FINISH'
				and ( isnull(mapping_comment,'') = '' OR isnull(mapping_comment,'') like '%OK%')
				
				--and DEV_REMARK = 'FROM_SITE'
				--and program_id  IN ( 'SCP_ANL_SHIPMENT_PLAN_FG_H','SCP_ANL_SHIPMENT_PLAN_FIX_H')
				--and program_id NOT IN ( 'SCP_ANL_SHIPMENT_PLAN_FG_H','SCP_RPT_GLOBAL_PSI_MD_MM')
				--and program_id = 'SCM_MST_ALTER_ITEM_TYPE'
				--and PROD_TABLE_CNT < 1000000000
				--and PROD_TABLE_CNT > 0
				order by PROD_TABLE_CNT, DEV_REMARK


			OPEN CURSOR_BATCH;
			FETCH NEXT FROM CURSOR_BATCH
			INTO @TABLE_NAME, @COLUMN_NAME, @USE_COLUMN,@CNT
			WHILE @@FETCH_STATUS = 0
			BEGIN
				 SELECT @TABLE_NAME, @COLUMN_NAME, @USE_COLUMN,@CNT
				 SET @MAPPING_RESULT = 'N';

				print '####################################################################################'
				print concat(@TABLE_NAME, ' , ', @COLUMN_NAME, ' , ', @USE_COLUMN, ' , ', @CNT)
				print '####################################################################################'

				set @v_log_message =  concat(@TABLE_NAME, ', ',@COLUMN_NAME, ', ',@USE_COLUMN, ' , ', @CNT)
				SET @CNT = @CNT+1;
				SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'CONV INCOTERMS', 0, @TABLE_NAME, @v_log_message, @START_TIME;


				IF OBJECT_ID('tempdb..#TMP_LIST') IS NOT NULL
				BEGIN
				DROP TABLE #TMP_LIST
				END

				IF OBJECT_ID('tempdb..#TMP_LIST_CONV') IS NOT NULL
				BEGIN
				DROP TABLE #TMP_LIST_CONV
				END



				SET @mSubQuery = ''
				SET @mSubQuery = @mSubQuery + ' 	DELETE 									' +CHAR(10);
				SET @mSubQuery = @mSubQuery + ' 	from NERP_CONV_SCP_DATA 	 			' +CHAR(10);
				SET @mSubQuery = @mSubQuery + ' 	where TABLE_NAME ='''+@TABLE_NAME+''' 	' +CHAR(10);
				SET @mSubQuery = @mSubQuery + ' 	and column_name1 = ''CONV_INCOTERMS''	' +CHAR(10);
				SET @mSubQuery = @mSubQuery + ' 	 ;										' +CHAR(10);
				print @mSubQuery
				exec (@mSubQuery)



				-- Master 에서 처리
				IF @TABLE_NAME = 'SCP_MST_BOD' AND @COLUMN_NAME = 'INCOTERMS'
					BEGIN
					-- #TMP_LIST
					----------------------------------------------------------------------------------------------
					SELECT  																								 
							BOD_ID
						,DIVISION_ID
						,FROM_SITE
						,TO_SITE
						,INCOTERMS
						,PRIORITY
						,ROUTE_ID
						,VALID_YN
						,COUNTRY															 
					, CASE WHEN (INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04'))	THEN 'DAP'		 
 							WHEN (INCOTERMS IN ('A02', 'S32', 'S33'))						THEN 'EXW'				 
 							WHEN (INCOTERMS IN ('DAT'))										THEN 'DPU'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS IN ('Z01')					THEN 'EXW'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS IN ('Z02')					THEN 'DAP'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS IN ('Z01')					THEN 'DAP'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS IN ('Z02')					THEN 'EXW'				 
 							ELSE INCOTERMS																					 
 							END TOBE_INCOTERMS
					, CASE WHEN (INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04'))	THEN '1'		 
 							WHEN (INCOTERMS IN ('A02', 'S32', 'S33'))						THEN '2'				 
 							WHEN (INCOTERMS IN ('DAT'))										THEN '3'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS IN ('Z01')					THEN '4'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS IN ('Z02')					THEN '5'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS IN ('Z01')					THEN '6'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS IN ('Z02')					THEN '7'				 
 							ELSE '8'																					 
 							END TOBE_INCOTERMS_TYPE	
						INTO #TMP_LIST																							 
						FROM 																									 
						(																										 
							SELECT BOD_ID
							,B.DIVISION_ID
							,B.FROM_SITE
							,B.TO_SITE	
							,B.INCOTERMS
							,B.PRIORITY
							,B.ROUTE_ID
							,B.VALID_YN
							,F.COUNTRY AS FCOUNTRY
							,T.COUNTRY AS TCOUNTRY
							,CASE WHEN B.ATTRIBUTE1 IN ('Z01', 'Z02') AND F.COUNTRY  = 'KR' THEN 'D' 					 
 									WHEN B.ATTRIBUTE1 IN ('Z01', 'Z02') AND F.COUNTRY != 'KR' THEN 'E' 					 
 									ELSE 'D'																						 
 									END COUNTRY																					 
							FROM SCP_MST_BOD B																					 
							LEFT JOIN SCM_MST_SITE F WITH(NOLOCK) ON B.DIVISION_ID = F.DIVISION_ID AND B.FROM_SITE = F.SCM_SITE_ID	 
							LEFT JOIN SCM_MST_SITE T WITH(NOLOCK) ON B.DIVISION_ID = T.DIVISION_ID AND B.TO_SITE = T.SCM_SITE_ID	 
							WHERE B.INCOTERMS IN (SELECT DISTINCT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID') 
						) list	
						ORDER BY BOD_ID

					-- #TMP_LIST_CONV
					----------------------------------------------------------------------------------------------
						SELECT * 
							, rank() over (partition by  DIVISION_ID, FROM_SITE, TO_SITE, INCOTERMS order by TOBE_INCOTERMS_TYPE ) AS RNO
						INTO #TMP_LIST_CONV	
						FROM #TMP_LIST 
						ORDER BY DIVISION_ID, FROM_SITE, TO_SITE,INCOTERMS,PRIORITY,ROUTE_ID,VALID_YN







					-- SCP_MST_BOD INCOTERMS Conversion
					----------------------------------------------------------------------------------------------
						UPDATE SCP_MST_BOD																	
						SET    SCP_MST_BOD.INCOTERMS = B.TOBE_INCOTERMS								
						FROM  .SCP_MST_BOD	 AS A,															
						( SELECT BOD_ID, FROM_SITE, TO_SITE, INCOTERMS, TOBE_INCOTERMS FROM #TMP_LIST_CONV) AS B		
						WHERE   A.BOD_ID			 = B.BOD_ID																	
						and     A.INCOTERMS IN (SELECT DISTINCT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID' )  
						;



					-- SCP_MST_BOD INCOTERMS 체크
					----------------------------------------------------------------------------------------------
						select division_id,from_site, to_site,incoterms, b.valid_yn, r.transport_mode
							, max(b.attribute3) as attribute3
							, max(b.attribute2) as attribute2 
							,  count(*) AS CNT
						into #TMP_LIST_TR
						from scp_mst_bod b with (nolock)
						inner join scp_mst_distribution_route r with (nolock) on b.ROUTE_ID = r.ROUTE_ID
						where b.valid_yn = 'Y'
						--and b.attribute3 >= '20210121'
						--and b.attribute2 <= '20241105'
						group by division_id,from_site, to_site,incoterms, b.valid_yn, r.transport_mode
						having count(*) > 1



						select a.division_id,a.from_site, a.to_site,a.incoterms, b.valid_yn, b.transport_mode, a.route_id,a.bod_id
						, rank () over ( partition by a.division_id,a.from_site, a.to_site,a.incoterms, b.valid_yn, b.transport_mode order by bod_id desc) as rno
						into #tmp_list_rank		
						from scp_mst_bod a with (nolock)
						inner join #TMP_LIST_TR b on A.division_id = B.DIVISION_ID
											and A.from_site = B.from_site
											and A.to_site = B.to_site
											and A.incoterms = B.incoterms
											and A.valid_yn = B.valid_yn
						order by a.division_id,a.from_site, a.to_site,a.incoterms, b.valid_yn, b.transport_mode

					-- 중복문제 조치 scp_mst_bod_n_v
					
					UPDATE scp_mst_bod 
						SET scp_mst_bod.VALID_YN	= 'N'
						FROM .scp_mst_bod AS A, 
					(select * from #tmp_list_rank) AS B
					WHERE   A.division_id = B.division_id
					and  A.from_site = B.from_site
					and  A.to_site = B.to_site
					and  A.incoterms = B.incoterms
					and  A.route_id = B.route_id
					and  A.valid_yn = B.valid_yn 
					and rno > 1
					
					--################################################################
					-- ATTRIBUTE1
					--################################################################
						SELECT BOD_ID
							,B.DIVISION_ID
							,B.FROM_SITE
							,B.TO_SITE	
							,B.INCOTERMS

							,B.PRIORITY
							,B.ROUTE_ID
							,B.VALID_YN
							,F.COUNTRY AS FCOUNTRY
							,T.COUNTRY AS TCOUNTRY
							,CASE WHEN B.ATTRIBUTE1 IN ('Z01', 'Z02') AND F.COUNTRY  = 'KR' THEN 'D' 					 
 									WHEN B.ATTRIBUTE1 IN ('Z01', 'Z02') AND F.COUNTRY != 'KR' THEN 'E' 					 
 									ELSE 'D'																						 
 									END COUNTRY	
							,B.ATTRIBUTE1
							into #tmp_list_inc
							FROM SCP_MST_BOD B																					 
							LEFT JOIN SCM_MST_SITE F WITH(NOLOCK) ON B.DIVISION_ID = F.DIVISION_ID AND B.FROM_SITE = F.SCM_SITE_ID	 
							LEFT JOIN SCM_MST_SITE T WITH(NOLOCK) ON B.DIVISION_ID = T.DIVISION_ID AND B.TO_SITE = T.SCM_SITE_ID	 
							WHERE B.ATTRIBUTE1 IN (SELECT DISTINCT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID') 





					SELECT  																								 
							BOD_ID
						,DIVISION_ID
						,FROM_SITE
						,TO_SITE
						,INCOTERMS
						,PRIORITY
						,ROUTE_ID
						,VALID_YN
						,COUNTRY	
						,ATTRIBUTE1
					, CASE WHEN (ATTRIBUTE1 IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04'))	THEN 'DAP'		 
 							WHEN (ATTRIBUTE1 IN ('A02', 'S32', 'S33'))						THEN 'EXW'				 
 							WHEN (ATTRIBUTE1 IN ('DAT'))										THEN 'DPU'				 
 							WHEN  COUNTRY =  'D' AND ATTRIBUTE1 IN ('Z01')					THEN 'EXW'				 
 							WHEN  COUNTRY =  'D' AND ATTRIBUTE1 IN ('Z02')					THEN 'DAP'				 
 							WHEN  COUNTRY != 'D' AND ATTRIBUTE1 IN ('Z01')					THEN 'DAP'				 
 							WHEN  COUNTRY != 'D' AND ATTRIBUTE1 IN ('Z02')					THEN 'EXW'				 
 							ELSE ATTRIBUTE1																					 
 							END TOBE_ATTRIBUTE1
						into #tmp_list_inc_conv
						from #tmp_list_inc


					UPDATE SCP_MST_BOD 
					SET SCP_MST_BOD.ATTRIBUTE1	= ISNULL( B.TOBE_ATTRIBUTE1,A.ATTRIBUTE1)
					FROM .SCP_MST_BOD AS A, 
					(select ATTRIBUTE1,TOBE_ATTRIBUTE1  from #tmp_list_inc_conv ) AS B
					WHERE   A.ATTRIBUTE1					= B.ATTRIBUTE1

					SET @MAPPING_RESULT = 'Y';	



					END 

				-- Master 에서 처리
				ELSE IF @TABLE_NAME = 'SCP_MST_BOD' AND @COLUMN_NAME = 'ATTRIBUTE1'
					BEGIN
					-- #TMP_LIST
					----------------------------------------------------------------------------------------------
					SELECT  																								 
							BOD_ID
						,DIVISION_ID
						,FROM_SITE
						,TO_SITE
						,INCOTERMS
						,PRIORITY
						,ROUTE_ID
						,VALID_YN
						,INCOTERMS_ATTR
						,COUNTRY															 
					, CASE WHEN (INCOTERMS_ATTR IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04'))	THEN 'DAP'		 
 							WHEN (INCOTERMS_ATTR IN ('A02', 'S32', 'S33'))						THEN 'EXW'				 
 							WHEN (INCOTERMS_ATTR IN ('DAT'))										THEN 'DPU'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS_ATTR IN ('Z01')					THEN 'EXW'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS_ATTR IN ('Z02')					THEN 'DAP'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS_ATTR IN ('Z01')					THEN 'DAP'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS_ATTR IN ('Z02')					THEN 'EXW'				 
 							ELSE INCOTERMS																					 
 							END TOBE_INCOTERMS_ATTR	
					, CASE WHEN (INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04'))	THEN '1'		 
 							WHEN (INCOTERMS IN ('A02', 'S32', 'S33'))						THEN '2'				 
 							WHEN (INCOTERMS IN ('DAT'))										THEN '3'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS_ATTR IN ('Z01')					THEN '4'				 
 							WHEN  COUNTRY =  'D' AND INCOTERMS_ATTR IN ('Z02')					THEN '5'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS_ATTR IN ('Z01')					THEN '6'				 
 							WHEN  COUNTRY != 'D' AND INCOTERMS_ATTR IN ('Z02')					THEN '7'				 
 							ELSE '8'																					 
 							END TOBE_INCOTERMS_TYPE	
						INTO #TMP_LIST2																							 
						FROM 																									 
						(																										 
							SELECT BOD_ID
							,B.DIVISION_ID
							,B.FROM_SITE
							,B.TO_SITE	
							,B.INCOTERMS
							,B.PRIORITY
							,B.ROUTE_ID
							,B.VALID_YN
							,B.ATTRIBUTE1 AS INCOTERMS_ATTR
							,F.COUNTRY AS FCOUNTRY
							,T.COUNTRY AS TCOUNTRY
							,CASE WHEN B.ATTRIBUTE1 IN ('Z01', 'Z02') AND F.COUNTRY  = 'KR' THEN 'D' 					 
 									WHEN B.ATTRIBUTE1 IN ('Z01', 'Z02') AND F.COUNTRY != 'KR' THEN 'E' 					 
 									ELSE 'D'																						 
 									END COUNTRY																					 
							FROM SCP_MST_BOD B																					 
							LEFT JOIN SCM_MST_SITE F WITH(NOLOCK) ON B.DIVISION_ID = F.DIVISION_ID AND B.FROM_SITE = F.SCM_SITE_ID	 
							LEFT JOIN SCM_MST_SITE T WITH(NOLOCK) ON B.DIVISION_ID = T.DIVISION_ID AND B.TO_SITE = T.SCM_SITE_ID	 
							WHERE B.ATTRIBUTE1 IN (SELECT DISTINCT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID') 
						) list	
						ORDER BY BOD_ID

					-- #TMP_LIST_CONV
					----------------------------------------------------------------------------------------------
						SELECT * 
							, rank() over (partition by  DIVISION_ID, FROM_SITE, TO_SITE, INCOTERMS, INCOTERMS_ATTR order by TOBE_INCOTERMS_TYPE ) AS RNO
						INTO #TMP_LIST_CONV2	
						FROM #TMP_LIST2 
						ORDER BY DIVISION_ID, FROM_SITE, TO_SITE,INCOTERMS,PRIORITY,ROUTE_ID,VALID_YN


					-- SCP_MST_BOD ATTRIBUTE1
					----------------------------------------------------------------------------------------------
						UPDATE SCP_MST_BOD																	
						SET    SCP_MST_BOD.ATTRIBUTE1 = B.TOBE_INCOTERMS_ATTR								
						FROM  .SCP_MST_BOD	 AS A,															
						( SELECT BOD_ID, FROM_SITE, TO_SITE, INCOTERMS, INCOTERMS_ATTR, TOBE_INCOTERMS_ATTR FROM #TMP_LIST_CONV2) AS B		
						WHERE   A.BOD_ID			 = B.BOD_ID																	
						and     A.ATTRIBUTE1 IN (SELECT DISTINCT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID' )  
						;
						SET @MAPPING_RESULT = 'Y';	
					END 

				-- INCOTERMS 아닌 ATTRIBUTE1
				ELSE IF @TABLE_NAME = 'SCP_MST_BOD_H' AND @COLUMN_NAME = 'ATTRIBUTE1'
					BEGIN
					
					SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' 	INSERT INTO NERP_CONV_SCP_DATA																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( TABLE_NAME																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3, COLUMN_NAME4, COLUMN_NAME5												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, NEW_VALUE1																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	)																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   '''+@TABLE_NAME+'''																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,''CONV_INCOTERMS'', '''+@USE_COLUMN+''',''COUNTRY'','''+@COLUMN_NAME+'''	,''CNT''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,'+@USE_COLUMN+', COUNTRY, '+@COLUMN_NAME+', CNT																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	,  CASE WHEN '+@COLUMN_NAME+' IN (''A01'', ''DDU'', ''FAC'', ''ZS3'', ''Z03'', ''Z04'')	THEN ''DAP''					' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN '+@COLUMN_NAME+' IN (''A02'', ''S32'', ''S33'')					THEN ''EXW''								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN '+@COLUMN_NAME+' IN (''DAT'')										THEN ''DPU''								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY = ''KR'' AND '+@COLUMN_NAME+' IN (''Z01'')					THEN ''EXW''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY = ''KR'' AND '+@COLUMN_NAME+' IN (''Z02'')					THEN ''DAP''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY != ''KR'' AND '+@COLUMN_NAME+' IN (''Z01'')					THEN ''DAP''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY != ''KR'' AND '+@COLUMN_NAME+' IN (''Z02'')					THEN ''EXW''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' LIKE ''A%'' OR '+@USE_COLUMN+' LIKE ''F%'') AND '+@COLUMN_NAME+' IN (''Z01'') THEN ''EXW''				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' LIKE ''A%'' OR '+@USE_COLUMN+' LIKE ''F%'') AND '+@COLUMN_NAME+' IN (''Z02'') THEN ''DAP''				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' NOT LIKE ''A%'' AND '+@USE_COLUMN+' NOT LIKE ''F%'') AND '+@COLUMN_NAME+' IN (''Z01'') THEN ''DAP''		' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' NOT LIKE ''A%'' AND '+@USE_COLUMN+' NOT LIKE ''F%'') AND '+@COLUMN_NAME+' IN (''Z02'') THEN ''EXW''		' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '				WHEN '+@COLUMN_NAME+' IN (''Z01'') THEN ''DAP''																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN '+@COLUMN_NAME+' IN (''Z02'') THEN ''EXW''																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			ELSE '+@COLUMN_NAME+'																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 		END  INCOTERMS_TOBE																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	FROM 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( 																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   A.'+@USE_COLUMN+'																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , B.COUNTRY AS COUNTRY																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , '+@COLUMN_NAME+'																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , COUNT(*) AS CNT																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 FROM '+@TABLE_NAME+' A with (nolock)																				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 LEFT JOIN (  SELECT OLD_VALUE1 as scm_site_id, OLD_VALUE2 as country from NERP_CONV_MASTER  WHERE CODETYPE = ''SCP_INCOTERMS'' AND ATTRIBUTE5 = ''1ST''  ) B ON A.'+@USE_COLUMN+' = B.scm_site_id				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 WHERE '+@COLUMN_NAME+' IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'') 				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 GROUP BY A.'+@USE_COLUMN+', B.COUNTRY,'+@COLUMN_NAME+'																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ) LIST																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																													' +CHAR(10);
					--print @mSubQuery
					--exec (@mSubQuery)


				  --SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' UPDATE '+@TABLE_NAME+'																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '    SET '+@TABLE_NAME+'.'+@COLUMN_NAME+'	= B.INCOTERMS_TOBE											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '  FROM .'+@TABLE_NAME+' AS A, 																	' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + ' (																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' SELECT OLD_VALUE1 AS '+@USE_COLUMN+'															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '      , OLD_VALUE2 AS COUNTRY																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , OLD_VALUE3 AS INCOTERMS 																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , NEW_VALUE1 AS INCOTERMS_TOBE 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' FROM NERP_CONV_SCP_DATA 																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' WHERE COLUMN_NAME1=''CONV_INCOTERMS'' 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' and TABLE_NAME = '''+@TABLE_NAME+'''															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' ) AS B																							' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' WHERE A.'+@USE_COLUMN+' = B.'+@USE_COLUMN+'														' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '   and A.'+@COLUMN_NAME+' = B.INCOTERMS																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '   and A.'+@COLUMN_NAME+' IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'')' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																							' +CHAR(10);
					print @mSubQuery
					--exec (@mSubQuery)	

					SET @MAPPING_RESULT = 'Y';	
					END 

				ELSE IF @USE_COLUMN = 'COMPANY_ID'
				BEGIN

					SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' 	INSERT INTO NERP_CONV_SCP_DATA																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( TABLE_NAME																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3, COLUMN_NAME4, COLUMN_NAME5														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, NEW_VALUE1																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	)																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   '''+@TABLE_NAME+'''																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,''CONV_INCOTERMS'', ''COMPANY_ID'',''-'',''INCOTERMS''	,''CNT''														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,COMPANY_ID, ''-'', INCOTERMS, CNT																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '		  , CASE WHEN (INCOTERMS IN (''A01'', ''DDU'', ''FAC'', ''ZS3'', ''Z03'', ''Z04''))							THEN ''DAP''	' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + '				WHEN (INCOTERMS IN (''A02'', ''S32'', ''S33''))														THEN ''EXW''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN (INCOTERMS IN (''DAT''))																		THEN ''DPU''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID LIKE ''C%'' OR COMPANY_ID LIKE ''HQ%'') AND (INCOTERMS IN (''Z01'')))				THEN ''EXW''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID LIKE ''C%'' OR COMPANY_ID LIKE ''HQ%'') AND (INCOTERMS IN (''Z02'')))				THEN ''DAP''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID NOT LIKE ''C%'' AND COMPANY_ID NOT LIKE ''HQ%'') AND (INCOTERMS IN (''Z01'')))	THEN ''DAP''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID NOT LIKE ''C%'' AND COMPANY_ID NOT LIKE ''HQ%'') AND (INCOTERMS IN (''Z02'')))	THEN ''EXW''	' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '				WHEN INCOTERMS IN (''Z01'') THEN ''DAP''																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''Z02'') THEN ''EXW''																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			ELSE INCOTERMS																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 		END  INCOTERMS_TOBE																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	FROM 																														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( 																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   COMPANY_ID																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , INCOTERMS																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , COUNT(*) AS CNT																											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 FROM '+@TABLE_NAME+' A with (nolock)																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 WHERE INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'') 							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 GROUP BY COMPANY_ID,INCOTERMS																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ) LIST																														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																															' +CHAR(10);
					--print @mSubQuery
					--exec (@mSubQuery)


				  --SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' UPDATE '+@TABLE_NAME+'																				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '    SET '+@TABLE_NAME+'.INCOTERMS	= B.INCOTERMS_TOBE												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '  FROM .'+@TABLE_NAME+' AS A, 																		' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + ' (																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' SELECT OLD_VALUE1 AS COMPANY_ID																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , OLD_VALUE3 AS INCOTERMS 																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , NEW_VALUE1 AS INCOTERMS_TOBE 																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' FROM NERP_CONV_SCP_DATA 																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' WHERE COLUMN_NAME1=''CONV_INCOTERMS'' 																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' and TABLE_NAME = '''+@TABLE_NAME+'''																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' ) AS B																								' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' WHERE A.COMPANY_ID = B.COMPANY_ID																	' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS  = B.INCOTERMS																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'')	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																								' +CHAR(10);
					print @mSubQuery
					--exec (@mSubQuery)	

					SET @MAPPING_RESULT = 'Y';	
				END

                -- SCM_DNM_INTRANSIT_CO_SUMMARY, SCM_DNM_INTRANSIT_CO_DETAIL
				ELSE IF  @USE_COLUMN = 'COMPANY_ID_PURCH'
				BEGIN

					SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' 	INSERT INTO NERP_CONV_SCP_DATA																											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( TABLE_NAME																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3, COLUMN_NAME4, COLUMN_NAME5																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, NEW_VALUE1																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	)																																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   '''+@TABLE_NAME+'''																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,''CONV_INCOTERMS'', ''COMPANY_ID_PURCH'',''-'',''INCOTERMS''	,''CNT''															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,COMPANY_ID_PURCH, ''-'', INCOTERMS, CNT																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '		  ,CASE WHEN (INCOTERMS IN (''A01'', ''DDU'', ''FAC'', ''ZS3'', ''Z03'', ''Z04''))										THEN ''DAP''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN (INCOTERMS IN (''A02'', ''S32'', ''S33''))																	THEN ''EXW''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN (INCOTERMS IN (''DAT''))																					THEN ''DPU''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID_PURCH LIKE ''C%'' OR COMPANY_ID_PURCH LIKE ''HQ%'') AND (INCOTERMS IN (''Z01'')))				THEN ''EXW''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID_PURCH LIKE ''C%'' OR COMPANY_ID_PURCH LIKE ''HQ%'') AND (INCOTERMS IN (''Z02'')))				THEN ''DAP''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID_PURCH NOT LIKE ''C%'' AND COMPANY_ID_PURCH NOT LIKE ''HQ%'') AND (INCOTERMS IN (''Z01'')))	THEN ''DAP''	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN ((COMPANY_ID_PURCH NOT LIKE ''C%'' AND COMPANY_ID_PURCH NOT LIKE ''HQ%'') AND (INCOTERMS IN (''Z02'')))	THEN ''EXW''	' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '				WHEN INCOTERMS IN (''Z01'') THEN ''DAP''																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''Z02'') THEN ''EXW''																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			ELSE INCOTERMS																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 		END  INCOTERMS_TOBE																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	FROM 																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( 																																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   COMPANY_ID_PURCH																														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , INCOTERMS																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , COUNT(*) AS CNT																														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 FROM '+@TABLE_NAME+' A with (nolock)																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 WHERE INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'') 										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 GROUP BY COMPANY_ID_PURCH,INCOTERMS																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ) LIST																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																																		' +CHAR(10);
					--print @mSubQuery
					--exec (@mSubQuery)


				  --SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' UPDATE '+@TABLE_NAME+'																				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '    SET '+@TABLE_NAME+'.INCOTERMS	= B.INCOTERMS_TOBE												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '  FROM .'+@TABLE_NAME+' AS A, 																		' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + ' (																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' SELECT OLD_VALUE1 AS COMPANY_ID_PURCH																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , OLD_VALUE3 AS INCOTERMS 																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , NEW_VALUE1 AS INCOTERMS_TOBE 																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' FROM NERP_CONV_SCP_DATA 																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' WHERE COLUMN_NAME1=''CONV_INCOTERMS'' 																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' and TABLE_NAME = '''+@TABLE_NAME+'''																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' ) AS B																								' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' WHERE A.COMPANY_ID_PURCH = B.COMPANY_ID_PURCH														' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS  = B.INCOTERMS																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'')	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																								' +CHAR(10);
					print @mSubQuery
					--exec (@mSubQuery)	

					SET @MAPPING_RESULT = 'Y';	
					END 


				ELSE IF @USE_COLUMN = 'DOM_EXP'
				BEGIN
		
					SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' 	INSERT INTO NERP_CONV_SCP_DATA																											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( TABLE_NAME																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3, COLUMN_NAME4, COLUMN_NAME5																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, NEW_VALUE1																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	)																																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   '''+@TABLE_NAME+'''																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,''CONV_INCOTERMS'', ''DOM_EXP'',''-'',''INCOTERMS''	,''CNT''																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,DOM_EXP, ''-'', INCOTERMS, CNT																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '	      ,CASE WHEN (INCOTERMS IN (''A01'', ''DDU'', ''FAC'', ''ZS3'', ''Z03'', ''Z04''))		THEN ''DAP''									' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + '				WHEN (INCOTERMS IN (''A02'', ''S32'', ''S33''))									THEN ''EXW''									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN (INCOTERMS IN (''DAT''))													THEN ''DPU''									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN DOM_EXP = ''D'' AND (INCOTERMS IN (''Z01''))								THEN ''EXW''									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN DOM_EXP = ''D'' AND (INCOTERMS IN (''Z02''))								THEN ''DAP''									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN DOM_EXP = ''E'' AND (INCOTERMS IN (''Z01''))								THEN ''DAP''									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '				WHEN DOM_EXP = ''E'' AND (INCOTERMS IN (''Z02''))								THEN ''EXW''									' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '				WHEN INCOTERMS IN (''Z01'') THEN ''DAP''																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''Z02'') THEN ''EXW''																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			ELSE INCOTERMS																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 		END  INCOTERMS_TOBE																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	FROM 																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( 																																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   DOM_EXP																																' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , INCOTERMS																															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , COUNT(*) AS CNT																														' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 FROM '+@TABLE_NAME+' A with (nolock)																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 WHERE INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'') 										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 GROUP BY DOM_EXP,INCOTERMS																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ) LIST																																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																																		' +CHAR(10);
					--print @mSubQuery
					--exec (@mSubQuery)


				  --SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' UPDATE '+@TABLE_NAME+'																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '    SET '+@TABLE_NAME+'.INCOTERMS	= B.INCOTERMS_TOBE											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '  FROM .'+@TABLE_NAME+' AS A, 																	' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + ' (																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' SELECT OLD_VALUE1 AS DOM_EXP																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , OLD_VALUE3 AS INCOTERMS 																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , NEW_VALUE1 AS INCOTERMS_TOBE 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' FROM NERP_CONV_SCP_DATA 																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' WHERE COLUMN_NAME1=''CONV_INCOTERMS'' 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' and TABLE_NAME = '''+@TABLE_NAME+'''															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' ) AS B																							' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' WHERE A.DOM_EXP = B.DOM_EXP																		' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'')' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																							' +CHAR(10);
					print @mSubQuery
					--exec (@mSubQuery)	

					SET @MAPPING_RESULT = 'Y';	
				END 

																															
																																				
																																				
				--FN_SCM_SPLIT, SCM_MST_ALTER_ITEM_TYPE
				ELSE IF @USE_COLUMN = 'SALES_SITE'
				     OR @USE_COLUMN = 'SALES_SITE_ID'
					 OR @USE_COLUMN = 'SCM_SITE_ID'
					 OR @USE_COLUMN = 'FROM_SITE'
					BEGIN
					
					SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' 	INSERT INTO NERP_CONV_SCP_DATA																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( TABLE_NAME																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3, COLUMN_NAME4, COLUMN_NAME5												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, NEW_VALUE1																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	)																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   '''+@TABLE_NAME+'''																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,''CONV_INCOTERMS'', '''+@USE_COLUMN+''',''COUNTRY'',''INCOTERMS''	,''CNT''										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,'+@USE_COLUMN+', COUNTRY, INCOTERMS, CNT																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	,  CASE WHEN INCOTERMS IN (''A01'', ''DDU'', ''FAC'', ''ZS3'', ''Z03'', ''Z04'')	THEN ''DAP''					' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''A02'', ''S32'', ''S33'')					THEN ''EXW''								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''DAT'')										THEN ''DPU''								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY = ''KR'' AND INCOTERMS IN (''Z01'')					THEN ''EXW''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY = ''KR'' AND INCOTERMS IN (''Z02'')					THEN ''DAP''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY != ''KR'' AND INCOTERMS IN (''Z01'')					THEN ''DAP''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY != ''KR'' AND INCOTERMS IN (''Z02'')					THEN ''EXW''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' LIKE ''A%'' OR '+@USE_COLUMN+' LIKE ''F%'') AND INCOTERMS IN (''Z01'') THEN ''EXW''				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' LIKE ''A%'' OR '+@USE_COLUMN+' LIKE ''F%'') AND INCOTERMS IN (''Z02'') THEN ''DAP''				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' NOT LIKE ''A%'' AND '+@USE_COLUMN+' NOT LIKE ''F%'') AND INCOTERMS IN (''Z01'') THEN ''DAP''		' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' 			WHEN ('+@USE_COLUMN+' NOT LIKE ''A%'' AND '+@USE_COLUMN+' NOT LIKE ''F%'') AND INCOTERMS IN (''Z02'') THEN ''EXW''		' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '				WHEN INCOTERMS IN (''Z01'') THEN ''DAP''																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''Z02'') THEN ''EXW''																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			ELSE INCOTERMS																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 		END  INCOTERMS_TOBE																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	FROM 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( 																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   A.'+@USE_COLUMN+'																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , B.COUNTRY AS COUNTRY																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , INCOTERMS																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , COUNT(*) AS CNT																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 FROM '+@TABLE_NAME+' A with (nolock)																				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 LEFT JOIN ( SELECT OLD_VALUE1 as scm_site_id, OLD_VALUE2 as country from NERP_CONV_MASTER  WHERE CODETYPE = ''SCP_INCOTERMS'' AND ATTRIBUTE5 = ''1ST''  ) B ON A.'+@USE_COLUMN+' = B.scm_site_id				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 WHERE INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'') 					' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 GROUP BY A.'+@USE_COLUMN+', B.COUNTRY,INCOTERMS																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ) LIST																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																													' +CHAR(10);
					--print @mSubQuery
					--exec (@mSubQuery)


				  --SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' UPDATE '+@TABLE_NAME+'																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '    SET '+@TABLE_NAME+'.INCOTERMS	= B.INCOTERMS_TOBE											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '  FROM .'+@TABLE_NAME+' AS A, 																	' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + ' (																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' SELECT OLD_VALUE1 AS '+@USE_COLUMN+'															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '      , OLD_VALUE2 AS COUNTRY																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , OLD_VALUE3 AS INCOTERMS 																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , NEW_VALUE1 AS INCOTERMS_TOBE 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' FROM NERP_CONV_SCP_DATA 																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' WHERE COLUMN_NAME1=''CONV_INCOTERMS'' 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' and TABLE_NAME = '''+@TABLE_NAME+'''															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' ) AS B																							' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' WHERE A.'+@USE_COLUMN+' = B.'+@USE_COLUMN+'														' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS = B.INCOTERMS																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'')' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																							' +CHAR(10);
					print @mSubQuery
					--exec (@mSubQuery)	

					SET @MAPPING_RESULT = 'Y';	
					END 


				-- 사용안함
				ELSE IF @USE_COLUMN = 'FROM_SITE_OLD'
				BEGIN
				

					SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' 	INSERT INTO NERP_CONV_SCP_DATA																						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( TABLE_NAME																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3, COLUMN_NAME4, COLUMN_NAME5												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	, NEW_VALUE1																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	)																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   '''+@TABLE_NAME+'''																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,''CONV_INCOTERMS'', ''FROM_SITE'',''COUNTRY'',''INCOTERMS''	,''CNT''											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   ,FROM_SITE, COUNTRY, INCOTERMS, CNT																				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	,  CASE WHEN INCOTERMS IN (''A01'', ''DDU'', ''FAC'', ''ZS3'', ''Z03'', ''Z04'')	THEN ''DAP''					' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''A02'', ''S32'', ''S33'')					THEN ''EXW''								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''DAT'')										THEN ''DPU''								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY = ''KR'' AND INCOTERMS IN (''Z01'')					THEN ''EXW''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY = ''KR'' AND INCOTERMS IN (''Z02'')					THEN ''DAP''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY != ''KR'' AND INCOTERMS IN (''Z01'')					THEN ''DAP''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN COUNTRY != ''KR'' AND INCOTERMS IN (''Z02'')					THEN ''EXW''							' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN (FROM_SITE LIKE ''A%'' OR FROM_SITE LIKE ''F%'') AND INCOTERMS IN (''Z01'') THEN ''EXW''				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN (FROM_SITE LIKE ''A%'' OR FROM_SITE LIKE ''F%'') AND INCOTERMS IN (''Z02'') THEN ''DAP''				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN (FROM_SITE NOT LIKE ''A%'' AND FROM_SITE NOT LIKE ''F%'') AND INCOTERMS IN (''Z01'') THEN ''DAP''		' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' 			WHEN (FROM_SITE NOT LIKE ''A%'' AND FROM_SITE NOT LIKE ''F%'') AND INCOTERMS IN (''Z02'') THEN ''EXW''		' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '				WHEN INCOTERMS IN (''Z01'') THEN ''DAP''																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			WHEN INCOTERMS IN (''Z02'') THEN ''EXW''																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 			ELSE INCOTERMS																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 		END  INCOTERMS_TOBE																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	FROM 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	( 																													' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	select 																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	   FROM_SITE																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , B.COUNTRY AS COUNTRY																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , INCOTERMS																										' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , COUNT(*) AS CNT																									' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 FROM '+@TABLE_NAME+' A with (nolock)																				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 LEFT JOIN (  SELECT OLD_VALUE1 as scm_site_id, OLD_VALUE2 as country from NERP_CONV_MASTER  WHERE CODETYPE = ''SCP_INCOTERMS'' AND ATTRIBUTE5 = ''1ST''  ) B ON A.FROM_SITE = B.scm_site_id						' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 WHERE INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'') 					' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 GROUP BY FROM_SITE,B.COUNTRY,INCOTERMS																				' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ) LIST																												' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																													' +CHAR(10);
					--print @mSubQuery
					--exec (@mSubQuery)


				  --SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + ' UPDATE '+@TABLE_NAME+'																			' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '    SET '+@TABLE_NAME+'.INCOTERMS	= B.INCOTERMS_TOBE											' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '  FROM .'+@TABLE_NAME+' AS A, 																	' +CHAR(10);
		  			SET @mSubQuery = @mSubQuery + ' (																								' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' SELECT OLD_VALUE1 AS from_site																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '      , OLD_VALUE2 AS COUNTRY																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , OLD_VALUE3 AS INCOTERMS 																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 , NEW_VALUE1 AS INCOTERMS_TOBE 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' FROM NERP_CONV_SCP_DATA 																		' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' WHERE COLUMN_NAME1=''CONV_INCOTERMS'' 															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' and TABLE_NAME = '''+@TABLE_NAME+'''															' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' ) AS B																							' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + ' WHERE A.FROM_SITE = B.FROM_SITE																	' +CHAR(10);	
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS = B.INCOTERMS																	' +CHAR(10);
					SET @mSubQuery = @mSubQuery + '   and A.INCOTERMS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = ''INCOTERMS_ID'')' +CHAR(10);
					SET @mSubQuery = @mSubQuery + ' 	 ;																							' +CHAR(10);
					print @mSubQuery
					--exec (@mSubQuery)		
					
					SET @MAPPING_RESULT = 'Y';																															
				END	

				-- SCM_MST_PROJECT		NO_MATCH  (작업대상은 ONLY DAT = 현상태 유지)
				-- SCM_MST_PROJECT_H	NO_MATCH  (작업대상은 ONLY DAT = 현상태 유지)
				ELSE 
					BEGIN 
					SET @mSubQuery = ''
					SET @mSubQuery = @mSubQuery + N' NO_MATCH  (작업대상은 ONLY DAT = 현상태 유지)	' +CHAR(10);

					PRINT @mSubQuery
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'CONV INCOTERMS 제외', 0, @TABLE_NAME, @mSubQuery, @START_TIME;

					SET @mSubQuery = ''
					SET @MAPPING_RESULT = 'Y';	
					END

				print '------------------------------------------------------------------------'
				--print @mSubQuery
					

			SET @RUN = 'Y'	
			IF @RUN = 'Y' AND @MAPPING_RESULT = 'Y'	
			BEGIN
				  exec (@mSubQuery)
				--####################################################
				-- Result
				--####################################################
			    
					SET @MAPPING_TIME = datediff(second, @START_TIME, getdate() );

					UPDATE ZNERP_DEV_ITEM_SCHEDULE 
					SET  MAPPING_START = @START_TIME 
						, MAPPING_END = getdate() 
						, MAPPING_TIME = @MAPPING_TIME
						, mapping_query = @mSubQuery
						, check_query = @@trancount
						--, mapping_comment = 'FINISH'
						, STATUS = 'FINISH'	
						, UPDATE_USER = 'NERP_BATCH_INCOTERMS'
					WHERE program_id = @TABLE_NAME
					and dev_detail = @COLUMN_NAME 
					and mapping_column = 'INCOTERMS'
					and mapping_use = 'IC'

					print concat(@@trancount, ' , ', @@trancount)
					EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @MAPPING_TIME, @COLUMN_NAME, @mSubQuery, @d_event_date;
			END

		FETCH NEXT FROM CURSOR_BATCH
		INTO @TABLE_NAME, @COLUMN_NAME, @USE_COLUMN,@CNT;
		END

			CLOSE CURSOR_BATCH;
			DEALLOCATE CURSOR_BATCH;

			PRINT 'END'	
			SET @MAPPING_TIME = datediff(second, @BATCH_START_TIME, getdate() );
			SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);	
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'END', @MAPPING_TIME, '0', '', @START_TIME;


	
END TRY
BEGIN CATCH
		SET @CNT = @@ROWCOUNT;
		SET @WORK_SECOND = ERROR_NUMBER();
		SET @v_description = ERROR_MESSAGE();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;

		print  ERROR_MESSAGE();
END CATCH
	
END
