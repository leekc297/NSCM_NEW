
/*
 * Program ID   : DMF0010_SAVE_DM_MST_METAL_PRICE_CUTOFF
 * Description  : DMF0010_BizPlanPrice(메탈 판가 등록 화면)의 Cut-Off
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/08/04	ilovu1			Initial Release 사업계획 프로젝트
 * 2023/09/03   ilovu1          CELL_PROD_SITE 컬럼 추가
 * 2023/09/18   ilovu1          81%로 조건 변경하여 81_UC/81_HM 컷오프 가능하도록 변경
 * 2023/09/25   ilovu1          METAL_LINK_START_MONTH 컬럼 추가
 */
CREATE procedure [dbo].[DMF0010_SAVE_DM_MST_METAL_PRICE_CUTOFF]
	  @p_DIVISION_ID					nvarchar(max) --사업부ID
    , @p_VERSION_DESCRIPTION			nvarchar(max) --설명
	, @p_CUTOFF_TYPE					nvarchar(max) --컷오프유형코드
	, @p_CREATED_BY						nvarchar(max) --생성자
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;	

	---------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	---------------------------------------------------------------------------------------------------------
    declare @v_program_name		nvarchar(150) = 'DMF0010_SAVE_DM_MST_METAL_PRICE_CUTOFF';
    declare @v_log_type			nvarchar(30); -- START/END/ERROR/...
    declare @n_log_count		integer = 0;
    declare @v_log_message		nvarchar(1000);
    declare @v_description		nvarchar(500);
    declare @v_event_date		datetime;
	---------------------------------------------------------------------------------------------------------	

	---------------------------------------------------------------------------------------------------------
	-- Local 변수 설정
	---------------------------------------------------------------------------------------------------------
	declare @v_VER_RETURN_NO	nvarchar(100) = null;
	declare @v_OK_DESCRIPTION	nvarchar(1200)= null;

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
	
	begin try
		EXEC    [dbo].[PR_DM_PLN_VERSION_CREATE]
					  @p_DIVISION_ID
					, @p_VERSION_DESCRIPTION
					, @p_CUTOFF_TYPE
					, @p_CREATED_BY
					, @v_VER_RETURN_NO  OUTPUT
					, @v_OK_DESCRIPTION OUTPUT;
		begin tran;
		--모델별 메탈 판가 컷오프(DM_MST_METAL_PRICE_C)
		insert
		  into dbo.DM_MST_METAL_PRICE_C			--모델별 메탈 판가 컷오프
		     (
			   DIVISION_ID						--사업부ID
			 , VERSION_NO						--버전번호
			 , CUTOFF_TYPE						--컷오프유형코드
			 , CUTOFF_YYYYMMDD					--컷오프일자
			 , PROJECT_CODE						--프로젝트코드
			 , SCM_SITE_ID						--SCM사이트ID
			 , ITEM_ID							--품목ID
			 , CELL_PROD_SITE					--Cell 생산지
			 , MEASURE							--계산기준
			 , STND_YM							--기준연월
			 , PRICE							--단가
			 , CURRENCY							--통화코드
			 , CREATED_BY						--생성자
			 , CREATION_DATE					--생성일자
			 , LAST_UPDATED_BY					--최종수정자
			 , LAST_UPDATE_DATE					--최종수정일자
			 )
		select
			   DIVISION_ID						--사업부ID
			 , @v_VER_RETURN_NO VERSION_NO      --버전번호
			 , @p_CUTOFF_TYPE   CUTOFF_TYPE     --컷오프유형코드
			 , CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) CUTOFF_YYYYMMDD --컷오프일자
			 , PROJECT_CODE						--프로젝트코드
			 , SCM_SITE_ID						--SCM사이트ID
			 , ITEM_ID							--품목ID
			 , CELL_PROD_SITE					--Cell 생산지
			 , MEASURE							--계산기준
			 , STND_YM							--기준연월
			 , PRICE							--단가
			 , CURRENCY							--통화코드
			 , @p_CREATED_BY CREATED_BY			--생성자
			 , GETDATE() CREATION_DATE			--생성일자
			 , @p_CREATED_BY LAST_UPDATED_BY	--최종수정자
			 , GETDATE() LAST_UPDATE_DATE		--최종수정일자
		  from dbo.DM_MST_METAL_PRICE with (nolock)--모델별 메탈 판가
		 where DIVISION_ID = @p_DIVISION_ID;

		--메탈 및 통화 가격  컷오프(DM_MST_METAL_CURRENCY_PRICE_C)
		insert
		  into dbo.DM_MST_METAL_CURRENCY_PRICE_C--메탈 및 통화 가격  컷오프
		     (
			   DIVISION_ID                      --사업부ID
			 , VERSION_NO                       --버전번호
			 , CUTOFF_TYPE                      --컷오프유형코드
			 , CUTOFF_YYYYMMDD                  --컷오프일자
			 , METAL_CURRENCY_GBN               --메탈통화구분(1 통화, 2 메탈)
			 , STND_YM                          --기준연월
			 , METAL_CURRENCY                   --메탈통화항목
			 , STND_MARKET                      --기준시장
			 , STND_PRICE                       --기준가격
			 , CREATED_BY                       --생성자
			 , CREATION_DATE                    --생성일자
			 , LAST_UPDATED_BY                  --최종수정자
			 , LAST_UPDATE_DATE                 --최종수정일자
			 )
		select
			   DIVISION_ID                      --사업부ID
			 , @v_VER_RETURN_NO VERSION_NO      --버전번호
			 , @p_CUTOFF_TYPE   CUTOFF_TYPE     --컷오프유형코드
			 , CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) CUTOFF_YYYYMMDD --컷오프일자
			 , METAL_CURRENCY_GBN               --메탈통화구분(1 통화, 2 메탈)
			 , STND_YM                          --기준연월
			 , METAL_CURRENCY                   --메탈통화항목
			 , STND_MARKET                      --기준시장
			 , STND_PRICE                       --기준가격
			 , @p_CREATED_BY CREATED_BY			--생성자
			 , GETDATE() CREATION_DATE			--생성일자
			 , @p_CREATED_BY LAST_UPDATED_BY	--최종수정자
			 , GETDATE() LAST_UPDATE_DATE		--최종수정일자
		  from dbo.DM_MST_METAL_CURRENCY_PRICE with (nolock)--메탈 및 통화 가격
		 where DIVISION_ID = @p_DIVISION_ID;	
		 
		if @p_DIVISION_ID like '81%' or @p_DIVISION_ID = '40'
		begin
			--메탈 단가 기준 컷오프(DM_MST_METAL_PRICE_RULE_C)
			insert
			  into dbo.DM_MST_METAL_PRICE_RULE_C--메탈 단가 기준 컷오프
				 (
				   DIVISION_ID                           --사업부ID
				 , VERSION_NO                            --버전번호
				 , CUTOFF_TYPE                           --컷오프유형코드
				 , CUTOFF_YYYYMMDD                       --컷오프일자
				 , PROJECT_CODE                          --프로젝트코드
				 , SCM_SITE_ID                           --SCM사이트ID
				 , ITEM_ID                               --품목ID
				 , CELL_PROD_SITE						 --Cell 생산지
				 , BASE_PRICE                            --기준단가
				 , METAL_LINK_YN                         --메탈링크여부
				 , CURRENCY                              --통화코드
				 , METAL_LINK_PERIOD                     --메탈링크범위
				 , METAL_LINK_MTD                        --메탈링크방법
				 , START_YM                              --시작연월
				 , END_YM                                --종료연월
				 , AL_KG_PER_BIZ_TYPE                    --메탈인덱스Al(KG/BizType)
				 , CU_KG_PER_BIZ_TYPE                    --메탈인덱스Cu(KG/BizType)
				 , MN_KG_PER_BIZ_TYPE                    --메탈인덱스Mn(KG/BizType)
				 , NI_KG_PER_BIZ_TYPE                    --메탈인덱스Ni(KG/BizType)
				 , CO_KG_PER_BIZ_TYPE                    --메탈인덱스Co(KG/BizType)
				 , LI2CO3_KG_PER_BIZ_TYPE                --메탈인덱스Li2Co3(KG/BizType)
				 , LIOH_KG_PER_BIZ_TYPE                  --메탈인덱스LiOH(KG/BizType)
				 , AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
				 , CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
				 , MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
				 , NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
				 , CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
				 , LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
				 , LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
				 , CNTRC_EXCHANGE_PRICE                  --계약시 환율
				 , AL_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Al
				 , CU_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Cu
				 , MN_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Mn
				 , NI_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Ni
				 , CO_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Co
				 , LI2CO3_MIX_METAL_LINK_PERIOD          --MIX메탈링크범위Li2Co3
				 , LIOH_MIX_METAL_LINK_PERIOD            --MIX메탈링크범위LiOH
				 , AL_STND_MARKET                        --기준시장Al
				 , CU_STND_MARKET                        --기준시장Cu
				 , MN_STND_MARKET                        --기준시장Mn
				 , NI_STND_MARKET                        --기준시장Ni
				 , CO_STND_MARKET                        --기준시장Co
				 , LI2CO3_STND_MARKET                    --기준시장Li2Co3
				 , LIOH_STND_MARKET                      --기준시장LiOH
				 , CREATED_BY                            --생성자
				 , CREATION_DATE                         --생성일자
				 , LAST_UPDATED_BY                       --최종수정자
				 , LAST_UPDATE_DATE                      --최종수정일자
				 , METAL_LINK_START_MONTH				 --동일값(Metal Index(Cur)) 기간 시작연월
				 )
			select
				   DIVISION_ID                           --사업부ID
				 , @v_VER_RETURN_NO VERSION_NO			 --버전번호
				 , @p_CUTOFF_TYPE   CUTOFF_TYPE			 --컷오프유형코드
				 , CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) CUTOFF_YYYYMMDD --컷오프일자
				 , PROJECT_CODE                          --프로젝트코드
				 , SCM_SITE_ID                           --SCM사이트ID
				 , ITEM_ID                               --품목ID
				 , CELL_PROD_SITE						 --Cell 생산지
				 , BASE_PRICE                            --기준단가
				 , METAL_LINK_YN                         --메탈링크여부
				 , CURRENCY                              --통화코드
				 , METAL_LINK_PERIOD                     --메탈링크범위
				 , METAL_LINK_MTD                        --메탈링크방법
				 , START_YM                              --시작연월
				 , END_YM                                --종료연월
				 , AL_KG_PER_BIZ_TYPE                    --메탈인덱스Al(KG/BizType)
				 , CU_KG_PER_BIZ_TYPE                    --메탈인덱스Cu(KG/BizType)
				 , MN_KG_PER_BIZ_TYPE                    --메탈인덱스Mn(KG/BizType)
				 , NI_KG_PER_BIZ_TYPE                    --메탈인덱스Ni(KG/BizType)
				 , CO_KG_PER_BIZ_TYPE                    --메탈인덱스Co(KG/BizType)
				 , LI2CO3_KG_PER_BIZ_TYPE                --메탈인덱스Li2Co3(KG/BizType)
				 , LIOH_KG_PER_BIZ_TYPE                  --메탈인덱스LiOH(KG/BizType)
				 , AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
				 , CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
				 , MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
				 , NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
				 , CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
				 , LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
				 , LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
				 , CNTRC_EXCHANGE_PRICE                  --계약시 환율
				 , AL_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Al
				 , CU_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Cu
				 , MN_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Mn
				 , NI_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Ni
				 , CO_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Co
				 , LI2CO3_MIX_METAL_LINK_PERIOD          --MIX메탈링크범위Li2Co3
				 , LIOH_MIX_METAL_LINK_PERIOD            --MIX메탈링크범위LiOH
				 , AL_STND_MARKET                        --기준시장Al
				 , CU_STND_MARKET                        --기준시장Cu
				 , MN_STND_MARKET                        --기준시장Mn
				 , NI_STND_MARKET                        --기준시장Ni
				 , CO_STND_MARKET                        --기준시장Co
				 , LI2CO3_STND_MARKET                    --기준시장Li2Co3
				 , LIOH_STND_MARKET                      --기준시장LiOH
				 , @p_CREATED_BY CREATED_BY			     --생성자
				 , GETDATE() CREATION_DATE			     --생성일자
				 , @p_CREATED_BY LAST_UPDATED_BY	     --최종수정자
				 , GETDATE() LAST_UPDATE_DATE		     --최종수정일자
				 , METAL_LINK_START_MONTH				 --동일값(Metal Index(Cur)) 기간 시작연월
			  from dbo.DM_MST_METAL_PRICE_RULE with (nolock)--메탈 단가 기준
			 where DIVISION_ID = @p_DIVISION_ID;
		end
		else if @p_DIVISION_ID = '82'
		begin
			--ESS 메탈 단가 기준 컷오프(DM_MST_ESS_METAL_PRICE_RULE_C)
			insert
			  into dbo.DM_MST_ESS_METAL_PRICE_RULE_C--ESS 메탈 단가 기준 컷오프
				 (
                   DIVISION_ID                           --사업부ID
                 , VERSION_NO                            --버전번호
                 , CUTOFF_TYPE                           --컷오프유형코드
                 , CUTOFF_YYYYMMDD                       --컷오프일자
                 , PROJECT_CODE                          --프로젝트코드
                 , SCM_SITE_ID                           --SCM사이트ID
                 , ITEM_ID                               --품목ID
                 , BASE_PRICE_PER_EA                     --기준단가(/EA)
                 , METAL_LINK_YN                         --메탈링크여부
                 , CURRENCY                              --통화코드
                 , METAL_LINK_PERIOD                     --메탈링크범위
                 , METAL_LINK_MTD                        --메탈링크방법
                 , CELL_NICK                             --Cell Nick
                 , CELL_QTY                              --Cell Qty(/Biz Type)
                 , CAP_PCT                               --Cap Percentage
                 , START_YM                              --시작연월
                 , END_YM                                --종료연월
                 , AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
                 , CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
                 , MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
                 , NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
                 , CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
                 , LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
                 , LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
                 , CNTRC_EXCHANGE_PRICE                  --계약시 환율
                 , CREATED_BY                            --생성자
                 , CREATION_DATE                         --생성일자
                 , LAST_UPDATED_BY                       --최종수정자
                 , LAST_UPDATE_DATE                      --최종수정일자
				 , METAL_LINK_START_MONTH				 --동일값(Metal Index(Cur)) 기간 시작연월
				 )
			select
                   DIVISION_ID                           --사업부ID
				 , @v_VER_RETURN_NO VERSION_NO			 --버전번호
				 , @p_CUTOFF_TYPE   CUTOFF_TYPE			 --컷오프유형코드
				 , CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) CUTOFF_YYYYMMDD --컷오프일자
                 , PROJECT_CODE                          --프로젝트코드
                 , SCM_SITE_ID                           --SCM사이트ID
                 , ITEM_ID                               --품목ID
                 , BASE_PRICE_PER_EA                     --기준단가(/EA)
                 , METAL_LINK_YN                         --메탈링크여부
                 , CURRENCY                              --통화코드
                 , METAL_LINK_PERIOD                     --메탈링크범위
                 , METAL_LINK_MTD                        --메탈링크방법
                 , CELL_NICK                             --Cell Nick
                 , CELL_QTY                              --Cell Qty(/Biz Type)
                 , CAP_PCT                               --Cap Percentage
                 , START_YM                              --시작연월
                 , END_YM                                --종료연월
                 , AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
                 , CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
                 , MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
                 , NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
                 , CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
                 , LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
                 , LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
                 , CNTRC_EXCHANGE_PRICE                  --계약시 환율
				 , @p_CREATED_BY CREATED_BY			     --생성자
				 , GETDATE() CREATION_DATE			     --생성일자
				 , @p_CREATED_BY LAST_UPDATED_BY	     --최종수정자
				 , GETDATE() LAST_UPDATE_DATE		     --최종수정일자
				 , METAL_LINK_START_MONTH				 --동일값(Metal Index(Cur)) 기간 시작연월
			  from dbo.DM_MST_ESS_METAL_PRICE_RULE with (nolock)--ESS 메탈 단가 기준
			 where DIVISION_ID = @p_DIVISION_ID;

			--ESS 메탈 민감도 컷오프(DM_MST_ESS_METAL_SENSITIVIT_C)
			insert
			  into dbo.DM_MST_ESS_METAL_SENSITIVITY_C--ESS 메탈 민감도 컷오프
				 (
				   DIVISION_ID                             --사업부ID
				 , VERSION_NO                              --버전번호
				 , CUTOFF_TYPE                             --컷오프유형코드
				 , CUTOFF_YYYYMMDD                         --컷오프일자
				 , CELL_NICK                               --Cell Nick
				 , KWH_PER_CELL                            --KWh/Cell
				 , AL                                      --AL
				 , CU                                      --CU
				 , MN                                      --MN
				 , NI                                      --NI
				 , CO                                      --CO
				 , LI2CO3                                  --LI2CO3
				 , LIOH                                    --LIOH
				 , CREATED_BY                              --생성자
				 , CREATION_DATE                           --생성일자
				 , LAST_UPDATED_BY                         --최종수정자
				 , LAST_UPDATE_DATE                        --최종수정일자  
				 )
			select
				   DIVISION_ID                             --사업부ID
				 , @v_VER_RETURN_NO VERSION_NO			 --버전번호
				 , @p_CUTOFF_TYPE   CUTOFF_TYPE			 --컷오프유형코드
				 , CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) CUTOFF_YYYYMMDD --컷오프일자
				 , CELL_NICK                               --Cell Nick
				 , KWH_PER_CELL                            --KWh/Cell
				 , AL                                      --AL
				 , CU                                      --CU
				 , MN                                      --MN
				 , NI                                      --NI
				 , CO                                      --CO
				 , LI2CO3                                  --LI2CO3
				 , LIOH                                    --LIOH
				 , @p_CREATED_BY CREATED_BY			     --생성자
				 , GETDATE() CREATION_DATE			     --생성일자
				 , @p_CREATED_BY LAST_UPDATED_BY	     --최종수정자
				 , GETDATE() LAST_UPDATE_DATE		     --최종수정일자 
			  from dbo.DM_MST_ESS_METAL_SENSITIVITY with (nolock)--ESS 메탈 민감도
			 where DIVISION_ID = @p_DIVISION_ID;
		end
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
