CREATE PROCEDURE [dbo].[PR_SCM_MANUAL_BOM_IMPLOSION_JKS]
   @p_master_id  nvarchar(max) = '-',  @p_plan_id    nvarchar(max) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_MANUAL_BOM_IMPLOSION                                               **/
/** 프로그램 명   :                                                                           **/
/** 설 명         : BOM전개 Buf 테이블 생성                                                   **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2017.10.19    ksjeon       최초 작성                                                      **/
/***********************************************************************************************/


BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  -- 필수 칼럼
  DECLARE @v_master_id      nvarchar(30)
  DECLARE @v_plan_id        nvarchar(30)

  -- LOG 용 변수 설정
  DECLARE @v_proc_name      nvarchar(100) = 'PR_SCM_MANUAL_BOM_IMPLOSION'
  DECLARE @v_table_name     nvarchar(100)
  DECLARE @v_message        nvarchar(250)
  DECLARE @v_descr          nvarchar(250)
  DECLARE @n_row_count      Integer  = 0
  DECLARE @n_log_count      Integer  = 0
  DECLARE @v_log_code       nvarchar(10)
  DECLARE @n_cnt            Integer  = 0
  DECLARE @v_confirm_date   date
  DECLARE @v_order_date_code nvarchar(10)
  
  DECLARE @sysdate          DATETIME2 = GETDATE()
  DECLARE @v_insert_dttm    date

  DECLARE @v_temp1          nvarchar(1000)
  DECLARE @v_temp2          nvarchar(1000)

  
  SET @v_master_id    = @p_master_id
  SET @v_plan_id      = @p_plan_id
  
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    -- BOM 전개 테이블 생성
    BEGIN
    
      BEGIN

    
      SET @v_table_name = 'TH_BUF_SCM_BOM_IMPLOSION'

          
      DELETE FROM TH_BUF_SCM_BOM_IMPLOSION
      WHERE   MASTER_ID     = @v_master_id
      and     dpp_plan_id   = @v_plan_id

      SET @v_message = @@ROWCOUNT
      SET @n_log_count += 1
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, 'TH_BUF_SCM_BOM_IMPLOSION', 'DELETE', @n_log_count, null, @v_message, null 


                      
      DECLARE
        @C_BOM_IMPLOSION$sales_model_id   nvarchar(150)

      
        DECLARE
          C_BOM_IMPLOSION CURSOR LOCAL FOR

            select distinct item_id 
            from   FP_DAILY_NET_DEMAND_H
            where  instance_id = @v_master_id
            and    dpp_plan_id = @v_plan_id
            order by item_id

--            select distinct sales_model_id
--            from   th_eng_net_demand
--            where  master_id = @v_master_id
--            and    plan_id = @v_plan_id
--            and    qty > 0
--            order by sales_model_id            


        OPEN C_BOM_IMPLOSION

          WHILE 1 = 1
           
            BEGIN

              FETCH C_BOM_IMPLOSION
               INTO @C_BOM_IMPLOSION$sales_model_id

                IF @@FETCH_STATUS <> 0
                  BREAK

                BEGIN

                  -- MS SQL 의 Connet by 절 ( 상 -> 하위로 전개 )
                  with buf_bom_level --( parent_item_id, child_item_id, nLevel )
                  as (
                       SELECT distinct a.child_item_id, a.parent_item_id, 1 as nLevel 
                       FROM    SCM_BOM_M A,
                               (
                                SELECT distinct A.instance_id, b.COMPANY_ID, b.DIVISION_ID, b.SITE_ID, PLANT_ID
                                FROM   FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                       SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                                WHERE  1=1
                                and    A.INSTANCE_ID = @v_master_id
                                AND    A.FACTORY_ID = B.FACTORY_ID
                               ) b 
                       WHERE   1=1
                       and     a.COMPANY_ID  = b.COMPANY_ID
                       and     a.DIVISION_ID = b.DIVISION_ID
                       and     a.SITE_ID     = b.SITE_ID
                       and     a.PLANT_ID    = b.PLANT_ID
                       and     a.parent_item_id =  @C_BOM_IMPLOSION$sales_model_id
                       union all
                       SELECT  a.child_item_id, a.parent_item_id, nLevel + 1 
                       FROM    SCM_BOM_M A, buf_bom_level b,
                               (
                                SELECT A.instance_id, b.COMPANY_ID, b.DIVISION_ID, b.SITE_ID, PLANT_ID
                                FROM   FP_INSTANCE_FACTORY_M A,   -- INSTANCE 별 FACTORY ID
                                       SCM_FACTORY_M         B    -- FACTORY 별 SITE ID
                                WHERE  1=1
                                and    A.INSTANCE_ID = @v_master_id
                                AND    A.FACTORY_ID = B.FACTORY_ID
                               ) c
                       WHERE   1=1
                       and     a.parent_item_id = b.child_item_id
                       and     a.COMPANY_ID  = c.COMPANY_ID
                       and     a.DIVISION_ID = c.DIVISION_ID
                       and     a.SITE_ID     = c.SITE_ID
                       and     a.PLANT_ID    = c.PLANT_ID
                      )
                  insert into TH_BUF_SCM_BOM_IMPLOSION ( master_id, dpp_plan_id, sales_model_id, child_item_id, parent_item_id, nLevel, insert_id, insert_time)    
                  select distinct @v_master_id, @v_plan_id, @C_BOM_IMPLOSION$sales_model_id, child_item_id, parent_item_id, nLevel, @v_proc_name as insert_id,  GETDATE() as insert_time
                  from   buf_bom_level
                    

                END;
                  
            END

        CLOSE C_BOM_IMPLOSION

        DEALLOCATE C_BOM_IMPLOSION

        --LOG 생성
        SET @v_message = @n_row_count
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
        
      END   -- WHILE END
        

    END
    
  END TRY

  BEGIN CATCH

    SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
    commit;
  END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
