

CREATE PROCEDURE [dbo].[PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL]
     @P_PLAN_ID           NVARCHAR(50)
    ,@PLAN_START_YYYYMMDD NVARCHAR(8)
AS 
BEGIN
    --2025.02.07 Taehyun Initial Release
	------------------------------------------------------------------------  
    -- Procedure 기본조건.
	------------------------------------------------------------------------
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	------------------------------------------------------------------------  
	
	------------------------------------------------------------------------
	-- Set Param for Log
	------------------------------------------------------------------------
    DECLARE @V_PROGRAM_NAME      NVARCHAR(150) = 'PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL';
    DECLARE @V_PLAN_ID           NVARCHAR(50)  = @P_PLAN_ID;
    DECLARE @V_MESSAGE_TEXT      NVARCHAR(1000);
    ------------------------------------------------------------------------
	-- LOG 용 변수 설정
	------------------------------------------------------------------------
    --DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_LGTM_INV_ALLOCATION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    ---------------------   ---------------------------------------------------
    -- Set Param for Biz
    ------------------------------------------------------------------------
    DECLARE @V_SCP_PLAN_DATE         NVARCHAR(8);
    DECLARE @V_SCP_PLAN_TYPE         NVARCHAR(8);
    DECLARE @V_SCP_PLAN_SEQ          NVARCHAR(8);
    DECLARE @V_DIVISION_ID           NVARCHAR(10);
	DECLARE @V_PLAN_START_YYYYMMDD   NVARCHAR(8);
    DECLARE @V_PLAN_END_YYYYMMDD     NVARCHAR(8);
    DECLARE @2ND_PLAN_START_YYYYMMDD NVARCHAR(8);
    DECLARE @NOW_DATE                DATETIME;
    DECLARE @MIN_WEEK                INT;          
    DECLARE @2ND_MIN_WEEK            INT;          
    -- 2026.07.22 Minyong Lee : [E20260713-000080] [ODS] 업로드 수량 이상건 수정
    DECLARE @WEEKS_IN_YEAR           INT;
    DECLARE @2ND_WEEKS_IN_YEAR       INT;
    DECLARE @UPDATE_NAME             NVARCHAR(100);
    DECLARE @OP_COUNT                INT;
    DECLARE @CHK_INTEGRAL            NVARCHAR(100);
    DECLARE @OP_RESULT TABLE(
                             SITE_ID             NVARCHAR(100)
                            ,ITEM_ID             NVARCHAR(100)
                            ,GRADE               NVARCHAR(100)
                            ,START_DATE          NVARCHAR(8)
                            ,OUT_QTY_INT         NUMERIC(38,10)
                            ,LINE_ID             NVARCHAR(100)
                            ,OPERATION_GROUP     NVARCHAR(100)
                            ,OPERATION_ID        NVARCHAR(100)
                            ,ELECTRODE_TYPE      NVARCHAR(100) -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                            )

    DECLARE @OS_RESULT TABLE(
            OPERATION_GROUP         NVARCHAR(100)
           ,ITEM_ID                 NVARCHAR(100)
           ,FROM_SITE               NVARCHAR(100)
           ,BOD_ID                  NVARCHAR(10)
           ,MEASURE                 NVARCHAR(100)
           ,YYYYMMDD                NVARCHAR(8)
           ,TO_SITE                 NVARCHAR(100)
           ,QTY                     NUMERIC(38,10)
           ,ORIGIN_FROM_DIVISION_ID	NVARCHAR(100)
           ,ORIGIN_TO_DIVISION_ID	NVARCHAR(100)
           ,ELECTRODE_TYPE	        NVARCHAR(100)
           ,BOD_TYPE                NVARCHAR(100)
           )


    DECLARE @OS_RESULT_FG TABLE(
            OPERATION_GROUP         NVARCHAR(100)
           ,PROJECT_CODE            NVARCHAR(100)
           ,ITEM_ID                 NVARCHAR(100)
           ,FROM_SITE               NVARCHAR(100)
           ,BOD_ID                  NVARCHAR(10)
           ,MEASURE                 NVARCHAR(100)
           ,YYYYMMDD                NVARCHAR(8)
           ,TO_SITE                 NVARCHAR(100)
           ,QTY                     NUMERIC(38,10)
           ,ORIGIN_FROM_DIVISION_ID	NVARCHAR(100)
           ,ORIGIN_TO_DIVISION_ID	NVARCHAR(100)
           ,ELECTRODE_TYPE	        NVARCHAR(100)
           ,BOD_TYPE                NVARCHAR(100)
           ,INCOTERMS               NVARCHAR(100)
           )
           
    DECLARE @OS_RESULT_FG_SMMR TABLE(
     ITEM_ID      NVARCHAR(100)
    ,BOD_ID       NVARCHAR(100)
    ,PROJECT_CODE NVARCHAR(100)
    )

    DECLARE @XLS_PV_READY TABLE(
                                TRG_DATE            NVARCHAR(6)
                               ,DIVISION_ID         NVARCHAR(100)
                               ,PLAN_START_YYYYMMDD NVARCHAR(8)
                               ,PLAN_TYPE           NVARCHAR(10)
                               ,SEQ                 NVARCHAR(100)
                               ,OPERATION_GROUP     NVARCHAR(10)
                               ,FROM_SITE           NVARCHAR(100)
                               ,ITEM_ID             NVARCHAR(100)
                               ,LINE_ID             NVARCHAR(100)
                               ,BOD_ID              NVARCHAR(100)
                               ,PROJECT_CODE        NVARCHAR(100)
                               ,MEASURE             NVARCHAR(100)
                               ,QTY_SUM             NUMERIC(20,10)
                               ,CREATE_FROM_YYYYMMDD NVARCHAR(8)
                               )
    
    
    DECLARE @XLS_PV_TABLE TABLE(
                                 DIVISION_ID         NVARCHAR(100)
                                ,PLAN_START_YYYYMMDD NVARCHAR(100)
                                ,PLAN_TYPE           NVARCHAR(100)
                                ,SEQ                 NVARCHAR(100)
                                ,OPERATION_GROUP     NVARCHAR(100)
                                ,FROM_SITE           NVARCHAR(100)
                                ,ITEM_ID             NVARCHAR(100)
                                ,LINE_ID             NVARCHAR(100)
                                ,BOD_ID              NVARCHAR(100)
                                ,PROJECT_CODE        NVARCHAR(100)
                                ,MEASURE             NVARCHAR(100)
                                ,CREATE_FROM_YYYYMMDD NVARCHAR(8)
                                ,QTY001 NUMERIC(20,10),QTY002 NUMERIC(20,10),QTY003 NUMERIC(20,10),QTY004 NUMERIC(20,10),QTY005 NUMERIC(20,10),QTY006 NUMERIC(20,10),QTY007 NUMERIC(20,10),QTY008 NUMERIC(20,10),QTY009 NUMERIC(20,10),QTY010 NUMERIC(20,10),QTY011 NUMERIC(20,10),QTY012 NUMERIC(20,10),QTY013 NUMERIC(20,10),QTY014 NUMERIC(20,10),QTY015 NUMERIC(20,10),QTY016 NUMERIC(20,10),QTY017 NUMERIC(20,10),QTY018 NUMERIC(20,10),QTY019 NUMERIC(20,10),QTY020 NUMERIC(20,10)
                                ,QTY021 NUMERIC(20,10),QTY022 NUMERIC(20,10),QTY023 NUMERIC(20,10),QTY024 NUMERIC(20,10),QTY025 NUMERIC(20,10),QTY026 NUMERIC(20,10),QTY027 NUMERIC(20,10),QTY028 NUMERIC(20,10),QTY029 NUMERIC(20,10),QTY030 NUMERIC(20,10),QTY031 NUMERIC(20,10),QTY032 NUMERIC(20,10),QTY033 NUMERIC(20,10),QTY034 NUMERIC(20,10),QTY035 NUMERIC(20,10),QTY036 NUMERIC(20,10),QTY037 NUMERIC(20,10),QTY038 NUMERIC(20,10),QTY039 NUMERIC(20,10),QTY040 NUMERIC(20,10)
                                ,QTY041 NUMERIC(20,10),QTY042 NUMERIC(20,10),QTY043 NUMERIC(20,10),QTY044 NUMERIC(20,10),QTY045 NUMERIC(20,10),QTY046 NUMERIC(20,10),QTY047 NUMERIC(20,10),QTY048 NUMERIC(20,10),QTY049 NUMERIC(20,10),QTY050 NUMERIC(20,10),QTY051 NUMERIC(20,10),QTY052 NUMERIC(20,10),QTY053 NUMERIC(20,10),QTY054 NUMERIC(20,10),QTY055 NUMERIC(20,10),QTY056 NUMERIC(20,10),QTY057 NUMERIC(20,10),QTY058 NUMERIC(20,10),QTY059 NUMERIC(20,10),QTY060 NUMERIC(20,10)
                                ,QTY061 NUMERIC(20,10),QTY062 NUMERIC(20,10),QTY063 NUMERIC(20,10),QTY064 NUMERIC(20,10),QTY065 NUMERIC(20,10),QTY066 NUMERIC(20,10),QTY067 NUMERIC(20,10),QTY068 NUMERIC(20,10),QTY069 NUMERIC(20,10),QTY070 NUMERIC(20,10),QTY071 NUMERIC(20,10),QTY072 NUMERIC(20,10),QTY073 NUMERIC(20,10),QTY074 NUMERIC(20,10),QTY075 NUMERIC(20,10),QTY076 NUMERIC(20,10),QTY077 NUMERIC(20,10),QTY078 NUMERIC(20,10),QTY079 NUMERIC(20,10),QTY080 NUMERIC(20,10)
                                ,QTY081 NUMERIC(20,10),QTY082 NUMERIC(20,10),QTY083 NUMERIC(20,10),QTY084 NUMERIC(20,10),QTY085 NUMERIC(20,10),QTY086 NUMERIC(20,10),QTY087 NUMERIC(20,10),QTY088 NUMERIC(20,10),QTY089 NUMERIC(20,10),QTY090 NUMERIC(20,10),QTY091 NUMERIC(20,10),QTY092 NUMERIC(20,10),QTY093 NUMERIC(20,10),QTY094 NUMERIC(20,10),QTY095 NUMERIC(20,10),QTY096 NUMERIC(20,10),QTY097 NUMERIC(20,10),QTY098 NUMERIC(20,10),QTY099 NUMERIC(20,10),QTY100 NUMERIC(20,10)
                                ,QTY101 NUMERIC(20,10),QTY102 NUMERIC(20,10),QTY103 NUMERIC(20,10),QTY104 NUMERIC(20,10),QTY105 NUMERIC(20,10),QTY106 NUMERIC(20,10),QTY107 NUMERIC(20,10),QTY108 NUMERIC(20,10),QTY109 NUMERIC(20,10),QTY110 NUMERIC(20,10),QTY111 NUMERIC(20,10),QTY112 NUMERIC(20,10),QTY113 NUMERIC(20,10),QTY114 NUMERIC(20,10),QTY115 NUMERIC(20,10),QTY116 NUMERIC(20,10),QTY117 NUMERIC(20,10),QTY118 NUMERIC(20,10),QTY119 NUMERIC(20,10),QTY120 NUMERIC(20,10)
                                ,QTY121 NUMERIC(20,10),QTY122 NUMERIC(20,10),QTY123 NUMERIC(20,10),QTY124 NUMERIC(20,10),QTY125 NUMERIC(20,10),QTY126 NUMERIC(20,10),QTY127 NUMERIC(20,10),QTY128 NUMERIC(20,10),QTY129 NUMERIC(20,10),QTY130 NUMERIC(20,10),QTY131 NUMERIC(20,10),QTY132 NUMERIC(20,10),QTY133 NUMERIC(20,10),QTY134 NUMERIC(20,10),QTY135 NUMERIC(20,10),QTY136 NUMERIC(20,10),QTY137 NUMERIC(20,10),QTY138 NUMERIC(20,10),QTY139 NUMERIC(20,10),QTY140 NUMERIC(20,10)
                                ,QTY141 NUMERIC(20,10),QTY142 NUMERIC(20,10),QTY143 NUMERIC(20,10),QTY144 NUMERIC(20,10),QTY145 NUMERIC(20,10),QTY146 NUMERIC(20,10),QTY147 NUMERIC(20,10),QTY148 NUMERIC(20,10),QTY149 NUMERIC(20,10),QTY150 NUMERIC(20,10),QTY151 NUMERIC(20,10),QTY152 NUMERIC(20,10),QTY153 NUMERIC(20,10),QTY154 NUMERIC(20,10),QTY155 NUMERIC(20,10),QTY156 NUMERIC(20,10),QTY157 NUMERIC(20,10),QTY158 NUMERIC(20,10),QTY159 NUMERIC(20,10),QTY160 NUMERIC(20,10)
                                ,QTY161 NUMERIC(20,10),QTY162 NUMERIC(20,10),QTY163 NUMERIC(20,10),QTY164 NUMERIC(20,10),QTY165 NUMERIC(20,10),QTY166 NUMERIC(20,10),QTY167 NUMERIC(20,10),QTY168 NUMERIC(20,10),QTY169 NUMERIC(20,10),QTY170 NUMERIC(20,10),QTY171 NUMERIC(20,10),QTY172 NUMERIC(20,10),QTY173 NUMERIC(20,10),QTY174 NUMERIC(20,10),QTY175 NUMERIC(20,10),QTY176 NUMERIC(20,10),QTY177 NUMERIC(20,10),QTY178 NUMERIC(20,10),QTY179 NUMERIC(20,10),QTY180 NUMERIC(20,10)
                                ,QTY181 NUMERIC(20,10),QTY182 NUMERIC(20,10),QTY183 NUMERIC(20,10),QTY184 NUMERIC(20,10),QTY185 NUMERIC(20,10),QTY186 NUMERIC(20,10),QTY187 NUMERIC(20,10),QTY188 NUMERIC(20,10),QTY189 NUMERIC(20,10),QTY190 NUMERIC(20,10),QTY191 NUMERIC(20,10),QTY192 NUMERIC(20,10),QTY193 NUMERIC(20,10),QTY194 NUMERIC(20,10),QTY195 NUMERIC(20,10),QTY196 NUMERIC(20,10),QTY197 NUMERIC(20,10),QTY198 NUMERIC(20,10),QTY199 NUMERIC(20,10),QTY200 NUMERIC(20,10)
                                ,QTY201 NUMERIC(20,10),QTY202 NUMERIC(20,10),QTY203 NUMERIC(20,10),QTY204 NUMERIC(20,10),QTY205 NUMERIC(20,10),QTY206 NUMERIC(20,10),QTY207 NUMERIC(20,10),QTY208 NUMERIC(20,10),QTY209 NUMERIC(20,10),QTY210 NUMERIC(20,10),QTY211 NUMERIC(20,10),QTY212 NUMERIC(20,10),QTY213 NUMERIC(20,10),QTY214 NUMERIC(20,10),QTY215 NUMERIC(20,10),QTY216 NUMERIC(20,10),QTY217 NUMERIC(20,10),QTY218 NUMERIC(20,10),QTY219 NUMERIC(20,10),QTY220 NUMERIC(20,10)
                                ,QTY221 NUMERIC(20,10),QTY222 NUMERIC(20,10),QTY223 NUMERIC(20,10),QTY224 NUMERIC(20,10),QTY225 NUMERIC(20,10),QTY226 NUMERIC(20,10),QTY227 NUMERIC(20,10),QTY228 NUMERIC(20,10),QTY229 NUMERIC(20,10),QTY230 NUMERIC(20,10),QTY231 NUMERIC(20,10),QTY232 NUMERIC(20,10),QTY233 NUMERIC(20,10),QTY234 NUMERIC(20,10),QTY235 NUMERIC(20,10),QTY236 NUMERIC(20,10),QTY237 NUMERIC(20,10),QTY238 NUMERIC(20,10),QTY239 NUMERIC(20,10),QTY240 NUMERIC(20,10)
                                ,QTY241 NUMERIC(20,10),QTY242 NUMERIC(20,10),QTY243 NUMERIC(20,10),QTY244 NUMERIC(20,10),QTY245 NUMERIC(20,10),QTY246 NUMERIC(20,10),QTY247 NUMERIC(20,10),QTY248 NUMERIC(20,10),QTY249 NUMERIC(20,10),QTY250 NUMERIC(20,10),QTY251 NUMERIC(20,10),QTY252 NUMERIC(20,10),QTY253 NUMERIC(20,10),QTY254 NUMERIC(20,10),QTY255 NUMERIC(20,10),QTY256 NUMERIC(20,10),QTY257 NUMERIC(20,10),QTY258 NUMERIC(20,10),QTY259 NUMERIC(20,10),QTY260 NUMERIC(20,10)
                                ,QTY261 NUMERIC(20,10),QTY262 NUMERIC(20,10),QTY263 NUMERIC(20,10),QTY264 NUMERIC(20,10),QTY265 NUMERIC(20,10),QTY266 NUMERIC(20,10),QTY267 NUMERIC(20,10),QTY268 NUMERIC(20,10),QTY269 NUMERIC(20,10),QTY270 NUMERIC(20,10),QTY271 NUMERIC(20,10),QTY272 NUMERIC(20,10),QTY273 NUMERIC(20,10),QTY274 NUMERIC(20,10),QTY275 NUMERIC(20,10),QTY276 NUMERIC(20,10),QTY277 NUMERIC(20,10),QTY278 NUMERIC(20,10),QTY279 NUMERIC(20,10),QTY280 NUMERIC(20,10)
                                ,QTY281 NUMERIC(20,10),QTY282 NUMERIC(20,10),QTY283 NUMERIC(20,10),QTY284 NUMERIC(20,10),QTY285 NUMERIC(20,10),QTY286 NUMERIC(20,10),QTY287 NUMERIC(20,10),QTY288 NUMERIC(20,10),QTY289 NUMERIC(20,10),QTY290 NUMERIC(20,10),QTY291 NUMERIC(20,10),QTY292 NUMERIC(20,10),QTY293 NUMERIC(20,10),QTY294 NUMERIC(20,10),QTY295 NUMERIC(20,10),QTY296 NUMERIC(20,10),QTY297 NUMERIC(20,10),QTY298 NUMERIC(20,10),QTY299 NUMERIC(20,10),QTY300 NUMERIC(20,10)
                                ,QTY301 NUMERIC(20,10),QTY302 NUMERIC(20,10),QTY303 NUMERIC(20,10),QTY304 NUMERIC(20,10),QTY305 NUMERIC(20,10),QTY306 NUMERIC(20,10),QTY307 NUMERIC(20,10),QTY308 NUMERIC(20,10),QTY309 NUMERIC(20,10),QTY310 NUMERIC(20,10),QTY311 NUMERIC(20,10),QTY312 NUMERIC(20,10),QTY313 NUMERIC(20,10),QTY314 NUMERIC(20,10),QTY315 NUMERIC(20,10),QTY316 NUMERIC(20,10),QTY317 NUMERIC(20,10),QTY318 NUMERIC(20,10),QTY319 NUMERIC(20,10),QTY320 NUMERIC(20,10)
                                ,QTY321 NUMERIC(20,10),QTY322 NUMERIC(20,10),QTY323 NUMERIC(20,10),QTY324 NUMERIC(20,10),QTY325 NUMERIC(20,10),QTY326 NUMERIC(20,10),QTY327 NUMERIC(20,10),QTY328 NUMERIC(20,10),QTY329 NUMERIC(20,10),QTY330 NUMERIC(20,10),QTY331 NUMERIC(20,10),QTY332 NUMERIC(20,10),QTY333 NUMERIC(20,10),QTY334 NUMERIC(20,10),QTY335 NUMERIC(20,10),QTY336 NUMERIC(20,10),QTY337 NUMERIC(20,10),QTY338 NUMERIC(20,10),QTY339 NUMERIC(20,10),QTY340 NUMERIC(20,10)
                                ,QTY341 NUMERIC(20,10),QTY342 NUMERIC(20,10),QTY343 NUMERIC(20,10),QTY344 NUMERIC(20,10),QTY345 NUMERIC(20,10),QTY346 NUMERIC(20,10),QTY347 NUMERIC(20,10),QTY348 NUMERIC(20,10),QTY349 NUMERIC(20,10),QTY350 NUMERIC(20,10),QTY351 NUMERIC(20,10),QTY352 NUMERIC(20,10),QTY353 NUMERIC(20,10),QTY354 NUMERIC(20,10),QTY355 NUMERIC(20,10),QTY356 NUMERIC(20,10),QTY357 NUMERIC(20,10),QTY358 NUMERIC(20,10),QTY359 NUMERIC(20,10),QTY360 NUMERIC(20,10)
                                ,QTY361 NUMERIC(20,10),QTY362 NUMERIC(20,10),QTY363 NUMERIC(20,10),QTY364 NUMERIC(20,10)
                                ,WQTY01 NUMERIC(20,10),WQTY02 NUMERIC(20,10),WQTY03 NUMERIC(20,10),WQTY04 NUMERIC(20,10),WQTY05 NUMERIC(20,10),WQTY06 NUMERIC(20,10),WQTY07 NUMERIC(20,10),WQTY08 NUMERIC(20,10),WQTY09 NUMERIC(20,10),WQTY10 NUMERIC(20,10),WQTY11 NUMERIC(20,10),WQTY12 NUMERIC(20,10),WQTY13 NUMERIC(20,10),WQTY14 NUMERIC(20,10),WQTY15 NUMERIC(20,10),WQTY16 NUMERIC(20,10),WQTY17 NUMERIC(20,10),WQTY18 NUMERIC(20,10),WQTY19 NUMERIC(20,10),WQTY20 NUMERIC(20,10)
                                ,WQTY21 NUMERIC(20,10),WQTY22 NUMERIC(20,10),WQTY23 NUMERIC(20,10),WQTY24 NUMERIC(20,10),WQTY25 NUMERIC(20,10),WQTY26 NUMERIC(20,10),WQTY27 NUMERIC(20,10),WQTY28 NUMERIC(20,10),WQTY29 NUMERIC(20,10),WQTY30 NUMERIC(20,10),WQTY31 NUMERIC(20,10),WQTY32 NUMERIC(20,10),WQTY33 NUMERIC(20,10),WQTY34 NUMERIC(20,10),WQTY35 NUMERIC(20,10),WQTY36 NUMERIC(20,10),WQTY37 NUMERIC(20,10),WQTY38 NUMERIC(20,10),WQTY39 NUMERIC(20,10),WQTY40 NUMERIC(20,10)
                                ,WQTY41 NUMERIC(20,10),WQTY42 NUMERIC(20,10),WQTY43 NUMERIC(20,10),WQTY44 NUMERIC(20,10),WQTY45 NUMERIC(20,10),WQTY46 NUMERIC(20,10),WQTY47 NUMERIC(20,10),WQTY48 NUMERIC(20,10),WQTY49 NUMERIC(20,10),WQTY50 NUMERIC(20,10),WQTY51 NUMERIC(20,10),WQTY52 NUMERIC(20,10)
                                )

	------------------------------------------------------------------------
	-- LOG 시작
	------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = 'START_' + @V_PROGRAM_NAME+'@'+@PLAN_START_YYYYMMDD+'@'+@V_PLAN_ID
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	------------------------------------------------------------------------  

    SELECT  @MIN_WEEK = (SELECT CONVERT(INT,ISO_WEEK) -1 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = @PLAN_START_YYYYMMDD)
    SELECT  @UPDATE_NAME = 'OPT_ENG_' + @V_PLAN_ID
    --52주 이후 구간의 데이터를 GLOBAL 테이블에 넣기 위한 변수 설정
    SELECT  @2ND_PLAN_START_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY,364,@PLAN_START_YYYYMMDD),112)
    SELECT  @2ND_MIN_WEEK = (SELECT CONVERT(INT,ISO_WEEK) -1 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = @2ND_PLAN_START_YYYYMMDD)

    -- 2026.07.22 Minyong Lee : [E20260713-000080] [ODS] 업로드 수량 이상건 수정
    -- 섹션1 시작연도의 실제 주차 수 (52 or 53)
    SELECT  @WEEKS_IN_YEAR = MAX(CONVERT(INT,ISO_WEEK)) FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE LEFT(BASIS_YYYYMMDD,4) = LEFT(@PLAN_START_YYYYMMDD,4)
    -- 섹션2(52주 이후 구간) 시작연도의 실제 주차 수 (52 or 53)
    SELECT  @2ND_WEEKS_IN_YEAR = MAX(CONVERT(INT,ISO_WEEK)) FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE LEFT(BASIS_YYYYMMDD,4) = LEFT(@2ND_PLAN_START_YYYYMMDD,4)

    SELECT  @NOW_DATE = GETDATE()
    --SELECT  @V_DIVISION_ID = DIVISION_ID
    --       ,@V_PLAN_START_YYYYMMDD = PLAN_START_YYYYMMDD
    --       ,@V_PLAN_END_YYYYMMDD   = PLAN_END_YYYYMMDD
    --FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
    --WHERE   1=1
    --AND     PLAN_ID = @V_PLAN_ID

    --SELECT   @V_DIVISION_ID         = PM.DIVISION_ID         
    --        ,@V_PLAN_START_YYYYMMDD = PM.PLAN_START_YYYYMMDD 
    --        ,@V_PLAN_END_YYYYMMDD   = PM.PLAN_END_YYYYMMDD   
    --FROM    SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
    --WHERE   PM.OPMZ_PLAN_ID = @V_PLAN_ID

    SELECT  @V_DIVISION_ID         = A.DIVISION_ID
           ,@V_PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
           ,@V_PLAN_END_YYYYMMDD   = A.PLAN_END_YYYYMMDD
    FROM(
         SELECT PM.DIVISION_ID          AS DIVISION_ID
               ,PM.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
               ,PM.PLAN_END_YYYYMMDD    AS PLAN_END_YYYYMMDD
         FROM     SCP_OPMZ_PLAN_M PM WITH(NOLOCK)
         WHERE   PM.OPMZ_PLAN_ID = @V_PLAN_ID
         UNION
         SELECT  DIVISION_ID             AS DIVISION_ID
                ,PLAN_START_YYYYMMDD     AS PLAN_START_YYYYMMDD
                ,PLAN_END_YYYYMMDD       AS PLAN_END_YYYYMMDD
         FROM    SCP_OPT_ENG_SCP_PLAN_ID_M_SN WITH(NOLOCK)
         WHERE   1=1
         AND     PLAN_ID = @V_PLAN_ID
    ) A

    SELECT @V_SCP_PLAN_DATE   = A.PLAN_START_YYYYMMDD 
          ,@V_SCP_PLAN_TYPE   = A.PLAN_TYPE 
          ,@V_SCP_PLAN_SEQ    = A.PLAN_SEQ 
    FROM  (SELECT TOP 1 DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
           FROM   SCP_PLAN_VERSION_V WITH(NOLOCK)
           WHERE  DIVISION_ID          = @V_DIVISION_ID
           AND    PLAN_START_YYYYMMDD  = @PLAN_START_YYYYMMDD
           -- 2026.03.17 Minyong Lee : FN 이후 TE Plan Type 추가 건 대응
           --ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
           ORDER BY
               CASE WHEN PLAN_TYPE = 'TE' THEN 0 ELSE 1 END ASC, 
               PLAN_TYPE_ORDER DESC,
               CONFIRM_FLAG DESC,
               PLAN_SEQ DESC
          ) A  

    SELECT  @CHK_INTEGRAL = PLAN_ID
    FROM    SCP_OPT_ENG_PHASES_SN WITH(NOLOCK)
    WHERE   1=1
    AND     PLAN_ID = @V_PLAN_ID
    AND     PRINT_RESULT LIKE N'%INTEGRAL%'


    ------------------------------------------------------------------------  	
	-- Transaction (START)
	------------------------------------------------------------------------  
	BEGIN TRY
        BEGIN TRAN
        SAVE TRANSACTION SP_OUTPUT_TRANS_ANL;

        IF (@V_SCP_PLAN_TYPE = 'FN')
            BEGIN
                SET XACT_ABORT OFF;
                RAISERROR ('I/F not executed because PLAN_TYPE is FN.',15,0);
            END

        ------------------------------------------------------------------------
        -- 엔진 결과에서 문자열 'E'를 붙여서 나오는 데이터 치환
        ------------------------------------------------------------------------
        UPDATE SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN          SET ATTRIBUTE1 = OUT_QTY         , OUT_QTY =LTRIM(STR(IIF(OUT_QTY LIKE '%E-%',0,CONVERT(FLOAT,OUT_QTY)),50))                            WHERE PLAN_ID = @V_PLAN_ID AND OUT_QTY LIKE N'%E%'
        UPDATE SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN      SET ATTRIBUTE1 = OUT_QTY_INT     , OUT_QTY_INT =LTRIM(STR(IIF(OUT_QTY_INT LIKE '%E-%',0,CONVERT(FLOAT,OUT_QTY_INT)),50))                WHERE PLAN_ID = @V_PLAN_ID AND OUT_QTY_INT LIKE N'%E%'
        UPDATE SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN        SET ATTRIBUTE1 = QTY_INT         , QTY_INT =LTRIM(STR(IIF(QTY_INT LIKE '%E-%',0,CONVERT(FLOAT,QTY_INT)),50))                            WHERE PLAN_ID = @V_PLAN_ID AND QTY_INT LIKE N'%E%'
        UPDATE SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN            SET ATTRIBUTE1 = QTY             , QTY =LTRIM(STR(IIF(QTY LIKE '%E-%',0,CONVERT(FLOAT,QTY)),50))                                        WHERE PLAN_ID = @V_PLAN_ID AND QTY LIKE N'%E%'

    ------------------------------------------------------------------------
    -- ORDER_PRODUCTION DATA START
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Get Order Production Int data
        ------------------------------------------------------------------------
        IF @CHK_INTEGRAL IS NULL
        BEGIN
            INSERT INTO @OP_RESULT
            SELECT OP.SITE_ID             AS SITE_ID
                  ,OP.ITEM_ID             AS ITEM_ID
                  ,OP.GRADE               AS GRADE
                  ,CM.BASIS_YYYYMMDD      AS START_DATE
                  ,SUM(IIF(CM.BASIS_YYYYMMDD = OP.START_DATE, CONVERT(NUMERIC(30,10), OP.OUT_QTY), 0)) AS OUT_QTY 
                  ,RE.RESOURCE_NAME       AS LINE_ID
                  ,FI.OPERATION_GROUP     AS OPERATION_GROUP
                  ,FI.FLOW_ID             AS OPERATION_ID
                  ,''                     AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
            FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN OP WITH(NOLOCK) 
                LEFT OUTER JOIN ( 
                                SELECT PRODUCTION_ORDER_ID
                                      ,PRODUCTION_LINE_ID
                                      ,PLAN_ID
                                FROM   SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN WITH(NOLOCK) 
                                WHERE  PLAN_ID = @V_PLAN_ID
                                GROUP BY PRODUCTION_ORDER_ID, PRODUCTION_LINE_ID, PLAN_ID
                                ) PG
                    ON  OP.PLAN_ID             = PG.PLAN_ID 
                    AND OP.PRODUCTION_ORDER_ID = PG.PRODUCTION_ORDER_ID
                INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                    ON  OP.PLAN_ID = RE.PLAN_ID
                    AND PG.PRODUCTION_LINE_ID = RE.RESOURCE_ID
                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                    ON  FI.DIVISION_ID = @V_DIVISION_ID
                    AND FI.ITEM_ID     = OP.ITEM_ID
                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON 1=1
            WHERE OP.PLAN_ID = @V_PLAN_ID
            AND   OP.GRADE IN ( 'ASSY','PACK','MDLE')
            AND   PG.PLAN_ID IS NOT NULL
            AND   CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
            GROUP BY OP.SITE_ID,OP.ITEM_ID,OP.GRADE,CM.BASIS_YYYYMMDD,RE.RESOURCE_NAME,FI.OPERATION_GROUP,FI.FLOW_ID
        END
        ELSE IF @CHK_INTEGRAL IS NOT NULL
        BEGIN
            INSERT INTO @OP_RESULT
            SELECT OP.SITE_ID             AS SITE_ID
                  ,OP.ITEM_ID             AS ITEM_ID
                  ,OP.GRADE               AS GRADE
                  ,CM.BASIS_YYYYMMDD      AS START_DATE
                  ,SUM(IIF(CM.BASIS_YYYYMMDD = OP.START_DATE, CONVERT(NUMERIC(30,10), OP.OUT_QTY_INT), 0)) AS OUT_QTY_INT
                  ,RE.RESOURCE_NAME       AS LINE_ID
                  ,FI.OPERATION_GROUP     AS OPERATION_GROUP
                  ,FI.FLOW_ID             AS OPERATION_ID
                  ,''                     AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
            FROM SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN OP WITH(NOLOCK) 
                LEFT OUTER JOIN ( 
                                SELECT PRODUCTION_ORDER_ID
                                      ,PRODUCTION_LINE_ID
                                      ,PLAN_ID
                                FROM   SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_INT_SN WITH(NOLOCK) 
                                WHERE  PLAN_ID = @V_PLAN_ID
                                GROUP BY PRODUCTION_ORDER_ID, PRODUCTION_LINE_ID, PLAN_ID
                                ) PG
                    ON  OP.PLAN_ID             = PG.PLAN_ID 
                    AND OP.PRODUCTION_ORDER_ID = PG.PRODUCTION_ORDER_ID
                INNER JOIN SCP_OPT_ENG_RESOURCE_SN RE WITH(NOLOCK)
                    ON  OP.PLAN_ID = RE.PLAN_ID
                    AND PG.PRODUCTION_LINE_ID = RE.RESOURCE_ID
                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                    ON  FI.DIVISION_ID = @V_DIVISION_ID
                    AND FI.ITEM_ID     = OP.ITEM_ID
                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON 1=1
            WHERE OP.PLAN_ID = @V_PLAN_ID
            AND   OP.GRADE IN ( 'ASSY','PACK','MDLE')
            AND   PG.PLAN_ID IS NOT NULL
            AND   CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
            GROUP BY OP.SITE_ID,OP.ITEM_ID,OP.GRADE,CM.BASIS_YYYYMMDD,RE.RESOURCE_NAME,FI.OPERATION_GROUP,FI.FLOW_ID
        END

        ------------------------------------------------------------------------
        -- 생산 결과가 없으면 Error 생성
        ------------------------------------------------------------------------
        SELECT  @OP_COUNT = COUNT(*)
        FROM    @OP_RESULT

        IF @OP_COUNT = 0
        BEGIN
            SET XACT_ABORT OFF;
            RAISERROR ('No Order Production data to interface.',15,0)
        END
        ------------------------------------------------------------------------
        -- Initialization Qty
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_PRODUCTION_PLAN
        SET SCP_ANL_PRODUCTION_PLAN.QTY = 0
          , LAST_UPDATED_BY  = @UPDATE_NAME
          , LAST_UPDATE_DATE = @NOW_DATE
          --, ATTRIBUTE9        = 'U'
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
        FROM SCP_ANL_PRODUCTION_PLAN 
        INNER JOIN  (SELECT SCM_SITE_ID
                           ,ITEM_ID
                     FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                     WHERE  PLAN_ID = @V_PLAN_ID
                     GROUP BY SCM_SITE_ID, ITEM_ID
                   ) ML
        ON  SCP_ANL_PRODUCTION_PLAN.SCM_SITE_ID = ML.SCM_SITE_ID
        AND SCP_ANL_PRODUCTION_PLAN.ITEM_ID     = ML.ITEM_ID
        WHERE 1=1
        AND SCP_ANL_PRODUCTION_PLAN.DIVISION_ID         = @V_DIVISION_ID
        AND SCP_ANL_PRODUCTION_PLAN.MEASURE             IN ('PROD_PLAN_AMEND')
        AND SCP_ANL_PRODUCTION_PLAN.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND SCP_ANL_PRODUCTION_PLAN.PLAN_TYPE           = @V_SCP_PLAN_TYPE
        AND SCP_ANL_PRODUCTION_PLAN.SEQ                 = @V_SCP_PLAN_SEQ
        AND SCP_ANL_PRODUCTION_PLAN.YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND SCP_ANL_PRODUCTION_PLAN.QTY != 0 

        PRINT 'SCP_ANL_PRODUCTION_PLAN'

        ------------------------------------------------------------------------
        -- MERGE INTO OPT ENG Data
        ------------------------------------------------------------------------
        MERGE INTO SCP_ANL_PRODUCTION_PLAN AS ANL
        USING @OP_RESULT AS OPR
        ON(    ANL.DIVISION_ID         = @V_DIVISION_ID
           AND ANL.MEASURE             IN ('PROD_PLAN_AMEND')
           AND ANL.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
           AND ANL.PLAN_TYPE           = @V_SCP_PLAN_TYPE
           AND ANL.SEQ                 = @V_SCP_PLAN_SEQ
           AND ANL.OPERATION_GROUP     = OPR.OPERATION_GROUP
           AND ANL.SCM_SITE_ID         = OPR.SITE_ID
           AND ANL.ITEM_ID             = OPR.ITEM_ID
           AND ANL.LINE_ID             = OPR.LINE_ID
           AND ANL.OPERATION_ID        = OPR.OPERATION_ID
           AND ANL.YYYYMMDD            = OPR.START_DATE
          )
        WHEN MATCHED THEN 
            UPDATE SET ANL.QTY = OPR.OUT_QTY_INT
                      ,ANL.LAST_UPDATE_DATE = @NOW_DATE
                      ,ANL.LAST_UPDATED_BY  = @UPDATE_NAME
                      --,ANL.ATTRIBUTE9        = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
        WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID
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
               ,ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        VALUES(@V_DIVISION_ID
              ,@PLAN_START_YYYYMMDD
              ,@V_SCP_PLAN_TYPE
              ,@V_SCP_PLAN_SEQ
              ,OPR.OPERATION_GROUP
              ,OPR.SITE_ID
              ,OPR.ITEM_ID
              ,OPR.LINE_ID
              ,OPR.OPERATION_ID
              ,'PROD_PLAN_AMEND'
              ,OPR.START_DATE
              ,OPR.OUT_QTY_INT
              ,@V_DIVISION_ID
              ,OPR.ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
              ,@UPDATE_NAME
              ,@NOW_DATE
              ,@UPDATE_NAME
              ,@NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
              );
        ------------------------------------------------------------------------
        -- INSERT HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_PRODUCTION_PLAN_H(
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
                                             ,ATTRIBUTE1
                                             ,ATTRIBUTE2
                                             ,ATTRIBUTE3
                                             ,ATTRIBUTE4
                                             ,ATTRIBUTE5
                                             ,ATTRIBUTE6
                                             ,ATTRIBUTE7
                                             ,ATTRIBUTE8
                                             ,ATTRIBUTE9
                                             ,ATTRIBUTE10
                                             ,HISTORY_CREATION_DATE
                                             )
        SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H
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
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,@NOW_DATE
        FROM SCP_ANL_PRODUCTION_PLAN WITH(NOLOCK)
        WHERE DIVISION_ID         = @V_DIVISION_ID
        AND MEASURE               IN ('PROD_PLAN_AMEND')
        AND PLAN_START_YYYYMMDD   = @PLAN_START_YYYYMMDD
        AND PLAN_TYPE             = @V_SCP_PLAN_TYPE
        AND SEQ                   = @V_SCP_PLAN_SEQ
        AND YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND LAST_UPDATED_BY       = @UPDATE_NAME
        AND LAST_UPDATE_DATE      = @NOW_DATE

        ------------------------------------------------------------------------
        -- Initialization SCP_ANL_PRODUCTION_PLAN_FIX QTY 
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_PRODUCTION_PLAN_FIX
        SET SCP_ANL_PRODUCTION_PLAN_FIX.QTY = 0
          , LAST_UPDATED_BY  = @UPDATE_NAME
          , LAST_UPDATE_DATE = @NOW_DATE
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
        FROM SCP_ANL_PRODUCTION_PLAN_FIX FX WITH(NOLOCK)
            INNER JOIN (SELECT SCM_SITE_ID
                              ,ITEM_ID
                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                        WHERE  PLAN_ID = @V_PLAN_ID
                        GROUP BY SCM_SITE_ID, ITEM_ID
                      ) ML
                ON  FX.SCM_SITE_ID = ML.SCM_SITE_ID
                AND FX.ITEM_ID     = ML.ITEM_ID
        WHERE FX.YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND   FX.DIVISION_ID         = @V_DIVISION_ID
        AND   FX.QTY != 0 
        ------------------------------------------------------------------------
        -- UPDATE SCP_ANL_PRODUCTION_PLAN_FIX QTY 
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_PRODUCTION_PLAN_FIX
        SET SCP_ANL_PRODUCTION_PLAN_FIX.QTY = OPR.OUT_QTY_INT
          , SCP_ANL_PRODUCTION_PLAN_FIX.LAST_UPDATED_BY  = @UPDATE_NAME
          , SCP_ANL_PRODUCTION_PLAN_FIX.LAST_UPDATE_DATE = @NOW_DATE
          --, SCP_ANL_PRODUCTION_PLAN_FIX.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/UPDATE'
        FROM SCP_ANL_PRODUCTION_PLAN_FIX FX WITH(NOLOCK) 
            INNER JOIN @OP_RESULT OPR
                ON  FX.DIVISION_ID = @V_DIVISION_ID
                AND FX.OPERATION_GROUP = OPR.OPERATION_GROUP
                AND FX.SCM_SITE_ID     = OPR.SITE_ID
                AND FX.ITEM_ID         = OPR.ITEM_ID
                AND FX.LINE_ID         = OPR.LINE_ID
                AND FX.OPERATION_ID    = OPR.OPERATION_ID
                AND FX.YYYYMMDD        = OPR.START_DATE
        ------------------------------------------------------------------------
        -- INSERT FIX HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H(
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
                                                 ,ATTRIBUTE1
                                                 ,ATTRIBUTE2
                                                 ,ATTRIBUTE3
                                                 ,ATTRIBUTE4
                                                 ,ATTRIBUTE5
                                                 ,ATTRIBUTE6
                                                 ,ATTRIBUTE7
                                                 ,ATTRIBUTE8
                                                 ,ATTRIBUTE9
                                                 ,ATTRIBUTE10
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
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,@NOW_DATE
        FROM SCP_ANL_PRODUCTION_PLAN_FIX WITH(NOLOCK)
        WHERE DIVISION_ID         = @V_DIVISION_ID
        AND YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND LAST_UPDATED_BY       = @UPDATE_NAME
        AND LAST_UPDATE_DATE      = @NOW_DATE

    ------------------------------------------------------------------------
    -- ORDER_SHIPPING SEMI DATA START
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Get Order Shipping Int data
        ------------------------------------------------------------------------
        IF @CHK_INTEGRAL IS NULL
        BEGIN
            INSERT INTO @OS_RESULT
            SELECT OPERATION_GROUP
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,CM.BASIS_YYYYMMDD
                  ,TO_SITE
                  ,SUM(IIF(CM.BASIS_YYYYMMDD = YYYYMMDD, CONVERT(NUMERIC(30,10), QTY), 0)) AS OUT_QTY_INT
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID  
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
            FROM(
                SELECT FI.OPERATION_GROUP
                      ,OS.ITEM_ID        AS ITEM_ID
                      ,OS.FROM_SITE_ID   AS FROM_SITE
                      ,BOD.ATTRIBUTE7    AS BOD_ID
                      ,'SHIP_PLAN_AMEND' AS MEASURE
                      ,OS.DEPARTURE_DATE AS YYYYMMDD
                      ,OS.TO_SITE_ID     AS TO_SITE
                      ,CONVERT(FLOAT,OS.QTY) AS QTY -- 2026.04.16 Minyong Lee : UNION ALL로 인한 의도치 않은 타입캐스팅 및 소수 데이터 유실 에러 수정
                      ,@V_DIVISION_ID    AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID    AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,BOD.ATTRIBUTE8    AS BOD_TYPE
                FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                    INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
                        ON  BOD.PLAN_ID = @V_PLAN_ID
                        AND OS.BOD_ID   = BOD.BOD_ID
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = OS.ITEM_ID
                WHERE 1=1
                AND BOD.ATTRIBUTE8 = 'PLANT'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                AND OS.PLAN_ID = @V_PLAN_ID

                UNION ALL
                SELECT FI.OPERATION_GROUP
                      ,SM.ATTRIBUTE2      AS ITEM_ID
                      ,SM.ATTRIBUTE1      AS FROM_SITE
                      ,SM.ATTRIBUTE7      AS BOD_ID
                      ,'SHIP_PLAN_AMEND'  AS MEASURE
                      ,SM.DEPARTURE_DATE  AS YYYYMMDD
                      ,SM.ATTRIBUTE4      AS TO_SITE
                      ,SM.QUANTITY        AS QTY
                      ,@V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                 AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,SM.ATTRIBUTE8      AS BOD_TYPE
                FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = SM.ATTRIBUTE2
                WHERE   SM.PLAN_ID = @V_PLAN_ID
                AND     SM.ATTRIBUTE6 ='IN'
                AND     SM.ATTRIBUTE8 ='PLANT'
            ) A 
                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON 1=1
            WHERE   1=1
            AND     CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
            GROUP BY OPERATION_GROUP,ITEM_ID,FROM_SITE,BOD_ID,MEASURE,TO_SITE,ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE,BOD_TYPE,CM.BASIS_YYYYMMDD
        END
        ELSE IF @CHK_INTEGRAL IS NOT NULL
        BEGIN
            INSERT INTO @OS_RESULT
            SELECT OPERATION_GROUP
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  ,CM.BASIS_YYYYMMDD
                  ,TO_SITE
                  ,SUM(IIF(CM.BASIS_YYYYMMDD = YYYYMMDD, CONVERT(NUMERIC(30,10), QTY), 0)) AS OUT_QTY_INT
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID  
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
            FROM(
                SELECT FI.OPERATION_GROUP
                      ,OS.ITEM_ID        AS ITEM_ID
                      ,OS.FROM_SITE_ID   AS FROM_SITE
                      ,BOD.ATTRIBUTE7    AS BOD_ID
                      ,'SHIP_PLAN_AMEND' AS MEASURE
                      ,OS.DEPARTURE_DATE AS YYYYMMDD
                      ,OS.TO_SITE_ID     AS TO_SITE
                      ,CONVERT(FLOAT,OS.QTY_INT) AS QTY -- 2026.04.16 Minyong Lee : UNION ALL로 인한 의도치 않은 타입캐스팅 및 소수 데이터 유실 에러 수정
                      ,@V_DIVISION_ID    AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID    AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,BOD.ATTRIBUTE8    AS BOD_TYPE
                FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN  OS WITH(NOLOCK)
                    INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
                        ON  BOD.PLAN_ID = @V_PLAN_ID
                        AND OS.BOD_ID   = BOD.BOD_ID
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = OS.ITEM_ID
                WHERE 1=1
                AND BOD.ATTRIBUTE8 = 'PLANT'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                AND OS.PLAN_ID = @V_PLAN_ID

                UNION ALL
                SELECT FI.OPERATION_GROUP
                      ,SM.ATTRIBUTE2      AS ITEM_ID
                      ,SM.ATTRIBUTE1      AS FROM_SITE
                      ,SM.ATTRIBUTE7      AS BOD_ID
                      ,'SHIP_PLAN_AMEND'  AS MEASURE
                      ,SM.DEPARTURE_DATE  AS YYYYMMDD
                      ,SM.ATTRIBUTE4      AS TO_SITE
                      ,SM.QUANTITY        AS QTY
                      ,@V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                 AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,SM.ATTRIBUTE8      AS BOD_TYPE
                FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = SM.ATTRIBUTE2
                WHERE   SM.PLAN_ID = @V_PLAN_ID
                AND     SM.ATTRIBUTE6 ='IN'
                AND     SM.ATTRIBUTE8 ='PLANT'
            ) A 
                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON 1=1
            WHERE   1=1
            AND     CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
            GROUP BY OPERATION_GROUP,ITEM_ID,FROM_SITE,BOD_ID,MEASURE,TO_SITE,ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE,BOD_TYPE,CM.BASIS_YYYYMMDD
        END

        ------------------------------------------------------------------------
        -- Initialization Qty
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_SEMI
        SET SCP_ANL_SHIPMENT_PLAN_SEMI.QTY = 0
          , LAST_UPDATED_BY  = @UPDATE_NAME
          , LAST_UPDATE_DATE = @NOW_DATE
          --, ATTRIBUTE9        = 'U'
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
        FROM SCP_ANL_SHIPMENT_PLAN_SEMI 
        INNER JOIN  (SELECT SCM_SITE_ID
                           ,ITEM_ID
                     FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                     WHERE  PLAN_ID = @V_PLAN_ID
                     GROUP BY SCM_SITE_ID, ITEM_ID
                   ) ML
        ON  SCP_ANL_SHIPMENT_PLAN_SEMI.FROM_SITE = ML.SCM_SITE_ID
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.ITEM_ID      = ML.ITEM_ID
        WHERE 1=1
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.DIVISION_ID         = @V_DIVISION_ID
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.MEASURE             IN ('SHIP_PLAN_AMEND')
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.PLAN_TYPE           = @V_SCP_PLAN_TYPE
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.SEQ                 = @V_SCP_PLAN_SEQ
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND SCP_ANL_SHIPMENT_PLAN_SEMI.QTY != 0 


        ------------------------------------------------------------------------
        -- MERGE INTO OPT ENG Data
        ------------------------------------------------------------------------
        PRINT 'SCP_ANL_SHIPMENT_PLAN_SEMI'
        MERGE INTO SCP_ANL_SHIPMENT_PLAN_SEMI AS ANL
        USING @OS_RESULT AS OSR
        ON(    ANL.DIVISION_ID         = @V_DIVISION_ID
           AND ANL.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
           AND ANL.PLAN_TYPE           = @V_SCP_PLAN_TYPE
           AND ANL.SEQ                 = @V_SCP_PLAN_SEQ
           AND ANL.OPERATION_GROUP     = OSR.OPERATION_GROUP
           AND ANL.ITEM_ID             = OSR.ITEM_ID
           AND ANL.FROM_SITE           = OSR.FROM_SITE
           AND ANL.BOD_ID              = OSR.BOD_ID
           AND ANL.MEASURE             = OSR.MEASURE
           AND ANL.YYYYMMDD            = OSR.YYYYMMDD
          )
        WHEN MATCHED THEN 
            UPDATE SET ANL.QTY = OSR.QTY
                      ,ANL.LAST_UPDATE_DATE = @NOW_DATE
                      ,ANL.LAST_UPDATED_BY  = @UPDATE_NAME
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10      = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
        WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID
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
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        VALUES(@V_DIVISION_ID
              ,@PLAN_START_YYYYMMDD
              ,@V_SCP_PLAN_TYPE
              ,@V_SCP_PLAN_SEQ
              ,OSR.OPERATION_GROUP
              ,OSR.ITEM_ID
              ,OSR.FROM_SITE
              ,OSR.BOD_ID
              ,OSR.MEASURE
              ,OSR.YYYYMMDD
              ,OSR.TO_SITE
              ,OSR.QTY
              ,OSR.ORIGIN_TO_DIVISION_ID
              ,OSR.ORIGIN_FROM_DIVISION_ID
              ,OSR.ELECTRODE_TYPE
              ,@UPDATE_NAME
              ,@NOW_DATE
              ,@UPDATE_NAME
              ,@NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
              );
        ------------------------------------------------------------------------
        -- INSERT HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI_H(
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
                                                ,ATTRIBUTE1
                                                ,ATTRIBUTE2
                                                ,ATTRIBUTE3
                                                ,ATTRIBUTE4
                                                ,ATTRIBUTE5
                                                ,ATTRIBUTE6
                                                ,ATTRIBUTE7
                                                ,ATTRIBUTE8
                                                ,ATTRIBUTE9
                                                ,ATTRIBUTE10
                                                ,HISTORY_CREATION_DATE
                                                )
        SELECT NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H
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
              ,NULL AS UPDATE_REASON_BOD
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,@NOW_DATE AS HISTORY_CREATION_DATE
        FROM SCP_ANL_SHIPMENT_PLAN_SEMI WITH(NOLOCK)
        WHERE DIVISION_ID         = @V_DIVISION_ID
        AND MEASURE             IN ('SHIP_PLAN_AMEND')
        AND PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND PLAN_TYPE           = @V_SCP_PLAN_TYPE
        AND SEQ                 = @V_SCP_PLAN_SEQ
        AND YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND LAST_UPDATED_BY = @UPDATE_NAME
        AND LAST_UPDATE_DATE =@NOW_DATE


        ------------------------------------------------------------------------
        -- Initialization SCP_ANL_SHIPMENT_PLAN_FIX QTY 
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX
        SET SCP_ANL_SHIPMENT_PLAN_FIX.QTY = 0
          , LAST_UPDATED_BY  = @UPDATE_NAME
          , LAST_UPDATE_DATE = @NOW_DATE
          --, ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
        FROM SCP_ANL_SHIPMENT_PLAN_FIX FX WITH(NOLOCK)
            INNER JOIN (SELECT SCM_SITE_ID
                              ,ITEM_ID
                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                        WHERE  PLAN_ID = @V_PLAN_ID
                        GROUP BY SCM_SITE_ID, ITEM_ID
                      ) ML
                ON  FX.FROM_SITE = ML.SCM_SITE_ID
                AND FX.ITEM_ID     = ML.ITEM_ID
        WHERE FX.YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND   FX.DIVISION_ID         = @V_DIVISION_ID
        AND   FX.QTY != 0 


        ------------------------------------------------------------------------
        -- Update SCP_ANL_SHIPMENT_PLAN_FIX QTY 
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX
        SET SCP_ANL_SHIPMENT_PLAN_FIX.QTY = OSR.QTY
          , SCP_ANL_SHIPMENT_PLAN_FIX.LAST_UPDATED_BY  = @UPDATE_NAME
          , SCP_ANL_SHIPMENT_PLAN_FIX.LAST_UPDATE_DATE = @NOW_DATE
          --, SCP_ANL_SHIPMENT_PLAN_FIX.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/UPDATE'
        FROM SCP_ANL_SHIPMENT_PLAN_FIX FX WITH(NOLOCK) 
            INNER JOIN @OS_RESULT OSR
                ON  FX.DIVISION_ID     = @V_DIVISION_ID
                AND FX.BIZ_TYPE        = OSR.OPERATION_GROUP
                AND FX.ITEM_ID         = OSR.ITEM_ID
                AND FX.TO_SITE         = OSR.TO_SITE
                AND FX.FROM_SITE       = OSR.FROM_SITE
                AND FX.BOD_ID          = OSR.BOD_ID
                AND FX.YYYYMMDD        = OSR.YYYYMMDD

    ------------------------------------------------------------------------
    -- ORDER_SHIPPING FG DATA START
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Get Order Shipping Int data
        ------------------------------------------------------------------------
        IF @CHK_INTEGRAL IS NULL
        BEGIN
            INSERT INTO @OS_RESULT_FG
            SELECT BIZ_TYPE
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  --,YYYYMMDD
                  ,CM.BASIS_YYYYMMDD
                  ,TO_SITE
                  ,SUM(IIF(CM.BASIS_YYYYMMDD = YYYYMMDD, CONVERT(NUMERIC(30,10), QTY), 0)) AS OUT_QTY_INT
                  --,QTY
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
                  ,INCOTERMS
            FROM(
                SELECT FI.OPERATION_GROUP AS BIZ_TYPE
                      ,BOD.ATTRIBUTE9     AS PROJECT_CODE
                      ,OS.ITEM_ID         AS ITEM_ID
                      ,OS.FROM_SITE_ID    AS FROM_SITE
                      ,BOD.ATTRIBUTE7     AS BOD_ID
                      ,'SHIP_PLAN_AMEND'  AS MEASURE
                      ,OS.DEPARTURE_DATE  AS YYYYMMDD
                      ,OS.TO_SITE_ID      AS TO_SITE
                      ,CONVERT(FLOAT,OS.QTY) AS QTY -- 2026.04.16 Minyong Lee : UNION ALL로 인한 의도치 않은 타입캐스팅 및 소수 데이터 유실 에러 수정
                      ,@V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                 AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,BOD.ATTRIBUTE8     AS BOD_TYPE
                      ,BOD.ATTRIBUTE6     AS INCOTERMS
                FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN  OS WITH(NOLOCK)
                    INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
                        ON  BOD.PLAN_ID = @V_PLAN_ID
                        AND OS.BOD_ID   = BOD.BOD_ID
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = OS.ITEM_ID
                WHERE 1=1
                AND OS.PLAN_ID=@V_PLAN_ID
                AND BOD.ATTRIBUTE8 = 'SALES'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                AND BOD.ATTRIBUTE7 <> 'DUMMY'
                ------------------------------------------------------------------------
                -- Get Scheduled Move data
                -- INT 테이블 결과에 Scheduled Move 데이터는 나오지 않음
                ------------------------------------------------------------------------
                UNION ALL
                SELECT FI.OPERATION_GROUP
                      ,SM.ATTRIBUTE10     AS PROJECT_CODE
                      ,SM.ATTRIBUTE2      AS ITEM_ID
                      ,SM.ATTRIBUTE1      AS FROM_SITE
                      ,SM.ATTRIBUTE7      AS BOD_ID
                      ,'SHIP_PLAN_AMEND'  AS MEASURE
                      ,SM.DEPARTURE_DATE  AS YYYYMMDD
                      ,SM.ATTRIBUTE4      AS TO_SITE
                      ,SUM(SM.QUANTITY)   AS QTY
                      ,@V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                 AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,SM.ATTRIBUTE8      AS BOD_TYPE
                      ,SM.ATTRIBUTE9      AS INCOTERMS
                FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = SM.ATTRIBUTE2
                WHERE   SM.PLAN_ID = @V_PLAN_ID
                AND     SM.ATTRIBUTE6 ='IN'
                AND     SM.ATTRIBUTE8 ='SALES'
                GROUP BY FI.OPERATION_GROUP, SM.ATTRIBUTE10,SM.ATTRIBUTE2,SM.ATTRIBUTE1,SM.ATTRIBUTE7,SM.DEPARTURE_DATE,SM.ATTRIBUTE4,SM.ATTRIBUTE8,SM.ATTRIBUTE9 -- SCHEDULED MOVE 테이블을 만들 때 PROJECT CODE가 없으면 찾아주는데, 원본에 있는거 하나, 없는거 하나 생길 수 있음
                ) A
                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON 1=1
            WHERE   CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
            GROUP BY BIZ_TYPE,PROJECT_CODE,ITEM_ID,FROM_SITE,BOD_ID,MEASURE,TO_SITE,ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE,BOD_TYPE,INCOTERMS,CM.BASIS_YYYYMMDD
        END
        ELSE IF @CHK_INTEGRAL IS NOT NULL
        BEGIN
            INSERT INTO @OS_RESULT_FG
            SELECT BIZ_TYPE
                  ,PROJECT_CODE
                  ,ITEM_ID
                  ,FROM_SITE
                  ,BOD_ID
                  ,MEASURE
                  --,YYYYMMDD
                  ,CM.BASIS_YYYYMMDD
                  ,TO_SITE
                  ,SUM(IIF(CM.BASIS_YYYYMMDD = YYYYMMDD, CONVERT(NUMERIC(30,10), QTY), 0)) AS OUT_QTY_INT
                  --,QTY
                  ,ORIGIN_FROM_DIVISION_ID
                  ,ORIGIN_TO_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,BOD_TYPE
                  ,INCOTERMS
            FROM(
                SELECT FI.OPERATION_GROUP AS BIZ_TYPE
                      ,BOD.ATTRIBUTE9     AS PROJECT_CODE
                      ,OS.ITEM_ID         AS ITEM_ID
                      ,OS.FROM_SITE_ID    AS FROM_SITE
                      ,BOD.ATTRIBUTE7     AS BOD_ID
                      ,'SHIP_PLAN_AMEND'  AS MEASURE
                      ,OS.DEPARTURE_DATE  AS YYYYMMDD
                      ,OS.TO_SITE_ID      AS TO_SITE
                      ,CONVERT(FLOAT,OS.QTY_INT) AS QTY -- 2026.04.16 Minyong Lee : UNION ALL로 인한 의도치 않은 타입캐스팅 및 소수 데이터 유실 에러 수정
                      ,@V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                 AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,BOD.ATTRIBUTE8     AS BOD_TYPE
                      ,BOD.ATTRIBUTE6     AS INCOTERMS
                FROM SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN  OS WITH(NOLOCK)
                    INNER JOIN SCP_OPT_ENG_BOD_SN BOD WITH(NOLOCK) 
                        ON  BOD.PLAN_ID = @V_PLAN_ID
                        AND OS.BOD_ID   = BOD.BOD_ID
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = OS.ITEM_ID
                WHERE 1=1
                AND OS.PLAN_ID=@V_PLAN_ID
                AND BOD.ATTRIBUTE8 = 'SALES'  --SALES는 FG에 넣고 PLANT만 SEMI에 넣으면 됨.
                AND BOD.ATTRIBUTE7 <> 'DUMMY'
                ------------------------------------------------------------------------
                -- Get Scheduled Move data
                -- INT 테이블 결과에 Scheduled Move 데이터는 나오지 않음
                ------------------------------------------------------------------------
                UNION ALL
                SELECT FI.OPERATION_GROUP
                      ,SM.ATTRIBUTE10     AS PROJECT_CODE
                      ,SM.ATTRIBUTE2      AS ITEM_ID
                      ,SM.ATTRIBUTE1      AS FROM_SITE
                      ,SM.ATTRIBUTE7      AS BOD_ID
                      ,'SHIP_PLAN_AMEND'  AS MEASURE
                      ,SM.DEPARTURE_DATE  AS YYYYMMDD
                      ,SM.ATTRIBUTE4      AS TO_SITE
                      ,SUM(SM.QUANTITY)   AS QTY
                      ,@V_DIVISION_ID     AS ORIGIN_FROM_DIVISION_ID -- 전극 할 땐 찾아서 넣어야 함
                      ,@V_DIVISION_ID     AS ORIGIN_TO_DIVISION_ID   -- 전극 할 땐 찾아서 넣어야 함
                      ,''                 AS ELECTRODE_TYPE -- 2025.11.05 Minyong Lee : ELECTRODE_TYPE NULL -> ''
                      ,SM.ATTRIBUTE8      AS BOD_TYPE
                      ,SM.ATTRIBUTE9      AS INCOTERMS
                FROM SCP_OPT_ENG_SCHEDULED_MOVE_SN SM WITH(NOLOCK)
                    INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                        ON  FI.DIVISION_ID = @V_DIVISION_ID
                        AND FI.ITEM_ID     = SM.ATTRIBUTE2
                WHERE   SM.PLAN_ID = @V_PLAN_ID
                AND     SM.ATTRIBUTE6 ='IN'
                AND     SM.ATTRIBUTE8 ='SALES'
                GROUP BY FI.OPERATION_GROUP, SM.ATTRIBUTE10,SM.ATTRIBUTE2,SM.ATTRIBUTE1,SM.ATTRIBUTE7,SM.DEPARTURE_DATE,SM.ATTRIBUTE4,SM.ATTRIBUTE8,SM.ATTRIBUTE9 -- SCHEDULED MOVE 테이블을 만들 때 PROJECT CODE가 없으면 찾아주는데, 원본에 있는거 하나, 없는거 하나 생길 수 있음
                ) A
                INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
                    ON 1=1
            WHERE   CM.BASIS_YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD  -- Plan From - To 구간 전체.
            GROUP BY BIZ_TYPE,PROJECT_CODE,ITEM_ID,FROM_SITE,BOD_ID,MEASURE,TO_SITE,ORIGIN_FROM_DIVISION_ID,ORIGIN_TO_DIVISION_ID,ELECTRODE_TYPE,BOD_TYPE,INCOTERMS,CM.BASIS_YYYYMMDD
        END

        ------------------------------------------------------------------------
        -- 0. 입력할 데이터가 있으면 진행
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- 1. Initialization Qty
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FG
        SET SCP_ANL_SHIPMENT_PLAN_FG.QTY = 0
          , LAST_UPDATED_BY  = @UPDATE_NAME
          , LAST_UPDATE_DATE = @NOW_DATE
          --, ATTRIBUTE9       = 'U'
          --, ATTRIBUTE10      = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/INIT'
        FROM SCP_ANL_SHIPMENT_PLAN_FG 
        INNER JOIN  (SELECT SCM_SITE_ID
                           ,ITEM_ID
                     FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                     WHERE  PLAN_ID = @V_PLAN_ID
                     GROUP BY SCM_SITE_ID, ITEM_ID
                   ) ML
        ON  SCP_ANL_SHIPMENT_PLAN_FG.FROM_SITE = ML.SCM_SITE_ID
        AND SCP_ANL_SHIPMENT_PLAN_FG.ITEM_ID   = ML.ITEM_ID
        WHERE 1=1
        AND SCP_ANL_SHIPMENT_PLAN_FG.DIVISION_ID         = @V_DIVISION_ID
        AND SCP_ANL_SHIPMENT_PLAN_FG.MEASURE             IN ('SHIP_PLAN_AMEND')
        AND SCP_ANL_SHIPMENT_PLAN_FG.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND SCP_ANL_SHIPMENT_PLAN_FG.PLAN_TYPE           = @V_SCP_PLAN_TYPE
        AND SCP_ANL_SHIPMENT_PLAN_FG.SEQ                 = @V_SCP_PLAN_SEQ
        AND SCP_ANL_SHIPMENT_PLAN_FG.YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND SCP_ANL_SHIPMENT_PLAN_FG.QTY != 0 

        ------------------------------------------------------------------------
        -- 2. Get SCP_ANL_SHIPMENT_PLAN_FG DATA
        -- 프로젝트 코드가 1개인 대상만 추출 -> 속도 개선을 위한 TEMP 테이블 사용
        -- '-'는 제외하고 COUNTING
        ------------------------------------------------------------------------
        INSERT INTO @OS_RESULT_FG_SMMR
        SELECT NPC.ITEM_ID
              ,NPC.BOD_ID
              ,FG.PROJECT_CODE
        FROM(
            SELECT DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,BIZ_TYPE
                  ,FG.ITEM_ID
                  ,MEASURE
                  ,BOD_ID
            FROM(
                SELECT DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,BIZ_TYPE
                      ,PROJECT_CODE
                      ,FG.ITEM_ID
                      ,MEASURE
                      ,BOD_ID
                FROM SCP_ANL_SHIPMENT_PLAN_FG FG WITH(NOLOCK)
                    INNER JOIN (SELECT SCM_SITE_ID
                                      ,ITEM_ID
                                FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                                WHERE  PLAN_ID = @V_PLAN_ID
                                GROUP BY SCM_SITE_ID, ITEM_ID
                               ) ML
                        ON  FG.FROM_SITE   = ML.SCM_SITE_ID
                        AND FG.ITEM_ID     = ML.ITEM_ID
                WHERE 1=1
                AND FG.DIVISION_ID         = @V_DIVISION_ID
                AND FG.MEASURE             IN ('SHIP_PLAN_AMEND')
                AND FG.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
                AND FG.PLAN_TYPE           = @V_SCP_PLAN_TYPE
                AND FG.SEQ                 = @V_SCP_PLAN_SEQ
                AND FG.YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
                AND FG.PROJECT_CODE       != '-'
                GROUP BY DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,BIZ_TYPE,PROJECT_CODE,FG.ITEM_ID,MEASURE,BOD_ID
                ) FG
            GROUP BY  DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,BIZ_TYPE,ITEM_ID,MEASURE,BOD_ID
            HAVING COUNT(DIVISION_ID) =1
            ) NPC
            INNER JOIN SCP_ANL_SHIPMENT_PLAN_FG FG WITH(NOLOCK)
                ON  NPC.ITEM_ID = FG.ITEM_ID
                AND NPC.BOD_ID  = FG.BOD_ID
                AND FG.DIVISION_ID         = NPC.DIVISION_ID        
                AND FG.MEASURE             = NPC.MEASURE            
                AND FG.PLAN_START_YYYYMMDD = NPC.PLAN_START_YYYYMMDD
                AND FG.PLAN_TYPE           = NPC.PLAN_TYPE          
                AND FG.SEQ                 = NPC.SEQ                
                AND FG.YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
                AND FG.PROJECT_CODE       != '-'
        GROUP BY NPC.ITEM_ID,NPC.BOD_ID,FG.PROJECT_CODE


        ------------------------------------------------------------------------
        -- 2-1. 프로젝트 코드가 있으면 바로 넣고, 없는 애들만 2-2에서 프로젝트 코드를 찾아서 넣음
        ------------------------------------------------------------------------
        PRINT 'SCP_ANL_SHIPMENT_PLAN_FG'
        MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG AS ANL
        USING (SELECT OSF.OPERATION_GROUP        
                     ,OSF.PROJECT_CODE    
                     ,OSF.ITEM_ID            
                     ,OSF.TO_SITE            
                     ,OSF.INCOTERMS          
                     ,OSF.FROM_SITE          
                     ,OSF.BOD_ID             
                     ,OSF.MEASURE            
                     ,OSF.YYYYMMDD          
                     ,OSF.QTY
                     ,OSF.ORIGIN_FROM_DIVISION_ID
                     ,OSF.ORIGIN_TO_DIVISION_ID
                     ,OSF.ELECTRODE_TYPE
               FROM @OS_RESULT_FG OSF
               WHERE OSF.PROJECT_CODE != '-' --프로젝트 코드를 가지고있는 애들은 바로 MERGE INTO
              ) AS OSF
        ON(    ANL.DIVISION_ID         = @V_DIVISION_ID
           AND ANL.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
           AND ANL.PLAN_TYPE           = @V_SCP_PLAN_TYPE
           AND ANL.SEQ                 = @V_SCP_PLAN_SEQ
           AND ANL.BIZ_TYPE            = OSF.OPERATION_GROUP
           AND ANL.PROJECT_CODE        = OSF.PROJECT_CODE
           AND ANL.ITEM_ID             = OSF.ITEM_ID
           AND ANL.TO_SITE             = OSF.TO_SITE
           AND ANL.INCOTERMS           = OSF.INCOTERMS
           AND ANL.FROM_SITE           = OSF.FROM_SITE
           AND ANL.BOD_ID              = OSF.BOD_ID
           AND ANL.MEASURE             = OSF.MEASURE
           AND ANL.YYYYMMDD            = OSF.YYYYMMDD
          )
        WHEN MATCHED THEN 
            UPDATE SET ANL.QTY = OSF.QTY
                      ,ANL.LAST_UPDATE_DATE = @NOW_DATE
                      ,ANL.LAST_UPDATED_BY  = @UPDATE_NAME
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
        WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID        
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
               ,ORIGIN_FROM_DIVISION_ID
               ,ORIGIN_TO_DIVISION_ID
               ,ELECTRODE_TYPE
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        VALUES(@V_DIVISION_ID
              ,@PLAN_START_YYYYMMDD
              ,@V_SCP_PLAN_TYPE
              ,@V_SCP_PLAN_SEQ
              ,OSF.OPERATION_GROUP         
              ,OSF.PROJECT_CODE
              ,OSF.ITEM_ID            
              ,OSF.TO_SITE            
              ,OSF.INCOTERMS          
              ,OSF.FROM_SITE          
              ,OSF.BOD_ID             
              ,OSF.MEASURE            
              ,OSF.YYYYMMDD          
              ,OSF.QTY
              ,OSF.ORIGIN_FROM_DIVISION_ID
              ,OSF.ORIGIN_TO_DIVISION_ID
              ,OSF.ELECTRODE_TYPE
              ,@UPDATE_NAME
              ,@NOW_DATE
              ,@UPDATE_NAME
              ,@NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
              );


        ------------------------------------------------------------------------
        -- 2-2. 엔진 결과에서 프로젝트 코드가 없는('-') 대상은 찾아서 넣어야 함
        -- FG에  PROJECT가 한개인 것 MERGE INTO 
        -- 프로젝트가 한 개 라면, 그 프로젝트를 찾아서 INSERT 하기위해
        ------------------------------------------------------------------------
        PRINT 'SCP_ANL_SHIPMENT_PLAN_FG_____2'
        MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG AS ANL
        USING (SELECT OSF.OPERATION_GROUP        
                     ,SMMR.PROJECT_CODE    
                     ,OSF.ITEM_ID            
                     ,OSF.TO_SITE            
                     ,OSF.INCOTERMS          
                     ,OSF.FROM_SITE          
                     ,OSF.BOD_ID             
                     ,OSF.MEASURE            
                     ,OSF.YYYYMMDD          
                     ,OSF.QTY
                     ,OSF.ORIGIN_FROM_DIVISION_ID
                     ,OSF.ORIGIN_TO_DIVISION_ID
                     ,OSF.ELECTRODE_TYPE
               FROM @OS_RESULT_FG OSF
                   INNER JOIN @OS_RESULT_FG_SMMR SMMR
                            ON  OSF.ITEM_ID = SMMR.ITEM_ID
                            AND OSF.BOD_ID  = SMMR.BOD_ID
               WHERE OSF.PROJECT_CODE = '-'
              ) AS OSF
        ON(    ANL.DIVISION_ID         = @V_DIVISION_ID
           AND ANL.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
           AND ANL.PLAN_TYPE           = @V_SCP_PLAN_TYPE
           AND ANL.SEQ                 = @V_SCP_PLAN_SEQ
           AND ANL.BIZ_TYPE            = OSF.OPERATION_GROUP
           AND ANL.PROJECT_CODE        = OSF.PROJECT_CODE
           AND ANL.ITEM_ID             = OSF.ITEM_ID
           AND ANL.TO_SITE             = OSF.TO_SITE
           AND ANL.INCOTERMS           = OSF.INCOTERMS
           AND ANL.FROM_SITE           = OSF.FROM_SITE
           AND ANL.BOD_ID              = OSF.BOD_ID
           AND ANL.MEASURE             = OSF.MEASURE
           AND ANL.YYYYMMDD            = OSF.YYYYMMDD
          )
        WHEN MATCHED THEN 
            UPDATE SET ANL.QTY = OSF.QTY
                      ,ANL.LAST_UPDATE_DATE = @NOW_DATE
                      ,ANL.LAST_UPDATED_BY  = @UPDATE_NAME
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
        WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID        
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
               ,ORIGIN_FROM_DIVISION_ID
               ,ORIGIN_TO_DIVISION_ID
               ,ELECTRODE_TYPE
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        VALUES(@V_DIVISION_ID
              ,@PLAN_START_YYYYMMDD
              ,@V_SCP_PLAN_TYPE
              ,@V_SCP_PLAN_SEQ
              ,OSF.OPERATION_GROUP         
              ,OSF.PROJECT_CODE    --OSF를 만들 때 하나인 프로젝트 코드를 찾았음
              ,OSF.ITEM_ID            
              ,OSF.TO_SITE            
              ,OSF.INCOTERMS          
              ,OSF.FROM_SITE          
              ,OSF.BOD_ID             
              ,OSF.MEASURE            
              ,OSF.YYYYMMDD          
              ,OSF.QTY
              ,OSF.ORIGIN_FROM_DIVISION_ID
              ,OSF.ORIGIN_TO_DIVISION_ID
              ,OSF.ELECTRODE_TYPE
              ,@UPDATE_NAME
              ,@NOW_DATE
              ,@UPDATE_NAME
              ,@NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
              );

        ------------------------------------------------------------------------
        -- 3. FG에 프로젝트가 여러개인 애들 MERGE INTO
        -- Project Code가 -로 등록되어있으면 update, 아니면 Project Code를 -로 insert
        ------------------------------------------------------------------------
        PRINT 'SCP_ANL_SHIPMENT_PLAN_FG_____3'
        MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG AS ANL
        USING (SELECT OSF.OPERATION_GROUP        
                     ,OSF.PROJECT_CODE    
                     ,OSF.ITEM_ID            
                     ,OSF.TO_SITE            
                     ,OSF.INCOTERMS          
                     ,OSF.FROM_SITE          
                     ,OSF.BOD_ID             
                     ,OSF.MEASURE            
                     ,OSF.YYYYMMDD          
                     ,OSF.QTY
                     ,OSF.ORIGIN_FROM_DIVISION_ID
                     ,OSF.ORIGIN_TO_DIVISION_ID
                     ,OSF.ELECTRODE_TYPE
               FROM   @OS_RESULT_FG OSF
               LEFT OUTER JOIN @OS_RESULT_FG_SMMR SMMR
                            ON  OSF.ITEM_ID = SMMR.ITEM_ID
                            AND OSF.BOD_ID  = SMMR.BOD_ID
               WHERE SMMR.ITEM_ID IS NULL
               AND   OSF.PROJECT_CODE = '-'
              ) AS OSF
        ON(    ANL.DIVISION_ID         = @V_DIVISION_ID
           AND ANL.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
           AND ANL.PLAN_TYPE           = @V_SCP_PLAN_TYPE
           AND ANL.SEQ                 = @V_SCP_PLAN_SEQ
           AND ANL.BIZ_TYPE            = OSF.OPERATION_GROUP
           AND ANL.PROJECT_CODE        = OSF.PROJECT_CODE
           AND ANL.ITEM_ID             = OSF.ITEM_ID
           AND ANL.TO_SITE             = OSF.TO_SITE
           AND ANL.INCOTERMS           = OSF.INCOTERMS
           AND ANL.FROM_SITE           = OSF.FROM_SITE
           AND ANL.BOD_ID              = OSF.BOD_ID
           AND ANL.MEASURE             = OSF.MEASURE
           AND ANL.YYYYMMDD            = OSF.YYYYMMDD
          )
        WHEN MATCHED THEN 
            UPDATE SET ANL.QTY = OSF.QTY
                      ,ANL.LAST_UPDATE_DATE = @NOW_DATE
                      ,ANL.LAST_UPDATED_BY  = @UPDATE_NAME
                      --,ANL.ATTRIBUTE9       = 'U'
                      --,ANL.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
        WHEN NOT MATCHED THEN
        INSERT (DIVISION_ID        
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
               ,ORIGIN_FROM_DIVISION_ID
               ,ORIGIN_TO_DIVISION_ID
               ,ELECTRODE_TYPE
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               --,ATTRIBUTE9
               --,ATTRIBUTE10
               )
        VALUES(@V_DIVISION_ID
              ,@PLAN_START_YYYYMMDD
              ,@V_SCP_PLAN_TYPE
              ,@V_SCP_PLAN_SEQ
              ,OSF.OPERATION_GROUP         
              ,OSF.PROJECT_CODE    --OSF를 만들 때 '-'로 넣었음
              ,OSF.ITEM_ID            
              ,OSF.TO_SITE            
              ,OSF.INCOTERMS          
              ,OSF.FROM_SITE          
              ,OSF.BOD_ID             
              ,OSF.MEASURE            
              ,OSF.YYYYMMDD          
              ,OSF.QTY
              ,OSF.ORIGIN_FROM_DIVISION_ID
              ,OSF.ORIGIN_TO_DIVISION_ID
              ,OSF.ELECTRODE_TYPE
              ,@UPDATE_NAME
              ,@NOW_DATE
              ,@UPDATE_NAME
              ,@NOW_DATE
              --,'I'
              --,CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/MERGE'
              );

        ------------------------------------------------------------------------
        -- INSERT HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG_H(
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
                                              ,ATTRIBUTE1
                                              ,ATTRIBUTE2
                                              ,ATTRIBUTE3
                                              ,ATTRIBUTE4
                                              ,ATTRIBUTE5
                                              ,ATTRIBUTE6
                                              ,ATTRIBUTE7
                                              ,ATTRIBUTE8
                                              ,ATTRIBUTE9
                                              ,ATTRIBUTE10
                                              ,HISTORY_CREATION_DATE
                                              )
        SELECT NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H AS HISTORY_SEQ
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
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,@NOW_DATE AS HISTORY_CREATION_DATE
        FROM SCP_ANL_SHIPMENT_PLAN_FG WITH(NOLOCK)
        WHERE DIVISION_ID         = @V_DIVISION_ID
        AND MEASURE             IN ('SHIP_PLAN_AMEND')
        AND PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND PLAN_TYPE           = @V_SCP_PLAN_TYPE
        AND SEQ                 = @V_SCP_PLAN_SEQ
        AND YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND LAST_UPDATED_BY = @UPDATE_NAME
        AND LAST_UPDATE_DATE =@NOW_DATE
        ------------------------------------------------------------------------
        -- Update SCP_ANL_SHIPMENT_PLAN_FIX QTY 
        ------------------------------------------------------------------------
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX
        SET SCP_ANL_SHIPMENT_PLAN_FIX.QTY = OSF.QTY
          , SCP_ANL_SHIPMENT_PLAN_FIX.LAST_UPDATED_BY  = @UPDATE_NAME
          , SCP_ANL_SHIPMENT_PLAN_FIX.LAST_UPDATE_DATE = @NOW_DATE
          --, SCP_ANL_SHIPMENT_PLAN_FIX.ATTRIBUTE10       = CONVERT(NVARCHAR(30),@NOW_DATE,120) + '/OPT_ENG/UPDATE'
        FROM SCP_ANL_SHIPMENT_PLAN_FIX FX WITH(NOLOCK) 
            INNER JOIN @OS_RESULT_FG OSF
                ON  FX.DIVISION_ID     = @V_DIVISION_ID
                AND FX.BIZ_TYPE        = OSF.OPERATION_GROUP
                AND FX.ITEM_ID         = OSF.ITEM_ID
                AND FX.TO_SITE         = OSF.TO_SITE
                AND FX.FROM_SITE       = OSF.FROM_SITE
                AND FX.BOD_ID          = OSF.BOD_ID
                AND FX.YYYYMMDD        = OSF.YYYYMMDD
                AND FX.PROJECT_CODE    = OSF.PROJECT_CODE
        ------------------------------------------------------------------------
        -- INSERT FIX HISTORY
        ------------------------------------------------------------------------
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H( HISTORY_SEQ
                                                ,FIX_ID
                                                ,DIVISION_ID
                                                ,BIZ_TYPE
                                                ,ITEM_ID
                                                ,TO_SITE
                                                ,FROM_SITE
                                                ,BOD_ID
                                                ,YYYYMMDD
                                                ,PROJECT_CODE
                                                ,INCOTERMS
                                                ,QTY
                                                ,FIX_REASON
                                                ,ORIGIN_FROM_DIVISION_ID
                                                ,ORIGIN_TO_DIVISION_ID
                                                ,ELECTRODE_TYPE
                                                ,CREATED_BY
                                                ,CREATION_DATE
                                                ,LAST_UPDATED_BY
                                                ,LAST_UPDATE_DATE
                                                ,ATTRIBUTE1
                                                ,ATTRIBUTE2
                                                ,ATTRIBUTE3
                                                ,ATTRIBUTE4
                                                ,ATTRIBUTE5
                                                ,ATTRIBUTE6
                                                ,ATTRIBUTE7
                                                ,ATTRIBUTE8
                                                ,ATTRIBUTE9
                                                ,ATTRIBUTE10
                                                ,HISTORY_CREATION_DATE
                                                )
        SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H -- 원본에서 SCP_ANL_SHIPMENT_PLAN_FIX_H의 SEQ를 SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H로 생성 중.
              ,FIX_ID
              ,DIVISION_ID
              ,BIZ_TYPE
              ,ITEM_ID
              ,TO_SITE
              ,FROM_SITE
              ,BOD_ID
              ,YYYYMMDD
              ,PROJECT_CODE
              ,INCOTERMS
              ,QTY
              ,FIX_REASON
              ,ORIGIN_FROM_DIVISION_ID
              ,ORIGIN_TO_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,ATTRIBUTE6
              ,ATTRIBUTE7
              ,ATTRIBUTE8
              ,ATTRIBUTE9
              ,ATTRIBUTE10
              ,@NOW_DATE
        FROM SCP_ANL_SHIPMENT_PLAN_FIX WITH(NOLOCK)
        WHERE DIVISION_ID         = @V_DIVISION_ID
        AND YYYYMMDD BETWEEN @V_PLAN_START_YYYYMMDD AND @V_PLAN_END_YYYYMMDD
        AND LAST_UPDATED_BY       = @UPDATE_NAME
        AND LAST_UPDATE_DATE      = @NOW_DATE

    ------------------------------------------------------------------------
    -- UPDATE SCP_XLS_PSI_GLOBAL
    ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- 52주 구간 : 52주 구간과 52주 이후 구간을 나눠서 넣어야 함
        -- Get Daily SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        INSERT INTO @XLS_PV_READY
        SELECT CAL.TRG_DATE            AS TRG_DATE
              ,AP.DIVISION_ID          AS DIVISION_ID
              ,AP.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,AP.PLAN_TYPE            AS PLAN_TYPE
              ,AP.SEQ                  AS SEQ
              ,AP.OPERATION_GROUP      AS OPERATION_GROUP
              ,AP.SCM_SITE_ID          AS SCM_SITE_ID
              ,AP.ITEM_ID              AS ITEM_ID
              ,AP.LINE_ID              AS LINE_ID
              ,'-'                     AS BOD_ID  
              ,'-'                     AS PROJECT_CODE
              ,CASE WHEN AP.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN AP.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(ISNULL(AP.QTY,0))   AS QTY_SUM
              ,@PLAN_START_YYYYMMDD    AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
                LEFT OUTER JOIN SCP_ANL_PRODUCTION_PLAN AP
                ON  CAL.BASIS_YYYYMMDD = AP.YYYYMMDD
        WHERE   1=1
        AND     AP.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     AP.LAST_UPDATED_BY     = @UPDATE_NAME
        --AND     AP.ATTRIBUTE9          = 'U'
        AND     AP.MEASURE             = 'PROD_PLAN_AMEND'
        AND     AP.QTY                != 0
        GROUP BY CAL.TRG_DATE,AP.DIVISION_ID,AP.PLAN_START_YYYYMMDD,AP.PLAN_TYPE,AP.SEQ,AP.OPERATION_GROUP,AP.SCM_SITE_ID,AP.ITEM_ID,AP.LINE_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM            AS TRG_DATE
              ,AP.DIVISION_ID          AS DIVISION_ID
              ,AP.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,AP.PLAN_TYPE            AS PLAN_TYPE
              ,AP.SEQ                  AS SEQ
              ,AP.OPERATION_GROUP      AS OPERATION_GROUP
              ,AP.SCM_SITE_ID          AS SCM_SITE_ID
              ,AP.ITEM_ID              AS ITEM_ID
              ,AP.LINE_ID              AS LINE_ID
              ,'-'                     AS BOD_ID  
              ,'-'                     AS PROJECT_CODE
              ,CASE WHEN AP.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN AP.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(QTY)                AS QTY_SUM
              ,@PLAN_START_YYYYMMDD    AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN SCP_ANL_PRODUCTION_PLAN AP
                ON  CAL.BASIS_YYYYMMDD = AP.YYYYMMDD
        WHERE   1=1
        AND     AP.LAST_UPDATED_BY     = @UPDATE_NAME
        --AND     AP.ATTRIBUTE9          = 'U'
        AND     AP.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     AP.MEASURE             = 'PROD_PLAN_AMEND'
        AND     AP.QTY                != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,SCM_SITE_ID,ITEM_ID,LINE_ID
        
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_SEMI data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.TRG_DATE             AS TRG_DATE
              ,ASS.DIVISION_ID          AS DIVISION_ID
              ,ASS.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASS.PLAN_TYPE            AS PLAN_TYPE
              ,ASS.SEQ                  AS SEQ
              ,ASS.OPERATION_GROUP      AS OPERATION_GROUP
              ,ASS.FROM_SITE            AS FROM_SITE
              ,ASS.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASS.BOD_ID               AS BOD_ID
              ,'-'                      AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN'         AS MEASURE
              ,SUM(ISNULL(ASS.QTY,0))   AS QTY_SUM
              ,@PLAN_START_YYYYMMDD     AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
                LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI ASS
                ON  CAL.BASIS_YYYYMMDD = ASS.YYYYMMDD
        WHERE   1=1
        AND     ASS.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASS.LAST_UPDATED_BY = @UPDATE_NAME
        --AND     ASS.ATTRIBUTE9      = 'U'
        AND     ASS.MEASURE         = 'SHIP_PLAN_AMEND'
        AND     ASS.QTY            != 0
        GROUP BY CAL.TRG_DATE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,BOD_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM             AS TRG_DATE
              ,ASS.DIVISION_ID          AS DIVISION_ID
              ,ASS.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASS.PLAN_TYPE            AS PLAN_TYPE
              ,ASS.SEQ                  AS SEQ
              ,ASS.OPERATION_GROUP      AS OPERATION_GROUP
              ,ASS.FROM_SITE            AS FROM_SITE
              ,ASS.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASS.BOD_ID               AS BOD_ID
              ,'-'                      AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN'         AS MEASURE
              ,SUM(ASS.QTY)             AS QTY_SUM
              ,@PLAN_START_YYYYMMDD     AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI ASS
                ON  CAL.BASIS_YYYYMMDD = ASS.YYYYMMDD
        WHERE   1=1
        AND     ASS.LAST_UPDATED_BY =@UPDATE_NAME
        --AND     ASS.ATTRIBUTE9 ='U'
        AND     ASS.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASS.MEASURE = 'SHIP_PLAN_AMEND'
        AND     ASS.QTY != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,BOD_ID
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.TRG_DATE             AS TRG_DATE
              ,ASF.DIVISION_ID          AS DIVISION_ID
              ,ASF.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASF.PLAN_TYPE            AS PLAN_TYPE
              ,ASF.SEQ                  AS SEQ
              ,ASF.BIZ_TYPE             AS OPERATION_GROUP
              ,ASF.FROM_SITE            AS FROM_SITE
              ,ASF.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASF.BOD_ID               AS BOD_ID
              ,ASF.PROJECT_CODE         AS PROJECT_CODE
              ,'SHIP_PLAN'              AS MEASURE
              ,SUM(ISNULL(ASF.QTY,0))   AS QTY_SUM
              ,@PLAN_START_YYYYMMDD     AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
                LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_FG ASF
                ON  CAL.BASIS_YYYYMMDD = ASF.YYYYMMDD
        WHERE   1=1
        AND     ASF.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASF.LAST_UPDATED_BY =@UPDATE_NAME
        --AND     ASF.ATTRIBUTE9 ='U'
        AND     ASF.MEASURE = 'SHIP_PLAN_AMEND'
        AND     ASF.QTY != 0
        GROUP BY CAL.TRG_DATE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,BIZ_TYPE,FROM_SITE,ITEM_ID,BOD_ID,ASF.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM             AS TRG_DATE
              ,ASF.DIVISION_ID          AS DIVISION_ID
              ,ASF.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASF.PLAN_TYPE            AS PLAN_TYPE
              ,ASF.SEQ                  AS SEQ
              ,ASF.BIZ_TYPE             AS OPERATION_GROUP
              ,ASF.FROM_SITE            AS FROM_SITE
              ,ASF.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASF.BOD_ID               AS BOD_ID
              ,ASF.PROJECT_CODE         AS PROJECT_CODE
              ,'SHIP_PLAN'              AS MEASURE
              ,SUM(ASF.QTY)             AS QTY_SUM
              ,@PLAN_START_YYYYMMDD     AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_FG ASF
                ON  CAL.BASIS_YYYYMMDD = ASF.YYYYMMDD
        WHERE   1=1
        AND     ASF.LAST_UPDATED_BY =@UPDATE_NAME
        --AND     ASF.ATTRIBUTE9 ='U'
        AND     ASF.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASF.MEASURE = 'SHIP_PLAN_AMEND'
        AND     ASF.QTY != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,BIZ_TYPE,FROM_SITE,ITEM_ID,BOD_ID,ASF.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Daily CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.TRG_DATE                         AS TRG_DATE
              ,CHR.DIVISION_ID                      AS DIVISION_ID
              ,CHR.PLAN_START_YYYYMMDD              AS PLAN_START_YYYYMMDD
              ,CHR.PLAN_TYPE                        AS PLAN_TYPE
              ,CHR.SEQ                              AS SEQ
              ,CHR.OPERATION_GROUP                  AS OPERATION_GROUP
              ,CHR.FROM_SITE                        AS FROM_SITE
              ,PAM.ITEM_ID_ASSY                     AS ITEM_ID
              ,'-'                                  AS LINE_ID
              ,'-'                                  AS BOD_ID
              ,'-'                                  AS PROJECT_CODE
              ,'CELL_CHAR_PLAN'                     AS MEASURE
              ,SUM(CONVERT(NUMERIC(20,10),CHR.QTY)) AS QTY_SUM
              ,@PLAN_START_YYYYMMDD                 AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN(
                            SELECT @V_DIVISION_ID         AS DIVISION_ID
                                  ,@PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD
                                  ,@V_SCP_PLAN_TYPE       AS PLAN_TYPE
                                  ,@V_SCP_PLAN_SEQ        AS SEQ
                                  ,FI.OPERATION_GROUP     AS OPERATION_GROUP
                                  ,OP.SITE_ID             AS FROM_SITE
                                  ,OP.ITEM_ID             AS ITEM_ID
                                  ,OP.GRADE               AS GRADE
                                  ,OP.START_DATE          AS YYYYMMDD
                                  ,OP.OUT_QTY_INT         AS QTY
                            FROM   SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN OP WITH(NOLOCK)
                                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                                    ON  FI.DIVISION_ID = @V_DIVISION_ID
                                    AND FI.ITEM_ID     = OP.ITEM_ID
                            WHERE OP.PLAN_ID = @V_PLAN_ID
                            AND   OP.GRADE IN ('CHAR')
                            ) CHR
                ON  CAL.BASIS_YYYYMMDD = CHR.YYYYMMDD
            INNER JOIN (
                        SELECT DISTINCT ITEM_ID_PROD, ITEM_ID_ASSY
                        FROM  SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
                        WHERE DIVISION_ID = @V_DIVISION_ID
                        AND   CELL_TYPE    = 'CA1'
                        ) PAM
                ON CHR.ITEM_ID = PAM.ITEM_ID_PROD
        WHERE   1=1
        AND     CONVERT(NUMERIC(20,10),CHR.QTY) != 0
        GROUP BY TRG_DATE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,PAM.ITEM_ID_ASSY
        ------------------------------------------------------------------------
        -- Get Weekly CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM                         AS TRG_DATE
              ,CHR.DIVISION_ID                      AS DIVISION_ID
              ,CHR.PLAN_START_YYYYMMDD              AS PLAN_START_YYYYMMDD
              ,CHR.PLAN_TYPE                        AS PLAN_TYPE
              ,CHR.SEQ                              AS SEQ
              ,CHR.OPERATION_GROUP                  AS OPERATION_GROUP
              ,CHR.FROM_SITE                        AS FROM_SITE
              ,PAM.ITEM_ID_ASSY                     AS ITEM_ID
              ,'-'                                  AS LINE_ID
              ,'-'                                  AS BOD_ID
              ,'-'                                  AS PROJECT_CODE
              ,'CELL_CHAR_PLAN'                     AS MEASURE
              ,SUM(CONVERT(NUMERIC(20,10),CHR.QTY)) AS QTY_SUM
              ,@PLAN_START_YYYYMMDD                 AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @MIN_WEEK>0,CAL.ISO_WEEK - @MIN_WEEK,CAL.ISO_WEEK +@WEEKS_IN_YEAR - @MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN(
                            SELECT @V_DIVISION_ID         AS DIVISION_ID
                                  ,@PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD
                                  ,@V_SCP_PLAN_TYPE       AS PLAN_TYPE
                                  ,@V_SCP_PLAN_SEQ        AS SEQ
                                  ,FI.OPERATION_GROUP     AS OPERATION_GROUP
                                  ,OP.SITE_ID             AS FROM_SITE
                                  ,OP.ITEM_ID             AS ITEM_ID
                                  ,OP.GRADE               AS GRADE
                                  ,OP.START_DATE          AS YYYYMMDD
                                  ,OP.OUT_QTY_INT         AS QTY
                            FROM   SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN OP WITH(NOLOCK)
                                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                                    ON  FI.DIVISION_ID = @V_DIVISION_ID
                                    AND FI.ITEM_ID     = OP.ITEM_ID
                            WHERE OP.PLAN_ID = @V_PLAN_ID
                            AND   OP.GRADE IN ( 'CHAR')
                            ) CHR
                ON  CAL.BASIS_YYYYMMDD = CHR.YYYYMMDD
            INNER JOIN (
                        SELECT DISTINCT ITEM_ID_PROD, ITEM_ID_ASSY
                        FROM  SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
                        WHERE DIVISION_ID = @V_DIVISION_ID
                        AND   CELL_TYPE    = 'CA1'
                        ) PAM
                ON CHR.ITEM_ID = PAM.ITEM_ID_PROD
        WHERE   1=1
        AND     CONVERT(NUMERIC(20,10),CHR.QTY) != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,PAM.ITEM_ID_ASSY
        ------------------------------------------------------------------------
        -- 52주 이후 구간 : 52주 구간과 52주 이후 구간을 나눠서 넣어야 함
        -- Get Daily SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        INSERT INTO @XLS_PV_READY
        SELECT CAL.TRG_DATE            AS TRG_DATE
              ,AP.DIVISION_ID          AS DIVISION_ID
              ,AP.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,AP.PLAN_TYPE            AS PLAN_TYPE
              ,AP.SEQ                  AS SEQ
              ,AP.OPERATION_GROUP      AS OPERATION_GROUP
              ,AP.SCM_SITE_ID          AS SCM_SITE_ID
              ,AP.ITEM_ID              AS ITEM_ID
              ,AP.LINE_ID              AS LINE_ID
              ,'-'                     AS BOD_ID  
              ,'-'                     AS PROJECT_CODE
              ,CASE WHEN AP.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN AP.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(ISNULL(AP.QTY,0))   AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
                LEFT OUTER JOIN SCP_ANL_PRODUCTION_PLAN AP
                ON  CAL.BASIS_YYYYMMDD = AP.YYYYMMDD
        WHERE   1=1
        AND     AP.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     AP.LAST_UPDATED_BY     = @UPDATE_NAME
        --AND     AP.ATTRIBUTE9          = 'U'
        AND     AP.MEASURE             = 'PROD_PLAN_AMEND'
        AND     AP.QTY                != 0
        GROUP BY CAL.TRG_DATE,AP.DIVISION_ID,AP.PLAN_START_YYYYMMDD,AP.PLAN_TYPE,AP.SEQ,AP.OPERATION_GROUP,AP.SCM_SITE_ID,AP.ITEM_ID,AP.LINE_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM            AS TRG_DATE
              ,AP.DIVISION_ID          AS DIVISION_ID
              ,AP.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,AP.PLAN_TYPE            AS PLAN_TYPE
              ,AP.SEQ                  AS SEQ
              ,AP.OPERATION_GROUP      AS OPERATION_GROUP
              ,AP.SCM_SITE_ID          AS SCM_SITE_ID
              ,AP.ITEM_ID              AS ITEM_ID
              ,AP.LINE_ID              AS LINE_ID
              ,'-'                     AS BOD_ID  
              ,'-'                     AS PROJECT_CODE
              ,CASE WHEN AP.OPERATION_GROUP = 'A' THEN 'CELL_PROD'
                    WHEN AP.OPERATION_GROUP = 'P' THEN 'PACK_PROD'
                    ELSE NULL
               END AS MEASURE
              ,SUM(QTY)                AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN SCP_ANL_PRODUCTION_PLAN AP
                ON  CAL.BASIS_YYYYMMDD = AP.YYYYMMDD
        WHERE   1=1
        AND     AP.LAST_UPDATED_BY     = @UPDATE_NAME
        --AND     AP.ATTRIBUTE9          = 'U'
        AND     AP.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     AP.MEASURE             = 'PROD_PLAN_AMEND'
        AND     AP.QTY                != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,SCM_SITE_ID,ITEM_ID,LINE_ID
        
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_SEMI data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.TRG_DATE             AS TRG_DATE
              ,ASS.DIVISION_ID          AS DIVISION_ID
              ,ASS.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASS.PLAN_TYPE            AS PLAN_TYPE
              ,ASS.SEQ                  AS SEQ
              ,ASS.OPERATION_GROUP      AS OPERATION_GROUP
              ,ASS.FROM_SITE            AS FROM_SITE
              ,ASS.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASS.BOD_ID               AS BOD_ID
              ,'-'                      AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN'         AS MEASURE
              ,SUM(ISNULL(ASS.QTY,0))   AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
                LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI ASS
                ON  CAL.BASIS_YYYYMMDD = ASS.YYYYMMDD
        WHERE   1=1
        AND     ASS.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASS.LAST_UPDATED_BY = @UPDATE_NAME
        --AND     ASS.ATTRIBUTE9      = 'U'
        AND     ASS.MEASURE         = 'SHIP_PLAN_AMEND'
        AND     ASS.QTY            != 0
        GROUP BY CAL.TRG_DATE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,BOD_ID
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM             AS TRG_DATE
              ,ASS.DIVISION_ID          AS DIVISION_ID
              ,ASS.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASS.PLAN_TYPE            AS PLAN_TYPE
              ,ASS.SEQ                  AS SEQ
              ,ASS.OPERATION_GROUP      AS OPERATION_GROUP
              ,ASS.FROM_SITE            AS FROM_SITE
              ,ASS.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASS.BOD_ID               AS BOD_ID
              ,'-'                      AS PROJECT_CODE
              ,'SEMI_SHIP_PLAN'         AS MEASURE
              ,SUM(ASS.QTY)             AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_SEMI ASS
                ON  CAL.BASIS_YYYYMMDD = ASS.YYYYMMDD
        WHERE   1=1
        AND     ASS.LAST_UPDATED_BY =@UPDATE_NAME
        --AND     ASS.ATTRIBUTE9 ='U'
        AND     ASS.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASS.MEASURE = 'SHIP_PLAN_AMEND'
        AND     ASS.QTY != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,ITEM_ID,BOD_ID
        ------------------------------------------------------------------------
        -- Get Daily SCP_ANL_SHIPMENT_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.TRG_DATE             AS TRG_DATE
              ,ASF.DIVISION_ID          AS DIVISION_ID
              ,ASF.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASF.PLAN_TYPE            AS PLAN_TYPE
              ,ASF.SEQ                  AS SEQ
              ,ASF.BIZ_TYPE             AS OPERATION_GROUP
              ,ASF.FROM_SITE            AS FROM_SITE
              ,ASF.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASF.BOD_ID               AS BOD_ID
              ,ASF.PROJECT_CODE         AS PROJECT_CODE
              ,'SHIP_PLAN'              AS MEASURE
              ,SUM(ISNULL(ASF.QTY,0))   AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
                LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_FG ASF
                ON  CAL.BASIS_YYYYMMDD = ASF.YYYYMMDD
        WHERE   1=1
        AND     ASF.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASF.LAST_UPDATED_BY =@UPDATE_NAME
        --AND     ASF.ATTRIBUTE9 ='U'
        AND     ASF.MEASURE = 'SHIP_PLAN_AMEND'
        AND     ASF.QTY != 0
        GROUP BY CAL.TRG_DATE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,BIZ_TYPE,FROM_SITE,ITEM_ID,BOD_ID,ASF.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Weekly SCP_ANL_PRODUCTION_PLAN_FG data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM             AS TRG_DATE
              ,ASF.DIVISION_ID          AS DIVISION_ID
              ,ASF.PLAN_START_YYYYMMDD  AS PLAN_START_YYYYMMDD
              ,ASF.PLAN_TYPE            AS PLAN_TYPE
              ,ASF.SEQ                  AS SEQ
              ,ASF.BIZ_TYPE             AS OPERATION_GROUP
              ,ASF.FROM_SITE            AS FROM_SITE
              ,ASF.ITEM_ID              AS ITEM_ID
              ,'-'                      AS LINE_ID
              ,ASF.BOD_ID               AS BOD_ID
              ,ASF.PROJECT_CODE         AS PROJECT_CODE
              ,'SHIP_PLAN'              AS MEASURE
              ,SUM(ASF.QTY)             AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN SCP_ANL_SHIPMENT_PLAN_FG ASF
                ON  CAL.BASIS_YYYYMMDD = ASF.YYYYMMDD
        WHERE   1=1
        AND     ASF.LAST_UPDATED_BY =@UPDATE_NAME
        --AND     ASF.ATTRIBUTE9 ='U'
        AND     ASF.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     ASF.MEASURE = 'SHIP_PLAN_AMEND'
        AND     ASF.QTY != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,BIZ_TYPE,FROM_SITE,ITEM_ID,BOD_ID,ASF.PROJECT_CODE
        ------------------------------------------------------------------------
        -- Get Daily CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.TRG_DATE                         AS TRG_DATE
              ,CHR.DIVISION_ID                      AS DIVISION_ID
              ,CHR.PLAN_START_YYYYMMDD              AS PLAN_START_YYYYMMDD
              ,CHR.PLAN_TYPE                        AS PLAN_TYPE
              ,CHR.SEQ                              AS SEQ
              ,CHR.OPERATION_GROUP                  AS OPERATION_GROUP
              ,CHR.FROM_SITE                        AS FROM_SITE
              ,PAM.ITEM_ID_ASSY                     AS ITEM_ID
              ,'-'                                  AS LINE_ID
              ,'-'                                  AS BOD_ID
              ,'-'                                  AS PROJECT_CODE
              ,'CELL_CHAR_PLAN'                     AS MEASURE
              ,SUM(CONVERT(NUMERIC(20,10),CHR.QTY)) AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD             AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,'QTY'+FORMAT(ROW_NUMBER() OVER(ORDER BY CAL.BASIS_YYYYMMDD),'000') AS TRG_DATE
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN(
                            SELECT @V_DIVISION_ID         AS DIVISION_ID
                                  ,@PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD
                                  ,@V_SCP_PLAN_TYPE       AS PLAN_TYPE
                                  ,@V_SCP_PLAN_SEQ        AS SEQ
                                  ,FI.OPERATION_GROUP     AS OPERATION_GROUP
                                  ,OP.SITE_ID             AS FROM_SITE
                                  ,OP.ITEM_ID             AS ITEM_ID
                                  ,OP.GRADE               AS GRADE
                                  ,OP.START_DATE          AS YYYYMMDD
                                  ,OP.OUT_QTY_INT         AS QTY
                            FROM   SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN OP WITH(NOLOCK)
                                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                                    ON  FI.DIVISION_ID = @V_DIVISION_ID
                                    AND FI.ITEM_ID     = OP.ITEM_ID
                            WHERE OP.PLAN_ID = @V_PLAN_ID
                            AND   OP.GRADE IN ('CHAR')
                            ) CHR
                ON  CAL.BASIS_YYYYMMDD = CHR.YYYYMMDD
            INNER JOIN (
                        SELECT DISTINCT ITEM_ID_PROD, ITEM_ID_ASSY
                        FROM  SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
                        WHERE DIVISION_ID = @V_DIVISION_ID
                        AND   CELL_TYPE    = 'CA1'
                        ) PAM
                ON CHR.ITEM_ID = PAM.ITEM_ID_PROD
        WHERE   1=1
        AND     CONVERT(NUMERIC(20,10),CHR.QTY) != 0
        GROUP BY TRG_DATE,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,PAM.ITEM_ID_ASSY
        ------------------------------------------------------------------------
        -- Get Weekly CHAR data
        ------------------------------------------------------------------------
        UNION ALL
        SELECT CAL.WEEK_NUM                         AS TRG_DATE
              ,CHR.DIVISION_ID                      AS DIVISION_ID
              ,CHR.PLAN_START_YYYYMMDD              AS PLAN_START_YYYYMMDD
              ,CHR.PLAN_TYPE                        AS PLAN_TYPE
              ,CHR.SEQ                              AS SEQ
              ,CHR.OPERATION_GROUP                  AS OPERATION_GROUP
              ,CHR.FROM_SITE                        AS FROM_SITE
              ,PAM.ITEM_ID_ASSY                     AS ITEM_ID
              ,'-'                                  AS LINE_ID
              ,'-'                                  AS BOD_ID
              ,'-'                                  AS PROJECT_CODE
              ,'CELL_CHAR_PLAN'                     AS MEASURE
              ,SUM(CONVERT(NUMERIC(20,10),CHR.QTY)) AS QTY_SUM
              ,@2ND_PLAN_START_YYYYMMDD             AS CREATE_FROM_YYYYMMDD
        FROM(
            SELECT  'WQTY'+FORMAT(IIF(CAL.ISO_WEEK - @2ND_MIN_WEEK>0,CAL.ISO_WEEK - @2ND_MIN_WEEK,CAL.ISO_WEEK +@2ND_WEEKS_IN_YEAR - @2ND_MIN_WEEK),'00') AS WEEK_NUM
                   ,CAL.BASIS_YYYYMMDD
            FROM    SCM_SYS_CALENDAR_M CAL WITH(NOLOCK)
            WHERE   CAL.BASIS_YYYYMMDD BETWEEN @2ND_PLAN_START_YYYYMMDD AND CONVERT(NVARCHAR(8),DATEADD(DAY,363,@2ND_PLAN_START_YYYYMMDD),112)
            ) CAL    
            LEFT OUTER JOIN(
                            SELECT @V_DIVISION_ID         AS DIVISION_ID
                                  ,@PLAN_START_YYYYMMDD   AS PLAN_START_YYYYMMDD
                                  ,@V_SCP_PLAN_TYPE       AS PLAN_TYPE
                                  ,@V_SCP_PLAN_SEQ        AS SEQ
                                  ,FI.OPERATION_GROUP     AS OPERATION_GROUP
                                  ,OP.SITE_ID             AS FROM_SITE
                                  ,OP.ITEM_ID             AS ITEM_ID
                                  ,OP.GRADE               AS GRADE
                                  ,OP.START_DATE          AS YYYYMMDD
                                  ,OP.OUT_QTY_INT         AS QTY
                            FROM   SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN OP WITH(NOLOCK)
                                INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK) 
                                    ON  FI.DIVISION_ID = @V_DIVISION_ID
                                    AND FI.ITEM_ID     = OP.ITEM_ID
                            WHERE OP.PLAN_ID = @V_PLAN_ID
                            AND   OP.GRADE IN ( 'CHAR')
                            ) CHR
                ON  CAL.BASIS_YYYYMMDD = CHR.YYYYMMDD
            INNER JOIN (
                        SELECT DISTINCT ITEM_ID_PROD, ITEM_ID_ASSY
                        FROM  SCP_MST_CELL_PROD_ASSY_MAP WITH(NOLOCK)
                        WHERE DIVISION_ID = @V_DIVISION_ID
                        AND   CELL_TYPE    = 'CA1'
                        ) PAM
                ON CHR.ITEM_ID = PAM.ITEM_ID_PROD
        WHERE   1=1
        AND     CONVERT(NUMERIC(20,10),CHR.QTY) != 0
        GROUP BY WEEK_NUM,DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_GROUP,FROM_SITE,PAM.ITEM_ID_ASSY


        ------------------------------------------------------------------------
        -- INSERT PIVOT TABLE
        ------------------------------------------------------------------------
        INSERT INTO @XLS_PV_TABLE
        SELECT  DIVISION_ID
               ,PLAN_START_YYYYMMDD
               ,PLAN_TYPE
               ,SEQ
               ,OPERATION_GROUP
               ,FROM_SITE
               ,ITEM_ID
               ,LINE_ID
               ,BOD_ID
               ,PROJECT_CODE
               ,MEASURE
               ,CREATE_FROM_YYYYMMDD
               ,ISNULL([QTY001],0) AS QTY001,ISNULL([QTY002],0) AS QTY002,ISNULL([QTY003],0) AS QTY003,ISNULL([QTY004],0) AS QTY004,ISNULL([QTY005],0) AS QTY005,ISNULL([QTY006],0) AS QTY006,ISNULL([QTY007],0) AS QTY007,ISNULL([QTY008],0) AS QTY008,ISNULL([QTY009],0) AS QTY009,ISNULL([QTY010],0) AS QTY010
               ,ISNULL([QTY011],0) AS QTY011,ISNULL([QTY012],0) AS QTY012,ISNULL([QTY013],0) AS QTY013,ISNULL([QTY014],0) AS QTY014,ISNULL([QTY015],0) AS QTY015,ISNULL([QTY016],0) AS QTY016,ISNULL([QTY017],0) AS QTY017,ISNULL([QTY018],0) AS QTY018,ISNULL([QTY019],0) AS QTY019,ISNULL([QTY020],0) AS QTY020
               ,ISNULL([QTY021],0) AS QTY021,ISNULL([QTY022],0) AS QTY022,ISNULL([QTY023],0) AS QTY023,ISNULL([QTY024],0) AS QTY024,ISNULL([QTY025],0) AS QTY025,ISNULL([QTY026],0) AS QTY026,ISNULL([QTY027],0) AS QTY027,ISNULL([QTY028],0) AS QTY028,ISNULL([QTY029],0) AS QTY029,ISNULL([QTY030],0) AS QTY030
               ,ISNULL([QTY031],0) AS QTY031,ISNULL([QTY032],0) AS QTY032,ISNULL([QTY033],0) AS QTY033,ISNULL([QTY034],0) AS QTY034,ISNULL([QTY035],0) AS QTY035,ISNULL([QTY036],0) AS QTY036,ISNULL([QTY037],0) AS QTY037,ISNULL([QTY038],0) AS QTY038,ISNULL([QTY039],0) AS QTY039,ISNULL([QTY040],0) AS QTY040
               ,ISNULL([QTY041],0) AS QTY041,ISNULL([QTY042],0) AS QTY042,ISNULL([QTY043],0) AS QTY043,ISNULL([QTY044],0) AS QTY044,ISNULL([QTY045],0) AS QTY045,ISNULL([QTY046],0) AS QTY046,ISNULL([QTY047],0) AS QTY047,ISNULL([QTY048],0) AS QTY048,ISNULL([QTY049],0) AS QTY049,ISNULL([QTY050],0) AS QTY050
               ,ISNULL([QTY051],0) AS QTY051,ISNULL([QTY052],0) AS QTY052,ISNULL([QTY053],0) AS QTY053,ISNULL([QTY054],0) AS QTY054,ISNULL([QTY055],0) AS QTY055,ISNULL([QTY056],0) AS QTY056,ISNULL([QTY057],0) AS QTY057,ISNULL([QTY058],0) AS QTY058,ISNULL([QTY059],0) AS QTY059,ISNULL([QTY060],0) AS QTY060
               ,ISNULL([QTY061],0) AS QTY061,ISNULL([QTY062],0) AS QTY062,ISNULL([QTY063],0) AS QTY063,ISNULL([QTY064],0) AS QTY064,ISNULL([QTY065],0) AS QTY065,ISNULL([QTY066],0) AS QTY066,ISNULL([QTY067],0) AS QTY067,ISNULL([QTY068],0) AS QTY068,ISNULL([QTY069],0) AS QTY069,ISNULL([QTY070],0) AS QTY070
               ,ISNULL([QTY071],0) AS QTY071,ISNULL([QTY072],0) AS QTY072,ISNULL([QTY073],0) AS QTY073,ISNULL([QTY074],0) AS QTY074,ISNULL([QTY075],0) AS QTY075,ISNULL([QTY076],0) AS QTY076,ISNULL([QTY077],0) AS QTY077,ISNULL([QTY078],0) AS QTY078,ISNULL([QTY079],0) AS QTY079,ISNULL([QTY080],0) AS QTY080
               ,ISNULL([QTY081],0) AS QTY081,ISNULL([QTY082],0) AS QTY082,ISNULL([QTY083],0) AS QTY083,ISNULL([QTY084],0) AS QTY084,ISNULL([QTY085],0) AS QTY085,ISNULL([QTY086],0) AS QTY086,ISNULL([QTY087],0) AS QTY087,ISNULL([QTY088],0) AS QTY088,ISNULL([QTY089],0) AS QTY089,ISNULL([QTY090],0) AS QTY090
               ,ISNULL([QTY091],0) AS QTY091,ISNULL([QTY092],0) AS QTY092,ISNULL([QTY093],0) AS QTY093,ISNULL([QTY094],0) AS QTY094,ISNULL([QTY095],0) AS QTY095,ISNULL([QTY096],0) AS QTY096,ISNULL([QTY097],0) AS QTY097,ISNULL([QTY098],0) AS QTY098,ISNULL([QTY099],0) AS QTY099,ISNULL([QTY100],0) AS QTY100
               ,ISNULL([QTY101],0) AS QTY101,ISNULL([QTY102],0) AS QTY102,ISNULL([QTY103],0) AS QTY103,ISNULL([QTY104],0) AS QTY104,ISNULL([QTY105],0) AS QTY105,ISNULL([QTY106],0) AS QTY106,ISNULL([QTY107],0) AS QTY107,ISNULL([QTY108],0) AS QTY108,ISNULL([QTY109],0) AS QTY109,ISNULL([QTY110],0) AS QTY110
               ,ISNULL([QTY111],0) AS QTY111,ISNULL([QTY112],0) AS QTY112,ISNULL([QTY113],0) AS QTY113,ISNULL([QTY114],0) AS QTY114,ISNULL([QTY115],0) AS QTY115,ISNULL([QTY116],0) AS QTY116,ISNULL([QTY117],0) AS QTY117,ISNULL([QTY118],0) AS QTY118,ISNULL([QTY119],0) AS QTY119,ISNULL([QTY120],0) AS QTY120
               ,ISNULL([QTY121],0) AS QTY121,ISNULL([QTY122],0) AS QTY122,ISNULL([QTY123],0) AS QTY123,ISNULL([QTY124],0) AS QTY124,ISNULL([QTY125],0) AS QTY125,ISNULL([QTY126],0) AS QTY126,ISNULL([QTY127],0) AS QTY127,ISNULL([QTY128],0) AS QTY128,ISNULL([QTY129],0) AS QTY129,ISNULL([QTY130],0) AS QTY130
               ,ISNULL([QTY131],0) AS QTY131,ISNULL([QTY132],0) AS QTY132,ISNULL([QTY133],0) AS QTY133,ISNULL([QTY134],0) AS QTY134,ISNULL([QTY135],0) AS QTY135,ISNULL([QTY136],0) AS QTY136,ISNULL([QTY137],0) AS QTY137,ISNULL([QTY138],0) AS QTY138,ISNULL([QTY139],0) AS QTY139,ISNULL([QTY140],0) AS QTY140
               ,ISNULL([QTY141],0) AS QTY141,ISNULL([QTY142],0) AS QTY142,ISNULL([QTY143],0) AS QTY143,ISNULL([QTY144],0) AS QTY144,ISNULL([QTY145],0) AS QTY145,ISNULL([QTY146],0) AS QTY146,ISNULL([QTY147],0) AS QTY147,ISNULL([QTY148],0) AS QTY148,ISNULL([QTY149],0) AS QTY149,ISNULL([QTY150],0) AS QTY150
               ,ISNULL([QTY151],0) AS QTY151,ISNULL([QTY152],0) AS QTY152,ISNULL([QTY153],0) AS QTY153,ISNULL([QTY154],0) AS QTY154,ISNULL([QTY155],0) AS QTY155,ISNULL([QTY156],0) AS QTY156,ISNULL([QTY157],0) AS QTY157,ISNULL([QTY158],0) AS QTY158,ISNULL([QTY159],0) AS QTY159,ISNULL([QTY160],0) AS QTY160
               ,ISNULL([QTY161],0) AS QTY161,ISNULL([QTY162],0) AS QTY162,ISNULL([QTY163],0) AS QTY163,ISNULL([QTY164],0) AS QTY164,ISNULL([QTY165],0) AS QTY165,ISNULL([QTY166],0) AS QTY166,ISNULL([QTY167],0) AS QTY167,ISNULL([QTY168],0) AS QTY168,ISNULL([QTY169],0) AS QTY169,ISNULL([QTY170],0) AS QTY170
               ,ISNULL([QTY171],0) AS QTY171,ISNULL([QTY172],0) AS QTY172,ISNULL([QTY173],0) AS QTY173,ISNULL([QTY174],0) AS QTY174,ISNULL([QTY175],0) AS QTY175,ISNULL([QTY176],0) AS QTY176,ISNULL([QTY177],0) AS QTY177,ISNULL([QTY178],0) AS QTY178,ISNULL([QTY179],0) AS QTY179,ISNULL([QTY180],0) AS QTY180
               ,ISNULL([QTY181],0) AS QTY181,ISNULL([QTY182],0) AS QTY182,ISNULL([QTY183],0) AS QTY183,ISNULL([QTY184],0) AS QTY184,ISNULL([QTY185],0) AS QTY185,ISNULL([QTY186],0) AS QTY186,ISNULL([QTY187],0) AS QTY187,ISNULL([QTY188],0) AS QTY188,ISNULL([QTY189],0) AS QTY189,ISNULL([QTY190],0) AS QTY190
               ,ISNULL([QTY191],0) AS QTY191,ISNULL([QTY192],0) AS QTY192,ISNULL([QTY193],0) AS QTY193,ISNULL([QTY194],0) AS QTY194,ISNULL([QTY195],0) AS QTY195,ISNULL([QTY196],0) AS QTY196,ISNULL([QTY197],0) AS QTY197,ISNULL([QTY198],0) AS QTY198,ISNULL([QTY199],0) AS QTY199,ISNULL([QTY200],0) AS QTY200
               ,ISNULL([QTY201],0) AS QTY201,ISNULL([QTY202],0) AS QTY202,ISNULL([QTY203],0) AS QTY203,ISNULL([QTY204],0) AS QTY204,ISNULL([QTY205],0) AS QTY205,ISNULL([QTY206],0) AS QTY206,ISNULL([QTY207],0) AS QTY207,ISNULL([QTY208],0) AS QTY208,ISNULL([QTY209],0) AS QTY209,ISNULL([QTY210],0) AS QTY210
               ,ISNULL([QTY211],0) AS QTY211,ISNULL([QTY212],0) AS QTY212,ISNULL([QTY213],0) AS QTY213,ISNULL([QTY214],0) AS QTY214,ISNULL([QTY215],0) AS QTY215,ISNULL([QTY216],0) AS QTY216,ISNULL([QTY217],0) AS QTY217,ISNULL([QTY218],0) AS QTY218,ISNULL([QTY219],0) AS QTY219,ISNULL([QTY220],0) AS QTY220
               ,ISNULL([QTY221],0) AS QTY221,ISNULL([QTY222],0) AS QTY222,ISNULL([QTY223],0) AS QTY223,ISNULL([QTY224],0) AS QTY224,ISNULL([QTY225],0) AS QTY225,ISNULL([QTY226],0) AS QTY226,ISNULL([QTY227],0) AS QTY227,ISNULL([QTY228],0) AS QTY228,ISNULL([QTY229],0) AS QTY229,ISNULL([QTY230],0) AS QTY230
               ,ISNULL([QTY231],0) AS QTY231,ISNULL([QTY232],0) AS QTY232,ISNULL([QTY233],0) AS QTY233,ISNULL([QTY234],0) AS QTY234,ISNULL([QTY235],0) AS QTY235,ISNULL([QTY236],0) AS QTY236,ISNULL([QTY237],0) AS QTY237,ISNULL([QTY238],0) AS QTY238,ISNULL([QTY239],0) AS QTY239,ISNULL([QTY240],0) AS QTY240
               ,ISNULL([QTY241],0) AS QTY241,ISNULL([QTY242],0) AS QTY242,ISNULL([QTY243],0) AS QTY243,ISNULL([QTY244],0) AS QTY244,ISNULL([QTY245],0) AS QTY245,ISNULL([QTY246],0) AS QTY246,ISNULL([QTY247],0) AS QTY247,ISNULL([QTY248],0) AS QTY248,ISNULL([QTY249],0) AS QTY249,ISNULL([QTY250],0) AS QTY250
               ,ISNULL([QTY251],0) AS QTY251,ISNULL([QTY252],0) AS QTY252,ISNULL([QTY253],0) AS QTY253,ISNULL([QTY254],0) AS QTY254,ISNULL([QTY255],0) AS QTY255,ISNULL([QTY256],0) AS QTY256,ISNULL([QTY257],0) AS QTY257,ISNULL([QTY258],0) AS QTY258,ISNULL([QTY259],0) AS QTY259,ISNULL([QTY260],0) AS QTY260
               ,ISNULL([QTY261],0) AS QTY261,ISNULL([QTY262],0) AS QTY262,ISNULL([QTY263],0) AS QTY263,ISNULL([QTY264],0) AS QTY264,ISNULL([QTY265],0) AS QTY265,ISNULL([QTY266],0) AS QTY266,ISNULL([QTY267],0) AS QTY267,ISNULL([QTY268],0) AS QTY268,ISNULL([QTY269],0) AS QTY269,ISNULL([QTY270],0) AS QTY270
               ,ISNULL([QTY271],0) AS QTY271,ISNULL([QTY272],0) AS QTY272,ISNULL([QTY273],0) AS QTY273,ISNULL([QTY274],0) AS QTY274,ISNULL([QTY275],0) AS QTY275,ISNULL([QTY276],0) AS QTY276,ISNULL([QTY277],0) AS QTY277,ISNULL([QTY278],0) AS QTY278,ISNULL([QTY279],0) AS QTY279,ISNULL([QTY280],0) AS QTY280
               ,ISNULL([QTY281],0) AS QTY281,ISNULL([QTY282],0) AS QTY282,ISNULL([QTY283],0) AS QTY283,ISNULL([QTY284],0) AS QTY284,ISNULL([QTY285],0) AS QTY285,ISNULL([QTY286],0) AS QTY286,ISNULL([QTY287],0) AS QTY287,ISNULL([QTY288],0) AS QTY288,ISNULL([QTY289],0) AS QTY289,ISNULL([QTY290],0) AS QTY290
               ,ISNULL([QTY291],0) AS QTY291,ISNULL([QTY292],0) AS QTY292,ISNULL([QTY293],0) AS QTY293,ISNULL([QTY294],0) AS QTY294,ISNULL([QTY295],0) AS QTY295,ISNULL([QTY296],0) AS QTY296,ISNULL([QTY297],0) AS QTY297,ISNULL([QTY298],0) AS QTY298,ISNULL([QTY299],0) AS QTY299,ISNULL([QTY300],0) AS QTY300
               ,ISNULL([QTY301],0) AS QTY301,ISNULL([QTY302],0) AS QTY302,ISNULL([QTY303],0) AS QTY303,ISNULL([QTY304],0) AS QTY304,ISNULL([QTY305],0) AS QTY305,ISNULL([QTY306],0) AS QTY306,ISNULL([QTY307],0) AS QTY307,ISNULL([QTY308],0) AS QTY308,ISNULL([QTY309],0) AS QTY309,ISNULL([QTY310],0) AS QTY310
               ,ISNULL([QTY311],0) AS QTY311,ISNULL([QTY312],0) AS QTY312,ISNULL([QTY313],0) AS QTY313,ISNULL([QTY314],0) AS QTY314,ISNULL([QTY315],0) AS QTY315,ISNULL([QTY316],0) AS QTY316,ISNULL([QTY317],0) AS QTY317,ISNULL([QTY318],0) AS QTY318,ISNULL([QTY319],0) AS QTY319,ISNULL([QTY320],0) AS QTY320
               ,ISNULL([QTY321],0) AS QTY321,ISNULL([QTY322],0) AS QTY322,ISNULL([QTY323],0) AS QTY323,ISNULL([QTY324],0) AS QTY324,ISNULL([QTY325],0) AS QTY325,ISNULL([QTY326],0) AS QTY326,ISNULL([QTY327],0) AS QTY327,ISNULL([QTY328],0) AS QTY328,ISNULL([QTY329],0) AS QTY329,ISNULL([QTY330],0) AS QTY330
               ,ISNULL([QTY331],0) AS QTY331,ISNULL([QTY332],0) AS QTY332,ISNULL([QTY333],0) AS QTY333,ISNULL([QTY334],0) AS QTY334,ISNULL([QTY335],0) AS QTY335,ISNULL([QTY336],0) AS QTY336,ISNULL([QTY337],0) AS QTY337,ISNULL([QTY338],0) AS QTY338,ISNULL([QTY339],0) AS QTY339,ISNULL([QTY340],0) AS QTY340
               ,ISNULL([QTY341],0) AS QTY341,ISNULL([QTY342],0) AS QTY342,ISNULL([QTY343],0) AS QTY343,ISNULL([QTY344],0) AS QTY344,ISNULL([QTY345],0) AS QTY345,ISNULL([QTY346],0) AS QTY346,ISNULL([QTY347],0) AS QTY347,ISNULL([QTY348],0) AS QTY348,ISNULL([QTY349],0) AS QTY349,ISNULL([QTY350],0) AS QTY350
               ,ISNULL([QTY351],0) AS QTY351,ISNULL([QTY352],0) AS QTY352,ISNULL([QTY353],0) AS QTY353,ISNULL([QTY354],0) AS QTY354,ISNULL([QTY355],0) AS QTY355,ISNULL([QTY356],0) AS QTY356,ISNULL([QTY357],0) AS QTY357,ISNULL([QTY358],0) AS QTY358,ISNULL([QTY359],0) AS QTY359,ISNULL([QTY360],0) AS QTY360
               ,ISNULL([QTY361],0) AS QTY361,ISNULL([QTY362],0) AS QTY362,ISNULL([QTY363],0) AS QTY363,ISNULL([QTY364],0) AS QTY364
               ,ISNULL([WQTY01],0) AS WQTY01 ,ISNULL([WQTY02],0) AS WQTY02 ,ISNULL([WQTY03],0) AS WQTY03 ,ISNULL([WQTY04],0) AS WQTY04,ISNULL([WQTY05],0) AS WQTY05,ISNULL([WQTY06],0) AS WQTY06,ISNULL([WQTY07],0) AS WQTY07,ISNULL([WQTY08],0) AS WQTY08,ISNULL([WQTY09],0) AS WQTY09,ISNULL([WQTY10],0) AS WQTY10
               ,ISNULL([WQTY11],0) AS WQTY11 ,ISNULL([WQTY12],0) AS WQTY12 ,ISNULL([WQTY13],0) AS WQTY13 ,ISNULL([WQTY14],0) AS WQTY14,ISNULL([WQTY15],0) AS WQTY15,ISNULL([WQTY16],0) AS WQTY16,ISNULL([WQTY17],0) AS WQTY17,ISNULL([WQTY18],0) AS WQTY18,ISNULL([WQTY19],0) AS WQTY19,ISNULL([WQTY20],0) AS WQTY20
               ,ISNULL([WQTY21],0) AS WQTY21 ,ISNULL([WQTY22],0) AS WQTY22 ,ISNULL([WQTY23],0) AS WQTY23 ,ISNULL([WQTY24],0) AS WQTY24,ISNULL([WQTY25],0) AS WQTY25,ISNULL([WQTY26],0) AS WQTY26,ISNULL([WQTY27],0) AS WQTY27,ISNULL([WQTY28],0) AS WQTY28,ISNULL([WQTY29],0) AS WQTY29,ISNULL([WQTY30],0) AS WQTY30
               ,ISNULL([WQTY31],0) AS WQTY31 ,ISNULL([WQTY32],0) AS WQTY32 ,ISNULL([WQTY33],0) AS WQTY33 ,ISNULL([WQTY34],0) AS WQTY34,ISNULL([WQTY35],0) AS WQTY35,ISNULL([WQTY36],0) AS WQTY36,ISNULL([WQTY37],0) AS WQTY37,ISNULL([WQTY38],0) AS WQTY38,ISNULL([WQTY39],0) AS WQTY39,ISNULL([WQTY40],0) AS WQTY40
               ,ISNULL([WQTY41],0) AS WQTY41 ,ISNULL([WQTY42],0) AS WQTY42 ,ISNULL([WQTY43],0) AS WQTY43 ,ISNULL([WQTY44],0) AS WQTY44,ISNULL([WQTY45],0) AS WQTY45,ISNULL([WQTY46],0) AS WQTY46,ISNULL([WQTY47],0) AS WQTY47,ISNULL([WQTY48],0) AS WQTY48,ISNULL([WQTY49],0) AS WQTY49,ISNULL([WQTY50],0) AS WQTY50
               ,ISNULL([WQTY51],0) AS WQTY51 ,ISNULL([WQTY52],0) AS WQTY52 
        FROM @XLS_PV_READY AS XLS
        PIVOT
        (
        SUM(QTY_SUM) 
        FOR TRG_DATE IN ([QTY001],[QTY002],[QTY003],[QTY004],[QTY005],[QTY006],[QTY007],[QTY008],[QTY009],[QTY010],[QTY011],[QTY012],[QTY013],[QTY014],[QTY015],[QTY016],[QTY017],[QTY018],[QTY019],[QTY020]
                        ,[QTY021],[QTY022],[QTY023],[QTY024],[QTY025],[QTY026],[QTY027],[QTY028],[QTY029],[QTY030],[QTY031],[QTY032],[QTY033],[QTY034],[QTY035],[QTY036],[QTY037],[QTY038],[QTY039],[QTY040]
                        ,[QTY041],[QTY042],[QTY043],[QTY044],[QTY045],[QTY046],[QTY047],[QTY048],[QTY049],[QTY050],[QTY051],[QTY052],[QTY053],[QTY054],[QTY055],[QTY056],[QTY057],[QTY058],[QTY059],[QTY060]
                        ,[QTY061],[QTY062],[QTY063],[QTY064],[QTY065],[QTY066],[QTY067],[QTY068],[QTY069],[QTY070],[QTY071],[QTY072],[QTY073],[QTY074],[QTY075],[QTY076],[QTY077],[QTY078],[QTY079],[QTY080]
                        ,[QTY081],[QTY082],[QTY083],[QTY084],[QTY085],[QTY086],[QTY087],[QTY088],[QTY089],[QTY090],[QTY091],[QTY092],[QTY093],[QTY094],[QTY095],[QTY096],[QTY097],[QTY098],[QTY099],[QTY100]
                        ,[QTY101],[QTY102],[QTY103],[QTY104],[QTY105],[QTY106],[QTY107],[QTY108],[QTY109],[QTY110],[QTY111],[QTY112],[QTY113],[QTY114],[QTY115],[QTY116],[QTY117],[QTY118],[QTY119],[QTY120]
                        ,[QTY121],[QTY122],[QTY123],[QTY124],[QTY125],[QTY126],[QTY127],[QTY128],[QTY129],[QTY130],[QTY131],[QTY132],[QTY133],[QTY134],[QTY135],[QTY136],[QTY137],[QTY138],[QTY139],[QTY140]
                        ,[QTY141],[QTY142],[QTY143],[QTY144],[QTY145],[QTY146],[QTY147],[QTY148],[QTY149],[QTY150],[QTY151],[QTY152],[QTY153],[QTY154],[QTY155],[QTY156],[QTY157],[QTY158],[QTY159],[QTY160]
                        ,[QTY161],[QTY162],[QTY163],[QTY164],[QTY165],[QTY166],[QTY167],[QTY168],[QTY169],[QTY170],[QTY171],[QTY172],[QTY173],[QTY174],[QTY175],[QTY176],[QTY177],[QTY178],[QTY179],[QTY180]
                        ,[QTY181],[QTY182],[QTY183],[QTY184],[QTY185],[QTY186],[QTY187],[QTY188],[QTY189],[QTY190],[QTY191],[QTY192],[QTY193],[QTY194],[QTY195],[QTY196],[QTY197],[QTY198],[QTY199],[QTY200]
                        ,[QTY201],[QTY202],[QTY203],[QTY204],[QTY205],[QTY206],[QTY207],[QTY208],[QTY209],[QTY210],[QTY211],[QTY212],[QTY213],[QTY214],[QTY215],[QTY216],[QTY217],[QTY218],[QTY219],[QTY220]
                        ,[QTY221],[QTY222],[QTY223],[QTY224],[QTY225],[QTY226],[QTY227],[QTY228],[QTY229],[QTY230],[QTY231],[QTY232],[QTY233],[QTY234],[QTY235],[QTY236],[QTY237],[QTY238],[QTY239],[QTY240]
                        ,[QTY241],[QTY242],[QTY243],[QTY244],[QTY245],[QTY246],[QTY247],[QTY248],[QTY249],[QTY250],[QTY251],[QTY252],[QTY253],[QTY254],[QTY255],[QTY256],[QTY257],[QTY258],[QTY259],[QTY260]
                        ,[QTY261],[QTY262],[QTY263],[QTY264],[QTY265],[QTY266],[QTY267],[QTY268],[QTY269],[QTY270],[QTY271],[QTY272],[QTY273],[QTY274],[QTY275],[QTY276],[QTY277],[QTY278],[QTY279],[QTY280]
                        ,[QTY281],[QTY282],[QTY283],[QTY284],[QTY285],[QTY286],[QTY287],[QTY288],[QTY289],[QTY290],[QTY291],[QTY292],[QTY293],[QTY294],[QTY295],[QTY296],[QTY297],[QTY298],[QTY299],[QTY300]
                        ,[QTY301],[QTY302],[QTY303],[QTY304],[QTY305],[QTY306],[QTY307],[QTY308],[QTY309],[QTY310],[QTY311],[QTY312],[QTY313],[QTY314],[QTY315],[QTY316],[QTY317],[QTY318],[QTY319],[QTY320]
                        ,[QTY321],[QTY322],[QTY323],[QTY324],[QTY325],[QTY326],[QTY327],[QTY328],[QTY329],[QTY330],[QTY331],[QTY332],[QTY333],[QTY334],[QTY335],[QTY336],[QTY337],[QTY338],[QTY339],[QTY340]
                        ,[QTY341],[QTY342],[QTY343],[QTY344],[QTY345],[QTY346],[QTY347],[QTY348],[QTY349],[QTY350],[QTY351],[QTY352],[QTY353],[QTY354],[QTY355],[QTY356],[QTY357],[QTY358],[QTY359],[QTY360]
                        ,[QTY361],[QTY362],[QTY363],[QTY364]
                        ,[WQTY01],[WQTY02],[WQTY03],[WQTY04],[WQTY05],[WQTY06],[WQTY07],[WQTY08],[WQTY09],[WQTY10],[WQTY11],[WQTY12],[WQTY13],[WQTY14],[WQTY15],[WQTY16],[WQTY17],[WQTY18],[WQTY19],[WQTY20]
                        ,[WQTY21],[WQTY22],[WQTY23],[WQTY24],[WQTY25],[WQTY26],[WQTY27],[WQTY28],[WQTY29],[WQTY30],[WQTY31],[WQTY32],[WQTY33],[WQTY34],[WQTY35],[WQTY36],[WQTY37],[WQTY38],[WQTY39],[WQTY40]
                        ,[WQTY41],[WQTY42],[WQTY43],[WQTY44],[WQTY45],[WQTY46],[WQTY47],[WQTY48],[WQTY49],[WQTY50],[WQTY51],[WQTY52]
                        )
        ) AS PIVOT_TABLE

        ------------------------------------------------------------------------
        -- Initialization Qty
        ------------------------------------------------------------------------
        UPDATE  SCP_XLS_PSI_GLOBAL
        SET     [QTY001] = 0,[QTY002] = 0,[QTY003] = 0,[QTY004] = 0,[QTY005] = 0,[QTY006] = 0,[QTY007] = 0,[QTY008] = 0,[QTY009] = 0,[QTY010] = 0,[QTY011] = 0,[QTY012] = 0,[QTY013] = 0,[QTY014] = 0,[QTY015] = 0,[QTY016] = 0,[QTY017] = 0,[QTY018] = 0,[QTY019] = 0,[QTY020] = 0
               ,[QTY021] = 0,[QTY022] = 0,[QTY023] = 0,[QTY024] = 0,[QTY025] = 0,[QTY026] = 0,[QTY027] = 0,[QTY028] = 0,[QTY029] = 0,[QTY030] = 0,[QTY031] = 0,[QTY032] = 0,[QTY033] = 0,[QTY034] = 0,[QTY035] = 0,[QTY036] = 0,[QTY037] = 0,[QTY038] = 0,[QTY039] = 0,[QTY040] = 0
               ,[QTY041] = 0,[QTY042] = 0,[QTY043] = 0,[QTY044] = 0,[QTY045] = 0,[QTY046] = 0,[QTY047] = 0,[QTY048] = 0,[QTY049] = 0,[QTY050] = 0,[QTY051] = 0,[QTY052] = 0,[QTY053] = 0,[QTY054] = 0,[QTY055] = 0,[QTY056] = 0,[QTY057] = 0,[QTY058] = 0,[QTY059] = 0,[QTY060] = 0
               ,[QTY061] = 0,[QTY062] = 0,[QTY063] = 0,[QTY064] = 0,[QTY065] = 0,[QTY066] = 0,[QTY067] = 0,[QTY068] = 0,[QTY069] = 0,[QTY070] = 0,[QTY071] = 0,[QTY072] = 0,[QTY073] = 0,[QTY074] = 0,[QTY075] = 0,[QTY076] = 0,[QTY077] = 0,[QTY078] = 0,[QTY079] = 0,[QTY080] = 0
               ,[QTY081] = 0,[QTY082] = 0,[QTY083] = 0,[QTY084] = 0,[QTY085] = 0,[QTY086] = 0,[QTY087] = 0,[QTY088] = 0,[QTY089] = 0,[QTY090] = 0,[QTY091] = 0,[QTY092] = 0,[QTY093] = 0,[QTY094] = 0,[QTY095] = 0,[QTY096] = 0,[QTY097] = 0,[QTY098] = 0,[QTY099] = 0,[QTY100] = 0
               ,[QTY101] = 0,[QTY102] = 0,[QTY103] = 0,[QTY104] = 0,[QTY105] = 0,[QTY106] = 0,[QTY107] = 0,[QTY108] = 0,[QTY109] = 0,[QTY110] = 0,[QTY111] = 0,[QTY112] = 0,[QTY113] = 0,[QTY114] = 0,[QTY115] = 0,[QTY116] = 0,[QTY117] = 0,[QTY118] = 0,[QTY119] = 0,[QTY120] = 0
               ,[QTY121] = 0,[QTY122] = 0,[QTY123] = 0,[QTY124] = 0,[QTY125] = 0,[QTY126] = 0,[QTY127] = 0,[QTY128] = 0,[QTY129] = 0,[QTY130] = 0,[QTY131] = 0,[QTY132] = 0,[QTY133] = 0,[QTY134] = 0,[QTY135] = 0,[QTY136] = 0,[QTY137] = 0,[QTY138] = 0,[QTY139] = 0,[QTY140] = 0
               ,[QTY141] = 0,[QTY142] = 0,[QTY143] = 0,[QTY144] = 0,[QTY145] = 0,[QTY146] = 0,[QTY147] = 0,[QTY148] = 0,[QTY149] = 0,[QTY150] = 0,[QTY151] = 0,[QTY152] = 0,[QTY153] = 0,[QTY154] = 0,[QTY155] = 0,[QTY156] = 0,[QTY157] = 0,[QTY158] = 0,[QTY159] = 0,[QTY160] = 0
               ,[QTY161] = 0,[QTY162] = 0,[QTY163] = 0,[QTY164] = 0,[QTY165] = 0,[QTY166] = 0,[QTY167] = 0,[QTY168] = 0,[QTY169] = 0,[QTY170] = 0,[QTY171] = 0,[QTY172] = 0,[QTY173] = 0,[QTY174] = 0,[QTY175] = 0,[QTY176] = 0,[QTY177] = 0,[QTY178] = 0,[QTY179] = 0,[QTY180] = 0
               ,[QTY181] = 0,[QTY182] = 0,[QTY183] = 0,[QTY184] = 0,[QTY185] = 0,[QTY186] = 0,[QTY187] = 0,[QTY188] = 0,[QTY189] = 0,[QTY190] = 0,[QTY191] = 0,[QTY192] = 0,[QTY193] = 0,[QTY194] = 0,[QTY195] = 0,[QTY196] = 0,[QTY197] = 0,[QTY198] = 0,[QTY199] = 0,[QTY200] = 0
               ,[QTY201] = 0,[QTY202] = 0,[QTY203] = 0,[QTY204] = 0,[QTY205] = 0,[QTY206] = 0,[QTY207] = 0,[QTY208] = 0,[QTY209] = 0,[QTY210] = 0,[QTY211] = 0,[QTY212] = 0,[QTY213] = 0,[QTY214] = 0,[QTY215] = 0,[QTY216] = 0,[QTY217] = 0,[QTY218] = 0,[QTY219] = 0,[QTY220] = 0
               ,[QTY221] = 0,[QTY222] = 0,[QTY223] = 0,[QTY224] = 0,[QTY225] = 0,[QTY226] = 0,[QTY227] = 0,[QTY228] = 0,[QTY229] = 0,[QTY230] = 0,[QTY231] = 0,[QTY232] = 0,[QTY233] = 0,[QTY234] = 0,[QTY235] = 0,[QTY236] = 0,[QTY237] = 0,[QTY238] = 0,[QTY239] = 0,[QTY240] = 0
               ,[QTY241] = 0,[QTY242] = 0,[QTY243] = 0,[QTY244] = 0,[QTY245] = 0,[QTY246] = 0,[QTY247] = 0,[QTY248] = 0,[QTY249] = 0,[QTY250] = 0,[QTY251] = 0,[QTY252] = 0,[QTY253] = 0,[QTY254] = 0,[QTY255] = 0,[QTY256] = 0,[QTY257] = 0,[QTY258] = 0,[QTY259] = 0,[QTY260] = 0
               ,[QTY261] = 0,[QTY262] = 0,[QTY263] = 0,[QTY264] = 0,[QTY265] = 0,[QTY266] = 0,[QTY267] = 0,[QTY268] = 0,[QTY269] = 0,[QTY270] = 0,[QTY271] = 0,[QTY272] = 0,[QTY273] = 0,[QTY274] = 0,[QTY275] = 0,[QTY276] = 0,[QTY277] = 0,[QTY278] = 0,[QTY279] = 0,[QTY280] = 0
               ,[QTY281] = 0,[QTY282] = 0,[QTY283] = 0,[QTY284] = 0,[QTY285] = 0,[QTY286] = 0,[QTY287] = 0,[QTY288] = 0,[QTY289] = 0,[QTY290] = 0,[QTY291] = 0,[QTY292] = 0,[QTY293] = 0,[QTY294] = 0,[QTY295] = 0,[QTY296] = 0,[QTY297] = 0,[QTY298] = 0,[QTY299] = 0,[QTY300] = 0
               ,[QTY301] = 0,[QTY302] = 0,[QTY303] = 0,[QTY304] = 0,[QTY305] = 0,[QTY306] = 0,[QTY307] = 0,[QTY308] = 0,[QTY309] = 0,[QTY310] = 0,[QTY311] = 0,[QTY312] = 0,[QTY313] = 0,[QTY314] = 0,[QTY315] = 0,[QTY316] = 0,[QTY317] = 0,[QTY318] = 0,[QTY319] = 0,[QTY320] = 0
               ,[QTY321] = 0,[QTY322] = 0,[QTY323] = 0,[QTY324] = 0,[QTY325] = 0,[QTY326] = 0,[QTY327] = 0,[QTY328] = 0,[QTY329] = 0,[QTY330] = 0,[QTY331] = 0,[QTY332] = 0,[QTY333] = 0,[QTY334] = 0,[QTY335] = 0,[QTY336] = 0,[QTY337] = 0,[QTY338] = 0,[QTY339] = 0,[QTY340] = 0
               ,[QTY341] = 0,[QTY342] = 0,[QTY343] = 0,[QTY344] = 0,[QTY345] = 0,[QTY346] = 0,[QTY347] = 0,[QTY348] = 0,[QTY349] = 0,[QTY350] = 0,[QTY351] = 0,[QTY352] = 0,[QTY353] = 0,[QTY354] = 0,[QTY355] = 0,[QTY356] = 0,[QTY357] = 0,[QTY358] = 0,[QTY359] = 0,[QTY360] = 0
               ,[QTY361] = 0,[QTY362] = 0,[QTY363] = 0,[QTY364] = 0
               ,[WQTY01] = 0,[WQTY02] = 0,[WQTY03] = 0,[WQTY04] = 0,[WQTY05] = 0,[WQTY06] = 0,[WQTY07] = 0,[WQTY08] = 0,[WQTY09] = 0,[WQTY10] = 0,[WQTY11] = 0,[WQTY12] = 0,[WQTY13] = 0,[WQTY14] = 0,[WQTY15] = 0,[WQTY16] = 0,[WQTY17] = 0,[WQTY18] = 0,[WQTY19] = 0,[WQTY20] = 0
               ,[WQTY21] = 0,[WQTY22] = 0,[WQTY23] = 0,[WQTY24] = 0,[WQTY25] = 0,[WQTY26] = 0,[WQTY27] = 0,[WQTY28] = 0,[WQTY29] = 0,[WQTY30] = 0,[WQTY31] = 0,[WQTY32] = 0,[WQTY33] = 0,[WQTY34] = 0,[WQTY35] = 0,[WQTY36] = 0,[WQTY37] = 0,[WQTY38] = 0,[WQTY39] = 0,[WQTY40] = 0
               ,[WQTY41] = 0,[WQTY42] = 0,[WQTY43] = 0,[WQTY44] = 0,[WQTY45] = 0,[WQTY46] = 0,[WQTY47] = 0,[WQTY48] = 0,[WQTY49] = 0,[WQTY50] = 0,[WQTY51] = 0,[WQTY52] = 0
               ,LAST_UPDATED_BY  = @UPDATE_NAME
               ,LAST_UPDATE_DATE = @NOW_DATE
        FROM    SCP_XLS_PSI_GLOBAL WITH(NOLOCK)
            INNER JOIN (SELECT SCM_SITE_ID
                              ,ITEM_ID
                        FROM   SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                        WHERE  PLAN_ID = @V_PLAN_ID
                        GROUP BY SCM_SITE_ID, ITEM_ID
                       ) ML
                ON  SCP_XLS_PSI_GLOBAL.FROM_SITE   = ML.SCM_SITE_ID
                AND SCP_XLS_PSI_GLOBAL.ITEM_ID     = ML.ITEM_ID
        WHERE   1=1
        AND     SCP_XLS_PSI_GLOBAL.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD
        AND     SCP_XLS_PSI_GLOBAL.DIVISION_ID         = @V_DIVISION_ID
        AND     SCP_XLS_PSI_GLOBAL.PLAN_TYPE           = @V_SCP_PLAN_TYPE
        AND     SCP_XLS_PSI_GLOBAL.SEQ                 = @V_SCP_PLAN_SEQ
        AND     SCP_XLS_PSI_GLOBAL.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD 
        AND     SCP_XLS_PSI_GLOBAL.CREATE_FROM_YYYYMMDD IN (SELECT DISTINCT CREATE_FROM_YYYYMMDD FROM @XLS_PV_READY)
        AND     SCP_XLS_PSI_GLOBAL.MEASURE IN (SELECT DISTINCT MEASURE
                                            FROM @XLS_PV_READY)

        ------------------------------------------------------------------------
        -- UPDATE SCP_XLS_PSI_GLOBAL
        ------------------------------------------------------------------------
        UPDATE SCP_XLS_PSI_GLOBAL
        SET LAST_UPDATED_BY  = @UPDATE_NAME, LAST_UPDATE_DATE = @NOW_DATE
        ,SCP_XLS_PSI_GLOBAL.QTY001=PV.QTY001	,SCP_XLS_PSI_GLOBAL.QTY002=PV.QTY002	,SCP_XLS_PSI_GLOBAL.QTY003=PV.QTY003	,SCP_XLS_PSI_GLOBAL.QTY004=PV.QTY004	,SCP_XLS_PSI_GLOBAL.QTY005=PV.QTY005	,SCP_XLS_PSI_GLOBAL.QTY006=PV.QTY006	,SCP_XLS_PSI_GLOBAL.QTY007=PV.QTY007	,SCP_XLS_PSI_GLOBAL.QTY008=PV.QTY008	,SCP_XLS_PSI_GLOBAL.QTY009=PV.QTY009	,SCP_XLS_PSI_GLOBAL.QTY010=PV.QTY010	,SCP_XLS_PSI_GLOBAL.QTY011=PV.QTY011	,SCP_XLS_PSI_GLOBAL.QTY012=PV.QTY012	,SCP_XLS_PSI_GLOBAL.QTY013=PV.QTY013	,SCP_XLS_PSI_GLOBAL.QTY014=PV.QTY014	,SCP_XLS_PSI_GLOBAL.QTY015=PV.QTY015	,SCP_XLS_PSI_GLOBAL.QTY016=PV.QTY016	,SCP_XLS_PSI_GLOBAL.QTY017=PV.QTY017	,SCP_XLS_PSI_GLOBAL.QTY018=PV.QTY018	,SCP_XLS_PSI_GLOBAL.QTY019=PV.QTY019	,SCP_XLS_PSI_GLOBAL.QTY020=PV.QTY020
        ,SCP_XLS_PSI_GLOBAL.QTY021=PV.QTY021	,SCP_XLS_PSI_GLOBAL.QTY022=PV.QTY022	,SCP_XLS_PSI_GLOBAL.QTY023=PV.QTY023	,SCP_XLS_PSI_GLOBAL.QTY024=PV.QTY024	,SCP_XLS_PSI_GLOBAL.QTY025=PV.QTY025	,SCP_XLS_PSI_GLOBAL.QTY026=PV.QTY026	,SCP_XLS_PSI_GLOBAL.QTY027=PV.QTY027	,SCP_XLS_PSI_GLOBAL.QTY028=PV.QTY028	,SCP_XLS_PSI_GLOBAL.QTY029=PV.QTY029	,SCP_XLS_PSI_GLOBAL.QTY030=PV.QTY030	,SCP_XLS_PSI_GLOBAL.QTY031=PV.QTY031	,SCP_XLS_PSI_GLOBAL.QTY032=PV.QTY032	,SCP_XLS_PSI_GLOBAL.QTY033=PV.QTY033	,SCP_XLS_PSI_GLOBAL.QTY034=PV.QTY034	,SCP_XLS_PSI_GLOBAL.QTY035=PV.QTY035	,SCP_XLS_PSI_GLOBAL.QTY036=PV.QTY036	,SCP_XLS_PSI_GLOBAL.QTY037=PV.QTY037	,SCP_XLS_PSI_GLOBAL.QTY038=PV.QTY038	,SCP_XLS_PSI_GLOBAL.QTY039=PV.QTY039	,SCP_XLS_PSI_GLOBAL.QTY040=PV.QTY040
        ,SCP_XLS_PSI_GLOBAL.QTY041=PV.QTY041	,SCP_XLS_PSI_GLOBAL.QTY042=PV.QTY042	,SCP_XLS_PSI_GLOBAL.QTY043=PV.QTY043	,SCP_XLS_PSI_GLOBAL.QTY044=PV.QTY044	,SCP_XLS_PSI_GLOBAL.QTY045=PV.QTY045	,SCP_XLS_PSI_GLOBAL.QTY046=PV.QTY046	,SCP_XLS_PSI_GLOBAL.QTY047=PV.QTY047	,SCP_XLS_PSI_GLOBAL.QTY048=PV.QTY048	,SCP_XLS_PSI_GLOBAL.QTY049=PV.QTY049	,SCP_XLS_PSI_GLOBAL.QTY050=PV.QTY050	,SCP_XLS_PSI_GLOBAL.QTY051=PV.QTY051	,SCP_XLS_PSI_GLOBAL.QTY052=PV.QTY052	,SCP_XLS_PSI_GLOBAL.QTY053=PV.QTY053	,SCP_XLS_PSI_GLOBAL.QTY054=PV.QTY054	,SCP_XLS_PSI_GLOBAL.QTY055=PV.QTY055	,SCP_XLS_PSI_GLOBAL.QTY056=PV.QTY056	,SCP_XLS_PSI_GLOBAL.QTY057=PV.QTY057	,SCP_XLS_PSI_GLOBAL.QTY058=PV.QTY058	,SCP_XLS_PSI_GLOBAL.QTY059=PV.QTY059	,SCP_XLS_PSI_GLOBAL.QTY060=PV.QTY060
        ,SCP_XLS_PSI_GLOBAL.QTY061=PV.QTY061	,SCP_XLS_PSI_GLOBAL.QTY062=PV.QTY062	,SCP_XLS_PSI_GLOBAL.QTY063=PV.QTY063	,SCP_XLS_PSI_GLOBAL.QTY064=PV.QTY064	,SCP_XLS_PSI_GLOBAL.QTY065=PV.QTY065	,SCP_XLS_PSI_GLOBAL.QTY066=PV.QTY066	,SCP_XLS_PSI_GLOBAL.QTY067=PV.QTY067	,SCP_XLS_PSI_GLOBAL.QTY068=PV.QTY068	,SCP_XLS_PSI_GLOBAL.QTY069=PV.QTY069	,SCP_XLS_PSI_GLOBAL.QTY070=PV.QTY070	,SCP_XLS_PSI_GLOBAL.QTY071=PV.QTY071	,SCP_XLS_PSI_GLOBAL.QTY072=PV.QTY072	,SCP_XLS_PSI_GLOBAL.QTY073=PV.QTY073	,SCP_XLS_PSI_GLOBAL.QTY074=PV.QTY074	,SCP_XLS_PSI_GLOBAL.QTY075=PV.QTY075	,SCP_XLS_PSI_GLOBAL.QTY076=PV.QTY076	,SCP_XLS_PSI_GLOBAL.QTY077=PV.QTY077	,SCP_XLS_PSI_GLOBAL.QTY078=PV.QTY078	,SCP_XLS_PSI_GLOBAL.QTY079=PV.QTY079	,SCP_XLS_PSI_GLOBAL.QTY080=PV.QTY080
        ,SCP_XLS_PSI_GLOBAL.QTY081=PV.QTY081	,SCP_XLS_PSI_GLOBAL.QTY082=PV.QTY082	,SCP_XLS_PSI_GLOBAL.QTY083=PV.QTY083	,SCP_XLS_PSI_GLOBAL.QTY084=PV.QTY084	,SCP_XLS_PSI_GLOBAL.QTY085=PV.QTY085	,SCP_XLS_PSI_GLOBAL.QTY086=PV.QTY086	,SCP_XLS_PSI_GLOBAL.QTY087=PV.QTY087	,SCP_XLS_PSI_GLOBAL.QTY088=PV.QTY088	,SCP_XLS_PSI_GLOBAL.QTY089=PV.QTY089	,SCP_XLS_PSI_GLOBAL.QTY090=PV.QTY090	,SCP_XLS_PSI_GLOBAL.QTY091=PV.QTY091	,SCP_XLS_PSI_GLOBAL.QTY092=PV.QTY092	,SCP_XLS_PSI_GLOBAL.QTY093=PV.QTY093	,SCP_XLS_PSI_GLOBAL.QTY094=PV.QTY094	,SCP_XLS_PSI_GLOBAL.QTY095=PV.QTY095	,SCP_XLS_PSI_GLOBAL.QTY096=PV.QTY096	,SCP_XLS_PSI_GLOBAL.QTY097=PV.QTY097	,SCP_XLS_PSI_GLOBAL.QTY098=PV.QTY098	,SCP_XLS_PSI_GLOBAL.QTY099=PV.QTY099	,SCP_XLS_PSI_GLOBAL.QTY100=PV.QTY100
        ,SCP_XLS_PSI_GLOBAL.QTY101=PV.QTY101	,SCP_XLS_PSI_GLOBAL.QTY102=PV.QTY102	,SCP_XLS_PSI_GLOBAL.QTY103=PV.QTY103	,SCP_XLS_PSI_GLOBAL.QTY104=PV.QTY104	,SCP_XLS_PSI_GLOBAL.QTY105=PV.QTY105	,SCP_XLS_PSI_GLOBAL.QTY106=PV.QTY106	,SCP_XLS_PSI_GLOBAL.QTY107=PV.QTY107	,SCP_XLS_PSI_GLOBAL.QTY108=PV.QTY108	,SCP_XLS_PSI_GLOBAL.QTY109=PV.QTY109	,SCP_XLS_PSI_GLOBAL.QTY110=PV.QTY110	,SCP_XLS_PSI_GLOBAL.QTY111=PV.QTY111	,SCP_XLS_PSI_GLOBAL.QTY112=PV.QTY112	,SCP_XLS_PSI_GLOBAL.QTY113=PV.QTY113	,SCP_XLS_PSI_GLOBAL.QTY114=PV.QTY114	,SCP_XLS_PSI_GLOBAL.QTY115=PV.QTY115	,SCP_XLS_PSI_GLOBAL.QTY116=PV.QTY116	,SCP_XLS_PSI_GLOBAL.QTY117=PV.QTY117	,SCP_XLS_PSI_GLOBAL.QTY118=PV.QTY118	,SCP_XLS_PSI_GLOBAL.QTY119=PV.QTY119	,SCP_XLS_PSI_GLOBAL.QTY120=PV.QTY120
        ,SCP_XLS_PSI_GLOBAL.QTY121=PV.QTY121	,SCP_XLS_PSI_GLOBAL.QTY122=PV.QTY122	,SCP_XLS_PSI_GLOBAL.QTY123=PV.QTY123	,SCP_XLS_PSI_GLOBAL.QTY124=PV.QTY124	,SCP_XLS_PSI_GLOBAL.QTY125=PV.QTY125	,SCP_XLS_PSI_GLOBAL.QTY126=PV.QTY126	,SCP_XLS_PSI_GLOBAL.QTY127=PV.QTY127	,SCP_XLS_PSI_GLOBAL.QTY128=PV.QTY128	,SCP_XLS_PSI_GLOBAL.QTY129=PV.QTY129	,SCP_XLS_PSI_GLOBAL.QTY130=PV.QTY130	,SCP_XLS_PSI_GLOBAL.QTY131=PV.QTY131	,SCP_XLS_PSI_GLOBAL.QTY132=PV.QTY132	,SCP_XLS_PSI_GLOBAL.QTY133=PV.QTY133	,SCP_XLS_PSI_GLOBAL.QTY134=PV.QTY134	,SCP_XLS_PSI_GLOBAL.QTY135=PV.QTY135	,SCP_XLS_PSI_GLOBAL.QTY136=PV.QTY136	,SCP_XLS_PSI_GLOBAL.QTY137=PV.QTY137	,SCP_XLS_PSI_GLOBAL.QTY138=PV.QTY138	,SCP_XLS_PSI_GLOBAL.QTY139=PV.QTY139	,SCP_XLS_PSI_GLOBAL.QTY140=PV.QTY140
        ,SCP_XLS_PSI_GLOBAL.QTY141=PV.QTY141	,SCP_XLS_PSI_GLOBAL.QTY142=PV.QTY142	,SCP_XLS_PSI_GLOBAL.QTY143=PV.QTY143	,SCP_XLS_PSI_GLOBAL.QTY144=PV.QTY144	,SCP_XLS_PSI_GLOBAL.QTY145=PV.QTY145	,SCP_XLS_PSI_GLOBAL.QTY146=PV.QTY146	,SCP_XLS_PSI_GLOBAL.QTY147=PV.QTY147	,SCP_XLS_PSI_GLOBAL.QTY148=PV.QTY148	,SCP_XLS_PSI_GLOBAL.QTY149=PV.QTY149	,SCP_XLS_PSI_GLOBAL.QTY150=PV.QTY150	,SCP_XLS_PSI_GLOBAL.QTY151=PV.QTY151	,SCP_XLS_PSI_GLOBAL.QTY152=PV.QTY152	,SCP_XLS_PSI_GLOBAL.QTY153=PV.QTY153	,SCP_XLS_PSI_GLOBAL.QTY154=PV.QTY154	,SCP_XLS_PSI_GLOBAL.QTY155=PV.QTY155	,SCP_XLS_PSI_GLOBAL.QTY156=PV.QTY156	,SCP_XLS_PSI_GLOBAL.QTY157=PV.QTY157	,SCP_XLS_PSI_GLOBAL.QTY158=PV.QTY158	,SCP_XLS_PSI_GLOBAL.QTY159=PV.QTY159	,SCP_XLS_PSI_GLOBAL.QTY160=PV.QTY160
        ,SCP_XLS_PSI_GLOBAL.QTY161=PV.QTY161	,SCP_XLS_PSI_GLOBAL.QTY162=PV.QTY162	,SCP_XLS_PSI_GLOBAL.QTY163=PV.QTY163	,SCP_XLS_PSI_GLOBAL.QTY164=PV.QTY164	,SCP_XLS_PSI_GLOBAL.QTY165=PV.QTY165	,SCP_XLS_PSI_GLOBAL.QTY166=PV.QTY166	,SCP_XLS_PSI_GLOBAL.QTY167=PV.QTY167	,SCP_XLS_PSI_GLOBAL.QTY168=PV.QTY168	,SCP_XLS_PSI_GLOBAL.QTY169=PV.QTY169	,SCP_XLS_PSI_GLOBAL.QTY170=PV.QTY170	,SCP_XLS_PSI_GLOBAL.QTY171=PV.QTY171	,SCP_XLS_PSI_GLOBAL.QTY172=PV.QTY172	,SCP_XLS_PSI_GLOBAL.QTY173=PV.QTY173	,SCP_XLS_PSI_GLOBAL.QTY174=PV.QTY174	,SCP_XLS_PSI_GLOBAL.QTY175=PV.QTY175	,SCP_XLS_PSI_GLOBAL.QTY176=PV.QTY176	,SCP_XLS_PSI_GLOBAL.QTY177=PV.QTY177	,SCP_XLS_PSI_GLOBAL.QTY178=PV.QTY178	,SCP_XLS_PSI_GLOBAL.QTY179=PV.QTY179	,SCP_XLS_PSI_GLOBAL.QTY180=PV.QTY180
        ,SCP_XLS_PSI_GLOBAL.QTY181=PV.QTY181	,SCP_XLS_PSI_GLOBAL.QTY182=PV.QTY182	,SCP_XLS_PSI_GLOBAL.QTY183=PV.QTY183	,SCP_XLS_PSI_GLOBAL.QTY184=PV.QTY184	,SCP_XLS_PSI_GLOBAL.QTY185=PV.QTY185	,SCP_XLS_PSI_GLOBAL.QTY186=PV.QTY186	,SCP_XLS_PSI_GLOBAL.QTY187=PV.QTY187	,SCP_XLS_PSI_GLOBAL.QTY188=PV.QTY188	,SCP_XLS_PSI_GLOBAL.QTY189=PV.QTY189	,SCP_XLS_PSI_GLOBAL.QTY190=PV.QTY190	,SCP_XLS_PSI_GLOBAL.QTY191=PV.QTY191	,SCP_XLS_PSI_GLOBAL.QTY192=PV.QTY192	,SCP_XLS_PSI_GLOBAL.QTY193=PV.QTY193	,SCP_XLS_PSI_GLOBAL.QTY194=PV.QTY194	,SCP_XLS_PSI_GLOBAL.QTY195=PV.QTY195	,SCP_XLS_PSI_GLOBAL.QTY196=PV.QTY196	,SCP_XLS_PSI_GLOBAL.QTY197=PV.QTY197	,SCP_XLS_PSI_GLOBAL.QTY198=PV.QTY198	,SCP_XLS_PSI_GLOBAL.QTY199=PV.QTY199	,SCP_XLS_PSI_GLOBAL.QTY200=PV.QTY200
        ,SCP_XLS_PSI_GLOBAL.QTY201=PV.QTY201	,SCP_XLS_PSI_GLOBAL.QTY202=PV.QTY202	,SCP_XLS_PSI_GLOBAL.QTY203=PV.QTY203	,SCP_XLS_PSI_GLOBAL.QTY204=PV.QTY204	,SCP_XLS_PSI_GLOBAL.QTY205=PV.QTY205	,SCP_XLS_PSI_GLOBAL.QTY206=PV.QTY206	,SCP_XLS_PSI_GLOBAL.QTY207=PV.QTY207	,SCP_XLS_PSI_GLOBAL.QTY208=PV.QTY208	,SCP_XLS_PSI_GLOBAL.QTY209=PV.QTY209	,SCP_XLS_PSI_GLOBAL.QTY210=PV.QTY210	,SCP_XLS_PSI_GLOBAL.QTY211=PV.QTY211	,SCP_XLS_PSI_GLOBAL.QTY212=PV.QTY212	,SCP_XLS_PSI_GLOBAL.QTY213=PV.QTY213	,SCP_XLS_PSI_GLOBAL.QTY214=PV.QTY214	,SCP_XLS_PSI_GLOBAL.QTY215=PV.QTY215	,SCP_XLS_PSI_GLOBAL.QTY216=PV.QTY216	,SCP_XLS_PSI_GLOBAL.QTY217=PV.QTY217	,SCP_XLS_PSI_GLOBAL.QTY218=PV.QTY218	,SCP_XLS_PSI_GLOBAL.QTY219=PV.QTY219	,SCP_XLS_PSI_GLOBAL.QTY220=PV.QTY220
        ,SCP_XLS_PSI_GLOBAL.QTY221=PV.QTY221	,SCP_XLS_PSI_GLOBAL.QTY222=PV.QTY222	,SCP_XLS_PSI_GLOBAL.QTY223=PV.QTY223	,SCP_XLS_PSI_GLOBAL.QTY224=PV.QTY224	,SCP_XLS_PSI_GLOBAL.QTY225=PV.QTY225	,SCP_XLS_PSI_GLOBAL.QTY226=PV.QTY226	,SCP_XLS_PSI_GLOBAL.QTY227=PV.QTY227	,SCP_XLS_PSI_GLOBAL.QTY228=PV.QTY228	,SCP_XLS_PSI_GLOBAL.QTY229=PV.QTY229	,SCP_XLS_PSI_GLOBAL.QTY230=PV.QTY230	,SCP_XLS_PSI_GLOBAL.QTY231=PV.QTY231	,SCP_XLS_PSI_GLOBAL.QTY232=PV.QTY232	,SCP_XLS_PSI_GLOBAL.QTY233=PV.QTY233	,SCP_XLS_PSI_GLOBAL.QTY234=PV.QTY234	,SCP_XLS_PSI_GLOBAL.QTY235=PV.QTY235	,SCP_XLS_PSI_GLOBAL.QTY236=PV.QTY236	,SCP_XLS_PSI_GLOBAL.QTY237=PV.QTY237	,SCP_XLS_PSI_GLOBAL.QTY238=PV.QTY238	,SCP_XLS_PSI_GLOBAL.QTY239=PV.QTY239	,SCP_XLS_PSI_GLOBAL.QTY240=PV.QTY240
        ,SCP_XLS_PSI_GLOBAL.QTY241=PV.QTY241	,SCP_XLS_PSI_GLOBAL.QTY242=PV.QTY242	,SCP_XLS_PSI_GLOBAL.QTY243=PV.QTY243	,SCP_XLS_PSI_GLOBAL.QTY244=PV.QTY244	,SCP_XLS_PSI_GLOBAL.QTY245=PV.QTY245	,SCP_XLS_PSI_GLOBAL.QTY246=PV.QTY246	,SCP_XLS_PSI_GLOBAL.QTY247=PV.QTY247	,SCP_XLS_PSI_GLOBAL.QTY248=PV.QTY248	,SCP_XLS_PSI_GLOBAL.QTY249=PV.QTY249	,SCP_XLS_PSI_GLOBAL.QTY250=PV.QTY250	,SCP_XLS_PSI_GLOBAL.QTY251=PV.QTY251	,SCP_XLS_PSI_GLOBAL.QTY252=PV.QTY252	,SCP_XLS_PSI_GLOBAL.QTY253=PV.QTY253	,SCP_XLS_PSI_GLOBAL.QTY254=PV.QTY254	,SCP_XLS_PSI_GLOBAL.QTY255=PV.QTY255	,SCP_XLS_PSI_GLOBAL.QTY256=PV.QTY256	,SCP_XLS_PSI_GLOBAL.QTY257=PV.QTY257	,SCP_XLS_PSI_GLOBAL.QTY258=PV.QTY258	,SCP_XLS_PSI_GLOBAL.QTY259=PV.QTY259	,SCP_XLS_PSI_GLOBAL.QTY260=PV.QTY260
        ,SCP_XLS_PSI_GLOBAL.QTY261=PV.QTY261	,SCP_XLS_PSI_GLOBAL.QTY262=PV.QTY262	,SCP_XLS_PSI_GLOBAL.QTY263=PV.QTY263	,SCP_XLS_PSI_GLOBAL.QTY264=PV.QTY264	,SCP_XLS_PSI_GLOBAL.QTY265=PV.QTY265	,SCP_XLS_PSI_GLOBAL.QTY266=PV.QTY266	,SCP_XLS_PSI_GLOBAL.QTY267=PV.QTY267	,SCP_XLS_PSI_GLOBAL.QTY268=PV.QTY268	,SCP_XLS_PSI_GLOBAL.QTY269=PV.QTY269	,SCP_XLS_PSI_GLOBAL.QTY270=PV.QTY270	,SCP_XLS_PSI_GLOBAL.QTY271=PV.QTY271	,SCP_XLS_PSI_GLOBAL.QTY272=PV.QTY272	,SCP_XLS_PSI_GLOBAL.QTY273=PV.QTY273	,SCP_XLS_PSI_GLOBAL.QTY274=PV.QTY274	,SCP_XLS_PSI_GLOBAL.QTY275=PV.QTY275	,SCP_XLS_PSI_GLOBAL.QTY276=PV.QTY276	,SCP_XLS_PSI_GLOBAL.QTY277=PV.QTY277	,SCP_XLS_PSI_GLOBAL.QTY278=PV.QTY278	,SCP_XLS_PSI_GLOBAL.QTY279=PV.QTY279	,SCP_XLS_PSI_GLOBAL.QTY280=PV.QTY280
        ,SCP_XLS_PSI_GLOBAL.QTY281=PV.QTY281	,SCP_XLS_PSI_GLOBAL.QTY282=PV.QTY282	,SCP_XLS_PSI_GLOBAL.QTY283=PV.QTY283	,SCP_XLS_PSI_GLOBAL.QTY284=PV.QTY284	,SCP_XLS_PSI_GLOBAL.QTY285=PV.QTY285	,SCP_XLS_PSI_GLOBAL.QTY286=PV.QTY286	,SCP_XLS_PSI_GLOBAL.QTY287=PV.QTY287	,SCP_XLS_PSI_GLOBAL.QTY288=PV.QTY288	,SCP_XLS_PSI_GLOBAL.QTY289=PV.QTY289	,SCP_XLS_PSI_GLOBAL.QTY290=PV.QTY290	,SCP_XLS_PSI_GLOBAL.QTY291=PV.QTY291	,SCP_XLS_PSI_GLOBAL.QTY292=PV.QTY292	,SCP_XLS_PSI_GLOBAL.QTY293=PV.QTY293	,SCP_XLS_PSI_GLOBAL.QTY294=PV.QTY294	,SCP_XLS_PSI_GLOBAL.QTY295=PV.QTY295	,SCP_XLS_PSI_GLOBAL.QTY296=PV.QTY296	,SCP_XLS_PSI_GLOBAL.QTY297=PV.QTY297	,SCP_XLS_PSI_GLOBAL.QTY298=PV.QTY298	,SCP_XLS_PSI_GLOBAL.QTY299=PV.QTY299	,SCP_XLS_PSI_GLOBAL.QTY300=PV.QTY300
        ,SCP_XLS_PSI_GLOBAL.QTY301=PV.QTY301	,SCP_XLS_PSI_GLOBAL.QTY302=PV.QTY302	,SCP_XLS_PSI_GLOBAL.QTY303=PV.QTY303	,SCP_XLS_PSI_GLOBAL.QTY304=PV.QTY304	,SCP_XLS_PSI_GLOBAL.QTY305=PV.QTY305	,SCP_XLS_PSI_GLOBAL.QTY306=PV.QTY306	,SCP_XLS_PSI_GLOBAL.QTY307=PV.QTY307	,SCP_XLS_PSI_GLOBAL.QTY308=PV.QTY308	,SCP_XLS_PSI_GLOBAL.QTY309=PV.QTY309	,SCP_XLS_PSI_GLOBAL.QTY310=PV.QTY310	,SCP_XLS_PSI_GLOBAL.QTY311=PV.QTY311	,SCP_XLS_PSI_GLOBAL.QTY312=PV.QTY312	,SCP_XLS_PSI_GLOBAL.QTY313=PV.QTY313	,SCP_XLS_PSI_GLOBAL.QTY314=PV.QTY314	,SCP_XLS_PSI_GLOBAL.QTY315=PV.QTY315	,SCP_XLS_PSI_GLOBAL.QTY316=PV.QTY316	,SCP_XLS_PSI_GLOBAL.QTY317=PV.QTY317	,SCP_XLS_PSI_GLOBAL.QTY318=PV.QTY318	,SCP_XLS_PSI_GLOBAL.QTY319=PV.QTY319	,SCP_XLS_PSI_GLOBAL.QTY320=PV.QTY320
        ,SCP_XLS_PSI_GLOBAL.QTY321=PV.QTY321	,SCP_XLS_PSI_GLOBAL.QTY322=PV.QTY322	,SCP_XLS_PSI_GLOBAL.QTY323=PV.QTY323	,SCP_XLS_PSI_GLOBAL.QTY324=PV.QTY324	,SCP_XLS_PSI_GLOBAL.QTY325=PV.QTY325	,SCP_XLS_PSI_GLOBAL.QTY326=PV.QTY326	,SCP_XLS_PSI_GLOBAL.QTY327=PV.QTY327	,SCP_XLS_PSI_GLOBAL.QTY328=PV.QTY328	,SCP_XLS_PSI_GLOBAL.QTY329=PV.QTY329	,SCP_XLS_PSI_GLOBAL.QTY330=PV.QTY330	,SCP_XLS_PSI_GLOBAL.QTY331=PV.QTY331	,SCP_XLS_PSI_GLOBAL.QTY332=PV.QTY332	,SCP_XLS_PSI_GLOBAL.QTY333=PV.QTY333	,SCP_XLS_PSI_GLOBAL.QTY334=PV.QTY334	,SCP_XLS_PSI_GLOBAL.QTY335=PV.QTY335	,SCP_XLS_PSI_GLOBAL.QTY336=PV.QTY336	,SCP_XLS_PSI_GLOBAL.QTY337=PV.QTY337	,SCP_XLS_PSI_GLOBAL.QTY338=PV.QTY338	,SCP_XLS_PSI_GLOBAL.QTY339=PV.QTY339	,SCP_XLS_PSI_GLOBAL.QTY340=PV.QTY340
        ,SCP_XLS_PSI_GLOBAL.QTY341=PV.QTY341	,SCP_XLS_PSI_GLOBAL.QTY342=PV.QTY342	,SCP_XLS_PSI_GLOBAL.QTY343=PV.QTY343	,SCP_XLS_PSI_GLOBAL.QTY344=PV.QTY344	,SCP_XLS_PSI_GLOBAL.QTY345=PV.QTY345	,SCP_XLS_PSI_GLOBAL.QTY346=PV.QTY346	,SCP_XLS_PSI_GLOBAL.QTY347=PV.QTY347	,SCP_XLS_PSI_GLOBAL.QTY348=PV.QTY348	,SCP_XLS_PSI_GLOBAL.QTY349=PV.QTY349	,SCP_XLS_PSI_GLOBAL.QTY350=PV.QTY350	,SCP_XLS_PSI_GLOBAL.QTY351=PV.QTY351	,SCP_XLS_PSI_GLOBAL.QTY352=PV.QTY352	,SCP_XLS_PSI_GLOBAL.QTY353=PV.QTY353	,SCP_XLS_PSI_GLOBAL.QTY354=PV.QTY354	,SCP_XLS_PSI_GLOBAL.QTY355=PV.QTY355	,SCP_XLS_PSI_GLOBAL.QTY356=PV.QTY356	,SCP_XLS_PSI_GLOBAL.QTY357=PV.QTY357	,SCP_XLS_PSI_GLOBAL.QTY358=PV.QTY358	,SCP_XLS_PSI_GLOBAL.QTY359=PV.QTY359	,SCP_XLS_PSI_GLOBAL.QTY360=PV.QTY360
        ,SCP_XLS_PSI_GLOBAL.QTY361=PV.QTY361	,SCP_XLS_PSI_GLOBAL.QTY362=PV.QTY362	,SCP_XLS_PSI_GLOBAL.QTY363=PV.QTY363	,SCP_XLS_PSI_GLOBAL.QTY364=PV.QTY364
        ,SCP_XLS_PSI_GLOBAL.WQTY01=PV.WQTY01	,SCP_XLS_PSI_GLOBAL.WQTY02=PV.WQTY02	,SCP_XLS_PSI_GLOBAL.WQTY03=PV.WQTY03	,SCP_XLS_PSI_GLOBAL.WQTY04=PV.WQTY04	,SCP_XLS_PSI_GLOBAL.WQTY05=PV.WQTY05	,SCP_XLS_PSI_GLOBAL.WQTY06=PV.WQTY06	,SCP_XLS_PSI_GLOBAL.WQTY07=PV.WQTY07	,SCP_XLS_PSI_GLOBAL.WQTY08=PV.WQTY08	,SCP_XLS_PSI_GLOBAL.WQTY09=PV.WQTY09	,SCP_XLS_PSI_GLOBAL.WQTY10=PV.WQTY10	,SCP_XLS_PSI_GLOBAL.WQTY11=PV.WQTY11	,SCP_XLS_PSI_GLOBAL.WQTY12=PV.WQTY12	,SCP_XLS_PSI_GLOBAL.WQTY13=PV.WQTY13	,SCP_XLS_PSI_GLOBAL.WQTY14=PV.WQTY14	,SCP_XLS_PSI_GLOBAL.WQTY15=PV.WQTY15	,SCP_XLS_PSI_GLOBAL.WQTY16=PV.WQTY16	,SCP_XLS_PSI_GLOBAL.WQTY17=PV.WQTY17	,SCP_XLS_PSI_GLOBAL.WQTY18=PV.WQTY18	,SCP_XLS_PSI_GLOBAL.WQTY19=PV.WQTY19	,SCP_XLS_PSI_GLOBAL.WQTY20=PV.WQTY20
        ,SCP_XLS_PSI_GLOBAL.WQTY21=PV.WQTY21	,SCP_XLS_PSI_GLOBAL.WQTY22=PV.WQTY22	,SCP_XLS_PSI_GLOBAL.WQTY23=PV.WQTY23	,SCP_XLS_PSI_GLOBAL.WQTY24=PV.WQTY24	,SCP_XLS_PSI_GLOBAL.WQTY25=PV.WQTY25	,SCP_XLS_PSI_GLOBAL.WQTY26=PV.WQTY26	,SCP_XLS_PSI_GLOBAL.WQTY27=PV.WQTY27	,SCP_XLS_PSI_GLOBAL.WQTY28=PV.WQTY28	,SCP_XLS_PSI_GLOBAL.WQTY29=PV.WQTY29	,SCP_XLS_PSI_GLOBAL.WQTY30=PV.WQTY30	,SCP_XLS_PSI_GLOBAL.WQTY31=PV.WQTY31	,SCP_XLS_PSI_GLOBAL.WQTY32=PV.WQTY32	,SCP_XLS_PSI_GLOBAL.WQTY33=PV.WQTY33	,SCP_XLS_PSI_GLOBAL.WQTY34=PV.WQTY34	,SCP_XLS_PSI_GLOBAL.WQTY35=PV.WQTY35	,SCP_XLS_PSI_GLOBAL.WQTY36=PV.WQTY36	,SCP_XLS_PSI_GLOBAL.WQTY37=PV.WQTY37	,SCP_XLS_PSI_GLOBAL.WQTY38=PV.WQTY38	,SCP_XLS_PSI_GLOBAL.WQTY39=PV.WQTY39	,SCP_XLS_PSI_GLOBAL.WQTY40=PV.WQTY40
        ,SCP_XLS_PSI_GLOBAL.WQTY41=PV.WQTY41	,SCP_XLS_PSI_GLOBAL.WQTY42=PV.WQTY42	,SCP_XLS_PSI_GLOBAL.WQTY43=PV.WQTY43	,SCP_XLS_PSI_GLOBAL.WQTY44=PV.WQTY44	,SCP_XLS_PSI_GLOBAL.WQTY45=PV.WQTY45	,SCP_XLS_PSI_GLOBAL.WQTY46=PV.WQTY46	,SCP_XLS_PSI_GLOBAL.WQTY47=PV.WQTY47	,SCP_XLS_PSI_GLOBAL.WQTY48=PV.WQTY48	,SCP_XLS_PSI_GLOBAL.WQTY49=PV.WQTY49	,SCP_XLS_PSI_GLOBAL.WQTY50=PV.WQTY50	,SCP_XLS_PSI_GLOBAL.WQTY51=PV.WQTY51	,SCP_XLS_PSI_GLOBAL.WQTY52=PV.WQTY52
        FROM SCP_XLS_PSI_GLOBAL XLS WITH(NOLOCK)
            INNER JOIN @XLS_PV_TABLE PV
                ON  XLS.DIVISION_ID         = PV.DIVISION_ID
                AND XLS.PLAN_START_YYYYMMDD = PV.PLAN_START_YYYYMMDD
                AND XLS.PLAN_TYPE           = PV.PLAN_TYPE
                AND XLS.SEQ                 = PV.SEQ
                AND XLS.OPERATION_GROUP     = PV.OPERATION_GROUP
                AND XLS.FROM_SITE           = PV.FROM_SITE
                AND XLS.ITEM_ID             = PV.ITEM_ID
                AND XLS.PROD_LINE           = PV.LINE_ID
                AND XLS.BOD_ID              = PV.BOD_ID
                AND XLS.MEASURE             = PV.MEASURE
                AND XLS.PROJECT_CODE        = PV.PROJECT_CODE
                AND XLS.CREATE_FROM_YYYYMMDD = PV.CREATE_FROM_YYYYMMDD

    ;

    -- 2026.06.15 Minyong Lee : I/F 수행된 버전 PLAN_MASTER ATTRIBUTE13에 마킹
    UPDATE SCP_OPT_ENG_PLAN_MASTER_SN
    SET ATTRIBUTE13 = @V_SCP_PLAN_DATE + ',' + @V_SCP_PLAN_TYPE + ',' + @V_SCP_PLAN_SEQ
    WHERE PLAN_ID = @V_PLAN_ID

    ------------------------------------------------------------------------
    -- 종료 LOG
	------------------------------------------------------------------------
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = @PLAN_START_YYYYMMDD+'@'+@V_PLAN_ID;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    ------------------------------------------------------------------------
    -- Data Insert End
    ------------------------------------------------------------------------
        COMMIT TRAN
	END TRY
	------------------------------------------------------------------------
    BEGIN CATCH
	------------------------------------------------------------------------
	--ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC;
	------------------------------------------------------------------------
        -- 본 프로시저의 SAVEPOINT로 롤백 후, 상위 프로시저의 TRANSACTION은 유지
        IF XACT_STATE() = -1
        BEGIN
            ROLLBACK;
        END
        ELSE IF XACT_STATE() = 1
        BEGIN
            ROLLBACK TRAN SP_OUTPUT_TRANS_ANL;
            COMMIT TRAN;
        END

        SET @V_MESSAGE_TEXT = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));

        IF @V_MESSAGE_TEXT IN (
            'I/F not executed because PLAN_TYPE is FN.',
            'No Order Production data to interface.'
        )
        BEGIN
            ------------------------------------------------------------------------
            -- 종료 LOG
	        ------------------------------------------------------------------------
            SET @v_log_type = 'END';
            SET @v_log_message = '########## END of procedure ##########';
            SET @v_description = @V_MESSAGE_TEXT+'@'+@PLAN_START_YYYYMMDD+'@'+@V_PLAN_ID
            SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        END
        ELSE
        BEGIN
	        ------------------------------------------------------------------------
              -- ERROR LOG
	        ------------------------------------------------------------------------
            SET @v_log_type = 'ERROR';
            SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
            SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE())+'@'+@PLAN_START_YYYYMMDD+'@'+@V_PLAN_ID
            SET @d_event_date = SYSDATETIME();
	        --SELECT '' + Convert(NVARCHAR(10), ERROR_NUMBER()) + '' + ERROR_MESSAGE();
	        ------------------------------------------------------------------------  
		    INSERT INTO scm_sys_log_batch (program_name
										    ,log_type
										    ,log_count
										    ,log_message
										    ,description
										    ,event_date
										    ,creation_date
										    ,created_by
										    ,last_update_date
										    ,last_updated_by)
		    VALUES (ERROR_PROCEDURE()
				    ,@v_log_type
				    ,NULL
				    ,@v_log_message
				    ,@v_description
				    ,SYSDATETIME()
				    ,SYSDATETIME()
				    ,ERROR_PROCEDURE()
				    ,SYSDATETIME()
				    ,ERROR_PROCEDURE());
	        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;	
	        ------------------------------------------------------------------------
        END;

        THROW;

    END CATCH

	------------------------------------------------------------------------

    ------------------------------------------------------------------------
  END;
