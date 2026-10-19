

/*
 * Program ID   : [PR_SSP_ANL_SHIP_CONFIRM_H_HIST]
 * Description  : SSP_ANL_SHIP_CONFIRM History 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.26	ygkim			[PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2018/05/29   ygkim			create date, last update date 시간 변경
 * 2018/06/11   ygkim			저장 로직 수정
 * 2018/07/11   ygkim		    CHANGE_TYPE 컬럼 추가
 * 2018/08/24   ygkim			CHANGE_TYPE = 'P' 일 경우 PLANNED_QTY 넣는 로직 수정
 * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
 * 2018/10/19   ygkim			BEFORE_QTY ,REMARKS ,CHECK_NEED_YN 컬럼 추가
 * 2019/03/12  juhlee          [PJ20189106] 전지.GSCM 고도화 이행  REMARKS2 컬럼 추가
 * 2019/03/15  juhlee          [PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
 */
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST]  
         @p_change_request_no	NVARCHAR(MAX)
		--,@p_change_status		NVARCHAR(MAX)
		--,@p_confirm_id			NVARCHAR(MAX)
		--,@p_etd_date			NVARCHAR(MAX)
		--,@p_eta_date			NVARCHAR(MAX)
		--,@p_qty					NVARCHAR(MAX)
		--,@p_ship_date			NVARCHAR(MAX)
		--,@p_new_yn				NVARCHAR(MAX)

		--,@p_new_bod_id			NVARCHAR(MAX)
		--,@p_new_route_id		NVARCHAR(MAX)
		--,@p_new_incoterms		NVARCHAR(MAX)
		--,@p_new_d_contry		NVARCHAR(MAX)
		--,@p_new_d_port_code		NVARCHAR(MAX)
		--,@p_new_a_country		NVARCHAR(MAX)
		--,@p_new_a_port_code		NVARCHAR(MAX)
		--,@p_new_to_country		NVARCHAR(MAX)
		--,@p_new_to_city			NVARCHAR(MAX)
		--,@p_new_lt_day			NVARCHAR(MAX)
		--,@p_new_transport_mode	NVARCHAR(MAX)

		,@p_last_updated_by		NVARCHAR(MAX)
		,@p_time_zone			NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @n_history_seq	INTEGER;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SSP_ANL_SHIP_CONFIRM_HIST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_last_update_date     datetime;
	SET @v_last_update_date    = SYSDATETIME();

		BEGIN TRY

				-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		   
			BEGIN    
				--OLD INSERT
				INSERT INTO SSP_ANL_SHIP_CONFIRM_H(
									HISTORY_SEQ
									,CONFIRM_ID
									,SHIPMENT_STATUS
									,DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,YYYYMMDD
									,PLANNED_QTY
									,QTY
									,BOD_ID
									,ROUTE_ID
									,BIZ_TYPE
									,PROJECT_CODE
									,FCST_TYPE
									,FCST_ETD_DATE
									,FCST_ETA_DATE
									,ETD_DATE
									,ETA_DATE
									,INCOTERMS
									,TRANSPORT_MODE
									,D_COUNTRY
									,D_PORT_CODE
									,A_COUNTRY
									,A_PORT_CODE
									,CUSTOMER_LT
									,TO_COUNTRY
									,TO_CITY
									,FROM_SITE_TYPE
									,FROM_SITE_PLANT_ID
									,FROM_SITE_VENDOR_ID
									,FROM_SITE_SOLDTO_CODE
									,FROM_SITE_SHIPTO_CODE
									,FROM_SITE_COMPANY_ID
									,TO_SITE_TYPE
									,TO_SITE_PLANT_ID
									,TO_SITE_VENDOR_ID
									,TO_SITE_SOLDTO_CODE
									,TO_SITE_SHIPTO_CODE
									,TO_SITE_COMPANY_ID
									,CHANGE_REQ_NO
									,ERP_SO_NO
									,ERP_SO_ITEM_NO
									,ERP_DO_NO
									,ERP_STATUS
									,CHANGE_TYPE
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
									,HISTORY_CREATION_DATE
									,ELECTRODE_YN
									,ELECTRODE_TYPE
									,ORIGIN_FROM_DIVISION_ID
									,ORIGIN_TO_DIVISION_ID
									,BEFORE_QTY
									,REMARKS
									,REMARKS2
									,REMARKS3
									,CHECK_NEED_YN
									/*----------------------------------------------------------------------------------------
										2020.06.30 : KBK
										I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
									------------------------------------------------------------------------------------------*/
									,PACKAGE_TYPE_CODE
									,FACTORY_ID
									,PACKAGE_QTY
									,DOM_EXP
									,ERP_ATTR1
									,ERP_ATTR2
									,ERP_ATTR3
									,ERP_ATTR4
									,ERP_ATTR5
				) SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_H
				            ,A.CONFIRM_ID
							,A.SHIPMENT_STATUS
							,A.DIVISION_ID
							,A.PLAN_START_YYYYMMDD
							,A.PLAN_TYPE
							,A.SEQ
							,A.ITEM_ID
							,A.FROM_SITE
							,A.TO_SITE
							,A.YYYYMMDD
							,A.PLANNED_QTY
							,A.QTY
							,A.BOD_ID
							,A.ROUTE_ID
							,A.BIZ_TYPE
							,A.PROJECT_CODE
							,A.FCST_TYPE
							,A.FCST_ETD_DATE
							,A.FCST_ETA_DATE
							,A.ETD_DATE
							,A.ETA_DATE
							,A.INCOTERMS
							,A.TRANSPORT_MODE
							,A.D_COUNTRY
							,A.D_PORT_CODE
							,A.A_COUNTRY
							,A.A_PORT_CODE
							,A.CUSTOMER_LT
							,A.TO_COUNTRY
							,A.TO_CITY
							,A.FROM_SITE_TYPE
							,A.FROM_SITE_PLANT_ID
							,A.FROM_SITE_VENDOR_ID
							,A.FROM_SITE_SOLDTO_CODE
							,A.FROM_SITE_SHIPTO_CODE
							,A.FROM_SITE_COMPANY_ID
							,A.TO_SITE_TYPE
							,A.TO_SITE_PLANT_ID
							,A.TO_SITE_VENDOR_ID
							,A.TO_SITE_SOLDTO_CODE
							,A.TO_SITE_SHIPTO_CODE
							,A.TO_SITE_COMPANY_ID
							,@p_change_request_no CHANGE_REQ_NO
							,A.ERP_SO_NO
							,A.ERP_SO_ITEM_NO
							,A.ERP_DO_NO
							,A.ERP_STATUS
							,CHANGE_TYPE
							,@p_last_updated_by CREATED_BY
							,@v_last_update_date CREATION_DATE--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
							,@p_last_updated_by LAST_UPDATED_BY
							,@v_last_update_date LAST_UPDATE_DATE--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
							,A.ATTRIBUTE1
							,A.ATTRIBUTE2
							,A.ATTRIBUTE3
							,A.ATTRIBUTE4
							,A.ATTRIBUTE5
							,A.ATTRIBUTE6
							,A.ATTRIBUTE7
							,A.ATTRIBUTE8
							,A.ATTRIBUTE9
							,A.ATTRIBUTE10
							,@v_last_update_date HISTORY_CREATION_DATE--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE 
							,a.ELECTRODE_YN
							,a.ELECTRODE_TYPE
							,a.ORIGIN_FROM_DIVISION_ID
							,a.ORIGIN_TO_DIVISION_ID
							,a.BEFORE_QTY
							,a.REMARKS
							,a.REMARKS2
							,a.REMARKS3
							,a.CHECK_NEED_YN
							/*----------------------------------------------------------------------------------------
								2020.06.30 : KBK
								I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							------------------------------------------------------------------------------------------*/
							,B.PACKAGE_TYPE
							,B.FACTORY_ID
							,B.PACKAGE_QTY
							,B.DOM_EXP
							,B.ERP_ATTR1
							,B.ERP_ATTR2
							,B.ERP_ATTR3
							,B.ERP_ATTR4
							,B.ERP_ATTR5
					FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
					INNER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_de B  WITH(NOLOCK)
						ON A.CONFIRM_ID = B.CONFIRM_ID 
						AND B.CHANGE_REQ_NO = @p_change_request_no 
						AND B.NEW_YN = 'N' 
						AND B.VALID_YN = 'Y';

					--NEW INSERT
					INSERT INTO SSP_ANL_SHIP_CONFIRM_H(
									HISTORY_SEQ
									,CONFIRM_ID
									,SHIPMENT_STATUS
									,DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,YYYYMMDD
									,PLANNED_QTY
									,QTY
									,BOD_ID
									,ROUTE_ID
									,BIZ_TYPE
									,PROJECT_CODE
									,FCST_TYPE
									,FCST_ETD_DATE
									,FCST_ETA_DATE
									,ETD_DATE
									,ETA_DATE
									,INCOTERMS
									,TRANSPORT_MODE
									,D_COUNTRY
									,D_PORT_CODE
									,A_COUNTRY
									,A_PORT_CODE
									,CUSTOMER_LT
									,TO_COUNTRY
									,TO_CITY
									,FROM_SITE_TYPE
									,FROM_SITE_PLANT_ID
									,FROM_SITE_VENDOR_ID
									,FROM_SITE_SOLDTO_CODE
									,FROM_SITE_SHIPTO_CODE
									,FROM_SITE_COMPANY_ID
									,TO_SITE_TYPE
									,TO_SITE_PLANT_ID
									,TO_SITE_VENDOR_ID
									,TO_SITE_SOLDTO_CODE
									,TO_SITE_SHIPTO_CODE
									,TO_SITE_COMPANY_ID
									,CHANGE_REQ_NO
									,ERP_SO_NO
									,ERP_SO_ITEM_NO
									,ERP_DO_NO
									,ERP_STATUS
									,CHANGE_TYPE
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
									,HISTORY_CREATION_DATE
									,ELECTRODE_YN
									,ELECTRODE_TYPE
									,ORIGIN_FROM_DIVISION_ID
									,ORIGIN_TO_DIVISION_ID
									,BEFORE_QTY
									,REMARKS
									,REMARKS2
									,REMARKS3
									,CHECK_NEED_YN
									/*----------------------------------------------------------------------------------------
										2020.06.30 : KBK
										I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
									------------------------------------------------------------------------------------------*/
									,PACKAGE_TYPE_CODE
									,FACTORY_ID
									,PACKAGE_QTY
									,DOM_EXP
									,ERP_ATTR1
									,ERP_ATTR2
									,ERP_ATTR3
									,ERP_ATTR4
									,ERP_ATTR5
				) SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_H
				            ,A.CONFIRM_ID
							,A.SHIPMENT_STATUS
							,A.DIVISION_ID
							,A.PLAN_START_YYYYMMDD
							,A.PLAN_TYPE
							,A.SEQ
							,A.ITEM_ID
							,A.FROM_SITE
							,A.TO_SITE
							,A.YYYYMMDD
							,CASE WHEN  C.CHANGE_TYPE = 'P' THEN A.PLANNED_QTY ELSE 0 END PLANNED_QTY
							,A.QTY
							,A.BOD_ID
							,A.ROUTE_ID
							,A.BIZ_TYPE
							,A.PROJECT_CODE
							,A.FCST_TYPE
							,A.FCST_ETD_DATE
							,A.FCST_ETA_DATE
							,A.ETD_DATE
							,A.ETA_DATE
							,A.INCOTERMS
							,A.TRANSPORT_MODE
							,A.D_COUNTRY
							,A.D_PORT_CODE
							,A.A_COUNTRY
							,A.A_PORT_CODE
							,A.CUSTOMER_LT
							,A.TO_COUNTRY
							,A.TO_CITY
							,A.FROM_SITE_TYPE
							,A.FROM_SITE_PLANT_ID
							,A.FROM_SITE_VENDOR_ID
							,A.FROM_SITE_SOLDTO_CODE
							,A.FROM_SITE_SHIPTO_CODE
							,A.FROM_SITE_COMPANY_ID
							,A.TO_SITE_TYPE
							,A.TO_SITE_PLANT_ID
							,A.TO_SITE_VENDOR_ID
							,A.TO_SITE_SOLDTO_CODE
							,A.TO_SITE_SHIPTO_CODE
							,A.TO_SITE_COMPANY_ID
							,@p_change_request_no CHANGE_REQ_NO
							,A.ERP_SO_NO
							,A.ERP_SO_ITEM_NO
							,A.ERP_DO_NO
							,A.ERP_STATUS
							,A.CHANGE_TYPE
							,@p_last_updated_by CREATED_BY
							,@v_last_update_date CREATION_DATE--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
							,@p_last_updated_by LAST_UPDATED_BY
							,@v_last_update_date LAST_UPDATE_DATE--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
							,A.ATTRIBUTE1
							,A.ATTRIBUTE2
							,A.ATTRIBUTE3
							,A.ATTRIBUTE4
							,A.ATTRIBUTE5
							,A.ATTRIBUTE6
							,A.ATTRIBUTE7
							,A.ATTRIBUTE8
							,A.ATTRIBUTE9
							,A.ATTRIBUTE10
							,@v_last_update_date HISTORY_CREATION_DATE--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE 
							,a.ELECTRODE_YN
							,a.ELECTRODE_TYPE
							,a.ORIGIN_FROM_DIVISION_ID
							,a.ORIGIN_TO_DIVISION_ID
							,a.BEFORE_QTY
							,a.REMARKS
							,a.REMARKS2
							,a.REMARKS3
							,a.CHECK_NEED_YN
							/*----------------------------------------------------------------------------------------
								2020.06.30 : KBK
								I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							------------------------------------------------------------------------------------------*/
							,B.PACKAGE_TYPE
							,B.FACTORY_ID
							,B.PACKAGE_QTY
							,B.DOM_EXP
							,B.ERP_ATTR1
							,B.ERP_ATTR2
							,B.ERP_ATTR3
							,B.ERP_ATTR4
							,B.ERP_ATTR5
					FROM SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
					INNER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_de B  WITH(NOLOCK)
						ON A.CONFIRM_ID = B.CONFIRM_ID 
						AND B.CHANGE_REQ_NO = @p_change_request_no 
						AND B.NEW_YN = 'Y' AND B.VALID_YN = 'Y'
					INNER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ C WITH(NOLOCK) 
						ON B.CHANGE_REQ_NO = C.CHANGE_REQ_NO
				/*
				SET @n_history_seq = NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_H
				
				IF @p_new_yn = 'Y'
					BEGIN
						INSERT INTO SSP_ANL_SHIP_CONFIRM_H(
									HISTORY_SEQ
									,CONFIRM_ID
									,SHIPMENT_STATUS
									,DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,YYYYMMDD
									,PLANNED_QTY
									,QTY
									,BOD_ID
									,ROUTE_ID
									,BIZ_TYPE
									,PROJECT_CODE
									,FCST_TYPE
									,FCST_ETD_DATE
									,FCST_ETA_DATE
									,ETD_DATE
									,ETA_DATE
									,INCOTERMS
									,TRANSPORT_MODE
									,D_COUNTRY
									,D_PORT_CODE
									,A_COUNTRY
									,A_PORT_CODE
									,CUSTOMER_LT
									,TO_COUNTRY
									,TO_CITY
									,FROM_SITE_TYPE
									,FROM_SITE_PLANT_ID
									,FROM_SITE_VENDOR_ID
									,FROM_SITE_SOLDTO_CODE
									,FROM_SITE_SHIPTO_CODE
									,FROM_SITE_COMPANY_ID
									,TO_SITE_TYPE
									,TO_SITE_PLANT_ID
									,TO_SITE_VENDOR_ID
									,TO_SITE_SOLDTO_CODE
									,TO_SITE_SHIPTO_CODE
									,TO_SITE_COMPANY_ID
									,CHANGE_REQ_NO
									,ERP_SO_NO
									,ERP_SO_ITEM_NO
									,ERP_DO_NO
									,ERP_STATUS
									,CREATED_BY
									,CREATION_DATE
									,LAST_UPDATED_BY
									,LAST_UPDATE_DATE
									,HISTORY_CREATION_DATE
							) SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_H
							        ,CONFIRM_ID
									,'C' SHIPMENT_STATUS
									,DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,@p_ship_date YYYYMMDD
									,@p_qty PLANNED_QTY
									,@p_qty QTY
									,@p_new_bod_id BOD_ID
									,@p_new_route_id ROUTE_ID
									,BIZ_TYPE
									,PROJECT_CODE
									,FCST_TYPE
									,FCST_ETD_DATE
									,FCST_ETA_DATE
									,@p_etd_date ETD_DATE
									,@p_eta_date ETA_DATE
									,@p_new_incoterms INCOTERMS
									,@p_new_transport_mode TRANSPORT_MODE
									,@p_new_d_contry D_COUNTRY
									,@p_new_d_port_code D_PORT_CODE
									,@p_new_a_country A_COUNTRY
									,@p_new_a_port_code A_PORT_CODE
									,@p_new_lt_day CUSTOMER_LT
									,@p_new_to_country TO_COUNTRY
									,@p_new_to_city TO_CITY
									,FROM_SITE_TYPE
									,FROM_SITE_PLANT_ID
									,FROM_SITE_VENDOR_ID
									,FROM_SITE_SOLDTO_CODE
									,FROM_SITE_SHIPTO_CODE
									,FROM_SITE_COMPANY_ID
									,TO_SITE_TYPE
									,TO_SITE_PLANT_ID
									,TO_SITE_VENDOR_ID
									,TO_SITE_SOLDTO_CODE
									,TO_SITE_SHIPTO_CODE
									,TO_SITE_COMPANY_ID
									,@p_change_request_no CHANGE_REQ_NO
									,ERP_SO_NO
									,ERP_SO_ITEM_NO
									,ERP_DO_NO
									,ERP_STATUS
									,@p_last_updated_by CREATED_BY
									,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
									,@p_last_updated_by LAST_UPDATED_BY
									,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
									,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) HISTORY_CREATION_DATE
								FROM SSP_ANL_SHIP_CONFIRM with(nolock)
								WHERE CONFIRM_ID = @p_confirm_id
					END
				ELSE
					BEGIN
						INSERT INTO SSP_ANL_SHIP_CONFIRM_H(
						            HISTORY_SEQ
									,CONFIRM_ID
									,SHIPMENT_STATUS
									,DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,YYYYMMDD
									,PLANNED_QTY
									,QTY
									,BOD_ID
									,ROUTE_ID
									,BIZ_TYPE
									,PROJECT_CODE
									,FCST_TYPE
									,FCST_ETD_DATE
									,FCST_ETA_DATE
									,ETD_DATE
									,ETA_DATE
									,INCOTERMS
									,TRANSPORT_MODE
									,D_COUNTRY
									,D_PORT_CODE
									,A_COUNTRY
									,A_PORT_CODE
									,CUSTOMER_LT
									,TO_COUNTRY
									,TO_CITY
									,FROM_SITE_TYPE
									,FROM_SITE_PLANT_ID
									,FROM_SITE_VENDOR_ID
									,FROM_SITE_SOLDTO_CODE
									,FROM_SITE_SHIPTO_CODE
									,FROM_SITE_COMPANY_ID
									,TO_SITE_TYPE
									,TO_SITE_PLANT_ID
									,TO_SITE_VENDOR_ID
									,TO_SITE_SOLDTO_CODE
									,TO_SITE_SHIPTO_CODE
									,TO_SITE_COMPANY_ID
									,CHANGE_REQ_NO
									,ERP_SO_NO
									,ERP_SO_ITEM_NO
									,ERP_DO_NO
									,ERP_STATUS
									,CREATED_BY
									,CREATION_DATE
									,LAST_UPDATED_BY
									,LAST_UPDATE_DATE
									,HISTORY_CREATION_DATE
							) SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_H
							        ,CONFIRM_ID
									,'C' SHIPMENT_STATUS
									,DIVISION_ID
									,PLAN_START_YYYYMMDD
									,PLAN_TYPE
									,SEQ
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,@p_ship_date YYYYMMDD
									,PLANNED_QTY
									,@p_qty QTY
									,@p_new_bod_id BOD_ID
									,@p_new_route_id ROUTE_ID
									,BIZ_TYPE
									,PROJECT_CODE
									,FCST_TYPE
									,FCST_ETD_DATE
									,FCST_ETA_DATE
									,ETD_DATE
									,ETA_DATE
									,@p_new_incoterms INCOTERMS
									,@p_new_transport_mode TRANSPORT_MODE
									,@p_new_d_contry D_COUNTRY
									,@p_new_d_port_code D_PORT_CODE
									,@p_new_a_country A_COUNTRY
									,@p_new_a_port_code A_PORT_CODE
									,@p_new_lt_day CUSTOMER_LT
									,@p_new_to_country TO_COUNTRY
									,@p_new_to_city TO_CITY
									,FROM_SITE_TYPE
									,FROM_SITE_PLANT_ID
									,FROM_SITE_VENDOR_ID
									,FROM_SITE_SOLDTO_CODE
									,FROM_SITE_SHIPTO_CODE
									,FROM_SITE_COMPANY_ID
									,TO_SITE_TYPE
									,TO_SITE_PLANT_ID
									,TO_SITE_VENDOR_ID
									,TO_SITE_SOLDTO_CODE
									,TO_SITE_SHIPTO_CODE
									,TO_SITE_COMPANY_ID
									,@p_change_request_no CHANGE_REQ_NO
									,ERP_SO_NO
									,ERP_SO_ITEM_NO
									,ERP_DO_NO
									,ERP_STATUS
									,@p_last_updated_by CREATED_BY
									,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE
									,@p_last_updated_by LAST_UPDATED_BY
									,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE
									,@v_last_update_date--[dbo].[FN_MULTY_TIME](@p_time_zone) HISTORY_CREATION_DATE
								FROM SSP_ANL_SHIP_CONFIRM with(nolock)
								WHERE CONFIRM_ID = @p_confirm_id
					END
				   */
			END

			SET @v_log_type = 'END';
				SET @v_log_message = '########## END of procedure ##########';
				SET @v_description = '';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END TRY

		BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;
		END CATCH;
	END;




