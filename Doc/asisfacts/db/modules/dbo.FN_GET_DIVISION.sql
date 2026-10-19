

/*  
 * Program ID   : FN_GET_DIVISION                                                               
 * Description  : 권한에 해당하는 사업부 조회(EE 포함)
 * 실행 예제    : SELECT * FROM dbo.FN_GET_DIVISION('ADMIN', 'iamarock')
 * Program History  
 *===================================================================================================  
 *Date          In Charge       Description  
 *===================================================================================================  
 *2023.03.28    chaan           V1.1.0      Initial Release PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 
 *                                                                                                    
*/  
--DROP FUNCTION [dbo].[FN_GET_DIVISION]
CREATE FUNCTION [dbo].[FN_GET_DIVISION]
(
      @p_group_id     NVARCHAR(MAX)     = ''
    , @p_user_id      NVARCHAR(MAX)     = ''
)
RETURNS TABLE
AS
RETURN
(
    SELECT    DIVISION_ID                           AS CODE
            , DIVISION_ID + ' ' + DIVISION_NAME     AS NAME
            , DAILY_PLAN_PERIOD
            , VALID_YN
            , CREATION_DATE
            , CREATED_BY
            , LAST_UPDATE_DATE
            , LAST_UPDATED_BY
            , ATTRIBUTE1
            , ATTRIBUTE2
            , ATTRIBUTE3
            , ATTRIBUTE4
            , ATTRIBUTE5
            , ATTRIBUTE6
            , ATTRIBUTE7
            , ATTRIBUTE8
            , ATTRIBUTE9
            , ATTRIBUTE10
    FROM    dbo.SCM_MST_DIVISION WITH(NOLOCK)
    WHERE   1=1
        AND DIVISION_ID IN (SELECT CODE 
		                    FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
						    WHERE  1=1
						    AND    (GroupID LIKE '%' + @p_group_id + '%')
						    AND    (UserID  LIKE '%' + @p_user_id + '%')					
						    AND    AuthType = 'D')
        AND VALID_YN = 'Y'
    --ORDER BY ATTRIBUTE1
)

