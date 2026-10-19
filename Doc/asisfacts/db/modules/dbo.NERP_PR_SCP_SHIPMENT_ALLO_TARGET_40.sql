


 /*      
 * Program ID  : [NERP_PR_SCP_SHIPMENT_ALLO_TARGET_40]      
 * Description  :  Model Allocation을 위한 결과 데이터 수집
 * Execute      : 
 				 
				 EXEC [dbo].[PR_SCP_SHIPMENT_ALLO_TARGET_40]
						@P_DIVISION_ID = N'40',
						@P_CUTOFF_YYYYMMDD = N'20211220'

 * Program History      
 *===================================================================================================      
 *   Date		In Charge	Description      
 *===================================================================================================      
 * 2021/12/27	HJ.LEE		Initial Release  [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) 
 * 2022/03/21   LWY		    [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - Process 및 데이타 정합성 보정
 * 2022/07/05   KSG		    [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Request Qty 보정
 * 2023/01/16   hrkim		[PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - cutoff 기준 당월 PLAN 생성 로직 변경
 *							전주 cutoff 기준 당월 Plan 수량 
 *							 - 
 *						    당주 cutoff 기준 전주기간 실적 중 당월 수량 (전주 기간이 2022/11/28~2022/12/04인 경우 2022/12/01~2022/12/04 기간의 실적) 
 * 2023/01/18   hrkim		[PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Request Qty 보정 로직 변경
							- Allo Target Request 화면 To의 Qty(ToBe) 값으로 plan 수량 보정 (SCP_ANL_ALLO_TARGET_REQUEST.ATTRIBUTE1) 
 * 2024.01.25   vadabi3     NERP - 특정 Company 별도 처리 개선
 * 2024.05.27	vadabi5	    NERP) QA, 개발 DB 적용
 ----------------------------------------------------------------------------------------------------
 EXEC NERP_PR_SCP_SHIPMENT_ALLO_TARGET_40 
   @P_DIVISION_ID='40'
 , @P_CUTOFF_YYYYMMDD=NULL


 EXEC PR_SCP_SHIPMENT_ALLO_TARGET_40 
   @P_DIVISION_ID='40'
 , @P_CUTOFF_YYYYMMDD=NULL

 */

CREATE PROCEDURE [dbo].[NERP_PR_SCP_SHIPMENT_ALLO_TARGET_40]  
	@P_DIVISION_ID		        NVARCHAR(30) = '40',
	@P_CUTOFF_YYYYMMDD			NVARCHAR(8) = NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	IF ISNULL(@P_CUTOFF_YYYYMMDD, '') = ''
	   SET @P_CUTOFF_YYYYMMDD =  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD

    DECLARE @V_FROM_YYYYMMDD AS NVARCHAR(8) = SUBSTRING(@P_CUTOFF_YYYYMMDD,1,4) + '0101';
	DECLARE @CUTOFF_YYYYMMDD  AS NVARCHAR(8) = @P_CUTOFF_YYYYMMDD;

	DECLARE @LAST_CUTOFF_YYYYMMDD  AS NVARCHAR(8); -- 최근 CUTOFF일자
	DECLARE @DEBUG_MODE AS NVARCHAR(8) = 'F';

	DECLARE @BP_FLAG AS NVARCHAR(8) = 'Y';
	DECLARE @VERSION_NO AS NVARCHAR(100);
	
    DECLARE @V_BP_YEAR AS NVARCHAR(4) = SUBSTRING(CONVERT(CHAR(8), DATEADD(YYYY, 0, convert(datetime,@V_FROM_YYYYMMDD)), 112),1,4);
    DECLARE @V_BP_YYYYMM AS NVARCHAR(6); -- 현재일 기준 18개월 뒤???
	DECLARE @V_CUR_YYYYMM AS NVARCHAR(6); -- 현재월
	DECLARE @V_LAST_YYYYMM AS NVARCHAR(6); -- 지난주 월
		

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_SHIPMENT_ALLO_TARGET_40'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N''; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '#[PR_SCP_SHIPMENT_ALLO_TARGET_40]#### Start of procedure #';     
    SET @v_description = @p_division_id + ' : ' + @V_FROM_YYYYMMDD + ' : ' + @P_CUTOFF_YYYYMMDD  ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
	
	
	-- 시작 LOG  (END)

    -- @P_TO_YYYYMMDD 기준 최근 월요일 구하기    -- TYPE = 'PLAN'의  CUTOFF_YYYYMMDD로 사용
	SELECT @CUTOFF_YYYYMMDD = MAX(C.BASIS_YYYYMMDD)       
         	 -- , MAX(DATEPART(WEEKDAY, BASIS_YYYYMMDD)) AS DAYIDX
	FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK)
	 WHERE C.BASIS_YYYYMMDD <= @P_CUTOFF_YYYYMMDD
	     AND C.BASIS_YYYYMMDD <= CONVERT(VARCHAR, GETDATE(), 112)
	     AND DATEPART(WEEKDAY, C.BASIS_YYYYMMDD) = 2 --1:SUN, 2:MON	

     -- 최근(지난주) Cutoff일자 구하기
     SELECT @LAST_CUTOFF_YYYYMMDD = ISNULL(MAX(CUTOFF_YYYYMMDD),@CUTOFF_YYYYMMDD)
	    FROM SCP_ANL_ALLO_TARGET WITH(NOLOCK)
	  WHERE DIVISION_ID = @P_DIVISION_ID
	      AND CUTOFF_YYYYMMDD < @CUTOFF_YYYYMMDD
	      AND TYPE = 'RESULT'


		  --select * from SCP_ANL_ALLO_TARGET
		  -- order by cutoff_yyyymmdd desc


    -- (LAST)CUTOFF 기준 월계산
	SELECT @V_BP_YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 18, DATEADD(DAY,0,convert(datetime,@CUTOFF_YYYYMMDD))), 112),1,6), -- 현재월 18개월뒤
	            @V_CUR_YYYYMM = SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, DATEADD(DAY,0,convert(datetime,@CUTOFF_YYYYMMDD))), 112),1,6), --Cutoff기준 현재월
				@V_LAST_YYYYMM= SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, 0, DATEADD(DAY,0,convert(datetime,@LAST_CUTOFF_YYYYMMDD))), 112),1,6); --Last_Cutoff기준 현재월
							
	BEGIN
		PRINT '----------------------------------';
		PRINT '@V_FROM_YYYYMMDD =' +@V_FROM_YYYYMMDD;
		PRINT '@CUTOFF_YYYYMMDD =' +@CUTOFF_YYYYMMDD;
		PRINT '@LAST_CUTOFF_YYYYMMDD =' +@LAST_CUTOFF_YYYYMMDD;
		PRINT '@V_BP_YEAR ='  +@V_BP_YEAR;
		PRINT '@V_BP_YYYYMM ='+@V_BP_YYYYMM;		
		PRINT '@V_CUR_YYYYMM ='+@V_CUR_YYYYMM;
		PRINT '@V_LAST_YYYYMM ='+@V_LAST_YYYYMM;
		PRINT '----------------------------------';
	END;

	BEGIN TRY
		BEGIN


		---------------------------------------------------------------------------------------------------------
		--팀별 출하 실적생성 (ERP) : 주단위로 생성
		---------------------------------------------------------------------------------------------------------
		--
		
		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT1') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT1;

		-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
			SELECT E.DIVISION_ID AS DIVISION_ID
					,[PLAN_START_YYYYMMDD]
					,[PLAN_TYPE]
					,[SEQ]
				   ,SC.FROM_SITE AS SCM_SITE_ID,
				   ISNULL((SELECT TOP 1 SITE_DESCRIPTION FROM SCM_MST_SITE WHERE 1=1 AND SCM_SITE_ID = SC.FROM_SITE),'-') AS SCM_SITE_NAME,
				   (SELECT TOP 1 ISNULL(NULLIF(SCP_EXTRA_SPEC, ''),'-') FROM DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) WHERE 1=1 AND X.DIVISION_ID = E.DIVISION_ID AND X.ITEM_ID = E.ITEM_ID) AS EXTRA_SPEC,
				   (SELECT TOP 1 ISNULL(NULLIF(NICK_NAME, ''), '-') FROM DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) WHERE 1=1 AND X.ITEM_ID = E.ITEM_ID) AS NICK_NAME,
				   E.ITEM_ID,
				   ISNULL(SUI.DEPT_ID, LMD.ATTRIBUTE1) AS DEPT_ID,
				   ISNULL(ISNULL(SDI.DEPT_NAME_KO, LMD.ATTRIBUTE2), SMS.SITE_DESCRIPTION) AS DEPT_NAME,
				   E.EXFACTORY_DATE AS YYYYMMDD,
				   SUM(E.EXFACTORY_QTY) AS QTY,
				   'RESULT_CE' AS PLAN_FROM,
				   'RESULT' AS TYPE,
				   E.CONFIRM_ID
			INTO #TMP_SCP0055_RESULT1
			FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
				 INNER JOIN SSP_ANL_SHIP_CONFIRM SC WITH (NOLOCK) ON E.DIVISION_ID = SC.DIVISION_ID AND E.CONFIRM_ID = SC.CONFIRM_ID --AND E.EXFACTORY_DATE = SC.YYYYMMDD 
				 JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) ON F.ITEM_ID = E.ITEM_ID 
														   AND F.DIVISION_ID = E.DIVISION_ID
														   AND F.CELL_TYPE_GROUP_CODE = 'C'    --2021.12.14
														   AND F.OPERATION_GROUP = 'A'             --2021.12.14
				 JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
	 																 AND L.VALID_YN = 'Y'
																	 AND L.SEGMENT1    = E.SSP_TYPE 
				 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK) ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
																				 AND L3.SEGMENT1    = E.DIVISION_ID 
																				 AND L3.SEGMENT2    = E.SOLDTO_CODE
																				 AND L3.SEGMENT3    = E.SHIPTO_CODE
				 LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SUI WITH (NOLOCK) ON (
																			 SELECT TOP 1 MSI.OWNER
																	  		   FROM SCM_MST_SITE_ITEM MSI WITH (NOLOCK)
																			  WHERE MSI.DIVISION_ID = E.DIVISION_ID
																				AND MSI.SCM_SITE_ID = ISNULL(L3.SEGMENT4, SC.TO_SITE)
											                        			AND MSI.ITEM_ID = E.ITEM_ID
											                         			AND MSI.VALID_YN = 'Y'
																			) = SUI.USER_ID
				 LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO SDI WITH (NOLOCK) ON SUI.DEPT_ID = SDI.DEPT_ID 
																			AND SDI.VALID_YN ='Y'
				 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH (NOLOCK) ON E.FROM_SCM_SITE_ID = LMD.SEGMENT1 
																				   AND ISNULL(L3.SEGMENT4, SC.TO_SITE) = LMD.SEGMENT2 
																				   AND E.ITEM_ID = LMD.SEGMENT3 
																				   AND LMD.LOOKUP_TYPE = 'SHIPMENT_REPORT_LOOKUP'
				 LEFT OUTER JOIN SCM_MST_SITE SMS WITH (NOLOCK) ON 1=1
																   AND E.DIVISION_ID = SMS.DIVISION_ID
																   AND SC.TO_SITE = SMS.SCM_SITE_ID 
																   AND SMS.OSP_YN = 'Y' 
																   AND SMS.VALID_YN = 'Y'
			WHERE 1=1
			  AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			  AND E.CONFIRM_ID LIKE 'C%'
			  AND E.DIVISION_ID = @P_DIVISION_ID
 			  AND E.EXFACTORY_DATE >= convert(datetime, @V_FROM_YYYYMMDD)
			  AND E.EXFACTORY_DATE < convert(datetime, @CUTOFF_YYYYMMDD)
		  	GROUP BY E.DIVISION_ID
					 ,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					 ,SC.FROM_SITE,
					 E.ITEM_ID,
					 ISNULL(SUI.DEPT_ID, LMD.ATTRIBUTE1),
					 --SUI.DEPT_ID,
					 SDI.DEPT_NAME_KO,
					 LMD.ATTRIBUTE2,
					 SMS.SITE_DESCRIPTION,
    				 E.EXFACTORY_DATE,
					 E.CONFIRM_ID;
		
		   

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT2') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT2;

			-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
			SELECT E.DIVISION_ID AS DIVISION_ID
				   ,E.FROM_SCM_SITE_ID AS SCM_SITE_ID
				   ,ISNULL((SELECT TOP 1 SITE_DESCRIPTION FROM SCM_MST_SITE WHERE 1=1 AND SCM_SITE_ID = E.FROM_SCM_SITE_ID),'-') AS SCM_SITE_NAME,
				   (SELECT TOP 1 ISNULL(NULLIF(SCP_EXTRA_SPEC, ''),'-') FROM DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) WHERE 1=1 AND X.DIVISION_ID = E.DIVISION_ID AND X.ITEM_ID = E.ITEM_ID) AS EXTRA_SPEC,
				   (SELECT TOP 1 ISNULL(NULLIF(NICK_NAME, ''), '-') FROM DBO.SCM_MST_ITEM_SN X WITH(NOLOCK) WHERE 1=1 AND X.ITEM_ID = E.ITEM_ID) AS NICK_NAME,
				   E.ITEM_ID,
				   ISNULL(SUI.DEPT_ID, LMD.ATTRIBUTE1) AS DEPT_ID,
				   ISNULL(ISNULL(SDI.DEPT_NAME_KO, LMD.ATTRIBUTE2), SMS.SITE_DESCRIPTION) AS DEPT_NAME,
				   E.EXFACTORY_DATE AS YYYYMMDD,
				   SUM(E.EXFACTORY_QTY) AS QTY,
				   'RESULT_CN' AS PLAN_FROM
				   ,'RESULT' AS  TYPE
			INTO #TMP_SCP0055_RESULT2
			FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
				 -- SCP 대상 ITEM만 
				 JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) ON F.ITEM_ID = E.ITEM_ID 
															AND F.DIVISION_ID = E.DIVISION_ID
															AND F.CELL_TYPE_GROUP_CODE = 'C'    --2021.12.14
														    AND F.OPERATION_GROUP = 'A'             --2021.12.14
				 JOIN SCM_MST_SITE FS WITH(NOLOCK) ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
														AND FS.DIVISION_ID = E.DIVISION_ID 
				 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK) ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
																				 AND L3.SEGMENT1    = E.DIVISION_ID 
																				 AND L3.SEGMENT2    = E.SOLDTO_CODE
																				 AND L3.SEGMENT3    = E.SHIPTO_CODE
				 LEFT OUTER JOIN SCM_MST_SSO_USER_INFO SUI WITH (NOLOCK) ON (
																			 SELECT TOP 1 MSI.OWNER
																	  		   FROM SCM_MST_SITE_ITEM MSI WITH (NOLOCK)
																				  WHERE MSI.DIVISION_ID = E.DIVISION_ID
																				AND MSI.SCM_SITE_ID = ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)
											                        			AND MSI.ITEM_ID = E.ITEM_ID
											                         			AND MSI.VALID_YN = 'Y'
																			) = SUI.USER_ID
				 LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO SDI WITH (NOLOCK) ON SUI.DEPT_ID = SDI.DEPT_ID 
																			AND SDI.VALID_YN ='Y'
				 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH (NOLOCK) ON E.FROM_SCM_SITE_ID = LMD.SEGMENT1
																				   AND ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) = LMD.SEGMENT2
																				   AND E.ITEM_ID = LMD.SEGMENT3 
																				   AND LMD.LOOKUP_TYPE = 'SHIPMENT_REPORT_LOOKUP'
				 LEFT OUTER JOIN SCM_MST_SITE SMS WITH (NOLOCK) ON 1=1
																   AND E.DIVISION_ID = SMS.DIVISION_ID
																   AND E.FROM_SCM_SITE_ID = SMS.SCM_SITE_ID 
																   AND SMS.OSP_YN = 'Y' 
																   AND SMS.VALID_YN = 'Y'
			WHERE 1=1
			  AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			  AND ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
			  AND E.STORAGE_ID NOT IN (
			                           -- 상품창고제외) 6000, 799A
									   SELECT SEGMENT2 
									     FROM SCM_CODE_LOOKUP_VALUE 
									    WHERE LOOKUP_TYPE_CODE = 'PR_SCP_SHIPMENT_ALLO_TARGET_40' 
									      AND SEGMENT1 = 'STORAGE_ID'
										  ) 
			 AND E.STORAGE_ID NOT IN ( SELECT SEGMENT1 
							   			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
										 WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
										   AND VALID_YN = 'Y'
									  ) -- 사외 창고 제외 LOOKUP 관리
			  AND E.ORDER_TYPE_CODE NOT IN ( SELECT SEGMENT1 
											   FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
											  WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE'
													AND VALID_YN = 'Y'
										   ) -- ERP오더타입 제외 LOOKUP 관리
			  AND E.DIVISION_ID = @P_DIVISION_ID
 			  AND  E.EXFACTORY_DATE			>= convert(datetime, @V_FROM_YYYYMMDD)
		      AND  E.EXFACTORY_DATE		   <    convert(datetime,  @CUTOFF_YYYYMMDD) 
		GROUP BY E.DIVISION_ID,
					 E.FROM_SCM_SITE_ID,
					 E.ITEM_ID,
					 ISNULL(SUI.DEPT_ID, LMD.ATTRIBUTE1),
					 SDI.DEPT_NAME_KO,
					 LMD.ATTRIBUTE2,
					 SMS.SITE_DESCRIPTION,
    				 E.EXFACTORY_DATE;

	
		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT11') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT11;

		SELECT F.DIVISION_ID 
				   ,F.SCM_SITE_ID
				   ,F.SCM_SITE_NAME
				   ,F.EXTRA_SPEC
				   ,F.NICK_NAME
				   ,F.ITEM_ID 
				   ,F.DEPT_ID
				   ,F.DEPT_NAME
				   ,F.YYYYMMDD
				   ,SUM(F.QTY) AS QTY
				   ,'RESULT_TOTAL' AS PLAN_FROM
				   ,TYPE
		 	 INTO #TMP_SCP0055_RESULT11
			FROM #TMP_SCP0055_RESULT1 F WITH (NOLOCK)
			GROUP BY F.DIVISION_ID,
					 F.NICK_NAME,
					 F.ITEM_ID, 
					 F.SCM_SITE_ID,
					 F.SCM_SITE_NAME,
					 F.EXTRA_SPEC,
					 F.DEPT_ID,
					 F.DEPT_NAME,
					 F.YYYYMMDD,
					 TYPE
			ORDER BY F.DIVISION_ID,
					 F.NICK_NAME,
					 F.SCM_SITE_ID,
					 F.SCM_SITE_NAME,
					 F.EXTRA_SPEC,
					 F.DEPT_ID,
					 F.DEPT_NAME,
					 F.YYYYMMDD;

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT22') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT22;

		SELECT F.DIVISION_ID 
				   ,F.SCM_SITE_ID
				   ,F.SCM_SITE_NAME
				   ,F.EXTRA_SPEC
				   ,F.NICK_NAME
				   ,F.ITEM_ID 
				   ,F.DEPT_ID
				   ,F.DEPT_NAME
				   ,F.YYYYMMDD
				   ,SUM(F.QTY) AS QTY
				   ,'RESULT_TOTAL' AS PLAN_FROM
				   ,TYPE
			INTO #TMP_SCP0055_RESULT22
			FROM #TMP_SCP0055_RESULT2 F WITH (NOLOCK)
			GROUP BY F.DIVISION_ID,
					 F.NICK_NAME,
					 F.ITEM_ID, 
					 F.SCM_SITE_ID,
					 F.SCM_SITE_NAME,
					 F.EXTRA_SPEC,
					 F.DEPT_ID,
					 F.DEPT_NAME,
					 F.YYYYMMDD,
					 TYPE
			ORDER BY F.DIVISION_ID,
					 F.NICK_NAME,
					 F.SCM_SITE_ID,
					 F.SCM_SITE_NAME,
					 F.EXTRA_SPEC,
					 F.DEPT_ID,
					 F.DEPT_NAME,
					 F.YYYYMMDD;

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT3') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT3;


		SELECT * INTO #TMP_SCP0055_RESULT3 FROM (
			SELECT * FROM #TMP_SCP0055_RESULT11
			UNION ALL
			SELECT * FROM #TMP_SCP0055_RESULT22
		) AS TEMP;

	 BEGIN TRAN
 	 WHILE (1=1)
 	 BEGIN
 	 DELETE  TOP(1000)[DBO].[SCP_ANL_ALLO_TARGET]
	  WHERE [DIVISION_ID] =@P_DIVISION_ID
		  AND CUTOFF_YYYYMMDD = @CUTOFF_YYYYMMDD
    		
 	 		IF @@ROWCOUNT = 0 BREAK;
 	 END
 	 COMMIT 
	  
	  

	  BEGIN TRAN
	  BEGIN
      -- RESULT
	  INSERT INTO [DBO].[SCP_ANL_ALLO_TARGET]
					   (DIVISION_ID
					   ,TYPE
					   ,CUTOFF_YYYYMMDD
					   ,YYYY
					   ,YYYYQQ
					   ,YYYYMM
					   ,YYYYMMDD
					   ,ITEM_ID
					   ,DEPT_ID
					   ,DEPT_NAME
					   ,QTY
					   ,NICK_NAME
					   ,EXTRA_SPEC
					   ,SCM_SITE_ID
					   ,SCM_SITE_NAME
					   ,ATTRIBUTE1  -- 20220705 [PJ20216994] Request Qty 보정용 Org Qty
					   )           
					  (
					SELECT      DISTINCT
					            [DIVISION_ID]  
							   ,'RESULT' AS TYPE
							   ,@CUTOFF_YYYYMMDD    -- @P_TO_YYYYMMDD 기준 최근 월요일
							   , SUBSTRING(YYYYMMDD,1,4) AS YYYY
							   , SUBSTRING(YYYYMMDD,1,4) + 'Q'+ CONVERT(NVARCHAR(1), DATEPART(QQ, CONVERT(DATETIME, SUBSTRING(YYYYMMDD,1,6) + '01'))) AS YYYYQQ
							   , SUBSTRING(YYYYMMDD,1,6) AS YYYYMM
							   ,YYYYMMDD AS YYYYMMDD
							   ,ITEM_ID
							   ,(CASE WHEN DEPT_ID = '' THEN NULL ELSE DEPT_ID END) AS DEPT_ID
							   ,NULL AS DEPT_NAME	
							   ,QTY
							   ,NICK_NAME						  
							   ,EXTRA_SPEC
							   ,NULL AS SCM_SITE_ID 
							   ,NULL AS SCM_SITE_NAME 
							   ,QTY  AS ATTRIBUTE1 -- 20220705 [PJ20216994] Request Qty 보정용 Org Qty
				     FROM #TMP_SCP0055_RESULT3 WITH (NOLOCK) 
				 WHERE YYYYMMDD < @CUTOFF_YYYYMMDD
				 )

      END
	  COMMIT
				
		/* 
			- 주단위 CUTOFF 시점에 현재월에는 이전주 PLAN + 이전주 실적 - 이번주 실적 으로 주차별 수정 대상 데이터 생성
			- 주단위 CUTOFF 시점에 이후월에는 기존 PLAN을 복사 
		*/				   

				--1. 주단위 CUTOFF 시점에 현재월에는 "전주(실적+PLAN) - 당월실적" 으로 주차별 수정 대상 데이터 생성 
				BEGIN TRAN
				INSERT INTO [dbo].[SCP_ANL_ALLO_TARGET]
						   (
							DIVISION_ID
						   ,TYPE
						   ,CUTOFF_YYYYMMDD
						   ,YYYY
						   ,YYYYQQ
						   ,YYYYMM
						   ,ITEM_ID
						   ,DEPT_ID
						   ,DEPT_NAME
						   ,QTY
						   ,NICK_NAME
						   ,EXTRA_SPEC
						   ,SCM_SITE_ID
						   ,SCM_SITE_NAME
					       ,ATTRIBUTE1  -- 20220705 [PJ20216994] Request Qty 보정용 Org Qty
						   )   
						   (
							 SELECT   
									    DIVISION_ID
									   ,'PLAN'
									   ,@CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
								       , SUBSTRING(@V_CUR_YYYYMM,1,4) AS YYYY
							           , SUBSTRING(@V_CUR_YYYYMM,1,4) + 'Q'+ CONVERT(NVARCHAR(1), DATEPART(QQ, CONVERT(DATETIME, SUBSTRING(@V_CUR_YYYYMM,1,6) + '01'))) AS YYYYQQ
							           , @V_CUR_YYYYMM AS YYYYMM
									   ,ITEM_ID
									   ,DEPT_ID
									   ,DEPT_NAME
									   -- 20230116 변경전 [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - cutoff 기준 당월 PLAN 생성 로직 변경 ,ISNULL(SUM(LAST_RESULT_QTY),0) + ISNULL(SUM(LAST_PLAN_QTY),0)  - ISNULL(SUM(RESULT_QTY),0) AS PLAN_QTY 
									   ,ISNULL(SUM(LAST_PLAN_QTY),0)  - ISNULL(SUM(RESULT_QTY),0) AS PLAN_QTY 
									   ,NICK_NAME
									   ,EXTRA_SPEC
									   ,MAX(SCM_SITE_ID) AS SCM_SITE_ID
									   ,MAX(SCM_SITE_NAME) AS SCM_SITE_NAME
					                   -- 20230116 변경전 [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - cutoff 기준 당월 PLAN 생성 로직 변경 ,ISNULL(SUM(LAST_RESULT_QTY),0) + ISNULL(SUM(LAST_PLAN_QTY),0)  - ISNULL(SUM(RESULT_QTY),0) AS ATTRIBUTE1  -- 20220705 [PJ20216994] Request Qty 보정용 Org Qty
					                   ,ISNULL(SUM(LAST_PLAN_QTY),0)  - ISNULL(SUM(RESULT_QTY),0) AS ATTRIBUTE1  -- 20220705 [PJ20216994] Request Qty 보정용 Org Qty
							 FROM 
									 (  
								/* 20230116 주석처리 : [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - cutoff 기준 당월 PLAN 생성 로직 변경
								-	 --지난실적(누적)
								-	 SELECT      DISTINCT
								-	             DIVISION_ID
								-			   , @CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD											
								-			   ,ITEM_ID
								-			   ,(CASE WHEN DEPT_ID = '' THEN NULL ELSE DEPT_ID END) AS DEPT_ID
								-			   ,DEPT_NAME
								-			   ,QTY AS LAST_RESULT_QTY     -- 지난 실적
								-			   ,0   AS LAST_PLAN_QTY       -- 지난주 PLAN
								-			   ,0   AS RESULT_QTY          -- 당원 실적
								-			   ,NICK_NAME
								-			   ,EXTRA_SPEC
								-			   ,SCM_SITE_ID
								-			   ,SCM_SITE_NAME
								-	   FROM SCP_ANL_ALLO_TARGET WITH(NOLOCK)
								-	 WHERE 1=1 						
								-		AND DIVISION_ID = @P_DIVISION_ID
								-		AND TYPE = 'RESULT'			
								-		AND CUTOFF_YYYYMMDD = @LAST_CUTOFF_YYYYMMDD -- @LAST_CUTOFF_YYYYMMDD 2021.10.25 누적 실적?
								-	    AND YYYYMMDD < @LAST_CUTOFF_YYYYMMDD        -- @LAST_CUTOFF_YYYYMMDD
								-		AND YYYYMM BETWEEN @V_BP_YEAR + '01' AND @V_BP_YYYYMM 
								-   
								-   UNION  ALL
								*/ 
								
								    --지난주 cutoff 기준 당월(당주 cutoff기준 당월) 계획 (cutoff date ~ 말일까지의 plan 수량) 
								   SELECT    
								             -- 20230116 주석처리 DISTINCT
										     DIVISION_ID
											,@CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD											 
											,ITEM_ID
											,(CASE WHEN DEPT_ID = '' THEN NULL ELSE DEPT_ID END) AS DEPT_ID
											,DEPT_NAME
											,0   AS LAST_RESULT_QTY      -- 지난 실적
											,QTY AS LAST_PLAN_QTY        -- 지난주 PLAN
											,0   AS RESULT_QTY           --  당원 실적
											,NICK_NAME
											,EXTRA_SPEC
											,SCM_SITE_ID
											,SCM_SITE_NAME
									   FROM SCP_ANL_ALLO_TARGET WITH(NOLOCK)
									 WHERE 1=1 						
										AND DIVISION_ID		= @P_DIVISION_ID
										AND TYPE			= 'PLAN'	
										AND CUTOFF_YYYYMMDD = @LAST_CUTOFF_YYYYMMDD		
										AND YYYYMM			= @V_CUR_YYYYMM -- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - cutoff 기준 당월 PLAN 생성 로직 변경 (@V_LAST_YYYYMM -> @V_CUR_YYYYMM)
								
									UNION  ALL
									
									-- 당월 실적
									SELECT      -- 20230116 주석처리 DISTINCT
									            DIVISION_ID 
											   ,@CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD											
											   ,ITEM_ID
											   ,(CASE WHEN DEPT_ID = '' THEN NULL ELSE DEPT_ID END) AS DEPT_ID
											   ,DEPT_NAME
											   ,0   AS LAST_RESULT_QTY     -- 지난 실적
											   ,0   AS LAST_PLAN_QTY       -- 지난주 PLAN
											   ,QTY AS RESULT_QTY          -- 당원 실적
											   ,NICK_NAME
											   ,EXTRA_SPEC
											   ,SCM_SITE_ID
											   ,SCM_SITE_NAME
									   FROM SCP_ANL_ALLO_TARGET WITH(NOLOCK)
									 WHERE 1=1 						
										AND DIVISION_ID = @P_DIVISION_ID
										AND TYPE = 'RESULT'
										AND CUTOFF_YYYYMMDD = @CUTOFF_YYYYMMDD
										AND YYYYMM			= @V_CUR_YYYYMM			-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - cutoff 기준 당월 PLAN 생성 로직 변경 (조건추가)
										AND YYYYMMDD	   >= @LAST_CUTOFF_YYYYMMDD	-- [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - cutoff 기준 당월 PLAN 생성 로직 변경 (조건추가)
										AND YYYYMMDD	   <  @CUTOFF_YYYYMMDD
										) A
							GROUP BY DIVISION_ID 									
									,ITEM_ID
									,DEPT_ID
									,DEPT_NAME
									,NICK_NAME
									,EXTRA_SPEC
					  )
				  	 
				COMMIT;
					
				BEGIN TRAN
				-- 주단위 CUTOFF 시점에 이후 월에는 PLAN값을 그대로 넘김 
				INSERT INTO [dbo].[SCP_ANL_ALLO_TARGET]
					   (DIVISION_ID
					   ,TYPE
					   ,CUTOFF_YYYYMMDD
					   ,YYYY
					   ,YYYYQQ
					   ,YYYYMM
					   ,YYYYMMDD
					   ,ITEM_ID
					   ,DEPT_ID
					   ,DEPT_NAME
					   ,QTY
					   ,NICK_NAME
					   ,EXTRA_SPEC
					   ,SCM_SITE_ID
					   ,SCM_SITE_NAME
					   ,ATTRIBUTE1  -- 20220705 [PJ20216994] Request Qty 보정용 Org Qty
					   )   
					   (
						SELECT   DIVISION_ID
								,'PLAN' AS TYPE
								, @CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
								,YYYY
								--,YYYYQQ
								,SUBSTRING(YYYYMM,1,4) + 'Q'+ CONVERT(NVARCHAR(1), DATEPART(QQ, CONVERT(DATETIME, SUBSTRING(YYYYMM,1,6) + '01'))) AS YYYYQQ
								,YYYYMM
								,YYYYMMDD
								,ITEM_ID
								,(CASE WHEN DEPT_ID = '' THEN NULL ELSE DEPT_ID END) AS DEPT_ID
								,DEPT_NAME
								,QTY
								,NICK_NAME
								,EXTRA_SPEC
								,SCM_SITE_ID
								,SCM_SITE_NAME
							    ,QTY  AS ATTRIBUTE1 -- 20220705 [PJ20216994] Request Qty 보정용 Org Qty
						   FROM SCP_ANL_ALLO_TARGET WITH(NOLOCK)
						 WHERE 1=1 						
							AND DIVISION_ID = @P_DIVISION_ID
							AND TYPE = 'PLAN'
							AND CUTOFF_YYYYMMDD = @LAST_CUTOFF_YYYYMMDD
							AND YYYYMM > @V_CUR_YYYYMM		 
						 ) 
                 COMMIT;
				 
		/*	20230118 [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Request Qty 보정 로직 변경	 
        ------------------------------------------------------------------------------------------------------------
        -- 20220705 [PJ20216994] Request Qty 보정
        ------------------------------------------------------------------------------------------------------------
        --------------------------------------------
        -- 1. From Qty 빼기
        --------------------------------------------
        UPDATE SCP_ANL_ALLO_TARGET
        SET    qty = CONVERT(NUMERIC, ISNULL(a.attribute1, '0')) + ISNULL((-1) * m.from_qty, 0)
             , last_updated_by = 'Minus Request From Qty'
        FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK) 

        JOIN SCP_ANL_ALLO_TARGET_REQUEST m with(nolock)
        ON  a.cutoff_yyyymmdd = m.cutoff_yyyymmdd
        AND a.dept_id         = m.from_dept_id
        AND a.item_id         = m.from_item_id
        AND a.yyyymm          = m.from_yyyymm
        AND m.confirm         = 'Y'
	  
        WHERE  a.division_id     = @P_DIVISION_ID
        AND    a.cutoff_yyyymmdd = @CUTOFF_YYYYMMDD
        AND    a.type            = 'PLAN'
	  
        --------------------------------------------
        -- 2. To Qty 더하기
        --------------------------------------------
        UPDATE SCP_ANL_ALLO_TARGET
        SET    qty = CONVERT(NUMERIC, ISNULL(a.attribute1, '0')) + ISNULL(p.to_qty, 0)
             , last_updated_by = 'Plus Request To Qty'
        FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK) 

        JOIN SCP_ANL_ALLO_TARGET_REQUEST p with(nolock)
        ON  a.cutoff_yyyymmdd = p.cutoff_yyyymmdd
        AND a.dept_id         = p.to_dept_id
        AND a.item_id         = p.to_item_id
        AND a.yyyymm          = p.to_yyyymm
        AND p.confirm         = 'Y'
	  
        WHERE  a.division_id     = @P_DIVISION_ID
        AND    a.cutoff_yyyymmdd = @CUTOFF_YYYYMMDD
        AND    a.type            = 'PLAN'		
		*/

        ------------------------------------------------------------------------------------------------------------
		-- 20230118 [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Request Qty 보정 로직 변경
		-- Request To Qty(ToBe)로 updadte
        ------------------------------------------------------------------------------------------------------------
        UPDATE SCP_ANL_ALLO_TARGET
        SET    qty = CONVERT(NUMERIC, ISNULL(p.attribute1, '0'))
             , last_updated_by = 'Update Request To Qty(ToBe)'
        FROM   SCP_ANL_ALLO_TARGET A WITH(NOLOCK) 
			   JOIN SCP_ANL_ALLO_TARGET_REQUEST p with(nolock)
				   ON  a.cutoff_yyyymmdd = p.cutoff_yyyymmdd
				   AND a.dept_id         = p.to_dept_id
				   AND a.item_id         = p.to_item_id
				   AND a.yyyymm          = p.to_yyyymm
				   AND p.confirm         = 'Y'
        WHERE  a.division_id     = @P_DIVISION_ID
        AND    a.cutoff_yyyymmdd = @CUTOFF_YYYYMMDD
        AND    a.type            = 'PLAN'	
		

		-- 임시 테이블 삭제

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT1') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT1;

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT2') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT2;

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT3') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT3;

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT11') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT11;

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT22') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT22;

		IF OBJECT_ID('tempdb..#TMP_SCP0055_RESULT3') IS NOT NULL
			DROP TABLE #TMP_SCP0055_RESULT3;

		END;
     END TRY

     BEGIN CATCH                  
    --  IF @@TRANCOUNT > 0                  
    --    BEGIN                  
    --      ROLLBACK                   
    --END;                  
                        
      -- ERROR LOG                  
      SET @v_log_type = N'ERROR';                  
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
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
	   PRINT @v_log_message      + ' : ' + @v_description           
      return -1                  
    END CATCH;   

    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'PR_SCP_SHIPMENT_ALLO_TARGET_40 END of procedure ##########';                  
    SET @v_description = N'['  + @v_exec_time + ']';             
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
                  
    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
    END; 

END
