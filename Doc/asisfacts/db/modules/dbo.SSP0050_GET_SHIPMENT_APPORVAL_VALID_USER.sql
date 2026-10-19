

/*
 * Program ID   : SSP0050_GET_SHIPMENT_APPORVAL_VALID_USER
 * Description  : Shipment Apporval
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *=================================================================================================== 
 * 2024/02/06   jilee          SSP 전자 결재 연동 승인자 기준일 적합성 유무

 ex) EXEC SSP0050_GET_SHIPMENT_APPORVAL_VALID_USER @p_user_id
 */

CREATE PROCEDURE [dbo].[SSP0050_GET_SHIPMENT_APPORVAL_VALID_USER]	
	 @p_user_id				NVARCHAR(100)	= ''
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	DECLARE @v_yn                NVARCHAR(1)    = 'N';
	DECLARE @v_now_date          NVARCHAR(8)    = CONVERT(NVARCHAR(8), GETDATE() ,112); 
	DECLARE @v_now_time          NVARCHAR(5)    = CONVERT(VARCHAR(5), CONVERT(TIME,GETDATE()));
	DECLARE @v_date_part         NVARCHAR(10)   = '';
	DECLARE @v_date_from_to      NVARCHAR(11)   = '';
	DECLARE @v_user_start_time   NVARCHAR(5)    = '';
	DECLARE @v_user_end_time     NVARCHAR(5)    = '';
	DECLARE @v_cnt_find_user	 INT            = 0;

	DECLARE @v_days_sun_yn       NVARCHAR(1)    = '';
	DECLARE @v_days_mon_yn       NVARCHAR(1)    = '';
	DECLARE @v_days_tue_yn       NVARCHAR(1)    = '';
	DECLARE @v_days_wed_yn       NVARCHAR(1)    = '';
	DECLARE @v_days_thu_yn       NVARCHAR(1)    = '';
	DECLARE @v_days_fri_yn       NVARCHAR(1)    = '';
	DECLARE @v_days_sat_yn       NVARCHAR(1)    = '';

	DECLARE @v_days_sun_from_to  NVARCHAR(11)   = '';
	DECLARE @v_days_mon_from_to  NVARCHAR(11)   = '';
	DECLARE @v_days_tue_from_to  NVARCHAR(11)   = '';
	DECLARE @v_days_wed_from_to  NVARCHAR(11)   = '';
	DECLARE @v_days_thu_from_to  NVARCHAR(11)   = '';
	DECLARE @v_days_fri_from_to  NVARCHAR(11)   = '';
	DECLARE @v_days_sat_from_to  NVARCHAR(11)   = '';

	SET @v_cnt_find_user = (	
	                            SELECT COUNT(*)
								FROM SSP_MST_APPROVAL A WITH(NOLOCK)
								WHERE 1=1
								AND @v_now_date BETWEEN A.PERIOD_FROM AND A.PERIOD_TO
								AND USER_ID = @p_user_id
								AND A.VALID_YN = 'Y'
							)
							
    IF @v_cnt_find_user = 0
		BEGIN
			SELECT @v_yn AS RESULT_CODE
			RETURN;
		END
    ELSE
		BEGIN
		   
		    SELECT  @v_days_sun_yn      = A.DAYS_SUN_YN
				   ,@v_days_mon_yn      = A.DAYS_MON_YN
				   ,@v_days_tue_yn      = A.DAYS_TUE_YN
				   ,@v_days_wed_yn      = A.DAYS_WED_YN
				   ,@v_days_thu_yn      = A.DAYS_THU_YN
				   ,@v_days_fri_yn      = A.DAYS_FRI_YN 
				   ,@v_days_sat_yn      = A.DAYS_SAT_YN				   
				   ,@v_days_sun_from_to = A.DAYS_SUN_FROM_TO
				   ,@v_days_mon_from_to	= A.DAYS_MON_FROM_TO
				   ,@v_days_tue_from_to	= A.DAYS_TUE_FROM_TO
				   ,@v_days_wed_from_to	= A.DAYS_WED_FROM_TO
				   ,@v_days_thu_from_to	= A.DAYS_THU_FROM_TO
				   ,@v_days_fri_from_to	= A.DAYS_FRI_FROM_TO
				   ,@v_days_sat_from_to	= A.DAYS_SAT_FROM_TO
            FROM SSP_MST_APPROVAL A WITH(NOLOCK) WHERE 1=1
			AND @v_now_date BETWEEN A.PERIOD_FROM AND A.PERIOD_TO
			AND USER_ID = @p_user_id
			AND A.VALID_YN = 'Y'
			                
			SELECT @v_date_part = CASE WHEN(DATEPART(WEEKDAY,GETDATE())='1') THEN @v_days_sun_yn             
			                           WHEN(DATEPART(WEEKDAY,GETDATE())='2') THEN @v_days_mon_yn
			                           WHEN(DATEPART(WEEKDAY,GETDATE())='3') THEN @v_days_tue_yn
			                           WHEN(DATEPART(WEEKDAY,GETDATE())='4') THEN @v_days_wed_yn 
			                		   WHEN(DATEPART(WEEKDAY,GETDATE())='5') THEN @v_days_thu_yn
									   WHEN(DATEPART(WEEKDAY,GETDATE())='6') THEN @v_days_fri_yn
									   WHEN(DATEPART(WEEKDAY,GETDATE())='7') THEN @v_days_sat_yn
								       END
			IF @v_date_part = 'Y'
				BEGIN
					SELECT @v_date_from_to = CASE WHEN(DATEPART(WEEKDAY,GETDATE())='1') THEN @v_days_sun_from_to
												  WHEN(DATEPART(WEEKDAY,GETDATE())='2') THEN @v_days_mon_from_to
												  WHEN(DATEPART(WEEKDAY,GETDATE())='3') THEN @v_days_tue_from_to 
												  WHEN(DATEPART(WEEKDAY,GETDATE())='4') THEN @v_days_wed_from_to
												  WHEN(DATEPART(WEEKDAY,GETDATE())='5') THEN @v_days_thu_from_to
												  WHEN(DATEPART(WEEKDAY,GETDATE())='6') THEN @v_days_fri_from_to
												  WHEN(DATEPART(WEEKDAY,GETDATE())='7') THEN @v_days_sat_from_to
											      END 
				END

			SET @v_user_start_time = SUBSTRING(@v_date_from_to, 1,  5)
			SET @v_user_end_time   = SUBSTRING(@v_date_from_to, 7, 11)
			
			IF @v_user_start_time <= @v_now_time AND @v_user_end_time >= @v_now_time
				BEGIN
					SET @v_yn = 'Y'
				END

			SELECT @v_yn AS RESULT_CODE

		END		
END
