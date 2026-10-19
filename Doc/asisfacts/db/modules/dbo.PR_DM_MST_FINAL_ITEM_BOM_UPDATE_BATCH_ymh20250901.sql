
/*
 * Program ID   : PR_DM_MST_FINAL_ITEM_BOM_UPDATE_BATCH
 * Description  : MKT FCST 조회시 cell 모델 bom에서 찾아오는것 때문에 속도이슈가 발생
 *                site_item table 에 attribute5번 컬럼에 cell 모델을 bom을 읽어서 넣어두고 화면 조회시 사용
 *                1시간단위 배치로 UPDATE 함
 * Program History
 *============================================================================================================
 *   Date       In Charge              Description
 *============================================================================================================
 * 2018.08.13   KHSONG   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * -----------------------------------------------------------------------------------------------------------
 * 20180907 KHSONG 자동차도 수행되도록 Division_id 조건 제거
 * 20180911 KHSONG 금일기준으로 EFF_START_DATE가 가장 가까운 하위모델 추출, child_item_id 추출조건수정,division_id 조건 보완
 * 20181116 KHSONG 원통형 계약고객 관리화면 업데이트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/11/16	HWI1993	[PJ20209643] 속도개선 - 악성쿼리 튜닝
 * 2022/01/24	rosia27	[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2022/02/24	rosia27	[C20220216-000319]Cell Model 컬럼 누락건 로직 추가 검토 요청의 건
 */

CREATE PROCEDURE [dbo].[PR_DM_MST_FINAL_ITEM_BOM_UPDATE_BATCH_ymh20250901]

	--Add the parameters for the stored procedure here
	--@p_division_id				NVARCHAR(MAX)
    --,@p_plan_id                  NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MST_FINAL_ITEM_BOM_UPDATE_BATCH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @max_plan_id                  NVARCHAR(MAX);
    DECLARE @c_division_id                NVARCHAR(MAX);
    DECLARE @c_plan_id                    NVARCHAR(MAX);
    DECLARE @plan_start_yyyymmdd          NVARCHAR(MAX);
    DECLARE @c_VERSION_NO				  NVARCHAR(MAX);
    DECLARE @c_target_date				  DATETIME;

	--set @c_target_date = DATEADD(hour,-2,GETDATE())  -- 20180805 KHSONG 작업대상을 현재시간기준 2시간내 수정된 데이터를 기준으로함

	-- 시작 LOG  (START)
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)

	-- 트랜잭션 (START)
	--BEGIN TRANSACTION FINAL_ITEM_BOM_UPDATE_BATCH
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------	
	UPDATE SI
	SET attribute5 = 
			CASE
				WHEN substring(item_id, 1,2) = 'MC' OR substring(item_id, 1,2) = 'AC' OR substring(item_id, 1,2) = 'EC' THEN item_id -- 20180911
				ELSE
					ISNULL
					( V.CHILD_ITEM_ID -- from절로 내림
					, 
						(
							SELECT TOP 1 [CHILD_ITEM_ID]
								FROM [dbo].[SCM_MST_MODEL_FINAL_ITEM_BOM_V] w WITH(NOLOCK)
								where 1=1
								and w.division_id = '40'  --이조건은 소형만 해당됨
								and MODEL_ID like CASE WHEN substring(item_id, 1,2) = 'MP' THEN substring(item_id, 1,11)+'%'
														ELSE substring(ITEM_ID, 1,12)
														END 
														and [OPERATION_GROUP_ID] = 'A'
														and child_item_id like 'MC%'
						)
					)
				END 
	-- SELECT COUNT(*) CNT                
	FROM scm_mst_site_item AS SI
		LEFT JOIN
		(
			SELECT DIVISION_ID, MODEL_ID
				, [1]
				+ CASE WHEN [2]  IS NOT NULL THEN ','+[2] ELSE '' END
				+ CASE WHEN [3]  IS NOT NULL THEN ','+[3] ELSE '' END
				+ CASE WHEN [4]  IS NOT NULL THEN ','+[4] ELSE '' END
				+ CASE WHEN [5]  IS NOT NULL THEN ','+[5] ELSE '' END
				+ CASE WHEN [6]  IS NOT NULL THEN ','+[6] ELSE '' END
				+ CASE WHEN [7]  IS NOT NULL THEN ','+[7] ELSE '' END
				+ CASE WHEN [8]  IS NOT NULL THEN ','+[8] ELSE '' END
				+ CASE WHEN [9]  IS NOT NULL THEN ','+[9] ELSE '' END
				+ CASE WHEN [10] IS NOT NULL THEN ','+[10] ELSE '' END
				AS CHILD_ITEM_ID

			FROM (
					SELECT DIVISION_ID, MODEL_ID, CHILD_ITEM_ID
						, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, MODEL_ID ORDER BY CHILD_ITEM_ID ) AS ROW_NUM
					FROM (	
						SELECT DISTINCT DIVISION_ID, MODEL_ID, CHILD_ITEM_ID
						FROM [DBO].[SCM_MST_MODEL_FINAL_ITEM_BOM_V] W WITH(NOLOCK)
						WHERE 1=1
							AND W.DIVISION_ID > '' -- 20250901 추가.
							AND W.[OPERATION_GROUP_ID] = 'A'
							AND W.CHILD_ITEM_ID LIKE  
													CASE
														WHEN W.DIVISION_ID = '40' THEN  'MC%'
														WHEN W.DIVISION_ID = '81'  THEN 'AC%'
														WHEN W.DIVISION_ID = '82'  THEN 'EC%'
														ELSE W.CHILD_ITEM_ID
													END 
							AND W.EFF_END_DATE > GETDATE()
						) A
					) A
			PIVOT (
				MAX(CHILD_ITEM_ID) FOR ROW_NUM IN ( [1], [2], [3], [4], [5], [6], [7], [8], [9], [10] ) 
				) AS PVT
		) AS V              ON V.DIVISION_ID = SI.division_id -- 20180911
							and V.MODEL_ID = SI.ITEM_ID
	where 1=1
		--and division_id = '40'  --20180907 KHSONG 자동차도 수행되도록 Division_id 조건 제거
		--and division_id = scm_mst_site_item.division_id -- 20180911
		and exists
			(
				select b.SCM_SITE_ID
					from scm_mst_site b
					where b.scm_site_id = SI.SCM_SITE_ID
					and b.site_type = 'SALES'
			)	
;
	
	-- [C20220216-000319]Cell Model 컬럼 누락건 로직 추가 검토 요청의 건
	/* -- 20250901
	UPDATE SI
	SET SI.ATTRIBUTE5 = V.ITEM_ID
	FROM SCM_MST_SITE_ITEM AS SI
		JOIN DM_MST_ITEM_SINGLE_V AS V
		ON SI.DIVISION_ID = V.DIVISION_ID
		AND SI.ITEM_ID = V.ITEM_ID
	WHERE SI.ATTRIBUTE5 IS NULL
	*/ -- 20250901
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--                                                                                                                         20181116 KHSONG 원통형 계약고객 관리화면 업데이트 (start)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	/* -- 20250901
	update scm_mst_site_item
			set attribute7 = 
				isnull((select t2.priority from 
							-- t2 (start)
							(
							select division_id,SCM_SITE_ID,PROJECT_CODE,ITEM_ID,priority, row_number() over ( partition by SCM_SITE_ID,PROJECT_CODE,ITEM_ID order by TYPE ) seq
							from 
								-- t1 (start)
								(
										-- End Customer 와 Sold-to, 팀이 다 선택된 경우
										select 1 TYPE, a.segment1, a.segment2, a.attribute1+a.attribute2 priority, b.division_id,d.scm_site_id, d.soldto_customer, b.project_code, b.item_id
										from	scm_adm_lookup_master_detail	a with(nolock)
												,scm_mst_site_item				b with(nolock)
												,dm_mst_item_single_v			c with(nolock)
												,scm_mst_site					d with(nolock)
												,scm_mst_sso_dept_info			e with(nolock)
												,scm_mst_sso_user_info			f with(nolock)
										where   a.lookup_type		= 'MOBILE_CYLINDER_CUSTOMER_PRIORITY'
											and a.valid_yn			= 'Y'
											and b.division_id		= '40'
											and b.division_id		= c.division_id
											and b.item_id			= c.item_id
											and a.valid_yn			= b.valid_yn
											and c.item_class		= 'EM010102' -- 원통형 Cell만 대상임.
											and b.division_id		= d.division_id
											and b.scm_site_id		= d.scm_site_id
											and a.valid_yn			= d.valid_yn
											and a.segment1			= b.PROJECT_CODE
											and a.segment2			<> '-'
											and a.segment3			<> '-'
											and a.segment2			= d.soldto_customer
											and e.dept_id			= f.dept_id
											and e.DEPT_NAME_KO		= a.segment3
											and substring( b.OWNER, 0, case when charindex(',',b.OWNER) = 0 then len(b.OWNER)+1 else charindex(',',b.OWNER) end )    = f.user_id
										---------
										UNION ALL
										---------
										-- End Customer 와 팀이 선택된 경우
										select 2 TYPE, a.segment1, a.segment2, a.attribute1+a.attribute2 priority, b.division_id,d.scm_site_id, d.soldto_customer, b.project_code, b.item_id
										from	scm_adm_lookup_master_detail	a with(nolock)
												,scm_mst_site_item				b with(nolock)
												,dm_mst_item_single_v			c with(nolock)
												,scm_mst_site					d with(nolock)
												,scm_mst_sso_dept_info			e with(nolock)
												,scm_mst_sso_user_info			f with(nolock)
										where   a.lookup_type		= 'MOBILE_CYLINDER_CUSTOMER_PRIORITY'
											and a.valid_yn			= 'Y'
											and b.division_id		= '40'
											and b.division_id		= c.division_id
											and b.item_id			= c.item_id
											and a.valid_yn			= b.valid_yn
											and c.item_class		= 'EM010102' -- 원통형 Cell만 대상임.
											and b.division_id		= d.division_id
											and b.scm_site_id		= d.scm_site_id
											and a.valid_yn			= d.valid_yn
											and a.segment1			= b.PROJECT_CODE
											and a.segment2			= '-'
											and a.segment2			<> '-'
											and e.dept_id			= f.dept_id
											and e.DEPT_NAME_KO		= a.segment3
											and substring( b.OWNER, 0, case when charindex(',',b.OWNER) = 0 then len(b.OWNER)+1 else charindex(',',b.OWNER) end )    = f.user_id
										---------
										UNION ALL
										---------
										-- End Customer 와 Sold-to 이 경우
										select 3 TYPE, a.segment1, a.segment2, a.attribute1+a.attribute2 priority, b.division_id,d.scm_site_id, d.soldto_customer, b.project_code, b.item_id
										from     scm_adm_lookup_master_detail	a with(nolock)
												,scm_mst_site_item				b with(nolock)
												,dm_mst_item_single_v			c with(nolock)
												,scm_mst_site					d with(nolock)
										where   a.lookup_type		= 'MOBILE_CYLINDER_CUSTOMER_PRIORITY'
											and a.valid_yn			= 'Y'
											and b.division_id		= '40'
											and b.division_id		= c.division_id
											and b.item_id			= c.item_id
											and a.valid_yn			= b.valid_yn
											and c.item_class		= 'EM010102' -- 원통형 Cell만 대상임.
											and b.division_id		= d.division_id
											and b.scm_site_id		= d.scm_site_id
											and a.valid_yn			= d.valid_yn
											and a.segment1			= b.PROJECT_CODE
											and a.segment2			<> '-'
											and a.segment3			=  '-'
											and a.segment2			= d.soldto_customer
										---------
										UNION ALL
										---------
										-- End Customer 만 설정된 경우
										select 4 TYPE, a.segment1, a.segment2, a.attribute1+a.attribute2 priority, b.division_id,d.scm_site_id, d.soldto_customer, b.project_code, b.item_id
										from	 SCM_ADM_LOOKUP_MASTER_DETAIL	a with(nolock)
												,scm_mst_site_item				b with(nolock)
												,dm_mst_item_single_v			c with(nolock)
												,scm_mst_site					d with(nolock)
										where   a.lookup_type		= 'MOBILE_CYLINDER_CUSTOMER_PRIORITY'
											and a.valid_yn			= 'Y'
											and b.division_id		= '40'
											and b.division_id		= c.division_id
											and b.item_id			= c.item_id
											and a.valid_yn			= b.valid_yn
											and c.item_class		= 'EM010102' -- 원통형 Cell만 대상임.
											and b.division_id		= d.division_id
											and b.scm_site_id		= d.scm_site_id
											and a.valid_yn			= d.valid_yn
											and a.segment1			= b.PROJECT_CODE
											and a.segment2			= '-'
											and a.segment3			= '-'
								) 	t1
							) t2
						where seq = 1
							AND division_id		= scm_mst_site_item.division_id
							AND scm_site_id		= scm_mst_site_item.scm_site_id
							AND project_code	= scm_mst_site_item.project_code
							AND item_id			= scm_mst_site_item.item_id
							and scm_mst_site_item.division_id	= '40'

				) ,99)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	--                                                                                                                         20181116 KHSONG 원통형 계약고객 관리화면 업데이트 (end)
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	*/ -- 20250901

    --COMMIT WORK;
	--------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	--ROLLBACK TRANSACTION FINAL_ITEM_BOM_UPDATE_BATCH

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
