
/*
 * Program ID   : PR_DM_BMW_EDI_TO_MKT_FCST
 * Description  : BMW EDI 정보 -> DM_PLN_MKT_FCST 테이블에 QTY INSERT Procedure
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2018.06.08   KHSONG         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * ---------------------------------------------------------------------------------------------------
 * 1. XIF_ERP_EDI_UNLOADING_POINT_R     => DM_MST_EDI_UNLOADING_POINT       
 * 2. XIF_ERP_EDI_CUST_MATERIAL_INFO_R  => DM_MST_EDI_CUST_MATERIAL_INFO
 * 3. XIF_ERP_EDI_CALL_OFF_SCHEDULE_R   => DM_DNM_EDI_CALL_OFF_SCHEDULE
 * 4. XIF_ERP_EDI_CALL_OFF_HEAD_R       => DM_DNM_EDI_CALL_OFF_HEAD
 *    DM_ 4개의 테이블에서 => DM_PLN_MKT_FCST 테이블로 정보 생성
 * 20180702 khsong valid='Y' 조건 추가
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * ---------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_DM_BMW_EDI_TO_MKT_FCST]

	-- Add the parameters for the stored procedure here
	-- @p_division_id			NVARCHAR(MAX)   -- division_id 전달받음
	--,@p_ver_return_no		NVARCHAR(MAX)   -- ver_return_no 전달받음

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_BMW_EDI_TO_MKT_FCST';
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
		BEGIN TRANSACTION PR_DM_BMW_EDI_TO_MKT_FCST;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		BEGIN
			-- I/F 테이블에 INSERT 처리
			SELECT a.DOC_ISSUE_DATE, a.unloading_point, a.BUYER_PART_NUMBER, a.PURCHASE_ORDER_NUMBE, a.CURRENT_CALL_OFF_DATE, a.BACKORDER_QTY, a.CUMULATIVE_QTY_RECEIVED, a.cumulative_qty_ordered
				  ,b.SCHEDULING_CONDITION, b.TOBE_DELIVERED_QTY
				  ,case when b.scheduling_condition = 24 THEN REQ_DELIVERY_DATE ELSE ISNULL( SCHEDULING_START_DATE, b.earliest_deliverY_date  ) END start_date 
				  ,case when b.scheduling_condition = 24 THEN REQ_DELIVERY_DATE ELSE ISNULL( SCHEDULING_END_DATE, b.LAST_DELIVERY_DATE ) END end_date
				  ,(
					--SELECT distinct w.item_id 
					SELECT top 1  w.item_id -- 20180906
						FROM [dbo].DM_MST_EDI_CUST_MATERIAL_INFO w WITH(NOLOCK)
						where w.customer_item_id = a.BUYER_PART_NUMBER
						  and VALID_YN = 'Y'  -- 20180702 khsong added
						  and company_id = a.company_id  -- 20180702 khsong added
				   ) ITEM_ID 
				   ,(
					--SELECT distinct w.SHIPTO_CODE
					SELECT top 1 w.SHIPTO_CODE -- 20180906
						FROM [dbo].DM_MST_EDI_UNLOADING_POINT w WITH(NOLOCK)
						where w.UNLOAD_POINT_ID = a.unloading_point
						  and VALID_YN = 'Y'  -- 20180702 khsong added
				   ) SHIPTO_CODE

			 INTO #BMW_EDI_01  -- TEMP 1번 TABLE에 저장
			  FROM [dbo].DM_DNM_EDI_CALL_OFF_HEAD a WITH(NOLOCK)
				  ,[dbo].DM_DNM_EDI_CALL_OFF_SCHEDULE b WITH(NOLOCK)
			 where a.doc_identifiner = (select max(x.doc_identifiner) from [DM_DNM_EDI_CALL_OFF_HEAD] x WITH(NOLOCK) where a.PURCHASE_ORDER_NUMBE = x.PURCHASE_ORDER_NUMBE)
			   and a.doc_identifiner = b.doc_identifiner
			   and b.SCHEDULING_CONDITION in ( 4, 24 ) -- 24번이 납입 지시
			   and a.VALID_YN = 'Y'  -- 20180702 khsong added
			   and b.VALID_YN = 'Y'  -- 20180702 khsong added
			;
			
		-- YYYYMMDD 기준 GROUP BY SUM
		SELECT unloading_point,start_date,ITEM_ID,SHIPTO_CODE,SUM(CONVERT(INT,  CAST(TOBE_DELIVERED_QTY AS NVARCHAR(10)))) AS QTY
		INTO #BMW_EDI_02  -- TEMP 2번 TABLE에 저장
			FROM #BMW_EDI_01 
		GROUP BY unloading_point,start_date,ITEM_ID,SHIPTO_CODE
		
		-- PROJECT_CODE,SCM_SITE_ID,DOM_EXP,MEASURE,PLANT_SITE_ID 추출
		SELECT '81' AS DIVISION_ID
			,(select max(PROJECT_CODE) from SCM_MST_PROJECT_ITEM PJT WITH(NOLOCK) where PJT.DIVISION_ID = '81' AND  PJT.ITEM_ID =  A.ITEM_ID AND VALID_YN='Y') AS PROJECT_CODE
			,(select max(SCM_SITE_ID) from SCM_MST_SITE_CUSTOMER CST WITH(NOLOCK) where CST.DIVISION_ID = '81' AND  CST.SHIPTO_CODE =  A.SHIPTO_CODE AND VALID_YN='Y') AS SCM_SITE_ID
			,A.ITEM_ID
			,'E' AS DOM_EXP
			,'CUST_FCST' AS MEASURE
			,'' AS PLANT_SITE_ID
			,A.start_date AS YYYYMMDD
			,A.QTY
		 INTO #BMW_EDI_03  -- TEMP 3번 TABLE에 저장
		 FROM #BMW_EDI_02 A
		 
		-- 
         SELECT A.DIVISION_ID
			,A.PROJECT_CODE
			,A.SCM_SITE_ID
			,A.ITEM_ID
			,A.DOM_EXP
			,B.FCST_TYPE
			,B.INCOTERMS
			,A.MEASURE
			,B.PLANT_SITE_ID
			,A.YYYYMMDD
			,A.QTY
			,'EDI_INTERFACE' AS CREATED_BY
			,GETDATE() AS CREATION_DATE
			,'EDI_INTERFACE' AS LAST_UPDATED_BY
			,GETDATE() AS LAST_UPDATE_DATE
			INTO #BMW_EDI_04  -- 최종 DATA TEMP TABLE에 저장
		   FROM #BMW_EDI_03 A  -- DM_PLN_MKT_FCST 테이블의 기준정보 추출
		       ,(
				SELECT --TOP 1 
				distinct FCST.DIVISION_ID, FCST.PROJECT_CODE,FCST.SCM_SITE_ID,FCST.ITEM_ID,FCST.DOM_EXP,FCST.FCST_TYPE,FCST.INCOTERMS, FCST.PLANT_SITE_ID
				   FROM [dbo].DM_PLN_MKT_FCST FCST WITH(NOLOCK)
					INNER JOIN #BMW_EDI_03 EDI
						ON  FCST.DIVISION_ID	= EDI.DIVISION_ID
						AND FCST.PROJECT_CODE	= EDI.PROJECT_CODE
						AND FCST.SCM_SITE_ID	= EDI.SCM_SITE_ID
						AND FCST.ITEM_ID		= EDI.ITEM_ID
                        AND FCST.YYYYMMDD		>= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이후 데이터 
						AND FCST.MEASURE		= 'MKT_FCST'
						AND FCST.qty			> 0
				) B
           WHERE A.DIVISION_ID	= B.DIVISION_ID
						AND A.PROJECT_CODE	= B.PROJECT_CODE
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID
						AND A.ITEM_ID		= B.ITEM_ID

			-- MKT_FCST TABLE 중복삭제
			DELETE
				FROM  [dbo].DM_PLN_MKT_FCST
                  WHERE (
						SELECT count(1) 
						  FROM #BMW_EDI_04 B   -- 최종 DATA TEMP TABLE
						 where  1=1
						   and  DM_PLN_MKT_FCST.DIVISION_ID        =  B.DIVISION_ID
						   and  DM_PLN_MKT_FCST.SCM_SITE_ID        =  B.SCM_SITE_ID                         
						   and  DM_PLN_MKT_FCST.PROJECT_CODE       =  B.PROJECT_CODE                         
						   and  DM_PLN_MKT_FCST.ITEM_ID            =  B.ITEM_ID                         
						   and  DM_PLN_MKT_FCST.DOM_EXP            =  B.DOM_EXP                         
						   and  DM_PLN_MKT_FCST.FCST_TYPE          =  B.FCST_TYPE                         
						   and  DM_PLN_MKT_FCST.INCOTERMS          =  B.INCOTERMS                         
						   and  DM_PLN_MKT_FCST.PLANT_SITE_ID      =  B.PLANT_SITE_ID                         
						   and  DM_PLN_MKT_FCST.MEASURE            =  B.MEASURE                       
						   --and  DM_PLN_MKT_FCST.YYYYMMDD           =  B.YYYYMMDD
						   and DM_PLN_MKT_FCST.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이후 데이터 
				  ) > 0

			-- MKT_FCST TABLE INSERT
			INSERT  INTO  [dbo].DM_PLN_MKT_FCST
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
				,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2
				,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
			SELECT 
				DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID
				,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
			FROM #BMW_EDI_04  -- 최종 DATA TEMP TABLE
			  where YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이후 데이터


		END
  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION PR_DM_BMW_EDI_TO_MKT_FCST;

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
    --  IF @v_log_message IS NULL
	--  SELECT 'success'

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
