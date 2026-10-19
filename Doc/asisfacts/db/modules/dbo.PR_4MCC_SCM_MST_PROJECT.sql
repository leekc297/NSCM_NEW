
/*
 Program ID  : [PR_4MCC_SCM_MST_PROJECT]                                                   
 Description : PR_4MCC_SCM_MST_PROJECT	                                                  
--------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                             
--------------------------------------------------------------------------------------------------
 2023/11/17  Chano0612  Initial Release [E20230608-000782] 4MCC 시스템 신규 구축에 따른 SCM 인터페이스 관련 항목 개발 
 2023/11/22  JSSBAE		14일 이전 데이터 삭제 후 생성하는 로직 추가, 컬럼 정보 추가, SEQ채번 RULE 변경
 2024/03/21	 JSSBAE		[E20240320-000882]_DM XIF 인덱스 생성 요청_데이터 삭제 로직 오류로 수정진행
*/

CREATE PROCEDURE [dbo].[PR_4MCC_SCM_MST_PROJECT]
AS

BEGIN

	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	DECLARE @n_if_name		NVARCHAR(12);
	DECLARE @n_if_no		INT;
	DECLARE @n_CNT			INT;
	DECLARE @n_dup_YN   	NVARCHAR(1);
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_4MCC_SCM_MST_PROJECT';
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
				
	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_4MCC_SCM_MST_PROJECT;
	
	BEGIN TRY
	
	SET @n_if_name = 'OSCM' + SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 3,6)
	SET @n_dup_YN = 'Y'
	
		/*-------------------------------------------------------------------------------------------------------
			IF 발송날짜 기준으로 데이터가 존재하는 경우, OSCM + 날짜 잘라낸 max(Seq)값을 Default_Val로 반영
			ELSE 발송날짜 기준으로 데이터가 없는 경우, Default_Val 은 초기값 유지
		-------------------------------------------------------------------------------------------------------*/
		BEGIN 
			SELECT @n_CNT = COUNT(*) FROM [LGCE_INFDEV].[dbo].[XIF_SCM_MST_PROJECT_4MCC_S] 
			WHERE CONVERT(NVARCHAR, IF_INS_DATE ,112) = CONVERT(NVARCHAR, GETDATE(), 112)
		END

		IF @n_CNT > 0
			SELECT @n_if_no = SUBSTRING(MAX(IF_SEQ), 11, 10) FROM [LGCE_INFDEV].[dbo].[XIF_SCM_MST_PROJECT_4MCC_S] 
			WHERE CONVERT(NVARCHAR, IF_INS_DATE ,112) = CONVERT(NVARCHAR, GETDATE(), 112)
		ELSE
			SET @n_if_no = 0
			
		/*-------------------------------------------------------------------------------------------------------
			매일 1회 도는 배치로 14일 이전 데이터는 삭제한다. 
			--[E20240320-000882]_DM XIF 인덱스 생성 요청_데이터 삭제 조건 오류로 수정진행
		-------------------------------------------------------------------------------------------------------*/
		BEGIN			
			DELETE FROM [LGCE_INFDEV].[dbo].[XIF_SCM_MST_PROJECT_4MCC_S]
			WHERE CONVERT(NVARCHAR, IF_INS_DATE ,112) < CONVERT(NVARCHAR, DATEADD(DAY, -14,GETDATE()), 112)
		END

		/*-------------------------------------------------------------------------------------------------------
			조건없이 마스터 테이블의 전체 데이터를 전송한다. 
		-------------------------------------------------------------------------------------------------------*/
		BEGIN    
			INSERT INTO [LGCE_INFDEV].[dbo].[XIF_SCM_MST_PROJECT_4MCC_S]
			SELECT 
			@n_if_name + RIGHT('0000000000' + CONVERT(NVARCHAR, @n_if_no + ROW_NUMBER() OVER(ORDER BY DIVISION_ID, PROJECT_CODE, PROJECT_VER_SEQ), 112), 10) AS IF_SEQ	--인터페이스번호
			, 'S' AS IF_TYPE									--인터페이스처리유형(S:데이터, R:처리결과)
			, 'OSCM_G4MC_XIF_SCM_MST_PROJECT' AS IF_ID			--인터페이스 ID
			, GETDATE() AS IF_INS_DATE							--인터페이스생성일시
			, 'N' AS IF_FLAG									--인터페이스전송상태(N:미처리,P:처리중,Y:처리완료)
			, NULL AS IF_SND_DATE								--인터페이스전송일시
			, DIVISION_ID										--사업부코드
			, PROJECT_CODE										--프로젝트코드
			, PROJECT_VER_SEQ									--프로젝트버전순번
			, PROJECT_NAME										--프로젝트명
			, BIZ_TYPE											--사업유형코드
			, BIZ_TYPE_NAME										--사업유형명
			, PROJECT_STATUS									--프로젝트상태코드
			, PROJECT_OWNER										--프로젝트담당사용자명
			, CURRENCY											--통화코드
			, DROP_YN											--제외여부
			, CAPACITY											--단위공급용량
			, GPLM_PROJECT_CODE									--GPLM프로젝트코드
			, GPLM_SYSTEM_PROJECT_CODE							--GPLM시스템프로젝트코드
			, GPLM_DEV_PROJECT_CODE								--GPLM개발프로젝트코드
			, GPLM_MAPPING_YN									--GPLM매핑여부
			, SHIPMENT_DATE										--출하일자
			, PRODUCT_GROUP_CODE								--제품그룹코드
			, PRODUCT_GROUP_NAME								--제품그룹명
			, INCOTERMS											--인코텀즈코드
			, CREATION_DATE										--데이터입력일시
			, CREATED_BY										--데이터입력사용자ID
			, LAST_UPDATE_DATE									--데이터수정일시
			, LAST_UPDATED_BY									--데이터수정사용자ID
			, ATTRIBUTE1										--사용자정의속성값내용1
			, ATTRIBUTE2										--사용자정의속성값내용2
			, ATTRIBUTE3										--사용자정의속성값내용3
			, ATTRIBUTE4										--사용자정의속성값내용4
			, ATTRIBUTE5										--사용자정의속성값내용5
			, ATTRIBUTE6										--사용자정의속성값내용6
			, ATTRIBUTE7										--사용자정의속성값내용7
			, ATTRIBUTE8										--사용자정의속성값내용8
			, ATTRIBUTE9										--사용자정의속성값내용9
			, ATTRIBUTE10										--사용자정의속성값내용10
			FROM SCM_MST_PROJECT
		END
		
		COMMIT TRANSACTION;
	END TRY

    BEGIN CATCH
	ROLLBACK TRANSACTION PR_4MCC_SCM_MST_PROJECT;

      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	  
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

    END CATCH

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END; 