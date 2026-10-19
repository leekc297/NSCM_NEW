
/*
 * Program ID   : PR_DM_PLN_MKT_FCST_TO_XIF_PLM_PLAN_S
 * Description  : 개발샘플 Visibility 구축 관련
 *                DM_PLN_MKT_FCST -> XIF_PLM_DM_PLN_MKT_FCST_PLAN_S 테이블로 I/F 처리 Procedure
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2018.11.29   KHSONG         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
   20190315     KHSONG         DESCRIPTION 추가요청 적용
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * ---------------------------------------------------------------------------------------------------
 * 	● 제약 조건 상세화 (DM → PLM)
 * 		가) 개발 샘플만 필요 (양산 제외)
 * 	- FCST_TYPE이 'MASS, Sample(Mass/Chargeable)'이 아닌 제품에 대한 검색이 필요함.
 * 		나) 자동차 전지 및 소형 전지만 필요
 * 	- DIVISION_ID 는 '81' 과 '40' 제품에 대한 검색이 필요함.
 * 		다) 최종 확정된 데이터만 필요
 * --------------------------------------------------------------------------------------------------- 
 * 배포시 주의사항 : 개발기 -> LGCE_INF , 운영기 -> LGCE_INF
 * --------------------------------------------------------------------------------------------------- 
 * IF_SEQ : 전송일자 8자리 + 일자별 Uniq Sequence 2자리 + Uniq Sequence 6자리
 * 
 * 
 * 
 * ---------------------------------------------------------------------------------------------------
 */



CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_TO_XIF_PLM_PLAN_S]

	-- Add the parameters for the stored procedure here
	-- @p_division_id			NVARCHAR(MAX)   -- division_id 전달받음
	--,@p_ver_return_no		NVARCHAR(MAX)   -- ver_return_no 전달받음

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- 변수 설정
	DECLARE @IFSEQNO              NVARCHAR(14) = '';
    DECLARE @TRANSFER_DATE        DATETIME     = GETDATE();  
    DECLARE @TRANSFER_TYPE        NVARCHAR(1)  = 'I'; -- IF_TYPE 인터페이스처리유형 (I:Insert,U:Update,D:Delete) 
    DECLARE @TRANSFER_FLAG        NVARCHAR(1)  = 'N'; -- IF_FLAG 인터페이스전송상태 (N:미처리,P:처리중,Y:처리완료) 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_TO_XIF_PLM_PLAN_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION MKT_FCST_TO_XIF_PLM_PLAN_S;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		-- I/F 테이블에 INSERT 처리
		BEGIN
			-- (1) DM_PLN_MKT_FCST
			-- PK IFSEQNO 생성 / IF_SEQ : (전송일자 8자리 + 일자별 MAX Uniq Sequence 2자리 추출하여 다음번호로 설정
			SELECT @IFSEQNO = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(SUBSTRING(IF_SEQ,9,2),2)),0)+1 ) ,2)
				FROM [LGCE_INF].[dbo].XIF_PLM_DM_PLN_MKT_FCST_PLAN_S WITH(NOLOCK)    -- (개발기 : LGCE_INF / 운영기:LGCE_INF)
					WHERE IF_SEQ LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

			-- I/F 테이블에 INSERT 처리
			INSERT INTO [LGCE_INF].[dbo].XIF_PLM_DM_PLN_MKT_FCST_PLAN_S  -- (개발기 : LGCE_INF / 운영기:LGCE_INF)
					( IF_SEQ,IF_TYPE,IF_ID,IF_INS_DATE,IF_FLAG,IF_SND_DATE
					,DIVISION_ID,PROJECT_CODE,SALES_SITE_ID,MODEL_ID,DOM_EXP
					,FCST_TYPE,INCOTERMS,MEASURE,PLAN_SITE_ID,YYYYMMDD,BIZ_TYPE
					,BIZ_TYPE_NM,MODEL_NM,MODEL_NICK_NAME,SALES_SITE_NM,DIVISION_NM
					,PROJECT_NM,QTY,CREATE_BY,CREATTION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					/* 20190315 KHSONG DESCRIPTION 추가요청 적용 */
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3
					)
			SELECT 
					 -- IF_SEQ		인터페이스번호 16자리 (전송일자 8자리 + 일자별 Uniq Sequence 2자리 + Uniq Sequence 6자리)
					 @IFSEQNO + replicate('0',6- len(row_number() OVER (ORDER BY A.DIVISION_ID))) + cast(row_number() OVER (ORDER BY A.DIVISION_ID) as varchar)     
					,@TRANSFER_TYPE  		-- IF_TYPE		인터페이스처리유형 (I:Insert,U:Update,D:Delete) 
					,'OFP0_OPLM_DSV_DM_PLM_001' AS IF_ID
					,@TRANSFER_DATE			-- IF_INS_DATE  인터페이스생성일시 
					,@TRANSFER_FLAG			-- IF_FLAG		인터페이스전송상태 (N:미처리,P:처리중,Y:처리완료) 
					,NULL       			-- IF_SND_DATE  인터페이스전송일시 
					,A.DIVISION_ID,A.PROJECT_CODE,A.SCM_SITE_ID,A.ITEM_ID,DOM_EXP,FCST_TYPE,A.INCOTERMS
					,MEASURE,PLANT_SITE_ID,YYYYMMDD
					,isnull(B.BIZ_TYPE,'')				AS BIZ_TYPE
					,isnull(B.BIZ_TYPE_NAME,'')			AS BIZ_TYPE_NM
					,isnull(C.ITEM_NAME,'')				AS MODEL_NM
					,isnull(C.NICK_NAME,'')				AS MODEL_NICK_NAME
					,isnull(D.SITE_DESCRIPTION,'')		AS SALES_SITE_NM
					,isnull(E.DIVISION_NAME,'')			AS DIVISION_NM
					,isnull(B.PROJECT_NAME,'')			AS PROJECT_NM
					,QTY,A.CREATED_BY,A.CREATION_DATE,A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE
					/* 20190315 KHSONG DESCRIPTION 추가요청 적용 */
					,(SELECT M.DESCRIPTION		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK) WHERE M.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND A.FCST_TYPE = M.SEGMENT1   ) AS ATTRIBUTE1
					,(SELECT M.DESCRIPTION		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK) WHERE M.LOOKUP_TYPE = 'INCOTERMS'		  AND A.INCOTERMS = M.SEGMENT1   ) AS ATTRIBUTE2
					,(SELECT M.COLUMN_LABEL_NAME FROM SCM_MST_SHEET_MEASURE		   M WITH(NOLOCK) WHERE M.PROGRAM_ID  = 'DMF0003'		  AND A.MEASURE   = M.COLUMN_NAME) AS ATTRIBUTE3
					FROM DM_PLN_MKT_FCST A WITH(NOLOCK)
						LEFT JOIN SCM_MST_PROJECT B WITH(NOLOCK)
							ON (A.DIVISION_ID = B.DIVISION_ID	AND A.PROJECT_CODE = B.PROJECT_CODE)
						LEFT JOIN DM_MST_ITEM_SINGLE_V C WITH(NOLOCK)
							ON (A.DIVISION_ID = C.DIVISION_ID AND  A.ITEM_ID = C.ITEM_ID)
						INNER JOIN SCM_MST_SITE D WITH(NOLOCK)
							ON (A.DIVISION_ID = D.DIVISION_ID	AND A.SCM_SITE_ID = D.SCM_SITE_ID AND D.VALID_YN = 'Y')
						INNER JOIN SCM_MST_DIVISION E WITH(NOLOCK)
							ON (A.DIVISION_ID = E.DIVISION_ID	)
				WHERE A.DIVISION_ID	IN ( SELECT DIVISION_ID FROM SCM_MST_DIVISION WHERE ATTRIBUTE3 IN ( '40', '81' )) -- 대상은 자동차,소형만
					--AND A.SCM_SITE_ID	= 'LGCNA_CN_NKG'  -- sample data
					AND MEASURE = 'MKT_FCST'  -- MKT_FCST MEASURE만
					AND QTY > 0               -- 값이 존재하는경우만
					AND FCST_TYPE		NOT IN ('MPS','SMC') -- MASS, Sample(Mass/Chargeable) 은 제외
					AND YYYYMMDD > = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD


		END

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION MKT_FCST_TO_XIF_PLM_PLAN_S;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
    --  IF @v_log_message IS NULL
	--  SELECT 'success'

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

