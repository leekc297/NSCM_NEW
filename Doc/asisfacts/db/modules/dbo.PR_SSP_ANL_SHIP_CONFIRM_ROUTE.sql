
/*
 * Program ID   : PR_SSP_ANL_SHIP_CONFIRM_ROUTE_ROUTE  
 * Description  :  
 * OutTable     : SSP_ANL_SHIP_CONFIRM_ROUTE
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.08.01   SSP Pjt.       Create.
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_ROUTE]
(
	  @p_confirm_id        NVARCHAR(4000) 
	 ,@p_route_id          bigint  
)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    --SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  
    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_ANL_SHIP_CONFIRM_ROUTE';
    DECLARE @v_log_type					NVARCHAR(30);	-- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER			= 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_ANL_SHIP_CONFIRM_ROUTE'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

    -- 임시 실행시간 확인용
    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= ''--'[00:00]';

	DECLARE @V_INX		INT	= 0;
	DECLARE @V_MAX_NUM	INT	= 0;

	declare @lv_confirm_id nvarchar(20);
	declare @lv_route_id   bigint;

	DECLARE @TAB_CONFIRM_ROUTE   TABLE
	(
		TID							INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	   ,CONFIRM_ID					[nvarchar](50) NOT NULL
	   ,ROUTE_ID                    bigint
	)

	INSERT INTO @TAB_CONFIRM_ROUTE ( CONFIRM_ID, ROUTE_ID )
	SELECT TOKEN		AS CONFIRM_ID
	      ,@p_route_id	AS ROUTE_ID 
	  FROM DBO.UF_FX_String_Split(@p_confirm_id, '^')


    BEGIN TRY

		SELECT @V_INX			= min(tid)
			  ,@V_MAX_NUM		= max(tid)
		  FROM @TAB_CONFIRM_ROUTE

		WHILE @V_INX <= @V_MAX_NUM
		BEGIN

			SELECT @lv_confirm_id			= confirm_id	
				 , @lv_route_id				= route_id		
			  FROM @TAB_CONFIRM_ROUTE 
			 WHERE TID						= @V_INX

			IF @lv_route_id IS NOT NULL
			BEGIN

				MERGE INTO SSP_ANL_SHIP_CONFIRM_ROUTE AS C
				USING (SELECT ROUTE_ID 
							 ,FROM_COUNTRY
							 ,FROM_CITY
							 ,TRANSPORT_MODE
							 ,PRIORITY
							 ,DAYS_MON
							 ,DAYS_TUE
							 ,DAYS_WED
							 ,DAYS_THU
							 ,DAYS_FRI
							 ,DAYS_SAT
							 ,DAYS_SUN
							 ,D_COUNTRY
							 ,D_PORT_CODE
							 ,D_PORT_NAME
							 ,A_COUNTRY
							 ,A_PORT_CODE
							 ,A_PORT_NAME
							 ,SHIPPING_COMPANY
							 ,TO_COUNTRY
							 ,TO_CITY
							 ,SHIP_DOC_PREPARATION_DATE
							 ,LT_DEPARTURE_INLAND
							 ,LT_WAIT_SHIPPING
							 ,LT_VOYAGE
							 ,LT_LAY_OFF_CLEARANCE
							 ,LT_ARRIVAL_INLAND
							 ,LT_TYPE
							 ,VALID_YN
							 ,CREATED_BY
							 ,CREATION_DATE
							 ,LAST_UPDATED_BY
							 ,LAST_UPDATE_DATE
							 ,ATTRIBUTE1
							 ,ATTRIBUTE2
							 ,ATTRIBUTE3
							 ,ATTRIBUTE4
							 ,ATTRIBUTE5
							 ,ATTRIBUTE6
							 ,ATTRIBUTE7
							 ,ATTRIBUTE8
							 ,ATTRIBUTE9
							 ,'1111'	AS ATTRIBUTE10    --Monotoring
				         FROM SCP_MST_DISTRIBUTION_ROUTE WITH(NOLOCK)
					   WHERE ROUTE_ID	= @lv_route_id 
					  ) AS R
				   ON C.CONFIRM_ID		= @lv_confirm_id
				 WHEN MATCHED THEN
				 UPDATE
					SET 
						C.ROUTE_ID						= R.ROUTE_ID
					   ,C.FROM_COUNTRY					= R.FROM_COUNTRY
					   ,C.FROM_CITY						= R.FROM_CITY
					   ,C.TRANSPORT_MODE				= R.TRANSPORT_MODE
					   ,C.PRIORITY						= R.PRIORITY
					   ,C.DAYS_MON						= R.DAYS_MON
					   ,C.DAYS_TUE						= R.DAYS_TUE
					   ,C.DAYS_WED						= R.DAYS_WED
					   ,C.DAYS_THU						= R.DAYS_THU
					   ,C.DAYS_FRI						= R.DAYS_FRI
					   ,C.DAYS_SAT						= R.DAYS_SAT
					   ,C.DAYS_SUN						= R.DAYS_SUN
					   ,C.D_COUNTRY						= R.D_COUNTRY
					   ,C.D_PORT_CODE					= R.D_PORT_CODE
					   ,C.D_PORT_NAME					= R.D_PORT_NAME
					   ,C.A_COUNTRY						= R.A_COUNTRY
					   ,C.A_PORT_CODE					= R.A_PORT_CODE
					   ,C.A_PORT_NAME					= R.A_PORT_NAME
					   ,C.SHIPPING_COMPANY				= R.SHIPPING_COMPANY
					   ,C.TO_COUNTRY					= R.TO_COUNTRY
					   ,C.TO_CITY						= R.TO_CITY
					   ,C.SHIP_DOC_PREPARATION_DATE		= R.SHIP_DOC_PREPARATION_DATE
					   ,C.LT_DEPARTURE_INLAND			= R.LT_DEPARTURE_INLAND
					   ,C.LT_WAIT_SHIPPING				= R.LT_WAIT_SHIPPING
					   ,C.LT_VOYAGE						= R.LT_VOYAGE
					   ,C.LT_LAY_OFF_CLEARANCE			= R.LT_LAY_OFF_CLEARANCE
					   ,C.LT_ARRIVAL_INLAND				= R.LT_ARRIVAL_INLAND
					   ,C.LT_TYPE						= R.LT_TYPE
					   ,C.VALID_YN						= R.VALID_YN
					   ,C.CREATED_BY					= R.CREATED_BY
					   ,C.CREATION_DATE					= R.CREATION_DATE
					   ,C.LAST_UPDATED_BY				= R.LAST_UPDATED_BY
					   ,C.LAST_UPDATE_DATE				= R.LAST_UPDATE_DATE
					   ,C.ATTRIBUTE1					= R.ATTRIBUTE1
					   ,C.ATTRIBUTE2					= R.ATTRIBUTE2
					   ,C.ATTRIBUTE3					= R.ATTRIBUTE3
					   ,C.ATTRIBUTE4					= R.ATTRIBUTE4
					   ,C.ATTRIBUTE5					= R.ATTRIBUTE5
					   ,C.ATTRIBUTE6					= R.ATTRIBUTE6
					   ,C.ATTRIBUTE7					= R.ATTRIBUTE7
					   ,C.ATTRIBUTE8					= R.ATTRIBUTE8
					   ,C.ATTRIBUTE9					= R.ATTRIBUTE9
					   ,C.ATTRIBUTE10					= R.ATTRIBUTE10
				 WHEN NOT MATCHED THEN 
				 INSERT (
						CONFIRM_ID
					   ,ROUTE_ID
					   ,FROM_COUNTRY
					   ,FROM_CITY
					   ,TRANSPORT_MODE
					   ,PRIORITY
					   ,DAYS_MON
					   ,DAYS_TUE
					   ,DAYS_WED
					   ,DAYS_THU
					   ,DAYS_FRI
					   ,DAYS_SAT
					   ,DAYS_SUN
					   ,D_COUNTRY
					   ,D_PORT_CODE
					   ,D_PORT_NAME
					   ,A_COUNTRY
					   ,A_PORT_CODE
					   ,A_PORT_NAME
					   ,SHIPPING_COMPANY
					   ,TO_COUNTRY
					   ,TO_CITY
					   ,SHIP_DOC_PREPARATION_DATE
					   ,LT_DEPARTURE_INLAND
					   ,LT_WAIT_SHIPPING
					   ,LT_VOYAGE
					   ,LT_LAY_OFF_CLEARANCE
					   ,LT_ARRIVAL_INLAND
					   ,LT_TYPE
					   ,VALID_YN
					   ,CREATED_BY
					   ,CREATION_DATE
					   ,LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE
					   ,ATTRIBUTE1
					   ,ATTRIBUTE2
					   ,ATTRIBUTE3
					   ,ATTRIBUTE4
					   ,ATTRIBUTE5
					   ,ATTRIBUTE6
					   ,ATTRIBUTE7
					   ,ATTRIBUTE8
					   ,ATTRIBUTE9
					   ,ATTRIBUTE10
						)
				 VALUES (
						@p_confirm_id
					   ,R.ROUTE_ID
					   ,R.FROM_COUNTRY
					   ,R.FROM_CITY
					   ,R.TRANSPORT_MODE
					   ,R.PRIORITY
					   ,R.DAYS_MON
					   ,R.DAYS_TUE
					   ,R.DAYS_WED
					   ,R.DAYS_THU
					   ,R.DAYS_FRI
					   ,R.DAYS_SAT
					   ,R.DAYS_SUN
					   ,R.D_COUNTRY
					   ,R.D_PORT_CODE
					   ,R.D_PORT_NAME
					   ,R.A_COUNTRY
					   ,R.A_PORT_CODE
					   ,R.A_PORT_NAME
					   ,R.SHIPPING_COMPANY
					   ,R.TO_COUNTRY
					   ,R.TO_CITY
					   ,R.SHIP_DOC_PREPARATION_DATE
					   ,R.LT_DEPARTURE_INLAND
					   ,R.LT_WAIT_SHIPPING
					   ,R.LT_VOYAGE
					   ,R.LT_LAY_OFF_CLEARANCE
					   ,R.LT_ARRIVAL_INLAND
					   ,R.LT_TYPE
					   ,R.VALID_YN
					   ,R.CREATED_BY
					   ,R.CREATION_DATE
					   ,R.LAST_UPDATED_BY
					   ,R.LAST_UPDATE_DATE
					   ,R.ATTRIBUTE1
					   ,R.ATTRIBUTE2
					   ,R.ATTRIBUTE3
					   ,R.ATTRIBUTE4
					   ,R.ATTRIBUTE5
					   ,R.ATTRIBUTE6
					   ,R.ATTRIBUTE7
					   ,R.ATTRIBUTE8
					   ,R.ATTRIBUTE9
					   ,R.ATTRIBUTE10
					   )
					   ;

			END
			ELSE
			BEGIN

				MERGE INTO SSP_ANL_SHIP_CONFIRM_ROUTE AS C
				USING (SELECT X.CONFIRM_ID
							 ,Z.ROUTE_ID
							 ,Z.FROM_COUNTRY
							 ,Z.FROM_CITY
							 ,Z.TRANSPORT_MODE
							 ,Z.PRIORITY
							 ,Z.DAYS_MON
							 ,Z.DAYS_TUE
							 ,Z.DAYS_WED
							 ,Z.DAYS_THU
							 ,Z.DAYS_FRI
							 ,Z.DAYS_SAT
							 ,Z.DAYS_SUN
							 ,Z.D_COUNTRY
							 ,Z.D_PORT_CODE
							 ,Z.D_PORT_NAME
							 ,Z.A_COUNTRY
							 ,Z.A_PORT_CODE
							 ,Z.A_PORT_NAME
							 ,Z.SHIPPING_COMPANY
							 ,Z.TO_COUNTRY
							 ,Z.TO_CITY
							 ,Z.SHIP_DOC_PREPARATION_DATE
							 ,Z.LT_DEPARTURE_INLAND
							 ,Z.LT_WAIT_SHIPPING
							 ,Z.LT_VOYAGE
							 ,Z.LT_LAY_OFF_CLEARANCE
							 ,Z.LT_ARRIVAL_INLAND
							 ,Z.LT_TYPE
							 ,Z.VALID_YN
							 ,Z.CREATED_BY
							 ,Z.CREATION_DATE
							 ,Z.LAST_UPDATED_BY
							 ,Z.LAST_UPDATE_DATE
							 ,Z.ATTRIBUTE1
							 ,Z.ATTRIBUTE2
							 ,Z.ATTRIBUTE3
							 ,Z.ATTRIBUTE4
							 ,Z.ATTRIBUTE5
							 ,Z.ATTRIBUTE6
							 ,Z.ATTRIBUTE7
							 ,Z.ATTRIBUTE8
							 ,Z.ATTRIBUTE9
							 ,'2222'	AS ATTRIBUTE10    --Monotoring
						 FROM SSP_ANL_SHIP_CONFIRM AS X with(nolock)
							  JOIN SCP_MST_BOD	AS Y with(nolock)
						   ON X.BOD_ID		= Y.BOD_ID
							  JOIN SCP_MST_DISTRIBUTION_ROUTE AS Z WITH(NOLOCK)
						   ON Y.ROUTE_ID	= Z.ROUTE_ID
						WHERE X.CONFIRM_ID	= @lv_confirm_id 
						) AS R
				   ON C.CONFIRM_ID		= R.CONFIRM_ID
				 WHEN MATCHED THEN
				 UPDATE
					SET 
					    C.ROUTE_ID						= R.ROUTE_ID
					   ,C.FROM_COUNTRY					= R.FROM_COUNTRY
					   ,C.FROM_CITY						= R.FROM_CITY
					   ,C.TRANSPORT_MODE				= R.TRANSPORT_MODE
					   ,C.PRIORITY						= R.PRIORITY
					   ,C.DAYS_MON						= R.DAYS_MON
					   ,C.DAYS_TUE						= R.DAYS_TUE
					   ,C.DAYS_WED						= R.DAYS_WED
					   ,C.DAYS_THU						= R.DAYS_THU
					   ,C.DAYS_FRI						= R.DAYS_FRI
					   ,C.DAYS_SAT						= R.DAYS_SAT
					   ,C.DAYS_SUN						= R.DAYS_SUN
					   ,C.D_COUNTRY						= R.D_COUNTRY
					   ,C.D_PORT_CODE					= R.D_PORT_CODE
					   ,C.D_PORT_NAME					= R.D_PORT_NAME
					   ,C.A_COUNTRY						= R.A_COUNTRY
					   ,C.A_PORT_CODE					= R.A_PORT_CODE
					   ,C.A_PORT_NAME					= R.A_PORT_NAME
					   ,C.SHIPPING_COMPANY				= R.SHIPPING_COMPANY
					   ,C.TO_COUNTRY					= R.TO_COUNTRY
					   ,C.TO_CITY						= R.TO_CITY
					   ,C.SHIP_DOC_PREPARATION_DATE		= R.SHIP_DOC_PREPARATION_DATE
					   ,C.LT_DEPARTURE_INLAND			= R.LT_DEPARTURE_INLAND
					   ,C.LT_WAIT_SHIPPING				= R.LT_WAIT_SHIPPING
					   ,C.LT_VOYAGE						= R.LT_VOYAGE
					   ,C.LT_LAY_OFF_CLEARANCE			= R.LT_LAY_OFF_CLEARANCE
					   ,C.LT_ARRIVAL_INLAND				= R.LT_ARRIVAL_INLAND
					   ,C.LT_TYPE						= R.LT_TYPE
					   ,C.VALID_YN						= R.VALID_YN
					   ,C.CREATED_BY					= R.CREATED_BY
					   ,C.CREATION_DATE					= R.CREATION_DATE
					   ,C.LAST_UPDATED_BY				= R.LAST_UPDATED_BY
					   ,C.LAST_UPDATE_DATE				= R.LAST_UPDATE_DATE
					   ,C.ATTRIBUTE1					= R.ATTRIBUTE1
					   ,C.ATTRIBUTE2					= R.ATTRIBUTE2
					   ,C.ATTRIBUTE3					= R.ATTRIBUTE3
					   ,C.ATTRIBUTE4					= R.ATTRIBUTE4
					   ,C.ATTRIBUTE5					= R.ATTRIBUTE5
					   ,C.ATTRIBUTE6					= R.ATTRIBUTE6
					   ,C.ATTRIBUTE7					= R.ATTRIBUTE7
					   ,C.ATTRIBUTE8					= R.ATTRIBUTE8
					   ,C.ATTRIBUTE9					= R.ATTRIBUTE9
					   ,C.ATTRIBUTE10					= R.ATTRIBUTE10
				 WHEN NOT MATCHED THEN 
				 INSERT (
						CONFIRM_ID
					   ,ROUTE_ID
					   ,FROM_COUNTRY
					   ,FROM_CITY
					   ,TRANSPORT_MODE
					   ,PRIORITY
					   ,DAYS_MON
					   ,DAYS_TUE
					   ,DAYS_WED
					   ,DAYS_THU
					   ,DAYS_FRI
					   ,DAYS_SAT
					   ,DAYS_SUN
					   ,D_COUNTRY
					   ,D_PORT_CODE
					   ,D_PORT_NAME
					   ,A_COUNTRY
					   ,A_PORT_CODE
					   ,A_PORT_NAME
					   ,SHIPPING_COMPANY
					   ,TO_COUNTRY
					   ,TO_CITY
					   ,SHIP_DOC_PREPARATION_DATE
					   ,LT_DEPARTURE_INLAND
					   ,LT_WAIT_SHIPPING
					   ,LT_VOYAGE
					   ,LT_LAY_OFF_CLEARANCE
					   ,LT_ARRIVAL_INLAND
					   ,LT_TYPE
					   ,VALID_YN
					   ,CREATED_BY
					   ,CREATION_DATE
					   ,LAST_UPDATED_BY
					   ,LAST_UPDATE_DATE
					   ,ATTRIBUTE1
					   ,ATTRIBUTE2
					   ,ATTRIBUTE3
					   ,ATTRIBUTE4
					   ,ATTRIBUTE5
					   ,ATTRIBUTE6
					   ,ATTRIBUTE7
					   ,ATTRIBUTE8
					   ,ATTRIBUTE9
					   ,ATTRIBUTE10
					   )
				VALUES (
						@p_confirm_id
					   ,R.ROUTE_ID
					   ,R.FROM_COUNTRY
					   ,R.FROM_CITY
					   ,R.TRANSPORT_MODE
					   ,R.PRIORITY
					   ,R.DAYS_MON
					   ,R.DAYS_TUE
					   ,R.DAYS_WED
					   ,R.DAYS_THU
					   ,R.DAYS_FRI
					   ,R.DAYS_SAT
					   ,R.DAYS_SUN
					   ,R.D_COUNTRY
					   ,R.D_PORT_CODE
					   ,R.D_PORT_NAME
					   ,R.A_COUNTRY
					   ,R.A_PORT_CODE
					   ,R.A_PORT_NAME
					   ,R.SHIPPING_COMPANY
					   ,R.TO_COUNTRY
					   ,R.TO_CITY
					   ,R.SHIP_DOC_PREPARATION_DATE
					   ,R.LT_DEPARTURE_INLAND
					   ,R.LT_WAIT_SHIPPING
					   ,R.LT_VOYAGE
					   ,R.LT_LAY_OFF_CLEARANCE
					   ,R.LT_ARRIVAL_INLAND
					   ,R.LT_TYPE
					   ,R.VALID_YN
					   ,R.CREATED_BY
					   ,R.CREATION_DATE
					   ,R.LAST_UPDATED_BY
					   ,R.LAST_UPDATE_DATE
					   ,R.ATTRIBUTE1
					   ,R.ATTRIBUTE2
					   ,R.ATTRIBUTE3
					   ,R.ATTRIBUTE4
					   ,R.ATTRIBUTE5
					   ,R.ATTRIBUTE6
					   ,R.ATTRIBUTE7
					   ,R.ATTRIBUTE8
					   ,R.ATTRIBUTE9
					   ,R.ATTRIBUTE10
					   )
					   ;

			END


			SET @V_INX		= @V_INX + 1
		END
    END TRY

    BEGIN CATCH

		RETURN -1

    END CATCH;

  
    RETURN 1  

END; 
