



/*
 * Program ID   : SSP0200_GET_SHIPMENT_DIVISION
 * Description  : DIVISION , COMPANY 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2026/01/14   chkim.68       신규작성
 * 2026/01/14   DIVISION , COMPANY 정보
 * 2026/01/14   강주용			[E20260206-001938] VP 권한 확장 - UP_FX_GetCommonDataList_SCP의 MyDivisionInEE를 복사함
 */

CREATE PROCEDURE [dbo].[SSP0200_GET_SHIPMENT_DIVISION]   
   @Param1 NVARCHAR(100) -- NOWGroupID
 , @Param2 NVARCHAR(100) -- UserID
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	BEGIN	
		  Declare @AuthTypePara varchar(100) = 'D'
		  if(@Param1 = 'JV Planner') SET @AuthTypePara = 'J';

		  SELECT CODE,  NAME, MAX(ATTRIBUTE1) AS ATTRIBUTE1
		  FROM 
		  (

		  SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
		       , 1 AS ATTRIBUTE1 -- [E20260206-001938] VP 권한 확장
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		   WHERE DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = @AuthTypePara)
		   GROUP BY DIVISION_ID
		 UNION
		  SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME
		       , 0 AS ATTRIBUTE1
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)
		   WHERE DIVISION_ID IN (SELECT VS.DIVISION_ID
								   FROM SCM_MST_SITE AS VS WITH(NOLOCK) 
								   JOIN SCM_MST_SITE AS FS WITH(NOLOCK) 
								     ON VS.ATTRIBUTE9 = FS.SCM_SITE_ID
								   JOIN TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) 
								     ON FS.DIVISION_ID = A.CODE
								    AND FS.SITE_TYPE = 'PLANT'
							      WHERE A.AuthType = @AuthTypePara
								    AND A.GroupID  = @Param1 
								    AND A.UserID   = @Param2
                                 )
		   GROUP BY DIVISION_ID

		   
		   )  A
		   GROUP BY CODE, NAME
		   ORDER BY CODE
		   ;
	END	

END
