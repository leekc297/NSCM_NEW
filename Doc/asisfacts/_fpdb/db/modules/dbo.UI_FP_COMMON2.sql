/*
 * Program ID   : UI_FP_COMMON
 * Description  : 공통 코드성 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   				Initial	Release GSCM UI통합
 */



CREATE PROCEDURE [dbo].[UI_FP_COMMON2]
	  @Code	NVARCHAR(100)
    , @USER_ID NVARCHAR(100)
	, @NON_AUTH NVARCHAR(10)
	, @SAVE_AUTH NVARCHAR(10)
	, @Param1 NVARCHAR(MAX)  
	, @Param2 NVARCHAR(MAX)  
	, @Param3 NVARCHAR(MAX)  
	, @Param4 NVARCHAR(MAX)  
	, @Param5 NVARCHAR(MAX)
	, @Param6 NVARCHAR(MAX)
	, @Param7 NVARCHAR(MAX)
	, @Param8 NVARCHAR(MAX)
	, @Param9 NVARCHAR(MAX)
	, @Param10 NVARCHAR(MAX)
	, @Param11 NVARCHAR(MAX)
	, @Param12 NVARCHAR(MAX)
	, @Param13 NVARCHAR(MAX)
	, @Param14 NVARCHAR(MAX)
	, @Param15 NVARCHAR(MAX)
	, @Param16 NVARCHAR(MAX)
	, @Param17 NVARCHAR(MAX)
	, @Param18 NVARCHAR(MAX)
	, @Param19 NVARCHAR(MAX)
	, @Param20 NVARCHAR(MAX)
	, @Param21 NVARCHAR(MAX)
	, @Param22 NVARCHAR(MAX)
	, @Param23 NVARCHAR(MAX)
	, @Param24 NVARCHAR(MAX)
	, @Param25 NVARCHAR(MAX)
	, @Param26 NVARCHAR(MAX)
	, @Param27 NVARCHAR(MAX)
	, @Param28 NVARCHAR(MAX)
	, @Param29 NVARCHAR(MAX)
	, @Param30 NVARCHAR(MAX)
	, @TimeZone NVARCHAR(MAX) = 'AS054'
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_proc_name      nvarchar(100) = 'UI_FP_COMMON';
	DECLARE @runstart datetime;
	DECLARE @runend datetime;

    DECLARE @v_dept_id nvarchar(50)='';
	DECLARE @v_group_id nvarchar(50)='';
	DECLARE @v_text nvarchar(MAX)='';
	DECLARE @v_dSql nvarchar(MAX)=''; 
	DECLARE @V_INSTANCE_ID  NVARCHAR(MAX), @V_INSTANCE_LT	NVARCHAR(MAX)
	DECLARE @V_COMPANY_ID 	NVARCHAR(MAX), @V_COMPANY_LT    NVARCHAR(MAX)
	DECLARE @V_DIVISION_ID 	NVARCHAR(MAX), @V_DIVISION_LT   NVARCHAR(MAX)
	DECLARE @V_SITE_ID 		NVARCHAR(MAX), @V_SITE_LT       NVARCHAR(MAX)
	DECLARE @V_PLANT_ID 	NVARCHAR(MAX), @V_PLANT_LT	    NVARCHAR(MAX)
	DECLARE @V_FACTORY_ID 	NVARCHAR(MAX), @V_FACTORY_LT    NVARCHAR(MAX)
	DECLARE @V_OPERATION_ID NVARCHAR(MAX), @V_OPERATION_LT  NVARCHAR(MAX)
	DECLARE @V_LINE_ID 		NVARCHAR(MAX), @V_LINE_LT       NVARCHAR(MAX)
	DECLARE @V_ITEM_ID 		NVARCHAR(MAX), @V_ITEM_LT       NVARCHAR(MAX)
	DECLARE @V_NICK_NAME_ID NVARCHAR(MAX), @V_NICK_NAME_LT  NVARCHAR(MAX)
	DECLARE @V_INSTANCE_ID_STR  NVARCHAR(MAX)

	
	/****************************************************************************************************************************************/
	/*  Parameter 세팅                                                                                                       */
	/*                                                                                                    */
	/****************************************************************************************************************************************/
	BEGIN
		SELECT @USER_ID AS USER_ID
		return 1
	END -- IF END


END
