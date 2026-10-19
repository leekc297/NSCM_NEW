/*
 * Program ID   : [SCP0015_GET_PLAN_ENGINE_RUN]
 * Description  : ENGINE RUN 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/23   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 실행예제)
 *  EXEC SCP0015_GET_PLAN_ENGINE_RUN @p_modeling_id='2',@p_division_id='81',@p_revision_no='20180226-PR-02'
 *  EXEC SCP0015_GET_PLAN_ENGINE_RUN @p_modeling_id='2',@p_division_id='81',@p_revision_no='20171211-MA-02'
 */
CREATE PROCEDURE [dbo].[SCP0015_GET_PLAN_ENGINE_RUN]
 (
	 @p_modeling_id  	NVARCHAR(1000)
  	,@p_division_id		NVARCHAR(1000)  
	,@p_revision_no		NVARCHAR(1000)
 )
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_plan_name NVARCHAR(8)='';
	DECLARE @v_plan_type NVARCHAR(2)='';
	DECLARE @v_plan_seq  NVARCHAR(2)='';
	DECLARE @v_plan_id   NVARCHAR(30)='';	

	SET @v_plan_name = [dbo].[FN_SCM_SPLIT](@p_revision_no,1,'-');
	SET @v_plan_type = [dbo].[FN_SCM_SPLIT](@p_revision_no,2,'-');
	SET @v_plan_seq  = [dbo].[FN_SCM_SPLIT](@p_revision_no,3,'-');

	SET @v_plan_id = (
						SELECT b.plan_id
						  FROM dbo.scm_mst_plan A
							   INNER JOIN scm_mst_plan_detail B ON a.division_id=b.division_id
															   AND a.plan_id    =b.plan_id	   
						 WHERE b.modeling_id = @p_modeling_id
						   AND a.division_id = @p_division_id
						   AND a.plan_name   = @v_plan_name
						   AND b.plan_type   = @v_plan_type
						   AND b.plan_seq    = @v_plan_seq 
						) ;

	SELECT a.code AS step_cd
		  ,a.name  AS step_name
		  ,'' AS step_process1
		  ,'' AS step_process2
		  ,'' AS step_process3
		  ,'' AS step_process4
		  ,b.modeling_id
		  ,b.division_id
		  ,b.plan_name
		  ,b.plan_id
		  ,b.plan_seq
		  ,b.plan_type
		  ,b.plan_status
		  ,CASE WHEN CODE =10 AND B.INPUT_START_DATE 	IS NOT NULL AND INPUT_END_DATE 		 IS NOT NULL THEN '1'
				WHEN CODE =20 AND B.PLAN_START_DATE 	IS NOT NULL AND PLAN_END_DATE 		 IS NOT NULL THEN '1'
				WHEN CODE =30 AND B.PLAN_END_DATE 		IS NOT NULL AND PLAN_OUTPUT_END_DATE IS NOT NULL THEN '1'
				WHEN CODE =40 AND B.OUTPUT_START_DATE 	IS NOT NULL AND ANL_END_DATE 	 IS NOT NULL THEN '1'
				WHEN CODE =10 AND B.INPUT_START_DATE 	IS NULL 	AND INPUT_END_DATE 		 IS NULL THEN '-1'
				WHEN CODE =20 AND B.PLAN_START_DATE 	IS NULL 	AND PLAN_END_DATE 		 IS NULL THEN '-1'
				WHEN CODE =30 AND B.PLAN_END_DATE 		IS NULL 	AND PLAN_OUTPUT_END_DATE IS NULL THEN '-1'
				WHEN CODE =40 AND B.OUTPUT_START_DATE IS  NULL AND ANL_END_DATE 			 IS NULL THEN '-1'				
				ELSE '0'
		   END AS STEP_STATUS -- 1:실행완료, -1:실행전, 0:실행중
		  ,CASE WHEN code =10 THEN b.input_start_date
				WHEN code =20 THEN b.plan_start_date
				WHEN code =30 THEN b.plan_end_date
				WHEN code =40 THEN b.output_start_date
		   END AS START_TIME
		  ,CASE WHEN code =10 THEN b.input_end_date
				WHEN code =20 THEN b.plan_end_date
				WHEN code =30 THEN b.plan_output_end_date
				WHEN code =40 THEN b.ANL_END_DATE
		   END AS END_TIME		
		 , '' AS view_log  		
	  FROM(
			SELECT segment1 as code
				  ,segment2 as name 
			  FROM dbo.scm_adm_lookup_master_detail
			 WHERE lookup_type ='ENGINE_RUN_STATUS'
			   AND valid_yn='Y'
		  ) A LEFT OUTER JOIN 
		  (	
			SELECT b.modeling_id
				  ,b.division_id
				  ,a.plan_name
				  ,b.plan_id
				  ,b.plan_seq
				  ,b.plan_type	 
				  ,b.plan_status
				  ,CONVERT(VARCHAR, b.input_start_date, 120) AS input_start_date
				  ,CONVERT(VARCHAR, b.input_end_date, 120) AS input_end_date
				  ,CONVERT(VARCHAR, b.plan_start_date, 120) AS plan_start_date
				  ,CONVERT(VARCHAR, b.plan_end_date, 120) AS plan_end_date
				  ,CONVERT(VARCHAR, b.plan_output_end_date, 120) AS plan_output_end_date
				  ,CONVERT(VARCHAR, b.output_start_date, 120) AS output_start_date
				  --,CONVERT(VARCHAR, b.output_end_date, 120) AS output_end_date
				  ,CONVERT(VARCHAR, b.ANL_END_DATE, 120) AS ANL_END_DATE
				  
			  FROM dbo.scm_mst_plan A
				   INNER JOIN scm_mst_plan_detail B ON a.division_id=b.division_id
												   AND a.plan_id    =b.plan_id	   
			 WHERE b.modeling_id = @p_modeling_id
			   and a.division_id = @p_division_id
			   AND a.plan_name   = @v_plan_name
			   AND b.plan_type   = @v_plan_type
			   AND b.plan_seq    = @v_plan_seq 
		 ) B  ON 1=1
	where 1=1	 
	ORDER BY a.code;

	-- 플랜상태정보 조회
	SELECT plan_status
	      ,dbo.fn_get_lookup_code_desc('PLAN_RUN_STATUS',plan_status) AS plan_status_name
	 FROM scm_mst_plan_detail	  
	WHERE modeling_id  = @p_modeling_id
	   AND division_id = @p_division_id
	   AND plan_id     = @v_plan_id
	   AND plan_type   = @v_plan_type 
	   AND plan_seq    = @v_plan_seq ;



END
