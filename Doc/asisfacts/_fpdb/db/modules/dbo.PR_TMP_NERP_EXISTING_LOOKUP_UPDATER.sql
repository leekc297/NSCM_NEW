-- =============================================
-- Author:		 chkim.68
-- Create date:  2024-02-06
-- Description: NERP를 위해 기존 룩업 테이블에 NERP 대상 데이터를 추가하는 함수
-- 기존 룩업 데이터에 NERP의 데이터값을 추가
-- 1. GERP, KERP 등에서 사용하던 룩업도 계속 사용하는지 여부 검사
-- 2. 시험을 위해 추가 후 CLEAN 하기 위해 추가된 룩업에 CLEAN용 ATTRIBUTE를 추가
-- 3. 개발 중 테스트 완료된 기능은 D, 작업 중인 데이터는 A(dont know work), B(work but not tested), C (mature) 로 단계 표시
-- =============================================
CREATE PROCEDURE [dbo].[PR_TMP_NERP_EXISTING_LOOKUP_UPDATER]
    @p_sys_type NVARCHAR(max)='USAGE',
    @p_sys_flag NVARCHAR(max)='',
    @p_sys_gubun NVARCHAR(max)='clean',
    @p_user_id NVARCHAR(max)='PR_TMP_NERP_EXISTING_LOOKUP_UPDATER',
	@p_option NVARCHAR(max)='N'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--print @p_sys_type
	print 'NO USE -- DEPLECATED -- '
	IF @p_sys_type = 'USAGE' 
	begin
		print ' usage '
		print ' EXEC	[dbo].[PR_TMP_NERP_EXISTING_LOOKUP_UPDATER] @p_sys_type, @p_sys_flag, @p_sys_gubun, @p_user_id, @p_option'
		print ' @p_sys_type  : USAGE (default) - this info '
		print '              : ALL - all lookup data '
		print '              : A - dont know work '
		print '              : b - working data'
		print '              : C - mature data [DEFAULT] '
		print '              : d - completed data  '

		print ' @p_sys_flag : LOOKUP TYPE CODE'
		print '              : '' (default) all code'
		print '              : ''a'' LOOKUP_TYPE_CODE '
		print ''

		print ' @p_sys_gubun : WORK OPTION'
		print '              : '' (default) convert'
		print '              : ''revert'' delete base on attribute '
		print ''

		print ' @p_user_id   : Specify UserID (defautl string AUTO)'
		print ''

		print ' @p_option    : N/A '
		print ''

		--print ' EXEC	[dbo].[PR_TMP_NERP_EXISTING_LOOKUP_UPDATER] ''C'',''exeption'',''INSERT'',''AUTO'',''CM'' '
		--print N'    run to convert PLANT for insert operation with id ''AUTO'', with option clear then only for ''확정'''

		-- TODO 

		RETURN
	end

DECLARE @work_option nvarchar(10) = ''
DECLARE @lookup_to_apply nvarchar(100) = ''
DECLARE @delete_option nvarchar(1) = ''
DECLARE @all_lookup_work int = 0
DECLARE @all_stage_work int = 0
DECLARE @user_id nvarchar(100) = 'AUTO'
DECLARE @stage_to_work nvarchar(10) = ''
DECLARE @go int = 0

if @p_sys_gubun = 'revert'
begin   SET @work_option = 'revert' end
else if @p_sys_gubun = ''
begin	SET @work_option = 'convert' end
else if @p_sys_gubun = 'convert'
begin SET  @work_option = 'convert' end


if @p_sys_type = 'ALL'
	SET @all_stage_work = 1
SET @stage_to_work = ISNULL(@p_sys_type,'')

if @p_sys_flag = ''
	SET @all_lookup_work = 1

SET @user_id = ISNULL(@p_user_id,'AUTO')
SET @lookup_to_apply = isnull(@p_sys_flag,'')

DECLARE @current_lookup nvarchar(100)
DECLARE @current_stage nvarchar(100)

------------------- AMEND_VALIDATION_EXCEPTION ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--AMEND_VALIDATION_EXCEPTION	Amend Validation 예외 처리(Target)	FP	Y	INSTANCE_ID	DIVISION_ID	SITE_ID	PLANT_ID	MODEL_ID
SET @current_lookup = 'AMEND_VALIDATION_EXCEPTION'
SET @current_stage = 'D'
--A > D
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		merge into [SCM_SYS_LOOKUP_VALUE] A
		using 
		-- comparison
		(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		ON 
		-- condtion
		( 1=1
		AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		AND A.SEGMENT4 = B.FROM_PLANT_ID 
		AND ISNULL(B.TO_PLANT_ID,'')<> '')

		when matched then
			UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
			,MODIFY_USER_ID = @user_id, MODIFY_DATE = GetDate()
		;
		if @all_lookup_work <> 1
		select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		update [SCM_SYS_LOOKUP_VALUE] 
		SET SEGMENT4 = ATTRIBUTE15
		, ATTRIBUTE15 = ''
		, ATTRIBUTE14 = ''
		,MODIFY_USER_ID = @user_id, MODIFY_DATE = GetDate()
		WHERE  1=1
		AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		AND ISNULL(ATTRIBUTE15,'')<> ''
		
		if @all_lookup_work <> 1
		select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of AMEND_VALIDATION_EXCEPTION ------------------------
print 'a'
print @lookup_to_apply
------------------- BASIS_START_TIME_PLANT ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAME
SET @go = 0
SET @current_lookup = 'BASIS_START_TIME_PLANT'
SET @current_stage = 'A'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup) AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
SET @go = 1 
if @go=1 begin
	print '---- start '
	print 'xxx1'
	print @work_option
	print 'xxx2'
	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		merge into [SCM_SYS_LOOKUP_VALUE] A
		using 
		-- comparison
		(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		ON 
		-- condtion
		( 1=1
		AND A.LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		AND A.SEGMENT1 = B.FROM_PLANT_ID 
		AND ISNULL(B.TO_PLANT_ID,'')<> '')

		when matched then
			UPDATE SET SEGMENT1 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT1
			,MODIFY_USER_ID = @user_id, MODIFY_DATE = GetDate()
		;
		if @all_lookup_work <> 1
		select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		update [SCM_SYS_LOOKUP_VALUE] 
		SET SEGMENT1 = ATTRIBUTE15
		, ATTRIBUTE15 = ''
		, ATTRIBUTE14 = ''
		,MODIFY_USER_ID = @user_id, MODIFY_DATE = GetDate()
		WHERE  1=1
		AND LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		AND ISNULL(ATTRIBUTE15,'')<> ''

		if @all_lookup_work <> 1
		select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'BASIS_START_TIME_PLANT'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------

------------------- TEMPLATE ------------------------
--LOOKUP_TYPE_CODE LOOKUP_DESCRIPTION SYSTEM_TYPE_CODE SEGMENT1 SEGMENT2 SEGMENT3 SEGMENT4 SEGMENT5
--BASIS_START_TIME_PLANT	PLANT별 시업시간	FP	Y	PLANT	CODE_ID	CODE_NAMESET @current_lookup = ''
SET @current_stage = 'D'
if (@all_lookup_work = 1 OR @lookup_to_apply = @current_lookup)
AND (@all_stage_work = 1 OR not (@current_stage < @stage_to_work))
	SET @go = 1
if @go=1 begin

	--------------- INSERET
	if @work_option = 'convert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		
		--merge into [SCM_SYS_LOOKUP_VALUE] A
		--using 
		---- comparison
		--(SELECT * FROM [TH_OC_CONV_MASTER] B WITH(NOLOCK) WHERE CODETYPE = 'PLANT_ID') B
		--ON 
		---- condtion
		--( 1=1
		--AND A.LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND A.SEGMENT4 = B.FROM_PLANT_ID 
		--AND ISNULL(B.TO_PLANT_ID,'')<> '')

		--when matched then
		--	UPDATE SET SEGMENT4 = B.TO_PLANT_ID, ATTRIBUTE14 = 'NERP_CONV PLANT_ID', ATTRIBUTE15 = A.SEGMENT4
		--;
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of insert
	--------------- CLEAN
	if @work_option = 'revert' begin
		print 'start ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   [stage: ' + @current_stage +' ]'

		--update [SCM_SYS_LOOKUP_VALUE] 
		--SET SEGMENT4 = ATTRIBUTE15
		--, ATTRIBUTE15 = ''
		--, ATTRIBUTE14 = ''
		--WHERE  1=1
		--AND LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		--AND ATTRIBUTE14 = 'NERP_CONV PLANT_ID' 
		--AND ISNULL(ATTRIBUTE15,'')<> ''
		
		--if @all_lookup_work <> 1
		--select * from SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = 'AMEND_VALIDATION_EXCEPTION'
		print 'end ' + @work_option + ' of LOOKUP ( ' + @current_lookup + ')   ' 
	end -- end of clean
end -- end of go
------------------- end of TEMPLATE ------------------------




END
