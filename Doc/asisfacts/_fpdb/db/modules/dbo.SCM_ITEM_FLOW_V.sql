
CREATE VIEW [dbo].[SCM_ITEM_FLOW_V]
AS
/*
 * Program ID   : SCM_ITEM_FLOW_V
 * Description  : SCM_ITEM_FLOW_V
 * Program History
 *==================================================================================
 *   Date       In Charge   Description
 *==================================================================================
 * 2021.12.08   scpark      기존 저성능 뷰 튜닝
                            불필요한 조인 힌트 모두 제거. ANSI조인으로 변경
  
 * Example 
    sp나 함수일때는 실행예제 넣어준다.
    
 */
SELECT 
    A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID,
    A.OPERATION_ID, A.OPERATION_SEQ, A.FLOW_ID,
    CASE WHEN X.OPERATION_LOT_SIZE IS NULL THEN B.OPERATION_LOT_SIZE
        ELSE X.OPERATION_LOT_SIZE
    END OPERATION_LOT_SIZE,
    --B.OPERATION_LOT_SIZE, X.OPERATION_LOT_SIZE,       
    B.MIN_LOT_SIZE,B.LOT_SIZE_UOM,  
    B.BUFFER_TIME, B.BUFFER_TIME_UOM, B.TAT, B.TAT_UOM,
    CASE WHEN C.CAPA_TYPE IN ('TAT', 'TAT_CAPA','TAT_MOVE','BATCH') THEN 'Y'
        ELSE 'N'
    END  TAT_FLAG, 
    C.CAPA_TYPE AS TAT_TYPE,
    B.PRECEDE_PRODUCING_TERM, B.PRECEDE_PRODUCING_TERM_UOM, 
    B.INITIAL_PRODUCING_LEAD_TIME, B.INITIAL_PRODUCING_LEAD_TIME_UOM, 
    B.ACTIVE_FLAG
FROM
(
    --#region d1서브
    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.FACTORY_ID, A.ITEM_ID,
            A.OPERATION_ID, A.OPERATION_SEQ, A.FLOW_ID
    FROM    
    (
         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,
                B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ
        FROM   DBO.SCM_ITEM_M AS A(NOLOCK)
            JOIN DBO.SCM_OPERATION_FLOW_M AS B(NOLOCK)  ON A.COMPANY_ID    = B.COMPANY_ID
                                                            AND A.DIVISION_ID   = B.DIVISION_ID
                                                            AND A.SITE_ID       = B.SITE_ID
                                                            AND
                                                            (
                                                                A.FLOW_ID               = B.FLOW_ID                                                                
                                                                OR A.FORMATION_FLOW_ID  = B.FLOW_ID
                                                            )                                                            
            JOIN DBO.SCM_ITEM_CLASS_M AS C(NOLOCK)      ON A.ITEM_CLASS = C.CLASS_ID
        WHERE  A.ACTIVE_FLAG = N'Y'
            AND B.ACTIVE_FLAG = N'Y'
            AND C.USE_FLAG = N'Y'

        --UNION ALL

        --SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID,
        --        B.FLOW_ID, B.OPERATION_ID, B.OPERATION_SEQ
        --FROM   SCM_ITEM_M A(NOLOCK)
        --    JOIN SCM_OPERATION_FLOW_M B(NOLOCK)      ON     A.COMPANY_ID = B.COMPANY_ID
        --                                                            AND    A.DIVISION_ID = B.DIVISION_ID
        --                                                            AND    A.SITE_ID = B.SITE_ID
        --                                                            AND    A.FORMATION_FLOW_ID = B.FLOW_ID
        --                                                            AND    B.ACTIVE_FLAG = 'Y'
        --    JOIN SCM_ITEM_CLASS_M C(NOLOCK)          ON   A.ITEM_CLASS = C.CLASS_ID
        --                                                            AND    C.USE_FLAG = 'Y'
        --WHERE  A.ACTIVE_FLAG = 'Y'
    ) AS A
    JOIN
    (        
        -- 3. ansi 조인으로 변경
        --region d2 3개테이블
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID
        FROM   DBO.SCM_ITEM_LINE_ASSIGN_M(NOLOCK) A
            JOIN DBO.SCM_BOM_M(NOLOCK) B                ON A.COMPANY_ID = B.COMPANY_ID
                                                            AND A.DIVISION_ID   = B.DIVISION_ID
                                                            AND A.SITE_ID       = B.SITE_ID
                                                            AND A.PLANT_ID      = B.PLANT_ID
                                                            AND A.ITEM_ID       = B.PARENT_ITEM_ID                                                             
            JOIN DBO.SCM_OPERATION_M(NOLOCK) C          ON A.COMPANY_ID = C.COMPANY_ID
                                                            AND A.DIVISION_ID   = C.DIVISION_ID
                                                            AND A.SITE_ID       = C.SITE_ID
                                                            AND A.OPERATION_ID  = C.OPERATION_ID
        WHERE  1 = 1  
            AND A.ACTIVE_FLAG = N'Y'   
            AND B.EFF_END_DATE > GETDATE()                       
            AND C.WO_FLAG = N'Y'
    --				AND    A.ITEM_ID = 'ACPP1034U-A1'
        GROUP  BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID      

        UNION ALL
        
        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID
        FROM DBO.SCM_ITEM_LINE_ASSIGN_M(NOLOCK) AS A
            JOIN DBO.SCM_OPERATION_M(NOLOCK) AS B       ON A.COMPANY_ID = B.COMPANY_ID
                                                            AND A.DIVISION_ID   = B.DIVISION_ID
                                                            AND A.SITE_ID       = B.SITE_ID
                                                            AND A.OPERATION_ID  = B.OPERATION_ID
        WHERE   A.ACTIVE_FLAG = N'Y'
            AND B.MO_FLAG = N'Y'
    --                AND    A.ITEM_ID = 'ACPP1034U-A1'
        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID             
        --endregion
    ) B
        ON A.COMPANY_ID = B.COMPANY_ID
            AND A.DIVISION_ID   = B.DIVISION_ID
            AND A.SITE_ID       = B.SITE_ID
            AND A.ITEM_ID       = B.ITEM_ID
            AND A.OPERATION_ID  = B.OPERATION_ID
    --#endregion
) A
    LEFT JOIN DBO.SCM_OPERATION_MOVE_M AS B(NOLOCK)     ON A.COMPANY_ID = B.COMPANY_ID      -- d. MERGE조인 힌트 뺌
                                                            AND A.DIVISION_ID   = B.DIVISION_ID
                                                            AND A.SITE_ID       = B.SITE_ID
                                                            AND A.PLANT_ID      = B.PLANT_ID
                                                            AND A.FACTORY_ID    = B.FACTORY_ID
                                                            AND A.OPERATION_ID  = B.OPERATION_ID
                                                            AND B.ACTIVE_FLAG   = N'Y'
    JOIN DBO.SCM_OPERATION_M AS C(NOLOCK)               ON A.COMPANY_ID = C.COMPANY_ID      -- f. hash뺌
                                                            AND A.DIVISION_ID   = C.DIVISION_ID
                                                            AND A.SITE_ID       = C.SITE_ID
                                                            AND A.OPERATION_ID  = C.OPERATION_ID
    LEFT JOIN DBO.SCM_ITEM_FLOW_EXCEPT_M AS X(NOLOCK)   ON A.COMPANY_ID = X.COMPANY_ID       -- g. outer 뺌
                                                            AND A.DIVISION_ID   = X.DIVISION_ID
                                                            AND A.SITE_ID       = X.SITE_ID
                                                            AND A.PLANT_ID      = X.PLANT_ID
                                                            AND A.FACTORY_ID    = X.FACTORY_ID
                                                            AND A.OPERATION_ID  = X.OPERATION_ID
                                                            AND A.ITEM_ID       = X.ITEM_ID
