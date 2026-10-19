
/*
 * PROGRAM ID   : SSP0023_GET_SHIPMENT_PLAN
 * DESCRIPTION  : 전극 SHIPMENT PLAN(Electrode) DETAIL
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE		DESCRIPTION
 *===================================================================================================
 * 2020-05-08   khj79			[PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선  최초 작성
 * 2020-09-21   KIMYONGHO		SSP INCOTERMS 변경 작업
 * 2021/09/02   KIMYONGHO      SCP_MST_BOD_N_V -> SCP_MST_BOD_N_V 변경
 * 2024/05/10   hsbang          확정구간 조회 일수(CONFIRM_DAY)를 펑션 FN_GET_ANL_SHIP_FROZEN_DAY_CNT] 에서 가져오도록 반영
 *
 * EX > 
	EXEC SSP0023_GET_SHIPMENT_PLAN_DETAIL @p_division_id = '40', @p_company_id='C100', @p_from_site='', @p_item_id='APCAN0023A', @p_model_id=''
		, @p_nick_name='', @p_requestor=''
		, @p_plan_start_yyyymmdd='20200529', @p_from_yyyymmdd='20200518', @p_to_yyyymmdd='20200723', @p_dbl_flag='N', @p_real_flag='Y'
		, @p_language='KO', @p_program_id='SSP0023', @p_sheet_name='Shipment Plan Detail'
		, @p_non_chk = 'Y', @p_my_model_chk ='N', @p_delegatee_chk='N', @p_part_leader_chk='N', @p_team_leader_chk='N', @p_user_id = 'khj79'
		, @debug_mode='T'
 */
 
CREATE PROCEDURE [dbo].[SSP0023_GET_SHIPMENT_PLAN_DETAIL]
	  @p_division_id			VARCHAR(10)
	, @p_company_id				NVARCHAR(10)
	, @p_from_site				NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_model_id				NVARCHAR(MAX)
	, @p_nick_name				NVARCHAR(MAX)
	, @p_requestor				NVARCHAR(MAX)
	, @p_plan_start_yyyymmdd	NVARCHAR(8)
	, @p_from_yyyymmdd			NVARCHAR(8)
	, @p_to_yyyymmdd			NVARCHAR(8)
	, @p_dbl_flag				CHAR(1)
	, @p_real_flag				CHAR(1)
	, @p_language				NVARCHAR(MAX) = 'KO'
	, @p_program_id				NVARCHAR(MAX) = 'SSP0023'
	, @p_sheet_name				NVARCHAR(MAX) = 'Shipment Plan Detail'
	, @p_non_chk				CHAR(1)
	, @p_my_model_chk			CHAR(1)
	, @p_delegatee_chk			CHAR(1)
	, @p_part_leader_chk		CHAR(1)
	, @p_team_leader_chk		CHAR(1)
	, @p_user_id				NVARCHAR(MAX)
	, @debug_mode				NVARCHAR(1)='T'
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @mDQry NVARCHAR(MAX)='';

	DECLARE  @v_division_id NVARCHAR(MAX) = '';
	DECLARE  @v_from_site NVARCHAR(MAX)   = '';
	DECLARE  @v_item_id NVARCHAR(MAX)     = '';
	DECLARE  @v_model_id NVARCHAR(MAX)     = '';
	DECLARE  @v_nick_name NVARCHAR(MAX)     = '';
	DECLARE  @v_requestor NVARCHAR(MAX)   = '';
	DECLARE @v_app_type    NVARCHAR(8) = 'SSP';

	--IN 조건으로 데이터를 가져옴
	SET @v_from_site = [dbo].FN_GET_IN_STR(@p_from_site);
	SET @v_item_id = [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_model_id = [dbo].FN_GET_IN_STR(@p_model_id);
	SET @v_nick_name = [dbo].FN_GET_IN_STR(@p_nick_name);
	SET @v_requestor = @p_requestor;


	IF @p_real_flag = 'Y'
		BEGIN
			SET @mDqry = @mDQry + '   SELECT   a.DIVISION_ID																													' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.ERP_SO_NO																														' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.SHIPMENT_STATUS																												' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.ITEM_ID																														' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.ITEM_ID_NICK_NAME																												' + char(10); 
			SET @mDqry = @mDQry + ' 		 , a.MODEL_ID																														' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.MODEL_ID_NICK_NAME 																											' + char(10); 
			SET @mDqry = @mDQry + '			 , ( SELECT DAYOFWEEK_NAME FROM  SCM_SYS_CALENDAR_M X1 WHERE X1.BASIS_YYYYMMDD = A.yyyymmdd ) as DAYOFWEEK_NAME						' + char(10);
			-- CSR
			SET @mDqry = @mDQry + '			 , convert(decimal(30,3), SHIPPING_PLAN_QTY)												as SHIPPING_PLAN_QTY								' + char(10);
			SET @mDqry = @mDQry + ' 		 , convert(decimal(30,3), isnull(a.QTY , 0))												as SHIPMENT_CONFIRM_QTY								' + char(10);
			SET @mDqry = @mDQry + '			 , convert(decimal(30,3), (SHIPPING_PLAN_QTY - isnull(a.QTY,0) ))							as GAP												' + char(10);
			-- CSR dd
			SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.YYYYMMDD,112), 23)				as SHIPMENT_DATE									' + char(10);
			SET @mDqry = @mDQry + ' 		 , ROW_NUMBER() OVER(PARTITION BY a.DIVISION_ID , a.ERP_SO_NO , a.SHIPMENT_STATUS,CELL_TYPE,a.YYYYMMDD,a.ITEM_ID,a.MODEL_ID,a.FROM_SITE,a.TO_SITE			' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 					ORDER BY a.division_id, a.shipment_status, a.ERP_SO_NO DESC, A.CELL_TYPE, a.yyyymmdd,  a.item_id, a.from_site, a.to_site) AS MERGE_NUM	' + CHAR(10);
			SET @mDqry = @mDQry + '			 , a.DOM_EXP_TYPE																as DOM_EXP											' + char(10);
			SET @mDqry = @mDQry + '			 , a.FACTORY_ID																	as FACTORY_ID										' + char(10);
			SET @mDqry = @mDQry + '			 , a.FACTORY_ID																	as FACTORY_NAME										' + char(10);
			SET @mDqry = @mDQry + '			 , a.CONFIRM_QTY_PANCAKE																											' + char(10);
			SET @mDqry = @mDQry + '			 , a.CONFIRM_QTY_JR																													' + char(10);
			SET @mDqry = @mDQry + '			 , a.CONFIRM_QTY_CELL																												' + char(10);
			SET @mDqry = @mDQry + '			 , a.CONFIRM_QTY_ROLL_LENGTH																										' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.PACKAGE_TYPE_CODE															as PACKAGE_TYPE										' + char(10);
			SET @mDqry = @mDQry + ' 		 , CEILING(CASE WHEN a.PACKAGE_TYPE_CODE = ''BX'' THEN CONFIRM_QTY_ROLL_LENGTH * isnull(a.BOX_PER_CUT ,1)									' + char(10);
			SET @mDqry = @mDQry + ' 		        WHEN a.PACKAGE_TYPE_CODE = ''SC'' THEN CONFIRM_QTY_ROLL_LENGTH * isnull(a.STEELCRATE_PER_CUT ,1)							' + char(10);
			SET @mDqry = @mDQry + ' 		        WHEN a.PACKAGE_TYPE_CODE = ''SR'' THEN CONFIRM_QTY_ROLL_LENGTH * isnull(a.STEELRACK_PER_CUT ,1)								' + char(10);
			SET @mDqry = @mDQry + ' 		   ELSE ISNULL(a.QTY,0)  END * 1000) /1000													as PACKAGE_QTY										' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_POST_OPER														as ELECTRODE_POST_OPER								' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.FROM_SITE																	as FROM_SITE										' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.TO_SITE																	as TO_SITE											' + char(10);
			SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION(a.DIVISION_ID, a.FROM_SITE),''-'')	as FROM_SITE_DESCRIPTION							' + char(10);
			SET @mDqry = @mDQry + ' 		 , isnull(dbo.FN_GET_SCM_SITE_DESCRIPTION(a.DIVISION_ID, a.TO_SITE  ),''-'')	as TO_SITE_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U3.UserName ELSE U3.UserName_E END + ''('' + a.requestor + '')'' REQUESTOR		' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.TRANSPORT_MODE																													' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.REMARKS2																														' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.REMARKS																														' + char(10);
			SET @mDqry = @mDQry + '			 , ''-''																		as CHANGE_REASON_CODE								' + char(10);
			SET @mDqry = @mDQry + '			 , ''''																			as CHANGE_REASON_DETAIL								' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.REMARKS3																														' + char(10);
			SET @mDqry = @mDQry + ' 		 , dbo.FN_GET_SITE_CUSTOMER_INFO((case when a.DIVISION_ID = ''EE'' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end), a.TO_SITE, ''SOLDTO_DESCRIPTION'' ) AS SOLDTO_DESCRIPTION   ' + char(10);
			SET @mDqry = @mDQry + ' 		 , dbo.FN_GET_SITE_CUSTOMER_INFO((case when a.DIVISION_ID = ''EE'' then a.ORIGIN_FROM_DIVISION_ID else a.DIVISION_ID end), a.TO_SITE, ''SHIPTO_DESCRIPTION'' ) AS SHIPTO_DESCRIPTION   ' + char(10);
			--* 2020-09-21   KIMYONGHO		SSP INCOTERMS 변경 작업
			--SET @mDqry = @mDQry + ' 		 , b.INCOTERMS																														' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.SSP_INCOTERMS	AS INCOTERMS																													' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.LT_TOTAL																	as LT_DAY											' + char(10);
			SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETD_DATE,112), 23)				as ETD												' + char(10);
			SET @mDqry = @mDQry + ' 		 , CONVERT(VARCHAR(10),   CONVERT(DATETIME, a.ETA_DATE,112), 23)				as ETA												' + char(10);
			SET @mDQry = @mDQry + ' 		 , CASE WHEN b.TRANSPORT_MODE = ''TRK'' then ''-'' else CONVERT(VARCHAR(10), CONVERT(DATETIME, [dbo].[FN_GET_SSP_EXPECTED_SHIP_DATE](a.DIVISION_ID, a.BOD_ID, a.YYYYMMDD), 112), 23) end as EXPECTED_SHIPPING_DATE    ' + char(10) ;
			SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U.UserName ELSE U.UserName_E END + ''('' + a.LAST_UPDATED_BY + '')'' AS UPDATED_BY ' + char(10);
			SET @mDqry = @mDQry + ' 		 , case when u.UserName is not null then a.LAST_UPDATE_DATE else null end UPDATED_DATE												' + char(10);
			SET @mDqry = @mDQry + '			 , h.CHANGE_REQ_NO																													' + char(10);
			SET @mDqry = @mDQry + ' 		 , CASE WHEN ''' +@p_language + ''' = ''KO'' THEN U2.UserName ELSE U2.UserName_E END + ''('' + mu.user_id + '')'' AS MODEL_USER		' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.CONFIRM_ID																														' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.LT_TOTAL		AS NEW_LT_DAY																									' + char(10);
			SET @mDqry = @mDQry + ' 		 , b.TRANSPORT_MODE AS NEW_TRANSPORT_MODE																							' + char(10);
			SET @mDqry = @mDQry + ' 		 , a.ERP_STATUS								' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.CHANGE_TYPE							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_ROUTE_ID							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_BOD_ID								' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_INCOTERMS							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_D_COUNTRY							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_D_PORT_CODE						' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_A_COUNTRY							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_A_PORT_CODE						' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_CUSTOMER_LT						' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_TO_COUNTRY							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_TO_CITY							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_ETA								' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_ETD								' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.NEW_SHIPMENT_DATE						' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.EDIT_REMARKS							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.EDIT_MAIN								' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.CHECK_NEED_YN							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_YN 							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.ELECTRODE_TYPE							' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.CELL_TYPE								' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 , a.ATTRIBUTE10							' + CHAR(10);
			-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			SET @mDqry = @mDQry + ' FROM																													' + char(10);
			SET @mDqry = @mDQry + ' (																														' + char(10);
			SET @mDqry = @mDQry + ' 	SELECT	DISTINCT																											' + char(10);
			SET @mDqry = @mDQry + ' 		  C.DIVISION_ID																									' + char(10);
			SET @mDqry = @mDQry + ' 		, C.ERP_SO_NO  																									' + char(10);
			SET @mDqry = @mDQry + ' 		, C.SHIPMENT_STATUS																								' + char(10);
			SET @mDqry = @mDQry + ' 		, C.ITEM_ID																										' + char(10);
			SET @mDqry = @mDQry + ' 		, C.ORIGIN_FROM_DIVISION_ID																						' + char(10);
			SET @mDqry = @mDQry + ' 		, C.ORIGIN_TO_DIVISION_ID																						' + char(10);
			SET @mDqry = @mDQry + ' 		, C.FROM_SITE																									' + char(10);
			SET @mDqry = @mDQry + ' 		, C.TO_SITE																										' + char(10);
			SET @mDqry = @mDQry + ' 		, C.REQUESTOR																									' + char(10);
			SET @mDqry = @mDQry + ' 		, C.QTY																											' + char(10);
			SET @mDqry = @mDQry + ' 		, ie.ITEM_ID_NICK_NAME																							' + char(10); 
			SET @mDqry = @mDQry + ' 		, ie.MODEL_ID																									' + char(10);
			SET @mDqry = @mDQry + ' 		, ie.MODEL_ID_NICK_NAME 																						' + char(10); 
			SET @mDqry = @mDQry + ' 		, isnull(c.ELECTRODE_TYPE,ie.ELECTRODE_TYPE)						as ELECTRODE_TYPE							' + char(10);
			SET @mDqry = @mDQry + '			, isnull(C.DOM_EXP, ie.DOM_EXP_TYPE) 													as DOM_EXP_TYPE								' + char(10);
			SET @mDqry = @mDQry + '			, CONVERT(decimal(30,3), c.QTY * isnull(ie.CONVERT_TO_PCM ,1) )				as CONFIRM_QTY_PANCAKE						' + char(10);
			SET @mDqry = @mDQry + '			, CONVERT(decimal(30,3), c.QTY * isnull(ie.CONVERT_TO_JRM ,1) )				as CONFIRM_QTY_JR							' + char(10);
			SET @mDqry = @mDQry + '			, CONVERT(decimal(30,3), c.QTY * isnull(ie.CONVERT_TO_CELL ,1) )				as CONFIRM_QTY_CELL							' + char(10);
			SET @mDqry = @mDQry + '			, CEILING(c.QTY * 1000) /1000 * isnull(ie.CONVERT_TO_PC_ROLL_LENGTH ,1) 			as CONFIRM_QTY_ROLL_LENGTH					' + char(10);
			SET @mDqry = @mDQry + '			, isnull(C.PACKAGE_TYPE_CODE, ie.PACKAGE_TYPE_CODE)					as PACKAGE_TYPE_CODE						' + char(10);
			SET @mDqry = @mDQry + '			, ie.BOX_PER_CUT																								' + char(10);
			SET @mDqry = @mDQry + '			, ie.STEELCRATE_PER_CUT																							' + char(10);
			SET @mDqry = @mDQry + '			, ie.STEELRACK_PER_CUT																							' + char(10);
			SET @mDqry = @mDQry + '			, ie.ELECTRODE_POST_OPER																						' + char(10);
			SET @mDqry = @mDQry + '			, ie.CELL_TYPE																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.YYYYMMDD																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.BOD_ID																										' + char(10);
			SET @mDqry = @mDQry + ' 		, c.REMARKS2																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.REMARKS																										' + char(10);
			SET @mDqry = @mDQry + ' 		, c.CHANGE_REQ_NO																								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.REMARKS3																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.ETD_DATE																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.ETA_DATE																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.LAST_UPDATED_BY																								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.LAST_UPDATE_DATE																							' + char(10);
			SET @mDqry = @mDQry + ' 		, c.CONFIRM_ID																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.ERP_STATUS																									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.CHANGE_TYPE 																								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.ROUTE_ID 													AS NEW_ROUTE_ID 								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.BOD_ID 														AS NEW_BOD_ID 									' + char(10);
			SET @mDqry = @mDQry + ' 		, c.INCOTERMS 													AS NEW_INCOTERMS 								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.D_COUNTRY 													AS NEW_D_COUNTRY 								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.D_PORT_CODE 												AS NEW_D_PORT_CODE 								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.A_COUNTRY 													AS NEW_A_COUNTRY  								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.A_PORT_CODE 												AS NEW_A_PORT_CODE 								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.CUSTOMER_LT 												AS NEW_CUSTOMER_LT								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.TO_COUNTRY													AS NEW_TO_COUNTRY								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.TO_CITY														AS NEW_TO_CITY 									' + char(10);
			SET @mDqry = @mDQry + ' 		, CONVERT(VARCHAR(10),	CONVERT(DATETIME, c.ETA_DATE,112), 23)	AS NEW_ETA  									' + char(10);
			SET @mDqry = @mDQry + ' 		, CONVERT(VARCHAR(10),	CONVERT(DATETIME, c.ETD_DATE,112), 23)	AS NEW_ETD  									' + char(10);
			SET @mDqry = @mDQry + ' 		, CONVERT(VARCHAR(10),	CONVERT(DATETIME, c.yyyymmdd,112), 23)	AS NEW_SHIPMENT_DATE 							' + char(10);
			SET @mDqry = @mDQry + ' 		, ''N''															AS EDIT_REMARKS 								' + char(10);
			SET @mDqry = @mDQry + ' 		, ''N''															AS EDIT_MAIN 									' + char(10);
			SET @mDqry = @mDQry + ' 		, isnull(C.CHECK_NEED_YN,''N'')									AS CHECK_NEED_YN 								' + char(10);
			SET @mDqry = @mDQry + ' 		, c.ELECTRODE_YN 																								' + char(10);
			SET @mDqry = @mDQry + ' 		, isnull(c.FACTORY_ID,ie.FACTORY_ID) 							AS FACTORY_ID									' + char(10);
			SET @mDqry = @mDQry + ' 		, ISNULL(pe.QTY,0) 												AS 	SHIPPING_PLAN_QTY							' + char(10);
			SET @mDqry = @mDQry + ' 		, C.ATTRIBUTE10	 												AS 	ATTRIBUTE10							' + char(10);
			SET @mDqry = @mDQry + ' 	FROM SSP_ANL_SHIP_CONFIRM	C WITH(NOLOCK)																						' + char(10);

			IF @P_NON_CHK != 'Y'
			BEGIN
				SET @mDqry = @mDqry+'		 JOIN SSP_MST_MODEL_USER MMU WITH(NOLOCK)															' + CHAR(10);
				SET @mDqry = @mDqry+'		   ON MMU.DIVISION_ID = C.DIVISION_ID																' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.FROM_SITE   = C.FROM_SITE																	' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.ITEM_ID     = C.ITEM_ID																	' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.VALID_YN    = ''Y''																		' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND (( MMU.USER_ID IN (SELECT CASE WHEN ''' + @p_my_model_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END				' + char(10) ;
				SET @mDqry = @mDqry+'								  UNION 																										' + char(10) ;
				SET @mDqry = @mDqry+'								 SELECT CASE WHEN ''' + @p_delegatee_chk + ''' = ''Y'' THEN USER_ID ELSE ''X'' END								' + char(10) ;
				SET @mDqry = @mDqry+'								   FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @p_user_id + ''' GROUP BY USER_ID) 	' + char(10) ;
				SET @mDqry = @mDqry+'					OR MMU.PART_LEADER = CASE WHEN ''' + @p_part_leader_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END			' + char(10) ;
				SET @mDqry = @mDqry+'					OR MMU.TEAM_LEADER = CASE WHEN ''' + @p_team_leader_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END))			' + char(10) ;
			END
			
			SET @mDqry = @mDQry + ' 	INNER JOIN SSP_MST_SITE_ITEM_EE_V IE ON ie.division_id = c.DIVISION_ID and ie.SCM_SITE_ID = c.FROM_SITE and ie.ITEM_ID  = c.ITEM_ID	' + char(10);

			SET @mDqry = @mDQry + '		LEFT OUTER JOIN SSP_ANL_SHIP_PLAN_EE PE 																					' + char(10);
			SET @mDqry = @mDQry + '		   ON PE.MEASURE = ''P_SHIP_PLAN_SIMU_ETD''																			' + char(10);
			SET @mDQry = @mDQry + ' 	  AND pe.PLAN_START_YYYYMMDD = '''+ @p_plan_start_yyyymmdd + '''													' +char(10);
			SET @mDQry = @mDQry + ' 	  AND pe.division_id = ie.DIVISION_ID and pe.SCM_SITE_ID = ie.SCM_SITE_ID and pe.ITEM_ID  = ie.ITEM_ID and pe.YYYYMMDD = c.yyyymmdd	' +char(10);
			SET @mDqry = @mDQry + ' 	WHERE 1 = 1    																										' + char(10);
			SET @mDQry = @mDQry + ' 	  AND c.CHANGE_TYPE  = ''C''																						' + char(10);
			SET @mDQry = @mDQry + ' 	  AND c.DIVISION_ID  = '''+ @p_division_id     +'''																	' + char(10);
			SET @mDQry = @mDQry + ' 	  AND c.FROM_SITE_COMPANY_ID = '''+ @p_company_id + '''																' + char(10);

			--//Model
			IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) 
				SET @mDQry = @mDQry + ' 	AND  c.ITEM_ID IN ('+ @v_item_id     +')																		' + char(10);

			IF ( @v_model_id     IS NOT NULL AND @v_model_id    != ''  ) 
				SET @mDQry = @mDQry + ' 	AND  ie.MODEL_ID IN ('+ @v_model_id     +')																		' + char(10);

			IF ( @v_nick_name     IS NOT NULL AND @v_nick_name    != ''  ) 
				SET @mDQry = @mDQry + ' 	AND  ie.ITEM_ID_NICK_NAME IN ('+ @v_nick_name     +')															' + char(10);

			IF ( @p_dbl_flag = 'Y')
				BEGIN
					SET @mDQry = @mDQry + ' 	AND  c.YYYYMMDD = '''+ @p_from_yyyymmdd     +'''															' + char(10);
				END
			ELSE
				BEGIN
					SET @mDqry = @mDQry + ' 	AND c.YYYYMMDD >= '''+ @p_from_yyyymmdd +'''	AND c.YYYYMMDD <= '''+ @p_to_yyyymmdd +'''					' + char(10);

					IF ( @v_requestor     IS NOT NULL AND @v_requestor    != ''  )
						BEGIN
							SET @mDQry = @mDQry + ' 					AND  c.REQUESTOR       IN (															' + char(10);
							SET @mDQry = @mDQry + '													SELECT DISTINCT TT1.UserID FROM (						' + char(10);
							SET @mDQry = @mDQry + '													(SELECT UserID FROM TB_FX_User							' + char(10);
							SET @mDQry = @mDQry + '													WHERE 1 = 1												' + char(10);
							SET @mDQry = @mDQry + '													AND UserName		IN (' + @v_requestor + ')			' + char(10);
							SET @mDQry = @mDQry + '													UNION ALL												' + char(10);
							SET @mDQry = @mDQry + '													SELECT UserID FROM TB_FX_User							' + char(10);
							SET @mDQry = @mDQry + '													WHERE 1 = 1												' + char(10);
							SET @mDQry = @mDQry + '													AND UserID		IN (' + @v_requestor + '))) TT1			' + char(10);
							SET @mDQry = @mDQry + '												)															' + char(10);
						END
				END --// end of dbl_flag
			IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') 
				SET @mDQry = @mDQry + ' 	AND  c.from_site IN ('+ @v_from_site   +')																		' + char(10);

		SET @mDqry = @mDQry + ' 	UNION ALL                       ' + char(10);
		SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
		SET @mDqry = @mDQry + '			  DIVISION_ID				' + char(10);
		SET @mDqry = @mDQry + '			, ERP_SO_NO					' + char(10);
		SET @mDqry = @mDQry + '			, SHIPMENT_STATUS			' + char(10);
		SET @mDqry = @mDQry + '			, ITEM_ID					' + char(10);
		SET @mDqry = @mDQry + '			, ORIGIN_FROM_DIVISION_ID	' + char(10);
		SET @mDqry = @mDQry + '			, ORIGIN_TO_DIVISION_ID		' + char(10);
		SET @mDqry = @mDQry + '			, FROM_SITE					' + char(10);
		SET @mDqry = @mDQry + '			, TO_SITE					' + char(10);
		SET @mDqry = @mDQry + '			, REQUESTOR					' + char(10);
		SET @mDqry = @mDQry + '			, QTY						' + char(10);
		SET @mDqry = @mDQry + ' 		, ITEM_ID_NICK_NAME			' + char(10); 
		SET @mDqry = @mDQry + ' 		, MODEL_ID					' + char(10);
		SET @mDqry = @mDQry + ' 		, MODEL_ID_NICK_NAME 		' + char(10); 
		SET @mDqry = @mDQry + ' 		, ELECTRODE_TYPE			' + char(10);
		SET @mDqry = @mDQry + '			, DOM_EXP_TYPE				' + char(10);
		SET @mDqry = @mDQry + '			, CONFIRM_QTY_PANCAKE		' + char(10);
		SET @mDqry = @mDQry + '			, CONFIRM_QTY_JR			' + char(10);
		SET @mDqry = @mDQry + '			, CONFIRM_QTY_CELL			' + char(10);
		SET @mDqry = @mDQry + '			, CONFIRM_QTY_ROLL_LENGTH	' + char(10);
		SET @mDqry = @mDQry + '			, PACKAGE_TYPE_CODE			' + char(10);
		SET @mDqry = @mDQry + '			, BOX_PER_CUT				' + char(10);
		SET @mDqry = @mDQry + '			, STEELCRATE_PER_CUT		' + char(10);
		SET @mDqry = @mDQry + '			, STEELRACK_PER_CUT			' + char(10);
		SET @mDqry = @mDQry + '			, ELECTRODE_POST_OPER		' + char(10);
		SET @mDqry = @mDQry + '			, CELL_TYPE					' + char(10);
		SET @mDqry = @mDQry + '			, YYYYMMDD					' + char(10);
		SET @mDqry = @mDQry + '			, BOD_ID					' + char(10);
		SET @mDqry = @mDQry + '			, REMARKS2					' + char(10);
		SET @mDqry = @mDQry + '			, REMARKS					' + char(10);
		SET @mDqry = @mDQry + '			, CHANGE_REQ_NO				' + char(10);
		SET @mDqry = @mDQry + '			, REMARKS3					' + char(10);
		SET @mDqry = @mDQry + '			, ETD_DATE					' + char(10);
		SET @mDqry = @mDQry + '			, ETA_DATE					' + char(10);
		SET @mDqry = @mDQry + '			, LAST_UPDATED_BY			' + char(10);
		SET @mDqry = @mDQry + '			, LAST_UPDATE_DATE			' + char(10);
		SET @mDqry = @mDQry + '			, CONFIRM_ID				' + char(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS ERP_STATUS		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS change_type		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ROUTE_ID		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_BOD_ID		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_INCOTERMS	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_COUNTRY	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_PORT_CODE	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_COUNTRY	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_PORT_CODE	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_CUSTOMER_LT	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_COUNTRY	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_CITY		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETA			' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETD			' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_SHIPMENT_DATE' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_REMARKS		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_MAIN		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS CHECK_NEED_YN	' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_YN		' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, FACTORY_ID				' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, SHIPPING_PLAN_QTY			' + CHAR(10);
		SET @mDqry = @mDQry + ' 		, '''' AS ATTRIBUTE10 		' + CHAR(10);
		SET @mDqry = @mDQry + ' 	FROM							' + char(10);
		SET @mDqry = @mDQry + ' 	(								' + char(10);
		SET @mDqry = @mDQry + ' 		SELECT																																		' + char(10);
		SET @mDqry = @mDQry + ' 			t0.FROM_DIVISION_ID		AS DIVISION_ID																									' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-''					AS ERP_SO_NO																									' + char(10);
		SET @mDqry = @mDQry + ' 			, ''P''					AS SHIPMENT_STATUS																								' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.ITEM_ID																															' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.FROM_DIVISION_ID	AS ORIGIN_FROM_DIVISION_ID																						' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.TO_DIVISION_ID		AS ORIGIN_TO_DIVISION_ID																						' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.FROM_SITE			AS FROM_SITE																									' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.TO_SITE			AS TO_SITE																										' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.LAST_UPDATED_BY	AS REQUESTOR																									' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.QTY																																' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.ETD_DATE			AS YYYYMMDD																										' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.BOD_ID																																' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS2																														' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS																														' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS CHANGE_REQ_NO																												' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS REMARKS3																														' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.ETD_DATE AS ETD_DATE																												' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.ETA_DATE AS ETA_DATE																												' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.LAST_UPDATED_BY																													' + char(10);
		SET @mDqry = @mDQry + ' 			, t0.LAST_UPDATE_DATE																													' + char(10);
		SET @mDqry = @mDQry + ' 			, ''-'' AS CONFIRM_ID																													' + char(10);
		--SET @mDqry = @mDQry + ' 			, CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](T0.FROM_DIVISION_ID ,T0.FROM_SITE) , CONVERT(DATETIME, ''' + @p_plan_start_yyyymmdd + ''' ,112)) ,112) AS frozen_yyyymmdd	' + char(10);
		SET @mDqry = @mDqry + '       	    , CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](''' + @v_app_type + ''', T0.FROM_DIVISION_ID,T0.FROM_SITE, ''' + @p_plan_start_yyyymmdd + ''') , CONVERT(DATETIME, '''+ @p_plan_start_yyyymmdd + ''' ,112)) ,112) AS frozen_yyyymmdd' + CHAR(10);
		SET @mDqry = @mDQry + ' 			, ie.FACTORY_ID																															' + char(10);
		SET @mDqry = @mDQry + ' 			, ie.ITEM_ID_NICK_NAME																													' + char(10); 
		SET @mDqry = @mDQry + ' 			, ie.MODEL_ID																															' + char(10);
		SET @mDqry = @mDQry + ' 			, ie.MODEL_ID_NICK_NAME 																												' + char(10); 
		SET @mDqry = @mDQry + ' 			, ie.ELECTRODE_TYPE																														' + char(10);
		SET @mDqry = @mDQry + '				, ie.DOM_EXP_TYPE																														' + char(10);
		SET @mDqry = @mDQry + '				, convert(int, t0.QTY * isnull(ie.CONVERT_TO_PCM ,1) )				as CONFIRM_QTY_PANCAKE												' + char(10);
		SET @mDqry = @mDQry + '				, convert(int, t0.QTY * isnull(ie.CONVERT_TO_JRM ,1) )				as CONFIRM_QTY_JR													' + char(10);
		SET @mDqry = @mDQry + '				, convert(int, t0.QTY * isnull(ie.CONVERT_TO_CELL ,1) )				as CONFIRM_QTY_CELL													' + char(10);
		SET @mDqry = @mDQry + '				, CEILING(t0.QTY * isnull(ie.CONVERT_TO_PC_ROLL_LENGTH ,1) )		as CONFIRM_QTY_ROLL_LENGTH											' + char(10);
		SET @mDqry = @mDQry + '				, ie.PACKAGE_TYPE_CODE												as PACKAGE_TYPE_CODE												' + char(10);
		SET @mDqry = @mDQry + '				, ie.BOX_PER_CUT																														' + char(10);
		SET @mDqry = @mDQry + '				, ie.STEELCRATE_PER_CUT																													' + char(10);
		SET @mDqry = @mDQry + '				, ie.STEELRACK_PER_CUT																													' + char(10);
		SET @mDqry = @mDQry + '				, ie.ELECTRODE_POST_OPER																												' + char(10);
		SET @mDqry = @mDQry + '				, ie.CELL_TYPE																															' + char(10);
		SET @mDqry = @mDQry + ' 		    , ISNULL(pe.QTY,0) 													as 	SHIPPING_PLAN_QTY												' + char(10);

		SET @mDqry = @mDQry + ' 		 FROM SSP_ANL_SHIP_REQ_EE T0 WITH(NOLOCK)																												' + char(10);

		IF @P_NON_CHK != 'Y'
			BEGIN
				SET @mDqry = @mDqry+'		 JOIN SSP_MST_MODEL_USER MMU WITH(NOLOCK)															' + CHAR(10);
				SET @mDqry = @mDqry+'		   ON MMU.DIVISION_ID = T0.FROM_DIVISION_ID																' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.FROM_SITE   = T0.FROM_SITE																	' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.ITEM_ID     = T0.ITEM_ID																	' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.VALID_YN    = ''Y''																		' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND (( MMU.USER_ID IN (SELECT CASE WHEN ''' + @p_my_model_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END				' + char(10) ;
				SET @mDqry = @mDqry+'								  UNION 																										' + char(10) ;
				SET @mDqry = @mDqry+'								 SELECT CASE WHEN ''' + @p_delegatee_chk + ''' = ''Y'' THEN USER_ID ELSE ''X'' END								' + char(10) ;
				SET @mDqry = @mDqry+'								   FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @p_user_id + ''' GROUP BY USER_ID) 	' + char(10) ;
				SET @mDqry = @mDqry+'					OR MMU.PART_LEADER = CASE WHEN ''' + @p_part_leader_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END			' + char(10) ;
				SET @mDqry = @mDqry+'					OR MMU.TEAM_LEADER = CASE WHEN ''' + @p_team_leader_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END))			' + char(10) ;
			END

		SET @mDqry = @mDQry + ' 		INNER JOIN  SCP_MST_BOD_N_V tt1 WITH(NOLOCK) ON t0.FROM_DIVISION_ID = tt1.division_id  AND t0.bod_id = tt1.bod_id												' + char(10);

		SET @mDqry = @mDQry + '			INNER JOIN SSP_MST_SITE_ITEM_EE_V IE WITH(NOLOCK) ON ie.division_id = t0.FROM_DIVISION_ID and ie.SCM_SITE_ID = t0.FROM_SITE and ie.ITEM_ID  = t0.ITEM_ID	' + char(10);

		SET @mDqry = @mDQry + '			LEFT OUTER JOIN SSP_ANL_SHIP_PLAN_EE PE WITH(NOLOCK)																											' + char(10);
		SET @mDqry = @mDQry + '			   ON pe.MEASURE = ''P_SHIP_PLAN_SIMU_ETD''																									' + char(10);
		SET @mDQry = @mDQry + ' 		  AND pe.PLAN_START_YYYYMMDD = '''+ @p_plan_start_yyyymmdd + '''		' +char(10);
		SET @mDQry = @mDQry + ' 		  AND pe.division_id = ie.DIVISION_ID and pe.SCM_SITE_ID = ie.SCM_SITE_ID and pe.ITEM_ID  = ie.ITEM_ID and pe.YYYYMMDD = T0.ETD_DATE		' +char(10);

		SET @mDqry = @mDQry + ' 	WHERE 1 = 1																																		' + char(10);
		SET @mDQry = @mDQry + ' 	AND  t0.FROM_DIVISION_ID = '''+ @p_division_id +'''																								' + char(10);
		SET @mDQry = @mDQry + ' 	AND  t0.FROM_COMPANY_ID  = '''+ @p_company_id  +'''																								' + char(10);

		IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) 
			SET @mDQry = @mDQry + ' 	AND  t0.ITEM_ID       IN ('+ @v_item_id     +')																								' + char(10);

		IF ( @v_model_id     IS NOT NULL AND @v_model_id    != ''  ) 
				SET @mDQry = @mDQry + ' 	AND  t0.MODEL_ID IN ('+ @v_model_id     +')																								' + char(10);

		IF ( @v_nick_name     IS NOT NULL AND @v_nick_name    != ''  ) 
				SET @mDQry = @mDQry + ' 	AND  ie.ITEM_ID_NICK_NAME IN ('+ @v_nick_name     +')																					' + char(10);

		IF ( @p_dbl_flag = 'Y')
			BEGIN
				SET @mDQry = @mDQry + ' 	AND  t0.ETD_DATE = '''+ @p_from_yyyymmdd     +'''																						' + char(10);
			END
		ELSE
			BEGIN
				SET @mDqry = @mDQry + ' 	AND t0.ETD_DATE >= '''+ @p_from_yyyymmdd +'''		AND t0.ETD_DATE <= '''+ @p_to_yyyymmdd +'''											' + char(10);
			END -- end of dbl_flag
		IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') 
			SET @mDQry = @mDQry + ' 					AND  t0.FROM_SITE     IN ('+ @v_from_site   +')																				' + char(10);
		SET @mDqry = @mDQry + '		) t																																				' + char(10);
		SET @mDqry = @mDQry + ' 	WHERE 1 = 1																																		' + char(10);
		SET @mDqry = @mDQry + ' 	AND t.YYYYMMDD >= t.FROZEN_YYYYMMDD																												' + char(10);
		SET @mDqry = @mDQry + ' ) a																																					' + char(10);
		SET @mDqry = @mDQry + ' INNER JOIN   SCP_MST_BOD_N_V b WITH(NOLOCK)																															' + char(10);
		SET @mDqry = @mDQry + ' 	ON (CASE WHEN a.DIVISION_ID = ''EE'' THEN a.ORIGIN_FROM_DIVISION_ID ELSE a.DIVISION_ID END) = b.division_id  AND a.bod_id = b.bod_id			' + char(10);

		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U ON a.LAST_UPDATED_BY = u.UserID AND U.UseYN = ''Y''																	' + char(10);

		SET @mDqry = @mDQry + ' LEFT OUTER JOIN (SELECT CONFIRM_ID, CHANGE_REQ_NO FROM(																								' + char(10);
		SET @mDqry = @mDQry + '				SELECT CONFIRM_ID ,CHANGE_REQ_NO																										' + char(10);
		SET @mDqry = @mDQry + '					,ROW_NUMBER() OVER(PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) NUM															' + char(10);
		SET @mDqry = @mDQry + '				FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE WITH(NOLOCK)																									' + char(10);
		SET @mDqry = @mDQry + '				WHERE VALID_YN = ''Y''																													' + char(10);
		SET @mDqry = @mDQry + '			) A WHERE NUM = 1) h on h.confirm_id = a.confirm_id																							' + char(10);

		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_MST_MODEL_USER mu on mu.division_id = a.origin_from_division_id and mu.from_site = a.from_site and mu.item_id = a.item_id and mu.valid_yn = ''Y''  ' + char(10);

		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U2 ON mu.user_id = u2.UserID AND U2.UseYN = ''Y''																		' + char(10);

		SET @mDqry = @mDQry + ' LEFT OUTER JOIN TB_FX_User U3 ON a.requestor = u3.UserID AND U3.UseYN = ''Y''																		' + char(10);

		SET @mDqry = @mDQry + ' LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ T1																										' + char(10);
		SET @mDqry = @mDQry + ' ON h.CHANGE_REQ_NO = T1.CHANGE_REQ_NO																												' + char(10);
		SET @mDqry = @mDQry + ' 	  WHERE 1=1																																		' + char(10);
		SET @mDqry = @mDQry + ' 		AND (a.shipment_status IS NOT NULL AND isnull(a.shipment_status,'''') != '''')																' + char(10);
		SET @mDqry = @mDQry + ' 		AND a.qty > 0																																' + char(10);
		SET @mDqry = @mDQry + ' ORDER BY a.division_id,   a.yyyymmdd,  a.item_id, a.from_site, a.to_site , a.ERP_SO_NO DESC							' + char(10);

		END --// END OF real_flag = 'Y' 
	ELSE
	BEGIN
	
		SET @mDqry = @mDQry + ' SELECT  AA.*  FROM      																										' + char(10);
			SET @mDqry = @mDQry + '  ( ' + char(10);
			SET @mDqry = @mDQry + ' 	SELECT							' + char(10);
			SET @mDqry = @mDQry + '			DIVISION_ID					' + char(10);
			SET @mDqry = @mDQry + '			, ERP_SO_NO                 ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPMENT_STATUS           ' + char(10);
			SET @mDqry = @mDQry + '			, PROJECT_CODE              ' + char(10);
			SET @mDqry = @mDQry + '			, PROJECT_NAME              ' + char(10);
			SET @mDqry = @mDQry + '			, FCST_TYPE                 ' + char(10);
			SET @mDqry = @mDQry + '			, ITEM_ID                   ' + char(10);
			SET @mDqry = @mDQry + '			, NICK_NAME                 ' + char(10);
			SET @mDqry = @mDQry + '			, MODEL_ID                  ' + char(10);
			SET @mDqry = @mDQry + '			, MODEL_ID_NICK_NAME AS ITEM_ID_NICK_NAME        ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPMENT_DATE             ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPPING_PLAN_QTY			' + char(10);
			SET @mDqry = @mDQry + '			, SHIPMENT_CONFIRM_QTY      ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS                   ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS2                  ' + char(10);
			SET @mDqry = @mDQry + '			, REMARKS3					' + char(10);
			SET @mDqry = @mDQry + '			, FROM_SITE                 ' + char(10);
			SET @mDqry = @mDQry + '			, FROM_SITE_DESCRIPTION     ' + char(10);
			SET @mDqry = @mDQry + '			, TO_SITE                   ' + char(10);
			SET @mDqry = @mDQry + '			, TO_SITE_DESCRIPTION       ' + char(10);
			SET @mDqry = @mDQry + ' 		, TO_SITE_SOLDTO_CODE		' + char(10);
			SET @mDqry = @mDQry + ' 		, TO_SITE_SHIPTO_CODE		' + char(10);
			SET @mDqry = @mDQry + '			, SOLDTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, SHIPTO_DESCRIPTION        ' + char(10);
			SET @mDqry = @mDQry + '			, BOD_ID                    ' + char(10);
			SET @mDqry = @mDQry + '			, INCOTERMS					' + char(10);
			SET @mDqry = @mDQry + '			, TRANSPORT_MODE            ' + char(10);
			SET @mDqry = @mDQry + '			, LT_DAY					' + char(10);
			SET @mDqry = @mDQry + '			, ETD						' + char(10);
			SET @mDqry = @mDQry + '			, ETA						' + char(10);
			SET @mDqry = @mDQry + '			, EXPECTED_SHIPPING_DATE    ' + char(10);
			SET @mDqry = @mDQry + '			, CONFIRM_ID                ' + char(10);
			SET @mDqry = @mDQry + '			, UPDATED_BY           ' + char(10);
			SET @mDqry = @mDQry + '			, UPDATED_DATE          ' + char(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ERP_STATUS ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS change_type ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ROUTE_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_BOD_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_INCOTERMS ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_COUNTRY ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_D_PORT_CODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_COUNTRY ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_A_PORT_CODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_CUSTOMER_LT ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_COUNTRY ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TO_CITY ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETA ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_ETD ' + CHAR(10);
			SET @mDqry = @mDQry + '			, ''-'' AS NEW_LT_DAY					' + char(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_TRANSPORT_MODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS NEW_SHIPMENT_DATE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_REMARKS ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS EDIT_MAIN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS CHECK_NEED_YN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, END_CUSTOMER AS END_CUSTOMER ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_YN ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ELECTRODE_TYPE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_FROM_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, ''-'' AS ORIGIN_TO_DIVISION_ID ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, CHANGE_REQ_NO AS CHANGE_REQ_NO ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, MODEL_USER AS MODEL_USER   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, MTK_OWNER AS MTK_OWNER   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, REQUESTOR AS REQUESTOR   ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, CHANGE_REASON_CODE ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, CHANGE_REASON_DETAIL ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, DOM_EXP AS DOM_EXP ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, DAYOFWEEK_NAME AS DAYOFWEEK_NAME ' + CHAR(10);
			SET @mDqry = @mDQry + ' 		, GAP AS GAP ' + CHAR(10);
			SET @mDqry = @mDQry + '			, CONFIRM_QTY_ROLL_LENGTH							' + char(10);
			SET @mDqry = @mDQry + '			, PACKAGE_TYPE										' + char(10);
			SET @mDqry = @mDQry + '			, PACKAGE_QTY										' + char(10);
			SET @mDqry = @mDQry + '			, ELECTRODE_POST_OPER								' + char(10);
			SET @mDqry = @mDQry + '			, CONFIRM_QTY_PANCAKE								' + char(10);
			SET @mDqry = @mDQry + '			, CONFIRM_QTY_JR									' + char(10);
			SET @mDqry = @mDQry + '			, CONFIRM_QTY_CELL									' + char(10);
			SET @mDqry = @mDQry + '			, CELL_TYPE											' + char(10);
			SET @mDqry = @mDQry + '			, FACTORY_ID											' + char(10);
			SET @mDqry = @mDQry + ' 		 , ROW_NUMBER() OVER(PARTITION BY T0.DIVISION_ID , T0.ERP_SO_NO , T0.SHIPMENT_STATUS, T0.CELL_TYPE, T0.SHIPMENT_DATE, T0.ITEM_ID, T0.MODEL_ID, T0.FROM_SITE, T0.TO_SITE			' + CHAR(10);
			SET @mDqry = @mDQry + ' 		 					ORDER BY T0.division_id, T0.shipment_status, T0.ERP_SO_NO DESC, T0.CELL_TYPE, T0.SHIPMENT_DATE,  T0.item_id, T0.from_site, T0.to_site) AS MERGE_NUM	' + CHAR(10);

			SET @mDqry = @mDQry + ' 	FROM							' + char(10);
			SET @mDqry = @mDQry + ' 	(								' + char(10);
			SET @mDqry = @mDQry + '			SELECT TT0.DIVISION_ID										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ERP_SO_NO											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SHIPMENT_STATUS									' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ITEM_ID											' + char(10);
			SET @mDqry = @mDQry + '			    , TT0.NICK_NAME											' + char(10);
			SET @mDqry = @mDQry + '			    , TT0.MODEL_ID											' + char(10);
			SET @mDqry = @mDQry + '			    , TT0.MODEL_ID_NICK_NAME								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ORIGIN_FROM_DIVISION_ID							' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ORIGIN_TO_DIVISION_ID								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.FROM_SITE											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.FROM_SITE_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.PROJECT_CODE										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.PROJECT_NAME										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REQUESTOR											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SHIPMENT_CONFIRM_QTY								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SHIPPING_PLAN_QTY									' + char(10);
			SET @mDqry = @mDQry + '			    , CONVERT(INT, (TT0.SHIPPING_PLAN_QTY - ISNULL(TT0.SHIPMENT_CONFIRM_QTY,0) ))	AS GAP	' + char(10);
			SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.YYYYMMDD,112), 23) AS SHIPMENT_DATE		' + char(10);
			SET @mDqry = @mDQry + '				, TT0.BOD_ID											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.INCOTERMS											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TRANSPORT_MODE									' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE_SOLDTO_CODE								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.TO_SITE_SHIPTO_CODE								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SOLDTO_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.SHIPTO_DESCRIPTION								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REMARKS2											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REMARKS											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CHANGE_REQ_NO										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.REMARKS3											' + char(10);
			SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.ETD,112), 23) AS ETD	' + char(10);
			SET @mDqry = @mDQry + '				, CONVERT(VARCHAR(10),   CONVERT(DATETIME, TT0.ETA,112), 23) AS ETA	' + char(10);
			SET @mDqry = @mDQry + '				, TT0.EXPECTED_SHIPPING_DATE							' + char(10);
			SET @mDqry = @mDQry + '				, TT0.LT_DAY						AS LT_DAY			' + char(10);
			SET @mDqry = @mDQry + '				, TT0.UPDATED_BY					AS UPDATED_BY		' + char(10);
			SET @mDqry = @mDQry + '				, TT0.UPDATED_DATE					AS UPDATED_DATE		' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CONFIRM_ID					AS CONFIRM_ID       ' + char(10);                                                                                                                                                                                                 
			SET @mDqry = @mDQry + '				, TT0.FCST_TYPE											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.END_CUSTOMER										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.MTK_OWNER											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.MODEL_USER										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.DOM_EXP											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.DAYOFWEEK_NAME									' + char(10);

			SET @mDqry = @mDQry + '				, TT0.CONFIRM_QTY_ROLL_LENGTH							' + char(10);
			SET @mDqry = @mDQry + '				, TT0.PACKAGE_TYPE										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.PACKAGE_QTY										' + char(10);
			SET @mDqry = @mDQry + '				, TT0.ELECTRODE_POST_OPER								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CONFIRM_QTY_PANCAKE								' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CONFIRM_QTY_JR									' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CONFIRM_QTY_CELL									' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CELL_TYPE											' + char(10);

			SET @mDqry = @mDQry + '				, TT0.CHANGE_REASON_CODE											' + char(10);
			SET @mDqry = @mDQry + '				, TT0.CHANGE_REASON_DETAIL											' + char(10);

			SET @mDqry = @mDQry + '				, TT0.FACTORY_ID											' + char(10);

			
			
			SET @mDqry = @mDQry + '			FROM SSP_ANL_SHIP_PLAN_ALL TT0 WITH(NOLOCK)					' + char(10);
			IF @P_NON_CHK != 'Y'
			BEGIN
				SET @mDqry = @mDqry+'		 JOIN SSP_MST_MODEL_USER MMU WITH(NOLOCK)															' + CHAR(10);
				SET @mDqry = @mDqry+'		   ON MMU.DIVISION_ID = C.DIVISION_ID																' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.FROM_SITE   = C.FROM_SITE																	' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.ITEM_ID     = C.ITEM_ID																	' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND MMU.VALID_YN    = ''Y''																		' + CHAR(10) ;
				SET @mDqry = @mDqry+'		  AND (( MMU.USER_ID IN (SELECT CASE WHEN ''' + @p_my_model_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END				' + char(10) ;
				SET @mDqry = @mDqry+'								  UNION 																										' + char(10) ;
				SET @mDqry = @mDqry+'								 SELECT CASE WHEN ''' + @p_delegatee_chk + ''' = ''Y'' THEN USER_ID ELSE ''X'' END								' + char(10) ;
				SET @mDqry = @mDqry+'								   FROM SSP_MST_DELEGATE WITH(NOLOCK) WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' + @p_user_id + ''' GROUP BY USER_ID) 	' + char(10) ;
				SET @mDqry = @mDqry+'					OR MMU.PART_LEADER = CASE WHEN ''' + @p_part_leader_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END			' + char(10) ;
				SET @mDqry = @mDqry+'					OR MMU.TEAM_LEADER = CASE WHEN ''' + @p_team_leader_chk + ''' = ''Y'' THEN ''' + @p_user_id + ''' ELSE ''X'' END))			' + char(10) ;
			END
			
			SET @mDqry = @mDQry + '			WHERE 1=1													' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.PLAN_START_YYYYMMDD = '+@p_plan_start_yyyymmdd +'	' + char(10);
			SET @mDQry = @mDQry + ' 		  AND TT0.DIVISION_ID = '''+ @p_division_id +'''			' + char(10);																						
			SET @mDQry = @mDQry + ' 		  AND TT0.COMPANY_ID  = '''+ @p_company_id  +'''			' + char(10);		
			SET @mDQry = @mDQry + '			  AND TT0.SHIPMENT_CONFIRM_QTY > 0							' + char(10);
			SET @mDQry = @mDQry + '			  AND TT0.OPERATION_GROUP = ''E''							' + char(10);
			SET @mDqry = @mDQry + '			  AND TT0.YYYYMMDD >= '+ @p_from_yyyymmdd +' AND TT0.YYYYMMDD <= '+ @p_to_yyyymmdd +' ' + char(10);
	
			IF ( @v_division_id IS NOT NULL AND @v_division_id  != '')	SET @mDQry = @mDQry + ' AND  TT0.DIVISION_ID   IN ('+ @v_division_id +')'+char(10);  
			IF ( @v_item_id     IS NOT NULL AND @v_item_id		!= '')	SET @mDQry = @mDQry + ' AND  TT0.ITEM_ID       IN ('+ @v_item_id     +')'+char(10); 
			IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '')	SET @mDQry = @mDQry + ' AND  TT0.FROM_SITE     IN ('+ @v_from_site   +')'+char(10); 
			
			IF ( @v_model_id    IS NOT NULL AND @v_model_id     != ''  ) SET @mDQry = @mDQry + ' AND  TT0.MODEL_ID	  IN ('+ @v_model_id     +')' + char(10);
			IF ( @v_nick_name   IS NOT NULL AND @v_nick_name    != ''  ) SET @mDQry = @mDQry + ' AND  TT0.MODEL_ID_NICK_NAME IN ('+ @v_nick_name     +')																					' + char(10);
			
			IF ( @p_dbl_flag = 'Y')
				BEGIN
					SET @mDQry = @mDQry + ' 	AND  TT0.YYYYMMDD = '''+ @p_from_yyyymmdd     +'''															' + char(10);
				END
			ELSE
				BEGIN
					SET @mDqry = @mDQry + ' 	AND TT0.YYYYMMDD >= '''+ @p_from_yyyymmdd +'''	AND TT0.YYYYMMDD <= '''+ @p_to_yyyymmdd +'''					' + char(10);

					IF ( @v_requestor   IS NOT NULL AND @v_requestor    != '')
					BEGIN
						SET @mDQry = @mDQry + ' AND  TT0.REQUESTOR IN (																				' + char(10);
						SET @mDQry = @mDQry + '						  SELECT DISTINCT TT1.UserID FROM (												' + char(10);
						SET @mDQry = @mDQry + '						  (SELECT UserID FROM TB_FX_User with(nolock)									' + char(10);
						SET @mDQry = @mDQry + '						  WHERE 1 = 1																	' + char(10);
						SET @mDQry = @mDQry + '						  AND UserName		IN (' + @v_requestor + ')									' + char(10);
						SET @mDQry = @mDQry + '						  UNION ALL ' + char(10);
						SET @mDQry = @mDQry + '						  SELECT UserID FROM TB_FX_User with(nolock) ' + char(10) ;
						SET @mDQry = @mDQry + '						  WHERE 1 = 1 ' + char(10) ;
						SET @mDQry = @mDQry + '						  AND UserID		IN (' + @v_requestor + '))) TT1 ' +char(10);
						SET @mDQry = @mDQry + '						) ' + char(10);
					END 
				END --// end of dbl_flag

			
			SET @mDqry = @mDQry + '		) AS  T0 ' + char(10);
			SET @mDqry = @mDQry + ' ) AS  AA ' + char(10);

			SET @mDqry = @mDQry + ' ORDER BY AA.division_id, AA.shipment_status, AA.shipment_date,  AA.item_id, AA.ERP_SO_NO DESC , AA.from_site, AA.to_site, AA.project_code, AA.fcst_type     ' + char(10);
	END

	IF( @debug_mode ='T')
	BEGIN				
		DECLARE @POS INT =1;
		DECLARE @LEN INT =LEN(@mDqry);
		WHILE @POS <= @LEN
		BEGIN
			PRINT SUBSTRING(@mDqry,@POS,4000);
			SET @POS = @POS+4000;
		END;
	END;

	EXEC(@mDqry);

END
