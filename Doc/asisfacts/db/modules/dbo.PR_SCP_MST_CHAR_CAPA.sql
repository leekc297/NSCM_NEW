
/*
 * Program ID   : PR_SCP_MST_CHAR_CAPA
 * Description  : SCP_MST_CHAR_CAPA(특성 CAPA) 테이블 데이터 생성 
                  
                  -------------------------------------------------
                  1. SCP_MST_CHAR_CAPA 데이터 임시테이블로 생성
                  -------------------------------------------------
                     - 1) 컬럼
                          - scp_mst_char_capa.daily_capa_qty 컬럼 : scp_mst_tact_time 테이블에서 division_id, plant_site_id, item_id 별  SUM(ROUND((1440 * 60) / tact_time, 0)) 
                          - scp_mst_char_capa.item_id 컬럼        : item_id가 '-'는  TOTAL 값을 나타냄(1,999,999,999 으로 하드코딩함)   
                     
                     - 2) 대상
                          - 사업부별 scp_mst_tact_time 중 operation_id 가 A3000, A9000 (LINE CAPA 대상인 셀 공정)

                     - 3) 생성제외 
                          - created_by, last_updated_by 컬럼의 아이디가 사용자가 등록/수정한 데이터는 생성안함(created_by, last_updated_by 가 'scp_batch'가 아닌 데이터는 생성안함)
                  
                  
                  ------------------------------------------------- 
                  2. 자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제
                  -------------------------------------------------
                     - 자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                 
                  -------------------------------------------------
                  3. SCP_MST_CHAR_CAPA 데이터 INSERT
                  -------------------------------------------------

                  -------------------------------------------------
                  4. SCP_MST_CHAR_CAPA TOTAL 데이터 INSERT
                  -------------------------------------------------
                      - SCP_MST_CHAR_CAPA 테이블의 division_id, plant_site_id  별 TOTAL 1개 생성  
                      - item_id 컬럼        : '-'로 셋팅
                      - daily_capa_qty 컬럼 : 1999999999 로 셋팅
 * OutTable     :
 * Execute      :    EXEC PR_SCP_MST_CHAR_CAPA
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
  * 2019.01.08   KSW           Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  

 */
 
CREATE PROCEDURE [dbo].[PR_SCP_MST_CHAR_CAPA]
   -- ( @p_division_id1         NVARCHAR(30) )
 AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    --20180228 프로시저 속도 개선을 위해서 입력변수를 일반변수로 변경함
    --DECLARE @p_division_id  NVARCHAR(150)    = @p_division_id1;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_MST_CHAR_CAPA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_CHAR_CAPA'; 
    DECLARE @d_event_date   DATETIME;

    DECLARE @d_create_date  DATETIME = GETDATE(); --데이터 생성 시간
    --DECLARE @n_rowcount     INT;
    
    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_MST_CHAR_CAPA INSERT';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user --'scp_batch'
                              ;
    
    
    
    BEGIN TRY
      BEGIN
    
        ---------------------------------------------------------------------------- 
        -- 1. SCP_MST_CHAR_CAPA 생성데이터 임시테이블에 생성
        ---------------------------------------------------------------------------- 
        -- 임시테이블 존재시 DROP
        IF OBJECT_ID('tempdb..#SCP_MST_CHAR_CAPA_TEMP') IS NOT NULL
        BEGIN 
            DROP TABLE  #SCP_MST_CHAR_CAPA_TEMP          
        END 

        -- 임시테이블 생성
        CREATE TABLE #SCP_MST_CHAR_CAPA_TEMP
        (
	        DIVISION_ID            NVARCHAR(50)  NOT NULL
	      , PLANT_SITE_ID          NVARCHAR(300) NOT NULL
          , ITEM_ID                NVARCHAR(300) NOT NULL
          , DAILY_CAPA_QTY         NUMERIC(20, 10) NOT NULL
        )
        ;

        -- SCP_MST_CHAR_CAPA 데이터 임시테이블로 생성
        WITH with_tact_time 
        AS   
        (    SELECT tt.division_id
                 ,  tt.plant_site_id 
                 ,  tt.item_id
                 ,  SUM(ROUND((1440*60) / tt.tact_time, 0)) AS sum_daily_capa_qty
             FROM   scp_mst_tact_time tt WITH (NOLOCK)
             WHERE  tt.valid_yn = 'Y'
             --AND    tt.division_id = @p_division_id
             AND    tt.operation_id IN ( SELECT  b.segment2 AS operation_id
                                         FROM    scm_adm_lookup_master_detail a WITH(NOLOCK)
                                                 INNER JOIN scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                 ON  a.segment1    = b.segment1
                                                 AND a.lookup_type = 'LOCATION_GROUP'
                                                 AND a.segment4    = 'Y' -- Capa 공정 여부 
                                                 AND a.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
                                                 AND a.valid_yn    = 'Y'
                                                 AND b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                 AND b.valid_yn    = 'Y'
                                                 AND b.segment3    = 'Y' -- Capa 세부 공정 여부 

                                                 AND a.segment3    = 'A' -- 셀 Capa  공정(A3000, A9000)
                                       ) -- LINE CAPA 대상인 셀 공정 
             GROUP BY tt.division_id, tt.plant_site_id, tt.item_id
              
        ) -- WITH문 종료
        INSERT INTO #SCP_MST_CHAR_CAPA_TEMP
        (      division_id
            ,  plant_site_id
            ,  item_id
            ,  daily_capa_qty
        )
        SELECT wtt.division_id
             , wtt.plant_site_id
             , wtt.item_id
          
             , wtt.sum_daily_capa_qty AS daily_capa_qty
        FROM  with_tact_time wtt
        WHERE NOT EXISTS ( SELECT 1
                           FROM   scp_mst_char_capa a WITH (NOLOCK)
                           WHERE  a.division_id        = wtt.division_id
                           AND    a.plant_site_id      = wtt.plant_site_id
                           AND    a.item_id            = wtt.item_id 
                           --AND    a.valid_yn           = 'Y' 
                           AND    (a.created_by         <> @v_batch_user --'scp_batch'
                                   OR
                                   a.last_updated_by    <> @v_batch_user)
                         )      
        ;
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'1.SCP_MST_CHAR_CAPA 생성 데이터 임시테이블에 생성'
        SET @v_description = N'SCP_MST_CHAR_CAPA INSERT 대상데이터 임시테이블에 생성' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user


        ---------------------------------------------------------------------------- 
        -- 2. SCP_MST_CHAR_CAPA 삭제
              --자동생성된 데이터만( created_by, last_updated_by 가 'scp_batch' 인 데이터) 삭제
        ---------------------------------------------------------------------------- 
        DELETE FROM SCP_MST_CHAR_CAPA 
        WHERE created_by     = @v_batch_user --'scp_batch'
        AND   last_updated_by= @v_batch_user --'scp_batch'
        --AND   division_id    = @p_division_id
        --    OR valid_yn = 'N'
        ;                       
        
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'2.DELETE '+@v_table_id;
        SET @v_description = N'사용자 아이디가 scp_batch로 생성된 데이터 삭제처리' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
        ----------------------------------------------------------- 
        -- 3.SCP_MST_CHAR_CAPA 입력
        -----------------------------------------------------------

        INSERT INTO /* PR_SCP_MST_CHAR_CAPA */ SCP_MST_CHAR_CAPA  
        (  division_id
         , plant_site_id
         , item_id
         , daily_capa_qty
         , valid_yn
         , created_by 
         , creation_date
         , last_updated_by
         , last_update_date
        )
        SELECT tt.division_id
             , tt.plant_site_id
             , tt.item_id
             , tt.daily_capa_qty
             , 'Y'              AS valid_yn
             , @v_batch_user    AS created_by 
             , @d_create_date   AS creation_date
             , @v_batch_user    AS last_updated_by
             , @d_create_date   AS  last_update_date
        FROM  #SCP_MST_CHAR_CAPA_TEMP tt
        ;
        
        
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'3.INSERT INTO '+@v_table_id + N' (TOTAL제외)';
        SET @v_description = N'SCP_MST_CHAR_CAPA 데이터 생성(TOTAL 제외)' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;
        ----------------------------------------------------------- 
        -- 4.SCP_MST_CHAR_CAPA  TOTAL 생성
        --    - 위 2.에서 생성된 데이터에서 division_id, plant_site_id 별 TOTAL값 생성
        --      ( TOTAL 은  item_id컬럼에 '-'값으로, daily_capa_qty = 1999999999 값으로 입력함)
        -----------------------------------------------------------

        INSERT INTO /* PR_SCP_MST_CHAR_CAPA */ scp_mst_char_capa  
        (  division_id
         , plant_site_id
         , item_id
         , daily_capa_qty
         , valid_yn
         , created_by 
         , creation_date
         , last_updated_by
         , last_update_date
        )
        SELECT division_id
            ,  plant_site_id
            ,  '-'              AS item_id
            ,  1999999999       AS daily_capa_qty    -- 1999999999은 하드코딩값
            , 'Y'               AS valid_yn
            ,  @v_batch_user    AS created_by        --'scp_batch'
            ,  @d_create_date   AS creation_date
            ,  @v_batch_user    AS last_updated_by   --'scp_bacth'
            ,  @d_create_date   AS last_update_date

        FROM   scp_mst_char_capa WITH (NOLOCK)
        --WHERE  valid_yn = 'Y'
        GROUP BY division_id, plant_site_id
        ;
       
        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT ;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'4.INSERT INTO '+@v_table_id + N' (TOTAL)';
        SET @v_description = N'SCP_MST_CHAR_CAPA TOTAL 데이터 생성' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

      END;

    END TRY

    BEGIN CATCH
      
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

      RETURN -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =0
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    RETURN 1 


  END;

