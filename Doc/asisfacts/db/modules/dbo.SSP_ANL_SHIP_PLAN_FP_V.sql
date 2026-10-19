
/*    
 * Program ID   : SSP_ANL_SHIP_PLAN_FP_V    
 * Description  : FP 제공용 SHIP PLAN (Cell, Pack)    
 * Program History    
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2022.09.01   SSP Pjt.       Created.     
 *    
 */    
CREATE VIEW [dbo].[SSP_ANL_SHIP_PLAN_FP_V]     
AS    
    
 SELECT P.PLAN_TYPE    
      , P.DIVISION_ID    
   , FS.COMPANY_ID    
   , P.ITEM_ID                                                                       
   , FS.OPERATION_GROUP                                                 
   , P.FROM_SITE AS SITE_CODE         
   , FS.PLANT_ID    
      , [DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SOLDTO_CODE')         AS CUSTOMER_CODE    
      , [DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SOLDTO_DESCRIPTION')  AS CUSTOMER_NAME    
      , [DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SHIPTO_CODE')         AS SHIP_TO_CODE                                                 
      , [DBO].[FN_GET_SITE_CUSTOMER_INFO] (P.DIVISION_ID,P.TO_SITE,'SHIPTO_DESCRIPTION')  AS SHIP_TO_PARTY    
      , P.TO_SITE  AS DEST_SITE_CODE         
      , TS.PLANT_ID  AS DEST_PLANT_ID    
      , TS.SITE_TYPE  AS DESTINATION_SITE_TYPE    
      , P.YYYYMMDD  AS EXFACTORY_YYYYMMDD                                                            
      , P.QTY      AS EXFACTORY_QTY     
      , CASE WHEN P.FCST_TYPE ='-' THEN 'MPS' ELSE P.FCST_TYPE END  AS ORDER_TYPE     
   , P.INCOTERMS    
      , P.TRANSPORT_MODE       
   , P.PROJECT_CODE    
   , P.ETD_DATE    
   , P.ETA_DATE    
   , [DBO].[FN_GET_SSP_DOM_EXP] (P.DIVISION_ID, P.FROM_SITE, P.TO_SITE) AS MARKET  
   , P.ETA_DATE AS RECEIVE_YYYYMMDD  
   FROM (    
        SELECT     
               C.DIVISION_ID    
             , C.ITEM_ID        
             , C.FROM_SITE       
             , C.TO_SITE        
             , C.YYYYMMDD        
             , C.BOD_ID         
             , C.ROUTE_ID        
             , C.QTY    
    , C.INCOTERMS    
             , C.TRANSPORT_MODE     
             , C.PROJECT_CODE      
             , C.FCST_TYPE       
             , C.ETD_DATE        
             , C.ETA_DATE        
             , C.CONFIRM_ID      
             , C.REQUESTOR    
    , 'Confirm' AS PLAN_TYPE    
          FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)     
         WHERE C.YYYYMMDD >= CONVERT(VARCHAR, getdate() - 1 ,112)     
           AND C.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, 56, getdate()) ,112)    
           AND C.CHANGE_TYPE = 'C' -- 확정    
           AND C.BIZ_TYPE    <> 'E'    
    
         UNION ALL     
    
        --확정기간 이후 출하요청     
    
        SELECT R.DIVISION_ID          
             , R.ITEM_ID        
             , R.PLANT_SITE_ID  AS FROM_SITE    
             , R.SCM_SITE_ID   AS TO_SITE      
             , R.YYYYMMDD        
             , R.BOD_ID         
             , B.ROUTE_ID     
             , R.QTY      
             , ISNULL(B.SSP_INCOTERMS, R.INCOTERMS)   AS INCOTERMS      
             , R.TRANSPORT_MODE     
             , R.PROJECT_CODE      
             , R.FCST_TYPE       
             , R.YYYYMMDD   AS ETD_DATE        
             , [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, R.BOD_ID, R.YYYYMMDD) AS ETA_DATE           
             , '-'     AS CONFIRM_ID     
             , R.LAST_UPDATED_BY  AS REQUESTOR    
    , 'Plan'    AS PLAN_TYPE    
          FROM DM_PLN_SHIPMENT_REQ R WITH(NOLOCK)     
               JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK)     
            ON B.DIVISION_ID  = R.DIVISION_ID    
           AND B.BOD_ID   = R.BOD_ID    
         WHERE R.MEASURE = 'SHIP_REQ'    
             AND R.YYYYMMDD >= CASE WHEN [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID,R.PLANT_SITE_ID) <= 0 THEN CONVERT(VARCHAR, getdate() ,112)    
                                    ELSE  CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID,R.PLANT_SITE_ID) , CONVERT(VARCHAR, getdate() ,112)) ,112)    
                               END      
             AND R.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, 56, getdate()) ,112)    
             AND ISDATE(R.YYYYMMDD) = 1    
    
        ) P    
    JOIN SCM_MST_SITE AS FS with(nolock)    
    ON P.DIVISION_ID  = FS.DIVISION_ID     
   AND P.FROM_SITE  = FS.SCM_SITE_ID    
   AND FS.VALID_YN  = 'Y'    
    JOIN SCM_MST_SITE AS TS with(nolock)    
    ON P.DIVISION_ID  = TS.DIVISION_ID     
   AND P.TO_SITE   = TS.SCM_SITE_ID    
   AND TS.VALID_YN  = 'Y'    
    WHERE 1 = 1    
      AND P.QTY > 0     
