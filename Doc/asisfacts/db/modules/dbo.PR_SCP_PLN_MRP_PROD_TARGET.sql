
/*
 * Program ID   : PR_SCP_PLN_MRP_PROD_TARGET 
 * Description  : MRP 생산TARGET 전송
 * OutTable     :
 * Execute      : EXEC PR_SCP_PLN_MRP_PROD_TARGET
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.03.20   YYDOK         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.03.21   YYDOK         주단위 수량 SUM으로 INTERFACE하기로 요건 변경반영
 * 2018.03.22   YYDOK         NICK NAME칼럼 및 INSERT COLUMN누락 수정
 * 2018.03.28   YYDOK         INTERFACE TABLE COLUMNS변경반영
 * 2018.04.02   YYDOK         IF ID변경(OFP0_OMRP_MRP_PROD_TARGET)
 * 2018.04.10   YYDOK         FINAL PLAN CODE CHANGE(FI->FN)
 * 2018.04.20   YYDOK         CURSOR오류로 CURSOR제거.
 * 2018.04.25   YYDOK         6주이후구간은 라인구분없이 '-'로 인터페이스처리
 * 2018.07.03   YYDOK         ORIGIN_DIVISION_ID ADD 
 * 2018.10.10   YYDOK         해당주차 MRP TARGET INTERFACE YN (인터페이스해야할지 여부) 체크로직추가
 * 2018.12.17   YYDOK         6주이후구간도 라인구분하여 인터페이스처리
 * 2018.12.18   YYDOK         ATTR_02에 DM의 PROD_TYP(FCST_TYPE) NAME을 인터페이스 추가
 * 2019.09.03   KSG           [CSR ID 4074962] SCP생산계획 송신(to MRP) 버켓단위 변경 요청 건 
 *                            PROD_WEEK 대신 Partial 기준 PROD_PARTIAL_WEEK 정보 사용
 * 2019.09.30   KSG           [CSR ID 4083826] 전극 Cell 환산자 처리 
 * 2020.02.18   KSG           [C20200207-000240] MRP - Requirement list cell수량 확인요청 
 * 2020.10.08   KSW           프로시저 수행 마지막에 Target 전송 이상유무를 체크하는 프로시저를 호출한다.
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_PLN_MRP_PROD_TARGET]
    ( 
      @p_division_id          NVARCHAR(10)
    , @p_start_yyyymmdd       NVARCHAR(8)
    , @p_plan_type            NVARCHAR(40)
    , @p_seq                  INT
    , @p_user_id              NVARCHAR(100)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_PLN_MRP_PROD_TARGET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_SYS_LOG_BATC'; 
    DECLARE @d_event_date   DATETIME;
    
        ----------------------------------------------------------- 
        -- 0. validation
        -- PLAN_TYPE='MA','FN', CONFIRM된 경우에 처리함.
        -----------------------------------------------------------
        IF @p_plan_type NOT IN ( 'MA','FN' )
           BEGIN
              RETURN;
           END
 
        ----------------------------------------------------------
        -- 해당주차 SCP자동으로 수행하여 인터페이스 안내리도록
        -- SCP_PLN_INTERFACE_YN에 N으로 셋팅시 수행안함.
        ----------------------------------------------------------
        DECLARE @X_FP_TARGET_YN NVARCHAR(1) = 'Y';
        DECLARE @X_MRP_TARGET_YN NVARCHAR(1) = 'Y';

        SELECT @X_FP_TARGET_YN =  ISNULL(FP_TARGET_YN,'Y'),
               @X_MRP_TARGET_YN =  ISNULL(MRP_TARGET_YN,'Y')
          FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
         WHERE DIVISION_ID         = @p_division_id 
           AND PLAN_START_YYYYMMDD = DBO.FN_GET_BUCKET_YYYYMMDD(0);

        IF @X_MRP_TARGET_YN = 'N'
           BEGIN
              RETURN;
           END

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':'  + @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;

   --BEGIN TRANSACTION; 
              
    BEGIN TRY
      BEGIN
           
        IF @p_user_id IS NULL 
           BEGIN
              SET @p_user_id = 'SCP';
           END                

        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        

            DECLARE @X_START_YYYYMMDD       NVARCHAR(8);
            DECLARE @X_CNT                  INT           = 0;
            DECLARE @X_SEND_SEQ             INT           = 1;
            
            DECLARE @X_IF_SEQ               VARCHAR(50);  -- MQ SEQ
            DECLARE @X_IF_TYPE              NVARCHAR(1)   = 'I';
            DECLARE @X_IF_ID                NVARCHAR(50)  = 'OFP0_OMRP_MRP_SCP_PROD_TARGET';
            DECLARE @X_IF_INS_DATE          DATETIME      = GETDATE();
            DECLARE @X_IF_FLAG              NVARCHAR(100)  = 'N';
            DECLARE @X_IF_SND_DATE          NVARCHAR(100)  = NULL;
            
            DECLARE @X_ST_PLAN_TYP          NVARCHAR(40)    = @p_plan_type;
            DECLARE @X_PLAN_VERSION         NVARCHAR(12);
            
            --DECLARE @X_TARGET_ID            NVARCHAR(200);
            DECLARE @X_DIV_CD               NVARCHAR(10);            
            DECLARE @X_SCP_SITE_CD          NVARCHAR(40);
            DECLARE @X_PLANT_CD             NVARCHAR(40);
            DECLARE @X_OPER_CD              NVARCHAR(40);            
            DECLARE @X_LINE_CD              NVARCHAR(40);                        
            DECLARE @X_PROD_TYP             NVARCHAR(40); --양산,샘플,...
            DECLARE @X_ITEM_CD              NVARCHAR(40);
            DECLARE @X_NICK_NM              NVARCHAR(100);
            DECLARE @X_PLAN_DT              NVARCHAR(8);
            DECLARE @X_PLAN_QTY             DECIMAL(18,3);
            DECLARE @X_PLAN_IN_QTY          DECIMAL(18,3);
            DECLARE @X_PROD_WEEK            NVARCHAR(8);
            DECLARE @X_MKT_FLAG             NVARCHAR(1);
            DECLARE @X_OPER_GRP_CD          NVARCHAR(50);
            DECLARE @X_CREATE_USER_ID       NVARCHAR(50);
            DECLARE @X_CREATE_DATE          DATETIME;
            DECLARE @X_MODIFY_USER_ID       NVARCHAR(50);
            DECLARE @X_MODIFY_DATE          DATETIME;
            DECLARE @X_ORIGIN_DIVISION_ID   NVARCHAR(40);      
      
            IF LEN(ISNULL(@P_START_YYYYMMDD,'')) = 8 
               BEGIN            
                    SET @X_START_YYYYMMDD = @P_START_YYYYMMDD;  
               END     
            ELSE
               BEGIN
                    SET @X_START_YYYYMMDD = DBO.FN_GET_BUCKET_YYYYMMDD(0);
               END
            
            SELECT @X_CNT = COUNT(1)
              FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
             WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
               AND DIVISION_ID         = @P_DIVISION_ID
               AND PLAN_TYPE           = @P_PLAN_TYPE
               AND IF_ID               = @X_IF_ID;   
      
            IF (@X_CNT > 0)
               BEGIN
                    SELECT @X_CNT = MAX(IFSEQNO)
                      FROM DBO.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
                     WHERE PLAN_START_YYYYMMDD = @X_START_YYYYMMDD
                       AND DIVISION_ID         = @P_DIVISION_ID
                       AND PLAN_TYPE           = @P_PLAN_TYPE
                       AND IF_ID               = @X_IF_ID;  
                       
                    SET @X_SEND_SEQ = @X_CNT +1;    
               
               END
      
            -- 전송주차 = 해당주차의 월요일 일자 YYYYMMDD + '001' 일련번호
            SET @X_PLAN_VERSION = @X_START_YYYYMMDD + '_' + DBO.FN_ZERO_LPAD( @X_SEND_SEQ,3 );
      
            BEGIN
            
                    -------------------------------------------------------------------------------------------------------------             
                    -- 0. temp 테이블 생성           
                    -------------------------------------------------------------------------------------------------------------             
                    IF OBJECT_ID('tempdb..#tmp_XIF_SCP_PROD_TARGET_MRP_S_SN') IS NOT NULL            
                        DROP TABLE #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN            
                      
                      CREATE TABLE #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN(            
                            IF_SEQ              [nvarchar](50)
                           ,IF_TYPE             [nvarchar](1)
                           ,IF_ID               [nvarchar](50)
                           ,IF_INS_DATE         [datetime]
                           ,IF_FLAG             [nvarchar](1)
                           ,IF_SND_DATE         [datetime]
                           ,PLAN_VRSN_ID        [nvarchar](20)
                           ,PLAN_TYP            [nvarchar](50)
                           ,DIV_CD              [nvarchar](50)
                           ,SCP_SITE_CD         [nvarchar](50)
                           ,PLANT_CD            [nvarchar](50)
                           ,OPER_CD             [nvarchar](50)
                           ,LINE_CD             [nvarchar](50)
                           ,PROD_TYP            [nvarchar](50)
                           ,ITEM_CD             [nvarchar](50)
                           ,PLAN_DT             [nvarchar](8)
                           ,MKT_FLAG            [nvarchar](1)
                           ,PLAN_QTY            [numeric](15, 3)
                           ,PLAN_IN_QTY         [numeric](15, 3)
                           ,PROD_WEEK           [nvarchar](8)
                           ,PJCT_NICK_NM        [nvarchar](200)
                           ,OPER_GRP_CD         [nvarchar](50)
                           ,REG_DTTM            [datetime]
                           ,REG_USER_ID         [nvarchar](50)
                           ,CHNG_DTTM           [datetime]
                           ,CHNG_USER_ID        [nvarchar](50)
                           ,ORIGIN_DIVISION_ID  [nvarchar](50)    
                           ,CELL_ITEM_CD        [nvarchar](150)    -- 20190930 전극 Cell 환산자 처리 
                           ,CONVERT_QTY_CELL    [numeric](20, 10)  -- 20190930 전극 Cell 환산자 처리 
                      );      
	  
                   /******************************************
                    * 생산타겟 송신용 임시 테이블에 기록한다.
                    ******************************************/                                      
                   -- MQ IF_SEQ 규칙: 'ORCP'+년월일+ 일련번호10자리(좌측0 PAD처리)
                          
                  --INSERT INTO XIF_SCP_PROD_TARGET_MRP_S_SN
                  INSERT INTO #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN
                            ( 
                              IF_SEQ             ,
                              IF_TYPE            ,
                              IF_ID              ,
                              IF_INS_DATE        ,
                              IF_FLAG            ,
                              IF_SND_DATE        , 
                              PLAN_VRSN_ID       ,
                              PLAN_TYP           ,
                              DIV_CD             ,
                              SCP_SITE_CD        ,
                              PLANT_CD           ,
                              OPER_CD            ,
                              LINE_CD            ,
                              PROD_TYP           ,
                              ITEM_CD            ,
                              PLAN_DT            ,
                              MKT_FLAG           ,
                              PLAN_QTY           ,
                              PLAN_IN_QTY        ,
                              PROD_WEEK          ,
                              PJCT_NICK_NM       ,
                              OPER_GRP_CD        ,
                              REG_DTTM           ,
                              REG_USER_ID        ,
                              CHNG_DTTM          ,
                              CHNG_USER_ID       ,
                              ORIGIN_DIVISION_ID ,
                              CELL_ITEM_CD       , -- 20190930 전극 Cell 환산자 처리 
                              CONVERT_QTY_CELL     -- 20190930 전극 Cell 환산자 처리 
                             )
                  SELECT  --'OSCP'+CONVERT(VARCHAR,GETDATE(),112)+ DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCP_PROD_TARGET_MRP_S),10) AS IF_SEQ
                          NULL                          AS IF_SEQ
                        , @X_IF_TYPE                    AS IF_TYPE
                        , @X_IF_ID                      AS IF_ID
                        , @X_IF_INS_DATE                AS IF_INS_DATE
                        , @X_IF_FLAG                    AS IF_FLAG
                        , @X_IF_SND_DATE                AS IF_SND_DATE
                        , @X_PLAN_VERSION               AS PLAN_VRSN_ID
                        , @P_PLAN_TYPE                  AS PLAN_TYP 
                        , ta.DIVISION_ID                AS DIV_CD
                        , ta.SITE_ID                    AS SCP_SITE_CD
                        , ta.PLANT_ID                   AS PLANT_CD
                        , ta.OPERATION_ID               AS OPER_CD
                        , ta.PRODUCTION_LINE            AS LINE_CD
                        , ta.FCST_TYPE                  AS PROD_TYP
                        , ta.ITEM_ID                    AS ITEM_CD
                        -- 20190903 [CSR ID 4074962]  PROD_WEEK 대신 Partial 기준 PROD_PARTIAL_WEEK 정보 사용
                        , ta.PROD_PARTIAL_WEEK          AS PLAN_DT    
                        --, ta.PROD_WEEK                  AS PLAN_DT    
                        , ta.DOM_EXP                    AS MKT_FLAG
                        , SUM(ta.PROD_QTY_MRP)          AS PLAN_QTY
                        , SUM(ta.PROD_IN_QTY)           AS PLAN_IN_QTY
                        -- 20190903 [CSR ID 4074962]  PROD_WEEK 대신 Partial 기준 PROD_PARTIAL_WEEK 정보 사용
                        , ta.PROD_PARTIAL_WEEK          AS PROD_WEEK  
                        --, ta.PROD_WEEK                  AS PROD_WEEK
                        , MAX(ta.NICK_NAME)             AS PJCT_NICK_NM
                        , MAX(ta.OPERATION_GROUP)       AS OPER_GRP_CD
                        , MAX(ta.CREATE_DATE)           AS REG_DTTM
                        , MAX(ta.CREATE_USER_ID)        AS REG_USER_ID
                        , MAX(ta.MODIFY_DATE)           AS CHNG_DTTM
                        , MAX(ta.MODIFY_USER_ID)        AS CHNG_USER_ID
                        , ta.ORIGIN_DIVISION_ID         AS ORIGIN_DIVISION_ID
                        , MAX(fi.CELL_ITEM_ID)          AS CELL_ITEM_ID     -- 20190930 전극 Cell 환산자 처리
                        , MAX(fi.CONVERT_QTY_CELL)      AS CONVERT_QTY_CELL -- 20190930 전극 Cell 환산자 처리

                     FROM dbo.SCP_PLN_PROD_PLAN_TARGET_V ta WITH(NOLOCK)

					      -- 20190930 전극 Cell 환산자 처리 : 전극 Item 만 정보 추가
					      LEFT OUTER JOIN SCP_MST_FINAL_ITEM fi WITH(NOLOCK)
						  ON  ta.ORIGIN_DIVISION_ID = fi.DIVISION_ID
						  AND ta.ITEM_ID            = fi.ITEM_ID

                    WHERE 1=1
                      AND ta.DIVISION_ID              = @p_division_id    --'81'
                      AND ta.PLAN_START_YYYYMMDD      = @p_start_yyyymmdd --'20180319'
                      AND ta.PLAN_TYPE                = @p_plan_type      --'MA'
                      AND ta.SEQ                      = @p_seq            --11
                    GROUP BY
                          ta.DIVISION_ID   
                        , ta.SITE_ID
                        , ta.PLANT_ID
                        , ta.OPERATION_ID
                        , ta.PRODUCTION_LINE
                        , ta.FCST_TYPE
                        , ta.ITEM_ID
                        -- 20190903 [CSR ID 4074962]  PROD_WEEK 대신 Partial 기준 PROD_PARTIAL_WEEK 정보 사용
                        , ta.PROD_PARTIAL_WEEK
                        --, ta.PROD_WEEK
                        , ta.DOM_EXP
                        , ta.ORIGIN_DIVISION_ID
                       ;                         

                  -- 20200218 [C20200207-000240] 전극 -> Cell 환산자 정보 없는 경우 FP 로직으로 추가
                  UPDATE #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN
                  SET    convert_qty_cell = (SELECT MAX(ic.value)
                                             FROM   SCM_MST_ITEM_CONV_CALC_SN ic WITH(NOLOCK)
                                             WHERE  ic.item_id      = a.item_cd
                                             --AND    ic.company_id   = 'G480'
                                             AND    ic.max_ver_flag = 'Y'
                                             AND    ic.category     = 'Pancake (cell/m)'
                                             AND    ic.operation    = 'E2000' 
                                            )
				  FROM   #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN a WITH(NOLOCK)
				  WHERE  1=1
				  AND    ISNULL(convert_qty_cell, -99) = -99
				  ;

                -- 6주 이후구간에 대해서는 LINE표기를 '-'로 한다. LINE에 대해서 SCP에서 책임못진다.
                -- --> LINE 표기하여 전달하도록 결정(2018.12.17)하여 COMMENT처리함.
         /*
                UPDATE #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN
                   SET LINE_CD ='-'
                 WHERE PROD_WEEK  > DBO.FN_GET_BUCKET_YYYYMMDD(5);  
         */ 
  
                   /******************************************
                    * 생산타겟 송신용 테이블에 기록한다.
                    ******************************************/  
                  INSERT INTO XIF_SCP_PROD_TARGET_MRP_S_SN
                            ( 
                              IF_SEQ             ,
                              IF_TYPE            ,
                              IF_ID              ,
                              IF_INS_DATE        ,
                              IF_FLAG            ,
                              IF_SND_DATE        , 
                              PLAN_VRSN_ID       ,
                              PLAN_TYP           ,
                              DIV_CD             ,
                              SCP_SITE_CD        ,
                              PLANT_CD           ,
                              OPER_CD            ,
                              LINE_CD            ,
                              PROD_TYP           ,
                              ITEM_CD            ,
                              PLAN_DT            ,
                              MKT_FLAG           ,
                              PLAN_QTY           ,
                              PLAN_IN_QTY        ,
                              PROD_WEEK          ,
                              PJCT_NICK_NM       ,
                              OPER_GRP_CD        ,
                              REG_DTTM           ,
                              REG_USER_ID        ,
                              CHNG_DTTM          ,
                              CHNG_USER_ID       ,
                              ATTR_01            , -- ORIGIN DIVISION ID
                              ATTR_02            , -- DM FCST TYPE NAME
                              ATTR_03            , -- 20190930 전극 Cell 환산자 처리 : PLAN_IN_QTY * 환산자
                              ATTR_04              -- 20190930 전극 Cell 환산자 처리 : PLAN_QTY * 환산자
                             )
                  SELECT  'OSCP'+CONVERT(VARCHAR,GETDATE(),112)+ DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCP_PROD_TARGET_MRP_S),10) AS IF_SEQ
                        , IF_TYPE
                        , IF_ID
                        , IF_INS_DATE
                        , IF_FLAG
                        , IF_SND_DATE
                        , PLAN_VRSN_ID
                        , PLAN_TYP 
                        , DIV_CD
                        , SCP_SITE_CD
                        , PLANT_CD
                        , OPER_CD
                        , LINE_CD
                        , PROD_TYP
                        , ITEM_CD
                        , PLAN_DT    
                        , MKT_FLAG
                        , SUM(PLAN_QTY)              AS PLAN_QTY
                        , SUM(PLAN_IN_QTY)           AS PLAN_IN_QTY
                        , PROD_WEEK
                        , MAX(PJCT_NICK_NM)          AS PJCT_NICK_NM
                        , MAX(OPER_GRP_CD)           AS OPER_GRP_CD
                        , MAX(REG_DTTM)              AS REG_DTTM
                        , MAX(REG_USER_ID)           AS REG_USER_ID
                        , MAX(CHNG_DTTM)             AS CHNG_DTTM
                        , MAX(CHNG_USER_ID)          AS CHNG_USER_ID
                        , ORIGIN_DIVISION_ID         AS ORIGIN_DIVISION_ID
                        , dbo.FN_GET_LOOKUP_CODE_DESC( 'SALES_TYPE_CODE' , PROD_TYP )  AS PROD_TYP_NM --(LOOKUP: SALES_TYPE_CODE)
                        , SUM(PLAN_IN_QTY) * MAX(CONVERT_QTY_CELL)                     AS PLAN_IN_CELL_QTY -- 20190930 전극 Cell 환산자 처리  : PLAN_IN_QTY * 환산자
                        , SUM(PLAN_QTY) * MAX(CONVERT_QTY_CELL)                        AS PLAN_CELL_QTY    -- 20190930 전극 Cell 환산자 처리  : PLAN_QTY * 환산자
                     FROM #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN  --WITH(NOLOCK)
                    WHERE 1=1
                    GROUP BY
                          IF_TYPE
                        , IF_ID
                        , IF_INS_DATE
                        , IF_FLAG
                        , IF_SND_DATE
                        , PLAN_VRSN_ID
                        , PLAN_TYP 
                        , DIV_CD
                        , SCP_SITE_CD
                        , PLANT_CD
                        , OPER_CD
                        , LINE_CD
                        , PROD_TYP
                        , ITEM_CD
                        , PLAN_DT    
                        , MKT_FLAG
                        , PROD_WEEK
                        , ORIGIN_DIVISION_ID
                       ;  
					   
                SET @n_log_count = @@ROWCOUNT;               
      
                INSERT INTO DBO.SCP_PLN_INTERFACE_SEND_H
                           ( PLAN_START_YYYYMMDD
                           , DIVISION_ID
                           , PLAN_TYPE
                           , IF_ID
                           , IFSEQNO
                           , CREATED_BY
                           , CREATION_DATE )
                           VALUES
                           (  
                             @X_START_YYYYMMDD
                           , @P_DIVISION_ID
                           , @P_PLAN_TYPE
                           , @X_IF_ID
                           , @X_SEND_SEQ
                           , @P_USER_ID
                           , GETDATE()    
                           );
               
            END    
            
        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------          
        IF OBJECT_ID('tempdb..#tmp_XIF_SCP_PROD_TARGET_MRP_S_SN') IS NOT NULL            
            DROP TABLE #tmp_XIF_SCP_PROD_TARGET_MRP_S_SN            

      
       -- IF @@TRANCOUNT > 0 
       --   BEGIN
       --      COMMIT WORK;
       --                                
       --   END;      
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';   
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ':'  + @p_division_id;
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
     -- IF @@TRANCOUNT > 0 
     --   BEGIN
     --     ROLLBACK;
     --   END;        
     
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE()) + ':'  + @p_division_id;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = @p_division_id;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ;

    ----------------------------------------------------------- start
	-- 2020.10.08   KSW :: 프로시저 수행 마지막에 Target 전송 이상유무를 체크하는 프로시저를 호출한다.
	-----------------------------------------------------------
	EXEC PR_SCP_PLN_IF_CHECK_SMS_SEND @p_division_id, @p_plan_type, 'MRP_PROD' ;
	----------------------------------------------------------- end

    return 1  


  END;
