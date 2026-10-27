-- =============================================
-- Author:		 chkim.68
-- Create date:  2024-02-05
-- Description:	XLS to DEV db conversion table
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_XLS_TO_CONVERTER]
    @p_sys_type NVARCHAR(max)='USAGE',
    @p_sys_flag NVARCHAR(max)='',
    @p_sys_gubun NVARCHAR(max)='MERGE',
    @p_user_id NVARCHAR(max)='AUTO',
	@p_option NVARCHAR(max)='N'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	print @p_sys_type

	IF @p_sys_type = 'USAGE' 
	begin
		print ' usage '
		print ' EXEC	[dbo].[PR_TMP_NERP_XLS_TO_CONVERTER] @p_sys_type, @p_sys_flag, @p_sys_gubun, @p_user_id, @p_option'
		print ' @p_sys_type  : USAGE (default) - this info '
		print '              : ALL - all CODE TYPE '
		print '              : COMPANY_ID - apply to CODE TYPE company_id '

		print ' @p_sys_flag  : N/A'

		print ' @p_sys_gubun : Operation to execute'
		print '              : MERGE - merge (default) '
		print '              : UPSERT - merge '
		print '              : INSERT - insert'
		print ''

		print ' @p_user_id   : Specify UserID (defautl string AUTO)'
		print ''

		print ' @p_option    : Running Option'
		print '              : ''C%'' : clear first '
		print N'              : ''%M'' : 매핑완료 적용'
		print ''

		print ' EXEC	[dbo].[PR_TMP_NERP_XLS_TO_CONVERTER] ''PLANT'','''',''INSERT'',''AUTO'',''CM'' '
		print N'    run to convert PLANT for insert operation with id ''AUTO'', with option clear then only for ''확정'''

		-- TODO 

		RETURN
	end

DECLARE @delete_option nvarchar(1) = 'N'
DECLARE @matching_option int = 0
if @p_option LIKE 'C%'  begin
	SET @delete_option = 'Y' 
end

if @p_option LIKE '%M' begin
	SET @matching_option = 1
end

-- DELETE EXISTING DATA
if @delete_option = 'Y' begin
	DELETE FROM [TH_OC_CONV_MASTER] WHERE 1=1
end

DECLARE @work_company int = 0
DECLARE @work_plant int = 0
DECLARE @work_storage int = 0

if @p_sys_type = 'ALL' 
begin
	SET @work_company = 1
	SET @work_plant = 1
	SET @work_storage = 1
end else if @p_sys_type= 'COMPANY' OR @p_sys_type= 'COMPANY_ID' begin
	SET @work_company = 1
end else if @p_sys_type= 'PLANT' OR @p_sys_type= 'PLANT_ID' begin
	SET @work_plant = 1
end else if @p_sys_type= 'STORAGE' OR @p_sys_type= 'STORAGE_ID' begin
	SET @work_storage = 1
end

if @p_sys_gubun = 'DELETE' begin
	if @work_company = 1 begin
		DELETE FROM [TH_OC_CONV_MASTER] WHERE 1=1
		AND CODETYPE = 'COMPANY_ID'
	end
	if @work_plant = 1 begin
		DELETE FROM [TH_OC_CONV_MASTER] WHERE 1=1
		AND CODETYPE = 'PLANT_ID'
	end
	if @work_storage = 1 begin
		DELETE FROM [TH_OC_CONV_MASTER] WHERE 1=1
		AND CODETYPE = 'STORAGE_ID'
	end
end
else if @p_sys_gubun = 'MERGE' OR @p_sys_gubun = 'UPSERT' begin
	if @work_company = 1 begin
	--- PLANT_ID UPSERT
		merge into  [TH_OC_CONV_MASTER] A
		using 
			(select 
					   [OLD CODE VALUE1] AS [FROM_COMPANY_ID]
					   ,Y.SITE_ID AS [FROM_SITE_ID]
					   ,'-' AS [FROM_PLANT_ID]
					   ,'-' AS [FROM_STORAGE_ID]
					   ,[NEW CODE VALUE1] AS [TO_COMPANY_ID]
					   ,'-' AS [TO_PLANT_ID]
					   ,'-' AS [TO_STORAGE_ID]
					   ,[ELEMENT 1] AS [ELEMENT1],[ELEMENT 2] AS [ELEMENT2],[ELEMENT 3] AS [ELEMENT3],[ELEMENT 4] AS [ELEMENT4]
					   ,[NEW CODE VALUE1 DESC] AS [DESC1] ,[NEW CODE VALUE2 DESC] AS [DESC2],[NEW CODE VALUE3 DESC] AS [DESC3],[NEW CODE VALUE4 DESC] AS [DESC4]
					   ,[COMMENT1] AS [COMMENT1],[COMMENT2] AS [COMMENT2],[COMMENT3] AS [COMMENT3],[COMMENT4] AS [COMMENT4] ,[COMMENT5] AS [COMMENT5],[COMMENT6] AS [COMMENT6]
					   ,[COMMENT] AS [COMMENT7]
					   ,'Y' AS [ACTIVE_FLAG]
					   ,'-' AS [ATTRIBUTE1],'-' AS [ATTRIBUTE2],'-' AS [ATTRIBUTE3] ,'-' AS [ATTRIBUTE4],'-' AS [ATTRIBUTE5]
					   FROM [lgce_infdev].[dbo].[znerp_xls_master_code] X with(nolock)
					   inner join SCM_COMPANY_M K with(nolock)
					   ON X.[OLD CODE VALUE1] = k.COMPANY_id
					   left outer join SCM_SITE_M Y with(nolock)
					   ON X.[OLD CODE VALUE1] = Y.COMPANY_ID 
			WHERE 1=1 
			AND [ELEMENT 1] LIKE 'BUKRS%' AND ISNULL([ELEMENT 2],'')=''
			AND (ISNULL([COMMENT6],'') = N'매핑확정' OR @matching_option=0) -- OR이므로 matching_option이 0이 아닐 때만 '매핑확정' 조건이 적용된다
		  ) B
		ON 1=1 AND A.CODETYPE = 'COMPANY_ID'
		AND A.FROM_COMPANY_ID = B.[FROM_COMPANY_ID]
		AND A.FROM_PLANT_ID = B.[FROM_PLANT_ID]
		AND A.FROM_STORAGE_ID = B.[FROM_STORAGE_ID]

		when matched then 
			--begin matched
			UPDATE Set TO_COMPANY_ID = B.TO_COMPANY_ID, TO_PLANT_ID = B.TO_PLANT_ID, TO_STORAGE_ID = B.TO_STORAGE_ID
			--end matched
		when not matched then
			--Begin not matched
			INSERT ([CODETYPE]
				   ,[FROM_COMPANY_ID],[FROM_SITE_ID],[FROM_PLANT_ID],[FROM_STORAGE_ID]
				   ,[TO_COMPANY_ID],[TO_PLANT_ID],[TO_STORAGE_ID]
				   ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
				   ,[DESC1],[DESC2],[DESC3],[DESC4]
				   ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
				   ,[ACTIVE_FLAG]
				   ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
				   ,[INSERT_ID]
				   ,[INSERT_DATE]
				   ,[UPDATE_ID]
				   ,[UPDATE_DATE]) VALUES 
				   ('COMPANY_ID',B.[FROM_COMPANY_ID] ,ISNULL(B.[FROM_SITE_ID],'')
				   ,'-'
				   ,'-' 
				   ,B.[TO_COMPANY_ID] 
				   ,'-' 
				   ,'-' 
				   ,B.[ELEMENT1] ,B.[ELEMENT2] ,B.[ELEMENT3] ,B.[ELEMENT4] 
				   ,B.[DESC1], B.[DESC2],B.[DESC3],B.[DESC4] 
				   ,B.[COMMENT1],B.[COMMENT2],B.[COMMENT3],B.[COMMENT4],B.[COMMENT5],B.[COMMENT6]
				   ,B.[COMMENT7] 
				   ,'Y' --AS [ACTIVE_FLAG]
				   ,'-' ,'-','-','-','-'
				   ,'a', GETDATE(), 'A',gETdATE()
				   );
			-- End not matched
	end -- end of work_company

	if @work_plant = 1 begin
	--- PLANT_ID UPSERT
		merge into  [TH_OC_CONV_MASTER] A
		using 
			(select 
					   Y.COMPANY_ID AS [FROM_COMPANY_ID]
					   ,Y.SITE_ID AS [FROM_SITE_ID]
					   ,[OLD CODE VALUE1] AS [FROM_PLANT_ID]
					   ,'-' AS [FROM_STORAGE_ID]
					   ,'-' AS [TO_COMPANY_ID]
					   ,Y.PLANT_ID AS [TO_PLANT_ID]
					   ,'-' AS [TO_STORAGE_ID]
					   ,[ELEMENT 1] AS [ELEMENT1],[ELEMENT 2] AS [ELEMENT2],[ELEMENT 3] AS [ELEMENT3],[ELEMENT 4] AS [ELEMENT4]
					   ,[NEW CODE VALUE1 DESC] AS [DESC1] ,[NEW CODE VALUE2 DESC] AS [DESC2],[NEW CODE VALUE3 DESC] AS [DESC3],[NEW CODE VALUE4 DESC] AS [DESC4]
					   ,[COMMENT1] AS [COMMENT1],[COMMENT2] AS [COMMENT2],[COMMENT3] AS [COMMENT3],[COMMENT4] AS [COMMENT4] ,[COMMENT5] AS [COMMENT5],[COMMENT6] AS [COMMENT6]
					   ,[COMMENT] AS [COMMENT7]
					   ,'Y' AS [ACTIVE_FLAG]
					   ,'-' AS [ATTRIBUTE1],'-' AS [ATTRIBUTE2],'-' AS [ATTRIBUTE3] ,'-' AS [ATTRIBUTE4],'-' AS [ATTRIBUTE5]
					   FROM [lgce_infdev].[dbo].[znerp_xls_master_code] X with(nolock)
					   inner join SCM_PLANT_M Y with(nolock)
					   ON X.[OLD CODE VALUE1] = Y.PLANT_ID
			WHERE 1=1 
			AND [ELEMENT 1] LIKE 'WERKS%' AND ISNULL([ELEMENT 2],'')=''
			AND (ISNULL([COMMENT6],'') = N'매핑확정' OR @matching_option=0)
		  ) B
		ON 1=1 AND A.CODETYPE = 'PLANT_ID'
		AND A.FROM_COMPANY_ID = B.[FROM_COMPANY_ID]
		AND A.FROM_PLANT_ID = B.[FROM_PLANT_ID]
		AND A.FROM_STORAGE_ID = B.[FROM_STORAGE_ID]

		when matched then 
			--begin matched
			UPDATE Set TO_COMPANY_ID = B.TO_COMPANY_ID, TO_PLANT_ID = B.TO_PLANT_ID, TO_STORAGE_ID = B.TO_STORAGE_ID
			--end matched
		when not matched then
			--Begin not matched
			INSERT ([CODETYPE]
				   ,[FROM_COMPANY_ID],[FROM_SITE_ID],[FROM_PLANT_ID],[FROM_STORAGE_ID]
				   ,[TO_COMPANY_ID],[TO_PLANT_ID],[TO_STORAGE_ID]
				   ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
				   ,[DESC1],[DESC2],[DESC3],[DESC4]
				   ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
				   ,[ACTIVE_FLAG]
				   ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
				   ,[INSERT_ID]
				   ,[INSERT_DATE]
				   ,[UPDATE_ID]
				   ,[UPDATE_DATE]) VALUES 
				   ('PLANT_ID','-' 
				   ,B.[FROM_SITE_ID] 
				   ,B.[FROM_PLANT_ID] 
				   ,'-' 
				   ,'-'
				   ,[TO_PLANT_ID] 
				   ,'-' 
				   ,B.[ELEMENT1] ,B.[ELEMENT2] ,B.[ELEMENT3] ,B.[ELEMENT4] 
				   ,B.[DESC1], B.[DESC2],B.[DESC3],B.[DESC4] 
				   ,B.[COMMENT1],B.[COMMENT2],B.[COMMENT3],B.[COMMENT4],B.[COMMENT5],B.[COMMENT6]
				   ,B.[COMMENT7] 
				   ,'Y' --AS [ACTIVE_FLAG]
				   ,'-' ,'-','-','-','-'
				   ,'a', GETDATE(), 'A',gETdATE()
				   );
			-- End not matched
	end -- end of work_plant

	if @work_storage = 1 begin
	--- STORAGE_ID UPSERT
		merge into  [TH_OC_CONV_MASTER] A
		using 
			(select 
					  '-' AS [FROM_COMPANY_ID],Y.SITE_ID AS [FROM_SITE_ID]
					   ,[OLD CODE VALUE1] AS [FROM_PLANT_ID]
					   ,[OLD CODE VALUE2] AS [FROM_STORAGE_ID]
					   ,'-' AS [TO_COMPANY_ID]
					   ,[NEW CODE VALUE1] AS [TO_PLANT_ID]
					   ,[NEW CODE VALUE2] AS [TO_STORAGE_ID]
					   ,[ELEMENT 1] AS [ELEMENT1],[ELEMENT 2] AS [ELEMENT2],[ELEMENT 3] AS [ELEMENT3],[ELEMENT 4] AS [ELEMENT4]
					   ,[NEW CODE VALUE1 DESC] AS [DESC1] ,[NEW CODE VALUE2 DESC] AS [DESC2],[NEW CODE VALUE3 DESC] AS [DESC3],[NEW CODE VALUE4 DESC] AS [DESC4]
					   ,[COMMENT1] AS [COMMENT1],[COMMENT2] AS [COMMENT2],[COMMENT3] AS [COMMENT3],[COMMENT4] AS [COMMENT4] ,[COMMENT5] AS [COMMENT5],[COMMENT6] AS [COMMENT6]
					   ,[COMMENT] AS [COMMENT7]
					   ,'Y' AS [ACTIVE_FLAG]
					   ,'-' AS [ATTRIBUTE1],'-' AS [ATTRIBUTE2],'-' AS [ATTRIBUTE3] ,'-' AS [ATTRIBUTE4],'-' AS [ATTRIBUTE5]
					   FROM [lgce_infdev].[dbo].[znerp_xls_master_code] X with(nolock)
					   inner join SCM_PLANT_M Y with(nolock)
					   ON X.[OLD CODE VALUE1] = Y.PLANT_ID
			WHERE 1=1 
			AND [ELEMENT 1] LIKE 'WERKS%' AND [ELEMENT 2] LIKE 'LGORT%'
			AND (ISNULL([COMMENT6],'') = N'매핑확정' OR @matching_option=0)
		  ) B
		ON 1=1 AND A.CODETYPE = 'STORAGE_ID'
		AND A.FROM_COMPANY_ID = B.[FROM_COMPANY_ID]
		AND A.FROM_PLANT_ID = B.[FROM_PLANT_ID]
		AND A.FROM_STORAGE_ID = B.[FROM_STORAGE_ID]

		when matched then 
			--begin matched
			UPDATE Set TO_COMPANY_ID = B.TO_COMPANY_ID, TO_PLANT_ID = B.TO_PLANT_ID, TO_STORAGE_ID = B.TO_STORAGE_ID
			--end matched
		when not matched then
			--Begin not matched
			INSERT ([CODETYPE]
				   ,[FROM_COMPANY_ID],[FROM_SITE_ID],[FROM_PLANT_ID],[FROM_STORAGE_ID]
				   ,[TO_COMPANY_ID],[TO_PLANT_ID],[TO_STORAGE_ID]
				   ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
				   ,[DESC1],[DESC2],[DESC3],[DESC4]
				   ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
				   ,[ACTIVE_FLAG]
				   ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
				   ,[INSERT_ID]
				   ,[INSERT_DATE]
				   ,[UPDATE_ID]
				   ,[UPDATE_DATE]) VALUES 
				   ('STORAGE_ID'
				   ,'-'
				   ,B.[FROM_SITE_ID]
				   ,B.[FROM_PLANT_ID] 
				   ,B.[FROM_STORAGE_ID] 
				   ,'-'
				   ,B.[TO_PLANT_ID] 
				   ,B.[TO_STORAGE_ID] 
				   ,B.[ELEMENT1] ,B.[ELEMENT2] ,B.[ELEMENT3] ,B.[ELEMENT4] 
				   ,B.[DESC1], B.[DESC2],B.[DESC3],B.[DESC4] 
				   ,B.[COMMENT1],B.[COMMENT2],B.[COMMENT3],B.[COMMENT4],B.[COMMENT5],B.[COMMENT6]
				   ,B.[COMMENT7] 
				   ,'Y' --AS [ACTIVE_FLAG]
				   ,'-' ,'-','-','-','-'
				   ,'a', GETDATE(), 'A',gETdATE()
				   );
			-- End not matched
	end -- end of work_storage	




end 
else if @p_sys_gubun = 'INSERT' begin
	-- USE UPSERT
    print '-- insert--' 
    print '--warning use upsert rather insert--' 
	if @work_company = 1 begin
	print ' insert work company'
	insert into [TH_OC_CONV_MASTER]
			   ([CODETYPE]
			   ,[FROM_COMPANY_ID],[FROM_PLANT_ID],[FROM_STORAGE_ID]
			   ,[TO_COMPANY_ID],[TO_PLANT_ID],[TO_STORAGE_ID]
			   ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
			   ,[DESC1],[DESC2],[DESC3],[DESC4]
			   ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
			   ,[ACTIVE_FLAG]
			   ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
			   ,[INSERT_ID]
			   ,[INSERT_DATE]
			   ,[UPDATE_ID]
			   ,[UPDATE_DATE])
	select 
	'COMPANY_ID' AS CODETYPE
			   ,[OLD CODE VALUE1] AS [FROM_COMPANY_ID]
			   ,'-' AS [FROM_PLANT_ID]
			   ,'-' AS [FROM_STORAGE_ID]
			   ,[NEW CODE VALUE1] AS [TO_COMPANY_ID]
			   ,'-' AS [TO_PLANT_ID]
			   ,'-' AS [TO_STORAGE_ID]
			   ,[ELEMENT 1] AS [ELEMENT1],[ELEMENT 2] AS [ELEMENT2],[ELEMENT 3] AS [ELEMENT3],[ELEMENT 4] AS [ELEMENT4]
			   ,[NEW CODE VALUE1 DESC] AS [DESC1] ,[NEW CODE VALUE2 DESC] AS [DESC2],[NEW CODE VALUE3 DESC] AS [DESC3],[NEW CODE VALUE4 DESC] AS [DESC4]
			   ,[COMMENT1] AS [COMMENT1],[COMMENT2] AS [COMMENT2],[COMMENT3] AS [COMMENT3],[COMMENT4] AS [COMMENT4] ,[COMMENT5] AS [COMMENT5],[COMMENT6] AS [COMMENT6]
			   ,[COMMENT] AS [COMMENT7]
			   ,'Y' AS [ACTIVE_FLAG]
			   ,'-' AS [ATTRIBUTE1],'-' AS [ATTRIBUTE2],'-' AS [ATTRIBUTE3] ,'-' AS [ATTRIBUTE4],'-' AS [ATTRIBUTE5]
			   ,'XLSCONVERTER' AS [INSERT_ID] ,GetDate() AS [INSERT_DATE] ,'XLSCONVERTER' AS [UPDATE_ID] ,GetDate() AS [UPDATE_DATE]
			   from [lgce_infdev].[dbo].[znerp_xls_master_code] with(nolock)
	WHERE 1=1
	AND [ELEMENT 1] LIKE 'BUKRS%' AND ISNULL([ELEMENT 2],'')=''
	AND (ISNULL([COMMENT6],'') = N'매핑확정' OR @matching_option=0)
	end -- end of work_company

	if @work_plant = 1 begin
	--- PLANT_ID INSERT
	insert into [TH_OC_CONV_MASTER]
			   ([CODETYPE]
			   ,[FROM_COMPANY_ID],[FROM_PLANT_ID],[FROM_STORAGE_ID]
			   ,[TO_COMPANY_ID],[TO_PLANT_ID],[TO_STORAGE_ID]
			   ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
			   ,[DESC1],[DESC2],[DESC3],[DESC4]
			   ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
			   ,[ACTIVE_FLAG]
			   ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
			   ,[INSERT_ID]
			   ,[INSERT_DATE]
			   ,[UPDATE_ID]
			   ,[UPDATE_DATE])
	select 
	'PLANT_ID' AS CODETYPE
			   ,'-' AS [FROM_OMPANY_ID]
			   ,[OLD CODE VALUE1] AS [FROM_PLANT_ID]
			   ,'-' AS [FROM_STORAGE_ID]
			   ,'-' AS [TO_COMPANY_ID]
			   ,[NEW CODE VALUE1]  AS [TO_PLANT_ID]
			   ,'-' AS [TO_STORAGE_ID]
			   ,[ELEMENT 1] AS [ELEMENT1],[ELEMENT 2] AS [ELEMENT2],[ELEMENT 3] AS [ELEMENT3],[ELEMENT 4] AS [ELEMENT4]
			   ,[NEW CODE VALUE1 DESC] AS [DESC1] ,[NEW CODE VALUE2 DESC] AS [DESC2],[NEW CODE VALUE3 DESC] AS [DESC3],[NEW CODE VALUE4 DESC] AS [DESC4]
			   ,[COMMENT1] AS [COMMENT1],[COMMENT2] AS [COMMENT2],[COMMENT3] AS [COMMENT3],[COMMENT4] AS [COMMENT4] ,[COMMENT5] AS [COMMENT5],[COMMENT6] AS [COMMENT6]
			   ,[COMMENT] AS [COMMENT7]
			   ,'Y' AS [ACTIVE_FLAG]
			   ,'-' AS [ATTRIBUTE1],'-' AS [ATTRIBUTE2],'-' AS [ATTRIBUTE3] ,'-' AS [ATTRIBUTE4],'-' AS [ATTRIBUTE5]
			   ,'XLSCONVERTER' AS [INSERT_ID] ,GetDate() AS [INSERT_DATE] ,'XLSCONVERTER' AS [UPDATE_ID] ,GetDate() AS [UPDATE_DATE]
			   from [lgce_infdev].[dbo].[znerp_xls_master_code] with(nolock)
	WHERE 1=1
	AND [ELEMENT 1] LIKE 'WERKS%' AND ISNULL([ELEMENT 2],'')=''
	AND (ISNULL([COMMENT6],'') = N'매핑확정' OR @matching_option=0)
	end -- end of work_plant

	if @work_storage = 1 begin
	--- STORAGE_ID INSERT
	insert into [TH_OC_CONV_MASTER]
			   ([CODETYPE]
			   ,[FROM_COMPANY_ID],[FROM_PLANT_ID],[FROM_STORAGE_ID]
			   ,[TO_COMPANY_ID],[TO_PLANT_ID],[TO_STORAGE_ID]
			   ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
			   ,[DESC1],[DESC2],[DESC3],[DESC4]
			   ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
			   ,[ACTIVE_FLAG]
			   ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
			   ,[INSERT_ID]
			   ,[INSERT_DATE]
			   ,[UPDATE_ID]
			   ,[UPDATE_DATE])
	select 
	'STORAGE_ID' AS CODETYPE
			   ,'-' AS [FROM_OMPANY_ID]
			   ,[OLD CODE VALUE1] AS [FROM_PLANT_ID]
			   ,[OLD CODE VALUE2] AS [FROM_STORAGE_ID]
			   ,'-' AS [TO_COMPANY_ID]
			   ,[NEW CODE VALUE1]  AS [TO_PLANT_ID]
			   ,[NEW CODE VALUE2] AS [TO_STORAGE_ID]
			   ,[ELEMENT 1] AS [ELEMENT1],[ELEMENT 2] AS [ELEMENT2],[ELEMENT 3] AS [ELEMENT3],[ELEMENT 4] AS [ELEMENT4]
			   ,[NEW CODE VALUE1 DESC] AS [DESC1] ,[NEW CODE VALUE2 DESC] AS [DESC2],[NEW CODE VALUE3 DESC] AS [DESC3],[NEW CODE VALUE4 DESC] AS [DESC4]
			   ,[COMMENT1] AS [COMMENT1],[COMMENT2] AS [COMMENT2],[COMMENT3] AS [COMMENT3],[COMMENT4] AS [COMMENT4] ,[COMMENT5] AS [COMMENT5],[COMMENT6] AS [COMMENT6]
			   ,[COMMENT] AS [COMMENT7]
			   ,'Y' AS [ACTIVE_FLAG]
			   ,'-' AS [ATTRIBUTE1],'-' AS [ATTRIBUTE2],'-' AS [ATTRIBUTE3] ,'-' AS [ATTRIBUTE4],'-' AS [ATTRIBUTE5]
			   ,'XLSCONVERTER' AS [INSERT_ID] ,GetDate() AS [INSERT_DATE] ,'XLSCONVERTER' AS [UPDATE_ID] ,GetDate() AS [UPDATE_DATE]
			   from [lgce_infdev].[dbo].[znerp_xls_master_code] with(nolock)
	WHERE 1=1
	AND [ELEMENT 1] LIKE 'WERKS%' AND [ELEMENT 2] LIKE 'LGORT%'
	AND (ISNULL([COMMENT6],'') = N'매핑확정' OR @matching_option=0)
	end -- end of work_storage
end -- end of insert branch




SELECT * FROM [TH_OC_CONV_MASTER] WITH(NOLOCK)



--[ELEMENT 1],[ELEMENT 2],[OLD CODE VALUE1],[OLD CODE VALUE2], [NEW CODE VALUE1],[NEW CODE VALUE2],* from [lgce_infdev].[dbo].[znerp_xls_master_code] with(nolock)

END
