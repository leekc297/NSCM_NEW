/*
 * Program ID   : PR_DM_PLN_ADJUSTED_MKT_FCST_R_TO_MKT_FCST
 * Description  : Visibility 구축 프로젝트
 *                PLM → DM MKT_FCST 테이블로 INSERT할 데이터 수신받아 처리
 *
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20181212     KHSONG         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 배포시 주의사항 : 개발기 -> LGCE_INFDEV , 운영기 -> LGCE_INF
 * 20190116 KHSONG 작업 임시 SKIP 처리하기
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_PLN_ADJUSTED_MKT_FCST_R_TO_MKT_FCST]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user			NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name			NVARCHAR(150) = 'PR_DM_PLN_ADJUSTED_MKT_FCST_R_TO_MKT_FCST';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	DECLARE @n_history_seq			BIGINT;

    -- CURSOR INPUT DATA
	DECLARE @v_ifseqno				NVARCHAR(50)     ; -- SEQ
	DECLARE @v_DML_FLAG				NVARCHAR(01)     ; -- DML FLAG (I,U,D)
	DECLARE @v_DIVISION_ID          NVARCHAR(30) 	 ;
	DECLARE @v_PROJECT_CODE         NVARCHAR(50) 	 ;
	DECLARE @v_SCM_SITE_ID          NVARCHAR(30) 	 ;
	DECLARE @v_ITEM_ID              NVARCHAR(50) 	 ;
	DECLARE @v_DOM_EXP              NVARCHAR(3)  	 ;
	DECLARE @v_DM_FCST_TYPE         NVARCHAR(20) 	 ;
	DECLARE @v_FCST_TYPE            NVARCHAR(20) 	 ;
	DECLARE @v_DM_INCOTERMS         NVARCHAR(10) 	 ;
	DECLARE @v_INCOTERMS            NVARCHAR(10) 	 ;
	DECLARE @v_MEASURE              NVARCHAR(50) 	 ;
	DECLARE @v_PLANT_SITE_ID        NVARCHAR(30) 	 ;
	DECLARE @v_DM_YYYYMMDD          NVARCHAR(8)  	 ;
	DECLARE @v_YYYYMMDD             NVARCHAR(8)  	 ;
	DECLARE @v_QTY                  NUMERIC(20,10)   ;

	DECLARE @v_I_COUNT				INTEGER = 0;
	DECLARE @v_U_COUNT				INTEGER = 0;
	DECLARE @v_D_COUNT				INTEGER = 0;
	DECLARE @v_RESULT_COUNT			INTEGER = 0;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRAN
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
	BEGIN TRY	
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

		-- IF TABLE의 신규 수신받은 건이 있을때만 처리
		IF ( ( SELECT COUNT(1) FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R WITH(NOLOCK) WHERE ISNULL(PROC_FLAG,'N') = 'N' )
		   --) > 0  
		   ) > 1000000  -- 20190116 KHSONG 작업 임시 SKIP 처리하기
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--                                                                             IF TABLE의 정보가 존재하는경우 수행 (START)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		BEGIN

			  -- 처리할 데이터를 진행중'P'로 마킹처리
			  UPDATE LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R
			    SET PROC_FLAG = 'P'
					WHERE ISNULL(PROC_FLAG,'N') = 'N'

			  -- CURSOR 시작
			  IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_ADJUSTED_MKT_FCST')
				BEGIN
					CLOSE CUR_ADJUSTED_MKT_FCST
					DEALLOCATE CUR_ADJUSTED_MKT_FCST
				END;

				-- 지나간 배치까지 적용하기 위해 Cursor 로 처리
				DECLARE CUR_ADJUSTED_MKT_FCST CURSOR FOR
		  
				SELECT IF_SEQ,DML_FLAG,DM_FCST_TYPE,DM_INCOTERMS,DM_YYYYMMDD
					  ,DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE
				      ,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY
					FROM   LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R WITH(NOLOCK)
						WHERE  PROC_FLAG = 'P'
				ORDER BY IF_SEQ ASC;

				OPEN CUR_ADJUSTED_MKT_FCST;
				FETCH NEXT FROM CUR_ADJUSTED_MKT_FCST 
				INTO @v_ifseqno,@v_DML_FLAG,@v_DM_FCST_TYPE,@v_DM_INCOTERMS,@v_DM_YYYYMMDD
					,@v_DIVISION_ID,@v_PROJECT_CODE,@v_SCM_SITE_ID,@v_ITEM_ID,@v_DOM_EXP,@v_FCST_TYPE
				    ,@v_INCOTERMS,@v_MEASURE,@v_PLANT_SITE_ID,@v_YYYYMMDD,@v_QTY          
				 ;

				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				WHILE (@@FETCH_STATUS = 0) 
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				BEGIN
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

					--------------------------------------------------------------------------- ◇◇◇◇◇
					---INSERT 인경우
					--------------------------------------------------------------------------- ◇◇◇◇◇
					IF  @v_DML_FLAG = 'I'
						BEGIN
							-- 삭제전 기존정보 history insert
						   INSERT INTO dbo.DM_PLN_MKT_FCST_H
						   ( DIVISION_ID,HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
							,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
							,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
						   SELECT 
						     DIVISION_ID,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H AS HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
							,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,'EDI_VISIBILITY' AS LAST_UPDATED_BY,GETDATE() AS LAST_UPDATE_DATE
							,'ifseqno : '+@v_ifseqno AS ATTRIBUTE1,'DML_FLAG : '+@v_DML_FLAG AS ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
						   FROM DM_PLN_MKT_FCST WITH(NOLOCK)
								WHERE 1=1
									AND DIVISION_ID    =  @v_DIVISION_ID  
									AND PROJECT_CODE   =  @v_PROJECT_CODE 
									AND SCM_SITE_ID	   =  @v_SCM_SITE_ID	 
									AND ITEM_ID		   =  @v_ITEM_ID		 
									AND DOM_EXP		   =  @v_DOM_EXP		 
									AND MEASURE		   =  @v_MEASURE		 
									AND PLANT_SITE_ID  =  @v_PLANT_SITE_ID
									AND FCST_TYPE	   =  @v_DM_FCST_TYPE	 -- DM의 변경전값과 일치하는 데이터
									AND INCOTERMS	   =  @v_DM_INCOTERMS	 -- DM의 변경전값과 일치하는 데이터
									AND YYYYMMDD	   =  @v_DM_YYYYMMDD	 -- DM의 변경전값과 일치하는 데이터
									AND EXISTS (SELECT DIVISION_ID FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R A WITH(NOLOCK)
												WHERE  A.PROC_FLAG = 'P'
													AND A.IF_SEQ		= @v_ifseqno
													AND A.DML_FLAG		= @v_DML_FLAG
												)

							-- DM의 변경전 데이터는 삭제함
							DELETE FROM DM_PLN_MKT_FCST
								WHERE 1=1
									AND DIVISION_ID    =  @v_DIVISION_ID  
									AND PROJECT_CODE   =  @v_PROJECT_CODE 
									AND SCM_SITE_ID	   =  @v_SCM_SITE_ID	 
									AND ITEM_ID		   =  @v_ITEM_ID		 
									AND DOM_EXP		   =  @v_DOM_EXP		 
									AND MEASURE		   =  @v_MEASURE		 
									AND PLANT_SITE_ID  =  @v_PLANT_SITE_ID
									AND FCST_TYPE	   =  @v_DM_FCST_TYPE	 -- DM의 변경전값과 일치하는 데이터
									AND INCOTERMS	   =  @v_DM_INCOTERMS	 -- DM의 변경전값과 일치하는 데이터
									AND YYYYMMDD	   =  @v_DM_YYYYMMDD	 -- DM의 변경전값과 일치하는 데이터
									AND EXISTS (SELECT DIVISION_ID FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R A WITH(NOLOCK)
												WHERE  A.PROC_FLAG = 'P'
													AND A.IF_SEQ		= @v_ifseqno
													AND A.DML_FLAG		= @v_DML_FLAG
												)

							-- 신규데이터를 INSERT함
							INSERT INTO DM_PLN_MKT_FCST
								  (DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
								  ,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
								  ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
								  )
							SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
								  ,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,'EDI_VISIBILITY',GETDATE(),'EDI_VISIBILITY',GETDATE()
									,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
							FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R WITH(NOLOCK)
								WHERE  PROC_FLAG = 'P'
								  AND IF_SEQ	= @v_ifseqno
								  AND DML_FLAG	= @v_DML_FLAG

							-- 작업 COUNT 증가
							SET @v_I_COUNT = @v_I_COUNT + 1
						END
					--------------------------------------------------------------------------- ◇◇◇◇◇
					---UPDATE 인경우
					--------------------------------------------------------------------------- ◇◇◇◇◇
					IF  @v_DML_FLAG = 'U'
						BEGIN
							-------------------------------------------- ◇◇◇◇◇
							--- UPDATE 대상건이 존재하는지 판단
							-------------------------------------------- ◇◇◇◇◇
							IF ( SELECT COUNT(1) FROM DM_PLN_MKT_FCST WITH(NOLOCK)
									WHERE 1=1
										AND DIVISION_ID    =  @v_DIVISION_ID  
										AND PROJECT_CODE   =  @v_PROJECT_CODE 
										AND SCM_SITE_ID	   =  @v_SCM_SITE_ID	 
										AND ITEM_ID		   =  @v_ITEM_ID		 
										AND DOM_EXP		   =  @v_DOM_EXP		 
										AND MEASURE		   =  @v_MEASURE		 
										AND PLANT_SITE_ID  =  @v_PLANT_SITE_ID
										AND FCST_TYPE	   =  @v_DM_FCST_TYPE	 -- DM의 변경전값과 일치하는 데이터
										AND INCOTERMS	   =  @v_DM_INCOTERMS	 -- DM의 변경전값과 일치하는 데이터
										AND YYYYMMDD	   =  @v_DM_YYYYMMDD	 -- DM의 변경전값과 일치하는 데이터
										AND EXISTS (SELECT DIVISION_ID FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R A WITH(NOLOCK)
													WHERE  A.PROC_FLAG = 'P'
														AND A.IF_SEQ		= @v_ifseqno
														AND A.DML_FLAG		= @v_DML_FLAG
													) 
								) > 0
								-------------------------------------------- ◇◇◇◇◇
								--- UPDATE 대상건이 존재하는경우는 UPDATE 처리
								-------------------------------------------- ◇◇◇◇◇
								BEGIN

										-- UPDATE전 기존정보 history insert
									   INSERT INTO dbo.DM_PLN_MKT_FCST_H
									   ( DIVISION_ID,HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
										,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
										,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
										)
									   SELECT 
										 DIVISION_ID,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H AS HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
										,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,'EDI_VISIBILITY' AS LAST_UPDATED_BY,GETDATE() AS LAST_UPDATE_DATE
										,'ifseqno : '+@v_ifseqno AS ATTRIBUTE1,'DML_FLAG : '+@v_DML_FLAG AS ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
									   FROM DM_PLN_MKT_FCST WITH(NOLOCK)
											WHERE 1=1
												AND DIVISION_ID    =  @v_DIVISION_ID  
												AND PROJECT_CODE   =  @v_PROJECT_CODE 
												AND SCM_SITE_ID	   =  @v_SCM_SITE_ID	 
												AND ITEM_ID		   =  @v_ITEM_ID		 
												AND DOM_EXP		   =  @v_DOM_EXP		 
												AND MEASURE		   =  @v_MEASURE		 
												AND PLANT_SITE_ID  =  @v_PLANT_SITE_ID
												AND FCST_TYPE	   =  @v_DM_FCST_TYPE	 -- DM의 변경전값과 일치하는 데이터
												AND INCOTERMS	   =  @v_DM_INCOTERMS	 -- DM의 변경전값과 일치하는 데이터
												AND YYYYMMDD	   =  @v_DM_YYYYMMDD	 -- DM의 변경전값과 일치하는 데이터
												AND EXISTS (SELECT DIVISION_ID FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R A WITH(NOLOCK)
															WHERE  A.PROC_FLAG = 'P'
																AND A.IF_SEQ		= @v_ifseqno
																AND A.DML_FLAG		= @v_DML_FLAG
															)

										-- UPDATE 처리
										UPDATE DM_PLN_MKT_FCST
										   SET 	DIVISION_ID      =  @v_DIVISION_ID  
											   ,PROJECT_CODE     =  @v_PROJECT_CODE 
											   ,SCM_SITE_ID	     =  @v_SCM_SITE_ID	 
											   ,ITEM_ID		     =  @v_ITEM_ID		 
											   ,DOM_EXP		     =  @v_DOM_EXP		 
											   ,MEASURE		     =  @v_MEASURE		 
											   ,PLANT_SITE_ID    =  @v_PLANT_SITE_ID
											   ,FCST_TYPE	     =  @v_FCST_TYPE	 -- 변경된 신규 데이터
											   ,INCOTERMS	     =  @v_INCOTERMS	 -- 변경된 신규 데이터
											   ,YYYYMMDD	     =  @v_YYYYMMDD	 -- 변경된 신규 데이터
											   ,QTY			     =  @v_QTY
											   ,CREATED_BY		 = 'EDI_VISIBILITY'
											   ,CREATION_DATE	 =  GETDATE()
											   ,LAST_UPDATED_BY  = 'EDI_VISIBILITY'
											   ,LAST_UPDATE_DATE =  GETDATE()
										WHERE 1=1
											AND DIVISION_ID    =  @v_DIVISION_ID  
											AND PROJECT_CODE   =  @v_PROJECT_CODE 
											AND SCM_SITE_ID	   =  @v_SCM_SITE_ID	 
											AND ITEM_ID		   =  @v_ITEM_ID		 
											AND DOM_EXP		   =  @v_DOM_EXP		 
											AND MEASURE		   =  @v_MEASURE		 
											AND PLANT_SITE_ID  =  @v_PLANT_SITE_ID
											AND FCST_TYPE	   =  @v_DM_FCST_TYPE	 -- DM의 변경전값과 일치하는 데이터
											AND INCOTERMS	   =  @v_DM_INCOTERMS	 -- DM의 변경전값과 일치하는 데이터
											AND YYYYMMDD	   =  @v_DM_YYYYMMDD	 -- DM의 변경전값과 일치하는 데이터
											AND EXISTS (SELECT DIVISION_ID FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R A WITH(NOLOCK)
														WHERE  A.PROC_FLAG = 'P'
															AND A.IF_SEQ		= @v_ifseqno
															AND A.DML_FLAG		= @v_DML_FLAG
														)
								END

							ELSE

								-------------------------------------------- ◇◇◇◇◇
								--- UPDATE 대상건이 존재하지 않는경우 INSERT 처리
								-------------------------------------------- ◇◇◇◇◇
								BEGIN
										INSERT INTO DM_PLN_MKT_FCST
											  (DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
											  ,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
											  ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
											  )
										SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
											  ,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,'EDI_VISIBILITY',GETDATE(),'EDI_VISIBILITY',GETDATE()
												,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
										FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R WITH(NOLOCK)
											WHERE  PROC_FLAG = 'P'
											  AND IF_SEQ	= @v_ifseqno
											  AND DML_FLAG	= @v_DML_FLAG
								END

							-- 작업 COUNT 증가
							SET @v_U_COUNT = @v_U_COUNT + 1
						END

					--------------------------------------------------------------------------- ◇◇◇◇◇
					---DELETE 인경우
					--------------------------------------------------------------------------- ◇◇◇◇◇
					IF  @v_DML_FLAG = 'D'
						BEGIN
							-- 삭제전 기존정보 history insert
							INSERT INTO dbo.DM_PLN_MKT_FCST_H
							( DIVISION_ID,HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
							,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
							,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							)
							SELECT 
								DIVISION_ID,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H AS HISTORY_SEQ,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS
							,MEASURE,PLANT_SITE_ID,YYYYMMDD,QTY,CREATED_BY,CREATION_DATE,'EDI_VISIBILITY' AS LAST_UPDATED_BY,GETDATE() AS LAST_UPDATE_DATE
							,'ifseqno : '+@v_ifseqno AS ATTRIBUTE1,'DML_FLAG : '+@v_DML_FLAG AS ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							FROM DM_PLN_MKT_FCST WITH(NOLOCK)
								WHERE 1=1
									AND DIVISION_ID    =  @v_DIVISION_ID  
									AND PROJECT_CODE   =  @v_PROJECT_CODE 
									AND SCM_SITE_ID	   =  @v_SCM_SITE_ID	 
									AND ITEM_ID		   =  @v_ITEM_ID		 
									AND DOM_EXP		   =  @v_DOM_EXP		 
									AND MEASURE		   =  @v_MEASURE		 
									AND PLANT_SITE_ID  =  @v_PLANT_SITE_ID
									AND FCST_TYPE	   =  @v_DM_FCST_TYPE	 -- DM의 변경전값과 일치하는 데이터
									AND INCOTERMS	   =  @v_DM_INCOTERMS	 -- DM의 변경전값과 일치하는 데이터
									AND YYYYMMDD	   =  @v_DM_YYYYMMDD	 -- DM의 변경전값과 일치하는 데이터
									AND EXISTS (SELECT DIVISION_ID FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R A WITH(NOLOCK)
												WHERE  A.PROC_FLAG = 'P'
													AND A.IF_SEQ		= @v_ifseqno
													AND A.DML_FLAG		= @v_DML_FLAG
												)
							-- 삭제처리
							DELETE FROM DM_PLN_MKT_FCST
								WHERE 1=1
									AND DIVISION_ID    =  @v_DIVISION_ID  
									AND PROJECT_CODE   =  @v_PROJECT_CODE 
									AND SCM_SITE_ID	   =  @v_SCM_SITE_ID	 
									AND ITEM_ID		   =  @v_ITEM_ID		 
									AND DOM_EXP		   =  @v_DOM_EXP		 
									AND MEASURE		   =  @v_MEASURE		 
									AND PLANT_SITE_ID  =  @v_PLANT_SITE_ID
									AND FCST_TYPE	   =  @v_DM_FCST_TYPE	 -- DM의 변경전값과 일치하는 데이터
									AND INCOTERMS	   =  @v_DM_INCOTERMS	 -- DM의 변경전값과 일치하는 데이터
									AND YYYYMMDD	   =  @v_DM_YYYYMMDD	 -- DM의 변경전값과 일치하는 데이터
									AND EXISTS (SELECT DIVISION_ID FROM LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R A WITH(NOLOCK)
												WHERE  A.PROC_FLAG = 'P'
													AND A.IF_SEQ		= @v_ifseqno
													AND A.DML_FLAG		= @v_DML_FLAG
												)
							-- 작업 COUNT 증가
							SET @v_D_COUNT = @v_D_COUNT + 1
						END


				FETCH NEXT FROM CUR_ADJUSTED_MKT_FCST 
				INTO @v_ifseqno,@v_DML_FLAG,@v_DM_FCST_TYPE,@v_DM_INCOTERMS,@v_DM_YYYYMMDD
					,@v_DIVISION_ID,@v_PROJECT_CODE,@v_SCM_SITE_ID,@v_ITEM_ID,@v_DOM_EXP,@v_FCST_TYPE
				    ,@v_INCOTERMS,@v_MEASURE,@v_PLANT_SITE_ID,@v_YYYYMMDD,@v_QTY          
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				END
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				CLOSE CUR_ADJUSTED_MKT_FCST;
				DEALLOCATE CUR_ADJUSTED_MKT_FCST; 
		
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				--- 처리완료건 UPDATE
				------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
				UPDATE LGCE_INF.DBO.XIF_PLM_ADJUSTED_MKT_FCST_R 
					SET  PROC_FLAG = 'Y'
						,PROC_DATE = GETDATE()
						,PROC_MSG = 'Success'
					WHERE PROC_FLAG = 'P'
					  AND DML_FLAG IN ('I','U','D')
				
				SET @v_RESULT_COUNT = @v_I_COUNT + @v_U_COUNT + @v_D_COUNT
		END
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
		--                                                                             IF TABLE의 정보가 존재하는경우 수행 (END)
		------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

		COMMIT WORK;

    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇
    END TRY
    ------------------------------------------------------------------------------------------------------------------- ◇◇◇◇◇

    BEGIN CATCH
		ROLLBACK TRAN
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description =        'INSERT : ' + CAST(@v_I_COUNT AS nvarchar(10)) 
					   +' / ' + 'UPDATE : ' + CAST(@v_U_COUNT AS nvarchar(10))
					   +' / ' + 'DELETE : ' + CAST(@v_D_COUNT AS nvarchar(10))
					   +' / ' + 'TOT : ' + CAST(@v_RESULT_COUNT AS nvarchar(10));
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
