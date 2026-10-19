


/*
 * Program ID   : DMF0010_GET_BIZ_PLAN_PRICE
 * Description  : DMF0010_BizPlanPrice(메탈 판가 등록 화면)의 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/29	ilovu1			Initial Release 사업계획 프로젝트
 * 2023/09/03   chkim.68        소형 경우 MEASURE 분기
 * 2023/09/03   ilovu1			소형 경우 CELL_PROD_SITE 컬럼 추가
 * 2023/09/06   ilovu1			소형 경우 CELL_PROD_SITE 컬럼에 값이 있는 로우만 표시
 * 2023/09/11   chkim.68        일자 컬럼을 DB에서 작성
 * 2023/09/21   ilovu1		    Compile
 * 2023/09/27   ilovu1		    메저 목록 변경
  /* 2024/08/16	KJJ			[PJ2024-50461] Team Mapping*/
 */
--EXEC DMF0010_GET_BIZ_PLAN_PRICE '81', 'ALL', 'ALL', 'ALL', '', '', 'ALL', 'chano0612', 'ADMIN', '', 'ICH', 'N'
CREATE procedure [dbo].[DMF0010_GET_BIZ_PLAN_PRICE]
	  @p_division_id		nvarchar(50)	--Division
	, @p_dept_id			nvarchar(4000)	--Department
	, @p_end_customer		nvarchar(4000)	--End Customer
	, @p_scm_site_id		nvarchar(4000)	--
	, @p_project_code		nvarchar(4000)
	, @p_item_id			nvarchar(4000)
	, @p_valid_yn			nvarchar(4000)
	, @p_created_by			nvarchar(50)
	, @p_userinfo			nvarchar(50)
	, @p_owner				nvarchar(4000)
	, @p_user_dept_id		nvarchar(50)   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가 
	, @p_end_cust_report_yn nvarchar(1)
    , @p_START_STND_YM      nvarchar(6)	  --시작 기준연월
    , @p_END_STND_YM        nvarchar(6)	  --종료 기준연월
	, @p_month_info			nvarchar(max) = ''
as
begin
	set nocount on;
	DECLARE @v_delimiter NVARCHAR(1)
	DECLARE @max_loop_cnt INTEGER = 0
	DECLARE @mst_loop_cnt INTEGER = 0

	DECLARE @v_month_info NVARCHAR(max)
	DECLARE @sub_mst_loop_cnt INTEGER = 0
	DECLARE @sub_max_loop_cnt INTEGER = 0
	DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
	DECLARE @sub_tmp_column NVARCHAR(max) = ''
	DECLARE @sub_param_0 NVARCHAR(max) = ''
	DECLARE @sub_param_1 NVARCHAR(max) = ''
	DECLARE @sub_param_2 NVARCHAR(max) = ''
	DECLARE @sub_param_3 NVARCHAR(max) = ''
	DECLARE @sub_param_4 NVARCHAR(max) = ''
	DECLARE @tmp_column NVARCHAR(max) = ''
	DECLARE @v_dSql NVARCHAR(MAX) = ''

	SET @v_month_info = '''' + @p_month_info + ''''
	SET @v_delimiter = '!' -- 데이터 구분자    
	SET @sub_v_delimiter = '#'
  
	---------------------------------------------------------------------------------
    --      20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    declare @v_group_id nvarchar(50)='';
    if exists (select 1
    			 from SCM_ADM_LOOKUP_MASTER_DETAIL with (nolock) 
    			where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
    			  and VALID_YN    = 'Y'
    			  and SEGMENT2    = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
    			  and SEGMENT1    = @p_userinfo
              )
    begin
    	set @v_group_id = 'ADMIN';
    end

	DECLARE @MEASUE_LOOKUP_KEY NVARCHAR(100)  = 'DMF_BIZ_PLAN_METAL_MEASURE'
	if @p_division_id like '81%'	
		SET @MEASUE_LOOKUP_KEY = 'DMF_BIZ_PLAN_METAL_MEASURE';
	else if @p_division_id = '82'	
		SET @MEASUE_LOOKUP_KEY = 'DMF_BIZ_PLAN_METAL_MEASURE82';
	else if @p_division_id = '40'	
		SET @MEASUE_LOOKUP_KEY = 'DMF_BIZ_PLAN_METAL_MEASURE40';
	

	create table #MEASURE (
		SEQ				int					not null
	  , CODE			nvarchar(20)        not null
	  , NAME			nvarchar(100)       not null
		);
	insert
	  into #MEASURE
	exec dbo.DMF0009_GET_CODE @MEASUE_LOOKUP_KEY;
	

	if @p_division_id = '40'		--소형
	BEGIN
		select *				
			 , case 
					when (([dbo].[FN_GET_DEPT_LIST](@p_created_by, DEPT_ID) = 'Y') or @v_group_id ='ADMIN') 
					then 'Y' 
					else 'N' 
			   end as EDIT_FLAG		
			 , case 
					when (([dbo].[FN_GET_DEPT_LIST](@p_created_by, DEPT_ID) = 'Y') and (@p_userinfo ='DM Planner')) 
					then 'Y' 
					else 'N' 
			   end as EDIT_FLAG3

		  into #SOURCE3
		  from (select SITE_PROJECT.DIVISION_ID
					 , TEAM.DEPT_ID
					 , TEAM.DEPT_ID           as DEPT_ID2
					 , TEAM.DEPT_NAME_KO      as TEAM_NAME_KO
					 , SITE_ITEM.PROJECT_CODE as END_CUSTOMER
					 , SITE_ITEM.PROJECT_CODE as END_CUSTOMER40
					 , SITE_CUST.SOLDTO_CODE
	     			 , CUST.SOLDTO_DESCRIPTION
					 , SITE_CUST.SHIPTO_CODE
					 , CUST.SHIPTO_DESCRIPTION
					 , SITE_PROJECT.SCM_SITE_ID
					 , SITE_PROJECT.SCM_SITE_ID as SCM_SITE_ID40
					 , SITE_PROJECT.PROJECT_CODE
					 , PJT.PROJECT_NAME
					 , PJT.PROJECT_STATUS
					 , PJT.PROJECT_OWNER
					 , SITE_PROJECT.owner		as USER_ID
					 , SITE_ITEM.SALES_PLAN_ADJUST_YN
					 , SITE_ITEM.ITEM_TYPE
					 , SITE_ITEM.ITEM_CLASS_NAME
					 , SITE_ITEM.ITEM_ID
					 , SITE_ITEM.ITEM_NAME
					 , SITE_ITEM.CELL_PER_CAR
					 , SITE_ITEM.CELL_PER_MODULE
					 , SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE as MODULE_PER_CAR

					 , CUST_ITEM.CUSTOMER_MODEL
					 , SITE_ITEM.NICK_NAME
					 , SITE_ITEM.SALES_COMPANY
					 , SITE_ITEM.SALES_PLANT

					 , SITE_ITEM.BPMS_EXIST
					 , SITE_ITEM.LIABILITY_PERIOD
					 --, SITE_ITEM.CURRENCY	--ilovu1: 메탈 단가 기준(DM_MST_METAL_PRICE_RULE)의 CURRENCY와 충돌함.
					 , case 
							when SITE_ITEM.ITEM_ID IS NULL 
							then isnull(SITE_PROJECT.VALID_YN, SITE_ITEM.VALID_YN) 
							else SITE_ITEM.VALID_YN 
					   end as VALID_YN
				 
					 , SITE_ITEM.LAST_UPDATE_DATE
					 , SITE_ITEM.LAST_UPDATED_BY
						
					 , SITE_ITEM.CUST_GROUP
					 , SITE_ITEM.CUST_GROUP_DTL
						
					 , dbo.FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') as OWNER
					 ,SITE_ITEM.APPLICATION
					 ,SITE_ITEM.ROUTE 
				 	   
					 ,SITE_ITEM.EDI		
					 ,SITE_ITEM.EDI_LT	
				 
					 ,SITE_ITEM.ATTRIBUTE1
					 ,SITE_ITEM.ATTRIBUTE2
					 ,SITE_ITEM.ATTRIBUTE4  
					 ,SITE_ITEM.ATTRIBUTE5  
					 ,SITE_ITEM.ATTRIBUTE9  as PRODUCTION_PROCESS
					 --------------------------------
					 ,SITE.SOLDTO_CUSTOMER
					 
					 ,REPORT_GROUP1
					 ,REPORT_GROUP2
					 ,REPORT_GROUP3
					 ,REPORT_GROUP4
					 
					 ,REPORT_GROUP6
					 ,REPORT_GROUP7
					 ,REPORT_GROUP8
					 ,SITE_ITEM.CELL_TYPE
					 , isnull(SITE_PROJECT.VMI_LT,0) as VMI_LT
			---------------------------------------------------------------------------------
			-- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
			---------------------------------------------------------------------------------
			--, M.BASE_PRICE                            --기준단가
			--, M.METAL_LINK_YN                         --메탈링크여부
--			  , M.CURRENCY                              --통화코드
			--, M.METAL_LINK_PERIOD                     --메탈링크범위
			--, M.METAL_LINK_MTD                        --메탈링크방법
--			, M.START_YM							  --시작연월
--			, M.END_YM								  --종료연월
			--, M.AL_KG_PER_BIZ_TYPE                    --메탈인덱스Al(KG/BizType)
			--, M.CU_KG_PER_BIZ_TYPE                    --메탈인덱스Cu(KG/BizType)
			--, M.MN_KG_PER_BIZ_TYPE                    --메탈인덱스Mn(KG/BizType)
			--, M.NI_KG_PER_BIZ_TYPE                    --메탈인덱스Ni(KG/BizType)
			--, M.CO_KG_PER_BIZ_TYPE                    --메탈인덱스Co(KG/BizType)
			--, M.LI2CO3_KG_PER_BIZ_TYPE                --메탈인덱스Li2Co3(KG/BizType)
			--, M.LIOH_KG_PER_BIZ_TYPE                  --메탈인덱스LiOH(KG/BizType)
			--, M.AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
			--, M.CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
			--, M.MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
			--, M.NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
			--, M.CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
			--, M.LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
			--, M.LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
			--, M.CNTRC_EXCHANGE_PRICE                  --계약시 환율
			--, M.AL_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Al
			--, M.CU_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Cu
			--, M.MN_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Mn
			--, M.NI_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Ni
			--, M.CO_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Co
			--, M.LI2CO3_MIX_METAL_LINK_PERIOD          --MIX메탈링크범위Li2Co3
			--, M.LIOH_MIX_METAL_LINK_PERIOD            --MIX메탈링크범위LiOH
			--, M.AL_STND_MARKET                        --기준시장Al
			--, M.CU_STND_MARKET                        --기준시장Cu
			--, M.MN_STND_MARKET                        --기준시장Mn
			--, M.NI_STND_MARKET                        --기준시장Ni
			--, M.CO_STND_MARKET                        --기준시장Co
			--, M.LI2CO3_STND_MARKET                    --기준시장Li2Co3
			--, M.LIOH_STND_MARKET                      --기준시장LiOH
			---------------------------------------------------------------------------------
				  from 
								   (select distinct
										   A.DIVISION_ID
										 , SCM_SITE_ID
										 , PROJECT_CODE
										 , isnull(max(VALID_YN),'Y') as VALID_YN
										 , '' owner
										 , '' ITEM_ID
										 , REPORT_GROUP1
										 , REPORT_GROUP2
										 , REPORT_GROUP3
										 , REPORT_GROUP4
										 --,REPORT_GROUP5
										 , REPORT_GROUP6
										 , REPORT_GROUP7
										 , REPORT_GROUP8
										 , max(A.SCP_VMI_LT) as VMI_LT
									  from SCM_MST_SITE_ITEM A with (nolock)
										 , SCM_MST_ITEM_SN   B with (nolock)
									   /* ilovu1, 2023.07.07
										  SCM_MST_SITE_ITEM[사이트품목기본]
											#DIVISION_ID	(사업부ID)
											#PROJECT_CODE	(프로젝트코드)
											#SCM_SITE_ID	(SCM사이트ID)
											#ITEM_ID		(품목ID)	   
									   */
									  /* ilovu1, 2023.07.07
										 SCM_MST_ITEM_SN = [LGCE_FP_TR_QA].[DBO].[SCM_ITEM_M][품목기본]
											#COMPANY_ID		(회사코드)
											#DIVISION_ID	(사업부코드)
											#SITE_ID		(지역코드)
											#ITEM_ID		(제품코드)
									  */
								   --WHERE ISNULL(VALID_YN,'Y')	='Y'
									 where A.ITEM_ID      = B.ITEM_ID 
									   and A.division_id <> '40'
									group by 
										  A.DIVISION_ID
										, SCM_SITE_ID
										, PROJECT_CODE
										, A.ATTRIBUTE1
										, A.ATTRIBUTE2
										-- 20190402
										, REPORT_GROUP1
										, REPORT_GROUP2
										, REPORT_GROUP3
										, REPORT_GROUP4
										--,REPORT_GROUP5
										, REPORT_GROUP6
										, REPORT_GROUP7
										, REPORT_GROUP8
									union
								   select distinct
										  A.DIVISION_ID
										, SCM_SITE_ID
										, PROJECT_CODE
										, VALID_YN
										, a.owner
										, ITEM_ID
										-- 20190402
										, REPORT_GROUP1
										, REPORT_GROUP2
										, REPORT_GROUP3
										, REPORT_GROUP4
										--,REPORT_GROUP5
										, REPORT_GROUP6
										, REPORT_GROUP7
										, REPORT_GROUP8
										, A.SCP_VMI_LT
									 from SCM_MST_SITE_ITEM A with (nolock)
									   /* ilovu1, 2023.07.07
										  SCM_MST_SITE_ITEM[사이트품목기본]
											#DIVISION_ID	(사업부ID)
											#PROJECT_CODE	(프로젝트코드)
											#SCM_SITE_ID	(SCM사이트ID)
											#ITEM_ID		(품목ID)	   
									   */
								--	WHERE ISNULL(VALID_YN,'Y')	='Y'
									where A.division_id = '40'
								   ) as SITE_PROJECT
					   left join SCM_MST_PROJECT as PJT  with (nolock)
							  on SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
							 and SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID
							   /* ilovu1, 2023.07.07
								  SCM_MST_PROJECT[프로젝트기본]
									#DIVISION_ID		(사업부ID)
									#PROJECT_CODE		(프로젝트코드)
									#PROJECT_VER_SEQ	(프로젝트버전순번)

									select DIVISION_ID				--(사업부ID)
										 , PROJECT_CODE				--(프로젝트코드)
										 , count(*) cnt
									  from SCM_MST_PROJECT
									 group by
										   DIVISION_ID				--(사업부ID)
										 , PROJECT_CODE				--(프로젝트코드)
									 having count(*) > 1
										 ;--O rows returned
							   */
					   left join SCM_MST_SITE as SITE  with (nolock)
							  on SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID  
							 and SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
							 and SITE.SITE_TYPE  = 'SALES'  
							/* ilovu1, 2023.07.07
								SCM_MST_SITE[SCM사이트기본]
									#DIVISION_ID		(사업부ID)
									#SCM_SITE_ID		(SCM사이트ID)
							*/
					   left join (select
	               						 B.USER_ID
									   , B.USER_NAME
									   , B.USER_NAME_EN
									   , B.DEPT_ID
									   , C.DEPT_NAME_KO 
	               					from [SCM_MST_SSO_USER_INFO] as B
	               						 inner join SCM_MST_SSO_DEPT_INFO as C
	               								 on B.DEPT_ID = C.DEPT_ID
								 ) as TEAM
							  on TEAM.USER_ID in (select top 1 token from [dbo].[String_Split](SITE_PROJECT.owner, ','))
					   left join (select T1.DIVISION_ID
									   , T1.SCM_SITE_ID
									   , T1.PROJECT_CODE
									   , T1.ITEM_ID
									   , T1.CELL_PER_CAR
									   , T1.CELL_PER_MODULE
									   , T2.ITEM_NAME
									   , T2.ITEM_TYPE
									   , T2.ITEM_CLASS_NAME
									   , T1.SALES_PLAN_ADJUST_YN
									   , T2.NICK_NAME
									   , T1.BPMS_EXIST
									   , T1.LIABILITY_PERIOD
									   , T1.CURRENCY
									   , T1.VALID_YN
									   , T1.LAST_UPDATE_DATE
									   , T1.LAST_UPDATED_BY	
									   
									   , T1.CUST_GROUP
									   , T1.CUST_GROUP_DTL
									   , T1.OWNER
									   , T1.APPLICATION
									   , T1.ROUTE 
									   , T1.ATTRIBUTE6 AS EDI
									   , T1.EDI_LT				
									   , T1.ATTRIBUTE1
									   , T1.ATTRIBUTE2
									   , T1.ATTRIBUTE5	
									   
									   , CO.COUNTRY_NAME as ATTRIBUTE4
									   , T1.ATTRIBUTE9    
									   , (select LMD.SEGMENT2  as NAME 
							       			from [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] LMD with (nolock)
							       		   where LOOKUP_TYPE = 'CELL_TYPE' AND T2.CELL_TYPE = LMD.SEGMENT1 
										 ) as CELL_TYPE
									   , T1.SALES_COMPANY
									   , T1.SALES_PLANT	
									from 	         SCM_MST_SITE_ITEM		T1  with (nolock)
										 inner join DM_MST_ITEM_SINGLE_V	T2  with (nolock)
										         on T1.DIVISION_ID = T2.DIVISION_ID
										        and T1.ITEM_ID     = T2.ITEM_ID
										   /* ilovu1, 2023.07.07
											  SCM_MST_SITE_ITEM[사이트품목기본]
												#DIVISION_ID	(사업부ID)
												#PROJECT_CODE	(프로젝트코드)
												#SCM_SITE_ID	(SCM사이트ID)
												#ITEM_ID		(품목ID)	 
									
											  DM_MST_ITEM_SINGLE_V
												from
													SCM_MST_ITEM_SN T1 
													inner join 
															   (SCM_MST_ITEM_SN group by DIVISION_ID, LEFT(ITEM_ID, 12)) T2 
															on T1.DIVISION_ID				= T2.DIVISION_ID
														   and SUBSTRING(T1.ITEM_ID,1,12)	= T2.ITEM_ID
												group by 
													  T1.DIVISION_ID
													, T1.ITEM_ID
									
										   */										 
										 inner join	SCM_MST_SITE	   T3  with (nolock)
												 on	T1.DIVISION_ID = T3.DIVISION_ID
												and	T1.SCM_SITE_ID = T3.SCM_SITE_ID							  
										 left  join SCM_MST_COUNTRY AS CO  with (nolock)
												 on T3.COUNTRY = CO.COUNTRY
							-- 소형인 경우에는 상품도 하나의 Grid에 다 보여야 함.
								   where (T2.ITEM_TYPE  = case when T1.DIVISION_ID = '40' then T2.ITEM_TYPE else 'H' end 
									  or  T2.ITEM_TYPE  = case when T1.DIVISION_ID = '40' then T2.ITEM_TYPE else 'P' end
										 )
								 ) as SITE_ITEM
							  on SITE_PROJECT.DIVISION_ID  = SITE_ITEM.DIVISION_ID
							 and SITE_PROJECT.SCM_SITE_ID  = SITE_ITEM.SCM_SITE_ID
							 and SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
							 and case 
										when SITE_PROJECT.DIVISION_ID = '40' 
										then SITE_PROJECT.ITEM_ID 
										else  SITE_ITEM.ITEM_ID 
								 end = SITE_ITEM.ITEM_ID
				       ---------------------------------------------------------------------------------
				       -- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
				       ---------------------------------------------------------------------------------
--				       inner join dbo.DM_MST_METAL_PRICE_RULE M with (nolock)
--				       		   on SITE_PROJECT.DIVISION_ID  = M.DIVISION_ID
--				       	      and SITE_PROJECT.PROJECT_CODE = M.PROJECT_CODE
--				       	      and SITE_PROJECT.SCM_SITE_ID  = M.SCM_SITE_ID
--				       	      and SITE_ITEM.ITEM_ID	        = M.ITEM_ID
				       ---------------------------------------------------------------------------------
					   left  join SCM_MST_SITE_CUSTOMER as SITE_CUST  with (nolock)
							   on SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
							  and SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
							  and SITE_CUST.REP_YN		  = 'Y'
							  /*  ilovu1, 2023.07.07
								  SCM_MST_SITE_CUSTOMER[사이트고객기본]; 아래는 고유 인덱스
										(UQ)*DIVISION_ID	(사업부ID)
										(UQ)*SCM_SITE_ID	(SCM사이트ID)
										(UQ)*SOLDTO_CODE	(판매처코드)
										(UQ)*SHIPTO_CODE	(인도처코드)

									select SCM_SITE_ID
										 , DIVISION_ID
										 , count(*) cnt 
									  from SCM_MST_SITE_CUSTOMER
									 where REP_YN = 'Y'
									 group by
										   SCM_SITE_ID
										 , DIVISION_ID
									having count(*) > 1;--0 rows returned
							  */
					   left  join SCM_MST_CUSTOMER as CUST  with (nolock)
							   on SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
							  and SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
							  and SITE_CUST.DIVISION_ID = CUST.DIVISION_ID  
							/* SCM_MST_CUSTOMER[고객기본]
									#DIVISION_ID	(사업부ID)
									#SOLDTO_CODE	(판매처코드)
									#SHIPTO_CODE	(인도처코드)
							*/
					   left  join (select DIVISION_ID
							    		, max(CUSTOMER_MODEL) as CUSTOMER_MODEL
							    		, SCM_SITE_ID
							    		, PROJECT_CODE
							    		, ITEM_ID
									 from DM_MST_CUSTOMER_MODEL  with (nolock)
									where VALID_YN = 'Y'
									group by 
										  DIVISION_ID
										, SCM_SITE_ID
										, PROJECT_CODE
										, ITEM_ID			
								  ) as CUST_ITEM
							   on SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
							  and SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
							  and SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
							  and SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID	
							/* DM_MST_CUSTOMER_MODEL[고객모델기본]
									#DIVISION_ID			(사업부ID)
									#CUSTOMER_PROJECT_CODE	(고객프로젝트코드)
									#CUSTOMER_MODEL			(고객모델명)
									#SCM_SITE_ID			(SCM사이트ID)
							*/
		-------------------------- Model/Item --------2018/07/30  Son Young Suk------------------------
					   inner join (select '%'+token+'%' tst from dbo.String_Split(@p_item_id,',')) b
							   on case 
										when @p_item_id = '' 
										then @p_item_id			
		           						else SITE_ITEM.ITEM_ID  
								  end like  b.tst 
							   or case 
										when @p_item_id = '' 
										then @p_item_id			
		           						else SITE_ITEM.NICK_NAME  
								  end like  b.tst 
		-----------------------------------------------------------------------------------------------
		------------  20180806  -------------------------------------------------------------------			
					   inner join (select distinct
										  X.OWNER
									 from SCM_MST_SITE_ITEM as X
										  left  join SCM_MST_SSO_USER_INFO as UI
												  on X.PROJECT_CODE = UI.USER_ID
										   /* ilovu1, 2023.07.07
											  SCM_MST_SITE_ITEM[사이트품목기본]
												#DIVISION_ID	(사업부ID)
												#PROJECT_CODE	(프로젝트코드)
												#SCM_SITE_ID	(SCM사이트ID)
												#ITEM_ID		(품목ID)	   
										   */						             
										  inner join (select '%'+token+'%' tst from dbo.String_Split(@p_owner,',') ) c
												  on (case 
															when @p_owner = '' 
															then @p_owner
															else [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') 
													  end like  c.tst 
												  or  case 
															when @p_owner = '' 
															then @p_owner
															else X.OWNER 
													  end like  c.tst 
												  or  case 
															when @p_owner = ''
															then @p_owner			
															else [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') 
													  end like  c.tst 
													 )
									where X.DIVISION_ID = @p_division_id
									  AND @p_owner <> ''
									union all
								   select '11'
									where @p_owner = ''
								  ) X
							   on isnull(SITE_ITEM.OWNER, 'xxxx') = case when @p_owner = '' then isnull(SITE_ITEM.OWNER,'xxxx') else X.owner end	
		-----------------------------------------------------------------------------------------------
				 where  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
				   and case 
							when @p_division_id = 'ALL' 
							then @p_division_id			
							else SITE_PROJECT.DIVISION_ID
 					   end in ( select token from dbo.String_Split(@p_division_id,',') )
				   and case 
							when @p_dept_id = 'ALL' 
							then @p_dept_id			
							else TEAM.DEPT_ID
 					   end in ( select token from dbo.String_Split(@p_dept_id,',') )		
				   and case 
							when @p_end_customer = 'ALL' 
							then @p_end_customer			
							else SITE_ITEM.PROJECT_CODE
 					   end in ( select token from dbo.String_Split(@p_end_customer,',') )
				   and case 
							when @p_scm_site_id = 'ALL' 
							then @p_scm_site_id			
							else SITE_ITEM.SCM_SITE_ID
 					   end in ( select token from dbo.String_Split(@p_scm_site_id,',') )
				   and case 
							when @p_project_code = '' 
							then @p_project_code			
							else SITE_PROJECT.PROJECT_CODE
 					   end IN ( select token from dbo.String_Split(@p_project_code,',') )
				   and    SITE.SITE_TYPE <> 'PLANT'
			   ) T1
		 where 1 = 1
		   and case 
					when @p_valid_yn = 'ALL' 
					then @p_valid_yn			
					else T1.VALID_YN
 			   end  IN ( select token from dbo.String_Split(@p_valid_yn,',') )
		   and	(( 
					isnull(T1.ATTRIBUTE2,'') not in (select SEGMENT1
													  from SCM_ADM_LOOKUP_MASTER_DETAIL
													 where LOOKUP_TYPE= 'END_CUST_REPORT'
													   and VALID_YN = 'Y' 
													) 
					and @p_end_cust_report_yn =  'Y' 
				 )  
				 or 
				 ( 
					1=1 and @p_end_cust_report_yn = 'N'
				 )
				)
		 order by
			   DIVISION_ID
			 , TEAM_NAME_KO
			 , END_CUSTOMER
			 , END_CUSTOMER40
			 , SOLDTO_CODE 			   
			 , SHIPTO_CODE				   
			 , SCM_SITE_ID
			 , SCM_SITE_ID40
			 , PROJECT_CODE
			 , PROJECT_NAME
			 , PROJECT_STATUS
			 , PROJECT_OWNER
			 , SALES_PLAN_ADJUST_YN
			 , ITEM_TYPE
			 , ITEM_CLASS_NAME
			 , ITEM_ID
			 , ITEM_NAME
			 , CUSTOMER_MODEL
			 , SALES_COMPANY
			 , SALES_PLANT
			 , NICK_NAME
			 , BPMS_EXIST
			 , LIABILITY_PERIOD
			 --, CURRENCY
			 , REPORT_GROUP1
			 , REPORT_GROUP2
			 , REPORT_GROUP3
			 , REPORT_GROUP4
			 , REPORT_GROUP6
			 , REPORT_GROUP7
			 , REPORT_GROUP8;


			 --Data PART
	SET @v_dSql += 'if object_id(''tempdb..#DATA_PART'') is not null ' + Char(10)
	SET @v_dSql += '	DROP TABLE #DATA_PART ' + Char(10) + Char(10)
	SET @v_dSql += '		create table #DATA_PART ('+ char(10)
	SET @v_dSql += '			DIVISION_ID		nvarchar(30)'+ char(10)
	SET @v_dSql += '			, PROJECT_CODE		nvarchar(150)'+ char(10)
	SET @v_dSql += '			, SCM_SITE_ID		nvarchar(150)'+ char(10)
	SET @v_dSql += '			, ITEM_ID			nvarchar(1000)'+ char(10)
	SET @v_dSql += '			, CELL_PROD_SITE	nvarchar(150)'+ char(10)
	SET @v_dSql += '			, MEASURE			nvarchar(50)'+ char(10)
	
	SET @max_loop_cnt = 0
	SET @mst_loop_cnt = 0
	SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
		SET @mst_loop_cnt = @mst_loop_cnt + 1
		SET @tmp_column = ''
		SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		--SET @v_dSql += @tmp_column + char(10)
		SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' ,' +@sub_param_0 + ' numeric(30,10)' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt  
	SET @v_dSql += '			)'+ char(10)		
  
	SET @v_dSql += '	INSERT INTO #DATA_PART '+ char(10)

	

  SET @v_dSql += '		select t.DIVISION_ID'+ char(10)
  SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '             , t.ITEM_ID'+ char(10)
  SET @v_dSql += '             , t.CELL_PROD_SITE'+ char(10)
  SET @v_dSql += '             , t.MEASURE'+ char(10)
  

    SET @mst_loop_cnt = 0
    SET @max_loop_cnt = 0
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

	--SET @v_dSql += TRY_CONVERT(NVARCHAR, @max_loop_cnt) + char(10)

	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
        SET @mst_loop_cnt = @mst_loop_cnt + 1
        SET @tmp_column = ''
        SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		  --SET @v_dSql += @tmp_column + char(10)
        SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END

		IF @sub_max_loop_cnt > 4
		BEGIN
			SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
			--SET @v_dsql += ' ,NULL AS ' +@sub_param_0
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' , MAX('+@sub_param_0 +') AS ' +@sub_param_0 + '' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt  

	SET @v_dSql += '		from ('+ char(10)
	--SET @v_dSql = ''
	SET @v_dSql += '		select distinct t.DIVISION_ID'+ char(10)
	SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
	SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '             , t.ITEM_ID'+ char(10)
	SET @v_dSql += '			 , t.CELL_PROD_SITE'+ char(10)
	SET @v_dSql += '             , t.MEASURE'+ char(10)

	
    SET @mst_loop_cnt = 0
    SET @max_loop_cnt = 0
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

	--SET @v_dSql += TRY_CONVERT(NVARCHAR, @max_loop_cnt) + char(10)

	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
        SET @mst_loop_cnt = @mst_loop_cnt + 1
        SET @tmp_column = ''
        SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		  --SET @v_dSql += @tmp_column + char(10)
        SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END

		IF @sub_max_loop_cnt > 4
		BEGIN
			SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
			--SET @v_dsql += ' ,NULL AS ' +@sub_param_0
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' , CASE WHEN t.STND_YM = ''' +@sub_param_1 + ''' THEN t.PRICE ELSE NULL END AS ' +@sub_param_0 + '' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt    
			--SET @v_dsql += '--' +char(10)

	--SET @v_dSql += '             , t.STND_YM'+ char(10)
	--SET @v_dSql += '             , t.PRICE'+ char(10)
	SET @v_dSql += '		  from #SOURCE3 s'+ char(10)
	SET @v_dSql += '		       inner join dbo.DM_MST_METAL_PRICE_RULE b with (nolock)'+ char(10)
	SET @v_dSql += '					   on s.DIVISION_ID		= b.DIVISION_ID'+ char(10)
	SET @v_dSql += '					  and s.END_CUSTOMER40	= b.PROJECT_CODE'+ char(10)
	SET @v_dSql += '					  and s.SCM_SITE_ID40	= b.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '					  and s.ITEM_ID			= b.ITEM_ID'+ char(10)
	SET @v_dSql += '		       inner join dbo.DM_MST_METAL_PRICE t with (nolock)'+ char(10)
	SET @v_dSql += '			           on b.DIVISION_ID	   = t.DIVISION_ID'+ char(10)
	SET @v_dSql += '                      and b.PROJECT_CODE   = t.PROJECT_CODE'+ char(10)
	SET @v_dSql += '					  and b.SCM_SITE_ID    = t.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '					  and b.ITEM_ID		   = t.ITEM_ID'+ char(10)
	SET @v_dSql += '					  and b.CELL_PROD_SITE = t.CELL_PROD_SITE'+ char(10)
	SET @v_dSql += '         where t.STND_YM between '+ @p_START_STND_YM + ' and '+ @p_END_STND_YM+''+ char(10)
	    SET @v_dSql += '      ) t group by '+ char(10)
	SET @v_dSql += '               t.DIVISION_ID'+ char(10)
	SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
	SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '             , t.ITEM_ID'+ char(10)
	SET @v_dSql += '             , t.CELL_PROD_SITE'+ char(10)
	SET @v_dSql += '             , t.MEASURE'+ char(10)
	SET @v_dSql += '         order by'+ char(10)
	SET @v_dSql += '               t.DIVISION_ID'+ char(10)
	SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
	SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '             , t.ITEM_ID'+ char(10)
	SET @v_dSql += '			 , t.CELL_PROD_SITE'+ char(10)
	SET @v_dSql += '             , t.MEASURE'+ char(10)
	--SET @v_dSql += '             , t.STND_YM;'+ char(10)

		--LIST
		  SET @v_dSql += 'select aa.*, data.* from (select'+ char(10)
  SET @v_dSql += '		        aa.*'+ char(10)
  SET @v_dSql += '			 , r.CURRENCY   --통화코드'+ char(10)
  SET @v_dSql += '			 , r.START_YM	--시작연월'+ char(10)
  SET @v_dSql += '			 , r.END_YM		--종료연월'+ char(10)
  SET @v_dSql += '		   from (	select s.*'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '						 , c.DISPLAY_SEQ'+ char(10)
  SET @v_dSql += '						 , c.CELL_PROD_SITE'+ char(10)
  SET @v_dSql += '						 , m.SEQ'+ char(10)
  SET @v_dSql += '						 , m.CODE MEASURE'+ char(10)
  SET @v_dSql += '						 , m.NAME MEASURE_NAME'+ char(10)
  SET @v_dSql += ''+ char(10)
  SET @v_dSql += '					  from (select a.*'+ char(10)
  SET @v_dSql += '							  from #SOURCE3 a'+ char(10)
  SET @v_dSql += '                             where exists (select 1'+ char(10)
  SET @v_dSql += '							                 from dbo.DM_MST_METAL_PRICE_RULE b with (nolock)'+ char(10)
  SET @v_dSql += '											where a.DIVISION_ID		= b.DIVISION_ID'+ char(10)
  SET @v_dSql += '										      and a.END_CUSTOMER40	= b.PROJECT_CODE'+ char(10)
  SET @v_dSql += '										      and a.SCM_SITE_ID40	= b.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '										      and a.ITEM_ID			= b.ITEM_ID'+ char(10)
  SET @v_dSql += '										  )'+ char(10)
  SET @v_dSql += '						   ) s'+ char(10)
  SET @v_dSql += '						   cross join ('+ char(10)
  SET @v_dSql += '										select SEGMENT1 CELL_PROD_SITE, ATTRIBUTE1 CELL_PROD_SITE_NM, DISPLAY_SEQ'+ char(10)
  SET @v_dSql += '										  from dbo.SCM_ADM_LOOKUP_MASTER_DETAIL with (nolock)'+ char(10)
  SET @v_dSql += '										 where LOOKUP_TYPE =   ''DM_CELL_PROD_SITE'''+ char(10)
  SET @v_dSql += '										   and SEGMENT1    in (''A01'', ''A02'', ''Z01'')'+ char(10)
  SET @v_dSql += '										 --order by'+ char(10)
  SET @v_dSql += '										 --	   DISPLAY_SEQ'+ char(10)
  SET @v_dSql += '									 ) c'+ char(10)
  SET @v_dSql += '						   cross join #MEASURE m ) aa'+ char(10)
  SET @v_dSql += '			   inner join dbo.DM_MST_METAL_PRICE_RULE r with (nolock)'+ char(10)
  SET @v_dSql += '			           on aa.DIVISION_ID	= r.DIVISION_ID'+ char(10)
  SET @v_dSql += '                      and aa.PROJECT_CODE   = r.PROJECT_CODE'+ char(10)
  SET @v_dSql += '					  and aa.SCM_SITE_ID	= r.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '					  and aa.ITEM_ID		= r.ITEM_ID'+ char(10)
  SET @v_dSql += '					  and aa.CELL_PROD_SITE = r.CELL_PROD_SITE'+ char(10)
  SET @v_dSql += '	) aa left outer join #DATA_PART data '+ char(10)
  
  SET @v_dSql += '	ON 1=1'+ char(10)
  SET @v_dSql += 'and aa.DIVISION_ID = data.DIVISION_ID'+ char(10)
  SET @v_dSql += 'and aa.PROJECT_CODE = data.PROJECT_CODE'+ char(10)
  SET @v_dSql += 'and aa.SCM_SITE_ID = data.SCM_SITE_ID'+ char(10)
  SET @v_dSql += 'and aa.ITEM_ID = data.ITEM_ID'+ char(10)
  SET @v_dSql += 'and aa.MEASURE = data.MEASURE'+ char(10)
  SET @v_dSql += 'and aa.CELL_PROD_SITE = data.CELL_PROD_SITE'+ char(10)
  
  SET @v_dSql += '		 order by'+ char(10)
  SET @v_dSql += '			   aa.DIVISION_ID'+ char(10)
  SET @v_dSql += '			 , aa.TEAM_NAME_KO'+ char(10)
  SET @v_dSql += '			 , aa.END_CUSTOMER'+ char(10)
  SET @v_dSql += '			 , aa.END_CUSTOMER40'+ char(10)
  SET @v_dSql += '			 , aa.SOLDTO_CODE'+ char(10)
  SET @v_dSql += '			 , aa.SHIPTO_CODE'+ char(10)
  SET @v_dSql += '			 , aa.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '			 , aa.SCM_SITE_ID40'+ char(10)
  SET @v_dSql += '			 , aa.PROJECT_CODE'+ char(10)
  SET @v_dSql += '			 , aa.PROJECT_NAME'+ char(10)
  SET @v_dSql += '			 , aa.PROJECT_STATUS'+ char(10)
  SET @v_dSql += '			 , aa.PROJECT_OWNER'+ char(10)
  SET @v_dSql += '			 , aa.SALES_PLAN_ADJUST_YN'+ char(10)
  SET @v_dSql += '			 , aa.ITEM_TYPE'+ char(10)
  SET @v_dSql += '			 , aa.ITEM_CLASS_NAME'+ char(10)
  SET @v_dSql += '			 , aa.ITEM_ID'+ char(10)
  SET @v_dSql += '			 , aa.ITEM_NAME'+ char(10)
  SET @v_dSql += '			 , aa.CUSTOMER_MODEL'+ char(10)
  SET @v_dSql += '			 , aa.SALES_COMPANY'+ char(10)
  SET @v_dSql += '			 , aa.SALES_PLANT'+ char(10)
  SET @v_dSql += '			 , aa.NICK_NAME'+ char(10)
  SET @v_dSql += '			 , aa.BPMS_EXIST'+ char(10)
  SET @v_dSql += '			 , aa.LIABILITY_PERIOD'+ char(10)
  SET @v_dSql += '			 --, r.CURRENCY'+ char(10)
  SET @v_dSql += '			 , aa.REPORT_GROUP1'+ char(10)
  SET @v_dSql += '			 , aa.REPORT_GROUP2'+ char(10)
  SET @v_dSql += '			 , aa.REPORT_GROUP3'+ char(10)
  SET @v_dSql += '			 , aa.REPORT_GROUP4'+ char(10)
  SET @v_dSql += '			 , aa.REPORT_GROUP6'+ char(10)
  SET @v_dSql += '			 , aa.REPORT_GROUP7'+ char(10)
  SET @v_dSql += '			 , aa.REPORT_GROUP8'+ char(10)
  SET @v_dSql += '			 , aa.DISPLAY_SEQ'+ char(10)
  SET @v_dSql += '			 , aa.SEQ;'+ char(10)

  SET @v_dSql += 'SELECT * FROM #DATA_PART'+ char(10)

	--SELECT @v_dSql as sql_data
	BEGIN TRAN
		-- run dynamic sql
		EXEC sp_executesql @v_dsql
    COMMIT TRAN


		--select t.DIVISION_ID                   
  --           , t.PROJECT_CODE   
  --           , t.SCM_SITE_ID    
  --           , t.ITEM_ID   
		--	 , t.CELL_PROD_SITE
  --           , t.MEASURE        
  --           , t.STND_YM        
  --           , t.PRICE 
		--  from #SOURCE3 s
		--       inner join dbo.DM_MST_METAL_PRICE_RULE b with (nolock)
		--			   on s.DIVISION_ID		= b.DIVISION_ID
		--			  and s.END_CUSTOMER40	= b.PROJECT_CODE
		--			  and s.SCM_SITE_ID40	= b.SCM_SITE_ID
		--			  and s.ITEM_ID			= b.ITEM_ID		           
		--       inner join dbo.DM_MST_METAL_PRICE t with (nolock)
		--	           on b.DIVISION_ID	   = t.DIVISION_ID
  --                    and b.PROJECT_CODE   = t.PROJECT_CODE
		--			  and b.SCM_SITE_ID    = t.SCM_SITE_ID
		--			  and b.ITEM_ID		   = t.ITEM_ID
		--			  and b.CELL_PROD_SITE = t.CELL_PROD_SITE
  --       where t.STND_YM between @p_START_STND_YM and @p_END_STND_YM
  --       order by
  --             t.DIVISION_ID          
  --           , t.PROJECT_CODE   
  --           , t.SCM_SITE_ID    
  --           , t.ITEM_ID  
		--	 , t.CELL_PROD_SITE
  --           , t.MEASURE        
  --           , t.STND_YM;
	END
	else if @p_division_id = '82'	--ESS
	BEGIN
		select *
			 , case 
					when (([dbo].[FN_GET_DEPT_LIST](@p_created_by, DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
					then 'Y' 
					else 'N' 
			   end as EDIT_FLAG
		  INTO #SOURCE2
		  from (select SITE_PROJECT.DIVISION_ID
				 		--DEPT.DEPT_ID,
						--DEPT.DEPT_NAME_KO,
					 , TEAM.DEPT_ID
					 , TEAM.DEPT_ID as DEPT_ID2
					 , TEAM.DEPT_NAME_KO as TEAM_NAME_KO
					 , SITE.END_CUSTOMER
					 , SITE.END_CUSTOMER as END_CUSTOMER40
					 , SITE_CUST.SOLDTO_CODE
	     			 , CUST.SOLDTO_DESCRIPTION
					 , SITE_CUST.SHIPTO_CODE
					 , CUST.SHIPTO_DESCRIPTION
					 , SITE_PROJECT.SCM_SITE_ID
					 , SITE_PROJECT.SCM_SITE_ID as SCM_SITE_ID40
					 , SITE_PROJECT.PROJECT_CODE
					 , PJT.PROJECT_NAME
					 , PJT.PROJECT_STATUS
					 , PJT.PROJECT_OWNER
					 , SITE_ITEM.OWNER as USER_ID
					 , SITE_ITEM.SALES_PLAN_ADJUST_YN
					 , SITE_ITEM.ITEM_TYPE
					 , SITE_ITEM.ITEM_CLASS_NAME
					 , SITE_ITEM.ITEM_ID
					 , SITE_ITEM.ITEM_NAME
					 , SITE_ITEM.ATTRIBUTE10 as CELL_TYPE_81
					 , SITE_ITEM.ATTRIBUTE10 as CELL_TYPE_82
					 , SITE_ITEM.ATTRIBUTE8  as KWH
					 , SITE_ITEM.CELL_PER_CAR
					 , SITE_ITEM.CELL_PER_MODULE
					 , SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE as MODULE_PER_CAR

					 , CUST_ITEM.CUSTOMER_MODEL
						   
					 
					 , SITE_ITEM.SALES_COMPANY
					 , SITE_ITEM.SALES_PLANT
				 
					 , SITE_ITEM.NICK_NAME
					 , SITE_ITEM.BPMS_EXIST
					 , SITE_ITEM.LIABILITY_PERIOD
					 --, SITE_ITEM.CURRENCY	--ilovu1: ESS 메탈 단가 기준(DM_MST_ESS_METAL_PRICE_RULE)의 CURRENCY와 충돌함.
					 , case 
							when SITE_ITEM.ITEM_ID is null
							then isnull(SITE_PROJECT.VALID_YN,SITE_ITEM.VALID_YN) 
							else SITE_ITEM.VALID_YN 
					   end as VALID_YN
				 
					 , SITE_ITEM.LAST_UPDATE_DATE
					 , SITE_ITEM.LAST_UPDATED_BY
					 , SITE_ITEM.CUST_GROUP
					 , SITE_ITEM.CUST_GROUP_DTL
					 , dbo.FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') as OWNER
					 , SITE_ITEM.APPLICATION
					 , SITE_ITEM.ROUTE 
					 , SITE_ITEM.ATTRIBUTE6 AS EDI
					 , SITE_ITEM.EDI_LT  
					 , isnull(SITE_ITEM.VMI_LT, 0) as VMI_LT
					 , SITE_ITEM.CELL_NAME 
					 , SITE_ITEM.PARTIAL_PLAN_YN 
					 , SITE_ITEM.ATTRIBUTE1  -- 양극재
					 , SITE_ITEM.ATTRIBUTE2 as MODULE_VARIANT

					 ---------------------------------------------------------------------------------
					 -- ilovu1; 2023.08.10 ESS 메탈 단가 기준(DM_MST_ESS_METAL_PRICE_RULE) 추가함
					 ---------------------------------------------------------------------------------
					 --, M.BASE_PRICE_PER_EA        --기준단가(/EA)
					 --, M.METAL_LINK_YN            --메탈링크여부
					 , M.CURRENCY                 --통화코드
					 --, M.METAL_LINK_PERIOD        --메탈링크범위
					 --, M.METAL_LINK_MTD           --메탈링크방법
					 --, M.CELL_NICK                --Cell Nick
					 --, M.CELL_QTY                 --Cell Qty(/Biz Type)
					 --, M.CAP_PCT                  --Cap Percentage                          
					 , M.START_YM                   --시작연월
					 , M.END_YM                     --종료연월
					 --, M.AL_USD_PER_KG            --메탈인덱스Al(USD/KG)
					 --, M.CU_USD_PER_KG            --메탈인덱스Cu(USD/KG)
					 --, M.MN_USD_PER_KG            --메탈인덱스Mn(USD/KG)
					 --, M.NI_USD_PER_KG            --메탈인덱스Ni(USD/KG)
					 --, M.CO_USD_PER_KG            --메탈인덱스Co(USD/KG)
					 --, M.LI2CO3_USD_PER_KG        --메탈인덱스Li2Co3(USD/KG)
					 --, M.LIOH_USD_PER_KG          --메탈인덱스LiOH(USD/KG)
					 --, M.CNTRC_EXCHANGE_PRICE     --계약시 환율  
				  from (select distinct
							   A.DIVISION_ID
							 , SCM_SITE_ID
							 , PROJECT_CODE
							 , isnull(max(VALID_YN), 'Y') as VALID_YN
						  from SCM_MST_SITE_ITEM A with (nolock)
							   inner join SCM_MST_ITEM_SN B with (nolock)
									   on A.ITEM_ID = B.ITEM_ID 
							   left  join (select SEGMENT1 as SITE_ID , '1' as NUM 
											 from SCM_ADM_LOOKUP_MASTER_DETAIL with (nolock)  
											where LOOKUP_TYPE = 'GM_JV_SITE' 
											  and VALID_YN	  = 'Y'
											union all 
											select SCM_SITE_ID as SITE_ID , '1' as NUM 
											  from SCM_MST_SITE with (nolock)  
											 where DEPT_ID = @p_user_dept_id
										  ) as C 
									   on A.SCM_SITE_ID = C.SITE_ID
						 where isnull(C.NUM,'') = case when '81' = @p_division_id AND @p_userinfo = 'JV Planner' then 1 else isnull(C.NUM,'') end
						   and A.DIVISION_ID = @p_division_id
						 group by 
							   A.DIVISION_ID
							 , SCM_SITE_ID
							 , PROJECT_CODE	
					   ) as SITE_PROJECT
					   left  join SCM_MST_PROJECT as PJT  with (nolock)
							   on SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
							  and SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID

					   left  join SCM_MST_SITE as SITE  with (nolock)
							   on SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID  
							  and SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID

					--[PJ2024-50461] Team Mapping
					/*
					  left  join SCM_MST_SSO_DEPT_INFO as TEAM with (nolock)	       
							  on SITE.DEPT_ID = TEAM.DEPT_ID
*/

					  left  join (select T1.DIVISION_ID
									   , T1.SCM_SITE_ID
									   , T1.PROJECT_CODE
									   , T1.ITEM_ID
									   , T1.CELL_PER_CAR
									   , T1.CELL_PER_MODULE
									   , T2.ITEM_NAME
									   , T2.ITEM_TYPE
									   , T2.ITEM_CLASS_NAME
									   , T1.SALES_PLAN_ADJUST_YN
									   , T2.NICK_NAME
									   , T1.BPMS_EXIST    
									   , T1.LIABILITY_PERIOD
									   , T1.CURRENCY
									   , T1.VALID_YN
									   , T1.LAST_UPDATE_DATE
									   , T1.LAST_UPDATED_BY	
										, T1.CUST_GROUP
										, T1.CUST_GROUP_DTL
										, T1.OWNER
										, T1.APPLICATION
										, T1.ROUTE 
										, T1.ATTRIBUTE6		
										, T1.EDI_LT		
										, T1.SCP_VMI_LT as VMI_LT
										, T1.ATTRIBUTE9 as CELL_NAME 							
										
										, T1.SALES_COMPANY
										, T1.SALES_PLANT
										, T1.PARTIAL_PLAN_YN 
										, T1.ATTRIBUTE10		
										, T1.ATTRIBUTE8		
										
										, isnull(T1.ATTRIBUTE1,'')  ATTRIBUTE1 -- 양극재
										, isnull(T1.ATTRIBUTE2,'')  ATTRIBUTE2
									from            SCM_MST_SITE_ITEM		T1  with (nolock)
										 inner join DM_MST_ITEM_SINGLE_V	T2  with (nolock)
										         on T1.DIVISION_ID = T2.DIVISION_ID
										        and T1.ITEM_ID     = T2.ITEM_ID
								  -- 20200422 KHSONG C20200422-000123 소형사업부와과 같이 상품도 하나의 Grid에 다 보이도록함
								   where (T2.ITEM_TYPE = case when T1.DIVISION_ID = '82' then T2.ITEM_TYPE else 'H' end
									  or  T2.ITEM_TYPE = case when T1.DIVISION_ID = '82' then T2.ITEM_TYPE else 'P' end
										 )
								 ) as SITE_ITEM
							  on SITE_PROJECT.DIVISION_ID  = SITE_ITEM.DIVISION_ID
							 and SITE_PROJECT.SCM_SITE_ID  = SITE_ITEM.SCM_SITE_ID
							 and SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
					 ---------------------------------------------------------------------------------
					 --[PJ2024-50461] Team Mapping
					 ---------------------------------------------------------------------------------
						LEFT JOIN (
							SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
							FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
							INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
							ON B.DEPT_ID = C.DEPT_ID
						) AS TEAM
						ON      
						TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](SITE_ITEM.owner, ','))

					 ---------------------------------------------------------------------------------
					 -- ilovu1; 2023.08.10 ESS 메탈 단가 기준(DM_MST_ESS_METAL_PRICE_RULE) 추가함
					 ---------------------------------------------------------------------------------
					 INNER JOIN dbo.DM_MST_ESS_METAL_PRICE_RULE M WITH (NOLOCK)
							 ON SITE_PROJECT.DIVISION_ID    = M.DIVISION_ID
							AND SITE_PROJECT.PROJECT_CODE   = M.PROJECT_CODE
							AND SITE_PROJECT.SCM_SITE_ID    = M.SCM_SITE_ID
							AND SITE_ITEM.ITEM_ID			= M.ITEM_ID
					 ---------------------------------------------------------------------------------
					  left  join SCM_MST_SITE_CUSTOMER as SITE_CUST  with (nolock)
							  on SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
							 and SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
							 and SITE_CUST.REP_YN      = 'Y'
					  left  join SCM_MST_CUSTOMER	   as CUST  with (nolock)
							  on SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
							 and SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
							 and SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
   
					  left  join (select DIVISION_ID
									   , MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
									   , SCM_SITE_ID
									   , PROJECT_CODE
									   , ITEM_ID
									from DM_MST_CUSTOMER_MODEL with (nolock)
								   where VALID_YN = 'Y'
								   group by 
								   		 DIVISION_ID
									   , SCM_SITE_ID
									   , PROJECT_CODE
									   , ITEM_ID			
								 ) as CUST_ITEM
							  on SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
							 and SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
							 and SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
							 and SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID
	
					  left  join SCM_MST_SSO_USER_INFO SU			
							  on SITE_ITEM.owner = SU.USER_ID
			
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
					  inner join (select '%'+token+'%' tst from dbo.String_Split(@p_item_id,',') ) b
							  on case 
										when @p_item_id = '' 
										then @p_item_id			
										else SITE_ITEM.ITEM_ID  
								 end like b.tst 
							  or case 
										when @p_item_id = '' 
										then @p_item_id			
										else SITE_ITEM.NICK_NAME  
								 end like b.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Project ---------------2018/07/30  Son Young Suk--------------------
					  inner join (select '%'+token+'%' tst from dbo.String_Split(@p_project_code,',') ) b1
							  on case
										when @p_project_code = '' 
										then @p_project_code			
										else PJT.PROJECT_CODE  
								 end like b1.tst 
							  or case 
										when @p_project_code = '' 
										then @p_project_code			
										else PJT.PROJECT_NAME  
								 end like b1.tst 
				-----------------------------------------------------------------------------------------------
				------------  20180806  -------------------------------------------------------------------			
					  inner join (select distinct
										 X.OWNER
									from SCM_MST_SITE_ITEM as X
										 left  join SCM_MST_SSO_USER_INFO as UI
												 on X.PROJECT_CODE = UI.USER_ID
										 inner join (select '%'+token+'%' tst from dbo.String_Split(@p_owner,',') ) c
												 on (case
															when @p_owner = '' 
															then @p_owner			
															else [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') 
													 end like c.tst 
												 or  case
															when @p_owner = '' 
															then @p_owner			
															else X.OWNER 
													 end like c.tst 
												 or  case
															when @p_owner = '' 
															then @p_owner			
															else [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') 
													 end like c.tst 
													)
								   where X.DIVISION_ID = @p_division_id
									 and @p_owner <> ''
								   union all
								  select '11'
								   where @p_owner = ''
								 ) X
							  on isnull(SITE_ITEM.OWNER,'xxxx') = case when @p_owner = '' then isnull(SITE_ITEM.OWNER,'xxxx') else X.owner end
				-----------------------------------------------------------------------------------------------
				 where  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
				   and case 
							when @p_division_id = 'ALL'
							then @p_division_id			
							else SITE_PROJECT.DIVISION_ID
 					   end in (select token from dbo.String_Split(@p_division_id,',') )
				   and case 
							when @p_dept_id = 'ALL' 
							then @p_dept_id			
							else TEAM.DEPT_ID
 					   end in (select token from dbo.String_Split(@p_dept_id,',') )
				   and case
							when @p_end_customer = 'ALL' 
							then @p_end_customer			
							else SITE.END_CUSTOMER
 					   end in (select token from dbo.String_Split(@p_end_customer,',') )
				   and case
							when @p_scm_site_id = 'ALL' 
							then @p_scm_site_id	
							else SITE_PROJECT.SCM_SITE_ID
 					   end  IN (select token from dbo.String_Split(@p_scm_site_id,',') )
				   and SITE.SITE_TYPE <> 'PLANT'
			   ) T1
		 where 1 = 1
		   and case
					when @p_valid_yn = 'ALL' 
					then @p_valid_yn			
					else T1.VALID_YN
 			   end IN (select token from dbo.String_Split(@p_valid_yn,',') )
		 order by 
			   DIVISION_ID
			 , TEAM_NAME_KO
			 , END_CUSTOMER
			 , END_CUSTOMER40
			 , SOLDTO_CODE			   
			 , SHIPTO_CODE			   
			 , SCM_SITE_ID
			 , SCM_SITE_ID40
			 , PROJECT_CODE
			 , PROJECT_NAME
			 , PROJECT_STATUS
			 , PROJECT_OWNER
			 , SALES_PLAN_ADJUST_YN
			 , ITEM_TYPE
			 , ITEM_CLASS_NAME
			 , ITEM_ID
			 , ITEM_NAME
			 , CELL_TYPE_81
			 , CELL_TYPE_82
			 , KWH				-- 셀용량 및 팩 당 용량 추가
			 , CUSTOMER_MODEL
			 , SALES_COMPANY
			 , SALES_PLANT
			 , NICK_NAME
			 , BPMS_EXIST
			 , LIABILITY_PERIOD
			 , CURRENCY;

--Data

	SET @v_dSql += 'if object_id(''tempdb..#DATA_PART'') is not null ' + Char(10)
	SET @v_dSql += '	DROP TABLE #DATA_PART ' + Char(10) + Char(10)
	SET @v_dSql += '		create table #DATA_PART ('+ char(10)
	SET @v_dSql += '			DIVISION_ID		nvarchar(30)'+ char(10)
	SET @v_dSql += '			, PROJECT_CODE		nvarchar(150)'+ char(10)
	SET @v_dSql += '			, SCM_SITE_ID		nvarchar(150)'+ char(10)
	SET @v_dSql += '			, ITEM_ID			nvarchar(1000)'+ char(10)
	SET @v_dSql += '			, MEASURE			nvarchar(50)'+ char(10)
	
	SET @max_loop_cnt = 0
	SET @mst_loop_cnt = 0
	SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
		SET @mst_loop_cnt = @mst_loop_cnt + 1
		SET @tmp_column = ''
		SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		--SET @v_dSql += @tmp_column + char(10)
		SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' ,' +@sub_param_0 + ' numeric(30,10)' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt  
	SET @v_dSql += '			)'+ char(10)		
  
	SET @v_dSql += '	INSERT INTO #DATA_PART '+ char(10)

  SET @v_dSql += '		select t.DIVISION_ID'+ char(10)
  SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '             , t.ITEM_ID'+ char(10)
  SET @v_dSql += '             , t.MEASURE'+ char(10)
  --SET @v_dSql += '             , t.STND_YM'+ char(10)
  --SET @v_dSql += '             , t.PRICE'+ char(10)

      SET @mst_loop_cnt = 0
    SET @max_loop_cnt = 0
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

	--SET @v_dSql += TRY_CONVERT(NVARCHAR, @max_loop_cnt) + char(10)

	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
        SET @mst_loop_cnt = @mst_loop_cnt + 1
        SET @tmp_column = ''
        SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		  --SET @v_dSql += @tmp_column + char(10)
        SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END

		IF @sub_max_loop_cnt > 4
		BEGIN
			SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
			--SET @v_dsql += ' ,NULL AS ' +@sub_param_0
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' , MAX('+@sub_param_0 +') AS ' +@sub_param_0 + '' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt  

	SET @v_dSql += '		from ('+ char(10)
	--SET @v_dSql = ''
	SET @v_dSql += '		select distinct t.DIVISION_ID'+ char(10)
	SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
	SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '             , t.ITEM_ID'+ char(10)
	--SET @v_dSql += '			 , t.CELL_PROD_SITE'+ char(10)
	SET @v_dSql += '             , t.MEASURE'+ char(10)
	
    SET @mst_loop_cnt = 0
    SET @max_loop_cnt = 0
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

	--SET @v_dSql += TRY_CONVERT(NVARCHAR, @max_loop_cnt) + char(10)

	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
        SET @mst_loop_cnt = @mst_loop_cnt + 1
        SET @tmp_column = ''
        SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		  --SET @v_dSql += @tmp_column + char(10)
        SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END

		IF @sub_max_loop_cnt > 4
		BEGIN
			SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
			--SET @v_dsql += ' ,NULL AS ' +@sub_param_0
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' , CASE WHEN t.STND_YM = ''' +@sub_param_1 + ''' THEN t.PRICE ELSE NULL END AS ' +@sub_param_0 + '' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt    
			--SET @v_dsql += '--' +char(10)

  SET @v_dSql += '		  from #SOURCE2 s'+ char(10)
  SET @v_dSql += '		       inner join dbo.DM_MST_METAL_PRICE t'+ char(10)
  SET @v_dSql += '			           on s.DIVISION_ID	= t.DIVISION_ID'+ char(10)
  SET @v_dSql += '                      and s.PROJECT_CODE= t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '					  and s.SCM_SITE_ID	= t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '					  and s.ITEM_ID		= t.ITEM_ID'+ char(10)
  SET @v_dSql += '         where t.STND_YM between ' + @p_START_STND_YM+ ' and '+ @p_END_STND_YM+''+ char(10)

	    SET @v_dSql += '      ) t group by '+ char(10)
	SET @v_dSql += '               t.DIVISION_ID'+ char(10)
	SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
	SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '             , t.ITEM_ID'+ char(10)
	SET @v_dSql += '             , t.MEASURE'+ char(10)
	SET @v_dSql += '         order by'+ char(10)
	SET @v_dSql += '               t.DIVISION_ID'+ char(10)
	SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
	SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
	SET @v_dSql += '             , t.ITEM_ID'+ char(10)
	SET @v_dSql += '             , t.MEASURE'+ char(10)


		--List
		  SET @v_dSql += 'select s.*, data.* from ('+ char(10)
  SET @v_dSql += 'select s.*'+ char(10)
  SET @v_dSql += '		     , m.SEQ'+ char(10)
  SET @v_dSql += '			 , m.CODE MEASURE'+ char(10)
  SET @v_dSql += '		  from #SOURCE2 s cross join #MEASURE m'+ char(10)

  SET @v_dSql += '	) s left outer join #DATA_PART data '+ char(10)
  
  SET @v_dSql += '	ON 1=1'+ char(10)
  SET @v_dSql += 'and s.DIVISION_ID = data.DIVISION_ID'+ char(10)
  SET @v_dSql += 'and s.PROJECT_CODE = data.PROJECT_CODE'+ char(10)
  SET @v_dSql += 'and s.SCM_SITE_ID = data.SCM_SITE_ID'+ char(10)
  SET @v_dSql += 'and s.ITEM_ID = data.ITEM_ID'+ char(10)
  SET @v_dSql += 'and s.MEASURE = data.MEASURE'+ char(10)

  SET @v_dSql += '		order by'+ char(10)
  SET @v_dSql += '			  s.DIVISION_ID'+ char(10)
  SET @v_dSql += '			, s.TEAM_NAME_KO'+ char(10)
  SET @v_dSql += '			, s.END_CUSTOMER'+ char(10)
  SET @v_dSql += '			, s.END_CUSTOMER40'+ char(10)
  SET @v_dSql += '			, s.SOLDTO_CODE'+ char(10)
  SET @v_dSql += '			, s.SHIPTO_CODE'+ char(10)
  SET @v_dSql += '			, s.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '			, s.SCM_SITE_ID40'+ char(10)
  SET @v_dSql += '			, s.PROJECT_CODE'+ char(10)
  SET @v_dSql += '			, s.PROJECT_NAME'+ char(10)
  SET @v_dSql += '			, s.PROJECT_STATUS'+ char(10)
  SET @v_dSql += '			, s.PROJECT_OWNER'+ char(10)
  SET @v_dSql += '			, s.SALES_PLAN_ADJUST_YN'+ char(10)
  SET @v_dSql += '			, s.ITEM_TYPE'+ char(10)
  SET @v_dSql += '			, s.ITEM_CLASS_NAME'+ char(10)
  SET @v_dSql += '			, s.ITEM_ID'+ char(10)
  SET @v_dSql += '			, s.ITEM_NAME'+ char(10)
  SET @v_dSql += '			, s.CELL_TYPE_81'+ char(10)
  SET @v_dSql += '			, s.CELL_TYPE_82'+ char(10)
  SET @v_dSql += '			, s.KWH				-- 셀용량 및 팩 당 용량 추가'+ char(10)
  SET @v_dSql += '			, s.CUSTOMER_MODEL'+ char(10)
  SET @v_dSql += '			, s.SALES_COMPANY'+ char(10)
  SET @v_dSql += '			, s.SALES_PLANT'+ char(10)
  SET @v_dSql += '			, s.NICK_NAME'+ char(10)
  SET @v_dSql += '			, s.BPMS_EXIST'+ char(10)
  SET @v_dSql += '			, s.LIABILITY_PERIOD'+ char(10)
  SET @v_dSql += '			, s.CURRENCY'+ char(10)
  SET @v_dSql += '			, s.SEQ;'+ char(10)
  
  SET @v_dSql += 'SELECT * FROM #DATA_PART'+ char(10)

	--SELECT @v_dSql as sql_data
	BEGIN TRAN
		-- run dynamic sql
		EXEC sp_executesql @v_dsql
    COMMIT TRAN

		
	END
	else
	begin
		create table #T_SINGLE (
				DIVISION_ID		nvarchar(30)
			, ITEM_ID			nvarchar(150)
			, ITEM_NAME			nvarchar(150)
			, ITEM_TYPE			varchar(1)
			, ITEM_CLASS_NAME	nvarchar(300)
			, NICK_NAME			nvarchar(50)
			);

		---------------------------------------------------------------------------------
		--      20230328 heesan91 속도개선
		---------------------------------------------------------------------------------
		create table #SCM_MST_SITE_ITEM (
				DIVISION_ID		nvarchar(30)
			, SCM_SITE_ID		nvarchar(150)
			, PROJECT_CODE		nvarchar(150)
			, CNT				varchar(5)			
			);

		insert 
			into #T_SINGLE 
				( DIVISION_ID
				, ITEM_ID
				, ITEM_NAME
				, ITEM_TYPE
				, ITEM_CLASS_NAME
				, NICK_NAME 
				)
		select T1.DIVISION_ID
				, T1.ITEM_ID
				, max(T1.ITEM_NAME)			as ITEM_NAME
				, case  min( case 
								when T1.item_type = 'P' then 1	
								when T1.item_type = 'H' then 2	
								when T1.item_type = 'Q' then 3
								else 4 
							end
						)  
					when 1 then 'P' 
					when 2 then 'H'
					when 3 then 'Q'
					else 'R' 
				end							as ITEM_TYPE
				, max(T1.ITEM_CLASS_NAME)		as ITEM_CLASS_NAME
				, max(T1.NICK_NAME)			as NICK_NAME
			from SCM_MST_ITEM_SN T1 with (nolock)
			/* ilovu1, 2023.07.07
				SCM_MST_ITEM_SN = [LGCE_FP_TR_QA].[DBO].[SCM_ITEM_M][품목기본]
				#COMPANY_ID		(회사코드)
				#DIVISION_ID	(사업부코드)
				#SITE_ID		(지역코드)
				#ITEM_ID		(제품코드)
			*/
			where 1=1
			AND T1.DIVISION_ID = @P_DIVISION_ID
			AND T1.ITEM_TYPE IN ( 'H', 'P' )
			group by 
				T1.DIVISION_ID
				, T1.ITEM_ID;

		insert 
			into #SCM_MST_SITE_ITEM 
				( DIVISION_ID
				, SCM_SITE_ID
				, PROJECT_CODE
				, CNT
				)
		select 
				A.DIVISION_ID
				, A.SCM_SITE_ID
				, A.PROJECT_CODE
				, sum(case 
						when B.ITEM_TYPE in ( 'H', 'P' ) 
						then 1 
						else 0 
					end 
					)
			from SCM_MST_SITE_ITEM A
				left join #T_SINGLE B 
						on A.DIVISION_ID = B.DIVISION_ID 
						and A.ITEM_ID     = B.ITEM_ID
				/* ilovu1, 2023.07.07
					SCM_MST_SITE_ITEM[사이트품목기본]
					#DIVISION_ID	(사업부ID)
					#PROJECT_CODE	(프로젝트코드)
					#SCM_SITE_ID	(SCM사이트ID)
					#ITEM_ID		(품목ID)	   
				*/
			where A.DIVISION_ID = @P_DIVISION_ID
			group by 
				A.DIVISION_ID
				, A.SCM_SITE_ID
				, A.PROJECT_CODE;

		select A.DIVISION_ID							--Div*
			--[PJ2024-50461] Team Mapping------------------------------------
			 /*, B.DEPT_ID								--Team
			 , B.DEPT_ID		AS DEPT_ID2				--Team
			 , C.DEPT_NAME_KO	AS TEAM_NAME_KO*/
			, TEAM.DEPT_ID
			, TEAM.DEPT_ID AS DEPT_ID2
			, TEAM.DEPT_NAME_KO AS TEAM_NAME_KO
			 --[PJ2024-50461] Team Mapping------------------------------------
			, B.END_CUSTOMER							--End Customer
			, B.END_CUSTOMER	as END_CUSTOMER40		--End Customer
			, D.SOLDTO_CODE							--Sold-To
			, E.SOLDTO_DESCRIPTION						--Sold-To
			, D.SHIPTO_CODE							--Rep Ship-To
			, E.SHIPTO_DESCRIPTION						--Rep Ship-To
			, A.SCM_SITE_ID							--Sales Site*
			, A.SCM_SITE_ID	as SCM_SITE_ID40		--Sales Site*
			, A.PROJECT_CODE							--Project Code*
			, F.PROJECT_NAME							--Project
			, F.PROJECT_STATUS							--Project Status
			, F.PROJECT_OWNER
			, A.OWNER			as USER_ID
			, A.SALES_PLAN_ADJUST_YN
			, G.ITEM_TYPE								--Item Type
			, G.ITEM_CLASS_NAME						--Model Type
			, A.ITEM_ID								--Model
			, G.ITEM_NAME								--Model Name
			, A.ATTRIBUTE10	as CELL_TYPE_81
			, A.ATTRIBUTE10	as CELL_TYPE_82
			, A.ATTRIBUTE8		as KWH
			, A.CELL_PER_CAR
			, A.CELL_PER_MODULE
			, case	--ilovu1:2023.07.17 A.CELL_PER_MODULE = 0 예외처리
				when A.CELL_PER_MODULE = 0 
				then null
				else A.CELL_PER_CAR / A.CELL_PER_MODULE 
			end as MODULE_PER_CAR
			, H.CUSTOMER_MODEL
			, A.SALES_COMPANY
			, A.SALES_PLANT							--Sales Plant*
			, G.NICK_NAME								--Nick Name
			, A.BPMS_EXIST
			, A.LIABILITY_PERIOD
			--, A.CURRENCY								--ilovu1 주석처리
			, A.VALID_YN
			, A.LAST_UPDATE_DATE
			, A.LAST_UPDATED_BY
			, A.CUST_GROUP
			, A.CUST_GROUP_DTL
			, dbo.FN_GET_MULTI_OWNER_NAME (A.OWNER, ',', '1') as OWNER
			, A.APPLICATION
			, A.ROUTE
			, A.ATTRIBUTE6 as EDI
			, A.EDI_LT
			, isnull(A.SCP_VMI_LT, 0) as VMI_LT
			, A.ATTRIBUTE9 as CELL_NAME
			, A.PARTIAL_PLAN_YN
			, A.ATTRIBUTE1 as CATHODE_MATERIALS
			, A.ATTRIBUTE2 as MODULE_VARIANT
			--[PJ2024-50461] Team Mapping------------------------------------
			/*, case 
				when (([dbo].[FN_GET_DEPT_LIST](@p_created_by, B.DEPT_ID) = 'Y') or @v_group_id ='ADMIN') 
		 		then 'Y' 
				else 'N' 
			end as EDIT_FLAG*/
			, case 
				when (([dbo].[FN_GET_DEPT_LIST](@p_created_by, TEAM.DEPT_ID) = 'Y') or @v_group_id ='ADMIN') 
		 		then 'Y' 
				else 'N' 
			end as EDIT_FLAG
			--[PJ2024-50461] Team Mapping------------------------------------
			---------------------------------------------------------------------------------
			-- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
			---------------------------------------------------------------------------------
			--, M.BASE_PRICE                            --기준단가
			--, M.METAL_LINK_YN                         --메탈링크여부
			  , M.CURRENCY                              --통화코드
			--, M.METAL_LINK_PERIOD                     --메탈링크범위
			--, M.METAL_LINK_MTD                        --메탈링크방법
			, M.START_YM							  --시작연월
			, M.END_YM								  --종료연월
			--, M.AL_KG_PER_BIZ_TYPE                    --메탈인덱스Al(KG/BizType)
			--, M.CU_KG_PER_BIZ_TYPE                    --메탈인덱스Cu(KG/BizType)
			--, M.MN_KG_PER_BIZ_TYPE                    --메탈인덱스Mn(KG/BizType)
			--, M.NI_KG_PER_BIZ_TYPE                    --메탈인덱스Ni(KG/BizType)
			--, M.CO_KG_PER_BIZ_TYPE                    --메탈인덱스Co(KG/BizType)
			--, M.LI2CO3_KG_PER_BIZ_TYPE                --메탈인덱스Li2Co3(KG/BizType)
			--, M.LIOH_KG_PER_BIZ_TYPE                  --메탈인덱스LiOH(KG/BizType)
			--, M.AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
			--, M.CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
			--, M.MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
			--, M.NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
			--, M.CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
			--, M.LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
			--, M.LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
			--, M.CNTRC_EXCHANGE_PRICE                  --계약시 환율
			--, M.AL_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Al
			--, M.CU_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Cu
			--, M.MN_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Mn
			--, M.NI_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Ni
			--, M.CO_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Co
			--, M.LI2CO3_MIX_METAL_LINK_PERIOD          --MIX메탈링크범위Li2Co3
			--, M.LIOH_MIX_METAL_LINK_PERIOD            --MIX메탈링크범위LiOH
			--, M.AL_STND_MARKET                        --기준시장Al
			--, M.CU_STND_MARKET                        --기준시장Cu
			--, M.MN_STND_MARKET                        --기준시장Mn
			--, M.NI_STND_MARKET                        --기준시장Ni
			--, M.CO_STND_MARKET                        --기준시장Co
			--, M.LI2CO3_STND_MARKET                    --기준시장Li2Co3
			--, M.LIOH_STND_MARKET                      --기준시장LiOH
			---------------------------------------------------------------------------------
		into #SOURCE
		from	        SCM_MST_SITE_ITEM A with (nolock)
				---------------------------------------------------------------------------------
				-- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
				---------------------------------------------------------------------------------
				inner join dbo.DM_MST_METAL_PRICE_RULE M with (nolock)
						on A.DIVISION_ID  = M.DIVISION_ID
					and A.PROJECT_CODE = M.PROJECT_CODE
					and A.SCM_SITE_ID  = M.SCM_SITE_ID
					and A.ITEM_ID	   = M.ITEM_ID
				---------------------------------------------------------------------------------
				inner join SCM_MST_SITE B with (nolock) 
						on A.DIVISION_ID = B.DIVISION_ID 
					and A.SCM_SITE_ID = B.SCM_SITE_ID
				inner join #SCM_MST_SITE_ITEM B2 
						on A.DIVISION_ID  = B2.DIVISION_ID 
					and A.SCM_SITE_ID	 = B2.SCM_SITE_ID 
					and A.PROJECT_CODE = B2.PROJECT_CODE --20230328 속도개선
				left  join SCM_MST_SSO_DEPT_INFO C with (nolock) 
						on B.DEPT_ID = C.DEPT_ID
				left  join SCM_MST_SITE_CUSTOMER D with (nolock)
						on B.DIVISION_ID = D.DIVISION_ID 
					and B.SCM_SITE_ID = D.SCM_SITE_ID 
					and D.REP_YN      = 'Y'
				/*  ilovu1, 2023.07.07
					SCM_MST_SITE_CUSTOMER[사이트고객기본]; 아래는 고유 인덱스
						(UQ)*DIVISION_ID	(사업부ID)
						(UQ)*SCM_SITE_ID	(SCM사이트ID)
						(UQ)*SOLDTO_CODE	(판매처코드)
						(UQ)*SHIPTO_CODE	(인도처코드)

					select SCM_SITE_ID
							, DIVISION_ID
							, count(*) cnt 
						from SCM_MST_SITE_CUSTOMER
						where REP_YN = 'Y'
						group by
					 		SCM_SITE_ID
					 		, DIVISION_ID
					having count(*) > 1;--0 rows returned
				*/
				left  join SCM_MST_CUSTOMER E with (nolock)
						on D.DIVISION_ID = E.DIVISION_ID 
					and D.SOLDTO_CODE = E.SOLDTO_CODE 
					and D.SHIPTO_CODE = E.SHIPTO_CODE 
				/* SCM_MST_CUSTOMER[고객기본]
						#DIVISION_ID	(사업부ID)
						#SOLDTO_CODE	(판매처코드)
						#SHIPTO_CODE	(인도처코드)
				*/
				left  join SCM_MST_PROJECT F with (nolock)
						on A.DIVISION_ID  = F.DIVISION_ID 
					and A.PROJECT_CODE = F.PROJECT_CODE
				/* ilovu1, 2023.07.07
					SCM_MST_PROJECT[프로젝트기본]
					#DIVISION_ID		(사업부ID)
					#PROJECT_CODE		(프로젝트코드)
					#PROJECT_VER_SEQ	(프로젝트버전순번)

					select DIVISION_ID				--(사업부ID)
					  		, PROJECT_CODE				--(프로젝트코드)
					  		, count(*) cnt
						from SCM_MST_PROJECT
						group by
					  		DIVISION_ID				--(사업부ID)
					  		, PROJECT_CODE				--(프로젝트코드)
					having count(*) > 1
					;--O rows returned
				*/
				left  join #T_SINGLE G with (nolock)
						on A.DIVISION_ID = G.DIVISION_ID 
					and A.ITEM_ID     = G.ITEM_ID
				left  join (select DIVISION_ID
								, max(CUSTOMER_MODEL) as CUSTOMER_MODEL
								, SCM_SITE_ID
								, PROJECT_CODE
								, ITEM_ID
							from DM_MST_CUSTOMER_MODEL  with (nolock)
							where VALID_YN = 'Y'
							and DIVISION_ID = @P_DIVISION_ID
							group by 
						  		DIVISION_ID 
						  		, SCM_SITE_ID
						  		, PROJECT_CODE
						  		, ITEM_ID			
						) as H
						on A.ITEM_ID      = H.ITEM_ID
					and A.PROJECT_CODE = H.PROJECT_CODE
					and A.DIVISION_ID  = H.DIVISION_ID
					and A.SCM_SITE_ID  = H.SCM_SITE_ID
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
				inner join (select '%'+token+'%' tst from dbo.String_Split(@p_item_id,',') ) X1
						on case 
							when @p_item_id = '' 
							then @p_item_id			
							else A.ITEM_ID  
						end like X1.tst 
						or case 
							when @p_item_id = '' 
							then @p_item_id			
							else isnull(G.NICK_NAME,'')  
						end like X1.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Project ---------------2018/07/30  Son Young Suk--------------------
				inner join (select '%'+token+'%' tst from dbo.String_Split(@p_project_code,',') ) b1
						on case 
							when @p_project_code = '' 
							then @p_project_code			
							else A.PROJECT_CODE 
						end like b1.tst 
						or case 
							when @p_project_code = '' 
							then @p_project_code			
							else isnull(F.PROJECT_NAME, '')  
						end like b1.tst 
				-----------------------------------------------------------------------------------------------
				inner join (select distinct 
								X.OWNER			        
							from SCM_MST_SITE_ITEM as X
									left  join SCM_MST_SSO_USER_INFO as UI
											on X.PROJECT_CODE = UI.USER_ID
									inner join (select '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) c
											on (case 
													when @p_owner = '' 
													then @p_owner												
													else [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') 
												end like c.tst 
											or
												case 
													when @p_owner = '' 
													then @p_owner			
													else X.OWNER 
												end like c.tst 
											or
												case 
													when @p_owner = '' 
													then @p_owner			
													else [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') 
												end like c.tst 
										)
								where X.DIVISION_ID = @p_division_id
								and @p_owner <> ''
								union all
							select '11'
								where @p_owner = ''
						) X
						on isnull(A.OWNER,'xxxx') = case when @p_owner = '' then  isnull(A.OWNER,'xxxx') else X.owner end		
						
					 ---------------------------------------------------------------------------------
					 --[PJ2024-50461] Team Mapping
					 ---------------------------------------------------------------------------------
						LEFT JOIN (
							SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
							FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
							INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
							ON B.DEPT_ID = C.DEPT_ID
						) AS TEAM
						ON      
						TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ','))	
		where A.DIVISION_ID = @P_DIVISION_ID
			-- H,P 가 없는 프로젝트도 한 줄은 나오도록 한다.
			and ( G.ITEM_TYPE IN ( 'H', 'P' ) or B2.CNT = 0 )		
			and case 
					when @p_division_id = 'ALL' 
					then @p_division_id			
					else A.DIVISION_ID
 				end in ( select token from dbo.String_Split(@p_division_id,',') )
			and case 
					when @p_dept_id = 'ALL' 
					then @p_dept_id			
					else TEAM.DEPT_ID
 				end in ( select token from dbo.String_Split(@p_dept_id,',') )
			and case 
					when @p_end_customer = 'ALL' 
					then @p_end_customer			
					else B.END_CUSTOMER
 				end in ( select token from dbo.String_Split(@p_end_customer,',') )
			and case 
					when @p_scm_site_id = 'ALL' 
					then @p_scm_site_id			
					else A.SCM_SITE_ID
 				end in ( select token from dbo.String_Split(@p_scm_site_id,',') )
			and B.SITE_TYPE <> 'PLANT'
			and case 
					when @p_valid_yn = 'ALL' 
					then @p_valid_yn			
					else A.VALID_YN
 				end in ( select token from dbo.String_Split(@p_valid_yn,',') )
		order by 
			  DIVISION_ID
			, TEAM_NAME_KO
			, END_CUSTOMER
			, END_CUSTOMER40
			, SOLDTO_CODE    			   
			, SHIPTO_CODE			   
			, SCM_SITE_ID
			, SCM_SITE_ID40
			, PROJECT_CODE
			, PROJECT_NAME
			, PROJECT_STATUS
			, PROJECT_OWNER 
			, SALES_PLAN_ADJUST_YN
			, ITEM_TYPE
			, ITEM_CLASS_NAME
			, ITEM_ID
			, ITEM_NAME
			, CELL_TYPE_81	
			, CELL_TYPE_82	
			, KWH
			, CUSTOMER_MODEL
			, SALES_COMPANY
			, SALES_PLANT
			, NICK_NAME
			, BPMS_EXIST
			, LIABILITY_PERIOD
			, CURRENCY;



		     -- FROM MONTH INFO to RESULT MONTH

		--Data Part (Daily Data)
  SET @v_dSql = ''
    -- FROM MONTH INFO to RESULT MONTH

  -- CREATE #DATA_PART temp_table

  SET @v_dSql += 'if object_id(''tempdb..#DATA_PART'') is not null ' + Char(10)
  SET @v_dSql += '	DROP TABLE #DATA_PART ' + Char(10) + Char(10)
  SET @v_dSql += '		create table #DATA_PART ('+ char(10)
  SET @v_dSql += '			DIVISION_ID		nvarchar(30)'+ char(10)
  SET @v_dSql += '			, PROJECT_CODE		nvarchar(150)'+ char(10)
  SET @v_dSql += '			, SCM_SITE_ID		nvarchar(150)'+ char(10)
  SET @v_dSql += '			, ITEM_ID			nvarchar(1000)'+ char(10)
  SET @v_dSql += '			, MEASURE			nvarchar(50)'+ char(10)
      SET @mst_loop_cnt = 0
    SET @max_loop_cnt = 0
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
    WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
        SET @mst_loop_cnt = @mst_loop_cnt + 1
        SET @tmp_column = ''
        SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		  --SET @v_dSql += @tmp_column + char(10)
        SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END

		SET @v_dsql += ' ,' +@sub_param_0 + ' numeric(30,10)' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt  
	  SET @v_dSql += '			)'+ char(10)		
  
  SET @v_dSql += '	INSERT INTO #DATA_PART '+ char(10)


  SET @v_dSql += '		select t.DIVISION_ID'+ char(10)
  SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '             , t.ITEM_ID'+ char(10)
  SET @v_dSql += '             , t.MEASURE'+ char(10)
  

    SET @mst_loop_cnt = 0
    SET @max_loop_cnt = 0
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

	--SET @v_dSql += TRY_CONVERT(NVARCHAR, @max_loop_cnt) + char(10)

	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
        SET @mst_loop_cnt = @mst_loop_cnt + 1
        SET @tmp_column = ''
        SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		  --SET @v_dSql += @tmp_column + char(10)
        SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END

		IF @sub_max_loop_cnt > 4
		BEGIN
			SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
			--SET @v_dsql += ' ,NULL AS ' +@sub_param_0
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' , MAX('+@sub_param_0 +') AS ' +@sub_param_0 + '' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt  

  SET @v_dSql += '		from ('+ char(10)
  SET @v_dSql += '		select distinct t.DIVISION_ID'+ char(10)
  SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '             , t.ITEM_ID'+ char(10)
  SET @v_dSql += '             , t.MEASURE'+ char(10)


  		--List Part

	--debug
	--SET @v_dSql = ''

    SET @mst_loop_cnt = 0
    SET @max_loop_cnt = 0
    SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

	--SET @v_dSql += TRY_CONVERT(NVARCHAR, @max_loop_cnt) + char(10)

	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN
        SET @mst_loop_cnt = @mst_loop_cnt + 1
        SET @tmp_column = ''
        SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
		  --SET @v_dSql += @tmp_column + char(10)
        SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

		IF @sub_max_loop_cnt > 0
		BEGIN
			SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
			--SET @v_dSql += @sub_param_0 + char(10)
		END

		IF @sub_max_loop_cnt > 4
		BEGIN
			SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
			--SET @v_dsql += ' ,NULL AS ' +@sub_param_0
			--SET @v_dSql += @sub_param_0 + char(10)
		END
		SET @v_dsql += ' , CASE WHEN t.STND_YM = ''' +@sub_param_1 + ''' THEN t.PRICE ELSE NULL END AS ' +@sub_param_0 + '' +char(10)
	END -- end of @mst_loop_cnt < @max_loop_cnt    
			--SET @v_dsql += '--' +char(10)

  SET @v_dSql += '		  from #SOURCE s'+ char(10)

  SET @v_dSql += '		       inner join dbo.DM_MST_METAL_PRICE t'+ char(10)
  SET @v_dSql += '			           on s.DIVISION_ID	= t.DIVISION_ID'+ char(10)
  SET @v_dSql += '                      and s.PROJECT_CODE= t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '					  and s.SCM_SITE_ID	= t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '					  and s.ITEM_ID		= t.ITEM_ID'+ char(10)
  SET @v_dSql += '         where t.STND_YM between ' + @p_START_STND_YM +' and ' +@p_END_STND_YM +''+ char(10)

    SET @v_dSql += '      ) t group by '+ char(10)
  SET @v_dSql += '               t.DIVISION_ID'+ char(10)
   SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '             , t.ITEM_ID'+ char(10)
  SET @v_dSql += '             , t.MEASURE'+ char(10)

  SET @v_dSql += '         order by'+ char(10)
  SET @v_dSql += '               t.DIVISION_ID'+ char(10)
  SET @v_dSql += '             , t.PROJECT_CODE'+ char(10)
  SET @v_dSql += '             , t.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '             , t.ITEM_ID'+ char(10)
  SET @v_dSql += '             , t.MEASURE;'+ char(10)
  --SET @v_dSql += '             , t.STND_YM;'+ char(10)
  --SET @v_dSql += '           select * FROM #DATA_PART'+ char(10)

    --SELECT @v_dsql AS sql_data
 -- 	BEGIN TRAN
	--EXEC sp_executesql @v_dsql
	----SELECT * FROM #DATA_PART
 --   COMMIT TRAN

 --- LIST PART
		--SET @v_dSql = ''
  SET @v_dSql += 'select s.*,data.* from (select s.*'+ char(10)
  SET @v_dSql += '		     , m.SEQ'+ char(10)
  SET @v_dSql += '			 , m.CODE MEASURE'+ char(10)

    -- FROM MONTH INFO to RESULT MONTH
	SET @v_delimiter = '!' -- 데이터 구분자    
	SET @sub_v_delimiter = '#'

	--debug
	--SET @v_dSql = ''

    --SET @mst_loop_cnt = 0
    --SET @max_loop_cnt = 0
    --SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

	--SET @v_dSql += TRY_CONVERT(NVARCHAR, @max_loop_cnt) + char(10)

	--WHILE @mst_loop_cnt < @max_loop_cnt
	--BEGIN
 --       SET @mst_loop_cnt = @mst_loop_cnt + 1
 --       SET @tmp_column = ''
 --       SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
	--	  --SET @v_dSql += @tmp_column + char(10)
 --       SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

	--	IF @sub_max_loop_cnt > 0
	--	BEGIN
	--		SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
	--		SET @v_dsql += ' ,NULL AS ' +@sub_param_0
	--		--SET @v_dSql += @sub_param_0 + char(10)
	--	END
 
	--END -- end of @mst_loop_cnt < @max_loop_cnt    
			--SET @v_dsql += '--' +char(10)

  SET @v_dSql += '		  from #SOURCE s cross join #MEASURE m ) s'+ char(10)

    SET @v_dSql += '  left outer join #DATA_PART data'+ char(10)
  SET @v_dSql += '  ON 1=1'+ char(10)
  SET @v_dSql += '  and s.DIVISION_ID = data.DIVISION_ID'+ char(10)
  SET @v_dSql += '  and s.PROJECT_CODE = data.PROJECT_CODE'+ char(10)
  SET @v_dSql += '  and s.SCM_SITE_ID = data.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '  and s.ITEM_ID = data.ITEM_ID'+ char(10)
  SET @v_dSql += '  and s.MEASURE = data.MEASURE'+ char(10)

  SET @v_dSql += '		order by'+ char(10)
  SET @v_dSql += '			  s.DIVISION_ID'+ char(10)
  SET @v_dSql += '			, s.TEAM_NAME_KO'+ char(10)
  SET @v_dSql += '			, s.END_CUSTOMER'+ char(10)
  SET @v_dSql += '			, s.END_CUSTOMER40'+ char(10)
  SET @v_dSql += '			, s.SOLDTO_CODE'+ char(10)
  SET @v_dSql += '			, s.SHIPTO_CODE'+ char(10)
  SET @v_dSql += '			, s.SCM_SITE_ID'+ char(10)
  SET @v_dSql += '			, s.SCM_SITE_ID40'+ char(10)
  SET @v_dSql += '			, s.PROJECT_CODE'+ char(10)
  SET @v_dSql += '			, s.PROJECT_NAME'+ char(10)
  SET @v_dSql += '			, s.PROJECT_STATUS'+ char(10)
  SET @v_dSql += '			, s.PROJECT_OWNER'+ char(10)
  SET @v_dSql += '			, s.SALES_PLAN_ADJUST_YN'+ char(10)
  SET @v_dSql += '			, s.ITEM_TYPE'+ char(10)
  SET @v_dSql += '			, s.ITEM_CLASS_NAME'+ char(10)
  SET @v_dSql += '			, s.ITEM_ID'+ char(10)
  SET @v_dSql += '			, s.ITEM_NAME'+ char(10)
  SET @v_dSql += '			, s.CELL_TYPE_81'+ char(10)
  SET @v_dSql += '			, s.CELL_TYPE_82'+ char(10)
  SET @v_dSql += '			, s.KWH'+ char(10)
  SET @v_dSql += '			, s.CUSTOMER_MODEL'+ char(10)
  SET @v_dSql += '			, s.SALES_COMPANY'+ char(10)
  SET @v_dSql += '			, s.SALES_PLANT'+ char(10)
  SET @v_dSql += '			, s.NICK_NAME'+ char(10)
  SET @v_dSql += '			, s.BPMS_EXIST'+ char(10)
  SET @v_dSql += '			, s.LIABILITY_PERIOD'+ char(10)
  SET @v_dSql += '			, s.CURRENCY'+ char(10)
  SET @v_dSql += '			, s.SEQ'+ char(10)

  -- FOR REFERENCE
  SET @v_dSql += '	select * FROM #DATA_PART'+ char(10)
 
	--SELECT @v_dsql as sql_text

	BEGIN TRAN
		-- run dynamic sql
		EXEC sp_executesql @v_dsql
    COMMIT TRAN


		--select t.DIVISION_ID                   
  --           , t.PROJECT_CODE   
  --           , t.SCM_SITE_ID    
  --           , t.ITEM_ID        
  --           , t.MEASURE        
  --           , t.STND_YM        
  --           , t.PRICE 
		--  from #SOURCE s
		--       inner join dbo.DM_MST_METAL_PRICE t
		--	           on s.DIVISION_ID	= t.DIVISION_ID
  --                    and s.PROJECT_CODE= t.PROJECT_CODE
		--			  and s.SCM_SITE_ID	= t.SCM_SITE_ID
		--			  and s.ITEM_ID		= t.ITEM_ID
  --       where t.STND_YM between @p_START_STND_YM and @p_END_STND_YM
  --       order by
  --             t.DIVISION_ID          
  --           , t.PROJECT_CODE   
  --           , t.SCM_SITE_ID    
  --           , t.ITEM_ID        
  --           , t.MEASURE        
  --           , t.STND_YM;
	end
end;
