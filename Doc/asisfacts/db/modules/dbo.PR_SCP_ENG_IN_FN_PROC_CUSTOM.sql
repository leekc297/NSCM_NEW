
/*
 * Program ID   : PR_SCP_ENG_IN_FN_PROC_CUSTOM
 * Description  : 엔진Custom(엔진후처리) 기능을 위한 엔진Custom 필드 생성                             
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.02.07   KKC         Initial Release
 * 2025.08.01   HRK			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경 
 */
CREATE PROCEDURE  [dbo].[PR_SCP_ENG_IN_FN_PROC_CUSTOM]
    ( @p_plan_cycle1  NVARCHAR(150)
    , @p_plan_name1   NVARCHAR(4000)
    , @p_plan_id1     NVARCHAR(4000)
    , @p_modeling_id1 NVARCHAR(4000)
    , @p_seq1         NVARCHAR(4000)
    , @p_plan_type1   NVARCHAR(4000)
    , @p_master_id1   NVARCHAR(4000)
    , @p_division_id1 NVARCHAR(30)
    , @p_engine_plan_id1 NVARCHAR(4000)   
    
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    DECLARE @p_plan_cycle  NVARCHAR(150)    = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)   = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)   = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)   = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)   = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)   = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)   = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)     = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;
    
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_IN_FN_PROC_CUSTOM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = '';
    DECLARE @d_event_date   DATETIME;

    -- DECLARE @v_division_id       NVARCHAR(30);
    DECLARE @d_plan_name         DATETIME = CONVERT(DATETIME,@p_plan_name);
    DECLARE @v_pet_date          NVARCHAR(8) ; -- Plan End Date
	DECLARE @v_add_pet_date      NVARCHAR(8) ; -- Add Plan End Date (2022.01.17 추가) 

	------------------------------------------------------------------------------------------------------------------
	-- [PJ20257329] Cell 완성 공정 하드 코딩 변경 (임시 테이블 변수)
	print  convert(varchar(30), getdate(), 121) + N' SCP Cell Final 공정 정보 - Cell Packaging/Assembly' 
	------------------------------------------------------------------------------------------------------------------
	 DECLARE @SCP_CELL_FINAL_OPERATION TABLE
	 (
		   OPERATION_ID					NVARCHAR(30)	NULL
	 )

	INSERT INTO @SCP_CELL_FINAL_OPERATION
	SELECT SEGMENT1 AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)
	 WHERE 1=1
	   AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
	   AND LK.SEGMENT3	  = 'A'	 -- 공정그룹 (Cell)
	   AND LK.ATTRIBUTE1  = 'Y'	 -- FInal Operation
	------------------------------------------------------------------------------------------------------------------


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        ------------------------------------------------------------
        --1. TH_ENG_CUSTOM.COLULMN 컬럼값 초기화
		------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1 START';
        SET @v_description = N'1. TH_ENG_CUSTOM.COLULMN 초기화' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		/* 초기화 */
		UPDATE A
		   SET A.ATTR01   = NULL
		  FROM TH_ENG_PLAN_INFO_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		UPDATE A
		   SET A.ATTR01   = NULL
		     , A.ATTR02   = NULL
		     , A.ATTR03   = NULL		    
		  FROM TH_ENG_SITE_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		;
		
		UPDATE A
		   SET A.ATTR01 = NULL
		     , A.ATTR02 = NULL
			 , A.ATTR03 = NULL
		  FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		UPDATE A
		   SET A.ATTR01   = NULL
		     , A.ATTR02   = NULL
		     , A.ATTR03   = NULL 
		  FROM TH_ENG_ITEM_BOD_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

		UPDATE A
		   SET A.ATTR01   = NULL
		     , A.ATTR02   = NULL
		     , A.ATTR03   = NULL		    
		  FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

        /**************************************************************
        2. ENG_CUSOM을 위한, 공통 컬럼 셋팅
		***************************************************************/
        ------------------------------------------------------------
        --TH_ENG_PLAN_INFO.ATTR01(DIVISION_ID) CUSTOM 컬럼값 설정
        ------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 2 START';
        SET @v_description = N'2. TH_ENG_PLAN_INFO.ATTR01(DIVISION_ID)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A 
		   SET A.ATTR01 = @p_division_id
		  FROM TH_ENG_PLAN_INFO_SN A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		;

        ------------------------------------------------------------
        --TH_ENG_SITE.CUSTOM_COLUMN ADD 컬럼값 설정
		--예시 : SITE_ID = A010-A~003
        --TH_ENG_SITE.ATTR01(LARGE_SITE_ID)  : A010 
		--TH_ENG_SITE.ATTR02(MIDIUM_SITE_ID) : 003 
		--TH_ENG_SITE.ATTR03(SMALL_SITE_ID)  : A 	
        ------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 START';
        SET @v_description = N'3. TH_ENG_SITE.CUSTOM_COLUMN ADD' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR01 = ISNULL(CASE WHEN A.SITE_GROUP = 'PLANT' THEN SUBSTRING(A.SITE_ID, 1, CHARINDEX('-',A.SITE_ID,1)-1)
									  ELSE A.SITE_ID
								  END, A.SITE_ID)
			 , A.ATTR02 = ISNULL(CASE WHEN A.SITE_GROUP = 'PLANT' THEN CASE WHEN A.DESCR = 'DUMMY' THEN '***'
	                                                                        ELSE SUBSTRING(A.SITE_ID, CHARINDEX('~',A.SITE_ID,1)+1,3)
													                   END	  
									  ELSE A.SITE_ID
								  END, A.SITE_ID) 
			 , A.ATTR03 = CASE WHEN A.SITE_GROUP = 'PLANT' THEN SUBSTRING(A.SITE_ID,CHARINDEX('-',A.SITE_ID,1)+1,1) 
			               END
		  FROM TH_ENG_SITE_SN A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		;

        ------------------------------------------------------------
        --TH_ENG_ITEM_ROUTE_SITE_SN.CUSTOM_COLUMN ADD 컬럼값 추가
        --TH_ENG_ITEM_ROUTE_SITE_SN.ATTR01(SMALL_SITE_ID)   : A / P (Cell Site / Pack Site 구분) 
        --TH_ENG_ITEM_ROUTE_SITE_SN.ATTR02(SHIFT_PLAN_TYPE) : 일정조정구분(EPST/LPST)
        --TH_ENG_ITEM_ROUTE_SITE_SN.ATTR03(OSP_YN)  : 외주 공정 여부
        ------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4 START';
        SET @v_description = N'4-1. TH_ENG_ITEM_ROUTE_SITE_SN.CUSTOM_COLUMN ADD' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR01  = B.ATTR03
			 , A.ATTR03  = CASE WHEN A.DESCR LIKE '%OSP%' THEN 'Y'
							    ELSE 'N'
						    END
		  FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
		  LEFT OUTER JOIN TH_ENG_SITE_SN B WITH(NOLOCK)
		   ON A.MASTER_ID = B.MASTER_ID
		  AND A.PLAN_ID   = B.PLAN_ID
		  AND A.SITE_ID   = B.SITE_ID
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		;

       /******************************************
		 TCO 공정(L/T공정)의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
        --TH_ENG_ITEM_ROUTE_SITE_SN.ATTR02(SHIFT_PLAN_TYPE) : 일정조정구분(EPST/LPST)
		--일정 조정 유형(SHIFT_PLAN_TYPE) : LPST (후공정 기준으로 일정조정)
		******************************************/
		SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4 START';
        SET @v_description = N'4-2. TH_ENG_ITEM_ROUTE_SITE_SN.ATTR02등(SHIFT_TYPE)(TCO아이템 기준) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		UPDATE A
		   SET A.ATTR02 = 'LPST'
		  FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.ROUTE_ID  LIKE 'F%'      --F공정(TCO 사내 LT 공정 조건)
		  AND A.SITE_ID   LIKE '%-A~002' --F공정(TCO 사내 LT 공정 조건)
		  /* TCO 아이템 Check하면, 누락되는 공정 발생하기 때문에, 주석처리
		  AND EXISTS (
						SELECT 'X'
						  FROM SCP_MST_FINAL_ITEM_V X WITH(NOLOCK)
						 WHERE X.TCO_CELL_YN = 'Y'
						   AND X.ITEM_ID     = A.ITEM_ID
					 )
		   */
		   AND EXISTS (SELECT 'X'
						FROM TH_ENG_OP_RES_GROUP_SN X WITH(NOLOCK)
						WHERE X.MASTER_ID = A.MASTER_ID
							AND X.PLAN_ID   = A.PLAN_ID 
							AND X.DESCR     = 'NO_CAPA'
							AND X.ITEM_ID   = A.ITEM_ID
							AND X.SITE_ID   = A.SITE_ID
						)
		;
        
        ------------------------------------------------------------
        --TH_ENG_RESOURCE_SN.CUSTOM_COLUMN ADD 컬럼값 추가
        --TH_ENG_RESOURCE_SN.ATTR01(CAPA_YN)  : CAPA RESOURCE 여부 
        --TH_ENG_RESOURCE_SN.ATTR02(SMALL_SITE_ID)  : A / P (Cell Site / Pack Site 구분) 
        ------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5 START';
        SET @v_description = N'5. TH_ENG_RESOURCE_SN.CUSTOM_COLUMN ADD ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR02          = B.ATTR03  --OPERATION_GROUP
			 , A.ATTR01          = CASE WHEN A.DESCR IN ('LINE_CAPA', 'OSP_L') THEN 'CAPA'
										ELSE 'NO_CAPA'
									END
		  FROM TH_ENG_RESOURCE_SN A WITH(NOLOCK)
		  LEFT OUTER JOIN TH_ENG_SITE_SN B WITH(NOLOCK)
		   ON A.MASTER_ID = B.MASTER_ID
		  AND A.PLAN_ID   = B.PLAN_ID
		  AND A.SITE_ID   = B.SITE_ID
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		;

		/**************************************************************
        TH_ENG_ITEM_BOD_SN CUSTOM COL 셋팅
		***************************************************************/
        ------------------------------------------------------------
        --TH_ENG_ITEM_BOD_SN.CUSTOM_COLUMN ADD 컬럼값 추가
        --TH_ENG_ITEM_BOD_SN.ATTR01(SHIPMENT_SPLIT_YN) : 분할출하공정여부 
        --TH_ENG_ITEM_BOD_SN.ATTR02(SHIPMENT_MERGE_YN) : 병합출하공정여부 
        --TH_ENG_ITEM_BOD_SN.ATTR01(SHIFT_PLAN_TYPE)   : 일정조정구분(EPST/LPST)
        ------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-1. TH_ENG_ITEM_BOD_SN.SHIPMENT_SPLIT_YN(Sales Site) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	    /******************************************
		최종 Sales Site BOD의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
		1)분할출하공정 대상여부(SHIPMENT_SPLIT_YN) : Y
		2)병합출하공정 대상여부(SHIPMENT_MERGE_YN) : Y
		3)일정 조정 유형(SHIFT_PLAN_TYPE) : LPST (납기일 기준으로)
		******************************************/
		WITH VW_TAGET_DATA AS (
								SELECT B.BOD_ID
									 , B.FROM_SITE_ID
									 , B.TO_SITE_ID
									 , A.ITEM_ID
								  FROM TH_ENG_ITEM_BOD_SN A  WITH(NOLOCK)
									 , TH_ENG_BOD_SN B WITH(NOLOCK)
								WHERE A.MASTER_ID = @p_master_id
								  AND A.PLAN_ID   = @p_engine_plan_id
								  AND B.MASTER_ID = A.MASTER_ID
								  AND B.PLAN_ID   = A.PLAN_ID
								  AND B.BOD_ID    = A.BOD_ID
								  AND EXISTS (SELECT 'X'
												FROM TH_ENG_NET_DEMAND_SN X WITH(NOLOCK)
											   WHERE X.MASTER_ID = A.MASTER_ID
												 AND X.PLAN_ID   = A.PLAN_ID
												 AND X.ITEM      = A.ITEM_ID
												)
								  /* SALES SITE인 BOD */				  
								  AND EXISTS (SELECT 'X'
												FROM TH_ENG_SITE_SN X WITH(NOLOCK)
											   WHERE X.MASTER_ID = A.MASTER_ID
												 AND X.PLAN_ID   = A.PLAN_ID
												 AND X.SITE_GROUP  = 'SALES'
												 AND X.SITE_ID   = B.TO_SITE_ID
											)
								)
		UPDATE A
		  SET A.ATTR01  = 'Y'
			, A.ATTR02  = 'Y'
			, A.ATTR03  = 'LPST'
		 FROM TH_ENG_ITEM_BOD_SN A
			, VW_TAGET_DATA      B
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.BOD_ID    = B.BOD_ID
		  AND A.ITEM_ID   = B.ITEM_ID
		;

       /*****************************
		PACK SITE
		*****************************/

        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-2. TH_ENG_ITEM_BOD_SN.SHIPMENT_SPLIT_YN등(Pack Site:~003) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	    /******************************************
		PACK 출하 공정의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
		1)분할출하공정 대상여부(SHIPMENT_SPLIT_YN) : Y
		2)병합출하공정 대상여부(SHIPMENT_MERGE_YN) : N
		3)일정 조정 유형(SHIFT_PLAN_TYPE) : EPST (전공정 기준으로 일정조정)
		******************************************/
		WITH VW_TAGET_DATA AS (
					SELECT B.BOD_ID
							, B.FROM_SITE_ID
							, B.TO_SITE_ID
							, A.ITEM_ID
						FROM TH_ENG_ITEM_BOD_SN A  WITH(NOLOCK)
							, TH_ENG_BOD_SN B       WITH(NOLOCK)
							, TH_ENG_SITE_SN C      WITH(NOLOCK)
					WHERE A.MASTER_ID = @p_master_id
						AND A.PLAN_ID   = @p_engine_plan_id
						AND B.MASTER_ID = A.MASTER_ID
						AND B.PLAN_ID   = A.PLAN_ID
						AND B.BOD_ID    = A.BOD_ID
						AND C.MASTER_ID = A.MASTER_ID
						AND C.PLAN_ID   = A.PLAN_ID
						AND C.SITE_ID   = B.FROM_SITE_ID
						AND C.ATTR03    = 'P'	
						AND C.ATTR02    = '***'
						AND B.TO_SITE_ID LIKE '%-P~003'  --PACK 출하공정
						/* SALES SITE가 아닌 경우 */
						AND EXISTS (SELECT 'X'
									FROM TH_ENG_NET_DEMAND_SN X WITH(NOLOCK)
									WHERE X.MASTER_ID = A.MASTER_ID
										AND X.PLAN_ID   = A.PLAN_ID
										AND X.ITEM      = A.ITEM_ID
									)
					)
		UPDATE A
		   SET A.ATTR01            = 'Y'
			 , A.ATTR02            = 'N'
			 , A.ATTR03            = 'EPST'  --전공정(CAPA)의 완성일자 기준으로 EPST
		  FROM TH_ENG_ITEM_BOD_SN A
			 , VW_TAGET_DATA      B
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		   AND A.BOD_ID    = B.BOD_ID
		   AND A.ITEM_ID   = B.ITEM_ID
		;

        
	    /******************************************
		PACK 5000 공정(L/T공정)의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
		1)일정 조정 유형(ATTR02 : SHIFT_PLAN_TYPE) : LPST (후공정 기준으로 일정조정)
		******************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-3. TH_ENG_ITEM_BOD_SN.ATTR03(SHIFT_TYPE)(Pack Site: P5000) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR02 = 'LPST'
		  FROM TH_ENG_ITEM_ROUTE_SITE_SN A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.ROUTE_ID  = 'P5000'
		  AND EXISTS (SELECT 'X'
						FROM TH_ENG_OP_RES_GROUP_SN X WITH(NOLOCK)
					   WHERE X.MASTER_ID = A.MASTER_ID
						 AND X.PLAN_ID   = A.PLAN_ID 
						 AND X.DESCR     = 'NO_CAPA'
						 AND X.ITEM_ID   = A.ITEM_ID
						 AND X.SITE_ID   = A.SITE_ID
					 )

		;

	    /******************************************
		PACK 이동 공정(Cell Site -> Pack Site)의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
		1)일정 조정 유형(SHIFT_PLAN_TYPE) : LPST (후공정 기준으로 일정조정)
		******************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-4. TH_ENG_ITEM_BOD_SN.ATTR03(SHIFT_TYPE)(Cell -> Pack) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		WITH VW_TAGET_DATA AS (
							SELECT B.BOD_ID
								 , B.FROM_SITE_ID
								 , B.TO_SITE_ID
								 , A.ITEM_ID
							  FROM TH_ENG_ITEM_BOD_SN A WITH(NOLOCK)
								 , TH_ENG_BOD_SN      B WITH(NOLOCK)
								 , TH_ENG_SITE_SN     C WITH(NOLOCK) --FROM SITE
								 , TH_ENG_SITE_SN     D WITH(NOLOCK) --TO   SITE
							 WHERE A.MASTER_ID = @p_master_id
							   AND A.PLAN_ID   = @p_engine_plan_id
							   AND B.MASTER_ID = A.MASTER_ID
							   AND B.PLAN_ID   = A.PLAN_ID
							   AND B.BOD_ID    = A.BOD_ID
							   AND C.MASTER_ID = A.MASTER_ID
							   AND C.PLAN_ID   = A.PLAN_ID
							   AND C.SITE_ID   = B.FROM_SITE_ID
							   AND C.ATTR03    = 'A'        --FROM SITE	
							   AND D.MASTER_ID = A.MASTER_ID
							   AND D.PLAN_ID   = A.PLAN_ID
							   AND D.SITE_ID   = B.TO_SITE_ID
							   AND D.ATTR03    = 'P'	    --TO SITE
							  )
		UPDATE A
		   SET A.ATTR03 = 'LPST'  --반제품 이동
		  FROM TH_ENG_ITEM_BOD_SN A
			 , VW_TAGET_DATA      B
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.BOD_ID    = B.BOD_ID
		  AND A.ITEM_ID   = B.ITEM_ID
		;

       /*****************************
		CELL SITE
		*****************************/
	    /******************************************
		1)CELL 출하공정의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
		--일정 조정 유형(SHIFT_PLAN_TYPE) : TCO 공정은 예외처리
		******************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-5. TH_ENG_ITEM_BOD_SN.ATTR03등(SHIFT_TYPE)(Cell Site : ~003) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	    WITH VW_TAGET_DATA AS (
					   SELECT B.BOD_ID
							, B.FROM_SITE_ID
							, B.TO_SITE_ID
							, A.ITEM_ID
							, C.ATTR02
						 FROM TH_ENG_ITEM_BOD_SN A  WITH(NOLOCK)
							, TH_ENG_BOD_SN B       WITH(NOLOCK)
							, TH_ENG_SITE_SN C      WITH(NOLOCK)
						WHERE A.MASTER_ID = @p_master_id
							AND A.PLAN_ID   = @p_engine_plan_id
							AND B.MASTER_ID = A.MASTER_ID
							AND B.PLAN_ID   = A.PLAN_ID
							AND B.BOD_ID    = A.BOD_ID
							AND C.MASTER_ID = A.MASTER_ID
							AND C.PLAN_ID   = A.PLAN_ID
							AND C.SITE_ID   = B.FROM_SITE_ID
							AND C.ATTR03    = 'A'	
							AND B.TO_SITE_ID LIKE '%-A~003'  --CELL 출하공정
						)
		UPDATE A
		   SET A.ATTR01  = 'Y'  --CELL BIZ의 분할출하여부 체크 
		     , A.ATTR03  = CASE WHEN B.ATTR02 = '***' THEN  'EPST'  --TCO 공정(-A~*** -> -A~003)
		                        ELSE 'LPST'  
						    END
		  FROM TH_ENG_ITEM_BOD_SN A
			 , VW_TAGET_DATA      B
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		   AND A.BOD_ID    = B.BOD_ID
		   AND A.ITEM_ID   = B.ITEM_ID
		;

	    /******************************************
		2)CELL 조립외 생산공정(TCO)의 ENG_CUSTOM 컬럼 셋팅
		--일정 조정 유형(SHIFT_PLAN_TYPE) : TCO 공정은 예외처리
		******************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-6. TH_ENG_ITEM_BOD_SN.ATTR03등(SHIFT_TYPE)(Cell Site : ~***) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	    WITH VW_TAGET_DATA AS (
					   SELECT B.BOD_ID
							, B.FROM_SITE_ID
							, B.TO_SITE_ID
							, A.ITEM_ID
							, C.ATTR02
						 FROM TH_ENG_ITEM_BOD_SN A  WITH(NOLOCK)
							, TH_ENG_BOD_SN B       WITH(NOLOCK)
							, TH_ENG_SITE_SN C      WITH(NOLOCK)  --FROM
						WHERE A.MASTER_ID = @p_master_id
							AND A.PLAN_ID   = @p_engine_plan_id
							AND B.MASTER_ID = A.MASTER_ID
							AND B.PLAN_ID   = A.PLAN_ID
							AND B.BOD_ID    = A.BOD_ID
							AND C.MASTER_ID = A.MASTER_ID
							AND C.PLAN_ID   = A.PLAN_ID
							AND C.SITE_ID   = B.FROM_SITE_ID
							AND C.ATTR03    = 'A'	
							AND B.TO_SITE_ID LIKE '%-A~***'  --CELL TCO 생산공정
						)
		UPDATE A
		   SET A.ATTR03  = CASE WHEN B.ATTR02 = '003' THEN  'LPST'  --TCO 공정(-A~003 -> -A~***)
		                        ELSE 'LPST'  
						    END
		  FROM TH_ENG_ITEM_BOD_SN A
			 , VW_TAGET_DATA      B
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		   AND A.BOD_ID    = B.BOD_ID
		   AND A.ITEM_ID   = B.ITEM_ID
		;

	    /******************************************
		3) 특성 공정 다음 공정의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
		--일정 조정 유형(SHIFT_PLAN_TYPE) : LPST (후공정 기준으로 일정조정)
		******************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-7. TH_ENG_ITEM_BOD_SN.ATTR03등(SHIFT_TYPE)(Cell Site : 002-> Pack) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		WITH VW_TAGET_DATA AS (
							   SELECT B.BOD_ID
									, B.FROM_SITE_ID
									, B.TO_SITE_ID
									, A.ITEM_ID
							 	 FROM TH_ENG_ITEM_BOD_SN A  WITH(NOLOCK)
									, TH_ENG_BOD_SN B       WITH(NOLOCK)
									, TH_ENG_SITE_SN C      WITH(NOLOCK)
								WHERE A.MASTER_ID = @p_master_id
									AND A.PLAN_ID   = @p_engine_plan_id
									AND B.MASTER_ID = A.MASTER_ID
									AND B.PLAN_ID   = A.PLAN_ID
									AND B.BOD_ID    = A.BOD_ID
									AND C.MASTER_ID = A.MASTER_ID
									AND C.PLAN_ID   = A.PLAN_ID
									AND C.SITE_ID   = B.FROM_SITE_ID
									AND C.ATTR03    =  'A'	
									AND C.ATTR02    = '002'
									AND B.TO_SITE_ID NOT LIKE '%-P~***'
									)
		UPDATE A
		  SET A.ATTR03   = 'LPST'  --
		 FROM TH_ENG_ITEM_BOD_SN A
			, VW_TAGET_DATA      B
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.BOD_ID    = B.BOD_ID
		  AND A.ITEM_ID   = B.ITEM_ID
		;

       /******************************************
		4) 활성화 공정의 ENG_CUSTOM 컬럼 셋팅
		-------------------------------------------
		--일정 조정 유형(SHIFT_PLAN_TYPE) : EPST (전공정 기준으로 일정조정)
		******************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 6 START';
        SET @v_description = N'6-8. TH_ENG_ITEM_BOD_SN.ATTR03등(SHIFT_TYPE)(Cell Site : ***-> 001) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		WITH VW_TAGET_DATA AS (
							   SELECT B.BOD_ID
									, B.FROM_SITE_ID
									, B.TO_SITE_ID
									, A.ITEM_ID
							 	 FROM TH_ENG_ITEM_BOD_SN A  WITH(NOLOCK)
									, TH_ENG_BOD_SN B       WITH(NOLOCK)
									, TH_ENG_SITE_SN C      WITH(NOLOCK)
								WHERE A.MASTER_ID = @p_master_id
									AND A.PLAN_ID   = @p_engine_plan_id
									AND B.MASTER_ID = A.MASTER_ID
									AND B.PLAN_ID   = A.PLAN_ID
									AND B.BOD_ID    = A.BOD_ID
									AND C.MASTER_ID = A.MASTER_ID
									AND C.PLAN_ID   = A.PLAN_ID
									AND C.SITE_ID   = B.FROM_SITE_ID
									AND C.ATTR03 = 'A'	
									AND C.ATTR02 = '***'
									AND B.TO_SITE_ID LIKE '%-A~001'
									)
		UPDATE A
		  SET A.ATTR03   = 'EPST'  --
		 FROM TH_ENG_ITEM_BOD_SN A
			, VW_TAGET_DATA      B
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.BOD_ID    = B.BOD_ID
		  AND A.ITEM_ID   = B.ITEM_ID
		;
	    
		------------------------------------------------------------
        --DEMAND의 BIZ_TYPE 구분
        ------------------------------------------------------------
		/**************************************************************
        TH_ENG_NET_DEMAND_SN CUSTOM COL 셋팅
		***************************************************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 7 START';
        SET @v_description = N'7-1. TH_ENG_NET_DEMAND.BIZ_TYPE(P)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR01 = 'PACK_BIZ'
		  FROM TH_ENG_NET_DEMAND_SN      A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND EXISTS (SELECT 'X'
						FROM TH_ENG_ITEM_ROUTE_SITE_SN X WITH(NOLOCK)
					   WHERE X.MASTER_ID = A.MASTER_ID
						 AND X.PLAN_ID   = A.PLAN_ID
						 AND X.ITEM_ID   = A.ITEM
						 AND X.ATTR01    = 'P'
					  )
		; 

        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 7 START';
        SET @v_description = N'7-2. TH_ENG_NET_DEMAND.BIZ_TYPE(A)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--CASE#1 : CELL조립공정(A3000, A9000)의 사내Site(A~***)인 CELL BIZ  
		UPDATE A
		   SET A.ATTR01 = 'CELL_BIZ'
		  FROM TH_ENG_NET_DEMAND_SN      A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND EXISTS (SELECT 'X'
						FROM TH_ENG_ITEM_ROUTE_SITE_SN X WITH(NOLOCK)
					   WHERE X.MASTER_ID = A.MASTER_ID
						 AND X.PLAN_ID   = A.PLAN_ID
						 AND X.ITEM_ID   = A.ITEM
						 AND X.ATTR01    = 'A'
						 AND X.ROUTE_ID IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
						 -- [PJ20257329] 변경전 AND X.ROUTE_ID IN ('A3000', 'A9000')
					  )
        ;

		--CASE#2 : 사내Site(A~***) 중 CELL조립공정(A3000, A9000)이 아닌, CAPA 생산공정인 CELL BIZ  
		WITH VW_TARGET_DATA AS (
								SELECT A.ITEM_ID    
								  FROM TH_ENG_ITEM_ROUTE_SITE_SN      A WITH(NOLOCK)
									 , TH_ENG_SITE_SN                 B WITH(NOLOCK)
									 , TH_ENG_OP_RES_GROUP_SN         C WITH(NOLOCK)
								 WHERE A.MASTER_ID = @p_master_id
								   AND A.PLAN_ID   = @p_engine_plan_id
								   AND B.MASTER_ID = A.MASTER_ID
								   AND B.PLAN_ID   = A.PLAN_ID
								   AND A.ATTR03    = 'N'              --사내공정
						           AND A.ROUTE_ID NOT IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
								   -- [PJ20257329] 변경전 AND A.ROUTE_ID NOT IN ('A3000', 'A9000') --CELL조립생산
								   AND B.SITE_ID   = A.SITE_ID
								   AND B.ATTR03    = 'A'    
								   AND B.ATTR02    = '***'
								   AND C.MASTER_ID = A.MASTER_ID
								   AND C.PLAN_ID   = A.PLAN_ID
								   AND C.SITE_ID   = A.SITE_ID
								   AND C.ITEM_ID   = A.ITEM_ID
								   AND C.OPERATION_ID = A.OPERATION_ID
								   AND C.DESCR      ='LINE_CAPA'            --CAPA
								  ) 
		UPDATE A
		   SET A.ATTR01 = 'CELL_BIZ'
		  FROM TH_ENG_NET_DEMAND_SN      A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		   AND EXISTS (SELECT 'X'
						FROM VW_TARGET_DATA X WITH(NOLOCK)
						WHERE X.ITEM_ID   = A.ITEM
						)
		;

		--CASE#3 : 사내Site(A~002) 중 CELL조립공정(A3000, A9000)이 아닌, NO CAPA 생산공정인 CELL BIZ  
		WITH VW_TARGET_DATA AS (
								SELECT A.ITEM_ID    
								  FROM TH_ENG_ITEM_ROUTE_SITE_SN      A WITH(NOLOCK)
									 , TH_ENG_SITE_SN                 B WITH(NOLOCK)
									 , TH_ENG_OP_RES_GROUP_SN         C WITH(NOLOCK)
								 WHERE A.MASTER_ID = @p_master_id
								   AND A.PLAN_ID   = @p_engine_plan_id
								   AND B.MASTER_ID = A.MASTER_ID
								   AND B.PLAN_ID   = A.PLAN_ID
						           AND A.ROUTE_ID NOT IN (SELECT OPERATION_ID  FROM @SCP_CELL_FINAL_OPERATION)  -- [PJ20257329] Cell 완성 공정 하드 코딩 변경
								   -- [PJ20257329] 변경전 AND A.ROUTE_ID NOT IN ('A3000', 'A9000')
								   AND A.ATTR03     = 'N'    --사내공정
								   AND B.SITE_ID   = A.SITE_ID
								   AND B.ATTR03    = 'A'    
								   AND B.ATTR02    = '002' 
								   AND C.MASTER_ID = A.MASTER_ID
								   AND C.PLAN_ID   = A.PLAN_ID
								   AND C.SITE_ID   = A.SITE_ID
								   AND C.ITEM_ID   = A.ITEM_ID
								   AND C.OPERATION_ID = A.OPERATION_ID
								   AND C.DESCR     = 'NO_CAPA'
								  ) 
		UPDATE A
		   SET A.ATTR01 = 'CELL_BIZ'
		  FROM TH_ENG_NET_DEMAND_SN      A WITH(NOLOCK)
		 WHERE A.MASTER_ID = @p_master_id
		   AND A.PLAN_ID   = @p_engine_plan_id
		   AND EXISTS (SELECT 'X'
						FROM VW_TARGET_DATA X WITH(NOLOCK)
						WHERE X.ITEM_ID   = A.ITEM
						)
		;

		SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 7 START';
        SET @v_description = N'7-3. TH_ENG_ITEM_BOD_SN.SHIPMENT_SPLIT_YN ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/*****************************
		TCO CELL BIZ
		*****************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 7 START';
        SET @v_description = N'7-4. TH_ENG_NET_DEMAND.BIZ_TYPE(TCO)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR01 = 'TCO_BIZ'
		  FROM TH_ENG_NET_DEMAND_SN      A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND EXISTS (
						SELECT 'X'
						  FROM SCP_MST_FINAL_ITEM_V X WITH(NOLOCK)
						 WHERE X.TCO_CELL_YN = 'Y'
						   AND X.ITEM_ID     = A.ITEM
					 )
		;

	    /*****************************
		병합출하 GROUP ID 셋팅
		*****************************/
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 7 START';
        SET @v_description = N'7-5. TH_ENG_NET_DEMAND.ATTR03(MERGE_GROUP_ID)' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR02 = A.COMPLETED_SHIPPING_ID
		  FROM TH_ENG_NET_DEMAND_SN A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.COMPLETED_SHIPPING_ID IS NOT NULL
		;

        ------------------------------------------------------------
        --TH_ENG_CUSTOM_MASTER의 옵션값 등록
		------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 8 START';
        SET @v_description = N'8-1. TH_ENG_CUSTOM_MASTER.OPTION = SINGLE_SPLIT_SHIPMENT' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		/**************************************************************
        3. TH_ENG_CUSTOM_DETAIL 등록
		***************************************************************/
		DELETE A
		  FROM TH_ENG_CUSTOM_DETAIL_SN A
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
        ;

		INSERT INTO TH_ENG_CUSTOM_DETAIL_SN
			(
			  MASTER_ID
			, PLAN_ID
			, KEY_TYPE
			, KEY_ID
			, KEY_SEQ
			, KEY01_VAL
			, KEY02_VAL
			, KEY03_VAL
			, KEY04_VAL
			)
		SELECT @p_master_id      AS MASTER_ID 
	 		, @p_engine_plan_id AS PLAN_ID
			, 'OPTION'          AS KEY_TYPE
			, A.KEY_ID          AS KEY_ID 
			, ROW_NUMBER() OVER(ORDER BY B.FROM_SITE_ID, B.TO_SITE_ID) AS KEY_SEQ
			, '1'               AS KEY01_VAL
			, 'BOD'             AS KEY02_VAL
			, B.FROM_SITE_ID    AS KEY03_VAL
			, B.TO_SITE_ID      AS KEY04_VAL
		FROM TH_ENG_CUSTOM_MASTER_SN A WITH(NOLOCK)
			, (
				SELECT DISTINCT 
					B.FROM_SITE_ID
					, B.TO_SITE_ID
				FROM TH_ENG_BOD_SN B WITH(NOLOCK)
				WHERE B.MASTER_ID = @p_master_id
				AND B.PLAN_ID   = @p_engine_plan_id
				AND B.TO_SITE_ID LIKE '%-A~001'
			) B
		WHERE A.KEY_ID = 'SINGLE_SPLIT_SHIPMENT'
			AND A.DIVISION_ID = @p_division_id
			AND A.USE_YN = 'Y'
		;
        -----------------------------------------------------------
        -- TXN LOG                
        -------------------------------------------------
		SET @v_log_type = 'TXN';
        SET @n_log_count = @@ROWCOUNT;
        --SET @v_log_message = 'INSERT INTO '+@v_table_id;
        SET @v_description = 'Process Complete...' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
          BEGIN
            COMMIT WORK;
          END

      END

    END TRY

    BEGIN CATCH
      -- ROLLBACK
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE()) + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
      return -1
    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1

  END
