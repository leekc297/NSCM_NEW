
/*
 * Program ID   : DMF0009_SAVE_METAL_CURRENCY_PRICE_POPUP
 * Description  : DMF009_MetalCurrencyPricePopUp(Metal & Currency)의 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/28	ilovu1			Initial Release 사업계획 프로젝트
 */
create procedure [dbo].[DMF0009_SAVE_METAL_CURRENCY_PRICE_POPUP]
	  @p_SAVE_FLAG						nvarchar(max) --저장구분(I:Insert, M: Modify)
	, @p_DIVISION_ID                    nvarchar(max) --사업부ID
	, @p_METAL_CURRENCY_GBN             nvarchar(max) --메탈통화구분(1 통화, 2 메탈)
	, @p_STND_YM                        nvarchar(max) --기준연월
	, @p_METAL_CURRENCY                 nvarchar(max) --메탈통화항목	
	, @p_STND_MARKET                    nvarchar(max) --기준시장
	, @p_STND_PRICE                     nvarchar(max) --기준가격
	, @p_CREATED_BY						nvarchar(max) --생성자
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;	

	---------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	---------------------------------------------------------------------------------------------------------
    declare @v_program_name		nvarchar(150) = 'DMF0009_SAVE_METAL_CURRENCY_PRICE_POPUP';
    declare @v_log_type			nvarchar(30); -- START/END/ERROR/...
    declare @n_log_count		integer = 0;
    declare @v_log_message		nvarchar(1000);
    declare @v_description		nvarchar(500);
    declare @v_event_date		datetime;
	---------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------
	-- 시작 LOG
	---------------------------------------------------------------------------------------------------------
	set @v_log_type		= 'START';
	set @n_log_count	= 0;
	set @v_log_message	= '########## Start of procedure ##########';
	set @v_description	= '';
	set @v_event_date	= sysdatetime();
	exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;
	---------------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------------
	-- 파라미터 값을 파싱하여 임시테이블에 저장
	---------------------------------------------------------------------------------------------------------
	declare @v_delimiter nvarchar(1) = '^';		--파람미터 값 구분자
	select nr as SEQ, token into #SAVE_FLAG						   from dbo.String_Split(@p_SAVE_FLAG					   , @v_delimiter);--저장구분(I:Insert, M: Modify, D: Delete)
    select nr as SEQ, token into #DIVISION_ID                      from dbo.String_Split(@p_DIVISION_ID                    , @v_delimiter);--사업부ID
    select nr as SEQ, token into #METAL_CURRENCY_GBN               from dbo.String_Split(@p_METAL_CURRENCY_GBN             , @v_delimiter);--메탈통화구분(1 통화, 2 메탈)
    select nr as SEQ, token into #STND_YM						   from dbo.String_Split(@p_STND_YM						   , @v_delimiter);--기준연월
    select nr as SEQ, token into #METAL_CURRENCY                   from dbo.String_Split(@p_METAL_CURRENCY                 , @v_delimiter);--메탈통화항목
    select nr as SEQ, token into #STND_MARKET                      from dbo.String_Split(@p_STND_MARKET                    , @v_delimiter);--기준시장
    select nr as SEQ, token into #STND_PRICE					   from dbo.String_Split(@p_STND_PRICE                     , @v_delimiter);--기준가격
	---------------------------------------------------------------------------------------------------------

	begin try
        select SAVE_FLAG.SEQ                            						 --순번
             , case when  SAVE_FLAG.token          <> '' then SAVE_FLAG.token          else null end as SAVE_FLAG               --저장구분(I:Insert, M: Modify, D: Delete)
             , case when  DIVISION_ID.token        <> '' then DIVISION_ID.token        else null end as DIVISION_ID             --사업부ID
             , case when  METAL_CURRENCY_GBN.token <> '' then METAL_CURRENCY_GBN.token else null end as METAL_CURRENCY_GBN      --메탈통화구분(1 통화, 2 메탈)
             , case when  STND_YM.token            <> '' then STND_YM.token            else null end as STND_YM                 --SCM사이트ID                      
             , case when  METAL_CURRENCY.token     <> '' then METAL_CURRENCY.token     else null end as METAL_CURRENCY          --품목ID                          
             , case when  STND_MARKET.token        <> '' then STND_MARKET.token        else null end as STND_MARKET             --기준단가                          
             , case when  STND_PRICE.token         <> '' then STND_PRICE.token         else null end as STND_PRICE              --메탈링크여부  
          into #SOURCE
          from            #SAVE_FLAG                          SAVE_FLAG                                                         --저장구분(I:Insert, M: Modify)
               inner join #DIVISION_ID                        DIVISION_ID        on SAVE_FLAG.SEQ = DIVISION_ID.SEQ             --사업부ID                       
               inner join #METAL_CURRENCY_GBN                 METAL_CURRENCY_GBN on SAVE_FLAG.SEQ = METAL_CURRENCY_GBN.SEQ      --메탈통화구분(1 통화, 2 메탈)
               inner join #STND_YM                            STND_YM            on SAVE_FLAG.SEQ = STND_YM.SEQ                 --기준연월
               inner join #METAL_CURRENCY                     METAL_CURRENCY     on SAVE_FLAG.SEQ = METAL_CURRENCY.SEQ          --메탈통화항목			   
               inner join #STND_MARKET                        STND_MARKET        on SAVE_FLAG.SEQ = STND_MARKET.SEQ             --기준시장                                              
               inner join #STND_PRICE                         STND_PRICE         on SAVE_FLAG.SEQ = STND_PRICE.SEQ              --기준가격
			   ;

		---------------------------------------------------------------------------------------------------------
		-- 데이터 유효성 체크
		---------------------------------------------------------------------------------------------------------
		--구분자에 의해 파싱한 파라미터 값의 개수 일치 여부 확인
		if exists (select 1 from #SAVE_FLAG a left join #SOURCE b on a.SEQ = b.SEQ where b.SEQ is null)
		begin 
			set @v_log_type = 'INVALID';
			select N'UI 프로그램 오류입니다. 파라미터의 값의 수가 일치하지 않습니다.';
			set @v_description = N'UI 화면 개발자에게 문의하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(DIVISION_ID)
		if exists (select 1 from #DIVISION_ID where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Div 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Div)을 확인하세요.';
			goto err_rtn;
		end
			
		--not null 제약 확인(METAL_CURRENCY_GBN)
		if exists (select 1 from #METAL_CURRENCY_GBN where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') not in ('1', '2'))
		begin 
			set @v_log_type = 'INVALID';
			select N'UI 프로그램 오류입니다. 입력값 오류입니다.';
			set @v_description = N'UI 화면 개발자에게 문의하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(STND_YM)
		if exists (select 1 from #STND_YM where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'기준연월 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(기준연월)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(METAL_CURRENCY)
		if exists (select 1 from #METAL_CURRENCY where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M', 'D')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Name 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Name)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(STND_MARKET)
		if exists (select 1 from #STND_MARKET where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'Standard 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(Standard)을 확인하세요.';
			goto err_rtn;
		end

		--not null 제약 확인(STND_PRICE)
		if exists (select 1 from #STND_PRICE where SEQ in (select SEQ from #SOURCE where SAVE_FLAG in ('I', 'M')) and isnull(token, '') = '')
		begin 
			set @v_log_type = 'INVALID';
			select N'금액 입력값을 확인하세요.';
			set @v_description = N'필수 입력값(금액)을 확인하세요.';
			goto err_rtn;
		end
		---------------------------------------------------------------------------------------------------------

		begin tran;
		merge 
		 into dbo.DM_MST_METAL_CURRENCY_PRICE t
		using #SOURCE s
		   on (	   t.DIVISION_ID		= s.DIVISION_ID				--사업부ID
		       and t.METAL_CURRENCY_GBN = s.METAL_CURRENCY_GBN		--메탈통화구분(1 통화, 2 메탈)
			   and t.STND_YM			= s.STND_YM					--기준연월
			   and t.METAL_CURRENCY		= s.METAL_CURRENCY			--메탈통화항목
			   and t.STND_MARKET		= s.STND_MARKET				--기준시장
		      )
		 when matched and SAVE_FLAG = 'D' then
			  delete
         when matched and SAVE_FLAG in ('I', 'M') then
		      update
			      set 
                      t.STND_PRICE                   = s.STND_PRICE    --기준가격             
					, t.LAST_UPDATED_BY				 = @p_CREATED_BY   --최종수정자
					, t.LAST_UPDATE_DATE			 = getdate()	   --최종수정일자
         when not matched by target and SAVE_FLAG in ('I', 'M') then
			  insert ( DIVISION_ID						--사업부ID      
	                 , METAL_CURRENCY_GBN               --메탈통화구분(1 통화, 2 메탈)
	                 , STND_YM                          --기준연월
	                 , METAL_CURRENCY                   --메탈통화항목	
	                 , STND_MARKET                      --기준시장
	                 , STND_PRICE                       --기준가격
					 , CREATED_BY						--생성자 
					 , CREATION_DATE					--생성일자
					 , LAST_UPDATED_BY					--최종수정자
					 , LAST_UPDATE_DATE					--최종수정일자
			         )
              values (s.DIVISION_ID						--사업부ID       
			  		, s.METAL_CURRENCY_GBN              --메탈통화구분(1 통화, 2 메탈)
			  		, s.STND_YM                         --기준연월
			  		, s.METAL_CURRENCY                  --메탈통화항목	
			  		, s.STND_MARKET                     --기준시장
			  		, s.STND_PRICE                      --기준가격               
					 , @p_CREATED_BY					--생성자 
					 , getdate()						--생성일자
					 , @p_CREATED_BY					--최종수정자
					 , getdate()						--최종수정일자			  
			         );
		commit tran;
	end try

	begin catch
		if @@trancount > 0
			rollback tran;

		---------------------------------------------------------------------------------------------------------
		-- ERROR LOG
		---------------------------------------------------------------------------------------------------------
		set @v_log_type		= 'ERROR';
		set @n_log_count	= @n_log_count + 1;
		set @v_log_message	= cast(error_message() AS nvarchar(1000));
		set @v_description	= 'ERROR_LINE : ' + str(error_line());
		set @v_event_date	= sysdatetime();
		exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;

		select '[' + convert(nvarchar(10), error_number()) + ']' + error_message();
	end catch

	---------------------------------------------------------------------------------------------------------
	-- 종료 LOG
	---------------------------------------------------------------------------------------------------------
	set @v_log_type		= 'END';
	set @n_log_count	= @n_log_count + 1;
	set @v_log_message	= '########## END of procedure ##########';;
	set @v_description	= '';
	set @v_event_date	= sysdatetime();
	exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;
end;

err_rtn:
	if @v_log_type = 'INVALID'
		begin		
			if @@trancount > 0
				rollback tran;

			set @n_log_count	= @n_log_count + 1;
			set @v_log_message	= '########## END of procedure ##########';
			set @v_event_date	= sysdatetime();
			exec PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @v_event_date;

			select @v_description;
		end	
