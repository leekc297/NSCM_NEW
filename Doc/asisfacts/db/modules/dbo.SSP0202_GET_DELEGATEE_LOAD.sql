

/*
 * Program ID   : SSP0003_SSP0003_GET_DELEGATEE_LOAD
 * Description  : DELEGATEE_LOAD
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/15   mcTheJ         [CSR ID:4044806] Model PIC 담당자 위임 기능 추가

 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0202_GET_DELEGATEE_LOAD]
	 @p_division_id			NVARCHAR(MAX)
	 ,@p_apploval			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	SELECT
		T0.DELEGATEE_ID
		, T1.Dept_ID
	FROM SSP_MST_DELEGATE T0
	INNER JOIN TB_FX_USER T1
	ON T1.UserID = T0.DELEGATEE_ID
	WHERE T0.DIVISION_ID =  @p_division_id
	AND T0.USER_ID = @p_apploval
	AND T0.VALID_YN = 'Y'
	AND CONVERT(NVARCHAR(8), GETDATE(), 112) BETWEEN T0.FROM_DATE AND T0.TO_DATE
END

