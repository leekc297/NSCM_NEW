


/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI02
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      : 
                 EXEC PR_SCP_XLS_ADD_XLSPSI02      @p_user_id             ='KTH'
                                                  ,@p_division_id         = '40'
                                                  ,@p_PLAN_START_YYYYMMDD = '2019225'
                                                  ,@p_PLAN_TYPE           ='PR'
                                                  ,@p_SEQ                 ='1'
                                                  ,@p_item_id             =''
                                                  ,@p_measure             ='PACK_PROD'
                                                  ,@p_xls_key1            ='468'

                                                  ,@p_WQTY01 = 0.0 ,@p_WQTY02  = 0.0 ,@p_WQTY03  = 0.0 ,@p_WQTY04  = 0.0 ,@p_WQTY05  = 0.0
                                                  ,@p_WQTY06 = 0.0 ,@p_WQTY07  = 0.0 ,@p_WQTY08  = 0.0 ,@p_WQTY09  = 0.0 ,@p_WQTY10  = 0.0
                                                  ,@p_WQTY11 = 0.0 ,@p_WQTY12  = 0.0 ,@p_WQTY13  = 0.0 ,@p_WQTY14  = 0.0 ,@p_WQTY15  = 0.0
                                                  ,@p_WQTY16 = 0.0 ,@p_WQTY17  = 0.0 ,@p_WQTY18  = 0.0 ,@p_WQTY19  = 0.0 ,@p_WQTY20  = 0.0
                                                  ,@p_WQTY21 = 0.0 ,@p_WQTY22  = 0.0 ,@p_WQTY23  = 0.0 ,@p_WQTY24  = 0.0 ,@p_WQTY25  = 0.0
                                                  ,@p_WQTY26 = 0.0 ,@p_WQTY27  = 0.0 ,@p_WQTY28  = 0.0 ,@p_WQTY29  = 0.0 ,@p_WQTY30  = 0.0
                                                  ,@p_WQTY31 = 0.0 ,@p_WQTY32  = 0.0 ,@p_WQTY33  = 0.0 ,@p_WQTY34  = 0.0 ,@p_WQTY35  = 0.0
                                                  ,@p_WQTY36 = 0.0 ,@p_WQTY37  = 0.0 ,@p_WQTY38  = 0.0 ,@p_WQTY39  = 0.0 ,@p_WQTY40  = 0.0
                                                  ,@p_WQTY41 = 0.0 ,@p_WQTY42  = 0.0 ,@p_WQTY43  = 0.0 ,@p_WQTY44  = 0.0 ,@p_WQTY45  = 0.0
                                                  ,@p_WQTY46 = 0.0 ,@p_WQTY47  = 0.0 ,@p_WQTY48  = 0.0 ,@p_WQTY49  = 0.0 ,@p_WQTY50  = 0.0
                                                  ,@p_WQTY51 = 0.0 ,@p_WQTY52  = 0.0


 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.02.27   KTH            Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.04.08   KTH            LINE LOAD율 수정
 * 2019.05.24   KTH            출하계획 수정시 특정 요일에 저장(@x_DAYOFWEEK_NO) 1~7(일~토) 목(5)
 * 2019.05.24   KTH            FROZEN 구간 DATA 미반영 로직 추가(반올림 4일 이상 일 경우)
 * 2019.06.03   KTH            저장후 시물레이션 데이터 UPDATE 로직 변경
 * 2019.06.05   KTH            출하(FG/SEMI) FROZEN DATA 미반영 구간 'PR'추가
 * 2019.06.12   KTH            Line Load율 로직 변경
 * 2019.06.14   KTH            생산 FROZEN 구간 전체 수정가능하도록 반영
 * 2019.06.27   KTH            저장로직(WEEK --> DAY) 변경
 * 2019.07.06   KTH            입력된 버전과 현재 버전이 다를 경우 RETURN  
 * 2019.07.16   KTH            plan_type IN  ('MA','SE','FN')  일 경우 FROZEN 구간 수정 금지 로직 추가
 * 2020.04.08   KTH            SCP_ANL_SHIPMENT_PLAN_FIX(FG) 변경조건 추가 (PROJECT_CODE)
 * 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가
 * 2021.04.21   KSW            C20210420-000399-소형 Pack 시뮬레이터 Cell - Packer 반제품 Shipment 저장 가능하도록 수정
                               - CELL_SHIP_PLAN (Ship Plan(SCP)) Measure 를 SEMI_SHIP_PLAN 에 준하여 처리하는 로직을 추가
 * 2021.08.25   KSW            PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
 * 2021.10.25   KSW            튜닝개선요청에 따른 변경
 * 2021.11.02   KSW            C20211101-000452 - Shipment plan Ship Frozen 해제(PR, MA)
 * 2021.12.06   KSW            SEMI SHIP PLAN(CELL_SHIP_PLAN) 에 대한 PR/MA Frozen 구간해제
 * 2022.05.02   KSW            Daily/Monthly Bucket 변경건 적용 :: 변경된 Daily 건만 저장하는 로직추가
 * 2022.07.22   KSW			   PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용 - SEMI_SHIP_PLAN case 추가
 * 2022.08.18   KSW            PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 소형 PACK 시뮬레이터 :: Daily & Monthly Bucket 2차 개선적용
 * 2022.09.21	KSW			   PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 소형SCM개선요청사항 적용
 * 2024.08.30	KS	K			   2년차 사업계획 호출파라미터 구조오류 수정
 */



CREATE PROCEDURE [dbo].[PR_SCP_XLS_ADD_XLSPSI02]
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

 ,@p_QTY365 INT = 0.0 ,@p_QTY366  INT = 0.0 ,@p_QTY367  INT = 0.0 ,@p_QTY368  INT = 0.0 ,@p_QTY369  INT = 0.0 
 ,@p_QTY370	INT = 0.0 ,@p_QTY371  INT = 0.0 ,@p_QTY372	INT = 0.0 ,@p_QTY373  INT = 0.0 ,@p_QTY374  INT = 0.0 
 ,@p_QTY375	INT = 0.0 ,@p_QTY376  INT = 0.0 ,@p_QTY377	INT = 0.0 ,@p_QTY378  INT = 0.0 ,@p_QTY379  INT = 0.0 
 ,@p_QTY380	INT = 0.0 ,@p_QTY381  INT = 0.0 ,@p_QTY382	INT = 0.0 ,@p_QTY383  INT = 0.0 ,@p_QTY384  INT = 0.0 
 ,@p_QTY385	INT = 0.0 ,@p_QTY386  INT = 0.0 ,@p_QTY387	INT = 0.0 ,@p_QTY388  INT = 0.0 ,@p_QTY389  INT = 0.0 
 ,@p_QTY390	INT = 0.0 ,@p_QTY391  INT = 0.0 ,@p_QTY392	INT = 0.0 ,@p_QTY393  INT = 0.0 ,@p_QTY394  INT = 0.0 
 ,@p_QTY395	INT = 0.0 ,@p_QTY396  INT = 0.0 ,@p_QTY397	INT = 0.0 ,@p_QTY398  INT = 0.0 ,@p_QTY399  INT = 0.0 
 ,@p_QTY400 INT = 0.0 
 ,@p_QTY401 INT = 0.0 ,@p_QTY402  INT = 0.0 ,@p_QTY403  INT = 0.0 ,@p_QTY404  INT = 0.0 ,@p_QTY405  INT = 0.0
 ,@p_QTY406	INT = 0.0 ,@p_QTY407  INT = 0.0 ,@p_QTY408  INT = 0.0 ,@p_QTY409  INT = 0.0 ,@p_QTY410  INT = 0.0
 ,@p_QTY411 INT = 0.0 ,@p_QTY412  INT = 0.0 ,@p_QTY413  INT = 0.0 ,@p_QTY414  INT = 0.0 ,@p_QTY415  INT = 0.0
 ,@p_QTY416	INT = 0.0 ,@p_QTY417  INT = 0.0 ,@p_QTY418  INT = 0.0 ,@p_QTY419  INT = 0.0 ,@p_QTY420  INT = 0.0
 ,@p_QTY421 INT = 0.0 ,@p_QTY422  INT = 0.0 ,@p_QTY423  INT = 0.0 ,@p_QTY424  INT = 0.0 ,@p_QTY425  INT = 0.0
 ,@p_QTY426	INT = 0.0 ,@p_QTY427  INT = 0.0 ,@p_QTY428  INT = 0.0 ,@p_QTY429  INT = 0.0 ,@p_QTY430  INT = 0.0
 ,@p_QTY431 INT = 0.0 ,@p_QTY432  INT = 0.0 ,@p_QTY433  INT = 0.0 ,@p_QTY434  INT = 0.0 ,@p_QTY435  INT = 0.0
 ,@p_QTY436	INT = 0.0 ,@p_QTY437  INT = 0.0 ,@p_QTY438  INT = 0.0 ,@p_QTY439  INT = 0.0 ,@p_QTY440  INT = 0.0
 ,@p_QTY441 INT = 0.0 ,@p_QTY442  INT = 0.0 ,@p_QTY443  INT = 0.0 ,@p_QTY444  INT = 0.0 ,@p_QTY445  INT = 0.0
 ,@p_QTY446	INT = 0.0 ,@p_QTY447  INT = 0.0 ,@p_QTY448  INT = 0.0 ,@p_QTY449  INT = 0.0 ,@p_QTY450  INT = 0.0
 ,@p_QTY451 INT = 0.0 ,@p_QTY452  INT = 0.0 ,@p_QTY453  INT = 0.0 ,@p_QTY454  INT = 0.0 ,@p_QTY455  INT = 0.0
 ,@p_QTY456	INT = 0.0 ,@p_QTY457  INT = 0.0 ,@p_QTY458  INT = 0.0 ,@p_QTY459  INT = 0.0 ,@p_QTY460  INT = 0.0
 ,@p_QTY461 INT = 0.0 ,@p_QTY462  INT = 0.0 ,@p_QTY463  INT = 0.0 ,@p_QTY464  INT = 0.0 ,@p_QTY465  INT = 0.0
 ,@p_QTY466	INT = 0.0 ,@p_QTY467  INT = 0.0 ,@p_QTY468  INT = 0.0 ,@p_QTY469  INT = 0.0 ,@p_QTY470  INT = 0.0
 ,@p_QTY471 INT = 0.0 ,@p_QTY472  INT = 0.0 ,@p_QTY473  INT = 0.0 ,@p_QTY474  INT = 0.0 ,@p_QTY475  INT = 0.0
 ,@p_QTY476	INT = 0.0 ,@p_QTY477  INT = 0.0 ,@p_QTY478  INT = 0.0 ,@p_QTY479  INT = 0.0 ,@p_QTY480  INT = 0.0
 ,@p_QTY481 INT = 0.0 ,@p_QTY482  INT = 0.0 ,@p_QTY483  INT = 0.0 ,@p_QTY484  INT = 0.0 ,@p_QTY485  INT = 0.0
 ,@p_QTY486	INT = 0.0 ,@p_QTY487  INT = 0.0 ,@p_QTY488  INT = 0.0 ,@p_QTY489  INT = 0.0 ,@p_QTY490  INT = 0.0
 ,@p_QTY491 INT = 0.0 ,@p_QTY492  INT = 0.0 ,@p_QTY493  INT = 0.0 ,@p_QTY494  INT = 0.0 ,@p_QTY495  INT = 0.0
 ,@p_QTY496	INT = 0.0 ,@p_QTY497  INT = 0.0 ,@p_QTY498  INT = 0.0 ,@p_QTY499  INT = 0.0 ,@p_QTY500  INT = 0.0

 ,@p_QTY501 INT = 0.0 ,@p_QTY502  INT = 0.0 ,@p_QTY503  INT = 0.0 ,@p_QTY504  INT = 0.0 ,@p_QTY505  INT = 0.0
 ,@p_QTY506	INT = 0.0 ,@p_QTY507  INT = 0.0 ,@p_QTY508  INT = 0.0 ,@p_QTY509  INT = 0.0 ,@p_QTY510  INT = 0.0
 ,@p_QTY511 INT = 0.0 ,@p_QTY512  INT = 0.0 ,@p_QTY513  INT = 0.0 ,@p_QTY514  INT = 0.0 ,@p_QTY515  INT = 0.0
 ,@p_QTY516	INT = 0.0 ,@p_QTY517  INT = 0.0 ,@p_QTY518  INT = 0.0 ,@p_QTY519  INT = 0.0 ,@p_QTY520  INT = 0.0
 ,@p_QTY521 INT = 0.0 ,@p_QTY522  INT = 0.0 ,@p_QTY523  INT = 0.0 ,@p_QTY524  INT = 0.0 ,@p_QTY525  INT = 0.0
 ,@p_QTY526	INT = 0.0 ,@p_QTY527  INT = 0.0 ,@p_QTY528  INT = 0.0 ,@p_QTY529  INT = 0.0 ,@p_QTY530  INT = 0.0
 ,@p_QTY531 INT = 0.0 ,@p_QTY532  INT = 0.0 ,@p_QTY533  INT = 0.0 ,@p_QTY534  INT = 0.0 ,@p_QTY535  INT = 0.0
 ,@p_QTY536	INT = 0.0 ,@p_QTY537  INT = 0.0 ,@p_QTY538  INT = 0.0 ,@p_QTY539  INT = 0.0 ,@p_QTY540  INT = 0.0
 ,@p_QTY541 INT = 0.0 ,@p_QTY542  INT = 0.0 ,@p_QTY543  INT = 0.0 ,@p_QTY544  INT = 0.0 ,@p_QTY545  INT = 0.0
 ,@p_QTY546	INT = 0.0 ,@p_QTY547  INT = 0.0 ,@p_QTY548  INT = 0.0 ,@p_QTY549  INT = 0.0 ,@p_QTY550  INT = 0.0
 ,@p_QTY551 INT = 0.0 ,@p_QTY552  INT = 0.0 ,@p_QTY553  INT = 0.0 ,@p_QTY554  INT = 0.0 ,@p_QTY555  INT = 0.0
 ,@p_QTY556	INT = 0.0 ,@p_QTY557  INT = 0.0 ,@p_QTY558  INT = 0.0 ,@p_QTY559  INT = 0.0 ,@p_QTY560  INT = 0.0
 ,@p_QTY561 INT = 0.0 ,@p_QTY562  INT = 0.0 ,@p_QTY563  INT = 0.0 ,@p_QTY564  INT = 0.0 ,@p_QTY565  INT = 0.0
 ,@p_QTY566	INT = 0.0 ,@p_QTY567  INT = 0.0 ,@p_QTY568  INT = 0.0 ,@p_QTY569  INT = 0.0 ,@p_QTY570  INT = 0.0
 ,@p_QTY571 INT = 0.0 ,@p_QTY572  INT = 0.0 ,@p_QTY573  INT = 0.0 ,@p_QTY574  INT = 0.0 ,@p_QTY575  INT = 0.0
 ,@p_QTY576	INT = 0.0 ,@p_QTY577  INT = 0.0 ,@p_QTY578  INT = 0.0 ,@p_QTY579  INT = 0.0 ,@p_QTY580  INT = 0.0
 ,@p_QTY581 INT = 0.0 ,@p_QTY582  INT = 0.0 ,@p_QTY583  INT = 0.0 ,@p_QTY584  INT = 0.0 ,@p_QTY585  INT = 0.0
 ,@p_QTY586	INT = 0.0 ,@p_QTY587  INT = 0.0 ,@p_QTY588  INT = 0.0 ,@p_QTY589  INT = 0.0 ,@p_QTY590  INT = 0.0
 ,@p_QTY591 INT = 0.0 ,@p_QTY592  INT = 0.0 ,@p_QTY593  INT = 0.0 ,@p_QTY594  INT = 0.0 ,@p_QTY595  INT = 0.0
 ,@p_QTY596	INT = 0.0 ,@p_QTY597  INT = 0.0 ,@p_QTY598  INT = 0.0 ,@p_QTY599  INT = 0.0 ,@p_QTY600  INT = 0.0

 ,@p_QTY601 INT = 0.0 ,@p_QTY602  INT = 0.0 ,@p_QTY603  INT = 0.0 ,@p_QTY604  INT = 0.0 ,@p_QTY605  INT = 0.0
 ,@p_QTY606	INT = 0.0 ,@p_QTY607  INT = 0.0 ,@p_QTY608  INT = 0.0 ,@p_QTY609  INT = 0.0 ,@p_QTY610  INT = 0.0
 ,@p_QTY611 INT = 0.0 ,@p_QTY612  INT = 0.0 ,@p_QTY613  INT = 0.0 ,@p_QTY614  INT = 0.0 ,@p_QTY615  INT = 0.0
 ,@p_QTY616	INT = 0.0 ,@p_QTY617  INT = 0.0 ,@p_QTY618  INT = 0.0 ,@p_QTY619  INT = 0.0 ,@p_QTY620  INT = 0.0
 ,@p_QTY621 INT = 0.0 ,@p_QTY622  INT = 0.0 ,@p_QTY623  INT = 0.0 ,@p_QTY624  INT = 0.0 ,@p_QTY625  INT = 0.0
 ,@p_QTY626	INT = 0.0 ,@p_QTY627  INT = 0.0 ,@p_QTY628  INT = 0.0 ,@p_QTY629  INT = 0.0 ,@p_QTY630  INT = 0.0
 ,@p_QTY631 INT = 0.0 ,@p_QTY632  INT = 0.0 ,@p_QTY633  INT = 0.0 ,@p_QTY634  INT = 0.0 ,@p_QTY635  INT = 0.0
 ,@p_QTY636	INT = 0.0 ,@p_QTY637  INT = 0.0 ,@p_QTY638  INT = 0.0 ,@p_QTY639  INT = 0.0 ,@p_QTY640  INT = 0.0
 ,@p_QTY641 INT = 0.0 ,@p_QTY642  INT = 0.0 ,@p_QTY643  INT = 0.0 ,@p_QTY644  INT = 0.0 ,@p_QTY645  INT = 0.0
 ,@p_QTY646	INT = 0.0 ,@p_QTY647  INT = 0.0 ,@p_QTY648  INT = 0.0 ,@p_QTY649  INT = 0.0 ,@p_QTY650  INT = 0.0
 ,@p_QTY651 INT = 0.0 ,@p_QTY652  INT = 0.0 ,@p_QTY653  INT = 0.0 ,@p_QTY654  INT = 0.0 ,@p_QTY655  INT = 0.0
 ,@p_QTY656	INT = 0.0 ,@p_QTY657  INT = 0.0 ,@p_QTY658  INT = 0.0 ,@p_QTY659  INT = 0.0 ,@p_QTY660  INT = 0.0
 ,@p_QTY661 INT = 0.0 ,@p_QTY662  INT = 0.0 ,@p_QTY663  INT = 0.0 ,@p_QTY664  INT = 0.0 ,@p_QTY665  INT = 0.0
 ,@p_QTY666	INT = 0.0 ,@p_QTY667  INT = 0.0 ,@p_QTY668  INT = 0.0 ,@p_QTY669  INT = 0.0 ,@p_QTY670  INT = 0.0
 ,@p_QTY671 INT = 0.0 ,@p_QTY672  INT = 0.0 ,@p_QTY673  INT = 0.0 ,@p_QTY674  INT = 0.0 ,@p_QTY675  INT = 0.0
 ,@p_QTY676	INT = 0.0 ,@p_QTY677  INT = 0.0 ,@p_QTY678  INT = 0.0 ,@p_QTY679  INT = 0.0 ,@p_QTY680  INT = 0.0
 ,@p_QTY681 INT = 0.0 ,@p_QTY682  INT = 0.0 ,@p_QTY683  INT = 0.0 ,@p_QTY684  INT = 0.0 ,@p_QTY685  INT = 0.0
 ,@p_QTY686	INT = 0.0 ,@p_QTY687  INT = 0.0 ,@p_QTY688  INT = 0.0 ,@p_QTY689  INT = 0.0 ,@p_QTY690  INT = 0.0
 ,@p_QTY691 INT = 0.0 ,@p_QTY692  INT = 0.0 ,@p_QTY693  INT = 0.0 ,@p_QTY694  INT = 0.0 ,@p_QTY695  INT = 0.0
 ,@p_QTY696	INT = 0.0 ,@p_QTY697  INT = 0.0 ,@p_QTY698  INT = 0.0 ,@p_QTY699  INT = 0.0 ,@p_QTY700  INT = 0.0

 ,@p_QTY701 INT = 0.0 ,@p_QTY702  INT = 0.0 ,@p_QTY703  INT = 0.0 ,@p_QTY704  INT = 0.0 ,@p_QTY705  INT = 0.0
 ,@p_QTY706	INT = 0.0 ,@p_QTY707  INT = 0.0 ,@p_QTY708  INT = 0.0 ,@p_QTY709  INT = 0.0 ,@p_QTY710  INT = 0.0
 ,@p_QTY711 INT = 0.0 ,@p_QTY712  INT = 0.0 ,@p_QTY713  INT = 0.0 ,@p_QTY714  INT = 0.0 ,@p_QTY715  INT = 0.0
 ,@p_QTY716	INT = 0.0 ,@p_QTY717  INT = 0.0 ,@p_QTY718  INT = 0.0 ,@p_QTY719  INT = 0.0 ,@p_QTY720  INT = 0.0
 ,@p_QTY721 INT = 0.0 ,@p_QTY722  INT = 0.0 ,@p_QTY723  INT = 0.0 ,@p_QTY724  INT = 0.0 ,@p_QTY725  INT = 0.0
 ,@p_QTY726	INT = 0.0 ,@p_QTY727  INT = 0.0	,@p_QTY728 INT = 0.0 		
		
 )                                     
AS                                     

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_XLS_ADD_XLSPSI02';
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
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
    
    
        -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';     

    --PRINT @p_plan_type
    -- PLAN_TYPE이 FN일경우 수정금지 RETURN
    if @p_plan_type = 'FN'            
      return -1   

    -------------------------------------------------------------------------------------------------------------------------------------------------------         
    -- 입력된 버전과 현재 버전이 다를 경우 RETURN 
    -------------------------------------------------------------------------------------------------------------------------------------------------------
        DECLARE   @v_division_id          NVARCHAR(030) = @p_division_id
                , @v_plan_start_yyyymmdd  NVARCHAR(008) = @p_plan_start_yyyymmdd
                , @v_plan_type            NVARCHAR(050) = @p_plan_type
                , @v_seq                  INT           = @p_seq

        SELECT TOP 1  @v_division_id          = DIVISION_ID
                    , @v_plan_start_yyyymmdd  = PLAN_START_YYYYMMDD
                    , @v_plan_type            = PLAN_TYPE
                    , @v_seq                  = SEQ
          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)
		 WHERE PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD) FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)) 	--  * 2022.09.21	KSW			  소형SCM개선요청사항 적용
		 order by creation_date desc

      IF (@p_division_id <> @v_division_id OR @p_plan_start_yyyymmdd <> @v_plan_start_yyyymmdd OR @p_plan_type <> @v_plan_type OR @p_seq <> @v_seq)  
		  BEGIN
			PRINT 'PLAN UNMATCHED'
        return -1   
		  END
	  ELSE
		PRINT 'PLAN MATCHED'
    -------------------------------------------------------------------------------------------------------------------------------------------------------



      --PRINT @p_plan_type
    BEGIN TRY
      BEGIN         

            
            
			DECLARE @rows INT;  
			DECLARE @p_create_from_yyyymmdd  NVARCHAR(0008);
			DECLARE @p_create_to_yyyymmdd    NVARCHAR(0008);

			SET @p_create_from_yyyymmdd = @p_plan_start_yyyymmdd;
			SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112);

			--  Plan End Date
			DECLARE @v_pet_date		NVARCHAR(12) = '';
			DECLARE @v_bp_flag		NVARCHAR(8) = '';
			DECLARE @v_bp_days		INT = 0;
			DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';

			SELECT @v_pet_date = p.horizon_end_date,
				   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
				   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
			FROM   dbo.scm_mst_plan p WITH(NOLOCK)
			WHERE  p.division_id = @p_division_id
			AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
			;

			SELECT @v_pet_date "@v_pet_date", @v_bp_flag "@v_bp_flag", @v_bp_days "@v_bp_days" --TEST

			-------------------------------------------------------------------------------------------------------------
            -- 1 year 저장 프로시저 실행
			-------------------------------------------------------------------------------------------------------------
			EXEC @rows = PR_SCP_XLS_ADD_XLSPSI02_S     @p_USER_ID             = @p_user_id
                                                 ,@p_division_id         = @p_division_id
                                                 ,@p_PLAN_START_YYYYMMDD = @p_PLAN_START_YYYYMMDD
                                                 ,@p_PLAN_TYPE           = @p_PLAN_TYPE
                                                 ,@p_SEQ                 = @p_seq
                                                 ,@p_item_id             = @p_item_id
                                                 ,@p_measure             = @p_measure
                                                 ,@p_xls_key1            = @p_xls_key1
												 ,@p_LoadRatio			 = @p_LoadRatio
												 ,@p_create_from_yyyymmdd = @p_create_from_yyyymmdd
												 ,@p_create_to_yyyymmdd   = @p_create_to_yyyymmdd                                                 
												 ,@p_QTY001  = @p_QTY001 ,@p_QTY002   = @p_QTY002 ,@p_QTY003   = @p_QTY003 ,@p_QTY004   = @p_QTY004 ,@p_QTY005   = @p_QTY005
												 ,@p_QTY006	 = @p_QTY006 ,@p_QTY007   = @p_QTY007 ,@p_QTY008   = @p_QTY008 ,@p_QTY009   = @p_QTY009 ,@p_QTY010   = @p_QTY010
												 ,@p_QTY011  = @p_QTY011 ,@p_QTY012   = @p_QTY012 ,@p_QTY013   = @p_QTY013 ,@p_QTY014   = @p_QTY014 ,@p_QTY015   = @p_QTY015
												 ,@p_QTY016	 = @p_QTY016 ,@p_QTY017   = @p_QTY017 ,@p_QTY018   = @p_QTY018 ,@p_QTY019   = @p_QTY019 ,@p_QTY020   = @p_QTY020
												 ,@p_QTY021  = @p_QTY021 ,@p_QTY022   = @p_QTY022 ,@p_QTY023   = @p_QTY023 ,@p_QTY024   = @p_QTY024 ,@p_QTY025   = @p_QTY025
												 ,@p_QTY026	 = @p_QTY026 ,@p_QTY027   = @p_QTY027 ,@p_QTY028   = @p_QTY028 ,@p_QTY029   = @p_QTY029 ,@p_QTY030   = @p_QTY030
												 ,@p_QTY031  = @p_QTY031 ,@p_QTY032   = @p_QTY032 ,@p_QTY033   = @p_QTY033 ,@p_QTY034   = @p_QTY034 ,@p_QTY035   = @p_QTY035
												 ,@p_QTY036	 = @p_QTY036 ,@p_QTY037   = @p_QTY037 ,@p_QTY038   = @p_QTY038 ,@p_QTY039   = @p_QTY039 ,@p_QTY040   = @p_QTY040
												 ,@p_QTY041  = @p_QTY041 ,@p_QTY042   = @p_QTY042 ,@p_QTY043   = @p_QTY043 ,@p_QTY044   = @p_QTY044 ,@p_QTY045   = @p_QTY045
												 ,@p_QTY046	 = @p_QTY046 ,@p_QTY047   = @p_QTY047 ,@p_QTY048   = @p_QTY048 ,@p_QTY049   = @p_QTY049 ,@p_QTY050   = @p_QTY050
												 ,@p_QTY051  = @p_QTY051 ,@p_QTY052   = @p_QTY052 ,@p_QTY053   = @p_QTY053 ,@p_QTY054   = @p_QTY054 ,@p_QTY055   = @p_QTY055
												 ,@p_QTY056	 = @p_QTY056 ,@p_QTY057   = @p_QTY057 ,@p_QTY058   = @p_QTY058 ,@p_QTY059   = @p_QTY059 ,@p_QTY060   = @p_QTY060
												 ,@p_QTY061  = @p_QTY061 ,@p_QTY062   = @p_QTY062 ,@p_QTY063   = @p_QTY063 ,@p_QTY064   = @p_QTY064 ,@p_QTY065   = @p_QTY065
												 ,@p_QTY066	 = @p_QTY066 ,@p_QTY067   = @p_QTY067 ,@p_QTY068   = @p_QTY068 ,@p_QTY069   = @p_QTY069 ,@p_QTY070   = @p_QTY070
												 ,@p_QTY071  = @p_QTY071 ,@p_QTY072   = @p_QTY072 ,@p_QTY073   = @p_QTY073 ,@p_QTY074   = @p_QTY074 ,@p_QTY075   = @p_QTY075
												 ,@p_QTY076	 = @p_QTY076 ,@p_QTY077   = @p_QTY077 ,@p_QTY078   = @p_QTY078 ,@p_QTY079   = @p_QTY079 ,@p_QTY080   = @p_QTY080
												 ,@p_QTY081  = @p_QTY081 ,@p_QTY082   = @p_QTY082 ,@p_QTY083   = @p_QTY083 ,@p_QTY084   = @p_QTY084 ,@p_QTY085   = @p_QTY085
												 ,@p_QTY086	 = @p_QTY086 ,@p_QTY087   = @p_QTY087 ,@p_QTY088   = @p_QTY088 ,@p_QTY089   = @p_QTY089 ,@p_QTY090   = @p_QTY090
												 ,@p_QTY091  = @p_QTY091 ,@p_QTY092   = @p_QTY092 ,@p_QTY093   = @p_QTY093 ,@p_QTY094   = @p_QTY094 ,@p_QTY095   = @p_QTY095
												 ,@p_QTY096	 = @p_QTY096 ,@p_QTY097   = @p_QTY097 ,@p_QTY098   = @p_QTY098 ,@p_QTY099   = @p_QTY099 ,@p_QTY100   = @p_QTY100

												 ,@p_QTY101  = @p_QTY101 ,@p_QTY102   = @p_QTY102 ,@p_QTY103   = @p_QTY103 ,@p_QTY104  = @p_QTY104 ,@p_QTY105  = @p_QTY105
												 ,@p_QTY106	 = @p_QTY106 ,@p_QTY107   = @p_QTY107 ,@p_QTY108   = @p_QTY108 ,@p_QTY109  = @p_QTY109 ,@p_QTY110  = @p_QTY110
												 ,@p_QTY111  = @p_QTY111 ,@p_QTY112   = @p_QTY112 ,@p_QTY113   = @p_QTY113 ,@p_QTY114  = @p_QTY114 ,@p_QTY115  = @p_QTY115
												 ,@p_QTY116	 = @p_QTY116 ,@p_QTY117   = @p_QTY117 ,@p_QTY118   = @p_QTY118 ,@p_QTY119  = @p_QTY119 ,@p_QTY120  = @p_QTY120
												 ,@p_QTY121  = @p_QTY121 ,@p_QTY122   = @p_QTY122 ,@p_QTY123   = @p_QTY123 ,@p_QTY124  = @p_QTY124 ,@p_QTY125  = @p_QTY125
												 ,@p_QTY126	 = @p_QTY126 ,@p_QTY127   = @p_QTY127 ,@p_QTY128   = @p_QTY128 ,@p_QTY129  = @p_QTY129 ,@p_QTY130  = @p_QTY130
												 ,@p_QTY131  = @p_QTY131 ,@p_QTY132   = @p_QTY132 ,@p_QTY133   = @p_QTY133 ,@p_QTY134  = @p_QTY134 ,@p_QTY135  = @p_QTY135
												 ,@p_QTY136	 = @p_QTY136 ,@p_QTY137   = @p_QTY137 ,@p_QTY138   = @p_QTY138 ,@p_QTY139  = @p_QTY139 ,@p_QTY140  = @p_QTY140
												 ,@p_QTY141  = @p_QTY141 ,@p_QTY142   = @p_QTY142 ,@p_QTY143   = @p_QTY143 ,@p_QTY144  = @p_QTY144 ,@p_QTY145  = @p_QTY145
												 ,@p_QTY146	 = @p_QTY146 ,@p_QTY147   = @p_QTY147 ,@p_QTY148   = @p_QTY148 ,@p_QTY149  = @p_QTY149 ,@p_QTY150  = @p_QTY150
												 ,@p_QTY151  = @p_QTY151 ,@p_QTY152   = @p_QTY152 ,@p_QTY153   = @p_QTY153 ,@p_QTY154  = @p_QTY154 ,@p_QTY155  = @p_QTY155
												 ,@p_QTY156	 = @p_QTY156 ,@p_QTY157   = @p_QTY157 ,@p_QTY158   = @p_QTY158 ,@p_QTY159  = @p_QTY159 ,@p_QTY160  = @p_QTY160
												 ,@p_QTY161  = @p_QTY161 ,@p_QTY162   = @p_QTY162 ,@p_QTY163   = @p_QTY163 ,@p_QTY164  = @p_QTY164 ,@p_QTY165  = @p_QTY165
												 ,@p_QTY166	 = @p_QTY166 ,@p_QTY167   = @p_QTY167 ,@p_QTY168   = @p_QTY168 ,@p_QTY169  = @p_QTY169 ,@p_QTY170  = @p_QTY170
												 ,@p_QTY171  = @p_QTY171 ,@p_QTY172   = @p_QTY172 ,@p_QTY173   = @p_QTY173 ,@p_QTY174  = @p_QTY174 ,@p_QTY175  = @p_QTY175
												 ,@p_QTY176	 = @p_QTY176 ,@p_QTY177   = @p_QTY177 ,@p_QTY178   = @p_QTY178 ,@p_QTY179  = @p_QTY179 ,@p_QTY180  = @p_QTY180
												 ,@p_QTY181  = @p_QTY181 ,@p_QTY182   = @p_QTY182 ,@p_QTY183   = @p_QTY183 ,@p_QTY184  = @p_QTY184 ,@p_QTY185  = @p_QTY185
												 ,@p_QTY186	 = @p_QTY186 ,@p_QTY187   = @p_QTY187 ,@p_QTY188   = @p_QTY188 ,@p_QTY189  = @p_QTY189 ,@p_QTY190  = @p_QTY190
												 ,@p_QTY191  = @p_QTY191 ,@p_QTY192   = @p_QTY192 ,@p_QTY193   = @p_QTY193 ,@p_QTY194  = @p_QTY194 ,@p_QTY195  = @p_QTY195
												 ,@p_QTY196	 = @p_QTY196 ,@p_QTY197   = @p_QTY197 ,@p_QTY198   = @p_QTY198 ,@p_QTY199  = @p_QTY199 ,@p_QTY200  = @p_QTY200

												 ,@p_QTY201  = @p_QTY201 ,@p_QTY202  = @p_QTY202 ,@p_QTY203  = @p_QTY203 ,@p_QTY204  = @p_QTY204 ,@p_QTY205  = @p_QTY205
												 ,@p_QTY206	 = @p_QTY206 ,@p_QTY207  = @p_QTY207 ,@p_QTY208  = @p_QTY208 ,@p_QTY209  = @p_QTY209 ,@p_QTY210  = @p_QTY210
												 ,@p_QTY211  = @p_QTY211 ,@p_QTY212  = @p_QTY212 ,@p_QTY213  = @p_QTY213 ,@p_QTY214  = @p_QTY214 ,@p_QTY215  = @p_QTY215
												 ,@p_QTY216	 = @p_QTY216 ,@p_QTY217  = @p_QTY217 ,@p_QTY218  = @p_QTY218 ,@p_QTY219  = @p_QTY219 ,@p_QTY220  = @p_QTY220
												 ,@p_QTY221  = @p_QTY221 ,@p_QTY222  = @p_QTY222 ,@p_QTY223  = @p_QTY223 ,@p_QTY224  = @p_QTY224 ,@p_QTY225  = @p_QTY225
												 ,@p_QTY226	 = @p_QTY226 ,@p_QTY227  = @p_QTY227 ,@p_QTY228  = @p_QTY228 ,@p_QTY229  = @p_QTY229 ,@p_QTY230  = @p_QTY230
												 ,@p_QTY231  = @p_QTY231 ,@p_QTY232  = @p_QTY232 ,@p_QTY233  = @p_QTY233 ,@p_QTY234  = @p_QTY234 ,@p_QTY235  = @p_QTY235
												 ,@p_QTY236	 = @p_QTY236 ,@p_QTY237  = @p_QTY237 ,@p_QTY238  = @p_QTY238 ,@p_QTY239  = @p_QTY239 ,@p_QTY240  = @p_QTY240
												 ,@p_QTY241  = @p_QTY241 ,@p_QTY242  = @p_QTY242 ,@p_QTY243  = @p_QTY243 ,@p_QTY244  = @p_QTY244 ,@p_QTY245  = @p_QTY245
												 ,@p_QTY246	 = @p_QTY246 ,@p_QTY247  = @p_QTY247 ,@p_QTY248  = @p_QTY248 ,@p_QTY249  = @p_QTY249 ,@p_QTY250  = @p_QTY250
												 ,@p_QTY251  = @p_QTY251 ,@p_QTY252  = @p_QTY252 ,@p_QTY253  = @p_QTY253 ,@p_QTY254  = @p_QTY254 ,@p_QTY255  = @p_QTY255
												 ,@p_QTY256	 = @p_QTY256 ,@p_QTY257  = @p_QTY257 ,@p_QTY258  = @p_QTY258 ,@p_QTY259  = @p_QTY259 ,@p_QTY260  = @p_QTY260
												 ,@p_QTY261  = @p_QTY261 ,@p_QTY262  = @p_QTY262 ,@p_QTY263  = @p_QTY263 ,@p_QTY264  = @p_QTY264 ,@p_QTY265  = @p_QTY265
												 ,@p_QTY266	 = @p_QTY266 ,@p_QTY267  = @p_QTY267 ,@p_QTY268  = @p_QTY268 ,@p_QTY269  = @p_QTY269 ,@p_QTY270  = @p_QTY270
												 ,@p_QTY271  = @p_QTY271 ,@p_QTY272  = @p_QTY272 ,@p_QTY273  = @p_QTY273 ,@p_QTY274  = @p_QTY274 ,@p_QTY275  = @p_QTY275
												 ,@p_QTY276	 = @p_QTY276 ,@p_QTY277  = @p_QTY277 ,@p_QTY278  = @p_QTY278 ,@p_QTY279  = @p_QTY279 ,@p_QTY280  = @p_QTY280
												 ,@p_QTY281  = @p_QTY281 ,@p_QTY282  = @p_QTY282 ,@p_QTY283  = @p_QTY283 ,@p_QTY284  = @p_QTY284 ,@p_QTY285  = @p_QTY285
												 ,@p_QTY286	 = @p_QTY286 ,@p_QTY287  = @p_QTY287 ,@p_QTY288  = @p_QTY288 ,@p_QTY289  = @p_QTY289 ,@p_QTY290  = @p_QTY290
												 ,@p_QTY291  = @p_QTY291 ,@p_QTY292  = @p_QTY292 ,@p_QTY293  = @p_QTY293 ,@p_QTY294  = @p_QTY294 ,@p_QTY295  = @p_QTY295
												 ,@p_QTY296	 = @p_QTY296 ,@p_QTY297  = @p_QTY297 ,@p_QTY298  = @p_QTY298 ,@p_QTY299  = @p_QTY299 ,@p_QTY300  = @p_QTY300
 
												 ,@p_QTY301  = @p_QTY301 ,@p_QTY302  = @p_QTY302 ,@p_QTY303  =  @p_QTY303 ,@p_QTY304  = @p_QTY304 ,@p_QTY305  = @p_QTY305
												 ,@p_QTY306	 = @p_QTY306 ,@p_QTY307  = @p_QTY307 ,@p_QTY308  =  @p_QTY308 ,@p_QTY309  = @p_QTY309 ,@p_QTY310  = @p_QTY310
												 ,@p_QTY311  = @p_QTY311 ,@p_QTY312  = @p_QTY312 ,@p_QTY313   = @p_QTY313 ,@p_QTY314  = @p_QTY314 ,@p_QTY315  = @p_QTY315
												 ,@p_QTY316	 = @p_QTY316 ,@p_QTY317  = @p_QTY317 ,@p_QTY318   = @p_QTY318 ,@p_QTY319  = @p_QTY319 ,@p_QTY320  = @p_QTY320
												 ,@p_QTY321  = @p_QTY321 ,@p_QTY322  = @p_QTY322 ,@p_QTY323   = @p_QTY323 ,@p_QTY324  = @p_QTY324 ,@p_QTY325  = @p_QTY325
												 ,@p_QTY326	 = @p_QTY326 ,@p_QTY327  = @p_QTY327 ,@p_QTY328   = @p_QTY328 ,@p_QTY329  = @p_QTY329 ,@p_QTY330  = @p_QTY330
												 ,@p_QTY331  = @p_QTY331 ,@p_QTY332  = @p_QTY332 ,@p_QTY333   = @p_QTY333 ,@p_QTY334  = @p_QTY334 ,@p_QTY335  = @p_QTY335
												 ,@p_QTY336	 = @p_QTY336 ,@p_QTY337  = @p_QTY337 ,@p_QTY338   = @p_QTY338 ,@p_QTY339  = @p_QTY339 ,@p_QTY340  = @p_QTY340
												 ,@p_QTY341  = @p_QTY341 ,@p_QTY342  = @p_QTY342 ,@p_QTY343   = @p_QTY343 ,@p_QTY344  = @p_QTY344 ,@p_QTY345  = @p_QTY345
												 ,@p_QTY346	 = @p_QTY346 ,@p_QTY347  = @p_QTY347 ,@p_QTY348   = @p_QTY348 ,@p_QTY349  = @p_QTY349 ,@p_QTY350  = @p_QTY350
												 ,@p_QTY351  = @p_QTY351 ,@p_QTY352  = @p_QTY352 ,@p_QTY353   = @p_QTY353 ,@p_QTY354  = @p_QTY354 ,@p_QTY355  = @p_QTY355
												 ,@p_QTY356	 = @p_QTY356 ,@p_QTY357  = @p_QTY357 ,@p_QTY358   = @p_QTY358 ,@p_QTY359  = @p_QTY359 ,@p_QTY360  = @p_QTY360
												 ,@p_QTY361  = @p_QTY361 ,@p_QTY362  = @p_QTY362 ,@p_QTY363   = @p_QTY363 ,@p_QTY364  = @p_QTY364 

			;

			SELECT  N'1년차 ' + str(@rows)--TEST

			IF (@rows < 0)  GOTO _RETURN_ERR_CODE


			IF @v_bp_flag = 'Y'
			BEGIN
				-------------------------------------------------------------------------------------------------------------
				-- 2 year 저장 프로시저 실행
				-------------------------------------------------------------------------------------------------------------
				SET @p_create_from_yyyymmdd = @p_create_to_yyyymmdd;	--CONVERT(VARCHAR(8), DATEADD(day, 1, @p_create_to_yyyymmdd), 112);
				SET @p_create_to_yyyymmdd   = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_from_yyyymmdd), 112);		-- 2022.08.17 중장기 버전 2 year 대응처리
				print 'ffffffffffff';
				print @p_create_from_yyyymmdd;
				print @p_create_to_yyyymmdd;

					EXEC @rows = PR_SCP_XLS_ADD_XLSPSI02_S     @p_USER_ID             = @p_user_id
                                                 ,@p_division_id         = @p_division_id
                                                 ,@p_PLAN_START_YYYYMMDD = @p_PLAN_START_YYYYMMDD
                                                 ,@p_PLAN_TYPE           = @p_PLAN_TYPE
                                                 ,@p_SEQ                 = @p_seq
                                                 ,@p_item_id             = @p_item_id
                                                 ,@p_measure             = @p_measure
                                                 ,@p_xls_key1            = @p_xls_key1
												 ,@p_LoadRatio			 = @p_LoadRatio
												 ,@p_create_from_yyyymmdd = @p_create_from_yyyymmdd
												 ,@p_create_to_yyyymmdd   = @p_create_to_yyyymmdd												 													 
												 ,@p_QTY001  = @p_QTY365 ,@p_QTY002   = @p_QTY366 ,@p_QTY003   = @p_QTY367 ,@p_QTY004   = @p_QTY368 ,@p_QTY005   = @p_QTY369
												 ,@p_QTY006	 = @p_QTY370 ,@p_QTY007   = @p_QTY371 ,@p_QTY008   = @p_QTY372 ,@p_QTY009   = @p_QTY373 ,@p_QTY010   = @p_QTY374
												 ,@p_QTY011  = @p_QTY375 ,@p_QTY012   = @p_QTY376 ,@p_QTY013   = @p_QTY377 ,@p_QTY014   = @p_QTY378 ,@p_QTY015   = @p_QTY379
												 ,@p_QTY016	 = @p_QTY380 ,@p_QTY017   = @p_QTY381 ,@p_QTY018   = @p_QTY382 ,@p_QTY019   = @p_QTY383 ,@p_QTY020   = @p_QTY384
												 ,@p_QTY021  = @p_QTY385 ,@p_QTY022   = @p_QTY386 ,@p_QTY023   = @p_QTY387 ,@p_QTY024   = @p_QTY388 ,@p_QTY025   = @p_QTY389
												 ,@p_QTY026	 = @p_QTY390 ,@p_QTY027   = @p_QTY391 ,@p_QTY028   = @p_QTY392 ,@p_QTY029   = @p_QTY393 ,@p_QTY030   = @p_QTY394
												 ,@p_QTY031  = @p_QTY395 ,@p_QTY032   = @p_QTY396 ,@p_QTY033   = @p_QTY397 ,@p_QTY034   = @p_QTY398 ,@p_QTY035   = @p_QTY399
												 ,@p_QTY036	 = @p_QTY400 ,@p_QTY037   = @p_QTY401 ,@p_QTY038   = @p_QTY402 ,@p_QTY039   = @p_QTY403 ,@p_QTY040   = @p_QTY404
												 ,@p_QTY041  = @p_QTY405 ,@p_QTY042   = @p_QTY406 ,@p_QTY043   = @p_QTY407 ,@p_QTY044   = @p_QTY408 ,@p_QTY045   = @p_QTY409
												 ,@p_QTY046	 = @p_QTY410 ,@p_QTY047   = @p_QTY411 ,@p_QTY048   = @p_QTY412 ,@p_QTY049   = @p_QTY413 ,@p_QTY050   = @p_QTY414
												 ,@p_QTY051  = @p_QTY415 ,@p_QTY052   = @p_QTY416 ,@p_QTY053   = @p_QTY417 ,@p_QTY054   = @p_QTY418 ,@p_QTY055   = @p_QTY419
												 ,@p_QTY056	 = @p_QTY420 ,@p_QTY057   = @p_QTY421 ,@p_QTY058   = @p_QTY422 ,@p_QTY059   = @p_QTY423 ,@p_QTY060   = @p_QTY424
												 ,@p_QTY061  = @p_QTY425 ,@p_QTY062   = @p_QTY426 ,@p_QTY063   = @p_QTY427 ,@p_QTY064   = @p_QTY428 ,@p_QTY065   = @p_QTY429
												 ,@p_QTY066	 = @p_QTY430 ,@p_QTY067   = @p_QTY431 ,@p_QTY068   = @p_QTY432 ,@p_QTY069   = @p_QTY433 ,@p_QTY070   = @p_QTY434
												 ,@p_QTY071  = @p_QTY435 ,@p_QTY072   = @p_QTY436 ,@p_QTY073   = @p_QTY437 ,@p_QTY074   = @p_QTY438 ,@p_QTY075   = @p_QTY439
												 ,@p_QTY076	 = @p_QTY440 ,@p_QTY077   = @p_QTY441 ,@p_QTY078   = @p_QTY442 ,@p_QTY079   = @p_QTY443 ,@p_QTY080   = @p_QTY444
												 ,@p_QTY081  = @p_QTY445 ,@p_QTY082   = @p_QTY446 ,@p_QTY083   = @p_QTY447 ,@p_QTY084   = @p_QTY448 ,@p_QTY085   = @p_QTY449
												 ,@p_QTY086	 = @p_QTY450 ,@p_QTY087   = @p_QTY451 ,@p_QTY088   = @p_QTY452 ,@p_QTY089   = @p_QTY453 ,@p_QTY090   = @p_QTY454
												 ,@p_QTY091  = @p_QTY455 ,@p_QTY092   = @p_QTY456 ,@p_QTY093   = @p_QTY457 ,@p_QTY094   = @p_QTY458 ,@p_QTY095   = @p_QTY459
												 ,@p_QTY096	 = @p_QTY460 ,@p_QTY097   = @p_QTY461 ,@p_QTY098   = @p_QTY462 ,@p_QTY099   = @p_QTY463 ,@p_QTY100   = @p_QTY464

												 ,@p_QTY101  = @p_QTY465 ,@p_QTY102   = @p_QTY466 ,@p_QTY103   = @p_QTY467 ,@p_QTY104  = @p_QTY468 ,@p_QTY105  = @p_QTY469
												 ,@p_QTY106	 = @p_QTY470 ,@p_QTY107   = @p_QTY471 ,@p_QTY108   = @p_QTY472 ,@p_QTY109  = @p_QTY473 ,@p_QTY110  = @p_QTY474
												 ,@p_QTY111  = @p_QTY475 ,@p_QTY112   = @p_QTY476 ,@p_QTY113   = @p_QTY477 ,@p_QTY114  = @p_QTY478 ,@p_QTY115  = @p_QTY479
												 ,@p_QTY116	 = @p_QTY480 ,@p_QTY117   = @p_QTY481 ,@p_QTY118   = @p_QTY482 ,@p_QTY119  = @p_QTY483 ,@p_QTY120  = @p_QTY484
												 ,@p_QTY121  = @p_QTY485 ,@p_QTY122   = @p_QTY486 ,@p_QTY123   = @p_QTY487 ,@p_QTY124  = @p_QTY488 ,@p_QTY125  = @p_QTY489
												 ,@p_QTY126	 = @p_QTY490 ,@p_QTY127   = @p_QTY491 ,@p_QTY128   = @p_QTY492 ,@p_QTY129  = @p_QTY493 ,@p_QTY130  = @p_QTY494
												 ,@p_QTY131  = @p_QTY495 ,@p_QTY132   = @p_QTY496 ,@p_QTY133   = @p_QTY497 ,@p_QTY134  = @p_QTY498 ,@p_QTY135  = @p_QTY499
												 ,@p_QTY136	 = @p_QTY500 ,@p_QTY137   = @p_QTY501 ,@p_QTY138   = @p_QTY502 ,@p_QTY139  = @p_QTY503 ,@p_QTY140  = @p_QTY504
												 ,@p_QTY141  = @p_QTY505 ,@p_QTY142   = @p_QTY506 ,@p_QTY143   = @p_QTY507 ,@p_QTY144  = @p_QTY508 ,@p_QTY145  = @p_QTY509
												 ,@p_QTY146	 = @p_QTY510 ,@p_QTY147   = @p_QTY511 ,@p_QTY148   = @p_QTY512 ,@p_QTY149  = @p_QTY513 ,@p_QTY150  = @p_QTY514
												 ,@p_QTY151  = @p_QTY515 ,@p_QTY152   = @p_QTY516 ,@p_QTY153   = @p_QTY517 ,@p_QTY154  = @p_QTY518 ,@p_QTY155  = @p_QTY519
												 ,@p_QTY156	 = @p_QTY520 ,@p_QTY157   = @p_QTY521 ,@p_QTY158   = @p_QTY522 ,@p_QTY159  = @p_QTY523 ,@p_QTY160  = @p_QTY524
												 ,@p_QTY161  = @p_QTY525 ,@p_QTY162   = @p_QTY526 ,@p_QTY163   = @p_QTY527 ,@p_QTY164  = @p_QTY528 ,@p_QTY165  = @p_QTY529
												 ,@p_QTY166	 = @p_QTY530 ,@p_QTY167   = @p_QTY531 ,@p_QTY168   = @p_QTY532 ,@p_QTY169  = @p_QTY533 ,@p_QTY170  = @p_QTY534
												 ,@p_QTY171  = @p_QTY535 ,@p_QTY172   = @p_QTY536 ,@p_QTY173   = @p_QTY537 ,@p_QTY174  = @p_QTY538 ,@p_QTY175  = @p_QTY539
												 ,@p_QTY176	 = @p_QTY540 ,@p_QTY177   = @p_QTY541 ,@p_QTY178   = @p_QTY542 ,@p_QTY179  = @p_QTY543 ,@p_QTY180  = @p_QTY544
												 ,@p_QTY181  = @p_QTY545 ,@p_QTY182   = @p_QTY546 ,@p_QTY183   = @p_QTY547 ,@p_QTY184  = @p_QTY548 ,@p_QTY185  = @p_QTY549
												 ,@p_QTY186	 = @p_QTY550 ,@p_QTY187   = @p_QTY551 ,@p_QTY188   = @p_QTY552 ,@p_QTY189  = @p_QTY553 ,@p_QTY190  = @p_QTY554
												 ,@p_QTY191  = @p_QTY555 ,@p_QTY192   = @p_QTY556 ,@p_QTY193   = @p_QTY557 ,@p_QTY194  = @p_QTY558 ,@p_QTY195  = @p_QTY559
												 ,@p_QTY196	 = @p_QTY560 ,@p_QTY197   = @p_QTY561 ,@p_QTY198   = @p_QTY562 ,@p_QTY199  = @p_QTY563 ,@p_QTY200  = @p_QTY564

												 ,@p_QTY201  = @p_QTY565 ,@p_QTY202  = @p_QTY566 ,@p_QTY203  = @p_QTY567 ,@p_QTY204  =@p_QTY568  ,@p_QTY205  = @p_QTY569
												 ,@p_QTY206	 = @p_QTY570 ,@p_QTY207  = @p_QTY571 ,@p_QTY208  = @p_QTY572 ,@p_QTY209  =@p_QTY573  ,@p_QTY210  = @p_QTY574
												 ,@p_QTY211  = @p_QTY575 ,@p_QTY212  = @p_QTY576 ,@p_QTY213  = @p_QTY577 ,@p_QTY214  =@p_QTY578  ,@p_QTY215  = @p_QTY579
												 ,@p_QTY216	 = @p_QTY580 ,@p_QTY217  = @p_QTY581 ,@p_QTY218  = @p_QTY582 ,@p_QTY219  =@p_QTY583  ,@p_QTY220  = @p_QTY584
												 ,@p_QTY221  = @p_QTY585 ,@p_QTY222  = @p_QTY586 ,@p_QTY223  = @p_QTY587 ,@p_QTY224  =@p_QTY588  ,@p_QTY225  = @p_QTY589
												 ,@p_QTY226	 = @p_QTY590 ,@p_QTY227  = @p_QTY591 ,@p_QTY228  = @p_QTY592 ,@p_QTY229  =@p_QTY593  ,@p_QTY230  = @p_QTY594
												 ,@p_QTY231  = @p_QTY595 ,@p_QTY232  = @p_QTY596 ,@p_QTY233  = @p_QTY597 ,@p_QTY234  =@p_QTY598  ,@p_QTY235  = @p_QTY599
												 ,@p_QTY236	 = @p_QTY600 ,@p_QTY237  = @p_QTY601 ,@p_QTY238  = @p_QTY602 ,@p_QTY239  =@p_QTY603  ,@p_QTY240  = @p_QTY604
												 ,@p_QTY241  = @p_QTY605 ,@p_QTY242  = @p_QTY606 ,@p_QTY243  = @p_QTY607 ,@p_QTY244  =@p_QTY608  ,@p_QTY245  = @p_QTY609
												 ,@p_QTY246	 = @p_QTY610 ,@p_QTY247  = @p_QTY611 ,@p_QTY248  = @p_QTY612 ,@p_QTY249  =@p_QTY613  ,@p_QTY250  = @p_QTY614
												 ,@p_QTY251  = @p_QTY615 ,@p_QTY252  = @p_QTY616 ,@p_QTY253  = @p_QTY617 ,@p_QTY254  =@p_QTY618  ,@p_QTY255  = @p_QTY619
												 ,@p_QTY256	 = @p_QTY620 ,@p_QTY257  = @p_QTY621 ,@p_QTY258  = @p_QTY622 ,@p_QTY259  =@p_QTY623  ,@p_QTY260  = @p_QTY624
												 ,@p_QTY261  = @p_QTY625 ,@p_QTY262  = @p_QTY626 ,@p_QTY263  = @p_QTY627 ,@p_QTY264  =@p_QTY628  ,@p_QTY265  = @p_QTY629
												 ,@p_QTY266	 = @p_QTY630 ,@p_QTY267  = @p_QTY631 ,@p_QTY268  = @p_QTY632 ,@p_QTY269  =@p_QTY633  ,@p_QTY270  = @p_QTY634
												 ,@p_QTY271  = @p_QTY635 ,@p_QTY272  = @p_QTY636 ,@p_QTY273  = @p_QTY637 ,@p_QTY274  =@p_QTY638  ,@p_QTY275  = @p_QTY639
												 ,@p_QTY276	 = @p_QTY640 ,@p_QTY277  = @p_QTY641 ,@p_QTY278  = @p_QTY642 ,@p_QTY279  =@p_QTY643  ,@p_QTY280  = @p_QTY644
												 ,@p_QTY281  = @p_QTY645 ,@p_QTY282  = @p_QTY646 ,@p_QTY283  = @p_QTY647 ,@p_QTY284  =@p_QTY648  ,@p_QTY285  = @p_QTY649
												 ,@p_QTY286	 = @p_QTY650 ,@p_QTY287  = @p_QTY651 ,@p_QTY288  = @p_QTY652 ,@p_QTY289  =@p_QTY653  ,@p_QTY290  = @p_QTY654
												 ,@p_QTY291  = @p_QTY655 ,@p_QTY292  = @p_QTY656 ,@p_QTY293  = @p_QTY657 ,@p_QTY294  =@p_QTY658  ,@p_QTY295  = @p_QTY659
												 ,@p_QTY296	 = @p_QTY660 ,@p_QTY297  = @p_QTY661 ,@p_QTY298  = @p_QTY662 ,@p_QTY299  =@p_QTY663  ,@p_QTY300  = @p_QTY664
 
												 ,@p_QTY301  = @p_QTY665 ,@p_QTY302  = @p_QTY666 ,@p_QTY303  =  @p_QTY667 ,@p_QTY304  = @p_QTY668 ,@p_QTY305  = @p_QTY669
												 ,@p_QTY306	 = @p_QTY670 ,@p_QTY307  = @p_QTY671 ,@p_QTY308  =  @p_QTY672 ,@p_QTY309  = @p_QTY673 ,@p_QTY310  = @p_QTY674
												 ,@p_QTY311  = @p_QTY675 ,@p_QTY312  = @p_QTY676 ,@p_QTY313   = @p_QTY677 ,@p_QTY314  = @p_QTY678 ,@p_QTY315  = @p_QTY679
												 ,@p_QTY316	 = @p_QTY680 ,@p_QTY317  = @p_QTY681 ,@p_QTY318   = @p_QTY682 ,@p_QTY319  = @p_QTY683 ,@p_QTY320  = @p_QTY684
												 ,@p_QTY321  = @p_QTY685 ,@p_QTY322  = @p_QTY686 ,@p_QTY323   = @p_QTY687 ,@p_QTY324  = @p_QTY688 ,@p_QTY325  = @p_QTY689
												 ,@p_QTY326	 = @p_QTY690 ,@p_QTY327  = @p_QTY691 ,@p_QTY328   = @p_QTY692 ,@p_QTY329  = @p_QTY693 ,@p_QTY330  = @p_QTY694
												 ,@p_QTY331  = @p_QTY695 ,@p_QTY332  = @p_QTY696 ,@p_QTY333   = @p_QTY697 ,@p_QTY334  = @p_QTY698 ,@p_QTY335  = @p_QTY699
												 ,@p_QTY336	 = @p_QTY700 ,@p_QTY337  = @p_QTY701 ,@p_QTY338   = @p_QTY702 ,@p_QTY339  = @p_QTY703 ,@p_QTY340  = @p_QTY704
												 ,@p_QTY341  = @p_QTY705 ,@p_QTY342  = @p_QTY706 ,@p_QTY343   = @p_QTY707 ,@p_QTY344  = @p_QTY708 ,@p_QTY345  = @p_QTY709
												 ,@p_QTY346	 = @p_QTY710 ,@p_QTY347  = @p_QTY711 ,@p_QTY348   = @p_QTY712 ,@p_QTY349  = @p_QTY713 ,@p_QTY350  = @p_QTY714
												 ,@p_QTY351  = @p_QTY715 ,@p_QTY352  = @p_QTY716 ,@p_QTY353   = @p_QTY717 ,@p_QTY354  = @p_QTY718 ,@p_QTY355  = @p_QTY719
												 ,@p_QTY356	 = @p_QTY720 ,@p_QTY357  = @p_QTY721 ,@p_QTY358   = @p_QTY722 ,@p_QTY359  = @p_QTY723 ,@p_QTY360  = @p_QTY724
												 ,@p_QTY361  = @p_QTY725 ,@p_QTY362  = @p_QTY726 ,@p_QTY363   = @p_QTY727 ,@p_QTY364  = @p_QTY728 


				;
			SELECT  N'2년차 ' + str(@rows); --TEST
				IF (@rows < 0)  GOTO _RETURN_ERR_CODE
			END


		-- 2021.03.17   KSW            temp table 일괄 drop 스크립트 추가 - start
		IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL	
						  DROP TABLE #SCM_MST_SITE;

		IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL	
						  DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL;

		IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ORG') IS NOT NULL	
						  DROP TABLE #SCP_XLS_PSI_GLOBAL_ORG;

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


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@p_division_id+']['+@p_PLAN_START_YYYYMMDD+']['+@p_measure+']['+@p_xls_key1+'][' + @v_exec_time + ']';         
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

    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END; 

  END;

