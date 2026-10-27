
CREATE PROCEDURE [dbo].[PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER]
    @p_sys_type NVARCHAR(max),
    @p_sys_flag NVARCHAR(max),
    @p_sys_gubun NVARCHAR(max),
    @p_user_id NVARCHAR(max),
    @in_columns NVARCHAR(max),
    @in_row NVARCHAR(max),
    @opt_none NVARCHAR(5) = 'N'
WITH EXEC AS caller
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER2                                                            **/
/** 프로그램 명   : Procedure PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER2                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2022-01-20     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/* 
    EXEC PR_UI_SQL_FP00598_CARRYOVER_FIND_FP00598_CARRYOVER2 
  */
BEGIN
    SET TRANSACTION isolation level READ uncommitted;
    SET nocount ON;
    SET xact_abort ON;

    --DECLARE BASE PARAMETER START 
    DECLARE @STRLEN NVARCHAR(max)
    DECLARE @runstart DATETIME
    DECLARE @runend DATETIME
    DECLARE @v_dSql NVARCHAR(max)
    DECLARE @v_Err NVARCHAR(max)
    DECLARE @v_Log NVARCHAR(max)
    DECLARE @v_proc_name NVARCHAR(100) = OBJECT_NAME(@@PROCID)
    DECLARE @v_delimiter NVARCHAR(1)
    DECLARE @max_loop_cnt INTEGER = 0
    DECLARE @mst_loop_cnt INTEGER = 0
    DECLARE @p_master_id NVARCHAR(max) = ''
    DECLARE @p_plan_id NVARCHAR(max) = ''
    DECLARE @p_bucket_from NVARCHAR(max) = ''
    DECLARE @p_bucket_to NVARCHAR(max) = ''
    DECLARE @p_site_id NVARCHAR(max) = ''
    DECLARE @p_operation_id NVARCHAR(max) = ''
    DECLARE @p_item_id NVARCHAR(max) = ''
    DECLARE @p_plan_date NVARCHAR(max) = ''
    DECLARE @p_item_name NVARCHAR(max) = ''
    DECLARE @p_basis_plan_id NVARCHAR(max) = ''
    DECLARE @p_instance_id NVARCHAR(max) = ''
    DECLARE @p_top_item_id NVARCHAR(max) = ''
    DECLARE @p_prod_type NVARCHAR(max) = ''
    DECLARE @p_cate_info NVARCHAR(max) = ''
    DECLARE @p_bucket NVARCHAR(max) = ''
    DECLARE @p_week_info NVARCHAR(max) = ''
    DECLARE @p_month_info NVARCHAR(max) = ''
    DECLARE @p_division_lt NVARCHAR(max) = ''
    DECLARE @p_plant_lt NVARCHAR(max) = ''
    DECLARE @p_factory_lt NVARCHAR(max) = ''
    DECLARE @p_line_lt NVARCHAR(max) = ''
    DECLARE @p_prodtype_lt NVARCHAR(max) = ''
    DECLARE @p_nickname NVARCHAR(max) = ''
    DECLARE @p_nickname_lt NVARCHAR(max) = ''
    DECLARE @p_param NVARCHAR(max) = ''
    DECLARE @p_categoryinfo NVARCHAR(max) = ''
    DECLARE @p_queryset1 NVARCHAR(max) = ''
    DECLARE @p_AMEND_TABLE NVARCHAR(max) = ''
    DECLARE @p_AMEND_CAPA_TABLE NVARCHAR(max) = ''
    DECLARE @p_AMEND_SALES_TABLE NVARCHAR(max) = ''
	DECLARE @p_AMEND_UTIL_TABLE NVARCHAR(max) = ''
    --DECLARE @p_curr_date_col nvarchar(max) = '' 
    DECLARE @p_ROUND_POINT NVARCHAR(max) = ''
    DECLARE @v_ROUND_POINT NVARCHAR(max) = '1'
    DECLARE @v_master_id NVARCHAR(max)
    DECLARE @v_plan_id NVARCHAR(max)
    DECLARE @v_bucket_from NVARCHAR(max)
    DECLARE @v_bucket_to NVARCHAR(max)
    DECLARE @v_site_id NVARCHAR(max)
    DECLARE @v_operation_id NVARCHAR(max)
    DECLARE @v_item_id NVARCHAR(max)
    DECLARE @v_plan_date NVARCHAR(max)
    DECLARE @v_item_name NVARCHAR(max)
    DECLARE @v_basis_plan_id NVARCHAR(max)
    DECLARE @v_instance_id NVARCHAR(max)
    DECLARE @v_top_item_id NVARCHAR(max)
    DECLARE @v_prod_type NVARCHAR(max)
    DECLARE @v_user_id NVARCHAR(max)
    DECLARE @v_cate_info NVARCHAR(max)
    DECLARE @v_bucket NVARCHAR(max)
    DECLARE @v_week_info NVARCHAR(max)
    DECLARE @v_month_info NVARCHAR(max)
    DECLARE @v_division_lt NVARCHAR(max)
    DECLARE @v_plant_lt NVARCHAR(max)
    DECLARE @v_factory_lt NVARCHAR(max)
    DECLARE @v_line_lt NVARCHAR(max)
    DECLARE @v_prodtype_lt NVARCHAR(max)
    DECLARE @v_nickname_lt NVARCHAR(max)
    DECLARE @v_param NVARCHAR(max)
    DECLARE @v_categoryinfo NVARCHAR(max)
    DECLARE @v_queryset1 NVARCHAR(max)

    DECLARE @p_day_info NVARCHAR(max) = ''
    --DECLARE BASE PARAMETER START END 
    --Optional Parameter Part START 
    DECLARE @opt_0master_id NVARCHAR(max)
    DECLARE @opt_1master_id NVARCHAR(max)
    DECLARE @opt_2master_id NVARCHAR(max)
    DECLARE @opt_3master_id NVARCHAR(max)
    DECLARE @opt_4master_id NVARCHAR(max)
    DECLARE @opt_5master_id NVARCHAR(max)
    DECLARE @opt_6master_id NVARCHAR(max)
    DECLARE @opt_7master_id NVARCHAR(max)
    DECLARE @opt_8master_id NVARCHAR(max)
    DECLARE @opt_9master_id NVARCHAR(max)
    DECLARE @opt_10master_id NVARCHAR(max)
    DECLARE @opt_11master_id NVARCHAR(max)
    DECLARE @opt_12master_id NVARCHAR(max)
    DECLARE @opt_13master_id NVARCHAR(max)
    DECLARE @opt_14master_id NVARCHAR(max)
    DECLARE @opt_15master_id NVARCHAR(max)
    DECLARE @opt_16master_id NVARCHAR(max)
    DECLARE @opt_17master_id NVARCHAR(max)
    DECLARE @opt_18master_id NVARCHAR(max)
    DECLARE @opt_19master_id NVARCHAR(max)
    DECLARE @opt_20master_id NVARCHAR(max)
    DECLARE @opt_21master_id NVARCHAR(max)
    DECLARE @opt_22master_id NVARCHAR(max)
    DECLARE @opt_23master_id NVARCHAR(max)
    DECLARE @opt_24master_id NVARCHAR(max)
    DECLARE @opt_25master_id NVARCHAR(max)
    DECLARE @opt_26master_id NVARCHAR(max)
    DECLARE @opt_27master_id NVARCHAR(max)
    DECLARE @opt_28master_id NVARCHAR(max)
    DECLARE @opt_29master_id NVARCHAR(max)
    DECLARE @opt_30master_id NVARCHAR(max)
    DECLARE @opt_31master_id NVARCHAR(max)
    DECLARE @opt_32master_id NVARCHAR(max)
    DECLARE @opt_33master_id NVARCHAR(max)
    DECLARE @opt_34master_id NVARCHAR(max)
    DECLARE @opt_35master_id NVARCHAR(max)
    DECLARE @opt_36master_id NVARCHAR(max)
    DECLARE @opt_37master_id NVARCHAR(max)
    DECLARE @opt_38master_id NVARCHAR(max)
    DECLARE @opt_39master_id NVARCHAR(max)
    DECLARE @opt_40master_id NVARCHAR(max)
    DECLARE @opt_41master_id NVARCHAR(max)
    DECLARE @opt_42master_id NVARCHAR(max)
    DECLARE @opt_43master_id NVARCHAR(max)
    DECLARE @opt_44master_id NVARCHAR(max)
    DECLARE @opt_45master_id NVARCHAR(max)
    DECLARE @opt_46master_id NVARCHAR(max)
    DECLARE @opt_47master_id NVARCHAR(max)
    DECLARE @opt_48master_id NVARCHAR(max)
    DECLARE @opt_49master_id NVARCHAR(max)
    DECLARE @opt_50master_id NVARCHAR(max)
    DECLARE @opt_51master_id NVARCHAR(max)
    DECLARE @opt_52master_id NVARCHAR(max)
    DECLARE @opt_53master_id NVARCHAR(max)
    DECLARE @opt_54master_id NVARCHAR(max)
    DECLARE @opt_55master_id NVARCHAR(max)
    DECLARE @opt_56master_id NVARCHAR(max)
    DECLARE @opt_57master_id NVARCHAR(max)
    DECLARE @opt_58master_id NVARCHAR(max)
    DECLARE @opt_59master_id NVARCHAR(max)
    DECLARE @opt_60master_id NVARCHAR(max)
    DECLARE @opt_61master_id NVARCHAR(max)
    DECLARE @opt_62master_id NVARCHAR(max)
    DECLARE @opt_63master_id NVARCHAR(max)
    DECLARE @opt_64master_id NVARCHAR(max)
    DECLARE @opt_65master_id NVARCHAR(max)
    DECLARE @opt_66master_id NVARCHAR(max)
    DECLARE @opt_67master_id NVARCHAR(max)
    DECLARE @opt_68master_id NVARCHAR(max)
    DECLARE @opt_69master_id NVARCHAR(max)
    DECLARE @opt_70master_id NVARCHAR(max)
    DECLARE @opt_71master_id NVARCHAR(max)
    DECLARE @opt_72master_id NVARCHAR(max)
    DECLARE @opt_73master_id NVARCHAR(max)
    DECLARE @opt_74master_id NVARCHAR(max)
    DECLARE @opt_75master_id NVARCHAR(max)
    DECLARE @opt_76site_id NVARCHAR(max)
    DECLARE @opt_77item_id NVARCHAR(max)
    DECLARE @opt_78site_id NVARCHAR(max)
    DECLARE @opt_79item_id NVARCHAR(max)
    DECLARE @opt_80site_id NVARCHAR(max)
    DECLARE @opt_81item_name NVARCHAR(max)
    DECLARE @opt_82site_id NVARCHAR(max)
    DECLARE @opt_83item_id NVARCHAR(max)
    DECLARE @opt_84site_id NVARCHAR(max)
    DECLARE @opt_85item_id NVARCHAR(max)
    DECLARE @opt_86site_id NVARCHAR(max)
    DECLARE @opt_87item_id NVARCHAR(max)
    DECLARE @opt_88site_id NVARCHAR(max)
    DECLARE @opt_89item_id NVARCHAR(max)
    DECLARE @opt_90item_name NVARCHAR(max)
    DECLARE @opt_91site_id NVARCHAR(max)
    DECLARE @opt_92item_id NVARCHAR(max)
    DECLARE @opt_93site_id NVARCHAR(max)
    DECLARE @opt_94operation_id NVARCHAR(max)
    DECLARE @opt_95item_id NVARCHAR(max)
    DECLARE @opt_96site_id NVARCHAR(max)
    DECLARE @opt_97item_id NVARCHAR(max)
    DECLARE @opt_98master_id NVARCHAR(max)
    DECLARE @opt_99master_id NVARCHAR(max)
    DECLARE @opt_100master_id NVARCHAR(max)
    DECLARE @opt_101site_id NVARCHAR(max)
    DECLARE @opt_102item_id NVARCHAR(max)
    DECLARE @opt_103site_id NVARCHAR(max)
    DECLARE @opt_104item_id NVARCHAR(max)
    DECLARE @opt_105site_id NVARCHAR(max)
    DECLARE @opt_106item_id NVARCHAR(max)
    DECLARE @opt_107site_id NVARCHAR(max)
    DECLARE @opt_108item_id NVARCHAR(max)
    DECLARE @opt_109item_name NVARCHAR(max)
    DECLARE @opt_110site_id NVARCHAR(max)
    DECLARE @opt_111item_id NVARCHAR(max)
    DECLARE @opt_112item_name NVARCHAR(max)
    DECLARE @opt_113plan_date NVARCHAR(max)
    DECLARE @opt_114plan_date NVARCHAR(max)
    DECLARE @opt_115site_id NVARCHAR(max)
    DECLARE @opt_116item_id NVARCHAR(max)
    DECLARE @opt_117site_id NVARCHAR(max)
    DECLARE @opt_118item_id NVARCHAR(max)
    DECLARE @opt_119site_id NVARCHAR(max)
    DECLARE @opt_120item_id NVARCHAR(max)
    DECLARE @opt_121site_id NVARCHAR(max)
    DECLARE @opt_122item_id NVARCHAR(max)
    DECLARE @opt_123site_id NVARCHAR(max)
    DECLARE @opt_124item_id NVARCHAR(max)
    DECLARE @opt_125item_name NVARCHAR(max)
    DECLARE @opt_126site_id NVARCHAR(max)
    DECLARE @opt_127item_id NVARCHAR(max)
    DECLARE @opt_128item_name NVARCHAR(max)
    DECLARE @opt_129instance_id NVARCHAR(max)
    DECLARE @opt_130site_id NVARCHAR(max)
    DECLARE @opt_131operation_id NVARCHAR(max)
    DECLARE @opt_132top_item_id NVARCHAR(max)
    DECLARE @opt_133item_id NVARCHAR(max)
    DECLARE @opt_134prod_type NVARCHAR(max)
    DECLARE @opt_135master_id NVARCHAR(max)
    DECLARE @opt_136site_id NVARCHAR(max)
    DECLARE @opt_137operation_id NVARCHAR(max)
    DECLARE @opt_138top_item_id NVARCHAR(max)
    DECLARE @opt_139item_id NVARCHAR(max)
    DECLARE @opt_140prod_type NVARCHAR(max)
    DECLARE @opt_141site_id NVARCHAR(max)
    DECLARE @opt_142item_id NVARCHAR(max)
    DECLARE @opt_143site_id NVARCHAR(max)
    DECLARE @opt_144item_id NVARCHAR(max)
    DECLARE @opt_145site_id NVARCHAR(max)
    DECLARE @opt_146item_id NVARCHAR(max)
    DECLARE @opt_147site_id NVARCHAR(max)
    DECLARE @opt_148item_name NVARCHAR(max)
    DECLARE @opt_149site_id NVARCHAR(max)
    DECLARE @opt_150item_id NVARCHAR(max)
    DECLARE @opt_151site_id NVARCHAR(max)
    DECLARE @opt_152item_id NVARCHAR(max)
    DECLARE @opt_153site_id NVARCHAR(max)
    DECLARE @opt_154item_id NVARCHAR(max)
    DECLARE @opt_155site_id NVARCHAR(max)
    DECLARE @opt_156item_id NVARCHAR(max)
    DECLARE @opt_157item_name NVARCHAR(max)
    DECLARE @opt_158site_id NVARCHAR(max)
    DECLARE @opt_159item_id NVARCHAR(max)
    DECLARE @opt_160site_id NVARCHAR(max)
    DECLARE @opt_161operation_id NVARCHAR(max)
    DECLARE @opt_162item_id NVARCHAR(max)
    DECLARE @opt_163site_id NVARCHAR(max)
    DECLARE @opt_164item_id NVARCHAR(max)
    DECLARE @opt_165site_id NVARCHAR(max)
    DECLARE @opt_166item_id NVARCHAR(max)
    DECLARE @opt_167site_id NVARCHAR(max)
    DECLARE @opt_168item_id NVARCHAR(max)
    DECLARE @opt_169site_id NVARCHAR(max)
    DECLARE @opt_170item_id NVARCHAR(max)
    DECLARE @opt_171site_id NVARCHAR(max)
    DECLARE @opt_172item_id NVARCHAR(max)
    DECLARE @opt_173item_name NVARCHAR(max)
    DECLARE @opt_174site_id NVARCHAR(max)
    DECLARE @opt_175item_id NVARCHAR(max)
    DECLARE @opt_176item_name NVARCHAR(max)
    DECLARE @opt_177site_id NVARCHAR(max)
    DECLARE @opt_178item_id NVARCHAR(max)
    DECLARE @opt_179site_id NVARCHAR(max)
    DECLARE @opt_180item_id NVARCHAR(max)
    DECLARE @opt_181site_id NVARCHAR(max)
    DECLARE @opt_182item_id NVARCHAR(max)
    DECLARE @opt_183site_id NVARCHAR(max)
    DECLARE @opt_184item_id NVARCHAR(max)
    DECLARE @opt_185site_id NVARCHAR(max)
    DECLARE @opt_186item_id NVARCHAR(max)
    DECLARE @opt_187item_name NVARCHAR(max)
    DECLARE @opt_188site_id NVARCHAR(max)
    DECLARE @opt_189item_id NVARCHAR(max)
    DECLARE @opt_190item_name NVARCHAR(max)
    DECLARE @opt_191site_id NVARCHAR(max)
    DECLARE @opt_192operation_id NVARCHAR(max)
    DECLARE @opt_193top_item_id NVARCHAR(max)
    DECLARE @opt_194item_id NVARCHAR(max)
    DECLARE @opt_195prod_type NVARCHAR(max)
    DECLARE @opt_196site_id NVARCHAR(max)
    DECLARE @opt_197operation_id NVARCHAR(max)
    DECLARE @opt_198top_item_id NVARCHAR(max)
    DECLARE @opt_199item_id NVARCHAR(max)
    DECLARE @opt_200prod_type NVARCHAR(max)
    DECLARE @opt_201site_id NVARCHAR(max)
    DECLARE @opt_202item_id NVARCHAR(max)
    DECLARE @opt_203site_id NVARCHAR(max)
    DECLARE @opt_204item_id NVARCHAR(max)
    DECLARE @opt_205site_id NVARCHAR(max)
    DECLARE @opt_206item_id NVARCHAR(max)
    DECLARE @opt_207site_id NVARCHAR(max)
    DECLARE @opt_208item_name NVARCHAR(max)
    DECLARE @opt_209site_id NVARCHAR(max)
    DECLARE @opt_210item_id NVARCHAR(max)
    DECLARE @opt_211site_id NVARCHAR(max)
    DECLARE @opt_212item_id NVARCHAR(max)
    DECLARE @opt_213site_id NVARCHAR(max)
    DECLARE @opt_214item_id NVARCHAR(max)
    DECLARE @opt_215site_id NVARCHAR(max)
    DECLARE @opt_216item_id NVARCHAR(max)
    DECLARE @opt_217item_name NVARCHAR(max)
    DECLARE @opt_218site_id NVARCHAR(max)
    DECLARE @opt_219item_id NVARCHAR(max)
    DECLARE @opt_220site_id NVARCHAR(max)
    DECLARE @opt_221operation_id NVARCHAR(max)
    DECLARE @opt_222item_id NVARCHAR(max)
    DECLARE @opt_223site_id NVARCHAR(max)
    DECLARE @opt_224item_id NVARCHAR(max)
    DECLARE @opt_225site_id NVARCHAR(max)
    DECLARE @opt_226item_id NVARCHAR(max)
    DECLARE @opt_227site_id NVARCHAR(max)
    DECLARE @opt_228item_id NVARCHAR(max)
    DECLARE @opt_229site_id NVARCHAR(max)
    DECLARE @opt_230item_id NVARCHAR(max)
    DECLARE @opt_231site_id NVARCHAR(max)
    DECLARE @opt_232item_id NVARCHAR(max)
    DECLARE @opt_233item_name NVARCHAR(max)
    DECLARE @opt_234site_id NVARCHAR(max)
    DECLARE @opt_235item_id NVARCHAR(max)
    DECLARE @opt_236item_name NVARCHAR(max)
    DECLARE @opt_237site_id NVARCHAR(max)
    DECLARE @opt_238item_id NVARCHAR(max)
    DECLARE @opt_239site_id NVARCHAR(max)
    DECLARE @opt_240item_id NVARCHAR(max)
    DECLARE @opt_241site_id NVARCHAR(max)
    DECLARE @opt_242item_id NVARCHAR(max)
    DECLARE @opt_243site_id NVARCHAR(max)
    DECLARE @opt_244item_id NVARCHAR(max)
    DECLARE @opt_245site_id NVARCHAR(max)
    DECLARE @opt_246item_id NVARCHAR(max)
    DECLARE @opt_247item_name NVARCHAR(max)
    DECLARE @opt_248site_id NVARCHAR(max)
    DECLARE @opt_249item_id NVARCHAR(max)
    DECLARE @opt_250item_name NVARCHAR(max)
    DECLARE @opt_251site_id NVARCHAR(max)
    DECLARE @opt_252operation_id NVARCHAR(max)
    DECLARE @opt_253top_item_id NVARCHAR(max)
    DECLARE @opt_254item_id NVARCHAR(max)
    DECLARE @opt_255prod_type NVARCHAR(max)
    DECLARE @opt_256site_id NVARCHAR(max)
    DECLARE @opt_257operation_id NVARCHAR(max)
    DECLARE @opt_258top_item_id NVARCHAR(max)
    DECLARE @opt_259item_id NVARCHAR(max)
    DECLARE @opt_260prod_type NVARCHAR(max)
    DECLARE @opt_261site_id NVARCHAR(max)
    DECLARE @opt_262item_id NVARCHAR(max)
    DECLARE @opt_263site_id NVARCHAR(max)
    DECLARE @opt_264item_id NVARCHAR(max)
    DECLARE @opt_265site_id NVARCHAR(max)
    DECLARE @opt_266item_id NVARCHAR(max)
    DECLARE @opt_267site_id NVARCHAR(max)
    DECLARE @opt_268item_name NVARCHAR(max)
    DECLARE @opt_269site_id NVARCHAR(max)
    DECLARE @opt_270item_id NVARCHAR(max)
    DECLARE @opt_271site_id NVARCHAR(max)
    DECLARE @opt_272item_id NVARCHAR(max)
    DECLARE @opt_273site_id NVARCHAR(max)
    DECLARE @opt_274item_id NVARCHAR(max)
    DECLARE @opt_275site_id NVARCHAR(max)
    DECLARE @opt_276item_id NVARCHAR(max)
    DECLARE @opt_277item_name NVARCHAR(max)
    DECLARE @opt_278site_id NVARCHAR(max)
    DECLARE @opt_279item_id NVARCHAR(max)
    DECLARE @opt_280site_id NVARCHAR(max)
    DECLARE @opt_281operation_id NVARCHAR(max)
    DECLARE @opt_282item_id NVARCHAR(max)
    DECLARE @opt_283site_id NVARCHAR(max)
    DECLARE @opt_284item_id NVARCHAR(max)
    DECLARE @opt_285site_id NVARCHAR(max)
    DECLARE @opt_286item_id NVARCHAR(max)
    DECLARE @opt_287site_id NVARCHAR(max)
    DECLARE @opt_288item_id NVARCHAR(max)
    DECLARE @opt_289site_id NVARCHAR(max)
    DECLARE @opt_290item_id NVARCHAR(max)
    DECLARE @opt_291site_id NVARCHAR(max)
    DECLARE @opt_292item_id NVARCHAR(max)
    DECLARE @opt_293item_name NVARCHAR(max)
    DECLARE @opt_294site_id NVARCHAR(max)
    DECLARE @opt_295item_id NVARCHAR(max)
    DECLARE @opt_296item_name NVARCHAR(max)
    DECLARE @opt_297site_id NVARCHAR(max)
    DECLARE @opt_298item_id NVARCHAR(max)
    DECLARE @opt_299site_id NVARCHAR(max)
    DECLARE @opt_300item_id NVARCHAR(max)
    DECLARE @opt_301site_id NVARCHAR(max)
    DECLARE @opt_302item_id NVARCHAR(max)
    DECLARE @opt_303site_id NVARCHAR(max)
    DECLARE @opt_304item_id NVARCHAR(max)
    DECLARE @opt_305site_id NVARCHAR(max)
    DECLARE @opt_306item_id NVARCHAR(max)
    DECLARE @opt_307item_name NVARCHAR(max)
    DECLARE @opt_308site_id NVARCHAR(max)
    DECLARE @opt_309item_id NVARCHAR(max)
    DECLARE @opt_310item_name NVARCHAR(max)
    DECLARE @opt_311site_id NVARCHAR(max)
    DECLARE @opt_312operation_id NVARCHAR(max)
    DECLARE @opt_313top_item_id NVARCHAR(max)
    DECLARE @opt_314item_id NVARCHAR(max)
    DECLARE @opt_315prod_type NVARCHAR(max)
    DECLARE @opt_316site_id NVARCHAR(max)
    DECLARE @opt_317operation_id NVARCHAR(max)
    DECLARE @opt_318top_item_id NVARCHAR(max)
    DECLARE @opt_319item_id NVARCHAR(max)
    DECLARE @opt_320prod_type NVARCHAR(max)
    DECLARE @opt_321site_id NVARCHAR(max)
    DECLARE @opt_322item_id NVARCHAR(max)

	DECLARE @SCM_PANCAKE_VIEW_TALBE NVARCHAR(50) = 'SCM_PANCAKE_MATERIAL_ALL_VERSION_V'
    --Optional Parameter Part END 


--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += ' @P_SYS_TYPE	= ''' +ISNULL(@P_SYS_TYPE,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_FLAG	= ''' +ISNULL(@P_SYS_FLAG,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_GUBUN	= ''' +ISNULL(@P_SYS_GUBUN,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_USER_ID		= ''' +ISNULL(@P_USER_ID,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_columns	= ''' +ISNULL(@in_columns,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_row		= ''' +ISNULL(@in_row,'')		+ '''' + CHAR(10)
--SET @PARAMS += ',@opt_none		= ''' +ISNULL(@opt_none,'')		+ '''' + CHAR(10)

--IF @P_SYS_TYPE = 'SQL' BEGIN
--	SELECT @PARAMS AS SQL
--	RETURN
--END



    SET @v_delimiter = '^' -- 데이터 구분자 
    SET @max_loop_cnt = [dbo].[Scm_arr_spl_cnt](@in_columns, @v_delimiter)
    -- 프로시저 LOOP 길이를 판단 

    DECLARE @tmp_column NVARCHAR(max) = ''

    WHILE @mst_loop_cnt < @max_loop_cnt
    BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트   
        SET @mst_loop_cnt = @mst_loop_cnt + 1; -- @mst_loop_cnt 1증가 
        SET @tmp_column = [dbo].[Scm_arr_spl_val](@in_columns, @v_delimiter, @mst_loop_cnt);

        IF @tmp_column = '_SAVE_AUTH'
        BEGIN
            SET @tmp_column = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'MASTER_ID'
        BEGIN
            SET @p_master_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PLAN_ID'
        BEGIN
            SET @p_plan_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'BUCKET_FROM'
        BEGIN
            SET @p_bucket_from = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'BUCKET_TO'
        BEGIN
            SET @p_bucket_to = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'SITE_ID'
        BEGIN
            SET @p_site_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'OPERATION_ID'
        BEGIN
            SET @p_operation_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'ITEM_ID'
        BEGIN
            SET @p_item_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PLAN_DATE'
        BEGIN
            SET @p_plan_date = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'ITEM_NAME'
        BEGIN
            SET @p_item_name = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'BASIS_PLAN_ID'
        BEGIN
            SET @p_basis_plan_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'INSTANCE_ID'
        BEGIN
            SET @p_instance_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'TOP_ITEM_ID'
        BEGIN
            SET @p_top_item_id = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PROD_TYPE'
        BEGIN
            SET @p_prod_type = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CATE_INFO'
        BEGIN
            SET @p_cate_info = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'BUCKET'
        BEGIN
            SET @p_bucket = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'WEEK_INFO'
        BEGIN
            SET @p_week_info = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'MONTH_INFO'
        BEGIN
            SET @p_month_info = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'DIVISION_ID'
        BEGIN
            SET @p_division_lt = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PLANT_ID'
        BEGIN
            SET @p_plant_lt = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'FACTORY_ID'
        BEGIN
            SET @p_factory_lt = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'LINE_ID'
        BEGIN
            SET @p_line_lt = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PRODTYPE_LT'
        BEGIN
            SET @p_prodtype_lt = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'NICKNAME'
        BEGIN
            SET @p_nickname = [dbo].[scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
		ELSE IF @tmp_column = 'NICKNAME_LT'
        BEGIN
            SET @p_nickname_lt = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'PARAM'
        BEGIN
            SET @p_param = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CATEGORYINFO'
        BEGIN
            SET @p_categoryinfo = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'ROUND_POINT'
        BEGIN
            SET @p_ROUND_POINT = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'CATE_INFO'
        BEGIN
            SET @p_cate_info = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'WEEK_INFO'
        BEGIN
            SET @p_week_info = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'AMEND_TABLE'
        BEGIN
            SET @p_amend_table = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'AMEND_CAPA_TABLE'
        BEGIN
            SET @p_amend_capa_table = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'AMEND_SALES_TABLE'
        BEGIN
            SET @p_AMEND_SALES_TABLE = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
		
		ELSE IF @tmp_column = 'AMEND_UTIL_TABLE'
        BEGIN
            SET @p_amend_util_table = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = 'QUERYSET1'
        BEGIN
            SET @p_queryset1 = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
        ELSE IF @tmp_column = '_NON_AUTH'
        BEGIN
            SET @tmp_column = [dbo].[Scm_arr_spl_val](@in_row, @v_delimiter, @mst_loop_cnt);
        END
    END

    SET @v_ROUND_POINT = Isnull(@p_ROUND_POINT, '1')
    --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id) 
    SET @v_master_id = '''' + @p_master_id + ''''
    SET @v_plan_id = '''' + @p_plan_id + ''''
    SET @v_bucket_from = '''' + @p_bucket_from + ''''
    SET @v_bucket_to = '''' + @p_bucket_to + ''''
    SET @v_site_id = '''' + @p_site_id + ''''
    SET @v_operation_id = '''' + @p_operation_id + ''''
    SET @v_item_id = '''' + @p_item_id + ''''
    SET @v_plan_date = '''' + @p_plan_date + ''''
    SET @v_item_name = '''' + @p_item_name + ''''
    SET @v_basis_plan_id = '''' + @p_basis_plan_id + ''''
    SET @v_instance_id = '''' + @p_instance_id + ''''
    SET @v_top_item_id = '''' + @p_top_item_id + ''''
    SET @v_prod_type = '''' + @p_prod_type + ''''
    SET @v_user_id = '''' + @p_user_id + ''''
    SET @v_cate_info = '''' + @p_cate_info + ''''
    SET @v_bucket = '''' + @p_bucket + ''''
    SET @v_week_info = '''' + @p_week_info + ''''
    SET @v_month_info = '''' + @p_month_info + ''''
    SET @v_division_lt = '''' + @p_division_lt + ''''
    SET @v_plant_lt = '''' + @p_plant_lt + ''''
    SET @v_factory_lt = '''' + @p_factory_lt + ''''
    SET @v_line_lt = '''' + @p_line_lt + ''''
    SET @v_prodtype_lt = '''' + @p_prodtype_lt + ''''
    SET @v_nickname_lt = '''' + @p_nickname_lt + ''''
    SET @v_param = '''' + @p_param + ''''
    SET @v_categoryinfo = '''' + @p_categoryinfo + ''''
    SET @v_queryset1 = '''' + @p_queryset1 + ''''
    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_0master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_0master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_1master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_1master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_2master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_2master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_3master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_3master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_4master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_4master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_5master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_5master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_6master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_6master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_7master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_7master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_8master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_8master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_9master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_9master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_10master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_10master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_11master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_11master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_12master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_12master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_13master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_13master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_14master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_14master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_15master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_15master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_16master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_16master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_17master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_17master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_18master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_18master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_19master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_19master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_20master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_20master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_21master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_21master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_22master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_22master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_23master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_23master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_24master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_24master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_25master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_25master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_26master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_26master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_27master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_27master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_28master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_28master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_29master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_29master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_30master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_30master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_31master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_31master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_32master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_32master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_33master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_33master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_34master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_34master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_35master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_35master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_36master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_36master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_37master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_37master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_38master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_38master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_39master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_39master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_40master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_40master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_41master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_41master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_42master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_42master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_43master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_43master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_44master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_44master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_45master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_45master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_46master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_46master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_47master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_47master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_48master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_48master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_49master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_49master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_50master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_50master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_51master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_51master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_52master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_52master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_53master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_53master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_54master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_54master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_55master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_55master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_56master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_56master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_57master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_57master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_58master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_58master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_59master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_59master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_60master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_60master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_61master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_61master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_62master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_62master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_63master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_63master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_64master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_64master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_65master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_65master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_66master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_66master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_67master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_67master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_68master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_68master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_69master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_69master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_70master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_70master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_71master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_71master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_72master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_72master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_73master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_73master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_74master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_74master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_75master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_75master_id = 'i'
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_76site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_76site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_77item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_77item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_78site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_78site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_79item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_79item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_80site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_80site_id = 'AND    B.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_81item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_81item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_82site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_82site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_83item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_83item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_84site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_84site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_85item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_85item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_86site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_86site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_87item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_87item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_88site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_88site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_89item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_89item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_90item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_90item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_91site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_91site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_92item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_92item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_93site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_93site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_94operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_94operation_id = 'AND    C.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_95item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_95item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_96site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_96site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_97item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_97item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_98master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_98master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_99master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_99master_id = 'i'
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_100master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_100master_id = 'i'
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_101site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_101site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_102item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_102item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_103site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_103site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_104item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_104item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_105site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_105site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_106item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_106item_id = 'AND    A.ELEC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_107site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_107site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_108item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_108item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_109item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_109item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_110site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_110site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_111item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_111item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_112item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_112item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_plan_date)

    IF @STRLEN < 1
    BEGIN
        SET @opt_113plan_date = ''
    END
    ELSE
    BEGIN
        SET @opt_113plan_date = 'i'
    END

    SET @STRLEN = Len(@p_plan_date)

    IF @STRLEN < 1
    BEGIN
        SET @opt_114plan_date = ''
    END
    ELSE
    BEGIN
        SET @opt_114plan_date = 'i'
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_115site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_115site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_116item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_116item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_117site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_117site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_118item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_118item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_119site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_119site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_120item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_120item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_121site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_121site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_122item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_122item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_123site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_123site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_124item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_124item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_125item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_125item_name = 'AND    C.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_126site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_126site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_127item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_127item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_128item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_128item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_instance_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_129instance_id = ''
    END
    ELSE
    BEGIN
        SET @opt_129instance_id = 'i'
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_130site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_130site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_131operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_131operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_132top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_132top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_133item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_133item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_134prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_134prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_master_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_135master_id = ''
    END
    ELSE
    BEGIN
        SET @opt_135master_id = 'i'
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_136site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_136site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_137operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_137operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_138top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_138top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_139item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_139item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_140prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_140prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_141site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_141site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_142item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_142item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_143site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_143site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_144item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_144item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_145site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_145site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_146item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_146item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_147site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_147site_id = 'AND    B.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_148item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_148item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_149site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_149site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_150item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_150item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_151site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_151site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_152item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_152item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_153site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_153site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_154item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_154item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_155site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_155site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_156item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_156item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_157item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_157item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_158site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_158site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_159item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_159item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_160site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_160site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_161operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_161operation_id = 'AND    C.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_162item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_162item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_163site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_163site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_164item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_164item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_165site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_165site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_166item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_166item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_167site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_167site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_168item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_168item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_169site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_169site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_170item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_170item_id = 'AND    A.ELEC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_171site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_171site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_172item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_172item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_173item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_173item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_174site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_174site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_175item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_175item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_176item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_176item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_177site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_177site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_178item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_178item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_179site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_179site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_180item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_180item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_181site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_181site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_182item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_182item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_183site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_183site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_184item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_184item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_185site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_185site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_186item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_186item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_187item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_187item_name = 'AND    C.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_188site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_188site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_189item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_189item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_190item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_190item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_191site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_191site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_192operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_192operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_193top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_193top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_194item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_194item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_195prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_195prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_196site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_196site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_197operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_197operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_198top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_198top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_199item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_199item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_200prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_200prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_201site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_201site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_202item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_202item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_203site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_203site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_204item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_204item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_205site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_205site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_206item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_206item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_207site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_207site_id = 'AND    B.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_208item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_208item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_209site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_209site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_210item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_210item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_211site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_211site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_212item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_212item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_213site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_213site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_214item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_214item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_215site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_215site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_216item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_216item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_217item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_217item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_218site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_218site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_219item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_219item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_220site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_220site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_221operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_221operation_id = 'AND    C.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_222item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_222item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_223site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_223site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_224item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_224item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_225site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_225site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_226item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_226item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_227site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_227site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_228item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_228item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_229site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_229site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_230item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_230item_id = 'AND    A.ELEC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_231site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_231site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_232item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_232item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_233item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_233item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_234site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_234site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_235item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_235item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_236item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_236item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_237site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_237site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_238item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_238item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_239site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_239site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_240item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_240item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_241site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_241site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_242item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_242item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_243site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_243site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_244item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_244item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_245site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_245site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_246item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_246item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_247item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_247item_name = 'AND    C.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_248site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_248site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_249item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_249item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_250item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_250item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_251site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_251site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_252operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_252operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_253top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_253top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_254item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_254item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_255prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_255prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_256site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_256site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_257operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_257operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_258top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_258top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_259item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_259item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_260prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_260prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_261site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_261site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_262item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_262item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_263site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_263site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_264item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_264item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_265site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_265site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_266item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_266item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_267site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_267site_id = 'AND    B.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_268item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_268item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_269site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_269site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_270item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_270item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_271site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_271site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_272item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_272item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_273site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_273site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_274item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_274item_id = 'AND    A.PC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_275site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_275site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_276item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_276item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_277item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_277item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_278site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_278site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_279item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_279item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_280site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_280site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_281operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_281operation_id = 'AND    C.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_282item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_282item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_283site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_283site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_284item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_284item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_285site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_285site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_286item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_286item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_287site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_287site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_288item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_288item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_289site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_289site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_290item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_290item_id = 'AND    A.ELEC_ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_291site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_291site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_292item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_292item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_293item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_293item_name = 'AND   B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_294site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_294site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_295item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_295item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_296item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_296item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_297site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_297site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_298item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_298item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_299site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_299site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_300item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_300item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_301site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_301site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_302item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_302item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_303site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_303site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_304item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_304item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_305site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_305site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_306item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_306item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_307item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_307item_name = 'AND    C.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_308site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_308site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_309item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_309item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_name)

    IF @STRLEN < 1
    BEGIN
        SET @opt_310item_name = ''
    END
    ELSE
    BEGIN
        SET @opt_310item_name = 'AND    B.NICK_NAME LIKE ''%'' + LTRIM(RTRIM( ' + @v_item_name + ' )) + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_311site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_311site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_312operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_312operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_313top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_313top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_314item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_314item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_315prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_315prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_316site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_316site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_operation_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_317operation_id = ''
    END
    ELSE
    BEGIN
        SET @opt_317operation_id = 'AND    A.OPERATION_ID   = ' + @v_operation_id + ''
    END

    SET @STRLEN = Len(@p_top_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_318top_item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_318top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + ' + @v_top_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_319item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_319item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    SET @STRLEN = Len(@p_prod_type)

    IF @STRLEN < 1
    BEGIN
        SET @opt_320prod_type = ''
    END
    ELSE
    BEGIN
        SET @opt_320prod_type = 'AND    A.PRODUCTION_TYPE LIKE ''%'' + ' + @v_prod_type + ' + ''%'''
    END

    SET @STRLEN = Len(@p_site_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_321site_id = ''
    END
    ELSE
    BEGIN
        SET @opt_321site_id = 'AND    A.SITE_ID   = ' + @v_site_id + ''
    END

    SET @STRLEN = Len(@p_item_id)

    IF @STRLEN < 1
    BEGIN
        SET @opt_322item_id = ''
    END
    ELSE
    BEGIN
        SET @opt_322item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id + ' + ''%'''
    END

    DECLARE @sub_mst_loop_cnt INTEGER = 0
    DECLARE @sub_max_loop_cnt INTEGER = 0
    DECLARE @sub_v_delimiter NVARCHAR(2) = '#'
    DECLARE @sub_tmp_column NVARCHAR(max) = ''
    DECLARE @sub_param_0 NVARCHAR(max) = ''
    DECLARE @sub_param_1 NVARCHAR(max) = ''
    DECLARE @sub_param_2 NVARCHAR(max) = ''
    DECLARE @sub_param_3 NVARCHAR(max) = ''
    DECLARE @sub_param_4 NVARCHAR(max) = ''
    DECLARE @pSql VARCHAR(max) = ''
    DECLARE @omitSql VARCHAR(max) = ''
    DECLARE @sSql VARCHAR(Max) = ''
    DECLARE @so_dsql VARCHAR(max) = ''

    SET @pSql = ''

    DECLARE @bSM INTEGER = 0
    DECLARE @bSCell INTEGER = 0
    DECLARE @bSscp INTEGER = 0
    DECLARE @bSBatch INTEGER = 0
    DECLARE @bPastSales INTEGER = 0
    DECLARE @bAssyPlan INTEGER = 0


    DECLARE @binqty INTEGER = 0 --y
    DECLARE @boutqty INTEGER = 0 --y

    DECLARE @bmppinqty INTEGER = 0
    DECLARE @bmppoutqty INTEGER = 0
    DECLARE @bwppinqty INTEGER = 0
    DECLARE @bwppoutqty INTEGER = 0
    DECLARE @bresultin INTEGER = 0
    DECLARE @bresultout INTEGER = 0
    DECLARE @benginein INTEGER = 0 --y
    DECLARE @bengineout INTEGER = 0 --y
    --DECLARE @bresult INTEGER = 0 
    DECLARE @bseq INTEGER = 0 --y
    --DECLARE @bsim INTEGER = 0 
    --DECLARE @bdpp INTEGER = 0 
    --DECLARE @bwpp INTEGER = 0 
    --DECLARE @bmpp INTEGER = 0 
    --DECLARE @bengine INTEGER = 0 
    DECLARE @bmemo INTEGER = 0 
    --DECLARE @bofftime INTEGER = 0 
    DECLARE @bcapa INTEGER = 0 --y
    --DECLARE @bsetup INTEGER = 0 
    DECLARE @bpc INTEGER = 0 --y
    DECLARE @bjr INTEGER = 0 --y
    DECLARE @bcell INTEGER = 0 --y
    DECLARE @bbatch INTEGER = 0 --y
    DECLARE @btotal INTEGER = 0 --y
    DECLARE @bsubtotal INTEGER = 0 --y

    DECLARE @bInventory INTEGER = 0 --N
    DECLARE @bInMPP INTEGER = 0
    DECLARE @bOutMPP INTEGER = 0
    DECLARE @bInWpp INTEGER = 0
    DECLARE @bOutWpp INTEGER = 0 --N

    DECLARE @bpcOut INTEGER = 0 --y
    DECLARE @bjrOut INTEGER = 0 --y
    DECLARE @bcellOut INTEGER = 0 --y
    DECLARE @bbatchOut INTEGER = 0 --y

    DECLARE @bDpp INTEGER = 0 --y
    DECLARE @bMpp INTEGER = 0 --y
    DECLARE @bWpp INTEGER = 0 --y
    DECLARE @bResult INTEGER = 0 --y
    DECLARE @bEngine INTEGER = 0 --y

	DECLARE @bSunWeek				NVARCHAR(2) = 'N'
	DECLARE @WeekColumn NVARCHAR(10) = 'ISO_YYYYWW';

    --          var bDpp = ""; 
    --          var bMpp = ""; 
    --          var bWpp = ""; 
    --          var bResult = ""; 
    --          var bEngine = ""; 
    -- 
	SET @v_dSql = ''


    -- FP00598_carryOver find_FP00598_carryOver   
    SET @v_dSql = ''
	-- 테스트 파트
	--SET @v_dSql += '--' + [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
	--SET @v_dSql += '--' +[DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
	--SET @v_dSql += '--' +[DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
	--SET @v_dSql += '--' +[DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
	--SET @v_dSql += '--' +[DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
	SET @pSql = ''
	SET @omitSql = ''
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    
    IF isnull(@p_cate_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_cate_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        WHILE @mst_loop_cnt < @max_loop_cnt
        BEGIN
            -- 각 컬럼들에 대한 스플릿처리로직 스타트      
            SET @mst_loop_cnt = @mst_loop_cnt + 1;
            -- @mst_loop_cnt 1증가    
            SET @tmp_column = [dbo].[scm_arr_spl_val](@p_cate_info, @v_delimiter, @mst_loop_cnt);
            SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

            IF @sub_max_loop_cnt > 0
            BEGIN
                SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
            END

            IF @sub_max_loop_cnt > 1
            BEGIN
                SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
            END

            IF @sub_max_loop_cnt > 2
            BEGIN
                SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
            END

            IF @sub_max_loop_cnt > 3
            BEGIN
                SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
            END -- D0    

            IF isnull(@sub_param_0, '') = 'chk_week_sun'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bSunWeek = 'Y'
            END
            IF isnull(@sub_param_0, '') = 'chk_S_M'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bSM = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_S_cell'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bSCell = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_S_scp'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bSscp = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_S_batch'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bSBatch = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_past_sales'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bPastSales = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_assy_plan'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bAssyPlan = 1
            END


            IF isnull(@sub_param_0, '') = 'chk_inqty'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @binqty = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_outqty'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @boutqty = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_result'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bResult = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_engine_inqty'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_cell' BEGIN    
                SET @benginein = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_engine_outqty'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN --IF @tmp_column = 'chk_cell' BEGIN    
                SET @bengineout = 1
            END

            IF isnull(@sub_param_0, '') = 'chk_i'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bInventory = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_capa'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bCapa = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_inqty_MPP'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bInMPP = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_outqty_MPP'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bOutMPP = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_inqty_WPP'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bInWPP = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_outqty_WPP'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bOutWPP = 1
            END

            IF isnull(@sub_param_0, '') = 'chk_pc'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bPc = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_jr'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bJr = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_cell'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bCell = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_batch'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bBatch = 1
            END

            IF isnull(@sub_param_0, '') = 'chk_pc_out'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bPcOut = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_jr_out'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bJrOut = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_cell_out'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bCellOut = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_batch_out'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bBatchOut = 1
            END

            IF isnull(@sub_param_0, '') = 'chk_total'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bTotal = 1
            END
            IF isnull(@sub_param_0, '') = 'chk_subTotal'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bSubTotal = 1
            END

			IF isnull(@sub_param_0, '') = 'chk_memo'
               AND isnull(@sub_param_1, '') = 'true'
            BEGIN
                SET @bMemo = 1
            END




            IF (
                   isnull(@sub_param_0, '') = 'chk_inqty'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_outqty'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bdpp = 1
            END
            IF (
                   isnull(@sub_param_0, '') = 'chk_inqty_MPP'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_outqty_MPP'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bmpp = 1
            END
            IF (
                   isnull(@sub_param_0, '') = 'chk_inqty_WPP'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_outqty_WPP'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bwpp = 1
            END
            IF (
                   isnull(@sub_param_0, '') = 'chk_result'
                   AND isnull(@sub_param_1, '') = 'true'
               )
            BEGIN
                SET @bResult = 1
            END
            IF (
                   isnull(@sub_param_0, '') = 'chk_engine_inqty'
                   AND isnull(@sub_param_1, '') = 'true'
               )
               OR (
                      isnull(@sub_param_0, '') = 'chk_engine_outqty'
                      AND isnull(@sub_param_1, '') = 'true'
                  )
            BEGIN
                SET @bengine = 1
            END

        END -- END OF WHILE    

		--SET @v_dSql += '=====dbg 111======'
		--	SELECT @v_dSql AS [QUERY_VALUE]
		--RETURN
		IF ISNULL(@bSunWeek,'') = 'Y' BEGIN
			SET @WeekColumn = 'YYYYWW'
		END

        SET @pSql 
            += 'SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS LV1_NAME, 0 AS CATEGORY_ORDER ' + char(10)
 --      		SET @v_dSql += '=====dbg 111======'
	--SELECT @pSql AS [QUERY_VALUE]
	--RETURN

	   -- 
        IF @bInMPP = 1
           AND @bPc = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.3 AS CATEGORY_ORDER '
                           + char(10)
        END
	--	       		SET @v_dSql += '=====dbg 111======'
	----SELECT @v_dSql AS [QUERY_VALUE]
	--SELECT 'xxxxxx' AS [QUERY_VALUE]
	--RETURN
        IF @bInMPP = 1
           AND @bJr = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.2 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInMPP = 1
           AND @bCell = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.4 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInMPP = 1
           AND @bBatch = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.1 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutMPP = 1
           AND @bPcOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.7 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutMPP = 1
           AND @bJrOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.6 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutMPP = 1
           AND @bCellOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.8 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutMPP = 1
           AND @bBatchOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.5 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInWPP = 1
           AND @bPc = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.3 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInWPP = 1
           AND @bJr = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.2 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInWPP = 1
           AND @bCell = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.4 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInWPP = 1
           AND @bBatch = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.1 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutWPP = 1
           AND @bPcOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.7 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutWPP = 1
           AND @bJrOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.6 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutWPP = 1
           AND @bCellOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.8 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutWPP = 1
           AND @bBatchOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.5 AS CATEGORY_ORDER '
                           + char(10)
        END
        -- 
        -- 
        IF @bInqty = 1
           AND @bPc = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 30 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInqty = 1
           AND @bJr = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 20 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInqty = 1
           AND @bCell = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 40 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bInqty = 1
           AND @bBatch = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 10 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutqty = 1
           AND @bPcOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 70 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutqty = 1
           AND @bJrOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 60 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutqty = 1
           AND @bCellOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 80 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bOutqty = 1
           AND @bBatchOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 50 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bCapa = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_CAPA'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, ''Load(%)'' AS LV1_NAME, 90 AS CATEGORY_ORDER     '
                           + char(10)
        END
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_RESULT'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, ''Result'' AS LV1_NAME, 100 AS CATEGORY_ORDER     ' + char(10)
        -- 
        IF @bEngineIn = 1
           AND @bBatch = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.1 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bEngineIn = 1
           AND @bJr = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.2 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bEngineIn = 1
           AND @bPc = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.3 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bEngineIn = 1
           AND @bCell = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.4 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bEngineOut = 1
           AND @bBatchOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.1 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bEngineOut = 1
           AND @bJrOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.2 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bEngineOut = 1
           AND @bPcOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.3 AS CATEGORY_ORDER '
                           + char(10)
        END
        IF @bEngineOut = 1
           AND @bCellOut = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_ENGINE_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.4 AS CATEGORY_ORDER '
                           + char(10)
        END

	    IF @bMemo = 1
        BEGIN
            SET @pSql += 'UNION ALL ' + char(10)
            SET @pSql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, 100 AS CATEGORY_ORDER' + char(10)
        END

        -- 
        SET @sSql += 'SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS LV1_NAME, 0 AS CATEGORY_ORDER, '''' AS CATE '
                     + char(10)
        -- 
        IF @bSM = 1
        BEGIN
            SET @sSql += 'UNION ALL ' + char(10)
            SET @sSql += 'SELECT ''S_PC'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -190 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                         + char(10)
        END
        -- 
        IF @bSCell = 1
        BEGIN
            SET @sSql += 'UNION ALL ' + char(10)
            SET @sSql += 'SELECT ''S_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -180 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                         + char(10)
        END
        -- 
        IF @bSBatch = 1
        BEGIN
            SET @sSql += 'UNION ALL ' + char(10)
            SET @sSql += 'SELECT ''S_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -200 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                         + char(10)
        END
        -- 
        IF @bSscp = 1
        BEGIN
            SET @sSql += 'UNION ALL ' + char(10)
            SET @sSql += 'SELECT ''S_SCP_PC'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Target(SCP)'' AS LV1_NAME, -150 AS CATEGORY_ORDER, ''SCP'' AS CATE '
                         + char(10)
            SET @sSql += 'UNION ALL ' + char(10)
            SET @sSql += 'SELECT ''S_SCP_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Target(SCP)'' AS LV1_NAME, -160 AS CATEGORY_ORDER, ''SCP'' AS CATE '
                         + char(10)
        END
        -- 
        IF @bPastSales = 1
        BEGIN
            SET @sSql += 'UNION ALL ' + char(10)
            SET @sSql += 'SELECT ''S_PAST_SALES'' AS CATEGORY_ID, ''S(W-1)'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -210 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                         + char(10)
        END
        -- 
        IF @bAssyPlan = 1
        BEGIN
            SET @sSql += 'UNION ALL ' + char(10)
            SET @sSql += 'SELECT ''S_ASSY_PLAN'' AS CATEGORY_ID, ''Assy Plan'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -170 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                         + char(10)
        END


    -- 
    END
    ELSE
    BEGIN
	--	SET @v_dSql += '=====dbg 111======'
	----SET @v_dSql += @pSql
	----SET @v_dSql += @sSql
	--SELECT @v_dSql AS [QUERY_VALUE]
	--RETURN
        SET @pSql += 'SELECT ''P_MPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.3 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_MPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.2 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_MPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.4 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_MPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''MPP (In)'' AS LV1_NAME, 2.1 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_MPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.7 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_MPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.6 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_MPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.8 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_MPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''MPP (Out)'' AS LV1_NAME, 2.5 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.3 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.2 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.4 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''WPP (In)'' AS LV1_NAME, 3.1 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.7 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.6 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.8 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_WPP_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''WPP (Out)'' AS LV1_NAME, 3.5 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 30 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 20 AS CATEGORY_ORDER        '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 40 AS CATEGORY_ORDER     '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Plan (In)'' AS LV1_NAME, 10 AS CATEGORY_ORDER   '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 70 AS CATEGORY_ORDER    '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 60 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 80 AS CATEGORY_ORDER   '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Plan (Out)'' AS LV1_NAME, 50 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_CAPA'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, ''Load(%)'' AS LV1_NAME, 90 AS CATEGORY_ORDER     '
                       + char(10)
        SET @pSql += 'UNION ALL                                                                                              '
                       + char(10)
        SET @pSql += 'SELECT ''P_RESULT'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, ''Result'' AS LV1_NAME, 100 AS CATEGORY_ORDER      '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_IN_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.1 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_IN_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.2 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_IN_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.3 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_IN_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Engine (In)'' AS LV1_NAME, 9.4 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.1 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.2 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_OUT_M'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.3 AS CATEGORY_ORDER '
                       + char(10)
        SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_ENGINE_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Engine (Out)'' AS LV1_NAME, 49.4 AS CATEGORY_ORDER '
                       + char(10)
        -- 
        -- 
        SET @sSql += 'SELECT ''S_PC'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -190 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE  '
                     + char(10)
        SET @sSql += '    ' + char(10)
        SET @sSql += 'UNION ALL                                                                                              '
                     + char(10)
        SET @sSql += 'SELECT ''S_CELL'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -180 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE  '
                     + char(10)
        SET @sSql += 'UNION ALL                                                 ' + char(10)
        SET @sSql += 'SELECT ''S_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -200 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                     + char(10)
        SET @sSql += 'UNION ALL ' + char(10)
        SET @sSql += 'SELECT ''S_SCP_PC'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, ''Target(SCP)'' AS LV1_NAME, -150 AS CATEGORY_ORDER, ''SCP'' AS CATE '
                     + char(10)
        SET @sSql += 'UNION ALL ' + char(10)
        SET @sSql += 'SELECT ''S_SCP_BATCH'' AS CATEGORY_ID, ''Batch'' AS CATEGORY_NAME, ''Target(SCP)'' AS LV1_NAME, -160 AS CATEGORY_ORDER, ''SCP'' AS CATE '
                     + char(10)
        SET @sSql += 'UNION ALL ' + char(10)
        SET @sSql += 'SELECT ''S_PAST_SALES'' AS CATEGORY_ID, ''S(W-1)'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -210 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                     + char(10)
        SET @sSql += 'UNION ALL ' + char(10)
        SET @sSql += 'SELECT ''S_ASSY_PLAN'' AS CATEGORY_ID, ''Assy Plan'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, -170 AS CATEGORY_ORDER, ''PRODUCT_TARGET'' AS CATE '
                     + char(10)
		SET @pSql += 'UNION ALL ' + char(10)
        SET @pSql += 'SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, ''Target'' AS LV1_NAME, 100 AS CATEGORY_ORDER, ''P_MEMO'' AS CATE '
                         + char(10)
    END
	--SET @v_dSql += '=====dbg 111======'
	----SET @v_dSql += @pSql
	----SET @v_dSql += @sSql
	--SELECT @v_dSql AS [QUERY_VALUE]
	--RETURN

    --var omitSql = " AND (  1=0 "; 
    -- 
    --            if( bMpp == "Y" ) omitSql+= " OR ISNULL(A.MPP_IN_QTY_BATCH,0) <> 0 "; 
    --            if( bWpp == "Y" ) omitSql+= " OR ISNULL(A.WPP_IN_QTY_BATCH,0) <> 0 "; 
    --            if( bDpp == "Y" ) omitSql+= " OR ISNULL(A.ADJUST_IN_QTY_BATCH,0) <> 0 "; 
    --            if( bResult == "Y" ) omitSql+= " OR ISNULL(A.RESULT_OUT_QTY_BATCH,0) <> 0 "; 
    --            if( bEngine == "Y" ) omitSql+= " OR ISNULL(A.PLAN_IN_QTY_BATCH,0) <> 0 "; 
    -- 
    --            omitSql+= " ) "; 
    -- 
    --            var sOmitSql = " AND (  1=0 "; 
    -- 
    --            if( bSM == "Y" ) sOmitSql+= " OR ISNULL(A.TARGET_QTY_M,0)  <> 0 "; 
    --            if( bSCell == "Y" ) sOmitSql+= " OR ISNULL(A.TARGET_QTY_CELL,0)  <> 0 "; 
    --            if( bSBatch == "Y" ) sOmitSql+= " OR ISNULL(A.TARGET_QTY_BATCH,0)  <> 0 "; 
    --            if( bPastSales == "Y" ) sOmitSql+= " OR ISNULL(A.PAST_SALES_QTY,0)  <> 0 "; 
    -- 
    --            sOmitSql+= " ) "; 
    -- 
    --          var sql=""; 
    --          sql=""; 
    --      } 

    SET @omitSql = ''
    SET @omitSql += ' AND (  1=0 ' + Char(10)

    IF @bmpp = 1
    BEGIN
        SET @omitSql += ' OR ISNULL(A.MPP_IN_QTY_BATCH,0) <> 0 ' + Char(10)
    END

    IF @bwpp = 1
    BEGIN
        SET @omitSql += ' OR ISNULL(A.WPP_IN_QTY_BATCH,0) <> 0 ' + Char(10)
    END

    IF @bdpp = 1
    BEGIN
        SET @omitSql += ' OR ISNULL(A.ADJUST_IN_QTY_BATCH,0) <> 0 ' + Char(10)
    END

    IF @bresult = 1
    BEGIN
        SET @omitSql += ' OR ISNULL(A.RESULT_OUT_QTY_BATCH,0) <> 0 ' + Char(10)
    END

    IF @bengine = 1
    BEGIN
        SET @omitSql += ' OR ISNULL(A.PLAN_IN_QTY_BATCH,0) <> 0 ' + Char(10)
    END

    SET @omitSql += ')' + Char(10)

    SET @so_dsql = ''
    SET @so_dsql += ' AND (  1=0 ' + Char(10)

    IF @bSM = 1
    BEGIN
        SET @so_dsql += ' OR ISNULL(A.TARGET_QTY_M,0) <> 0 ' + Char(10)
    END

    IF @bSCell = 1
    BEGIN
        SET @so_dsql += ' OR ISNULL(A.TARGET_QTY_CELL,0) <> 0 ' + Char(10)
    END

    IF @bSBatch = 1
    BEGIN
        SET @so_dsql += ' OR ISNULL(A.TARGET_QTY_BATCH,0) <> 0 ' + Char(10)
    END

    IF @bPastSales = 1
    BEGIN
        SET @so_dsql += ' OR ISNULL(A.PAST_SALES_QTY,0) <> 0 ' + Char(10)
    END

    SET @so_dsql += ')' + Char(10)

    --END    
    --END    
    --SET @v_dsql = ''
	SET @v_dSql += N'IF OBJECT_ID(''tempdb..#MAIN_P'') IS NOT NULL  DROP TABLE #MAIN_P ' + char(10) --Tuning_block_01 begin
	SET @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP01'') IS NOT NULL  DROP TABLE #TEMP01 ' + char(10)
	SET @v_dSql += N'if object_id(''tempdb..#FOIL_INFO'') is not null	DROP TABLE #FOIL_INFO ' + char(10) -- foil 정보 수정... 20240329
	SET @v_dSql += N'' + char(10)
	-- foil 정보 수정... 20240329
	SET @v_dSql += N'SELECT A.* ' + char(10)
	SET @v_dSql += N'INTO #FOIL_INFO ' + char(10)
	SET @v_dSql += N'FROM   ( ' + char(10)
	SET @v_dSql += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID, A.MODEL_ID, A.PROD_VERSION AS VERSION ' + char(10)
	SET @v_dSql += N'		 , ROW_NUMBER() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID, A.MODEL_ID, A.PROD_VERSION ' + char(10)
	SET @v_dSql += N'		 				       ORDER BY     V.APPLY_DATE DESC )  AS NUM ' + char(10)
	SET @v_dSql += N'	FROM ( ' + char(10)
	SET @v_dSql += N'		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
	SET @v_dSql += N'			 , A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, A.PROD_SEQ ' + char(10)
	SET @v_dSql += N'			 , A.PROD_VERSION_TYPE, A.FOIL_ID ' + char(10)
	SET @v_dSql += N'		FROM   ( ' + char(10)
	SET @v_dSql += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
	SET @v_dSql += N'				 , A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION, A.PROD_SEQ ' + char(10) -- key value
	SET @v_dSql += N'				 , A.PROD_VERSION_TYPE, A.FOIL_ID ' + char(10)
	SET @v_dSql += N'				 , ROW_NUMBER() OVER ( PARTITION BY A.FACTORY_ID, A.MODEL_ID, A.ITEM_ID, A.PROD_VERSION ORDER BY A.PROD_SEQ DESC ) AS NUM ' + char(10)
	SET @v_dSql += N'			FROM   SCM_ITEM_FOIL_M A WITH(NOLOCK) ' + char(10)
	SET @v_dSql += N'			WHERE  1=1 ' + char(10)
    SET @v_dsql += N'			'+( SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt) )
    SET @v_dsql += N'			'+( SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id) )
    SET @v_dsql += N'			'+( SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt) )
    SET @v_dsql += N'			'+( SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt) )
    SET @v_dsql += N'			'+( SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id) ) + Char(10)
	SET @v_dSql += N'		) A ' + char(10)
	SET @v_dSql += N'		WHERE A.NUM = 1 ' + char(10)
	SET @v_dSql += N'	) A ' + char(10)
	SET @v_dSql += N'	, FP_PROD_VERSION_M      V WITH(NOLOCK) ' + char(10)
	SET @v_dSql += N'	, SCM_ITEM_M             B WITH(NOLOCK) ' + char(10)
	SET @v_dSql += N'	, SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK) ' + char(10)
	SET @v_dSql += N'	WHERE A.FACTORY_ID    = V.FACTORY_ID ' + char(10)
	SET @v_dSql += N'	AND   A.MODEL_ID      = V.MODEL_ID ' + char(10)
	SET @v_dSql += N'	AND   A.ITEM_ID       = V.ITEM_ID ' + char(10)
	SET @v_dSql += N'	AND   A.PROD_VERSION  = V.PROD_VERSION ' + char(10)
	SET @v_dSql += N'	AND   A.PROD_SEQ      = V.PROD_SEQ ' + char(10)
	SET @v_dSql += N'	AND   A.COMPANY_ID    = B.COMPANY_ID ' + char(10)
	SET @v_dSql += N'	AND   A.DIVISION_ID   = B.DIVISION_ID ' + char(10)
	SET @v_dSql += N'	AND   A.SITE_ID       = B.SITE_ID ' + char(10)
	SET @v_dSql += N'	AND   A.FOIL_ID       = B.ITEM_ID ' + char(10)
	SET @v_dSql += N'	AND   A.COMPANY_ID    = C.COMPANY_ID ' + char(10)
	SET @v_dSql += N'	AND   A.DIVISION_ID   = C.DIVISION_ID ' + char(10)
	SET @v_dSql += N'	AND   A.SITE_ID       = C.SITE_ID ' + char(10)
	SET @v_dSql += N'	AND   A.PLANT_ID      = C.PLANT_ID ' + char(10)
	SET @v_dSql += N'	AND   A.FACTORY_ID    = C.FACTORY_ID ' + char(10)
	SET @v_dSql += N'	AND   A.ITEM_ID       = C.ITEM_ID ' + char(10)
	SET @v_dSql += N') A ' + char(10)
	SET @v_dSql += N'WHERE A.NUM = 1 ' + char(10)
	SET @v_dSql += N'; ' + char(10)+ char(10)

    SET @v_dSql += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                     , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                     , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                     , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                     , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                     , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME' + Char(10)
    SET @v_dSql += '                     , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '                     , A.MARKET' + Char(10)
    SET @v_dSql += '                     , A.SEQ' + Char(10)
    SET @v_dSql += '                     , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR' + Char(10)
    SET @v_dSql += '                     , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' + Char(10)
    SET @v_dSql += '                     , A.ADJUST_RESULT_QTY_BATCH, A.ADJUST_RESULT_QTY, A.ADJUST_RESULT_QTY_M, A.ADJUST_RESULT_QTY_CELL, A.ADJUST_RESULT_QTY_JR' + Char(10)
    SET @v_dSql += '                     , A.UTILIZATION' + Char(10)
    SET @v_dSql += '                     , B.ITEM_UOM' + Char(10)
    SET @v_dSql += '                     , C.PROD_VERSION_TYPE' + Char(10)
    SET @v_dSql += '                     , A.TOTAL_BATCH' + Char(10)
    SET @v_dSql += '                     , A.ADJUST_IN_QTY_BATCH_MPP, A.ADJUST_IN_QTY_M_MPP, A.ADJUST_IN_QTY_CELL_MPP, A.ADJUST_IN_QTY_JR_MPP' + Char(10)
    SET @v_dSql += '                     , A.ADJUST_OUT_QTY_BATCH_MPP, A.ADJUST_OUT_QTY_M_MPP, A.ADJUST_OUT_QTY_CELL_MPP, A.ADJUST_OUT_QTY_JR_MPP' + Char(10)
    SET @v_dSql += '                     , A.ADJUST_IN_QTY_BATCH_WPP, A.ADJUST_IN_QTY_M_WPP, A.ADJUST_IN_QTY_CELL_WPP, A.ADJUST_IN_QTY_JR_WPP' + Char(10)
    SET @v_dSql += '                     , A.ADJUST_OUT_QTY_BATCH_WPP, A.ADJUST_OUT_QTY_M_WPP, A.ADJUST_OUT_QTY_CELL_WPP, A.ADJUST_OUT_QTY_JR_WPP' + Char(10)
    SET @v_dSql += '                     , A.PLAN_IN_QTY_BATCH, A.PLAN_IN_QTY_M, A.PLAN_IN_QTY_JR, A.PLAN_IN_QTY_CELL' + Char(10)
    SET @v_dSql += '                     , A.PLAN_OUT_QTY_BATCH, A.PLAN_OUT_QTY_M, A.PLAN_OUT_QTY_JR, A.PLAN_OUT_QTY_CELL' + Char(10)
    SET @v_dSql += '                     , ISNULL(X.CALC_TYPE, dbo.FN_GET_CONV_CALC(' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += ', A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, '''', A.ITEM_ID, A.PRODUCTION_TYPE, NULL, ''CALC_TYPE'')) AS CALC_TYPE' + Char(10)
    SET @v_dSql += '                     ,A.WORK_REQUEST_MODEL_ID,A.PLM_EC_NO, BB.PROD_SEQ, A.VERSION' + Char(10)
    SET @v_dSql += '                 into #TEMP01' + Char(10)
    SET @v_dSql += '                 FROM (' + Char(10)
    SET @v_dSql += '                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                             , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                             , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                             , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                             , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                             , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + Char(10)
    SET @v_dSql += '                             , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '                             , A.MARKET' + Char(10)
    SET @v_dSql += '                             , A.SEQ' + Char(10)
	
	SET @v_dSql += ',A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO' + Char(10)
    
	SET @v_dSql += '                             , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR' + Char(10)
    SET @v_dSql += '                             , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' + Char(10)
    SET @v_dSql += '                             , A.RESULT_OUT_QTY_BATCH AS ADJUST_RESULT_QTY_BATCH, A.RESULT_OUT_QTY AS ADJUST_RESULT_QTY, A.RESULT_OUT_QTY_M AS ADJUST_RESULT_QTY_M, A.RESULT_OUT_QTY_CELL AS ADJUST_RESULT_QTY_CELL, A.RESULT_OUT_QTY_JR AS ADJUST_RESULT_QTY_JR' + Char(10)
    SET @v_dSql += '                             , 0 AS UTILIZATION' + Char(10)
    SET @v_dSql += '                             , A.TOTAL_BATCH' + Char(10)
    SET @v_dSql += '                             , A.MPP_IN_QTY_BATCH AS ADJUST_IN_QTY_BATCH_MPP, A.MPP_IN_QTY_M AS ADJUST_IN_QTY_M_MPP, A.MPP_IN_QTY_CELL AS ADJUST_IN_QTY_CELL_MPP, A.MPP_IN_QTY_JR AS ADJUST_IN_QTY_JR_MPP' + Char(10)
    SET @v_dSql += '                             , A.MPP_OUT_QTY_BATCH AS ADJUST_OUT_QTY_BATCH_MPP, A.MPP_OUT_QTY_M AS ADJUST_OUT_QTY_M_MPP, A.MPP_OUT_QTY_CELL AS ADJUST_OUT_QTY_CELL_MPP, A.MPP_OUT_QTY_JR AS ADJUST_OUT_QTY_JR_MPP' + Char(10)
    SET @v_dSql += '                             , A.WPP_IN_QTY_BATCH AS ADJUST_IN_QTY_BATCH_WPP, A.WPP_IN_QTY_M AS ADJUST_IN_QTY_M_WPP, A.WPP_IN_QTY_CELL AS ADJUST_IN_QTY_CELL_WPP, A.WPP_IN_QTY_JR AS ADJUST_IN_QTY_JR_WPP' + Char(10)
    SET @v_dSql += '                             , A.WPP_OUT_QTY_BATCH AS ADJUST_OUT_QTY_BATCH_WPP, A.WPP_OUT_QTY_M AS ADJUST_OUT_QTY_M_WPP, A.WPP_OUT_QTY_CELL AS ADJUST_OUT_QTY_CELL_WPP, A.WPP_OUT_QTY_JR AS ADJUST_OUT_QTY_JR_WPP' + Char(10)
    SET @v_dSql += '                             , A.PLAN_IN_QTY_BATCH, A.PLAN_IN_QTY_M, A.PLAN_IN_QTY_JR, A.PLAN_IN_QTY_CELL' + Char(10)
    SET @v_dSql += '                             , A.PLAN_OUT_QTY_BATCH, A.PLAN_OUT_QTY_M, A.PLAN_OUT_QTY_JR, A.PLAN_OUT_QTY_CELL' + Char(10)
    SET @v_dSql += '                        FROM    '+ @p_amend_table + ' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                        WHERE  INSTANCE_ID      =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                        AND    FP_PLAN_ID       =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                        AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + Char(10)
	---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    SET @v_dsql += isnull(@omitSql, '')

    SET @v_dSql += '             UNION ALL' + Char(10)
    SET @v_dSql += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '      , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '      , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '      , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '      , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '      , A.TOP_ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID AS ITEM_ID, NULL AS NICK_NAME' + Char(10)
    SET @v_dSql += '      , A.PRODUCTION_TYPE AS PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '      , A.MARKET AS MARKET' + Char(10)
    SET @v_dSql += '      , NULL AS SEQ' + Char(10)
	SET @v_dSql += ',A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO' + Char(10)
    SET @v_dSql += '      , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_M, 0 AS ADJUST_IN_QTY_CELL, 0 AS ADJUST_IN_QTY_JR' + Char(10)
    SET @v_dSql += '      , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_M, 0 AS ADJUST_OUT_QTY_CELL, 0 AS ADJUST_OUT_QTY_JR' + Char(10)
    SET @v_dSql += '      , 0 AS ADJUST_RESULT_QTY_BATCH, 0 AS ADJUST_RESULT_QTY, 0 AS ADJUST_RESULT_QTY_M, 0 AS ADJUST_RESULT_QTY_CELL, 0 AS ADJUST_RESULT_QTY_JR' + Char(10)
    SET @v_dSql += '      , B.UTILIZATION' + Char(10)
    SET @v_dSql += '      , 0 AS TOTAL_BATCH' + Char(10)
    SET @v_dSql += '       , 0 AS ADJUST_IN_QTY_BATCH_MPP, 0 AS ADJUST_IN_QTY_M_MPP, 0 AS ADJUST_IN_QTY_CELL_MPP, 0 AS ADJUST_IN_QTY_JR_MPP' + Char(10)
    SET @v_dSql += '       , 0 AS ADJUST_OUT_QTY_BATCH_MPP, 0 AS ADJUST_OUT_QTY_M_MPP, 0 AS ADJUST_OUT_QTY_CELL_MPP, 0 AS ADJUST_OUT_QTY_JR_MPP' + Char(10)
    SET @v_dSql += '       , 0 AS ADJUST_IN_QTY_BATCH_WPP, 0 AS ADJUST_IN_QTY_M_WPP, 0 AS ADJUST_IN_QTY_CELL_WPP, 0 AS ADJUST_IN_QTY_JR_WPP' + Char(10)
    SET @v_dSql += '       , 0 AS ADJUST_OUT_QTY_BATCH_WPP, 0 AS ADJUST_OUT_QTY_M_WPP, 0 AS ADJUST_OUT_QTY_CELL_WPP, 0 AS ADJUST_OUT_QTY_JR_WPP' + Char(10)
    SET @v_dSql += '       , 0 AS PLAN_IN_QTY_BATCH, 0 AS PLAN_IN_QTY_M, 0 AS PLAN_IN_QTY_JR, 0 AS PLAN_IN_QTY_CELL' + Char(10)
    SET @v_dSql += '       , 0 AS PLAN_OUT_QTY_BATCH, 0 AS PLAN_OUT_QTY_M, 0 AS PLAN_OUT_QTY_JR, 0 AS PLAN_OUT_QTY_CELL' + Char(10)
    SET @v_dSql += '             FROM (' + Char(10)
    SET @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '              , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '              , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '              , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '              , C.YYYYMMDD AS PLAN_DATE' + Char(10)
    SET @v_dSql += '              , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + Char(10)
    SET @v_dSql += '              , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '              , A.MARKET' + Char(10)
	SET @v_dSql += ',A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO' + Char(10)
    SET @v_dSql += '         FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '         INNER JOIN TH_UIS_CAL C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '         ON  1=1' + Char(10)
    SET @v_dSql += '         AND C.YYYYMMDD  BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_plan_date + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '         WHERE  INSTANCE_ID      =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                       AND    FP_PLAN_ID       =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                       AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_plan_date + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + Char(10)
	
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    SET @v_dsql += isnull(@omitSql, '')

    SET @v_dSql += '                         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '              , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '              , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '              , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '              , C.YYYYMMDD' + Char(10)
    SET @v_dSql += '              , A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '              , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '              , A.MARKET' + Char(10)
    SET @v_dSql += ', A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO' + Char(10)
    SET @v_dSql += '     ) A' + Char(10)
    SET @v_dSql += '                 INNER JOIN ' + @p_amend_util_table + ' B WITH(NOLOCK)' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	IF @bCapa = 1 BEGIN
		SET @v_dSql += ' ON 1=1 ' + Char(10)
    END ELSE BEGIN
		SET @v_dSql += ' ON 1=0 ' + Char(10)
    END

    SET @v_dSql += '             AND    B.INSTANCE_ID      =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                  AND    B.FP_PLAN_ID       =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                  AND    CONVERT(VARCHAR, B.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_plan_date + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
		)

    SET @v_dSql += '     AND    A.COMPANY_ID     = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '     AND    A.DIVISION_ID    = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '     AND    A.SITE_ID        = B.SITE_ID' + Char(10)
    SET @v_dSql += '     AND    A.PLANT_ID       = B.PLANT_ID' + Char(10)
    SET @v_dSql += '     AND    A.FACTORY_ID     = B.FACTORY_ID' + Char(10)
    SET @v_dSql += '     AND    A.LOCATION       = B.LOCATION' + Char(10)
    SET @v_dSql += '     AND    A.OPERATION_ID   = B.OPERATION_ID' + Char(10)
    SET @v_dSql += '     AND    A.LINE_ID        = B.LINE_ID' + Char(10)
    SET @v_dSql += '     AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '     AND    A.EQUIPMENT_ID   = B.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '     AND    A.PLAN_DATE  = B.PLAN_DATE' + Char(10)
    SET @v_dSql += '               ) A' + Char(10)
    SET @v_dSql += '     LEFT OUTER JOIN ( ' + Char(10)
    SET @v_dSql += '     		SELECT COMPANY_ID, FACTORY_ID, MODEL_ID, VERSION, OPERATION AS OPERATION_ID, ITEM_ID, MAX(PROD_SEQ) AS PROD_SEQ ' + Char(10)
    SET @v_dSql += '     		FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) ' + Char(10)
    SET @v_dSql += '     		WHERE  A.OPERATION = ''E2000'' ' + Char(10)
	SET @v_dsql += '     		' + (SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)) + Char(10)
	SET @v_dsql += '     		' + (SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)) + Char(10)
	SET @v_dsql += '     		' + (SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)) + Char(10)
	SET @v_dsql += '     		' + (SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)) + Char(10)
    SET @v_dSql += '     		AND    A.VALUE > 0 ' + Char(10)
    SET @v_dSql += '     		AND    A.CATEGORY IN ( ''Jumbo Roll (cell/m)'', ''Lane Number'', ''Pancake (m/batch)'', ''cell/batch'', ''Jumbo Roll (m/batch)'', ''Pancake (cell/m)'' ) ' + Char(10)
    SET @v_dSql += '     		GROUP BY COMPANY_ID, FACTORY_ID, MODEL_ID, VERSION, OPERATION, ITEM_ID ' + Char(10)
    SET @v_dSql += '     ) BB ' + Char(10)
    SET @v_dSql += '     ON  A.COMPANY_ID   = BB.COMPANY_ID ' + Char(10)
    SET @v_dSql += '     AND A.FACTORY_ID   = BB.FACTORY_ID ' + Char(10)
    SET @v_dSql += '     AND A.WORK_REQUEST_MODEL_ID = BB.MODEL_ID ' + Char(10)
    SET @v_dSql += '     AND A.VERSION      = BB.VERSION ' + Char(10)
    SET @v_dSql += '     AND A.OPERATION_ID = BB.OPERATION_ID ' + Char(10)
    SET @v_dSql += '     AND A.ITEM_ID      = BB.ITEM_ID ' + Char(10)


    SET @v_dSql += '               INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                ON     A.COMPANY_ID     = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '                AND    A.DIVISION_ID    = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '                AND    A.SITE_ID        = B.SITE_ID' + Char(10)
    SET @v_dSql += '                AND    A.ITEM_ID        = B.ITEM_ID' + Char(10)
    SET @v_dSql += '                INNER JOIN SCM_LINE_M C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                ON     A.COMPANY_ID     = C.COMPANY_ID' + Char(10)
    SET @v_dSql += '                AND    A.DIVISION_ID    = C.DIVISION_ID' + Char(10)
    SET @v_dSql += '                AND    A.SITE_ID        = C.SITE_ID' + Char(10)
    SET @v_dSql += '                AND    A.PLANT_ID       = C.PLANT_ID' + Char(10)
    SET @v_dSql += '                AND    A.FACTORY_ID     = C.FACTORY_ID' + Char(10)
    SET @v_dSql += '                AND    A.OPERATION_ID   = C.OPERATION_ID' + Char(10)
    SET @v_dSql += '                AND    A.LINE_ID        = C.LINE_ID' + Char(10)
    SET @v_dSql += '                AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += ' LEFT OUTER HASH JOIN (' + Char(10)
    SET @v_dSql += '   SELECT B.*' + Char(10)
    SET @v_dSql += '    , MIN(B.IDX) OVER (PARTITION BY B.INSTANCE_ID, B.PRODUCTION_TYPE, A.LINE_ID, A.ITEM_ID ) AS MIN_IDX' + Char(10)
    SET @v_dSql += '    , A.*' + Char(10)
    SET @v_dSql += '   FROM (' + Char(10)
    SET @v_dSql += '   SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID AS CALC_PLANT_ID, A.FACTORY_ID, B.LINE_ID, A.ITEM_ID, B.ELECTRODE_TYPE, A.VERSION_TYPE AS CALC_TYPE, A.VERSION, A.PROD_SEQ' + Char(10)
    SET @v_dSql += '    , DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION, A.ITEM_ID, A.PROD_VERSION_TYPE, A.VERSION_TYPE' + Char(10)
    SET @v_dSql += '     ORDER BY A.APPLY_DATE DESC, (CASE WHEN A.VERSION LIKE ''Z%'' THEN REPLACE( A.VERSION, ''Z'', ''/'') ELSE A.VERSION END) DESC' + Char(10)
    SET @v_dSql += '            , (CASE WHEN A.MODEL_ID = C.APPLIED_MODEL THEN 1 ELSE 2 END), A.MODEL_ID DESC ) AS SEQ '-- 적용모델이 동일한 것 우선순위 조건 추가...20210420'
                   + Char(10)
    SET @v_dSql += '   FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK), SCM_LINE_M B WITH(NOLOCK), SCM_ITEM_M C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '   WHERE  1=1' + Char(10)
    SET @v_dSql += '   AND    A.OPERATION    = ''E2000''' + Char(10)
    SET @v_dSql += '   AND    A.MAX_VER_FLAG = ''Y''' + Char(10)
    SET @v_dSql += '  	AND    A.COMPANY_ID   = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '   AND    A.DIVISION_ID  = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '   AND    A.SITE_ID      = B.SITE_ID' + Char(10)
    SET @v_dSql += '   AND    A.PLANT_ID     = B.PLANT_ID' + Char(10)
    SET @v_dSql += '   AND    A.FACTORY_ID   = B.FACTORY_ID' + Char(10)
    SET @v_dSql += '   AND    A.OPERATION    = B.OPERATION_ID' + Char(10)
    SET @v_dSql += '   AND    A.PROD_VERSION_TYPE = ISNULL(B.PROD_VERSION_TYPE, ''GENERAL'')' + Char(10)
    SET @v_dSql += '                         AND    A.COMPANY_ID   = C.COMPANY_ID' + Char(10)
    SET @v_dSql += '                         AND    A.DIVISION_ID  = C.DIVISION_ID' + Char(10)
    SET @v_dSql += '                         AND    A.SITE_ID      = C.SITE_ID' + Char(10)
    SET @v_dSql += '                         AND    A.ITEM_ID      = C.ITEM_ID' + Char(10)
    SET @v_dSql += '   AND    B.ACTIVE_FLAG = ''Y''' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)

    SET @v_dSql += '   ) A' + Char(10)
    SET @v_dSql += '   , (' + Char(10)
    SET @v_dSql += '   SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLANT_ID, SEGMENT3 AS PRODUCTION_TYPE,  VERSION_TYPE'
                   + Char(10)
    SET @v_dSql += '    , RANK() OVER (PARTITION BY SEGMENT1, SEGMENT3 ORDER BY GUBUN) AS IDX' + Char(10)
    SET @v_dSql += '   FROM (' + Char(10)
    SET @v_dSql += '   SELECT *' + Char(10)
    SET @v_dSql += '   FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '   WHERE  1=1' + Char(10)
    SET @v_dSql += '   AND    LOOKUP_TYPE_CODE = ''INSTANCE_CONV_PRIORITY''' + Char(10)
    SET @v_dSql += '   AND    SEGMENT1         =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '   AND    ACTIVE_FLAG      = ''Y''' + Char(10)
    SET @v_dSql += '   ) A' + Char(10)
    SET @v_dSql += '   UNPIVOT(VERSION_TYPE FOR GUBUN IN (ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5) ) AS VERSION_TYPE'
                   + Char(10)
    SET @v_dSql += '   ) B' + Char(10)
    SET @v_dSql += '   WHERE 1=1' + Char(10)
    SET @v_dSql += '   AND   A.CALC_PLANT_ID = B.PLANT_ID' + Char(10)
    SET @v_dSql += '   AND   A.CALC_TYPE = B.VERSION_TYPE' + Char(10)
    SET @v_dSql += '   AND   A.SEQ = 1' + Char(10)
    SET @v_dSql += ' ) X' + Char(10)
    SET @v_dSql += ' ON    1=1' + Char(10)
    SET @v_dSql += ' AND   X.MIN_IDX         = X.IDX' + Char(10)
    SET @v_dSql += ' AND   A.SITE_ID         = X.SITE_ID' + Char(10)
    SET @v_dSql += ' AND   A.PLANT_ID        = X.PLANT_ID' + Char(10)
    SET @v_dSql += ' AND   A.FACTORY_ID      = X.FACTORY_ID' + Char(10)
    SET @v_dSql += ' AND   A.LINE_ID         = X.LINE_ID' + Char(10)
    SET @v_dSql += ' AND   A.ITEM_ID         = X.ITEM_ID' + Char(10)
    SET @v_dSql += ' AND   A.ELECTRODE_TYPE  = X.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += ' AND   A.PRODUCTION_TYPE = X.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '                WHERE 1=1' + Char(10)
    SET @v_dSql += ' ' + @opt_81item_name + ' ' + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(B.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + Char(10)
	
    SET @v_dSql += ' ;' + Char(10)
    --SET @v_dSql += '      WITH MAIN_P AS (' + Char(10) --Tuning_block_01 end
    --SET @v_dSql += '          -- P' + Char(10)
    SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '               , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '               , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '               , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '               , A.PRODUCTION_TYPE, A.MARKET,' + Char(10)

    SET @v_dSql += '               E.SLURRY_1 AS BATCH_ID, '+ Char(10)
    SET @v_dSql += '               E.SLURRY_2 AS BATCH_ID_2, '+ Char(10)
    SET @v_dSql += '               E.PRE_DISPERSION_ID AS PRE_DISPERSION_ID, '+ Char(10)
    SET @v_dSql += '               E.PRE_DISPERSION_NAME AS PRE_DISPERSION_NAME, '+ Char(10)
    SET @v_dSql += '               E.PRE_DISPERSION_ID_2 AS PRE_DISPERSION_ID_2,'+ Char(10)
    SET @v_dSql += '               E.PRE_DISPERSION_NAME_2 AS PRE_DISPERSION_NAME_2, '+ Char(10)
    SET @v_dSql += '               E.ACTIVE_MATERIAL_1 AS ACTIVE_MATERIAL_1, '+ Char(10)
    SET @v_dSql += '               E.ACTIVE_MATERIAL_2 AS ACTIVE_MATERIAL_2, '+ Char(10)
    SET @v_dSql += '               E.ACTIVE_MATERIAL_3 AS ACTIVE_MATERIAL_3, '+ Char(10)
    SET @v_dSql += '               E.BINDER_1 AS BINDER_1, '+ Char(10)
    SET @v_dSql += '               E.BINDER_2 AS BINDER_2, '+ Char(10)
    SET @v_dSql += '               E.BINDER_3 AS BINDER_3, '+ Char(10)
    SET @v_dSql += '               E.CMC AS CMC, '+ Char(10)
    SET @v_dSql += '               A.VERSION, '+ Char(10)
    --SET @v_dSql += '               E.MODEL_ID AS PC_MODEL_ID, '+ Char(10)
	SET @v_dSql += '               A.WORK_REQUEST_MODEL_ID AS PC_MODEL_ID, '+ Char(10)
    SET @v_dSql += '               E.ADDITION_AGENT AS ADDITION_AGENT'+ Char(10)

	SET @v_dSql += '               , ISNULL(H.FOIL_CODE, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, ''FOIL_CODE'')) AS FOIL_CODE'+ Char(10)
    SET @v_dSql += '               , ISNULL(H.FOIL, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID,A.PROD_VERSION_TYPE, ''FOIL'')) AS FOIL'+ Char(10)
    SET @v_dSql += '               , G.DAILY_CAPA_PPM  AS DC_PPM' + Char(10)
/*
    SET @v_dSql += '               , ISNULL(D.DAILY_CAPA_M, I.DAILY_CAPA_M) AS DC_M' + Char(10)
    SET @v_dSql += '               , ISNULL(D.DAILY_CAPA_EA, I.DAILY_CAPA_EA) AS DC_CELL' + Char(10)
    SET @v_dSql += '               , ISNULL(D.DAILY_CAPA_KG, I.DAILY_CAPA_KG) AS DC_KG' + Char(10)
    SET @v_dSql += '               , ISNULL(D.DAILY_CAPA_JR, I.DAILY_CAPA_JR) AS DC_JR' + Char(10)
    SET @v_dSql += '               , ISNULL(D.DAILY_CAPA_BATCH, I.DAILY_CAPA_BATCH) AS DC_BATCH' + Char(10)
    SET @v_dSql += '               , (CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''N'' ELSE ISNULL(D.DC_FLAG, I.DC_FLAG) END) AS DC_FLAG' + Char(10)
*/
    SET @v_dSql += '               , D.DAILY_CAPA_M AS DC_M' + Char(10)
    SET @v_dSql += '               , D.DAILY_CAPA_EA AS DC_CELL' + Char(10)
    SET @v_dSql += '               , D.DAILY_CAPA_KG AS DC_KG' + Char(10)
    SET @v_dSql += '               , D.DAILY_CAPA_JR AS DC_JR' + Char(10)
    SET @v_dSql += '               , D.DAILY_CAPA_BATCH AS DC_BATCH' + Char(10)
    SET @v_dSql += '               , (CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''N'' ELSE D.DC_FLAG END) AS DC_FLAG' + Char(10)

    SET @v_dSql += '               , ISNULL(Z.QTY,0) AS BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 


    SET @p_day_info = @p_bucket

    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        IF @max_loop_cnt > 0
        BEGIN
            -- monthinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @max_loop_cnt) +char(10)    
            --SET @v_dSql += @p_MONTH_INFO  +char(10)    
            --SET @v_dSql += '  KKKKKKKKKK ### MAX LOOP COUNT %%%'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_columns +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@in_row +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@p_MONTH_INFO +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_MONTH_INFO +char(10)    
            --SET @v_dSql += '   ### MAX LOOP COUNT %%%'+@v_delimiter +char(10)    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- //SAMPLE SET @v_dSql += '               , NULL AS M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +char(10)    
                SET @v_dsql += '               , SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_RESULT'' THEN (CASE WHEN A.ITEM_UOM=''M'' THEN CEILING(ADJUST_RESULT_QTY_M)*1.0 ELSE CEILING(ADJUST_RESULT_QTY_CELL)*1.0 END) '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M_MPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR_MPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL_MPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH_MPP,'
                               + @v_round_point + ')*1.0 ' + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M_MPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR_MPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL_MPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_MPP,'
                               + @v_round_point + ')*1.0 ' + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M_WPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR_WPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL_WPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH_WPP,2)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M_WPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR_WPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL_WPP)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_WPP,2)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_IN_M'' THEN CEILING(A.PLAN_IN_QTY_M)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_IN_JR'' THEN CEILING(A.PLAN_IN_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_IN_CELL'' THEN CEILING(A.PLAN_IN_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_IN_BATCH'' THEN ROUND(A.PLAN_IN_QTY_BATCH,2)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_OUT_M'' THEN CEILING(A.PLAN_OUT_QTY_M)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_OUT_JR'' THEN CEILING(A.PLAN_OUT_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_OUT_CELL'' THEN CEILING(A.PLAN_OUT_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            WHEN B.CATEGORY_ID=''P_ENGINE_OUT_BATCH'' THEN ROUND(A.PLAN_OUT_QTY_BATCH,2)*1.0 '
                               + char(10)
                SET @v_dsql += '                                                            ELSE 0 END) ELSE 0 END) AS M'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + ' ' + char(10)

            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- weekinfo    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
                SET @v_dSql += '              , SUM(CASE WHEN C.' + @WeekColumn + '=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'
                               + @v_round_point + ') ' + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_RESULT'' THEN (CASE WHEN A.ITEM_UOM=''M'' THEN CEILING(ADJUST_RESULT_QTY_M)*1.0 ELSE CEILING(ADJUST_RESULT_QTY_CELL)*1.0 END) '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH_MPP,'
                               + @v_round_point + ')*1.0 ' + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_MPP,'
                               + @v_round_point + ')*1.0 ' + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH_WPP,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_WPP,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_M'' THEN CEILING(A.PLAN_IN_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_JR'' THEN CEILING(A.PLAN_IN_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_CELL'' THEN CEILING(A.PLAN_IN_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_IN_BATCH'' THEN ROUND(A.PLAN_IN_QTY_BATCH,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_M'' THEN CEILING(A.PLAN_OUT_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_JR'' THEN CEILING(A.PLAN_OUT_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_CELL'' THEN CEILING(A.PLAN_OUT_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                WHEN B.CATEGORY_ID=''P_ENGINE_OUT_BATCH'' THEN ROUND(A.PLAN_OUT_QTY_BATCH,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                ELSE 0 END) ELSE 0 END) AS W'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + ' ' + char(10)

            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- bucket    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)

            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
                -- SAMPLE SET @v_dSql += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= '''+ @sub_param_0 +''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''' + @p_PLAN_DATE + ''' THEN ( CASE   WHEN B.CATEGORY_ID = ''I'' THEN A.EOH_QTY '+ char(10)    
                SET @v_dSql += '              , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0
                               + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,'
                               + @v_round_point + ')' + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_RESULT'' THEN (CASE WHEN A.ITEM_UOM=''M'' THEN CEILING(ADJUST_RESULT_QTY_M)*1.0 ELSE CEILING(ADJUST_RESULT_QTY_CELL)*1.0 END) '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_CAPA'' THEN A.UTILIZATION '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH_MPP,'
                               + @v_round_point + ')*1.0' + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL_MPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_MPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_MPP,'
                               + @v_round_point + ')*1.0' + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_IN_M'' THEN CEILING(A.ADJUST_IN_QTY_M_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_IN_JR'' THEN CEILING(A.ADJUST_IN_QTY_JR_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_IN_CELL'' THEN CEILING(A.ADJUST_IN_QTY_CELL_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_IN_BATCH'' THEN ROUND(A.ADJUST_IN_QTY_BATCH_WPP,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_OUT_M'' THEN CEILING(A.ADJUST_OUT_QTY_M_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_OUT_JR'' THEN CEILING(A.ADJUST_OUT_QTY_JR_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL_WPP)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_WPP_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_WPP,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_IN_M'' THEN CEILING(A.PLAN_IN_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_IN_JR'' THEN CEILING(A.PLAN_IN_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_IN_CELL'' THEN CEILING(A.PLAN_IN_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_IN_BATCH'' THEN ROUND(A.PLAN_IN_QTY_BATCH,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_OUT_M'' THEN CEILING(A.PLAN_OUT_QTY_M)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_OUT_JR'' THEN CEILING(A.PLAN_OUT_QTY_JR)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_OUT_CELL'' THEN CEILING(A.PLAN_OUT_QTY_CELL)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     WHEN B.CATEGORY_ID=''P_ENGINE_OUT_BATCH'' THEN ROUND(A.PLAN_OUT_QTY_BATCH,2)*1.0 '
                               + char(10)
                SET @v_dSql += '                                                                                     ELSE 0 END) ELSE 0 END) AS D'
                               + try_convert(nvarchar, @mst_loop_cnt - 1) + ' ' + char(10)


                --SET @v_dsql += '               , D' + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '               , D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR' + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    



        -- weekinfo    
        SET @mst_loop_cnt = 0
        SET @max_loop_cnt = 0
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)

        -- 프로시저 LOOP 길이를 판단    
        WHILE @mst_loop_cnt < @max_loop_cnt
        BEGIN
            SET @mst_loop_cnt = @mst_loop_cnt + 1
            SET @tmp_column = ''
            SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
            SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

            IF @sub_max_loop_cnt > 0
            BEGIN
                SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
            END

            IF @sub_max_loop_cnt > 1
            BEGIN
                SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
            END

            IF @sub_max_loop_cnt > 2
            BEGIN
                SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
            END

            IF @sub_max_loop_cnt > 3
            BEGIN
                SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
            END

            IF @sub_max_loop_cnt > 4
            BEGIN
                SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
            END

            -- @sub_param_0 => WEEK    
            -- @sub_param_0 => WEEK_NAME    
            -- @sub_param_0 => WEEK_COUNT    
            -- @sub_param_0 => W_VALUE    
            -- @sub_param_0 => IS_DAY_VIEW        

            SET @v_dSql += '              , SUM(CASE WHEN C.' + @WeekColumn + '=''' + @sub_param_0
                           + ''' THEN (CASE WHEN B.CATEGORY_ID=''P_IN_M'' THEN NULL ' + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_IN_JR'' THEN NULL '
                           + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_IN_CELL'' THEN NULL '
                           + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_IN_BATCH'' THEN ROUND(A.TOTAL_BATCH,'
                           + @v_round_point + ') ' + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_M'' THEN NULL '
                           + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN NULL '
                           + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN NULL '
                           + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN NULL '
                           + char(10)
            SET @v_dSql += '                                                               WHEN B.CATEGORY_ID=''P_RESULT'' THEN NULL '
                           + char(10)
            SET @v_dSql += '                                                               ELSE 0 END) ELSE 0 END) AS W'
                           + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT ' + char(10)

        END -- end of @mst_loop_cnt < @max_loop_cnt    

    END -- end of isnull(@p_day_info,'') <> ''    

    --SET @v_dSql += ' 
    --{ 
    --                var sql=""; 
    --                var list = $data.bucket; 
    --                var weekInfo  = $data.WEEK_INFO; 
    --                var monthInfo = $data.MONTH_INFO; 
    -- 
    --                if(list.size() > 0) { 
    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                        sql+="               , SUM(CASE WHEN C.YYYYMM=''''" + monthInfo[i].month + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''P_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH,@ROUND_POINT@) \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,@ROUND_POINT@) \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_RESULT'''' THEN (CASE WHEN A.ITEM_UOM=''''M'''' THEN CEILING(ADJUST_RESULT_QTY_M)*1.0 ELSE CEILING(ADJUST_RESULT_QTY_CELL)*1.0 END) \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M_MPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR_MPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL_MPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH_MPP,@ROUND_POINT@)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M_MPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR_MPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL_MPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_MPP_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_MPP,@ROUND_POINT@)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M_WPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR_WPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL_WPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH_WPP,2)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M_WPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR_WPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL_WPP)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_WPP_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_WPP,2)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_IN_M'''' THEN CEILING(A.PLAN_IN_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_IN_JR'''' THEN CEILING(A.PLAN_IN_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_IN_CELL'''' THEN CEILING(A.PLAN_IN_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_IN_BATCH'''' THEN ROUND(A.PLAN_IN_QTY_BATCH,2)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_M'''' THEN CEILING(A.PLAN_OUT_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_JR'''' THEN CEILING(A.PLAN_OUT_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_CELL'''' THEN CEILING(A.PLAN_OUT_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                            WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_BATCH'''' THEN ROUND(A.PLAN_OUT_QTY_BATCH,2)*1.0 \r\n"; 
    --                        sql+="                                                            ELSE 0 END) ELSE 0 END) AS M" + i + " \r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                        sql+="               , SUM(CASE WHEN C.' + @WeekColumn + '=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''P_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH,@ROUND_POINT@) \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,@ROUND_POINT@) \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_RESULT'''' THEN (CASE WHEN A.ITEM_UOM=''''M'''' THEN CEILING(ADJUST_RESULT_QTY_M)*1.0 ELSE CEILING(ADJUST_RESULT_QTY_CELL)*1.0 END) \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M_MPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR_MPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL_MPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH_MPP,@ROUND_POINT@)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M_MPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR_MPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL_MPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_MPP_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_MPP,@ROUND_POINT@)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M_WPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR_WPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL_WPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH_WPP,2)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M_WPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR_WPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL_WPP)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_WPP_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_WPP,2)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_IN_M'''' THEN CEILING(A.PLAN_IN_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_IN_JR'''' THEN CEILING(A.PLAN_IN_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_IN_CELL'''' THEN CEILING(A.PLAN_IN_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_IN_BATCH'''' THEN ROUND(A.PLAN_IN_QTY_BATCH,2)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_M'''' THEN CEILING(A.PLAN_OUT_QTY_M)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_JR'''' THEN CEILING(A.PLAN_OUT_QTY_JR)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_CELL'''' THEN CEILING(A.PLAN_OUT_QTY_CELL)*1.0 \r\n"; 
    --                        sql+="                                                                WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_BATCH'''' THEN ROUND(A.PLAN_OUT_QTY_BATCH,2)*1.0 \r\n"; 
    --                        sql+="                                                                ELSE 0 END) ELSE 0 END) AS W" + i + " \r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                          sql+="               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''P_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH,@ROUND_POINT@) \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,@ROUND_POINT@) \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_RESULT'''' THEN (CASE WHEN A.ITEM_UOM=''''M'''' THEN CEILING(ADJUST_RESULT_QTY_M)*1.0 ELSE CEILING(ADJUST_RESULT_QTY_CELL)*1.0 END) \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_CAPA'''' THEN A.UTILIZATION \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M_MPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR_MPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL_MPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH_MPP,@ROUND_POINT@)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M_MPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR_MPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL_MPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_MPP_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_MPP,@ROUND_POINT@)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_IN_M'''' THEN CEILING(A.ADJUST_IN_QTY_M_WPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_IN_JR'''' THEN CEILING(A.ADJUST_IN_QTY_JR_WPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_IN_CELL'''' THEN CEILING(A.ADJUST_IN_QTY_CELL_WPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_IN_BATCH'''' THEN ROUND(A.ADJUST_IN_QTY_BATCH_WPP,2)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_OUT_M'''' THEN CEILING(A.ADJUST_OUT_QTY_M_WPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_OUT_JR'''' THEN CEILING(A.ADJUST_OUT_QTY_JR_WPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_OUT_CELL'''' THEN CEILING(A.ADJUST_OUT_QTY_CELL_WPP)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_WPP_OUT_BATCH'''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH_WPP,2)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_IN_M'''' THEN CEILING(A.PLAN_IN_QTY_M)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_IN_JR'''' THEN CEILING(A.PLAN_IN_QTY_JR)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_IN_CELL'''' THEN CEILING(A.PLAN_IN_QTY_CELL)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_IN_BATCH'''' THEN ROUND(A.PLAN_IN_QTY_BATCH,2)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_M'''' THEN CEILING(A.PLAN_OUT_QTY_M)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_JR'''' THEN CEILING(A.PLAN_OUT_QTY_JR)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_CELL'''' THEN CEILING(A.PLAN_OUT_QTY_CELL)*1.0 \r\n"; 
    --                          sql+="                                                                                      WHEN B.CATEGORY_ID=''''P_ENGINE_OUT_BATCH'''' THEN ROUND(A.PLAN_OUT_QTY_BATCH,2)*1.0 \r\n"; 
    --                          sql+="                                                                                      ELSE 0 END) ELSE 0 END) AS D" + i + " \r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                          sql+="               , SUM(CASE WHEN C.' + @WeekColumn + '=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''P_IN_M'''' THEN NULL \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_IN_JR'''' THEN NULL \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_IN_CELL'''' THEN NULL \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_IN_BATCH'''' THEN ROUND(A.TOTAL_BATCH,@ROUND_POINT@) \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_M'''' THEN NULL \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_JR'''' THEN NULL \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_CELL'''' THEN NULL \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_OUT_BATCH'''' THEN NULL \r\n"; 
    --                          sql+="                                                                WHEN B.CATEGORY_ID=''''P_RESULT'''' THEN NULL \r\n"; 
    --                          sql+="                                                                ELSE 0 END) ELSE 0 END) AS W" + i + "_TOT \r\n"; 
    --                  } 
    --                } 
    --              } 
    --' 
    SET @v_dSql += '               , B.CATEGORY_ID, B.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , (CASE WHEN B.CATEGORY_ID = ''P_RESULT'' THEN (CASE WHEN A.ITEM_UOM=''M'' THEN ''M(P/C)'' ELSE ''Cell'' END) ELSE B.CATEGORY_NAME END) AS CATEGORY_NAME'
                   + Char(10)
    SET @v_dSql += '               , B.LV1_NAME' + Char(10)
    SET @v_dSql += '               , A.ITEM_UOM' + Char(10)
    SET @v_dSql += '               , ''P'' AS PSI' + Char(10)
    SET @v_dSql += '               , ''DATA'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '               , A.CALC_TYPE' + Char(10)
    SET @v_dSql += '               , A.PROD_SEQ,A.WORK_REQUEST_MODEL_ID,A.PLM_EC_NO' + Char(10)
    SET @v_dSql += '          into #MAIN_P' + Char(10) --Tuning_block_02 begin
    SET @v_dSql += '          FROM #TEMP01 A' + Char(10)
    --SET @v_dSql += '          FROM (' + Char(10)
    --SET @v_dSql += '         ) A' + Char(10) --Tuning_block_02 end
    SET @v_dSql += '         INNER JOIN (' + Char(10)
    SET @v_dSql += '               SELECT * FROM (' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	SET @v_dSql += @pSql 
    --SET @v_dSql += ' 
    --{ 
    --                      pSql; 
    --                    } 
    --' 
    SET @v_dSql += '               ) A' + Char(10)
    SET @v_dSql += '               WHERE CATEGORY_ID <> ''X''' + Char(10)
    SET @v_dSql += '         ) B' + Char(10)
    SET @v_dSql += '         ON 1=1' + Char(10)
    SET @v_dSql += '         INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '       ON  A.PLAN_DATE = C.DT' + Char(10)
    SET @v_dSql += '       AND C.YYYYMMDD  BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '       LEFT OUTER HASH JOIN (' + Char(10)
    SET @v_dSql += '           SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                , A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '                , ROUND(A.DAILY_CAPA_M,0) AS DAILY_CAPA_M' + Char(10)
    SET @v_dSql += '                , ROUND(A.DAILY_CAPA_EA,0) AS DAILY_CAPA_EA' + Char(10)
    SET @v_dSql += '                , ROUND(A.DAILY_CAPA_KG,0) AS DAILY_CAPA_KG' + Char(10)
    SET @v_dSql += '                , ROUND(A.DAILY_CAPA_JR,0) AS DAILY_CAPA_JR' + Char(10)
    SET @v_dSql += '                , ROUND(A.DAILY_CAPA_BATCH,'+ @v_round_point + ') AS DAILY_CAPA_BATCH' + Char(10)
    SET @v_dSql += '                , CAPA_VALIDATION_FLAG AS DC_FLAG' + Char(10)
    SET @v_dSql += '                , A.CALC_TYPE, A.CALC_VERSION, A.VERSION, A.WORK_REQUEST_MODEL_ID' + Char(10)
    SET @v_dSql += '           FROM   ' + @p_AMEND_CAPA_TABLE +' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '           WHERE  A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '           AND    A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    --) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    --) + Char(10)
	--SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    ----                    var sDiv = $data.DIVISION_LT; 
    ----                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    ----                    sql; 
    ----                  } 
    ----' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    ----AND    A.SITE_ID   = #SITE_ID# 
    ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    ----SET @v_dSql += ' 
    ----{ 
    ----                    var sql=""; 
    ----                    var sPlt = $data.PLANT_LT; 
    ----                    sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    ----                    sql; 
    ----                  } 
    ----' 
    ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    ----SET @v_dSql += ' 
    ----{ 
    ----                    var sql=""; 
    ----                    var sFac = $data.FACTORY_LT; 
    ----                    sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    ----                    sql; 
    ----                  } 
    ----' 
    --SET @v_dSql += '               AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    ----SET @v_dSql += ' 
    ----{ 
    ----                    var sql=""; 
    ----                    var sLine = $data.LINE_LT; 
    --                    sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    SET @v_dSql += '           ) D' + Char(10)
    SET @v_dSql += '           ON  A.COMPANY_ID      = D.COMPANY_ID' + Char(10)
    SET @v_dSql += '           AND A.DIVISION_ID     = D.DIVISION_ID' + Char(10)
    SET @v_dSql += '           AND A.SITE_ID         = D.SITE_ID' + Char(10)
    SET @v_dSql += '           AND A.PLANT_ID        = D.PLANT_ID' + Char(10)
    SET @v_dSql += '           AND A.FACTORY_ID      = D.FACTORY_ID' + Char(10)
    SET @v_dSql += '           AND A.LOCATION        = D.LOCATION' + Char(10)
    SET @v_dSql += '           AND A.OPERATION_ID    = D.OPERATION_ID' + Char(10)
    SET @v_dSql += '           AND A.LINE_ID         = D.LINE_ID' + Char(10)
    SET @v_dSql += '           AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '           AND A.EQUIPMENT_ID    = D.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '           AND A.TOP_ITEM_ID     = D.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID         = D.ITEM_ID' + Char(10)
    SET @v_dSql += '           --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = D.CALC_TYPE'
                   + Char(10)
    --SET @v_dSql += '           AND A.CALC_TYPE       = D.CALC_TYPE' + Char(10)
	SET @v_dSql += '           AND A.VERSION         = D.VERSION' + Char(10)
	SET @v_dSql += '           AND A.WORK_REQUEST_MODEL_ID = D.WORK_REQUEST_MODEL_ID' + Char(10)
    SET @v_dSql += '           LEFT OUTER HASH JOIN (' + Char(10)
    SET @v_dSql += '            SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, A.PROD_SEQ,MAX(A.PAN_PROD_VERSION)  AS PROD_VERSION'
                   + Char(10)
    SET @v_dSql += '       , A.PC_ITEM_ID, A.MODEL_ID' + Char(10)
    SET @v_dSql += '       , NULL AS BATCH_ID' + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 1'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 2'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 3'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1' + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2' + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Binder 3'' THEN A.DESCRIPTION END) AS BINDER_3' + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID_2'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.CLASS_NAME = ''CMC'' then A.DESCRIPTION END) AS CMC' + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 2'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2'
                   + Char(10)
    SET @v_dSql += '       , MAX(CASE WHEN A.CLASS_NAME = ''Addition Agent'' THEN A.DESCRIPTION END) AS ADDITION_AGENT'
                   + Char(10)
    SET @v_dSql += '       FROM ' + @SCM_PANCAKE_VIEW_TALBE +' A  WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '       WHERE  1=1' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PC_ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
    
    ----AND    A.PC_ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    SET @v_dSql += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, A.PC_ITEM_ID, A.MODEL_ID,A.PAN_PROD_VERSION,A.PROD_SEQ'
                   + Char(10)
    SET @v_dSql += '           ) E' + Char(10)
    SET @v_dSql += '           ON  A.COMPANY_ID      = E.COMPANY_ID' + Char(10)
    SET @v_dSql += '           AND A.DIVISION_ID     = E.DIVISION_ID' + Char(10)
    SET @v_dSql += '           AND A.SITE_ID         = E.SITE_ID' + Char(10)
    SET @v_dSql += '           AND A.PLANT_ID        = E.PLANT_ID' + Char(10)
    SET @v_dSql += '           AND A.FACTORY_ID     = E.FACTORY_ID' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID         = E.PC_ITEM_ID' + Char(10)
    SET @v_dSql += '           AND A.WORK_REQUEST_MODEL_ID = E.MODEL_ID ' + Char(10)
    SET @v_dSql += '           AND A.VERSION        = E.PROD_VERSION ' + Char(10)
    SET @v_dSql += '           AND A.PROD_SEQ       = E.PROD_SEQ ' + Char(10)
    --SET @v_dSql += '           AND A.PROD_VERSION_TYPE = E.PROD_VERSION_TYPE' + Char(10)
--    SET @v_dSql += '           --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = E.PROD_TYPE'
                   + Char(10)
    SET @v_dSql += '           AND A.CALC_TYPE = E.PROD_TYPE' + Char(10)
 --   SET @v_dSql += '           LEFT OUTER HASH JOIN (' + Char(10)
 --   SET @v_dSql += '            SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, MAX(A.PAN_PROD_VERSION)  AS PROD_VERSION'
 --                  + Char(10)
 --   SET @v_dSql += '       , A.PC_ITEM_ID, A.MODEL_ID' + Char(10)
 --   SET @v_dSql += '       , NULL AS BATCH_ID' + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_1'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS SLURRY_2'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 1'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_1'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 2'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_2'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Active Material 3'' THEN A.DESCRIPTION END) AS ACTIVE_MATERIAL_3'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Binder 1'' THEN A.DESCRIPTION END) AS BINDER_1' + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Binder 2'' THEN A.DESCRIPTION END) AS BINDER_2' + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Binder 3'' THEN A.DESCRIPTION END) AS BINDER_3' + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 1'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.MATERIAL_ITEM_ID END) AS PRE_DISPERSION_ID_2'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Pre Dispersion Slurry 2'' THEN A.DESCRIPTION END) AS PRE_DISPERSION_NAME_2'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.CLASS_NAME = ''CMC'' then A.DESCRIPTION END) AS CMC' + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 1'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_1'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.UI_COLUMN = ''Conducting Material 2'' THEN A.DESCRIPTION END) AS CONDUCTION_MATERIAL_2'
 --                  + Char(10)
 --   SET @v_dSql += '       , MAX(CASE WHEN A.CLASS_NAME = ''Addition Agent'' THEN A.DESCRIPTION END) AS ADDITION_AGENT'
 --                  + Char(10)
 --   SET @v_dSql += '       FROM   SCM_PANCAKE_MATERIAL_V A  WITH(NOLOCK)' + Char(10)
 --   SET @v_dSql += '       WHERE  1=1' + Char(10)
 --   ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	--SET @v_dsql +=
 --   (
 --       SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
 --   ) + Char(10)
 --   SET @v_dsql +=
 --   (
 --       SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
 --   ) + Char(10)
 --   SET @v_dsql +=
 --   (
 --       SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
 --   ) + Char(10)
 --   SET @v_dsql +=
 --   (
 --       SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
 --   ) + Char(10)
 --   --SET @v_dsql +=
 --   --(
 --   --    SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
 --   --) + Char(10)
 --   --SET @v_dsql +=
 --   --(
 --   --    SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
 --   --) + Char(10)
 --   --SET @v_dsql +=
 --   --(
 --   --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
 --   --) + Char(10)
 --   SET @v_dsql +=
 --   (
 --       SELECT [DBO].[fn_scm_get_where_sql]('A.PC_ITEM_ID', 'LK', @p_item_id)
 --   ) + Char(10)

 --   --SET @v_dSql += ' 
 --   --{ 
 --   --                      var sql=""; 
 --   --                      var sDiv = $data.DIVISION_LT; 
 --   --                      sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
 --   --                      sql; 
 --   --                  } 
 --   --' 
 --   --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
 --   --AND    A.SITE_ID   = #SITE_ID# 
 --   ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
 --   --SET @v_dSql += ' 
 --   --{ 
 --   --                      var sql=""; 
 --   --                      var sPlt = $data.PLANT_LT; 
 --   --                      sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
 --   --                      sql; 
 --   --                  } 
 --   --' 
 --   ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
 --   --SET @v_dSql += ' 
 --   --{ 
 --   --                   var sql=""; 
 --   --                     var sFac = $data.FACTORY_LT; 
 --   --                     sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
 --   --                       sql; 
 --   --                    } 
 --   --' 
 --   --SET @v_dSql += ' ' + @opt_85item_id + ' ' + '' + Char(10)
 --   --AND    A.PC_ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
 --   SET @v_dSql += '       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PROD_VERSION_TYPE, A.PROD_TYPE, A.PC_ITEM_ID, A.MODEL_ID'
 --                  + Char(10)
 --   SET @v_dSql += '           ) F' + Char(10)
 --   SET @v_dSql += '           ON  A.COMPANY_ID      = F.COMPANY_ID' + Char(10)
 --   SET @v_dSql += '           AND A.DIVISION_ID     = F.DIVISION_ID' + Char(10)
 --   SET @v_dSql += '	          AND A.SITE_ID         = F.SITE_ID' + Char(10)
 --   SET @v_dSql += '           AND A.PLANT_ID        = F.PLANT_ID' + Char(10)
 --   SET @v_dSql += '           AND A.FACTORY_ID     = F.FACTORY_ID' + Char(10)
 --   SET @v_dSql += '           AND A.ITEM_ID         = F.PC_ITEM_ID' + Char(10)
 --   SET @v_dSql += '           AND A.PROD_VERSION_TYPE = F.PROD_VERSION_TYPE' + Char(10)
 --   SET @v_dSql += '           --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) <> F.PROD_TYPE'
 --                  + Char(10)
 --   SET @v_dSql += '           AND A.CALC_TYPE <> F.PROD_TYPE' + Char(10)
    SET @v_dSql += '             LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                    , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '                    , SUM(ISNULL(CASE WHEN B.ITEM_UOM = ''M'' THEN A.CARRY_OVER_QTY_M ELSE A.CARRY_OVER_QTY_CELL END,0)) * (-1) AS QTY'
                   + Char(10)
    SET @v_dSql += '               FROM   '+@p_AMEND_SALES_TABLE +' A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '               WHERE  A.COMPANY_ID   = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '               AND    A.DIVISION_ID  = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '               AND    A.SITE_ID      = B.SITE_ID' + Char(10)
    SET @v_dSql += '               AND    A.ITEM_ID      = B.ITEM_ID' + Char(10)
    SET @v_dSql += '               AND    A.INSTANCE_ID  =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '               AND    A.FP_PLAN_ID   =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '               AND    A.CATEGORY_ID  = ''PRODUCT_TARGET''' + Char(10)
    SET @v_dSql += '               AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)

	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(B.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + Char(10)
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sDiv = $data.DIVISION_LT; 
    --                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sPlt = $data.PLANT_LT; 
    --                    sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                    sql; 
    --                  } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sFac = $data.FACTORY_LT; 
    --                    sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += '               AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sLine = $data.LINE_LT; 
    --                    sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_90item_name + ' ' + '' + Char(10)
    --AND    B.NICK_NAME LIKE '%' + LTRIM(RTRIM( #ITEM_NAME# )) + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sNickNameLt = $data.NICKNAME_LT; 
    -- 
    --                    if(sNickNameLt!="" && sNickNameLt!=null)  sql="AND    ISNULL(B.NICK_NAME,''''-'''') IN (" + sNickNameLt + ")\r\n"; 
    -- 
    --                    sql; 
    --                  } 
    --' 
    SET @v_dSql += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                      , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '           ) Z' + Char(10)
    SET @v_dSql += '           ON  A.COMPANY_ID   = Z.COMPANY_ID' + Char(10)
    SET @v_dSql += '           AND A.DIVISION_ID  = Z.DIVISION_ID' + Char(10)
    SET @v_dSql += '           AND A.SITE_ID      = Z.SITE_ID' + Char(10)
    SET @v_dSql += '           AND A.PLANT_ID     = Z.PLANT_ID' + Char(10)
    SET @v_dSql += '           AND A.OPERATION_ID = Z.OPERATION_ID' + Char(10)
    SET @v_dSql += '           AND A.TOP_ITEM_ID  = Z.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID      = Z.ITEM_ID' + Char(10)
    SET @v_dSql += '           LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += '               SELECT   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'
                   + Char(10)
    SET @v_dSql += '                     , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/A.TACT_TIME, 0) ELSE 0 END) DAILY_CAPA_PPM'
                   + Char(10)
    SET @v_dSql += '               , MAX(CASE WHEN A.TACT_TIME > 0 THEN ROUND(60/(A.TACT_TIME*2), 0) ELSE 0 END) DAILY_CAPA_PPM2'
                   + Char(10)
    SET @v_dSql += '              FROM   SCM_TACT_TIME_M A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '              WHERE  1=1' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	
	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)

		  --  SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(B.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    --) + Char(10)
	   -- SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    --) + Char(10)
	   -- SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    --) + Char(10)

    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sDiv = $data.DIVISION_LT; 
    --                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sPlt = $data.PLANT_LT; 
    --                    sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                    sql; 
    --                  } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sFac = $data.FACTORY_LT; 
    --                    sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += '               AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sLine = $data.LINE_LT; 
    --                    sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    SET @v_dSql += '               AND    A.MONTH = SUBSTRING(' + Char(10)
    SET @v_dSql += '' + @v_plan_date + '' + Char(10)
    SET @v_dSql += ',1,6)' + Char(10)
    SET @v_dSql += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID'
                   + Char(10)
    SET @v_dSql += '           ) G' + Char(10)
    SET @v_dSql += '           ON  A.COMPANY_ID      = G.COMPANY_ID' + Char(10)
    SET @v_dSql += '           AND A.DIVISION_ID     = G.DIVISION_ID' + Char(10)
    SET @v_dSql += '           AND A.SITE_ID         = G.SITE_ID' + Char(10)
    SET @v_dSql += '           AND A.PLANT_ID        = G.PLANT_ID' + Char(10)
    SET @v_dSql += '           AND A.FACTORY_ID      = G.FACTORY_ID' + Char(10)
    SET @v_dSql += '           AND A.OPERATION_ID    = G.OPERATION_ID' + Char(10)
    SET @v_dSql += '           AND A.LINE_ID         = G.LINE_ID' + Char(10)
    SET @v_dSql += '           AND A.ELECTRODE_TYPE  = G.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID         = G.ITEM_ID' + Char(10)
	-- foil 정보 수정... 20240329
    SET @v_dSql += '           LEFT OUTER JOIN #FOIL_INFO H WITH(NOLOCK) ' + Char(10)
    SET @v_dSql += '           ON 1=1 ' + Char(10)
    SET @v_dSql += '           AND A.COMPANY_ID            = H.COMPANY_ID ' + Char(10)
    SET @v_dSql += '           AND A.DIVISION_ID           = H.DIVISION_ID ' + Char(10)
    SET @v_dSql += '           AND A.SITE_ID               = H.SITE_ID ' + Char(10)
    SET @v_dSql += '           AND A.PLANT_ID              = H.PLANT_ID ' + Char(10)
    SET @v_dSql += '           AND A.FACTORY_ID            = H.FACTORY_ID ' + Char(10)
    SET @v_dSql += '           AND A.LINE_ID               = H.LINE_ID ' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID               = H.ITEM_ID ' + Char(10)
    SET @v_dSql += '           AND A.WORK_REQUEST_MODEL_ID = H.MODEL_ID ' + Char(10)
    SET @v_dSql += '           AND A.VERSION               = H.VERSION ' + Char(10)
/*
    SET @v_dSql += '           LEFT OUTER HASH JOIN (' + Char(10)
    SET @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_CODE, A.FOIL, A.PROD_VERSION_TYPE, A.LINE_ID, A.PROD_TYPE'
                   + Char(10)
    SET @v_dSql += ' FROM   (' + Char(10)
    SET @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.FOIL_ID AS FOIL_CODE, B.ITEM_NAME AS FOIL, A.PROD_VERSION_TYPE, C.LINE_ID'
                   + Char(10)
    SET @v_dSql += ' , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END AS PROD_TYPE'
                   + Char(10)
    SET @v_dSql += '   , ROW_NUMBER() OVER (  PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, C.LINE_ID'
                   + Char(10)
    SET @v_dSql += '      , CASE WHEN LEFT(V.PROD_VERSION, 1) = ''Z'' THEN ''TEST'' ELSE ''MASS'' END' + Char(10)
    SET @v_dSql += ' ORDER BY V.APPLY_DATE DESC )  AS NUM' + Char(10)
    SET @v_dSql += ' FROM  SCM_ITEM_FOIL_M        A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '    ,FP_PROD_VERSION_M      V WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '    ,SCM_ITEM_M             B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '    ,SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += ' WHERE 1=1' + Char(10)
    SET @v_dSql += ' AND   A.FACTORY_ID    = V.FACTORY_ID' + Char(10)
    SET @v_dSql += ' AND   A.MODEL_ID      = V.MODEL_ID' + Char(10)
    SET @v_dSql += ' AND   A.ITEM_ID       = V.ITEM_ID' + Char(10)
    SET @v_dSql += ' AND   A.PROD_VERSION  = V.PROD_VERSION' + Char(10)
    SET @v_dSql += ' AND   A.PROD_SEQ      = V.PROD_SEQ' + Char(10)
    SET @v_dSql += ' AND   A.COMPANY_ID = B.COMPANY_ID' + Char(10)
    SET @v_dSql += ' AND   A.DIVISION_ID = B.DIVISION_ID' + Char(10)
    SET @v_dSql += ' AND   A.SITE_ID = B.SITE_ID' + Char(10)
    SET @v_dSql += ' AND   A.FOIL_ID = B.ITEM_ID' + Char(10)
    SET @v_dSql += ' AND   A.COMPANY_ID = C.COMPANY_ID' + Char(10)
    SET @v_dSql += ' AND   A.DIVISION_ID = C.DIVISION_ID' + Char(10)
    SET @v_dSql += ' AND   A.SITE_ID = C.SITE_ID' + Char(10)
    SET @v_dSql += ' AND   A.PLANT_ID = C.PLANT_ID' + Char(10)
    SET @v_dSql += ' AND   A.FACTORY_ID = C.FACTORY_ID' + Char(10)
    SET @v_dSql += ' AND   A.ITEM_ID = C.ITEM_ID' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	
	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('C.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('C.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
    SET @v_dSql += ' ) A' + Char(10)
    SET @v_dSql += ' WHERE  NUM = 1' + Char(10)
    SET @v_dSql += '            ) H' + Char(10)
    SET @v_dSql += '            ON 1=1' + Char(10)
    SET @v_dSql += '            AND A.COMPANY_ID      = H.COMPANY_ID' + Char(10)
    SET @v_dSql += '            AND A.DIVISION_ID     = H.DIVISION_ID' + Char(10)
    SET @v_dSql += '            AND A.SITE_ID         = H.SITE_ID' + Char(10)
    SET @v_dSql += '            AND A.PLANT_ID        = H.PLANT_ID' + Char(10)
    SET @v_dSql += '            AND A.FACTORY_ID      = H.FACTORY_ID' + Char(10)
    SET @v_dSql += '            AND A.LINE_ID         = H.LINE_ID' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID         = H.ITEM_ID' + Char(10)
    SET @v_dSql += '            AND A.PROD_VERSION_TYPE = H.PROD_VERSION_TYPE' + Char(10)
    SET @v_dSql += '            --AND (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = H.PROD_TYPE  -- kimcd 2019-12-02' + Char(10)
    SET @v_dSql += '            AND A.CALC_TYPE       = H.PROD_TYPE' + Char(10)
*/

/*
    SET @v_dSql += '          LEFT OUTER HASH JOIN (' + Char(10)
    SET @v_dSql += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                    , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                    , A.ITEM_ID' + Char(10)
    SET @v_dSql += '                    , MAX(ROUND(A.DAILY_CAPA_M,0)) AS DAILY_CAPA_M' + Char(10)
    SET @v_dSql += '                    , MAX(ROUND(A.DAILY_CAPA_EA,0)) AS DAILY_CAPA_EA' + Char(10)
    SET @v_dSql += '                    , MAX(ROUND(A.DAILY_CAPA_KG,0)) AS DAILY_CAPA_KG' + Char(10)
    SET @v_dSql += '                    , MAX(ROUND(A.DAILY_CAPA_JR,0)) AS DAILY_CAPA_JR' + Char(10)
    SET @v_dSql += '                    , MAX(ROUND(A.DAILY_CAPA_BATCH,'+ @v_round_point + ')) AS DAILY_CAPA_BATCH' + Char(10)
    SET @v_dSql += '                    , MAX(CAPA_VALIDATION_FLAG) AS DC_FLAG' + Char(10)
    SET @v_dSql += '               FROM   ' + @p_AMEND_CAPA_TABLE +' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '               WHERE  A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '               AND    A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)

    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    
	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	
	--SET @v_dSql += ' 
    --{ 
    --                      var sql=""; 
    --                      var sDiv = $data.DIVISION_LT; 
    --                      sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                      sql; 
    --                    } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                      var sql=""; 
    --                      var sPlt = $data.PLANT_LT; 
    --                      sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                      sql; 
    --                    } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                      var sql=""; 
    --                      var sFac = $data.FACTORY_LT; 
    --                      sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                      sql; 
    --                    } 
    --' 
    --SET @v_dSql += '               AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                      var sql=""; 
    --                      var sLine = $data.LINE_LT; 
    --                      sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                      sql; 
    --                    } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    SET @v_dSql += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                      , A.ITEM_ID' + Char(10)
    SET @v_dSql += '           ) I' + Char(10)
    SET @v_dSql += '           ON  A.COMPANY_ID      = I.COMPANY_ID' + Char(10)
    SET @v_dSql += '           AND A.DIVISION_ID     = I.DIVISION_ID' + Char(10)
    SET @v_dSql += '           AND A.SITE_ID         = I.SITE_ID' + Char(10)
    SET @v_dSql += '           AND A.PLANT_ID        = I.PLANT_ID' + Char(10)
    SET @v_dSql += '           AND A.FACTORY_ID      = I.FACTORY_ID' + Char(10)
    SET @v_dSql += '           AND A.LOCATION        = I.LOCATION' + Char(10)
    SET @v_dSql += '           AND A.OPERATION_ID    = I.OPERATION_ID' + Char(10)
    SET @v_dSql += '           AND A.LINE_ID         = I.LINE_ID' + Char(10)
    SET @v_dSql += '           AND A.ELECTRODE_TYPE  = I.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '           AND A.EQUIPMENT_ID    = I.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID         = I.ITEM_ID' + Char(10)
*/
    SET @v_dSql += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                  , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                  , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                  , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                  , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '                  , A.PRODUCTION_TYPE, A.MARKET' + Char(10)

    SET @v_dSql += ',E.SLURRY_1,' + Char(10)
    SET @v_dSql += 'E.SLURRY_2,' + Char(10)
    SET @v_dSql += 'E.PRE_DISPERSION_ID,' + Char(10)
    SET @v_dSql += 'E.PRE_DISPERSION_NAME,' + Char(10)
    SET @v_dSql += 'E.PRE_DISPERSION_ID_2,' + Char(10)
    SET @v_dSql += 'E.PRE_DISPERSION_NAME_2,' + Char(10)
    SET @v_dSql += 'E.ACTIVE_MATERIAL_1,' + Char(10)
    SET @v_dSql += 'E.ACTIVE_MATERIAL_2,' + Char(10)
    SET @v_dSql += 'E.ACTIVE_MATERIAL_3,' + Char(10)
    SET @v_dSql += 'E.BINDER_1,' + Char(10)
    SET @v_dSql += 'E.BINDER_2,' + Char(10)
    SET @v_dSql += 'E.BINDER_3,' + Char(10)
    SET @v_dSql += 'E.CMC,' + Char(10)
    SET @v_dSql += 'A.VERSION,' + Char(10)
    SET @v_dSql += 'A.PROD_SEQ,' + Char(10)
    SET @v_dSql += 'E.MODEL_ID,'+ Char(10)
    SET @v_dSql += 'E.ADDITION_AGENT' + Char(10)


    --SET @v_dSql += '                  , ISNULL(E.SLURRY_1,F.SLURRY_1), ISNULL(E.SLURRY_2,F.SLURRY_2)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.PRE_DISPERSION_ID,F.PRE_DISPERSION_ID)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.PRE_DISPERSION_NAME,F.PRE_DISPERSION_NAME)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.PRE_DISPERSION_ID_2,F.PRE_DISPERSION_ID_2)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.PRE_DISPERSION_NAME_2,F.PRE_DISPERSION_NAME_2)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.ACTIVE_MATERIAL_1,F.ACTIVE_MATERIAL_1)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.ACTIVE_MATERIAL_2,F.ACTIVE_MATERIAL_2)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.ACTIVE_MATERIAL_3,F.ACTIVE_MATERIAL_3)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.BINDER_1,F.BINDER_1)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.BINDER_2,F.BINDER_2)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.BINDER_3,F.BINDER_3)' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.CMC,F.CMC)' + Char(10)
    --SET @v_dSql += '                  --, ISNULL(E.PROD_VERSION,F.PROD_VERSION)' + Char(10)
    --SET @v_dSql += '                  , A.VERSION, A.PROD_SEQ' + Char(10)
    --SET @v_dSql += '                  , ISNULL(E.MODEL_ID,F.MODEL_ID), ISNULL(E.ADDITION_AGENT,F.ADDITION_AGENT)'
                   + Char(10)
--    SET @v_dSql += '                  --, ISNULL(H.FOIL_CODE, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID, (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END), ''FOIL_CODE''))'
                   + Char(10)
--    SET @v_dSql += '                --, ISNULL(H.FOIL, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID, (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END), ''FOIL''))'
                   + Char(10)
    SET @v_dSql += '                  , ISNULL(H.FOIL_CODE, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID, A.PROD_VERSION_TYPE, ''FOIL_CODE''))'
                   + Char(10)
    SET @v_dSql += '                  , ISNULL(H.FOIL, dbo.FN_GET_FOIL(A.FACTORY_ID, A.ITEM_ID,A.PROD_VERSION_TYPE, ''FOIL''))'
                   + Char(10)
    SET @v_dSql += '                  , G.DAILY_CAPA_PPM' + Char(10)
/*
    SET @v_dSql += '                  , ISNULL(D.DAILY_CAPA_M, I.DAILY_CAPA_M)' + Char(10)
    SET @v_dSql += '                  , ISNULL(D.DAILY_CAPA_EA, I.DAILY_CAPA_EA)' + Char(10)
    SET @v_dSql += '                  , ISNULL(D.DAILY_CAPA_KG, I.DAILY_CAPA_KG)' + Char(10)
    SET @v_dSql += '                  , ISNULL(D.DAILY_CAPA_JR, I.DAILY_CAPA_JR)' + Char(10)
    SET @v_dSql += '                  , ISNULL(D.DAILY_CAPA_BATCH, I.DAILY_CAPA_BATCH)' + Char(10)
    SET @v_dSql += '                  , (CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''N'' ELSE ISNULL(D.DC_FLAG, I.DC_FLAG) END)' + Char(10)
*/
    SET @v_dSql += '                  , D.DAILY_CAPA_M' + Char(10)
    SET @v_dSql += '                  , D.DAILY_CAPA_EA' + Char(10)
    SET @v_dSql += '                  , D.DAILY_CAPA_KG' + Char(10)
    SET @v_dSql += '                  , D.DAILY_CAPA_JR' + Char(10)
    SET @v_dSql += '                  , D.DAILY_CAPA_BATCH' + Char(10)
    SET @v_dSql += '                  , (CASE WHEN A.TOP_ITEM_ID=''NONE'' THEN ''N'' ELSE D.DC_FLAG END)' + Char(10)
    SET @v_dSql += '                  , Z.QTY' + Char(10)
    SET @v_dSql += '                  , B.CATEGORY_ID, B.CATEGORY_ORDER, B.CATEGORY_NAME, B.LV1_NAME' + Char(10)
    SET @v_dSql += '                  , A.ITEM_UOM, A.CALC_TYPE,A.WORK_REQUEST_MODEL_ID,A.PLM_EC_NO' + Char(10)
    SET @v_dSql += '      ;--)' + Char(10) --Tuning_block_03
    SET @v_dSql += '      WITH MAIN_S AS (' + Char(10) --Tuning_block_03
    SET @v_dSql += '          -- S' + Char(10)
    SET @v_dSql += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID AS FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '                , NULL AS LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                , A.LINE_ID AS LINE_ID, A.LINE_NAME AS LINE_NAME, NULL AS ELECTRODE_TYPE'
                   + Char(10)
    SET @v_dSql += '                , NULL AS EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '                , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '                , E.BATCH_ID, E.BATCH_ID_2' + Char(10)
    SET @v_dSql += '                , E.PRE_DISPERSION_ID' + Char(10)
    SET @v_dSql += '                , E.PRE_DISPERSION_NAME' + Char(10)
    SET @v_dSql += '                , NULL AS PRE_DISPERSION_ID_2' + Char(10)
    SET @v_dSql += '                , NULL AS PRE_DISPERSION_NAME_2' + Char(10)
    SET @v_dSql += '                , E.ACTIVE_MATERIAL_1, E.ACTIVE_MATERIAL_2, E.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '                , E.BINDER_1, E.BINDER_2, E.BINDER_3' + Char(10)
    SET @v_dSql += '                , E.CMC' + Char(10)
    SET @v_dSql += '	               , E.VERSION' + Char(10)
    SET @v_dSql += '                , E.PC_MODEL_ID' + Char(10)
    SET @v_dSql += '                , E.ADDITION_AGENT' + Char(10)
    SET @v_dSql += '                , E.FOIL_CODE' + Char(10)
    SET @v_dSql += '                , E.FOIL' + Char(10)
    SET @v_dSql += '                , NULL AS DC_PPM' + Char(10)
    SET @v_dSql += '                , NULL AS DC_M' + Char(10)
    SET @v_dSql += '                , NULL AS DC_CELL' + Char(10)
    SET @v_dSql += '                , NULL AS DC_KG' + Char(10)
    SET @v_dSql += '                , NULL AS DC_JR' + Char(10)
    SET @v_dSql += '                , NULL AS DC_BATCH' + Char(10)
    SET @v_dSql += '                , NULL AS DC_FLAG' + Char(10)
    SET @v_dSql += '                , ISNULL(F.QTY,0) AS BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var list = $data.bucket; 
    --                    var weekInfo  = $data.WEEK_INFO; 
    --                    var monthInfo = $data.MONTH_INFO; 
    -- 
    --                    if(list.size() > 0) { 
    --                      for(var i = 0; i < monthInfo.size(); i++) { 
    --                        sql+="               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN C.YYYYMM=''''" + monthInfo[i].month + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''S_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0         \r\n"; 
    --                        sql+="                                                     WHEN B.CATEGORY_ID=''''S_CELL'''' THEN CEILING(A.TARGET_QTY_CELL)*1.0       \r\n"; 
    --                        sql+="                                                     WHEN B.CATEGORY_ID=''''S_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)      \r\n"; 
    --                        sql+="                                                     WHEN B.CATEGORY_ID=''''S_SCP_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0        \r\n"; 
    --                        sql+="                                                     WHEN B.CATEGORY_ID=''''S_SCP_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)     \r\n"; 
    --                        sql+="                                                     WHEN B.CATEGORY_ID=''''S_PAST_SALES'''' THEN A.PAST_SALES_QTY     \r\n"; 
    --                        sql+="                                                     WHEN B.CATEGORY_ID=''''S_ASSY_PLAN'''' THEN A.ASSY_PLAN     \r\n"; 
    --                        sql+="                                                     ELSE 0 END) ELSE 0 END)) AS M" + i + "\r\n"; 
    --                      } 
    -- 
    --                      for(var i = 0; i < weekInfo.size(); i++) { 
    --                        sql+="               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN C.' + @WeekColumn + '=''''" + weekInfo[i].week + "'''' THEN (CASE  WHEN B.CATEGORY_ID=''''S_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0           \r\n"; 
    --                        sql+="                                                       WHEN B.CATEGORY_ID=''''S_CELL'''' THEN CEILING(A.TARGET_QTY_CELL)*1.0       \r\n"; 
    --                        sql+="                                                       WHEN B.CATEGORY_ID=''''S_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)      \r\n"; 
    --                        sql+="                                                       WHEN B.CATEGORY_ID=''''S_SCP_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0        \r\n"; 
    --                        sql+="                                                       WHEN B.CATEGORY_ID=''''S_SCP_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)     \r\n"; 
    --                        sql+="                                                       WHEN B.CATEGORY_ID=''''S_PAST_SALES'''' THEN A.PAST_SALES_QTY     \r\n"; 
    --                        sql+="                                                       WHEN B.CATEGORY_ID=''''S_ASSY_PLAN'''' THEN A.ASSY_PLAN     \r\n"; 
    --                        sql+="                                                       ELSE 0 END) ELSE 0 END)) AS W" + i + "\r\n"; 
    --                      } 
    -- 
    --                      for(var i = 0; i < list.size(); i++) { 
    --                        sql+="               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''S_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0         \r\n"; 
    --                        sql+="                                                                 WHEN B.CATEGORY_ID=''''S_CELL'''' THEN CEILING(A.TARGET_QTY_CELL)*1.0       \r\n"; 
    --                          sql+="                                                                 WHEN B.CATEGORY_ID=''''S_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)      \r\n"; 
    --                          sql+="                                                                 WHEN B.CATEGORY_ID=''''S_SCP_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0      \r\n"; 
    --                          sql+="                                                                 WHEN B.CATEGORY_ID=''''S_SCP_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)   \r\n"; 
    --                          sql+="                                                               WHEN B.CATEGORY_ID=''''S_PAST_SALES'''' THEN A.PAST_SALES_QTY     \r\n"; 
    --                          sql+="                                                               WHEN B.CATEGORY_ID=''''S_ASSY_PLAN'''' THEN A.ASSY_PLAN     \r\n"; 
    --                        sql+="                                                                 ELSE 0 END) ELSE 0 END)) AS D" + i + "\r\n"; 
    --                      } 
    -- 
    --                      for(var i = 0; i < weekInfo.size(); i++) { 
    --                        sql+="                ,  NULL AS W" + i + "_TOT\r\n"; 
    --                      } 
    --                    } 
    --                  } 
    --' 
    IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

			-- MONTH 
            -- 프로시저 LOOP 길이를 판단  
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

				SET @v_dsql += '               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN C.YYYYMM=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''S_PC'' THEN CEILING(A.TARGET_QTY_M)*1.0         '+char(10)
				SET @v_dsql += '                                                     WHEN B.CATEGORY_ID=''S_CELL'' THEN CEILING(A.TARGET_QTY_CELL)*1.0       '+char(10) 
				SET @v_dsql += '                                                     WHEN B.CATEGORY_ID=''S_BATCH'' THEN ROUND(A.TARGET_QTY_BATCH,'+ @v_round_point + ')      '+char(10)
				SET @v_dsql += '                                                     WHEN B.CATEGORY_ID=''S_SCP_PC'' THEN CEILING(A.TARGET_QTY_M)*1.0      '+char(10) 
				SET @v_dsql += '                                                     WHEN B.CATEGORY_ID=''S_SCP_BATCH'' THEN ROUND(A.TARGET_QTY_BATCH,'+ @v_round_point + ')    '+char(10)
				SET @v_dsql += '                                                     WHEN B.CATEGORY_ID=''S_PAST_SALES'' THEN A.PAST_SALES_QTY    '+char(10)
				SET @v_dsql += '                                                     WHEN B.CATEGORY_ID=''S_ASSY_PLAN'' THEN A.ASSY_PLAN    '+char(10)
				SET @v_dsql += '                                                     ELSE 0 END) ELSE 0 END)) AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+char(10)


                --SET @v_dsql += '             , SUM(M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS M'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
				SET @v_dsql += '               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN C.' + @WeekColumn + '=''' + @sub_param_0 + ''' THEN (CASE  WHEN B.CATEGORY_ID=''S_PC'' THEN CEILING(A.TARGET_QTY_M)*1.0           '+char(10)
				SET @v_dsql += '                                                       WHEN B.CATEGORY_ID=''S_CELL'' THEN CEILING(A.TARGET_QTY_CELL)*1.0      '+char(10)
				SET @v_dsql += '                                                       WHEN B.CATEGORY_ID=''S_BATCH'' THEN ROUND(A.TARGET_QTY_BATCH,'+ @v_round_point + ')     '+char(10) 
				SET @v_dsql += '                                                       WHEN B.CATEGORY_ID=''S_SCP_PC'' THEN CEILING(A.TARGET_QTY_M)*1.0       '+char(10)
				SET @v_dsql += '                                                       WHEN B.CATEGORY_ID=''S_SCP_BATCH'' THEN ROUND(A.TARGET_QTY_BATCH,'+ @v_round_point + ')    '+char(10)
				SET @v_dsql += '                                                       WHEN B.CATEGORY_ID=''S_PAST_SALES'' THEN A.PAST_SALES_QTY    '+char(10)
				SET @v_dsql += '                                                       WHEN B.CATEGORY_ID=''S_ASSY_PLAN'' THEN A.ASSY_PLAN    '+char(10)
				SET @v_dsql += '                                                       ELSE 0 END) ELSE 0 END)) AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+char(10) 
                --SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
    --                        sql+="               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN (CASE WHEN B.CATEGORY_ID=''''S_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0         \r\n"; 
    --                        sql+="                                                                 WHEN B.CATEGORY_ID=''''S_CELL'''' THEN CEILING(A.TARGET_QTY_CELL)*1.0       \r\n"; 
    --                          sql+="                                                                 WHEN B.CATEGORY_ID=''''S_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)      \r\n"; 
    --                          sql+="                                                                 WHEN B.CATEGORY_ID=''''S_SCP_PC'''' THEN CEILING(A.TARGET_QTY_M)*1.0      \r\n"; 
    --                          sql+="                                                                 WHEN B.CATEGORY_ID=''''S_SCP_BATCH'''' THEN ROUND(A.TARGET_QTY_BATCH,@ROUND_POINT@)   \r\n"; 
    --                          sql+="                                                               WHEN B.CATEGORY_ID=''''S_PAST_SALES'''' THEN A.PAST_SALES_QTY     \r\n"; 
    --                          sql+="                                                               WHEN B.CATEGORY_ID=''''S_ASSY_PLAN'''' THEN A.ASSY_PLAN     \r\n"; 
    --                        sql+="                                                                 ELSE 0 END) ELSE 0 END)) AS D" + i + "\r\n"; 

				SET @v_dsql += '               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0 + ''' THEN (CASE WHEN B.CATEGORY_ID=''S_PC'' THEN CEILING(A.TARGET_QTY_M)*1.0        '+char(10)
				SET @v_dsql += '                                                                 WHEN B.CATEGORY_ID=''S_CELL'' THEN CEILING(A.TARGET_QTY_CELL)*1.0       '+char(10)
				SET @v_dsql += '                                                                 WHEN B.CATEGORY_ID=''S_BATCH'' THEN ROUND(A.TARGET_QTY_BATCH,'+ @v_round_point + ')     '+char(10)
				SET @v_dsql += '                                                                 WHEN B.CATEGORY_ID=''S_SCP_PC'' THEN CEILING(A.TARGET_QTY_M)*1.0     '+char(10)
				SET @v_dsql += '                                                                 WHEN B.CATEGORY_ID=''S_SCP_BATCH'' THEN ROUND(A.TARGET_QTY_BATCH,'+ @v_round_point + ')  '+char(10)
				SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''S_PAST_SALES'' THEN A.PAST_SALES_QTY     '+char(10)
				SET @v_dsql += '                                                               WHEN B.CATEGORY_ID=''S_ASSY_PLAN'' THEN A.ASSY_PLAN     '+char(10)
				SET @v_dsql += '                                                                 ELSE 0 END) ELSE 0 END)) AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) +''++char(10) 

                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
				--  sql+="                ,  NULL AS W" + i + "_TOT\r\n"; 
				SET @v_dsql += '               ,  NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT'+ Char(10)

                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    


        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '                , B.CATEGORY_ID, B.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '                , B.CATEGORY_NAME' + Char(10)
    SET @v_dSql += '                , B.LV1_NAME' + Char(10)
    SET @v_dSql += '                , A.ITEM_UOM' + Char(10)
    SET @v_dSql += '                , ''S'' AS PSI' + Char(10)
    SET @v_dSql += '                , ''DATA'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '                , NULL AS CALC_TYPE' + Char(10)
    SET @v_dSql += '                , NULL AS PROD_SEQ, NULL AS WORK_REQUEST_MODEL_ID, NULL AS PLM_EC_NO' + Char(10)
    SET @v_dSql += '           FROM (' + Char(10)
    SET @v_dSql += '               SELECT A.*, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME, B.ITEM_UOM' + Char(10)
    SET @v_dSql += '               FROM (' + Char(10)
    SET @v_dSql += '                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                       , NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '                        , A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                        , NULL AS LINE_ID' + Char(10)
    SET @v_dSql += '                        , NULL AS LINE_NAME' + Char(10)
    SET @v_dSql += '                        , A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '                        , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '                        , A.CATEGORY_ID' + Char(10)
    SET @v_dSql += '                        , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                        , A.TARGET_QTY_CELL, A.CARRY_OVER_QTY_CELL, A.RESULT_QTY_CELL' + Char(10)
    SET @v_dSql += '                        , A.TARGET_QTY_M, A.CARRY_OVER_QTY_M, A.RESULT_QTY_M' + Char(10)
    SET @v_dSql += '                        , A.TARGET_QTY_BATCH' + Char(10)
    SET @v_dSql += '                        , A.PAST_SALES_QTY' + Char(10)
    SET @v_dSql += '                        , 0 AS ASSY_PLAN' + Char(10)
    SET @v_dSql += '                   FROM   '+@p_AMEND_SALES_TABLE +' A WITH(NOLOCK)' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	IF @bPastSales = 0 AND @bSM = 0 AND @bSCell = 0 BEGIN
	    SET @v_dSql += 'WHERE 1=0'
	END ELSE BEGIN
	    SET @v_dSQL += 'WHERE 1=1 '
	END
    --SET @v_dSql += ' 
    --{ 
    --                        var sql = "" 
    --                        if( bPastSales != "Y" && bSM != "Y" && bSBatch != "Y" && bSCell != "Y" ) { 
    --                          sql = "WHERE 1=0 " 
    --                        } else { 
    --                          sql = "WHERE 1=1 " 
    --                        } 
    -- 
    --                        sql; 
    --                        } 
    --' 
    SET @v_dSql += '                   AND  A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                   AND    A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                   AND    A.CATEGORY_ID = ''PRODUCT_TARGET''' + Char(10)
    SET @v_dSql += '                   AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    --) + Char(10)
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sDiv = $data.DIVISION_LT; 
    --                                  sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sPlt = $data.PLANT_LT; 
    --                                  sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sFac = $data.FACTORY_LT; 
    --                                  sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                                  sql; 
    --                                } 
    ----' 
    --SET @v_dSql += '                   AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sLine = $data.LINE_LT; 
    --                                  sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                          var sql=""; 
    --                          var sProdType = $data.PRODTYPE_LT; 
    --                          if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                            sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                          } 
    --                          sql; 
    --                        } 
    --' 
    SET @v_dSql += '                   AND (A.TARGET_QTY_CELL + A.TARGET_QTY_M + A.TARGET_QTY_BATCH + ISNULL(A.PAST_SALES_QTY,0) ) > 0'
                   + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

    --SET @v_dSql += ' 
        SET @v_dsql += isnull(@so_dsql, '')
	--{ 
    --                                    sOmitSql; 
    --                                  } 
    --' 
    SET @v_dSql += '                   UNION ALL' + Char(10)
    SET @v_dSql += '                   -- Target(SCP) : 수량 존재하면 무조건 출력... 20210628' + Char(10)
    SET @v_dSql += '                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID'
                   + Char(10)
    SET @v_dSql += '                                      , NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '                                      , A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                                      , A.LINE_ID' + Char(10)
    SET @v_dSql += '                                      , B.LINE_NAME' + Char(10)
    SET @v_dSql += '                                      , A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '                                      , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '                                      , ''SCP'' AS CATEGORY_ID' + Char(10)
    SET @v_dSql += '                                      , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                                      , A.TARGET_QTY_CELL, A.CARRY_OVER_QTY_CELL, A.RESULT_QTY_CELL'
                   + Char(10)
    SET @v_dSql += '                                      , A.TARGET_QTY_M, A.CARRY_OVER_QTY_M, A.RESULT_QTY_M'
                   + Char(10)
    SET @v_dSql += '                                      , A.TARGET_QTY_BATCH' + Char(10)
    SET @v_dSql += '                                      , 0 AS PAST_SALES_QTY' + Char(10)
    SET @v_dSql += '                                      , 0 AS ASSY_PLAN' + Char(10)
    SET @v_dSql += '                                FROM   '+@p_AMEND_SALES_TABLE +' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                                INNER JOIN SCM_LINE_M B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                                ON    1=1' + Char(10)
    SET @v_dSql += '                                AND   B.COMPANY_ID   = A.COMPANY_ID' + Char(10)
    SET @v_dSql += '                                AND   B.DIVISION_ID  = A.DIVISION_ID' + Char(10)
    SET @v_dSql += '                                AND   B.SITE_ID      = A.SITE_ID' + Char(10)
    SET @v_dSql += '                                AND   B.PLANT_ID     = A.PLANT_ID' + Char(10)
    SET @v_dSql += '                                AND   B.FACTORY_ID   = A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                                AND   B.LINE_ID      = A.LINE_ID' + Char(10)
    SET @v_dSql += '                                AND   B.OPERATION_ID = A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                                AND   B.ELECTRODE_TYPE = A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                   WHERE A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                   AND   A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                   AND   A.CATEGORY_ID = ''PRODUCT_TARGET''' + Char(10)
    SET @v_dSql += '                   AND   CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)

    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sDiv = $data.DIVISION_LT; 
    --                                  sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sPlt = $data.PLANT_LT; 
    --                                  sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sFac = $data.FACTORY_LT; 
    --                                  sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += '                   AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sLine = $data.LINE_LT; 
    --                                  sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sProdType = $data.PRODTYPE_LT; 
    --                                  if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                                    sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                                  } 
    --                                  sql; 
    --                                } 
    --' 
    SET @v_dSql += '                   AND (A.TARGET_QTY_CELL + A.TARGET_QTY_M + A.TARGET_QTY_BATCH) > 0' + Char(10)
    SET @v_dSql += '                   UNION ALL' + Char(10)
    SET @v_dSql += '                    SELECT  A.COMPANY_ID' + Char(10)
    SET @v_dSql += ' , A.DIVISION_ID' + Char(10)
    SET @v_dSql += ' , A.SITE_ID' + Char(10)
    SET @v_dSql += ' , B.PLANT_ID' + Char(10)
    SET @v_dSql += ' , NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '	, ''E2000'' AS OPERATION_ID' + Char(10)
    SET @v_dSql += ' , NULL AS LINE_ID' + Char(10)
    SET @v_dSql += ' , NULL AS LINE_NAME' + Char(10)
    SET @v_dSql += ' , A.ELEC_ITEM_ID AS TOP_ITEM_ID' + Char(10)
    SET @v_dSql += ' , A.ELEC_ITEM_ID AS ITEM_ID' + Char(10)
    SET @v_dSql += ' , A.PRODUCTION_TYPE AS PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += ' , A.MARKET' + Char(10)
    SET @v_dSql += ' , ''PRODUCT_TARGET'' AS CATEGORY_ID' + Char(10)
    SET @v_dSql += ' , A.PLAN_DATE' + Char(10)
    SET @v_dSql += ' , 0 AS TARGET_QTY_CELL, 0 AS CARRY_OVER_QTY_CELL, 0 AS RESULT_QTY_CELL' + Char(10)
    SET @v_dSql += ' , 0 AS TARGET_QTY_M, 0 AS CARRY_OVER_QTY_M, 0 AS RESULT_QTY_M' + Char(10)
    SET @v_dSql += ' , 0 AS TARGET_QTY_BATCH' + Char(10)
    SET @v_dSql += ' , 0 AS PAST_SALES_QTY' + Char(10)
    SET @v_dSql += ' , SUM(A.PLAN_IN_QTY) AS ASSY_PLAN' + Char(10)
    SET @v_dSql += ' FROM  FP_AMEND_ELEC_TO_ASSY_PLAN_R A,' + Char(10)
    SET @v_dSql += ' (SELECT DISTINCT A.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID' + Char(10)
    SET @v_dSql += '  FROM  FP_INSTANCE_FACTORY_M A,' + Char(10)
    SET @v_dSql += ' SCM_FACTORY_M B' + Char(10)
    SET @v_dSql += '  WHERE  1=1' + Char(10)
    SET @v_dSql += '  AND  A.SHOP_GROUP_ID = ''E''' + Char(10)
    SET @v_dSql += '  AND  A.ACTIVE_FLAG = ''Y''' + Char(10)
    SET @v_dSql += '  AND  B.ACTIVE_FLAG = ''Y''' + Char(10)
    SET @v_dSql += '  AND  A.FACTORY_ID = B.FACTORY_ID) B' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
	IF @bAssyPlan = 0 BEGIN
		SET @v_dSql += 'WHERE 1=0 '
	end else begin
	    SET @v_dSql += 'WHERE 1=1 '
	END
    --{ 
    --                          var sql = "" 
    --                          if( bAssyPlan != "Y" ) { 
    --                            sql = "WHERE 1=0 " 
    --                          } else { 
    --                            sql = "WHERE 1=1 " 
    --                          } 
    -- 
    --                          sql; 
    --                        } 
    --' 
    SET @v_dSql += '   AND  A.INSTANCE_ID = B.INSTANCE_ID' + Char(10)
    SET @v_dSql += '   AND  A.SITE_ID = B.SITE_ID' + Char(10)
    SET @v_dSql += '   AND  A.DIVISION_ID = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '   AND  A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                   AND A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_basis_plan_id + '' + Char(10)
    SET @v_dSql += '	                  AND   CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ELEC_ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
	
    --SET @v_dSql += ' 
    --{ 
    --                                    var sql=""; 
    --                                    var sDiv = $data.DIVISION_LT; 
    --                                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                                    sql; 
    --                                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    ----AND    A.SITE_ID   = #SITE_ID# 
    --SET @v_dSql += ' ' + @opt_106item_id + ' ' + '' + Char(10)
    --AND    A.ELEC_ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                          var sql=""; 
    --                          var sProdType = $data.PRODTYPE_LT; 
    --                          if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                            sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                          } 
    --                          sql; 
    --                        } 
    --' 
    SET @v_dSql += '   GROUP BY  A.COMPANY_ID' + Char(10)
    SET @v_dSql += ' , A.DIVISION_ID' + Char(10)
    SET @v_dSql += ' , A.SITE_ID' + Char(10)
    SET @v_dSql += ' , B.PLANT_ID' + Char(10)
    SET @v_dSql += ' , A.ELEC_ITEM_ID' + Char(10)
    SET @v_dSql += ' , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += ' , A.MARKET' + Char(10)
    SET @v_dSql += ' , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                   UNION ALL' + Char(10)
    SET @v_dSql += '                   -- p item' + Char(10)
    SET @v_dSql += '                   SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '	                      , NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '                        , A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                        , NULL AS LINE_ID' + Char(10)
    SET @v_dSql += '                        , NULL AS LINE_NAME' + Char(10)
    SET @v_dSql += '                        , A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '                        , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '                        , ''PRODUCT_TARGET'' AS CATEGORY_ID' + Char(10)
    SET @v_dSql += '                        , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                        , 0 AS TARGET_QTY_CELL, 0 AS CARRY_OVER_QTY_CELL, 0 AS RESULT_QTY_CELL'
                   + Char(10)
    SET @v_dSql += '                        , 0 AS TARGET_QTY_M, 0 AS CARRY_OVER_QTY_M, 0 AS RESULT_QTY_M' + Char(10)
    SET @v_dSql += '                        , 0 AS TARGET_QTY_BATCH' + Char(10)
    SET @v_dSql += '                        , 0 AS PAST_SALES_QTY' + Char(10)
    SET @v_dSql += '                        , 0 AS ASSY_PLAN' + Char(10)
    SET @v_dSql += '                   FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                   WHERE  A.INSTANCE_ID      =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                   AND    A.FP_PLAN_ID       =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                   AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)

    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sDiv = $data.DIVISION_LT; 
    --                                  sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sPlt = $data.PLANT_LT; 
    --                                  sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sFac = $data.FACTORY_LT; 
    --                                  sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                                  sql; 
    --                                } 
    ----' 
    --SET @v_dSql += '                   AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sLine = $data.LINE_LT; 
    --                                  sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                        var sql=""; 
    --                        var sProdType = $data.PRODTYPE_LT; 
    --                        if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                          sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                        } 
    --                        sql; 
    --                      } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += '
	    SET @v_dsql += isnull(@omitSql, '')
    --{ 
    --                                      omitSql; 
    --                                  } 
    --' 
    SET @v_dSql += '               ) A' + Char(10)
    SET @v_dSql += '               INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '               ON     A.COMPANY_ID   = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '               AND    A.DIVISION_ID  = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '               AND    A.SITE_ID      = B.SITE_ID' + Char(10)
    SET @v_dSql += '               AND    A.ITEM_ID      = B.ITEM_ID' + Char(10)
    SET @v_dSql += '               AND    B.ACTIVE_FLAG  = ''Y''' + Char(10)
    SET @v_dSql += '               WHERE  1=1' + Char(10)
    SET @v_dSql += ' ' + @opt_81item_name + ' ' + '' + Char(10)
    --AND   B.NICK_NAME LIKE '%' + LTRIM(RTRIM( #ITEM_NAME# )) + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                          var sql=""; 
    --                          var sNickNameLt = $data.NICKNAME_LT; 
    -- 
    --                          if(sNickNameLt!="" && sNickNameLt!=null)  sql="AND   ISNULL(B.NICK_NAME,''''-'''') IN (" + sNickNameLt + ")\r\n"; 
    -- 
    --                          sql; 
    --                        } 
    --' 
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(B.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + Char(10)

    SET @v_dSql += '           ) A' + Char(10)
    SET @v_dSql += '           INNER JOIN (' + Char(10)
    SET @v_dSql += '               SELECT *' + Char(10)
    SET @v_dSql += '               FROM (' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 


	SET @v_dSql += @sSql 
    --{ 
    --                        sSql; 
    --                      } 
    --' 
    SET @v_dSql += '               ) A' + Char(10)
    SET @v_dSql += '               WHERE CATEGORY_ID <> ''X''' + Char(10)
    SET @v_dSql += '           ) B' + Char(10)
    SET @v_dSql += '           ON 1=1' + Char(10)
    SET @v_dSql += '           AND A.CATEGORY_ID = B.CATE' + Char(10)
    SET @v_dSql += '           INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '           ON  A.PLAN_DATE = C.DT' + Char(10)
    SET @v_dSql += '           AND C.YYYYMMDD  BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '           LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += '	              SELECT  NULL AS BATCH_ID' + Char(10)
    SET @v_dSql += '                    , NULL  AS BATCH_ID_2' + Char(10)
    SET @v_dSql += '                    , NULL  AS ACTIVE_MATERIAL_1' + Char(10)
    SET @v_dSql += '                    , NULL  AS ACTIVE_MATERIAL_2' + Char(10)
    SET @v_dSql += '                    , NULL  AS ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '                    , NULL  AS BINDER_1' + Char(10)
    SET @v_dSql += '                    , NULL  AS BINDER_2' + Char(10)
    SET @v_dSql += '                    , NULL  AS BINDER_3' + Char(10)
    SET @v_dSql += '                    , NULL  AS PRE_DISPERSION_ID' + Char(10)
    SET @v_dSql += '                    , NULL  AS PRE_DISPERSION_NAME' + Char(10)
    SET @v_dSql += '                    , NULL  AS CMC' + Char(10)
    SET @v_dSql += '                    , NULL  AS FOIL' + Char(10)
    SET @v_dSql += '                    , NULL  AS FOIL_CODE' + Char(10)
    SET @v_dSql += '                    , NULL  AS VERSION' + Char(10)
    SET @v_dSql += '                    , NULL  AS PC_MODEL_ID' + Char(10)
    SET @v_dSql += '                    , NULL  AS ADDITION_AGENT' + Char(10)
    SET @v_dSql += '           ) E' + Char(10)
    SET @v_dSql += '           ON  1=1' + Char(10)
    SET @v_dSql += '           LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += '               SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                    , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '                    , SUM(ISNULL(CASE WHEN B.ITEM_UOM = ''M'' THEN A.CARRY_OVER_QTY_M ELSE A.CARRY_OVER_QTY_CELL END,0)) * (-1) AS QTY'
                   + Char(10)
    SET @v_dSql += '               FROM   '+@p_AMEND_SALES_TABLE +' A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '               WHERE  A.COMPANY_ID   = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '               AND    A.DIVISION_ID  = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '               AND    A.SITE_ID      = B.SITE_ID' + Char(10)
    SET @v_dSql += '               AND    A.ITEM_ID      = B.ITEM_ID' + Char(10)
    SET @v_dSql += '               AND    A.INSTANCE_ID  =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '               AND    A.FP_PLAN_ID   =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '               AND    A.CATEGORY_ID  = ''PRODUCT_TARGET''' + Char(10)
    SET @v_dSql += '               AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(B.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + Char(10)

    --SET @v_dSql += ' 
    --{ 
    --                        var sql=""; 
    --                        var sDiv = $data.DIVISION_LT; 
    --                        sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                        sql; 
    --                      } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                        var sql=""; 
    --                        var sPlt = $data.PLANT_LT; 
    --                        sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                        sql; 
    --                      } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                        var sql=""; 
    --                        var sFac = $data.FACTORY_LT; 
    --                        sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                        sql; 
    --                      } 
    --' 
    --SET @v_dSql += '               AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                        var sql=""; 
    --                        var sLine = $data.LINE_LT; 
    --                        sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                        sql; 
    --                      } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_90item_name + ' ' + '' + Char(10)
    --AND    B.NICK_NAME LIKE '%' + LTRIM(RTRIM( #ITEM_NAME# )) + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                        var sql=""; 
    --                        var sNickNameLt = $data.NICKNAME_LT; 
    -- 
    --                        if(sNickNameLt!="" && sNickNameLt!=null)  sql="AND    ISNULL(B.NICK_NAME,''''-'''') IN (" + sNickNameLt + ")\r\n"; 
    -- 
    --                        sql; 
    --                      } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                  var sql=""; 
    --                  var sProdType = $data.PRODTYPE_LT; 
    --                  if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                    sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                  } 
    --                  sql; 
    --                } 
    --' 
    SET @v_dSql += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                      , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '           ) F' + Char(10)
    SET @v_dSql += '           ON  A.COMPANY_ID   = F.COMPANY_ID' + Char(10)
    SET @v_dSql += '           AND A.DIVISION_ID  = F.DIVISION_ID' + Char(10)
    SET @v_dSql += '           AND A.SITE_ID      = F.SITE_ID' + Char(10)
    SET @v_dSql += '           AND A.PLANT_ID     = F.PLANT_ID' + Char(10)
    SET @v_dSql += '           AND A.OPERATION_ID = F.OPERATION_ID' + Char(10)
    SET @v_dSql += '           AND A.TOP_ITEM_ID  = F.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '           AND A.ITEM_ID      = F.ITEM_ID' + Char(10)
    SET @v_dSql += '           WHERE 1=1' + Char(10)
    SET @v_dSql += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                  , A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME'
                   + Char(10)
    SET @v_dSql += '                  , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '                  , E.BATCH_ID, E.BATCH_ID_2, E.PRE_DISPERSION_ID, E.PRE_DISPERSION_NAME'
                   + Char(10)
    SET @v_dSql += '                  , E.ACTIVE_MATERIAL_1, E.ACTIVE_MATERIAL_2, E.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '                  , E.BINDER_1, E.BINDER_2, E.BINDER_3' + Char(10)
    SET @v_dSql += '                  , E.CMC' + Char(10)
    SET @v_dSql += '                  , E.VERSION' + Char(10)
    SET @v_dSql += '                  , E.PC_MODEL_ID' + Char(10)
    SET @v_dSql += '                  , E.ADDITION_AGENT' + Char(10)
    SET @v_dSql += '                  , E.FOIL_CODE' + Char(10)
    SET @v_dSql += '                  , E.FOIL' + Char(10)
    SET @v_dSql += '                  , F.QTY' + Char(10)
    SET @v_dSql += '                  , B.CATEGORY_ID, B.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '                  , B.CATEGORY_NAME' + Char(10)
    SET @v_dSql += '                  , B.LV1_NAME' + Char(10)
    SET @v_dSql += '                  , A.ITEM_UOM' + Char(10)
    SET @v_dSql += '      )' + Char(10)
    SET @v_dSql += '      , MAIN_I AS (' + Char(10)
    SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '               , NULL AS LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '               , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS PRODUCTION_TYPE, NULL AS MARKET' + Char(10)
    SET @v_dSql += '               , E.BATCH_ID, E.BATCH_ID_2' + Char(10)
    SET @v_dSql += '               , E.PRE_DISPERSION_ID' + Char(10)
    SET @v_dSql += '               , E.PRE_DISPERSION_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS PRE_DISPERSION_ID_2' + Char(10)
    SET @v_dSql += '               , NULL AS PRE_DISPERSION_NAME_2' + Char(10)
    SET @v_dSql += '               , E.ACTIVE_MATERIAL_1, E.ACTIVE_MATERIAL_2, E.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '               , E.BINDER_1, E.BINDER_2, E.BINDER_3' + Char(10)
    SET @v_dSql += '               , E.CMC' + Char(10)
    SET @v_dSql += '               , E.VERSION' + Char(10)
    SET @v_dSql += '               , E.PC_MODEL_ID' + Char(10)
    SET @v_dSql += '               , E.ADDITION_AGENT' + Char(10)
    SET @v_dSql += '               , E.FOIL_CODE' + Char(10)
    SET @v_dSql += '               , E.FOIL' + Char(10)
    SET @v_dSql += '               , NULL AS DC_PPM' + Char(10)
    SET @v_dSql += '               , NULL AS DC_M' + Char(10)
    SET @v_dSql += '               , NULL AS DC_CELL' + Char(10)
    SET @v_dSql += '               , NULL AS DC_KG' + Char(10)
    SET @v_dSql += '               , NULL AS DC_JR' + Char(10)
    SET @v_dSql += '               , NULL AS DC_BATCH' + Char(10)
    SET @v_dSql += '               , NULL AS DC_FLAG' + Char(10)
    SET @v_dSql += '               , ISNULL(A.BOH_QTY,0) AS BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                var sql=""; 
    --                var list = $data.bucket; 
    --                var weekInfo  = $data.WEEK_INFO; 
    --                var monthInfo = $data.MONTH_INFO; 
    -- 
    --                if(list.size() > 0) { 
    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                    sql+="             , NULL AS M" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , CONVERT(NUMERIC(25,10), SUM(CASE WHEN A.PLAN_WEEK<=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''''" + $data.PLAN_DATE + "'''' THEN (CASE WHEN F.CATEGORY_NAME = ''''Cell'''' THEN A.EOH_CELL_QTY ELSE A.EOH_M_QTY END) ELSE 0 END) ELSE 0 END )) AS W" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                    sql+="               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''''" + list[i].VALUE + "'''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''''" + $data.PLAN_DATE + "'''' THEN (CASE WHEN F.CATEGORY_NAME = ''''Cell'''' THEN A.EOH_CELL_QTY ELSE A.EOH_M_QTY END) ELSE 0 END)) AS D" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , NULL AS W" + i + "_TOT\r\n"; 
    --                  } 
    --                } 
    --              } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

			-- MONTH 
            -- 프로시저 LOOP 길이를 판단  
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

    --                    sql+="             , NULL AS M" + i + "\r\n"; 
				SET @v_dsql += '             , NULL AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ''+ char(10) 
		    --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
				--  sql+="             , CONVERT(NUMERIC(25,10), SUM(CASE WHEN A.PLAN_WEEK<=''''" + weekInfo[i].week + "'''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''''" + $data.PLAN_DATE + "'''' THEN (CASE WHEN F.CATEGORY_NAME = ''''Cell'''' THEN A.EOH_CELL_QTY ELSE A.EOH_M_QTY END) ELSE 0 END) ELSE 0 END )) AS W" + i + "\r\n"; 
				SET @v_dsql += '             , CONVERT(NUMERIC(25,10), SUM(CASE WHEN A.PLAN_WEEK<=''' + @sub_param_0 + ''' THEN (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= A.WEEK_ENDDATE AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+@p_plan_date+''' THEN (CASE WHEN F.CATEGORY_NAME = ''Cell'' THEN A.EOH_CELL_QTY ELSE A.EOH_M_QTY END) ELSE 0 END) ELSE 0 END )) AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+char(10) 
                --SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
    --                    sql+="               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''''" + list[i].VALUE + "'''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= ''''" + $data.PLAN_DATE + "'''' THEN (CASE WHEN F.CATEGORY_NAME = ''''Cell'''' THEN A.EOH_CELL_QTY ELSE A.EOH_M_QTY END) ELSE 0 END)) AS D" + i + "\r\n"; 
				SET @v_dsql += '               , CONVERT(NUMERIC(25,10),SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''' + @sub_param_0 + ''' AND CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @p_plan_date+''' THEN (CASE WHEN F.CATEGORY_NAME = ''Cell'' THEN A.EOH_CELL_QTY ELSE A.EOH_M_QTY END) ELSE 0 END)) AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+CHAR(10)


                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
				--  sql+="                ,  NULL AS W" + i + "_TOT\r\n"; 
				SET @v_dsql += '               ,  NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT'+ Char(10)

                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    


        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '               , ''I'' AS CATEGORY_ID' + Char(10)
    SET @v_dSql += '               , F.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , F.CATEGORY_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS LV1_NAME' + Char(10)
    SET @v_dSql += '               , F.CATEGORY_NAME AS ITEM_UOM' + Char(10)
    SET @v_dSql += '               , ''I'' AS PSI' + Char(10)
    SET @v_dSql += '               , ''DATA'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS CALC_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS PROD_SEQ, NULL AS WORK_REQUEST_MODEL_ID, NULL AS PLM_EC_NO' + Char(10)
    SET @v_dSql += '          FROM (' + Char(10)
    SET @v_dSql += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                   , A.OPERATION_ID, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_UOM, A.NICK_NAME'
                   + Char(10)
    SET @v_dSql += '                   , B.QTY * (-1) AS BOH_QTY' + Char(10)
    SET @v_dSql += '                   , E.' + @WeekColumn + ' AS PLAN_WEEK, E.WEEK_ENDDATE' + Char(10)
    SET @v_dSql += '                   , (CASE WHEN A.PLAN_DATE = CONVERT(DATE,' + Char(10)
    SET @v_dSql += '' + @v_plan_date + '' + Char(10)
    SET @v_dSql += ') THEN ((ISNULL(B.CARRY_OVER_QTY_M,0)*(-1)) - A.S_M_QTY + A.P_M_QTY) ELSE (0 - A.S_M_QTY + A.P_M_QTY) END) AS EOH_M_QTY'
                   + Char(10)
    SET @v_dSql += '                   , (CASE WHEN A.PLAN_DATE = CONVERT(DATE,' + Char(10)
    SET @v_dSql += '' + @v_plan_date + '' + Char(10)
    SET @v_dSql += ') THEN ((ISNULL(B.CARRY_OVER_QTY_CELL,0)*(-1)) - A.S_CELL_QTY + A.P_CELL_QTY) ELSE (0 - A.S_CELL_QTY + A.P_CELL_QTY) END) AS EOH_CELL_QTY'
                   + Char(10)
    SET @v_dSql += '              FROM (' + Char(10)
    SET @v_dSql += '                   SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                        , A.OPERATION_ID, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, C.ITEM_UOM, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME'
                   + Char(10)
    SET @v_dSql += '                        , SUM(CEILING(A.ADJUST_OUT_QTY_M)) AS P_M_QTY' + Char(10)
    SET @v_dSql += '                        , SUM(CEILING(A.ADJUST_OUT_QTY_CELL)) AS P_CELL_QTY' + Char(10)
    SET @v_dSql += '                        , SUM(CEILING(A.TARGET_QTY_M)) AS S_M_QTY' + Char(10)
    SET @v_dSql += '                        , SUM(CEILING(A.TARGET_QTY_CELL)) AS S_CELL_QTY' + Char(10)
    SET @v_dSql += '                   FROM (' + Char(10)
    SET @v_dSql += '                       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '                            , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                            , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                            , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                            , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                            , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + Char(10)
    SET @v_dSql += '                            , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '                            , A.MARKET' + Char(10)
    SET @v_dSql += '                            , A.SEQ' + Char(10)
    SET @v_dSql += '                            , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY, A.ADJUST_OUT_QTY_M, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , 0 AS ADJUST_RESULT_QTY_BATCH, 0 AS ADJUST_RESULT_QTY, 0 AS ADJUST_RESULT_QTY_M, 0 AS ADJUST_RESULT_QTY_CELL, 0 AS ADJUST_RESULT_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , 0 AS TARGET_QTY_CELL, 0 AS TARGET_QTY_M' + Char(10)
    SET @v_dSql += '                       FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                       WHERE  INSTANCE_ID      =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                       AND    FP_PLAN_ID       =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                       AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)


    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sDiv = $data.DIVISION_LT; 
    --                              sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                              sql; 
    --                            } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sPlt = $data.PLANT_LT; 
    --                              sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                              sql; 
    --                            } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sFac = $data.FACTORY_LT; 
    --                              sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                              sql; 
    --                            } 
    --' 
    --SET @v_dSql += '                       AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sLine = $data.LINE_LT; 
    --                              sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                              sql; 
    --                            } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sProdType = $data.PRODTYPE_LT; 
    --                    if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                      sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                    } 
    --                    sql; 
    --                  } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    SET @v_dsql += isnull(@omitSql, '')
    --{ 
    --                                omitSql; 
    --                            } 
    --' 
    SET @v_dSql += '                       UNION ALL' + Char(10)
    SET @v_dSql += '                       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '                            , NULL AS LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                            , NULL AS LINE_ID, NULL AS ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                            , NULL AS EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                            , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                            , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + Char(10)
    SET @v_dSql += '                            , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '                            , NULL AS SEQ' + Char(10)
    SET @v_dSql += '                            , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_M, 0 AS ADJUST_IN_QTY_CELL, 0 AS ADJUST_IN_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_M, 0 AS ADJUST_OUT_QTY_CELL, 0 AS ADJUST_OUT_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , 0 AS ADJUST_RESULT_QTY_BATCH, 0 AS ADJUST_RESULT_QTY, 0 AS ADJUST_RESULT_QTY_M, 0 AS ADJUST_RESULT_QTY_CELL, 0 AS ADJUST_RESULT_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , SUM(A.TARGET_QTY_CELL) AS TARGET_QTY_CELL, SUM(A.TARGET_QTY_M) AS TARGET_QTY_M'
                   + Char(10)
    SET @v_dSql += '                       FROM   '+@p_AMEND_SALES_TABLE +' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                       WHERE  A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                       AND    A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                       AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '                       AND    A.CATEGORY_ID = ''PRODUCT_TARGET''' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)

    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)


    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sDiv = $data.DIVISION_LT; 
    --                              sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                              sql; 
    --                            } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sPlt = $data.PLANT_LT; 
    --                              sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                              sql; 
    --                            } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sFac = $data.FACTORY_LT; 
    --                              sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                              sql; 
    --                            } 
    --' 
    --SET @v_dSql += '                       AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                              var sql=""; 
    --                              var sLine = $data.LINE_LT; 
    --                              sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                              sql; 
    --                            } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sProdType = $data.PRODTYPE_LT; 
    --                    if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                      sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                    } 
    --                    sql; 
    --                  } 
    --' 
    SET @v_dSql += '                       AND ( A.TARGET_QTY_CELL <> 0 OR A.TARGET_QTY_M <> 0 )' + Char(10)
    SET @v_dSql += '                       GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID'
                   + Char(10)
    SET @v_dSql += '                              , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET'
                   + Char(10)
    SET @v_dSql += '                       -- 0 qty data create start' + Char(10)
    SET @v_dSql += '                       UNION ALL' + Char(10)
    SET @v_dSql += '                       SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '                            , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                            , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                            , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                            , D.DT AS PLAN_DATE' + Char(10)
    SET @v_dSql += '                            , A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '                            , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '                            , A.MARKET' + Char(10)
    SET @v_dSql += '                            , A.SEQ' + Char(10)
    SET @v_dSql += '                            , 0 AS ADJUST_IN_QTY_BATCH, 0 AS ADJUST_IN_QTY, 0 AS ADJUST_IN_QTY_M, 0 AS ADJUST_IN_QTY_CELL, 0 AS ADJUST_IN_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY, 0 AS ADJUST_OUT_QTY_M, 0 AS ADJUST_OUT_QTY_CELL, 0 AS ADJUST_OUT_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , 0 AS ADJUST_RESULT_QTY_BATCH, 0 AS ADJUST_RESULT_QTY, 0 AS ADJUST_RESULT_QTY_M, 0 AS ADJUST_RESULT_QTY_CELL, 0 AS ADJUST_RESULT_QTY_JR'
                   + Char(10)
    SET @v_dSql += '                            , 0 AS TARGET_QTY_CELL, 0 AS TARGET_QTY_M' + Char(10)
    SET @v_dSql += '                       FROM   (' + Char(10)
    SET @v_dSql += '                           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '                                , A.LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                                , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                                , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                                , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                                , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + Char(10)
    SET @v_dSql += '                                , A.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '                                , A.MARKET' + Char(10)
    SET @v_dSql += '                                , A.SEQ' + Char(10)
    SET @v_dSql += '                           FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                           WHERE  INSTANCE_ID      =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                           AND    FP_PLAN_ID       =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                           AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)

    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sDiv = $data.DIVISION_LT; 
    --                                  sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sPlt = $data.PLANT_LT; 
    --                                  sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sFac = $data.FACTORY_LT; 
    --                                  sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                                  sql; 
    --                                } 
    ----' 
    --SET @v_dSql += '                           AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sLine = $data.LINE_LT; 
    --                                  sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                      var sql=""; 
    --                      var sProdType = $data.PRODTYPE_LT; 
    --                      if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                        sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                      } 
    --                      sql; 
    --                    } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    SET @v_dsql += isnull(@omitSql, '')
    --{ 
    --                                  omitSql; 
    --                              } 
    --' 
    SET @v_dSql += '                           UNION ALL' + Char(10)
    SET @v_dSql += '                           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '                                , NULL AS LOCATION, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                                , NULL AS LINE_ID, NULL AS ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                                , NULL AS EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                                , A.PLAN_DATE' + Char(10)
    SET @v_dSql += '                                , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + Char(10)
    SET @v_dSql += '                                , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '                                , NULL AS SEQ' + Char(10)
    SET @v_dSql += '                           FROM   '+@p_AMEND_SALES_TABLE +' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                           WHERE  A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                           AND    A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                           AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '                           AND    A.CATEGORY_ID = ''PRODUCT_TARGET''' + Char(10)

    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    --SET @v_dsql +=
    --(
    --    SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    --) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)


    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sDiv = $data.DIVISION_LT; 
    --                                  sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sPlt = $data.PLANT_LT; 
    --                                  sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sFac = $data.FACTORY_LT; 
    --                                  sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += '                           AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                                  var sql=""; 
    --                                  var sLine = $data.LINE_LT; 
    --                                  sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                                  sql; 
    --                                } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                      var sql=""; 
    --                      var sProdType = $data.PRODTYPE_LT; 
    --                      if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --                        sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --                      } 
    --                      sql; 
    --                    } 
    --' 
    SET @v_dSql += '                           AND ( A.TARGET_QTY_CELL <> 0 OR A.TARGET_QTY_M <> 0 )' + Char(10)
    SET @v_dSql += '                       ) A' + Char(10)
    SET @v_dSql += '                       FULL OUTER JOIN (' + Char(10)
    SET @v_dSql += '                        SELECT *' + Char(10)
    SET @v_dSql += '                        FROM TH_UIS_CAL D WITH(NOLOCK)' + Char(10)
    SET @v_dSql += ' WHERE D.YYYYMMDD BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '                       ) D' + Char(10)
    SET @v_dSql += '                       ON   1=1' + Char(10)
    SET @v_dSql += '                  ) A' + Char(10)
    SET @v_dSql += '                  INNER JOIN SCM_ITEM_M C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                  ON     A.COMPANY_ID   = C.COMPANY_ID' + Char(10)
    SET @v_dSql += '                  AND    A.DIVISION_ID  = C.DIVISION_ID' + Char(10)
    SET @v_dSql += '                  AND    A.SITE_ID      = C.SITE_ID' + Char(10)
    SET @v_dSql += '                  AND    A.ITEM_ID      = C.ITEM_ID' + Char(10)
    SET @v_dSql += '                  WHERE  1=1' + Char(10)
    SET @v_dSql += '                  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(C.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('C.NICK_NAME', 'LK', @p_nickname)
    ) + Char(10)

	


    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sDiv = $data.DIVISION_LT; 
    --                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    ----                    sql; 
    ----                  } 
    ----' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    ----AND    A.SITE_ID   = #SITE_ID# 
    ------ REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    ----SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sPlt = $data.PLANT_LT; 
    --                    sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                    sql; 
    --                  } 
    ----' 
    --SET @v_dSql += '                  AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_125item_name + ' ' + '' + Char(10)
    --AND    C.NICK_NAME LIKE '%' + LTRIM(RTRIM( #ITEM_NAME# )) + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sNickNameLt = $data.NICKNAME_LT; 
    -- 
    --                    if(sNickNameLt!="" && sNickNameLt!=null)  sql="AND    ISNULL(C.NICK_NAME,''''-'''') IN (" + sNickNameLt + ")\r\n"; 
    -- 
    --                    sql; 
    --                  } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --            var sql=""; 
    --            var sProdType = $data.PRODTYPE_LT; 
    --            if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --              sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --            } 
    --            sql; 
    --          } 
    --' 
    SET @v_dSql += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                         , A.OPERATION_ID, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, C.ITEM_UOM, ISNULL(C.NICK_NAME,''-'')'
                   + Char(10)
    SET @v_dSql += '              ) A' + Char(10)
    SET @v_dSql += '              LEFT OUTER HASH JOIN (' + Char(10)
    SET @v_dSql += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                       , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '                       , SUM(ISNULL(CASE WHEN B.ITEM_UOM = ''M'' THEN A.CARRY_OVER_QTY_M ELSE A.CARRY_OVER_QTY_CELL END,0)) AS QTY'
                   + Char(10)
    SET @v_dSql += '                       , SUM(ISNULL(A.CARRY_OVER_QTY_M,0)) AS CARRY_OVER_QTY_M' + Char(10)
    SET @v_dSql += '                       , SUM(ISNULL(A.CARRY_OVER_QTY_CELL,0)) AS CARRY_OVER_QTY_CELL' + Char(10)
    SET @v_dSql += '                  FROM   '+@p_AMEND_SALES_TABLE +' A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                  WHERE  A.COMPANY_ID   = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '                  AND    A.DIVISION_ID  = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '                  AND    A.SITE_ID      = B.SITE_ID' + Char(10)
    SET @v_dSql += '                  AND    A.ITEM_ID      = B.ITEM_ID' + Char(10)
    SET @v_dSql += '                  AND    A.INSTANCE_ID  =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '                  AND    A.FP_PLAN_ID   =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '                  AND    A.CATEGORY_ID  = ''PRODUCT_TARGET''' + Char(10)
    SET @v_dSql += '                  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('ISNULL(B.NICK_NAME,''-'')', 'EQ', @p_nickname_lt)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('B.NICK_NAME', 'LK', @p_nickname)
    ) + Char(10)
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sDiv = $data.DIVISION_LT; 
    --                    sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sPlt = $data.PLANT_LT; 
    --                    sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --                    sql; 
    --                  } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sFac = $data.FACTORY_LT; 
    --                    sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --                    sql; 
    --                  } 
    ----' 
    --SET @v_dSql += '                  AND    A.OPERATION_ID =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sLine = $data.LINE_LT; 
    --                    sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --                    sql; 
    --                  } 
    --' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_90item_name + ' ' + '' + Char(10)
    --AND    B.NICK_NAME LIKE '%' + LTRIM(RTRIM( #ITEM_NAME# )) + '%' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var sNickNameLt = $data.NICKNAME_LT; 
    -- 
    --                    if(sNickNameLt!="" && sNickNameLt!=null)  sql="AND    ISNULL(B.NICK_NAME,''''-'''') IN (" + sNickNameLt + ")\r\n"; 
    -- 
    --                    sql; 
    --                  } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --            var sql=""; 
    --            var sProdType = $data.PRODTYPE_LT; 
    --            if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --              sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --            } 
    --            sql; 
    --          } 
    --' 
    SET @v_dSql += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '                         , A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID' + Char(10)
    SET @v_dSql += '              ) B' + Char(10)
    SET @v_dSql += '              ON  A.COMPANY_ID   = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '              AND A.DIVISION_ID  = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '              AND A.SITE_ID      = B.SITE_ID' + Char(10)
    SET @v_dSql += '              AND A.PLANT_ID     = B.PLANT_ID' + Char(10)
    SET @v_dSql += '              AND A.OPERATION_ID = B.OPERATION_ID' + Char(10)
    SET @v_dSql += '              AND A.TOP_ITEM_ID  = B.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '              AND A.ITEM_ID      = B.ITEM_ID' + Char(10)
    SET @v_dSql += '              INNER HASH JOIN (' + Char(10)
    SET @v_dSql += '                  SELECT A.DT, B.YYYYMMDD AS WEEK_ENDDATE, A.' + @WeekColumn + '' + Char(10)
    SET @v_dSql += '                  FROM TH_UIS_CAL A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                  LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += '                      SELECT ' + @WeekColumn + ', MAX(YYYYMMDD) AS YYYYMMDD' + Char(10)
    SET @v_dSql += '                      FROM   TH_UIS_CAL A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '                      WHERE  A.YYYYMMDD BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '                      GROUP BY A.' + @WeekColumn + '' + Char(10)
    SET @v_dSql += '                  ) B' + Char(10)
    SET @v_dSql += '                  ON  A.' + @WeekColumn + ' = B.' + @WeekColumn + '' + Char(10)
    SET @v_dSql += '                  WHERE  A.YYYYMMDD BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_bucket_from + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    SET @v_dSql += '             ) E' + Char(10)
    SET @v_dSql += '             ON     A.PLAN_DATE    = E.DT' + Char(10)
    SET @v_dSql += '          ) A' + Char(10)
    SET @v_dSql += '          LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += '               SELECT  NULL AS BATCH_ID' + Char(10)
    SET @v_dSql += '                    , NULL  AS BATCH_ID_2' + Char(10)
    SET @v_dSql += '                    , NULL  AS ACTIVE_MATERIAL_1' + Char(10)
    SET @v_dSql += '                    , NULL  AS ACTIVE_MATERIAL_2' + Char(10)
    SET @v_dSql += '                    , NULL  AS ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '                    , NULL  AS BINDER_1' + Char(10)
    SET @v_dSql += '                    , NULL  AS BINDER_2' + Char(10)
    SET @v_dSql += '                    , NULL  AS BINDER_3' + Char(10)
    SET @v_dSql += '                    , NULL  AS PRE_DISPERSION_ID' + Char(10)
    SET @v_dSql += '                    , NULL  AS PRE_DISPERSION_NAME' + Char(10)
    SET @v_dSql += '                    , NULL  AS CMC' + Char(10)
    SET @v_dSql += '                    , NULL  AS VERSION' + Char(10)
    SET @v_dSql += '                    , NULL  AS PC_MODEL_ID' + Char(10)
    SET @v_dSql += '                    , NULL  AS FOIL' + Char(10)
    SET @v_dSql += '                    , NULL  AS FOIL_CODE' + Char(10)
    SET @v_dSql += '                    , NULL  AS ADDITION_AGENT' + Char(10)
    SET @v_dSql += '          ) E' + Char(10)
    SET @v_dSql += '          ON  1=1' + Char(10)
    SET @v_dSql += '          INNER JOIN (' + Char(10)
    SET @v_dSql += '              SELECT ''I'' AS CATEGORY_ID, ''M(P/C)'' AS CATEGORY_NAME, 998 AS CATEGORY_ORDER'
                   + Char(10)
    SET @v_dSql += '              UNION ALL' + Char(10)
    SET @v_dSql += '              SELECT ''I'' AS CATEGORY_ID, ''Cell'' AS CATEGORY_NAME, 999 AS CATEGORY_ORDER'
                   + Char(10)
    SET @v_dSql += '          ) F' + Char(10)
    SET @v_dSql += '          ON 1=1' + Char(10)
    SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '                 , E.BATCH_ID, E.BATCH_ID_2, E.PRE_DISPERSION_ID, E.PRE_DISPERSION_NAME' + Char(10)
    SET @v_dSql += '                 , E.ACTIVE_MATERIAL_1, E.ACTIVE_MATERIAL_2, E.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '                 , E.BINDER_1, E.BINDER_2, E.BINDER_3' + Char(10)
    SET @v_dSql += '                 , E.CMC' + Char(10)
    SET @v_dSql += '                 , E.VERSION' + Char(10)
    SET @v_dSql += '                 , E.PC_MODEL_ID' + Char(10)
    SET @v_dSql += '                 , E.ADDITION_AGENT' + Char(10)
    SET @v_dSql += '              , E.FOIL_CODE' + Char(10)
    SET @v_dSql += '              , E.FOIL' + Char(10)
    SET @v_dSql += '                 , A.BOH_QTY, A.ITEM_UOM' + Char(10)
    SET @v_dSql += '                 , F.CATEGORY_ORDER, F.CATEGORY_NAME' + Char(10)
    SET @v_dSql += '      )' + Char(10)
    SET @v_dSql += '      , T_MEMO AS (' + Char(10)
    SET @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                , A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                , A.ITEM_ID, A.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '                , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 

    --SET @v_dSql += ' 
    --{ 
    --                    var sql=""; 
    --                    var list = $data.bucket; 
    --                    for(var i = 0; i < list.size(); i++) { 
    --                      sql+="               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' AND A.MEMO IS NOT NULL THEN ''''Y'''' ELSE NULL END) AS D" + i + "_MO \r\n"; 
    --                    } 
    --                  } 
    --' 
	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
--                      sql+="               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' AND A.MEMO IS NOT NULL THEN ''''Y'''' ELSE NULL END) AS D" + i + "_MO \r\n"; 
				SET @v_dsql += '                , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0 + ''' AND A.MEMO IS NOT NULL THEN ''Y'' ELSE NULL END) AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) +'_MO '+char(10) 

                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '           FROM   FP_AMEND_MEMO_M A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '           WHERE  1=1' + Char(10)
    SET @v_dSql += '           AND    A.INSTANCE_ID  =' + Char(10)
    SET @v_dSql += '' + @v_instance_id + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + Char(10)
    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sDiv = $data.DIVISION_LT; 
    --              sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --              sql; 
    --            } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sPlt = $data.PLANT_LT; 
    --              sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --              sql; 
    --            } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sFac = $data.FACTORY_LT; 
    --              sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --              sql; 
    --            } 
    --' 
    --SET @v_dSql += ' ' + @opt_131operation_id + ' ' + '' + Char(10)
    --AND    A.OPERATION_ID   = #OPERATION_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sLine = $data.LINE_LT; 
    --              sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --              sql; 
    --            } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --        var sql=""; 
    --        var sProdType = $data.PRODTYPE_LT; 
    --        if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --          sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --        } 
    --        sql; 
    --      } 
    --' 
    --SET @v_dSql += ' ' + @opt_132top_item_id + ' ' + '' + Char(10)
    --AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_134prod_type + ' ' + '' + Char(10)
    --AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%' 
    SET @v_dSql += '           GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '          , A.OPERATION_ID' + Char(10)
    SET @v_dSql += '          , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '          , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '          , A.ITEM_ID, A.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '          , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '      )' + Char(10)
    SET @v_dSql += '      , T_BCOLOR AS (' + Char(10)
    SET @v_dSql += '         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                   , A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                   , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '                   , A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '                   , A.ITEM_ID, A.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '                   , A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                        var sql=""; 
    --                        var list = $data.bucket; 
    --                        for(var i = 0; i < list.size(); i++) { 
    --                          sql+="               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN B.SETUP_COLOR ELSE NULL END) AS D" + i + "_BCOLOR \r\n"; 
    --                          } 
    --                 } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
    --                          sql+="               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''''" + list[i].VALUE + "'''' THEN B.SETUP_COLOR ELSE NULL END) AS D" + i + "_BCOLOR \r\n"; 
				SET @v_dsql += '               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_0 +'''  THEN B.SETUP_COLOR ELSE NULL END) AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_BCOLOR ' + char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '            FROM   ' + @p_amend_table + ' A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '            LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += '                SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS SETUP_COLOR_CODE, A.SEGMENT3 AS SETUP_COLOR_NAME, A.SEGMENT4 AS SETUP_COLOR, A.SORT_ORDER'
                   + Char(10)
    SET @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''UI_AMEND_COLOR''' + Char(10)
    SET @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''' + Char(10)
    SET @v_dSql += '           ) B' + Char(10)
    SET @v_dSql += '           ON A.INSTANCE_ID = B.INSTANCE_ID' + Char(10)
    SET @v_dSql += '           AND A.SETUP_COLOR_CODE = B.SETUP_COLOR_CODE' + Char(10)
    SET @v_dSql += '            WHERE  A.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += '            AND    A.FP_PLAN_ID  =' + Char(10)
    SET @v_dSql += '' + @v_plan_id + '' + Char(10)
    SET @v_dSql += '            AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN' + Char(10)
    SET @v_dSql += '' + @v_plan_date + '' + Char(10)
    SET @v_dSql += ' AND' + Char(10)
    SET @v_dSql += '' + @v_bucket_to + '' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION_ID', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.LINE_ID', 'EQ', @p_line_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.TOP_ITEM_ID', 'LK', @p_top_item_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
	    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'EQ', @p_prodtype_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PRODUCTION_TYPE', 'LK', @p_prod_type)
    ) + Char(10)

    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sDiv = $data.DIVISION_LT; 
    --              sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --              sql; 
    --            } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sPlt = $data.PLANT_LT; 
    --              sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --              sql; 
    --            } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sFac = $data.FACTORY_LT; 
    --              sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --              sql; 
    --            } 
    --' 
    --SET @v_dSql += ' ' + @opt_131operation_id + ' ' + '' + Char(10)
    --AND    A.OPERATION_ID   = #OPERATION_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --              var sql=""; 
    --              var sLine = $data.LINE_LT; 
    --              sql="AND    A.LINE_ID IN (" + sLine + ")"; 
    --              sql; 
    --            } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --        var sql=""; 
    --        var sProdType = $data.PRODTYPE_LT; 
    --        if($data.PRODTYPE_LT != null && $data.PRODTYPE_LT != ""){ 
    --          sql="AND    A.PRODUCTION_TYPE IN (" + sProdType + ")"; 
    --        } 
    --        sql; 
    --      } 
    --' 
    --SET @v_dSql += ' ' + @opt_132top_item_id + ' ' + '' + Char(10)
    ----AND    A.TOP_ITEM_ID LIKE '%' + #TOP_ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    ----AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    --SET @v_dSql += ' ' + @opt_134prod_type + ' ' + '' + Char(10)
    --AND    A.PRODUCTION_TYPE LIKE '%' + #PROD_TYPE# + '%' 
    SET @v_dSql += '            AND    A.ADJUST_IN_QTY_BATCH > 0' + Char(10)
    SET @v_dSql += '            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '               , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET' + Char(10)
    SET @v_dSql += '      )' + Char(10)
    SET @v_dSql += '      , T_VERSION AS (' + Char(10)
    SET @v_dSql += '      SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                , A.OPERATION AS OPERATION_ID' + Char(10)
    SET @v_dSql += '                , A.MODEL_ID' + Char(10)
    SET @v_dSql += '                , A.ITEM_ID' + Char(10)
    SET @v_dSql += '                , A.PROD_VERSION_TYPE' + Char(10)
    SET @v_dSql += '                , A.VERSION, A.VERSION_TYPE' + Char(10)
    SET @v_dSql += '                , CASE WHEN A.CATEGORY = ''Pancake (m/batch)'' THEN ''M(P/C)''' + Char(10)
    SET @v_dSql += '       WHEN A.CATEGORY = ''Jumbo Roll (m/batch)'' THEN ''J/R''' + Char(10)
    SET @v_dSql += '   WHEN A.CATEGORY = ''cell/batch'' THEN ''Cell''' + Char(10)
    SET @v_dSql += '   ELSE ''BATCH'' END AS CATEGORY' + Char(10)
    SET @v_dSql += '    , MAX(A.VALUE) AS CAL' + Char(10)
    SET @v_dSql += '           FROM    SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '           WHERE   A.MAX_VER_FLAG = ''Y''' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.DIVISION_ID', 'EQ', @p_division_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.SITE_ID', 'EQ', @p_site_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.PLANT_ID', 'EQ', @p_plant_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.FACTORY_ID', 'EQ', @p_factory_lt)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.OPERATION', 'EQ', @p_operation_id)
    ) + Char(10)
    SET @v_dsql +=
    (
        SELECT [DBO].[fn_scm_get_where_sql]('A.ITEM_ID', 'LK', @p_item_id)
    ) + Char(10)
    --SET @v_dSql += ' 
    --{ 
    --            var sql=""; 
    --            var sDiv = $data.DIVISION_LT; 
    --            sql="AND    A.DIVISION_ID IN (" + sDiv + ")"; 
    --            sql; 
    --          } 
    --' 
    --SET @v_dSql += ' ' + @opt_76site_id + ' ' + '' + Char(10)
    --AND    A.SITE_ID   = #SITE_ID# 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --            var sql=""; 
    --            var sPlt = $data.PLANT_LT; 
    --            sql="AND    A.PLANT_ID IN (" + sPlt + ")"; 
    --            sql; 
    --          } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --            var sql=""; 
    --            var sFac = $data.FACTORY_LT; 
    --            sql="AND    A.FACTORY_ID IN (" + sFac + ")"; 
    --            sql; 
    --          } 
    --' 
    --SET @v_dSql += ' AND    A.OPERATION =' + Char(10)
    --SET @v_dSql += '' + @v_operation_id + '' + Char(10)
    --SET @v_dSql += ' ' + @opt_77item_id + ' ' + '' + Char(10)
    --AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%' 
    SET @v_dSql += ' AND A.CATEGORY IN (''cell/batch'', ''Jumbo Roll (m/batch)'', ''Pancake (m/batch)'')' + Char(10)
    SET @v_dSql += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
    SET @v_dSql += '                   , A.OPERATION' + Char(10)
    SET @v_dSql += '                   , A.MODEL_ID' + Char(10)
    SET @v_dSql += '                   , A.ITEM_ID' + Char(10)
    SET @v_dSql += '                   , A.PROD_VERSION_TYPE' + Char(10)
    SET @v_dSql += '                   , A.VERSION, A.VERSION_TYPE' + Char(10)
    SET @v_dSql += '                   , A.CATEGORY' + Char(10)
    SET @v_dSql += '     )' + Char(10)
    SET @v_dSql += '      SELECT A.*' + Char(10)
    SET @v_dSql += '       , CASE WHEN A.DATA_TYPE = ''DATA'' THEN ROUND( ISNULL(G.CAL, ISNULL(dbo.FN_GET_CONVERT_CAL(A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID,  ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL), A.ITEM_ID, CASE WHEN A.FACTORY_ID NOT IN (''E2'', ''E3'', ''E5'',''E6'', ''EB'', ''EC'', ''ED'') THEN ''-'' ELSE A.VERSION END, ''-'', ISNULL(C.PROD_VERSION_TYPE,''GENERAL''), A.CATEGORY_NAME )'
                   + Char(10)
    SET @v_dSql += '                              , dbo.FN_GET_CONVERT_CAL(A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID,  B.APPLIED_MODEL, A.ITEM_ID, CASE WHEN A.FACTORY_ID NOT IN (''E2'', ''E3'', ''E5'',''E6'', ''EB'', ''EC'', ''ED'') THEN ''-'' ELSE A.VERSION END, ''-'', ISNULL(C.PROD_VERSION_TYPE,''GENERAL''), A.CATEGORY_NAME ) )) , 0)'
                   + Char(10)
    SET @v_dSql += '          ELSE NULL END AS CONVERSION' + Char(10)
    SET @v_dSql += '           , B.APPLIED_MODEL' + Char(10)
    --SET @v_dSql += '           , CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(A.PC_MODEL_ID,''N/A'') END AS WORK_MODEL' + Char(10)
	SET @v_dsql += '           , A.PC_MODEL_ID AS WORK_MODEL ' + Char(10)
    SET @v_dSql += '           , DENSE_RANK() OVER(ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID) AS LV1' + Char(10)
    SET @v_dSql += '           , ISNULL(C.PROD_VERSION_TYPE, ''GENERAL'') AS PROD_VERSION_TYPE' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --            var sql=""; 
    --            var list = $data.bucket; 
    --            for(var i = 0; i < list.size(); i++) { 
    --              sql+="  , D.D" + i + "_MO \r\n"; 
    --            } 
    --          } 
    --' 
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --            var sql=""; 
    --            var list = $data.bucket; 
    --            for(var i = 0; i < list.size(); i++) { 
    --              sql+="  , D.D" + i + "_MO \r\n"; 

    --              sql+="      , CASE WHEN A.DATA_TYPE=''''TOTAL_2'''' THEN ''''#FFBA85'''' \r\n"; 
    --              sql+="             WHEN A.DATA_TYPE=''''TOTAL'''' THEN ''''#FFE5C2'''' \r\n"; 
    --              sql+="             WHEN A.PSI=''''I'''' THEN ''''#EDF2FEFF'''' \r\n"; 
    --              sql+="             WHEN A.CATEGORY_ID=''''P_IN_BATCH'''' THEN (CASE WHEN E.D" + i + "_BCOLOR IS NOT NULL THEN E.D" + i + "_BCOLOR   \r\n"; 
    --              sql+="                                   ELSE ( CASE WHEN A.DATA_TYPE = ''''DATA'''' AND H.PRODUCTION_TYPE IS NOT NULL AND R.FACTORY_ID IS NOT NULL THEN ''''#FFFF0055'''' ELSE '''''''' END ) END ) \r\n"; 
    --              sql+="             ELSE '''''''' END AS D" + i + "_BCOLOR \r\n"; 
    --            } 
    --          } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            


            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

--              sql+="  , D.D" + i + "_MO \r\n"; 
				SET @v_dsql += '  , D.D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_MO ' +char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

			            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

    --              sql+="      , CASE WHEN A.DATA_TYPE=''''TOTAL_2'''' THEN ''''#FFBA85'''' \r\n"; 
    --              sql+="             WHEN A.DATA_TYPE=''''TOTAL'''' THEN ''''#FFE5C2'''' \r\n"; 
    --              sql+="             WHEN A.PSI=''''I'''' THEN ''''#EDF2FEFF'''' \r\n"; 
    --              sql+="             WHEN A.CATEGORY_ID=''''P_IN_BATCH'''' THEN (CASE WHEN E.D" + i + "_BCOLOR IS NOT NULL THEN E.D" + i + "_BCOLOR   \r\n"; 
    --              sql+="                                   ELSE ( CASE WHEN A.DATA_TYPE = ''''DATA'''' AND H.PRODUCTION_TYPE IS NOT NULL AND R.FACTORY_ID IS NOT NULL THEN ''''#FFFF0055'''' ELSE '''''''' END ) END ) \r\n"; 
    --              sql+="             ELSE '''''''' END AS D" + i + "_BCOLOR \r\n"; 

				SET @v_dsql += '      , CASE WHEN A.DATA_TYPE=''TOTAL_2'' THEN ''#FFBA85'' ' +char(10)
				SET @v_dsql += '             WHEN A.DATA_TYPE=''TOTAL'' THEN ''#FFE5C2'' ' +char(10) 
				SET @v_dsql += '             WHEN A.PSI=''I'' THEN ''#EDF2FEFF'' ' +char(10) 
				SET @v_dsql += '             WHEN A.CATEGORY_ID=''P_IN_BATCH'' THEN (CASE WHEN E.D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_BCOLOR IS NOT NULL THEN E.D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_BCOLOR  ' +char(10)
				SET @v_dsql += '                                   ELSE ( CASE WHEN A.DATA_TYPE = ''DATA'' AND H.PRODUCTION_TYPE IS NOT NULL AND R.FACTORY_ID IS NOT NULL THEN ''#FFFF0055'' ELSE '''' END ) END ) ' +char(10) 
				SET @v_dsql += '             ELSE '''' END AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_BCOLOR ' +char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    


        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '         , CASE WHEN A.DATA_TYPE = ''DATA'' AND H.PRODUCTION_TYPE IS NOT NULL AND R.FACTORY_ID IS NOT NULL THEN ''Y'' ELSE ''N'' END AS EDIT_YN'
                   + Char(10)
    
	
	SET @v_dSql += ' , ISNULL(WW.NICK_NAME,''-'') AS WORK_MODEL_NAME  ' + char(10) 
	SET @v_dSql += ' , WZ.SCP_EXTRA_SPEC  ' + char(10) 
	SET @v_dSql += ' , (CASE WHEN GG.VERSION IS NULL THEN ''N'' ELSE ''Y'' END) AS MAX_VER_FLAG ' + char(10) -- max version flag 추가... 20230905

	SET @v_dSql += '      FROM (' + Char(10)
    SET @v_dSql += '          SELECT * FROM #MAIN_P' + Char(10) --Tuning_block_04
    SET @v_dSql += '          UNION ALL' + Char(10)
    SET @v_dSql += '          SELECT * FROM MAIN_S' + Char(10)
    SET @v_dSql += '          UNION ALL' + Char(10)
    SET @v_dSql += '          SELECT * FROM MAIN_I' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
	IF @bInventory = 0 BEGIN
		SET @v_dSql += 'WHERE 1=0 '
	END
    --{ 
    --            var sql = "" 
    --            if( bInventory != "Y" ) { 
    --              sql = "WHERE 1=0 " 
    --            } 
    --          } 
    --' 
    SET @v_dSql += '          -- SUB TOTAL P' + Char(10)
    SET @v_dSql += '          UNION ALL' + Char(10)
    SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '               , NULL AS LOCATION, A.OPERATION_ID, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'
                   + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS PRODUCTION_TYPE, NULL AS MARKET' + Char(10)
    SET @v_dSql += '               , A.BATCH_ID, A.BATCH_ID_2, A.PRE_DISPERSION_ID, A.PRE_DISPERSION_NAME, A.PRE_DISPERSION_ID_2, A.PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '               , A.ACTIVE_MATERIAL_1, A.ACTIVE_MATERIAL_2, A.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '               , A.BINDER_1, A.BINDER_2, A.BINDER_3' + Char(10)
    SET @v_dSql += '               , A.CMC, A.VERSION, A.PC_MODEL_ID, A.ADDITION_AGENT, A.FOIL_CODE, A.FOIL' + Char(10)
    SET @v_dSql += '               , A.DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR' + Char(10)
    SET @v_dSql += '               , NULL AS DC_BATCH, NULL AS DC_FLAG' + Char(10)
    SET @v_dSql += '               , A.BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                var sql=""; 
    --                var list = $data.bucket; 
    --                var weekInfo  = $data.WEEK_INFO; 
    --                var monthInfo = $data.MONTH_INFO; 
    -- 
    --                if(list.size() > 0) { 
    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + "_TOT) AS W" + i + "_TOT\r\n"; 
    --                  } 
    --                } 
    --              } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

			-- MONTH 
            -- 프로시저 LOOP 길이를 판단  
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
				SET @v_dsql += '             , SUM(M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+ char(10) 
		    --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        

    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
				SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+ char(10) 
                --SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
				SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+ char(10) 


                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
    --                    sql+="             , SUM(W" + i + "_TOT) AS W" + i + "_TOT\r\n"; 
				SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT) AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT'+ char(10) 

                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    
        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS ITEM_UOM' + Char(10)
    SET @v_dSql += '               , ''P'' AS PSI' + Char(10)
    SET @v_dSql += '               , ''TOTAL'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS CALC_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS PROD_SEQ, NULL AS WORK_REQUEST_MODEL_ID,NULL AS PLM_EC_NO' + Char(10)
    
	
	SET @v_dSql += '          FROM   #MAIN_P A' + Char(10) --Tuning_block_05
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	IF @bsubtotal = 0 BEGIN
		SET @v_dSql += 'WHERE 1=0 '
	END
    --SET @v_dSql += ' 
    --{ 
    --            var sql = "" 
    --            if( bSubTotal != "Y" ) { 
    --              sql = "WHERE 1=0 " 
    --            } 
    --          } 
    --' 
    SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '                 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '                 , A.BATCH_ID, A.BATCH_ID_2, A.PRE_DISPERSION_ID, A.PRE_DISPERSION_NAME, A.PRE_DISPERSION_ID_2, A.PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '                 , A.ACTIVE_MATERIAL_1, A.ACTIVE_MATERIAL_2, A.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '                 , A.BINDER_1, A.BINDER_2, A.BINDER_3' + Char(10)
    SET @v_dSql += '                 , A.CMC, A.VERSION, A.PC_MODEL_ID, A.ADDITION_AGENT, A.FOIL_CODE, A.FOIL'
                   + Char(10)
    SET @v_dSql += '                 , A.DC_PPM/*, A.DC_M, A.DC_CELL, A.DC_KG, A.DC_JR' + Char(10)
    SET @v_dSql += '                 , A.DC_BATCH, A.DC_FLAG*/' + Char(10)
    SET @v_dSql += '                 , A.BOH_QTY' + Char(10)
    SET @v_dSql += '                 , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '                 , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '          -- SUB TOTAL S' + Char(10)
    SET @v_dSql += '          UNION ALL' + Char(10)
    SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '               , NULL AS LOCATION, A.OPERATION_ID, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'
                   + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS PRODUCTION_TYPE, NULL AS MARKET' + Char(10)
    SET @v_dSql += '               , A.BATCH_ID, A.BATCH_ID_2, A.PRE_DISPERSION_ID, A.PRE_DISPERSION_NAME, A.PRE_DISPERSION_ID_2, A.PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '               , A.ACTIVE_MATERIAL_1, A.ACTIVE_MATERIAL_2, A.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '               , A.BINDER_1, A.BINDER_2, A.BINDER_3' + Char(10)
    SET @v_dSql += '               , A.CMC, A.VERSION, A.PC_MODEL_ID, A.ADDITION_AGENT, A.FOIL_CODE, A.FOIL' + Char(10)
    SET @v_dSql += '               , A.DC_PPM, A.DC_M, A.DC_CELL, A.DC_KG, A.DC_JR' + Char(10)
    SET @v_dSql += '               , A.DC_BATCH, A.DC_FLAG' + Char(10)
    SET @v_dSql += '               , A.BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                var sql=""; 
    --                var list = $data.bucket; 
    --                var weekInfo  = $data.WEEK_INFO; 
    --                var monthInfo = $data.MONTH_INFO; 
    -- 
    --                if(list.size() > 0) { 
    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , NULL AS W" + i + "_TOT\r\n"; 
    --                  } 
    --                } 
    --              } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

			-- MONTH 
            -- 프로시저 LOOP 길이를 판단  
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    


    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
				SET @v_dsql += '             , SUM(M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) ++ ''+ char(10) 
		    --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        

    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
				SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) +  ''+ char(10) 
                --SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    

    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
				SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) ++ ') AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) +  ''+ char(10) 


                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        

    --                    sql+="             , NULL AS W" + i + "_TOT\r\n"; 
				SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT'+ ''+ char(10) 

                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    


        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '               , A.ITEM_UOM' + Char(10)
    SET @v_dSql += '               , ''S'' AS PSI' + Char(10)
    SET @v_dSql += '               , ''TOTAL'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS CALC_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS PROD_SEQ, NULL AS WORK_REQUEST_MODEL_ID,NULL AS PLM_EC_NO' + Char(10)
    SET @v_dSql += '          FROM   MAIN_S A' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
	IF @bsubtotal= 0 BEGIN
		SET @v_dSql += 'WHERE 1=0'
	END
    --SET @v_dSql += ' 
    --{ 
    --            var sql = "" 
    --            if( bSubTotal != "Y" ) { 
    --              sql = "WHERE 1=0 " 
    --            } 
    --          } 
    --' 
    SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '               , A.BATCH_ID, A.BATCH_ID_2, A.PRE_DISPERSION_ID, A.PRE_DISPERSION_NAME, A.PRE_DISPERSION_ID_2, A.PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '               , A.ACTIVE_MATERIAL_1, A.ACTIVE_MATERIAL_2, A.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '               , A.BINDER_1, A.BINDER_2, A.BINDER_3' + Char(10)
    SET @v_dSql += '               , A.CMC, A.VERSION, A.PC_MODEL_ID, A.ADDITION_AGENT, A.FOIL_CODE, A.FOIL' + Char(10)
    SET @v_dSql += '               , A.DC_PPM, A.DC_M, A.DC_CELL, A.DC_KG, A.DC_JR' + Char(10)
    SET @v_dSql += '               , A.DC_BATCH, A.DC_FLAG' + Char(10)
    SET @v_dSql += '               , A.BOH_QTY' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '               , A.ITEM_UOM' + Char(10)
    SET @v_dSql += '          -- SUB TOTAL I' + Char(10)
    SET @v_dSql += '          UNION ALL' + Char(10)
    SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, NULL AS FACTORY_ID' + Char(10)
    SET @v_dSql += '               , NULL AS LOCATION, A.OPERATION_ID, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'
                   + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS PRODUCTION_TYPE, NULL AS MARKET' + Char(10)
    SET @v_dSql += '               , A.BATCH_ID, A.BATCH_ID_2, A.PRE_DISPERSION_ID, A.PRE_DISPERSION_NAME, A.PRE_DISPERSION_ID_2, A.PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '               , A.ACTIVE_MATERIAL_1, A.ACTIVE_MATERIAL_2, A.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '               , A.BINDER_1, A.BINDER_2, A.BINDER_3' + Char(10)
    SET @v_dSql += '               , A.CMC, A.VERSION, A.PC_MODEL_ID, A.ADDITION_AGENT, A.FOIL_CODE, A.FOIL' + Char(10)
    SET @v_dSql += '               , A.DC_PPM, A.DC_M, A.DC_CELL, A.DC_KG, A.DC_JR' + Char(10)
    SET @v_dSql += '               , A.DC_BATCH, A.DC_FLAG' + Char(10)
    SET @v_dSql += '               , A.BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                var sql=""; 
    --                var list = $data.bucket; 
    --                var weekInfo  = $data.WEEK_INFO; 
    --                var monthInfo = $data.MONTH_INFO; 
    -- 
    --                if(list.size() > 0) { 
    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                    sql+="               , SUM(ISNULL(A.M" + i + ",0)) AS M" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="               , SUM(ISNULL(A.W" + i + ",0)) AS W" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                    sql+="               , SUM(ISNULL(A.D" + i + ",0)) AS D" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="               , NULL AS W" + i + "_TOT\r\n"; 
    --                  } 
    --                } 
    --              } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

			-- MONTH 
            -- 프로시저 LOOP 길이를 판단  
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

    --                    sql+="               , SUM(ISNULL(A.M" + i + ",0)) AS M" + i + "\r\n"; 
				SET @v_dsql += '               , SUM(ISNULL(A.M' + try_convert(nvarchar, @mst_loop_cnt - 1) +',0)) AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+char(10) 
		    --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
				
    --                    sql+="               , SUM(ISNULL(A.W" + i + ",0)) AS W" + i + "\r\n"; 
				SET @v_dsql += '               , SUM(ISNULL(A.W' + try_convert(nvarchar, @mst_loop_cnt - 1) +',0)) AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+char(10)  
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    


    --                    sql+="               , SUM(ISNULL(A.D" + i + ",0)) AS D" + i + "\r\n"; 
				SET @v_dsql += '              , SUM(ISNULL(A.D' + try_convert(nvarchar, @mst_loop_cnt - 1) +',0)) AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) +''+char(10) 
                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
				--  sql+="                ,  NULL AS W" + i + "_TOT\r\n"; 

    --                    sql+="               , NULL AS W" + i + "_TOT\r\n"; 
				SET @v_dsql += '               , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) +'_TOT'+char(10) 

                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    


        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '               , A.ITEM_UOM' + Char(10)
    SET @v_dSql += '               , ''I'' AS PSI' + Char(10)
    SET @v_dSql += '               , ''TOTAL'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS CALC_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS PROD_SEQ, NULL AS WORK_REQUEST_MODEL_ID,NULL AS PLM_EC_NO' + Char(10)
   
    SET @v_dSql += '          FROM   MAIN_I A' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
	IF @bsubtotal = 0 begin
		SET @v_dSql += 'WHERE 1=0'
	END
    --{ 
    --            var sql = "" 
    --            if( bSubTotal != "Y" ) { 
    --              sql = "WHERE 1=0 " 
    --            } 
    --          } 
    --' 
    SET @v_dSql += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
    SET @v_dSql += '               , A.BATCH_ID, A.BATCH_ID_2, A.PRE_DISPERSION_ID, A.PRE_DISPERSION_NAME, A.PRE_DISPERSION_ID_2, A.PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '               , A.ACTIVE_MATERIAL_1, A.ACTIVE_MATERIAL_2, A.ACTIVE_MATERIAL_3' + Char(10)
    SET @v_dSql += '               , A.BINDER_1, A.BINDER_2, A.BINDER_3' + Char(10)
    SET @v_dSql += '               , A.CMC, A.VERSION, A.PC_MODEL_ID, A.ADDITION_AGENT, A.FOIL_CODE, A.FOIL' + Char(10)
    SET @v_dSql += '               , A.DC_PPM, A.DC_M, A.DC_CELL, A.DC_KG, A.DC_JR' + Char(10)
    SET @v_dSql += '               , A.DC_BATCH, A.DC_FLAG' + Char(10)
    SET @v_dSql += '               , A.BOH_QTY' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '               , A.ITEM_UOM' + Char(10)
    SET @v_dSql += '          -- TOTAL P' + Char(10)
    SET @v_dSql += '          UNION ALL' + Char(10)
    SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '               , NULL AS LOCATION, NULL AS OPERATION_ID, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'
                   + Char(10)
    SET @v_dSql += '               , ''Total'' AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS PRODUCTION_TYPE, NULL AS MARKET' + Char(10)
    SET @v_dSql += '               , NULL AS BATCH_ID, NULL AS BATCH_ID_2, NULL AS PRE_DISPERSION_ID, NULL AS PRE_DISPERSION_NAME, NULL AS PRE_DISPERSION_ID_2, NULL AS PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '               , NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'
                   + Char(10)
    SET @v_dSql += '               , NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + Char(10)
    SET @v_dSql += '               , NULL AS CMC, NULL AS VERSION, NULL AS PC_MODEL_ID, NULL AS ADDITION_AGENT, NULL AS FOIL_CODE, NULL AS FOIL'
                   + Char(10)
    SET @v_dSql += '               , NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR'
                   + Char(10)
    SET @v_dSql += '               , NULL AS DC_BATCH, NULL AS DC_FLAG' + Char(10)
    SET @v_dSql += '               , SUM(A.BOH_QTY) AS BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                var sql=""; 
    --                var list = $data.bucket; 
    --                var weekInfo  = $data.WEEK_INFO; 
    --                var monthInfo = $data.MONTH_INFO; 
    -- 
    --                if(list.size() > 0) { 
    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + "_TOT) AS W" + i + "_TOT\r\n"; 
    --                  } 
    --                } 
    --              } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

			-- MONTH 
            -- 프로시저 LOOP 길이를 판단  
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + "_TOT) AS W" + i + "_TOT\r\n"; 

    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
				SET @v_dsql += '             , SUM(M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ''+ char(10) 
		    --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        

   
				SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ''+ char(10) 
    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 

				--SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    


    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n";
				SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ''+ char(10) 
	


                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        

    --                    sql+="             , SUM(W" + i + "_TOT) AS W" + i + "_TOT\r\n"; 
				SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT) AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT'+ char(10) 

                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    


        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS ITEM_UOM' + Char(10)
    SET @v_dSql += '               , ''P'' AS PSI' + Char(10)
    SET @v_dSql += '               , ''TOTAL_2'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS CALC_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS PROD_SEQ, NULL AS WORK_REQUEST_MODEL_ID,NULL AS PLM_EC_NO' + Char(10)
    SET @v_dSql += '          FROM   #MAIN_P A' + Char(10) --Tuning_block_06
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
	IF @bTotal = 0 BEGIN
		SET @v_dSql += 'WHERE 1=0 '
	END
    --{ 
    --            var sql = "" 
    --            if( bTotal != "Y" ) { 
    --              sql = "WHERE 1=0 " 
    --            } 
    --          } 
    --' 
    SET @v_dSql += '          GROUP BY A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '                 , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '          -- TOTAL S' + Char(10)
    SET @v_dSql += '          UNION ALL' + Char(10)
    SET @v_dSql += '          SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID'
                   + Char(10)
    SET @v_dSql += '               , NULL AS LOCATION, NULL AS OPERATION_ID, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, NULL AS EQUIPMENT_ID'
                   + Char(10)
    SET @v_dSql += '               , ''Total'' AS ITEM_ID, NULL AS TOP_ITEM_ID, NULL AS NICK_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS PRODUCTION_TYPE, NULL AS MARKET' + Char(10)
    SET @v_dSql += '               , NULL AS BATCH_ID, NULL AS BATCH_ID_2, NULL AS PRE_DISPERSION_ID, NULL AS PRE_DISPERSION_NAME, NULL AS PRE_DISPERSION_ID_2, NULL AS PRE_DISPERSION_NAME_2'
                   + Char(10)
    SET @v_dSql += '               , NULL AS ACTIVE_MATERIAL_1, NULL AS ACTIVE_MATERIAL_2, NULL AS ACTIVE_MATERIAL_3'
                   + Char(10)
    SET @v_dSql += '               , NULL AS BINDER_1, NULL AS BINDER_2, NULL AS BINDER_3' + Char(10)
    SET @v_dSql += '               , NULL AS CMC, NULL AS VERSION, NULL AS PC_MODEL_ID, NULL AS ADDITION_AGENT, NULL AS FOIL_CODE, NULL AS FOIL'
                   + Char(10)
    SET @v_dSql += '               , NULL AS DC_PPM, NULL AS DC_M, NULL AS DC_CELL, NULL AS DC_KG, NULL AS DC_JR'
                   + Char(10)
    SET @v_dSql += '               , NULL AS DC_BATCH, NULL AS DC_FLAG' + Char(10)
    SET @v_dSql += '               , SUM(A.BOH_QTY) AS BOH_QTY' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
    --{ 
    --                var sql=""; 
    --                var list = $data.bucket; 
    --                var weekInfo  = $data.WEEK_INFO; 
    --                var monthInfo = $data.MONTH_INFO; 
    -- 
    --                if(list.size() > 0) { 
    --                  for(var i = 0; i < monthInfo.size(); i++) { 
    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < list.size(); i++) { 
    --                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
    --                  } 
    -- 
    --                  for(var i = 0; i < weekInfo.size(); i++) { 
    --                    sql+="             , NULL AS W" + i + "_TOT\r\n"; 
    --                  } 
    --                } 
    --              } 
    --' 

	IF isnull(@p_day_info, '') <> ''
    BEGIN
        SET @mst_loop_cnt = 0
        SET @v_delimiter = '!' -- 데이터 구분자    
        SET @sub_v_delimiter = '#'
        SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)


        IF @max_loop_cnt > 0
        BEGIN            

			-- MONTH 
            -- 프로시저 LOOP 길이를 판단  
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_month_info, @v_delimiter)
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_month_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END --MONTH    
                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END --MONTH_NAME    
                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END --MONTH_COUNT    
                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END --M_VALUE    
                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    

    --                    sql+="             , SUM(M" + i + ") AS M" + i + "\r\n"; 
    SET @v_dsql += '             , SUM(M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS M' + try_convert(nvarchar, @mst_loop_cnt - 1) + ''+ char(10) 
		    --SET @mst_loop_cnt =  @mst_loop_cnt + 1    
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
    --                    sql+="             , SUM(W" + i + ") AS W" + i + "\r\n"; 
    SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ''+ char(10) 
                --SET @v_dsql += '             , SUM(W' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS W'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- DAY(BUCKET)    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_day_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_day_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                --IF @sub_max_loop_cnt > 4 BEGIN   SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   END    
                -- @sub_param_0 => MONth    
                -- @sub_param_0 => MONTH_NAME    
                -- @sub_param_0 => MONTH_COUNT    
                -- @sub_param_0 => M_VALUE    
                --SET @v_dSql += @tmp_column + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @sub_param_3 + '+++++++ffgs+++++++++++++++++' +char(10)    
                --SET @v_dSql += @p_plan_date + '++++++++++++++++++++++++' +char(10)    
    
	--                    sql+="             , SUM(D" + i + ") AS D" + i + "\r\n"; 
    SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ''+ char(10) 
   

                --SET @v_dsql += '             , SUM(D' + try_convert(nvarchar, @mst_loop_cnt - 1) + ') AS D'
                --               + try_convert(nvarchar, @mst_loop_cnt - 1) + Char(10)
                --SET @v_dsql += '             , NULL AS D' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_CR '
                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    

            -- WEEK    
            SET @mst_loop_cnt = 0
            SET @max_loop_cnt = 0
            SET @max_loop_cnt = [dbo].[scm_arr_spl_cnt](@p_week_info, @v_delimiter)
            -- 프로시저 LOOP 길이를 판단    
            WHILE @mst_loop_cnt < @max_loop_cnt
            BEGIN
                SET @mst_loop_cnt = @mst_loop_cnt + 1
                SET @tmp_column = ''
                SET @tmp_column = [dbo].[scm_arr_spl_val](@p_week_info, @v_delimiter, @mst_loop_cnt)
                SET @sub_max_loop_cnt = [dbo].[scm_arr_spl_cnt](@tmp_column, @sub_v_delimiter)

                IF @sub_max_loop_cnt > 0
                BEGIN
                    SET @sub_param_0 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 1)
                END

                IF @sub_max_loop_cnt > 1
                BEGIN
                    SET @sub_param_1 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 2)
                END

                IF @sub_max_loop_cnt > 2
                BEGIN
                    SET @sub_param_2 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 3)
                END

                IF @sub_max_loop_cnt > 3
                BEGIN
                    SET @sub_param_3 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 4)
                END

                IF @sub_max_loop_cnt > 4
                BEGIN
                    SET @sub_param_4 = [dbo].[scm_arr_spl_val_entity](@tmp_column, @sub_v_delimiter, 5)
                END

                -- @sub_param_0 => WEEK    
                -- @sub_param_0 => WEEK_NAME    
                -- @sub_param_0 => WEEK_COUNT    
                -- @sub_param_0 => W_VALUE    
                -- @sub_param_0 => IS_DAY_VIEW        
    SET @v_dsql += '             , NULL AS W' + try_convert(nvarchar, @mst_loop_cnt - 1) + '_TOT' + ''+ char(10) 
    --                    sql+="             , NULL AS W" + i + "_TOT\r\n"; 

                --               + Char(10)
            END -- end of @mst_loop_cnt < @max_loop_cnt    


        END --end of @max_loop_cnt    
    END

    SET @v_dSql += '               , A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '               , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '               , NULL AS ITEM_UOM' + Char(10)
    SET @v_dSql += '               , ''S'' AS PSI' + Char(10)
    SET @v_dSql += '               , ''TOTAL_2'' AS DATA_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS CALC_TYPE' + Char(10)
    SET @v_dSql += '               , NULL AS PROD_SEQ, NULL AS WORK_REQUEST_MODEL_ID,NULL AS PLM_EC_NO' + Char(10)
    SET @v_dSql += '          FROM   MAIN_S A' + Char(10)
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY---- 
    --SET @v_dSql += ' 
	IF @bTotal = 0 BEGIN
		SET @v_dSql += 'WHERE 1=0 '
	END
    --{ 
    --            var sql = "" 
    --            if( bTotal != "Y" ) { 
    --              sql = "WHERE 1=0 " 
    --            } 
    --          } 
    --' 
    SET @v_dSql += '          GROUP BY A.CATEGORY_ID, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '                 , A.CATEGORY_NAME, A.LV1_NAME' + Char(10)
    SET @v_dSql += '          -- TOTAL I' + Char(10)
    SET @v_dSql += '      ) A' + Char(10)
    SET @v_dSql += '      LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '      ON  A.COMPANY_ID      = B.COMPANY_ID' + Char(10)
    SET @v_dSql += '      AND A.DIVISION_ID     = B.DIVISION_ID' + Char(10)
    SET @v_dSql += '      AND A.SITE_ID         = B.SITE_ID' + Char(10)
    SET @v_dSql += '      AND A.ITEM_ID         = B.ITEM_ID' + Char(10)
    SET @v_dSql += '      LEFT OUTER JOIN SCM_LINE_M C WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '      ON  A.COMPANY_ID      = C.COMPANY_ID' + Char(10)
    SET @v_dSql += '      AND A.DIVISION_ID     = C.DIVISION_ID' + Char(10)
    SET @v_dSql += '      AND A.SITE_ID         = C.SITE_ID' + Char(10)
    SET @v_dSql += '      AND A.PLANT_ID        = C.PLANT_ID' + Char(10)
    SET @v_dSql += '      AND A.FACTORY_ID      = C.FACTORY_ID' + Char(10)
    SET @v_dSql += '      AND A.OPERATION_ID    = C.OPERATION_ID' + Char(10)
    SET @v_dSql += '      AND A.LINE_ID         = C.LINE_ID' + Char(10)
    SET @v_dSql += '      AND A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '      LEFT OUTER JOIN T_MEMO D WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '      ON  A.COMPANY_ID      = D.COMPANY_ID' + Char(10)
    SET @v_dSql += '      AND A.DIVISION_ID     = D.DIVISION_ID' + Char(10)
    SET @v_dSql += '      AND A.SITE_ID         = D.SITE_ID' + Char(10)
    SET @v_dSql += '      AND A.PLANT_ID        = D.PLANT_ID' + Char(10)
    SET @v_dSql += '      AND A.FACTORY_ID      = D.FACTORY_ID' + Char(10)
    SET @v_dSql += '      AND A.OPERATION_ID    = D.OPERATION_ID' + Char(10)
    SET @v_dSql += '      AND A.LINE_ID         = D.LINE_ID' + Char(10)
    SET @v_dSql += '      AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '      AND A.EQUIPMENT_ID    = D.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '      AND A.PRODUCTION_TYPE = D.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '      AND A.MARKET          = D.MARKET' + Char(10)
    SET @v_dSql += '      AND A.TOP_ITEM_ID     = D.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '      AND A.ITEM_ID         = D.ITEM_ID' + Char(10)
    SET @v_dSql += '      LEFT OUTER JOIN T_BCOLOR E WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '      ON  A.COMPANY_ID      = E.COMPANY_ID' + Char(10)
    SET @v_dSql += '      AND A.DIVISION_ID     = E.DIVISION_ID' + Char(10)
    SET @v_dSql += '      AND A.SITE_ID         = E.SITE_ID' + Char(10)
    SET @v_dSql += '      AND A.PLANT_ID        = E.PLANT_ID' + Char(10)
    SET @v_dSql += '      AND A.FACTORY_ID      = E.FACTORY_ID' + Char(10)
    SET @v_dSql += '      AND A.OPERATION_ID    = E.OPERATION_ID' + Char(10)
    SET @v_dSql += '      AND A.LINE_ID         = E.LINE_ID' + Char(10)
    SET @v_dSql += '      AND A.ELECTRODE_TYPE  = E.ELECTRODE_TYPE' + Char(10)
    SET @v_dSql += '      AND A.EQUIPMENT_ID    = E.EQUIPMENT_ID' + Char(10)
    SET @v_dSql += '      AND A.PRODUCTION_TYPE = E.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '      AND A.MARKET          = E.MARKET' + Char(10)
    SET @v_dSql += '      AND A.TOP_ITEM_ID     = E.TOP_ITEM_ID' + Char(10)
    SET @v_dSql += '      AND A.ITEM_ID         = E.ITEM_ID' + Char(10)
    SET @v_dSql += '      LEFT OUTER JOIN T_VERSION G WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '      ON     A.COMPANY_ID     = G.COMPANY_ID' + Char(10)
    SET @v_dSql += '      AND    A.DIVISION_ID    = G.DIVISION_ID' + Char(10)
    SET @v_dSql += '      AND    A.SITE_ID        = G.SITE_ID' + Char(10)
    SET @v_dSql += '      AND    A.PLANT_ID       = G.PLANT_ID' + Char(10)
    SET @v_dSql += '      AND    A.FACTORY_ID     = G.FACTORY_ID' + Char(10)
    SET @v_dSql += '      AND    A.OPERATION_ID   = G.OPERATION_ID' + Char(10)
    SET @v_dSql += '      AND    ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL)  = G.MODEL_ID' + Char(10)
    SET @v_dSql += '      AND    A.ITEM_ID        = G.ITEM_ID' + Char(10)
    SET @v_dSql += '      AND    C.PROD_VERSION_TYPE = G.PROD_VERSION_TYPE' + Char(10)
    SET @v_dSql += '      --AND    (CASE WHEN PATINDEX(''%TEST'', A.PRODUCTION_TYPE) > 0 THEN ''TEST'' ELSE ''MASS'' END) = G.VERSION_TYPE' + Char(10)
    SET @v_dSql += '      AND    A.CALC_TYPE      = G.VERSION_TYPE' + Char(10)
    SET @v_dSql += '      AND    A.VERSION        = G.VERSION' + Char(10)
    SET @v_dSql += '      AND    A.CATEGORY_NAME  = G.CATEGORY' + Char(10)
    SET @v_dsql += '      LEFT OUTER JOIN ' + Char(10) -- max version flag 추가... 20230905
    SET @v_dsql += '      ( ' + Char(10)
    SET @v_dsql += '      	SELECT GG.COMPANY_ID, GG.DIVISION_ID, GG.SITE_ID, GG.PLANT_ID, GG.FACTORY_ID ' + Char(10)
    SET @v_dsql += '               , GG.OPERATION_ID, GG.MODEL_ID, GG.ITEM_ID ' + Char(10)
    SET @v_dsql += '               , GG.PROD_VERSION_TYPE, GG.VERSION, GG.VERSION_TYPE ' + Char(10)
    SET @v_dsql += '      	FROM   T_VERSION GG WITH(NOLOCK) ' + Char(10)
    SET @v_dsql += '      	GROUP BY GG.COMPANY_ID, GG.DIVISION_ID, GG.SITE_ID, GG.PLANT_ID, GG.FACTORY_ID ' + Char(10)
    SET @v_dsql += '                 , GG.OPERATION_ID, GG.MODEL_ID, GG.ITEM_ID ' + Char(10)
    SET @v_dsql += '                 , GG.PROD_VERSION_TYPE, GG.VERSION, GG.VERSION_TYPE ' + Char(10)
    SET @v_dsql += '      ) GG ' + Char(10)
    SET @v_dsql += '      ON  A.COMPANY_ID        = GG.COMPANY_ID ' + Char(10)
    SET @v_dsql += '      AND A.DIVISION_ID       = GG.DIVISION_ID ' + Char(10)
    SET @v_dsql += '      AND A.SITE_ID           = GG.SITE_ID ' + Char(10)
    SET @v_dsql += '      AND A.PLANT_ID          = GG.PLANT_ID ' + Char(10)
    SET @v_dsql += '      AND A.FACTORY_ID        = GG.FACTORY_ID ' + Char(10)
    SET @v_dsql += '      AND A.OPERATION_ID      = GG.OPERATION_ID ' + Char(10)
    SET @v_dsql += '      AND ISNULL(A.PC_MODEL_ID, B.APPLIED_MODEL) = GG.MODEL_ID ' + Char(10)
    SET @v_dsql += '      AND A.ITEM_ID           = GG.ITEM_ID ' + Char(10)
    SET @v_dsql += '      AND C.PROD_VERSION_TYPE = GG.PROD_VERSION_TYPE ' + Char(10)
    SET @v_dsql += '      AND A.CALC_TYPE         = GG.VERSION_TYPE ' + Char(10)
    SET @v_dsql += '      AND A.VERSION           = GG.VERSION ' + Char(10)
    SET @v_dSql += '   LEFT OUTER JOIN' + Char(10)
    SET @v_dSql += '   (' + Char(10)
    SET @v_dSql += '     SELECT DISTINCT  A.SEGMENT1 AS DIVISION_ID, A.ATTRIBUTE2 AS PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + Char(10)
    SET @v_dSql += '     WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''' + Char(10)
    SET @v_dSql += '     AND    A.ACTIVE_FLAG = ''Y''' + Char(10)
    SET @v_dSql += '   ) H' + Char(10)
    SET @v_dSql += '   ON A.DIVISION_ID = H.DIVISION_ID' + Char(10)
    SET @v_dSql += '   AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE' + Char(10)
    SET @v_dSql += '   AND (CASE WHEN A.SITE_ID <> ''A004'' AND A.PRODUCTION_TYPE IN (''E-TEST'',''D-TEST'') THEN ''XX'' ELSE A.PRODUCTION_TYPE END ) = H.PRODUCTION_TYPE'
                   + Char(10)
    SET @v_dSql += ' LEFT OUTER JOIN (' + Char(10)
    SET @v_dSql += ' SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID'
                   + Char(10)
    SET @v_dSql += ' FROM  FP_USER_ROLE_INFO_V R WITH(NOLOCK)' + Char(10)
    SET @v_dSql += ' WHERE  1=1' + Char(10)
    SET @v_dSql += ' AND  R.USER_ID     =' + Char(10)
    SET @v_dSql += '' + @v_user_id + '' + Char(10)
    SET @v_dSql += ' AND  R.SAVE_FLAG   = ''Y''' + Char(10)
    SET @v_dSql += ' AND  R.INSTANCE_ID =' + Char(10)
    SET @v_dSql += '' + @v_master_id + '' + Char(10)
    SET @v_dSql += ' ) R' + Char(10)
    SET @v_dSql += ' ON 1=1' + Char(10)
    SET @v_dSql += ' AND A.COMPANY_ID   = R.COMPANY_ID' + Char(10)
    SET @v_dSql += ' AND A.DIVISION_ID  = R.DIVISION_ID' + Char(10)
    SET @v_dSql += ' AND A.SITE_ID      = R.SITE_ID' + Char(10)
    SET @v_dSql += ' AND A.PLANT_ID     = R.PLANT_ID' + Char(10)
    SET @v_dSql += ' AND A.FACTORY_ID   = R.FACTORY_ID' + Char(10)
    SET @v_dSql += ' AND A.OPERATION_ID = R.OPERATION_ID' + Char(10)
    SET @v_dSql += ' AND A.LINE_ID      = R.LINE_ID' + Char(10)
    
	--KIMSI 22.07.15
	---------------------------------------------------------------------------------
	SET @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M WW WITH(NOLOCK) '+char(10)
	SET @v_dSql += ' ON  A.COMPANY_ID  = WW.COMPANY_ID '+char(10)
	SET @v_dSql += ' AND A.DIVISION_ID = WW.DIVISION_ID '+char(10)
	SET @v_dSql += ' AND A.SITE_ID     = WW.SITE_ID '+char(10)
	SET @v_dSql += ' AND A.PC_MODEL_ID = WW.ITEM_ID '+char(10)
	--SET @v_dSql += ' AND (CASE WHEN A.DATA_TYPE = ''DATA'' AND B.APPLIED_MODEL = A.PC_MODEL_ID THEN NULL ELSE ISNULL(A.PC_MODEL_ID,''N/A'') END) = WW.ITEM_ID '+char(10)
	---------------------------------------------------------------------------------
	--KIMSI 22.07.15
	SET @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M WZ WITH(NOLOCK) '+char(10)
	SET @v_dSql += ' ON  B.COMPANY_ID  = WZ.COMPANY_ID '+char(10)
	SET @v_dSql += ' AND B.DIVISION_ID = WZ.DIVISION_ID '+char(10)
	SET @v_dSql += ' AND B.SITE_ID     = WZ.SITE_ID '+char(10)
	SET @v_dSql += ' AND B.APPLIED_MODEL     = WZ.ITEM_ID '+char(10)
	SET @v_dSql += ' AND  WZ.SCP_EXTRA_SPEC IS NOT NULL'+char(10)
	
	SET @v_dSql += '      ORDER BY (CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN A.CATEGORY_ORDER ELSE 999999 END) -- TOTAL' + Char(10)
    SET @v_dSql += '             , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID' + Char(10)
    SET @v_dSql += '             , A.NICK_NAME, A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID' + Char(10)
    SET @v_dSql += '             , (CASE WHEN A.DATA_TYPE=''DATA'' THEN 1 ELSE 999 END)' + Char(10)
    --SET @v_dSql += '             , (CASE WHEN A.PSI = ''I'' THEN 999999 ELSE 1 END) -- I' + Char(10)
    SET @v_dSql += '             , (CASE WHEN A.PSI = ''I'' THEN 999999 WHEN A.PSI = ''P'' THEN 2 ELSE 1 END) -- I' + Char(10)
    SET @v_dSql += '             , A.PRODUCTION_TYPE, A.MARKET, A.FACTORY_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.WORK_REQUEST_MODEL_ID, A.VERSION DESC, A.PLM_EC_NO, A.PROD_SEQ, A.CATEGORY_ORDER' + Char(10)
    SET @v_dSql += '             , (CASE WHEN A.PSI = ''S'' THEN A.CATEGORY_ORDER ELSE 999999 END) -- S' + Char(10)+ Char(10)

    SET @v_dSql += N'IF OBJECT_ID(''tempdb..#MAIN_P'') IS NOT NULL  DROP TABLE #MAIN_P ' + char(10)
    SET @v_dSql += N'IF OBJECT_ID(''tempdb..#TEMP01'') IS NOT NULL  DROP TABLE #TEMP01 ' + char(10)
	SET @v_dSql += N'if object_id(''tempdb..#FOIL_INFO'') is not null	DROP TABLE #FOIL_INFO ' + char(10) -- foil 정보 수정... 20240329

    IF @p_sys_type = 'SQL'
    BEGIN
        -- return SQL Query Source 
        SELECT @v_dSql AS [QUERY_VALUE]
    END
    ELSE
    BEGIN
        SET @runstart = Getdate()

        BEGIN try
            BEGIN TRAN

            -- run dynamic sql 
            EXEC Sp_executesql @v_dSql

            COMMIT TRAN
        END try
        BEGIN catch
            ROLLBACK

            SET @runend = Getdate()

            EXEC Pr_ui_sql_log @v_proc_name, @p_user_id, '', '', @v_dSql, 'rollback error', @runstart, @runend
        END catch

        SET @runend = Getdate()

        -- Record sql query 
        EXEC Pr_ui_sql_log @v_proc_name, @p_user_id, '', '', @v_dSql, 'select', @runstart, @runend
    END
END
