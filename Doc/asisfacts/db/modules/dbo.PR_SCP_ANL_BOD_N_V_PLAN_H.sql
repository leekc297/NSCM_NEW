
/*
 * Program ID   : PR_SCP_ANL_BOD_N_V_PLAN_H
 * Description  : 계획실행 당시 참조하는 bod_n_v의 테이블로 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.05.18   sclee.lee      PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - Initial Release
 * 2023.03.28	hrkim		   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 *
 */
-- EXEC dbo.PR_SCP_ANL_BOD_N_V_PLAN_H 'EE', '20220509', 'MA', 1
CREATE PROCEDURE [dbo].[PR_SCP_ANL_BOD_N_V_PLAN_H]
	@p_division_id          NVARCHAR(30)
   ,@p_plan_name            NVARCHAR(100)
   ,@p_plan_type            NVARCHAR(50)
   ,@p_plan_seq             INT
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	-- 복사대상 사업부 목록
	DECLARE @v_tb_division_id TABLE
	(
	 DIVISION_ID              NVARCHAR(30)
	);

	/*
	-- --계획을 생성할 사업부코드가 'EE' 또는 'EE_UC'인 경우 SCM_MST_DIVISION의 WHERE 조건에 해당하는 사업부들을 복사대상으로 지정한다
	-- IF(@p_division_id IN ('EE', 'EE_UC'))
	-- BEGIN
	--     INSERT INTO @v_tb_division_id
    --     SELECT A.DIVISION_ID
    --     FROM   dbo.SCM_MST_DIVISION A WITH (NOLOCK)
    --     WHERE  1 = 1
    --     AND    EXISTS ( SELECT 1 FROM dbo.SCM_MST_DIVISION WHERE DIVISION_ID = @p_division_id AND ATTRIBUTE4 = A.ATTRIBUTE4 );
	-- END
	-- 
	-- ELSE
	-- BEGIN
	--     INSERT INTO @v_tb_division_id
    --     SELECT @p_division_id;
	-- END
	*/

	-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
	INSERT INTO @v_tb_division_id
	SELECT DISTINCT DT.DIVISION_ID
	 FROM SCM_MST_DIVISION  DM WITH(NOLOCK)  
		  INNER JOIN SCM_MST_DIVISION DT WITH(NOLOCK) 
				  ON DT.ATTRIBUTE4 = DM.ATTRIBUTE4 
				 AND DT.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE'
										   THEN DT.DIVISION_ID
										   ELSE DM.DIVISION_ID
									  end
				AND DT.VALID_YN	   = 'Y'
	WHERE 1=1
	  AND DM.DIVISION_ID = @p_division_id 
	  AND DM.VALID_YN	 = 'Y'
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name   NVARCHAR(150) = 'PR_SCP_ANL_BOD_N_V_PLAN_H';
    DECLARE @v_log_type       NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count      INTEGER = 0;
    DECLARE @v_log_message    NVARCHAR(1000);
    DECLARE @v_description    NVARCHAR(500);
    DECLARE @d_event_date     DATETIME;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = CONCAT('DIVISION_ID : ', @p_division_id, ', PLAN_NAME : ' + @p_plan_name, ', PLAN_TYPE : ', @p_plan_type, ', PLAN_SEQ : ', @p_plan_seq);
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
		BEGIN
            BEGIN TRAN

            -- 기존내역 존재하면 지우고 시작
            WHILE(1 = 1)
            BEGIN
                DELETE TOP (10000) A
                FROM dbo.SCP_ANL_BOD_N_V_PLAN_H A
                WHERE DIVISION_ID = @p_division_id
				AND   PLAN_NAME = @p_plan_name
				AND   PLAN_TYPE = @p_plan_type
				AND   PLAN_SEQ = @p_plan_seq;
           
                IF(@@ROWCOUNT = 0)
                BEGIN
                    BREAK;
                END
            END

            COMMIT
		
            -------------------------------------------------------
            -- SCP_MST_BOD_N_V에 저장
            -------------------------------------------------------
            INSERT INTO dbo.SCP_ANL_BOD_N_V_PLAN_H WITH (TABLOCK)
            (
              DIVISION_ID
             ,PLAN_NAME
             ,PLAN_TYPE
             ,PLAN_SEQ
             ,ORG_DIVISION_ID
             ,BOD_ID
             ,BOD_TYPE
             ,FROM_SITE
             ,D_COUNTRY
             ,D_PORT_CODE
             ,A_COUNTRY
             ,A_PORT_CODE
             ,TO_COUNTRY
             ,TO_CITY
             ,HUB_SLOC
             ,TO_SITE
             ,INCOTERMS
             ,SSP_INCOTERMS
             ,TRANSPORT_MODE
             ,ROUTE_ID
             ,PRIORITY
             ,DAYS_MON
             ,DAYS_TUE
             ,DAYS_WED
             ,DAYS_THU
             ,DAYS_FRI
             ,DAYS_SAT
             ,DAYS_SUN
             ,SAFETY_STOCK
             ,LT_DEPARTURE_INLAND
             ,LT_WAIT_SHIPPING
             ,LT_VOYAGE
             ,LT_LAY_OFF_CLEARANCE
             ,LT_ARRIVAL_INLAND
             ,LT_TOTAL
             ,SHIP_LT_TOTAL
             ,BOD_VALID_YN
             ,ROUTE_VALID_YN
             ,LT_TYPE
             ,LT_TOTAL_ORIGIN
             ,SHIP_LT_TOTAL_ORIGIN
             ,LT_TOTAL_SSP
             ,SHIP_LT_TOTAL_SSP
             ,BEFORE_LT
             ,AFTER_LT
             ,ORG_LT_TOTAL
             ,ORG_SHIP_LT_TOTAL
             ,ORG_LT_TOTAL_SSP
             ,ADD_AFTER_LT_TOTAL
             ,SEGMENT3
             ,SSP_SEGMENT3
             ,FROM_YYYYMMDD
             ,TO_YYYYMMDD
             ,CREATION_DATE
             ,CREATED_BY
             ,LAST_UPDATE_DATE
             ,LAST_UPDATED_BY
            )
            SELECT @p_division_id DIVISION_ID
                  ,@p_plan_name PLAN_NAME
                  ,@p_plan_type PLAN_TYPE
                  ,@p_plan_seq PLAN_SEQ
                  ,A.division_id ORG_DIVISION_ID
                  ,A.BOD_ID
                  ,A.bod_type
                  ,A.from_site
                  ,A.d_country
                  ,A.d_port_code
                  ,A.a_country
                  ,A.a_port_code
                  ,A.to_country
                  ,A.to_city
                  ,A.hub_sloc
                  ,A.to_site
                  ,A.incoterms
                  ,A.ssp_incoterms
                  ,A.transport_mode
                  ,A.route_id
                  ,A.priority
                  ,A.days_mon
                  ,A.days_tue
                  ,A.days_wed
                  ,A.days_thu
                  ,A.days_fri
                  ,A.days_sat
                  ,A.days_sun
                  ,A.safety_stock
                  ,A.lt_departure_inland
                  ,A.lt_wait_shipping
                  ,A.lt_voyage
                  ,A.lt_lay_off_clearance
                  ,A.lt_arrival_inland
                  ,A.lt_total
                  ,A.ship_lt_total
                  ,A.bod_valid_yn
                  ,A.route_valid_yn
                  ,A.lt_type
                  ,A.lt_total_origin
                  ,A.ship_lt_total_origin
                  ,A.lt_total_ssp
                  ,A.ship_lt_total_ssp
                  ,A.before_lt
                  ,A.after_lt
                  ,A.org_lt_total
                  ,A.org_ship_lt_total
                  ,A.org_lt_total_ssp
                  ,A.add_after_lt_total
                  ,A.segment3
                  ,A.ssp_segment3
                  ,A.from_yyyymmdd
                  ,A.to_yyyymmdd
                  ,GETDATE() CREATION_DATE
                  ,'scm_batch' CREATED_BY
                  ,GETDATE() LAST_UPDATE_DATE
                  ,'scm_batch' LAST_UPDATED_BY
            FROM   dbo.SCP_MST_BOD_N_V A
            WHERE  A.division_id IN ( SELECT * FROM @v_tb_division_id );
            
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END
	END TRY

	BEGIN CATCH
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
		BEGIN
		    COMMIT WORK;
		END
	
	    -- error코드, errror 메시지 반환
	    SELECT 'F' AS result_code;
	    SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END






