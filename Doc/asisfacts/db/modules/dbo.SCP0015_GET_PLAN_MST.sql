/*
 * Program ID   : [SCP0015_GET_PLAN_MST]
 * Description  : Plan Management 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018-02-23   PJS				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018-04-16   PJS				화면그리드 조회시 REVISION_NO 상태 초기값 조회쿼리로 변경 
 * 2018-05-21   PJS				confirm, run 사용자 권한 기능 추가
 * 2018-06-18   PJS				modeling_id 조회방식 변경
 * 2018-11-01   YHW				TE 플랜 추가
 * 2019-06-14	YHW				[CSR ID:4004411] GSCM(SCP) 서비스 점검결과 조치(Message Exception 처리)
 * 2025-07-19	YMH				[CSR : 20250618-001038] 관련조치 
									1. 권한을 GROUP MENU MODIFY 권한으로 수정
									2. RUN은 오류종료시에만 가능
									3. 취소버튼 추가 
									4. 취소버튼은 정상종료만 가능.
 * ex)
    EXEC SCP0015_GET_PLAN_MST @p_division_id='81',@p_plan_year='2018',@p_plan_week='',@p_user_id=''
 */
CREATE PROCEDURE [dbo].[SCP0015_GET_PLAN_MST]
 (
  	 @p_division_id		NVARCHAR(MAX)  
	,@p_plan_year  		NVARCHAR(MAX)
	,@p_plan_week	  	NVARCHAR(MAX)
	,@p_user_id         NVARCHAR(MAX)
	,@p_group_id		NVARCHAR(MAX)
	--,@p_plan_type	  	NVARCHAR(MAX) =''
 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	/* 화면 그리드 조회 */
	--SELECT  B.division_id
	--	   ,B.DIVISION_NAME
	--	   ,A.SEGMENT2 PLAN_TYPE_DESCRIPTION
	--	   ,A.SEGMENT3 PLAN_TYPE
	--	   ,'' AS REVISION_NO
	--	   ,'' AS REVISION_DESC
	--	   ,'' AS CONFIRM_TIME
	--	   ,'' AS CONFIRM_USER
	--FROM   SCM_ADM_LOOKUP_MASTER_DETAIL A
	--	, (SELECT division_id, DIVISION_NAME 
	--		FROM dbo.SCM_MST_DIVISION
	--	   WHERE DIVISION_ID =@p_division_id
	--	  ) B 	 
	--WHERE A.LOOKUP_TYPE ='PLAN_TYPE'
	--  AND A.VALID_YN    ='Y'
	--ORDER BY A.DISPLAY_SEQ ;

	SELECT t.division_id
		  ,t.division_name
		  ,t.plan_type_description
		  ,t.plan_type
		  ,(SELECT modeling_id FROM scm_mst_modeling WHERE  plan_cycle  = 'WEEKLY' AND division_id    = @p_division_id) AS modeling_id 
		  ,u.revision_no
		  ,u.revision_desc
		  ,u.plan_status_name
		  ,u.plan_status
		  ,u.confirm_flag as confirm_yn
		  ,u.confirm_time
		  ,u.confirm_user

		  /* 20250709 [csr : E20250618-001038] 관련 수정 주석처리 시작 */
		  --,ISNULL(v.confirm_auth,'N') AS confirm_auth
		  --,ISNULL(v.run_auth,'N') AS run_auth
		  /* 20250709 [csr : E20250618-001038] 관련 수정 주석처리 끝 */
		  /* 20250709 [csr : E20250618-001038] 관련 신규로직 시작 */
		  ,ISNULL(v.confirm_auth,'N') AS confirm_auth
		  ,ISNULL(v.run_auth,'N') AS run_auth
		  ,ISNULL(v.CANCEL_AUTH,'N') AS CANCEL_AUTH
		  /* 20250709 [csr : E20250618-001038] 관련 신규로직 끝   */
	  FROM(
			SELECT  b.division_id
				   ,b.division_name
				   ,a.segment2 plan_type_description
				   ,a.segment3 plan_type
				   ,'' AS revision_no
				   ,'' AS revision_desc
				   ,'' AS confirm_time
				   ,'' AS confirm_user
				   ,a.display_seq
			FROM   scm_adm_lookup_master_detail a
				, (SELECT division_id, division_name 
					FROM dbo.scm_mst_division
				   WHERE division_id = @p_division_id
				  ) B 	 
			WHERE A.LOOKUP_TYPE ='PLAN_TYPE'
			  AND A.VALID_YN    ='Y'
		
		 ) T LEFT OUTER JOIN
		 (
			SELECT m.division_id
				  ,m.plan_type
				  ,m.revision_no
				  ,m.modeling_id
				  ,m.revision_desc
				  ,m.plan_status
				  ,m.plan_status_name			
				  ,n.confirm_date AS confirm_time
				  ,n.confirm_flag
				  ,n.confirm_user
			  FROM (
					SELECT   a.plan_version_id as revision_no
							,a.plan_version_id as revision_desc
							--,a.modeling_id
							,a.plan_status
							,a.plan_status_name			
							,c.segment2 AS plan_type_description
							,c.display_seq
							,RANK() OVER(PARTITION BY a.plan_type ORDER BY A.plan_version_id DESC) AS rank
							,a.modeling_id
							,a.division_id
							,a.plan_id
							,a.plan_type
							,convert(int, [dbo].[fn_scm_split](a.plan_version_id,3,'-')) as plan_seq			
					 FROM   fn_scp_plan_version_v(@p_division_id,'',@p_plan_year,@p_plan_week) a 
							JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
							JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'			
					WHERE    1=1	  
					) m
					LEFT JOIN scm_mst_plan_detail n  ON m.modeling_id = n.modeling_id
													and m.division_id = n.division_id
													and m.plan_id     = n.plan_id
													and m.plan_type   = n.plan_type
													and m.plan_seq    = n.plan_seq   
			WHERE 1=1
			  and rank =1
		   ) U ON t.DIVISION_ID =u.division_id
			  and t.PLAN_TYPE   =u.plan_type
		  /* 20250709 [csr : E20250618-001038] 관련 수정 주석처리 */
		  /*
		  LEFT OUTER JOIN (SELECT division_id
							     ,MAX(CASE WHEN  action_type ='CONFIRM' THEN 'Y' END) AS confirm_auth
								 ,MAX(CASE WHEN  action_type ='RUN' THEN 'Y' END) AS run_auth
							FROM scm_mst_plan_user
						   WHERE division_id = @p_division_id
					         AND plan_cycle  = 'WEEKLY'
					         AND user_id     = @p_user_id
					       GROUP BY division_id
					) V ON t.division_id = v.division_id
			*/
			/* 20250709 [csr : E20250618-001038] 관련 신규로직 시작*/
			LEFT OUTER JOIN (
								SELECT 
									B.CODE AS DIVISION_ID
									, 'Y' AS CONFIRM_AUTH
									, 'Y' AS RUN_AUTH
									, 'Y' AS CANCEL_AUTH
								FROM TB_FX_UserGroupInfo  AS A
									LEFT OUTER JOIN TB_FX_UserGroupAuthExtention AS B
									ON A.GroupID = B.GROUPID
									AND A.UserID = B.UserID
								WHERE A.GROUPID IN
								(
									SELECT GROUPID
									FROM TB_FX_GroupMenuAuth AS A WITH(NOLOCK) 
									WHERE MENUID = 'SCP0015' -- 메뉴고정.
									AND GROUPID = @p_group_id
									AND BASICACLU = 1
								) AND USEYN = 'Y'
								AND A.USERID =  @p_user_id
								AND B.AuthType = 'D' -- 디비전 고정.
								AND B.Code = @p_division_id
							) V ON t.division_id = v.division_id
			/* 20250709 [csr : E20250618-001038] 관련 신규로직 끝*/

	ORDER BY T.display_seq 		


   /* Revision 조회  view를 사용하면 소팅시 속도 저장=> view 원본으로 쿼리 재작성 => view를 함수로 변경하여 재작성*/
   SELECT   a.plan_version_id as code
			,a.plan_version_id as name
			,a.modeling_id
			,a.plan_status
			,a.plan_status_name			
			,a.plan_type
			,c.segment2 AS plan_type_description
			,c.display_seq
			--,plan_start_yyyymmdd +'-' + b.week_name AS week
	 FROM   fn_scp_plan_version_v(@p_division_id,'TE',@p_plan_year,@p_plan_week) a 
			JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
			JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'
	WHERE    1=1	  
	ORDER BY a.plan_type_order , code desc;

	SELECT   a.plan_version_id as code
			,a.plan_version_id as name
			,a.modeling_id
			,a.plan_status
			,a.plan_status_name			
			,a.plan_type
			,c.segment2 AS plan_type_description
			,c.display_seq
			--,plan_start_yyyymmdd +'-' + b.week_name AS week
	 FROM   fn_scp_plan_version_v(@p_division_id,'TM',@p_plan_year,@p_plan_week) a 
			JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
			JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'
	WHERE    1=1	  
	ORDER BY a.plan_type_order , code desc;


	SELECT   a.plan_version_id as code
			,a.plan_version_id as name
			,a.modeling_id
			,a.plan_status
			,a.plan_status_name			
			,a.plan_type
			,c.segment2 AS plan_type_description
			,c.display_seq
			--,plan_start_yyyymmdd +'-' + b.week_name AS week
	 FROM   fn_scp_plan_version_v(@p_division_id,'PR',@p_plan_year,@p_plan_week) a 
			JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
			JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'
	WHERE    1=1	  
	ORDER BY a.plan_type_order , code desc;
	
	SELECT   a.plan_version_id as code
			,a.plan_version_id as name
			,a.modeling_id
			,a.plan_status
			,a.plan_status_name			
			,a.plan_type
			,c.segment2 AS plan_type_description
			,c.display_seq
			--,plan_start_yyyymmdd +'-' + b.week_name AS week
	 FROM   fn_scp_plan_version_v(@p_division_id,'MA',@p_plan_year,@p_plan_week) a 
			JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
			JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'
	WHERE    1=1	  
	ORDER BY a.plan_type_order , code desc;
	
		SELECT   a.plan_version_id as code
			,a.plan_version_id as name
			,a.modeling_id
			,a.plan_status
			,a.plan_status_name						
			,a.plan_type
			,c.segment2 AS plan_type_description
			,c.display_seq
			--,plan_start_yyyymmdd +'-' + b.week_name AS week
	 FROM   fn_scp_plan_version_v(@p_division_id,'SE',@p_plan_year,@p_plan_week) a 
			JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
			JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'
	WHERE    1=1	  
	ORDER BY a.plan_type_order , code desc;
	
	SELECT   a.plan_version_id as code
			,a.plan_version_id as name
			,a.modeling_id
			,a.plan_status
			,a.plan_status_name						
			,a.plan_type
			,c.segment2 AS plan_type_description
			,c.display_seq
			--,plan_start_yyyymmdd +'-' + b.week_name AS week
	 FROM   fn_scp_plan_version_v(@p_division_id,'FN',@p_plan_year,@p_plan_week) a 
			JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
			JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'
	WHERE    1=1	  
	ORDER BY a.plan_type_order , code desc;
	
	SELECT   a.plan_version_id as code
			,a.plan_version_id as name
			,a.modeling_id
			,a.plan_status
			,a.plan_status_name						
			,a.plan_type
			,c.segment2 AS plan_type_description
			,c.display_seq
			--,plan_start_yyyymmdd +'-' + b.week_name AS week
	 FROM   fn_scp_plan_version_v(@p_division_id,'SU',@p_plan_year,@p_plan_week) a 
			JOIN scm_sys_calendar_m b  ON       a.plan_start_yyyymmdd = b.basis_yyyymmdd
			JOIN scm_adm_lookup_master_detail c ON a.plan_type = c.segment1 AND c.lookup_type ='PLAN_TYPE'
	WHERE    1=1	  
	ORDER BY a.plan_type_order , code desc;
	


END
