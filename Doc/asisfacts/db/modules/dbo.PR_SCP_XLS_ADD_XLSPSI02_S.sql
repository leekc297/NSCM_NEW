

/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI02_S
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      : 
                 EXEC PR_SCP_XLS_ADD_XLSPSI02_S    


 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.09.25   DHJ            Initial Release PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2
 * 2023.12.12   OIJ            전달 변수를 지역변수로 변경하여 사용하도록 수정
 * 2024.09.06   KSK           프로시저의 주요파라미터정보를 로그에 기록함
 * 2025.02.17   KSK           CELL_SHIP_PLAN의 변경정보를 원본에 반영함
 */


CREATE PROCEDURE [dbo].[PR_SCP_XLS_ADD_XLSPSI02_S]
( 
  @p_user_id                 VARCHAR(100)
 ,@p_division_id	          NVARCHAR(030)
 ,@p_plan_start_yyyymmdd	  NVARCHAR(008)
 ,@p_plan_type	            NVARCHAR(050)
 ,@p_seq	                  BIGINT
 --,@p_CELL_ITEM_ID	          NVARCHAR(150)
 ,@p_item_id	              NVARCHAR(050)
 ,@p_measure	              NVARCHAR(050)			-- MEASURE별
 ,@p_xls_key1	              NVARCHAR(200)
 ,@p_LoadRatio	              NVARCHAR(20)			-- RATIO 계산 Flag 추가
 ,@p_create_from_yyyymmdd     NVARCHAR(008)
 ,@p_create_to_yyyymmdd       NVARCHAR(008)

 ,@p_QTY001 INT = 0.0 ,@p_QTY002  INT = 0.0 ,@p_QTY003  INT = 0.0 ,@p_QTY004  INT = 0.0 ,@p_QTY005  INT = 0.0
 ,@p_QTY006	INT = 0.0 ,@p_QTY007  INT = 0.0 ,@p_QTY008  INT = 0.0 ,@p_QTY009  INT = 0.0 ,@p_QTY010  INT = 0.0
 ,@p_QTY011 INT = 0.0 ,@p_QTY012  INT = 0.0 ,@p_QTY013  INT = 0.0 ,@p_QTY014  INT = 0.0 ,@p_QTY015  INT = 0.0
 ,@p_QTY016	INT = 0.0 ,@p_QTY017  INT = 0.0 ,@p_QTY018  INT = 0.0 ,@p_QTY019  INT = 0.0 ,@p_QTY020  INT = 0.0
 ,@p_QTY021 INT = 0.0 ,@p_QTY022  INT = 0.0 ,@p_QTY023  INT = 0.0 ,@p_QTY024  INT = 0.0 ,@p_QTY025  INT = 0.0
 ,@p_QTY026	INT = 0.0 ,@p_QTY027  INT = 0.0 ,@p_QTY028  INT = 0.0 ,@p_QTY029  INT = 0.0 ,@p_QTY030  INT = 0.0
 ,@p_QTY031 INT = 0.0 ,@p_QTY032  INT = 0.0 ,@p_QTY033  INT = 0.0 ,@p_QTY034  INT = 0.0 ,@p_QTY035  INT = 0.0
 ,@p_QTY036	INT = 0.0 ,@p_QTY037  INT = 0.0 ,@p_QTY038  INT = 0.0 ,@p_QTY039  INT = 0.0 ,@p_QTY040  INT = 0.0
 ,@p_QTY041 INT = 0.0 ,@p_QTY042  INT = 0.0 ,@p_QTY043  INT = 0.0 ,@p_QTY044  INT = 0.0 ,@p_QTY045  INT = 0.0
 ,@p_QTY046	INT = 0.0 ,@p_QTY047  INT = 0.0 ,@p_QTY048  INT = 0.0 ,@p_QTY049  INT = 0.0 ,@p_QTY050  INT = 0.0
 ,@p_QTY051 INT = 0.0 ,@p_QTY052  INT = 0.0 ,@p_QTY053  INT = 0.0 ,@p_QTY054  INT = 0.0 ,@p_QTY055  INT = 0.0
 ,@p_QTY056	INT = 0.0 ,@p_QTY057  INT = 0.0 ,@p_QTY058  INT = 0.0 ,@p_QTY059  INT = 0.0 ,@p_QTY060  INT = 0.0
 ,@p_QTY061 INT = 0.0 ,@p_QTY062  INT = 0.0 ,@p_QTY063  INT = 0.0 ,@p_QTY064  INT = 0.0 ,@p_QTY065  INT = 0.0
 ,@p_QTY066	INT = 0.0 ,@p_QTY067  INT = 0.0 ,@p_QTY068  INT = 0.0 ,@p_QTY069  INT = 0.0 ,@p_QTY070  INT = 0.0
 ,@p_QTY071 INT = 0.0 ,@p_QTY072  INT = 0.0 ,@p_QTY073  INT = 0.0 ,@p_QTY074  INT = 0.0 ,@p_QTY075  INT = 0.0
 ,@p_QTY076	INT = 0.0 ,@p_QTY077  INT = 0.0 ,@p_QTY078  INT = 0.0 ,@p_QTY079  INT = 0.0 ,@p_QTY080  INT = 0.0
 ,@p_QTY081 INT = 0.0 ,@p_QTY082  INT = 0.0 ,@p_QTY083  INT = 0.0 ,@p_QTY084  INT = 0.0 ,@p_QTY085  INT = 0.0
 ,@p_QTY086	INT = 0.0 ,@p_QTY087  INT = 0.0 ,@p_QTY088  INT = 0.0 ,@p_QTY089  INT = 0.0 ,@p_QTY090  INT = 0.0
 ,@p_QTY091 INT = 0.0 ,@p_QTY092  INT = 0.0 ,@p_QTY093  INT = 0.0 ,@p_QTY094  INT = 0.0 ,@p_QTY095  INT = 0.0
 ,@p_QTY096	INT = 0.0 ,@p_QTY097  INT = 0.0 ,@p_QTY098  INT = 0.0 ,@p_QTY099  INT = 0.0 ,@p_QTY100  INT = 0.0

 ,@p_QTY101 INT = 0.0 ,@p_QTY102  INT = 0.0 ,@p_QTY103  INT = 0.0 ,@p_QTY104  INT = 0.0 ,@p_QTY105  INT = 0.0
 ,@p_QTY106	INT = 0.0 ,@p_QTY107  INT = 0.0 ,@p_QTY108  INT = 0.0 ,@p_QTY109  INT = 0.0 ,@p_QTY110  INT = 0.0
 ,@p_QTY111 INT = 0.0 ,@p_QTY112  INT = 0.0 ,@p_QTY113  INT = 0.0 ,@p_QTY114  INT = 0.0 ,@p_QTY115  INT = 0.0
 ,@p_QTY116	INT = 0.0 ,@p_QTY117  INT = 0.0 ,@p_QTY118  INT = 0.0 ,@p_QTY119  INT = 0.0 ,@p_QTY120  INT = 0.0
 ,@p_QTY121 INT = 0.0 ,@p_QTY122  INT = 0.0 ,@p_QTY123  INT = 0.0 ,@p_QTY124  INT = 0.0 ,@p_QTY125  INT = 0.0
 ,@p_QTY126	INT = 0.0 ,@p_QTY127  INT = 0.0 ,@p_QTY128  INT = 0.0 ,@p_QTY129  INT = 0.0 ,@p_QTY130  INT = 0.0
 ,@p_QTY131 INT = 0.0 ,@p_QTY132  INT = 0.0 ,@p_QTY133  INT = 0.0 ,@p_QTY134  INT = 0.0 ,@p_QTY135  INT = 0.0
 ,@p_QTY136	INT = 0.0 ,@p_QTY137  INT = 0.0 ,@p_QTY138  INT = 0.0 ,@p_QTY139  INT = 0.0 ,@p_QTY140  INT = 0.0
 ,@p_QTY141 INT = 0.0 ,@p_QTY142  INT = 0.0 ,@p_QTY143  INT = 0.0 ,@p_QTY144  INT = 0.0 ,@p_QTY145  INT = 0.0
 ,@p_QTY146	INT = 0.0 ,@p_QTY147  INT = 0.0 ,@p_QTY148  INT = 0.0 ,@p_QTY149  INT = 0.0 ,@p_QTY150  INT = 0.0
 ,@p_QTY151 INT = 0.0 ,@p_QTY152  INT = 0.0 ,@p_QTY153  INT = 0.0 ,@p_QTY154  INT = 0.0 ,@p_QTY155  INT = 0.0
 ,@p_QTY156	INT = 0.0 ,@p_QTY157  INT = 0.0 ,@p_QTY158  INT = 0.0 ,@p_QTY159  INT = 0.0 ,@p_QTY160  INT = 0.0
 ,@p_QTY161 INT = 0.0 ,@p_QTY162  INT = 0.0 ,@p_QTY163  INT = 0.0 ,@p_QTY164  INT = 0.0 ,@p_QTY165  INT = 0.0
 ,@p_QTY166	INT = 0.0 ,@p_QTY167  INT = 0.0 ,@p_QTY168  INT = 0.0 ,@p_QTY169  INT = 0.0 ,@p_QTY170  INT = 0.0
 ,@p_QTY171 INT = 0.0 ,@p_QTY172  INT = 0.0 ,@p_QTY173  INT = 0.0 ,@p_QTY174  INT = 0.0 ,@p_QTY175  INT = 0.0
 ,@p_QTY176	INT = 0.0 ,@p_QTY177  INT = 0.0 ,@p_QTY178  INT = 0.0 ,@p_QTY179  INT = 0.0 ,@p_QTY180  INT = 0.0
 ,@p_QTY181 INT = 0.0 ,@p_QTY182  INT = 0.0 ,@p_QTY183  INT = 0.0 ,@p_QTY184  INT = 0.0 ,@p_QTY185  INT = 0.0
 ,@p_QTY186	INT = 0.0 ,@p_QTY187  INT = 0.0 ,@p_QTY188  INT = 0.0 ,@p_QTY189  INT = 0.0 ,@p_QTY190  INT = 0.0
 ,@p_QTY191 INT = 0.0 ,@p_QTY192  INT = 0.0 ,@p_QTY193  INT = 0.0 ,@p_QTY194  INT = 0.0 ,@p_QTY195  INT = 0.0
 ,@p_QTY196	INT = 0.0 ,@p_QTY197  INT = 0.0 ,@p_QTY198  INT = 0.0 ,@p_QTY199  INT = 0.0 ,@p_QTY200  INT = 0.0

 ,@p_QTY201 INT = 0.0 ,@p_QTY202  INT = 0.0 ,@p_QTY203  INT = 0.0 ,@p_QTY204  INT = 0.0 ,@p_QTY205  INT = 0.0
 ,@p_QTY206	INT = 0.0 ,@p_QTY207  INT = 0.0 ,@p_QTY208  INT = 0.0 ,@p_QTY209  INT = 0.0 ,@p_QTY210  INT = 0.0
 ,@p_QTY211 INT = 0.0 ,@p_QTY212  INT = 0.0 ,@p_QTY213  INT = 0.0 ,@p_QTY214  INT = 0.0 ,@p_QTY215  INT = 0.0
 ,@p_QTY216	INT = 0.0 ,@p_QTY217  INT = 0.0 ,@p_QTY218  INT = 0.0 ,@p_QTY219  INT = 0.0 ,@p_QTY220  INT = 0.0
 ,@p_QTY221 INT = 0.0 ,@p_QTY222  INT = 0.0 ,@p_QTY223  INT = 0.0 ,@p_QTY224  INT = 0.0 ,@p_QTY225  INT = 0.0
 ,@p_QTY226	INT = 0.0 ,@p_QTY227  INT = 0.0 ,@p_QTY228  INT = 0.0 ,@p_QTY229  INT = 0.0 ,@p_QTY230  INT = 0.0
 ,@p_QTY231 INT = 0.0 ,@p_QTY232  INT = 0.0 ,@p_QTY233  INT = 0.0 ,@p_QTY234  INT = 0.0 ,@p_QTY235  INT = 0.0
 ,@p_QTY236	INT = 0.0 ,@p_QTY237  INT = 0.0 ,@p_QTY238  INT = 0.0 ,@p_QTY239  INT = 0.0 ,@p_QTY240  INT = 0.0
 ,@p_QTY241 INT = 0.0 ,@p_QTY242  INT = 0.0 ,@p_QTY243  INT = 0.0 ,@p_QTY244  INT = 0.0 ,@p_QTY245  INT = 0.0
 ,@p_QTY246	INT = 0.0 ,@p_QTY247  INT = 0.0 ,@p_QTY248  INT = 0.0 ,@p_QTY249  INT = 0.0 ,@p_QTY250  INT = 0.0
 ,@p_QTY251 INT = 0.0 ,@p_QTY252  INT = 0.0 ,@p_QTY253  INT = 0.0 ,@p_QTY254  INT = 0.0 ,@p_QTY255  INT = 0.0
 ,@p_QTY256	INT = 0.0 ,@p_QTY257  INT = 0.0 ,@p_QTY258  INT = 0.0 ,@p_QTY259  INT = 0.0 ,@p_QTY260  INT = 0.0
 ,@p_QTY261 INT = 0.0 ,@p_QTY262  INT = 0.0 ,@p_QTY263  INT = 0.0 ,@p_QTY264  INT = 0.0 ,@p_QTY265  INT = 0.0
 ,@p_QTY266	INT = 0.0 ,@p_QTY267  INT = 0.0 ,@p_QTY268  INT = 0.0 ,@p_QTY269  INT = 0.0 ,@p_QTY270  INT = 0.0
 ,@p_QTY271 INT = 0.0 ,@p_QTY272  INT = 0.0 ,@p_QTY273  INT = 0.0 ,@p_QTY274  INT = 0.0 ,@p_QTY275  INT = 0.0
 ,@p_QTY276	INT = 0.0 ,@p_QTY277  INT = 0.0 ,@p_QTY278  INT = 0.0 ,@p_QTY279  INT = 0.0 ,@p_QTY280  INT = 0.0
 ,@p_QTY281 INT = 0.0 ,@p_QTY282  INT = 0.0 ,@p_QTY283  INT = 0.0 ,@p_QTY284  INT = 0.0 ,@p_QTY285  INT = 0.0
 ,@p_QTY286	INT = 0.0 ,@p_QTY287  INT = 0.0 ,@p_QTY288  INT = 0.0 ,@p_QTY289  INT = 0.0 ,@p_QTY290  INT = 0.0
 ,@p_QTY291 INT = 0.0 ,@p_QTY292  INT = 0.0 ,@p_QTY293  INT = 0.0 ,@p_QTY294  INT = 0.0 ,@p_QTY295  INT = 0.0
 ,@p_QTY296	INT = 0.0 ,@p_QTY297  INT = 0.0 ,@p_QTY298  INT = 0.0 ,@p_QTY299  INT = 0.0 ,@p_QTY300  INT = 0.0
 
 ,@p_QTY301 INT = 0.0 ,@p_QTY302  INT = 0.0 ,@p_QTY303  INT = 0.0 ,@p_QTY304  INT = 0.0 ,@p_QTY305  INT = 0.0
 ,@p_QTY306	INT = 0.0 ,@p_QTY307  INT = 0.0 ,@p_QTY308  INT = 0.0 ,@p_QTY309  INT = 0.0 ,@p_QTY310  INT = 0.0
 ,@p_QTY311 INT = 0.0 ,@p_QTY312  INT = 0.0 ,@p_QTY313  INT = 0.0 ,@p_QTY314  INT = 0.0 ,@p_QTY315  INT = 0.0
 ,@p_QTY316	INT = 0.0 ,@p_QTY317  INT = 0.0 ,@p_QTY318  INT = 0.0 ,@p_QTY319  INT = 0.0 ,@p_QTY320  INT = 0.0
 ,@p_QTY321 INT = 0.0 ,@p_QTY322  INT = 0.0 ,@p_QTY323  INT = 0.0 ,@p_QTY324  INT = 0.0 ,@p_QTY325  INT = 0.0
 ,@p_QTY326	INT = 0.0 ,@p_QTY327  INT = 0.0 ,@p_QTY328  INT = 0.0 ,@p_QTY329  INT = 0.0 ,@p_QTY330  INT = 0.0
 ,@p_QTY331 INT = 0.0 ,@p_QTY332  INT = 0.0 ,@p_QTY333  INT = 0.0 ,@p_QTY334  INT = 0.0 ,@p_QTY335  INT = 0.0
 ,@p_QTY336	INT = 0.0 ,@p_QTY337  INT = 0.0 ,@p_QTY338  INT = 0.0 ,@p_QTY339  INT = 0.0 ,@p_QTY340  INT = 0.0
 ,@p_QTY341 INT = 0.0 ,@p_QTY342  INT = 0.0 ,@p_QTY343  INT = 0.0 ,@p_QTY344  INT = 0.0 ,@p_QTY345  INT = 0.0
 ,@p_QTY346	INT = 0.0 ,@p_QTY347  INT = 0.0 ,@p_QTY348  INT = 0.0 ,@p_QTY349  INT = 0.0 ,@p_QTY350  INT = 0.0
 ,@p_QTY351 INT = 0.0 ,@p_QTY352  INT = 0.0 ,@p_QTY353  INT = 0.0 ,@p_QTY354  INT = 0.0 ,@p_QTY355  INT = 0.0
 ,@p_QTY356	INT = 0.0 ,@p_QTY357  INT = 0.0 ,@p_QTY358  INT = 0.0 ,@p_QTY359  INT = 0.0 ,@p_QTY360  INT = 0.0
 ,@p_QTY361 INT = 0.0 ,@p_QTY362  INT = 0.0 ,@p_QTY363  INT = 0.0 ,@p_QTY364  INT = 0.0 
 , @P_IS_DEBUG BIT = 0  -- 0 : RELEASE, 1 :DEBUG (KSK, 250828) 
 )                                     
AS                                     
BEGIN

	print N'플랜 ' +  @p_create_from_yyyymmdd + '~' + @p_create_to_yyyymmdd 

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	DECLARE @v_batch_user_id                 VARCHAR(100) = N'';  
	DECLARE @v_batch_division_id	          NVARCHAR(30);
	DECLARE @v_batch_plan_start_yyyymmdd	  NVARCHAR(8);
	DECLARE @v_batch_plan_type	            NVARCHAR(50);
	DECLARE @v_batch_seq	                  BIGINT;
	DECLARE @v_batch_item_id	              NVARCHAR(50);
	DECLARE @v_batch_measure	              NVARCHAR(50);		
	DECLARE @v_batch_xls_key1	              int;
	DECLARE @v_batch_LoadRatio	              NVARCHAR(20);		
	DECLARE @v_batch_create_from_yyyymmdd     NVARCHAR(8);
	DECLARE @v_batch_create_to_yyyymmdd       NVARCHAR(8);

	--변수 선언
	SET @v_batch_user_id              	= @p_user_id;
	SET @v_batch_division_id	      	= @p_division_id;
	SET @v_batch_plan_start_yyyymmdd	= @p_plan_start_yyyymmdd;
	SET @v_batch_plan_type	          	= @p_plan_type;
	SET @v_batch_seq	              	= @p_seq;
	SET @v_batch_item_id	          	= @p_item_id;
	SET @v_batch_measure	          	= @p_measure;
	SET @v_batch_xls_key1	          	= CONVERT(INT, @p_xls_key1);
	SET @v_batch_LoadRatio	          	= @p_LoadRatio;
	SET @v_batch_create_from_yyyymmdd 	= @p_create_from_yyyymmdd;
	SET @v_batch_create_to_yyyymmdd   	= @p_create_to_yyyymmdd;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_ADD_XLSPSI02_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);     
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_XLS_PSI_GLOBAL'; -- 테이블
    DECLARE @d_event_date   DATETIME;


  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_XLS_PSI_GLOBAL_SMALL_PACK SAVE LOGIC';
    SET @d_event_date = SYSDATETIME();

	--declare @v_attribute10 nvarchar(4000)
	--set @v_attribute10 = ltrim(@p_QTY001)+','+ltrim(@p_QTY002)+','+ltrim(@p_QTY003)+','+ltrim(@p_QTY004)+','+ltrim(@p_QTY005)+','+ltrim(@p_QTY006)+','+ltrim(@p_QTY007)+','+ltrim(@p_QTY008)+','+ltrim(@p_QTY009)+','+ltrim(@p_QTY010)+','+ltrim(@p_QTY011)+','+ltrim(@p_QTY012)+','+ltrim(@p_QTY013)+','+ltrim(@p_QTY014)+','+ltrim(@p_QTY015)+','+ltrim(@p_QTY016)+','+ltrim(@p_QTY017)+','+ltrim(@p_QTY018)+','+ltrim(@p_QTY019)+','+ltrim(@p_QTY020)+','+ltrim(@p_QTY021)+','+ltrim(@p_QTY022)+','+ltrim(@p_QTY023)+','+ltrim(@p_QTY024)+','+ltrim(@p_QTY025)+','+ltrim(@p_QTY026)+','+ltrim(@p_QTY027)+','+ltrim(@p_QTY028)+','+ltrim(@p_QTY029)+','+ltrim(@p_QTY030)+','+ltrim(@p_QTY031)+','+ltrim(@p_QTY032)+','+ltrim(@p_QTY033)+','+ltrim(@p_QTY034)+','+ltrim(@p_QTY035)+','+ltrim(@p_QTY036)+','+ltrim(@p_QTY037)+','+ltrim(@p_QTY038)+','+ltrim(@p_QTY039)+','+ltrim(@p_QTY040)+','+ltrim(@p_QTY041)+','+ltrim(@p_QTY042)+','+ltrim(@p_QTY043)+','+ltrim(@p_QTY044)+','+ltrim(@p_QTY045)+','+ltrim(@p_QTY046)+','+ltrim(@p_QTY047)+','+ltrim(@p_QTY048)+','+ltrim(@p_QTY049)+','+ltrim(@p_QTY050)+','+ltrim(@p_QTY051)+','+ltrim(@p_QTY052)+','+ltrim(@p_QTY053)+','+ltrim(@p_QTY054)+','+ltrim(@p_QTY055)+','+ltrim(@p_QTY056)+','+ltrim(@p_QTY057)+','+ltrim(@p_QTY058)+','+ltrim(@p_QTY059)+','+ltrim(@p_QTY060)+','+ltrim(@p_QTY061)+','+ltrim(@p_QTY062)+','+ltrim(@p_QTY063)+','+ltrim(@p_QTY064)+','+ltrim(@p_QTY065)+','+ltrim(@p_QTY066)+','+ltrim(@p_QTY067)+','+ltrim(@p_QTY068)+','+ltrim(@p_QTY069)+','+ltrim(@p_QTY070)+','+ltrim(@p_QTY071)+','+ltrim(@p_QTY072)+','+ltrim(@p_QTY073)+','+ltrim(@p_QTY074)+','+ltrim(@p_QTY075)+','+ltrim(@p_QTY076)+','+ltrim(@p_QTY077)+','+ltrim(@p_QTY078)+','+ltrim(@p_QTY079)+','+ltrim(@p_QTY080)+','+ltrim(@p_QTY081)+','+ltrim(@p_QTY082)+','+ltrim(@p_QTY083)+','+ltrim(@p_QTY084)+','+ltrim(@p_QTY085)+','+ltrim(@p_QTY086)+','+ltrim(@p_QTY087)+','+ltrim(@p_QTY088)+','+ltrim(@p_QTY089)+','+ltrim(@p_QTY090)+','+ltrim(@p_QTY091)+','+ltrim(@p_QTY092)+','+ltrim(@p_QTY093)+','+ltrim(@p_QTY094)+','+ltrim(@p_QTY095)+','+ltrim(@p_QTY096)+','+ltrim(@p_QTY097)+','+ltrim(@p_QTY098)+','+ltrim(@p_QTY099)+','+ltrim(@p_QTY100)+','+ltrim(@p_QTY101)+','+ltrim(@p_QTY102)+','+ltrim(@p_QTY103)+','+ltrim(@p_QTY104)+','+ltrim(@p_QTY105)+','+ltrim(@p_QTY106)+','+ltrim(@p_QTY107)+','+ltrim(@p_QTY108)+','+ltrim(@p_QTY109)+','+ltrim(@p_QTY110)+','+ltrim(@p_QTY111)+','+ltrim(@p_QTY112)+','+ltrim(@p_QTY113)+','+ltrim(@p_QTY114)+','+ltrim(@p_QTY115)+','+ltrim(@p_QTY116)+','+ltrim(@p_QTY117)+','+ltrim(@p_QTY118)+','+ltrim(@p_QTY119)+','+ltrim(@p_QTY120)+','+ltrim(@p_QTY121)+','+ltrim(@p_QTY122)+','+ltrim(@p_QTY123)+','+ltrim(@p_QTY124)+','+ltrim(@p_QTY125)+','+ltrim(@p_QTY126)+','+ltrim(@p_QTY127)+','+ltrim(@p_QTY128)+','+ltrim(@p_QTY129)+','+ltrim(@p_QTY130)+','+ltrim(@p_QTY131)+','+ltrim(@p_QTY132)+','+ltrim(@p_QTY133)+','+ltrim(@p_QTY134)+','+ltrim(@p_QTY135)+','+ltrim(@p_QTY136)+','+ltrim(@p_QTY137)+','+ltrim(@p_QTY138)+','+ltrim(@p_QTY139)+','+ltrim(@p_QTY140)+','+ltrim(@p_QTY141)+','+ltrim(@p_QTY142)+','+ltrim(@p_QTY143)+','+ltrim(@p_QTY144)+','+ltrim(@p_QTY145)+','+ltrim(@p_QTY146)+','+ltrim(@p_QTY147)+','+ltrim(@p_QTY148)+','+ltrim(@p_QTY149)+','+ltrim(@p_QTY150)+','+ltrim(@p_QTY151)+','+ltrim(@p_QTY152)+','+ltrim(@p_QTY153)+','+ltrim(@p_QTY154)+','+ltrim(@p_QTY155)+','+ltrim(@p_QTY156)+','+ltrim(@p_QTY157)+','+ltrim(@p_QTY158)+','+ltrim(@p_QTY159)+','+ltrim(@p_QTY160)+','+ltrim(@p_QTY161)+','+ltrim(@p_QTY162)+','+ltrim(@p_QTY163)+','+ltrim(@p_QTY164)+','+ltrim(@p_QTY165)+','+ltrim(@p_QTY166)+','+ltrim(@p_QTY167)+','+ltrim(@p_QTY168)+','+ltrim(@p_QTY169)+','+ltrim(@p_QTY170)+','+ltrim(@p_QTY171)+','+ltrim(@p_QTY172)+','+ltrim(@p_QTY173)+','+ltrim(@p_QTY174)+','+ltrim(@p_QTY175)+','+ltrim(@p_QTY176)+','+ltrim(@p_QTY177)+','+ltrim(@p_QTY178)+','+ltrim(@p_QTY179)+','+ltrim(@p_QTY180)+','+ltrim(@p_QTY181)+','+ltrim(@p_QTY182)+','+ltrim(@p_QTY183)+','+ltrim(@p_QTY184)+','+ltrim(@p_QTY185)+','+ltrim(@p_QTY186)+','+ltrim(@p_QTY187)+','+ltrim(@p_QTY188)+','+ltrim(@p_QTY189)+','+ltrim(@p_QTY190)+','+ltrim(@p_QTY191)+','+ltrim(@p_QTY192)+','+ltrim(@p_QTY193)+','+ltrim(@p_QTY194)+','+ltrim(@p_QTY195)+','+ltrim(@p_QTY196)+','+ltrim(@p_QTY197)+','+ltrim(@p_QTY198)+','+ltrim(@p_QTY199)+','+ltrim(@p_QTY200)+','+ltrim(@p_QTY201)+','+ltrim(@p_QTY202)+','+ltrim(@p_QTY203)+','+ltrim(@p_QTY204)+','+ltrim(@p_QTY205)+','+ltrim(@p_QTY206)+','+ltrim(@p_QTY207)+','+ltrim(@p_QTY208)+','+ltrim(@p_QTY209)+','+ltrim(@p_QTY210)+','+ltrim(@p_QTY211)+','+ltrim(@p_QTY212)+','+ltrim(@p_QTY213)+','+ltrim(@p_QTY214)+','+ltrim(@p_QTY215)+','+ltrim(@p_QTY216)+','+ltrim(@p_QTY217)+','+ltrim(@p_QTY218)+','+ltrim(@p_QTY219)+','+ltrim(@p_QTY220)+','+ltrim(@p_QTY221)+','+ltrim(@p_QTY222)+','+ltrim(@p_QTY223)+','+ltrim(@p_QTY224)+','+ltrim(@p_QTY225)+','+ltrim(@p_QTY226)+','+ltrim(@p_QTY227)+','+ltrim(@p_QTY228)+','+ltrim(@p_QTY229)+','+ltrim(@p_QTY230)+','+ltrim(@p_QTY231)+','+ltrim(@p_QTY232)+','+ltrim(@p_QTY233)+','+ltrim(@p_QTY234)+','+ltrim(@p_QTY235)+','+ltrim(@p_QTY236)+','+ltrim(@p_QTY237)+','+ltrim(@p_QTY238)+','+ltrim(@p_QTY239)+','+ltrim(@p_QTY240)+','+ltrim(@p_QTY241)+','+ltrim(@p_QTY242)+','+ltrim(@p_QTY243)+','+ltrim(@p_QTY244)+','+ltrim(@p_QTY245)+','+ltrim(@p_QTY246)+','+ltrim(@p_QTY247)+','+ltrim(@p_QTY248)+','+ltrim(@p_QTY249)+','+ltrim(@p_QTY250)+','+ltrim(@p_QTY251)+','+ltrim(@p_QTY252)+','+ltrim(@p_QTY253)+','+ltrim(@p_QTY254)+','+ltrim(@p_QTY255)+','+ltrim(@p_QTY256)+','+ltrim(@p_QTY257)+','+ltrim(@p_QTY258)+','+ltrim(@p_QTY259)+','+ltrim(@p_QTY260)+','+ltrim(@p_QTY261)+','+ltrim(@p_QTY262)+','+ltrim(@p_QTY263)+','+ltrim(@p_QTY264)+','+ltrim(@p_QTY265)+','+ltrim(@p_QTY266)+','+ltrim(@p_QTY267)+','+ltrim(@p_QTY268)+','+ltrim(@p_QTY269)+','+ltrim(@p_QTY270)+','+ltrim(@p_QTY271)+','+ltrim(@p_QTY272)+','+ltrim(@p_QTY273)+','+ltrim(@p_QTY274)+','+ltrim(@p_QTY275)+','+ltrim(@p_QTY276)+','+ltrim(@p_QTY277)+','+ltrim(@p_QTY278)+','+ltrim(@p_QTY279)+','+ltrim(@p_QTY280)+','+ltrim(@p_QTY281)+','+ltrim(@p_QTY282)+','+ltrim(@p_QTY283)+','+ltrim(@p_QTY284)+','+ltrim(@p_QTY285)+','+ltrim(@p_QTY286)+','+ltrim(@p_QTY287)+','+ltrim(@p_QTY288)+','+ltrim(@p_QTY289)+','+ltrim(@p_QTY290)+','+ltrim(@p_QTY291)+','+ltrim(@p_QTY292)+','+ltrim(@p_QTY293)+','+ltrim(@p_QTY294)+','+ltrim(@p_QTY295)+','+ltrim(@p_QTY296)+','+ltrim(@p_QTY297)+','+ltrim(@p_QTY298)+','+ltrim(@p_QTY299)+','+ltrim(@p_QTY300)+','+ltrim(@p_QTY301)+','+ltrim(@p_QTY302)+','+ltrim(@p_QTY303)+','+ltrim(@p_QTY304)+','+ltrim(@p_QTY305)+','+ltrim(@p_QTY306)+','+ltrim(@p_QTY307)+','+ltrim(@p_QTY308)+','+ltrim(@p_QTY309)+','+ltrim(@p_QTY310)+','+ltrim(@p_QTY311)+','+ltrim(@p_QTY312)+','+ltrim(@p_QTY313)+','+ltrim(@p_QTY314)+','+ltrim(@p_QTY315)+','+ltrim(@p_QTY316)+','+ltrim(@p_QTY317)+','+ltrim(@p_QTY318)+','+ltrim(@p_QTY319)+','+ltrim(@p_QTY320)+','+ltrim(@p_QTY321)+','+ltrim(@p_QTY322)+','+ltrim(@p_QTY323)+','+ltrim(@p_QTY324)+','+ltrim(@p_QTY325)+','+ltrim(@p_QTY326)+','+ltrim(@p_QTY327)+','+ltrim(@p_QTY328)+','+ltrim(@p_QTY329)+','+ltrim(@p_QTY330)+','+ltrim(@p_QTY331)+','+ltrim(@p_QTY332)+','+ltrim(@p_QTY333)+','+ltrim(@p_QTY334)+','+ltrim(@p_QTY335)+','+ltrim(@p_QTY336)+','+ltrim(@p_QTY337)+','+ltrim(@p_QTY338)+','+ltrim(@p_QTY339)+','+ltrim(@p_QTY340)+','+ltrim(@p_QTY341)+','+ltrim(@p_QTY342)+','+ltrim(@p_QTY343)+','+ltrim(@p_QTY344)+','+ltrim(@p_QTY345)+','+ltrim(@p_QTY346)+','+ltrim(@p_QTY347)+','+ltrim(@p_QTY348)+','+ltrim(@p_QTY349)+','+ltrim(@p_QTY350)+','+ltrim(@p_QTY351)+','+ltrim(@p_QTY352)+','+ltrim(@p_QTY353)+','+ltrim(@p_QTY354)+','+ltrim(@p_QTY355)+','+ltrim(@p_QTY356)+','+ltrim(@p_QTY357)+','+ltrim(@p_QTY358)+','+ltrim(@p_QTY359)+','+ltrim(@p_QTY360)+','+ltrim(@p_QTY361)+','+ltrim(@p_QTY362)+','+ltrim(@p_QTY363)+','+ltrim(@p_QTY364)
	
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
							  --,@p_attribute1 =  @v_batch_measure
							  --,@p_attribute2 =	  @v_batch_create_from_yyyymmdd
							  --,@p_attribute3	=   @v_batch_create_to_yyyymmdd
							  --,@p_attribute4 =  @P_XLS_KEY1
							  --,@p_attribute10 =  @v_attribute10
                              ;
    
    
        -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';     

    PRINT '@p_plan_type ' +  @p_plan_type + ' @division_id '  + @v_batch_division_id

    -- PLAN_TYPE이 FN일경우 수정금지 RETURN
    if @v_batch_plan_type = 'FN'            
      return -1   

    -------------------------------------------------------------------------------------------------------------------------------------------------------         
    -- 입력된 버전과 현재 버전이 다를 경우 RETURN 
    -------------------------------------------------------------------------------------------------------------------------------------------------------
        DECLARE   @v_division_id          NVARCHAR(030) = @v_batch_division_id
                , @v_plan_start_yyyymmdd  NVARCHAR(008) = @v_batch_plan_start_yyyymmdd
                , @v_plan_type            NVARCHAR(050) = @v_batch_plan_type
                , @v_seq                  INT           = @v_batch_seq

        SELECT TOP 1  @v_division_id          = DIVISION_ID
                    , @v_plan_start_yyyymmdd  = PLAN_START_YYYYMMDD
                    , @v_plan_type            = PLAN_TYPE
                    , @v_seq                  = SEQ
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)
		 WHERE PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD) FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)) 	--  * 2022.09.21	KSW			  소형SCM개선요청사항 적용
		 ORDER BY CREATION_DATE DESC 

      IF (@v_batch_division_id <> @v_division_id OR @v_batch_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd OR @v_batch_plan_type <> @v_plan_type OR @v_batch_seq <> @v_seq)  
        return -1   

	IF @P_IS_DEBUG = 1  SELECT 'BEFORE TRY'		
    -------------------------------------------------------------------------------------------------------------------------------------------------------



      --PRINT @p_plan_type
    BEGIN TRY
      BEGIN                             
 
            DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @v_batch_plan_start_yyyymmdd), 112)
			DECLARE @p_from_site	VARCHAR(40)  = '';		-- 가동율 계산시간을 줄이기 위해서 FROM_SITE 추가

			-- 2022.08.19 :: CELL_SHIP_PLAN + CELL_PKG_PLAN_OUT 합산수량 저장으로 인한 CELL_SHIP_PLAN 입력수량 백업 measure OLD_CELL_SHIP_PLAN 저장추가 - START
			IF @v_batch_measure = 'OLD_CELL_SHIP_PLAN'
			BEGIN
				DECLARE @v_org_xls_key1		NVARCHAR(200) = @v_batch_xls_key1;

				SET @v_batch_xls_key1 = 0;

				SELECT @v_batch_xls_key1 = CONVERT(INT, @v_org_xls_key1) * 100;
			END
			-- 2022.08.19 :: CELL_SHIP_PLAN + CELL_PKG_PLAN_OUT 합산수량 저장으로 인한 CELL_SHIP_PLAN 입력수량 백업 measure OLD_CELL_SHIP_PLAN 저장추가 - END

            -------------------------------------------------------------------------------------------------------------         
            -- 수정하기전의 테이블에 존재하는 데이타를 가져와서 변수에 담아둔다.
            ------------------------------------------------------------------------------------------------------------- 
            -- 수정전 QTY 변수                                        
             DECLARE  @x_QTY001 INT = 0.0 ,@x_QTY002  INT = 0.0 ,@x_QTY003  INT = 0.0 ,@x_QTY004  INT = 0.0 ,@x_QTY005  INT = 0.0
                     ,@x_QTY006	INT = 0.0 ,@x_QTY007  INT = 0.0 ,@x_QTY008  INT = 0.0 ,@x_QTY009  INT = 0.0 ,@x_QTY010  INT = 0.0
                     ,@x_QTY011 INT = 0.0 ,@x_QTY012  INT = 0.0 ,@x_QTY013  INT = 0.0 ,@x_QTY014  INT = 0.0 ,@x_QTY015  INT = 0.0
                     ,@x_QTY016	INT = 0.0 ,@x_QTY017  INT = 0.0 ,@x_QTY018  INT = 0.0 ,@x_QTY019  INT = 0.0 ,@x_QTY020  INT = 0.0
                     ,@x_QTY021 INT = 0.0 ,@x_QTY022  INT = 0.0 ,@x_QTY023  INT = 0.0 ,@x_QTY024  INT = 0.0 ,@x_QTY025  INT = 0.0
                     ,@x_QTY026	INT = 0.0 ,@x_QTY027  INT = 0.0 ,@x_QTY028  INT = 0.0 ,@x_QTY029  INT = 0.0 ,@x_QTY030  INT = 0.0
                     ,@x_QTY031 INT = 0.0 ,@x_QTY032  INT = 0.0 ,@x_QTY033  INT = 0.0 ,@x_QTY034  INT = 0.0 ,@x_QTY035  INT = 0.0
                     ,@x_QTY036	INT = 0.0 ,@x_QTY037  INT = 0.0 ,@x_QTY038  INT = 0.0 ,@x_QTY039  INT = 0.0 ,@x_QTY040  INT = 0.0
                     ,@x_QTY041 INT = 0.0 ,@x_QTY042  INT = 0.0 ,@x_QTY043  INT = 0.0 ,@x_QTY044  INT = 0.0 ,@x_QTY045  INT = 0.0
                     ,@x_QTY046	INT = 0.0 ,@x_QTY047  INT = 0.0 ,@x_QTY048  INT = 0.0 ,@x_QTY049  INT = 0.0 ,@x_QTY050  INT = 0.0
                     ,@x_QTY051 INT = 0.0 ,@x_QTY052  INT = 0.0 ,@x_QTY053  INT = 0.0 ,@x_QTY054  INT = 0.0 ,@x_QTY055  INT = 0.0
                     ,@x_QTY056	INT = 0.0 ,@x_QTY057  INT = 0.0 ,@x_QTY058  INT = 0.0 ,@x_QTY059  INT = 0.0 ,@x_QTY060  INT = 0.0
                     ,@x_QTY061 INT = 0.0 ,@x_QTY062  INT = 0.0 ,@x_QTY063  INT = 0.0 ,@x_QTY064  INT = 0.0 ,@x_QTY065  INT = 0.0
                     ,@x_QTY066	INT = 0.0 ,@x_QTY067  INT = 0.0 ,@x_QTY068  INT = 0.0 ,@x_QTY069  INT = 0.0 ,@x_QTY070  INT = 0.0
                     ,@x_QTY071 INT = 0.0 ,@x_QTY072  INT = 0.0 ,@x_QTY073  INT = 0.0 ,@x_QTY074  INT = 0.0 ,@x_QTY075  INT = 0.0
                     ,@x_QTY076	INT = 0.0 ,@x_QTY077  INT = 0.0 ,@x_QTY078  INT = 0.0 ,@x_QTY079  INT = 0.0 ,@x_QTY080  INT = 0.0
                     ,@x_QTY081 INT = 0.0 ,@x_QTY082  INT = 0.0 ,@x_QTY083  INT = 0.0 ,@x_QTY084  INT = 0.0 ,@x_QTY085  INT = 0.0
                     ,@x_QTY086	INT = 0.0 ,@x_QTY087  INT = 0.0 ,@x_QTY088  INT = 0.0 ,@x_QTY089  INT = 0.0 ,@x_QTY090  INT = 0.0
                     ,@x_QTY091 INT = 0.0 ,@x_QTY092  INT = 0.0 ,@x_QTY093  INT = 0.0 ,@x_QTY094  INT = 0.0 ,@x_QTY095  INT = 0.0
                     ,@x_QTY096	INT = 0.0 ,@x_QTY097  INT = 0.0 ,@x_QTY098  INT = 0.0 ,@x_QTY099  INT = 0.0 ,@x_QTY100  INT = 0.0

                     ,@x_QTY101 INT = 0.0 ,@x_QTY102  INT = 0.0 ,@x_QTY103  INT = 0.0 ,@x_QTY104  INT = 0.0 ,@x_QTY105  INT = 0.0
                     ,@x_QTY106	INT = 0.0 ,@x_QTY107  INT = 0.0 ,@x_QTY108  INT = 0.0 ,@x_QTY109  INT = 0.0 ,@x_QTY110  INT = 0.0
                     ,@x_QTY111 INT = 0.0 ,@x_QTY112  INT = 0.0 ,@x_QTY113  INT = 0.0 ,@x_QTY114  INT = 0.0 ,@x_QTY115  INT = 0.0
                     ,@x_QTY116	INT = 0.0 ,@x_QTY117  INT = 0.0 ,@x_QTY118  INT = 0.0 ,@x_QTY119  INT = 0.0 ,@x_QTY120  INT = 0.0
                     ,@x_QTY121 INT = 0.0 ,@x_QTY122  INT = 0.0 ,@x_QTY123  INT = 0.0 ,@x_QTY124  INT = 0.0 ,@x_QTY125  INT = 0.0
                     ,@x_QTY126	INT = 0.0 ,@x_QTY127  INT = 0.0 ,@x_QTY128  INT = 0.0 ,@x_QTY129  INT = 0.0 ,@x_QTY130  INT = 0.0
                     ,@x_QTY131 INT = 0.0 ,@x_QTY132  INT = 0.0 ,@x_QTY133  INT = 0.0 ,@x_QTY134  INT = 0.0 ,@x_QTY135  INT = 0.0
                     ,@x_QTY136	INT = 0.0 ,@x_QTY137  INT = 0.0 ,@x_QTY138  INT = 0.0 ,@x_QTY139  INT = 0.0 ,@x_QTY140  INT = 0.0
                     ,@x_QTY141 INT = 0.0 ,@x_QTY142  INT = 0.0 ,@x_QTY143  INT = 0.0 ,@x_QTY144  INT = 0.0 ,@x_QTY145  INT = 0.0
                     ,@x_QTY146	INT = 0.0 ,@x_QTY147  INT = 0.0 ,@x_QTY148  INT = 0.0 ,@x_QTY149  INT = 0.0 ,@x_QTY150  INT = 0.0
                     ,@x_QTY151 INT = 0.0 ,@x_QTY152  INT = 0.0 ,@x_QTY153  INT = 0.0 ,@x_QTY154  INT = 0.0 ,@x_QTY155  INT = 0.0
                     ,@x_QTY156	INT = 0.0 ,@x_QTY157  INT = 0.0 ,@x_QTY158  INT = 0.0 ,@x_QTY159  INT = 0.0 ,@x_QTY160  INT = 0.0
                     ,@x_QTY161 INT = 0.0 ,@x_QTY162  INT = 0.0 ,@x_QTY163  INT = 0.0 ,@x_QTY164  INT = 0.0 ,@x_QTY165  INT = 0.0
                     ,@x_QTY166	INT = 0.0 ,@x_QTY167  INT = 0.0 ,@x_QTY168  INT = 0.0 ,@x_QTY169  INT = 0.0 ,@x_QTY170  INT = 0.0
                     ,@x_QTY171 INT = 0.0 ,@x_QTY172  INT = 0.0 ,@x_QTY173  INT = 0.0 ,@x_QTY174  INT = 0.0 ,@x_QTY175  INT = 0.0
                     ,@x_QTY176	INT = 0.0 ,@x_QTY177  INT = 0.0 ,@x_QTY178  INT = 0.0 ,@x_QTY179  INT = 0.0 ,@x_QTY180  INT = 0.0
                     ,@x_QTY181 INT = 0.0 ,@x_QTY182  INT = 0.0 ,@x_QTY183  INT = 0.0 ,@x_QTY184  INT = 0.0 ,@x_QTY185  INT = 0.0
                     ,@x_QTY186	INT = 0.0 ,@x_QTY187  INT = 0.0 ,@x_QTY188  INT = 0.0 ,@x_QTY189  INT = 0.0 ,@x_QTY190  INT = 0.0
                     ,@x_QTY191 INT = 0.0 ,@x_QTY192  INT = 0.0 ,@x_QTY193  INT = 0.0 ,@x_QTY194  INT = 0.0 ,@x_QTY195  INT = 0.0
                     ,@x_QTY196	INT = 0.0 ,@x_QTY197  INT = 0.0 ,@x_QTY198  INT = 0.0 ,@x_QTY199  INT = 0.0 ,@x_QTY200  INT = 0.0

                     ,@x_QTY201 INT = 0.0 ,@x_QTY202  INT = 0.0 ,@x_QTY203  INT = 0.0 ,@x_QTY204  INT = 0.0 ,@x_QTY205  INT = 0.0
                     ,@x_QTY206	INT = 0.0 ,@x_QTY207  INT = 0.0 ,@x_QTY208  INT = 0.0 ,@x_QTY209  INT = 0.0 ,@x_QTY210  INT = 0.0
                     ,@x_QTY211 INT = 0.0 ,@x_QTY212  INT = 0.0 ,@x_QTY213  INT = 0.0 ,@x_QTY214  INT = 0.0 ,@x_QTY215  INT = 0.0
                     ,@x_QTY216	INT = 0.0 ,@x_QTY217  INT = 0.0 ,@x_QTY218  INT = 0.0 ,@x_QTY219  INT = 0.0 ,@x_QTY220  INT = 0.0
                     ,@x_QTY221 INT = 0.0 ,@x_QTY222  INT = 0.0 ,@x_QTY223  INT = 0.0 ,@x_QTY224  INT = 0.0 ,@x_QTY225  INT = 0.0
                     ,@x_QTY226	INT = 0.0 ,@x_QTY227  INT = 0.0 ,@x_QTY228  INT = 0.0 ,@x_QTY229  INT = 0.0 ,@x_QTY230  INT = 0.0
                     ,@x_QTY231 INT = 0.0 ,@x_QTY232  INT = 0.0 ,@x_QTY233  INT = 0.0 ,@x_QTY234  INT = 0.0 ,@x_QTY235  INT = 0.0
                     ,@x_QTY236	INT = 0.0 ,@x_QTY237  INT = 0.0 ,@x_QTY238  INT = 0.0 ,@x_QTY239  INT = 0.0 ,@x_QTY240  INT = 0.0
                     ,@x_QTY241 INT = 0.0 ,@x_QTY242  INT = 0.0 ,@x_QTY243  INT = 0.0 ,@x_QTY244  INT = 0.0 ,@x_QTY245  INT = 0.0
                     ,@x_QTY246	INT = 0.0 ,@x_QTY247  INT = 0.0 ,@x_QTY248  INT = 0.0 ,@x_QTY249  INT = 0.0 ,@x_QTY250  INT = 0.0
                     ,@x_QTY251 INT = 0.0 ,@x_QTY252  INT = 0.0 ,@x_QTY253  INT = 0.0 ,@x_QTY254  INT = 0.0 ,@x_QTY255  INT = 0.0
                     ,@x_QTY256	INT = 0.0 ,@x_QTY257  INT = 0.0 ,@x_QTY258  INT = 0.0 ,@x_QTY259  INT = 0.0 ,@x_QTY260  INT = 0.0
                     ,@x_QTY261 INT = 0.0 ,@x_QTY262  INT = 0.0 ,@x_QTY263  INT = 0.0 ,@x_QTY264  INT = 0.0 ,@x_QTY265  INT = 0.0
                     ,@x_QTY266	INT = 0.0 ,@x_QTY267  INT = 0.0 ,@x_QTY268  INT = 0.0 ,@x_QTY269  INT = 0.0 ,@x_QTY270  INT = 0.0
                     ,@x_QTY271 INT = 0.0 ,@x_QTY272  INT = 0.0 ,@x_QTY273  INT = 0.0 ,@x_QTY274  INT = 0.0 ,@x_QTY275  INT = 0.0
                     ,@x_QTY276	INT = 0.0 ,@x_QTY277  INT = 0.0 ,@x_QTY278  INT = 0.0 ,@x_QTY279  INT = 0.0 ,@x_QTY280  INT = 0.0
                     ,@x_QTY281 INT = 0.0 ,@x_QTY282  INT = 0.0 ,@x_QTY283  INT = 0.0 ,@x_QTY284  INT = 0.0 ,@x_QTY285  INT = 0.0
                     ,@x_QTY286	INT = 0.0 ,@x_QTY287  INT = 0.0 ,@x_QTY288  INT = 0.0 ,@x_QTY289  INT = 0.0 ,@x_QTY290  INT = 0.0
                     ,@x_QTY291 INT = 0.0 ,@x_QTY292  INT = 0.0 ,@x_QTY293  INT = 0.0 ,@x_QTY294  INT = 0.0 ,@x_QTY295  INT = 0.0
                     ,@x_QTY296	INT = 0.0 ,@x_QTY297  INT = 0.0 ,@x_QTY298  INT = 0.0 ,@x_QTY299  INT = 0.0 ,@x_QTY300  INT = 0.0
 
                     ,@x_QTY301 INT = 0.0 ,@x_QTY302  INT = 0.0 ,@x_QTY303  INT = 0.0 ,@x_QTY304  INT = 0.0 ,@x_QTY305  INT = 0.0
                     ,@x_QTY306	INT = 0.0 ,@x_QTY307  INT = 0.0 ,@x_QTY308  INT = 0.0 ,@x_QTY309  INT = 0.0 ,@x_QTY310  INT = 0.0
                     ,@x_QTY311 INT = 0.0 ,@x_QTY312  INT = 0.0 ,@x_QTY313  INT = 0.0 ,@x_QTY314  INT = 0.0 ,@x_QTY315  INT = 0.0
                     ,@x_QTY316	INT = 0.0 ,@x_QTY317  INT = 0.0 ,@x_QTY318  INT = 0.0 ,@x_QTY319  INT = 0.0 ,@x_QTY320  INT = 0.0
                     ,@x_QTY321 INT = 0.0 ,@x_QTY322  INT = 0.0 ,@x_QTY323  INT = 0.0 ,@x_QTY324  INT = 0.0 ,@x_QTY325  INT = 0.0
                     ,@x_QTY326	INT = 0.0 ,@x_QTY327  INT = 0.0 ,@x_QTY328  INT = 0.0 ,@x_QTY329  INT = 0.0 ,@x_QTY330  INT = 0.0
                     ,@x_QTY331 INT = 0.0 ,@x_QTY332  INT = 0.0 ,@x_QTY333  INT = 0.0 ,@x_QTY334  INT = 0.0 ,@x_QTY335  INT = 0.0
                     ,@x_QTY336	INT = 0.0 ,@x_QTY337  INT = 0.0 ,@x_QTY338  INT = 0.0 ,@x_QTY339  INT = 0.0 ,@x_QTY340  INT = 0.0
                     ,@x_QTY341 INT = 0.0 ,@x_QTY342  INT = 0.0 ,@x_QTY343  INT = 0.0 ,@x_QTY344  INT = 0.0 ,@x_QTY345  INT = 0.0
                     ,@x_QTY346	INT = 0.0 ,@x_QTY347  INT = 0.0 ,@x_QTY348  INT = 0.0 ,@x_QTY349  INT = 0.0 ,@x_QTY350  INT = 0.0
                     ,@x_QTY351 INT = 0.0 ,@x_QTY352  INT = 0.0 ,@x_QTY353  INT = 0.0 ,@x_QTY354  INT = 0.0 ,@x_QTY355  INT = 0.0
                     ,@x_QTY356	INT = 0.0 ,@x_QTY357  INT = 0.0 ,@x_QTY358  INT = 0.0 ,@x_QTY359  INT = 0.0 ,@x_QTY360  INT = 0.0
                     ,@x_QTY361 INT = 0.0 ,@x_QTY362  INT = 0.0 ,@x_QTY363  INT = 0.0 ,@x_QTY364  INT = 0.0 


             SELECT 
                     @X_QTY001 = QTY001  ,@X_QTY002  = QTY002  ,@X_QTY003  = QTY003  ,@X_QTY004  = QTY004  ,@X_QTY005  = QTY005  ,@X_QTY006  = QTY006  ,@X_QTY007  = QTY007  ,@X_QTY008  = QTY008  ,@X_QTY009  = QTY009  ,@X_QTY010  = QTY010
                    ,@X_QTY011 = QTY011  ,@X_QTY012  = QTY012  ,@X_QTY013  = QTY013  ,@X_QTY014  = QTY014  ,@X_QTY015  = QTY015  ,@X_QTY016  = QTY016  ,@X_QTY017  = QTY017  ,@X_QTY018  = QTY018  ,@X_QTY019  = QTY019  ,@X_QTY020  = QTY020
                    ,@X_QTY021 = QTY021  ,@X_QTY022  = QTY022  ,@X_QTY023  = QTY023  ,@X_QTY024  = QTY024  ,@X_QTY025  = QTY025  ,@X_QTY026  = QTY026  ,@X_QTY027  = QTY027  ,@X_QTY028  = QTY028  ,@X_QTY029  = QTY029  ,@X_QTY030  = QTY030
                    ,@X_QTY031 = QTY031  ,@X_QTY032  = QTY032  ,@X_QTY033  = QTY033  ,@X_QTY034  = QTY034  ,@X_QTY035  = QTY035  ,@X_QTY036  = QTY036  ,@X_QTY037  = QTY037  ,@X_QTY038  = QTY038  ,@X_QTY039  = QTY039  ,@X_QTY040  = QTY040
                    ,@X_QTY041 = QTY041  ,@X_QTY042  = QTY042  ,@X_QTY043  = QTY043  ,@X_QTY044  = QTY044  ,@X_QTY045  = QTY045  ,@X_QTY046  = QTY046  ,@X_QTY047  = QTY047  ,@X_QTY048  = QTY048  ,@X_QTY049  = QTY049  ,@X_QTY050  = QTY050
                    ,@X_QTY051 = QTY051  ,@X_QTY052  = QTY052  ,@X_QTY053  = QTY053  ,@X_QTY054  = QTY054  ,@X_QTY055  = QTY055  ,@X_QTY056  = QTY056  ,@X_QTY057  = QTY057  ,@X_QTY058  = QTY058  ,@X_QTY059  = QTY059  ,@X_QTY060  = QTY060
                    ,@X_QTY061 = QTY061  ,@X_QTY062  = QTY062  ,@X_QTY063  = QTY063  ,@X_QTY064  = QTY064  ,@X_QTY065  = QTY065  ,@X_QTY066  = QTY066  ,@X_QTY067  = QTY067  ,@X_QTY068  = QTY068  ,@X_QTY069  = QTY069  ,@X_QTY070  = QTY070
                    ,@X_QTY071 = QTY071  ,@X_QTY072  = QTY072  ,@X_QTY073  = QTY073  ,@X_QTY074  = QTY074  ,@X_QTY075  = QTY075  ,@X_QTY076  = QTY076  ,@X_QTY077  = QTY077  ,@X_QTY078  = QTY078  ,@X_QTY079  = QTY079  ,@X_QTY080  = QTY080
                    ,@X_QTY081 = QTY081  ,@X_QTY082  = QTY082  ,@X_QTY083  = QTY083  ,@X_QTY084  = QTY084  ,@X_QTY085  = QTY085  ,@X_QTY086  = QTY086  ,@X_QTY087  = QTY087  ,@X_QTY088  = QTY088  ,@X_QTY089  = QTY089  ,@X_QTY090  = QTY090
                    ,@X_QTY091 = QTY091  ,@X_QTY092  = QTY092  ,@X_QTY093  = QTY093  ,@X_QTY094  = QTY094  ,@X_QTY095  = QTY095  ,@X_QTY096  = QTY096  ,@X_QTY097  = QTY097  ,@X_QTY098  = QTY098  ,@X_QTY099  = QTY099  ,@X_QTY100  = QTY100

                    ,@X_QTY101 = QTY101  ,@X_QTY102  = QTY102  ,@X_QTY103  = QTY103  ,@X_QTY104  = QTY104  ,@X_QTY105  = QTY105  ,@X_QTY106  = QTY106  ,@X_QTY107  = QTY107  ,@X_QTY108  = QTY108  ,@X_QTY109  = QTY109  ,@X_QTY110  = QTY110
                    ,@X_QTY111 = QTY111  ,@X_QTY112  = QTY112  ,@X_QTY113  = QTY113  ,@X_QTY114  = QTY114  ,@X_QTY115  = QTY115  ,@X_QTY116  = QTY116  ,@X_QTY117  = QTY117  ,@X_QTY118  = QTY118  ,@X_QTY119  = QTY119  ,@X_QTY120  = QTY120
                    ,@X_QTY121 = QTY121  ,@X_QTY122  = QTY122  ,@X_QTY123  = QTY123  ,@X_QTY124  = QTY124  ,@X_QTY125  = QTY125  ,@X_QTY126  = QTY126  ,@X_QTY127  = QTY127  ,@X_QTY128  = QTY128  ,@X_QTY129  = QTY129  ,@X_QTY130  = QTY130
                    ,@X_QTY131 = QTY131  ,@X_QTY132  = QTY132  ,@X_QTY133  = QTY133  ,@X_QTY134  = QTY134  ,@X_QTY135  = QTY135  ,@X_QTY136  = QTY136  ,@X_QTY137  = QTY137  ,@X_QTY138  = QTY138  ,@X_QTY139  = QTY139  ,@X_QTY140  = QTY140
                    ,@X_QTY141 = QTY141  ,@X_QTY142  = QTY142  ,@X_QTY143  = QTY143  ,@X_QTY144  = QTY144  ,@X_QTY145  = QTY145  ,@X_QTY146  = QTY146  ,@X_QTY147  = QTY147  ,@X_QTY148  = QTY148  ,@X_QTY149  = QTY149  ,@X_QTY150  = QTY150
                    ,@X_QTY151 = QTY151  ,@X_QTY152  = QTY152  ,@X_QTY153  = QTY153  ,@X_QTY154  = QTY154  ,@X_QTY155  = QTY155  ,@X_QTY156  = QTY156  ,@X_QTY157  = QTY157  ,@X_QTY158  = QTY158  ,@X_QTY159  = QTY159  ,@X_QTY160  = QTY160
                    ,@X_QTY161 = QTY161  ,@X_QTY162  = QTY162  ,@X_QTY163  = QTY163  ,@X_QTY164  = QTY164  ,@X_QTY165  = QTY165  ,@X_QTY166  = QTY166  ,@X_QTY167  = QTY167  ,@X_QTY168  = QTY168  ,@X_QTY169  = QTY169  ,@X_QTY170  = QTY170
                    ,@X_QTY171 = QTY171  ,@X_QTY172  = QTY172  ,@X_QTY173  = QTY173  ,@X_QTY174  = QTY174  ,@X_QTY175  = QTY175  ,@X_QTY176  = QTY176  ,@X_QTY177  = QTY177  ,@X_QTY178  = QTY178  ,@X_QTY179  = QTY179  ,@X_QTY180  = QTY180
                    ,@X_QTY181 = QTY181  ,@X_QTY182  = QTY182  ,@X_QTY183  = QTY183  ,@X_QTY184  = QTY184  ,@X_QTY185  = QTY185  ,@X_QTY186  = QTY186  ,@X_QTY187  = QTY187  ,@X_QTY188  = QTY188  ,@X_QTY189  = QTY189  ,@X_QTY190  = QTY190
                    ,@X_QTY191 = QTY191  ,@X_QTY192  = QTY192  ,@X_QTY193  = QTY193  ,@X_QTY194  = QTY194  ,@X_QTY195  = QTY195  ,@X_QTY196  = QTY196  ,@X_QTY197  = QTY197  ,@X_QTY198  = QTY198  ,@X_QTY199  = QTY199  ,@X_QTY200  = QTY200

                    ,@X_QTY201 = QTY201  ,@X_QTY202  = QTY202  ,@X_QTY203  = QTY203  ,@X_QTY204  = QTY204  ,@X_QTY205  = QTY205  ,@X_QTY206  = QTY206  ,@X_QTY207  = QTY207  ,@X_QTY208  = QTY208  ,@X_QTY209  = QTY209  ,@X_QTY210  = QTY210
                    ,@X_QTY211 = QTY211  ,@X_QTY212  = QTY212  ,@X_QTY213  = QTY213  ,@X_QTY214  = QTY214  ,@X_QTY215  = QTY215  ,@X_QTY216  = QTY216  ,@X_QTY217  = QTY217  ,@X_QTY218  = QTY218  ,@X_QTY219  = QTY219  ,@X_QTY220  = QTY220
                    ,@X_QTY221 = QTY221  ,@X_QTY222  = QTY222  ,@X_QTY223  = QTY223  ,@X_QTY224  = QTY224  ,@X_QTY225  = QTY225  ,@X_QTY226  = QTY226  ,@X_QTY227  = QTY227  ,@X_QTY228  = QTY228  ,@X_QTY229  = QTY229  ,@X_QTY230  = QTY230
                    ,@X_QTY231 = QTY231  ,@X_QTY232  = QTY232  ,@X_QTY233  = QTY233  ,@X_QTY234  = QTY234  ,@X_QTY235  = QTY235  ,@X_QTY236  = QTY236  ,@X_QTY237  = QTY237  ,@X_QTY238  = QTY238  ,@X_QTY239  = QTY239  ,@X_QTY240  = QTY240
                    ,@X_QTY241 = QTY241  ,@X_QTY242  = QTY242  ,@X_QTY243  = QTY243  ,@X_QTY244  = QTY244  ,@X_QTY245  = QTY245  ,@X_QTY246  = QTY246  ,@X_QTY247  = QTY247  ,@X_QTY248  = QTY248  ,@X_QTY249  = QTY249  ,@X_QTY250  = QTY250
                    ,@X_QTY251 = QTY251  ,@X_QTY252  = QTY252  ,@X_QTY253  = QTY253  ,@X_QTY254  = QTY254  ,@X_QTY255  = QTY255  ,@X_QTY256  = QTY256  ,@X_QTY257  = QTY257  ,@X_QTY258  = QTY258  ,@X_QTY259  = QTY259  ,@X_QTY260  = QTY260
                    ,@X_QTY261 = QTY261  ,@X_QTY262  = QTY262  ,@X_QTY263  = QTY263  ,@X_QTY264  = QTY264  ,@X_QTY265  = QTY265  ,@X_QTY266  = QTY266  ,@X_QTY267  = QTY267  ,@X_QTY268  = QTY268  ,@X_QTY269  = QTY269  ,@X_QTY270  = QTY270
                    ,@X_QTY271 = QTY271  ,@X_QTY272  = QTY272  ,@X_QTY273  = QTY273  ,@X_QTY274  = QTY274  ,@X_QTY275  = QTY275  ,@X_QTY276  = QTY276  ,@X_QTY277  = QTY277  ,@X_QTY278  = QTY278  ,@X_QTY279  = QTY279  ,@X_QTY280  = QTY280
                    ,@X_QTY281 = QTY281  ,@X_QTY282  = QTY282  ,@X_QTY283  = QTY283  ,@X_QTY284  = QTY284  ,@X_QTY285  = QTY285  ,@X_QTY286  = QTY286  ,@X_QTY287  = QTY287  ,@X_QTY288  = QTY288  ,@X_QTY289  = QTY289  ,@X_QTY290  = QTY290
                    ,@X_QTY291 = QTY291  ,@X_QTY292  = QTY292  ,@X_QTY293  = QTY293  ,@X_QTY294  = QTY294  ,@X_QTY295  = QTY295  ,@X_QTY296  = QTY296  ,@X_QTY297  = QTY297  ,@X_QTY298  = QTY298  ,@X_QTY299  = QTY299  ,@X_QTY300  = QTY300

                    ,@X_QTY301 = QTY301  ,@X_QTY302  = QTY302  ,@X_QTY303  = QTY303  ,@X_QTY304  = QTY304  ,@X_QTY305  = QTY305  ,@X_QTY306  = QTY306  ,@X_QTY307  = QTY307  ,@X_QTY308  = QTY308  ,@X_QTY309  = QTY309  ,@X_QTY310  = QTY310
                    ,@X_QTY311 = QTY311  ,@X_QTY312  = QTY312  ,@X_QTY313  = QTY313  ,@X_QTY314  = QTY314  ,@X_QTY315  = QTY315  ,@X_QTY316  = QTY316  ,@X_QTY317  = QTY317  ,@X_QTY318  = QTY318  ,@X_QTY319  = QTY319  ,@X_QTY320  = QTY320
                    ,@X_QTY321 = QTY321  ,@X_QTY322  = QTY322  ,@X_QTY323  = QTY323  ,@X_QTY324  = QTY324  ,@X_QTY325  = QTY325  ,@X_QTY326  = QTY326  ,@X_QTY327  = QTY327  ,@X_QTY328  = QTY328  ,@X_QTY329  = QTY329  ,@X_QTY330  = QTY330
                    ,@X_QTY331 = QTY331  ,@X_QTY332  = QTY332  ,@X_QTY333  = QTY333  ,@X_QTY334  = QTY334  ,@X_QTY335  = QTY335  ,@X_QTY336  = QTY336  ,@X_QTY337  = QTY337  ,@X_QTY338  = QTY338  ,@X_QTY339  = QTY339  ,@X_QTY340  = QTY340
                    ,@X_QTY341 = QTY341  ,@X_QTY342  = QTY342  ,@X_QTY343  = QTY343  ,@X_QTY344  = QTY344  ,@X_QTY345  = QTY345  ,@X_QTY346  = QTY346  ,@X_QTY347  = QTY347  ,@X_QTY348  = QTY348  ,@X_QTY349  = QTY349  ,@X_QTY350  = QTY350
                    ,@X_QTY351 = QTY351  ,@X_QTY352  = QTY352  ,@X_QTY353  = QTY353  ,@X_QTY354  = QTY354  ,@X_QTY355  = QTY355  ,@X_QTY356  = QTY356  ,@X_QTY357  = QTY357  ,@X_QTY358  = QTY358  ,@X_QTY359  = QTY359  ,@X_QTY360  = QTY360
                    ,@X_QTY361 = QTY361  ,@X_QTY362  = QTY362  ,@X_QTY363  = QTY363  ,@X_QTY364  = QTY364 
					,@p_from_site = FROM_SITE

               FROM DBO.SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH(NOLOCK)
              WHERE 0 = 0
                AND DIVISION_ID         = @v_batch_division_id
                AND PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
				AND CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
				AND PLAN_TYPE			= @v_batch_plan_type
                AND SEQ                 = @v_batch_seq
                AND XLS_KEY1            = @v_batch_xls_key1; 

            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 대상 DATA 생성
            -- 생산을 경우 반올림(4보다 크면 1주 추가)
            -------------------------------------------------------------------------------------------------------------         
            IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL	
	              DROP TABLE #SCM_MST_SITE

            SELECT 
                    S.DIVISION_ID
	            ,S.PLANT_ID
	            ,S.OPERATION_GROUP
	            ,S.SCM_SITE_ID 
	            ,S.SHIP_FROZEN
                ,(S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS SHIP_FROZEN_WEEK
                ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.SHIP_FROZEN/7 + (CASE WHEN SHIP_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS SHIP_FROZEN_WEEK_DAY
	            ,S.PROD_FROZEN
                ,(S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)) AS PROD_FROZEN_WEEK
                ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, (S.PROD_FROZEN/7 + (CASE WHEN PROD_FROZEN%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY
--                        ,CONVERT(NVARCHAR(8),  DATEADD(WEEK, ( (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END) /7 + (CASE WHEN (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END)%7 > 0 THEN 1 ELSE 0 END)), @v_batch_plan_start_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY_MA
				,CONVERT(NVARCHAR(8),  DATEADD(WEEK, ( (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END) /7 + (CASE WHEN (CASE WHEN ((S.PROD_FROZEN -7) > 0) THEN (S.PROD_FROZEN -7) ELSE 0 END)%7 > 0 THEN 1 ELSE 0 END)), @v_batch_create_from_yyyymmdd), 112)  AS PROD_FROZEN_WEEK_DAY_MA
	            ,S.FP_PLAN_PERIOD		
	            ,S.VALID_YN
	            ,S.NEW_YN
	            ,S.COMPANY_ID
	            ,S.LOGISTIC_PLANT_ID
	            ,S.PACKER_ITEM_ID_SUFFIX
            INTO #SCM_MST_SITE 
            FROM SCM_MST_SITE S WITH (NOLOCK)
            WHERE S.SITE_TYPE   = 'PLANT'
                AND S.VALID_YN    = 'Y'
                AND S.DIVISION_ID = @v_batch_division_id
            ;

            -------------------------------------------------------------------------------------------------------------         
            -- 수정하기전의 테이블에 존재하는 데이타를 가져와서 임시 테이블에 담아둔다.
            ------------------------------------------------------------------------------------------------------------- 
            -- SOURCE에 반영될 테이블 #DAY_SCP_XLS_PSI_GLOBAL
            IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL	
	              DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL
			SELECT * INTO #DAY_SCP_XLS_PSI_GLOBAL FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WHERE 1=2;
		
			INSERT INTO #DAY_SCP_XLS_PSI_GLOBAL
            SELECT * 
            FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
                WHERE 0 = 0
                AND DIVISION_ID         = @v_batch_division_id
                AND PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
				AND CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
				AND PLAN_TYPE			= @v_batch_plan_type
                AND SEQ                 = @v_batch_seq
                AND XLS_KEY1            = @v_batch_xls_key1 
                ;

			IF @P_IS_DEBUG = 1  SELECT '430' AS "#DAY_SCP_XLS_PSI_GLOBAL",  * FROM #DAY_SCP_XLS_PSI_GLOBAL
	
			--SELECT '#DAY_SCP_XLS_PSI_GLOBAL_1' TN , * FROM #DAY_SCP_XLS_PSI_GLOBAL --TEST

			

            -- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start
			-- BOD RANGE
			DECLARE @v_bod_from				NVARCHAR(12) = '';
			DECLARE @v_bod_to				NVARCHAR(12) = '';

			SELECT @v_bod_from = (CASE WHEN ATTRIBUTE3 IS NULL THEN '19900101' 
									   ELSE LEFT(ATTRIBUTE3, 8) END)
				  ,@v_bod_to   = (CASE WHEN ATTRIBUTE3 IS NULL THEN '29991231' 
									   ELSE RIGHT(ATTRIBUTE3, 8) END)
			  FROM #DAY_SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
			;			

			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end


			-- SCP_XLS_PSI_GLOBAL에 반영될 테이블 #SCP_XLS_PSI_GLOBAL_ORG
            IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ORG') IS NOT NULL	
	              DROP TABLE #SCP_XLS_PSI_GLOBAL_ORG

			SELECT * 
			  INTO #SCP_XLS_PSI_GLOBAL_ORG
			  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
			 WHERE 0 = 0
			   AND DIVISION_ID         = @v_batch_division_id
			   AND PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
			   AND CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
			   AND PLAN_TYPE			= @v_batch_plan_type
			   AND SEQ                 = @v_batch_seq
			   AND XLS_KEY1            = @v_batch_xls_key1 
			;

			PRINT @v_batch_measure + '05. ' +CONVERT(CHAR(23), GETDATE(), 21);

            -------------------------------------------------------------------------------------------------------------         
            -- 'PACK_SHIP_PLAN' 일경우 지정 요일에 저장
            --  대상 주QTY가 -9 일경우는 기존 값을 사용하고, +일경우는 지정된 요일에 값을 UPDATE한다.
            ------------------------------------------------------------------------------------------------------------- 
            -------------------------------------------------------------------------------------------------------------

			-- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정
            --               - CELL_SHIP_PLAN (Ship Plan(SCP)) Measure 를 SEMI_SHIP_PLAN 에 준하여 처리하는 로직을 추가
			-- 2022.04.05   KSW            Daily/Monthly Bucket 변경건 적용 :: 변경된 Daily 건만 저장하는 로직추가 -- PACK_PROD 추가
			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 - SEMI_SHIP_PLAN case 추가
            IF @v_batch_measure IN  ('PACK_SHIP_PLAN', 'CELL_SHIP_PLAN', 'PACK_PROD', 'SEMI_SHIP_PLAN') --
              BEGIN 

              UPDATE X
                 SET   X.QTY001 = @p_QTY001  ,X.QTY002  = @p_QTY002  ,X.QTY003  = @p_QTY003  ,X.QTY004  = @p_QTY004  ,X.QTY005  = @p_QTY005  
                      ,X.QTY006 = @p_QTY006  ,X.QTY007  = @p_QTY007  ,X.QTY008  = @p_QTY008  ,X.QTY009  = @p_QTY009  ,X.QTY010  = @p_QTY010
                      ,X.QTY011 = @p_QTY011  ,X.QTY012  = @p_QTY012  ,X.QTY013  = @p_QTY013  ,X.QTY014  = @p_QTY014  ,X.QTY015  = @p_QTY015  
                      ,X.QTY016 = @p_QTY016  ,X.QTY017  = @p_QTY017  ,X.QTY018  = @p_QTY018  ,X.QTY019  = @p_QTY019  ,X.QTY020  = @p_QTY020
                      ,X.QTY021 = @p_QTY021  ,X.QTY022  = @p_QTY022  ,X.QTY023  = @p_QTY023  ,X.QTY024  = @p_QTY024  ,X.QTY025  = @p_QTY025  
                      ,X.QTY026 = @p_QTY026  ,X.QTY027  = @p_QTY027  ,X.QTY028  = @p_QTY028  ,X.QTY029  = @p_QTY029  ,X.QTY030  = @p_QTY030
                      ,X.QTY031 = @p_QTY031  ,X.QTY032  = @p_QTY032  ,X.QTY033  = @p_QTY033  ,X.QTY034  = @p_QTY034  ,X.QTY035  = @p_QTY035  
                      ,X.QTY036 = @p_QTY036  ,X.QTY037  = @p_QTY037  ,X.QTY038  = @p_QTY038  ,X.QTY039  = @p_QTY039  ,X.QTY040  = @p_QTY040
                      ,X.QTY041 = @p_QTY041  ,X.QTY042  = @p_QTY042  ,X.QTY043  = @p_QTY043  ,X.QTY044  = @p_QTY044  ,X.QTY045  = @p_QTY045  
                      ,X.QTY046 = @p_QTY046  ,X.QTY047  = @p_QTY047  ,X.QTY048  = @p_QTY048  ,X.QTY049  = @p_QTY049  ,X.QTY050  = @p_QTY050
                      ,X.QTY051 = @p_QTY051  ,X.QTY052  = @p_QTY052  ,X.QTY053  = @p_QTY053  ,X.QTY054  = @p_QTY054  ,X.QTY055  = @p_QTY055  
                      ,X.QTY056 = @p_QTY056  ,X.QTY057  = @p_QTY057  ,X.QTY058  = @p_QTY058  ,X.QTY059  = @p_QTY059  ,X.QTY060  = @p_QTY060
                      ,X.QTY061 = @p_QTY061  ,X.QTY062  = @p_QTY062  ,X.QTY063  = @p_QTY063  ,X.QTY064  = @p_QTY064  ,X.QTY065  = @p_QTY065  
                      ,X.QTY066 = @p_QTY066  ,X.QTY067  = @p_QTY067  ,X.QTY068  = @p_QTY068  ,X.QTY069  = @p_QTY069  ,X.QTY070  = @p_QTY070
                      ,X.QTY071 = @p_QTY071  ,X.QTY072  = @p_QTY072  ,X.QTY073  = @p_QTY073  ,X.QTY074  = @p_QTY074  ,X.QTY075  = @p_QTY075  
                      ,X.QTY076 = @p_QTY076  ,X.QTY077  = @p_QTY077  ,X.QTY078  = @p_QTY078  ,X.QTY079  = @p_QTY079  ,X.QTY080  = @p_QTY080
                      ,X.QTY081 = @p_QTY081  ,X.QTY082  = @p_QTY082  ,X.QTY083  = @p_QTY083  ,X.QTY084  = @p_QTY084  ,X.QTY085  = @p_QTY085  
                      ,X.QTY086 = @p_QTY086  ,X.QTY087  = @p_QTY087  ,X.QTY088  = @p_QTY088  ,X.QTY089  = @p_QTY089  ,X.QTY090  = @p_QTY090
                      ,X.QTY091 = @p_QTY091  ,X.QTY092  = @p_QTY092  ,X.QTY093  = @p_QTY093  ,X.QTY094  = @p_QTY094  ,X.QTY095  = @p_QTY095  
                      ,X.QTY096 = @p_QTY096  ,X.QTY097  = @p_QTY097  ,X.QTY098  = @p_QTY098  ,X.QTY099  = @p_QTY099  ,X.QTY100  = @p_QTY100

                      ,X.QTY101 = @p_QTY101  ,X.QTY102  = @p_QTY102  ,X.QTY103  = @p_QTY103  ,X.QTY104  = @p_QTY104  ,X.QTY105  = @p_QTY105  
                      ,X.QTY106 = @p_QTY106  ,X.QTY107  = @p_QTY107  ,X.QTY108  = @p_QTY108  ,X.QTY109  = @p_QTY109  ,X.QTY110  = @p_QTY110
                      ,X.QTY111 = @p_QTY111  ,X.QTY112  = @p_QTY112  ,X.QTY113  = @p_QTY113  ,X.QTY114  = @p_QTY114  ,X.QTY115  = @p_QTY115  
                      ,X.QTY116 = @p_QTY116  ,X.QTY117  = @p_QTY117  ,X.QTY118  = @p_QTY118  ,X.QTY119  = @p_QTY119  ,X.QTY120  = @p_QTY120
                      ,X.QTY121 = @p_QTY121  ,X.QTY122  = @p_QTY122  ,X.QTY123  = @p_QTY123  ,X.QTY124  = @p_QTY124  ,X.QTY125  = @p_QTY125  
                      ,X.QTY126 = @p_QTY126  ,X.QTY127  = @p_QTY127  ,X.QTY128  = @p_QTY128  ,X.QTY129  = @p_QTY129  ,X.QTY130  = @p_QTY130
                      ,X.QTY131 = @p_QTY131  ,X.QTY132  = @p_QTY132  ,X.QTY133  = @p_QTY133  ,X.QTY134  = @p_QTY134  ,X.QTY135  = @p_QTY135  
                      ,X.QTY136 = @p_QTY136  ,X.QTY137  = @p_QTY137  ,X.QTY138  = @p_QTY138  ,X.QTY139  = @p_QTY139  ,X.QTY140  = @p_QTY140
                      ,X.QTY141 = @p_QTY141  ,X.QTY142  = @p_QTY142  ,X.QTY143  = @p_QTY143  ,X.QTY144  = @p_QTY144  ,X.QTY145  = @p_QTY145  
                      ,X.QTY146 = @p_QTY146  ,X.QTY147  = @p_QTY147  ,X.QTY148  = @p_QTY148  ,X.QTY149  = @p_QTY149  ,X.QTY150  = @p_QTY150
                      ,X.QTY151 = @p_QTY151  ,X.QTY152  = @p_QTY152  ,X.QTY153  = @p_QTY153  ,X.QTY154  = @p_QTY154  ,X.QTY155  = @p_QTY155  
                      ,X.QTY156 = @p_QTY156  ,X.QTY157  = @p_QTY157  ,X.QTY158  = @p_QTY158  ,X.QTY159  = @p_QTY159  ,X.QTY160  = @p_QTY160
                      ,X.QTY161 = @p_QTY161  ,X.QTY162  = @p_QTY162  ,X.QTY163  = @p_QTY163  ,X.QTY164  = @p_QTY164  ,X.QTY165  = @p_QTY165  
                      ,X.QTY166 = @p_QTY166  ,X.QTY167  = @p_QTY167  ,X.QTY168  = @p_QTY168  ,X.QTY169  = @p_QTY169  ,X.QTY170  = @p_QTY170
                      ,X.QTY171 = @p_QTY171  ,X.QTY172  = @p_QTY172  ,X.QTY173  = @p_QTY173  ,X.QTY174  = @p_QTY174  ,X.QTY175  = @p_QTY175  
                      ,X.QTY176 = @p_QTY176  ,X.QTY177  = @p_QTY177  ,X.QTY178  = @p_QTY178  ,X.QTY179  = @p_QTY179  ,X.QTY180  = @p_QTY180
                      ,X.QTY181 = @p_QTY181  ,X.QTY182  = @p_QTY182  ,X.QTY183  = @p_QTY183  ,X.QTY184  = @p_QTY184  ,X.QTY185  = @p_QTY185  
                      ,X.QTY186 = @p_QTY186  ,X.QTY187  = @p_QTY187  ,X.QTY188  = @p_QTY188  ,X.QTY189  = @p_QTY189  ,X.QTY190  = @p_QTY190
                      ,X.QTY191 = @p_QTY191  ,X.QTY192  = @p_QTY192  ,X.QTY193  = @p_QTY193  ,X.QTY194  = @p_QTY194  ,X.QTY195  = @p_QTY195  
                      ,X.QTY196 = @p_QTY196  ,X.QTY197  = @p_QTY197  ,X.QTY198  = @p_QTY198  ,X.QTY199  = @p_QTY199  ,X.QTY200  = @p_QTY200

                      ,X.QTY201 = @p_QTY201  ,X.QTY202  = @p_QTY202  ,X.QTY203  = @p_QTY203  ,X.QTY204  = @p_QTY204  ,X.QTY205  = @p_QTY205  
                      ,X.QTY206 = @p_QTY206  ,X.QTY207  = @p_QTY207  ,X.QTY208  = @p_QTY208  ,X.QTY209  = @p_QTY209  ,X.QTY210  = @p_QTY210
                      ,X.QTY211 = @p_QTY211  ,X.QTY212  = @p_QTY212  ,X.QTY213  = @p_QTY213  ,X.QTY214  = @p_QTY214  ,X.QTY215  = @p_QTY215  
                      ,X.QTY216 = @p_QTY216  ,X.QTY217  = @p_QTY217  ,X.QTY218  = @p_QTY218  ,X.QTY219  = @p_QTY219  ,X.QTY220  = @p_QTY220
                      ,X.QTY221 = @p_QTY221  ,X.QTY222  = @p_QTY222  ,X.QTY223  = @p_QTY223  ,X.QTY224  = @p_QTY224  ,X.QTY225  = @p_QTY225  
                      ,X.QTY226 = @p_QTY226  ,X.QTY227  = @p_QTY227  ,X.QTY228  = @p_QTY228  ,X.QTY229  = @p_QTY229  ,X.QTY230  = @p_QTY230
                      ,X.QTY231 = @p_QTY231  ,X.QTY232  = @p_QTY232  ,X.QTY233  = @p_QTY233  ,X.QTY234  = @p_QTY234  ,X.QTY235  = @p_QTY235  
                      ,X.QTY236 = @p_QTY236  ,X.QTY237  = @p_QTY237  ,X.QTY238  = @p_QTY238  ,X.QTY239  = @p_QTY239  ,X.QTY240  = @p_QTY240
                      ,X.QTY241 = @p_QTY241  ,X.QTY242  = @p_QTY242  ,X.QTY243  = @p_QTY243  ,X.QTY244  = @p_QTY244  ,X.QTY245  = @p_QTY245  
                      ,X.QTY246 = @p_QTY246  ,X.QTY247  = @p_QTY247  ,X.QTY248  = @p_QTY248  ,X.QTY249  = @p_QTY249  ,X.QTY250  = @p_QTY250
                      ,X.QTY251 = @p_QTY251  ,X.QTY252  = @p_QTY252  ,X.QTY253  = @p_QTY253  ,X.QTY254  = @p_QTY254  ,X.QTY255  = @p_QTY255  
                      ,X.QTY256 = @p_QTY256  ,X.QTY257  = @p_QTY257  ,X.QTY258  = @p_QTY258  ,X.QTY259  = @p_QTY259  ,X.QTY260  = @p_QTY260
                      ,X.QTY261 = @p_QTY261  ,X.QTY262  = @p_QTY262  ,X.QTY263  = @p_QTY263  ,X.QTY264  = @p_QTY264  ,X.QTY265  = @p_QTY265  
                      ,X.QTY266 = @p_QTY266  ,X.QTY267  = @p_QTY267  ,X.QTY268  = @p_QTY268  ,X.QTY269  = @p_QTY269  ,X.QTY270  = @p_QTY270
                      ,X.QTY271 = @p_QTY271  ,X.QTY272  = @p_QTY272  ,X.QTY273  = @p_QTY273  ,X.QTY274  = @p_QTY274  ,X.QTY275  = @p_QTY275  
                      ,X.QTY276 = @p_QTY276  ,X.QTY277  = @p_QTY277  ,X.QTY278  = @p_QTY278  ,X.QTY279  = @p_QTY279  ,X.QTY280  = @p_QTY280
                      ,X.QTY281 = @p_QTY281  ,X.QTY282  = @p_QTY282  ,X.QTY283  = @p_QTY283  ,X.QTY284  = @p_QTY284  ,X.QTY285  = @p_QTY285  
                      ,X.QTY286 = @p_QTY286  ,X.QTY287  = @p_QTY287  ,X.QTY288  = @p_QTY288  ,X.QTY289  = @p_QTY289  ,X.QTY290  = @p_QTY290
                      ,X.QTY291 = @p_QTY291  ,X.QTY292  = @p_QTY292  ,X.QTY293  = @p_QTY293  ,X.QTY294  = @p_QTY294  ,X.QTY295  = @p_QTY295  
                      ,X.QTY296 = @p_QTY296  ,X.QTY297  = @p_QTY297  ,X.QTY298  = @p_QTY298  ,X.QTY299  = @p_QTY299  ,X.QTY300  = @p_QTY300

                      ,X.QTY301 = @p_QTY301  ,X.QTY302  = @p_QTY302  ,X.QTY303  = @p_QTY303  ,X.QTY304  = @p_QTY304  ,X.QTY305  = @p_QTY305  
                      ,X.QTY306 = @p_QTY306  ,X.QTY307  = @p_QTY307  ,X.QTY308  = @p_QTY308  ,X.QTY309  = @p_QTY309  ,X.QTY310  = @p_QTY310
                      ,X.QTY311 = @p_QTY311  ,X.QTY312  = @p_QTY312  ,X.QTY313  = @p_QTY313  ,X.QTY314  = @p_QTY314  ,X.QTY315  = @p_QTY315  
                      ,X.QTY316 = @p_QTY316  ,X.QTY317  = @p_QTY317  ,X.QTY318  = @p_QTY318  ,X.QTY319  = @p_QTY319  ,X.QTY320  = @p_QTY320
                      ,X.QTY321 = @p_QTY321  ,X.QTY322  = @p_QTY322  ,X.QTY323  = @p_QTY323  ,X.QTY324  = @p_QTY324  ,X.QTY325  = @p_QTY325  
                      ,X.QTY326 = @p_QTY326  ,X.QTY327  = @p_QTY327  ,X.QTY328  = @p_QTY328  ,X.QTY329  = @p_QTY329  ,X.QTY330  = @p_QTY330
                      ,X.QTY331 = @p_QTY331  ,X.QTY332  = @p_QTY332  ,X.QTY333  = @p_QTY333  ,X.QTY334  = @p_QTY334  ,X.QTY335  = @p_QTY335  
                      ,X.QTY336 = @p_QTY336  ,X.QTY337  = @p_QTY337  ,X.QTY338  = @p_QTY338  ,X.QTY339  = @p_QTY339  ,X.QTY340  = @p_QTY340
                      ,X.QTY341 = @p_QTY341  ,X.QTY342  = @p_QTY342  ,X.QTY343  = @p_QTY343  ,X.QTY344  = @p_QTY344  ,X.QTY345  = @p_QTY345  
                      ,X.QTY346 = @p_QTY346  ,X.QTY347  = @p_QTY347  ,X.QTY348  = @p_QTY348  ,X.QTY349  = @p_QTY349  ,X.QTY350  = @p_QTY350
                      ,X.QTY351 = @p_QTY351  ,X.QTY352  = @p_QTY352  ,X.QTY353  = @p_QTY353  ,X.QTY354  = @p_QTY354  ,X.QTY355  = @p_QTY355  
                      ,X.QTY356 = @p_QTY356  ,X.QTY357  = @p_QTY357  ,X.QTY358  = @p_QTY358  ,X.QTY359  = @p_QTY359  ,X.QTY360  = @p_QTY360
                      ,X.QTY361 = @p_QTY361  ,X.QTY362  = @p_QTY362  ,X.QTY363  = @p_QTY363  ,X.QTY364  = @p_QTY364 
               FROM #DAY_SCP_XLS_PSI_GLOBAL X
			  WHERE 1=1
			    AND DIVISION_ID         = @v_batch_division_id
				AND CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
                AND XLS_KEY1            = @v_batch_xls_key1 
               ;
            END
			
		    -- SELECT '#DAY_SCP_XLS_PSI_GLOBAL_2' TN , * FROM #DAY_SCP_XLS_PSI_GLOBAL --TEST

			-- RETURN --TEST
		   
			-------------------------------------------------------------------------------------------------------------
			-- 2022.04.05   KSW            Daily/Monthly Bucket 변경건 적용 :: 변경된 Daily 건만 저장하는 로직추가
			-- 입력값이 -9 (변경건 아님) 일때 DB 값으로 사용
			-------------------------------------------------------------------------------------------------------------
			BEGIN
				IF @p_QTY001 = -9 SET @p_QTY001	= @X_QTY001;
				IF @p_QTY002 = -9 SET @p_QTY002	= @X_QTY002;
				IF @p_QTY003 = -9 SET @p_QTY003	= @X_QTY003;
				IF @p_QTY004 = -9 SET @p_QTY004	= @X_QTY004;
				IF @p_QTY005 = -9 SET @p_QTY005	= @X_QTY005;
				IF @p_QTY006 = -9 SET @p_QTY006	= @X_QTY006;
				IF @p_QTY007 = -9 SET @p_QTY007	= @X_QTY007;
				IF @p_QTY008 = -9 SET @p_QTY008	= @X_QTY008;
				IF @p_QTY009 = -9 SET @p_QTY009	= @X_QTY009;
				IF @p_QTY010 = -9 SET @p_QTY010	= @X_QTY010;
				IF @p_QTY011 = -9 SET @p_QTY011	= @X_QTY011;
				IF @p_QTY012 = -9 SET @p_QTY012	= @X_QTY012;
				IF @p_QTY013 = -9 SET @p_QTY013	= @X_QTY013;
				IF @p_QTY014 = -9 SET @p_QTY014	= @X_QTY014;
				IF @p_QTY015 = -9 SET @p_QTY015	= @X_QTY015;
				IF @p_QTY016 = -9 SET @p_QTY016	= @X_QTY016;
				IF @p_QTY017 = -9 SET @p_QTY017	= @X_QTY017;
				IF @p_QTY018 = -9 SET @p_QTY018	= @X_QTY018;
				IF @p_QTY019 = -9 SET @p_QTY019	= @X_QTY019;
				IF @p_QTY020 = -9 SET @p_QTY020	= @X_QTY020;
				IF @p_QTY021 = -9 SET @p_QTY021	= @X_QTY021;
				IF @p_QTY022 = -9 SET @p_QTY022	= @X_QTY022;
				IF @p_QTY023 = -9 SET @p_QTY023	= @X_QTY023;
				IF @p_QTY024 = -9 SET @p_QTY024	= @X_QTY024;
				IF @p_QTY025 = -9 SET @p_QTY025	= @X_QTY025;
				IF @p_QTY026 = -9 SET @p_QTY026	= @X_QTY026;
				IF @p_QTY027 = -9 SET @p_QTY027	= @X_QTY027;
				IF @p_QTY028 = -9 SET @p_QTY028	= @X_QTY028;
				IF @p_QTY029 = -9 SET @p_QTY029	= @X_QTY029;
				IF @p_QTY030 = -9 SET @p_QTY030	= @X_QTY030;
				IF @p_QTY031 = -9 SET @p_QTY031	= @X_QTY031;
				IF @p_QTY032 = -9 SET @p_QTY032	= @X_QTY032;
				IF @p_QTY033 = -9 SET @p_QTY033	= @X_QTY033;
				IF @p_QTY034 = -9 SET @p_QTY034	= @X_QTY034;
				IF @p_QTY035 = -9 SET @p_QTY035	= @X_QTY035;
				IF @p_QTY036 = -9 SET @p_QTY036	= @X_QTY036;
				IF @p_QTY037 = -9 SET @p_QTY037	= @X_QTY037;
				IF @p_QTY038 = -9 SET @p_QTY038	= @X_QTY038;
				IF @p_QTY039 = -9 SET @p_QTY039	= @X_QTY039;
				IF @p_QTY040 = -9 SET @p_QTY040	= @X_QTY040;
				IF @p_QTY041 = -9 SET @p_QTY041	= @X_QTY041;
				IF @p_QTY042 = -9 SET @p_QTY042	= @X_QTY042;
				IF @p_QTY043 = -9 SET @p_QTY043	= @X_QTY043;
				IF @p_QTY044 = -9 SET @p_QTY044	= @X_QTY044;
				IF @p_QTY045 = -9 SET @p_QTY045	= @X_QTY045;
				IF @p_QTY046 = -9 SET @p_QTY046	= @X_QTY046;
				IF @p_QTY047 = -9 SET @p_QTY047	= @X_QTY047;
				IF @p_QTY048 = -9 SET @p_QTY048	= @X_QTY048;
				IF @p_QTY049 = -9 SET @p_QTY049	= @X_QTY049;
				IF @p_QTY050 = -9 SET @p_QTY050	= @X_QTY050;
				IF @p_QTY051 = -9 SET @p_QTY051	= @X_QTY051;
				IF @p_QTY052 = -9 SET @p_QTY052	= @X_QTY052;
				IF @p_QTY053 = -9 SET @p_QTY053	= @X_QTY053;
				IF @p_QTY054 = -9 SET @p_QTY054	= @X_QTY054;
				IF @p_QTY055 = -9 SET @p_QTY055	= @X_QTY055;
				IF @p_QTY056 = -9 SET @p_QTY056	= @X_QTY056;
				IF @p_QTY057 = -9 SET @p_QTY057	= @X_QTY057;
				IF @p_QTY058 = -9 SET @p_QTY058	= @X_QTY058;
				IF @p_QTY059 = -9 SET @p_QTY059	= @X_QTY059;
				IF @p_QTY060 = -9 SET @p_QTY060	= @X_QTY060;
				IF @p_QTY061 = -9 SET @p_QTY061	= @X_QTY061;
				IF @p_QTY062 = -9 SET @p_QTY062	= @X_QTY062;
				IF @p_QTY063 = -9 SET @p_QTY063	= @X_QTY063;
				IF @p_QTY064 = -9 SET @p_QTY064	= @X_QTY064;
				IF @p_QTY065 = -9 SET @p_QTY065	= @X_QTY065;
				IF @p_QTY066 = -9 SET @p_QTY066	= @X_QTY066;
				IF @p_QTY067 = -9 SET @p_QTY067	= @X_QTY067;
				IF @p_QTY068 = -9 SET @p_QTY068	= @X_QTY068;
				IF @p_QTY069 = -9 SET @p_QTY069	= @X_QTY069;
				IF @p_QTY070 = -9 SET @p_QTY070	= @X_QTY070;
				IF @p_QTY071 = -9 SET @p_QTY071	= @X_QTY071;
				IF @p_QTY072 = -9 SET @p_QTY072	= @X_QTY072;
				IF @p_QTY073 = -9 SET @p_QTY073	= @X_QTY073;
				IF @p_QTY074 = -9 SET @p_QTY074	= @X_QTY074;
				IF @p_QTY075 = -9 SET @p_QTY075	= @X_QTY075;
				IF @p_QTY076 = -9 SET @p_QTY076	= @X_QTY076;
				IF @p_QTY077 = -9 SET @p_QTY077	= @X_QTY077;
				IF @p_QTY078 = -9 SET @p_QTY078	= @X_QTY078;
				IF @p_QTY079 = -9 SET @p_QTY079	= @X_QTY079;
				IF @p_QTY080 = -9 SET @p_QTY080	= @X_QTY080;
				IF @p_QTY081 = -9 SET @p_QTY081	= @X_QTY081;
				IF @p_QTY082 = -9 SET @p_QTY082	= @X_QTY082;
				IF @p_QTY083 = -9 SET @p_QTY083	= @X_QTY083;
				IF @p_QTY084 = -9 SET @p_QTY084	= @X_QTY084;
				IF @p_QTY085 = -9 SET @p_QTY085	= @X_QTY085;
				IF @p_QTY086 = -9 SET @p_QTY086	= @X_QTY086;
				IF @p_QTY087 = -9 SET @p_QTY087	= @X_QTY087;
				IF @p_QTY088 = -9 SET @p_QTY088	= @X_QTY088;
				IF @p_QTY089 = -9 SET @p_QTY089	= @X_QTY089;
				IF @p_QTY090 = -9 SET @p_QTY090	= @X_QTY090;
				IF @p_QTY091 = -9 SET @p_QTY091	= @X_QTY091;
				IF @p_QTY092 = -9 SET @p_QTY092	= @X_QTY092;
				IF @p_QTY093 = -9 SET @p_QTY093	= @X_QTY093;
				IF @p_QTY094 = -9 SET @p_QTY094	= @X_QTY094;
				IF @p_QTY095 = -9 SET @p_QTY095	= @X_QTY095;
				IF @p_QTY096 = -9 SET @p_QTY096	= @X_QTY096;
				IF @p_QTY097 = -9 SET @p_QTY097	= @X_QTY097;
				IF @p_QTY098 = -9 SET @p_QTY098	= @X_QTY098;
				IF @p_QTY099 = -9 SET @p_QTY099	= @X_QTY099;
				IF @p_QTY100 = -9 SET @p_QTY100	= @X_QTY100;
				IF @p_QTY101 = -9 SET @p_QTY101	= @X_QTY101;
				IF @p_QTY102 = -9 SET @p_QTY102	= @X_QTY102;
				IF @p_QTY103 = -9 SET @p_QTY103	= @X_QTY103;
				IF @p_QTY104 = -9 SET @p_QTY104	= @X_QTY104;
				IF @p_QTY105 = -9 SET @p_QTY105	= @X_QTY105;
				IF @p_QTY106 = -9 SET @p_QTY106	= @X_QTY106;
				IF @p_QTY107 = -9 SET @p_QTY107	= @X_QTY107;
				IF @p_QTY108 = -9 SET @p_QTY108	= @X_QTY108;
				IF @p_QTY109 = -9 SET @p_QTY109	= @X_QTY109;
				IF @p_QTY110 = -9 SET @p_QTY110	= @X_QTY110;
				IF @p_QTY111 = -9 SET @p_QTY111	= @X_QTY111;
				IF @p_QTY112 = -9 SET @p_QTY112	= @X_QTY112;
				IF @p_QTY113 = -9 SET @p_QTY113	= @X_QTY113;
				IF @p_QTY114 = -9 SET @p_QTY114	= @X_QTY114;
				IF @p_QTY115 = -9 SET @p_QTY115	= @X_QTY115;
				IF @p_QTY116 = -9 SET @p_QTY116	= @X_QTY116;
				IF @p_QTY117 = -9 SET @p_QTY117	= @X_QTY117;
				IF @p_QTY118 = -9 SET @p_QTY118	= @X_QTY118;
				IF @p_QTY119 = -9 SET @p_QTY119	= @X_QTY119;
				IF @p_QTY120 = -9 SET @p_QTY120	= @X_QTY120;
				IF @p_QTY121 = -9 SET @p_QTY121	= @X_QTY121;
				IF @p_QTY122 = -9 SET @p_QTY122	= @X_QTY122;
				IF @p_QTY123 = -9 SET @p_QTY123	= @X_QTY123;
				IF @p_QTY124 = -9 SET @p_QTY124	= @X_QTY124;
				IF @p_QTY125 = -9 SET @p_QTY125	= @X_QTY125;
				IF @p_QTY126 = -9 SET @p_QTY126	= @X_QTY126;
				IF @p_QTY127 = -9 SET @p_QTY127	= @X_QTY127;
				IF @p_QTY128 = -9 SET @p_QTY128	= @X_QTY128;
				IF @p_QTY129 = -9 SET @p_QTY129	= @X_QTY129;
				IF @p_QTY130 = -9 SET @p_QTY130	= @X_QTY130;
				IF @p_QTY131 = -9 SET @p_QTY131	= @X_QTY131;
				IF @p_QTY132 = -9 SET @p_QTY132	= @X_QTY132;
				IF @p_QTY133 = -9 SET @p_QTY133	= @X_QTY133;
				IF @p_QTY134 = -9 SET @p_QTY134	= @X_QTY134;
				IF @p_QTY135 = -9 SET @p_QTY135	= @X_QTY135;
				IF @p_QTY136 = -9 SET @p_QTY136	= @X_QTY136;
				IF @p_QTY137 = -9 SET @p_QTY137	= @X_QTY137;
				IF @p_QTY138 = -9 SET @p_QTY138	= @X_QTY138;
				IF @p_QTY139 = -9 SET @p_QTY139	= @X_QTY139;
				IF @p_QTY140 = -9 SET @p_QTY140	= @X_QTY140;
				IF @p_QTY141 = -9 SET @p_QTY141	= @X_QTY141;
				IF @p_QTY142 = -9 SET @p_QTY142	= @X_QTY142;
				IF @p_QTY143 = -9 SET @p_QTY143	= @X_QTY143;
				IF @p_QTY144 = -9 SET @p_QTY144	= @X_QTY144;
				IF @p_QTY145 = -9 SET @p_QTY145	= @X_QTY145;
				IF @p_QTY146 = -9 SET @p_QTY146	= @X_QTY146;
				IF @p_QTY147 = -9 SET @p_QTY147	= @X_QTY147;
				IF @p_QTY148 = -9 SET @p_QTY148	= @X_QTY148;
				IF @p_QTY149 = -9 SET @p_QTY149	= @X_QTY149;
				IF @p_QTY150 = -9 SET @p_QTY150	= @X_QTY150;
				IF @p_QTY151 = -9 SET @p_QTY151	= @X_QTY151;
				IF @p_QTY152 = -9 SET @p_QTY152	= @X_QTY152;
				IF @p_QTY153 = -9 SET @p_QTY153	= @X_QTY153;
				IF @p_QTY154 = -9 SET @p_QTY154	= @X_QTY154;
				IF @p_QTY155 = -9 SET @p_QTY155	= @X_QTY155;
				IF @p_QTY156 = -9 SET @p_QTY156	= @X_QTY156;
				IF @p_QTY157 = -9 SET @p_QTY157	= @X_QTY157;
				IF @p_QTY158 = -9 SET @p_QTY158	= @X_QTY158;
				IF @p_QTY159 = -9 SET @p_QTY159	= @X_QTY159;
				IF @p_QTY160 = -9 SET @p_QTY160	= @X_QTY160;
				IF @p_QTY161 = -9 SET @p_QTY161	= @X_QTY161;
				IF @p_QTY162 = -9 SET @p_QTY162	= @X_QTY162;
				IF @p_QTY163 = -9 SET @p_QTY163	= @X_QTY163;
				IF @p_QTY164 = -9 SET @p_QTY164	= @X_QTY164;
				IF @p_QTY165 = -9 SET @p_QTY165	= @X_QTY165;
				IF @p_QTY166 = -9 SET @p_QTY166	= @X_QTY166;
				IF @p_QTY167 = -9 SET @p_QTY167	= @X_QTY167;
				IF @p_QTY168 = -9 SET @p_QTY168	= @X_QTY168;
				IF @p_QTY169 = -9 SET @p_QTY169	= @X_QTY169;
				IF @p_QTY170 = -9 SET @p_QTY170	= @X_QTY170;
				IF @p_QTY171 = -9 SET @p_QTY171	= @X_QTY171;
				IF @p_QTY172 = -9 SET @p_QTY172	= @X_QTY172;
				IF @p_QTY173 = -9 SET @p_QTY173	= @X_QTY173;
				IF @p_QTY174 = -9 SET @p_QTY174	= @X_QTY174;
				IF @p_QTY175 = -9 SET @p_QTY175	= @X_QTY175;
				IF @p_QTY176 = -9 SET @p_QTY176	= @X_QTY176;
				IF @p_QTY177 = -9 SET @p_QTY177	= @X_QTY177;
				IF @p_QTY178 = -9 SET @p_QTY178	= @X_QTY178;
				IF @p_QTY179 = -9 SET @p_QTY179	= @X_QTY179;
				IF @p_QTY180 = -9 SET @p_QTY180	= @X_QTY180;
				IF @p_QTY181 = -9 SET @p_QTY181	= @X_QTY181;
				IF @p_QTY182 = -9 SET @p_QTY182	= @X_QTY182;
				IF @p_QTY183 = -9 SET @p_QTY183	= @X_QTY183;
				IF @p_QTY184 = -9 SET @p_QTY184	= @X_QTY184;
				IF @p_QTY185 = -9 SET @p_QTY185	= @X_QTY185;
				IF @p_QTY186 = -9 SET @p_QTY186	= @X_QTY186;
				IF @p_QTY187 = -9 SET @p_QTY187	= @X_QTY187;
				IF @p_QTY188 = -9 SET @p_QTY188	= @X_QTY188;
				IF @p_QTY189 = -9 SET @p_QTY189	= @X_QTY189;
				IF @p_QTY190 = -9 SET @p_QTY190	= @X_QTY190;
				IF @p_QTY191 = -9 SET @p_QTY191	= @X_QTY191;
				IF @p_QTY192 = -9 SET @p_QTY192	= @X_QTY192;
				IF @p_QTY193 = -9 SET @p_QTY193	= @X_QTY193;
				IF @p_QTY194 = -9 SET @p_QTY194	= @X_QTY194;
				IF @p_QTY195 = -9 SET @p_QTY195	= @X_QTY195;
				IF @p_QTY196 = -9 SET @p_QTY196	= @X_QTY196;
				IF @p_QTY197 = -9 SET @p_QTY197	= @X_QTY197;
				IF @p_QTY198 = -9 SET @p_QTY198	= @X_QTY198;
				IF @p_QTY199 = -9 SET @p_QTY199	= @X_QTY199;
				IF @p_QTY200 = -9 SET @p_QTY200	= @X_QTY200;
				IF @p_QTY201 = -9 SET @p_QTY201	= @X_QTY201;
				IF @p_QTY202 = -9 SET @p_QTY202	= @X_QTY202;
				IF @p_QTY203 = -9 SET @p_QTY203	= @X_QTY203;
				IF @p_QTY204 = -9 SET @p_QTY204	= @X_QTY204;
				IF @p_QTY205 = -9 SET @p_QTY205	= @X_QTY205;
				IF @p_QTY206 = -9 SET @p_QTY206	= @X_QTY206;
				IF @p_QTY207 = -9 SET @p_QTY207	= @X_QTY207;
				IF @p_QTY208 = -9 SET @p_QTY208	= @X_QTY208;
				IF @p_QTY209 = -9 SET @p_QTY209	= @X_QTY209;
				IF @p_QTY210 = -9 SET @p_QTY210	= @X_QTY210;
				IF @p_QTY211 = -9 SET @p_QTY211	= @X_QTY211;
				IF @p_QTY212 = -9 SET @p_QTY212	= @X_QTY212;
				IF @p_QTY213 = -9 SET @p_QTY213	= @X_QTY213;
				IF @p_QTY214 = -9 SET @p_QTY214	= @X_QTY214;
				IF @p_QTY215 = -9 SET @p_QTY215	= @X_QTY215;
				IF @p_QTY216 = -9 SET @p_QTY216	= @X_QTY216;
				IF @p_QTY217 = -9 SET @p_QTY217	= @X_QTY217;
				IF @p_QTY218 = -9 SET @p_QTY218	= @X_QTY218;
				IF @p_QTY219 = -9 SET @p_QTY219	= @X_QTY219;
				IF @p_QTY220 = -9 SET @p_QTY220	= @X_QTY220;
				IF @p_QTY221 = -9 SET @p_QTY221	= @X_QTY221;
				IF @p_QTY222 = -9 SET @p_QTY222	= @X_QTY222;
				IF @p_QTY223 = -9 SET @p_QTY223	= @X_QTY223;
				IF @p_QTY224 = -9 SET @p_QTY224	= @X_QTY224;
				IF @p_QTY225 = -9 SET @p_QTY225	= @X_QTY225;
				IF @p_QTY226 = -9 SET @p_QTY226	= @X_QTY226;
				IF @p_QTY227 = -9 SET @p_QTY227	= @X_QTY227;
				IF @p_QTY228 = -9 SET @p_QTY228	= @X_QTY228;
				IF @p_QTY229 = -9 SET @p_QTY229	= @X_QTY229;
				IF @p_QTY230 = -9 SET @p_QTY230	= @X_QTY230;
				IF @p_QTY231 = -9 SET @p_QTY231	= @X_QTY231;
				IF @p_QTY232 = -9 SET @p_QTY232	= @X_QTY232;
				IF @p_QTY233 = -9 SET @p_QTY233	= @X_QTY233;
				IF @p_QTY234 = -9 SET @p_QTY234	= @X_QTY234;
				IF @p_QTY235 = -9 SET @p_QTY235	= @X_QTY235;
				IF @p_QTY236 = -9 SET @p_QTY236	= @X_QTY236;
				IF @p_QTY237 = -9 SET @p_QTY237	= @X_QTY237;
				IF @p_QTY238 = -9 SET @p_QTY238	= @X_QTY238;
				IF @p_QTY239 = -9 SET @p_QTY239	= @X_QTY239;
				IF @p_QTY240 = -9 SET @p_QTY240	= @X_QTY240;
				IF @p_QTY241 = -9 SET @p_QTY241	= @X_QTY241;
				IF @p_QTY242 = -9 SET @p_QTY242	= @X_QTY242;
				IF @p_QTY243 = -9 SET @p_QTY243	= @X_QTY243;
				IF @p_QTY244 = -9 SET @p_QTY244	= @X_QTY244;
				IF @p_QTY245 = -9 SET @p_QTY245	= @X_QTY245;
				IF @p_QTY246 = -9 SET @p_QTY246	= @X_QTY246;
				IF @p_QTY247 = -9 SET @p_QTY247	= @X_QTY247;
				IF @p_QTY248 = -9 SET @p_QTY248	= @X_QTY248;
				IF @p_QTY249 = -9 SET @p_QTY249	= @X_QTY249;
				IF @p_QTY250 = -9 SET @p_QTY250	= @X_QTY250;
				IF @p_QTY251 = -9 SET @p_QTY251	= @X_QTY251;
				IF @p_QTY252 = -9 SET @p_QTY252	= @X_QTY252;
				IF @p_QTY253 = -9 SET @p_QTY253	= @X_QTY253;
				IF @p_QTY254 = -9 SET @p_QTY254	= @X_QTY254;
				IF @p_QTY255 = -9 SET @p_QTY255	= @X_QTY255;
				IF @p_QTY256 = -9 SET @p_QTY256	= @X_QTY256;
				IF @p_QTY257 = -9 SET @p_QTY257	= @X_QTY257;
				IF @p_QTY258 = -9 SET @p_QTY258	= @X_QTY258;
				IF @p_QTY259 = -9 SET @p_QTY259	= @X_QTY259;
				IF @p_QTY260 = -9 SET @p_QTY260	= @X_QTY260;
				IF @p_QTY261 = -9 SET @p_QTY261	= @X_QTY261;
				IF @p_QTY262 = -9 SET @p_QTY262	= @X_QTY262;
				IF @p_QTY263 = -9 SET @p_QTY263	= @X_QTY263;
				IF @p_QTY264 = -9 SET @p_QTY264	= @X_QTY264;
				IF @p_QTY265 = -9 SET @p_QTY265	= @X_QTY265;
				IF @p_QTY266 = -9 SET @p_QTY266	= @X_QTY266;
				IF @p_QTY267 = -9 SET @p_QTY267	= @X_QTY267;
				IF @p_QTY268 = -9 SET @p_QTY268	= @X_QTY268;
				IF @p_QTY269 = -9 SET @p_QTY269	= @X_QTY269;
				IF @p_QTY270 = -9 SET @p_QTY270	= @X_QTY270;
				IF @p_QTY271 = -9 SET @p_QTY271	= @X_QTY271;
				IF @p_QTY272 = -9 SET @p_QTY272	= @X_QTY272;
				IF @p_QTY273 = -9 SET @p_QTY273	= @X_QTY273;
				IF @p_QTY274 = -9 SET @p_QTY274	= @X_QTY274;
				IF @p_QTY275 = -9 SET @p_QTY275	= @X_QTY275;
				IF @p_QTY276 = -9 SET @p_QTY276	= @X_QTY276;
				IF @p_QTY277 = -9 SET @p_QTY277	= @X_QTY277;
				IF @p_QTY278 = -9 SET @p_QTY278	= @X_QTY278;
				IF @p_QTY279 = -9 SET @p_QTY279	= @X_QTY279;
				IF @p_QTY280 = -9 SET @p_QTY280	= @X_QTY280;
				IF @p_QTY281 = -9 SET @p_QTY281	= @X_QTY281;
				IF @p_QTY282 = -9 SET @p_QTY282	= @X_QTY282;
				IF @p_QTY283 = -9 SET @p_QTY283	= @X_QTY283;
				IF @p_QTY284 = -9 SET @p_QTY284	= @X_QTY284;
				IF @p_QTY285 = -9 SET @p_QTY285	= @X_QTY285;
				IF @p_QTY286 = -9 SET @p_QTY286	= @X_QTY286;
				IF @p_QTY287 = -9 SET @p_QTY287	= @X_QTY287;
				IF @p_QTY288 = -9 SET @p_QTY288	= @X_QTY288;
				IF @p_QTY289 = -9 SET @p_QTY289	= @X_QTY289;
				IF @p_QTY290 = -9 SET @p_QTY290	= @X_QTY290;
				IF @p_QTY291 = -9 SET @p_QTY291	= @X_QTY291;
				IF @p_QTY292 = -9 SET @p_QTY292	= @X_QTY292;
				IF @p_QTY293 = -9 SET @p_QTY293	= @X_QTY293;
				IF @p_QTY294 = -9 SET @p_QTY294	= @X_QTY294;
				IF @p_QTY295 = -9 SET @p_QTY295	= @X_QTY295;
				IF @p_QTY296 = -9 SET @p_QTY296	= @X_QTY296;
				IF @p_QTY297 = -9 SET @p_QTY297	= @X_QTY297;
				IF @p_QTY298 = -9 SET @p_QTY298	= @X_QTY298;
				IF @p_QTY299 = -9 SET @p_QTY299	= @X_QTY299;
				IF @p_QTY300 = -9 SET @p_QTY300	= @X_QTY300;
				IF @p_QTY301 = -9 SET @p_QTY301	= @X_QTY301;
				IF @p_QTY302 = -9 SET @p_QTY302	= @X_QTY302;
				IF @p_QTY303 = -9 SET @p_QTY303	= @X_QTY303;
				IF @p_QTY304 = -9 SET @p_QTY304	= @X_QTY304;
				IF @p_QTY305 = -9 SET @p_QTY305	= @X_QTY305;
				IF @p_QTY306 = -9 SET @p_QTY306	= @X_QTY306;
				IF @p_QTY307 = -9 SET @p_QTY307	= @X_QTY307;
				IF @p_QTY308 = -9 SET @p_QTY308	= @X_QTY308;
				IF @p_QTY309 = -9 SET @p_QTY309	= @X_QTY309;
				IF @p_QTY310 = -9 SET @p_QTY310	= @X_QTY310;
				IF @p_QTY311 = -9 SET @p_QTY311	= @X_QTY311;
				IF @p_QTY312 = -9 SET @p_QTY312	= @X_QTY312;
				IF @p_QTY313 = -9 SET @p_QTY313	= @X_QTY313;
				IF @p_QTY314 = -9 SET @p_QTY314	= @X_QTY314;
				IF @p_QTY315 = -9 SET @p_QTY315	= @X_QTY315;
				IF @p_QTY316 = -9 SET @p_QTY316	= @X_QTY316;
				IF @p_QTY317 = -9 SET @p_QTY317	= @X_QTY317;
				IF @p_QTY318 = -9 SET @p_QTY318	= @X_QTY318;
				IF @p_QTY319 = -9 SET @p_QTY319	= @X_QTY319;
				IF @p_QTY320 = -9 SET @p_QTY320	= @X_QTY320;
				IF @p_QTY321 = -9 SET @p_QTY321	= @X_QTY321;
				IF @p_QTY322 = -9 SET @p_QTY322	= @X_QTY322;
				IF @p_QTY323 = -9 SET @p_QTY323	= @X_QTY323;
				IF @p_QTY324 = -9 SET @p_QTY324	= @X_QTY324;
				IF @p_QTY325 = -9 SET @p_QTY325	= @X_QTY325;
				IF @p_QTY326 = -9 SET @p_QTY326	= @X_QTY326;
				IF @p_QTY327 = -9 SET @p_QTY327	= @X_QTY327;
				IF @p_QTY328 = -9 SET @p_QTY328	= @X_QTY328;
				IF @p_QTY329 = -9 SET @p_QTY329	= @X_QTY329;
				IF @p_QTY330 = -9 SET @p_QTY330	= @X_QTY330;
				IF @p_QTY331 = -9 SET @p_QTY331	= @X_QTY331;
				IF @p_QTY332 = -9 SET @p_QTY332	= @X_QTY332;
				IF @p_QTY333 = -9 SET @p_QTY333	= @X_QTY333;
				IF @p_QTY334 = -9 SET @p_QTY334	= @X_QTY334;
				IF @p_QTY335 = -9 SET @p_QTY335	= @X_QTY335;
				IF @p_QTY336 = -9 SET @p_QTY336	= @X_QTY336;
				IF @p_QTY337 = -9 SET @p_QTY337	= @X_QTY337;
				IF @p_QTY338 = -9 SET @p_QTY338	= @X_QTY338;
				IF @p_QTY339 = -9 SET @p_QTY339	= @X_QTY339;
				IF @p_QTY340 = -9 SET @p_QTY340	= @X_QTY340;
				IF @p_QTY341 = -9 SET @p_QTY341	= @X_QTY341;
				IF @p_QTY342 = -9 SET @p_QTY342	= @X_QTY342;
				IF @p_QTY343 = -9 SET @p_QTY343	= @X_QTY343;
				IF @p_QTY344 = -9 SET @p_QTY344	= @X_QTY344;
				IF @p_QTY345 = -9 SET @p_QTY345	= @X_QTY345;
				IF @p_QTY346 = -9 SET @p_QTY346	= @X_QTY346;
				IF @p_QTY347 = -9 SET @p_QTY347	= @X_QTY347;
				IF @p_QTY348 = -9 SET @p_QTY348	= @X_QTY348;
				IF @p_QTY349 = -9 SET @p_QTY349	= @X_QTY349;
				IF @p_QTY350 = -9 SET @p_QTY350	= @X_QTY350;
				IF @p_QTY351 = -9 SET @p_QTY351	= @X_QTY351;
				IF @p_QTY352 = -9 SET @p_QTY352	= @X_QTY352;
				IF @p_QTY353 = -9 SET @p_QTY353	= @X_QTY353;
				IF @p_QTY354 = -9 SET @p_QTY354	= @X_QTY354;
				IF @p_QTY355 = -9 SET @p_QTY355	= @X_QTY355;
				IF @p_QTY356 = -9 SET @p_QTY356	= @X_QTY356;
				IF @p_QTY357 = -9 SET @p_QTY357	= @X_QTY357;
				IF @p_QTY358 = -9 SET @p_QTY358	= @X_QTY358;
				IF @p_QTY359 = -9 SET @p_QTY359	= @X_QTY359;
				IF @p_QTY360 = -9 SET @p_QTY360	= @X_QTY360;
				IF @p_QTY361 = -9 SET @p_QTY361	= @X_QTY361;
				IF @p_QTY362 = -9 SET @p_QTY362	= @X_QTY362;
				IF @p_QTY363 = -9 SET @p_QTY363	= @X_QTY363;
				IF @p_QTY364 = -9 SET @p_QTY364	= @X_QTY364;

			END
            -------------------------------------------------------------------------------------------------------------
            -- SCP_XLS_PSI_GLOBAL_SMALL_PACK (XLSPSI02) 화면조회용 테이블에 해당 레코드를 수정한다.
            -------------------------------------------------------------------------------------------------------------
             -- PACK_PROD         --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND'
             -- SEMI_SHIP_PLAN, SHIP_PLAN   --> SHIP_PLAN_AMEND           


			-- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정
            --               - CELL_SHIP_PLAN (Ship Plan(SCP)) Measure 를 SEMI_SHIP_PLAN 에 준하여 처리하는 로직을 추가
			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 - SEMI_SHIP_PLAN case 추가
			--
			-- 2022.08.19 :: CELL_SHIP_PLAN + CELL_PKG_PLAN_OUT 합산수량 저장으로 인한 CELL_SHIP_PLAN 입력수량 백업 measure OLD_CELL_SHIP_PLAN 저장추가
			--

            IF @v_batch_measure IN  ('PACK_PROD','PACK_SHIP_PLAN','CELL_SHIP_PLAN', 'SEMI_SHIP_PLAN', 'OLD_CELL_SHIP_PLAN')    -- 'PACK_SHIP_PLAN','PACK_PROD','CELL_SHIP_PLAN' SCP_XLS_PSI_GLOBAL_SMALL_PACK 테이블에 저장만 처리함.
               BEGIN
            -------------------------------------------------------------------------------------------------------------         
            -- WEEK DATA를 DAY DATA로 반영  
            -- 확정 구간이 주에 포함될 경우 수정금지 구간을 제외하고, 일 배분해야 함.
            --  
            -------------------------------------------------------------------------------------------------------------   
                    UPDATE X
                        SET  
                             X.QTY001 = @p_QTY001  ,X.QTY002  = @p_QTY002  ,X.QTY003  = @p_QTY003  ,X.QTY004  = @p_QTY004  ,X.QTY005  = @p_QTY005  
                            ,X.QTY006 = @p_QTY006  ,X.QTY007  = @p_QTY007  ,X.QTY008  = @p_QTY008  ,X.QTY009  = @p_QTY009  ,X.QTY010  = @p_QTY010
                            ,X.QTY011 = @p_QTY011  ,X.QTY012  = @p_QTY012  ,X.QTY013  = @p_QTY013  ,X.QTY014  = @p_QTY014  ,X.QTY015  = @p_QTY015  
                            ,X.QTY016 = @p_QTY016  ,X.QTY017  = @p_QTY017  ,X.QTY018  = @p_QTY018  ,X.QTY019  = @p_QTY019  ,X.QTY020  = @p_QTY020
                            ,X.QTY021 = @p_QTY021  ,X.QTY022  = @p_QTY022  ,X.QTY023  = @p_QTY023  ,X.QTY024  = @p_QTY024  ,X.QTY025  = @p_QTY025  
                            ,X.QTY026 = @p_QTY026  ,X.QTY027  = @p_QTY027  ,X.QTY028  = @p_QTY028  ,X.QTY029  = @p_QTY029  ,X.QTY030  = @p_QTY030
                            ,X.QTY031 = @p_QTY031  ,X.QTY032  = @p_QTY032  ,X.QTY033  = @p_QTY033  ,X.QTY034  = @p_QTY034  ,X.QTY035  = @p_QTY035  
                            ,X.QTY036 = @p_QTY036  ,X.QTY037  = @p_QTY037  ,X.QTY038  = @p_QTY038  ,X.QTY039  = @p_QTY039  ,X.QTY040  = @p_QTY040
                            ,X.QTY041 = @p_QTY041  ,X.QTY042  = @p_QTY042  ,X.QTY043  = @p_QTY043  ,X.QTY044  = @p_QTY044  ,X.QTY045  = @p_QTY045  
                            ,X.QTY046 = @p_QTY046  ,X.QTY047  = @p_QTY047  ,X.QTY048  = @p_QTY048  ,X.QTY049  = @p_QTY049  ,X.QTY050  = @p_QTY050
                            ,X.QTY051 = @p_QTY051  ,X.QTY052  = @p_QTY052  ,X.QTY053  = @p_QTY053  ,X.QTY054  = @p_QTY054  ,X.QTY055  = @p_QTY055  
                            ,X.QTY056 = @p_QTY056  ,X.QTY057  = @p_QTY057  ,X.QTY058  = @p_QTY058  ,X.QTY059  = @p_QTY059  ,X.QTY060  = @p_QTY060
                            ,X.QTY061 = @p_QTY061  ,X.QTY062  = @p_QTY062  ,X.QTY063  = @p_QTY063  ,X.QTY064  = @p_QTY064  ,X.QTY065  = @p_QTY065  
                            ,X.QTY066 = @p_QTY066  ,X.QTY067  = @p_QTY067  ,X.QTY068  = @p_QTY068  ,X.QTY069  = @p_QTY069  ,X.QTY070  = @p_QTY070
                            ,X.QTY071 = @p_QTY071  ,X.QTY072  = @p_QTY072  ,X.QTY073  = @p_QTY073  ,X.QTY074  = @p_QTY074  ,X.QTY075  = @p_QTY075  
                            ,X.QTY076 = @p_QTY076  ,X.QTY077  = @p_QTY077  ,X.QTY078  = @p_QTY078  ,X.QTY079  = @p_QTY079  ,X.QTY080  = @p_QTY080
                            ,X.QTY081 = @p_QTY081  ,X.QTY082  = @p_QTY082  ,X.QTY083  = @p_QTY083  ,X.QTY084  = @p_QTY084  ,X.QTY085  = @p_QTY085  
                            ,X.QTY086 = @p_QTY086  ,X.QTY087  = @p_QTY087  ,X.QTY088  = @p_QTY088  ,X.QTY089  = @p_QTY089  ,X.QTY090  = @p_QTY090
                            ,X.QTY091 = @p_QTY091  ,X.QTY092  = @p_QTY092  ,X.QTY093  = @p_QTY093  ,X.QTY094  = @p_QTY094  ,X.QTY095  = @p_QTY095  
                            ,X.QTY096 = @p_QTY096  ,X.QTY097  = @p_QTY097  ,X.QTY098  = @p_QTY098  ,X.QTY099  = @p_QTY099  ,X.QTY100  = @p_QTY100

                            ,X.QTY101 = @p_QTY101  ,X.QTY102  = @p_QTY102  ,X.QTY103  = @p_QTY103  ,X.QTY104  = @p_QTY104  ,X.QTY105  = @p_QTY105  
                            ,X.QTY106 = @p_QTY106  ,X.QTY107  = @p_QTY107  ,X.QTY108  = @p_QTY108  ,X.QTY109  = @p_QTY109  ,X.QTY110  = @p_QTY110
                            ,X.QTY111 = @p_QTY111  ,X.QTY112  = @p_QTY112  ,X.QTY113  = @p_QTY113  ,X.QTY114  = @p_QTY114  ,X.QTY115  = @p_QTY115  
                            ,X.QTY116 = @p_QTY116  ,X.QTY117  = @p_QTY117  ,X.QTY118  = @p_QTY118  ,X.QTY119  = @p_QTY119  ,X.QTY120  = @p_QTY120
                            ,X.QTY121 = @p_QTY121  ,X.QTY122  = @p_QTY122  ,X.QTY123  = @p_QTY123  ,X.QTY124  = @p_QTY124  ,X.QTY125  = @p_QTY125  
                            ,X.QTY126 = @p_QTY126  ,X.QTY127  = @p_QTY127  ,X.QTY128  = @p_QTY128  ,X.QTY129  = @p_QTY129  ,X.QTY130  = @p_QTY130
                            ,X.QTY131 = @p_QTY131  ,X.QTY132  = @p_QTY132  ,X.QTY133  = @p_QTY133  ,X.QTY134  = @p_QTY134  ,X.QTY135  = @p_QTY135  
                            ,X.QTY136 = @p_QTY136  ,X.QTY137  = @p_QTY137  ,X.QTY138  = @p_QTY138  ,X.QTY139  = @p_QTY139  ,X.QTY140  = @p_QTY140
                            ,X.QTY141 = @p_QTY141  ,X.QTY142  = @p_QTY142  ,X.QTY143  = @p_QTY143  ,X.QTY144  = @p_QTY144  ,X.QTY145  = @p_QTY145  
                            ,X.QTY146 = @p_QTY146  ,X.QTY147  = @p_QTY147  ,X.QTY148  = @p_QTY148  ,X.QTY149  = @p_QTY149  ,X.QTY150  = @p_QTY150
                            ,X.QTY151 = @p_QTY151  ,X.QTY152  = @p_QTY152  ,X.QTY153  = @p_QTY153  ,X.QTY154  = @p_QTY154  ,X.QTY155  = @p_QTY155  
                            ,X.QTY156 = @p_QTY156  ,X.QTY157  = @p_QTY157  ,X.QTY158  = @p_QTY158  ,X.QTY159  = @p_QTY159  ,X.QTY160  = @p_QTY160
                            ,X.QTY161 = @p_QTY161  ,X.QTY162  = @p_QTY162  ,X.QTY163  = @p_QTY163  ,X.QTY164  = @p_QTY164  ,X.QTY165  = @p_QTY165  
                            ,X.QTY166 = @p_QTY166  ,X.QTY167  = @p_QTY167  ,X.QTY168  = @p_QTY168  ,X.QTY169  = @p_QTY169  ,X.QTY170  = @p_QTY170
                            ,X.QTY171 = @p_QTY171  ,X.QTY172  = @p_QTY172  ,X.QTY173  = @p_QTY173  ,X.QTY174  = @p_QTY174  ,X.QTY175  = @p_QTY175  
                            ,X.QTY176 = @p_QTY176  ,X.QTY177  = @p_QTY177  ,X.QTY178  = @p_QTY178  ,X.QTY179  = @p_QTY179  ,X.QTY180  = @p_QTY180
                            ,X.QTY181 = @p_QTY181  ,X.QTY182  = @p_QTY182  ,X.QTY183  = @p_QTY183  ,X.QTY184  = @p_QTY184  ,X.QTY185  = @p_QTY185  
                            ,X.QTY186 = @p_QTY186  ,X.QTY187  = @p_QTY187  ,X.QTY188  = @p_QTY188  ,X.QTY189  = @p_QTY189  ,X.QTY190  = @p_QTY190
                            ,X.QTY191 = @p_QTY191  ,X.QTY192  = @p_QTY192  ,X.QTY193  = @p_QTY193  ,X.QTY194  = @p_QTY194  ,X.QTY195  = @p_QTY195  
                            ,X.QTY196 = @p_QTY196  ,X.QTY197  = @p_QTY197  ,X.QTY198  = @p_QTY198  ,X.QTY199  = @p_QTY199  ,X.QTY200  = @p_QTY200

                            ,X.QTY201 = @p_QTY201  ,X.QTY202  = @p_QTY202  ,X.QTY203  = @p_QTY203  ,X.QTY204  = @p_QTY204  ,X.QTY205  = @p_QTY205  
                            ,X.QTY206 = @p_QTY206  ,X.QTY207  = @p_QTY207  ,X.QTY208  = @p_QTY208  ,X.QTY209  = @p_QTY209  ,X.QTY210  = @p_QTY210
                            ,X.QTY211 = @p_QTY211  ,X.QTY212  = @p_QTY212  ,X.QTY213  = @p_QTY213  ,X.QTY214  = @p_QTY214  ,X.QTY215  = @p_QTY215  
                            ,X.QTY216 = @p_QTY216  ,X.QTY217  = @p_QTY217  ,X.QTY218  = @p_QTY218  ,X.QTY219  = @p_QTY219  ,X.QTY220  = @p_QTY220
                            ,X.QTY221 = @p_QTY221  ,X.QTY222  = @p_QTY222  ,X.QTY223  = @p_QTY223  ,X.QTY224  = @p_QTY224  ,X.QTY225  = @p_QTY225  
                            ,X.QTY226 = @p_QTY226  ,X.QTY227  = @p_QTY227  ,X.QTY228  = @p_QTY228  ,X.QTY229  = @p_QTY229  ,X.QTY230  = @p_QTY230
                            ,X.QTY231 = @p_QTY231  ,X.QTY232  = @p_QTY232  ,X.QTY233  = @p_QTY233  ,X.QTY234  = @p_QTY234  ,X.QTY235  = @p_QTY235  
                            ,X.QTY236 = @p_QTY236  ,X.QTY237  = @p_QTY237  ,X.QTY238  = @p_QTY238  ,X.QTY239  = @p_QTY239  ,X.QTY240  = @p_QTY240
                            ,X.QTY241 = @p_QTY241  ,X.QTY242  = @p_QTY242  ,X.QTY243  = @p_QTY243  ,X.QTY244  = @p_QTY244  ,X.QTY245  = @p_QTY245  
                            ,X.QTY246 = @p_QTY246  ,X.QTY247  = @p_QTY247  ,X.QTY248  = @p_QTY248  ,X.QTY249  = @p_QTY249  ,X.QTY250  = @p_QTY250
                            ,X.QTY251 = @p_QTY251  ,X.QTY252  = @p_QTY252  ,X.QTY253  = @p_QTY253  ,X.QTY254  = @p_QTY254  ,X.QTY255  = @p_QTY255  
                            ,X.QTY256 = @p_QTY256  ,X.QTY257  = @p_QTY257  ,X.QTY258  = @p_QTY258  ,X.QTY259  = @p_QTY259  ,X.QTY260  = @p_QTY260
                            ,X.QTY261 = @p_QTY261  ,X.QTY262  = @p_QTY262  ,X.QTY263  = @p_QTY263  ,X.QTY264  = @p_QTY264  ,X.QTY265  = @p_QTY265  
                            ,X.QTY266 = @p_QTY266  ,X.QTY267  = @p_QTY267  ,X.QTY268  = @p_QTY268  ,X.QTY269  = @p_QTY269  ,X.QTY270  = @p_QTY270
                            ,X.QTY271 = @p_QTY271  ,X.QTY272  = @p_QTY272  ,X.QTY273  = @p_QTY273  ,X.QTY274  = @p_QTY274  ,X.QTY275  = @p_QTY275  
                            ,X.QTY276 = @p_QTY276  ,X.QTY277  = @p_QTY277  ,X.QTY278  = @p_QTY278  ,X.QTY279  = @p_QTY279  ,X.QTY280  = @p_QTY280
                            ,X.QTY281 = @p_QTY281  ,X.QTY282  = @p_QTY282  ,X.QTY283  = @p_QTY283  ,X.QTY284  = @p_QTY284  ,X.QTY285  = @p_QTY285  
                            ,X.QTY286 = @p_QTY286  ,X.QTY287  = @p_QTY287  ,X.QTY288  = @p_QTY288  ,X.QTY289  = @p_QTY289  ,X.QTY290  = @p_QTY290
                            ,X.QTY291 = @p_QTY291  ,X.QTY292  = @p_QTY292  ,X.QTY293  = @p_QTY293  ,X.QTY294  = @p_QTY294  ,X.QTY295  = @p_QTY295  
                            ,X.QTY296 = @p_QTY296  ,X.QTY297  = @p_QTY297  ,X.QTY298  = @p_QTY298  ,X.QTY299  = @p_QTY299  ,X.QTY300  = @p_QTY300

                            ,X.QTY301 = @p_QTY301  ,X.QTY302  = @p_QTY302  ,X.QTY303  = @p_QTY303  ,X.QTY304  = @p_QTY304  ,X.QTY305  = @p_QTY305  
                            ,X.QTY306 = @p_QTY306  ,X.QTY307  = @p_QTY307  ,X.QTY308  = @p_QTY308  ,X.QTY309  = @p_QTY309  ,X.QTY310  = @p_QTY310
                            ,X.QTY311 = @p_QTY311  ,X.QTY312  = @p_QTY312  ,X.QTY313  = @p_QTY313  ,X.QTY314  = @p_QTY314  ,X.QTY315  = @p_QTY315  
                            ,X.QTY316 = @p_QTY316  ,X.QTY317  = @p_QTY317  ,X.QTY318  = @p_QTY318  ,X.QTY319  = @p_QTY319  ,X.QTY320  = @p_QTY320
                            ,X.QTY321 = @p_QTY321  ,X.QTY322  = @p_QTY322  ,X.QTY323  = @p_QTY323  ,X.QTY324  = @p_QTY324  ,X.QTY325  = @p_QTY325  
                            ,X.QTY326 = @p_QTY326  ,X.QTY327  = @p_QTY327  ,X.QTY328  = @p_QTY328  ,X.QTY329  = @p_QTY329  ,X.QTY330  = @p_QTY330
                            ,X.QTY331 = @p_QTY331  ,X.QTY332  = @p_QTY332  ,X.QTY333  = @p_QTY333  ,X.QTY334  = @p_QTY334  ,X.QTY335  = @p_QTY335  
                            ,X.QTY336 = @p_QTY336  ,X.QTY337  = @p_QTY337  ,X.QTY338  = @p_QTY338  ,X.QTY339  = @p_QTY339  ,X.QTY340  = @p_QTY340
                            ,X.QTY341 = @p_QTY341  ,X.QTY342  = @p_QTY342  ,X.QTY343  = @p_QTY343  ,X.QTY344  = @p_QTY344  ,X.QTY345  = @p_QTY345  
                            ,X.QTY346 = @p_QTY346  ,X.QTY347  = @p_QTY347  ,X.QTY348  = @p_QTY348  ,X.QTY349  = @p_QTY349  ,X.QTY350  = @p_QTY350
                            ,X.QTY351 = @p_QTY351  ,X.QTY352  = @p_QTY352  ,X.QTY353  = @p_QTY353  ,X.QTY354  = @p_QTY354  ,X.QTY355  = @p_QTY355  
                            ,X.QTY356 = @p_QTY356  ,X.QTY357  = @p_QTY357  ,X.QTY358  = @p_QTY358  ,X.QTY359  = @p_QTY359  ,X.QTY360  = @p_QTY360
                            ,X.QTY361 = @p_QTY361  ,X.QTY362  = @p_QTY362  ,X.QTY363  = @p_QTY363  ,X.QTY364  = @p_QTY364 

                            ,X.WQTY01 = @p_QTY001 + @p_QTY002 + @p_QTY003 + @p_QTY004 + @p_QTY005 + @p_QTY006 + @p_QTY007  
                            ,X.WQTY02 = @p_QTY008 + @p_QTY009 + @p_QTY010 + @p_QTY011 + @p_QTY012 + @p_QTY013 + @p_QTY014  
                            ,X.WQTY03 = @p_QTY015 + @p_QTY016 + @p_QTY017 + @p_QTY018 + @p_QTY019 + @p_QTY020 + @p_QTY021
                            ,X.WQTY04 = @p_QTY022 + @p_QTY023 + @p_QTY024 + @p_QTY025 + @p_QTY026 + @p_QTY027 + @p_QTY028
                            ,X.WQTY05 = @p_QTY029 + @p_QTY030 + @p_QTY031 + @p_QTY032 + @p_QTY033 + @p_QTY034 + @p_QTY035
                            ,X.WQTY06 = @p_QTY036 + @p_QTY037 + @p_QTY038 + @p_QTY039 + @p_QTY040 + @p_QTY041 + @p_QTY042
                            ,X.WQTY07 = @p_QTY043 + @p_QTY044 + @p_QTY045 + @p_QTY046 + @p_QTY047 + @p_QTY048 + @p_QTY049
                            ,X.WQTY08 = @p_QTY050 + @p_QTY051 + @p_QTY052 + @p_QTY053 + @p_QTY054 + @p_QTY055 + @p_QTY056
                            ,X.WQTY09 = @p_QTY057 + @p_QTY058 + @p_QTY059 + @p_QTY060 + @p_QTY061 + @p_QTY062 + @p_QTY063
                            ,X.WQTY10 = @p_QTY064 + @p_QTY065 + @p_QTY066 + @p_QTY067 + @p_QTY068 + @p_QTY069 + @p_QTY070
                            ,X.WQTY11 = @p_QTY071 + @p_QTY072 + @p_QTY073 + @p_QTY074 + @p_QTY075 + @p_QTY076 + @p_QTY077
                            ,X.WQTY12 = @p_QTY078 + @p_QTY079 + @p_QTY080 + @p_QTY081 + @p_QTY082 + @p_QTY083 + @p_QTY084
                            ,X.WQTY13 = @p_QTY085 + @p_QTY086 + @p_QTY087 + @p_QTY088 + @p_QTY089 + @p_QTY090 + @p_QTY091
                            ,X.WQTY14 = @p_QTY092 + @p_QTY093 + @p_QTY094 + @p_QTY095 + @p_QTY096 + @p_QTY097 + @p_QTY098
                            ,X.WQTY15 = @p_QTY099 + @p_QTY100 + @p_QTY101 + @p_QTY102 + @p_QTY103 + @p_QTY104 + @p_QTY105
                            ,X.WQTY16 = @p_QTY106 + @p_QTY107 + @p_QTY108 + @p_QTY109 + @p_QTY110 + @p_QTY111 + @p_QTY112
                            ,X.WQTY17 = @p_QTY113 + @p_QTY114 + @p_QTY115 + @p_QTY116 + @p_QTY117 + @p_QTY118 + @p_QTY119
                            ,X.WQTY18 = @p_QTY120 + @p_QTY121 + @p_QTY122 + @p_QTY123 + @p_QTY124 + @p_QTY125 + @p_QTY126
                            ,X.WQTY19 = @p_QTY127 + @p_QTY128 + @p_QTY129 + @p_QTY130 + @p_QTY131 + @p_QTY132 + @p_QTY133
                            ,X.WQTY20 = @p_QTY134 + @p_QTY135 + @p_QTY136 + @p_QTY137 + @p_QTY138 + @p_QTY139 + @p_QTY140
                            ,X.WQTY21 = @p_QTY141 + @p_QTY142 + @p_QTY143 + @p_QTY144 + @p_QTY145 + @p_QTY146 + @p_QTY147 
                            ,X.WQTY22 = @p_QTY148 + @p_QTY149 + @p_QTY150 + @p_QTY151 + @p_QTY152 + @p_QTY153 + @p_QTY154 
                            ,X.WQTY23 = @p_QTY155 + @p_QTY156 + @p_QTY157 + @p_QTY158 + @p_QTY159 + @p_QTY160 + @p_QTY161
                            ,X.WQTY24 = @p_QTY162 + @p_QTY163 + @p_QTY164 + @p_QTY165 + @p_QTY166 + @p_QTY167 + @p_QTY168 
                            ,X.WQTY25 = @p_QTY169 + @p_QTY170 + @p_QTY171 + @p_QTY172 + @p_QTY173 + @p_QTY174 + @p_QTY175 
                            ,X.WQTY26 = @p_QTY176 + @p_QTY177 + @p_QTY178 + @p_QTY179 + @p_QTY180 + @p_QTY181 + @p_QTY182 
                            ,X.WQTY27 = @p_QTY183 + @p_QTY184 + @p_QTY185 + @p_QTY186 + @p_QTY187 + @p_QTY188 + @p_QTY189 
                            ,X.WQTY28 = @p_QTY190 + @p_QTY191 + @p_QTY192 + @p_QTY193 + @p_QTY194 + @p_QTY195 + @p_QTY196 
                            ,X.WQTY29 = @p_QTY197 + @p_QTY198 + @p_QTY199 + @p_QTY200 + @p_QTY201 + @p_QTY202 + @p_QTY203 
                            ,X.WQTY30 = @p_QTY204 + @p_QTY205 + @p_QTY206 + @p_QTY207 + @p_QTY208 + @p_QTY209 + @p_QTY210
                            ,X.WQTY31 = @p_QTY211 + @p_QTY212 + @p_QTY213 + @p_QTY214 + @p_QTY215 + @p_QTY216 + @p_QTY217 
                            ,X.WQTY32 = @p_QTY218 + @p_QTY219 + @p_QTY220 + @p_QTY221 + @p_QTY222 + @p_QTY223 + @p_QTY224 
                            ,X.WQTY33 = @p_QTY225 + @p_QTY226 + @p_QTY227 + @p_QTY228 + @p_QTY229 + @p_QTY230 + @p_QTY231 
                            ,X.WQTY34 = @p_QTY232 + @p_QTY233 + @p_QTY234 + @p_QTY235 + @p_QTY236 + @p_QTY237 + @p_QTY238 
                            ,X.WQTY35 = @p_QTY239 + @p_QTY240 + @p_QTY241 + @p_QTY242 + @p_QTY243 + @p_QTY244 + @p_QTY245 
                            ,X.WQTY36 = @p_QTY246 + @p_QTY247 + @p_QTY248 + @p_QTY249 + @p_QTY250 + @p_QTY251 + @p_QTY252 
                            ,X.WQTY37 = @p_QTY253 + @p_QTY254 + @p_QTY255 + @p_QTY256 + @p_QTY257 + @p_QTY258 + @p_QTY259 
                            ,X.WQTY38 = @p_QTY260 + @p_QTY261 + @p_QTY262 + @p_QTY263 + @p_QTY264 + @p_QTY265 + @p_QTY266 
                            ,X.WQTY39 = @p_QTY267 + @p_QTY268 + @p_QTY269 + @p_QTY270 + @p_QTY271 + @p_QTY272 + @p_QTY273 
                            ,X.WQTY40 = @p_QTY274 + @p_QTY275 + @p_QTY276 + @p_QTY277 + @p_QTY278 + @p_QTY279 + @p_QTY280
                            ,X.WQTY41 = @p_QTY281 + @p_QTY282 + @p_QTY283 + @p_QTY284 + @p_QTY285 + @p_QTY286 + @p_QTY287 
                            ,X.WQTY42 = @p_QTY288 + @p_QTY289 + @p_QTY290 + @p_QTY291 + @p_QTY292 + @p_QTY293 + @p_QTY294 
                            ,X.WQTY43 = @p_QTY295 + @p_QTY296 + @p_QTY297 + @p_QTY298 + @p_QTY299 + @p_QTY300 + @p_QTY301 
                            ,X.WQTY44 = @p_QTY302 + @p_QTY303 + @p_QTY304 + @p_QTY305 + @p_QTY306 + @p_QTY307 + @p_QTY308 
                            ,X.WQTY45 = @p_QTY309 + @p_QTY310 + @p_QTY311 + @p_QTY312 + @p_QTY313 + @p_QTY314 + @p_QTY315 
                            ,X.WQTY46 = @p_QTY316 + @p_QTY317 + @p_QTY318 + @p_QTY319 + @p_QTY320 + @p_QTY321 + @p_QTY322 
                            ,X.WQTY47 = @p_QTY323 + @p_QTY324 + @p_QTY325 + @p_QTY326 + @p_QTY327 + @p_QTY328 + @p_QTY329 
                            ,X.WQTY48 = @p_QTY330 + @p_QTY331 + @p_QTY332 + @p_QTY333 + @p_QTY334 + @p_QTY335 + @p_QTY336 
                            ,X.WQTY49 = @p_QTY337 + @p_QTY338 + @p_QTY339 + @p_QTY340 + @p_QTY341 + @p_QTY342 + @p_QTY343 
                            ,X.WQTY50 = @p_QTY344 + @p_QTY345 + @p_QTY346 + @p_QTY347 + @p_QTY348 + @p_QTY349 + @p_QTY350
                            ,X.WQTY51 = @p_QTY351 + @p_QTY352 + @p_QTY353 + @p_QTY354 + @p_QTY355 + @p_QTY356 + @p_QTY357 
                            ,X.WQTY52 = @p_QTY358 + @p_QTY359 + @p_QTY360 + @p_QTY361 + @p_QTY362 + @p_QTY363 + @p_QTY364

                    ,LAST_UPDATED_BY    = @v_batch_user_id
                    ,LAST_UPDATE_DATE   = GETDATE()
                FROM DBO.SCP_XLS_PSI_GLOBAL_SMALL_PACK X
               WHERE 0 = 0
                 AND DIVISION_ID         = @v_batch_division_id
                 AND PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
				 AND CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
				 AND PLAN_TYPE			= @v_batch_plan_type
                 AND SEQ                 = @v_batch_seq
                 AND XLS_KEY1            = @v_batch_xls_key1;    

				 --PRINT @v_batch_measure + '08. ' +CONVERT(CHAR(23), GETDATE(), 21);

     
               END

print '222222222222222222222'

			IF @v_batch_measure =  'OLD_CELL_SHIP_PLAN'
			BEGIN
				-- 시뮬레이터 PSI DATA 만 저장하고 종료
				-- TXN LOG
				SET @v_log_type = N'TXN';    -- 로그타입
				SET @n_log_count = @@ROWCOUNT;
				SET @v_log_message = N'INSERT INTO '+@v_table_id;
				SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121);
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
										  ,@p_log_type      = @v_log_type
										  ,@p_log_count     = @n_log_count 
										  ,@p_log_message   = @v_log_message 
										  ,@p_description   = @v_description 
										  ,@p_event_date    = @d_event_date 
										  ,@p_user_id       = @v_batch_user
										  ;
				-- 종료 LOG
				SET @v_log_type = N'END';
				SET @v_log_message = N'########## END of procedure ##########';
				SET @v_description = N'['+@v_batch_division_id+']['+@v_batch_plan_start_yyyymmdd+']['+@v_batch_measure+']['+convert(varchar, @v_batch_xls_key1)+'][' + @v_exec_time + ']';         
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
										  ,@p_log_type      = @v_log_type
										  ,@p_log_count     = @n_log_count 
										  ,@p_log_message   = @v_log_message 
										  ,@p_description   = @v_description 
										  ,@p_event_date    = @d_event_date 
										  ,@p_user_id       = @v_batch_user
										  ;
				return 1 
			END

            -------------------------------------------------------------------------------------------------------------         
            -- SOURCE TABLE 반영
            -------------------------------------------------------------------------------------------------------------   
            SET @v_batch_user = @v_batch_user_id + '[SIMULATION]' -- UI 작업자와 시물레이션 작업자를 구분하기 위해서

            DECLARE @n_history_seq	INTEGER;   -- HISTORY SEQ 
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FG UPDATE
            -- PACK_SHIP_PLAN  --> SCP_ANL_SHIPMENT_PLAN_FG.MEASURE 'SHIP_PLAN_AMEND' UPDATE
            -------------------------------------------------------------------------------------------------------------
            IF @v_batch_measure IN  ('PACK_SHIP_PLAN', 'CELL_SHIP_PLAN')   -- FG
              BEGIN 
            -- SHIP_PLAN
               IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
	              DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG

                SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                      ,X.OPERATION_GROUP AS BIZ_TYPE
                      ,X.PROJECT_CODE
--                      ,X.CELL_ITEM_ID
                    ,X.ITEM_ID
                    ,X.TO_SITE
                    ,X.INCOTERMS
                    ,X.FROM_SITE
                    ,X.BOD_ID
                    ,X.TRANSPORT_MODE
                    ,'SHIP_PLAN_AMEND' AS MEASURE 
                    ,Y.YYYYMMDD AS YYYYMMDD
                    ,X.QTY
                    ,@v_batch_division_id AS ORIGIN_FROM_DIVISION_ID
                    ,@v_batch_division_id AS ORIGIN_TO_DIVISION_ID
                      ,'' AS ELECTRODE_TYPE
                      ,X.ATTRIBUTE1
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_SHIPMENT_PLAN_FG
                FROM #DAY_SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) 
                UNPIVOT 
                    (
                     QTY FOR  YYYYMMDD_COLUMN IN (
                                           [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                          ,[QTY361], [QTY362], [QTY363], [QTY364]

                                          )  
                ) AS X
                INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                              FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
							  WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
								
                                AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd
								
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start
				WHERE Y.YYYYMMDD >= @v_bod_from
				  AND Y.YYYYMMDD <= @v_bod_to
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end
				  AND X.DIVISION_ID         = @v_batch_division_id
				  AND X.CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
                  AND X.XLS_KEY1            = @v_batch_xls_key1 
            ;

			IF @P_IS_DEBUG= 1 SELECT  '1248' AS "#DAY_SCP_XLS_PSI_GLOBAL",   * FROM #DAY_SCP_XLS_PSI_GLOBAL
			
			-------------------------------------------------------------------------------------------------------------
			-- 2022.04.05   KSW            Daily/Monthly Bucket 변경건 적용 :: 변경된 Daily 건만 저장하는 로직추가
			-- 입력값이 -9 (변경건 아님) 건은 제외한다.
			-------------------------------------------------------------------------------------------------------------
			DELETE #SCP_ANL_SHIPMENT_PLAN_FG
			 WHERE QTY = -9
			 ;
			
			 --SELECT '#SCP_ANL_SHIPMENT_PLAN_FG', * FROM #SCP_ANL_SHIPMENT_PLAN_FG --TEST

        -------------------------------------------------------------------------------------------------------------         
        -- FROZEN 구간 UPDATE
        -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
        -------------------------------------------------------------------------------------------------------------

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG AS X  
                USING (SELECT 
                              DIVISION_ID
                             ,PLAN_START_YYYYMMDD
                             ,PLAN_TYPE
                             ,SEQ
                             ,BIZ_TYPE
                             ,PROJECT_CODE
      --                     ,CELL_ITEM_ID
                             ,ITEM_ID
                             ,TO_SITE
                             ,INCOTERMS
                             ,FROM_SITE
                             ,BOD_ID
--                             ,TRANSPORT_MODE
                             ,MEASURE 
                             ,YYYYMMDD
                             ,QTY
                             ,ORIGIN_FROM_DIVISION_ID
                             ,ORIGIN_TO_DIVISION_ID
                             ,ELECTRODE_TYPE
                        FROM #SCP_ANL_SHIPMENT_PLAN_FG
                       --WHERE QTY > 0 
                      ) AS Y
                ON 0 = 0
                AND X.DIVISION_ID               = Y.DIVISION_ID					--@v_batch_division_id				-- 2021.10.25 튜닝개선요청에 따른 변경
                AND X.PLAN_START_YYYYMMDD       = Y.PLAN_START_YYYYMMDD			--@v_batch_PLAN_START_YYYYMMDD
                AND X.PLAN_TYPE                 = Y.PLAN_TYPE					--@v_batch_PLAN_TYPE
                AND X.SEQ                       = Y.SEQ							--@v_batch_SEQ
                
                AND X.BIZ_TYPE                  = Y.BIZ_TYPE
                AND X.PROJECT_CODE              = Y.PROJECT_CODE
                AND X.ITEM_ID                   = Y.ITEM_ID
                AND X.TO_SITE                   = Y.TO_SITE
                AND X.INCOTERMS                 = Y.INCOTERMS
                AND X.FROM_SITE                 = Y.FROM_SITE
                AND X.BOD_ID                    = Y.BOD_ID
                
                AND X.MEASURE                   = Y.MEASURE
                AND X.YYYYMMDD                  = Y.YYYYMMDD



                WHEN MATCHED  THEN 
                UPDATE 
                  SET  X.QTY = Y.QTY
                      --,X.CREATED_BY         = @v_batch_user
                      --,X.CREATION_DATE      = GETDATE()
                      ,X.LAST_UPDATED_BY    = @v_batch_user
                      ,X.LAST_UPDATE_DATE   = GETDATE()

                WHEN NOT MATCHED  THEN 
                 
                  INSERT (
                             DIVISION_ID
                             ,PLAN_START_YYYYMMDD
                             ,PLAN_TYPE
                             ,SEQ
                             ,BIZ_TYPE
                             ,PROJECT_CODE
      --                     ,CELL_ITEM_ID
                             ,ITEM_ID
                             ,TO_SITE
                             ,INCOTERMS
                             ,FROM_SITE
                             ,BOD_ID
    --                       ,TRANSPORT_MODE
                             ,MEASURE 
                             ,YYYYMMDD
                             ,QTY
                             ,ORIGIN_FROM_DIVISION_ID
                             ,ORIGIN_TO_DIVISION_ID
                             ,ELECTRODE_TYPE
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                        )
                 VALUES (
                           Y.DIVISION_ID
                          ,Y.PLAN_START_YYYYMMDD
                          ,Y.PLAN_TYPE
                          ,Y.SEQ
                          ,Y.BIZ_TYPE
                          ,Y.PROJECT_CODE
  --                     ,Y.CELL_ITEM_ID
                          ,Y.ITEM_ID
                          ,Y.TO_SITE
                          ,Y.INCOTERMS
                          ,Y.FROM_SITE
                          ,Y.BOD_ID
  --                       ,Y.TRANSPORT_MODE
                          ,Y.MEASURE 
                          ,Y.YYYYMMDD
                          ,Y.QTY
                          ,Y.ORIGIN_FROM_DIVISION_ID
                          ,Y.ORIGIN_TO_DIVISION_ID
                          ,Y.ELECTRODE_TYPE
                          ,@v_batch_user
                          ,GETDATE() 
                          ,@v_batch_user
                          ,GETDATE() 
                        )
                        ;                        
            
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FG_H : History 입력
            -------------------------------------------------------------------------------------------------------------         
            -- SELECT top 10 * FROM dbo.SCP_ANL_SHIPMENT_PLAN_FG_H WITH (NOLOCK)     -- HISTORY_SEQ
            
            -- SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H
            
                      INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FG_H
                      (
                        HISTORY_SEQ
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,BIZ_TYPE
                        ,PROJECT_CODE
                        ,ITEM_ID
                        ,TO_SITE
                        ,INCOTERMS
                        ,FROM_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_TO_DIVISION_ID
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,HISTORY_CREATION_DATE
                      )
                      SELECT 
                        NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,BIZ_TYPE
                        ,PROJECT_CODE
                        ,ITEM_ID
                        ,TO_SITE
                        ,INCOTERMS
                        ,FROM_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_TO_DIVISION_ID
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,@v_batch_user   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@v_batch_user   AS LAST_UPDATED_BY
                        ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                       FROM #SCP_ANL_SHIPMENT_PLAN_FG  WITH (NOLOCK)


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(FG)
            -------------------------------------------------------------------------------------------------------------         


                        -- FIX UPDATE
                        UPDATE X
                          SET X.QTY               = Y.QTY
                             ,X.ATTRIBUTE1        = 'Y'       -- History 구분을 위해
                             ,X.LAST_UPDATED_BY   = @v_batch_user
                             ,X.LAST_UPDATE_DATE  = GETDATE()
                          FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                          INNER JOIN #SCP_ANL_SHIPMENT_PLAN_FG Y WITH (NOLOCK)
                          ON 0 = 0
                          AND X.DIVISION_ID = Y.DIVISION_ID
                          AND X.BIZ_TYPE    = Y.BIZ_TYPE
                          AND X.PROJECT_CODE= Y.PROJECT_CODE
                          AND X.ITEM_ID     = Y.ITEM_ID
                          AND X.TO_SITE     = Y.TO_SITE
                          AND X.FROM_SITE   = Y.FROM_SITE
                          AND X.BOD_ID      = Y.BOD_ID
                          AND X.YYYYMMDD    = Y.YYYYMMDD          


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력
            -------------------------------------------------------------------------------------------------------------         

--                       SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX_H   -- 현재 사용안함.
--                       SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H -- SCP_ANL_PRODUCTION_PLAN_FIX 대신 사용중임.
                       --SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H

                      INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FIX_H
                      (
                          HISTORY_SEQ
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          --,ATTRIBUTE1
                          --,ATTRIBUTE2
                          --,ATTRIBUTE3
                          --,ATTRIBUTE4
                          --,ATTRIBUTE5
                          --,ATTRIBUTE6
                          --,ATTRIBUTE7
                          --,ATTRIBUTE8
                          --,ATTRIBUTE9
                          --,ATTRIBUTE10
                          ,HISTORY_CREATION_DATE
                    )
                    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                            ,@v_batch_user   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@v_batch_user   AS LAST_UPDATED_BY
                          ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                   FROM SCP_ANL_SHIPMENT_PLAN_FIX  WITH (NOLOCK)
                  WHERE ATTRIBUTE1 =N'Y'


                  UPDATE X
                    SET X.ATTRIBUTE1 = NULL       -- History 구분을 위해 원상복구
                    FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                    INNER JOIN #SCP_ANL_SHIPMENT_PLAN_FG Y WITH (NOLOCK)
                    ON 0 = 0
                    AND X.DIVISION_ID = Y.DIVISION_ID
                    AND X.BIZ_TYPE    = Y.BIZ_TYPE
                    AND X.PROJECT_CODE= Y.PROJECT_CODE
                    AND X.ITEM_ID     = Y.ITEM_ID
                    AND X.TO_SITE     = Y.TO_SITE
                    AND X.FROM_SITE   = Y.FROM_SITE
                    AND X.BOD_ID      = Y.BOD_ID
                    AND X.YYYYMMDD    = Y.YYYYMMDD  
                    AND X.ATTRIBUTE1  ='Y'




            END
			print '5555555555555555555555555555'
			-------------------------------------------------------------------------------------------------------------
			-- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - start
            --               - CELL_SHIP_PLAN (Ship Plan(SCP)) Measure 를 SEMI_SHIP_PLAN 에 준하여 처리하는 로직을 추가
			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 - SEMI_SHIP_PLAN case 추가
			--
			-- SCP_ANL_SHIPMENT_PLAN_SEMI UPDATE
            -- SEMI_SHIP_PLAN --> SCP_ANL_SHIPMENT_PLAN_SEMI.MEASURE 'SHIP_PLAN_AMEND' UPDATE
			--

			
				 

			IF @v_batch_measure IN  ('CELL_SHIP_PLAN', 'SEMI_SHIP_PLAN')   -- SEMI
              BEGIN 

            -- SEMI_SHIP_PLAN
              IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL	
	              DROP TABLE #SCP_ANL_SHIPMENT_PLAN_SEMI


                SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                      ,X.OPERATION_GROUP

                      ,X.ITEM_ID
                      ,X.FROM_SITE
                      ,X.BOD_ID
                      ,'SHIP_PLAN_AMEND' AS MEASURE
                      ,Y.YYYYMMDD AS YYYYMMDD
                      ,X.TO_SITE
                      ,X.QTY
                      ,'40' AS ORIGIN_FROM_DIVISION_ID
                      ,'40' AS ORIGIN_TO_DIVISION_ID
                      ,'' AS ELECTRODE_TYPE
                      ,X.ATTRIBUTE1
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_SHIPMENT_PLAN_SEMI
                FROM #DAY_SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) 
                UNPIVOT 
                    (
                     QTY FOR  YYYYMMDD_COLUMN IN (
                                           [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                          ,[QTY361], [QTY362], [QTY363], [QTY364]

                                          )  
                ) AS X
                INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                              FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
								WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
								-- KSK,  v_batch_create_from_yyyymmdd => @v_batch_create_to_yyyymmdd 기간일자 오류수정 (2024-02-23)
                                AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd

                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - start
				WHERE Y.YYYYMMDD >= @v_bod_from
				  AND Y.YYYYMMDD <= @v_bod_to
				-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - end

				AND Y.YYYYMMDD				>= @v_batch_create_from_yyyymmdd-------@v_batch_PLAN_START_YYYYMMDD---------------DHJ
				AND X.DIVISION_ID			= @v_batch_division_id
				AND X.CREATE_FROM_YYYYMMDD	=@v_batch_create_from_yyyymmdd
                AND X.XLS_KEY1				= @v_batch_xls_key1 
                ;


				-------------------------------------------------------------------------------------------------------------
				-- 2022.04.05   KSW            Daily/Monthly Bucket 변경건 적용 :: 변경된 Daily 건만 저장하는 로직추가
				-- 입력값이 -9 (변경건 아님) 건은 제외한다.
				-------------------------------------------------------------------------------------------------------------
				DELETE #SCP_ANL_SHIPMENT_PLAN_SEMI
				 WHERE QTY = -9
				 ;
                
				--SELECT '#SCP_ANL_SHIPMENT_PLAN_SEMI' TN, *	FROM #SCP_ANL_SHIPMENT_PLAN_SEMI WHERE QTY > 0
				print '#SCP_ANL_SHIPMENT_PLAN_SEMI PREPARED'				


                -------------------------------------------------------------------------------------------------------------         
                -- FROZEN 구간 UPDATE
                -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
                -------------------------------------------------------------------------------------------------------------
				-- 2021.12.06 SEMI SHIP PLAN(CELL_SHIP_PLAN) 에 대한 PR/MA Frozen 구간해제
                --IF @p_plan_type IN  ('MA','SE')  
                --BEGIN
                --  DELETE  FROM #SCP_ANL_SHIPMENT_PLAN_SEMI
                --          FROM #SCP_ANL_SHIPMENT_PLAN_SEMI X
                --        INNER JOIN #SCM_MST_SITE Y
                --           ON Y.DIVISION_ID = X.DIVISION_ID
                --          AND Y.SCM_SITE_ID = X.FROM_SITE
                --        WHERE 
                --            X.YYYYMMDD < Y.SHIP_FROZEN_WEEK_DAY;
                --END

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_SEMI AS X  
                USING (SELECT DIVISION_ID
                             ,PLAN_START_YYYYMMDD --PLAN_START_YYYYMMDD------------DHJ
                             ,PLAN_TYPE
                             ,SEQ
                             ,OPERATION_GROUP
--                             ,CELL_ITEM_ID
                             ,ITEM_ID
                             ,FROM_SITE
                             ,BOD_ID
                             ,MEASURE
                             ,YYYYMMDD
                             ,TO_SITE
                             ,QTY
                             ,ORIGIN_FROM_DIVISION_ID
                             ,ORIGIN_TO_DIVISION_ID
                             ,ELECTRODE_TYPE
                        FROM #SCP_ANL_SHIPMENT_PLAN_SEMI
                       --WHERE QTY > 0 
                      ) AS Y
                ON 0 = 0
                AND X.DIVISION_ID         = Y.DIVISION_ID				--@v_batch_division_id					-- 2021.10.25 튜닝개선요청에 따른 변경
                AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD		--@v_batch_PLAN_START_YYYYMMDD
			--	AND X.PLAN_START_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD		-----------------------DHJ
                AND X.PLAN_TYPE           = Y.PLAN_TYPE					--@v_batch_PLAN_TYPE
                AND X.SEQ                 = Y.SEQ						--@v_batch_SEQ
                
                AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                AND X.ITEM_ID             = Y.ITEM_ID
                AND X.FROM_SITE           = Y.FROM_SITE
                AND X.BOD_ID              = Y.BOD_ID
                AND X.MEASURE             = Y.MEASURE
                AND X.YYYYMMDD            = Y.YYYYMMDD
                AND X.TO_SITE             = Y.TO_SITE


                WHEN MATCHED  THEN 
                UPDATE 
                  SET  X.QTY = Y.QTY
                      --,X.CREATED_BY         = @v_batch_user
                      --,X.CREATION_DATE      = GETDATE()
                      ,X.LAST_UPDATED_BY    = @v_batch_user
                      ,X.LAST_UPDATE_DATE   = GETDATE()

                WHEN NOT MATCHED  THEN 
                  INSERT (
                             DIVISION_ID
                            ,PLAN_START_YYYYMMDD
                            ,PLAN_TYPE
                            ,SEQ
                            ,OPERATION_GROUP
                            ,ITEM_ID
                            ,FROM_SITE
                            ,BOD_ID
                            ,MEASURE
                            ,YYYYMMDD
                            ,TO_SITE
                            ,QTY
                            ,ORIGIN_FROM_DIVISION_ID
                            ,ORIGIN_TO_DIVISION_ID
                            ,ELECTRODE_TYPE
                            ,CREATED_BY
                            ,CREATION_DATE
                            ,LAST_UPDATED_BY
                            ,LAST_UPDATE_DATE
                        )
                 VALUES (
                           Y.DIVISION_ID
                          ,Y.PLAN_START_YYYYMMDD-------------PLAN_START_YYYYMMDD----DHJ
                          ,Y.PLAN_TYPE
                          ,Y.SEQ
                          ,Y.OPERATION_GROUP
                          ,Y.ITEM_ID
                          ,Y.FROM_SITE
                          ,Y.BOD_ID
                          ,Y.MEASURE
                          ,Y.YYYYMMDD
                          ,Y.TO_SITE
                          ,Y.QTY
                          ,Y.ORIGIN_FROM_DIVISION_ID
                          ,Y.ORIGIN_TO_DIVISION_ID
                          ,Y.ELECTRODE_TYPE
                          ,@v_batch_user
                          ,GETDATE()
                          ,@v_batch_user
                          ,GETDATE()
                        )
                        ;

						
            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_SEMI_H : History 입력(SEMI)
            ------------------------------------------------------------------------------------------------------------- 

                      INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_SEMI_H
                      (
                        HISTORY_SEQ
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,FROM_SITE
                        ,TO_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,UPDATE_REASON_BOD
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ORIGIN_TO_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,HISTORY_CREATION_DATE
                      )
                      SELECT 
                         NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,ITEM_ID
                        ,FROM_SITE
                        ,TO_SITE
                        ,BOD_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,NULL AS UPDATE_REASON_BOD
                        ,ORIGIN_FROM_DIVISION_ID
                        ,ORIGIN_TO_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,@v_batch_user   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@v_batch_user   AS LAST_UPDATED_BY
                        ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE() AS HISTORY_CREATION_DATE
                       FROM #SCP_ANL_SHIPMENT_PLAN_SEMI  WITH (NOLOCK)

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(SEMI)
            ------------------------------------------------------------------------------------------------------------- 
                        -- FIX UPDATE
                        UPDATE X
                          SET X.QTY         = Y.QTY
                            , X.FIX_REASON    = 'SIMULATION UPDATE'
                            , X.ATTRIBUTE1  ='Y'       -- History 구분을 위해
                          FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                          INNER JOIN #SCP_ANL_SHIPMENT_PLAN_SEMI Y WITH (NOLOCK)
                          ON 0 = 0
                          AND X.DIVISION_ID = Y.DIVISION_ID
                          AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                          AND X.ITEM_ID     = Y.ITEM_ID
                          AND X.TO_SITE     = Y.TO_SITE
                          AND X.FROM_SITE   = Y.FROM_SITE
                          AND X.BOD_ID      = Y.BOD_ID
                          AND X.YYYYMMDD    = Y.YYYYMMDD


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력(SEMI)
            -------------------------------------------------------------------------------------------------------------         
            INSERT INTO dbo.SCP_ANL_SHIPMENT_PLAN_FIX_H
                      (
                          HISTORY_SEQ
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          --,ATTRIBUTE1
                          --,ATTRIBUTE2
                          --,ATTRIBUTE3
                          --,ATTRIBUTE4
                          --,ATTRIBUTE5
                          --,ATTRIBUTE6
                          --,ATTRIBUTE7
                          --,ATTRIBUTE8
                          --,ATTRIBUTE9
                          --,ATTRIBUTE10
                          ,HISTORY_CREATION_DATE
                    )
                    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
                          ,FIX_ID
                          ,DIVISION_ID
                          ,BIZ_TYPE
                          ,ITEM_ID
                          ,TO_SITE
                          ,FROM_SITE
                          ,PROJECT_CODE
                          ,INCOTERMS
                          ,BOD_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_FROM_DIVISION_ID
                          ,ORIGIN_TO_DIVISION_ID
                          ,ELECTRODE_TYPE
                            ,@v_batch_user   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@v_batch_user   AS LAST_UPDATED_BY
                          ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                   FROM SCP_ANL_SHIPMENT_PLAN_FIX  WITH (NOLOCK)
                  WHERE ATTRIBUTE1 ='Y'


                  -- FIX UPDATE
                   UPDATE X
                    SET X.ATTRIBUTE1 = NULL       -- History 구분을 위해 원상복구
                    FROM SCP_ANL_SHIPMENT_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD
                    INNER JOIN #SCP_ANL_SHIPMENT_PLAN_SEMI Y WITH (NOLOCK)
                    ON 0 = 0
                    AND X.DIVISION_ID = Y.DIVISION_ID
                    AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                    AND X.ITEM_ID     = Y.ITEM_ID
                    AND X.TO_SITE     = Y.TO_SITE
                    AND X.FROM_SITE   = Y.FROM_SITE
                    AND X.BOD_ID      = Y.BOD_ID
                    AND X.YYYYMMDD    = Y.YYYYMMDD
                    AND X.ATTRIBUTE1  ='Y'


            END

			-- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - end
			-------------------------------------------------------------------------------------------------------------

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN UPDATE
            -- PACK_PROD  --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND' UPDATE
            -------------------------------------------------------------------------------------------------------------  

            IF @v_batch_measure IN  ('PACK_PROD')   
              BEGIN 
 
               IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL	
	              DROP TABLE #SCP_ANL_PRODUCTION_PLAN

                SELECT X.DIVISION_ID, X.PLAN_START_YYYYMMDD, X.PLAN_TYPE, X.SEQ
                      ,X.OPERATION_GROUP
--                      ,X.CELL_ITEM_ID
                      ,X.FROM_SITE AS SCM_SITE_ID
                      ,X.ITEM_ID
                      ,X.PROD_LINE AS LINE_ID
                      ,X.ATTRIBUTE9 AS OPERATION_ID
                      ,'PROD_PLAN_AMEND' AS MEASURE
                      ,Y.YYYYMMDD AS YYYYMMDD
                      ,X.QTY
                      ,X.DIVISION_ID AS ORIGIN_DIVISION_ID
                      ,'' AS ELECTRODE_TYPE
                      ,CELL_QTY_PACK AS CELL_QTY
                      ,Y.YYYYMMDD_COLUMN
                INTO #SCP_ANL_PRODUCTION_PLAN
                FROM #DAY_SCP_XLS_PSI_GLOBAL SourceTable WITH (NOLOCK) 
                UNPIVOT 
                    (
                     QTY FOR  YYYYMMDD_COLUMN IN (
                                           [QTY001], [QTY002], [QTY003], [QTY004], [QTY005],[QTY006], [QTY007], [QTY008], [QTY009], [QTY010]
                                          ,[QTY011], [QTY012], [QTY013], [QTY014], [QTY015],[QTY016], [QTY017], [QTY018], [QTY019], [QTY020]
                                          ,[QTY021], [QTY022], [QTY023], [QTY024], [QTY025],[QTY026], [QTY027], [QTY028], [QTY029], [QTY030]
                                          ,[QTY031], [QTY032], [QTY033], [QTY034], [QTY035],[QTY036], [QTY037], [QTY038], [QTY039], [QTY040]
                                          ,[QTY041], [QTY042], [QTY043], [QTY044], [QTY045],[QTY046], [QTY047], [QTY048], [QTY049], [QTY050]
                                          ,[QTY051], [QTY052], [QTY053], [QTY054], [QTY055],[QTY056], [QTY057], [QTY058], [QTY059], [QTY060]
                                          ,[QTY061], [QTY062], [QTY063], [QTY064], [QTY065],[QTY066], [QTY067], [QTY068], [QTY069], [QTY070]
                                          ,[QTY071], [QTY072], [QTY073], [QTY074], [QTY075],[QTY076], [QTY077], [QTY078], [QTY079], [QTY080]
                                          ,[QTY081], [QTY082], [QTY083], [QTY084], [QTY085],[QTY086], [QTY087], [QTY088], [QTY089], [QTY090]
                                          ,[QTY091], [QTY092], [QTY093], [QTY094], [QTY095],[QTY096], [QTY097], [QTY098], [QTY099], [QTY100]

                                          ,[QTY101], [QTY102], [QTY103], [QTY104], [QTY105],[QTY106], [QTY107], [QTY108], [QTY109], [QTY110]
                                          ,[QTY111], [QTY112], [QTY113], [QTY114], [QTY115],[QTY116], [QTY117], [QTY118], [QTY119], [QTY120]
                                          ,[QTY121], [QTY122], [QTY123], [QTY124], [QTY125],[QTY126], [QTY127], [QTY128], [QTY129], [QTY130]
                                          ,[QTY131], [QTY132], [QTY133], [QTY134], [QTY135],[QTY136], [QTY137], [QTY138], [QTY139], [QTY140]
                                          ,[QTY141], [QTY142], [QTY143], [QTY144], [QTY145],[QTY146], [QTY147], [QTY148], [QTY149], [QTY150]
                                          ,[QTY151], [QTY152], [QTY153], [QTY154], [QTY155],[QTY156], [QTY157], [QTY158], [QTY159], [QTY160]
                                          ,[QTY161], [QTY162], [QTY163], [QTY164], [QTY165],[QTY166], [QTY167], [QTY168], [QTY169], [QTY170]
                                          ,[QTY171], [QTY172], [QTY173], [QTY174], [QTY175],[QTY176], [QTY177], [QTY178], [QTY179], [QTY180]
                                          ,[QTY181], [QTY182], [QTY183], [QTY184], [QTY185],[QTY186], [QTY187], [QTY188], [QTY189], [QTY190]
                                          ,[QTY191], [QTY192], [QTY193], [QTY194], [QTY195],[QTY196], [QTY197], [QTY198], [QTY199], [QTY200]

                                          ,[QTY201], [QTY202], [QTY203], [QTY204], [QTY205],[QTY206], [QTY207], [QTY208], [QTY209], [QTY210]
                                          ,[QTY211], [QTY212], [QTY213], [QTY214], [QTY215],[QTY216], [QTY217], [QTY218], [QTY219], [QTY220]
                                          ,[QTY221], [QTY222], [QTY223], [QTY224], [QTY225],[QTY226], [QTY227], [QTY228], [QTY229], [QTY230]
                                          ,[QTY231], [QTY232], [QTY233], [QTY234], [QTY235],[QTY236], [QTY237], [QTY238], [QTY239], [QTY240]
                                          ,[QTY241], [QTY242], [QTY243], [QTY244], [QTY245],[QTY246], [QTY247], [QTY248], [QTY249], [QTY250]
                                          ,[QTY251], [QTY252], [QTY253], [QTY254], [QTY255],[QTY256], [QTY257], [QTY258], [QTY259], [QTY260]
                                          ,[QTY261], [QTY262], [QTY263], [QTY264], [QTY265],[QTY266], [QTY267], [QTY268], [QTY269], [QTY270]
                                          ,[QTY271], [QTY272], [QTY273], [QTY274], [QTY275],[QTY276], [QTY277], [QTY278], [QTY279], [QTY280]
                                          ,[QTY281], [QTY282], [QTY283], [QTY284], [QTY285],[QTY286], [QTY287], [QTY288], [QTY289], [QTY290]
                                          ,[QTY291], [QTY292], [QTY293], [QTY294], [QTY295],[QTY296], [QTY297], [QTY298], [QTY299], [QTY300]

                                          ,[QTY301], [QTY302], [QTY303], [QTY304], [QTY305],[QTY306], [QTY307], [QTY308], [QTY309], [QTY310]
                                          ,[QTY311], [QTY312], [QTY313], [QTY314], [QTY315],[QTY316], [QTY317], [QTY318], [QTY319], [QTY320]
                                          ,[QTY321], [QTY322], [QTY323], [QTY324], [QTY325],[QTY326], [QTY327], [QTY328], [QTY329], [QTY330]
                                          ,[QTY331], [QTY332], [QTY333], [QTY334], [QTY335],[QTY336], [QTY337], [QTY338], [QTY339], [QTY340]
                                          ,[QTY341], [QTY342], [QTY343], [QTY344], [QTY345],[QTY346], [QTY347], [QTY348], [QTY349], [QTY350]
                                          ,[QTY351], [QTY352], [QTY353], [QTY354], [QTY355],[QTY356], [QTY357], [QTY358], [QTY359], [QTY360]
                                          ,[QTY361], [QTY362], [QTY363], [QTY364]

                                          )  
                ) AS X
                INNER JOIN (SELECT A.BASIS_YYYYMMDD AS YYYYMMDD    
                                  ,'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY BASIS_YYYYMMDD)) AS YYYYMMDD_COLUMN
                              FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
							  /*
                              WHERE A.BASIS_YYYYMMDD     >= @p_PLAN_START_YYYYMMDD
                                AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
								*/
								WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                                AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd
                            ) Y
                ON X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
				WHERE Y.YYYYMMDD >= @v_batch_create_from_yyyymmdd-------@v_batch_PLAN_START_YYYYMMDD
				  AND X.DIVISION_ID         = @v_batch_division_id
				  AND X.CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
                  AND X.XLS_KEY1            = @v_batch_xls_key1 
                ;
                            

			-------------------------------------------------------------------------------------------------------------
			-- 2022.04.05   KSW            Daily/Monthly Bucket 변경건 적용 :: 변경된 Daily 건만 저장하는 로직추가
			-- 입력값이 -9 (변경건 아님) 건은 제외한다.
			-------------------------------------------------------------------------------------------------------------
			DELETE #SCP_ANL_PRODUCTION_PLAN
			WHERE QTY = -9
			;

            -------------------------------------------------------------------------------------------------------------         
            -- FROZEN 구간 UPDATE
            -- PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다.
            -------------------------------------------------------------------------------------------------------------
            
        IF @v_batch_plan_type IN  ('MA','SE')    AND @v_batch_measure IN  ('PACK_PROD')   
        BEGIN
            DELETE  FROM #SCP_ANL_PRODUCTION_PLAN
                    FROM #SCP_ANL_PRODUCTION_PLAN X
                INNER JOIN #SCM_MST_SITE Y
                    ON Y.DIVISION_ID = X.DIVISION_ID
                    AND Y.SCM_SITE_ID = X.SCM_SITE_ID
                WHERE 
                    X.YYYYMMDD < (CASE WHEN @v_batch_plan_type = 'MA' THEN Y.PROD_FROZEN_WEEK_DAY_MA ELSE Y.PROD_FROZEN_WEEK_DAY END)   --7
        END
            

               -- PROD_PLAN_AMEND
               INSERT INTO SCP_ANL_PRODUCTION_PLAN
                                     (DIVISION_ID
                                     ,PLAN_START_YYYYMMDD
                                     ,PLAN_TYPE
                                     ,SEQ
                                     ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                                     ,SCM_SITE_ID
                                     ,ITEM_ID
                                     ,LINE_ID
                                     ,OPERATION_ID
                                     ,MEASURE
                                     ,YYYYMMDD
                                     ,QTY
                                     ,ORIGIN_DIVISION_ID
                                     ,ELECTRODE_TYPE
                                     ,CELL_QTY
                                     ,CREATED_BY
                                     ,CREATION_DATE
                                     ,LAST_UPDATED_BY
                                     ,LAST_UPDATE_DATE  
                                     )

                SELECT DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,LINE_ID
                      ,OPERATION_ID
                      ,MEASURE
                      ,YYYYMMDD
                      ,QTY
                      ,ORIGIN_DIVISION_ID
                      ,ELECTRODE_TYPE
                      ,CELL_QTY
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE  
                  FROM  
                  (   
                       MERGE INTO SCP_ANL_PRODUCTION_PLAN AS X  
                        USING (SELECT DIVISION_ID
                                     ,PLAN_START_YYYYMMDD
                                     ,PLAN_TYPE
                                     ,SEQ
                                     ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                                     ,SCM_SITE_ID
                                     ,ITEM_ID
                                     ,LINE_ID
                                     ,OPERATION_ID
                                     ,MEASURE
                                     ,YYYYMMDD
                                     ,QTY
                                     ,ORIGIN_DIVISION_ID
                                     ,ELECTRODE_TYPE
                                     ,CELL_QTY
                                FROM #SCP_ANL_PRODUCTION_PLAN
                               --WHERE QTY > 0 
                              ) AS Y
                        ON 0 = 0
                        AND X.DIVISION_ID         = Y.DIVISION_ID				--@v_batch_division_id				-- 2021.10.25 튜닝개선요청에 따른 변경
                        AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD		--@v_batch_PLAN_START_YYYYMMDD
                        AND X.PLAN_TYPE           = Y.PLAN_TYPE					--@v_batch_PLAN_TYPE
                        AND X.SEQ                 = Y.SEQ						--@v_batch_SEQ
                
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.LINE_ID             = Y.LINE_ID
                        AND X.OPERATION_ID        = Y.OPERATION_ID
                        AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                        AND X.ELECTRODE_TYPE      = Y.ELECTRODE_TYPE

                

                        WHEN MATCHED  THEN 
                        UPDATE 
                          SET  X.QTY = Y.QTY
                              --,X.CREATED_BY         = @v_batch_user
                              --,X.CREATION_DATE      = GETDATE()
                              ,X.LAST_UPDATED_BY    = @v_batch_user
                              ,X.LAST_UPDATE_DATE   = GETDATE()

                        WHEN NOT MATCHED THEN  
                          INSERT (
                                     DIVISION_ID
                                     ,PLAN_START_YYYYMMDD
                                     ,PLAN_TYPE
                                     ,SEQ
                                     ,OPERATION_GROUP
        --                             ,CELL_ITEM_ID
                                     ,SCM_SITE_ID
                                     ,ITEM_ID
                                     ,LINE_ID
                                     ,OPERATION_ID
                                     ,MEASURE
                                     ,YYYYMMDD
                                     ,QTY
                                     ,ORIGIN_DIVISION_ID
                                     ,ELECTRODE_TYPE
                                     ,CELL_QTY
                                    ,CREATED_BY
                                    ,CREATION_DATE
                                    ,LAST_UPDATED_BY
                                    ,LAST_UPDATE_DATE
                                )
                         VALUES (
                                   Y.DIVISION_ID
                                   ,Y.PLAN_START_YYYYMMDD
                                   ,Y.PLAN_TYPE
                                   ,Y.SEQ
                                   ,Y.OPERATION_GROUP
        --                         ,Y.CELL_ITEM_ID
                                   ,Y.SCM_SITE_ID
                                   ,Y.ITEM_ID
                                   ,Y.LINE_ID
                                   ,Y.OPERATION_ID
                                   ,Y.MEASURE
                                   ,Y.YYYYMMDD
                                   ,Y.QTY
                                   ,Y.ORIGIN_DIVISION_ID
                                   ,Y.ELECTRODE_TYPE
                                   ,Y.CELL_QTY
                                  ,@v_batch_user
                                  ,GETDATE()
                                  ,@v_batch_user
                                  ,GETDATE()
                                )

                     -- INSERT 일경우 PROD_PLAN_ENGINE/PROD_PLAN_AMEND 쌍으로 입력한다.
                      OUTPUT $action, Inserted.DIVISION_ID
                                     ,Inserted.PLAN_START_YYYYMMDD
                                     ,Inserted.PLAN_TYPE
                                     ,Inserted.SEQ
                                     ,Inserted.OPERATION_GROUP
          --                         ,Inserted.CELL_ITEM_ID
                                     ,Inserted.SCM_SITE_ID
                                     ,Inserted.ITEM_ID
                                     ,Inserted.LINE_ID
                                     ,Inserted.OPERATION_ID
                                     ,'PROD_PLAN_ENGINE' AS MEASURE
                                     ,Inserted.YYYYMMDD
                                     ,0  AS QTY
                                     ,Inserted.ORIGIN_DIVISION_ID
                                     ,Inserted.ELECTRODE_TYPE
                                     ,Inserted.CELL_QTY
                                     ,@v_batch_user AS CREATED_BY
                                     ,GETDATE() AS CREATION_DATE
                                     ,@v_batch_user AS LAST_UPDATED_BY
                                     ,GETDATE() AS LAST_UPDATE_DATE                             
                        )

                        AS Changes ( Action
                                    ,DIVISION_ID
                                    ,PLAN_START_YYYYMMDD
                                    ,PLAN_TYPE
                                    ,SEQ
                                    ,OPERATION_GROUP
                      --                             ,CELL_ITEM_ID
                                    ,SCM_SITE_ID
                                    ,ITEM_ID
                                    ,LINE_ID
                                    ,OPERATION_ID
                                    ,MEASURE
                                    ,YYYYMMDD
                                    ,QTY
                                    ,ORIGIN_DIVISION_ID
                                    ,ELECTRODE_TYPE
                                    ,CELL_QTY
                                    ,CREATED_BY
                                    ,CREATION_DATE
                                    ,LAST_UPDATED_BY
                                    ,LAST_UPDATE_DATE
                                    ) 
                        WHERE Action = 'INSERT' 
                                ;

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN_H : History 입력
            -------------------------------------------------------------------------------------------------------------         
            -- SELECT top 10 * FROM dbo.SCP_ANL_PRODUCTION_PLAN_H WITH (NOLOCK)     -- HISTORY_SEQ
            -------------------------------------------------------------------------------------------------------------   
--                      SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H

                      INSERT INTO dbo.SCP_ANL_PRODUCTION_PLAN_H
                      (
                        HISTORY_SEQ
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,SCM_SITE_ID
                        ,ITEM_ID
                        ,LINE_ID
                        ,OPERATION_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,HISTORY_CREATION_DATE
                      )
                      SELECT 
                        NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H
                        ,DIVISION_ID
                        ,PLAN_START_YYYYMMDD
                        ,PLAN_TYPE
                        ,SEQ
                        ,OPERATION_GROUP
                        ,SCM_SITE_ID
                        ,ITEM_ID
                        ,LINE_ID
                        ,OPERATION_ID
                        ,MEASURE
                        ,YYYYMMDD
                        ,QTY
                        ,ORIGIN_DIVISION_ID
                        ,ELECTRODE_TYPE
                        ,@v_batch_user   AS CREATED_BY
                        ,GETDATE()    AS CREATION_DATE
                        ,@v_batch_user   AS LAST_UPDATED_BY
                        ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE() AS HISTORY_CREATION_DATE
                       FROM #SCP_ANL_PRODUCTION_PLAN  WITH (NOLOCK)


            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN_FIX : FIX 입력
            -------------------------------------------------------------------------------------------------------------  
                      UPDATE X
                        SET  X.QTY              = Y.QTY
                            ,X.ATTRIBUTE1       ='Y'
                            ,X.LAST_UPDATED_BY  = @v_batch_user
                            ,X.LAST_UPDATE_DATE = GETDATE()
                        FROM SCP_ANL_PRODUCTION_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD
                        INNER JOIN #SCP_ANL_PRODUCTION_PLAN Y WITH (NOLOCK)
                        ON 0 = 0
                        AND X.DIVISION_ID       = Y.DIVISION_ID
                        AND X.OPERATION_GROUP   = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID       = Y.SCM_SITE_ID
                        AND X.ITEM_ID           = Y.ITEM_ID
                        AND X.LINE_ID           = Y.LINE_ID
                        AND X.OPERATION_ID      = Y.OPERATION_ID
                        AND X.YYYYMMDD          = Y.YYYYMMDD

            -------------------------------------------------------------------------------------------------------------         
            -- SCP_ANL_PRODUCTION_PLAN_FIX : FIX History 입력
            -------------------------------------------------------------------------------------------------------------         

--                       SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H 
                       --SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H

                      INSERT INTO dbo.SCP_ANL_PRODUCTION_PLAN_FIX_H
                      (
                          HISTORY_SEQ
                          ,FIX_ID
                          ,DIVISION_ID
                          ,OPERATION_GROUP
                          ,SCM_SITE_ID
                          ,ITEM_ID
                          ,LINE_ID
                          ,OPERATION_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          --,ATTRIBUTE1
                          --,ATTRIBUTE2
                          --,ATTRIBUTE3
                          --,ATTRIBUTE4
                          --,ATTRIBUTE5
                          --,ATTRIBUTE6
                          --,ATTRIBUTE7
                          --,ATTRIBUTE8
                          --,ATTRIBUTE9
                          --,ATTRIBUTE10
                          ,HISTORY_CREATION_DATE
                    )

                    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
                          ,FIX_ID
                          ,DIVISION_ID
                          ,OPERATION_GROUP
                          ,SCM_SITE_ID
                          ,ITEM_ID
                          ,LINE_ID
                          ,OPERATION_ID
                          ,YYYYMMDD
                          ,QTY
                          ,FIX_REASON
                          ,ORIGIN_DIVISION_ID
                          ,ELECTRODE_TYPE
                          ,@v_batch_user   AS CREATED_BY
                          ,GETDATE()    AS CREATION_DATE
                          ,@v_batch_user   AS LAST_UPDATED_BY
                          ,GETDATE()    AS LAST_UPDATE_DATE
                        --,ATTRIBUTE1
                        --,ATTRIBUTE2
                        --,ATTRIBUTE3
                        --,ATTRIBUTE4
                        --,ATTRIBUTE5
                        --,ATTRIBUTE6
                        --,ATTRIBUTE7
                        --,ATTRIBUTE8
                        --,ATTRIBUTE9
                        --,ATTRIBUTE10
                        ,GETDATE()    AS HISTORY_CREATION_DATE
                   FROM SCP_ANL_PRODUCTION_PLAN_FIX  WITH (NOLOCK)
                  WHERE ATTRIBUTE1 = 'Y'


              UPDATE X
                    SET X.ATTRIBUTE1 = NULL       -- History 구분을 위해 원상복구
                    FROM SCP_ANL_PRODUCTION_PLAN_FIX  X WITH (NOLOCK)     -- FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD
                    INNER JOIN #SCP_ANL_PRODUCTION_PLAN Y WITH (NOLOCK)
                    ON 0 = 0
                    AND X.DIVISION_ID     = Y.DIVISION_ID
                    AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                    AND X.SCM_SITE_ID     = Y.SCM_SITE_ID
                    AND X.ITEM_ID         = Y.ITEM_ID
                    AND X.LINE_ID         = Y.LINE_ID
                    AND X.OPERATION_ID    = Y.OPERATION_ID
                    AND X.YYYYMMDD        = Y.YYYYMMDD
                    AND X.ATTRIBUTE1      =N'Y'

             
            END

            -----------------------------------------------------------
              -- FROZEN 구간 복구              
              -----------------------------------------------------------
               print @p_create_from_yyyymmdd
				print @p_create_to_yyyymmdd
               -------------------------------------------------------------------------------------------------------------         
                  -- 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_MODIFY)
                  -------------------------------------------------------------------------------------------------------------  
                      IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY') IS NOT NULL	
	                        DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY

                    --DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY
                    CREATE TABLE #SCP_XLS_PSI_GLOBAL_MODIFY(
	                    XLS_KEY1       INT     NOT NULL, DIVISION_ID       NVARCHAR(30)     NOT NULL, CREATE_FROM_YYYYMMDD     NVARCHAR(8)     NOT NULL,
                      QTY001  NUMERIC (20,10) NULL, QTY002  NUMERIC (20,10) NULL, QTY003  NUMERIC (20,10) NULL, QTY004 NUMERIC (20,10) NULL,  QTY005  NUMERIC (20,10) NULL, -- 신규
	                    QTY006  NUMERIC (20,10) NULL,	QTY007  NUMERIC (20,10) NULL, QTY008  NUMERIC (20,10) NULL, QTY009 NUMERIC (20,10) NULL,  QTY010  NUMERIC (20,10) NULL,
	                    QTY011  NUMERIC (20,10) NULL, QTY012  NUMERIC (20,10) NULL, QTY013  NUMERIC (20,10) NULL, QTY014 NUMERIC (20,10) NULL,  QTY015  NUMERIC (20,10) NULL,
	                    QTY016  NUMERIC (20,10) NULL,	QTY017  NUMERIC (20,10) NULL, QTY018  NUMERIC (20,10) NULL, QTY019 NUMERIC (20,10) NULL,  QTY020  NUMERIC (20,10) NULL,
                      QTY021  NUMERIC (20,10) NULL, QTY022  NUMERIC (20,10) NULL, QTY023  NUMERIC (20,10) NULL, QTY024 NUMERIC (20,10) NULL,  QTY025  NUMERIC (20,10) NULL,
	                    QTY026  NUMERIC (20,10) NULL,	QTY027  NUMERIC (20,10) NULL, QTY028  NUMERIC (20,10) NULL, QTY029 NUMERIC (20,10) NULL,  QTY030  NUMERIC (20,10) NULL,
                      QTY031  NUMERIC (20,10) NULL, QTY032  NUMERIC (20,10) NULL, QTY033  NUMERIC (20,10) NULL, QTY034 NUMERIC (20,10) NULL,  QTY035  NUMERIC (20,10) NULL,
	                    QTY036  NUMERIC (20,10) NULL,	QTY037  NUMERIC (20,10) NULL, QTY038  NUMERIC (20,10) NULL, QTY039 NUMERIC (20,10) NULL,  QTY040  NUMERIC (20,10) NULL,
                      QTY041  NUMERIC (20,10) NULL, QTY042  NUMERIC (20,10) NULL, QTY043  NUMERIC (20,10) NULL, QTY044 NUMERIC (20,10) NULL,  QTY045  NUMERIC (20,10) NULL,
	                    QTY046  NUMERIC (20,10) NULL,	QTY047  NUMERIC (20,10) NULL, QTY048  NUMERIC (20,10) NULL, QTY049 NUMERIC (20,10) NULL,  QTY050  NUMERIC (20,10) NULL,

                      QTY051  NUMERIC (20,10) NULL, QTY052  NUMERIC (20,10) NULL, QTY053  NUMERIC (20,10) NULL, QTY054 NUMERIC (20,10) NULL,  QTY055  NUMERIC (20,10) NULL,
	                    QTY056  NUMERIC (20,10) NULL,	QTY057  NUMERIC (20,10) NULL, QTY058  NUMERIC (20,10) NULL, QTY059 NUMERIC (20,10) NULL,  QTY060  NUMERIC (20,10) NULL,
                      QTY061  NUMERIC (20,10) NULL, QTY062  NUMERIC (20,10) NULL, QTY063  NUMERIC (20,10) NULL, QTY064 NUMERIC (20,10) NULL,  QTY065  NUMERIC (20,10) NULL,
	                    QTY066  NUMERIC (20,10) NULL,	QTY067  NUMERIC (20,10) NULL, QTY068  NUMERIC (20,10) NULL, QTY069 NUMERIC (20,10) NULL,  QTY070  NUMERIC (20,10) NULL,
                      QTY071  NUMERIC (20,10) NULL, QTY072  NUMERIC (20,10) NULL, QTY073  NUMERIC (20,10) NULL, QTY074 NUMERIC (20,10) NULL,  QTY075  NUMERIC (20,10) NULL,
	                    QTY076  NUMERIC (20,10) NULL,	QTY077  NUMERIC (20,10) NULL, QTY078  NUMERIC (20,10) NULL, QTY079 NUMERIC (20,10) NULL,  QTY080  NUMERIC (20,10) NULL,
                      QTY081  NUMERIC (20,10) NULL, QTY082  NUMERIC (20,10) NULL, QTY083  NUMERIC (20,10) NULL, QTY084 NUMERIC (20,10) NULL,  QTY085  NUMERIC (20,10) NULL,
	                    QTY086  NUMERIC (20,10) NULL,	QTY087  NUMERIC (20,10) NULL, QTY088  NUMERIC (20,10) NULL, QTY089 NUMERIC (20,10) NULL,  QTY090  NUMERIC (20,10) NULL,
                      QTY091  NUMERIC (20,10) NULL, QTY092  NUMERIC (20,10) NULL, QTY093  NUMERIC (20,10) NULL, QTY094 NUMERIC (20,10) NULL,  QTY095  NUMERIC (20,10) NULL,
	                    QTY096  NUMERIC (20,10) NULL,	QTY097  NUMERIC (20,10) NULL, QTY098  NUMERIC (20,10) NULL, QTY099 NUMERIC (20,10) NULL,  QTY100  NUMERIC (20,10) NULL,

                      QTY101  NUMERIC (20,10) NULL, QTY102  NUMERIC (20,10) NULL, QTY103  NUMERIC (20,10) NULL, QTY104 NUMERIC (20,10) NULL,  QTY105  NUMERIC (20,10) NULL,
	                    QTY106  NUMERIC (20,10) NULL,	QTY107  NUMERIC (20,10) NULL, QTY108  NUMERIC (20,10) NULL, QTY109 NUMERIC (20,10) NULL,  QTY110  NUMERIC (20,10) NULL,
	                    QTY111  NUMERIC (20,10) NULL, QTY112  NUMERIC (20,10) NULL, QTY113  NUMERIC (20,10) NULL, QTY114 NUMERIC (20,10) NULL,  QTY115  NUMERIC (20,10) NULL,
	                    QTY116  NUMERIC (20,10) NULL,	QTY117  NUMERIC (20,10) NULL, QTY118  NUMERIC (20,10) NULL, QTY119 NUMERIC (20,10) NULL,  QTY120  NUMERIC (20,10) NULL,
                      QTY121  NUMERIC (20,10) NULL, QTY122  NUMERIC (20,10) NULL, QTY123  NUMERIC (20,10) NULL, QTY124 NUMERIC (20,10) NULL,  QTY125  NUMERIC (20,10) NULL,
	                    QTY126  NUMERIC (20,10) NULL,	QTY127  NUMERIC (20,10) NULL, QTY128  NUMERIC (20,10) NULL, QTY129 NUMERIC (20,10) NULL,  QTY130  NUMERIC (20,10) NULL,
                      QTY131  NUMERIC (20,10) NULL, QTY132  NUMERIC (20,10) NULL, QTY133  NUMERIC (20,10) NULL, QTY134 NUMERIC (20,10) NULL,  QTY135  NUMERIC (20,10) NULL,
	                    QTY136  NUMERIC (20,10) NULL,	QTY137  NUMERIC (20,10) NULL, QTY138  NUMERIC (20,10) NULL, QTY139 NUMERIC (20,10) NULL,  QTY140  NUMERIC (20,10) NULL,
                      QTY141  NUMERIC (20,10) NULL, QTY142  NUMERIC (20,10) NULL, QTY143  NUMERIC (20,10) NULL, QTY144 NUMERIC (20,10) NULL,  QTY145  NUMERIC (20,10) NULL,
	                    QTY146  NUMERIC (20,10) NULL,	QTY147  NUMERIC (20,10) NULL, QTY148  NUMERIC (20,10) NULL, QTY149 NUMERIC (20,10) NULL,  QTY150  NUMERIC (20,10) NULL,

                      QTY151  NUMERIC (20,10) NULL, QTY152  NUMERIC (20,10) NULL, QTY153  NUMERIC (20,10) NULL, QTY154 NUMERIC (20,10) NULL,  QTY155  NUMERIC (20,10) NULL,
	                    QTY156  NUMERIC (20,10) NULL,	QTY157  NUMERIC (20,10) NULL, QTY158  NUMERIC (20,10) NULL, QTY159 NUMERIC (20,10) NULL,  QTY160  NUMERIC (20,10) NULL,
                      QTY161  NUMERIC (20,10) NULL, QTY162  NUMERIC (20,10) NULL, QTY163  NUMERIC (20,10) NULL, QTY164 NUMERIC (20,10) NULL,  QTY165  NUMERIC (20,10) NULL,
	                    QTY166  NUMERIC (20,10) NULL,	QTY167  NUMERIC (20,10) NULL, QTY168  NUMERIC (20,10) NULL, QTY169 NUMERIC (20,10) NULL,  QTY170  NUMERIC (20,10) NULL,
                      QTY171  NUMERIC (20,10) NULL, QTY172  NUMERIC (20,10) NULL, QTY173  NUMERIC (20,10) NULL, QTY174 NUMERIC (20,10) NULL,  QTY175  NUMERIC (20,10) NULL,
	                    QTY176  NUMERIC (20,10) NULL,	QTY177  NUMERIC (20,10) NULL, QTY178  NUMERIC (20,10) NULL, QTY179 NUMERIC (20,10) NULL,  QTY180  NUMERIC (20,10) NULL,
                      QTY181  NUMERIC (20,10) NULL, QTY182  NUMERIC (20,10) NULL, QTY183  NUMERIC (20,10) NULL, QTY184 NUMERIC (20,10) NULL,  QTY185  NUMERIC (20,10) NULL,
	                    QTY186  NUMERIC (20,10) NULL,	QTY187  NUMERIC (20,10) NULL, QTY188  NUMERIC (20,10) NULL, QTY189 NUMERIC (20,10) NULL,  QTY190  NUMERIC (20,10) NULL,
                      QTY191  NUMERIC (20,10) NULL, QTY192  NUMERIC (20,10) NULL, QTY193  NUMERIC (20,10) NULL, QTY194 NUMERIC (20,10) NULL,  QTY195  NUMERIC (20,10) NULL,
	                    QTY196  NUMERIC (20,10) NULL,	QTY197  NUMERIC (20,10) NULL, QTY198  NUMERIC (20,10) NULL, QTY199 NUMERIC (20,10) NULL,  QTY200  NUMERIC (20,10) NULL,

                      QTY201  NUMERIC (20,10) NULL, QTY202  NUMERIC (20,10) NULL, QTY203  NUMERIC (20,10) NULL, QTY204 NUMERIC (20,10) NULL,  QTY205  NUMERIC (20,10) NULL,
	                    QTY206  NUMERIC (20,10) NULL,	QTY207  NUMERIC (20,10) NULL, QTY208  NUMERIC (20,10) NULL, QTY209 NUMERIC (20,10) NULL,  QTY210  NUMERIC (20,10) NULL,
	                    QTY211  NUMERIC (20,10) NULL, QTY212  NUMERIC (20,10) NULL, QTY213  NUMERIC (20,10) NULL, QTY214 NUMERIC (20,10) NULL,  QTY215  NUMERIC (20,10) NULL,
	                    QTY216  NUMERIC (20,10) NULL,	QTY217  NUMERIC (20,10) NULL, QTY218  NUMERIC (20,10) NULL, QTY219 NUMERIC (20,10) NULL,  QTY220  NUMERIC (20,10) NULL,
                      QTY221  NUMERIC (20,10) NULL, QTY222  NUMERIC (20,10) NULL, QTY223  NUMERIC (20,10) NULL, QTY224 NUMERIC (20,10) NULL,  QTY225  NUMERIC (20,10) NULL,
	                    QTY226  NUMERIC (20,10) NULL,	QTY227  NUMERIC (20,10) NULL, QTY228  NUMERIC (20,10) NULL, QTY229 NUMERIC (20,10) NULL,  QTY230  NUMERIC (20,10) NULL,
                      QTY231  NUMERIC (20,10) NULL, QTY232  NUMERIC (20,10) NULL, QTY233  NUMERIC (20,10) NULL, QTY234 NUMERIC (20,10) NULL,  QTY235  NUMERIC (20,10) NULL,
	                    QTY236  NUMERIC (20,10) NULL,	QTY237  NUMERIC (20,10) NULL, QTY238  NUMERIC (20,10) NULL, QTY239 NUMERIC (20,10) NULL,  QTY240  NUMERIC (20,10) NULL,
                      QTY241  NUMERIC (20,10) NULL, QTY242  NUMERIC (20,10) NULL, QTY243  NUMERIC (20,10) NULL, QTY244 NUMERIC (20,10) NULL,  QTY245  NUMERIC (20,10) NULL,
	                    QTY246  NUMERIC (20,10) NULL,	QTY247  NUMERIC (20,10) NULL, QTY248  NUMERIC (20,10) NULL, QTY249 NUMERIC (20,10) NULL,  QTY250  NUMERIC (20,10) NULL,

                      QTY251  NUMERIC (20,10) NULL, QTY252  NUMERIC (20,10) NULL, QTY253  NUMERIC (20,10) NULL, QTY254 NUMERIC (20,10) NULL,  QTY255  NUMERIC (20,10) NULL,
	                    QTY256  NUMERIC (20,10) NULL,	QTY257  NUMERIC (20,10) NULL, QTY258  NUMERIC (20,10) NULL, QTY259 NUMERIC (20,10) NULL,  QTY260  NUMERIC (20,10) NULL,
                      QTY261  NUMERIC (20,10) NULL, QTY262  NUMERIC (20,10) NULL, QTY263  NUMERIC (20,10) NULL, QTY264 NUMERIC (20,10) NULL,  QTY265  NUMERIC (20,10) NULL,
	                    QTY266  NUMERIC (20,10) NULL,	QTY267  NUMERIC (20,10) NULL, QTY268  NUMERIC (20,10) NULL, QTY269 NUMERIC (20,10) NULL,  QTY270  NUMERIC (20,10) NULL,
                      QTY271  NUMERIC (20,10) NULL, QTY272  NUMERIC (20,10) NULL, QTY273  NUMERIC (20,10) NULL, QTY274 NUMERIC (20,10) NULL,  QTY275  NUMERIC (20,10) NULL,
	                    QTY276  NUMERIC (20,10) NULL,	QTY277  NUMERIC (20,10) NULL, QTY278  NUMERIC (20,10) NULL, QTY279 NUMERIC (20,10) NULL,  QTY280  NUMERIC (20,10) NULL,
                      QTY281  NUMERIC (20,10) NULL, QTY282  NUMERIC (20,10) NULL, QTY283  NUMERIC (20,10) NULL, QTY284 NUMERIC (20,10) NULL,  QTY285  NUMERIC (20,10) NULL,
	                    QTY286  NUMERIC (20,10) NULL,	QTY287  NUMERIC (20,10) NULL, QTY288  NUMERIC (20,10) NULL, QTY289 NUMERIC (20,10) NULL,  QTY290  NUMERIC (20,10) NULL,
                      QTY291  NUMERIC (20,10) NULL, QTY292  NUMERIC (20,10) NULL, QTY293  NUMERIC (20,10) NULL, QTY294 NUMERIC (20,10) NULL,  QTY295  NUMERIC (20,10) NULL,
	                    QTY296  NUMERIC (20,10) NULL,	QTY297  NUMERIC (20,10) NULL, QTY298  NUMERIC (20,10) NULL, QTY299 NUMERIC (20,10) NULL,  QTY300  NUMERIC (20,10) NULL,

                      QTY301  NUMERIC (20,10) NULL, QTY302  NUMERIC (20,10) NULL, QTY303  NUMERIC (20,10) NULL, QTY304 NUMERIC (20,10) NULL,  QTY305  NUMERIC (20,10) NULL,
	                    QTY306  NUMERIC (20,10) NULL,	QTY307  NUMERIC (20,10) NULL, QTY308  NUMERIC (20,10) NULL, QTY309 NUMERIC (20,10) NULL,  QTY310  NUMERIC (20,10) NULL,
	                    QTY311  NUMERIC (20,10) NULL, QTY312  NUMERIC (20,10) NULL, QTY313  NUMERIC (20,10) NULL, QTY314 NUMERIC (20,10) NULL,  QTY315  NUMERIC (20,10) NULL,
	                    QTY316  NUMERIC (20,10) NULL,	QTY317  NUMERIC (20,10) NULL, QTY318  NUMERIC (20,10) NULL, QTY319 NUMERIC (20,10) NULL,  QTY320  NUMERIC (20,10) NULL,
                      QTY321  NUMERIC (20,10) NULL, QTY322  NUMERIC (20,10) NULL, QTY323  NUMERIC (20,10) NULL, QTY324 NUMERIC (20,10) NULL,  QTY325  NUMERIC (20,10) NULL,
	                    QTY326  NUMERIC (20,10) NULL,	QTY327  NUMERIC (20,10) NULL, QTY328  NUMERIC (20,10) NULL, QTY329 NUMERIC (20,10) NULL,  QTY330  NUMERIC (20,10) NULL,
                      QTY331  NUMERIC (20,10) NULL, QTY332  NUMERIC (20,10) NULL, QTY333  NUMERIC (20,10) NULL, QTY334 NUMERIC (20,10) NULL,  QTY335  NUMERIC (20,10) NULL,
	                    QTY336  NUMERIC (20,10) NULL,	QTY337  NUMERIC (20,10) NULL, QTY338  NUMERIC (20,10) NULL, QTY339 NUMERIC (20,10) NULL,  QTY340  NUMERIC (20,10) NULL,
                      QTY341  NUMERIC (20,10) NULL, QTY342  NUMERIC (20,10) NULL, QTY343  NUMERIC (20,10) NULL, QTY344 NUMERIC (20,10) NULL,  QTY345  NUMERIC (20,10) NULL,
	                    QTY346  NUMERIC (20,10) NULL,	QTY347  NUMERIC (20,10) NULL, QTY348  NUMERIC (20,10) NULL, QTY349 NUMERIC (20,10) NULL,  QTY350  NUMERIC (20,10) NULL,

                      QTY351  NUMERIC (20,10) NULL, QTY352  NUMERIC (20,10) NULL, QTY353  NUMERIC (20,10) NULL, QTY354 NUMERIC (20,10) NULL,  QTY355  NUMERIC (20,10) NULL,
	                    QTY356  NUMERIC (20,10) NULL,	QTY357  NUMERIC (20,10) NULL, QTY358  NUMERIC (20,10) NULL, QTY359 NUMERIC (20,10) NULL,  QTY360  NUMERIC (20,10) NULL,
                      QTY361  NUMERIC (20,10) NULL, QTY362  NUMERIC (20,10) NULL, QTY363  NUMERIC (20,10) NULL, QTY364 NUMERIC (20,10) NULL,
                    ) 
					print '66666666666666666666666666666'
              DECLARE @X_ITEM_ID         NVARCHAR(50) = ''

              -- SCP_ANL_SHIPMENT_PLAN_FG/SEMI PK Parameter 
              DECLARE @X_OPERATION_GROUP NVARCHAR(50) = ''   -- BIZ_TYPE
              DECLARE @X_PROJECT_CODE    NVARCHAR(50) = ''
              DECLARE @X_TO_SITE         NVARCHAR(50) = ''
              DECLARE @X_INCOTERMS       NVARCHAR(50) = ''
              DECLARE @X_FROM_SITE       NVARCHAR(50) = ''   -- SCM_SITE_ID
              DECLARE @X_BOD_ID          NVARCHAR(50) = ''

              -- SCP_ANL_PRODUCTION_PLAN PK Parameter 
              DECLARE @X_LINE_ID         NVARCHAR(50) = ''
              DECLARE @X_OPERATION_ID    NVARCHAR(50) = ''


              SELECT @X_OPERATION_GROUP  = OPERATION_GROUP
                    ,@X_ITEM_ID          = ITEM_ID
                    ,@X_LINE_ID          = PROD_LINE
                    ,@X_OPERATION_ID     = ATTRIBUTE9 
                    ,@X_PROJECT_CODE     = PROJECT_CODE
                    ,@X_TO_SITE          = TO_SITE
                    ,@X_INCOTERMS        = INCOTERMS
                    ,@X_FROM_SITE        = FROM_SITE
                    ,@X_BOD_ID           = BOD_ID
              FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK  WITH (NOLOCK)
              WHERE DIVISION_ID			= @v_batch_division_id
			    AND PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
				AND CREATE_FROM_YYYYMMDD =@v_batch_create_from_yyyymmdd
			    AND PLAN_TYPE			= @v_batch_plan_type 
				AND SEQ					= @v_batch_seq
				AND XLS_KEY1			= @v_batch_xls_key1
				;
		

        -----------------------------------------------------------
        -- FROZEN 구간 복구
        -----------------------------------------------------------
		-- 2022.08.25 PACK_PROD 만 FROZEN 처리되는 것으로 오류수정 
        IF @v_batch_measure = 'PACK_PROD'-----------------------------------------------------------------------------------XXXXXX
        BEGIN        
            -------------------------------------------------------------------------------------------------------------         
            -- 저장후 시물레이션 데이터 UPDATE
            -------------------------------------------------------------------------------------------------------------
                  
              DECLARE @mQry_sum2 NVARCHAR(MAX);      
   
		          SET     @mQry_sum2 = '';
		          SELECT  @mQry_sum2 = @mQry_sum2+','+       
			          CASE  
                      WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN QTY ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
			          END +''+CHAR(10)      
		          FROM (       
			          SELECT A.BASIS_YYYYMMDD                    AS YYYYMMDD    
                      , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO      
  	  	          FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	     
				  /*
	 		            WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd 
                    AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd
					*/
					WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
						AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd

			            GROUP BY A.BASIS_YYYYMMDD       
		          ) AS A      
		          ORDER BY SORT_ORDER_NO  ;      

                    
              DECLARE @mEXEC2 NVARCHAR(MAX);

		          SET @mEXEC2 = '';
              SET @mEXEC2 = @mEXEC2 + ' INSERT INTO #SCP_XLS_PSI_GLOBAL_MODIFY WITH (TABLOCK)  '+CHAR(10);	

                    
              ------------------------------------------------------------------------------------------------------------- 
              -- 'SHIP_PLAN'
              -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, YYYYMMDD, BIZ_TYPE, ITEM_ID, PROJECT_CODE, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE
              ------------------------------------------------------------------------------------------------------------- 
              DECLARE @mFG NVARCHAR(MAX) = '';

		          SET @mFG = @mFG + ' SELECT  '''+ convert(varchar, @v_batch_xls_key1)  +''' AS XLS_KEY1  '+CHAR(10);	
				  SET @mFG = @mFG + '         ,'''+ convert(varchar, @v_batch_division_id)  +''' AS DIVISION_ID  '+CHAR(10);	
				  SET @mFG = @mFG + '         ,'''+ convert(varchar, @v_batch_create_from_yyyymmdd)  +''' AS CREATE_FROM_YYYYMMDD  '+CHAR(10);	

		          SET @mFG = @mFG + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
  	          SET @mFG = @mFG + ' 		FROM SCP_ANL_SHIPMENT_PLAN_FG WITH (NOLOCK)  '+CHAR(10);	
              SET @mFG = @mFG + ' 		WHERE 0 = 0                                 '+CHAR(10);	
              SET @mFG = @mFG + ' 		AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);	
              SET @mFG = @mFG + ' 		AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);		
              SET @mFG = @mFG + ' 		AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);	
              SET @mFG = @mFG + ' 		AND SEQ                 =  '+ CONVERT(NVARCHAR,@v_batch_seq)+'' +CHAR(10);
                    
              SET @mFG = @mFG + ' 		AND BIZ_TYPE            =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
              SET @mFG = @mFG + ' 		AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
              SET @mFG = @mFG + ' 		AND PROJECT_CODE        =  '''+ @X_PROJECT_CODE+'''' +CHAR(10);	
              SET @mFG = @mFG + ' 		AND TO_SITE             =  '''+ @X_TO_SITE+'''' +CHAR(10);	
              SET @mFG = @mFG + ' 		AND INCOTERMS           =  '''+ @X_INCOTERMS+'''' +CHAR(10);		
              SET @mFG = @mFG + ' 		AND FROM_SITE           =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
              SET @mFG = @mFG + ' 		AND BOD_ID              =  '''+ @X_BOD_ID+'''' +CHAR(10);	
                    
              SET @mFG = @mFG + ' 		AND MEASURE             = ''SHIP_PLAN_AMEND'' '+CHAR(10);	
--              SET @mFG = @mFG + ' 		AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);
			  SET @mFG = @mFG + ' 		AND YYYYMMDD            >=  '''+ @v_batch_create_from_yyyymmdd +''''+CHAR(10);
			  SET @mFG = @mFG + ' 		AND YYYYMMDD            <  '''+ @v_batch_create_to_yyyymmdd +''''+CHAR(10);

              ------------------------------------------------------------------------------------------------------------- 
              -- 'SEMI_SHIP_PLAN'
              -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, FROM_SITE, BOD_ID, MEASURE, YYYYMMDD
              ------------------------------------------------------------------------------------------------------------- 
			  -- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - start 
              --               - CELL_SHIP_PLAN (Ship Plan(SCP)) Measure 를 SEMI_SHIP_PLAN 에 준하여 처리하는 로직을 추가
			  -- 주석해제
              
              DECLARE @mSEMI NVARCHAR(MAX) = '';

		          SET @mSEMI = @mSEMI + ' SELECT  '''+ convert(varchar, @v_batch_xls_key1)  +''' AS XLS_KEY1  '+CHAR(10);	
				  SET @mSEMI = @mSEMI + '         ,'''+ convert(varchar, @v_batch_division_id)  +''' AS DIVISION_ID  '+CHAR(10);	
				  SET @mSEMI = @mSEMI + '         ,'''+ convert(varchar, @v_batch_create_from_yyyymmdd)  +''' AS CREATE_FROM_YYYYMMDD  '+CHAR(10);	

		          SET @mSEMI = @mSEMI + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
  	          SET @mSEMI = @mSEMI + ' 		FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH (NOLOCK)  '+CHAR(10);	
              SET @mSEMI = @mSEMI + ' 		WHERE 0 = 0                                 '+CHAR(10);	
              SET @mSEMI = @mSEMI + ' 		AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);	
              SET @mSEMI = @mSEMI + ' 		AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);		
              SET @mSEMI = @mSEMI + '     AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);	
              SET @mSEMI = @mSEMI + ' 		AND SEQ                 =  '+ CONVERT(NVARCHAR,@v_batch_seq)+'' +CHAR(10);
                    
              SET @mSEMI = @mSEMI + ' 		AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
              SET @mSEMI = @mSEMI + ' 		AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
              SET @mSEMI = @mSEMI + ' 		AND FROM_SITE           =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
              SET @mSEMI = @mSEMI + ' 		AND BOD_ID              =  '''+ @X_BOD_ID+'''' +CHAR(10);	
                    
              SET @mSEMI = @mSEMI + ' 		AND MEASURE             = ''SHIP_PLAN_AMEND'' '+CHAR(10);	
--              SET @mSEMI = @mSEMI + ' 		AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);

			  SET @mSEMI = @mSEMI + ' 		AND YYYYMMDD            >=  '''+ @v_batch_create_from_yyyymmdd +''''+CHAR(10);
			  SET @mSEMI = @mSEMI + ' 		AND YYYYMMDD            <  '''+ @v_batch_create_to_yyyymmdd +''''+CHAR(10);

              -- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - end

              ------------------------------------------------------------------------------------------------------------- 
              -- 'PACK_PROD','CELL_PROD'
              -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
              ------------------------------------------------------------------------------------------------------------- 
              DECLARE @mPROD NVARCHAR(MAX) = '';

		          SET @mPROD = @mPROD + ' SELECT  '''+ convert(varchar, @v_batch_xls_key1)  +''' AS XLS_KEY1  '+CHAR(10);	
				  SET @mPROD = @mPROD + '         ,'''+ convert(varchar, @v_batch_division_id)  +''' AS DIVISION_ID  '+CHAR(10);	
				  SET @mPROD = @mPROD + '         ,'''+ convert(varchar, @v_batch_create_from_yyyymmdd)  +''' AS CREATE_FROM_YYYYMMDD  '+CHAR(10);

		          SET @mPROD = @mPROD + ' 				' + @mQry_sum2 +'									      '+CHAR(10);	
  	          SET @mPROD = @mPROD + ' 		FROM SCP_ANL_PRODUCTION_PLAN WITH (NOLOCK)  '+CHAR(10);	
              SET @mPROD = @mPROD + ' 		WHERE 0 = 0                                 '+CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND DIVISION_ID         =  '''+ @v_batch_division_id  +'''' +CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND PLAN_START_YYYYMMDD =  '''+ @v_batch_plan_start_yyyymmdd+'''' +CHAR(10);		
              SET @mPROD = @mPROD + '     AND PLAN_TYPE           =  '''+ @v_batch_plan_type  +'''' +CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND SEQ                 =  '+ CONVERT(NVARCHAR,@v_batch_seq)+'' +CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND OPERATION_GROUP     =  '''+ @X_OPERATION_GROUP+'''' +CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND SCM_SITE_ID         =  '''+ @X_FROM_SITE+'''' +CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND ITEM_ID             =  '''+ @X_ITEM_ID+'''' +CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND LINE_ID             =  '''+ @X_LINE_ID+'''' +CHAR(10);	
              SET @mPROD = @mPROD + ' 		AND OPERATION_ID        =  '''+ @X_OPERATION_ID+'''' +CHAR(10);		
              SET @mPROD = @mPROD + ' 		AND MEASURE             = ''PROD_PLAN_AMEND'' '+CHAR(10);	

--              SET @mPROD = @mPROD + ' 		AND YYYYMMDD            <  '''+ @p_to_yyyymmdd +''''+CHAR(10);

			  SET @mPROD = @mPROD + ' 		AND YYYYMMDD            >=  '''+ @v_batch_create_from_yyyymmdd +''''+CHAR(10);
			  SET @mPROD = @mPROD + ' 		AND YYYYMMDD            <  '''+ @v_batch_create_to_yyyymmdd +''''+CHAR(10);
			  			  
              ------------------------------------------------------------------------------------------------------------- 



              IF @v_batch_measure IN  ('PACK_SHIP_PLAN', 'CELL_SHIP_PLAN')   -- FG--------------------------------------------------------------
                SET @mEXEC2 = @mEXEC2 + @mFG

			  -- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - start 
              --               - CELL_SHIP_PLAN (Ship Plan(SCP)) Measure 를 SEMI_SHIP_PLAN 에 준하여 처리하는 로직을 추가
			  -- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 - SEMI_SHIP_PLAN case 추가
			  -- 주석해제
			  --
              IF @v_batch_measure IN  ('CELL_SHIP_PLAN', 'SEMI_SHIP_PLAN')  -- SEMI
                SET @mEXEC2 = @mEXEC2 + @mSEMI
			  -- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - end 


			  
              IF @v_batch_measure IN  ('PACK_PROD')   -- PROD
                SET @mEXEC2 = @mEXEC2 + @mPROD

			 
			 

/*                            
            DECLARE @POS int
            DECLARE @LEN NVARCHAR(max)
				    SET @POS =1;
				    SET @LEN =LEN(@mEXEC2);
				    WHILE @POS <= @LEN
					    BEGIN
						    PRINT SUBSTRING(@mEXEC2,@POS,4000);
						    SET @POS = @POS+4000;
					    END;
*/
			
              EXEC sp_executesql @mEXEC2;

                  -- #SCP_XLS_PSI_GLOBAL_MODIFY

                  UPDATE  X SET 
                          X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005, X.QTY006= Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010,
                          X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015, X.QTY016= Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020,
                          X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025, X.QTY026= Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030,
                          X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035, X.QTY036= Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040,
                          X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045, X.QTY046= Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050,
                          X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055, X.QTY056= Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060,
                          X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065, X.QTY066= Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070,
                          X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075, X.QTY076= Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080,
                          X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085, X.QTY086= Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090,
                          X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095, X.QTY096= Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100, 

                          X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105, X.QTY106= Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110,
                          X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115, X.QTY116= Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120,
                          X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125, X.QTY126= Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130,
                          X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135, X.QTY136= Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140,
                          X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145, X.QTY146= Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150,
                          X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155, X.QTY156= Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160,
                          X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165, X.QTY166= Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170,
                          X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175, X.QTY176= Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180,
                          X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185, X.QTY186= Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190,
                          X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195, X.QTY196= Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200, 

                          X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205, X.QTY206= Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210,
                          X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215, X.QTY216= Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220,
                          X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225, X.QTY226= Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230,
                          X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235, X.QTY236= Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240,
                          X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245, X.QTY246= Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250,
                          X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255, X.QTY256= Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260,
                          X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265, X.QTY266= Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270,
                          X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275, X.QTY276= Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280,
                          X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285, X.QTY286= Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290,
                          X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295, X.QTY296= Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300, 

                          X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305, X.QTY306= Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310,
                          X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315, X.QTY316= Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320,
                          X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325, X.QTY326= Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330,
                          X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335, X.QTY336= Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340,
                          X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345, X.QTY346= Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350,
                          X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355, X.QTY356= Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360, 
                          X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364, 

                          X.WQTY01 = Y.QTY001 + Y.QTY002 +  Y.QTY003 +  Y.QTY004 +  Y.QTY005 +  Y.QTY006 +  Y.QTY007,  
                          X.WQTY02 = Y.QTY008 + Y.QTY009 +  Y.QTY010 +  Y.QTY011 +  Y.QTY012 +  Y.QTY013 +  Y.QTY014,  
                          X.WQTY03 = Y.QTY015 + Y.QTY016 +  Y.QTY017 +  Y.QTY018 +  Y.QTY019 +  Y.QTY020 +  Y.QTY021,   
                          X.WQTY04 = Y.QTY022 + Y.QTY023 +  Y.QTY024 +  Y.QTY025 +  Y.QTY026 +  Y.QTY027 +  Y.QTY028,  
                          X.WQTY05 = Y.QTY029 + Y.QTY030 +  Y.QTY031 +  Y.QTY032 +  Y.QTY033 +  Y.QTY034 +  Y.QTY035,  
                          X.WQTY06 = Y.QTY036 + Y.QTY037 +  Y.QTY038 +  Y.QTY039 +  Y.QTY040 +  Y.QTY041 +  Y.QTY042,  
                          X.WQTY07 = Y.QTY043 + Y.QTY044 +  Y.QTY045 +  Y.QTY046 +  Y.QTY047 +  Y.QTY048 +  Y.QTY049,  
                          X.WQTY08 = Y.QTY050 + Y.QTY051 +  Y.QTY052 +  Y.QTY053 +  Y.QTY054 +  Y.QTY055 +  Y.QTY056,  
                          X.WQTY09 = Y.QTY057 + Y.QTY058 +  Y.QTY059 +  Y.QTY060 +  Y.QTY061 +  Y.QTY062 +  Y.QTY063,  
                          X.WQTY10 = Y.QTY064 + Y.QTY065 +  Y.QTY066 +  Y.QTY067 +  Y.QTY068 +  Y.QTY069 +  Y.QTY070,  

                          X.WQTY11 = Y.QTY071 + Y.QTY072 +  Y.QTY073 +  Y.QTY074 +  Y.QTY075 +  Y.QTY076 +  Y.QTY077,  
                          X.WQTY12 = Y.QTY078 + Y.QTY079 +  Y.QTY080 +  Y.QTY081 +  Y.QTY082 +  Y.QTY083 +  Y.QTY084,   
                          X.WQTY13 = Y.QTY085 + Y.QTY086 +  Y.QTY087 +  Y.QTY088 +  Y.QTY089 +  Y.QTY090 +  Y.QTY091,  
                          X.WQTY14 = Y.QTY092 + Y.QTY093 +  Y.QTY094 +  Y.QTY095 +  Y.QTY096 +  Y.QTY097 +  Y.QTY098,  
                          X.WQTY15 = Y.QTY099 + Y.QTY100 +  Y.QTY101 +  Y.QTY102 +  Y.QTY103 +  Y.QTY104 +  Y.QTY105,  
                          X.WQTY16 = Y.QTY106 + Y.QTY107 +  Y.QTY108 +  Y.QTY109 +  Y.QTY110 +  Y.QTY111 +  Y.QTY112,  
                          X.WQTY17 = Y.QTY113 + Y.QTY114 +  Y.QTY115 +  Y.QTY116 +  Y.QTY117 +  Y.QTY118 +  Y.QTY119,  
                          X.WQTY18 = Y.QTY120 + Y.QTY121 +  Y.QTY122 +  Y.QTY123 +  Y.QTY124 +  Y.QTY125 +  Y.QTY126,  
                          X.WQTY19 = Y.QTY127 + Y.QTY128 +  Y.QTY129 +  Y.QTY130 +  Y.QTY131 +  Y.QTY132 +  Y.QTY133,  
                          X.WQTY20 = Y.QTY134 + Y.QTY135 +  Y.QTY136 +  Y.QTY137 +  Y.QTY138 +  Y.QTY139 +  Y.QTY140,  

                          X.WQTY21 = Y.QTY141 + Y.QTY142 +  Y.QTY143 +  Y.QTY144 +  Y.QTY145 +  Y.QTY146 +  Y.QTY147,  
                          X.WQTY22 = Y.QTY148 + Y.QTY149 +  Y.QTY150 +  Y.QTY151 +  Y.QTY152 +  Y.QTY153 +  Y.QTY154,  
                          X.WQTY23 = Y.QTY155 + Y.QTY156 +  Y.QTY157 +  Y.QTY158 +  Y.QTY159 +  Y.QTY160 +  Y.QTY161,  
                          X.WQTY24 = Y.QTY162 + Y.QTY163 +  Y.QTY164 +  Y.QTY165 +  Y.QTY166 +  Y.QTY167 +  Y.QTY168,  
                          X.WQTY25 = Y.QTY169 + Y.QTY170 +  Y.QTY171 +  Y.QTY172 +  Y.QTY173 +  Y.QTY174 +  Y.QTY175,  
                          X.WQTY26 = Y.QTY176 + Y.QTY177 +  Y.QTY178 +  Y.QTY179 +  Y.QTY180 +  Y.QTY181 +  Y.QTY182,   
                          X.WQTY27 = Y.QTY183 + Y.QTY184 +  Y.QTY185 +  Y.QTY186 +  Y.QTY187 +  Y.QTY188 +  Y.QTY189,   
                          X.WQTY28 = Y.QTY190 + Y.QTY191 +  Y.QTY192 +  Y.QTY193 +  Y.QTY194 +  Y.QTY195 +  Y.QTY196,   
                          X.WQTY29 = Y.QTY197 + Y.QTY198 +  Y.QTY199 +  Y.QTY200 +  Y.QTY201 +  Y.QTY202 +  Y.QTY203,   
                          X.WQTY30 = Y.QTY204 + Y.QTY205 +  Y.QTY206 +  Y.QTY207 +  Y.QTY208 +  Y.QTY209 +  Y.QTY210,  

                          X.WQTY31 = Y.QTY211 + Y.QTY212 +  Y.QTY213 +  Y.QTY214 +  Y.QTY215 +  Y.QTY216 +  Y.QTY217,   
                          X.WQTY32 = Y.QTY218 + Y.QTY219 +  Y.QTY220 +  Y.QTY221 +  Y.QTY222 +  Y.QTY223 +  Y.QTY224,   
                          X.WQTY33 = Y.QTY225 + Y.QTY226 +  Y.QTY227 +  Y.QTY228 +  Y.QTY229 +  Y.QTY230 +  Y.QTY231,   
                          X.WQTY34 = Y.QTY232 + Y.QTY233 +  Y.QTY234 +  Y.QTY235 +  Y.QTY236 +  Y.QTY237 +  Y.QTY238,   
                          X.WQTY35 = Y.QTY239 + Y.QTY240 +  Y.QTY241 +  Y.QTY242 +  Y.QTY243 +  Y.QTY244 +  Y.QTY245,   
                          X.WQTY36 = Y.QTY246 + Y.QTY247 +  Y.QTY248 +  Y.QTY249 +  Y.QTY250 +  Y.QTY251 +  Y.QTY252,   
                          X.WQTY37 = Y.QTY253 + Y.QTY254 +  Y.QTY255 +  Y.QTY256 +  Y.QTY257 +  Y.QTY258 +  Y.QTY259,   
                          X.WQTY38 = Y.QTY260 + Y.QTY261 +  Y.QTY262 +  Y.QTY263 +  Y.QTY264 +  Y.QTY265 +  Y.QTY266,   
                          X.WQTY39 = Y.QTY267 + Y.QTY268 +  Y.QTY269 +  Y.QTY270 +  Y.QTY271 +  Y.QTY272 +  Y.QTY273,   
                          X.WQTY40 = Y.QTY274 + Y.QTY275 +  Y.QTY276 +  Y.QTY277 +  Y.QTY278 +  Y.QTY279 +  Y.QTY280,  

                          X.WQTY41 = Y.QTY281 + Y.QTY282 +  Y.QTY283 +  Y.QTY284 +  Y.QTY285 +  Y.QTY286 +  Y.QTY287,   
                          X.WQTY42 = Y.QTY288 + Y.QTY289 +  Y.QTY290 +  Y.QTY291 +  Y.QTY292 +  Y.QTY293 +  Y.QTY294,   
                          X.WQTY43 = Y.QTY295 + Y.QTY296 +  Y.QTY297 +  Y.QTY298 +  Y.QTY299 +  Y.QTY300 +  Y.QTY301,   
                          X.WQTY44 = Y.QTY302 + Y.QTY303 +  Y.QTY304 +  Y.QTY305 +  Y.QTY306 +  Y.QTY307 +  Y.QTY308,   
                          X.WQTY45 = Y.QTY309 + Y.QTY310 +  Y.QTY311 +  Y.QTY312 +  Y.QTY313 +  Y.QTY314 +  Y.QTY315,   
                          X.WQTY46 = Y.QTY316 + Y.QTY317 +  Y.QTY318 +  Y.QTY319 +  Y.QTY320 +  Y.QTY321 +  Y.QTY322,   
                          X.WQTY47 = Y.QTY323 + Y.QTY324 +  Y.QTY325 +  Y.QTY326 +  Y.QTY327 +  Y.QTY328 +  Y.QTY329,   
                          X.WQTY48 = Y.QTY330 + Y.QTY331 +  Y.QTY332 +  Y.QTY333 +  Y.QTY334 +  Y.QTY335 +  Y.QTY336,   
                          X.WQTY49 = Y.QTY337 + Y.QTY338 +  Y.QTY339 +  Y.QTY340 +  Y.QTY341 +  Y.QTY342 +  Y.QTY343,   
                          X.WQTY50 = Y.QTY344 + Y.QTY345 +  Y.QTY346 +  Y.QTY347 +  Y.QTY348 +  Y.QTY349 +  Y.QTY350,  

                          X.WQTY51 = Y.QTY351 + Y.QTY352 +  Y.QTY353 +  Y.QTY354 +  Y.QTY355 +  Y.QTY356 +  Y.QTY357,   
                          X.WQTY52 = Y.QTY358 + Y.QTY359 +  Y.QTY360 +  Y.QTY361 +  Y.QTY362 +  Y.QTY363 +  Y.QTY364,  
                          X.LAST_UPDATED_BY   = @v_batch_user , 
                          X.LAST_UPDATE_DATE  = GETDATE() 
                    FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK) 
                   INNER JOIN #SCP_XLS_PSI_GLOBAL_MODIFY Y WITH (NOLOCK)
                      ON X.XLS_KEY1 			= Y.XLS_KEY1
					 AND X.CREATE_FROM_YYYYMMDD = Y.CREATE_FROM_YYYYMMDD
					 AND X.DIVISION_ID          = Y.DIVISION_ID
				   WHERE X.DIVISION_ID			= @v_batch_division_id
					 AND X.PLAN_START_YYYYMMDD  = @v_batch_plan_start_yyyymmdd
					 AND X.CREATE_FROM_YYYYMMDD = @v_batch_create_from_yyyymmdd
				     AND X.PLAN_TYPE			= @v_batch_plan_type 
				     AND X.SEQ					= @v_batch_seq 
					 AND X.XLS_KEY1				= @v_batch_xls_key1
				   ;


              --IF @v_batch_measure IN  ('PACK_PROD')   
			  IF @v_batch_LoadRatio = 'RATIO'		-- 가동율 계산을 위한 처리 추가 :: 마지막 PACK_PROD 건에서만 처리
              BEGIN 
              -------------------------------------------------------------------------------------------------------------         
              -- LINE_TOTAL_LOAD_ENGINE UPDATE (TACT_TIME,WORKING_TIME)  , PACK_PROD_LOAD
              -------------------------------------------------------------------------------------------------------------
              -------------------------------------------------------------------------------------------------------------         
              -- Line Load 율 로직 작업중
              -------------------------------------------------------------------------------------------------------------
              IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL      
	              DROP TABLE #LINE_WORKINGTIME_BY_LOSS;   


					-- 저장속도개선 : FN_LINE_WORKINGTIME_BY_LOSS 을 사용하지 않고 FN_LINE_WORKINGTIME_BY_LOSS 에 정의된 쿼리를 직접사용
					SELECT A.DIVISION_ID
					     , A.PLANT_SITE_ID AS SCM_SITE_ID
						 , A.OPERATION_ID
						 , A.LINE_ID
						 , A.YYYYMMDD
						 ,(CASE WHEN C.LOSS_START_DATE IS NOT NULL THEN A.WORKING_TIME - ROUND(ISNULL(C.SETUP_LOSS_TIME_MIN, 0), 0, 1) 
							    ELSE A.WORKING_TIME - ROUND( (A.WORKING_TIME_RATE * ISNULL(B.SETUP_LOSS_TIME_MIN, 0)), 0, 1) END) AS WORKING_TIME
					INTO #LINE_WORKINGTIME_BY_LOSS
					FROM (SELECT *
							  , WORKING_TIME / 1440.0 AS WORKING_TIME_RATE
						   FROM SCP_MST_WORKING_TIME WITH (NOLOCK)
					      WHERE DIVISION_ID = @v_batch_division_id --'40' --20180709 주석처리
					        AND PLANT_SITE_ID = @p_from_site
					    ) A
					LEFT JOIN SCM_MST_SITE S 
					       ON S.DIVISION_ID=A.DIVISION_ID 
					      AND S.SCM_SITE_ID=A.PLANT_SITE_ID 
						  AND (S.OSP_YN='N' OR (S.OSP_YN='Y' AND ISNULL(S.ATTRIBUTE1,'N')='Y' AND A.LINE_ID<>'-'))
					LEFT JOIN (SELECT *
								 FROM SCP_MST_LOSS_TIME WITH (NOLOCK) 
								WHERE DIVISION_ID    = @v_batch_division_id 
								  AND PLANT_SITE_ID  = @p_from_site
							) B
					       ON   A.DIVISION_ID   = B.DIVISION_ID
						  AND  A.PLANT_SITE_ID = B.PLANT_SITE_ID
						  AND  A.FACTORY_ID    = B.FACTORY_ID
						  AND  A.OPERATION_ID  = B.OPERATION_ID
						  AND  A.LINE_ID       = B.LINE_ID 
					LEFT JOIN (SELECT DIVISION_ID
									, PLANT_SITE_ID
									, FACTORY_ID
									, OPERATION_ID
									, LINE_ID
									, LOSS_START_DATE
									, LOSS_END_DATE
									, LOSS_TIME_MIN
									, SETUP_LOSS_TIME_MIN
								FROM SCP_MST_LOSS_TIME_EXCEPT WITH (NOLOCK) 
							   WHERE DIVISION_ID    = @v_batch_division_id
								 AND PLANT_SITE_ID  = @p_from_site
							) C
						   ON   A.DIVISION_ID   = C.DIVISION_ID
						  AND  A.PLANT_SITE_ID = C.PLANT_SITE_ID
						  AND  A.FACTORY_ID    = C.FACTORY_ID
						  AND  A.OPERATION_ID  = C.OPERATION_ID
						  AND  A.LINE_ID       = C.LINE_ID 
						  AND  A.YYYYMMDD      >= C.LOSS_START_DATE
						  AND  A.YYYYMMDD      <= C.LOSS_END_DATE
					 WHERE A.DIVISION_ID    = @v_batch_division_id
					   AND  A.YYYYMMDD      >= @v_batch_create_from_yyyymmdd
					   AND  A.YYYYMMDD      <= @v_batch_create_to_yyyymmdd
					
					UNION ALL 
					
					SELECT A.DIVISION_ID
						  ,A.PLANT_SITE_ID
						  ,A.OPERATION_ID
						  ,A.LINE_ID
						  ,A.YYYYMMDD 
						  ,( SELECT ISNULL(SUM(ISNULL(C.DAILY_CAPA_QTY,0)),0)
						   	   FROM  SCP_MST_OUTSOURCING_CAPA  C WITH(NOLOCK)
							  WHERE C.DIVISION_ID      = A.DIVISION_ID
								AND   C.PLANT_SITE_ID  = A.PLANT_SITE_ID
								AND   C.ITEM_ID        = '-' 
						   ) AS WORKING_TIME
					FROM  (
							SELECT W.*
								 , W.WORKING_TIME / 1440.0 AS WORKING_TIME_RATE
							FROM   SCP_MST_WORKING_TIME W WITH (NOLOCK)
								 , SCM_MST_SITE         S WITH (NOLOCK)
							WHERE W.DIVISION_ID   = @v_batch_division_id
							  AND W.DIVISION_ID   = S.DIVISION_ID
							  AND W.PLANT_SITE_ID = @p_from_site
							  AND W.PLANT_SITE_ID = S.SCM_SITE_ID
							  AND S.OSP_YN      = 'Y'
							  AND (ISNULL(S.ATTRIBUTE1,'N') IN ('','N') OR W.LINE_ID='-')
					     ) A
					WHERE 1=1
					  AND A.YYYYMMDD >= @v_batch_create_from_yyyymmdd
					  AND A.YYYYMMDD <= @v_batch_create_to_yyyymmdd
				   ;

	              IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL      
	                DROP TABLE #LineLoad;  
  	
                SELECT /*DISTINCT */
				      A.DIVISION_ID
					, A.SCM_SITE_ID 
                    , A.OPERATION_GROUP
		            , A.OPERATION_ID
		            , A.LINE_ID
                    , 'PACK_PROD_LOAD' AS MEASURE
                    , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ) ,0 ) *100  END AS QTY
					, ISNULL(ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0), 0) AS CAPA_TACT
					, ISNULL( D.WORKING_TIME ,0 ) AS WORKING_TIME
                    , A.YYYYMMDD AS YYYYMMDD
                    , C.ISO_YYYYWW AS ISO_YYYYWW
                    , 'WQTY' + REPLICATE('0', 2 - LEN(DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW) )) + CONVERT(NVARCHAR,DENSE_RANK()  OVER(PARTITION BY  A.LINE_ID ORDER BY C.ISO_YYYYWW))  AS WEEK_COLUMN
                INTO #LineLoad
			    FROM SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                INNER JOIN SCM_SYS_CALENDAR_M C   WITH (NOLOCK)
                        ON A.YYYYMMDD = C.BASIS_YYYYMMDD
			    LEFT OUTER JOIN #LINE_WORKINGTIME_BY_LOSS D  WITH (NOLOCK)
                             ON   A.DIVISION_ID   = D.DIVISION_ID 
                            AND A.OPERATION_ID  = D.OPERATION_ID 
					        AND A.SCM_SITE_ID   = D.SCM_SITE_ID 
					        AND A.LINE_ID       = D.LINE_ID 
					        AND A.YYYYMMDD      = D.YYYYMMDD
			    LEFT OUTER JOIN SCP_ANL_TACT_TIME E WITH(NOLOCK)	
                             ON A.DIVISION_ID    = E.DIVISION_ID 
                            AND A.OPERATION_ID   = E.OPERATION_ID 
				            AND A.SCM_SITE_ID    = E.SCM_SITE_ID  
				            AND A.LINE_ID        = E.LINE_ID     --- LINE_ID ='-'
						    AND A.ITEM_ID        = E.ITEM_ID 
				            AND A.YYYYMMDD       = E.YYYYMMDD
			    WHERE 1=1 
                  AND A.DIVISION_ID         = @v_batch_division_id
                  AND A.PLAN_START_YYYYMMDD = @v_batch_plan_start_yyyymmdd
                  AND A.PLAN_TYPE           = @v_batch_plan_type
                  AND A.SEQ                 = @v_batch_seq
				  AND A.YYYYMMDD           >= @v_batch_create_from_yyyymmdd
	              AND A.YYYYMMDD           <  @v_batch_create_to_yyyymmdd
	              AND A.MEASURE             = 'PROD_PLAN_AMEND'
                  AND A.OPERATION_GROUP     = 'P'
				  AND A.SCM_SITE_iD         = @p_from_site	--가동율 계산시간을 줄이기 위해서 추가
             GROUP BY A.DIVISION_ID, A.SCM_SITE_ID ,A.OPERATION_ID ,A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME,  C.ISO_YYYYWW,A.OPERATION_GROUP


			  			  print '~~~~~~~~~~1111111111111111111111111'
            -------------------------------------------------------------------------------------------------------------         
            --  364일 데이터 생성(PIVOIT 대상 날짜문자열 생성)
            -------------------------------------------------------------------------------------------------------------         
              DECLARE @mQry_sum NVARCHAR(MAX);      
   
		          SET     @mQry_sum = '';
		          SELECT  @mQry_sum = @mQry_sum+','+       
			          CASE  
                      WHEN 1 = 1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+YYYYMMDD+'''    THEN QTY ELSE 0 END ) AS ' + 'QTY' + REPLICATE('0', 3 - LEN(ROW_NUMBER() OVER(ORDER BY YYYYMMDD) )) + CONVERT(NVARCHAR,ROW_NUMBER() OVER(ORDER BY YYYYMMDD))        
			          END +''+CHAR(10)      
		          FROM (       
			          SELECT A.BASIS_YYYYMMDD                    AS YYYYMMDD    
                      , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO      
  	  	          FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)	  
				     WHERE A.BASIS_YYYYMMDD     >= @v_batch_create_from_yyyymmdd
                     AND A.BASIS_YYYYMMDD     <  @v_batch_create_to_yyyymmdd
				  /*
	 		           WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd 
                   AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd     
				   */
			           GROUP BY A.BASIS_YYYYMMDD       
		          ) AS A      
		          ORDER BY SORT_ORDER_NO  ;      


              DECLARE @mEXEC NVARCHAR(MAX);

		          SET @mEXEC = '';
              SET @mEXEC = @mEXEC + 'UPDATE X SET 
                                            X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005, X.QTY006= Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010,
                                            X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015, X.QTY016= Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020,
                                            X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025, X.QTY026= Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030,
                                            X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035, X.QTY036= Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040,
                                            X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045, X.QTY046= Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050,
                                            X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055, X.QTY056= Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060,
                                            X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065, X.QTY066= Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070,
                                            X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075, X.QTY076= Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080,
                                            X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085, X.QTY086= Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090,
                                            X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095, X.QTY096= Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100, '+CHAR(10);	

              SET @mEXEC = @mEXEC + '       X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105, X.QTY106= Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110,
                                            X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115, X.QTY116= Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120,
                                            X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125, X.QTY126= Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130,
                                            X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135, X.QTY136= Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140,
                                            X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145, X.QTY146= Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150,
                                            X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155, X.QTY156= Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160,
                                            X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165, X.QTY166= Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170,
                                            X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175, X.QTY176= Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180,
                                            X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185, X.QTY186= Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190,
                                            X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195, X.QTY196= Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200, '+CHAR(10);	

              SET @mEXEC = @mEXEC + '       X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205, X.QTY206= Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210,
                                            X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215, X.QTY216= Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220,
                                            X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225, X.QTY226= Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230,
                                            X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235, X.QTY236= Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240,
                                            X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245, X.QTY246= Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250,
                                            X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255, X.QTY256= Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260,
                                            X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265, X.QTY266= Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270,
                                            X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275, X.QTY276= Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280,
                                            X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285, X.QTY286= Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290,
                                            X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295, X.QTY296= Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300, '+CHAR(10);	

              SET @mEXEC = @mEXEC + '       X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305, X.QTY306= Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310,
                                            X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315, X.QTY316= Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320,
                                            X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325, X.QTY326= Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330,
                                            X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335, X.QTY336= Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340,
                                            X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345, X.QTY346= Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350,
                                            X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355, X.QTY356= Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360, 
                                            X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364, 
                                            X.LAST_UPDATED_BY = ''' + @v_batch_user + ''', 
                                            X.LAST_UPDATE_DATE = GETDATE() '+CHAR(10);	

              SET @mEXEC = @mEXEC + ' FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X  WITH (NOLOCK) '+CHAR(10);	
		          SET @mEXEC = @mEXEC + ' INNER JOIN ('
		          SET @mEXEC = @mEXEC + '               SELECT A.DIVISION_ID
                                                           ,A.OPERATION_GROUP
                                                           ,A.SCM_SITE_ID	 
                                                           ,A.OPERATION_ID
                                                           ,A.MEASURE  
                                                           ,A.LINE_ID      '+CHAR(10);	
		          SET @mEXEC = @mEXEC + ' 				           ' + @mQry_sum +'  '+CHAR(10);	
  	          SET @mEXEC = @mEXEC + ' 		            FROM #LineLoad A WITH (NOLOCK)		
                                                  GROUP BY  A.DIVISION_ID
                                                           ,A.OPERATION_GROUP
                                                           ,A.SCM_SITE_ID	 
                                                           ,A.OPERATION_ID
                                                           ,A.MEASURE  
                                                           ,A.LINE_ID       '+CHAR(10);
              SET @mEXEC = @mEXEC + '             ) Y '+CHAR(10);	
              SET @mEXEC = @mEXEC + ' ON 0 = 0
                                      AND X.OPERATION_GROUP   = Y.OPERATION_GROUP 
                                      AND X.FROM_SITE         = Y.SCM_SITE_ID 
                                      AND X.ATTRIBUTE9        = Y.OPERATION_ID
									  AND X.FROM_SITE         = ''' + @p_from_site + '''
                                      AND X.PROD_LINE         = Y.LINE_ID 
                                      AND X.MEASURE           = Y.MEASURE
									  '+CHAR(10);

			   --SET @mEXEC = @mEXEC + ' WHERE X.DIVISION_ID			= ''' + @v_batch_division_id + ''' 
			  	--						 AND X.PLAN_START_YYYYMMDD	= ''' + @v_batch_plan_start_yyyymmdd + '''
			   --							 AND X.PLAN_TYPE			= ''' + @v_batch_plan_type + '''
			   --							 AND X.SEQ					= ''' + @v_batch_seq + '''
						--			  '+CHAR(10);

              EXEC sp_executesql @mEXEC;
              
			  print '~~~~~~~~~~222222222222222'

          /*
            DECLARE @POS int
            DECLARE @LEN NVARCHAR(max)
				    SET @POS =1;
				    SET @LEN =LEN(@mEXEC);
				    WHILE @POS <= @LEN
					    BEGIN
						    PRINT SUBSTRING(@mEXEC,@POS,4000);
						    SET @POS = @POS+4000;
					    END;
            */
            
            
           -------------------------------------------------------------------------------------------------------------         
            --  WEEK SUM PIVOT 생성 후 UPDATE
            -------------------------------------------------------------------------------------------------------------         
              IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL      
	              DROP TABLE #LineLoad_WEEK;   

                SELECT   A.DIVISION_ID
                        ,A.SCM_SITE_ID  AS SITE_ID
                        ,A.OPERATION_ID
                        ,A.LINE_ID AS PROD_LINE
                        ,A.MEASURE
                        ,CASE WHEN SUM(A.WORKING_TIME) <= 0.0   THEN 0 
                              ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100
                         END AS WQTY
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN
                 INTO #LineLoad_WEEK
                  FROM #LineLoad A WITH (NOLOCK)
                GROUP BY A.DIVISION_ID
                        ,A.SCM_SITE_ID
                        ,A.OPERATION_ID
                        ,A.LINE_ID
                        ,A.MEASURE
                        ,A.ISO_YYYYWW
                        ,A.WEEK_COLUMN

                IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL      
	                DROP TABLE #LineLoad_WEEK_PIVOT; 

                  SELECT *
                  INTO #LineLoad_WEEK_PIVOT
                  FROM
                    (
                    SELECT DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE,WQTY,WEEK_COLUMN
                     FROM #LineLoad_WEEK WITH (NOLOCK) 
                     ) AS SourceTable  
                  PIVOT 
                      (
                       MIN(WQTY)
                       FOR  WEEK_COLUMN IN ( [WQTY01],[WQTY02],[WQTY03],[WQTY04],[WQTY05],[WQTY06],[WQTY07],[WQTY08],[WQTY09],[WQTY10],
                                             [WQTY11],[WQTY12],[WQTY13],[WQTY14],[WQTY15],[WQTY16],[WQTY17],[WQTY18],[WQTY19],[WQTY20],
                                             [WQTY21],[WQTY22],[WQTY23],[WQTY24],[WQTY25],[WQTY26],[WQTY27],[WQTY28],[WQTY29],[WQTY30],
                                             [WQTY31],[WQTY32],[WQTY33],[WQTY34],[WQTY35],[WQTY36],[WQTY37],[WQTY38],[WQTY39],[WQTY40],
                                             [WQTY41],[WQTY42],[WQTY43],[WQTY44],[WQTY45],[WQTY46],[WQTY47],[WQTY48],[WQTY49],[WQTY50],
                                             [WQTY51],[WQTY52]
                                            )  
                       ) X


                UPDATE X 
                  SET   X.WQTY01 = Y.WQTY01 ,X.WQTY02 = Y.WQTY02  ,X.WQTY03 = Y.WQTY03  ,X.WQTY04 = Y.WQTY04  ,X.WQTY05 = Y.WQTY05
                      , X.WQTY06 = Y.WQTY06 ,X.WQTY07 = Y.WQTY07  ,X.WQTY08 = Y.WQTY08  ,X.WQTY09 = Y.WQTY09  ,X.WQTY10 = Y.WQTY10
                      , X.WQTY11 = Y.WQTY11 ,X.WQTY12 = Y.WQTY12  ,X.WQTY13 = Y.WQTY13  ,X.WQTY14 = Y.WQTY14  ,X.WQTY15 = Y.WQTY15
                      , X.WQTY16 = Y.WQTY16 ,X.WQTY17 = Y.WQTY17  ,X.WQTY18 = Y.WQTY18  ,X.WQTY19 = Y.WQTY19  ,X.WQTY20 = Y.WQTY20
                      , X.WQTY21 = Y.WQTY21 ,X.WQTY22 = Y.WQTY22  ,X.WQTY23 = Y.WQTY23  ,X.WQTY24 = Y.WQTY24  ,X.WQTY25 = Y.WQTY25
                      , X.WQTY26 = Y.WQTY26 ,X.WQTY27 = Y.WQTY27  ,X.WQTY28 = Y.WQTY28  ,X.WQTY29 = Y.WQTY29  ,X.WQTY30 = Y.WQTY30
                      , X.WQTY31 = Y.WQTY31 ,X.WQTY32 = Y.WQTY32  ,X.WQTY33 = Y.WQTY33  ,X.WQTY34 = Y.WQTY34  ,X.WQTY35 = Y.WQTY35
                      , X.WQTY36 = Y.WQTY36 ,X.WQTY37 = Y.WQTY37  ,X.WQTY38 = Y.WQTY38  ,X.WQTY39 = Y.WQTY39  ,X.WQTY40 = Y.WQTY40
                      , X.WQTY41 = Y.WQTY41 ,X.WQTY42 = Y.WQTY42  ,X.WQTY43 = Y.WQTY43  ,X.WQTY44 = Y.WQTY44  ,X.WQTY45 = Y.WQTY45
                      , X.WQTY46 = Y.WQTY46 ,X.WQTY47 = Y.WQTY47  ,X.WQTY48 = Y.WQTY48  ,X.WQTY49 = Y.WQTY49  ,X.WQTY50 = Y.WQTY50
                      , X.WQTY51 = Y.WQTY51 ,X.WQTY52 = Y.WQTY52
                   FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)
                   INNER JOIN #LineLoad_WEEK_PIVOT Y WITH (NOLOCK)
                      ON X.PROD_LINE    = Y.PROD_LINE 
                     AND X.DIVISION_ID  = Y.DIVISION_ID
                     AND X.FROM_SITE    = Y.SITE_ID
                     AND X.ATTRIBUTE9   = Y.OPERATION_ID
                   WHERE X.DIVISION_ID			= @v_batch_division_id
				     AND X.PLAN_START_YYYYMMDD	= @v_batch_plan_start_yyyymmdd
				     AND X.PLAN_TYPE			= @v_batch_plan_type 
				     AND X.SEQ					= @v_batch_seq 
					 AND X.MEASURE IN ('PACK_PROD_LOAD') 



            END
        END
		print 'SAVE DONE OK!' 

		-- 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가 - start
		IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL	
						  DROP TABLE #SCM_MST_SITE;

		IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL	
						  DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL;

		IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ORG') IS NOT NULL	
						  DROP TABLE #SCP_XLS_PSI_GLOBAL_ORG;

		IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL	
						  DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG;

		-- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - start 
        --               - CELL_SHIP_PLAN (Ship Plan(SCP)) Measure 를 SEMI_SHIP_PLAN 에 준하여 처리하는 로직을 추가
		IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL	
						  DROP TABLE #SCP_ANL_SHIPMENT_PLAN_SEMI;
        -- 2021.04.2 KSW C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정 - end

		IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL	
						  DROP TABLE #SCP_ANL_PRODUCTION_PLAN;

		IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_MODIFY') IS NOT NULL	
						  DROP TABLE #SCP_XLS_PSI_GLOBAL_MODIFY;

		IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL
						  DROP TABLE #LINE_WORKINGTIME_BY_LOSS;

		IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL
						  DROP TABLE #LineLoad;  

		IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL      
						  DROP TABLE #LineLoad_WEEK;

		IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL      
						  DROP TABLE #LineLoad_WEEK_PIVOT; 
		-- 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가 - end

		print 'TEMP TABLE CLEAR'
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count 
                                  ,@p_log_message   = @v_log_message 
                                  ,@p_description   = @v_description 
                                  ,@p_event_date    = @d_event_date 
                                  ,@p_user_id       = @v_batch_user
                                  ;

      END;
	  

    END TRY

    BEGIN CATCH
        
      --IF @@TRANCOUNT > 0 
      --  BEGIN
      --    ROLLBACK;
      --  END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                ,@p_log_type      = @v_log_type
                                ,@p_log_count     = @n_log_count 
                                ,@p_log_message   = @v_log_message 
                                ,@p_description   = @v_description 
                                ,@p_event_date    = @d_event_date 
                                ,@p_user_id       = @v_batch_user
                                ;

      return -1 
    END CATCH;

    --     임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 

	print 'PROCEDUE END'

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
	 --전체시작일자 대신에  키필드인 구간시작일자를 기록함
    SET @v_description = N'['+@v_batch_division_id+']['+@v_batch_CREATE_FROM_YYYYMMDD+']['+@v_batch_measure+']['+convert(varchar, @v_batch_xls_key1)+'][' + @v_exec_time + ']';         
	print @v_description;
    SET @d_event_date = SYSDATETIME();
	
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
	
    return 1 		
  END;
