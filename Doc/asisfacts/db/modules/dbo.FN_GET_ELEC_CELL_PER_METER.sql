
CREATE FUNCTION [dbo].[FN_GET_ELEC_CELL_PER_METER]
      (
       @P_DIVISION_ID      NVARCHAR(30),  
       @P_PLANT_ID         NVARCHAR(30),
       @P_ITEM_ID          NVARCHAR(30)
       )
       RETURNS NUMERIC(10,5)
       WITH EXEC AS CALLER       
AS

/***************************************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_ELEC_CELL_PER_METER
  * DESCRIPTION   : 전극ITEM의 CELL/M 환산값을 리턴
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-03-09   YYDOK        INITIAL
  * 2018-03-28   YYDOK        P_SITE_ID PARAMETER제거
  * 2018-05-25   YYDOK        COMPANY_ID 조건추가
  * 2018-05-28   YYDOK        속도개선을 위한 조인순서조정,전극아니면 리턴처리
  * 2018-10-04   YYDOK        E2000공정으로 변경, 관리되는 환산수량없으면 1/BOM기준 소요량으로 반영
  *************************************************************************************************/
BEGIN
  
   DECLARE @X_SITE_ID     NVARCHAR(10);
   DECLARE @X_COMPANY_ID  NVARCHAR(10);   
   DECLARE @X_VALUE       NUMERIC(10,5) =  0;

   /* 데이타 검증.
      item_id = 'APCAN0532A'
      적용 대표모델,  ACEN1021U-A1, SITE A001, PLANT A040
      BOM 누적소요량 2.5755
      CELL/M = 1 CELL/2.5755M = 0.388274 
      */
     
     IF LEFT(@P_ITEM_ID,5) NOT IN ('APCAN','APCCA','APCCS') BEGIN RETURN NULL; END
      
/*     
     IF  @P_PLANT_ID ='' BEGIN SET  @P_PLANT_ID = NULL; END;
     
     IF ISNULL(@P_PLANT_ID,'') <> ''
        BEGIN
             SELECT TOP 1 @X_SITE_ID = SITE_ID,@X_COMPANY_ID = COMPANY_ID
               FROM SCM_MST_PLANT_SN WITH(NOLOCK)
              WHERE 1=1
                AND PLANT_ID = @P_PLANT_ID;
        END
      ELSE
        BEGIN
            SET @X_SITE_ID = NULL;
        END
*/ 

/*  
     SELECT TOP 1 @X_VALUE  = VALUE
       FROM SCM_MST_ITEM_CONV_CALC_SN C WITH(NOLOCK),  -- FACTORY별로 여러건이 존재함.
            SCM_MST_ITEM_SN           I WITH(NOLOCK)
      WHERE 1=1
        AND I.DIVISION_ID              = @P_DIVISION_ID
     --   AND I.COMPANY_ID               = ISNULL(@X_COMPANY_ID ,I.COMPANY_ID)        
     --   AND I.SITE_ID                  = ISNULL(@X_SITE_ID    ,I.SITE_ID)
     --   AND C.PLANT_ID                 = ISNULL(@P_PLANT_ID   ,C.PLANT_ID)
        AND I.ITEM_ID                  = @P_ITEM_ID        
        AND C.CATEGORY                 = 'Pancake (cell/m)'
        AND C.MAX_VER_FLAG             = 'Y'
        AND C.OPERATION                = 'E2000'  --COATING
        AND C.DIVISION_ID              = I.DIVISION_ID
        AND C.SITE_ID                  = I.SITE_ID
        AND C.ITEM_ID                  = I.ITEM_ID
        AND C.MODEL_ID                 = I.APPLIED_MODEL --대표cell 
        AND C.COMPANY_ID               = I.COMPANY_ID
        AND C.VALUE                    > 0
        ;
*/

--  IF  ISNULL(@X_VALUE,0) <= 0.0 
--      BEGIN
           
           /************************************************************
            * 셀하위 전극BOM소요량은 1셀당 전극M이므로
            *   CELL/M 환산자 = 1.0 / 전극소요량 으로 계산될수있음.
            ************************************************************/

            SELECT  TOP 1 @X_VALUE  = 1.0 / A.ACCUMULATED_CHILD_QTY 
              FROM  [dbo].[SCM_MST_MODEL_FINAL_ITEM_BOM_V] A WITH(NOLOCK)
                  , SCM_MST_ITEM_SN                        I WITH(NOLOCK)  
             WHERE I.DIVISION_ID     = @P_DIVISION_ID
               AND I.ITEM_ID         = @P_ITEM_ID
               AND A.MODEL_ID        = ISNULL(I.APPLIED_MODEL,A.MODEL_ID)
               AND A.division_id     = I.DIVISION_ID
               AND A.CHILD_ITEM_ID   = I.ITEM_ID
               AND A.MODEL_ID        LIKE '_C%' --CELL
               AND A.OPERATION_GROUP_ID = 'E'   --CHILD IS ELECTRODE

  --    END
        
   RETURN  ISNULL(@X_VALUE,0);

END
;
