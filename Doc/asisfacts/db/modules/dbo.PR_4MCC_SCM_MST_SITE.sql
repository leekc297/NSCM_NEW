
/*
 Program ID  : [PR_4MCC_SCM_MST_SITE]                                                   
 Description : PR_4MCC_SCM_MST_SITE	                                                  
--------------------------------------------------------------------------------------------------
 Date        In Charge    Description                                                             
--------------------------------------------------------------------------------------------------
 2023/11/17  Chano0612  Initial Release [E20230608-000782] 4MCC 시스템 신규 구축에 따른 SCM 인터페이스 관련 항목 개발 
 2023/11/22  JSSBAE		14일 이전 데이터 삭제 후 생성하는 로직 추가, 컬럼 정보 추가, SEQ채번 RULE 변경
 2024/03/21	 JSSBAE		[E20240320-000882]_DM XIF 인덱스 생성 요청_데이터 삭제 로직 오류로 수정진행
--------------------------------------------------------------------------------------------------
*/

-- EXEC PR_4MCC_SCM_MST_SITE 
CREATE PROCEDURE [dbo].[PR_4MCC_SCM_MST_SITE]
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_4MCC_SCM_MST_SITE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	
	--[C20200909-000203] LOG 표준화 적용
		-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
		
	-- 트랜잭션 (START)
	BEGIN TRANSACTION PR_4MCC_SCM_MST_SITE;

	BEGIN TRY
	
	SET @n_if_name = 'OSCM' + SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 3,6)
	SET @n_dup_YN = 'Y'
	
		/*-------------------------------------------------------------------------------------------------------
			IF 발송날짜 기준으로 데이터가 존재하는 경우, OSCM + 날짜 잘라낸 max(Seq)값을 Default_Val로 반영
			ELSE 발송날짜 기준으로 데이터가 없는 경우, Default_Val 은 초기값 유지
		-------------------------------------------------------------------------------------------------------*/
		BEGIN 
			SELECT @n_CNT = COUNT(*) FROM [LGCE_INFDEV].[dbo].[XIF_SCM_MST_SITE_4MCC_S] 
			WHERE CONVERT(NVARCHAR, IF_INS_DATE ,112) = CONVERT(NVARCHAR, GETDATE(), 112)
		END

		IF @n_CNT > 0
			SELECT @n_if_no = SUBSTRING(MAX(IF_SEQ), 11, 10) FROM [LGCE_INFDEV].[dbo].[XIF_SCM_MST_SITE_4MCC_S] 
			WHERE CONVERT(NVARCHAR, IF_INS_DATE ,112) = CONVERT(NVARCHAR, GETDATE(), 112)
		ELSE
			SET @n_if_no = 0
					
		/*-------------------------------------------------------------------------------------------------------
			매일 1회 도는 배치로 14일 이전 데이터는 삭제한다. 
			--[E20240320-000882]_DM XIF 인덱스 생성 요청_데이터 삭제 조건 오류로 수정진행
		-------------------------------------------------------------------------------------------------------*/
		BEGIN	
			DELETE FROM [LGCE_INFDEV].[dbo].[XIF_SCM_MST_SITE_4MCC_S]
			WHERE CONVERT(NVARCHAR, IF_INS_DATE ,112) < CONVERT(NVARCHAR, DATEADD(DAY, -14,GETDATE()), 112)
		END
			
		/*-------------------------------------------------------------------------------------------------------
			조건없이 마스터 테이블의 전체 데이터를 전송한다. 
		-------------------------------------------------------------------------------------------------------*/
		BEGIN    
			INSERT INTO [LGCE_INFDEV].[dbo].[XIF_SCM_MST_SITE_4MCC_S]
			SELECT 
			@n_if_name + RIGHT('0000000000' + CONVERT(NVARCHAR, @n_if_no + ROW_NUMBER() OVER( ORDER BY DIVISION_ID, SCM_SITE_ID), 112), 10) AS IF_SEQ		--인터페이스번호
			, 'S' AS IF_TYPE							--인터페이스처리유형(S:데이터, R:처리결과)
			, 'OSCM_G4MC_XIF_SCM_MST_SITE' AS IF_ID		--인터페이스 ID
			, GETDATE() AS IF_INS_DATE					--인터페이스생성일시
			, 'N' AS IF_FLAG							--인터페이스전송상태(N:미처리,P:처리중,Y:처리완료)
			, NULL AS IF_SND_DATE						--인터페이스전송일시
			, DIVISION_ID								--사업부코드
			, SCM_SITE_ID								--SCM사이트ID
			, PLANT_ID									--플랜트코드
			, OPERATION_GROUP							--공정그룹코드
			, SITE_DESCRIPTION							--사이트설명
			, SITE_TYPE									--사이트유형코드
			, CITY										--도시코드
			, COUNTRY									--국가코드
			, DEPT_ID									--부서코드
			, VMI_YN									--VMI사이트여부
			, VALID_YN									--유효여부
			, NEW_YN									--신규사이트여부
			, SITE_HRCY_ID								--사이트계층ID
			, OSP_YN									--OSP여부
			, SHIP_FROZEN								--선적확정기간일수
			, PROD_FROZEN								--생산확정기간일수
			, END_CUSTOMER								--최종고객명
			, SOLDTO_CUSTOMER							--출하처고객명
			, FP_PLAN_PERIOD							--FP계획SCP반영구간값수치
			, BUILD_AHEAD								--선행생산가능시간수
			, LOGISTIC_PLANT_ID							--물류플랜트코드
			, PACKER_ITEM_ID_SUFFIX						--외주업체ID접미사명
			, HQ_VENDOR_CODE							--본사공급업체코드
			, COMPANY_ID								--회사코드
			, SITE_ID									--사이트ID
			, CREATED_BY								--데이터입력사용자ID
			, CREATION_DATE								--데이터입력일시
			, LAST_UPDATED_BY							--데이터수정사용자ID
			, LAST_UPDATE_DATE							--데이터수정일시
			, ATTRIBUTE1								--사용자정의속성값내용1
			, ATTRIBUTE2								--사용자정의속성값내용2
			, ATTRIBUTE3								--사용자정의속성값내용3
			, ATTRIBUTE4								--사용자정의속성값내용4
			, ATTRIBUTE5								--사용자정의속성값내용5
			, ATTRIBUTE6								--사용자정의속성값내용6
			, ATTRIBUTE7								--사용자정의속성값내용7
			, ATTRIBUTE8								--사용자정의속성값내용8
			, ATTRIBUTE9								--사용자정의속성값내용9
			, ATTRIBUTE10								--사용자정의속성값내용10
			FROM SCM_MST_SITE
		END
		 
		COMMIT TRANSACTION;
	END TRY

    BEGIN CATCH
	ROLLBACK TRANSACTION PR_4MCC_SCM_MST_SITE;

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
