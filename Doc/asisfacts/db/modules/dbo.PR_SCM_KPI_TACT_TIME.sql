


/*
 * Program ID   : PR_SCM_KPI_TACT_TIME
 * Description  : Tact Time 준수율 데이타 생성 : 매주 화요일 새벽 당주 정보 생성
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019.04.17	hwyoon			Initial Release [CSR ID:3977249] [지표정의] GSCM Portal - SCP HI 지표 산출 
 * 2021.10.06   sclee.lee       PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 : RTF개선
 * 2022.03.25   sclee           PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.11.15   KSG             PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 2023.03.23	hrkim			[PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 */
 
CREATE PROCEDURE [dbo].[PR_SCM_KPI_TACT_TIME]
(
   @p_basis_yyyymmdd  NVARCHAR(8)=NULL
 )
 AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch_TACTTIME';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCM_KPI_TACT_TIME';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCM_KPI_TACT_TIME'; 
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' PR_SCM_KPI_TACT_TIME INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    

	-- 업무용 변수
	DECLARE @v_basis_yyyymmdd  NVARCHAR(8);  -- 기준 일자  
	DECLARE @v_plan_id         NVARCHAR(8);  -- 
	DECLARE @rows INT;         

    -- PJ20216891
	-- DECLARE @p_division_id nvarchar(max) = '40,81,82';
	DECLARE @p_division_id nvarchar(max) = ''; -- '40,81,82,81_UC';
	DECLARE @v_division_id nvarchar(max) = '';
	
	-- [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
	SELECT  @p_division_id = -- 40,81,82,81_HM,81_UC
							STUFF(( SELECT ',' +  division_id
									 FROM SCM_MST_DIVISION WITH(NOLOCK) 
									WHERE 1=1
									  AND ATTRIBUTE3 != 'EE'
									  AND VALID_YN	  = 'Y'
									ORDER BY SUBSTRING(DIVISION_ID, 1,1)
											,LEN(DIVISION_ID)
											,DIVISION_ID 
								  FOR XML PATH('')), 1, 1,'')

	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0; 
	DECLARE @v_delimiter NVARCHAR(1) = ',';

	DECLARE @p_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @p_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_result       AS NVARCHAR(8)='';
	DECLARE @v_to_result         AS NVARCHAR(8)='';
	DECLARE @v_unit_date         AS NVARCHAR(8)='';  --현재일 기준의 주(week)의 시작일자

	DECLARE @p_status			 NVARCHAR(6)=NULL


	BEGIN TRY
		BEGIN
			------------------------------------------------------------------------------------
			-- 매주 일요일에 월요일 일자로 적재한다. 
			------------------------------------------------------------------------------------
			-- 기준일자 설정
			IF @p_basis_yyyymmdd IS NOT NULL
				BEGIN
					SET @v_basis_yyyymmdd = @p_basis_yyyymmdd;
				END
			ELSE
				BEGIN
					SET @v_basis_yyyymmdd = convert(VARCHAR(8), GETDATE(),112) --현재일자
				END
			;

			-- from_yyyymmdd는 현재일자의 월요일로 강제설정
			set @p_from_yyyymmdd= (SELECT convert(VARCHAR(8), dateadd(dd, -(dayofweek_no-1),basis_yyyymmDD),112) as basis_start_date
									FROM (
										SELECT (CASE WHEN DAYOFWEEK_NO -1 =0 THEN 7 ELSE dayofweek_no -1 END ) dayofweek_no 
												,CONVERT(DATETIME, basis_yyyymmDD) as basis_yyyymmDD
												,DAYOFWEEK
										FROM scm_sys_calendar_m 
										WHERE basis_yyyymmdd =@v_basis_yyyymmdd
  										) f 
									) ;
			-- 52주 설정
			SET @p_to_yyyymmdd =  convert(varchar, dateadd(day,-1, dateadd(day, 364, convert(datetime,@p_from_yyyymmdd))) ,112);

			-- 주차 데이터 삭제
			DELETE FROM SCM_KPI_TACT_TIME
			WHERE PLAN_START_YYYYMMDD=@p_from_yyyymmdd

			/********************************************************************************      
			* 임시테이블만들기 - 본 테이블      
			********************************************************************************/      
			IF OBJECT_ID('tempdb..#TblDynamicPivot_TactTime') IS NOT NULL      
			DROP TABLE #TblDynamicPivot_TactTime; 

			CREATE TABLE #TblDynamicPivot_TactTime (
				 DIVISION_ID		NVARCHAR(30)	
				,PLANT_SITE_ID		NVARCHAR(30)
				,OPERATION_GROUP_ID		NVARCHAR(10)
				,ITEM_ID		NVARCHAR(50)
				,VALID_TYPE		NVARCHAR(10)
			);
			
			/********************************************************************************
			* 임시테이블만들기
			********************************************************************************/
			IF OBJECT_ID('tempdb..#TblDynamicPivot_Fcst') IS NOT NULL	
			DROP TABLE #TblDynamicPivot_Fcst;

			CREATE TABLE #TblDynamicPivot_Fcst (
				 DIVISION_ID		NVARCHAR(60)	
				,ITEM_ID			NVARCHAR(100)
			);

			SET @v_division_id = @p_division_id;

			--FCST 수요 아이템 조회
			INSERT INTO #TblDynamicPivot_Fcst
			SELECT distinct aa.division_id, T.ITEM_ID 
			FROM   dm_pln_mkt_fcst aa WITH (NOLOCK)
			JOIN scm_mst_site mse with(nolock) on mse.VALID_YN='Y' 

                                               /* PJ20214907 */
											   -- 20221115 PJ20216994 MKT FCST 조건 변경
											   --and aa.measure         = IIF(mse.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST') 
											   --and aa.measure         = IIF(ISNULL(mse.operation_group, '') = 'W', 'AS_In_Req', IIF(ISNULL(mse.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST'))
                                               AND aa.measure = CASE WHEN ISNULL(mse.operation_group, '') = 'W' THEN 'AS_In_Req' WHEN mse.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(aa.attribute10, '') = '' THEN 'MKT_FCST' END
											   AND aa.scm_site_id = mse.scm_site_id 
											   AND aa.division_id = mse.division_id
			JOIN DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK) ON aa.DIVISION_ID = b.division_id and aa.ITEM_ID=b.MODEL_ID
			JOIN SCP_MST_FINAL_ITEM T WITH(NOLOCK) ON b.DIVISION_ID=t.DIVISION_ID and b.CHILD_ITEM_ID=t.ITEM_ID
			WHERE 1=1
			AND    aa.yyyymmdd       >= @p_from_yyyymmdd--CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND    aa.yyyymmdd       <= @p_to_yyyymmdd--CONVERT(CHAR(8), DATEADD(DD, 7*51, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
			AND	   aa.yyyymmdd != '' and aa.yyyymmdd is not null
			AND    aa.qty            >  0
			and	   aa.DIVISION_ID IN (SELECT token FROM dbo.String_Split(@v_division_id		,','))--= @v_division_id
			group by aa.division_id	, T.ITEM_ID  
			;

			--T/T 입력대상 & 입력완료건수 조회
			INSERT INTO #TblDynamicPivot_TactTime
			SELECT DISTINCT
				   m.division_id
				  ,m.plant_site_id
				  ,m.operation_group_id
				  ,m.item_id
				  ,CASE WHEN m.line_id IS NULL OR m.line_id='' THEN 'NG' ELSE 'OK' END AS VALID_TYPE
			FROM(
						-- Tact Time Master 조회
						SELECT distinct 
							   a.division_id
							  ,a.plant_site_id
							  ,dbo.fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id -- item_sn 테이블에 미등록된 site 경우 값을 가져올 수 없어 function을 통해 가져옴
							  ,a.operation_id
							  ,i.site_id AS model_site
							  ,a.item_id
							  ,i.nick_name
							  ,a.line_id
							  ,a.priority
							  ,a.tact_time
							  ,ROUND(a.yield*100,2) AS yield
							  , ((1440 - isnull( d.loss_time_min,0) - isnull( d.setup_loss_time_min,0) ) *60 / a.tact_time ) * isnull(a.uom_convert_value,1) AS daily_capacity
							  ,a.item_uom
							  ,a.uom_convert_value
							  ,a.valid_yn
							  ,NULL AS BOM_MIN_DUE_DATE
							  ,a.created_by
							  ,a.creation_date
							  ,a.last_updated_by
							  ,a.last_update_date
							  , 'M' as input_status
							  , isnull((select top 1 'Y'
										from SCP_MST_TACT_TIME_EXCEPT x 
										INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
													FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
													WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
													AND    b.valid_yn    = 'Y'
													AND    b.segment3    = 'Y' -- Capa 세부 공정 여부						
												) c ON a.operation_id = c.segment4
										where x.division_id=a.division_id 
										and x.plant_site_id=a.plant_site_id 
										and x.operation_id=a.operation_id
										and x.item_id=a.item_id
										and x.line_id=a.line_id
										--and x.use_yn='Y'
										),'N') as except_yn
								,ISNULL((SELECT COUNT(LS.ACTIVE_FLAG) FROM SCM_MST_LINE_SN LS 
															  WHERE LS.COMPANY_ID=B.COMPANY_ID AND LS.DIVISION_ID=A.DIVISION_ID AND LS.SITE_ID=B.SITE_ID AND LS.PLANT_ID=B.PLANT_ID 
																AND LS.OPERATION_ID=A.OPERATION_ID AND LS.LINE_ID=A.LINE_ID AND LS.ACTIVE_FLAG='Y'), 0) ACTIVE_CNT
						 FROM scp_mst_tact_time a (NOLOCK) 
						 LEFT OUTER JOIN scm_mst_item_sn i (NOLOCK) ON a.division_id = i.division_id 
																	AND a.item_id = i.item_id 
																	AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
						 JOIN scm_mst_site b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id			 
						 LEFT OUTER JOIN scp_mst_loss_time d ON a.division_id = d.division_id and a.plant_site_id = d.plant_site_id and a.operation_id = d.operation_id and a.line_id = d.line_id
						WHERE 1=1 
						  AND b.osp_yn        = 'N' -- 외주 packer 제외
						  AND a.operation_id <> 'P5000' -- P5000 공정 제외
						  AND a.division_id    IN (SELECT token FROM dbo.String_Split(@v_division_id		,',')) --=  @p_division_id
						UNION ALL
						-- Project Route 화면에 등록된 모델중 Tact Time Master에 없는 모델 조회
						-- scp_mst_tact_time 에 등록되면 리스트에서 제외
						SELECT DISTINCT
							   a.division_id
							  ,a.plant_site_id
							  ,dbo.fn_get_item_operation_group(a.division_id, a.item_id) AS operation_group_id -- item_sn 테이블에 미등록된 site 경우 값을 가져올 수 없어 function을 통해 가져옴
							  ,(SELECT TOP 1 substring(X.scp_flow_id,1,5) FROM scm_mst_item_sn X WITH (NOLOCK) WHERE X.division_id = A.division_id AND X.item_id=A.item_id) AS operation_id
							  ,i.site_id AS model_site
							  ,a.item_id
							  ,i.nick_name
							  ,null AS line_id
							  ,null AS priority
							  ,null AS tact_time
							  ,null AS yield
							  ,null AS daily_capacity
							  ,null AS item_uom
							  ,null AS uom_convert_value
							  ,'Y' AS valid_yn
							  ,CONVERT(CHAR(10), C.MIN_DUE_DATE, 23) AS BOM_MIN_DUE_DATE
							  ,null AS created_by
							  ,null AS creation_date
							  ,null AS last_updated_by
							  ,null AS last_update_date
							  , 'I' as input_status
							  ,null AS except_yn
							  ,1 AS ACTIVE_CNT
						FROM scm_mst_site_item_priority a (NOLOCK)
						LEFT OUTER JOIN scm_mst_item_sn i (NOLOCK) ON a.division_id = i.division_id 
																	AND a.item_id = i.item_id 
																	AND i.site_id = ( select site_id from scm_mst_plant_sn s (NOLOCK) where s.division_id = a.division_id and s.plant_id = dbo.fn_scm_split(a.plant_site_id,1,'-') )
						JOIN SCM_MST_SITE b ON a.division_id = b.division_id AND a.plant_site_id = b.scm_site_id
						LEFT JOIN scp_mst_final_item C (NOLOCK) ON a.division_id = C.division_id and a.item_id = C.item_id and C.fcst_yn = upper('Y')
						WHERE 1=1 
						  AND a.valid_yn    = 'Y'
						  AND b.osp_yn      = 'N' -- 외주 packer 제외
						  AND NOT EXISTS ( select 'X' from scp_mst_tact_time n (NOLOCK) 
											JOIN SCM_MST_LINE_SN LS ON LS.COMPANY_ID=B.COMPANY_ID AND LS.DIVISION_ID=N.DIVISION_ID AND LS.SITE_ID=B.SITE_ID AND LS.PLANT_ID=B.PLANT_ID
																					AND LS.OPERATION_ID=N.OPERATION_ID AND LS.LINE_ID=N.LINE_ID AND LS.ACTIVE_FLAG='Y'
											where n.division_id = a.division_id 
											and n.plant_site_id = a.plant_site_id 
											and n.item_id = a.item_id )
						  -- MKT FCST 존재하는 모델만 조회(전극이 아닐 경우에만) -> 전극도 포함
						  AND EXISTS ( SELECT 'X'
											   FROM #TblDynamicPivot_Fcst F WITH(NOLOCK)
											  WHERE F.DIVISION_ID=A.DIVISION_ID
												AND F.ITEM_ID=A.ITEM_ID
										   )
						  AND a.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id		,',')) --= @p_division_id
						  --AND ( ( @p_plant_site_id IS NULL OR  @p_plant_site_id = '' ) OR a.plant_site_id IN (SELECT token FROM dbo.String_Split(@p_plant_site_id  ,',')) )			
						  --AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.item_id IN (SELECT token FROM dbo.String_Split(@p_item_id  ,',')) )	
						 )m
			 LEFT OUTER JOIN scp_mst_tact_time_big n (NOLOCK) ON m.division_id  = n.division_id
															AND m.plant_site_id = n.plant_site_id
															AND m.item_id       = n.item_id
															and m.operation_id  = n.operation_id
															and m.line_id       = n.line_id
															and CONVERT(CHAR(8), n.last_update_date, 112)>='20181101' -- Big Data 로직 개선전 제외
			WHERE 1=1
			AND m.division_id IN (SELECT token FROM dbo.String_Split(@v_division_id		,','))--= @p_division_id
			AND m.operation_group_id  in ('P','A','E')
			AND substring(m.item_id,2,1) = CASE WHEN m.operation_group_id = 'A' Then 'C' ELSE substring(m.item_id,2,1)  END  --TCO Cell조회불가
			AND m.ACTIVE_CNT>0
			;


			--전극 추가
			/* -- 추후 협의
			INSERT INTO #TblDynamicPivot_TactTime
			SELECT * FROM #TblDynamicPivot_TactTime
			WHERE OPERATION_GROUP_ID='E'
			*/

			INSERT INTO SCM_KPI_TACT_TIME
			(DIVISION_ID, PLAN_START_YYYYMMDD, SCM_SITE_ID, ITEM_ID, OPERATION_GROUP, VALID_TYPE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
			SELECT DIVISION_ID, @p_from_yyyymmdd, PLANT_SITE_ID, ITEM_ID, OPERATION_GROUP_ID, VALID_TYPE, @v_batch_user, GETDATE(), @v_batch_user, GETDATE()
			FROM #TblDynamicPivot_TactTime

			SET @n_log_count = (SELECT COUNT(*) FROM #TblDynamicPivot_TactTime);

			IF OBJECT_ID('tempdb..#TblDynamicPivot_Fcst') IS NOT NULL	
				DROP TABLE #TblDynamicPivot_Fcst;

			IF OBJECT_ID('tempdb..#TblDynamicPivot_ProjectRoute') IS NOT NULL
				DROP TABLE #TblDynamicPivot_ProjectRoute;

		END

	END TRY

	BEGIN CATCH
     
    -- ERROR LOG
    SET @v_log_type = N'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

    return -1 
	END CATCH;

	-- 종료 LOG
	SET @v_log_type = N'END';
	SET @v_log_message = N'########## END of procedure ##########';
	SET @v_description = N'';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCP_SYS_LOG_BATCH @p_program_name  =@v_program_name
                             ,@p_log_type      =@v_log_type
                             ,@p_log_count     =@n_log_count 
                             ,@p_log_message   =@v_log_message 
                             ,@p_description   =@v_description 
                             ,@p_event_date    =@d_event_date 
                             ,@p_user_id       =@v_batch_user
                             ;
	return 1 

	_RETURN_ERR_CODE:          
		BEGIN          
			RETURN -1          
		END;  
END;


