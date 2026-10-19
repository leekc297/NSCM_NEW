/*
 * Program ID   : PR_SCP_ENG_EE_PRE_PROC_CUSTOM
 * Description  : 엔진Custom(엔진후처리) 기능을 위한 엔진Custom 필드 생성                             
 * OutTable     :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.21   KKC         Initial Release
 * 2022.07.07   KKC         전극 후공정 이후 NLFP(A5000~A9000)까지, 공정 납기일 기준으로 SHIFT_TYPE(LPST) 설정
 */
CREATE PROCEDURE  [dbo].[PR_SCP_ENG_EE_PRE_PROC_CUSTOM]
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

     --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    DECLARE @p_plan_cycle  NVARCHAR(150)     = @p_plan_cycle1;
    DECLARE @p_plan_name   NVARCHAR(4000)    = @p_plan_name1;
    DECLARE @p_plan_id     NVARCHAR(4000)    = @p_plan_id1;
    DECLARE @p_modeling_id NVARCHAR(4000)    = @p_modeling_id1 ;
    DECLARE @p_seq         NVARCHAR(4000)    = @p_seq1 ;
    DECLARE @p_plan_type   NVARCHAR(4000)    = @p_plan_type1 ;
    DECLARE @p_master_id   NVARCHAR(4000)    = @p_master_id1 ;
    DECLARE @p_division_id NVARCHAR(30)      = @p_division_id1 ; 
    DECLARE @p_engine_plan_id NVARCHAR(4000) = @p_engine_plan_id1 ;
    
    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ENG_EE_PRE_PROC_CUSTOM';
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

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = @p_master_id + ' / ' + @p_engine_plan_id ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

        ------------------------------------------------------------
        --TH_ENG_XXXX.CUSTOM_COLULMN 컬럼값 초기화
		------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1 START';
        SET @v_description = N'1. TH_ENG_CUSTOM.COLULMN 초기화' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		/* CUSTOM 컬럼 초기화 */
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
        1. ENG_CUSOM을 위한, 공통 컬럼 셋팅
		***************************************************************/
        ------------------------------------------------------------
        --TH_ENG_PLAN_INFO.DIVISION_ID CUSTOM 컬럼값 추가
        ------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 1 START';
        SET @v_description = N'1. TH_ENG_PLAN_INFO.DIVISION_ID' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
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
        SET @v_log_message = 'PART 2 START';
        SET @v_description = N'2. TH_ENG_SITE.CUSTOM_COLUMN ADD' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
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
						      ELSE NULL
						  END
		  FROM TH_ENG_SITE_SN A WITH(NOLOCK)
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		;

        ------------------------------------------------------------
        --TH_ENG_ITEM_ROUTE_SITE_SN.CUSTOM_COLUMN ADD 컬럼값 추가
        ------------------------------------------------------------
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 3 START';
        SET @v_description = N'3. TH_ENG_ITEM_ROUTE_SITE_SN.CUSTOM_COLUMN ADD' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		UPDATE A
		   SET A.ATTR01  = B.ATTR03
		       /* Cell Site의 NLFP LT공정은 후공정 일자 기준으로 조정, 22.07.07 수정.*/
		     , A.ATTR02  = CASE WHEN B.ATTR03 = 'A' THEN 'LPST'
							    ELSE NULL
						    END
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
		
        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 4 START';
        SET @v_description = N'4. TH_ENG_RESOURCE_SN.CUSTOM_COLUMN ADD ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
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
        SET @v_log_message = 'PART 5 START';
        SET @v_description = N'5-1. TH_ENG_ITEM_BOD_SN.SHIFT_PLAN_TYPE(Sales Site) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	    /******************************************
		최종 Sales Site BOD의 ENG_CUSTOM 컬럼 셋팅
        --전극 모델링 가상 SALES SITE 
		-------------------------------------------
		1)분할출하공정 대상여부(SHIPMENT_SPLIT_YN) : N
		2)병합출하공정 대상여부(SHIPMENT_MERGE_YN) : N
		3)일정 조정 유형(SHIFT_PLAN_TYPE) : EPST (전극은 납기 기준이 아니라, NLFP의 Packing 공정의 완료일자 기준)
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
								  AND B.FROM_SITE_ID LIKE '%-A~***%'  --//가상 SALES SITE만, EPST로
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
		  SET A.ATTR03  = CASE WHEN B.FROM_SITE_ID LIKE '%-A~***%' THEN 'EPST'  --//가상Sales(Cell) Model에만, EPST
		                       ELSE 'LPST'  --//전극Sales Model는 다른 사업부에 동일하게, 22.07.07 수정
						   END
		 FROM TH_ENG_ITEM_BOD_SN A
			, VW_TAGET_DATA      B
		WHERE A.MASTER_ID = @p_master_id
		  AND A.PLAN_ID   = @p_engine_plan_id
		  AND A.BOD_ID    = B.BOD_ID
		  AND A.ITEM_ID   = B.ITEM_ID
		;

        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5 START';
        SET @v_description = N'5-2. TH_ENG_ITEM_BOD_SN.SHIFT_PLAN_TYPE(Cell-> Pack) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/******************************************
		2)일정 조정 유형(SHIFT_PLAN_TYPE) : LPST(후공정 시작일 기준으로)
		******************************************/
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
							   AND C.ATTR03    = 'E'        --FROM SITE	
							   AND D.MASTER_ID = A.MASTER_ID
							   AND D.PLAN_ID   = A.PLAN_ID
							   AND D.SITE_ID   = B.TO_SITE_ID
							   AND D.ATTR03    = 'A'	    --TO SITE
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

        SET @v_log_type = 'TXN';
        SET @v_log_message = 'PART 5 START';
        SET @v_description = N'5-3. TH_ENG_ITEM_BOD_SN.SHIFT_PLAN_TYPE(ELEC-> ~002,~003) ' + ' / ' + @p_master_id + ' / ' + @p_engine_plan_id ;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		/******************************************
		3)일정 조정 유형(SHIFT_PLAN_TYPE) : LPST
		******************************************/
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
							   AND C.ATTR03    = 'E'        --FROM SITE	
							   AND D.MASTER_ID = A.MASTER_ID
							   AND D.PLAN_ID   = A.PLAN_ID
							   AND D.SITE_ID   = B.TO_SITE_ID
							   AND D.ATTR03    = 'E'	    --TO SITE
							   AND D.ATTR02 IN ('002','003') 
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
