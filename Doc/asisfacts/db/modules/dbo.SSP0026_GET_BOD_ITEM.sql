/****************************************************************************************************/
/* Program ID  : SSP0026_GET_ITEM_POPUP													*/
/* Description :																	*/
/* Usage       :																	*/
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/04/20  KIMYONGHO    신규추가													*/
/* 2021/09/02   KIMYONGHO      scp_mst_bod_n_v -> SCP_MST_BOD_N_V 변경					*/
/****************************************************************************************************/


CREATE PROCEDURE [dbo].[SSP0026_GET_BOD_ITEM]  
  @p_division_id		NVARCHAR(30),
  @p_from_site_id		NVARCHAR(50),
  @p_to_site_id			NVARCHAR(30),
  @p_item_id			NVARCHAR(50),
  @p_bod_id				NVARCHAR(50)
AS
BEGIN
	
  SET NOCOUNT ON;
	
SELECT V.DIVISION_ID 
,      V.BOD_ID 
,      A.ITEM_ID 
,      V.INCOTERMS 
,      V.PRIORITY
,      V.TRANSPORT_MODE 

FROM    (
			SELECT  DISTINCT B.DIVISION_ID , B.BOD_ID , B.FROM_SITE, B.TO_SITE , B.INCOTERMS, B.TRANSPORT_MODE, B.PRIORITY
			FROM (
					SELECT DIVISION_ID 
					,      BOD_ID
					,      FROM_SITE
					,      TO_SITE 
					-- 20201223 INCOTERMS 변경 MODIFY KIMYONGHO
					,      SSP_INCOTERMS		AS INCOTERMS
					,      TRANSPORT_MODE 
					,      LT_TOTAL_ORIGIN       AS LT_TOTAL    
					,      SHIP_LT_TOTAL_ORIGIN  AS SHIP_LT_TOTAL 
					,      PRIORITY 			
					FROM SCP_MST_BOD_N_V WITH(NOLOCK) 
					WHERE DIVISION_ID = @p_division_id
                    AND   FROM_SITE   = @p_from_site_id
					AND   TO_SITE   = @p_to_site_id
					--AND (( @p_to_site_id  IS NULL OR @p_to_site_id ='ALL' OR @p_to_site_id ='')       OR TO_SITE IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_to_site_id , ',')))	 
					--AND CASE WHEN @p_to_site_id = 'ALL' OR @p_to_site_id = '' THEN @p_to_site_id
					--	ELSE TO_SITE
 				--		END  IN ( SELECT token FROM dbo.String_Split(@p_to_site_id,','))
					--AND (( @p_bod_id  IS NULL OR @p_bod_id ='')       OR BOD_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_bod_id , ',')))	 
					AND   BOD_VALID_YN ='Y'
					AND   FROM_YYYYMMDD  <= GETDATE()
					AND   TO_YYYYMMDD  >= GETDATE()

				)  B 
		
   )  V

    JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , BOD_ID 
	       FROM   SCP_MST_BOD_ITEM WITH(NOLOCK)   -- SCP_MST_BOD_ITEM A WITH(NOLOCK) 
	       WHERE  DIVISION_ID =   @p_division_id
		   AND     (( @p_item_id  IS NULL OR @p_item_id ='')   OR ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))	
          )   A
	  ON A.DIVISION_ID  = V.DIVISION_ID 
	 AND A.BOD_ID       = V.BOD_ID

WHERE V.DIVISION_ID = @p_division_id
AND   V.FROM_SITE   = @p_from_site_id
AND   V.TO_SITE     = @p_to_site_id
 

order by V.PRIORITY


			
END
