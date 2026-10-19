
/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_ANL_SYS_LOG_BATCH_ERROR_CHECK                        
 * Description  : 1. 해당 일자동안 START되었으나 END, ERROR, INVALID 로 종료되지 않은 작업 조회
                  2. 해당 일자동안 ERROR 난 작업 조회                
 * OutTable     : None                     
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2025.05.31                  Initial 
 *
 *******************************************************************************************************************/                    

-- exec PR_SCP_ANL_SYS_LOG_BATCH_ERROR_CHECK  '20250530', '20250531'

CREATE PROCEDURE [dbo].[PR_SCP_ANL_SYS_LOG_BATCH_ERROR_CHECK]
(                         
      @P_From_Date    NVARCHAR(8)            
    , @P_To_Date	  NVARCHAR(8)            
)                         
AS                        

BEGIN 


	/***************************************************************************************************************************

	 Description : 1. 해당 일자동안 START되었으나 END, ERROR, INVALID 로 종료되지 않은 작업 조회
				   2. 해당 일자동안 ERROR 난 작업 조회

	****************************************************************************************************************************/

    IF OBJECT_ID('tempdb..#tmp_log_batch') IS NOT NULL                        
       DROP TABLE #tmp_log_batch 

	declare @From_Date nvarchar(8)
	declare @To_Date nvarchar(8)
	declare @To_Date_5 nvarchar(17)

	set @From_Date = convert(nvarchar(8),dateadd(d,-1,getdate()),112)  -- From 작업 수행일(From_오류체크대상일자)
	set @To_Date = convert(nvarchar(8),dateadd(d,-0,getdate()),112) -- To 작업 수행일(To_오류체크대상일자)
	set @To_Date_5 = @To_Date + ' 05:00:00'  -- 전일 수행 START 되어 익일 종료된 내역 찾는 범위

	-- 해당일의 수행 데이터 수집
	select *
	into #tmp_log_batch
	FROM scm_sys_log_batch a WITH(NOLOCK)  -- scm_sys_log_batch
	where a.creation_date >= @From_Date   --'2025-05-27 00:00:00'
	and a.creation_date <    @To_Date  --'2025-05-28 00:00:00'
	AND A.LOG_TYPE IN ('START', 'ERROR', 'END','INVALID')
--	and program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
	and a.CREATION_DATE >= ( select min(c.creation_date)  -- 첫번째 start 이후의 작업들이 대상임(즉, 전날 start 되어서 익일 'error'나'end' 된 작업을 제외하기 위함)
							FROM scm_sys_log_batch c with(nolock)
							where c.PROGRAM_NAME = a.PROGRAM_NAME
							and c.creation_date >= @From_Date  --'2025-05-27 00:00:00'
							and c.creation_date <    @To_Date  --'2025-05-28 00:00:00'
							and c.log_type= 'START')
--	AND a.PROGRAM_NAME LIKE 'PR%';

	-- 해당일 내에 START 되어 익일 종료된 데이터를 찾아서 익일 'ERROR'나 'END' 정보만 추가함.
;	INSERT into #tmp_log_batch
	select *
	FROM scm_sys_log_batch a WITH(NOLOCK)  -- scm_sys_log_batch
	where a.creation_date >= @To_Date  --'2025-05-28 00:00:00'
	and a.creation_date <    @To_Date_5  --'2025-05-28 05:00:00'
	AND A.LOG_TYPE IN ( 'ERROR', 'END','INVALID')
--	and program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
	and a.CREATION_DATE <    ISNULL(( select min(c.creation_date)
							FROM scm_sys_log_batch c with(nolock)
							where c.PROGRAM_NAME = a.PROGRAM_NAME
							and c.creation_date >= @To_Date  --'2025-05-28 00:00:00'
							and c.creation_date <    @To_Date_5  --'2025-05-28 05:00:00'
							and c.log_type= 'START'),@To_Date_5)
--	AND a.PROGRAM_NAME LIKE 'PR%'

     -- 해당 기간동안 종료 ('ERROR', 'INVALID', 'END') 되지 않은 작업 조회.
 ;   WITH Not_Ended AS (  	
							select program_name,
									sum(case when log_type = 'START' then 1 end ) start_count,
									sum(case when log_type in ('ERROR','END') and  program_name = 'PR_GSCM_XIF_DM_NSD0001_R' then 4   -- 이 프로그램은 START 정보 4개에 END 정보 1개로 구성되어 있음. 
											 when log_type in ('ERROR') and  program_name = 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL' then 0   -- 이 프로그램은 'END'로그 입력 후 'ERROR' 로그도 같이 입력 하므로 중복되지 않게 'ERROR'를 Count 에서 제외함.
											 when log_type in ('ERROR','END') and  program_name = 'PR_DM_XIF_ERP_NSD0010_R' then 2   -- 이 프로그램은 START 정보 2개에 END 정보 1개로 구성되어 있음. 
											 when log_type in ('INVALID') and  program_name = 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL' and LOG_MESSAGE = '########## END of procedure @@@##########' then 1   -- 이 프로그램은 ERROR 대신 INVALID 로도 종료가 됨.
											 when log_type in ('INVALID') and  program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' and LOG_MESSAGE = '########## END of procedure ##########' then 1   -- 이 프로그램은 ERROR 대신 INVALID 로도 종료가 됨.
											 when log_type in ('ERROR','INVALID') and  program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'  then 0    -- 이 프로그램은 'END'로그 입력 후 'ERROR' 로그도 같이 입력 하므로 중복되지 않게 'ERROR'를 Count 에서 제외함.
											 when log_type in ('ERROR') and  program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_BATCH'then 0    -- 이 프로그램은 'END'로그 입력 후 'ERROR' 로그도 같이 입력 하므로 중복되지 않게 'ERROR'를 Count 에서 제외함.
											 when log_type in ('END') and  program_name = 'PR_SCP_XLS_PSI_GLOBAL_ESS' and description like 'DELETE HISTORY%' then 0    -- 이 프로그램은 END 정보가 중복 생성됨.(description 이 DELETE HISTORY% 인 경우)
											 when log_type in ('END') and  program_name = 'FN_ERP_UI_TransferPosting_NERP_PROD' and LOG_MESSAGE = '########## Failure of FN_ERP_UI_TransferPosting_NERP_PROD Call - Exception Error ##########' then 0    -- 이 프로그램은 END 정보가 중복 생성 됨.(LOG_MESSAGE로 제외시킴)
											 when log_type in ('ERROR') and  program_name = 'SCP0049_CAPA_EXCEL_UPLOAD'then 0    -- 이 프로그램은 'END'로그 입력 후 'ERROR' 로그도 같이 입력 하므로 중복되지 않게 'ERROR'를 Count 에서 제외함.
											 when log_type in ('ERROR') and  program_name = 'SCP0049_SAVE_CAPA'then 0    -- 이 프로그램은 'END'로그 입력 후 'ERROR' 로그도 같이 입력 하므로 중복되지 않게 'ERROR'를 Count 에서 제외함.
											 when log_type in ('ERROR','END') then 1 end)   end_count
							FROM #tmp_log_batch a WITH(NOLOCK)
							where 1=1
							--and a.PROGRAM_NAME LIKE 'PR%'
							group by program_name
                            )

	select *
	from Not_Ended
	where 1=1
	and start_count <   > end_count
	and program_name not in ('PR_SSP_MAIL_SEND_ADJUST_MST')
	order by program_name

-- 해당 기간동안 에러 발생 내역 조회
	select A.*
	FROM scm_sys_log_batch a WITH(NOLOCK)
	where 1=1
	and a.creation_date >= @From_Date   --'2025-05-27 00:00:00'
	and a.creation_date <    @To_Date  --'2025-05-28 00:00:00'
	and a.log_type = 'ERROR'
--	and (a.log_type = 'ERROR' or a.log_type = 'INVALID')   -- ERROR 와 Invalid 같이 볼 경우.
--	AND a.PROGRAM_NAME LIKE 'PR%'   -- PR로 수행되는 프로시저만 볼 경우
	ORDER BY a.PROGRAM_NAME, a.CREATION_DATE


/*  검증 용 start

	select *
	from scm_sys_log_batch with(nolock)
	where 1=1
	and creation_date >= '2025-05-30 00:00:00'
	and creation_date <    '2025-05-31 00:00:00'
	and program_name = 'SCM_ADM_MAIL_SEND_BATCH_MST'
	order by creation_date, log_type

    검증 용 end  */

end