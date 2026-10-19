

CREATE VIEW [dbo].[SCM_KPI_ITEM_V] AS
/*
 * Program ID   : SCM_KPI_ITEM_V
 * Description  : KPI ITEM MASTER INTERFACE
 *                ITEM TYPE: P(제품),H(반제품),Q(상품),R(원재료) -> SCP계획수립대상은 P,H
 *                OPERATION_GROUP : P (PACK), A (CELL), E (ELECTRODE)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.21  YYDOK         Initial Release 전지본부 GSCM 구축 프로젝트
 * 2018.11.22  YYDOK         item type name칼럼추가
 * 2020.10.28  KSW           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz 대응
 */
SELECT X.DIVISION_ID,
       X.ITEM_ID,
       MAX(X.ITEM_NAME)                 AS ITEM_NAME,
       MAX(X.NICK_NAME)                 AS NICK_NAME,
       CASE  min( case when X.item_type = 'P' then 1   
                       when X.item_type = 'H' then 2    
                       when X.item_type = 'Q' then 3
                       else 4 end )  
           when 1 then 'P' 
           WHEN 2 then 'H'
           WHEN 3 then 'Q'
           ELSE 'R' 
       END                              AS ITEM_TYPE,
       CASE  min( case when X.item_type = 'P' then 1   
                       when X.item_type = 'H' then 2    
                       when X.item_type = 'Q' then 3
                       else 4 end )  
           when 1 then 'Product' 
           WHEN 2 then 'Semi-Product'
           WHEN 3 then 'Goods'
           ELSE 'Raw Material' 
       END                              AS ITEM_TYPE_NAME,       
       MAX(X.ITEM_UOM)                  AS ITEM_UOM,
       MAX(X.SPEC)                      AS SPEC,
       MAX(ISNULL(F.OPERATION_GROUP,
                  -- PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz 대응 - left(FLOW_ID,1) 'R' 을 'P' 으로 대체 - start
				  -- old version
                  --ISNULL(LEFT(F.FLOW_ID,1),
                  --       LEFT(X.FLOW_ID,1)
                  --      )
                  --)
				  (CASE WHEN ISNULL(LEFT(F.FLOW_ID,1), LEFT(X.FLOW_ID,1)) = 'R' THEN 'P' ELSE ISNULL(LEFT(F.FLOW_ID,1), LEFT(X.FLOW_ID,1)) END)
                  )
				  -- PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz 대응 - left(FLOW_ID,1) 'R' 을 'P' 으로 대체 - end
           )  AS OPERATION_GROUP,
       MAX(F.OPERATION_GROUP_ID)        AS OPERATION_GROUP_ID,
       MAX(ISNULL(LEFT(F.FLOW_ID,5),X.FLOW_ID)) AS FLOW_ID,
       MAX(CASE  
               WHEN ( F.OPERATION_GROUP  ='E' OR ISNULL(LEFT(F.FLOW_ID,1),LEFT(X.FLOW_ID,1)) = 'E') then 'ELECTRODE'
               WHEN ( F.OPERATION_GROUP  ='A' OR ISNULL(LEFT(F.FLOW_ID,1),LEFT(X.FLOW_ID,1)) = 'A') then 'CELL' 
             --  WHEN ( F.OPERATION_GROUP  ='P' AND ISNULL(LEFT(F.FLOW_ID,5),LEFT(X.FLOW_ID,5)) = 'P9500' ) then 'PACK'
               WHEN ( ISNULL(F.OPERATION_GROUP,ISNULL(LEFT(F.FLOW_ID,1),LEFT(X.FLOW_ID,1)))  ='P' AND ISNULL(LEFT(F.FLOW_ID,5),LEFT(X.FLOW_ID,5)) = 'P9500' ) then 'PACK'
             --  WHEN ( F.OPERATION_GROUP  ='P' AND ISNULL(LEFT(F.FLOW_ID,5),LEFT(X.FLOW_ID,5)) = 'P5500' ) then 'MODULE'
               WHEN ( ISNULL(F.OPERATION_GROUP,ISNULL(LEFT(F.FLOW_ID,1),LEFT(X.FLOW_ID,1))) ='P' AND ISNULL(LEFT(F.FLOW_ID,5),LEFT(X.FLOW_ID,5)) = 'P5500' ) then 'MODULE'
               WHEN ( ISNULL(LEFT(F.FLOW_ID,5),LEFT(X.FLOW_ID,5)) = 'P5000' OR LEFT(X.ITEM_ID,5) ='AMDAU' ) then 'MODULE'

			   -- PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz 대응 - left(FLOW_ID,1) 'R' 을 'P' 으로 대체 - start
			   WHEN ISNULL(LEFT(F.FLOW_ID,1), LEFT(X.FLOW_ID,1)) = 'R' THEN 'PACK'
			   -- PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz 대응 - left(FLOW_ID,1) 'R' 을 'P' 으로 대체 - end
           ELSE '' 
           END)                       AS OPERATION_GROUP_NAME   
  FROM SCM_MST_ITEM_SN X WITH(NOLOCK)
       LEFT OUTER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
                  ON   X.DIVISION_ID  = F.DIVISION_ID
                  AND  X.ITEM_ID      = F.ITEM_ID
 WHERE X.ACTIVE_FLAG ='Y'
 GROUP BY 
       X.DIVISION_ID,
       X.ITEM_ID

