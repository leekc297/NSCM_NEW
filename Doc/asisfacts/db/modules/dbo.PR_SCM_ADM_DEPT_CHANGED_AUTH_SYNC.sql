
/*
 * Program ID   : PR_SCM_ADM_FP_AUTH_SYNC
 * Description  : FP 권한과 SCM 권한 동기화
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.03.20   FP Pjt.        FP 권한과 SCM 권한 동기화
 * 2023.04.24   FP Pjt.        EE 사업부 추가
 *
 */


CREATE PROCEDURE [dbo].[PR_SCM_ADM_DEPT_CHANGED_AUTH_SYNC]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- 변수 설정
	DECLARE @v_user_id          NVARCHAR(30);   -- 사용자ID
	DECLARE @v_user_name        NVARCHAR(150);  -- 사용자명
	DECLARE @v_remain_day       NVARCHAR(30);   -- 권한회수까지 남은 일수
	DECLARE @v_dbname           NVARCHAR(50);

	-- LOG 용 변수 설정
    DECLARE @v_program_name		NVARCHAR(150) = 'PR_SCM_ADM_DEPT_CHANGED_AUTH_SYNC';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;

	DECLARE @t_group_id			NVARCHAR(20);
	DECLARE @t_division_id		NVARCHAR(30);

	BEGIN TRY
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- fp 권한 없는 scm 권한 delete		
        delete 
		-- select *
	      from [dbo].[TB_FX_USERGROUPAUTHEXTENTION] 
	     where 1 = 1
	       AND GROUPID IN ('FP Viewer', 'FP Planner')
		   AND CODE NOT LIKE 'EE%'
	       and not exists (
               SELECT UIR.USER_ID AS USERID
	                , IIF(UIR.SAVE_FLAG = 'Y', 'FP Planner', 'FP Viewer') AS GroupID
		    --        , case when f.shop_group_id = 'E' then (case when f.division_id IN ('40', '81', '82') then 'EE' else 'EE' +  substring(f.division_id, 3, 3) end)
						--else RIR.DIVISION_ID end 
						--AS Code
					, rir.division_id as code
	             FROM [dbo].[TH_UIS_USER_INSTANCE_RELATE_SN] AS UIR WITH(NOLOCK)
	                  JOIN [dbo].[TH_UIS_ROLE_INSTANCE_SN] AS RI WITH(NOLOCK)
	               ON UIR.ROLE_ID		= RI.ROLE_ID  
	                  JOIN [dbo].[TH_UIS_ROLE_INSTANCE_RELATE_SN] AS RIR WITH(NOLOCK)
	               ON RIR.ROLE_ID		= RI.ROLE_ID 
					  join [dbo].[SCM_FACTORY_M_SN] as f with(nolock)
				   on rir.company_id = f.company_id
				  and rir.FACTORY_ID = f.factory_id
	            WHERE 1 = 1
				  AND UIR.USE_AT_FLAG = 'Y'
				  AND RIR.USE_AT_FLAG = 'Y'
				  AND UIR.USER_ID = USERID
				  AND UIR.SAVE_FLAG = IIF(GROUPID = 'FP Planner', 'Y', 'N')
				  --AND case when f.shop_group_id = 'E' then (case when f.division_id IN ('40', '81', '82') then 'EE' else 'EE' +  substring(f.division_id, 3, 3) end)
						--else RIR.DIVISION_ID end  = CODE	
				  AND RIR.DIVISION_ID = CODE
				)


	    --EE 사업부 삭제
        delete 
		-- select *
	      from [dbo].[TB_FX_USERGROUPAUTHEXTENTION] 
	     where 1 = 1
	       AND GROUPID IN ('FP Viewer', 'FP Planner')
		   AND CODE LIKE 'EE%'
	       and not exists (
               SELECT UIR.USER_ID AS USERID
	                , IIF(UIR.SAVE_FLAG = 'Y', 'FP Planner', 'FP Viewer') AS GroupID
		            , case when f.shop_group_id = 'E' then (case when f.division_id IN ('40', '81', '82') then 'EE' else 'EE' +  substring(f.division_id, 3, 3) end)
						else RIR.DIVISION_ID end 
						AS Code
					--, rir.division_id as code
	             FROM [dbo].[TH_UIS_USER_INSTANCE_RELATE_SN] AS UIR WITH(NOLOCK)
	                  JOIN [dbo].[TH_UIS_ROLE_INSTANCE_SN] AS RI WITH(NOLOCK)
	               ON UIR.ROLE_ID		= RI.ROLE_ID  
	                  JOIN [dbo].[TH_UIS_ROLE_INSTANCE_RELATE_SN] AS RIR WITH(NOLOCK)
	               ON RIR.ROLE_ID		= RI.ROLE_ID 
					  join [dbo].[SCM_FACTORY_M_SN] as f with(nolock)
				   on rir.company_id = f.company_id
				  and rir.FACTORY_ID = f.factory_id
	            WHERE 1 = 1
				  AND UIR.USE_AT_FLAG = 'Y'
				  AND RIR.USE_AT_FLAG = 'Y'
				  AND UIR.USER_ID = USERID
				  AND UIR.SAVE_FLAG = IIF(GROUPID = 'FP Planner', 'Y', 'N')
				  AND case when f.shop_group_id = 'E' then (case when f.division_id IN ('40', '81', '82') then 'EE' else 'EE' +  substring(f.division_id, 3, 3) end)
						else RIR.DIVISION_ID end  = CODE	
				  --AND RIR.DIVISION_ID = CODE
				  AND f.shop_group_id = 'E'
				)
				

		update UG
		   SET UG.USEYN					= 'N'
		     , UG.UPDATEUSERID			= 'scm_batch'
		     , UG.UPDATEDATETIME		= getdate()
		-- select *
		  FROM dbo.TB_FX_USERGROUPINFO AS UG with(nolock)
		 WHERE 1 = 1
		   and ug.GROUPID IN ('FP Viewer', 'FP Planner')
		   AND UG.USEYN					= 'Y'
		   AND NOT EXISTS (
		       SELECT GROUPID 
		         FROM [dbo].[TB_FX_USERGROUPAUTHEXTENTION] with(nolock)
		        WHERE USERID			= UG.USERID
		          AND GROUPID			= UG.GROUPID
		       )

		update r
		   set r.APPROVAL_RESULT		= 'REJECT'
			 , r.REJECT_REASON          = 'DEPT_CHANGED_AUTH_DELETE'
			 , r.LAST_UPDATED_BY		= 'scm_batch'
			 , r.LAST_UPDATE_DATE		= getdate()
		-- select *
		  from SCM_MST_AUTH_REQUEST AS R with(nolock)
		 where 1 = 1
		  AND R.GROUP_ID IN ('FP Viewer', 'FP Planner')
		  and r.APPROVAL_RESULT		!= 'REJECT'
		  AND NOT EXISTS (
			  SELECT UIR.USER_ID AS USERID
				   , IIF(UIR.SAVE_FLAG = 'Y', 'FP Planner', 'FP Viewer') AS GroupID
				   , RIR.DIVISION_ID AS Code
			    FROM [dbo].[TH_UIS_USER_INSTANCE_RELATE_SN] AS UIR WITH(NOLOCK)
					 JOIN [dbo].[TH_UIS_ROLE_INSTANCE_SN] AS RI WITH(NOLOCK)
				  ON UIR.ROLE_ID		= RI.ROLE_ID  
					 JOIN [dbo].[TH_UIS_ROLE_INSTANCE_RELATE_SN] AS RIR WITH(NOLOCK)
				  ON RIR.ROLE_ID		= RI.ROLE_ID 
			   WHERE 1 = 1
				 AND UIR.USE_AT_FLAG		= 'Y'
				 AND RIR.USE_AT_FLAG		= 'Y'
				 AND UIR.USER_ID			= R.USER_ID
				 AND UIR.SAVE_FLAG			= IIF(R.GROUP_ID = 'FP Planner', 'Y', 'N')
				 AND RIR.DIVISION_ID		= R.DIVISION_ID
			  )

		--fp권한 있는데 scm 권한 없을 경우 insert
		INSERT INTO [dbo].[TB_FX_UserGroupAuthExtention]
		          ( [GroupID]
		          , [UserID]
		          , [AuthType]
		          , [Code]
		          , [PrntCode]
		          , [RegtUserID]
		          , [RegtDateTime]
		          , [UpdateUserID]
		          , [UpdateDateTime]
		          , [JV_PLANT_ID])
		     select x.GroupID
			      , x.USERID
				  , 'D'
				  , x.Code
		          , ''
		          , 'scm_batch'
		          , getdate()
		          , 'scm_batch'
		          , getdate()
		          , ''
		       from (
		            SELECT distinct UIR.USER_ID AS USERID
		                 , IIF(UIR.SAVE_FLAG = 'Y', 'FP Planner', 'FP Viewer') AS GroupID
		      --           , case when f.shop_group_id = 'E' then (case when f.division_id IN ('40', '81', '82') then 'EE' else 'EE' +  substring(f.division_id, 3, 3) end)
						  --      else RIR.DIVISION_ID end 
								--AS Code
						 , RIR.DIVISION_ID as Code
		              FROM [dbo].[TH_UIS_USER_INSTANCE_RELATE_SN] AS UIR WITH(NOLOCK)
		                   JOIN [dbo].[TH_UIS_ROLE_INSTANCE_SN] AS RI WITH(NOLOCK)
		                ON UIR.ROLE_ID		= RI.ROLE_ID  
		                   JOIN [dbo].[TH_UIS_ROLE_INSTANCE_RELATE_SN] AS RIR WITH(NOLOCK)
		                ON RIR.ROLE_ID		= RI.ROLE_ID 
						   join [dbo].[SCM_FACTORY_M_SN] as f with(nolock)
						on rir.company_id = f.company_id
					   and rir.FACTORY_ID = f.factory_id
		             WHERE 1 = 1
		               AND UIR.USE_AT_FLAG = 'Y'
		               AND RIR.USE_AT_FLAG = 'Y'
		            ) as x
		            join TB_FX_USERGROUPINFO as ug with(nolock)
		         on x.userid = ug.userid
		        and x.groupid = ug.groupid
		            left outer join [dbo].[TB_FX_UserGroupAuthExtention] as uga with(nolock)
		         on x.userid = uga.userid
		        and x.groupid = uga.groupid
		        and x.code = uga.code
		      where 1 = 1
		        and uga.groupid is null

			--EE 사업부 추가
			INSERT INTO [dbo].[TB_FX_UserGroupAuthExtention]
		          ( [GroupID]
		          , [UserID]
		          , [AuthType]
		          , [Code]
		          , [PrntCode]
		          , [RegtUserID]
		          , [RegtDateTime]
		          , [UpdateUserID]
		          , [UpdateDateTime]
		          , [JV_PLANT_ID])
		     select x.GroupID
			      , x.USERID
				  , 'D'
				  , x.Code
		          , ''
		          , 'scm_batch'
		          , getdate()
		          , 'scm_batch'
		          , getdate()
		          , ''
		       from (
		            SELECT distinct UIR.USER_ID AS USERID
		                 , IIF(UIR.SAVE_FLAG = 'Y', 'FP Planner', 'FP Viewer') AS GroupID
		                 , case when f.shop_group_id = 'E' then (case when f.division_id IN ('40', '81', '82') then 'EE' else 'EE' +  substring(f.division_id, 3, 3) end)
						        else RIR.DIVISION_ID end 
								AS Code
						 --, RIR.DIVISION_ID as code
		              FROM [dbo].[TH_UIS_USER_INSTANCE_RELATE_SN] AS UIR WITH(NOLOCK)
		                   JOIN [dbo].[TH_UIS_ROLE_INSTANCE_SN] AS RI WITH(NOLOCK)
		                ON UIR.ROLE_ID		= RI.ROLE_ID  
		                   JOIN [dbo].[TH_UIS_ROLE_INSTANCE_RELATE_SN] AS RIR WITH(NOLOCK)
		                ON RIR.ROLE_ID		= RI.ROLE_ID 
						   join [dbo].[SCM_FACTORY_M_SN] as f with(nolock)
						on rir.company_id = f.company_id
					   and rir.FACTORY_ID = f.factory_id
		             WHERE 1 = 1
		               AND UIR.USE_AT_FLAG = 'Y'
		               AND RIR.USE_AT_FLAG = 'Y'
					   and f.shop_group_id = 'E'   --전극만 추가
		            ) as x
		            join TB_FX_USERGROUPINFO as ug with(nolock)
		         on x.userid = ug.userid
		        and x.groupid = ug.groupid
		            left outer join [dbo].[TB_FX_UserGroupAuthExtention] as uga with(nolock)
		         on x.userid = uga.userid
		        and x.groupid = uga.groupid
		        and x.code = uga.code
		      where 1 = 1
		        and uga.groupid is null

		update UG
		   SET UG.USEYN					= 'Y'
		     , UG.UPDATEUSERID			= 'scm_batch'
		     , UG.UPDATEDATETIME		= getdate()
        -- select *
		  FROM dbo.TB_FX_USERGROUPINFO AS UG with(nolock)
		 WHERE 1 = 1
		   and ug.GROUPID IN ('FP Viewer', 'FP Planner')
		   AND UG.USEYN					= 'N'
		   AND EXISTS (
		       SELECT GROUPID 
		         FROM [dbo].[TB_FX_USERGROUPAUTHEXTENTION] with(nolock)
		        WHERE USERID			= UG.USERID
		          AND GROUPID			= UG.GROUPID
		       )

		
		-- 종료 LOG
		SET @v_log_type		= 'END';
		SET @v_log_message	= '########## END of procedure ##########';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;  

	END TRY

	-- CATCH 실행
	BEGIN CATCH

		BEGIN

			SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());

			INSERT INTO SCM_SYS_LOG_BATCH 
			     ( PROGRAM_NAME
				 , LOG_TYPE
				 , LOG_COUNT
				 , LOG_MESSAGE
				 , DESCRIPTION
				 , EVENT_DATE
				 , CREATION_DATE
				 , CREATED_BY
				 , LAST_UPDATE_DATE
	             , LAST_UPDATED_BY)
			VALUES 
			     ( ERROR_PROCEDURE()
				 , 'ERROR'
				 , NULL
				 , ERROR_MESSAGE()
				 , @v_description
				 , SYSDATETIME()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE()
				 , SYSDATETIME()
				 , ERROR_PROCEDURE()
				 );

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + CONVERT(nvarchar(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
 
END
