PROCEDURE PR_SCP_XLS_ADD_XLSPSI04
(
      P_USER_ID                 VARCHAR2
    /* ,@P_GUBUN                 VARCHAR(040)       -- MEASURE  @P_GUBUN  PACK / CELL / SUPPLY */
    , P_DIVISION_ID            VARCHAR2
    , P_PLAN_START_YYYYMMDD    VARCHAR2
    , P_PLAN_TYPE              VARCHAR2
    , P_SEQ                    PLS_INTEGER                  /* INT */
    , P_ITEM_ID                VARCHAR2
    , P_MEASURE                VARCHAR2                     /* NVARCHAR(050)   MEASURE별 */
    , P_DAY_WEEK_FLAG          VARCHAR2                     /* NVARCHAR(010)   (day,week) */
    , P_XLS_KEY1               VARCHAR2

 /*
 ,@p_QTY001 NUMERIC (20,10) = 0.0 ,@p_QTY002  NUMERIC (20,10) = 0.0 ,@p_QTY003  NUMERIC (20,10) = 0.0 ,@p_QTY004  NUMERIC (20,10) = 0.0 ,@p_QTY005  NUMERIC (20,10) = 0.0
 ,@p_QTY006	NUMERIC (20,10) = 0.0 ,@p_QTY007  NUMERIC (20,10) = 0.0 ,@p_QTY008  NUMERIC (20,10) = 0.0 ,@p_QTY009  NUMERIC (20,10) = 0.0 ,@p_QTY010  NUMERIC (20,10) = 0.0
 ,@p_QTY011 NUMERIC (20,10) = 0.0 ,@p_QTY012  NUMERIC (20,10) = 0.0 ,@p_QTY013  NUMERIC (20,10) = 0.0 ,@p_QTY014  NUMERIC (20,10) = 0.0 ,@p_QTY015  NUMERIC (20,10) = 0.0
 ,@p_QTY016	NUMERIC (20,10) = 0.0 ,@p_QTY017  NUMERIC (20,10) = 0.0 ,@p_QTY018  NUMERIC (20,10) = 0.0 ,@p_QTY019  NUMERIC (20,10) = 0.0 ,@p_QTY020  NUMERIC (20,10) = 0.0
 ,@p_QTY021 NUMERIC (20,10) = 0.0 ,@p_QTY022  NUMERIC (20,10) = 0.0 ,@p_QTY023  NUMERIC (20,10) = 0.0 ,@p_QTY024  NUMERIC (20,10) = 0.0 ,@p_QTY025  NUMERIC (20,10) = 0.0
 ,@p_QTY026	NUMERIC (20,10) = 0.0 ,@p_QTY027  NUMERIC (20,10) = 0.0 ,@p_QTY028  NUMERIC (20,10) = 0.0 ,@p_QTY029  NUMERIC (20,10) = 0.0 ,@p_QTY030  NUMERIC (20,10) = 0.0
 ,@p_QTY031 NUMERIC (20,10) = 0.0 ,@p_QTY032  NUMERIC (20,10) = 0.0 ,@p_QTY033  NUMERIC (20,10) = 0.0 ,@p_QTY034  NUMERIC (20,10) = 0.0 ,@p_QTY035  NUMERIC (20,10) = 0.0
 ,@p_QTY036	NUMERIC (20,10) = 0.0 ,@p_QTY037  NUMERIC (20,10) = 0.0 ,@p_QTY038  NUMERIC (20,10) = 0.0 ,@p_QTY039  NUMERIC (20,10) = 0.0 ,@p_QTY040  NUMERIC (20,10) = 0.0
 ,@p_QTY041 NUMERIC (20,10) = 0.0 ,@p_QTY042  NUMERIC (20,10) = 0.0 ,@p_QTY043  NUMERIC (20,10) = 0.0 ,@p_QTY044  NUMERIC (20,10) = 0.0 ,@p_QTY045  NUMERIC (20,10) = 0.0
 ,@p_QTY046	NUMERIC (20,10) = 0.0 ,@p_QTY047  NUMERIC (20,10) = 0.0 ,@p_QTY048  NUMERIC (20,10) = 0.0 ,@p_QTY049  NUMERIC (20,10) = 0.0 ,@p_QTY050  NUMERIC (20,10) = 0.0
 ,@p_QTY051 NUMERIC (20,10) = 0.0 ,@p_QTY052  NUMERIC (20,10) = 0.0 ,@p_QTY053  NUMERIC (20,10) = 0.0 ,@p_QTY054  NUMERIC (20,10) = 0.0 ,@p_QTY055  NUMERIC (20,10) = 0.0
 ,@p_QTY056	NUMERIC (20,10) = 0.0 ,@p_QTY057  NUMERIC (20,10) = 0.0 ,@p_QTY058  NUMERIC (20,10) = 0.0 ,@p_QTY059  NUMERIC (20,10) = 0.0 ,@p_QTY060  NUMERIC (20,10) = 0.0
 ,@p_QTY061 NUMERIC (20,10) = 0.0 ,@p_QTY062  NUMERIC (20,10) = 0.0 ,@p_QTY063  NUMERIC (20,10) = 0.0 ,@p_QTY064  NUMERIC (20,10) = 0.0 ,@p_QTY065  NUMERIC (20,10) = 0.0
 ,@p_QTY066	NUMERIC (20,10) = 0.0 ,@p_QTY067  NUMERIC (20,10) = 0.0 ,@p_QTY068  NUMERIC (20,10) = 0.0 ,@p_QTY069  NUMERIC (20,10) = 0.0 ,@p_QTY070  NUMERIC (20,10) = 0.0
 ,@p_QTY071 NUMERIC (20,10) = 0.0 ,@p_QTY072  NUMERIC (20,10) = 0.0 ,@p_QTY073  NUMERIC (20,10) = 0.0 ,@p_QTY074  NUMERIC (20,10) = 0.0 ,@p_QTY075  NUMERIC (20,10) = 0.0
 ,@p_QTY076	NUMERIC (20,10) = 0.0 ,@p_QTY077  NUMERIC (20,10) = 0.0 ,@p_QTY078  NUMERIC (20,10) = 0.0 ,@p_QTY079  NUMERIC (20,10) = 0.0 ,@p_QTY080  NUMERIC (20,10) = 0.0
 ,@p_QTY081 NUMERIC (20,10) = 0.0 ,@p_QTY082  NUMERIC (20,10) = 0.0 ,@p_QTY083  NUMERIC (20,10) = 0.0 ,@p_QTY084  NUMERIC (20,10) = 0.0 ,@p_QTY085  NUMERIC (20,10) = 0.0
 ,@p_QTY086	NUMERIC (20,10) = 0.0 ,@p_QTY087  NUMERIC (20,10) = 0.0 ,@p_QTY088  NUMERIC (20,10) = 0.0 ,@p_QTY089  NUMERIC (20,10) = 0.0 ,@p_QTY090  NUMERIC (20,10) = 0.0
 ,@p_QTY091 NUMERIC (20,10) = 0.0 ,@p_QTY092  NUMERIC (20,10) = 0.0 ,@p_QTY093  NUMERIC (20,10) = 0.0 ,@p_QTY094  NUMERIC (20,10) = 0.0 ,@p_QTY095  NUMERIC (20,10) = 0.0
 ,@p_QTY096	NUMERIC (20,10) = 0.0 ,@p_QTY097  NUMERIC (20,10) = 0.0 ,@p_QTY098  NUMERIC (20,10) = 0.0 ,@p_QTY099  NUMERIC (20,10) = 0.0 ,@p_QTY100  NUMERIC (20,10) = 0.0

 ,@p_QTY101 NUMERIC (20,10) = 0.0 ,@p_QTY102  NUMERIC (20,10) = 0.0 ,@p_QTY103  NUMERIC (20,10) = 0.0 ,@p_QTY104  NUMERIC (20,10) = 0.0 ,@p_QTY105  NUMERIC (20,10) = 0.0
 ,@p_QTY106	NUMERIC (20,10) = 0.0 ,@p_QTY107  NUMERIC (20,10) = 0.0 ,@p_QTY108  NUMERIC (20,10) = 0.0 ,@p_QTY109  NUMERIC (20,10) = 0.0 ,@p_QTY110  NUMERIC (20,10) = 0.0
 ,@p_QTY111 NUMERIC (20,10) = 0.0 ,@p_QTY112  NUMERIC (20,10) = 0.0
*/
                                                                  /*,@p_QTY113  NUMERIC (20,10) = 0.0 ,@p_QTY114  NUMERIC (20,10) = 0.0 ,@p_QTY115  NUMERIC (20,10) = 0.0
 ,@p_QTY116	NUMERIC (20,10) = 0.0 ,@p_QTY117  NUMERIC (20,10) = 0.0 ,@p_QTY118  NUMERIC (20,10) = 0.0 ,@p_QTY119  NUMERIC (20,10) = 0.0 ,@p_QTY120  NUMERIC (20,10) = 0.0
 ,@p_QTY121 NUMERIC (20,10) = 0.0 ,@p_QTY122  NUMERIC (20,10) = 0.0 ,@p_QTY123  NUMERIC (20,10) = 0.0 ,@p_QTY124  NUMERIC (20,10) = 0.0 ,@p_QTY125  NUMERIC (20,10) = 0.0
 ,@p_QTY126	NUMERIC (20,10) = 0.0 ,@p_QTY127  NUMERIC (20,10) = 0.0 ,@p_QTY128  NUMERIC (20,10) = 0.0 ,@p_QTY129  NUMERIC (20,10) = 0.0 ,@p_QTY130  NUMERIC (20,10) = 0.0
 ,@p_QTY131 NUMERIC (20,10) = 0.0 ,@p_QTY132  NUMERIC (20,10) = 0.0 ,@p_QTY133  NUMERIC (20,10) = 0.0 ,@p_QTY134  NUMERIC (20,10) = 0.0 ,@p_QTY135  NUMERIC (20,10) = 0.0
 ,@p_QTY136	NUMERIC (20,10) = 0.0 ,@p_QTY137  NUMERIC (20,10) = 0.0 ,@p_QTY138  NUMERIC (20,10) = 0.0 ,@p_QTY139  NUMERIC (20,10) = 0.0 ,@p_QTY140  NUMERIC (20,10) = 0.0
 ,@p_QTY141 NUMERIC (20,10) = 0.0 ,@p_QTY142  NUMERIC (20,10) = 0.0 ,@p_QTY143  NUMERIC (20,10) = 0.0 ,@p_QTY144  NUMERIC (20,10) = 0.0 ,@p_QTY145  NUMERIC (20,10) = 0.0
 ,@p_QTY146	NUMERIC (20,10) = 0.0 ,@p_QTY147  NUMERIC (20,10) = 0.0 ,@p_QTY148  NUMERIC (20,10) = 0.0 ,@p_QTY149  NUMERIC (20,10) = 0.0 ,@p_QTY150  NUMERIC (20,10) = 0.0
 ,@p_QTY151 NUMERIC (20,10) = 0.0 ,@p_QTY152  NUMERIC (20,10) = 0.0 ,@p_QTY153  NUMERIC (20,10) = 0.0 ,@p_QTY154  NUMERIC (20,10) = 0.0 ,@p_QTY155  NUMERIC (20,10) = 0.0
 ,@p_QTY156	NUMERIC (20,10) = 0.0 ,@p_QTY157  NUMERIC (20,10) = 0.0 ,@p_QTY158  NUMERIC (20,10) = 0.0 ,@p_QTY159  NUMERIC (20,10) = 0.0 ,@p_QTY160  NUMERIC (20,10) = 0.0
 ,@p_QTY161 NUMERIC (20,10) = 0.0 ,@p_QTY162  NUMERIC (20,10) = 0.0 ,@p_QTY163  NUMERIC (20,10) = 0.0 ,@p_QTY164  NUMERIC (20,10) = 0.0 ,@p_QTY165  NUMERIC (20,10) = 0.0
 ,@p_QTY166	NUMERIC (20,10) = 0.0 ,@p_QTY167  NUMERIC (20,10) = 0.0 ,@p_QTY168  NUMERIC (20,10) = 0.0 ,@p_QTY169  NUMERIC (20,10) = 0.0 ,@p_QTY170  NUMERIC (20,10) = 0.0
 ,@p_QTY171 NUMERIC (20,10) = 0.0 ,@p_QTY172  NUMERIC (20,10) = 0.0 ,@p_QTY173  NUMERIC (20,10) = 0.0 ,@p_QTY174  NUMERIC (20,10) = 0.0 ,@p_QTY175  NUMERIC (20,10) = 0.0
 ,@p_QTY176	NUMERIC (20,10) = 0.0 ,@p_QTY177  NUMERIC (20,10) = 0.0 ,@p_QTY178  NUMERIC (20,10) = 0.0 ,@p_QTY179  NUMERIC (20,10) = 0.0 ,@p_QTY180  NUMERIC (20,10) = 0.0
 ,@p_QTY181 NUMERIC (20,10) = 0.0 ,@p_QTY182  NUMERIC (20,10) = 0.0 ,@p_QTY183  NUMERIC (20,10) = 0.0 ,@p_QTY184  NUMERIC (20,10) = 0.0 ,@p_QTY185  NUMERIC (20,10) = 0.0
 ,@p_QTY186	NUMERIC (20,10) = 0.0 ,@p_QTY187  NUMERIC (20,10) = 0.0 ,@p_QTY188  NUMERIC (20,10) = 0.0 ,@p_QTY189  NUMERIC (20,10) = 0.0 ,@p_QTY190  NUMERIC (20,10) = 0.0
 ,@p_QTY191 NUMERIC (20,10) = 0.0 ,@p_QTY192  NUMERIC (20,10) = 0.0 ,@p_QTY193  NUMERIC (20,10) = 0.0 ,@p_QTY194  NUMERIC (20,10) = 0.0 ,@p_QTY195  NUMERIC (20,10) = 0.0
 ,@p_QTY196	NUMERIC (20,10) = 0.0 ,@p_QTY197  NUMERIC (20,10) = 0.0 ,@p_QTY198  NUMERIC (20,10) = 0.0 ,@p_QTY199  NUMERIC (20,10) = 0.0 ,@p_QTY200  NUMERIC (20,10) = 0.0

 ,@p_QTY201 NUMERIC (20,10) = 0.0 ,@p_QTY202  NUMERIC (20,10) = 0.0 ,@p_QTY203  NUMERIC (20,10) = 0.0 ,@p_QTY204  NUMERIC (20,10) = 0.0 ,@p_QTY205  NUMERIC (20,10) = 0.0
 ,@p_QTY206	NUMERIC (20,10) = 0.0 ,@p_QTY207  NUMERIC (20,10) = 0.0 ,@p_QTY208  NUMERIC (20,10) = 0.0 ,@p_QTY209  NUMERIC (20,10) = 0.0 ,@p_QTY210  NUMERIC (20,10) = 0.0
 ,@p_QTY211 NUMERIC (20,10) = 0.0 ,@p_QTY212  NUMERIC (20,10) = 0.0 ,@p_QTY213  NUMERIC (20,10) = 0.0 ,@p_QTY214  NUMERIC (20,10) = 0.0 ,@p_QTY215  NUMERIC (20,10) = 0.0
 ,@p_QTY216	NUMERIC (20,10) = 0.0 ,@p_QTY217  NUMERIC (20,10) = 0.0 ,@p_QTY218  NUMERIC (20,10) = 0.0 ,@p_QTY219  NUMERIC (20,10) = 0.0 ,@p_QTY220  NUMERIC (20,10) = 0.0
 ,@p_QTY221 NUMERIC (20,10) = 0.0 ,@p_QTY222  NUMERIC (20,10) = 0.0 ,@p_QTY223  NUMERIC (20,10) = 0.0 ,@p_QTY224  NUMERIC (20,10) = 0.0 ,@p_QTY225  NUMERIC (20,10) = 0.0
 ,@p_QTY226	NUMERIC (20,10) = 0.0 ,@p_QTY227  NUMERIC (20,10) = 0.0 ,@p_QTY228  NUMERIC (20,10) = 0.0 ,@p_QTY229  NUMERIC (20,10) = 0.0 ,@p_QTY230  NUMERIC (20,10) = 0.0
 ,@p_QTY231 NUMERIC (20,10) = 0.0 ,@p_QTY232  NUMERIC (20,10) = 0.0 ,@p_QTY233  NUMERIC (20,10) = 0.0 ,@p_QTY234  NUMERIC (20,10) = 0.0 ,@p_QTY235  NUMERIC (20,10) = 0.0
 ,@p_QTY236	NUMERIC (20,10) = 0.0 ,@p_QTY237  NUMERIC (20,10) = 0.0 ,@p_QTY238  NUMERIC (20,10) = 0.0 ,@p_QTY239  NUMERIC (20,10) = 0.0 ,@p_QTY240  NUMERIC (20,10) = 0.0
 ,@p_QTY241 NUMERIC (20,10) = 0.0 ,@p_QTY242  NUMERIC (20,10) = 0.0 ,@p_QTY243  NUMERIC (20,10) = 0.0 ,@p_QTY244  NUMERIC (20,10) = 0.0 ,@p_QTY245  NUMERIC (20,10) = 0.0
 ,@p_QTY246	NUMERIC (20,10) = 0.0 ,@p_QTY247  NUMERIC (20,10) = 0.0 ,@p_QTY248  NUMERIC (20,10) = 0.0 ,@p_QTY249  NUMERIC (20,10) = 0.0 ,@p_QTY250  NUMERIC (20,10) = 0.0
 ,@p_QTY251 NUMERIC (20,10) = 0.0 ,@p_QTY252  NUMERIC (20,10) = 0.0 ,@p_QTY253  NUMERIC (20,10) = 0.0 ,@p_QTY254  NUMERIC (20,10) = 0.0 ,@p_QTY255  NUMERIC (20,10) = 0.0
 ,@p_QTY256	NUMERIC (20,10) = 0.0 ,@p_QTY257  NUMERIC (20,10) = 0.0 ,@p_QTY258  NUMERIC (20,10) = 0.0 ,@p_QTY259  NUMERIC (20,10) = 0.0 ,@p_QTY260  NUMERIC (20,10) = 0.0
 ,@p_QTY261 NUMERIC (20,10) = 0.0 ,@p_QTY262  NUMERIC (20,10) = 0.0 ,@p_QTY263  NUMERIC (20,10) = 0.0 ,@p_QTY264  NUMERIC (20,10) = 0.0 ,@p_QTY265  NUMERIC (20,10) = 0.0
 ,@p_QTY266	NUMERIC (20,10) = 0.0 ,@p_QTY267  NUMERIC (20,10) = 0.0 ,@p_QTY268  NUMERIC (20,10) = 0.0 ,@p_QTY269  NUMERIC (20,10) = 0.0 ,@p_QTY270  NUMERIC (20,10) = 0.0
 ,@p_QTY271 NUMERIC (20,10) = 0.0 ,@p_QTY272  NUMERIC (20,10) = 0.0 ,@p_QTY273  NUMERIC (20,10) = 0.0 ,@p_QTY274  NUMERIC (20,10) = 0.0 ,@p_QTY275  NUMERIC (20,10) = 0.0
 ,@p_QTY276	NUMERIC (20,10) = 0.0 ,@p_QTY277  NUMERIC (20,10) = 0.0 ,@p_QTY278  NUMERIC (20,10) = 0.0 ,@p_QTY279  NUMERIC (20,10) = 0.0 ,@p_QTY280  NUMERIC (20,10) = 0.0
 ,@p_QTY281 NUMERIC (20,10) = 0.0 ,@p_QTY282  NUMERIC (20,10) = 0.0 ,@p_QTY283  NUMERIC (20,10) = 0.0 ,@p_QTY284  NUMERIC (20,10) = 0.0 ,@p_QTY285  NUMERIC (20,10) = 0.0
 ,@p_QTY286	NUMERIC (20,10) = 0.0 ,@p_QTY287  NUMERIC (20,10) = 0.0 ,@p_QTY288  NUMERIC (20,10) = 0.0 ,@p_QTY289  NUMERIC (20,10) = 0.0 ,@p_QTY290  NUMERIC (20,10) = 0.0
 ,@p_QTY291 NUMERIC (20,10) = 0.0 ,@p_QTY292  NUMERIC (20,10) = 0.0 ,@p_QTY293  NUMERIC (20,10) = 0.0 ,@p_QTY294  NUMERIC (20,10) = 0.0 ,@p_QTY295  NUMERIC (20,10) = 0.0
 ,@p_QTY296	NUMERIC (20,10) = 0.0 ,@p_QTY297  NUMERIC (20,10) = 0.0 ,@p_QTY298  NUMERIC (20,10) = 0.0 ,@p_QTY299  NUMERIC (20,10) = 0.0 ,@p_QTY300  NUMERIC (20,10) = 0.0

 ,@p_QTY301 NUMERIC (20,10) = 0.0 ,@p_QTY302  NUMERIC (20,10) = 0.0 ,@p_QTY303  NUMERIC (20,10) = 0.0 ,@p_QTY304  NUMERIC (20,10) = 0.0 ,@p_QTY305  NUMERIC (20,10) = 0.0
 ,@p_QTY306	NUMERIC (20,10) = 0.0 ,@p_QTY307  NUMERIC (20,10) = 0.0 ,@p_QTY308  NUMERIC (20,10) = 0.0 ,@p_QTY309  NUMERIC (20,10) = 0.0 ,@p_QTY310  NUMERIC (20,10) = 0.0
 ,@p_QTY311 NUMERIC (20,10) = 0.0 ,@p_QTY312  NUMERIC (20,10) = 0.0 ,@p_QTY313  NUMERIC (20,10) = 0.0 ,@p_QTY314  NUMERIC (20,10) = 0.0 ,@p_QTY315  NUMERIC (20,10) = 0.0
 ,@p_QTY316	NUMERIC (20,10) = 0.0 ,@p_QTY317  NUMERIC (20,10) = 0.0 ,@p_QTY318  NUMERIC (20,10) = 0.0 ,@p_QTY319  NUMERIC (20,10) = 0.0 ,@p_QTY320  NUMERIC (20,10) = 0.0
 ,@p_QTY321 NUMERIC (20,10) = 0.0 ,@p_QTY322  NUMERIC (20,10) = 0.0 ,@p_QTY323  NUMERIC (20,10) = 0.0 ,@p_QTY324  NUMERIC (20,10) = 0.0 ,@p_QTY325  NUMERIC (20,10) = 0.0
 ,@p_QTY326	NUMERIC (20,10) = 0.0 ,@p_QTY327  NUMERIC (20,10) = 0.0 ,@p_QTY328  NUMERIC (20,10) = 0.0 ,@p_QTY329  NUMERIC (20,10) = 0.0 ,@p_QTY330  NUMERIC (20,10) = 0.0
 ,@p_QTY331 NUMERIC (20,10) = 0.0 ,@p_QTY332  NUMERIC (20,10) = 0.0 ,@p_QTY333  NUMERIC (20,10) = 0.0 ,@p_QTY334  NUMERIC (20,10) = 0.0 ,@p_QTY335  NUMERIC (20,10) = 0.0
 ,@p_QTY336	NUMERIC (20,10) = 0.0 ,@p_QTY337  NUMERIC (20,10) = 0.0 ,@p_QTY338  NUMERIC (20,10) = 0.0 ,@p_QTY339  NUMERIC (20,10) = 0.0 ,@p_QTY340  NUMERIC (20,10) = 0.0
 ,@p_QTY341 NUMERIC (20,10) = 0.0 ,@p_QTY342  NUMERIC (20,10) = 0.0 ,@p_QTY343  NUMERIC (20,10) = 0.0 ,@p_QTY344  NUMERIC (20,10) = 0.0 ,@p_QTY345  NUMERIC (20,10) = 0.0
 ,@p_QTY346	NUMERIC (20,10) = 0.0 ,@p_QTY347  NUMERIC (20,10) = 0.0 ,@p_QTY348  NUMERIC (20,10) = 0.0 ,@p_QTY349  NUMERIC (20,10) = 0.0 ,@p_QTY350  NUMERIC (20,10) = 0.0
 ,@p_QTY351 NUMERIC (20,10) = 0.0 ,@p_QTY352  NUMERIC (20,10) = 0.0 ,@p_QTY353  NUMERIC (20,10) = 0.0 ,@p_QTY354  NUMERIC (20,10) = 0.0 ,@p_QTY355  NUMERIC (20,10) = 0.0
 ,@p_QTY356	NUMERIC (20,10) = 0.0 ,@p_QTY357  NUMERIC (20,10) = 0.0 ,@p_QTY358  NUMERIC (20,10) = 0.0 ,@p_QTY359  NUMERIC (20,10) = 0.0 ,@p_QTY360  NUMERIC (20,10) = 0.0
 ,@p_QTY361 NUMERIC (20,10) = 0.0 ,@p_QTY362  NUMERIC (20,10) = 0.0 ,@p_QTY363  NUMERIC (20,10) = 0.0 ,@p_QTY364  NUMERIC (20,10) = 0.0
 */

    , P_WQTY01 PLS_INTEGER DEFAULT 0 , P_WQTY02 PLS_INTEGER DEFAULT 0 , P_WQTY03 PLS_INTEGER DEFAULT 0 , P_WQTY04 PLS_INTEGER DEFAULT 0 , P_WQTY05 PLS_INTEGER DEFAULT 0
    , P_WQTY06 PLS_INTEGER DEFAULT 0 , P_WQTY07 PLS_INTEGER DEFAULT 0 , P_WQTY08 PLS_INTEGER DEFAULT 0 , P_WQTY09 PLS_INTEGER DEFAULT 0 , P_WQTY10 PLS_INTEGER DEFAULT 0
    , P_WQTY11 PLS_INTEGER DEFAULT 0 , P_WQTY12 PLS_INTEGER DEFAULT 0 , P_WQTY13 PLS_INTEGER DEFAULT 0 , P_WQTY14 PLS_INTEGER DEFAULT 0 , P_WQTY15 PLS_INTEGER DEFAULT 0
    , P_WQTY16 PLS_INTEGER DEFAULT 0 , P_WQTY17 PLS_INTEGER DEFAULT 0 , P_WQTY18 PLS_INTEGER DEFAULT 0 , P_WQTY19 PLS_INTEGER DEFAULT 0 , P_WQTY20 PLS_INTEGER DEFAULT 0
    , P_WQTY21 PLS_INTEGER DEFAULT 0 , P_WQTY22 PLS_INTEGER DEFAULT 0 , P_WQTY23 PLS_INTEGER DEFAULT 0 , P_WQTY24 PLS_INTEGER DEFAULT 0 , P_WQTY25 PLS_INTEGER DEFAULT 0
    , P_WQTY26 PLS_INTEGER DEFAULT 0 , P_WQTY27 PLS_INTEGER DEFAULT 0 , P_WQTY28 PLS_INTEGER DEFAULT 0 , P_WQTY29 PLS_INTEGER DEFAULT 0 , P_WQTY30 PLS_INTEGER DEFAULT 0
    , P_WQTY31 PLS_INTEGER DEFAULT 0 , P_WQTY32 PLS_INTEGER DEFAULT 0 , P_WQTY33 PLS_INTEGER DEFAULT 0 , P_WQTY34 PLS_INTEGER DEFAULT 0 , P_WQTY35 PLS_INTEGER DEFAULT 0
    , P_WQTY36 PLS_INTEGER DEFAULT 0 , P_WQTY37 PLS_INTEGER DEFAULT 0 , P_WQTY38 PLS_INTEGER DEFAULT 0 , P_WQTY39 PLS_INTEGER DEFAULT 0 , P_WQTY40 PLS_INTEGER DEFAULT 0
    , P_WQTY41 PLS_INTEGER DEFAULT 0 , P_WQTY42 PLS_INTEGER DEFAULT 0 , P_WQTY43 PLS_INTEGER DEFAULT 0 , P_WQTY44 PLS_INTEGER DEFAULT 0 , P_WQTY45 PLS_INTEGER DEFAULT 0
    , P_WQTY46 PLS_INTEGER DEFAULT 0 , P_WQTY47 PLS_INTEGER DEFAULT 0 , P_WQTY48 PLS_INTEGER DEFAULT 0 , P_WQTY49 PLS_INTEGER DEFAULT 0 , P_WQTY50 PLS_INTEGER DEFAULT 0
    , P_WQTY51 PLS_INTEGER DEFAULT 0 , P_WQTY52 PLS_INTEGER DEFAULT 0
)
/*
 * Program ID   : PR_SCP_XLS_ADD_XLSPSI04
 * Description  : SCP SIMULATION SAVE
 * OutTable     :
 * Execute      :
                 EXEC PR_SCP_XLS_ADD_XLSPSI04     @p_USER_ID             ='KTH'
                                                 ,@p_division_id         = '82'
                                                 ,@p_PLAN_START_YYYYMMDD = '2019128'
                                                 ,@p_PLAN_TYPE           ='PR'
                                                 ,@p_SEQ                 ='1'
                                                 ,@p_item_id             ='ACEN1063I-A3'
                                                 ,@p_measure             ='CELL_CHAR_PLAN'
                                                 ,@p_xls_key1            ='468'
                                                 ,@p_WQTY01 INT = 0.0 ,@p_WQTY02  INT = 0.0 ,@p_WQTY03  INT = 0.0 ,@p_WQTY04  INT = 0.0 ,@p_WQTY05  INT = 0.0
                                                 ,@p_WQTY06	INT = 0.0 ,@p_WQTY07  INT = 0.0 ,@p_WQTY08  INT = 0.0 ,@p_WQTY09  INT = 0.0 ,@p_WQTY10  INT = 0.0
                                                 ,@p_WQTY11 INT = 0.0 ,@p_WQTY12  INT = 0.0 ,@p_WQTY13  INT = 0.0 ,@p_WQTY14  INT = 0.0 ,@p_WQTY15  INT = 0.0
                                                 ,@p_WQTY16	INT = 0.0 ,@p_WQTY17  INT = 0.0 ,@p_WQTY18  INT = 0.0 ,@p_WQTY19  INT = 0.0 ,@p_WQTY20  INT = 0.0
                                                 ,@p_WQTY21 INT = 0.0 ,@p_WQTY22  INT = 0.0 ,@p_WQTY23  INT = 0.0 ,@p_WQTY24  INT = 0.0 ,@p_WQTY25  INT = 0.0
                                                 ,@p_WQTY26	INT = 0.0 ,@p_WQTY27  INT = 0.0 ,@p_WQTY28  INT = 0.0 ,@p_WQTY29  INT = 0.0 ,@p_WQTY30  INT = 0.0
                                                 ,@p_WQTY31 INT = 0.0 ,@p_WQTY32  INT = 0.0 ,@p_WQTY33  INT = 0.0 ,@p_WQTY34  INT = 0.0 ,@p_WQTY35  INT = 0.0
                                                 ,@p_WQTY36	INT = 0.0 ,@p_WQTY37  INT = 0.0 ,@p_WQTY38  INT = 0.0 ,@p_WQTY39  INT = 0.0 ,@p_WQTY40  INT = 0.0
                                                 ,@p_WQTY41 INT = 0.0 ,@p_WQTY42  INT = 0.0 ,@p_WQTY43  INT = 0.0 ,@p_WQTY44  INT = 0.0 ,@p_WQTY45  INT = 0.0
                                                 ,@p_WQTY46	INT = 0.0 ,@p_WQTY47  INT = 0.0 ,@p_WQTY48  INT = 0.0 ,@p_WQTY49  INT = 0.0 ,@p_WQTY50  INT = 0.0
                                                 ,@p_WQTY51 INT = 0.0 ,@p_WQTY52  INT = 0.0

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.06.27   KTH            Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019.12.04   KTH            SHIP_PLAN 저장시 -9로 입력되는것은 0으로 처리 하는 로직 추가
 * 2020.01.09   KTH            저장로직 변경 : 모두 주 입력으로 변경
 * 2026.08.07   ZIONEX         [PJ202650304] NextSCM Migration
 *   - 반환코드 : 원본 return -1(L188/L206/L2950) / return 1(L2971) 은 Oracle 프로시저가 값을 돌려줄 수 없고
 *     정상 조기종료(L188/L206)와 정상 종료(L2971) 는 RETURN 으로, 오류경로(L2950) 는 오류를 삼키면 저장 실패가
 *   - WITH (NOLOCK) 은 Oracle 다중버전 읽기일관성으로 대응이 없어 전 구문에서 제거.
 *   - UPDATE .. FROM .. JOIN 은 원천 유일성이 보장되는 곳만 MERGE, 다중매치 가능성이 있는 곳은
 *     상관 UPDATE + EXISTS + ROWNUM = 1 로 옮겨 ORA-30926(비결정 갱신)을 원천 차단한다(CV-024).
 *   - MSSQL composable DML (INSERT .. SELECT FROM (MERGE .. OUTPUT $action) Changes WHERE Action=INSERT)
 *     은 Oracle 에 대응 구문이 없다. MERGE 가 INSERT 할 행 집합 = ON 절 미매칭 원천행이므로 MERGE 직전에
 *     NOT EXISTS 로 같은 집합을 뽑아 PROD_PLAN_ENGINE 짝 행을 먼저 INSERT 한다(MEASURE 가 달라 MERGE 매칭에
 */
AS
    /*  LOG 용 변수 설정 */
    V_P_USER_ID              VARCHAR2(100 CHAR);       /* MSSQL @p_user_id VARCHAR(100). 본문 L1015 에서 재대입하므로 IN 파라미터를 지역변수로 옮긴다 */
    V_BATCH_USER             VARCHAR2(150 CHAR) := '';
    V_PROGRAM_NAME           VARCHAR2(150 CHAR) := 'PR_SCP_XLS_ADD_XLSPSI04';
    V_LOG_TYPE               VARCHAR2(30 CHAR);        /* START/END/ERROR/... */
    N_LOG_COUNT              INTEGER := 0;
    V_LOG_MESSAGE            VARCHAR2(1000 CHAR);
    V_DESCRIPTION            VARCHAR2(500 CHAR);
    V_TABLE_ID               VARCHAR2(150 CHAR) := 'SCP_XLS_PSI_GLOBAL_ESS';
    D_EVENT_DATE             DATE;
    /*  임시 실행시간 확인용 */
    V_START_TIME             DATE;
    V_EXEC_TIME              VARCHAR2(10 CHAR);        /* '[00:00]'; */
    /*  입력된 버전과 현재 버전 비교용 */
    V_DIVISION_ID            VARCHAR2(30 CHAR);
    V_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR);
    V_PLAN_TYPE              VARCHAR2(50 CHAR);
    V_SEQ                    PLS_INTEGER;
    /*  저장할 요일 (월,화,수,목,금,토,일:2,3,4,5,6,7,1), 8이상은 일배분 */
    V_X_DAYOFWEEK_NO         PLS_INTEGER;
    V_P_TO_YYYYMMDD          VARCHAR2(8 CHAR);
    /*  SCP_ANL_SHIPMENT_PLAN_FG/SEMI · SCP_ANL_PRODUCTION_PLAN PK Parameter */
    V_X_ITEM_ID              VARCHAR2(50 CHAR);
    V_X_OPERATION_GROUP      VARCHAR2(50 CHAR);        /* BIZ_TYPE */
    V_X_PROJECT_CODE         VARCHAR2(50 CHAR);
    V_X_TO_SITE              VARCHAR2(50 CHAR);
    V_X_INCOTERMS            VARCHAR2(50 CHAR);
    V_X_FROM_SITE            VARCHAR2(50 CHAR);        /* SCM_SITE_ID */
    V_X_BOD_ID               VARCHAR2(50 CHAR);
    V_X_LINE_ID              VARCHAR2(50 CHAR);
    V_X_OPERATION_ID         VARCHAR2(50 CHAR);
    /*  동적 SQL 조립 버퍼. MSSQL NVARCHAR(MAX) 이고 실측 조립길이가 364컬럼 x 약 90자 = 33,000자를 넘어 */
    V_MQRY_SUM2              CLOB;
    V_MEXEC2                 CLOB;
    V_MFG                    CLOB;
    V_MSEMI                  CLOB;
    V_MPROD                  CLOB;
    V_LINE_ID                VARCHAR2(100 CHAR);
    V_MQRY_SUM               CLOB;
    V_MEXEC                  CLOB;
BEGIN


    /*  MSSQL @p_user_id 는 VARCHAR(100) 이라 L1015 의 문자열 덧붙이기가 100자에서 조용히 잘린다.
        같은 폭의 지역변수 + SUBSTR 로 그 절단까지 1:1 재현한다. */
    V_P_USER_ID       := SUBSTR(P_USER_ID, 1, 100);
    V_BATCH_USER      := V_P_USER_ID;

  /*  시작 LOG */
    V_LOG_TYPE        := 'START';
    V_LOG_MESSAGE     := '########## Start of procedure ##########';
    V_DESCRIPTION     := V_PROGRAM_NAME || ':' || ' SCP_XLS_PSI_GLOBAL_ESS SAVE LOGIC';
    D_EVENT_DATE      := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER
                        );

        /*  임시 실행시간 확인용 */
    V_START_TIME      := SYSDATE;
    V_EXEC_TIME       := '';

    /* PRINT @p_plan_type */
    /*  PLAN_TYPE이 FN일경우 수정금지 RETURN */
    IF P_PLAN_TYPE = 'FN' THEN
        RETURN;   /* MSSQL: RETURN -1 */
    END IF;

    /* ------------------------------------------------------------------------------------------------------------- */
    /*  입력된 버전과 현재 버전이 다를 경우 RETURN */
    /* ------------------------------------------------------------------------------------------------------------- */
    V_DIVISION_ID           := P_DIVISION_ID;
    V_PLAN_START_YYYYMMDD   := P_PLAN_START_YYYYMMDD;
    V_PLAN_TYPE             := P_PLAN_TYPE;
    V_SEQ                   := P_SEQ;

    /*  MSSQL : SELECT TOP 1 @v_.. = .. FROM SCP_XLS_PSI_GLOBAL_ESS (WHERE·ORDER BY 없음)
        0행이면 MSSQL 은 변수 기존값을 그대로 두므로 SELECT INTO(NO_DATA_FOUND) 가 아니라 커서 FOR 루프로 1:1 재현한다. */
    FOR R IN ( SELECT DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                 FROM SCP_XLS_PSI_GLOBAL_ESS
                WHERE ROWNUM = 1
             )
    LOOP
        V_DIVISION_ID           := R.DIVISION_ID;
        V_PLAN_START_YYYYMMDD   := R.PLAN_START_YYYYMMDD;
        V_PLAN_TYPE             := R.PLAN_TYPE;
        V_SEQ                   := R.SEQ;
    END LOOP;

    IF ( P_DIVISION_ID <> V_DIVISION_ID OR P_PLAN_START_YYYYMMDD <> V_PLAN_START_YYYYMMDD
         OR P_PLAN_TYPE <> V_PLAN_TYPE OR P_SEQ <> V_SEQ ) THEN
        RETURN;   /* MSSQL: return -1 */
    END IF;
    /* ------------------------------------------------------------------------------------------------------------- */

      /* PRINT @p_plan_type */
    BEGIN
      BEGIN

            /* ------------------------------------------------------------------------------------------- */
            /*  SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE  ='DAYOFWEEK_NO' */
            /*  저장할 요일 (월,화,수,목,금,토,일:2,3,4,5,6,7,1), 8이상은 일배분 */
            /* ------------------------------------------------------------------------------------------- */
            V_X_DAYOFWEEK_NO := 8;   /* (1~7) 8은 일별배분 (월,화,수,목,금,토,일:2,3,4,5,6,7,1) */

            /* SELECT SEGMENT1, SEGMENT2,DESCRIPTION */
            /*  MSSQL SELECT TOP 1 @x_DAYOFWEEK_NO = ISNULL(SEGMENT2,8) : 0행이면 기존값 8 유지 -> 커서 FOR 루프 */
            FOR R IN ( SELECT NVL(SEGMENT2, '8') AS SEGMENT2
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE  = 'SHIP_PLAN_SAVE_WEEK'   /* 'DAYOFWEEK_NO' */
                          AND SEGMENT1     = P_DIVISION_ID           /* DIVISION_ID */
                          AND VALID_YN     = 'Y'
                          AND ROWNUM       = 1
                     )
            LOOP
                /*  MSSQL 은 nvarchar SEGMENT2 를 INT 변수에 대입하며 암묵 형변환한다 -> TO_NUMBER 로 명시 */
                V_X_DAYOFWEEK_NO := TO_NUMBER(R.SEGMENT2);
            END LOOP;

               /*  선택된 항목만 주로 변경해야 하기 때문에 반영하지 않도록 수정 2019.05.07 */
               /* SET @x_DAYOFWEEK_NO = '8' */

            V_P_TO_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD');

            /* ------------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 대상 DATA 생성 */
            /* ------------------------------------------------------------------------------------------- */
            /*  IF OBJECT_ID('tempdb..#SCM_MST_SITE') IS NOT NULL DROP TABLE #SCM_MST_SITE */

            DELETE FROM GT_XPGT_SCM_MST_SITE;

            /*                MSSQL DATEADD(WEEK, n, 'YYYYMMDD') -> TO_CHAR(TO_DATE(..,'YYYYMMDD') + n * 7, 'YYYYMMDD') */
            INSERT INTO GT_XPGT_SCM_MST_SITE
                 ( DIVISION_ID
                 , PLANT_ID
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , SHIP_FROZEN
                 , SHIP_FROZEN_WEEK
                 , SHIP_FROZEN_WEEK_DAY
                 , PROD_FROZEN
                 , PROD_FROZEN_WEEK
                 , PROD_FROZEN_WEEK_DAY
                 , PROD_FROZEN_WEEK_DAY_MA
                 , FP_PLAN_PERIOD
                 , VALID_YN
                 , NEW_YN
                 , COMPANY_ID
                 , LOGISTIC_PLANT_ID
                 , PACKER_ITEM_ID_SUFFIX )
            SELECT S.DIVISION_ID
                 , S.PLANT_ID
                 , S.OPERATION_GROUP
                 , S.SCM_SITE_ID
                 , S.SHIP_FROZEN
                 , (TRUNC(S.SHIP_FROZEN / 7) + (CASE WHEN MOD(S.SHIP_FROZEN, 7) > 0 THEN 1 ELSE 0 END)) AS SHIP_FROZEN_WEEK
                 , TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                           + (TRUNC(S.SHIP_FROZEN / 7) + (CASE WHEN MOD(S.SHIP_FROZEN, 7) > 0 THEN 1 ELSE 0 END)) * 7
                          , 'YYYYMMDD') AS SHIP_FROZEN_WEEK_DAY
                 , S.PROD_FROZEN
                 , (TRUNC(S.PROD_FROZEN / 7) + (CASE WHEN MOD(S.PROD_FROZEN, 7) > 0 THEN 1 ELSE 0 END)) AS PROD_FROZEN_WEEK
                 , TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                           + (TRUNC(S.PROD_FROZEN / 7) + (CASE WHEN MOD(S.PROD_FROZEN, 7) > 0 THEN 1 ELSE 0 END)) * 7
                          , 'YYYYMMDD') AS PROD_FROZEN_WEEK_DAY
                 , TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                           + (TRUNC((CASE WHEN ((S.PROD_FROZEN - 7) > 0) THEN (S.PROD_FROZEN - 7) ELSE 0 END) / 7)
                              + (CASE WHEN MOD((CASE WHEN ((S.PROD_FROZEN - 7) > 0) THEN (S.PROD_FROZEN - 7) ELSE 0 END), 7) > 0 THEN 1 ELSE 0 END)) * 7
                          , 'YYYYMMDD') AS PROD_FROZEN_WEEK_DAY_MA
                 , S.FP_PLAN_PERIOD
                 , S.VALID_YN
                 , S.NEW_YN
                 , S.COMPANY_ID
                 , S.LOGISTIC_PLANT_ID
                 , S.PACKER_ITEM_ID_SUFFIX
              FROM SCM_MST_SITE S
             WHERE S.SITE_TYPE   = 'PLANT'
               AND S.VALID_YN    = 'Y'
               AND S.DIVISION_ID = P_DIVISION_ID
                 ;


            /* ------------------------------------------------------------------------------------------- */
            /*  수정하기전의 테이블에 존재하는 데이타를 가져와서 임시 테이블에 담아둔다. */
            /* ------------------------------------------------------------------------------------------- */
            /*  SOURCE에 반영될 테이블 #DAY_SCP_XLS_PSI_GLOBAL */
            /*  IF OBJECT_ID('tempdb..#DAY_SCP_XLS_PSI_GLOBAL') IS NOT NULL DROP TABLE #DAY_SCP_XLS_PSI_GLOBAL */
            DELETE FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL;

            /*  SELECT * INTO -> GTT 는 SCP_XLS_PSI_GLOBAL_ESS 와 컬럼명/순서/타입이 동일하게 선언되어 있다. */
            INSERT INTO GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL
            SELECT *
              FROM SCP_XLS_PSI_GLOBAL_ESS
             WHERE 0 = 0
               AND DIVISION_ID         = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND SEQ                 = P_SEQ
               AND XLS_KEY1            = P_XLS_KEY1
                 ;

            /*  SCP_XLS_PSI_GLOBAL_ESS에 반영될 테이블 #SCP_XLS_PSI_GLOBAL_ESS_ORG */
            /*  IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_ESS_ORG') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_ORG */
            DELETE FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_ESS_ORG;

            INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_ESS_ORG
            SELECT *
              FROM SCP_XLS_PSI_GLOBAL_ESS
             WHERE 0 = 0
               AND DIVISION_ID         = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND SEQ                 = P_SEQ
               AND XLS_KEY1            = P_XLS_KEY1
                 ;

            /* ------------------------------------------------------------------------------------------- */
            /*  수정하기전의 테이블에 존재하는 데이타를 가져와서 변수에 담아둔다. */
            /* ------------------------------------------------------------------------------------------- */

            /*
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
                     ,@x_QTY111 INT = 0.0 ,@x_QTY112  INT = 0.0


                     ,@x_WQTY16	INT = 0.0 ,@x_WQTY17  INT = 0.0 ,@x_WQTY18  INT = 0.0 ,@x_WQTY19  INT = 0.0 ,@x_WQTY20  INT = 0.0
                     ,@x_WQTY21 INT = 0.0 ,@x_WQTY22  INT = 0.0 ,@x_WQTY23  INT = 0.0 ,@x_WQTY24  INT = 0.0 ,@x_WQTY25  INT = 0.0
                     ,@x_WQTY26	INT = 0.0 ,@x_WQTY27  INT = 0.0 ,@x_WQTY28  INT = 0.0 ,@x_WQTY29  INT = 0.0 ,@x_WQTY30  INT = 0.0
                     ,@x_WQTY31 INT = 0.0 ,@x_WQTY32  INT = 0.0 ,@x_WQTY33  INT = 0.0 ,@x_WQTY34  INT = 0.0 ,@x_WQTY35  INT = 0.0
                     ,@x_WQTY36	INT = 0.0 ,@x_WQTY37  INT = 0.0 ,@x_WQTY38  INT = 0.0 ,@x_WQTY39  INT = 0.0 ,@x_WQTY40  INT = 0.0
                     ,@x_WQTY41 INT = 0.0 ,@x_WQTY42  INT = 0.0 ,@x_WQTY43  INT = 0.0 ,@x_WQTY44  INT = 0.0 ,@x_WQTY45  INT = 0.0
                     ,@x_WQTY46	INT = 0.0 ,@x_WQTY47  INT = 0.0 ,@x_WQTY48  INT = 0.0 ,@x_WQTY49  INT = 0.0 ,@x_WQTY50  INT = 0.0
                     ,@x_WQTY51 INT = 0.0 ,@x_WQTY52  INT = 0.0
            */
            /*
            IF @p_day_week_flag = 'day'
              BEGIN
                 SELECT @X_QTY001 = QTY001  ,@X_QTY002  = QTY002  ,@X_QTY003  = QTY003  ,@X_QTY004  = QTY004  ,@X_QTY005  = QTY005  ,@X_QTY006  = QTY006  ,@X_QTY007  = QTY007  ,@X_QTY008  = QTY008  ,@X_QTY009  = QTY009  ,@X_QTY010  = QTY010
                        ,@X_QTY011 = QTY011  ,@X_QTY012  = QTY012  ,@X_QTY013  = QTY013  ,@X_QTY014  = QTY014  ,@X_QTY015  = QTY015  ,@X_QTY016  = QTY016  ,@X_QTY017  = QTY017  ,@X_QTY018  = QTY018  ,@X_QTY019  = QTY019  ,@X_QTY020  = QTY020
                        ,@X_QTY021 = QTY021  ,@X_QTY022  = QTY022  ,@X_QTY023  = QTY023  ,@X_QTY024  = QTY024  ,@X_QTY025  = QTY025  ,@X_QTY026  = QTY026  ,@X_QTY027  = QTY027  ,@X_QTY028  = QTY028  ,@X_QTY029  = QTY029  ,@X_QTY030  = QTY030
                        ,@X_QTY031 = QTY031  ,@X_QTY032  = QTY032  ,@X_QTY033  = QTY033  ,@X_QTY034  = QTY034  ,@X_QTY035  = QTY035  ,@X_QTY036  = QTY036  ,@X_QTY037  = QTY037  ,@X_QTY038  = QTY038  ,@X_QTY039  = QTY039  ,@X_QTY040  = QTY040
                        ,@X_QTY041 = QTY041  ,@X_QTY042  = QTY042  ,@X_QTY043  = QTY043  ,@X_QTY044  = QTY044  ,@X_QTY045  = QTY045  ,@X_QTY046  = QTY046  ,@X_QTY047  = QTY047  ,@X_QTY048  = QTY048  ,@X_QTY049  = QTY049  ,@X_QTY050  = QTY050
                        ,@X_QTY051 = QTY051  ,@X_QTY052  = QTY052  ,@X_QTY053  = QTY053  ,@X_QTY054  = QTY054  ,@X_QTY055  = QTY055  ,@X_QTY056  = QTY056  ,@X_QTY057  = QTY057  ,@X_QTY058  = QTY058  ,@X_QTY059  = QTY059  ,@X_QTY060  = QTY060
                        ,@X_QTY061 = QTY061  ,@X_QTY062  = QTY062  ,@X_QTY063  = QTY063  ,@X_QTY064  = QTY064  ,@X_QTY065  = QTY065  ,@X_QTY066  = QTY066  ,@X_QTY067  = QTY067  ,@X_QTY068  = QTY068  ,@X_QTY069  = QTY069  ,@X_QTY070  = QTY070
                        ,@X_QTY071 = QTY071  ,@X_QTY072  = QTY072  ,@X_QTY073  = QTY073  ,@X_QTY074  = QTY074  ,@X_QTY075  = QTY075  ,@X_QTY076  = QTY076  ,@X_QTY077  = QTY077  ,@X_QTY078  = QTY078  ,@X_QTY079  = QTY079  ,@X_QTY080  = QTY080
                        ,@X_QTY081 = QTY081  ,@X_QTY082  = QTY082  ,@X_QTY083  = QTY083  ,@X_QTY084  = QTY084  ,@X_QTY085  = QTY085  ,@X_QTY086  = QTY086  ,@X_QTY087  = QTY087  ,@X_QTY088  = QTY088  ,@X_QTY089  = QTY089  ,@X_QTY090  = QTY090
                        ,@X_QTY091 = QTY091  ,@X_QTY092  = QTY092  ,@X_QTY093  = QTY093  ,@X_QTY094  = QTY094  ,@X_QTY095  = QTY095  ,@X_QTY096  = QTY096  ,@X_QTY097  = QTY097  ,@X_QTY098  = QTY098  ,@X_QTY099  = QTY099  ,@X_QTY100  = QTY100

                        ,@X_QTY101 = QTY101  ,@X_QTY102  = QTY102  ,@X_QTY103  = QTY103  ,@X_QTY104  = QTY004  ,@X_QTY105  = QTY105  ,@X_QTY106  = QTY106  ,@X_QTY107  = QTY107  ,@X_QTY108  = QTY108  ,@X_QTY109  = QTY109  ,@X_QTY110  = QTY110
                        ,@X_QTY111 = QTY111  ,@X_QTY112  = QTY112

                   FROM DBO.SCP_XLS_PSI_GLOBAL_ESS WITH(NOLOCK)
                  WHERE 0 = 0
                    AND DIVISION_ID         = @p_division_id
                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND SEQ                 = @p_seq
                    AND XLS_KEY1            = @p_xls_key1;
              END
              */
              /*
          IF @p_day_week_flag = 'week'
              BEGIN
                 SELECT @X_WQTY01 = WQTY01  ,@X_WQTY02  = WQTY02  ,@X_WQTY03  = WQTY03  ,@X_WQTY04  = WQTY04  ,@X_WQTY05  = WQTY05  ,@X_WQTY06  = WQTY06  ,@X_WQTY07  = WQTY07  ,@X_WQTY08  = WQTY08  ,@X_WQTY09  = WQTY09  ,@X_WQTY10  = WQTY10
                        ,@X_WQTY11 = WQTY11  ,@X_WQTY12  = WQTY12  ,@X_WQTY13  = WQTY13  ,@X_WQTY14  = WQTY14  ,@X_WQTY15  = WQTY15  ,@X_WQTY16  = WQTY16
                                                                                                                                                           ,@X_WQTY17  = WQTY17  ,@X_WQTY18  = WQTY18  ,@X_WQTY19  = WQTY19  ,@X_WQTY20  = WQTY20
                        ,@X_WQTY21 = WQTY21  ,@X_WQTY22  = WQTY22  ,@X_WQTY23  = WQTY23  ,@X_WQTY24  = WQTY24  ,@X_WQTY25  = WQTY25  ,@X_WQTY26  = WQTY26  ,@X_WQTY27  = WQTY27  ,@X_WQTY28  = WQTY28  ,@X_WQTY29  = WQTY29  ,@X_WQTY30  = WQTY30
                        ,@X_WQTY31 = WQTY31  ,@X_WQTY32  = WQTY32  ,@X_WQTY33  = WQTY33  ,@X_WQTY34  = WQTY34  ,@X_WQTY35  = WQTY35  ,@X_WQTY36  = WQTY36  ,@X_WQTY37  = WQTY37  ,@X_WQTY38  = WQTY38  ,@X_WQTY39  = WQTY39  ,@X_WQTY40  = WQTY40
                        ,@X_WQTY41 = WQTY41  ,@X_WQTY42  = WQTY42  ,@X_WQTY43  = WQTY43  ,@X_WQTY44  = WQTY44  ,@X_WQTY45  = WQTY45  ,@X_WQTY46  = WQTY46  ,@X_WQTY47  = WQTY47  ,@X_WQTY48  = WQTY48  ,@X_WQTY49  = WQTY49  ,@X_WQTY50  = WQTY50
                        ,@X_WQTY51 = WQTY51  ,@X_WQTY52  = WQTY52
                   FROM DBO.SCP_XLS_PSI_GLOBAL_ESS WITH(NOLOCK)
                  WHERE 0 = 0
                    AND DIVISION_ID         = @p_division_id
                    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                    AND SEQ                 = @p_seq
                    AND XLS_KEY1            = @p_xls_key1;
              END
              */

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_XLS_PSI_GLOBAL_ESS (XLSPSI04) 화면조회용 테이블에 해당 레코드를 수정한다. */
            /* ------------------------------------------------------------------------------------------- */
            /*  CELL_PROD,PACK_PROD         --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND' */
            /*  SEMI_SHIP_PLAN, SHIP_PLAN   --> SHIP_PLAN_AMEND */
            /* ------------------------------------------------------------------------------------------- */
            /*  WEEK DATA를 DAY DATA로 반영 */
            /*  확정 구간이 주에 포함될 경우 수정금지 구간을 제외하고, 일 배분해야 함. */
            /* ------------------------------------------------------------------------------------------- */

            IF P_MEASURE IN ('PACK_PROD', 'CELL_CHAR_PLAN', 'CELL_PROD') THEN   /* CELL_CHAR_PLAN SCP_XLS_PSI_GLOBAL_ESS 테이블에 저장만 처리함. */

               /*
               IF  @p_day_week_flag = 'day'
                BEGIN
                     UPDATE X
                        SET
                             QTY001 = @p_QTY001 ,QTY002  = @p_QTY002  ,QTY003 = @p_QTY003 ,QTY004 = @p_QTY004 ,QTY005  = @p_QTY005 ,QTY006  = @p_QTY006 ,QTY007 = @p_QTY007
                            ,QTY008 = @p_QTY008 ,QTY009  = @p_QTY009  ,QTY010 = @p_QTY010 ,QTY011 = @p_QTY011 ,QTY012  = @p_QTY012 ,QTY013  = @p_QTY013 ,QTY014 = @p_QTY014
                            ,QTY015 = @p_QTY015 ,QTY016  = @p_QTY016  ,QTY017 = @p_QTY017 ,QTY018 = @p_QTY018 ,QTY019  = @p_QTY019 ,QTY020  = @p_QTY020 ,QTY021 = @p_QTY021
                            ,QTY022 = @p_QTY022 ,QTY023  = @p_QTY023  ,QTY024 = @p_QTY024 ,QTY025 = @p_QTY025 ,QTY026  = @p_QTY026 ,QTY027  = @p_QTY027 ,QTY028 = @p_QTY028
                            ,QTY029 = @p_QTY029 ,QTY030  = @p_QTY030  ,QTY031 = @p_QTY031 ,QTY032 = @p_QTY032 ,QTY033  = @p_QTY033 ,QTY034  = @p_QTY034 ,QTY035 = @p_QTY035
                            ,QTY036 = @p_QTY036 ,QTY037  = @p_QTY037  ,QTY038 = @p_QTY038 ,QTY039 = @p_QTY039 ,QTY040  = @p_QTY040 ,QTY041  = @p_QTY041 ,QTY042 = @p_QTY042
                            ,QTY043 = @p_QTY043 ,QTY044  = @p_QTY044  ,QTY045 = @p_QTY045 ,QTY046 = @p_QTY046 ,QTY047  = @p_QTY047 ,QTY048  = @p_QTY048 ,QTY049 = @p_QTY049
                            ,QTY050 = @p_QTY050 ,QTY051  = @p_QTY051  ,QTY052 = @p_QTY052 ,QTY053 = @p_QTY053 ,QTY054  = @p_QTY054 ,QTY055  = @p_QTY055 ,QTY056 = @p_QTY056
                            ,QTY057 = @p_QTY057 ,QTY058  = @p_QTY058  ,QTY059 = @p_QTY059 ,QTY060 = @p_QTY060 ,QTY061  = @p_QTY061 ,QTY062  = @p_QTY062 ,QTY063 = @p_QTY063
                            ,QTY064 = @p_QTY064 ,QTY065  = @p_QTY065  ,QTY066 = @p_QTY066 ,QTY067 = @p_QTY067 ,QTY068  = @p_QTY068 ,QTY069  = @p_QTY069 ,QTY070 = @p_QTY070
                            ,QTY071 = @p_QTY071 ,QTY072  = @p_QTY072  ,QTY073 = @p_QTY073 ,QTY074 = @p_QTY074 ,QTY075  = @p_QTY075 ,QTY076  = @p_QTY076 ,QTY077 = @p_QTY077
                            ,QTY078 = @p_QTY078 ,QTY079  = @p_QTY079  ,QTY080 = @p_QTY080 ,QTY081 = @p_QTY081 ,QTY082  = @p_QTY082 ,QTY083  = @p_QTY083 ,QTY084 = @p_QTY084
                            ,QTY085 = @p_QTY085 ,QTY086  = @p_QTY086  ,QTY087 = @p_QTY087 ,QTY088 = @p_QTY088 ,QTY089  = @p_QTY089 ,QTY090  = @p_QTY090 ,QTY091 = @p_QTY091
                            ,QTY092 = @p_QTY092 ,QTY093  = @p_QTY093  ,QTY094 = @p_QTY094 ,QTY095 = @p_QTY095 ,QTY096  = @p_QTY096 ,QTY097  = @p_QTY097 ,QTY098 = @p_QTY098
                            ,QTY099 = @p_QTY099 ,QTY100  = @p_QTY100  ,QTY101 = @p_QTY101 ,QTY102 = @p_QTY102 ,QTY103  = @p_QTY103 ,QTY104  = @p_QTY104 ,QTY105 = @p_QTY105
                            ,QTY106 = @p_QTY106 ,QTY107  = @p_QTY107  ,QTY108 = @p_QTY108 ,QTY109 = @p_QTY109 ,QTY110  = @p_QTY110 ,QTY111  = @p_QTY111 ,QTY112 = @p_QTY112

                            ,LAST_UPDATED_BY    = @p_user_id
                            ,LAST_UPDATE_DATE   = GETDATE()
                      FROM SCP_XLS_PSI_GLOBAL_ESS X  WITH (NOLOCK)
                      WHERE 0 = 0
                        AND DIVISION_ID         = @p_division_id
                        AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                        AND SEQ                 = @p_seq
                        AND XLS_KEY1            = @p_xls_key1;

                END  --  @p_day_week_flag = 'day'
                */

                IF P_DAY_WEEK_FLAG = 'week' THEN


                    UPDATE SCP_XLS_PSI_GLOBAL_ESS
                       SET QTY001 = TRUNC(P_WQTY01 / 7), QTY002 = TRUNC(P_WQTY01 / 7), QTY003 = TRUNC(P_WQTY01 / 7), QTY004 = TRUNC(P_WQTY01 / 7), QTY005 = TRUNC(P_WQTY01 / 7)
                         , QTY006 = TRUNC(P_WQTY01 / 7), QTY007 = ((TRUNC(P_WQTY01 / 7)) + (MOD(P_WQTY01, 7))), QTY008 = TRUNC(P_WQTY02 / 7), QTY009 = TRUNC(P_WQTY02 / 7), QTY010 = TRUNC(P_WQTY02 / 7)
                         , QTY011 = TRUNC(P_WQTY02 / 7), QTY012 = TRUNC(P_WQTY02 / 7), QTY013 = TRUNC(P_WQTY02 / 7), QTY014 = ((TRUNC(P_WQTY02 / 7)) + (MOD(P_WQTY02, 7))), QTY015 = TRUNC(P_WQTY03 / 7)
                         , QTY016 = TRUNC(P_WQTY03 / 7), QTY017 = TRUNC(P_WQTY03 / 7), QTY018 = TRUNC(P_WQTY03 / 7), QTY019 = TRUNC(P_WQTY03 / 7), QTY020 = TRUNC(P_WQTY03 / 7)
                         , QTY021 = ((TRUNC(P_WQTY03 / 7)) + (MOD(P_WQTY03, 7))), QTY022 = TRUNC(P_WQTY04 / 7), QTY023 = TRUNC(P_WQTY04 / 7), QTY024 = TRUNC(P_WQTY04 / 7), QTY025 = TRUNC(P_WQTY04 / 7)
                         , QTY026 = TRUNC(P_WQTY04 / 7), QTY027 = TRUNC(P_WQTY04 / 7), QTY028 = ((TRUNC(P_WQTY04 / 7)) + (MOD(P_WQTY04, 7))), QTY029 = TRUNC(P_WQTY05 / 7), QTY030 = TRUNC(P_WQTY05 / 7)
                         , QTY031 = TRUNC(P_WQTY05 / 7), QTY032 = TRUNC(P_WQTY05 / 7), QTY033 = TRUNC(P_WQTY05 / 7), QTY034 = TRUNC(P_WQTY05 / 7), QTY035 = ((TRUNC(P_WQTY05 / 7)) + (MOD(P_WQTY05, 7)))
                         , QTY036 = TRUNC(P_WQTY06 / 7), QTY037 = TRUNC(P_WQTY06 / 7), QTY038 = TRUNC(P_WQTY06 / 7), QTY039 = TRUNC(P_WQTY06 / 7), QTY040 = TRUNC(P_WQTY06 / 7)
                         , QTY041 = TRUNC(P_WQTY06 / 7), QTY042 = ((TRUNC(P_WQTY06 / 7)) + (MOD(P_WQTY06, 7))), QTY043 = TRUNC(P_WQTY07 / 7), QTY044 = TRUNC(P_WQTY07 / 7), QTY045 = TRUNC(P_WQTY07 / 7)
                         , QTY046 = TRUNC(P_WQTY07 / 7), QTY047 = TRUNC(P_WQTY07 / 7), QTY048 = TRUNC(P_WQTY07 / 7), QTY049 = ((TRUNC(P_WQTY07 / 7)) + (MOD(P_WQTY07, 7))), QTY050 = TRUNC(P_WQTY08 / 7)
                         , QTY051 = TRUNC(P_WQTY08 / 7), QTY052 = TRUNC(P_WQTY08 / 7), QTY053 = TRUNC(P_WQTY08 / 7), QTY054 = TRUNC(P_WQTY08 / 7), QTY055 = TRUNC(P_WQTY08 / 7)
                         , QTY056 = ((TRUNC(P_WQTY08 / 7)) + (MOD(P_WQTY08, 7))), QTY057 = TRUNC(P_WQTY09 / 7), QTY058 = TRUNC(P_WQTY09 / 7), QTY059 = TRUNC(P_WQTY09 / 7), QTY060 = TRUNC(P_WQTY09 / 7)
                         , QTY061 = TRUNC(P_WQTY09 / 7), QTY062 = TRUNC(P_WQTY09 / 7), QTY063 = ((TRUNC(P_WQTY09 / 7)) + (MOD(P_WQTY09, 7))), QTY064 = TRUNC(P_WQTY10 / 7), QTY065 = TRUNC(P_WQTY10 / 7)
                         , QTY066 = TRUNC(P_WQTY10 / 7), QTY067 = TRUNC(P_WQTY10 / 7), QTY068 = TRUNC(P_WQTY10 / 7), QTY069 = TRUNC(P_WQTY10 / 7), QTY070 = ((TRUNC(P_WQTY10 / 7)) + (MOD(P_WQTY10, 7)))
                         , QTY071 = TRUNC(P_WQTY11 / 7), QTY072 = TRUNC(P_WQTY11 / 7), QTY073 = TRUNC(P_WQTY11 / 7), QTY074 = TRUNC(P_WQTY11 / 7), QTY075 = TRUNC(P_WQTY11 / 7)
                         , QTY076 = TRUNC(P_WQTY11 / 7), QTY077 = ((TRUNC(P_WQTY11 / 7)) + (MOD(P_WQTY11, 7))), QTY078 = TRUNC(P_WQTY12 / 7), QTY079 = TRUNC(P_WQTY12 / 7), QTY080 = TRUNC(P_WQTY12 / 7)
                         , QTY081 = TRUNC(P_WQTY12 / 7), QTY082 = TRUNC(P_WQTY12 / 7), QTY083 = TRUNC(P_WQTY12 / 7), QTY084 = ((TRUNC(P_WQTY12 / 7)) + (MOD(P_WQTY12, 7))), QTY085 = TRUNC(P_WQTY13 / 7)
                         , QTY086 = TRUNC(P_WQTY13 / 7), QTY087 = TRUNC(P_WQTY13 / 7), QTY088 = TRUNC(P_WQTY13 / 7), QTY089 = TRUNC(P_WQTY13 / 7), QTY090 = TRUNC(P_WQTY13 / 7)
                         , QTY091 = ((TRUNC(P_WQTY13 / 7)) + (MOD(P_WQTY13, 7))), QTY092 = TRUNC(P_WQTY14 / 7), QTY093 = TRUNC(P_WQTY14 / 7), QTY094 = TRUNC(P_WQTY14 / 7), QTY095 = TRUNC(P_WQTY14 / 7)
                         , QTY096 = TRUNC(P_WQTY14 / 7), QTY097 = TRUNC(P_WQTY14 / 7), QTY098 = ((TRUNC(P_WQTY14 / 7)) + (MOD(P_WQTY14, 7))), QTY099 = TRUNC(P_WQTY15 / 7), QTY100 = TRUNC(P_WQTY15 / 7)
                         , QTY101 = TRUNC(P_WQTY15 / 7), QTY102 = TRUNC(P_WQTY15 / 7), QTY103 = TRUNC(P_WQTY15 / 7), QTY104 = TRUNC(P_WQTY15 / 7), QTY105 = ((TRUNC(P_WQTY15 / 7)) + (MOD(P_WQTY15, 7)))
                         , QTY106 = TRUNC(P_WQTY16 / 7), QTY107 = TRUNC(P_WQTY16 / 7), QTY108 = TRUNC(P_WQTY16 / 7), QTY109 = TRUNC(P_WQTY16 / 7), QTY110 = TRUNC(P_WQTY16 / 7)
                         , QTY111 = TRUNC(P_WQTY16 / 7), QTY112 = ((TRUNC(P_WQTY16 / 7)) + (MOD(P_WQTY16, 7))), QTY113 = TRUNC(P_WQTY17 / 7), QTY114 = TRUNC(P_WQTY17 / 7), QTY115 = TRUNC(P_WQTY17 / 7)
                         , QTY116 = TRUNC(P_WQTY17 / 7), QTY117 = TRUNC(P_WQTY17 / 7), QTY118 = TRUNC(P_WQTY17 / 7), QTY119 = ((TRUNC(P_WQTY17 / 7)) + (MOD(P_WQTY17, 7))), QTY120 = TRUNC(P_WQTY18 / 7)
                         , QTY121 = TRUNC(P_WQTY18 / 7), QTY122 = TRUNC(P_WQTY18 / 7), QTY123 = TRUNC(P_WQTY18 / 7), QTY124 = TRUNC(P_WQTY18 / 7), QTY125 = TRUNC(P_WQTY18 / 7)
                         , QTY126 = ((TRUNC(P_WQTY18 / 7)) + (MOD(P_WQTY18, 7))), QTY127 = TRUNC(P_WQTY19 / 7), QTY128 = TRUNC(P_WQTY19 / 7), QTY129 = TRUNC(P_WQTY19 / 7), QTY130 = TRUNC(P_WQTY19 / 7)
                         , QTY131 = TRUNC(P_WQTY19 / 7), QTY132 = TRUNC(P_WQTY19 / 7), QTY133 = ((TRUNC(P_WQTY19 / 7)) + (MOD(P_WQTY19, 7))), QTY134 = TRUNC(P_WQTY20 / 7), QTY135 = TRUNC(P_WQTY20 / 7)
                         , QTY136 = TRUNC(P_WQTY20 / 7), QTY137 = TRUNC(P_WQTY20 / 7), QTY138 = TRUNC(P_WQTY20 / 7), QTY139 = TRUNC(P_WQTY20 / 7), QTY140 = ((TRUNC(P_WQTY20 / 7)) + (MOD(P_WQTY20, 7)))
                         , QTY141 = TRUNC(P_WQTY21 / 7), QTY142 = TRUNC(P_WQTY21 / 7), QTY143 = TRUNC(P_WQTY21 / 7), QTY144 = TRUNC(P_WQTY21 / 7), QTY145 = TRUNC(P_WQTY21 / 7)
                         , QTY146 = TRUNC(P_WQTY21 / 7), QTY147 = ((TRUNC(P_WQTY21 / 7)) + (MOD(P_WQTY21, 7))), QTY148 = TRUNC(P_WQTY22 / 7), QTY149 = TRUNC(P_WQTY22 / 7), QTY150 = TRUNC(P_WQTY22 / 7)
                         , QTY151 = TRUNC(P_WQTY22 / 7), QTY152 = TRUNC(P_WQTY22 / 7), QTY153 = TRUNC(P_WQTY22 / 7), QTY154 = ((TRUNC(P_WQTY22 / 7)) + (MOD(P_WQTY22, 7))), QTY155 = TRUNC(P_WQTY23 / 7)
                         , QTY156 = TRUNC(P_WQTY23 / 7), QTY157 = TRUNC(P_WQTY23 / 7), QTY158 = TRUNC(P_WQTY23 / 7), QTY159 = TRUNC(P_WQTY23 / 7), QTY160 = TRUNC(P_WQTY23 / 7)
                         , QTY161 = ((TRUNC(P_WQTY23 / 7)) + (MOD(P_WQTY23, 7))), QTY162 = TRUNC(P_WQTY24 / 7), QTY163 = TRUNC(P_WQTY24 / 7), QTY164 = TRUNC(P_WQTY24 / 7), QTY165 = TRUNC(P_WQTY24 / 7)
                         , QTY166 = TRUNC(P_WQTY24 / 7), QTY167 = TRUNC(P_WQTY24 / 7), QTY168 = ((TRUNC(P_WQTY24 / 7)) + (MOD(P_WQTY24, 7))), QTY169 = TRUNC(P_WQTY25 / 7), QTY170 = TRUNC(P_WQTY25 / 7)
                         , QTY171 = TRUNC(P_WQTY25 / 7), QTY172 = TRUNC(P_WQTY25 / 7), QTY173 = TRUNC(P_WQTY25 / 7), QTY174 = TRUNC(P_WQTY25 / 7), QTY175 = ((TRUNC(P_WQTY25 / 7)) + (MOD(P_WQTY25, 7)))
                         , QTY176 = TRUNC(P_WQTY26 / 7), QTY177 = TRUNC(P_WQTY26 / 7), QTY178 = TRUNC(P_WQTY26 / 7), QTY179 = TRUNC(P_WQTY26 / 7), QTY180 = TRUNC(P_WQTY26 / 7)
                         , QTY181 = TRUNC(P_WQTY26 / 7), QTY182 = ((TRUNC(P_WQTY26 / 7)) + (MOD(P_WQTY26, 7))), QTY183 = TRUNC(P_WQTY27 / 7), QTY184 = TRUNC(P_WQTY27 / 7), QTY185 = TRUNC(P_WQTY27 / 7)
                         , QTY186 = TRUNC(P_WQTY27 / 7), QTY187 = TRUNC(P_WQTY27 / 7), QTY188 = TRUNC(P_WQTY27 / 7), QTY189 = ((TRUNC(P_WQTY27 / 7)) + (MOD(P_WQTY27, 7))), QTY190 = TRUNC(P_WQTY28 / 7)
                         , QTY191 = TRUNC(P_WQTY28 / 7), QTY192 = TRUNC(P_WQTY28 / 7), QTY193 = TRUNC(P_WQTY28 / 7), QTY194 = TRUNC(P_WQTY28 / 7), QTY195 = TRUNC(P_WQTY28 / 7)
                         , QTY196 = ((TRUNC(P_WQTY28 / 7)) + (MOD(P_WQTY28, 7))), QTY197 = TRUNC(P_WQTY29 / 7), QTY198 = TRUNC(P_WQTY29 / 7), QTY199 = TRUNC(P_WQTY29 / 7), QTY200 = TRUNC(P_WQTY29 / 7)
                         , QTY201 = TRUNC(P_WQTY29 / 7), QTY202 = TRUNC(P_WQTY29 / 7), QTY203 = ((TRUNC(P_WQTY29 / 7)) + (MOD(P_WQTY29, 7))), QTY204 = TRUNC(P_WQTY30 / 7), QTY205 = TRUNC(P_WQTY30 / 7)
                         , QTY206 = TRUNC(P_WQTY30 / 7), QTY207 = TRUNC(P_WQTY30 / 7), QTY208 = TRUNC(P_WQTY30 / 7), QTY209 = TRUNC(P_WQTY30 / 7), QTY210 = ((TRUNC(P_WQTY30 / 7)) + (MOD(P_WQTY30, 7)))
                         , QTY211 = TRUNC(P_WQTY31 / 7), QTY212 = TRUNC(P_WQTY31 / 7), QTY213 = TRUNC(P_WQTY31 / 7), QTY214 = TRUNC(P_WQTY31 / 7), QTY215 = TRUNC(P_WQTY31 / 7)
                         , QTY216 = TRUNC(P_WQTY31 / 7), QTY217 = ((TRUNC(P_WQTY31 / 7)) + (MOD(P_WQTY31, 7))), QTY218 = TRUNC(P_WQTY32 / 7), QTY219 = TRUNC(P_WQTY32 / 7), QTY220 = TRUNC(P_WQTY32 / 7)
                         , QTY221 = TRUNC(P_WQTY32 / 7), QTY222 = TRUNC(P_WQTY32 / 7), QTY223 = TRUNC(P_WQTY32 / 7), QTY224 = ((TRUNC(P_WQTY32 / 7)) + (MOD(P_WQTY32, 7))), QTY225 = TRUNC(P_WQTY33 / 7)
                         , QTY226 = TRUNC(P_WQTY33 / 7), QTY227 = TRUNC(P_WQTY33 / 7), QTY228 = TRUNC(P_WQTY33 / 7), QTY229 = TRUNC(P_WQTY33 / 7), QTY230 = TRUNC(P_WQTY33 / 7)
                         , QTY231 = ((TRUNC(P_WQTY33 / 7)) + (MOD(P_WQTY33, 7))), QTY232 = TRUNC(P_WQTY34 / 7), QTY233 = TRUNC(P_WQTY34 / 7), QTY234 = TRUNC(P_WQTY34 / 7), QTY235 = TRUNC(P_WQTY34 / 7)
                         , QTY236 = TRUNC(P_WQTY34 / 7), QTY237 = TRUNC(P_WQTY34 / 7), QTY238 = ((TRUNC(P_WQTY34 / 7)) + (MOD(P_WQTY34, 7))), QTY239 = TRUNC(P_WQTY35 / 7), QTY240 = TRUNC(P_WQTY35 / 7)
                         , QTY241 = TRUNC(P_WQTY35 / 7), QTY242 = TRUNC(P_WQTY35 / 7), QTY243 = TRUNC(P_WQTY35 / 7), QTY244 = TRUNC(P_WQTY35 / 7), QTY245 = ((TRUNC(P_WQTY35 / 7)) + (MOD(P_WQTY35, 7)))
                         , QTY246 = TRUNC(P_WQTY36 / 7), QTY247 = TRUNC(P_WQTY36 / 7), QTY248 = TRUNC(P_WQTY36 / 7), QTY249 = TRUNC(P_WQTY36 / 7), QTY250 = TRUNC(P_WQTY36 / 7)
                         , QTY251 = TRUNC(P_WQTY36 / 7), QTY252 = ((TRUNC(P_WQTY36 / 7)) + (MOD(P_WQTY36, 7))), QTY253 = TRUNC(P_WQTY37 / 7), QTY254 = TRUNC(P_WQTY37 / 7), QTY255 = TRUNC(P_WQTY37 / 7)
                         , QTY256 = TRUNC(P_WQTY37 / 7), QTY257 = TRUNC(P_WQTY37 / 7), QTY258 = TRUNC(P_WQTY37 / 7), QTY259 = ((TRUNC(P_WQTY37 / 7)) + (MOD(P_WQTY37, 7))), QTY260 = TRUNC(P_WQTY38 / 7)
                         , QTY261 = TRUNC(P_WQTY38 / 7), QTY262 = TRUNC(P_WQTY38 / 7), QTY263 = TRUNC(P_WQTY38 / 7), QTY264 = TRUNC(P_WQTY38 / 7), QTY265 = TRUNC(P_WQTY38 / 7)
                         , QTY266 = ((TRUNC(P_WQTY38 / 7)) + (MOD(P_WQTY38, 7))), QTY267 = TRUNC(P_WQTY39 / 7), QTY268 = TRUNC(P_WQTY39 / 7), QTY269 = TRUNC(P_WQTY39 / 7), QTY270 = TRUNC(P_WQTY39 / 7)
                         , QTY271 = TRUNC(P_WQTY39 / 7), QTY272 = TRUNC(P_WQTY39 / 7), QTY273 = ((TRUNC(P_WQTY39 / 7)) + (MOD(P_WQTY39, 7))), QTY274 = TRUNC(P_WQTY40 / 7), QTY275 = TRUNC(P_WQTY40 / 7)
                         , QTY276 = TRUNC(P_WQTY40 / 7), QTY277 = TRUNC(P_WQTY40 / 7), QTY278 = TRUNC(P_WQTY40 / 7), QTY279 = TRUNC(P_WQTY40 / 7), QTY280 = ((TRUNC(P_WQTY40 / 7)) + (MOD(P_WQTY40, 7)))
                         , QTY281 = TRUNC(P_WQTY41 / 7), QTY282 = TRUNC(P_WQTY41 / 7), QTY283 = TRUNC(P_WQTY41 / 7), QTY284 = TRUNC(P_WQTY41 / 7), QTY285 = TRUNC(P_WQTY41 / 7)
                         , QTY286 = TRUNC(P_WQTY41 / 7), QTY287 = ((TRUNC(P_WQTY41 / 7)) + (MOD(P_WQTY41, 7))), QTY288 = TRUNC(P_WQTY42 / 7), QTY289 = TRUNC(P_WQTY42 / 7), QTY290 = TRUNC(P_WQTY42 / 7)
                         , QTY291 = TRUNC(P_WQTY42 / 7), QTY292 = TRUNC(P_WQTY42 / 7), QTY293 = TRUNC(P_WQTY42 / 7), QTY294 = ((TRUNC(P_WQTY42 / 7)) + (MOD(P_WQTY42, 7))), QTY295 = TRUNC(P_WQTY43 / 7)
                         , QTY296 = TRUNC(P_WQTY43 / 7), QTY297 = TRUNC(P_WQTY43 / 7), QTY298 = TRUNC(P_WQTY43 / 7), QTY299 = TRUNC(P_WQTY43 / 7), QTY300 = TRUNC(P_WQTY43 / 7)
                         , QTY301 = ((TRUNC(P_WQTY43 / 7)) + (MOD(P_WQTY43, 7))), QTY302 = TRUNC(P_WQTY44 / 7), QTY303 = TRUNC(P_WQTY44 / 7), QTY304 = TRUNC(P_WQTY44 / 7), QTY305 = TRUNC(P_WQTY44 / 7)
                         , QTY306 = TRUNC(P_WQTY44 / 7), QTY307 = TRUNC(P_WQTY44 / 7), QTY308 = ((TRUNC(P_WQTY44 / 7)) + (MOD(P_WQTY44, 7))), QTY309 = TRUNC(P_WQTY45 / 7), QTY310 = TRUNC(P_WQTY45 / 7)
                         , QTY311 = TRUNC(P_WQTY45 / 7), QTY312 = TRUNC(P_WQTY45 / 7), QTY313 = TRUNC(P_WQTY45 / 7), QTY314 = TRUNC(P_WQTY45 / 7), QTY315 = ((TRUNC(P_WQTY45 / 7)) + (MOD(P_WQTY45, 7)))
                         , QTY316 = TRUNC(P_WQTY46 / 7), QTY317 = TRUNC(P_WQTY46 / 7), QTY318 = TRUNC(P_WQTY46 / 7), QTY319 = TRUNC(P_WQTY46 / 7), QTY320 = TRUNC(P_WQTY46 / 7)
                         , QTY321 = TRUNC(P_WQTY46 / 7), QTY322 = ((TRUNC(P_WQTY46 / 7)) + (MOD(P_WQTY46, 7))), QTY323 = TRUNC(P_WQTY47 / 7), QTY324 = TRUNC(P_WQTY47 / 7), QTY325 = TRUNC(P_WQTY47 / 7)
                         , QTY326 = TRUNC(P_WQTY47 / 7), QTY327 = TRUNC(P_WQTY47 / 7), QTY328 = TRUNC(P_WQTY47 / 7), QTY329 = ((TRUNC(P_WQTY47 / 7)) + (MOD(P_WQTY47, 7))), QTY330 = TRUNC(P_WQTY48 / 7)
                         , QTY331 = TRUNC(P_WQTY48 / 7), QTY332 = TRUNC(P_WQTY48 / 7), QTY333 = TRUNC(P_WQTY48 / 7), QTY334 = TRUNC(P_WQTY48 / 7), QTY335 = TRUNC(P_WQTY48 / 7)
                         , QTY336 = ((TRUNC(P_WQTY48 / 7)) + (MOD(P_WQTY48, 7))), QTY337 = TRUNC(P_WQTY49 / 7), QTY338 = TRUNC(P_WQTY49 / 7), QTY339 = TRUNC(P_WQTY49 / 7), QTY340 = TRUNC(P_WQTY49 / 7)
                         , QTY341 = TRUNC(P_WQTY49 / 7), QTY342 = TRUNC(P_WQTY49 / 7), QTY343 = ((TRUNC(P_WQTY49 / 7)) + (MOD(P_WQTY49, 7))), QTY344 = TRUNC(P_WQTY50 / 7), QTY345 = TRUNC(P_WQTY50 / 7)
                         , QTY346 = TRUNC(P_WQTY50 / 7), QTY347 = TRUNC(P_WQTY50 / 7), QTY348 = TRUNC(P_WQTY50 / 7), QTY349 = TRUNC(P_WQTY50 / 7), QTY350 = ((TRUNC(P_WQTY50 / 7)) + (MOD(P_WQTY50, 7)))
                         , QTY351 = TRUNC(P_WQTY51 / 7), QTY352 = TRUNC(P_WQTY51 / 7), QTY353 = TRUNC(P_WQTY51 / 7), QTY354 = TRUNC(P_WQTY51 / 7), QTY355 = TRUNC(P_WQTY51 / 7)
                         , QTY356 = TRUNC(P_WQTY51 / 7), QTY357 = ((TRUNC(P_WQTY51 / 7)) + (MOD(P_WQTY51, 7))), QTY358 = TRUNC(P_WQTY52 / 7), QTY359 = TRUNC(P_WQTY52 / 7), QTY360 = TRUNC(P_WQTY52 / 7)
                         , QTY361 = TRUNC(P_WQTY52 / 7), QTY362 = TRUNC(P_WQTY52 / 7), QTY363 = TRUNC(P_WQTY52 / 7), QTY364 = ((TRUNC(P_WQTY52 / 7)) + (MOD(P_WQTY52, 7)))
                         , WQTY01 = P_WQTY01, WQTY02 = P_WQTY02, WQTY03 = P_WQTY03, WQTY04 = P_WQTY04, WQTY05 = P_WQTY05
                         , WQTY06 = P_WQTY06, WQTY07 = P_WQTY07, WQTY08 = P_WQTY08, WQTY09 = P_WQTY09, WQTY10 = P_WQTY10
                         , WQTY11 = P_WQTY11, WQTY12 = P_WQTY12, WQTY13 = P_WQTY13, WQTY14 = P_WQTY14, WQTY15 = P_WQTY15
                         , WQTY16 = P_WQTY16, WQTY17 = P_WQTY17, WQTY18 = P_WQTY18, WQTY19 = P_WQTY19, WQTY20 = P_WQTY20
                         , WQTY21 = P_WQTY21, WQTY22 = P_WQTY22, WQTY23 = P_WQTY23, WQTY24 = P_WQTY24, WQTY25 = P_WQTY25
                         , WQTY26 = P_WQTY26, WQTY27 = P_WQTY27, WQTY28 = P_WQTY28, WQTY29 = P_WQTY29, WQTY30 = P_WQTY30
                         , WQTY31 = P_WQTY31, WQTY32 = P_WQTY32, WQTY33 = P_WQTY33, WQTY34 = P_WQTY34, WQTY35 = P_WQTY35
                         , WQTY36 = P_WQTY36, WQTY37 = P_WQTY37, WQTY38 = P_WQTY38, WQTY39 = P_WQTY39, WQTY40 = P_WQTY40
                         , WQTY41 = P_WQTY41, WQTY42 = P_WQTY42, WQTY43 = P_WQTY43, WQTY44 = P_WQTY44, WQTY45 = P_WQTY45
                         , WQTY46 = P_WQTY46, WQTY47 = P_WQTY47, WQTY48 = P_WQTY48, WQTY49 = P_WQTY49, WQTY50 = P_WQTY50
                         , WQTY51 = P_WQTY51, WQTY52 = P_WQTY52
                         , LAST_UPDATED_BY    = V_P_USER_ID
                         , LAST_UPDATE_DATE   = SYSDATE
                         , ATTRIBUTE2         = 'Y'
                     WHERE 0 = 0
                       AND DIVISION_ID         = P_DIVISION_ID
                       AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND SEQ                 = P_SEQ
                       AND XLS_KEY1            = P_XLS_KEY1;

                END IF;   /*  @p_day_week_flag = 'week' */

            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  'SHIP_PLAN','SEMI_SHIP_PLAN' 일경우 지정 요일에 저장 */
            /*   대상 주QTY가 -9 일경우는 기존 값(0)을 사용하고, +일경우는 값을 UPDATE한다. */
            /* ------------------------------------------------------------------------------------------- */
            IF P_MEASURE IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN') THEN

               IF P_DAY_WEEK_FLAG = 'week' THEN

                  /*  MSSQL UPDATE X SET .. FROM #DAY_SCP_XLS_PSI_GLOBAL X : 조인 없는 자기 갱신이라 단순 UPDATE */
                  UPDATE GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL
                     SET QTY001 = (CASE WHEN P_WQTY01 < 0 THEN QTY001 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY01 ELSE 0 END) END)
                       , QTY002 = (CASE WHEN P_WQTY01 < 0 THEN QTY002 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY01 ELSE 0 END) END)
                       , QTY003 = (CASE WHEN P_WQTY01 < 0 THEN QTY003 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY01 ELSE 0 END) END)
                       , QTY004 = (CASE WHEN P_WQTY01 < 0 THEN QTY004 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY01 ELSE 0 END) END)
                       , QTY005 = (CASE WHEN P_WQTY01 < 0 THEN QTY005 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY01 ELSE 0 END) END)
                       , QTY006 = (CASE WHEN P_WQTY01 < 0 THEN QTY006 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY01 ELSE 0 END) END)
                       , QTY007 = (CASE WHEN P_WQTY01 < 0 THEN QTY007 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY01 ELSE 0 END) END)
                       , QTY008 = (CASE WHEN P_WQTY02 < 0 THEN QTY008 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY02 ELSE 0 END) END)
                       , QTY009 = (CASE WHEN P_WQTY02 < 0 THEN QTY009 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY02 ELSE 0 END) END)
                       , QTY010 = (CASE WHEN P_WQTY02 < 0 THEN QTY010 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY02 ELSE 0 END) END)
                       , QTY011 = (CASE WHEN P_WQTY02 < 0 THEN QTY011 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY02 ELSE 0 END) END)
                       , QTY012 = (CASE WHEN P_WQTY02 < 0 THEN QTY012 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY02 ELSE 0 END) END)
                       , QTY013 = (CASE WHEN P_WQTY02 < 0 THEN QTY013 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY02 ELSE 0 END) END)
                       , QTY014 = (CASE WHEN P_WQTY02 < 0 THEN QTY014 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY02 ELSE 0 END) END)
                       , QTY015 = (CASE WHEN P_WQTY03 < 0 THEN QTY015 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY03 ELSE 0 END) END)
                       , QTY016 = (CASE WHEN P_WQTY03 < 0 THEN QTY016 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY03 ELSE 0 END) END)
                       , QTY017 = (CASE WHEN P_WQTY03 < 0 THEN QTY017 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY03 ELSE 0 END) END)
                       , QTY018 = (CASE WHEN P_WQTY03 < 0 THEN QTY018 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY03 ELSE 0 END) END)
                       , QTY019 = (CASE WHEN P_WQTY03 < 0 THEN QTY019 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY03 ELSE 0 END) END)
                       , QTY020 = (CASE WHEN P_WQTY03 < 0 THEN QTY020 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY03 ELSE 0 END) END)
                       , QTY021 = (CASE WHEN P_WQTY03 < 0 THEN QTY021 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY03 ELSE 0 END) END)
                       , QTY022 = (CASE WHEN P_WQTY04 < 0 THEN QTY022 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY04 ELSE 0 END) END)
                       , QTY023 = (CASE WHEN P_WQTY04 < 0 THEN QTY023 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY04 ELSE 0 END) END)
                       , QTY024 = (CASE WHEN P_WQTY04 < 0 THEN QTY024 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY04 ELSE 0 END) END)
                       , QTY025 = (CASE WHEN P_WQTY04 < 0 THEN QTY025 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY04 ELSE 0 END) END)
                       , QTY026 = (CASE WHEN P_WQTY04 < 0 THEN QTY026 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY04 ELSE 0 END) END)
                       , QTY027 = (CASE WHEN P_WQTY04 < 0 THEN QTY027 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY04 ELSE 0 END) END)
                       , QTY028 = (CASE WHEN P_WQTY04 < 0 THEN QTY028 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY04 ELSE 0 END) END)
                       , QTY029 = (CASE WHEN P_WQTY05 < 0 THEN QTY029 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY05 ELSE 0 END) END)
                       , QTY030 = (CASE WHEN P_WQTY05 < 0 THEN QTY030 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY05 ELSE 0 END) END)
                       , QTY031 = (CASE WHEN P_WQTY05 < 0 THEN QTY031 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY05 ELSE 0 END) END)
                       , QTY032 = (CASE WHEN P_WQTY05 < 0 THEN QTY032 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY05 ELSE 0 END) END)
                       , QTY033 = (CASE WHEN P_WQTY05 < 0 THEN QTY033 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY05 ELSE 0 END) END)
                       , QTY034 = (CASE WHEN P_WQTY05 < 0 THEN QTY034 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY05 ELSE 0 END) END)
                       , QTY035 = (CASE WHEN P_WQTY05 < 0 THEN QTY035 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY05 ELSE 0 END) END)
                       , QTY036 = (CASE WHEN P_WQTY06 < 0 THEN QTY036 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY06 ELSE 0 END) END)
                       , QTY037 = (CASE WHEN P_WQTY06 < 0 THEN QTY037 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY06 ELSE 0 END) END)
                       , QTY038 = (CASE WHEN P_WQTY06 < 0 THEN QTY038 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY06 ELSE 0 END) END)
                       , QTY039 = (CASE WHEN P_WQTY06 < 0 THEN QTY039 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY06 ELSE 0 END) END)
                       , QTY040 = (CASE WHEN P_WQTY06 < 0 THEN QTY040 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY06 ELSE 0 END) END)
                       , QTY041 = (CASE WHEN P_WQTY06 < 0 THEN QTY041 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY06 ELSE 0 END) END)
                       , QTY042 = (CASE WHEN P_WQTY06 < 0 THEN QTY042 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY06 ELSE 0 END) END)
                       , QTY043 = (CASE WHEN P_WQTY07 < 0 THEN QTY043 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY07 ELSE 0 END) END)
                       , QTY044 = (CASE WHEN P_WQTY07 < 0 THEN QTY044 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY07 ELSE 0 END) END)
                       , QTY045 = (CASE WHEN P_WQTY07 < 0 THEN QTY045 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY07 ELSE 0 END) END)
                       , QTY046 = (CASE WHEN P_WQTY07 < 0 THEN QTY046 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY07 ELSE 0 END) END)
                       , QTY047 = (CASE WHEN P_WQTY07 < 0 THEN QTY047 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY07 ELSE 0 END) END)
                       , QTY048 = (CASE WHEN P_WQTY07 < 0 THEN QTY048 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY07 ELSE 0 END) END)
                       , QTY049 = (CASE WHEN P_WQTY07 < 0 THEN QTY049 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY07 ELSE 0 END) END)
                       , QTY050 = (CASE WHEN P_WQTY08 < 0 THEN QTY050 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY08 ELSE 0 END) END)
                       , QTY051 = (CASE WHEN P_WQTY08 < 0 THEN QTY051 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY08 ELSE 0 END) END)
                       , QTY052 = (CASE WHEN P_WQTY08 < 0 THEN QTY052 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY08 ELSE 0 END) END)
                       , QTY053 = (CASE WHEN P_WQTY08 < 0 THEN QTY053 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY08 ELSE 0 END) END)
                       , QTY054 = (CASE WHEN P_WQTY08 < 0 THEN QTY054 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY08 ELSE 0 END) END)
                       , QTY055 = (CASE WHEN P_WQTY08 < 0 THEN QTY055 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY08 ELSE 0 END) END)
                       , QTY056 = (CASE WHEN P_WQTY08 < 0 THEN QTY056 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY08 ELSE 0 END) END)
                       , QTY057 = (CASE WHEN P_WQTY09 < 0 THEN QTY057 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY09 ELSE 0 END) END)
                       , QTY058 = (CASE WHEN P_WQTY09 < 0 THEN QTY058 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY09 ELSE 0 END) END)
                       , QTY059 = (CASE WHEN P_WQTY09 < 0 THEN QTY059 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY09 ELSE 0 END) END)
                       , QTY060 = (CASE WHEN P_WQTY09 < 0 THEN QTY060 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY09 ELSE 0 END) END)
                       , QTY061 = (CASE WHEN P_WQTY09 < 0 THEN QTY061 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY09 ELSE 0 END) END)
                       , QTY062 = (CASE WHEN P_WQTY09 < 0 THEN QTY062 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY09 ELSE 0 END) END)
                       , QTY063 = (CASE WHEN P_WQTY09 < 0 THEN QTY063 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY09 ELSE 0 END) END)
                       , QTY064 = (CASE WHEN P_WQTY10 < 0 THEN QTY064 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY10 ELSE 0 END) END)
                       , QTY065 = (CASE WHEN P_WQTY10 < 0 THEN QTY065 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY10 ELSE 0 END) END)
                       , QTY066 = (CASE WHEN P_WQTY10 < 0 THEN QTY066 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY10 ELSE 0 END) END)
                       , QTY067 = (CASE WHEN P_WQTY10 < 0 THEN QTY067 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY10 ELSE 0 END) END)
                       , QTY068 = (CASE WHEN P_WQTY10 < 0 THEN QTY068 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY10 ELSE 0 END) END)
                       , QTY069 = (CASE WHEN P_WQTY10 < 0 THEN QTY069 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY10 ELSE 0 END) END)
                       , QTY070 = (CASE WHEN P_WQTY10 < 0 THEN QTY070 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY10 ELSE 0 END) END)
                       , QTY071 = (CASE WHEN P_WQTY11 < 0 THEN QTY071 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY11 ELSE 0 END) END)
                       , QTY072 = (CASE WHEN P_WQTY11 < 0 THEN QTY072 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY11 ELSE 0 END) END)
                       , QTY073 = (CASE WHEN P_WQTY11 < 0 THEN QTY073 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY11 ELSE 0 END) END)
                       , QTY074 = (CASE WHEN P_WQTY11 < 0 THEN QTY074 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY11 ELSE 0 END) END)
                       , QTY075 = (CASE WHEN P_WQTY11 < 0 THEN QTY075 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY11 ELSE 0 END) END)
                       , QTY076 = (CASE WHEN P_WQTY11 < 0 THEN QTY076 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY11 ELSE 0 END) END)
                       , QTY077 = (CASE WHEN P_WQTY11 < 0 THEN QTY077 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY11 ELSE 0 END) END)
                       , QTY078 = (CASE WHEN P_WQTY12 < 0 THEN QTY078 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY12 ELSE 0 END) END)
                       , QTY079 = (CASE WHEN P_WQTY12 < 0 THEN QTY079 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY12 ELSE 0 END) END)
                       , QTY080 = (CASE WHEN P_WQTY12 < 0 THEN QTY080 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY12 ELSE 0 END) END)
                       , QTY081 = (CASE WHEN P_WQTY12 < 0 THEN QTY081 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY12 ELSE 0 END) END)
                       , QTY082 = (CASE WHEN P_WQTY12 < 0 THEN QTY082 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY12 ELSE 0 END) END)
                       , QTY083 = (CASE WHEN P_WQTY12 < 0 THEN QTY083 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY12 ELSE 0 END) END)
                       , QTY084 = (CASE WHEN P_WQTY12 < 0 THEN QTY084 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY12 ELSE 0 END) END)
                       , QTY085 = (CASE WHEN P_WQTY13 < 0 THEN QTY085 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY13 ELSE 0 END) END)
                       , QTY086 = (CASE WHEN P_WQTY13 < 0 THEN QTY086 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY13 ELSE 0 END) END)
                       , QTY087 = (CASE WHEN P_WQTY13 < 0 THEN QTY087 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY13 ELSE 0 END) END)
                       , QTY088 = (CASE WHEN P_WQTY13 < 0 THEN QTY088 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY13 ELSE 0 END) END)
                       , QTY089 = (CASE WHEN P_WQTY13 < 0 THEN QTY089 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY13 ELSE 0 END) END)
                       , QTY090 = (CASE WHEN P_WQTY13 < 0 THEN QTY090 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY13 ELSE 0 END) END)
                       , QTY091 = (CASE WHEN P_WQTY13 < 0 THEN QTY091 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY13 ELSE 0 END) END)
                       , QTY092 = (CASE WHEN P_WQTY14 < 0 THEN QTY092 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY14 ELSE 0 END) END)
                       , QTY093 = (CASE WHEN P_WQTY14 < 0 THEN QTY093 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY14 ELSE 0 END) END)
                       , QTY094 = (CASE WHEN P_WQTY14 < 0 THEN QTY094 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY14 ELSE 0 END) END)
                       , QTY095 = (CASE WHEN P_WQTY14 < 0 THEN QTY095 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY14 ELSE 0 END) END)
                       , QTY096 = (CASE WHEN P_WQTY14 < 0 THEN QTY096 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY14 ELSE 0 END) END)
                       , QTY097 = (CASE WHEN P_WQTY14 < 0 THEN QTY097 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY14 ELSE 0 END) END)
                       , QTY098 = (CASE WHEN P_WQTY14 < 0 THEN QTY098 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY14 ELSE 0 END) END)
                       , QTY099 = (CASE WHEN P_WQTY15 < 0 THEN QTY099 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY15 ELSE 0 END) END)
                       , QTY100 = (CASE WHEN P_WQTY15 < 0 THEN QTY100 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY15 ELSE 0 END) END)
                       , QTY101 = (CASE WHEN P_WQTY15 < 0 THEN QTY101 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY15 ELSE 0 END) END)
                       , QTY102 = (CASE WHEN P_WQTY15 < 0 THEN QTY102 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY15 ELSE 0 END) END)
                       , QTY103 = (CASE WHEN P_WQTY15 < 0 THEN QTY103 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY15 ELSE 0 END) END)
                       , QTY104 = (CASE WHEN P_WQTY15 < 0 THEN QTY104 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY15 ELSE 0 END) END)
                       , QTY105 = (CASE WHEN P_WQTY15 < 0 THEN QTY105 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY15 ELSE 0 END) END)
                       , QTY106 = (CASE WHEN P_WQTY16 < 0 THEN QTY106 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY16 ELSE 0 END) END)
                       , QTY107 = (CASE WHEN P_WQTY16 < 0 THEN QTY107 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY16 ELSE 0 END) END)
                       , QTY108 = (CASE WHEN P_WQTY16 < 0 THEN QTY108 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY16 ELSE 0 END) END)
                       , QTY109 = (CASE WHEN P_WQTY16 < 0 THEN QTY109 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY16 ELSE 0 END) END)
                       , QTY110 = (CASE WHEN P_WQTY16 < 0 THEN QTY110 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY16 ELSE 0 END) END)
                       , QTY111 = (CASE WHEN P_WQTY16 < 0 THEN QTY111 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY16 ELSE 0 END) END)
                       , QTY112 = (CASE WHEN P_WQTY16 < 0 THEN QTY112 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY16 ELSE 0 END) END)
                       , QTY113 = (CASE WHEN P_WQTY17 < 0 THEN QTY113 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY17 ELSE 0 END) END)
                       , QTY114 = (CASE WHEN P_WQTY17 < 0 THEN QTY114 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY17 ELSE 0 END) END)
                       , QTY115 = (CASE WHEN P_WQTY17 < 0 THEN QTY115 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY17 ELSE 0 END) END)
                       , QTY116 = (CASE WHEN P_WQTY17 < 0 THEN QTY116 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY17 ELSE 0 END) END)
                       , QTY117 = (CASE WHEN P_WQTY17 < 0 THEN QTY117 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY17 ELSE 0 END) END)
                       , QTY118 = (CASE WHEN P_WQTY17 < 0 THEN QTY118 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY17 ELSE 0 END) END)
                       , QTY119 = (CASE WHEN P_WQTY17 < 0 THEN QTY119 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY17 ELSE 0 END) END)
                       , QTY120 = (CASE WHEN P_WQTY18 < 0 THEN QTY120 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY18 ELSE 0 END) END)
                       , QTY121 = (CASE WHEN P_WQTY18 < 0 THEN QTY121 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY18 ELSE 0 END) END)
                       , QTY122 = (CASE WHEN P_WQTY18 < 0 THEN QTY122 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY18 ELSE 0 END) END)
                       , QTY123 = (CASE WHEN P_WQTY18 < 0 THEN QTY123 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY18 ELSE 0 END) END)
                       , QTY124 = (CASE WHEN P_WQTY18 < 0 THEN QTY124 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY18 ELSE 0 END) END)
                       , QTY125 = (CASE WHEN P_WQTY18 < 0 THEN QTY125 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY18 ELSE 0 END) END)
                       , QTY126 = (CASE WHEN P_WQTY18 < 0 THEN QTY126 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY18 ELSE 0 END) END)
                       , QTY127 = (CASE WHEN P_WQTY19 < 0 THEN QTY127 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY19 ELSE 0 END) END)
                       , QTY128 = (CASE WHEN P_WQTY19 < 0 THEN QTY128 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY19 ELSE 0 END) END)
                       , QTY129 = (CASE WHEN P_WQTY19 < 0 THEN QTY129 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY19 ELSE 0 END) END)
                       , QTY130 = (CASE WHEN P_WQTY19 < 0 THEN QTY130 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY19 ELSE 0 END) END)
                       , QTY131 = (CASE WHEN P_WQTY19 < 0 THEN QTY131 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY19 ELSE 0 END) END)
                       , QTY132 = (CASE WHEN P_WQTY19 < 0 THEN QTY132 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY19 ELSE 0 END) END)
                       , QTY133 = (CASE WHEN P_WQTY19 < 0 THEN QTY133 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY19 ELSE 0 END) END)
                       , QTY134 = (CASE WHEN P_WQTY20 < 0 THEN QTY134 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY20 ELSE 0 END) END)
                       , QTY135 = (CASE WHEN P_WQTY20 < 0 THEN QTY135 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY20 ELSE 0 END) END)
                       , QTY136 = (CASE WHEN P_WQTY20 < 0 THEN QTY136 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY20 ELSE 0 END) END)
                       , QTY137 = (CASE WHEN P_WQTY20 < 0 THEN QTY137 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY20 ELSE 0 END) END)
                       , QTY138 = (CASE WHEN P_WQTY20 < 0 THEN QTY138 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY20 ELSE 0 END) END)
                       , QTY139 = (CASE WHEN P_WQTY20 < 0 THEN QTY139 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY20 ELSE 0 END) END)
                       , QTY140 = (CASE WHEN P_WQTY20 < 0 THEN QTY140 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY20 ELSE 0 END) END)
                       , QTY141 = (CASE WHEN P_WQTY21 < 0 THEN QTY141 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY21 ELSE 0 END) END)
                       , QTY142 = (CASE WHEN P_WQTY21 < 0 THEN QTY142 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY21 ELSE 0 END) END)
                       , QTY143 = (CASE WHEN P_WQTY21 < 0 THEN QTY143 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY21 ELSE 0 END) END)
                       , QTY144 = (CASE WHEN P_WQTY21 < 0 THEN QTY144 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY21 ELSE 0 END) END)
                       , QTY145 = (CASE WHEN P_WQTY21 < 0 THEN QTY145 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY21 ELSE 0 END) END)
                       , QTY146 = (CASE WHEN P_WQTY21 < 0 THEN QTY146 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY21 ELSE 0 END) END)
                       , QTY147 = (CASE WHEN P_WQTY21 < 0 THEN QTY147 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY21 ELSE 0 END) END)
                       , QTY148 = (CASE WHEN P_WQTY22 < 0 THEN QTY148 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY22 ELSE 0 END) END)
                       , QTY149 = (CASE WHEN P_WQTY22 < 0 THEN QTY149 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY22 ELSE 0 END) END)
                       , QTY150 = (CASE WHEN P_WQTY22 < 0 THEN QTY150 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY22 ELSE 0 END) END)
                       , QTY151 = (CASE WHEN P_WQTY22 < 0 THEN QTY151 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY22 ELSE 0 END) END)
                       , QTY152 = (CASE WHEN P_WQTY22 < 0 THEN QTY152 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY22 ELSE 0 END) END)
                       , QTY153 = (CASE WHEN P_WQTY22 < 0 THEN QTY153 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY22 ELSE 0 END) END)
                       , QTY154 = (CASE WHEN P_WQTY22 < 0 THEN QTY154 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY22 ELSE 0 END) END)
                       , QTY155 = (CASE WHEN P_WQTY23 < 0 THEN QTY155 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY23 ELSE 0 END) END)
                       , QTY156 = (CASE WHEN P_WQTY23 < 0 THEN QTY156 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY23 ELSE 0 END) END)
                       , QTY157 = (CASE WHEN P_WQTY23 < 0 THEN QTY157 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY23 ELSE 0 END) END)
                       , QTY158 = (CASE WHEN P_WQTY23 < 0 THEN QTY158 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY23 ELSE 0 END) END)
                       , QTY159 = (CASE WHEN P_WQTY23 < 0 THEN QTY159 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY23 ELSE 0 END) END)
                       , QTY160 = (CASE WHEN P_WQTY23 < 0 THEN QTY160 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY23 ELSE 0 END) END)
                       , QTY161 = (CASE WHEN P_WQTY23 < 0 THEN QTY161 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY23 ELSE 0 END) END)
                       , QTY162 = (CASE WHEN P_WQTY24 < 0 THEN QTY162 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY24 ELSE 0 END) END)
                       , QTY163 = (CASE WHEN P_WQTY24 < 0 THEN QTY163 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY24 ELSE 0 END) END)
                       , QTY164 = (CASE WHEN P_WQTY24 < 0 THEN QTY164 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY24 ELSE 0 END) END)
                       , QTY165 = (CASE WHEN P_WQTY24 < 0 THEN QTY165 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY24 ELSE 0 END) END)
                       , QTY166 = (CASE WHEN P_WQTY24 < 0 THEN QTY166 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY24 ELSE 0 END) END)
                       , QTY167 = (CASE WHEN P_WQTY24 < 0 THEN QTY167 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY24 ELSE 0 END) END)
                       , QTY168 = (CASE WHEN P_WQTY24 < 0 THEN QTY168 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY24 ELSE 0 END) END)
                       , QTY169 = (CASE WHEN P_WQTY25 < 0 THEN QTY169 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY25 ELSE 0 END) END)
                       , QTY170 = (CASE WHEN P_WQTY25 < 0 THEN QTY170 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY25 ELSE 0 END) END)
                       , QTY171 = (CASE WHEN P_WQTY25 < 0 THEN QTY171 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY25 ELSE 0 END) END)
                       , QTY172 = (CASE WHEN P_WQTY25 < 0 THEN QTY172 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY25 ELSE 0 END) END)
                       , QTY173 = (CASE WHEN P_WQTY25 < 0 THEN QTY173 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY25 ELSE 0 END) END)
                       , QTY174 = (CASE WHEN P_WQTY25 < 0 THEN QTY174 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY25 ELSE 0 END) END)
                       , QTY175 = (CASE WHEN P_WQTY25 < 0 THEN QTY175 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY25 ELSE 0 END) END)
                       , QTY176 = (CASE WHEN P_WQTY26 < 0 THEN QTY176 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY26 ELSE 0 END) END)
                       , QTY177 = (CASE WHEN P_WQTY26 < 0 THEN QTY177 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY26 ELSE 0 END) END)
                       , QTY178 = (CASE WHEN P_WQTY26 < 0 THEN QTY178 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY26 ELSE 0 END) END)
                       , QTY179 = (CASE WHEN P_WQTY26 < 0 THEN QTY179 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY26 ELSE 0 END) END)
                       , QTY180 = (CASE WHEN P_WQTY26 < 0 THEN QTY180 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY26 ELSE 0 END) END)
                       , QTY181 = (CASE WHEN P_WQTY26 < 0 THEN QTY181 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY26 ELSE 0 END) END)
                       , QTY182 = (CASE WHEN P_WQTY26 < 0 THEN QTY182 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY26 ELSE 0 END) END)
                       , QTY183 = (CASE WHEN P_WQTY27 < 0 THEN QTY183 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY27 ELSE 0 END) END)
                       , QTY184 = (CASE WHEN P_WQTY27 < 0 THEN QTY184 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY27 ELSE 0 END) END)
                       , QTY185 = (CASE WHEN P_WQTY27 < 0 THEN QTY185 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY27 ELSE 0 END) END)
                       , QTY186 = (CASE WHEN P_WQTY27 < 0 THEN QTY186 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY27 ELSE 0 END) END)
                       , QTY187 = (CASE WHEN P_WQTY27 < 0 THEN QTY187 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY27 ELSE 0 END) END)
                       , QTY188 = (CASE WHEN P_WQTY27 < 0 THEN QTY188 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY27 ELSE 0 END) END)
                       , QTY189 = (CASE WHEN P_WQTY27 < 0 THEN QTY189 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY27 ELSE 0 END) END)
                       , QTY190 = (CASE WHEN P_WQTY28 < 0 THEN QTY190 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY28 ELSE 0 END) END)
                       , QTY191 = (CASE WHEN P_WQTY28 < 0 THEN QTY191 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY28 ELSE 0 END) END)
                       , QTY192 = (CASE WHEN P_WQTY28 < 0 THEN QTY192 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY28 ELSE 0 END) END)
                       , QTY193 = (CASE WHEN P_WQTY28 < 0 THEN QTY193 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY28 ELSE 0 END) END)
                       , QTY194 = (CASE WHEN P_WQTY28 < 0 THEN QTY194 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY28 ELSE 0 END) END)
                       , QTY195 = (CASE WHEN P_WQTY28 < 0 THEN QTY195 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY28 ELSE 0 END) END)
                       , QTY196 = (CASE WHEN P_WQTY28 < 0 THEN QTY196 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY28 ELSE 0 END) END)
                       , QTY197 = (CASE WHEN P_WQTY29 < 0 THEN QTY197 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY29 ELSE 0 END) END)
                       , QTY198 = (CASE WHEN P_WQTY29 < 0 THEN QTY198 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY29 ELSE 0 END) END)
                       , QTY199 = (CASE WHEN P_WQTY29 < 0 THEN QTY199 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY29 ELSE 0 END) END)
                       , QTY200 = (CASE WHEN P_WQTY29 < 0 THEN QTY200 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY29 ELSE 0 END) END)
                       , QTY201 = (CASE WHEN P_WQTY29 < 0 THEN QTY201 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY29 ELSE 0 END) END)
                       , QTY202 = (CASE WHEN P_WQTY29 < 0 THEN QTY202 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY29 ELSE 0 END) END)
                       , QTY203 = (CASE WHEN P_WQTY29 < 0 THEN QTY203 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY29 ELSE 0 END) END)
                       , QTY204 = (CASE WHEN P_WQTY30 < 0 THEN QTY204 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY30 ELSE 0 END) END)
                       , QTY205 = (CASE WHEN P_WQTY30 < 0 THEN QTY205 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY30 ELSE 0 END) END)
                       , QTY206 = (CASE WHEN P_WQTY30 < 0 THEN QTY206 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY30 ELSE 0 END) END)
                       , QTY207 = (CASE WHEN P_WQTY30 < 0 THEN QTY207 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY30 ELSE 0 END) END)
                       , QTY208 = (CASE WHEN P_WQTY30 < 0 THEN QTY208 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY30 ELSE 0 END) END)
                       , QTY209 = (CASE WHEN P_WQTY30 < 0 THEN QTY209 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY30 ELSE 0 END) END)
                       , QTY210 = (CASE WHEN P_WQTY30 < 0 THEN QTY210 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY30 ELSE 0 END) END)
                       , QTY211 = (CASE WHEN P_WQTY31 < 0 THEN QTY211 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY31 ELSE 0 END) END)
                       , QTY212 = (CASE WHEN P_WQTY31 < 0 THEN QTY212 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY31 ELSE 0 END) END)
                       , QTY213 = (CASE WHEN P_WQTY31 < 0 THEN QTY213 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY31 ELSE 0 END) END)
                       , QTY214 = (CASE WHEN P_WQTY31 < 0 THEN QTY214 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY31 ELSE 0 END) END)
                       , QTY215 = (CASE WHEN P_WQTY31 < 0 THEN QTY215 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY31 ELSE 0 END) END)
                       , QTY216 = (CASE WHEN P_WQTY31 < 0 THEN QTY216 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY31 ELSE 0 END) END)
                       , QTY217 = (CASE WHEN P_WQTY31 < 0 THEN QTY217 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY31 ELSE 0 END) END)
                       , QTY218 = (CASE WHEN P_WQTY32 < 0 THEN QTY218 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY32 ELSE 0 END) END)
                       , QTY219 = (CASE WHEN P_WQTY32 < 0 THEN QTY219 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY32 ELSE 0 END) END)
                       , QTY220 = (CASE WHEN P_WQTY32 < 0 THEN QTY220 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY32 ELSE 0 END) END)
                       , QTY221 = (CASE WHEN P_WQTY32 < 0 THEN QTY221 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY32 ELSE 0 END) END)
                       , QTY222 = (CASE WHEN P_WQTY32 < 0 THEN QTY222 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY32 ELSE 0 END) END)
                       , QTY223 = (CASE WHEN P_WQTY32 < 0 THEN QTY223 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY32 ELSE 0 END) END)
                       , QTY224 = (CASE WHEN P_WQTY32 < 0 THEN QTY224 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY32 ELSE 0 END) END)
                       , QTY225 = (CASE WHEN P_WQTY33 < 0 THEN QTY225 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY33 ELSE 0 END) END)
                       , QTY226 = (CASE WHEN P_WQTY33 < 0 THEN QTY226 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY33 ELSE 0 END) END)
                       , QTY227 = (CASE WHEN P_WQTY33 < 0 THEN QTY227 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY33 ELSE 0 END) END)
                       , QTY228 = (CASE WHEN P_WQTY33 < 0 THEN QTY228 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY33 ELSE 0 END) END)
                       , QTY229 = (CASE WHEN P_WQTY33 < 0 THEN QTY229 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY33 ELSE 0 END) END)
                       , QTY230 = (CASE WHEN P_WQTY33 < 0 THEN QTY230 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY33 ELSE 0 END) END)
                       , QTY231 = (CASE WHEN P_WQTY33 < 0 THEN QTY231 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY33 ELSE 0 END) END)
                       , QTY232 = (CASE WHEN P_WQTY34 < 0 THEN QTY232 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY34 ELSE 0 END) END)
                       , QTY233 = (CASE WHEN P_WQTY34 < 0 THEN QTY233 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY34 ELSE 0 END) END)
                       , QTY234 = (CASE WHEN P_WQTY34 < 0 THEN QTY234 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY34 ELSE 0 END) END)
                       , QTY235 = (CASE WHEN P_WQTY34 < 0 THEN QTY235 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY34 ELSE 0 END) END)
                       , QTY236 = (CASE WHEN P_WQTY34 < 0 THEN QTY236 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY34 ELSE 0 END) END)
                       , QTY237 = (CASE WHEN P_WQTY34 < 0 THEN QTY237 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY34 ELSE 0 END) END)
                       , QTY238 = (CASE WHEN P_WQTY34 < 0 THEN QTY238 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY34 ELSE 0 END) END)
                       , QTY239 = (CASE WHEN P_WQTY35 < 0 THEN QTY239 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY35 ELSE 0 END) END)
                       , QTY240 = (CASE WHEN P_WQTY35 < 0 THEN QTY240 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY35 ELSE 0 END) END)
                       , QTY241 = (CASE WHEN P_WQTY35 < 0 THEN QTY241 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY35 ELSE 0 END) END)
                       , QTY242 = (CASE WHEN P_WQTY35 < 0 THEN QTY242 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY35 ELSE 0 END) END)
                       , QTY243 = (CASE WHEN P_WQTY35 < 0 THEN QTY243 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY35 ELSE 0 END) END)
                       , QTY244 = (CASE WHEN P_WQTY35 < 0 THEN QTY244 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY35 ELSE 0 END) END)
                       , QTY245 = (CASE WHEN P_WQTY35 < 0 THEN QTY245 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY35 ELSE 0 END) END)
                       , QTY246 = (CASE WHEN P_WQTY36 < 0 THEN QTY246 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY36 ELSE 0 END) END)
                       , QTY247 = (CASE WHEN P_WQTY36 < 0 THEN QTY247 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY36 ELSE 0 END) END)
                       , QTY248 = (CASE WHEN P_WQTY36 < 0 THEN QTY248 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY36 ELSE 0 END) END)
                       , QTY249 = (CASE WHEN P_WQTY36 < 0 THEN QTY249 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY36 ELSE 0 END) END)
                       , QTY250 = (CASE WHEN P_WQTY36 < 0 THEN QTY250 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY36 ELSE 0 END) END)
                       , QTY251 = (CASE WHEN P_WQTY36 < 0 THEN QTY251 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY36 ELSE 0 END) END)
                       , QTY252 = (CASE WHEN P_WQTY36 < 0 THEN QTY252 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY36 ELSE 0 END) END)
                       , QTY253 = (CASE WHEN P_WQTY37 < 0 THEN QTY253 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY37 ELSE 0 END) END)
                       , QTY254 = (CASE WHEN P_WQTY37 < 0 THEN QTY254 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY37 ELSE 0 END) END)
                       , QTY255 = (CASE WHEN P_WQTY37 < 0 THEN QTY255 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY37 ELSE 0 END) END)
                       , QTY256 = (CASE WHEN P_WQTY37 < 0 THEN QTY256 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY37 ELSE 0 END) END)
                       , QTY257 = (CASE WHEN P_WQTY37 < 0 THEN QTY257 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY37 ELSE 0 END) END)
                       , QTY258 = (CASE WHEN P_WQTY37 < 0 THEN QTY258 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY37 ELSE 0 END) END)
                       , QTY259 = (CASE WHEN P_WQTY37 < 0 THEN QTY259 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY37 ELSE 0 END) END)
                       , QTY260 = (CASE WHEN P_WQTY38 < 0 THEN QTY260 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY38 ELSE 0 END) END)
                       , QTY261 = (CASE WHEN P_WQTY38 < 0 THEN QTY261 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY38 ELSE 0 END) END)
                       , QTY262 = (CASE WHEN P_WQTY38 < 0 THEN QTY262 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY38 ELSE 0 END) END)
                       , QTY263 = (CASE WHEN P_WQTY38 < 0 THEN QTY263 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY38 ELSE 0 END) END)
                       , QTY264 = (CASE WHEN P_WQTY38 < 0 THEN QTY264 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY38 ELSE 0 END) END)
                       , QTY265 = (CASE WHEN P_WQTY38 < 0 THEN QTY265 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY38 ELSE 0 END) END)
                       , QTY266 = (CASE WHEN P_WQTY38 < 0 THEN QTY266 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY38 ELSE 0 END) END)
                       , QTY267 = (CASE WHEN P_WQTY39 < 0 THEN QTY267 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY39 ELSE 0 END) END)
                       , QTY268 = (CASE WHEN P_WQTY39 < 0 THEN QTY268 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY39 ELSE 0 END) END)
                       , QTY269 = (CASE WHEN P_WQTY39 < 0 THEN QTY269 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY39 ELSE 0 END) END)
                       , QTY270 = (CASE WHEN P_WQTY39 < 0 THEN QTY270 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY39 ELSE 0 END) END)
                       , QTY271 = (CASE WHEN P_WQTY39 < 0 THEN QTY271 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY39 ELSE 0 END) END)
                       , QTY272 = (CASE WHEN P_WQTY39 < 0 THEN QTY272 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY39 ELSE 0 END) END)
                       , QTY273 = (CASE WHEN P_WQTY39 < 0 THEN QTY273 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY39 ELSE 0 END) END)
                       , QTY274 = (CASE WHEN P_WQTY40 < 0 THEN QTY274 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY40 ELSE 0 END) END)
                       , QTY275 = (CASE WHEN P_WQTY40 < 0 THEN QTY275 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY40 ELSE 0 END) END)
                       , QTY276 = (CASE WHEN P_WQTY40 < 0 THEN QTY276 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY40 ELSE 0 END) END)
                       , QTY277 = (CASE WHEN P_WQTY40 < 0 THEN QTY277 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY40 ELSE 0 END) END)
                       , QTY278 = (CASE WHEN P_WQTY40 < 0 THEN QTY278 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY40 ELSE 0 END) END)
                       , QTY279 = (CASE WHEN P_WQTY40 < 0 THEN QTY279 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY40 ELSE 0 END) END)
                       , QTY280 = (CASE WHEN P_WQTY40 < 0 THEN QTY280 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY40 ELSE 0 END) END)
                       , QTY281 = (CASE WHEN P_WQTY41 < 0 THEN QTY281 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY41 ELSE 0 END) END)
                       , QTY282 = (CASE WHEN P_WQTY41 < 0 THEN QTY282 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY41 ELSE 0 END) END)
                       , QTY283 = (CASE WHEN P_WQTY41 < 0 THEN QTY283 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY41 ELSE 0 END) END)
                       , QTY284 = (CASE WHEN P_WQTY41 < 0 THEN QTY284 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY41 ELSE 0 END) END)
                       , QTY285 = (CASE WHEN P_WQTY41 < 0 THEN QTY285 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY41 ELSE 0 END) END)
                       , QTY286 = (CASE WHEN P_WQTY41 < 0 THEN QTY286 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY41 ELSE 0 END) END)
                       , QTY287 = (CASE WHEN P_WQTY41 < 0 THEN QTY287 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY41 ELSE 0 END) END)
                       , QTY288 = (CASE WHEN P_WQTY42 < 0 THEN QTY288 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY42 ELSE 0 END) END)
                       , QTY289 = (CASE WHEN P_WQTY42 < 0 THEN QTY289 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY42 ELSE 0 END) END)
                       , QTY290 = (CASE WHEN P_WQTY42 < 0 THEN QTY290 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY42 ELSE 0 END) END)
                       , QTY291 = (CASE WHEN P_WQTY42 < 0 THEN QTY291 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY42 ELSE 0 END) END)
                       , QTY292 = (CASE WHEN P_WQTY42 < 0 THEN QTY292 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY42 ELSE 0 END) END)
                       , QTY293 = (CASE WHEN P_WQTY42 < 0 THEN QTY293 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY42 ELSE 0 END) END)
                       , QTY294 = (CASE WHEN P_WQTY42 < 0 THEN QTY294 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY42 ELSE 0 END) END)
                       , QTY295 = (CASE WHEN P_WQTY43 < 0 THEN QTY295 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY43 ELSE 0 END) END)
                       , QTY296 = (CASE WHEN P_WQTY43 < 0 THEN QTY296 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY43 ELSE 0 END) END)
                       , QTY297 = (CASE WHEN P_WQTY43 < 0 THEN QTY297 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY43 ELSE 0 END) END)
                       , QTY298 = (CASE WHEN P_WQTY43 < 0 THEN QTY298 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY43 ELSE 0 END) END)
                       , QTY299 = (CASE WHEN P_WQTY43 < 0 THEN QTY299 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY43 ELSE 0 END) END)
                       , QTY300 = (CASE WHEN P_WQTY43 < 0 THEN QTY300 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY43 ELSE 0 END) END)
                       , QTY301 = (CASE WHEN P_WQTY43 < 0 THEN QTY301 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY43 ELSE 0 END) END)
                       , QTY302 = (CASE WHEN P_WQTY44 < 0 THEN QTY302 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY44 ELSE 0 END) END)
                       , QTY303 = (CASE WHEN P_WQTY44 < 0 THEN QTY303 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY44 ELSE 0 END) END)
                       , QTY304 = (CASE WHEN P_WQTY44 < 0 THEN QTY304 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY44 ELSE 0 END) END)
                       , QTY305 = (CASE WHEN P_WQTY44 < 0 THEN QTY305 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY44 ELSE 0 END) END)
                       , QTY306 = (CASE WHEN P_WQTY44 < 0 THEN QTY306 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY44 ELSE 0 END) END)
                       , QTY307 = (CASE WHEN P_WQTY44 < 0 THEN QTY307 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY44 ELSE 0 END) END)
                       , QTY308 = (CASE WHEN P_WQTY44 < 0 THEN QTY308 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY44 ELSE 0 END) END)
                       , QTY309 = (CASE WHEN P_WQTY45 < 0 THEN QTY309 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY45 ELSE 0 END) END)
                       , QTY310 = (CASE WHEN P_WQTY45 < 0 THEN QTY310 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY45 ELSE 0 END) END)
                       , QTY311 = (CASE WHEN P_WQTY45 < 0 THEN QTY311 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY45 ELSE 0 END) END)
                       , QTY312 = (CASE WHEN P_WQTY45 < 0 THEN QTY312 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY45 ELSE 0 END) END)
                       , QTY313 = (CASE WHEN P_WQTY45 < 0 THEN QTY313 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY45 ELSE 0 END) END)
                       , QTY314 = (CASE WHEN P_WQTY45 < 0 THEN QTY314 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY45 ELSE 0 END) END)
                       , QTY315 = (CASE WHEN P_WQTY45 < 0 THEN QTY315 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY45 ELSE 0 END) END)
                       , QTY316 = (CASE WHEN P_WQTY46 < 0 THEN QTY316 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY46 ELSE 0 END) END)
                       , QTY317 = (CASE WHEN P_WQTY46 < 0 THEN QTY317 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY46 ELSE 0 END) END)
                       , QTY318 = (CASE WHEN P_WQTY46 < 0 THEN QTY318 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY46 ELSE 0 END) END)
                       , QTY319 = (CASE WHEN P_WQTY46 < 0 THEN QTY319 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY46 ELSE 0 END) END)
                       , QTY320 = (CASE WHEN P_WQTY46 < 0 THEN QTY320 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY46 ELSE 0 END) END)
                       , QTY321 = (CASE WHEN P_WQTY46 < 0 THEN QTY321 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY46 ELSE 0 END) END)
                       , QTY322 = (CASE WHEN P_WQTY46 < 0 THEN QTY322 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY46 ELSE 0 END) END)
                       , QTY323 = (CASE WHEN P_WQTY47 < 0 THEN QTY323 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY47 ELSE 0 END) END)
                       , QTY324 = (CASE WHEN P_WQTY47 < 0 THEN QTY324 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY47 ELSE 0 END) END)
                       , QTY325 = (CASE WHEN P_WQTY47 < 0 THEN QTY325 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY47 ELSE 0 END) END)
                       , QTY326 = (CASE WHEN P_WQTY47 < 0 THEN QTY326 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY47 ELSE 0 END) END)
                       , QTY327 = (CASE WHEN P_WQTY47 < 0 THEN QTY327 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY47 ELSE 0 END) END)
                       , QTY328 = (CASE WHEN P_WQTY47 < 0 THEN QTY328 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY47 ELSE 0 END) END)
                       , QTY329 = (CASE WHEN P_WQTY47 < 0 THEN QTY329 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY47 ELSE 0 END) END)
                       , QTY330 = (CASE WHEN P_WQTY48 < 0 THEN QTY330 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY48 ELSE 0 END) END)
                       , QTY331 = (CASE WHEN P_WQTY48 < 0 THEN QTY331 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY48 ELSE 0 END) END)
                       , QTY332 = (CASE WHEN P_WQTY48 < 0 THEN QTY332 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY48 ELSE 0 END) END)
                       , QTY333 = (CASE WHEN P_WQTY48 < 0 THEN QTY333 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY48 ELSE 0 END) END)
                       , QTY334 = (CASE WHEN P_WQTY48 < 0 THEN QTY334 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY48 ELSE 0 END) END)
                       , QTY335 = (CASE WHEN P_WQTY48 < 0 THEN QTY335 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY48 ELSE 0 END) END)
                       , QTY336 = (CASE WHEN P_WQTY48 < 0 THEN QTY336 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY48 ELSE 0 END) END)
                       , QTY337 = (CASE WHEN P_WQTY49 < 0 THEN QTY337 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY49 ELSE 0 END) END)
                       , QTY338 = (CASE WHEN P_WQTY49 < 0 THEN QTY338 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY49 ELSE 0 END) END)
                       , QTY339 = (CASE WHEN P_WQTY49 < 0 THEN QTY339 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY49 ELSE 0 END) END)
                       , QTY340 = (CASE WHEN P_WQTY49 < 0 THEN QTY340 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY49 ELSE 0 END) END)
                       , QTY341 = (CASE WHEN P_WQTY49 < 0 THEN QTY341 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY49 ELSE 0 END) END)
                       , QTY342 = (CASE WHEN P_WQTY49 < 0 THEN QTY342 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY49 ELSE 0 END) END)
                       , QTY343 = (CASE WHEN P_WQTY49 < 0 THEN QTY343 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY49 ELSE 0 END) END)
                       , QTY344 = (CASE WHEN P_WQTY50 < 0 THEN QTY344 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY50 ELSE 0 END) END)
                       , QTY345 = (CASE WHEN P_WQTY50 < 0 THEN QTY345 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY50 ELSE 0 END) END)
                       , QTY346 = (CASE WHEN P_WQTY50 < 0 THEN QTY346 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY50 ELSE 0 END) END)
                       , QTY347 = (CASE WHEN P_WQTY50 < 0 THEN QTY347 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY50 ELSE 0 END) END)
                       , QTY348 = (CASE WHEN P_WQTY50 < 0 THEN QTY348 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY50 ELSE 0 END) END)
                       , QTY349 = (CASE WHEN P_WQTY50 < 0 THEN QTY349 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY50 ELSE 0 END) END)
                       , QTY350 = (CASE WHEN P_WQTY50 < 0 THEN QTY350 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY50 ELSE 0 END) END)
                       , QTY351 = (CASE WHEN P_WQTY51 < 0 THEN QTY351 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY51 ELSE 0 END) END)
                       , QTY352 = (CASE WHEN P_WQTY51 < 0 THEN QTY352 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY51 ELSE 0 END) END)
                       , QTY353 = (CASE WHEN P_WQTY51 < 0 THEN QTY353 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY51 ELSE 0 END) END)
                       , QTY354 = (CASE WHEN P_WQTY51 < 0 THEN QTY354 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY51 ELSE 0 END) END)
                       , QTY355 = (CASE WHEN P_WQTY51 < 0 THEN QTY355 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY51 ELSE 0 END) END)
                       , QTY356 = (CASE WHEN P_WQTY51 < 0 THEN QTY356 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY51 ELSE 0 END) END)
                       , QTY357 = (CASE WHEN P_WQTY51 < 0 THEN QTY357 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY51 ELSE 0 END) END)
                       , QTY358 = (CASE WHEN P_WQTY52 < 0 THEN QTY358 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 2 THEN P_WQTY52 ELSE 0 END) END)
                       , QTY359 = (CASE WHEN P_WQTY52 < 0 THEN QTY359 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 3 THEN P_WQTY52 ELSE 0 END) END)
                       , QTY360 = (CASE WHEN P_WQTY52 < 0 THEN QTY360 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 4 THEN P_WQTY52 ELSE 0 END) END)
                       , QTY361 = (CASE WHEN P_WQTY52 < 0 THEN QTY361 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 5 THEN P_WQTY52 ELSE 0 END) END)
                       , QTY362 = (CASE WHEN P_WQTY52 < 0 THEN QTY362 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 6 THEN P_WQTY52 ELSE 0 END) END)
                       , QTY363 = (CASE WHEN P_WQTY52 < 0 THEN QTY363 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 7 THEN P_WQTY52 ELSE 0 END) END)
                       , QTY364 = (CASE WHEN P_WQTY52 < 0 THEN QTY364 ELSE (CASE WHEN V_X_DAYOFWEEK_NO = 1 THEN P_WQTY52 ELSE 0 END) END)
                       ;


                  /*  MSSQL UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN #DAY_SCP_XLS_PSI_GLOBAL Y ON XLS_KEY1
                      -> 원천이 XLS_KEY1 당 유일하다는 보장이 없어(적재처 PK = CREATE_FROM_YYYYMMDD + XLS_KEY1)
                         MERGE 는 ORA-30926 위험이 있다. 상관 UPDATE + EXISTS + ROWNUM = 1 로 결정적으로 옮긴다(CV-024). */
                  /* ★원본 L950 은 WQTY11 의 마지막 항이 Y.QTY077 이 아니라 Y.QTY007 이다(원본 오타로 보이나 */
                  UPDATE SCP_XLS_PSI_GLOBAL_ESS X
                     SET ( WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                                , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                                , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                                , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                                , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                                , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                                , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                                , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                                , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                                , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                                , WQTY51, WQTY52
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE ) =
                         ( SELECT Y.QTY001 + Y.QTY002 + Y.QTY003 + Y.QTY004 + Y.QTY005 + Y.QTY006 + Y.QTY007
                                , Y.QTY008 + Y.QTY009 + Y.QTY010 + Y.QTY011 + Y.QTY012 + Y.QTY013 + Y.QTY014
                                , Y.QTY015 + Y.QTY016 + Y.QTY017 + Y.QTY018 + Y.QTY019 + Y.QTY020 + Y.QTY021
                                , Y.QTY022 + Y.QTY023 + Y.QTY024 + Y.QTY025 + Y.QTY026 + Y.QTY027 + Y.QTY028
                                , Y.QTY029 + Y.QTY030 + Y.QTY031 + Y.QTY032 + Y.QTY033 + Y.QTY034 + Y.QTY035
                                , Y.QTY036 + Y.QTY037 + Y.QTY038 + Y.QTY039 + Y.QTY040 + Y.QTY041 + Y.QTY042
                                , Y.QTY043 + Y.QTY044 + Y.QTY045 + Y.QTY046 + Y.QTY047 + Y.QTY048 + Y.QTY049
                                , Y.QTY050 + Y.QTY051 + Y.QTY052 + Y.QTY053 + Y.QTY054 + Y.QTY055 + Y.QTY056
                                , Y.QTY057 + Y.QTY058 + Y.QTY059 + Y.QTY060 + Y.QTY061 + Y.QTY062 + Y.QTY063
                                , Y.QTY064 + Y.QTY065 + Y.QTY066 + Y.QTY067 + Y.QTY068 + Y.QTY069 + Y.QTY070
                                , Y.QTY071 + Y.QTY072 + Y.QTY073 + Y.QTY074 + Y.QTY075 + Y.QTY076 + Y.QTY007
                                , Y.QTY078 + Y.QTY079 + Y.QTY080 + Y.QTY081 + Y.QTY082 + Y.QTY083 + Y.QTY084
                                , Y.QTY085 + Y.QTY086 + Y.QTY087 + Y.QTY088 + Y.QTY089 + Y.QTY090 + Y.QTY091
                                , Y.QTY092 + Y.QTY093 + Y.QTY094 + Y.QTY095 + Y.QTY096 + Y.QTY097 + Y.QTY098
                                , Y.QTY099 + Y.QTY100 + Y.QTY101 + Y.QTY102 + Y.QTY103 + Y.QTY104 + Y.QTY105
                                , Y.QTY106 + Y.QTY107 + Y.QTY108 + Y.QTY109 + Y.QTY110 + Y.QTY111 + Y.QTY112
                                , Y.QTY113 + Y.QTY114 + Y.QTY115 + Y.QTY116 + Y.QTY117 + Y.QTY118 + Y.QTY119
                                , Y.QTY120 + Y.QTY121 + Y.QTY122 + Y.QTY123 + Y.QTY124 + Y.QTY125 + Y.QTY126
                                , Y.QTY127 + Y.QTY128 + Y.QTY129 + Y.QTY130 + Y.QTY131 + Y.QTY132 + Y.QTY133
                                , Y.QTY134 + Y.QTY135 + Y.QTY136 + Y.QTY137 + Y.QTY138 + Y.QTY139 + Y.QTY140
                                , Y.QTY141 + Y.QTY142 + Y.QTY143 + Y.QTY144 + Y.QTY145 + Y.QTY146 + Y.QTY147
                                , Y.QTY148 + Y.QTY149 + Y.QTY150 + Y.QTY151 + Y.QTY152 + Y.QTY153 + Y.QTY154
                                , Y.QTY155 + Y.QTY156 + Y.QTY157 + Y.QTY158 + Y.QTY159 + Y.QTY160 + Y.QTY161
                                , Y.QTY162 + Y.QTY163 + Y.QTY164 + Y.QTY165 + Y.QTY166 + Y.QTY167 + Y.QTY168
                                , Y.QTY169 + Y.QTY170 + Y.QTY171 + Y.QTY172 + Y.QTY173 + Y.QTY174 + Y.QTY175
                                , Y.QTY176 + Y.QTY177 + Y.QTY178 + Y.QTY179 + Y.QTY180 + Y.QTY181 + Y.QTY182
                                , Y.QTY183 + Y.QTY184 + Y.QTY185 + Y.QTY186 + Y.QTY187 + Y.QTY188 + Y.QTY189
                                , Y.QTY190 + Y.QTY191 + Y.QTY192 + Y.QTY193 + Y.QTY194 + Y.QTY195 + Y.QTY196
                                , Y.QTY197 + Y.QTY198 + Y.QTY199 + Y.QTY200 + Y.QTY201 + Y.QTY202 + Y.QTY203
                                , Y.QTY204 + Y.QTY205 + Y.QTY206 + Y.QTY207 + Y.QTY208 + Y.QTY209 + Y.QTY210
                                , Y.QTY211 + Y.QTY212 + Y.QTY213 + Y.QTY214 + Y.QTY215 + Y.QTY216 + Y.QTY217
                                , Y.QTY218 + Y.QTY219 + Y.QTY220 + Y.QTY221 + Y.QTY222 + Y.QTY223 + Y.QTY224
                                , Y.QTY225 + Y.QTY226 + Y.QTY227 + Y.QTY228 + Y.QTY229 + Y.QTY230 + Y.QTY231
                                , Y.QTY232 + Y.QTY233 + Y.QTY234 + Y.QTY235 + Y.QTY236 + Y.QTY237 + Y.QTY238
                                , Y.QTY239 + Y.QTY240 + Y.QTY241 + Y.QTY242 + Y.QTY243 + Y.QTY244 + Y.QTY245
                                , Y.QTY246 + Y.QTY247 + Y.QTY248 + Y.QTY249 + Y.QTY250 + Y.QTY251 + Y.QTY252
                                , Y.QTY253 + Y.QTY254 + Y.QTY255 + Y.QTY256 + Y.QTY257 + Y.QTY258 + Y.QTY259
                                , Y.QTY260 + Y.QTY261 + Y.QTY262 + Y.QTY263 + Y.QTY264 + Y.QTY265 + Y.QTY266
                                , Y.QTY267 + Y.QTY268 + Y.QTY269 + Y.QTY270 + Y.QTY271 + Y.QTY272 + Y.QTY273
                                , Y.QTY274 + Y.QTY275 + Y.QTY276 + Y.QTY277 + Y.QTY278 + Y.QTY279 + Y.QTY280
                                , Y.QTY281 + Y.QTY282 + Y.QTY283 + Y.QTY284 + Y.QTY285 + Y.QTY286 + Y.QTY287
                                , Y.QTY288 + Y.QTY289 + Y.QTY290 + Y.QTY291 + Y.QTY292 + Y.QTY293 + Y.QTY294
                                , Y.QTY295 + Y.QTY296 + Y.QTY297 + Y.QTY298 + Y.QTY299 + Y.QTY300 + Y.QTY301
                                , Y.QTY302 + Y.QTY303 + Y.QTY304 + Y.QTY305 + Y.QTY306 + Y.QTY307 + Y.QTY308
                                , Y.QTY309 + Y.QTY310 + Y.QTY311 + Y.QTY312 + Y.QTY313 + Y.QTY314 + Y.QTY315
                                , Y.QTY316 + Y.QTY317 + Y.QTY318 + Y.QTY319 + Y.QTY320 + Y.QTY321 + Y.QTY322
                                , Y.QTY323 + Y.QTY324 + Y.QTY325 + Y.QTY326 + Y.QTY327 + Y.QTY328 + Y.QTY329
                                , Y.QTY330 + Y.QTY331 + Y.QTY332 + Y.QTY333 + Y.QTY334 + Y.QTY335 + Y.QTY336
                                , Y.QTY337 + Y.QTY338 + Y.QTY339 + Y.QTY340 + Y.QTY341 + Y.QTY342 + Y.QTY343
                                , Y.QTY344 + Y.QTY345 + Y.QTY346 + Y.QTY347 + Y.QTY348 + Y.QTY349 + Y.QTY350
                                , Y.QTY351 + Y.QTY352 + Y.QTY353 + Y.QTY354 + Y.QTY355 + Y.QTY356 + Y.QTY357
                                , Y.QTY358 + Y.QTY359 + Y.QTY360 + Y.QTY361 + Y.QTY362 + Y.QTY363 + Y.QTY364
                                , V_P_USER_ID
                                , SYSDATE
                             FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL Y
                            WHERE X.XLS_KEY1 = Y.XLS_KEY1
                              AND ROWNUM     = 1 )
                   WHERE 0 = 0
                     AND X.DIVISION_ID         = P_DIVISION_ID
                     AND X.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                     AND X.SEQ                 = P_SEQ
                     AND X.XLS_KEY1            = P_XLS_KEY1   /* 43 */
                     AND X.MEASURE             IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
                     AND EXISTS ( SELECT 1
                                    FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL Y
                                   WHERE X.XLS_KEY1 = Y.XLS_KEY1 );

               END IF;   /*  IF  @p_day_week_flag = 'week' */

            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  SOURCE TABLE 반영 */
            /* ------------------------------------------------------------------------------------------- */

            /*  UI 작업자와 시물레이션 작업자를 구분하기 위해서 */
            /*                CASE 로 1:1 재현하고, VARCHAR(100) 재대입 시의 조용한 절단도 SUBSTR 로 재현한다. */
            V_P_USER_ID := CASE WHEN V_P_USER_ID IS NULL
                                THEN NULL
                                ELSE SUBSTR(V_P_USER_ID || '[SIMULATION]', 1, 100)
                           END;


            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FG UPDATE */
            /*  SHIP_PLAN  --> SCP_ANL_SHIPMENT_PLAN_FG.MEASURE 'SHIP_PLAN_AMEND' UPDATE */
            /* ------------------------------------------------------------------------------------------- */
            IF P_MEASURE IN ('SHIP_PLAN') THEN   /* FG */

            /*  SHIP_PLAN */
               /*  IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL DROP TABLE #SCP_ANL_SHIPMENT_PLAN_FG */
               DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG;


               INSERT INTO GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG
                    ( DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                    , BIZ_TYPE
                    , PROJECT_CODE
                    , ITEM_ID
                    , TO_SITE
                    , INCOTERMS
                    , FROM_SITE
                    , BOD_ID
                    , TRANSPORT_MODE
                    , MEASURE
                    , YYYYMMDD
                    , QTY
                    , ORIGIN_FROM_DIVISION_ID
                    , ORIGIN_TO_DIVISION_ID
                    , ELECTRODE_TYPE
                    , ATTRIBUTE1
                    , YYYYMMDD_COLUMN )
            SELECT X.DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , X.PLAN_TYPE
                 , X.SEQ
                 , X.OPERATION_GROUP AS BIZ_TYPE
                 , X.PROJECT_CODE
                 /* , X.CELL_ITEM_ID */
                 , X.ITEM_ID
                 , X.TO_SITE
                 , X.INCOTERMS
                 , X.FROM_SITE
                 , X.BOD_ID
                 , X.TRANSPORT_MODE
                 , 'SHIP_PLAN_AMEND' AS MEASURE
                 , Y.YYYYMMDD AS YYYYMMDD
                 , X.QTY
                 , '82' AS ORIGIN_FROM_DIVISION_ID
                 , '82' AS ORIGIN_TO_DIVISION_ID
                 , '' AS ELECTRODE_TYPE
                 , X.ATTRIBUTE1
                 , Y.YYYYMMDD_COLUMN
              FROM ( SELECT *
                       FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL
                      WHERE 0 = 0
                   )
                   UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN ( QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
                                        , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
                                        , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
                                        , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                                        , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
                                        , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
                                        , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
                                        , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                                        , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
                                        , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
                                        , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
                                        , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                                        , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
                                        , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
                                        , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
                                        , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                                        , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
                                        , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
                                        , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
                                        , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                                        , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
                                        , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
                                        , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
                                        , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                                        , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
                                        , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
                                        , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
                                        , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                                        , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
                                        , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
                                        , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
                                        , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                                        , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
                                        , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
                                        , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
                                        , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                                        , QTY361, QTY362, QTY363, QTY364
                                        )
                           ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                  , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD     >= P_PLAN_START_YYYYMMDD
                                AND A.BASIS_YYYYMMDD     <  V_P_TO_YYYYMMDD
                            ) Y
             WHERE X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                 ;


            /* ------------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 UPDATE */
            /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
            /* ------------------------------------------------------------------------------------------- */
              IF P_PLAN_TYPE IN ('PR', 'MA', 'SE') THEN

                DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG X
                 WHERE EXISTS ( SELECT 1
                                  FROM GT_XPGT_SCM_MST_SITE Y
                                 WHERE Y.DIVISION_ID = X.DIVISION_ID
                                   AND Y.SCM_SITE_ID = X.FROM_SITE
                                   AND X.YYYYMMDD    < Y.SHIP_FROZEN_WEEK_DAY );
              END IF;

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_FG X
                USING ( SELECT DIVISION_ID
                             , PLAN_START_YYYYMMDD
                             , PLAN_TYPE
                             , SEQ
                             , BIZ_TYPE
                             , PROJECT_CODE
                             /* , CELL_ITEM_ID */
                             , ITEM_ID
                             , TO_SITE
                             , INCOTERMS
                             , FROM_SITE
                             , BOD_ID
                             /* , TRANSPORT_MODE */
                             , MEASURE
                             , YYYYMMDD
                             , QTY
                             , ORIGIN_FROM_DIVISION_ID
                             , ORIGIN_TO_DIVISION_ID
                             , ELECTRODE_TYPE
                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG
                         /* WHERE QTY > 0 */
                      ) Y
                   ON ( 0 = 0
                        AND X.DIVISION_ID               = P_DIVISION_ID
                        AND X.PLAN_START_YYYYMMDD       = P_PLAN_START_YYYYMMDD
                        AND X.PLAN_TYPE                 = P_PLAN_TYPE
                        AND X.SEQ                       = P_SEQ
                        AND X.BIZ_TYPE                  = Y.BIZ_TYPE
                        AND X.PROJECT_CODE              = Y.PROJECT_CODE
                        AND X.ITEM_ID                   = Y.ITEM_ID
                        AND X.TO_SITE                   = Y.TO_SITE
                        AND X.INCOTERMS                 = Y.INCOTERMS
                        AND X.FROM_SITE                 = Y.FROM_SITE
                        AND X.BOD_ID                    = Y.BOD_ID
                        AND X.MEASURE                   = Y.MEASURE
                        AND X.YYYYMMDD                  = Y.YYYYMMDD )
                WHEN MATCHED THEN
                UPDATE
                   SET X.QTY               = Y.QTY
                     /* , X.CREATED_BY         = @p_USER_ID */
                     /* , X.CREATION_DATE      = GETDATE()  */
                     , X.LAST_UPDATED_BY  = V_P_USER_ID
                     , X.LAST_UPDATE_DATE = SYSDATE
                WHEN NOT MATCHED THEN
                  INSERT ( DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , SEQ
                         , BIZ_TYPE
                         , PROJECT_CODE
                         /* , CELL_ITEM_ID */
                         , ITEM_ID
                         , TO_SITE
                         , INCOTERMS
                         , FROM_SITE
                         , BOD_ID
                         /* , TRANSPORT_MODE */
                         , MEASURE
                         , YYYYMMDD
                         , QTY
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                         , ELECTRODE_TYPE
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                 VALUES ( Y.DIVISION_ID
                        , Y.PLAN_START_YYYYMMDD
                        , Y.PLAN_TYPE
                        , Y.SEQ
                        , Y.BIZ_TYPE
                        , Y.PROJECT_CODE
                        /* , Y.CELL_ITEM_ID */
                        , Y.ITEM_ID
                        , Y.TO_SITE
                        , Y.INCOTERMS
                        , Y.FROM_SITE
                        , Y.BOD_ID
                        /* , Y.TRANSPORT_MODE */
                        , Y.MEASURE
                        , Y.YYYYMMDD
                        , Y.QTY
                        , Y.ORIGIN_FROM_DIVISION_ID
                        , Y.ORIGIN_TO_DIVISION_ID
                        , Y.ELECTRODE_TYPE
                        , V_P_USER_ID
                        , SYSDATE
                        , V_P_USER_ID
                        , SYSDATE )
                        ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FG_H : History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SELECT top 10 * FROM dbo.SCP_ANL_SHIPMENT_PLAN_FG_H WITH (NOLOCK)     -- HISTORY_SEQ */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H */

                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG_H
                           ( HISTORY_SEQ
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , BIZ_TYPE
                           , PROJECT_CODE
                           , ITEM_ID
                           , TO_SITE
                           , INCOTERMS
                           , FROM_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_TO_DIVISION_ID
                           , ORIGIN_FROM_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H.NEXTVAL
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , BIZ_TYPE
                           , PROJECT_CODE
                           , ITEM_ID
                           , TO_SITE
                           , INCOTERMS
                           , FROM_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_TO_DIVISION_ID
                           , ORIGIN_FROM_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_P_USER_ID   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_P_USER_ID   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG
                           ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(FG) */
            /* ------------------------------------------------------------------------------------------- */
                        /*  FIX UPDATE */
                        /*  MSSQL UPDATE X SET .. FROM SCP_ANL_SHIPMENT_PLAN_FIX X INNER JOIN #FG Y ON ..
                            -> 원천 다중매치가 가능하므로 상관 UPDATE + EXISTS + ROWNUM = 1 (CV-024) */
                        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                           SET ( QTY
                               , FIX_REASON
                               , ATTRIBUTE1
                               , LAST_UPDATED_BY
                               , LAST_UPDATE_DATE ) =
                               ( SELECT Y.QTY
                                      , 'SIMULATION UPDATE'
                                      , 'Y'                    /* History 구분을 위해 */
                                      , V_P_USER_ID
                                      , SYSDATE
                                   FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                                  WHERE 0 = 0
                                    AND X.DIVISION_ID = Y.DIVISION_ID
                                    AND X.BIZ_TYPE    = Y.BIZ_TYPE
                                    AND X.ITEM_ID     = Y.ITEM_ID
                                    AND X.TO_SITE     = Y.TO_SITE
                                    AND X.FROM_SITE   = Y.FROM_SITE
                                    AND X.BOD_ID      = Y.BOD_ID
                                    AND X.YYYYMMDD    = Y.YYYYMMDD
                                    AND ROWNUM        = 1 )
                         WHERE EXISTS ( SELECT 1
                                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                                         WHERE 0 = 0
                                           AND X.DIVISION_ID = Y.DIVISION_ID
                                           AND X.BIZ_TYPE    = Y.BIZ_TYPE
                                           AND X.ITEM_ID     = Y.ITEM_ID
                                           AND X.TO_SITE     = Y.TO_SITE
                                           AND X.FROM_SITE   = Y.FROM_SITE
                                           AND X.BOD_ID      = Y.BOD_ID
                                           AND X.YYYYMMDD    = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX_H   -- 현재 사용안함. */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H -- SCP_ANL_PRODUCTION_PLAN_FIX 대신 사용중임. */
            /*  SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */


                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
                           ( HISTORY_SEQ
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_P_USER_ID   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_P_USER_ID   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM SCP_ANL_SHIPMENT_PLAN_FIX
                       WHERE ATTRIBUTE1 = 'Y'
                           ;


                  /*  History 구분을 위해 원상복구 */
                  UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                     SET X.ATTRIBUTE1 = NULL
                   WHERE EXISTS ( SELECT 1
                                    FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_FG Y
                                   WHERE 0 = 0
                                     AND X.DIVISION_ID = Y.DIVISION_ID
                                     AND X.BIZ_TYPE    = Y.BIZ_TYPE
                                     AND X.ITEM_ID     = Y.ITEM_ID
                                     AND X.TO_SITE     = Y.TO_SITE
                                     AND X.FROM_SITE   = Y.FROM_SITE
                                     AND X.BOD_ID      = Y.BOD_ID
                                     AND X.YYYYMMDD    = Y.YYYYMMDD )
                     AND X.ATTRIBUTE1 = 'Y';

            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_SEMI UPDATE */
            /*  SEMI_SHIP_PLAN --> SCP_ANL_SHIPMENT_PLAN_SEMI.MEASURE 'SHIP_PLAN_AMEND' UPDATE */
            /* ------------------------------------------------------------------------------------------- */
            IF P_MEASURE IN ('SEMI_SHIP_PLAN') THEN   /* SEMI */

            /*  SEMI_SHIP_PLAN */
              /*  IF OBJECT_ID('tempdb..#SCP_ANL_SHIPMENT_PLAN_SEMI') IS NOT NULL DROP TABLE #SCP_ANL_SHIPMENT_PLAN_SEMI */
              DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI;

              INSERT INTO GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                   ( DIVISION_ID
                   , PLAN_START_YYYYMMDD
                   , PLAN_TYPE
                   , SEQ
                   , OPERATION_GROUP
                   , ITEM_ID
                   , FROM_SITE
                   , BOD_ID
                   , MEASURE
                   , YYYYMMDD
                   , TO_SITE
                   , QTY
                   , ORIGIN_FROM_DIVISION_ID
                   , ORIGIN_TO_DIVISION_ID
                   , ELECTRODE_TYPE
                   , ATTRIBUTE1
                   , YYYYMMDD_COLUMN )
            SELECT X.DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , X.PLAN_TYPE
                 , X.SEQ
                 , X.OPERATION_GROUP
                 /* , X.CELL_ITEM_ID */
                 , X.ITEM_ID
                 , X.FROM_SITE
                 , X.BOD_ID
                 , 'SHIP_PLAN_AMEND' AS MEASURE
                 , Y.YYYYMMDD AS YYYYMMDD
                 , X.TO_SITE
                 , X.QTY
                 , '82' AS ORIGIN_FROM_DIVISION_ID
                 , '82' AS ORIGIN_TO_DIVISION_ID
                 , '' AS ELECTRODE_TYPE
                 , X.ATTRIBUTE1
                 , Y.YYYYMMDD_COLUMN
              FROM ( SELECT *
                       FROM GT_XPGT_DAY_SCP_XLS_PSI_GLOBAL
                      WHERE 0 = 0
                        AND XLS_KEY1            = P_XLS_KEY1   /* 43 */
                   )
                   UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN ( QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
                                        , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
                                        , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
                                        , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                                        , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
                                        , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
                                        , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
                                        , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                                        , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
                                        , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
                                        , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
                                        , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                                        , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
                                        , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
                                        , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
                                        , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                                        , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
                                        , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
                                        , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
                                        , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                                        , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
                                        , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
                                        , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
                                        , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                                        , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
                                        , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
                                        , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
                                        , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                                        , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
                                        , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
                                        , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
                                        , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                                        , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
                                        , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
                                        , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
                                        , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                                        , QTY361, QTY362, QTY363, QTY364
                                        )
                           ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                  , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD     >= P_PLAN_START_YYYYMMDD
                                AND A.BASIS_YYYYMMDD     <  V_P_TO_YYYYMMDD
                            ) Y
             WHERE X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                 ;

                /* ------------------------------------------------------------------------------------------- */
                /*  FROZEN 구간 UPDATE */
                /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
                /* ------------------------------------------------------------------------------------------- */
                IF P_PLAN_TYPE IN ('PR', 'MA', 'SE') THEN
                  DELETE FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI X
                   WHERE EXISTS ( SELECT 1
                                    FROM GT_XPGT_SCM_MST_SITE Y
                                   WHERE Y.DIVISION_ID = X.DIVISION_ID
                                     AND Y.SCM_SITE_ID = X.FROM_SITE
                                     AND X.YYYYMMDD    < Y.SHIP_FROZEN_WEEK_DAY );
                END IF;

               MERGE INTO SCP_ANL_SHIPMENT_PLAN_SEMI X
                USING ( SELECT DIVISION_ID
                             , PLAN_START_YYYYMMDD
                             , PLAN_TYPE
                             , SEQ
                             , OPERATION_GROUP
                             /* , CELL_ITEM_ID */
                             , ITEM_ID
                             , FROM_SITE
                             , BOD_ID
                             , MEASURE
                             , YYYYMMDD
                             , TO_SITE
                             , QTY
                             , ORIGIN_FROM_DIVISION_ID
                             , ORIGIN_TO_DIVISION_ID
                             , ELECTRODE_TYPE
                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                         /* WHERE QTY > 0 */
                      ) Y
                   ON ( 0 = 0
                        AND X.DIVISION_ID         = P_DIVISION_ID
                        AND X.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                        AND X.PLAN_TYPE           = P_PLAN_TYPE
                        AND X.SEQ                 = P_SEQ
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.FROM_SITE           = Y.FROM_SITE
                        AND X.BOD_ID              = Y.BOD_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.TO_SITE             = Y.TO_SITE )
                WHEN MATCHED THEN
                UPDATE
                   SET X.QTY               = Y.QTY
                     /* , X.CREATED_BY         = @p_USER_ID */
                     /* , X.CREATION_DATE      = GETDATE()  */
                     , X.LAST_UPDATED_BY  = V_P_USER_ID
                     , X.LAST_UPDATE_DATE = SYSDATE
                WHEN NOT MATCHED THEN
                  INSERT ( DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , SEQ
                         , OPERATION_GROUP
                         , ITEM_ID
                         , FROM_SITE
                         , BOD_ID
                         , MEASURE
                         , YYYYMMDD
                         , TO_SITE
                         , QTY
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                         , ELECTRODE_TYPE
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                 VALUES ( Y.DIVISION_ID
                        , Y.PLAN_START_YYYYMMDD
                        , Y.PLAN_TYPE
                        , Y.SEQ
                        , Y.OPERATION_GROUP
                        , Y.ITEM_ID
                        , Y.FROM_SITE
                        , Y.BOD_ID
                        , Y.MEASURE
                        , Y.YYYYMMDD
                        , Y.TO_SITE
                        , Y.QTY
                        , Y.ORIGIN_FROM_DIVISION_ID
                        , Y.ORIGIN_TO_DIVISION_ID
                        , Y.ELECTRODE_TYPE
                        , V_P_USER_ID
                        , SYSDATE
                        , V_P_USER_ID
                        , SYSDATE )
                        ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_SEMI_H : History 입력(SEMI) */
            /* ------------------------------------------------------------------------------------------- */
                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI_H
                           ( HISTORY_SEQ
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , ITEM_ID
                           , FROM_SITE
                           , TO_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , UPDATE_REASON_BOD
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H.NEXTVAL
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , ITEM_ID
                           , FROM_SITE
                           , TO_SITE
                           , BOD_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , NULL          AS UPDATE_REASON_BOD
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_P_USER_ID   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_P_USER_ID   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI
                           ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX : FIX 입력(SEMI) */
            /* ------------------------------------------------------------------------------------------- */
                        /*  FIX UPDATE */
                        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                           SET ( QTY
                               , FIX_REASON
                               , ATTRIBUTE1 ) =
                               ( SELECT Y.QTY
                                      , 'SIMULATION UPDATE'
                                      , 'Y'                    /* History 구분을 위해 */
                                   FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                                  WHERE 0 = 0
                                    AND X.DIVISION_ID = Y.DIVISION_ID
                                    AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                                    AND X.ITEM_ID     = Y.ITEM_ID
                                    AND X.TO_SITE     = Y.TO_SITE
                                    AND X.FROM_SITE   = Y.FROM_SITE
                                    AND X.BOD_ID      = Y.BOD_ID
                                    AND X.YYYYMMDD    = Y.YYYYMMDD
                                    AND ROWNUM        = 1 )
                         WHERE EXISTS ( SELECT 1
                                          FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                                         WHERE 0 = 0
                                           AND X.DIVISION_ID = Y.DIVISION_ID
                                           AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                                           AND X.ITEM_ID     = Y.ITEM_ID
                                           AND X.TO_SITE     = Y.TO_SITE
                                           AND X.FROM_SITE   = Y.FROM_SITE
                                           AND X.BOD_ID      = Y.BOD_ID
                                           AND X.YYYYMMDD    = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_SHIPMENT_PLAN_FIX_H : FIX History 입력(SEMI) */
            /* ------------------------------------------------------------------------------------------- */


                      INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
                           ( HISTORY_SEQ
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                           , FIX_ID
                           , DIVISION_ID
                           , BIZ_TYPE
                           , ITEM_ID
                           , TO_SITE
                           , FROM_SITE
                           , PROJECT_CODE
                           , INCOTERMS
                           , BOD_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_P_USER_ID   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_P_USER_ID   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM SCP_ANL_SHIPMENT_PLAN_FIX
                       WHERE ATTRIBUTE1 = 'Y'
                           ;


                  /*  History 구분을 위해 원상복구 */
                  UPDATE SCP_ANL_SHIPMENT_PLAN_FIX X   /* FIX_ID, DIVISION_ID, BIZ_TYPE, ITEM_ID, TO_SITE, FROM_SITE, BOD_ID, YYYYMMDD */
                     SET X.ATTRIBUTE1 = NULL
                   WHERE EXISTS ( SELECT 1
                                    FROM GT_XPGT_SCP_ANL_SHIPMENT_PLAN_SEMI Y
                                   WHERE 0 = 0
                                     AND X.DIVISION_ID = Y.DIVISION_ID
                                     AND X.BIZ_TYPE    = Y.OPERATION_GROUP
                                     AND X.ITEM_ID     = Y.ITEM_ID
                                     AND X.TO_SITE     = Y.TO_SITE
                                     AND X.FROM_SITE   = Y.FROM_SITE
                                     AND X.BOD_ID      = Y.BOD_ID
                                     AND X.YYYYMMDD    = Y.YYYYMMDD )
                     AND X.ATTRIBUTE1 = 'Y';

            END IF;


            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN UPDATE */
            /*  CELL_PROD,PACK_PROD  --> SCP_ANL_PRODUCTION_PLAN.MEASURE 'PROD_PLAN_AMEND' UPDATE */
            /* ------------------------------------------------------------------------------------------- */
            IF P_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN

               /*  IF OBJECT_ID('tempdb..#SCP_ANL_PRODUCTION_PLAN') IS NOT NULL DROP TABLE #SCP_ANL_PRODUCTION_PLAN */
               DELETE FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN;


               INSERT INTO GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                    ( DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                    , OPERATION_GROUP
                    , SCM_SITE_ID
                    , ITEM_ID
                    , LINE_ID
                    , OPERATION_ID
                    , MEASURE
                    , YYYYMMDD
                    , QTY
                    , ORIGIN_DIVISION_ID
                    , ELECTRODE_TYPE
                    , CELL_QTY
                    , YYYYMMDD_COLUMN )
            SELECT X.DIVISION_ID
                 , X.PLAN_START_YYYYMMDD
                 , X.PLAN_TYPE
                 , X.SEQ
                 , X.OPERATION_GROUP
                 /* , X.CELL_ITEM_ID */
                 , X.FROM_SITE AS SCM_SITE_ID
                 , X.ITEM_ID
                 , X.PROD_LINE AS LINE_ID
                 , NVL(X.ATTRIBUTE9, '-') AS OPERATION_ID
                 , 'PROD_PLAN_AMEND' AS MEASURE
                 , Y.YYYYMMDD AS YYYYMMDD
                 , X.QTY
                 , X.DIVISION_ID AS ORIGIN_DIVISION_ID
                 , '' AS ELECTRODE_TYPE
                 , X.CELL_QTY_PACK AS CELL_QTY
                 , Y.YYYYMMDD_COLUMN
              FROM ( SELECT *
                       FROM SCP_XLS_PSI_GLOBAL_ESS
                      WHERE 0 = 0
                        AND DIVISION_ID         = P_DIVISION_ID
                        AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                        AND SEQ                 = P_SEQ
                        AND XLS_KEY1            = P_XLS_KEY1   /* 43 */
                   )
                   UNPIVOT ( QTY FOR YYYYMMDD_COLUMN IN ( QTY001, QTY002, QTY003, QTY004, QTY005, QTY006, QTY007, QTY008, QTY009, QTY010
                                        , QTY011, QTY012, QTY013, QTY014, QTY015, QTY016, QTY017, QTY018, QTY019, QTY020
                                        , QTY021, QTY022, QTY023, QTY024, QTY025, QTY026, QTY027, QTY028, QTY029, QTY030
                                        , QTY031, QTY032, QTY033, QTY034, QTY035, QTY036, QTY037, QTY038, QTY039, QTY040
                                        , QTY041, QTY042, QTY043, QTY044, QTY045, QTY046, QTY047, QTY048, QTY049, QTY050
                                        , QTY051, QTY052, QTY053, QTY054, QTY055, QTY056, QTY057, QTY058, QTY059, QTY060
                                        , QTY061, QTY062, QTY063, QTY064, QTY065, QTY066, QTY067, QTY068, QTY069, QTY070
                                        , QTY071, QTY072, QTY073, QTY074, QTY075, QTY076, QTY077, QTY078, QTY079, QTY080
                                        , QTY081, QTY082, QTY083, QTY084, QTY085, QTY086, QTY087, QTY088, QTY089, QTY090
                                        , QTY091, QTY092, QTY093, QTY094, QTY095, QTY096, QTY097, QTY098, QTY099, QTY100
                                        , QTY101, QTY102, QTY103, QTY104, QTY105, QTY106, QTY107, QTY108, QTY109, QTY110
                                        , QTY111, QTY112, QTY113, QTY114, QTY115, QTY116, QTY117, QTY118, QTY119, QTY120
                                        , QTY121, QTY122, QTY123, QTY124, QTY125, QTY126, QTY127, QTY128, QTY129, QTY130
                                        , QTY131, QTY132, QTY133, QTY134, QTY135, QTY136, QTY137, QTY138, QTY139, QTY140
                                        , QTY141, QTY142, QTY143, QTY144, QTY145, QTY146, QTY147, QTY148, QTY149, QTY150
                                        , QTY151, QTY152, QTY153, QTY154, QTY155, QTY156, QTY157, QTY158, QTY159, QTY160
                                        , QTY161, QTY162, QTY163, QTY164, QTY165, QTY166, QTY167, QTY168, QTY169, QTY170
                                        , QTY171, QTY172, QTY173, QTY174, QTY175, QTY176, QTY177, QTY178, QTY179, QTY180
                                        , QTY181, QTY182, QTY183, QTY184, QTY185, QTY186, QTY187, QTY188, QTY189, QTY190
                                        , QTY191, QTY192, QTY193, QTY194, QTY195, QTY196, QTY197, QTY198, QTY199, QTY200
                                        , QTY201, QTY202, QTY203, QTY204, QTY205, QTY206, QTY207, QTY208, QTY209, QTY210
                                        , QTY211, QTY212, QTY213, QTY214, QTY215, QTY216, QTY217, QTY218, QTY219, QTY220
                                        , QTY221, QTY222, QTY223, QTY224, QTY225, QTY226, QTY227, QTY228, QTY229, QTY230
                                        , QTY231, QTY232, QTY233, QTY234, QTY235, QTY236, QTY237, QTY238, QTY239, QTY240
                                        , QTY241, QTY242, QTY243, QTY244, QTY245, QTY246, QTY247, QTY248, QTY249, QTY250
                                        , QTY251, QTY252, QTY253, QTY254, QTY255, QTY256, QTY257, QTY258, QTY259, QTY260
                                        , QTY261, QTY262, QTY263, QTY264, QTY265, QTY266, QTY267, QTY268, QTY269, QTY270
                                        , QTY271, QTY272, QTY273, QTY274, QTY275, QTY276, QTY277, QTY278, QTY279, QTY280
                                        , QTY281, QTY282, QTY283, QTY284, QTY285, QTY286, QTY287, QTY288, QTY289, QTY290
                                        , QTY291, QTY292, QTY293, QTY294, QTY295, QTY296, QTY297, QTY298, QTY299, QTY300
                                        , QTY301, QTY302, QTY303, QTY304, QTY305, QTY306, QTY307, QTY308, QTY309, QTY310
                                        , QTY311, QTY312, QTY313, QTY314, QTY315, QTY316, QTY317, QTY318, QTY319, QTY320
                                        , QTY321, QTY322, QTY323, QTY324, QTY325, QTY326, QTY327, QTY328, QTY329, QTY330
                                        , QTY331, QTY332, QTY333, QTY334, QTY335, QTY336, QTY337, QTY338, QTY339, QTY340
                                        , QTY341, QTY342, QTY343, QTY344, QTY345, QTY346, QTY347, QTY348, QTY349, QTY350
                                        , QTY351, QTY352, QTY353, QTY354, QTY355, QTY356, QTY357, QTY358, QTY359, QTY360
                                        , QTY361, QTY362, QTY363, QTY364
                                        )
                           ) X
                 , ( SELECT A.BASIS_YYYYMMDD AS YYYYMMDD
                                  , 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD)), 3, '0') AS YYYYMMDD_COLUMN
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD     >= P_PLAN_START_YYYYMMDD
                                AND A.BASIS_YYYYMMDD     <  V_P_TO_YYYYMMDD
                            ) Y
             WHERE X.YYYYMMDD_COLUMN = Y.YYYYMMDD_COLUMN
                 ;

            /* ------------------------------------------------------------------------------------------- */
            /*  FROZEN 구간 UPDATE */
            /*  PLANT SITE(SCM_MST_SITE)의 SHIP_FROZEN ,PROD_FROZEN를 주단위로 변경하여 FROZEN 구간을 저장 내역에서 삭제한다. */
            /* ------------------------------------------------------------------------------------------- */
            IF P_PLAN_TYPE IN ('MA', 'SE') THEN
              DELETE FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN X
               WHERE EXISTS ( SELECT 1
                                FROM GT_XPGT_SCM_MST_SITE Y
                               WHERE Y.DIVISION_ID = X.DIVISION_ID
                                 AND Y.SCM_SITE_ID = X.SCM_SITE_ID
                                 AND X.YYYYMMDD    < Y.PROD_FROZEN_WEEK_DAY );
            END IF;

               /*  PROD_PLAN_AMEND */
               /*  MSSQL : INSERT INTO SCP_ANL_PRODUCTION_PLAN (..) SELECT .. FROM ( MERGE .. OUTPUT $action, Inserted.* )
                   AS Changes(..) WHERE Action = 'INSERT'   (composable DML - Oracle 무대응)
                   = MERGE 로 실제 INSERT 된 행마다 MEASURE='PROD_PLAN_ENGINE', QTY=0 짝 행을 하나 더 넣는 로직이다.
                   MERGE 가 INSERT 할 집합 = ON 절에 매칭되지 않는 원천행이므로, 같은 조건을 NOT EXISTS 로 뽑아
                   MERGE 직전에 짝 행을 먼저 INSERT 한다. 짝 행의 MEASURE 는 'PROD_PLAN_ENGINE' 이고
                   ON 절/PK 모두 MEASURE 를 포함하므로 뒤따르는 MERGE 의 매칭 결과에 영향을 주지 않는다(1:1 등가). */
               /*  INSERT 일경우 PROD_PLAN_ENGINE/PROD_PLAN_AMEND 쌍으로 입력한다. */
               INSERT INTO SCP_ANL_PRODUCTION_PLAN
                    ( DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                    , OPERATION_GROUP
                    /* , CELL_ITEM_ID */
                    , SCM_SITE_ID
                    , ITEM_ID
                    , LINE_ID
                    , OPERATION_ID
                    , MEASURE
                    , YYYYMMDD
                    , QTY
                    , ORIGIN_DIVISION_ID
                    , ELECTRODE_TYPE
                    , CELL_QTY
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE )
               SELECT Y.DIVISION_ID
                    , Y.PLAN_START_YYYYMMDD
                    , Y.PLAN_TYPE
                    , Y.SEQ
                    , Y.OPERATION_GROUP
                    /* , Inserted.CELL_ITEM_ID */
                    , Y.SCM_SITE_ID
                    , Y.ITEM_ID
                    , Y.LINE_ID
                    , NVL(Y.OPERATION_ID, '-') AS OPERATION_ID
                    , 'PROD_PLAN_ENGINE' AS MEASURE
                    , Y.YYYYMMDD
                    , 0 AS QTY
                    , Y.ORIGIN_DIVISION_ID
                    , Y.ELECTRODE_TYPE
                    , Y.CELL_QTY
                    , V_P_USER_ID   AS CREATED_BY
                    , SYSDATE       AS CREATION_DATE
                    , V_P_USER_ID   AS LAST_UPDATED_BY
                    , SYSDATE       AS LAST_UPDATE_DATE
                 FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                WHERE NOT EXISTS ( SELECT 1
                                     FROM SCP_ANL_PRODUCTION_PLAN X
                                    WHERE 0 = 0
                        AND X.DIVISION_ID         = P_DIVISION_ID
                        AND X.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                        AND X.PLAN_TYPE           = P_PLAN_TYPE
                        AND X.SEQ                 = P_SEQ
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.LINE_ID             = Y.LINE_ID
                        AND X.OPERATION_ID        = Y.OPERATION_ID
                        AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                        AND NVL(X.ELECTRODE_TYPE, ' ') = NVL(Y.ELECTRODE_TYPE, ' ') )
                    ;

                       MERGE INTO SCP_ANL_PRODUCTION_PLAN X
                        USING ( SELECT DIVISION_ID
                                     , PLAN_START_YYYYMMDD
                                     , PLAN_TYPE
                                     , SEQ
                                     , OPERATION_GROUP
                                     /* , CELL_ITEM_ID */
                                     , SCM_SITE_ID
                                     , ITEM_ID
                                     , LINE_ID
                                     , OPERATION_ID
                                     , MEASURE
                                     , YYYYMMDD
                                     , QTY
                                     , ORIGIN_DIVISION_ID
                                     , ELECTRODE_TYPE
                                     , CELL_QTY
                                  FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                                 /* WHERE QTY > 0 */
                              ) Y
                           ON ( 0 = 0
                        AND X.DIVISION_ID         = P_DIVISION_ID
                        AND X.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                        AND X.PLAN_TYPE           = P_PLAN_TYPE
                        AND X.SEQ                 = P_SEQ
                        AND X.OPERATION_GROUP     = Y.OPERATION_GROUP
                        AND X.SCM_SITE_ID         = Y.SCM_SITE_ID
                        AND X.ITEM_ID             = Y.ITEM_ID
                        AND X.MEASURE             = Y.MEASURE
                        AND X.YYYYMMDD            = Y.YYYYMMDD
                        AND X.LINE_ID             = Y.LINE_ID
                        AND X.OPERATION_ID        = Y.OPERATION_ID
                        AND X.ORIGIN_DIVISION_ID  = Y.ORIGIN_DIVISION_ID
                        AND NVL(X.ELECTRODE_TYPE, ' ') = NVL(Y.ELECTRODE_TYPE, ' ') )
                        WHEN MATCHED THEN
                        UPDATE
                           SET X.QTY               = Y.QTY
                             /* , X.CREATED_BY         = @p_USER_ID */
                             /* , X.CREATION_DATE      = GETDATE()  */
                             , X.LAST_UPDATED_BY  = V_P_USER_ID
                             , X.LAST_UPDATE_DATE = SYSDATE
                        WHEN NOT MATCHED THEN
                          INSERT ( DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , SEQ
                                 , OPERATION_GROUP
                                 /* , CELL_ITEM_ID */
                                 , SCM_SITE_ID
                                 , ITEM_ID
                                 , LINE_ID
                                 , OPERATION_ID
                                 , MEASURE
                                 , YYYYMMDD
                                 , QTY
                                 , ORIGIN_DIVISION_ID
                                 , ELECTRODE_TYPE
                                 , CELL_QTY
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE )
                         VALUES ( Y.DIVISION_ID
                                , Y.PLAN_START_YYYYMMDD
                                , Y.PLAN_TYPE
                                , Y.SEQ
                                , Y.OPERATION_GROUP
                                /* , Y.CELL_ITEM_ID */
                                , Y.SCM_SITE_ID
                                , Y.ITEM_ID
                                , Y.LINE_ID
                                , NVL(Y.OPERATION_ID, '-')
                                , Y.MEASURE
                                , Y.YYYYMMDD
                                , Y.QTY
                                , Y.ORIGIN_DIVISION_ID
                                , Y.ELECTRODE_TYPE
                                , Y.CELL_QTY
                                , V_P_USER_ID
                                , SYSDATE
                                , V_P_USER_ID
                                , SYSDATE )
                                ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_H : History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SELECT top 10 * FROM dbo.SCP_ANL_PRODUCTION_PLAN_H WITH (NOLOCK)     -- HISTORY_SEQ */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H */
                      INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
                           ( HISTORY_SEQ
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
                           , DIVISION_ID
                           , PLAN_START_YYYYMMDD
                           , PLAN_TYPE
                           , SEQ
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , MEASURE
                           , YYYYMMDD
                           , QTY
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_P_USER_ID   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_P_USER_ID   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN
                           ;

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_FIX : FIX 입력 */
            /* ------------------------------------------------------------------------------------------- */
                      UPDATE SCP_ANL_PRODUCTION_PLAN_FIX X   /* FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD */
                         SET ( QTY
                             , ATTRIBUTE1
                             , FIX_REASON
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE ) =
                             ( SELECT Y.QTY
                                    , 'Y'
                                    , 'SIMULATION UPDATE'
                                    , V_P_USER_ID
                                    , SYSDATE
                                 FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                                WHERE 0 = 0
                                  AND X.DIVISION_ID       = Y.DIVISION_ID
                                  AND X.OPERATION_GROUP   = Y.OPERATION_GROUP
                                  AND X.SCM_SITE_ID       = Y.SCM_SITE_ID
                                  AND X.ITEM_ID           = Y.ITEM_ID
                                  AND X.LINE_ID           = Y.LINE_ID
                                  AND X.OPERATION_ID      = Y.OPERATION_ID
                                  AND X.YYYYMMDD          = Y.YYYYMMDD
                                  AND ROWNUM              = 1 )
                       WHERE EXISTS ( SELECT 1
                                        FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                                       WHERE 0 = 0
                                         AND X.DIVISION_ID       = Y.DIVISION_ID
                                         AND X.OPERATION_GROUP   = Y.OPERATION_GROUP
                                         AND X.SCM_SITE_ID       = Y.SCM_SITE_ID
                                         AND X.ITEM_ID           = Y.ITEM_ID
                                         AND X.LINE_ID           = Y.LINE_ID
                                         AND X.OPERATION_ID      = Y.OPERATION_ID
                                         AND X.YYYYMMDD          = Y.YYYYMMDD );

            /* ------------------------------------------------------------------------------------------- */
            /*  SCP_ANL_PRODUCTION_PLAN_FIX : FIX History 입력 */
            /* ------------------------------------------------------------------------------------------- */
            /*  SET @n_history_seq = NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */
            /*  SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H */
                      INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
                           ( HISTORY_SEQ
                           , FIX_ID
                           , DIVISION_ID
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , CREATED_BY
                           , CREATION_DATE
                           , LAST_UPDATED_BY
                           , LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , HISTORY_CREATION_DATE )
                      SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                           , FIX_ID
                           , DIVISION_ID
                           , OPERATION_GROUP
                           , SCM_SITE_ID
                           , ITEM_ID
                           , LINE_ID
                           , OPERATION_ID
                           , YYYYMMDD
                           , QTY
                           , FIX_REASON
                           , ORIGIN_DIVISION_ID
                           , ELECTRODE_TYPE
                           , V_P_USER_ID   AS CREATED_BY
                           , SYSDATE       AS CREATION_DATE
                           , V_P_USER_ID   AS LAST_UPDATED_BY
                           , SYSDATE       AS LAST_UPDATE_DATE
                           /* ,ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10 */
                           , SYSDATE       AS HISTORY_CREATION_DATE
                        FROM SCP_ANL_PRODUCTION_PLAN_FIX
                       WHERE ATTRIBUTE1 = 'Y'
                           ;

              /*  History 구분을 위해 원상복구 */
              UPDATE SCP_ANL_PRODUCTION_PLAN_FIX X   /* FIX_ID, DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, YYYYMMDD */
                 SET X.ATTRIBUTE1 = NULL
               WHERE EXISTS ( SELECT 1
                                FROM GT_XPGT_SCP_ANL_PRODUCTION_PLAN Y
                               WHERE 0 = 0
                                 AND X.DIVISION_ID     = Y.DIVISION_ID
                                 AND X.OPERATION_GROUP = Y.OPERATION_GROUP
                                 AND X.SCM_SITE_ID     = Y.SCM_SITE_ID
                                 AND X.ITEM_ID         = Y.ITEM_ID
                                 AND X.LINE_ID         = Y.LINE_ID
                                 AND X.OPERATION_ID    = Y.OPERATION_ID
                                 AND X.YYYYMMDD        = Y.YYYYMMDD )
                 AND X.ATTRIBUTE1 = 'Y';

            END IF;


              /* --------------------------------------------------------------- */
              /*  FROZEN 구간 복구 */
              /* --------------------------------------------------------------- */

               /* ------------------------------------------------------------------------------------------- */
                  /*  전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_ESS_MODIFY) */
                  /* ------------------------------------------------------------------------------------------- */
                  /*                      DROP TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY
                      CREATE TABLE #SCP_XLS_PSI_GLOBAL_ESS_MODIFY ( XLS_KEY1 NVARCHAR(200) NULL,
                        QTY001 NUMERIC(20,10) NULL, .. QTY364 NUMERIC(20,10) NULL ) */
                  DELETE FROM GT_XPGT_SCP_XLS_PSI_GLOBAL_ESS_MODIFY;

                    /*  SCP_ANL_SHIPMENT_PLAN_FG/SEMI PK Parameter, SCP_ANL_PRODUCTION_PLAN PK Parameter */
                    V_X_ITEM_ID         := '';
                    V_X_OPERATION_GROUP := '';   /* BIZ_TYPE */
                    V_X_PROJECT_CODE    := '';
                    V_X_TO_SITE         := '';
                    V_X_INCOTERMS       := '';
                    V_X_FROM_SITE       := '';   /* SCM_SITE_ID */
                    V_X_BOD_ID          := '';
                    V_X_LINE_ID         := '';
                    V_X_OPERATION_ID    := '';

                    /*  MSSQL SELECT @X_.. = .. FROM .. WHERE XLS_KEY1 = @p_xls_key1 : 0행이면 기존값 유지, */
                    FOR R IN ( SELECT OPERATION_GROUP
                                    , ITEM_ID
                                    , PROD_LINE
                                    , ATTRIBUTE9
                                    , PROJECT_CODE
                                    , TO_SITE
                                    , INCOTERMS
                                    , FROM_SITE
                                    , BOD_ID
                                 FROM SCP_XLS_PSI_GLOBAL_ESS
                                WHERE XLS_KEY1 = P_XLS_KEY1 )
                    LOOP
                        V_X_OPERATION_GROUP := R.OPERATION_GROUP;
                        V_X_ITEM_ID         := R.ITEM_ID;
                        V_X_LINE_ID         := R.PROD_LINE;
                        V_X_OPERATION_ID    := R.ATTRIBUTE9;
                        V_X_PROJECT_CODE    := R.PROJECT_CODE;
                        V_X_TO_SITE         := R.TO_SITE;
                        V_X_INCOTERMS       := R.INCOTERMS;
                        V_X_FROM_SITE       := R.FROM_SITE;
                        V_X_BOD_ID          := R.BOD_ID;
                    END LOOP;

              IF P_MEASURE <> 'CELL_CHAR_PLAN' THEN
                  /* ------------------------------------------------------------------------------------------- */
                  /*  저장후 시물레이션 데이터 UPDATE */
                  /* ------------------------------------------------------------------------------------------- */

                    /*  MSSQL SELECT @v = @v + .. FROM (..) ORDER BY .. (행별 문자열 누적 트릭, EP-013) */
                    V_MQRY_SUM2 := '';
                    FOR R IN ( SELECT ' SUM(CASE WHEN YYYYMMDD = ''' || A.YYYYMMDD || '''    THEN QTY ELSE 0 END ) AS '
                                      || 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.YYYYMMDD)), 3, '0') AS COL_EXPR
                                 FROM ( SELECT A.BASIS_YYYYMMDD                      AS YYYYMMDD
                                             , A.BASIS_YYYYMMDD || TO_CHAR(31)       AS SORT_ORDER_NO
                                          FROM SCM_SYS_CALENDAR_M A
                                         WHERE A.BASIS_YYYYMMDD     >= P_PLAN_START_YYYYMMDD
                                           AND A.BASIS_YYYYMMDD     <  V_P_TO_YYYYMMDD
                                         GROUP BY A.BASIS_YYYYMMDD
                                      ) A
                                ORDER BY A.SORT_ORDER_NO )
                    LOOP
                        V_MQRY_SUM2 := V_MQRY_SUM2 || ',' || R.COL_EXPR || '' || CHR(10);
                    END LOOP;

                    V_MEXEC2 := '';
                    /*  MSSQL INSERT INTO #.. WITH (TABLOCK) : TABLOCK 힌트는 Oracle 무대응이라 제거(H-13) */
                    V_MEXEC2 := V_MEXEC2 || ' INSERT INTO GT_XPGT_SCP_XLS_PSI_GLOBAL_ESS_MODIFY  ' || CHR(10);

                    /* ------------------------------------------------------------------------------------------- */
                    /*  'SHIP_PLAN' */
                    /*  PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, YYYYMMDD, BIZ_TYPE, ITEM_ID, PROJECT_CODE, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE */
                    /* ------------------------------------------------------------------------------------------- */
                    V_MFG := '';
                    V_MFG := V_MFG || ' SELECT  ''' || P_XLS_KEY1 || ''' AS XLS_KEY1  ' || CHR(10);
                    V_MFG := V_MFG || '           ' || V_MQRY_SUM2 || '                       ' || CHR(10);
                    V_MFG := V_MFG || '    FROM SCP_ANL_SHIPMENT_PLAN_FG  ' || CHR(10);
                    V_MFG := V_MFG || '    WHERE 0 = 0                                 ' || CHR(10);
                    V_MFG := V_MFG || '    AND DIVISION_ID         =  ''' || P_DIVISION_ID || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND PLAN_START_YYYYMMDD =  ''' || P_PLAN_START_YYYYMMDD || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND PLAN_TYPE           =  ''' || P_PLAN_TYPE || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND SEQ                 =  ' || TO_CHAR(P_SEQ) || '' || CHR(10);
                    V_MFG := V_MFG || '    AND BIZ_TYPE            =  ''' || V_X_OPERATION_GROUP || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND ITEM_ID             =  ''' || V_X_ITEM_ID || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND PROJECT_CODE        =  ''' || V_X_PROJECT_CODE || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND TO_SITE             =  ''' || V_X_TO_SITE || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND INCOTERMS           =  ''' || V_X_INCOTERMS || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND FROM_SITE           =  ''' || V_X_FROM_SITE || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND BOD_ID              =  ''' || V_X_BOD_ID || '''' || CHR(10);
                    V_MFG := V_MFG || '    AND MEASURE             = ''SHIP_PLAN_AMEND'' ' || CHR(10);
                    V_MFG := V_MFG || '    AND YYYYMMDD            <  ''' || V_P_TO_YYYYMMDD || '''' || CHR(10);

                    /* ------------------------------------------------------------------------------------------- */
                    /*  'SEMI_SHIP_PLAN' */
                    /*  PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ITEM_ID, FROM_SITE, BOD_ID, MEASURE, YYYYMMDD */
                    /* ------------------------------------------------------------------------------------------- */
                    V_MSEMI := '';
                    V_MSEMI := V_MSEMI || ' SELECT  ''' || P_XLS_KEY1 || ''' AS XLS_KEY1  ' || CHR(10);
                    V_MSEMI := V_MSEMI || '           ' || V_MQRY_SUM2 || '                       ' || CHR(10);
                    V_MSEMI := V_MSEMI || '    FROM SCP_ANL_SHIPMENT_PLAN_SEMI  ' || CHR(10);
                    V_MSEMI := V_MSEMI || '    WHERE 0 = 0                                 ' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND DIVISION_ID         =  ''' || P_DIVISION_ID || '''' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND PLAN_START_YYYYMMDD =  ''' || P_PLAN_START_YYYYMMDD || '''' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND PLAN_TYPE           =  ''' || P_PLAN_TYPE || '''' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND SEQ                 =  ' || TO_CHAR(P_SEQ) || '' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND OPERATION_GROUP     =  ''' || V_X_OPERATION_GROUP || '''' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND ITEM_ID             =  ''' || V_X_ITEM_ID || '''' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND FROM_SITE           =  ''' || V_X_FROM_SITE || '''' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND BOD_ID              =  ''' || V_X_BOD_ID || '''' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND MEASURE             = ''SHIP_PLAN_AMEND'' ' || CHR(10);
                    V_MSEMI := V_MSEMI || '    AND YYYYMMDD            <  ''' || V_P_TO_YYYYMMDD || '''' || CHR(10);

                    /* ------------------------------------------------------------------------------------------- */
                    /*  'PACK_PROD','CELL_PROD' */
                    /*  PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD */
                    /* ------------------------------------------------------------------------------------------- */
                    V_MPROD := '';
                    V_MPROD := V_MPROD || ' SELECT  ''' || P_XLS_KEY1 || ''' AS XLS_KEY1  ' || CHR(10);
                    V_MPROD := V_MPROD || '           ' || V_MQRY_SUM2 || '                       ' || CHR(10);
                    V_MPROD := V_MPROD || '    FROM SCP_ANL_PRODUCTION_PLAN  ' || CHR(10);
                    V_MPROD := V_MPROD || '    WHERE 0 = 0                                 ' || CHR(10);
                    V_MPROD := V_MPROD || '    AND DIVISION_ID         =  ''' || P_DIVISION_ID || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND PLAN_START_YYYYMMDD =  ''' || P_PLAN_START_YYYYMMDD || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND PLAN_TYPE           =  ''' || P_PLAN_TYPE || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND SEQ                 =  ' || TO_CHAR(P_SEQ) || '' || CHR(10);
                    V_MPROD := V_MPROD || '    AND OPERATION_GROUP     =  ''' || V_X_OPERATION_GROUP || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND SCM_SITE_ID         =  ''' || V_X_FROM_SITE || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND ITEM_ID             =  ''' || V_X_ITEM_ID || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND LINE_ID             =  ''' || V_X_LINE_ID || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND OPERATION_ID        =  ''' || V_X_OPERATION_ID || '''' || CHR(10);
                    V_MPROD := V_MPROD || '    AND MEASURE             = ''PROD_PLAN_AMEND'' ' || CHR(10);
                    V_MPROD := V_MPROD || '    AND YYYYMMDD            <  ''' || V_P_TO_YYYYMMDD || '''' || CHR(10);
                    /* ------------------------------------------------------------------------------------------- */

                    IF P_MEASURE IN ('SHIP_PLAN') THEN        /* FG */
                      V_MEXEC2 := V_MEXEC2 || V_MFG;
                    END IF;

                    IF P_MEASURE IN ('SEMI_SHIP_PLAN') THEN   /* SEMI */
                      V_MEXEC2 := V_MEXEC2 || V_MSEMI;
                    END IF;

                    IF P_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN   /* PROD */
                      V_MEXEC2 := V_MEXEC2 || V_MPROD;
                    END IF;

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

          EXECUTE IMMEDIATE V_MEXEC2;

                  /*  #SCP_XLS_PSI_GLOBAL_ESS_MODIFY */
                  /*  MSSQL UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN #MODIFY Y ON X.XLS_KEY1 = Y.XLS_KEY1 */
                  MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X
                   USING GT_XPGT_SCP_XLS_PSI_GLOBAL_ESS_MODIFY Y
                      ON ( X.XLS_KEY1 = Y.XLS_KEY1 )
                   WHEN MATCHED THEN
                   UPDATE
                      SET X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005
                        , X.QTY006 = Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010
                        , X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015
                        , X.QTY016 = Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020
                        , X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025
                        , X.QTY026 = Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030
                        , X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035
                        , X.QTY036 = Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040
                        , X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045
                        , X.QTY046 = Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050
                        , X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055
                        , X.QTY056 = Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060
                        , X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065
                        , X.QTY066 = Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070
                        , X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075
                        , X.QTY076 = Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080
                        , X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085
                        , X.QTY086 = Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090
                        , X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095
                        , X.QTY096 = Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100
                        , X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105
                        , X.QTY106 = Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110
                        , X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115
                        , X.QTY116 = Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120
                        , X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125
                        , X.QTY126 = Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130
                        , X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135
                        , X.QTY136 = Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140
                        , X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145
                        , X.QTY146 = Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150
                        , X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155
                        , X.QTY156 = Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160
                        , X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165
                        , X.QTY166 = Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170
                        , X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175
                        , X.QTY176 = Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180
                        , X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185
                        , X.QTY186 = Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190
                        , X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195
                        , X.QTY196 = Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200
                        , X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205
                        , X.QTY206 = Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210
                        , X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215
                        , X.QTY216 = Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220
                        , X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225
                        , X.QTY226 = Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230
                        , X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235
                        , X.QTY236 = Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240
                        , X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245
                        , X.QTY246 = Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250
                        , X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255
                        , X.QTY256 = Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260
                        , X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265
                        , X.QTY266 = Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270
                        , X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275
                        , X.QTY276 = Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280
                        , X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285
                        , X.QTY286 = Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290
                        , X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295
                        , X.QTY296 = Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300
                        , X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305
                        , X.QTY306 = Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310
                        , X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315
                        , X.QTY316 = Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320
                        , X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325
                        , X.QTY326 = Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330
                        , X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335
                        , X.QTY336 = Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340
                        , X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345
                        , X.QTY346 = Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350
                        , X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355
                        , X.QTY356 = Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360
                        , X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364
                        , X.WQTY01 = Y.QTY001 + Y.QTY002 + Y.QTY003 + Y.QTY004 + Y.QTY005 + Y.QTY006 + Y.QTY007
                        , X.WQTY02 = Y.QTY008 + Y.QTY009 + Y.QTY010 + Y.QTY011 + Y.QTY012 + Y.QTY013 + Y.QTY014
                        , X.WQTY03 = Y.QTY015 + Y.QTY016 + Y.QTY017 + Y.QTY018 + Y.QTY019 + Y.QTY020 + Y.QTY021
                        , X.WQTY04 = Y.QTY022 + Y.QTY023 + Y.QTY024 + Y.QTY025 + Y.QTY026 + Y.QTY027 + Y.QTY028
                        , X.WQTY05 = Y.QTY029 + Y.QTY030 + Y.QTY031 + Y.QTY032 + Y.QTY033 + Y.QTY034 + Y.QTY035
                        , X.WQTY06 = Y.QTY036 + Y.QTY037 + Y.QTY038 + Y.QTY039 + Y.QTY040 + Y.QTY041 + Y.QTY042
                        , X.WQTY07 = Y.QTY043 + Y.QTY044 + Y.QTY045 + Y.QTY046 + Y.QTY047 + Y.QTY048 + Y.QTY049
                        , X.WQTY08 = Y.QTY050 + Y.QTY051 + Y.QTY052 + Y.QTY053 + Y.QTY054 + Y.QTY055 + Y.QTY056
                        , X.WQTY09 = Y.QTY057 + Y.QTY058 + Y.QTY059 + Y.QTY060 + Y.QTY061 + Y.QTY062 + Y.QTY063
                        , X.WQTY10 = Y.QTY064 + Y.QTY065 + Y.QTY066 + Y.QTY067 + Y.QTY068 + Y.QTY069 + Y.QTY070
                        , X.WQTY11 = Y.QTY071 + Y.QTY072 + Y.QTY073 + Y.QTY074 + Y.QTY075 + Y.QTY076 + Y.QTY077
                        , X.WQTY12 = Y.QTY078 + Y.QTY079 + Y.QTY080 + Y.QTY081 + Y.QTY082 + Y.QTY083 + Y.QTY084
                        , X.WQTY13 = Y.QTY085 + Y.QTY086 + Y.QTY087 + Y.QTY088 + Y.QTY089 + Y.QTY090 + Y.QTY091
                        , X.WQTY14 = Y.QTY092 + Y.QTY093 + Y.QTY094 + Y.QTY095 + Y.QTY096 + Y.QTY097 + Y.QTY098
                        , X.WQTY15 = Y.QTY099 + Y.QTY100 + Y.QTY101 + Y.QTY102 + Y.QTY103 + Y.QTY104 + Y.QTY105
                        , X.WQTY16 = Y.QTY106 + Y.QTY107 + Y.QTY108 + Y.QTY109 + Y.QTY110 + Y.QTY111 + Y.QTY112
                        , X.WQTY17 = Y.QTY113 + Y.QTY114 + Y.QTY115 + Y.QTY116 + Y.QTY117 + Y.QTY118 + Y.QTY119
                        , X.WQTY18 = Y.QTY120 + Y.QTY121 + Y.QTY122 + Y.QTY123 + Y.QTY124 + Y.QTY125 + Y.QTY126
                        , X.WQTY19 = Y.QTY127 + Y.QTY128 + Y.QTY129 + Y.QTY130 + Y.QTY131 + Y.QTY132 + Y.QTY133
                        , X.WQTY20 = Y.QTY134 + Y.QTY135 + Y.QTY136 + Y.QTY137 + Y.QTY138 + Y.QTY139 + Y.QTY140
                        , X.WQTY21 = Y.QTY141 + Y.QTY142 + Y.QTY143 + Y.QTY144 + Y.QTY145 + Y.QTY146 + Y.QTY147
                        , X.WQTY22 = Y.QTY148 + Y.QTY149 + Y.QTY150 + Y.QTY151 + Y.QTY152 + Y.QTY153 + Y.QTY154
                        , X.WQTY23 = Y.QTY155 + Y.QTY156 + Y.QTY157 + Y.QTY158 + Y.QTY159 + Y.QTY160 + Y.QTY161
                        , X.WQTY24 = Y.QTY162 + Y.QTY163 + Y.QTY164 + Y.QTY165 + Y.QTY166 + Y.QTY167 + Y.QTY168
                        , X.WQTY25 = Y.QTY169 + Y.QTY170 + Y.QTY171 + Y.QTY172 + Y.QTY173 + Y.QTY174 + Y.QTY175
                        , X.WQTY26 = Y.QTY176 + Y.QTY177 + Y.QTY178 + Y.QTY179 + Y.QTY180 + Y.QTY181 + Y.QTY182
                        , X.WQTY27 = Y.QTY183 + Y.QTY184 + Y.QTY185 + Y.QTY186 + Y.QTY187 + Y.QTY188 + Y.QTY189
                        , X.WQTY28 = Y.QTY190 + Y.QTY191 + Y.QTY192 + Y.QTY193 + Y.QTY194 + Y.QTY195 + Y.QTY196
                        , X.WQTY29 = Y.QTY197 + Y.QTY198 + Y.QTY199 + Y.QTY200 + Y.QTY201 + Y.QTY202 + Y.QTY203
                        , X.WQTY30 = Y.QTY204 + Y.QTY205 + Y.QTY206 + Y.QTY207 + Y.QTY208 + Y.QTY209 + Y.QTY210
                        , X.WQTY31 = Y.QTY211 + Y.QTY212 + Y.QTY213 + Y.QTY214 + Y.QTY215 + Y.QTY216 + Y.QTY217
                        , X.WQTY32 = Y.QTY218 + Y.QTY219 + Y.QTY220 + Y.QTY221 + Y.QTY222 + Y.QTY223 + Y.QTY224
                        , X.WQTY33 = Y.QTY225 + Y.QTY226 + Y.QTY227 + Y.QTY228 + Y.QTY229 + Y.QTY230 + Y.QTY231
                        , X.WQTY34 = Y.QTY232 + Y.QTY233 + Y.QTY234 + Y.QTY235 + Y.QTY236 + Y.QTY237 + Y.QTY238
                        , X.WQTY35 = Y.QTY239 + Y.QTY240 + Y.QTY241 + Y.QTY242 + Y.QTY243 + Y.QTY244 + Y.QTY245
                        , X.WQTY36 = Y.QTY246 + Y.QTY247 + Y.QTY248 + Y.QTY249 + Y.QTY250 + Y.QTY251 + Y.QTY252
                        , X.WQTY37 = Y.QTY253 + Y.QTY254 + Y.QTY255 + Y.QTY256 + Y.QTY257 + Y.QTY258 + Y.QTY259
                        , X.WQTY38 = Y.QTY260 + Y.QTY261 + Y.QTY262 + Y.QTY263 + Y.QTY264 + Y.QTY265 + Y.QTY266
                        , X.WQTY39 = Y.QTY267 + Y.QTY268 + Y.QTY269 + Y.QTY270 + Y.QTY271 + Y.QTY272 + Y.QTY273
                        , X.WQTY40 = Y.QTY274 + Y.QTY275 + Y.QTY276 + Y.QTY277 + Y.QTY278 + Y.QTY279 + Y.QTY280
                        , X.WQTY41 = Y.QTY281 + Y.QTY282 + Y.QTY283 + Y.QTY284 + Y.QTY285 + Y.QTY286 + Y.QTY287
                        , X.WQTY42 = Y.QTY288 + Y.QTY289 + Y.QTY290 + Y.QTY291 + Y.QTY292 + Y.QTY293 + Y.QTY294
                        , X.WQTY43 = Y.QTY295 + Y.QTY296 + Y.QTY297 + Y.QTY298 + Y.QTY299 + Y.QTY300 + Y.QTY301
                        , X.WQTY44 = Y.QTY302 + Y.QTY303 + Y.QTY304 + Y.QTY305 + Y.QTY306 + Y.QTY307 + Y.QTY308
                        , X.WQTY45 = Y.QTY309 + Y.QTY310 + Y.QTY311 + Y.QTY312 + Y.QTY313 + Y.QTY314 + Y.QTY315
                        , X.WQTY46 = Y.QTY316 + Y.QTY317 + Y.QTY318 + Y.QTY319 + Y.QTY320 + Y.QTY321 + Y.QTY322
                        , X.WQTY47 = Y.QTY323 + Y.QTY324 + Y.QTY325 + Y.QTY326 + Y.QTY327 + Y.QTY328 + Y.QTY329
                        , X.WQTY48 = Y.QTY330 + Y.QTY331 + Y.QTY332 + Y.QTY333 + Y.QTY334 + Y.QTY335 + Y.QTY336
                        , X.WQTY49 = Y.QTY337 + Y.QTY338 + Y.QTY339 + Y.QTY340 + Y.QTY341 + Y.QTY342 + Y.QTY343
                        , X.WQTY50 = Y.QTY344 + Y.QTY345 + Y.QTY346 + Y.QTY347 + Y.QTY348 + Y.QTY349 + Y.QTY350
                        , X.WQTY51 = Y.QTY351 + Y.QTY352 + Y.QTY353 + Y.QTY354 + Y.QTY355 + Y.QTY356 + Y.QTY357
                        , X.WQTY52 = Y.QTY358 + Y.QTY359 + Y.QTY360 + Y.QTY361 + Y.QTY362 + Y.QTY363 + Y.QTY364
                        , X.LAST_UPDATED_BY   = V_P_USER_ID
                        , X.LAST_UPDATE_DATE  = SYSDATE
                        ;


              IF P_MEASURE IN ('PACK_PROD', 'CELL_PROD') THEN
              /* ------------------------------------------------------------------------------------------- */
              /*  LINE_TOTAL_LOAD_ENGINE UPDATE (TACT_TIME,WORKING_TIME)  , PACK_PROD_LOAD,CELL_PROD_LOAD */
              /* ------------------------------------------------------------------------------------------- */
              /*  Line Load 율 로직 작업중 */
              /* ------------------------------------------------------------------------------------------- */
              /*  IF OBJECT_ID('tempdb..#LINE_WORKINGTIME_BY_LOSS') IS NOT NULL DROP TABLE #LINE_WORKINGTIME_BY_LOSS */

              DELETE FROM GT_XPGT_LINE_WORKINGTIME_LOSS;

                V_LINE_ID := '';

                /*  MSSQL SELECT @v_line_id = PROD_LINE FROM .. WHERE XLS_KEY1 = @p_xls_key1 -> 커서 FOR 루프 */
                FOR R IN ( SELECT PROD_LINE
                             FROM SCP_XLS_PSI_GLOBAL_ESS
                            WHERE XLS_KEY1 = P_XLS_KEY1 )
                LOOP
                    V_LINE_ID := R.PROD_LINE;
                END LOOP;

                /* Working Time 추출 */

                INSERT INTO GT_XPGT_LINE_WORKINGTIME_LOSS
                     ( DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_ID
                     , LINE_ID
                     , YYYYMMDD
                     , WORKING_TIME )
                SELECT DIVISION_ID
                     , PLANT_SITE_ID AS SCM_SITE_ID
                     , OPERATION_ID
                     , LINE_ID
                     , YYYYMMDD
                     , WORKING_TIME
                  FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(P_DIVISION_ID, P_PLAN_START_YYYYMMDD, V_P_TO_YYYYMMDD, V_LINE_ID))
                 WHERE LINE_ID = V_LINE_ID
                     ;

                /*  IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad */

                DELETE FROM GT_XPGT_LINELOAD;

                INSERT INTO GT_XPGT_LINELOAD
                     ( DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_GROUP
                     , OPERATION_ID
                     , LINE_ID
                     , MEASURE
                     , QTY
                     , CAPA_TACT
                     , WORKING_TIME
                     , YYYYMMDD
                     , ISO_YYYYWW
                     , WEEK_COLUMN )
            SELECT /*DISTINCT */
                   A.DIVISION_ID
                 , A.SCM_SITE_ID
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                         WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                    END) AS MEASURE
                 , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                        ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100
                   END AS QTY
                 , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0) AS CAPA_TACT
                 , NVL(D.WORKING_TIME, 0) AS WORKING_TIME
                 , A.YYYYMMDD AS YYYYMMDD
                 , C.ISO_YYYYWW AS ISO_YYYYWW
                 , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0') AS WEEK_COLUMN
              FROM SCP_ANL_PRODUCTION_PLAN A
                 , SCM_SYS_CALENDAR_M C
                 , GT_XPGT_LINE_WORKINGTIME_LOSS D
                 , SCP_ANL_TACT_TIME E
             WHERE 1 = 1
               AND A.YYYYMMDD           = C.BASIS_YYYYMMDD
               AND A.DIVISION_ID        = D.DIVISION_ID(+)
               AND A.OPERATION_ID       = D.OPERATION_ID(+)
               AND A.SCM_SITE_ID        = D.SCM_SITE_ID(+)
               AND A.LINE_ID            = D.LINE_ID(+)
               AND A.YYYYMMDD           = D.YYYYMMDD(+)
               AND A.DIVISION_ID        = E.DIVISION_ID(+)
               AND A.OPERATION_ID       = E.OPERATION_ID(+)
               AND A.SCM_SITE_ID        = E.SCM_SITE_ID(+)
               AND A.LINE_ID            = E.LINE_ID(+)
               AND A.ITEM_ID            = E.ITEM_ID(+)
               AND A.YYYYMMDD           = E.YYYYMMDD(+)
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               AND A.YYYYMMDD           >= P_PLAN_START_YYYYMMDD
               AND A.YYYYMMDD           <  V_P_TO_YYYYMMDD
               AND A.MEASURE             = 'PROD_PLAN_AMEND'
               AND A.LINE_ID             = V_LINE_ID
             GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.OPERATION_ID, A.LINE_ID, A.YYYYMMDD, D.WORKING_TIME, C.ISO_YYYYWW, A.OPERATION_GROUP
                 , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                         WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                    END)
                 ;

            /* ------------------------------------------------------------------------------------------- */
            /*   364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) */
            /* ------------------------------------------------------------------------------------------- */
              V_MQRY_SUM := '';
              FOR R IN ( SELECT ' SUM(CASE WHEN YYYYMMDD = ''' || A.YYYYMMDD || '''    THEN QTY ELSE 0 END ) AS '
                                || 'QTY' || LPAD(TO_CHAR(ROW_NUMBER() OVER(ORDER BY A.YYYYMMDD)), 3, '0') AS COL_EXPR
                           FROM ( SELECT A.BASIS_YYYYMMDD                      AS YYYYMMDD
                                       , A.BASIS_YYYYMMDD || TO_CHAR(31)       AS SORT_ORDER_NO
                                    FROM SCM_SYS_CALENDAR_M A
                                   WHERE A.BASIS_YYYYMMDD     >= P_PLAN_START_YYYYMMDD
                                     AND A.BASIS_YYYYMMDD     <  V_P_TO_YYYYMMDD
                                   GROUP BY A.BASIS_YYYYMMDD
                                ) A
                          ORDER BY A.SORT_ORDER_NO )
              LOOP
                  V_MQRY_SUM := V_MQRY_SUM || ',' || R.COL_EXPR || '' || CHR(10);
              END LOOP;

              /*  MSSQL 동적 UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN (GROUP BY 인라인뷰) Y ON .. */
              V_MEXEC := '';
              V_MEXEC := V_MEXEC || 'MERGE INTO SCP_XLS_PSI_GLOBAL_ESS X' || CHR(10);
              V_MEXEC := V_MEXEC || ' USING ( SELECT A.DIVISION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.OPERATION_GROUP' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.SCM_SITE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.OPERATION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.MEASURE' || CHR(10);
              V_MEXEC := V_MEXEC || '              ,A.LINE_ID ' || CHR(10);
              V_MEXEC := V_MEXEC || '               ' || V_MQRY_SUM || '  ' || CHR(10);
              V_MEXEC := V_MEXEC || '           FROM GT_XPGT_LINELOAD A' || CHR(10);
              V_MEXEC := V_MEXEC || '          GROUP BY  A.DIVISION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.OPERATION_GROUP' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.SCM_SITE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.OPERATION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.MEASURE' || CHR(10);
              V_MEXEC := V_MEXEC || '                   ,A.LINE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '       ) Y ' || CHR(10);
              V_MEXEC := V_MEXEC || '    ON ( 0 = 0' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.OPERATION_GROUP   = Y.OPERATION_GROUP' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.FROM_SITE         = Y.SCM_SITE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.ATTRIBUTE9        = Y.OPERATION_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.PROD_LINE         = Y.LINE_ID' || CHR(10);
              V_MEXEC := V_MEXEC || '         AND X.MEASURE           = Y.MEASURE )' || CHR(10);
              V_MEXEC := V_MEXEC || ' WHEN MATCHED THEN UPDATE SET ' || CHR(10);
              V_MEXEC := V_MEXEC || '        X.QTY001 = Y.QTY001, X.QTY002 = Y.QTY002, X.QTY003 = Y.QTY003, X.QTY004 = Y.QTY004, X.QTY005 = Y.QTY005, X.QTY006 = Y.QTY006, X.QTY007 = Y.QTY007, X.QTY008 = Y.QTY008, X.QTY009 = Y.QTY009, X.QTY010 = Y.QTY010' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY011 = Y.QTY011, X.QTY012 = Y.QTY012, X.QTY013 = Y.QTY013, X.QTY014 = Y.QTY014, X.QTY015 = Y.QTY015, X.QTY016 = Y.QTY016, X.QTY017 = Y.QTY017, X.QTY018 = Y.QTY018, X.QTY019 = Y.QTY019, X.QTY020 = Y.QTY020' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY021 = Y.QTY021, X.QTY022 = Y.QTY022, X.QTY023 = Y.QTY023, X.QTY024 = Y.QTY024, X.QTY025 = Y.QTY025, X.QTY026 = Y.QTY026, X.QTY027 = Y.QTY027, X.QTY028 = Y.QTY028, X.QTY029 = Y.QTY029, X.QTY030 = Y.QTY030' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY031 = Y.QTY031, X.QTY032 = Y.QTY032, X.QTY033 = Y.QTY033, X.QTY034 = Y.QTY034, X.QTY035 = Y.QTY035, X.QTY036 = Y.QTY036, X.QTY037 = Y.QTY037, X.QTY038 = Y.QTY038, X.QTY039 = Y.QTY039, X.QTY040 = Y.QTY040' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY041 = Y.QTY041, X.QTY042 = Y.QTY042, X.QTY043 = Y.QTY043, X.QTY044 = Y.QTY044, X.QTY045 = Y.QTY045, X.QTY046 = Y.QTY046, X.QTY047 = Y.QTY047, X.QTY048 = Y.QTY048, X.QTY049 = Y.QTY049, X.QTY050 = Y.QTY050' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY051 = Y.QTY051, X.QTY052 = Y.QTY052, X.QTY053 = Y.QTY053, X.QTY054 = Y.QTY054, X.QTY055 = Y.QTY055, X.QTY056 = Y.QTY056, X.QTY057 = Y.QTY057, X.QTY058 = Y.QTY058, X.QTY059 = Y.QTY059, X.QTY060 = Y.QTY060' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY061 = Y.QTY061, X.QTY062 = Y.QTY062, X.QTY063 = Y.QTY063, X.QTY064 = Y.QTY064, X.QTY065 = Y.QTY065, X.QTY066 = Y.QTY066, X.QTY067 = Y.QTY067, X.QTY068 = Y.QTY068, X.QTY069 = Y.QTY069, X.QTY070 = Y.QTY070' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY071 = Y.QTY071, X.QTY072 = Y.QTY072, X.QTY073 = Y.QTY073, X.QTY074 = Y.QTY074, X.QTY075 = Y.QTY075, X.QTY076 = Y.QTY076, X.QTY077 = Y.QTY077, X.QTY078 = Y.QTY078, X.QTY079 = Y.QTY079, X.QTY080 = Y.QTY080' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY081 = Y.QTY081, X.QTY082 = Y.QTY082, X.QTY083 = Y.QTY083, X.QTY084 = Y.QTY084, X.QTY085 = Y.QTY085, X.QTY086 = Y.QTY086, X.QTY087 = Y.QTY087, X.QTY088 = Y.QTY088, X.QTY089 = Y.QTY089, X.QTY090 = Y.QTY090' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY091 = Y.QTY091, X.QTY092 = Y.QTY092, X.QTY093 = Y.QTY093, X.QTY094 = Y.QTY094, X.QTY095 = Y.QTY095, X.QTY096 = Y.QTY096, X.QTY097 = Y.QTY097, X.QTY098 = Y.QTY098, X.QTY099 = Y.QTY099, X.QTY100 = Y.QTY100' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY101 = Y.QTY101, X.QTY102 = Y.QTY102, X.QTY103 = Y.QTY103, X.QTY104 = Y.QTY104, X.QTY105 = Y.QTY105, X.QTY106 = Y.QTY106, X.QTY107 = Y.QTY107, X.QTY108 = Y.QTY108, X.QTY109 = Y.QTY109, X.QTY110 = Y.QTY110' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY111 = Y.QTY111, X.QTY112 = Y.QTY112, X.QTY113 = Y.QTY113, X.QTY114 = Y.QTY114, X.QTY115 = Y.QTY115, X.QTY116 = Y.QTY116, X.QTY117 = Y.QTY117, X.QTY118 = Y.QTY118, X.QTY119 = Y.QTY119, X.QTY120 = Y.QTY120' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY121 = Y.QTY121, X.QTY122 = Y.QTY122, X.QTY123 = Y.QTY123, X.QTY124 = Y.QTY124, X.QTY125 = Y.QTY125, X.QTY126 = Y.QTY126, X.QTY127 = Y.QTY127, X.QTY128 = Y.QTY128, X.QTY129 = Y.QTY129, X.QTY130 = Y.QTY130' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY131 = Y.QTY131, X.QTY132 = Y.QTY132, X.QTY133 = Y.QTY133, X.QTY134 = Y.QTY134, X.QTY135 = Y.QTY135, X.QTY136 = Y.QTY136, X.QTY137 = Y.QTY137, X.QTY138 = Y.QTY138, X.QTY139 = Y.QTY139, X.QTY140 = Y.QTY140' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY141 = Y.QTY141, X.QTY142 = Y.QTY142, X.QTY143 = Y.QTY143, X.QTY144 = Y.QTY144, X.QTY145 = Y.QTY145, X.QTY146 = Y.QTY146, X.QTY147 = Y.QTY147, X.QTY148 = Y.QTY148, X.QTY149 = Y.QTY149, X.QTY150 = Y.QTY150' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY151 = Y.QTY151, X.QTY152 = Y.QTY152, X.QTY153 = Y.QTY153, X.QTY154 = Y.QTY154, X.QTY155 = Y.QTY155, X.QTY156 = Y.QTY156, X.QTY157 = Y.QTY157, X.QTY158 = Y.QTY158, X.QTY159 = Y.QTY159, X.QTY160 = Y.QTY160' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY161 = Y.QTY161, X.QTY162 = Y.QTY162, X.QTY163 = Y.QTY163, X.QTY164 = Y.QTY164, X.QTY165 = Y.QTY165, X.QTY166 = Y.QTY166, X.QTY167 = Y.QTY167, X.QTY168 = Y.QTY168, X.QTY169 = Y.QTY169, X.QTY170 = Y.QTY170' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY171 = Y.QTY171, X.QTY172 = Y.QTY172, X.QTY173 = Y.QTY173, X.QTY174 = Y.QTY174, X.QTY175 = Y.QTY175, X.QTY176 = Y.QTY176, X.QTY177 = Y.QTY177, X.QTY178 = Y.QTY178, X.QTY179 = Y.QTY179, X.QTY180 = Y.QTY180' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY181 = Y.QTY181, X.QTY182 = Y.QTY182, X.QTY183 = Y.QTY183, X.QTY184 = Y.QTY184, X.QTY185 = Y.QTY185, X.QTY186 = Y.QTY186, X.QTY187 = Y.QTY187, X.QTY188 = Y.QTY188, X.QTY189 = Y.QTY189, X.QTY190 = Y.QTY190' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY191 = Y.QTY191, X.QTY192 = Y.QTY192, X.QTY193 = Y.QTY193, X.QTY194 = Y.QTY194, X.QTY195 = Y.QTY195, X.QTY196 = Y.QTY196, X.QTY197 = Y.QTY197, X.QTY198 = Y.QTY198, X.QTY199 = Y.QTY199, X.QTY200 = Y.QTY200' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY201 = Y.QTY201, X.QTY202 = Y.QTY202, X.QTY203 = Y.QTY203, X.QTY204 = Y.QTY204, X.QTY205 = Y.QTY205, X.QTY206 = Y.QTY206, X.QTY207 = Y.QTY207, X.QTY208 = Y.QTY208, X.QTY209 = Y.QTY209, X.QTY210 = Y.QTY210' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY211 = Y.QTY211, X.QTY212 = Y.QTY212, X.QTY213 = Y.QTY213, X.QTY214 = Y.QTY214, X.QTY215 = Y.QTY215, X.QTY216 = Y.QTY216, X.QTY217 = Y.QTY217, X.QTY218 = Y.QTY218, X.QTY219 = Y.QTY219, X.QTY220 = Y.QTY220' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY221 = Y.QTY221, X.QTY222 = Y.QTY222, X.QTY223 = Y.QTY223, X.QTY224 = Y.QTY224, X.QTY225 = Y.QTY225, X.QTY226 = Y.QTY226, X.QTY227 = Y.QTY227, X.QTY228 = Y.QTY228, X.QTY229 = Y.QTY229, X.QTY230 = Y.QTY230' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY231 = Y.QTY231, X.QTY232 = Y.QTY232, X.QTY233 = Y.QTY233, X.QTY234 = Y.QTY234, X.QTY235 = Y.QTY235, X.QTY236 = Y.QTY236, X.QTY237 = Y.QTY237, X.QTY238 = Y.QTY238, X.QTY239 = Y.QTY239, X.QTY240 = Y.QTY240' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY241 = Y.QTY241, X.QTY242 = Y.QTY242, X.QTY243 = Y.QTY243, X.QTY244 = Y.QTY244, X.QTY245 = Y.QTY245, X.QTY246 = Y.QTY246, X.QTY247 = Y.QTY247, X.QTY248 = Y.QTY248, X.QTY249 = Y.QTY249, X.QTY250 = Y.QTY250' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY251 = Y.QTY251, X.QTY252 = Y.QTY252, X.QTY253 = Y.QTY253, X.QTY254 = Y.QTY254, X.QTY255 = Y.QTY255, X.QTY256 = Y.QTY256, X.QTY257 = Y.QTY257, X.QTY258 = Y.QTY258, X.QTY259 = Y.QTY259, X.QTY260 = Y.QTY260' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY261 = Y.QTY261, X.QTY262 = Y.QTY262, X.QTY263 = Y.QTY263, X.QTY264 = Y.QTY264, X.QTY265 = Y.QTY265, X.QTY266 = Y.QTY266, X.QTY267 = Y.QTY267, X.QTY268 = Y.QTY268, X.QTY269 = Y.QTY269, X.QTY270 = Y.QTY270' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY271 = Y.QTY271, X.QTY272 = Y.QTY272, X.QTY273 = Y.QTY273, X.QTY274 = Y.QTY274, X.QTY275 = Y.QTY275, X.QTY276 = Y.QTY276, X.QTY277 = Y.QTY277, X.QTY278 = Y.QTY278, X.QTY279 = Y.QTY279, X.QTY280 = Y.QTY280' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY281 = Y.QTY281, X.QTY282 = Y.QTY282, X.QTY283 = Y.QTY283, X.QTY284 = Y.QTY284, X.QTY285 = Y.QTY285, X.QTY286 = Y.QTY286, X.QTY287 = Y.QTY287, X.QTY288 = Y.QTY288, X.QTY289 = Y.QTY289, X.QTY290 = Y.QTY290' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY291 = Y.QTY291, X.QTY292 = Y.QTY292, X.QTY293 = Y.QTY293, X.QTY294 = Y.QTY294, X.QTY295 = Y.QTY295, X.QTY296 = Y.QTY296, X.QTY297 = Y.QTY297, X.QTY298 = Y.QTY298, X.QTY299 = Y.QTY299, X.QTY300 = Y.QTY300' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY301 = Y.QTY301, X.QTY302 = Y.QTY302, X.QTY303 = Y.QTY303, X.QTY304 = Y.QTY304, X.QTY305 = Y.QTY305, X.QTY306 = Y.QTY306, X.QTY307 = Y.QTY307, X.QTY308 = Y.QTY308, X.QTY309 = Y.QTY309, X.QTY310 = Y.QTY310' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY311 = Y.QTY311, X.QTY312 = Y.QTY312, X.QTY313 = Y.QTY313, X.QTY314 = Y.QTY314, X.QTY315 = Y.QTY315, X.QTY316 = Y.QTY316, X.QTY317 = Y.QTY317, X.QTY318 = Y.QTY318, X.QTY319 = Y.QTY319, X.QTY320 = Y.QTY320' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY321 = Y.QTY321, X.QTY322 = Y.QTY322, X.QTY323 = Y.QTY323, X.QTY324 = Y.QTY324, X.QTY325 = Y.QTY325, X.QTY326 = Y.QTY326, X.QTY327 = Y.QTY327, X.QTY328 = Y.QTY328, X.QTY329 = Y.QTY329, X.QTY330 = Y.QTY330' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY331 = Y.QTY331, X.QTY332 = Y.QTY332, X.QTY333 = Y.QTY333, X.QTY334 = Y.QTY334, X.QTY335 = Y.QTY335, X.QTY336 = Y.QTY336, X.QTY337 = Y.QTY337, X.QTY338 = Y.QTY338, X.QTY339 = Y.QTY339, X.QTY340 = Y.QTY340' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY341 = Y.QTY341, X.QTY342 = Y.QTY342, X.QTY343 = Y.QTY343, X.QTY344 = Y.QTY344, X.QTY345 = Y.QTY345, X.QTY346 = Y.QTY346, X.QTY347 = Y.QTY347, X.QTY348 = Y.QTY348, X.QTY349 = Y.QTY349, X.QTY350 = Y.QTY350' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY351 = Y.QTY351, X.QTY352 = Y.QTY352, X.QTY353 = Y.QTY353, X.QTY354 = Y.QTY354, X.QTY355 = Y.QTY355, X.QTY356 = Y.QTY356, X.QTY357 = Y.QTY357, X.QTY358 = Y.QTY358, X.QTY359 = Y.QTY359, X.QTY360 = Y.QTY360' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.QTY361 = Y.QTY361, X.QTY362 = Y.QTY362, X.QTY363 = Y.QTY363, X.QTY364 = Y.QTY364' || CHR(10);
              V_MEXEC := V_MEXEC || '       ,X.LAST_UPDATED_BY = ''' || V_P_USER_ID || ''',' || CHR(10);
              V_MEXEC := V_MEXEC || '        X.LAST_UPDATE_DATE = SYSDATE ' || CHR(10);

              EXECUTE IMMEDIATE V_MEXEC;

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

            /* ------------------------------------------------------------------------------------------- */
            /*   WEEK SUM PIVOT 생성 후 UPDATE */
            /* ------------------------------------------------------------------------------------------- */
              /*  IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL DROP TABLE #LineLoad_WEEK */
              DELETE FROM GT_XPGT_LINELOAD_WEEK;

                INSERT INTO GT_XPGT_LINELOAD_WEEK
                     ( DIVISION_ID
                     , SITE_ID
                     , OPERATION_ID
                     , PROD_LINE
                     , MEASURE
                     , WQTY
                     , ISO_YYYYWW
                     , WEEK_COLUMN )
                SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID  AS SITE_ID
                     , A.OPERATION_ID
                     , A.LINE_ID AS PROD_LINE
                     , A.MEASURE
                     , CASE WHEN SUM(A.WORKING_TIME) <= 0.0 THEN 0
                            ELSE NVL((ROUND(SUM(A.CAPA_TACT), 0) / SUM(A.WORKING_TIME)), 0) * 100
                       END AS WQTY
                     , A.ISO_YYYYWW
                     , A.WEEK_COLUMN
                  FROM GT_XPGT_LINELOAD A
                 GROUP BY A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , A.MEASURE
                     , A.ISO_YYYYWW
                     , A.WEEK_COLUMN
                     ;

                /*  IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL DROP TABLE #LineLoad_WEEK_PIVOT */
                DELETE FROM GT_XPGT_LINELOAD_WEEK_PIVOT;

                  INSERT INTO GT_XPGT_LINELOAD_WEEK_PIVOT
                  SELECT *
                    FROM ( SELECT DIVISION_ID, SITE_ID, OPERATION_ID, PROD_LINE, MEASURE, WQTY, WEEK_COLUMN
                             FROM GT_XPGT_LINELOAD_WEEK
                         )
                   PIVOT ( MIN(WQTY)
                           FOR WEEK_COLUMN IN ( 'WQTY01' AS WQTY01, 'WQTY02' AS WQTY02, 'WQTY03' AS WQTY03, 'WQTY04' AS WQTY04, 'WQTY05' AS WQTY05, 'WQTY06' AS WQTY06, 'WQTY07' AS WQTY07, 'WQTY08' AS WQTY08, 'WQTY09' AS WQTY09, 'WQTY10' AS WQTY10
                                              , 'WQTY11' AS WQTY11, 'WQTY12' AS WQTY12, 'WQTY13' AS WQTY13, 'WQTY14' AS WQTY14, 'WQTY15' AS WQTY15, 'WQTY16' AS WQTY16, 'WQTY17' AS WQTY17, 'WQTY18' AS WQTY18, 'WQTY19' AS WQTY19, 'WQTY20' AS WQTY20
                                              , 'WQTY21' AS WQTY21, 'WQTY22' AS WQTY22, 'WQTY23' AS WQTY23, 'WQTY24' AS WQTY24, 'WQTY25' AS WQTY25, 'WQTY26' AS WQTY26, 'WQTY27' AS WQTY27, 'WQTY28' AS WQTY28, 'WQTY29' AS WQTY29, 'WQTY30' AS WQTY30
                                              , 'WQTY31' AS WQTY31, 'WQTY32' AS WQTY32, 'WQTY33' AS WQTY33, 'WQTY34' AS WQTY34, 'WQTY35' AS WQTY35, 'WQTY36' AS WQTY36, 'WQTY37' AS WQTY37, 'WQTY38' AS WQTY38, 'WQTY39' AS WQTY39, 'WQTY40' AS WQTY40
                                              , 'WQTY41' AS WQTY41, 'WQTY42' AS WQTY42, 'WQTY43' AS WQTY43, 'WQTY44' AS WQTY44, 'WQTY45' AS WQTY45, 'WQTY46' AS WQTY46, 'WQTY47' AS WQTY47, 'WQTY48' AS WQTY48, 'WQTY49' AS WQTY49, 'WQTY50' AS WQTY50
                                              , 'WQTY51' AS WQTY51, 'WQTY52' AS WQTY52
                                              )
                         )
                       ;

                /*  MSSQL UPDATE X SET .. FROM SCP_XLS_PSI_GLOBAL_ESS X INNER JOIN #LineLoad_WEEK_PIVOT Y ON ..
                    -> 조인키에 MEASURE 가 없어 원천 다중매치가 가능하므로 상관 UPDATE + EXISTS + ROWNUM = 1 (CV-024) */
                UPDATE SCP_XLS_PSI_GLOBAL_ESS X
                   SET ( WQTY01, WQTY02, WQTY03, WQTY04, WQTY05
                       , WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                       , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15
                       , WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                       , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25
                       , WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                       , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35
                       , WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                       , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45
                       , WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                       , WQTY51, WQTY52 ) =
                       ( SELECT Y.WQTY01, Y.WQTY02, Y.WQTY03, Y.WQTY04, Y.WQTY05
                              , Y.WQTY06, Y.WQTY07, Y.WQTY08, Y.WQTY09, Y.WQTY10
                              , Y.WQTY11, Y.WQTY12, Y.WQTY13, Y.WQTY14, Y.WQTY15
                              , Y.WQTY16, Y.WQTY17, Y.WQTY18, Y.WQTY19, Y.WQTY20
                              , Y.WQTY21, Y.WQTY22, Y.WQTY23, Y.WQTY24, Y.WQTY25
                              , Y.WQTY26, Y.WQTY27, Y.WQTY28, Y.WQTY29, Y.WQTY30
                              , Y.WQTY31, Y.WQTY32, Y.WQTY33, Y.WQTY34, Y.WQTY35
                              , Y.WQTY36, Y.WQTY37, Y.WQTY38, Y.WQTY39, Y.WQTY40
                              , Y.WQTY41, Y.WQTY42, Y.WQTY43, Y.WQTY44, Y.WQTY45
                              , Y.WQTY46, Y.WQTY47, Y.WQTY48, Y.WQTY49, Y.WQTY50
                              , Y.WQTY51, Y.WQTY52
                           FROM GT_XPGT_LINELOAD_WEEK_PIVOT Y
                          WHERE Y.PROD_LINE    = X.PROD_LINE
                            AND X.DIVISION_ID  = Y.DIVISION_ID
                            AND X.FROM_SITE    = Y.SITE_ID
                            AND X.ATTRIBUTE9   = Y.OPERATION_ID
                            AND ROWNUM         = 1 )
                 WHERE X.MEASURE IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD')
                   AND EXISTS ( SELECT 1
                                  FROM GT_XPGT_LINELOAD_WEEK_PIVOT Y
                                 WHERE Y.PROD_LINE    = X.PROD_LINE
                                   AND X.DIVISION_ID  = Y.DIVISION_ID
                                   AND X.FROM_SITE    = Y.SITE_ID
                                   AND X.ATTRIBUTE9   = Y.OPERATION_ID );

              END IF;

              END IF;   /*  IF @p_measure <> 'CELL_CHAR_PLAN' */

        /* --------------------------------------------------------- */
        /*  실행 Logic END -- */
        /* --------------------------------------------------------- */


        /*  TXN LOG */
        V_LOG_TYPE     := 'TXN';    /* 로그타입 */
        N_LOG_COUNT    := SQL%ROWCOUNT;
        V_LOG_MESSAGE  := 'INSERT INTO ' || V_TABLE_ID;
        /*  MSSQL CONVERT(CHAR(23), @d_event_date, 121) = 'YYYY-MM-DD HH:MI:SS.mmm'. */
        V_DESCRIPTION  := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYY-MM-DD HH24:MI:SS');
        D_EVENT_DATE   := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER
                            );

      END;

    EXCEPTION
      WHEN OTHERS THEN

        /*           IF @@TRANCOUNT > 0
             BEGIN
               ROLLBACK;
             END; */

        /*  ERROR LOG */
        V_LOG_TYPE     := 'ERROR';
        V_LOG_MESSAGE  := SUBSTR(SQLERRM, 1, 1000);

        V_DESCRIPTION  := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
        D_EVENT_DATE   := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                            , P_LOG_TYPE      => V_LOG_TYPE
                            , P_LOG_COUNT     => N_LOG_COUNT
                            , P_LOG_MESSAGE   => V_LOG_MESSAGE
                            , P_DESCRIPTION   => V_DESCRIPTION
                            , P_EVENT_DATE    => D_EVENT_DATE
                            , P_USER_ID       => V_BATCH_USER
                            );
        /* MSSQL: return -1 */
        RAISE_APPLICATION_ERROR(-20001, SUBSTR(SQLCODE || SQLERRM || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 2000));
    END;

    /*  임시 운영반영시에 주석처리 할것. */


    V_EXEC_TIME  :=  LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0') || ':' ||
                     LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

    /*  종료 LOG */
    V_LOG_TYPE     := 'END';
    V_LOG_MESSAGE  := '########## END of procedure ##########';

    V_DESCRIPTION  := CASE WHEN P_DIVISION_ID IS NULL OR P_PLAN_START_YYYYMMDD IS NULL
                             OR P_MEASURE IS NULL OR P_XLS_KEY1 IS NULL OR V_EXEC_TIME IS NULL
                           THEN NULL
                           ELSE '[' || P_DIVISION_ID || '][' || P_PLAN_START_YYYYMMDD || '][' || P_MEASURE
                                || '][' || P_XLS_KEY1 || '][' || V_EXEC_TIME || ']'
                      END;
    D_EVENT_DATE   := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                        , P_LOG_TYPE      => V_LOG_TYPE
                        , P_LOG_COUNT     => N_LOG_COUNT
                        , P_LOG_MESSAGE   => V_LOG_MESSAGE
                        , P_DESCRIPTION   => V_DESCRIPTION
                        , P_EVENT_DATE    => D_EVENT_DATE
                        , P_USER_ID       => V_BATCH_USER
                        );
    RETURN;   /*  MSSQL: return 1 (Oracle 프로시저는 반환값이 없다. 호출자 0건 확인 - LS-023/CV-053 로 OUT 미추가) */

END;