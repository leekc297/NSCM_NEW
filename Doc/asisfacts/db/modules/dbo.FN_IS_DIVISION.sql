CREATE FUNCTION [dbo].[FN_IS_DIVISION](@P_DIVISION_ID NVARCHAR(30),  @P_CHECk NVARCHAR(30), @P_TAG NVARCHAR(30) = NULL)
      RETURNS BIT
AS
/****************************************************************************
  * PROJECT       : LG ES GSCM SCP PRJ.
  * FUNCTION NAME : [FN_IS_DIVISION]
  * DESCRIPTION   : 사업부별 체크결과를 반환
  *
  * INPUT         : @P_DIVISION_ID : 사업부ID, @P_CHECk : 체크할 사항
  * OUTPUT        : 
  * USAGE         : 
		- JOINT VENDOR 여부 : SELECT DBO.[FN_IS_DIVISION]('81_HM', 'JV')
		- 자동차사업부및 자동차합작사업부 여부 ;  SELECT DBO.[FN_IS_DIVISION]('81_HM', '자동차')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2023-05-10   KSK        INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @RET BIT = 0
  
   -- 합작법인의 사업부 여부(JV : Joint Ventor)
	IF  @P_CHECk  = 'JV' 
		 select @RET = 1  from SCM_MST_DIVISION 
			where DIVISION_ID = @P_DIVISION_ID 
			AND  ATTRIBUTE3 != @P_DIVISION_ID 

	--데이터 생성시의 사업부 여부
	IF @P_CHECk ='CREATE'
		select @RET = 1 from SCM_MST_DIVISION 
		 where DIVISION_ID = @P_DIVISION_ID  
		 AND  ATTRIBUTE3 = @P_TAG		
    
	-- 소속상의 사업부 여부
	IF @P_CHECk = 'GROUP'	
		select @RET = 1  from SCM_MST_DIVISION 
		 where DIVISION_ID = @P_DIVISION_ID 
		 AND  ATTRIBUTE4 = @P_TAG 

	-- 전극기준의 사업부 여부
	IF @P_CHECk = 'ELECTRODE'	
	BEGIN
		DECLARE @ELECTRODE_GROUP NVARCHAR(30)
		SELECT @ELECTRODE_GROUP = ATTRIBUTE4 FROM SCM_MST_DIVISION
		WHERE DIVISION_ID = @P_TAG
		AND LEFT(@P_TAG, 2) != 'EE' --전극은 비교사업부에서 제외

		select @RET = 1  from SCM_MST_DIVISION 
		 where DIVISION_ID = @P_DIVISION_ID  
		 AND  ATTRIBUTE4 = @ELECTRODE_GROUP
	END

  return ISNULL(@RET, 0)
END
;


