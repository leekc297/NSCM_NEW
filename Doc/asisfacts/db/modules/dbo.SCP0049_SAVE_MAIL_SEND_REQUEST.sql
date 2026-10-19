
/*
 * Program ID   : SCP0049
 * Description  : SCP MAIL 발송 (Master < Supply Master < Capa ( NewModel Popup 요청)
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/03/26   khj79      최초작성
 * 2021/06/15   khj79      최초작성 - USER_ID_2 ~ USER_ID_10 추가 메일 발송
 
DECLARE  @p_division_id		NVARCHAR(MAX)  = '81^81^81'
	  , @p_company_id		NVARCHAR(MAX)  = 'C100^C100^C100'
	  , @p_site_id			NVARCHAR(MAX)  = 'A001^A001^A001'
	  , @p_plant_id			NVARCHAR(MAX)  = 'A040^A040^A040'
	  , @p_factory_id		NVARCHAR(MAX)  = 'A1^A1^A1'
	  , @p_operation_id		NVARCHAR(MAX)  = 'A5000^A5000^A7000'
	  , @p_line_id			NVARCHAR(MAX)  = 'A1A02^A1A02^A1A02'
	  , @p_electrode_type	NVARCHAR(MAX)  = 'Anode^Anode^A'
	  , @p_item_id			NVARCHAR(MAX)  = 'ANPAN0492A^ANPAN0492A^ANPAN0492A'
	  , @p_lane_qty			NVARCHAR(MAX)  = '2^0^0'
	  , @p_loss_code		NVARCHAR(MAX)  = 'LA001^LA001^LA001'
	  , @p_update_id		NVARCHAR(100)  = 'khj79'
*/


CREATE PROCEDURE [dbo].[SCP0049_SAVE_MAIL_SEND_REQUEST]
		@p_division_id		NVARCHAR(MAX)
	  , @p_company_id		NVARCHAR(MAX)
	  , @p_site_id			NVARCHAR(MAX)
	  , @p_plant_id			NVARCHAR(MAX)
	  , @p_factory_id		NVARCHAR(MAX)
	  , @p_operation_id		NVARCHAR(MAX)
	  , @p_line_id			NVARCHAR(MAX)
	  , @p_electrode_type	NVARCHAR(MAX)
	  , @p_item_id			NVARCHAR(MAX)
	  , @p_lane_qty			NVARCHAR(MAX)
	  , @p_loss_code		NVARCHAR(MAX)
	  , @p_update_id		NVARCHAR(100)
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'

	DECLARE @v_mail_title		NVARCHAR(100);
	DECLARE @v_head_cont		NVARCHAR(MAX);
	DECLARE @v_body_cont		NVARCHAR(MAX);
	DECLARE @v_body_text		NVARCHAR(MAX);
	DECLARE @v_to_mail			NVARCHAR(MAX);
	DECLARE @v_to_mail_back		NVARCHAR(MAX);
	DECLARE @TABLE_BODY			NVARCHAR(MAX);

	-- mail 전송을 위한 변수 설정
	DECLARE @v_division_id		NVARCHAR(30);
	DECLARE @v_company_id		NVARCHAR(30);
	DECLARE @v_site_id			NVARCHAR(30);
	DECLARE @v_plant_id			NVARCHAR(30);
	DECLARE @v_factory_id		NVARCHAR(30);
	DECLARE @v_operation_id		NVARCHAR(30);
	DECLARE @v_line_id			NVARCHAR(30);
	DECLARE @v_electrode_type	NVARCHAR(30);
	DECLARE @v_item_id			NVARCHAR(30);
	DECLARE @v_lane_qty			NVARCHAR(30);
	DECLARE @v_send_user_id		NVARCHAR(100);
	DECLARE @v_recv_user_id		NVARCHAR(100);
	DECLARE @v_recv_user_cnt	INTEGER = 0;
	DECLARE @v_recv_rank		INTEGER = 0;

	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0049_SAVE_MAIL_SEND_REQUEST';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;



	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRY
		-- 요청 정보를 임시 테이블에 저장
		INSERT INTO SCM_CAPA_MAIL_SEND_H_SN
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, ITEM_ID
				, LANE_QTY
				, LOSS_CODE
				, SEND_USER_ID
				, MAIL_SEND_YN
				, MAIL_REQUEST_TIME
		)
		SELECT A1.TOKEN			AS DIVISION_ID
			 , A2.TOKEN			AS COMPANY_ID
			 , A3.TOKEN			AS SITE_ID
			 , A4.TOKEN			AS PLANT_ID
			 , A5.TOKEN			AS FACTORY_ID
			 , A6.TOKEN			AS LINE_ID
			 , A7.TOKEN			AS ELECTRODE_TYPE
			 , A8.TOKEN			AS OPERATION_ID
			 , A9.TOKEN			AS ITEM_ID
			 , CASE WHEN A10.TOKEN = '-' OR A10.TOKEN  = '' THEN 0.0 ELSE  CONVERT(NUMERIC(20,10),A10.TOKEN) END AS LANE_QTY
			 , A11.TOKEN		AS LOSS_CODE
			 , @p_update_id		AS SEND_USER_ID
			 , 'N'				AS MAIL_SEND_YN
			 , SYSDATETIME()	AS MAIL_SEND_TIME
		  FROM DBO.UF_FX_String_Split(@p_division_id	, @v_delimiter) A1
		  JOIN DBO.UF_FX_String_Split(@p_company_id		, @v_delimiter) A2  ON A1.NR = A2.NR
		  JOIN DBO.UF_FX_String_Split(@p_site_id		, @v_delimiter) A3  ON A1.NR = A3.NR
		  JOIN DBO.UF_FX_String_Split(@P_plant_id		, @v_delimiter) A4  ON A1.NR = A4.NR
		  JOIN DBO.UF_FX_String_Split(@p_factory_id		, @v_delimiter) A5  ON A1.NR = A5.NR
		  JOIN DBO.UF_FX_String_Split(@p_line_id		, @v_delimiter) A6  ON A1.NR = A6.NR
		  JOIN DBO.UF_FX_String_Split(@p_electrode_type	, @v_delimiter) A7  ON A1.NR = A7.NR
		  JOIN DBO.UF_FX_String_Split(@p_operation_id	, @v_delimiter) A8  ON A1.NR = A8.NR
		  JOIN DBO.UF_FX_String_Split(@p_item_id		, @v_delimiter) A9  ON A1.NR = A9.NR
		  JOIN DBO.UF_FX_String_Split(@p_lane_qty		, @v_delimiter) A10 ON A1.NR = A10.NR
		  JOIN DBO.UF_FX_String_Split(@p_loss_code		, @v_delimiter) A11 ON A1.NR = A11.NR
		;

		-- 사용자 정보 INSERT(PIC 에 등록된 사용자 중 USER_ID_1 을 제외한 사용자)
		
		INSERT INTO SCM_CAPA_MAIL_SEND_H_SN
		(
			  DIVISION_ID
			, COMPANY_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, ITEM_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, LOSS_CODE
			, LANE_QTY
			, SEND_USER_ID
			, RECV_USER_ID
			, MAIL_SEND_YN
			, MAIL_REQUEST_TIME
		)
		SELECT DISTINCT DIVISION_ID
				 , COMPANY_ID
				 , SITE_ID
				 , PLANT_ID
				 , FACTORY_ID
				 , ITEM_ID
				 , OPERATION_ID
				 , LINE_ID
				 , ELECTRODE_TYPE
				 , LOSS_CODE
				 , LANE_QTY
				 , SEND_USER_ID
				 , USER_INFO_DATA
				 , 'N'					-- MAIL_SEND_YN
				 , SYSDATETIME()		-- MAIL_SEND_TIME
			 FROM (
					SELECT A.DIVISION_ID
						 , A.COMPANY_ID
						 , A.SITE_ID
						 , A.PLANT_ID
						 , A.FACTORY_ID
						 , B.ITEM_ID
						 , A.OPERATION_ID
						 , A.LINE_ID
						 , A.ELECTRODE_TYPE
						 , A.LOSS_CODE
						 , B.LANE_QTY
						 , B.SEND_USER_ID
						 , A.USER_ID_2
						 , A.USER_ID_3
						 , A.USER_ID_4
						 , A.USER_ID_5
						 , A.USER_ID_6
						 , A.USER_ID_7
						 , A.USER_ID_8
						 , A.USER_ID_9
						 , A.USER_ID_10
					  FROM SCM_MASTER_MANAGER_M_SN A WITH(NOLOCK)
					 INNER JOIN SCM_CAPA_MAIL_SEND_H_SN B WITH(NOLOCK)
					    ON A.LINE_ID = B.LINE_ID
					   AND A.OPERATION_ID = B.OPERATION_ID
					   AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
					   AND A.LOSS_CODE = B.LOSS_CODE
					 WHERE ISNULL(B.MAIL_SEND_YN,'N') = 'N'
				) AS T
			UNPIVOT ( 
						USER_INFO_DATA  FOR COLUMN_NAME IN (  USER_ID_2
															 , USER_ID_3
															 , USER_ID_4
															 , USER_ID_5
															 , USER_ID_6
															 , USER_ID_7
															 , USER_ID_8
															 , USER_ID_9
															 , USER_ID_10) 
					) AS X
			WHERE USER_INFO_DATA IS NOT NULL
			  AND USER_INFO_DATA <> ''
		;

		-- 사용자 정보 UPDATE(PIC 에 등록된 USER_ID_1 사용자)
		UPDATE SCM_CAPA_MAIL_SEND_H_SN
		   SET RECV_USER_ID	= M.USER_ID_1
		  FROM SCM_CAPA_MAIL_SEND_H_SN T
		  JOIN SCM_MASTER_MANAGER_M_SN M WITH(NOLOCK)
		    ON T.DIVISION_ID	= M.DIVISION_ID
		   AND T.COMPANY_ID		= M.COMPANY_ID
		   AND T.SITE_ID		= M.SITE_ID
		   AND T.PLANT_ID		= M.PLANT_ID
		   AND T.FACTORY_ID		= M.FACTORY_ID
		   AND T.OPERATION_ID	= M.OPERATION_ID
		   AND T.LINE_ID		= M.LINE_ID
		   AND T.ELECTRODE_TYPE	= M.ELECTRODE_TYPE
		   AND T.LOSS_CODE		= M.LOSS_CODE
		   AND ISNULL(T.MAIL_SEND_YN,'N') = 'N'
		   AND T.RECV_USER_ID IS NULL
		;

		-- 결과 코드 반환
		SELECT  'S' AS result_code

		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		BEGIN

		 BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

		 END;

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;
	END CATCH;
END
