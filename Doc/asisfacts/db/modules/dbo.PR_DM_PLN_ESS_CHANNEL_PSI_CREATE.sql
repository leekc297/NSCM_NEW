
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : PR_DM_PLN_ESS_CHANNEL_PSI_CREATE
 * Description  : Dynamic DQ_TEXT Register Batch (INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 03. 05    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20181204 KHSONG scm_dnm_delivery_tracking.COMPANY_ID 컬럼 추가반영	
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2020.12.17	hwi1993		[C20201217-000126] ESS 판매법인 VMI inventory 수신 프로세스 수정
2022.04.05   hwi1993     GM JV 작업
 *  2024.03.12	P.C.I			[PJ20228272] NERP 하드코딩 대응 및 개선
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_ESS_CHANNEL_PSI_CREATE]

	-- Add the parameters for the stored procedure here
	--@p_active_flag              NVARCHAR(MAX),    

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_ESS_CHANNEL_PSI_CREATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION PR_DM_PLN_ESS_CHANNEL_PSI_CREATE;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
	BEGIN
	
		-- temp table 생성 ------------------------------------------------  (START)
		BEGIN
		IF  OBJECT_ID(N'dbo.TEMP_ESS_CHANNEL_PSI$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE dbo.TEMP_ESS_CHANNEL_PSI$
			END;

		SELECT * INTO dbo.TEMP_ESS_CHANNEL_PSI$
			FROM dbo.DM_PLN_ESS_CHANNEL_PSI WITH(NOLOCK) where division_id = 'x';
		END
		-- temp table 생성 ------------------------------------------------  (END)

		-- TEMP INSERT ----------------------------------------------------------  (START)
		BEGIN
		INSERT INTO  dbo.TEMP_ESS_CHANNEL_PSI$
					(DIVISION_ID      ,  
					SCM_SITE_ID      ,
					ITEM_ID          ,
					MEASURE          ,
					YYYYMMDD         ,
					VALUE            ,
					CREATED_BY       ,
					CREATION_DATE    ,
					LAST_UPDATED_BY  ,
					LAST_UPDATE_DATE ,
					ATTRIBUTE1       ,
					ATTRIBUTE2       ,
					ATTRIBUTE3       ,
					ATTRIBUTE4       ,
					ATTRIBUTE5       ,
					ATTRIBUTE6       ,
					ATTRIBUTE7       ,
					ATTRIBUTE8       ,
					ATTRIBUTE9       ,
					ATTRIBUTE10
					)
			SELECT *
			FROM (
					select		'82' AS DIVISION,
								'LGCEG_DE_MWA' AS SALES_SITE_ID,
								ITEM_ID,
								'P' AS MEASURE, 
								case when f_dest_ata_date = '' then F_DEST_ETA_DATE 
																else f_dest_ata_date end AS YYYYMMDD,
								SUM(delivery_qty) VALUE,
								'ESS_PSI_BATCH'		AS CREATE_USER,    ---BATCH PROCESS 이름 ,
								GETDATE()	AS CREATE_DATE,
								'ESS_PSI_BATCH' AS LAST_UPDATE_USER,    ---BATCH PROCESS 이름 
								GETDATE()	AS LAST_UPDATE_DATE,
								null		AS ATTR1,
								null		AS ATTR2,
								null		AS ATTR3,
								null		AS ATTR4,
								null		AS ATTR5,
								null		AS ATTR6,
								null		AS ATTR7,
								null		AS ATTR8,
								null		AS ATTR9,
								null		AS ATTR10
						from	(    
									  SELECT		di.item_id						,
													di.delivery_qty					,
													dt.shipping_date				,
													dt.f_dest_eta_date				,
													dt.f_dest_ata_date				 
									  FROM			scm_dnm_intransit di WITH(NOLOCK)
									  LEFT JOIN		(
															SELECT	t.shipment_no,t.COMPANY_ID	,  -- 20181204 KHSONG scm_dnm_delivery_tracking.COMPANY_ID 컬럼 추가반영								
																	max(t.shipping_date) shipping_date				,
																	max(t.f_dest_eta_date) f_dest_eta_date			,
																	max(t.f_dest_ata_date) f_dest_ata_date
															FROM	scm_dnm_delivery_tracking t WITH(NOLOCK)
															WHERE	len(t.pol_atd_date) > 0
															GROUP BY t.shipment_no, t.COMPANY_ID  -- 20181204 KHSONG scm_dnm_delivery_tracking.COMPANY_ID 컬럼 추가반영		
													) dt 
									  ON     di.shipment_no = dt.shipment_no
									  AND di.COMPANY_ID = dt.COMPANY_ID  -- 20181204 KHSONG scm_dnm_delivery_tracking.COMPANY_ID 컬럼 추가반영
									  --WHERE  di.CUSTOMER_CODE = 'G690'					----CEG 법인 
									  WHERE  di.CUSTOMER_CODE IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_ESS_CHANNEL_PSI_CREATE', 'CUSTOMER_CODE')) --[PJ20228272] NERP 대응
								) x    
						where	x.SHIPPING_DATE is not null    
						--20231215 [SM] 구문오류로 구문변경, 원소스 주석처리하고 하단의 NOT EXISTS 구문으로 처리
						/*
						  and	(    
								  select distinct b.ITEM_TYPE    
									from  [dbo].[SCM_MST_ITEM_SN] b  WITH(NOLOCK)
								   where b.ITEM_ID = x.item_id    
									 and b.DIVISION_ID = '82'  
								) <> 'R'    
								*/
						and not exists ( select 1
										  from   [dbo].[SCM_MST_ITEM_SN] b  WITH(NOLOCK)
										  where b.ITEM_ID = x.item_id    
											and b.DIVISION_ID = '82'
											and b.item_type = 'R'
										)
					group by	ITEM_ID, 
								case when f_dest_ata_date = ''	then F_DEST_ETA_DATE 
																else f_dest_ata_date end
			) AS MEASURE_P

			UNION ALL

			SELECT *
			FROM (
					SELECT		'82' AS DIVISION,
								'LGCEG_DE_MWA' AS SALES_SITE_ID,
								ITEM_ID,
								'I' AS MEASURE, 
								RESULT_DATE AS YYYYMMDD,
								qty VALUE,
								'ESS_PSI_BATCH'		AS CREATE_USER,    ---BATCH PROCESS 이름 ,
								GETDATE()	AS CREATE_DATE,
								'ESS_PSI_BATCH' AS LAST_UPDATE_USER,    ---BATCH PROCESS 이름 
								GETDATE()	AS LAST_UPDATE_DATE,
								null		AS ATTR1,
								null		AS ATTR2,
								null		AS ATTR3,
								null		AS ATTR4,
								null		AS ATTR5,
								null		AS ATTR6,
								null		AS ATTR7,
								null		AS ATTR8,
								null		AS ATTR9,
								null		AS ATTR10
					FROM		[dbo].[SCM_DNM_STOCK_SALES] a	WITH(NOLOCK)				
					--where		STORAGE_ID = '6600'		-- [C20201217-000126]
					--AND			A.PLANT_ID = 'G690'
					where		STORAGE_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_ESS_CHANNEL_PSI_CREATE', 'STORAGE_ID')) --[PJ20228272] NERP 대응
					AND			A.PLANT_ID IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_ESS_CHANNEL_PSI_CREATE', 'PLANT_ID')) --[PJ20228272] NERP 대응
					AND			A.DIVISION_ID = '82'				
					--20231215 [SM] 구문오류로 구문변경, 원소스 주석처리하고 하단의 NOT EXISTS 구문으로 처리
					/*
					  and		(					
									select distinct b.ITEM_TYPE					
									  from   [dbo].[SCM_MST_ITEM_SN] b	WITH(NOLOCK)		
									 where  b.ITEM_ID = a.item_id					
									   and  b.DIVISION_ID = '82'			
								) <> 'R'		
					*/
					and not exists ( select 1
									 from   [dbo].[SCM_MST_ITEM_SN] b  WITH(NOLOCK)
									 where b.ITEM_ID = a.item_id	   
									 and b.DIVISION_ID = '82'
									 and b.item_type = 'R'
									)
			) AS MEASURE_I

			UNION ALL

			SELECT *
			FROM (				
					 SELECT		a.division_id AS DIVISION,
								a.SALES_SITE_ID AS SALES_SITE_ID,
								A.ITEM_ID,
								'S' AS MEASURE,
								A.YYYYMMDD AS YYYYMMDD,
								SUM(a.QTY) VALUE,
								'ESS_PSI_BATCH'		AS CREATE_USER,    ---BATCH PROCESS 이름 ,
								GETDATE()	AS CREATE_DATE,
								'ESS_PSI_BATCH' AS LAST_UPDATE_USER,    ---BATCH PROCESS 이름 
								GETDATE()	AS LAST_UPDATE_DATE,
								null		AS ATTR1,
								null		AS ATTR2,
								null		AS ATTR3,
								null		AS ATTR4,
								null		AS ATTR5,
								null		AS ATTR6,
								null		AS ATTR7,
								null		AS ATTR8,
								null		AS ATTR9,
								null		AS ATTR10
					  FROM		[DBO].DM_DNM_SALES_RESULT a WITH(NOLOCK) ,					
								 [dbo].[SCM_MST_ITEM_SN] b WITH(NOLOCK)					
					 where		a.SALES_SITE_ID = 'LGCEG_DE_MWA' 				
					   and		a.item_id = b.item_id 					
				--	   and		result_yyyymmdd = '20180227'					
					   and		b.item_type <> 'R'				
					   and      a.MEASURE = 'SALES_RESULT'	
					   and      a.division_id = '82'
					   and		a.item_id  in (					
												select distinct item_id
												  from [DBO].scm_dnm_intransit WITH(NOLOCK)
												 --where SHIPTO_CODE = 'G260'
												 where SHIPTO_CODE IN (SELECT CODE FROM [dbo].FN_LIST_LOOKUP_VALUE('PR_DM_PLN_ESS_CHANNEL_PSI_CREATE', 'SHIPTO_CODE')) --[PJ20228272] NERP 대응
												   and DIVISION_ID = '82'												   
												)					
					group by a.division_id, a.SALES_SITE_ID, a.ITEM_ID, a.YYYYMMDD			
 			) AS MEASURE_S	

		END
		-- INSERT ----------------------------------------------------------  (END)

		-- 정규 TABLE INSERT 전 중복삭제------------------------------------------------  (START)
		BEGIN

			DELETE
				FROM  dbo.DM_PLN_ESS_CHANNEL_PSI 
           WHERE (
                    SELECT count(1) 
					  FROM dbo.TEMP_ESS_CHANNEL_PSI$ B WITH(NOLOCK) WHERE 1=1
					    AND DM_PLN_ESS_CHANNEL_PSI.DIVISION_ID  = B.DIVISION_ID
					    AND DM_PLN_ESS_CHANNEL_PSI.SCM_SITE_ID  = B.SCM_SITE_ID
					    AND DM_PLN_ESS_CHANNEL_PSI.ITEM_ID		= B.ITEM_ID
					    AND DM_PLN_ESS_CHANNEL_PSI.MEASURE		= B.MEASURE
					    AND DM_PLN_ESS_CHANNEL_PSI.YYYYMMDD		= B.YYYYMMDD
				  ) > 0
		END
		-- 정규 TABLE INSERT 전 중복삭제------------------------------------------------  (END)

		-- 정규 TABLE INSERT ----------------------------------------------------------  (START)
		BEGIN
		
			INSERT  INTO dbo.DM_PLN_ESS_CHANNEL_PSI 
               SELECT *	  FROM dbo.TEMP_ESS_CHANNEL_PSI$ B WITH(NOLOCK)
		END
		-- 정규 TABLE INSERT ----------------------------------------------------------  (END)

		-- history TABLE INSERT ----------------------------------------------------------  (START)
		BEGIN

			SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_PLN_ESS_CHANNEL_PSI_H
			INSERT  INTO dbo.DM_PLN_ESS_CHANNEL_PSI_H 
					(
					DIVISION_ID      ,  
					HISTORY_SEQ      ,
					SCM_SITE_ID      ,
					ITEM_ID          ,
					MEASURE          ,
					YYYYMMDD         ,
					VALUE            ,
					CREATED_BY       ,
					CREATION_DATE    ,
					LAST_UPDATED_BY  ,
					LAST_UPDATE_DATE ,
					ATTRIBUTE1       ,
					ATTRIBUTE2       ,
					ATTRIBUTE3       ,
					ATTRIBUTE4       ,
					ATTRIBUTE5       ,
					ATTRIBUTE6       ,
					ATTRIBUTE7       ,
					ATTRIBUTE8       ,
					ATTRIBUTE9       ,
					ATTRIBUTE10
					)
               SELECT 
			   		
					DIVISION_ID      ,  
					@n_history_seq  AS HISTORY_SEQ    ,
					SCM_SITE_ID      ,
					ITEM_ID          ,
					MEASURE          ,
					YYYYMMDD         ,
					VALUE            ,
					CREATED_BY       ,
					CREATION_DATE    ,
					LAST_UPDATED_BY  ,
					LAST_UPDATE_DATE ,
					ATTRIBUTE1       ,
					ATTRIBUTE2       ,
					ATTRIBUTE3       ,
					ATTRIBUTE4       ,
					ATTRIBUTE5       ,
					ATTRIBUTE6       ,
					ATTRIBUTE7       ,
					ATTRIBUTE8       ,
					ATTRIBUTE9       ,
					ATTRIBUTE10
					
	  FROM dbo.TEMP_ESS_CHANNEL_PSI$ B WITH(NOLOCK)
		END
		-- history TABLE INSERT ----------------------------------------------------------  (END)

	END

	-- temp table 삭제 ------------------------------------------------  (START)
	BEGIN
		IF  OBJECT_ID(N'dbo.TEMP_ESS_CHANNEL_PSI$', N'U') IS NOT NULL 
			BEGIN
				DROP TABLE dbo.TEMP_ESS_CHANNEL_PSI$
			END;
	END
	-- temp table 삭제 ------------------------------------------------  (end)

        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION PR_DM_PLN_ESS_CHANNEL_PSI_CREATE;
      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

