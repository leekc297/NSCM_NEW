


/*
 * Program ID   : SSP0050_GET_EMPLOYEE_NUMBER_LOAD
 * Description  : EMPLOYEE_NUMBER_LOAD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024/02/21   jilee          요청자,승인자 임직원 사번 조회

 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0050_GET_EMPLOYEE_NUMBER_LOAD]
	  @p_requester			NVARCHAR(100)
	 ,@p_approver			NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT (SELECT EMP_NO FROM LP_SYS_USER_SN A WITH(NOLOCK) WHERE A.USER_ID = @p_requester) AS REQUESTER
          ,(SELECT EMP_NO FROM LP_SYS_USER_SN B WITH(NOLOCK) WHERE B.USER_ID = @p_approver)  AS APPROVER
END
