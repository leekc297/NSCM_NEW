/*    
 * Program ID   : PR_SCP_ANL_PLN_TABLE_DELETE_KSG
 * Description  : 
 * OutTable     :   
 * Program History
 *===================================================================================================    
 *   Date       In Charge      Description    
 *===================================================================================================    
 * 2024.10.14   KSG           Rule 변경 전 Data 삭제용
 *  HIST_SCP_ANL_SHIPMENT_PLAN_FG / HIST_SCP_ANL_SHIPMENT_PLAN_SEMI
    SCP_ANL_PSI_GLOBAL / SCP_ANL_PSI_ELECTRODE / SCP_ANL_PSI_GLOBAL_SMALL / SCP_ANL_PSI_GLOBAL_ESS
=> FN 만 남기고 모두 삭제
 * 
 */
     

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PLN_TABLE_DELETE_KSG]
(
  @p_delete_type NVARCHAR(1)=NULL
 )
AS 
BEGIN

	DECLARE @v_del_flag             NVARCHAR(10) = 'TRUE';
	
	-- LOG 용 변수 설정
	DECLARE @v_batch_user          NVARCHAR(150) = N'scp_batch';
	DECLARE @v_program_name        NVARCHAR(150) = N'PR_SCP_ANL_PLN_TABLE_DELETE_KSG' + '_' + @p_delete_type;
	DECLARE @v_log_type            NVARCHAR(30); -- START/END/ERROR/...	
	DECLARE @n_log_count           INTEGER = 0;
	DECLARE @v_log_message         NVARCHAR(1000);
	DECLARE @v_description         NVARCHAR(500);
	DECLARE @d_event_date          DATETIME;

	-- Dynamic Query 용 변수 설정
	DECLARE @v_deleteSql           NVARCHAR(MAX); -- 삭제 SQL
	DECLARE @v_whereSql            NVARCHAR(MAX); -- 삭제 조건 SQL
	DECLARE @v_sql                 NVARCHAR(MAX); -- 삭제 SQL
	DECLARE @v_rowcount            INT;           -- 삭제 건수
	DECLARE @v_totcount            INT;           -- 테이블 목록 LOOP 실행 시 총 건수(LOOP 실행 여부 판단)

	-- DELETE 대상 Table
	DECLARE @v_table_list          NVARCHAR(1000);
	DECLARE @v_table_name          NVARCHAR(200);

	-- DELETE 대상 처리 Index
	DECLARE @v_index_list          NVARCHAR(1000);
	DECLARE @v_index_name          NVARCHAR(200);
	
	-- 삭제를 날짜 정보 변수 설정
	DECLARE @v_std_day  NVARCHAR(10) = ''; -- 기준 요일
	DECLARE @v_std_time NVARCHAR(10) = ''; -- 기준 시간
	DECLARE @v_cur_time NVARCHAR(10) = ''; -- 현재 시간

	-- 삭제 건수 변수 설정
	DECLARE @v_del_cnt INT = 0;

	-- 삭제 대상 Plan Type
	DECLARE @v_del_plan_type_ALL   NVARCHAR(100) = ''; -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정 : 전체 삭제
	DECLARE @v_del_plan_type_FN    NVARCHAR(100) = ''; -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정 : FN 외 삭제
	DECLARE @v_del_plan_type_FNMA  NVARCHAR(100) = ''; -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정 : FN/MA외 삭제
	DECLARE @v_del_plan_type       NVARCHAR(100) = ''; -- 아래에서 항목별 기간 재설정함

    -----------------------------------------------------------
	-- Delete 기준 일자 정보 셋팅
    -- 운영 : '1'   개발 : '2'
    -----------------------------------------------------------
    DECLARE @X_DB_NAME       NVARCHAR(100);
	-- 20210128 C20210126-000135 항목별 삭제 기간 지정
	DECLARE @v_del_yyyymmdd_6M  NVARCHAR(10) = '';  -- 6개월(26주) 기준
	DECLARE @v_del_yyyymmdd_1M  NVARCHAR(10) = '';  -- 1개월(6주) 기준

	DECLARE @v_del_yyyymmdd_start  NVARCHAR(10) = '';  -- Delete Start 기준 일자
	DECLARE @v_del_yyyymmdd  NVARCHAR(10) = '';  -- Delete 기준 일자

    SELECT @X_DB_NAME = DB_NAME();
	
	----------------------------------------------------------------------------
	-- 운영 : 26주 전 월요일 일자(6개월 이전)
	-- 20210128 C20210126-000135 항목별 삭제 기간 지정
	----------------------------------------------------------------------------
    SET @v_del_yyyymmdd_6M = CONVERT(CHAR(8), DATEADD(DD, -7*27, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 26주 전 월요일 일자(약 6개월)
    SET @v_del_yyyymmdd_1M = CONVERT(CHAR(8), DATEADD(DD, -7*7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 6주 전 월요일 일자(약 1개월)	
    SET @v_del_yyyymmdd    = @v_del_yyyymmdd_6M -- 기본 6개월(아래에서 항목별 기간 재설정함)
	
	-- 개발 :  8주 전 월요일 일자
    IF @X_DB_NAME = 'LGCE_SCMDEV'  
	BEGIN
        SET @v_del_yyyymmdd_6M = CONVERT(CHAR(8), DATEADD(DD, -7*9, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 8주 전 월요일 일자
        SET @v_del_yyyymmdd_1M = CONVERT(CHAR(8), DATEADD(DD, -7*9, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 8주 전 월요일 일자
		SET @v_del_yyyymmdd    = CONVERT(CHAR(8), DATEADD(DD, -7*9, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 8주 전 월요일 일자
	END

    -----------------------------------------------------------
	-- 요일별 삭제 중단 시간 정보 셋팅
    -----------------------------------------------------------
	-- 기준 요일 정보 셋팅
	SELECT @v_std_day = CONVERT(NVARCHAR, DATEPART(DW, GETDATE()));

	-- 기준 시간 정보 셋팅 : 23시 종료로 처리
    SET @v_std_time = '230000';


	-- 현재 시간 정보 셋팅
	SELECT @v_cur_time = REPLACE(CONVERT(VARCHAR(8),GETDATE(),108),':','');

	----------------------------------------------------------------------------
	-- 삭제 대상 Plan Type
	----------------------------------------------------------------------------
	-- 20210128 C20210126-000135 삭제 대상 Plan Type 지정 : 전체 삭제
    SELECT @v_del_plan_type_ALL = (SELECT ',''' + segment1 + ''' ' 
                                   FROM   scm_adm_lookup_master_detail A WITH(NOLOCK)
                                   WHERE  lookup_type = 'PLAN_TYPE'
                                   FOR XML PATH('')
                                  );

    -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정 : FN 외 삭제
    SELECT @v_del_plan_type_FN = (SELECT ',''' + segment1 + ''' ' 
                                  FROM   scm_adm_lookup_master_detail A WITH(NOLOCK)
                                  WHERE  lookup_type = 'PLAN_TYPE'
                                  AND    segment1   <> 'FN'
                                  FOR XML PATH('')
                                 );

    -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정 : FN/MA외 삭제
    SELECT @v_del_plan_type_FNMA = (SELECT ',''' + segment1 + ''' ' 
                                    FROM   scm_adm_lookup_master_detail A WITH(NOLOCK)
                                    WHERE  lookup_type = 'PLAN_TYPE'
                                    AND    segment1    NOT IN ('FN', 'MA')
                                    FOR XML PATH('')
                                   );

	SET @v_del_plan_type = SUBSTRING(@v_del_plan_type_FN, 2, 100) -- 기본 FN 외 삭제(아래에서 항목별 기간 재설정함)

	-- 시작 LOG      
	SET @v_log_type    = N'START';      
	SET @v_log_message = N'########## Start of procedure ##########';      
	SET @v_description = @v_program_name + '::' + @v_cur_time +  '::' + @v_std_time +  '::' + @v_del_flag + '::' + @v_del_yyyymmdd;;      
	SET @d_event_date  = SYSDATETIME();      
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	BEGIN TRY
		BEGIN
		IF ( @v_cur_time < @v_std_time AND @v_del_flag = 'TRUE')
			BEGIN
				PRINT N'현재시간' + @v_cur_time + N'삭제를 진행 합니다';

				WHILE (@v_del_flag = 'TRUE')
				BEGIN
					SET @v_totcount = 0; -- 테이블 목록 LOOP 실행 시 총 건수(LOOP 실행 여부 판단)
							
	                -----------------------------------------------------------------
	                -- @v_deleteSql 설정 시 Index 태울 버전만 IF 문으로 사용하게 함
	                -- Table과 Index 는 한 쌍으로 순서도 같게 구성해야 하며, 동일 Type에 속한 전체 Table의 Index 가 전부 있을 경우만 설정해야 함
	                -- 운영 Index 생성 후 조정할 것
	                -----------------------------------------------------------------	

------------------------------------------------------------------
 ----- 임시 삭제 기간 조정하여 처리
                        SET @v_del_yyyymmdd_start = '20180104' -- CONVERT(CHAR(8), DATEADD(DD, -7*4, CONVERT(DATETIME, @v_del_yyyymmdd)), 112) 
                        SET @v_del_yyyymmdd       = '20180801'--@v_del_yyyymmdd_6M -- 20240501 보다 작은 주로만 설정할 것
------------------------------------------------------------------


					IF @p_delete_type = '5'
						BEGIN
						SET @v_table_list    = 'HIST_SCP_ANL_SHIPMENT_PLAN_SEMI,HIST_SCP_ANL_SHIPMENT_PLAN_FG';
						SET @v_index_list    = 'IX04_SCP_ANL_SHIPMENT_PLAN_SEMI,PK_HIST_SCP_ANL_SHIPMENT_PLAN_FG'; -- 실행 할 SQL에서 Index 지정 -- 20211104  PJ20214907 사용 Index 조정
                        --SET @v_del_yyyymmdd  = @v_del_yyyymmdd_6M -- 20210128 C20210126-000135 항목별 삭제 기간 지정
                        --SET @v_del_yyyymmdd_start = '20110101' -- CONVERT(CHAR(8), DATEADD(DD, -7*4, CONVERT(DATETIME, @v_del_yyyymmdd)), 112) 
                        SET @v_del_plan_type = SUBSTRING(@v_del_plan_type_FN, 2, 100) -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정
						END
					ELSE IF @p_delete_type = '6'
						BEGIN
						SET @v_table_list    = 'SCP_ANL_PSI_GLOBAL,HIST_SCP_ANL_PRODUCTION_PLAN';
						SET @v_index_list    = 'PK_SCP_ANL_PSI_GLOBAL,IX05_SCP_ANL_PRODUCTION_PLAN'; -- 실행 할 SQL에서 Index 지정 -- 20211104  PJ20214907 사용 Index 조정
                        --SET @v_del_yyyymmdd  = @v_del_yyyymmdd_6M -- 20210128 C20210126-000135 항목별 삭제 기간 지정
                        --SET @v_del_yyyymmdd_start = '20110101' -- CONVERT(CHAR(8), DATEADD(DD, -7*4, CONVERT(DATETIME, @v_del_yyyymmdd)), 112) 
                        SET @v_del_plan_type = SUBSTRING(@v_del_plan_type_FN, 2, 100) -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정
						END
					ELSE IF @p_delete_type = 'A'
						BEGIN
						SET @v_table_list    = 'SCP_ANL_PSI_GLOBAL_SMALL,SCP_ANL_PSI_ELECTRODE,SCP_ANL_PSI_GLOBAL_ESS';
						SET @v_index_list    = 'PK_SCP_ANL_PSI_GLOBAL_SMALL,IX02_SCP_ANL_PSI_ELECTRODE,IX01_SCP_ANL_PSI_GLOBAL_ESS'; --  실행 할 SQL에서 Index 지정 -- 20211104  PJ20214907 사용 Index 조정
                        --SET @v_del_yyyymmdd  = @v_del_yyyymmdd_6M -- 20210128 C20210126-000135 항목별 삭제 기간 지정
                        --SET @v_del_yyyymmdd_start = '20110101' -- CONVERT(CHAR(8), DATEADD(DD, -7*4, CONVERT(DATETIME, @v_del_yyyymmdd)), 112) 
                        SET @v_del_plan_type = SUBSTRING(@v_del_plan_type_FN, 2, 100) -- 20210128 C20210126-000135 삭제 대상 Plan Type 지정
						END
					ELSE IF @p_delete_type = 'B'
						BEGIN
						SET @v_table_list    = 'SCP_ANL_PROBLEM_REPORT_PEGGING,SCP_ANL_PROBLEM_REPORT_DESC,SCP_ANL_PROBLEM_REPORT_DEMAND';
						SET @v_index_list    = 'IX01_SCP_ANL_PROBLEM_REPORT_PEGGING,IX01_SCP_ANL_PROBLEM_REPORT_DESC,IX01_SCP_ANL_PROBLEM_REPORT_DEMAND'; -- 실행 할 SQL에서 Index 지정
                        --SET @v_del_yyyymmdd  = @v_del_yyyymmdd_6M -- 20210128 C20210126-000135 항목별 삭제 기간 지정
                        --SET @v_del_yyyymmdd_start = '20110101' -- CONVERT(CHAR(8), DATEADD(DD, -7*4, CONVERT(DATETIME, @v_del_yyyymmdd)), 112) 
                        SET @v_del_plan_type = 'ALL'
						END

					-- 테이블 리스트에 SPLIT 문자열(',') 추가
					SET @v_table_list = LTRIM(RTRIM(@v_table_list)) + ',';
					SET @v_index_list = LTRIM(RTRIM(@v_index_list)) + ',';

					-- TRANSACTION 시작
					BEGIN TRAN

					-- 테이블 목록 수 만큼 LOOP 실행
					WHILE CHARINDEX(',',@v_table_list) <> 0
					BEGIN
						SET @v_table_name = SUBSTRING(@v_table_list, 1, CHARINDEX(',',@v_table_list)-1);
						SET @v_index_name = SUBSTRING(@v_index_list, 1, CHARINDEX(',',@v_index_list)-1);

						----------------------------------------------------------------
						-- 실행 할 SQL 문장 셋팅
						----------------------------------------------------------------	
                        -- 한 번에 Delete할 Row 수		
                        IF @v_index_name <> 'X' -- Index 지정하는 경우
                            SET @v_deleteSql = 'DELETE /* PR_SCP_ANL_PLN_TABLE_DELETE_KSG */ TOP(50000) a FROM ' + @v_table_name 
                                                + ' a WITH(ROWLOCK, INDEX(' + @v_index_name +')) ';

                        ELSE -- Index 지정 안 하는 경우
                            SET @v_deleteSql = 'DELETE /* PR_SCP_ANL_PLN_TABLE_DELETE_KSG */ TOP(50000) a FROM ' + @v_table_name + ' a WITH(ROWLOCK) ';

						----------------------------------------------------------------
						-- 일반 GROUP : plan_start_yyyymmdd/plan_type 기준 삭제(FN 제외)
						----------------------------------------------------------------
                        IF @v_del_plan_type = 'ALL'
                           SET @v_whereSql  = ' WHERE division_id = division_id' +
                                              '   AND plan_start_yyyymmdd >= ''' + @v_del_yyyymmdd_start + ''' ' +
                                              '   AND plan_start_yyyymmdd <  ''' + @v_del_yyyymmdd + ''' ' +
                                              '   AND ''' + @v_cur_time + ''' = ''' + @v_cur_time + ''' ' ;
						ELSE 
                           SET @v_whereSql  = ' WHERE division_id = division_id' +
                                              '   AND plan_start_yyyymmdd >= ''' + @v_del_yyyymmdd_start + ''' ' +
                                              '   AND plan_start_yyyymmdd <  ''' + @v_del_yyyymmdd + ''' ' +
                                              '   AND plan_type           IN ( ' + @v_del_plan_type + ' ) ' +
                                              '   AND ''' + @v_cur_time + ''' = ''' + @v_cur_time + ''' ' ;

						----------------------------------------------------------------
						-- GROUP C : cutoff_date 기준으로 삭제한다
						----------------------------------------------------------------
						IF @p_delete_type = 'C'
                           SET @v_whereSql  = ' WHERE division_id = division_id' +
                                              '   AND cutoff_date >= CONVERT(DATETIME, ''' + @v_del_yyyymmdd_start + ''') ' +
                                              '   AND cutoff_date <  CONVERT(DATETIME, ''' + @v_del_yyyymmdd + ''') ' +
                                              '   AND ''' + @v_cur_time + ''' = ''' + @v_cur_time + ''' ' ;

						SET @v_sql = @v_deleteSql + @v_whereSql;

						-- 테이블을 삭제 처리 한다.
						PRINT @v_sql;
						EXEC (@v_sql);

						-- 삭제 건수 저장
						SET @v_rowcount = @@ROWCOUNT;                  -- 실행 카운트
						SET @v_totcount = @v_totcount + @v_rowcount;   -- 테이블 목록 LOOP 실행 시 총 건수(LOOP 실행 여부 판단)
						SET @n_log_count = @n_log_count + @v_rowcount; -- 총 삭제 건수(로그 저장)

						PRINT @n_log_count;

						-- 현재 시간 정보 셋팅
						SET @v_cur_time =  REPLACE(CONVERT(VARCHAR(8),GETDATE(),108),':','');

						-- 현재 시간이 기준 시간을 초과 하면 flag 값 변경 삭제 중지
						IF @v_cur_time >= @v_std_time
							BEGIN
								SET @v_del_flag = 'FALSE';
								BREAK;
							END

						-- 삭제 한 테이블을 제거하고 새롭게 리스트 저장
						SET @v_table_list = SUBSTRING(@v_table_list, CHARINDEX(',',@v_table_list) + 1,LEN(@v_table_list));
						SET @v_index_list = SUBSTRING(@v_index_list, CHARINDEX(',',@v_index_list) + 1,LEN(@v_index_list));

					END -- WHILE CHARINDEX(',',@v_table_list) <> 0

					-- TRANSACTION 완료
					COMMIT TRAN
								
					-- 각 @p_delete_type 마다 한 번만 실행되도록 Flag 설정함
					-- SQL Agent Job : 일정에서 반복 수행하도록 설정
					--   => 이전 작업이 안 긑난 경우 다음 작업 실행 안 됨, 작업 종료 후 다음 시점에 새 작업 실행됨
					SET @v_del_flag = 'FALSE';

					-- 삭제 총 건수가 0 이면 LOOP 를 중지
					IF @v_totcount = 0
						BEGIN
							SET @v_del_flag = 'FALSE';
							BREAK;
						END

				END -- WHILE (@v_del_flag = 'TRUE')

			END -- IF ( @v_cur_time < @v_std_time AND @v_del_flag = 'TRUE')

			ELSE
				BEGIN
					PRINT N'현재시간 : ' + @v_cur_time + N' 삭제를 진행 할 수 없습니다';
				END
		END
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK;
		END;
	-- ERROR LOG
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = @v_cur_time +  '::' + @v_std_time +  '::' + @v_del_flag + '::' + @v_del_yyyymmdd +  '::' + @v_deleteSql +  '::' + @v_whereSql; --'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	END CATCH;

	-- 종료 LOG
	SET @v_log_type    = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = @v_cur_time +  '::' + @v_std_time +  '::' + @v_del_flag + '::' + @v_del_yyyymmdd;
	SET @d_event_date  = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END
