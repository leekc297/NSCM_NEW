
/*
 * Program ID   : PR_DM_PLN_MKT_FCST_LASTEST_MEASURE
 * Description  : MKT FCST Latest Measure Create
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 01. 03    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_LASTEST_MEASURE]
	@p_DIVISION_ID     NVARCHAR(MAX)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    DECLARE  @v_DIVISION_ID             NVARCHAR(MAX);
    DECLARE  @v_PROJECT_CODE            NVARCHAR(MAX);
    DECLARE  @v_SCM_SITE_ID             NVARCHAR(MAX);
    DECLARE  @v_ITEM_ID                 NVARCHAR(MAX);
    DECLARE  @v_DOM_EXP                 NVARCHAR(MAX);
    DECLARE  @v_FCST_TYPE               NVARCHAR(MAX);
    DECLARE  @v_INCOTERMS               NVARCHAR(MAX);
    DECLARE  @v_MEASURE                 NVARCHAR(MAX);
    DECLARE  @v_YYYYMMDD                NVARCHAR(MAX);


	-- recv init
    SET  @v_DIVISION_ID   =  NULL;
    SET  @v_PROJECT_CODE  =  NULL;
    SET  @v_SCM_SITE_ID   =  NULL;
    SET  @v_ITEM_ID       =  NULL;
    SET  @v_DOM_EXP       =  NULL;
    SET  @v_FCST_TYPE     =  NULL;
    SET  @v_INCOTERMS     =  NULL;
    SET  @v_MEASURE       =  NULL;
    SET  @v_YYYYMMDD      =  NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_LASTEST_MEASURE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_cur_monday   NVARCHAR(8) = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

      /* DELETE */
	  -- (2) 
	  BEGIN
		  DELETE 
			FROM  dbo.DM_PLN_MKT_FCST
			  WHERE 1=1
				AND  DIVISION_ID   =  @p_DIVISION_ID 
				AND  MEASURE       in ('MKT_FCST_LATEST','CUST_FCST_LATEST')
				AND  YYYYMMDD       >=  @v_cur_monday

		--select @v_cur_monday as v_cur_monday   
	  END;
	  -- (2) 
    
      /* INSERT */
	  -- (3) 
	  BEGIN
    	INSERT  INTO  dbo.DM_PLN_MKT_FCST
          	(
             DIVISION_ID      ,PROJECT_CODE      ,SCM_SITE_ID
            ,ITEM_ID          ,DOM_EXP           ,FCST_TYPE
            ,INCOTERMS        ,PLANT_SITE_ID ,MEASURE           ,YYYYMMDD
            ,QTY              ,CREATED_BY        ,CREATION_DATE
            ,LAST_UPDATED_BY  ,LAST_UPDATE_DATE
    	    ,attribute1, attribute2, attribute3, attribute4, attribute5
    	    ,attribute6, attribute7, attribute8, attribute9, attribute10
            )
    	SELECT 
             DIVISION_ID      ,PROJECT_CODE      ,SCM_SITE_ID
            ,ITEM_ID          ,DOM_EXP           ,FCST_TYPE
            ,INCOTERMS        ,PLANT_SITE_ID 
			--,'MKT_FCST_LATEST' AS MEASURE 
			,CASE WHEN MEASURE =  'MKT_FCST' THEN  'MKT_FCST_LATEST'  ELSE 'CUST_FCST_LATEST' END AS MEASURE       
			,YYYYMMDD
            ,QTY              ,CREATED_BY        ,CREATION_DATE
            ,LAST_UPDATED_BY  ,SYSDATETIME() as LAST_UPDATE_DATE
    	    ,attribute1, attribute2, attribute3, attribute4, attribute5
    	    ,attribute6, attribute7, attribute8, attribute9, attribute10
    	FROM  dbo.DM_PLN_MKT_FCST  WITH  (NOLOCK)  
      	WHERE 1 = 1
            AND  DIVISION_ID   =  @p_DIVISION_ID 
			AND  MEASURE         in ( 'MKT_FCST',  'CUST_FCST' )
            AND  YYYYMMDD       >=  @v_cur_monday
	  END;
	  -- (3) 

     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION;
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

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
