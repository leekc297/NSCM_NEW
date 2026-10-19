
/**
  * PROJECT       : FN_GET_SCP_ITEM_ACTIVE
  * VIEW NAME     : 
  * DESCRIPTION   : ITEM ACTIVE Flag Check
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2023-06-30   vadabi3        INITIAL
  * 2023-07-03   vadabi3        Material 조건 적용
  -----------------------------------------------------------------
  SELECT * FROM FN_GET_SCP_ITEM_ACTIVE('MODEL','1000116,1002452')
*/

CREATE FUNCTION [dbo].[FN_GET_SCP_ITEM_ACTIVE]  
(
 @p_gubun NVARCHAR(MAX)
,@p_value NVARCHAR(MAX)
)
RETURNS @Item_Active TABLE
(
	   code  NVARCHAR(1000)
	   ,active NVARCHAR(1000)
)AS
BEGIN

	--DECLARE @arr_value       NVARCHAR(MAX)   = '';
	--DECLARE @arr_nickname    NVARCHAR(MAX)   = '';
	--SELECT @arr_value	= ISNULL(@arr_value	+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@p_value,',')

		DECLARE @v_item_id          NVARCHAR(MAX)   = N'';

	    DECLARE CUR_GET_ITEM_ACTIVE CURSOR FOR
        SELECT  TOKEN 
        FROM    dbo.STRING_SPLIT(@p_value	, ',')

        OPEN CUR_GET_ITEM_ACTIVE;
        FETCH NEXT FROM CUR_GET_ITEM_ACTIVE INTO @v_item_id

        WHILE @@FETCH_STATUS = 0
        BEGIN

			INSERT @Item_Active	
			-- Masterial 조건 적용 후	
			  SELECT DISTINCT A.ITEM_ID, A.ACTIVE_FLAG
				FROM SCM_MST_ITEM_SN  A
	 INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK)  ON    A.ITEM_CLASS = B.CLASS_ID
			   WHERE B.USE_FLAG = 'Y'
			     AND A.ACTIVE_FLAG = 'N'
				 and item_id = @v_item_id
				 --AND EXISTS (
		   -- 			SELECT 1
		   -- 			  FROM LGCE_FP_TR.dbo.FP_USER_ROLE_INFO_V B WITH(NOLOCK)
		   -- 			 WHERE A.COMPANY_ID  = B.COMPANY_ID
		   -- 			   AND A.DIVISION_ID = B.DIVISION_ID
		   -- 			   AND A.SITE_ID     = B.SITE_ID
		   -- 			 --AND B.USER_ID     ='vadabi3'
		   --             )
				
			
			
			-- Masterial 조건 적용 전				
			--select distinct item_id, active_flag	
			--from SCM_MST_ITEM_SN 	WITH(NOLOCK)	
			--where active_flag = 'N'			    
			--and item_id = @v_item_id


	        FETCH NEXT FROM CUR_GET_ITEM_ACTIVE INTO @v_item_id
        END

        CLOSE CUR_GET_ITEM_ACTIVE
        DEALLOCATE CUR_GET_ITEM_ACTIVE

		RETURN;
END;
