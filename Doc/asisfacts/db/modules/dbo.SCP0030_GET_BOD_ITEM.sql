
/*
 * Program ID   : SCP0030_GET_BOD_ITEM
 * Description  : BOD ITEM 조회
 * Program History
 *===================================================================================================
 * Date         In Charge                 Description
 *===================================================================================================
 * 2018/09/07   ygkim                     Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/23    hwyoon                   SAFETY_STOCK 추가
 * 2021/06/10   khj79                     [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 2단계 개발(From , To 를 bod에서 관리)
 * 2021/07/14   KMJ                       [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - UI 속도 개선
 * 2023/06/29   vadabi3                   [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - ACTIVE_FLAG = N 은 조회 대상 제외
 * 2023/06/29   vadabi3                   [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - ACTIVE_FLAG = N Material 조건 적용
 * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 * 2024/01/15   chaan           V1.1.1    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회대상 제외 로직 수정(하나라도 ACTIVE_FLAG = N 이면 제외 => 전체가 N 이면 제외로 변경)
 * 2024-01-19   chaan           V1.1.2    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
 * 2025-04-07   kimcd                     PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - LEAD TIME 조회 안 되어서 SCP_MST_BOD_V를 SCP_MST_BOD_N_V 로 변경
 *===================================================================================================
* ex) EXEC SCP0030_GET_BOD_ITEM @p_division_id = '40', @p_from_site = '', @p_to_site = '', @p_incoterms = '', @p_trans_mode = ''
                 ,@p_item_id = '', @p_nick_name = '', @p_valid = ''

 */
CREATE PROCEDURE [dbo].[SCP0030_GET_BOD_ITEM]
--CREATE PROCEDURE [dbo].[SCP0030_GET_BOD_ITEM]
	  @p_division_id		NVARCHAR(MAX)
	, @p_from_site			NVARCHAR(MAX)
	, @p_to_site			NVARCHAR(MAX)
	, @p_incoterms			NVARCHAR(MAX)
	, @p_trans_mode			NVARCHAR(MAX)
	, @p_item_id			NVARCHAR(MAX)
	, @p_nick_name			NVARCHAR(MAX)
	, @p_valid				NVARCHAR(1)
	, @debug_mode			NVARCHAR(1)		= N'F'
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	--DECLARE @p_division_id	NVARCHAR(100)	= N'40,81,81_UC,81_HM,82';
	--DECLARE @p_from_site    NVARCHAR(MAX)   = N'3050-E,A002_40-W,A010-A,A011-E,CN000998_40-P,CN002685_40-P,KR008147_40-P,KR009120_40-P,KR023815_40-P,KR024953_40-P,TW000023_40-P,VN000493_40-P,G183-E,IN003426_40-P,KR000197_40-P,KR001641_40-E,KR004004_40-A,KR005304_40-P,CN003256_40-A,CN007289_40-P,F030-A,F031-E,G182-A,G182-P,A002-W,A040-A,A040-P,A041-E,F040-P,G382_81-W,G631-A,G631-P,G632-E,G691_81-W,KR013131_81-P,G451-P,G452-E,G481_81-W,G481-A,G481-P,G482-E,G382-A,G382-P,G383-E,G388_81-W,G388-P,G451-A,G741-A,G742-E,G671-A,G672-E,G673-A,G674-E,A002_82-W,A050-A,CN003035-P,G184_82-W,G184-A,G634-A,G691_82-W,KR008147-P,KR012031-P,KR32625300_82-P';
	--DECLARE @p_to_site		NVARCHAR(MAX)	= N'G690,G891,3050-E,A002_40-W,A010-A,A011-E,CN000998_40-P,CN002685_40-P,CN003256_40-A,CN007289_40-P,F030-A,F031-E,G182-A,G182-P,G183-E,IN003426_40-P,KR000197_40-P,KR001641_40-E,KR004004_40-A,KR005304_40-P,KR008147_40-P,KR009120_40-P,KR023815_40-P,KR024953_40-P,TW000023_40-P,VN000493_40-P,ABS_US_LRP,Acell Electronic_TW_NTC,Acell_TW_NTC,Acer BC_TW_TPE,acer_CN_CKG,acer_CN_KUS,acer_HK_HKG,acer_TW_NTC,Acme_IN_HAR,Acme_IN_RUD,Aeon Motor_TW_TNN,Aigo_CN_BJS,Airbus_FR_SCY,Airtek_CN_SZX,Airwheel_CN_CZX,Akasol Inc_US_HZP,Akasol_DE_DAR,Akku_DE_SDF,Alelion_SE_GOT,All Good Energy_HK_HKG,All Good Energy_TW_TYN,AllCell_US_CHI,Alta Motors_US_BSA,Alte_KR_SEL,Amara Raja Batteries_IN_TIR,Amazon Robotics_US_NRG,Amazon_US_SEA,Ambrane_IN_HAR,Ambrane_IN_ICD,Ample_US_SFO,Ananda_CN_SHA,Ananda_CN_WUX,Anrui_CN_SZH,Ansmann_CN_HUI,Ansmann_DE_ASA,Ansmann_HK_HKG,Aoxiang_CN_SZX,Apack Tech_TW_NTC,Apex_TW_TXG,Arb Accessories_IN_ICD,Arcimoto_US_EUG,Ari Tech_KR_ANY,Arima_CN_WJA,Arrival_GB_OXF,Arrival_GB_ZDO,Arrival_LT_NMS,Arrival_LT_VNO,Arrival_NL_AMS,Arrival_US_AAZ,Arrival_US_CXR,Askoll_IT_DUV,Asus_CH_BE1,Asus_CN_CKG,Asus_TW_TPE,ATA Industrial_MY_JHB,Atemitech_CN_KUS,Atemitech_TW_TYN,Atex_IT_SVT,Ather Energy_IN_BLR,B&S_CN_SHA,B&S_US_XOH,B2B_US_JMH,Bafang_CN_SZH,BAIC_CN_BJS,Baicheng_CN_PDG,Baicheng_CN_SHA,Bajaj Auto_IN_NSA,BakNew Power_CN_SUH,Banglilai_CN_SZX,Banglilai_HK_HKG,Bikebank_KR_TAE,Biostar_TW_TPE,Bissell_HK_HKG,Bitland_CN_HFE,BK Energy_HK_HKG,Bluebird_CN_DGG,Bluebird_CN_DNN,Blueway Energy_CN_HUI,BMC_CN_BJS,Bmspow Deyi_CN_SZX,Bmspow Dianzi_CN_SZX,Bmspow_CN_SZX,Bmspow_HK_HKG,Bmspow_TW_TPE,BMSPOW1_CN_SZX,BMSPro_CN_SZX,BMW_DE_MUC,BMZ_CN_SZX,BMZ_DE_KSN,BMZ_HK_HKG,BMZ_HK_HKN,BMZ_JP_MST,BMZ_PL_GWC,BMZ_US_VAB,BMZ-1_US_VAB,Bollinger_US_ALB,Bonsung_CN_NJG,Bonsung_KR_SUO,BorgWarner Akasol_DE_DAR,Bosch Mcp_CN_SHA,Bosch Mcp_DE_BRE,Bosch Mcp_HU_MCQ,Bosch Mcp_PL_QLC,Bosch PgP_MY_BLE,Boston Dynamics_US_WLM,Brisk EV_IN_HYD,BRP_CA_QUE,BYD Electronics_CN_WUH,BYD Group_CN_SZX,BYD_CN_SZX,C&T Asia_CN_CZX,C&T Asia_HK_HKG,Caban_US_BGI,Canoo_US_TOA,Cell Plus_KR_SGM,Celxpert_CN_KUS,Celxpert_TW_TYN,CEM S.P.A_IT_QUO,Changan_CN_CKG,ChangHuiYuan_CN_SZX,Charmlink_CN_DGG,CHC_CN_SUZ,Chehejia_CN_CZX,Chennuo_CN_SZH,Chervon_CN_NJG,Chery_CN_WHI,Chezhiyi_CN_SZX,China Effort_CN_SZX,China Effort_HK_HKG,Chuangdian_CN_DGG,Chunju_CN_SUZ,Comlink_TW_TYN,Compal Elec_CN_KUS,Compal Elec_TW_TPE,Compal Wireless_CN_NJG,Compal_CN_KUS,Compal_TW_TYN,Continental_CZ_BNL,Continental_DE_SC1,Continental_MX_AGU,Continental_MX_NOG,Continental_US_MNC,Coppercell_CN_DGG,Coppercell_TW_TPE,Corun_CN_LHW,Corun_CN_SZX,CS Enertech_KR_OSN,C-Tech_CN_CKG,C-Tech_CN_YGC,C-Tech_TW_TPE,Cummins_GB_MIK,Curo_KR_USN,Cyoshin_CN_SZX,D.Throne_KR_BCN,Daechang Motors_KR_CHU,Daedong Mobility_KR_DSG,DAFTRUCKS N.V._NL_EIN,Damon Motors_CA_VAN,Damon Motors_US_PUM,Darfon Energy_CN_SZH,Darfon Energy_TW_TYN,Darfon_01_CN_SUZ,Darfon_CN_SUZ,Darfon_TW_TYN,Dayi_CN_KUS,DBK_CN_JFZ,DBK_CN_SZX,DBK_HK_HKG,Debao_CN_SZX,Debo_CN_SZH,Delingxun_CN_CZX,Dell_BR_HTL,Dell_CN_CTU,Dell_CN_KUS,Dell_CN_XMN,Dell_IN_BLR,Dell_IN_SRP,Dell_MY_NTL,Dell_NL_HRK,Dell_NL_TLB,Dell_SG_SIN,Dell_US_HOU,Dell_US_LBN,Dell_US_MJB,Dell_US_UQT,Dell_VN_HAN,Desay_CN_HUI,Desay_CN_XIY,Dexun_CN_SZX,DLG_CN_FGH,DLG_CN_HGH,DLG_CN_SHA,DLG1_CN_JNG,DLG1_CN_SHA,Dongcheng_CN_QDG,Dongcheng_CN_SHA,DongHwa ES_VN_HDG,Donlim_CN_FOS,Doosan_KR_INC,Dreame_CN_SZH,DRN_CN_DGG,DRN_CN_DNN,Dualtron_CN_JHA,Dynabook Hangzhou_CN_HZO,Dynapack_CN_SUZ,Dynapack_CN_WJA,Dynapack_TW_TYN,Dynavolt_CN_SWA,Dynavolt_CN_ZZU,Dyson_GB_MMB,Dyson_MY_JHB,Dyson_PH_NGT,E3 Mobility_KR_SEL,Ecocoach_CH_BRU,Ecocoach_CH_SCZ,Ecovacs _CN_SND,Ecovacs _CN_SUZ,Ecovacs _CN_SZH,Edison Tech_KR_TJN,Eicher Motors_IN_MAA,E-jens_KR_UWN,Electrochem_CN_SHA,Electrolux_HU_JAS,Electrum_ID_JUT,Elentec_CN_AOY,Elentec_CN_SHF,Elentec_CN_TSN,Elentec_KR_HWS,Elentec_MY_KSL,Elentec_VN_HAN,eleo_tech_NL_HLM,Elite Electronic_CN_SZX,Elite Electronic_CN_YCG,Elring Klinger AG_DE_DTG,EM Tech_KR_CHW,EM Tech_VN_BNH,EMI_FR_BKR,Enervision_CN_SZX,Enervision_US_SJC,ENU Systems_HK_HKG,ENU Systems_KR_SEL,EPI_CN_GUA,EPI_IN_NDA,EPI_VN_HAN,EPlus_TW_TPE,E-tess_KR_ANY,Etica_TW_NTC,EVC_CZ_HUL,EVE_CN_HUI,Evolute Solutions_IN_BOM,Evva_HK_HKG,Exicom_CN_SHA,Fabricators_CN_QIN,Fabricators_HK_HKG,Fabricators_MY_SEI,Fabricators_US_WOQ,Facebook_DE_BER,Facebook_PH_STR,Facebook_SI_LJU,Facebook_TW_TPE,Facebook_US_ABQ,Facebook_US_AKE,Facebook_US_BNM,Facebook_US_CLT,Facebook_US_DAL,Facebook_US_IOX,Facebook_US_MKU,Facebook_US_PDX,Facebook_US_QWB,Fangde_CN_SHA,Faraday&Future_US_CPM,Faraday&Future_US_GAC,Fengxi_CN_SZX,Fengxi_CN_TSN,FEY_DE_HAM,Fisker_US_TOA,Flex Ltd._CN_ZUH,Flex Ltd._HK_HKG,Flex Ltd._MY_PGU,Flex Ltd._SG_SIN,Flextronics_CN_SYN,Flextronics_CN_TSN,Flextronics_HK_HKG,Flextronics_HU_ZER,Flextronics_MY_JHB,Formosa_CN_KUS,Formosa_TW_TPE,Forsee_CN_ZGA,Forsee_CN_ZSN,Forsee_FR_PAR,Forsee_FR_SCN,Forsee_HK_HKG,Foxconn_CN_TSN,Foxconn_CN_YNT,Foxconn_TW_TPE,Foxlink_CN_DGG,Foxlink_CN_KUS,Foxlink_TW_TPE,FSP_TW_TYN,Fuhrmeister_JP_CAU,Fuji_CN_SZX,Fuji_HK_HKG,Fushida_CN_SZX,Futurepath_CN_DGG,Ganfeng Dianzi_CN_SIY,Ganfeng Jiangxi_CN_SIY,Ganfeng_CN_DGG,Ganfeng_HZ_CN_HUI,GETAC_CN_KUS,GETAC_HK_HKG,GETAC_TW_HSZ,Giken Sakata_ID_BTM,Giken Sakata_SG_SIN,Gims_CA_BTA,Gims_JP_TYO,Gims_KR_CHF,Gims_KR_HWS,Gims_KR_INC,Gims_KR_PUS,Gims_KR_SEL,Gims_KR_TAE,Gims_KR_TJN,Gims_KR_UWN,Global Powersource_IN_MUB,Globetools_CN_CZX,Globetools_VN_HAP,GLW_01_CN_KUS,GLW_CN_KUS,GLW_CN_SHA,GLW_HK_HKG,GLW_TW_TPE,GM_US_DET,Goertek Inc._CN_WFG,Goertek Inc._VN_BNH,Gogoro_TW_TYN,Gooda_TW_TPE,Google_NL_AMS,Google_SG_SIN,Google_US_FBN,Google_US_NUQ,Google_US_UCG,Great Power_CN_SZX,Great Power_HK_HKG,Great Power_TW_NTC,Great Power1_CN_SZX,Green Battery_US_AUS,Greenfuel Energy_IN_DGA,Greenfuel Energy_SG_SIN,Greenway Dongguan_CN_DGG,Greenway Dongguan_HK_HKG,Greenway_CN_DGG,Greenway_HK_HKG,Greyp_HR_SVN,G-Tech_CN_DGG,GWKC_CN_GUA,GWKC_CN_SZP,Haimao_CN_SZX,Han Win Tech_TW_NTC,HansungWT_KR_PUS,Hanwha Aerospace_KR_CHU,Hanwha Defense_KR_SGM,Hanyu_CN_SUZ,Harley Davidson_US_MKE,Harley Davidson_US_NUQ,Hello Tech_CN_SZX,Henes_KR_HAN,Hero Motocorp_IN_CHT,Hero Motocorp_IN_JAI,Hero Motorcorp_DE_BGH,High Power (Boke)_CN_SZX,High Power (Icon)_CN_SZX,High Power (Icon)_HK_HKG,Hilti_DE_KAG,Hilti_PL_GWC,Hilti_SG_SIN,Hitachi_HK_HKG,HLDS_CN_HUI,HMG_KR_TAE,HMG_UL_KR_USN,Hogstger_CN_CIX,Honda Trading India_IN_HAR,Honda_IN_BLR,Honda_IN_HAR,Honda_JP_STM,Hongfugang_CN_SZX,Hongfugang_HK_KWN,Honhai_CN_HGH,Honhai_HK_YUE,Hope_CN_TAO,HP_CN_CKG,HP_CN_KUS,HP_CN_SZX,HP_DE_BOE,HP_HU_SZY,HP_IN_HSR,HP_IN_RUD,HP_MX_MTM,HP_SG_SIN,HP_TW_TYN,HP_US_TXT,HP1_CN_CKG,HP1_CN_KUS,HP1_CN_SZP,HP1_CZ_PRB,HP1_HU_GYL,HP1_IN_HAR,HP1_NL_BEJ,HP1_SG_SIN,HP1_US_JFV,HP1_US_LUI,HP1_US_SAC,HP1_US_XFK,HP2_CN_CKG,HP2_CN_KUS,HP2_SG_SIN,HP2_US_LUI,HP2_US_SAC,HP2_US_XFK,HP3_CN_CKG,HP3_CN_KUS,HP4_CN_CKG,HP5_CN_CKG,HP6_CN_CKG,HTE_TW_TPE,Huachuangli_CN_SZH,Huagreen_CN_SZX,Huapu_CN_CGU,Huaqin Telecom_CN_DNN,Huilai_CN_SZX,Hyosung_KR_ANY,Hyundai Motor Lab_KR_HWS,IBS_FR_BKR,Igreatpower_CN_SZH,IM_CN_KUS,IM_CN_NGG,IM_DE_BBG,IM_DE_BER,IM_DE_PRU,IM_SH_CN_KUS,IM_US_PAO,IM_US_SPK,IM_US_TXT,Impossible Aero_US_SJC,IM-Re_CN_NGG,Ingeniarts_CA_QUE,Ingeniarts_US_CHI,Initra_SI_LJU,Innotech_CN_BHY,Innotech_CN_KHN,InnoTM_KR_TJN,InnoTM_US_NUQ,Innov_CN_SUZ,Innov_CN_SZH,Intilion_CN_LIY,Intilion_DE_ZWI,Intretech_CN_XMN,Inventec_CN_SHA,Inventec_TW_TPE,Inventus Power_BR_MAO,Inventus Power_CN_SHA,Inventus Power_HK_HKG,Inventus Power_MY_SEI,Inventus Power_US_SAN,Inventus Power_US_WOQ,Invox_CN_NKG,iRobot_CN_SZX,Isuzu_JP_TYO,Isuzu_KR_OCH,ITM_KR_CHU,ITM_VN_BNH,J Starcom_KR_SEL,Jan Hui Power_CN_SZX,Jan Hui Power_TW_NTC,Jetech_CN_HUI,Jetech_CN_SZX,Jiade_CN_ZUH,Jiaxin_CN_BHY,Jiaxin_CN_SZX,Jiedian_CN_SZX,Jinding_CN_CZX,Jinkang_CN_CKG,Jinle_CN_DGG,Jinle_CN_SZX,Jinle_HK_HKG,Jinle_HK_HKN,Jinle_KR_SEL,Jiutong_CN_DGG,Jiuyi_CN_ASN,JJ Solstice_DE_ESC,JJ Solstice_DE_FRA,JJ Solstice_KR_ANY,JJ Solstice_KR_GUN,JLR_GB_CVT,JLR_GB_WGE,JMBS_PL_GWC,JMS_TW_KHH,Jofemar_ES_MCL,Joffe_CN_FOC,John Deere_KR_GCN,John Deere_US_GTS,John Deere_US_MLI,John Deere_US_XZM,Joway_CN_SZX,JS Tech_JP_HIU,Judong LEV_CN_TIZ,Judong_CN_TIZ,Junchang_CN_YBN,Kais_CN_CAN,Kais_CN_SZH,Kais_CN_ZJG,Kawasaki_JP_HY1,Kayo_CN_DGG,Kayo_CN_DNN,Kenmec_TW_TPE,Keyway_CN_SZH,Kingclean CNY_CN_SUZ,Kingclean_CN_SUZ,Kingclean_CN_SZH,Kingin_CN_DGG,Kingsmile_CN_SZX,Kinpo Electronics_PH_BTG,Kion_DE_KSN,Koland_CN_DGG,Koland_CN_SZX,KR Motors_KR_CHW,Kreisel Elec._AT_RIM,Kreisel Elec._AT_VDD,KRJ_CN_SZX,KRJ_HK_HKG,Kstrong_CN_SZX,Kswheel_CN_SZX,KTM AG_AT_ANF,Kwonnie_CN_DGG,Kwonnie_HK_HKG,Kymco_CN_KUS,Kymco_IT_UBT,Kymco_TW_KHH,Kymco_TW_TPE,Kyocera_JP_FUS,Lanwwei_CN_HUI,Large_CN_DGG,LCFC_CN_HFE,Leineng_CN_FOS,Lenovo MBG_CN_WUH,Lenovo MBG_HK_HKG,Lenovo MBG_US_CHI,Lenovo_CN_CKG,Lenovo_CN_HFE,Lenovo_CN_KUS,Lenovo_CN_SHA,Lenovo_CN_SZX,Lenovo_HK_HKG,LERA_CN_NGB,LGCDJ_KR_TJN,LGCEG_DE_WIN,LGE HE_KR_PTK,LGE MC VMI_KR_PTK,LGE MC_KR_PTK,LGE VC_CN_NKG,LGE VC_KR_PTK,LGE_CN_NJG,LGE_CN_TAO,LGE_CN_YNT,LGE_KR_CHW,LGE_KR_HWS,LGE_KR_PTK,LGE_KR_SEL,LGE_VN_HAP,LGE_VN_VLM,LGI_KR_INC,LGI_KR_SYS,LGI_TW_TPE,Lianghan_CN_KUS,Lichi_CN_DGG,Lika_CN_SZX,Limeng_CN_SZX,Lion Electric_CA_MRB,Lion Electric_CA_QUE,Lion Electric_US_HLM,LIPC_CN_CKG,LIPC_CN_KUS,LIPC_CN_SZP,LIPC_CN_SZX,Lithos Energy_US_SRF,Liwei Tech_CN_TSN,Longood_CN_DGG,Lordstown_MY_KLM,Lordstown_US_WRN,Lucid Motors_US_FNC,Lucid Motors_US_HLM,Lucid Motors_US_NKQ,Lucid Motors_US_OGD,Lucid Motors_US_PAO,Lucid Motors_US_TPE,Luxshare Electronic_CN_KUS,Luxshare Precision_CN_JNX,Luxshare Precision_CN_KUS,Luxshare Precision_VN_BGG,Luxshare Technology_CN_JAN,Mac Beyond_CN_SHA,Mahindra_IN_MUB,Maisui_CN_SHA,Maitrox_CN_KUS,Masstex_HK_HKG,MAX_JP_CHC,MAZDA_JP_AIG,Medion AG_CN_NGB,Medion AG_DE_OBL,Meiko_VN_HAN,Mercedes Benz_DE_SDN,Merry_HK_HKG,Merry_TW_TXG,MG Energy_NL_LWR,Mica_CN_DGG,Micro Powertronics_IN_QSL,Micromax_IN_HAR,Micromax_IN_RUD,Microtronics_MY_JHB,Midea_CN_SZH,Millor Battery_ES_BCN,Mini Battery_CN_JHA,Mini Motors_CN_DGG,Mini Motors_CN_JHA,Mini Motors_CN_SZX,Misum Systech_KR_ANY,Mobiletron_CN_YOU,Mobiletron_TW_TXG,Mombike_CN_CZX,MOR Electric_CN_WHI,MPS Energy_TW_TPE,MPS_TW_NTC,MPS_TW_TPE,MPST_KR_GUN,MS Tablet_US_XLC,Myvelo_KR_SYS,Nanku_CN_SHA,Naverlabs_KR_SGM,Navistar_US_LSA,Near East Univ._CY_NIC,Near East Univ._GB_NSF,Newflyer_CA_WNP,Nexcon_CN_NKG,Nexcon_KR_SUO,Next EV_US_SJC,Nikola Motor_US_SLC,Ninebot Beijing_CN_CZX,Ninebot Changzhou_CN_CZX,Ninebot Changzhou_CN_DNN,Ninebot Changzhou_CN_FOC,Ninebot Changzhou_CN_HUI,Ninebot Changzhou_CN_SAD,Ninebot Changzhou_CN_SZX,Ninebot Changzhou_CN_YBN,Ninebot Shenzhen_CN_SZX,Ninebot Tianjin_CN_DNN,Ninebot Tianjin_CN_SAD,Ninebot Tianjin_CN_TSN,Nintendo_JP_TKX,Noras_PT_LIS,Noritz_CN_SUZ,Novonix_CA_BDF,NT Computer_CN_CGU,NT Computer_IE_ORK,NT Computer_TW_HSZ,NT_CN_CGU,NT_CN_DGG,NT_CN_HUI,NT_CN_SZX,NT_CN_WJA,NT_TW_HSZ,NT_US_CUO,NVT_CN_DGG,NVT_HK_HKG,Oceanwing Anker_CN_CSX,Oceanwing Anker_CN_DGG,Oceanwing Anker_CN_SZX,Oceanwing_CN_CSX,Oceanwing_CN_DGG,Oceanwing_CN_SZX,Oceanwing_VN_BGG,Octillion_CN_HFE,Octillion_US_HWD,Oculus_US_IVN,OLA Electric_IN_BLR,Pana JV_CN_SHA,Panacycle_JP_OSA,Panasonic_JP_TSU,pantrue_CN_SHA,pantrue_CN_XMN,Partron_VN_VYN,Patron_KR_HWS,PCTEST_US_ACW,Pegatron_TW_TPE,Peg-Perego_IT_ARC,Pellenc_CN_DGG,Pellenc_FR_PAR,Penghui_CN_CAN,Peopleworks_KR_KUM,Peopleworks_KR_SEL,Philip Morris_HU_GYL,Philips Bodine_US_CJE,Phylion_CN_SUZ,PN Telecom_KR_ANY,PNE SYSTEMS_KR_SUO,Polaris_US_NMZ,Porta Power_CN_CA0,Porta Power_CN_CAN,Porta Power_CN_SZX,Porta Power_HK_HKG,Portronics_IN_ICD,Positec_CN_SUZ,Power Plaza_KR_SEL,Power7_CN_DGG,Power7_CN_DNN,Powergene_TW_TPE,Powerglobal_US_PSD,Powerlogics_KR_OCH,Powerlogics_VN_VPC,Powertech_TW_TPE,Powtech_CN_DGG,Probest_HK_HKG,Proterra_US_BGI,PT Bluetek_ID_JKT,PT. Garda_ID_SDJ,Pure watercraft_US_SEA,Puyi_CN_MAA,Puyi_CN_SZX,Puyi_CN_UAN,PYTES_CN_SHA,Qisda_CN_SUZ,Quanta_CN_CKG,Reynosa_MX_REX,Reynosa_US_ZMX,Rihuida_CN_SZP,Rihuida_CN_SZX,Rimac Automobili_HR_SVN,Ring_CN_DGG,Ring_CN_SZX,Ring_HK_KWN,Ritwin_TW_NTC,Rivian Automotive_US_IVN,Rivian Automotive_US_LVI,Robostar_KR_SUO,Rockrobo_CN_HUI,Rockrobo_Sunwoda_CN_SZX,Romeo Power_US_CYQ,Romeo Power_US_SMO,Roofer_CN_DGG,Rugged Logic_US_CYL,Ruide_HK_HKG,Ruipu_CN_JYN,Runing Power_CN_SZH,Ryder_CN_SZX,Salcomp PIC_BR_MAO,Salcomp PIC_FI_SAL,Samsung Electronics_BR_CPQ,Samsung Electronics_BR_MAO,Samsung Electronics_KR_KUM,Samsung Electronics_KR_SUO,Samsung Electronics_VN_BNH,Samsung Electronics_VN_TNG,Sanchuang_CN_BHY,SB&D_CN_SZH,SB&D_HK_HKG,SBD_CN_FOS,SBD_CN_NGB,SBD_CN_SHA,SBD_CN_SUZ,SBD_CN_SZH,SBD_CN_SZX,SBD_GB_SPN,SBD_HK_HKG,SBD_HK_HKN,SBD_IN_ICD,SBD_MO_MFM,SBD_US_Z2A,SBS_DE_KTM,SCUD_CN_DGG,SCUD_CN_FOC,SCUD_CN_SZX,SCUD_HK_HKG,SCUD-1_CN_FOC,Scutum_ES_BCN,Sebang _KR_GUN,Sebang _KR_KWJ,SEGL Energy_HK_HKG,SEGL Energy_TW_KEL,SEGL Energy_TW_TPE,Semiroad_KR_PJU,SF Motors_US_MPT,SFT_CN_DGG,SFT_CN_HUI,SFT_CN_LYG,SFT_CN_SUZ,SFT_CN_SZX,Shandong PYTES_CN_SAD,Shangde_CN_DGG,Shark Ninja_CN_HUI,Shark Ninja_US_NDM,Shimano_JP_OSA,Shin-Heung SEC_KR_OSN,Shinko_JP_FKW,Shinko_JP_KGQ,Shin-Sung Delta Tech_KR_CHW,Shinsung_KR_SEL,Shuofang_CN_SZX,Simplo(CN)_CN_CGU,Simplo_CN_CGU,Simplo_CN_CKG,Simplo_TW_HSZ,Singh_HK_HKG,Singh_IN_BLR,Singh_SG_SIN,Sino EV_CN_BJS,Sino EV_CN_HFE,Skio_CN_HGH,Skio_CN_SHA,Skypower_TW_TPE,Skyworth power_CN_XUZ,Smartec_CN_SZX,Soho_CN_NKG,Solution_CN_HUB,Solution_HK_HKG,SOMC_SE_LUD,Sony_CN_SHA,Sony_DE_MUC,Sotech_CN_YIX,SpaceX_US_HHR,SpaceX_US_XLC,Spard_CN_ZGA,Spard_CN_ZSN,Spear Power_US_GVW,SRAM TW_TW_TXG,Stark Future_ES_BCN,Stihl_DE_WAI,STL_TW_KHH,Sumec_CN_NJG,Sunwoda_CN_SZX,Sunwoda_HK_HKG,Sunwoda_India_IN_NDA,Swag_SG_SIN,Tabos_KR_CHO,Taehyong_KR_BCN,Taiba_CN_SIY,Taiding_CN_SZH,Taotao tech_CN_YKG,Taotao_CN_LIS,Tech-com_CN_SHA,Techfront_CN_SHA,Techfront_TW_TYN,Tecyea_CN_DGG,Thinked_CN_SZH,THIX tech_CN_SZX,Thor Trucks_US_NHD,Tianhong_CN_HZH,TIG_CN_SZX,TIH_CN_HGH,TIMI_CN_BJS,Tiveni_DE_BBI,TL Power_CN_SZX,Tocad Donghwa_KR_CHO,Tocad Energy_HK_HKG,Tocad Energy_JP_OOT,Tongfan_CN_SZH,Tonly_HK_ZTW,Topband Battery_CN_SZX,Topband_CN_HUI,Topband_CN_SZX,Topband_HK_HKN,Totex Manufacturing_HK_HKG,Totex Manufacturing_US_TOA,Toyota Tsusho KR_KR_SEL,Toyota_SE_MJB,TP Link_CN_DGG,TP Link_CN_SZX,TQ Systems GmbH_DE_ZIE,Trend Energy_CN_CGU,Trend Energy_TW_HSZ,Trend Power (CN)_CN_CGU,Trend Power (CN)_TW_HSZ,Trend Power Singapore_CN_CGU,Trend Power Singapore_CN_KUS,Trend Power Singapore_TW_HSZ,Trend Power_CN_CGU,Trend Power_TW_HSZ,Triteck_CN_SZX,TTi_2_HK_HKN,TTi_2_US_AND,TTi_HK_HKG,TTi_MO_MFM,TTi_US_AND,Turnlife New Energy_CN_CHZ,Turnlife_CN_CHZ,Turnlife_CN_HGH,Turnlife_CN_SZX,TVS Motor_IN_HSR,Twenty Two Motors_IN_HAR,TWS Liangshi_CN_CA0,TWS Liangshi_CN_SHA,TWS_CN_CA0,TWS_HK_HKG,Tyva-Energie_FR_AOY,Uber Technologies_US_CSL,Uber Technologies_US_SFO,Ultraviolette_IN_MAA,Unicoba_BR_MAO,Univ. of Warwick_GB_CVT,Urim Korea_KR_SEL,Usrich_TW_KEL,Usti_BE_MAC,Usti_CZ_7JK,V.S. Industry_MY_SEI,Vanmoof_HK_WNI,Varta RO_RO_OTP,Varta_CN_SHA,Varta_DE_NON,Varta-2_DE_NON,Veger_CN_SZX,Veken_CN_NGB,Venture_MY_JHB,Venture_SG_SIN,Vestel_TR_IST,Videoton_BG_KAT,Videoton_BG_KVN,Videoton_BG_SZR,Vinfast_VN_HAN,Vinzo_CN_DGG,VL Battery_CN_JNX,VLBP_VN_HAP,Volta_CN_NTG,Volta_US_BUF,Voltabox AG_DE_DEK,Volvo_SE_GOT,Vorwerk_CN_SHA,VS Electronics_MY_SEI,Wacco_KR_TJN,Wacom_JP_KZO,Waitley_CN_SZX,Wandadian_CN_DGG,Wandadian_CN_KUS,Wanghsing_HK_SGS,Wanghsing_TW_KHH,Wanghsing_TW_NTC,Webasto Roof_DE_HGB,Webasto Roof_DE_SKF,Webasto_DE_HGB,Weidian_CN_AOY,Weimu_CN_HGH,Welldone_CN_CZX,Welldone_TW_TPE,Whill_CN_SZH,Whill_JP_YOK,Whill_NL_RTM,Whill_US_BNA,Wingtech_CN_HFE,WINLIFE_ES_BCN,Wistron_CN_CKG,Wistron_CN_KUS,Wistron_TW_NTC,WOOJIN_KR_CJJ,WTE_CN_CZX,WTE_CN_KUS,WTE_TW_TPE,Xiaju_CN_SHA,Xianzhong_CN_TSN,Xiaoniu_CN_CZX,Xiaoniu_CN_DNN,Xiaoniu_CN_HGH,Xiaoniu_CN_SZX,Xiaoniu2_CN_CZX,Xiaopeng_CN_CAN,Xiexun Electronic_CN_JAN,Xing Mobility_TW_TPE,xingte_CN_SZP,xingte_CN_SZX,Xinhe_CN_NGB,Xinpengcheng_CN_GUA,Xinpengcheng_CN_SZX,Xinshili_CN_SZH,XPT Energy_CN_SHA,Yadea_CN_AIN,Yamaha_JP_KGW,Yamaha_JP_SHO,Yashinuo_HK_HKG,YAT_CN_BJI,Yeong Kwang_KR_BCN,Yilink_CN_DGG,Yilink_CN_GAZ,Yinhai_CN_SZX,Yongchang_CN_SZX,Yoobao_CN_DGG,Youlai Power_CN_SZX,YouLead_TW_HSZ,Younth_CN_NGB,Yunzhong_CN_FOC,Zentropy_KR_SGM,Zhongxin_CN_SZX,Zimi_CN_JIA,Zimi_CN_JPU,Zimi_CN_NJG,Zimi_CN_TSN,Zoox_GB_WGE,Zoox_US_FCI,마크원테크놀로지_KR_INC,중국 특화 E-Bike_CN_SHA,중국Mobile_CN_BJS,중국Mobile_CN_HFE,G690,A002-W,A040-A,A040-P,A041-E,F040-P,G382_81-W,G382-A,G382-P,G383-E,G388_81-W,G388-P,G451-A,G451-P,G452-E,G481_81-W,G481-A,G481-P,G482-E,G631-A,G631-P,G632-E,G691_81-W,KR013131_81-P,A002-81-AS,Aeonus_KR_GUN,Arpiem_RO_OTP,ATBS_CN_SHA,ATL_DE_RDG,ATL_GB_POO,audi as_BE_BRU,audi as_DE_KAS,audi as_DE_RSE,audi as_KR_HSO,Audi CKD_DE_ING,Audi_DE_ING,Audi_DE_KAS,Audi_DE_NEM,Audi_DE_SHM,Audi_DE_WOB,Audi_DE_WVN,Audi_GB_CRE,Audi_HU_GYO,Audi_MX_PBC,Audi_PL_WRO,Audi_SK_BTS,AW_DE_LEJ,BAE_US_ENC,Banglilai_CN_SZX,BEDEO_TR_BTS,BMW_AT_GRZ,BMW_AT_SER,BMW_DE_DFG,BMW_DE_ECH,BMW_DE_GBM,BMW_DE_LEJ,BMW_DE_MUC,BMW_DE_NBH,BMW_DE_NTG,BMW_DE_WEO,BMW_DE_WKD,BMW_GB_BSI,BMW_MX_MEX,BMW_US_SPA,China Effort(A)_HK_KWN,Club Car_US_AGS,COENSYS_KR_HWS,Corvus Norway_NO_BGO,Corvus Norway_US_BLI,CS Enertech_KR_OSN,CS Enertech_KR_OSN_KR_OSN,Cummins EP(OTS)_GB_YTH,Cummins(OTS)_US_CLU,Daimler(AS)_DE_BAU,Daimler(AS)_DE_KAZ,Daimler_DE_BAU,Daimler_DE_KAZ,Daimler_JP_HG9,dianchibao_CN_SHA,dianchibao_HK_MUN,DIS_DE_VBS,DSMT_KR_KMH,EDISON MOTORS_KR_TJN,Edisoninno_KR_TJN,Edisoninno_KR_UIJ,EForce(OTS)_CH_BCR,EK_DE_DTG,equipmake(OTS)_GB_NRW,ESS_CN_NKG,ESS_KR_HWS,ESS_KR_OCH,ESS_KR_TJN,FAW VW_CN_CGQ,FAW VW_CN_DLC,FBPS(OTS)_US_ILD,FCA AS_CA_WND,FCA AS_IT_MEI,FCA AS_IT_TRN,FCA AS_PL_WRO,FCA AS_US_SEH,FCA AS_US_WAM,FCA_CA_WND,FCA_IT_MEI,FCA_IT_MOD,FCA_IT_TRN,FCA_KR_JCH,FCA_MX_TLC,FCA_US_2TT,FCA_US_ABH,FCA_US_CMH,FCA_US_ETA,FCA_US_LFC,FCA_US_PHL,FCA_US_SEH,FCA_US_WAM,FLASH_IT_SIZ,Ford AS_DE_CGN,Ford AS_DE_QKL,Ford AS_MX_TPZ,Ford AS_US_DEO,Ford AS_US_RDF,Ford(MX-VMI)_TR_KCO,Ford_BE_ANR,Ford_BE_LML,Ford_DE_QKL,Ford_ES_VLC,Ford_GB_ESX,Ford_MX_CTN,Ford_MX_TPZ,Ford_PL_WRO,Ford_RO_CRV,Ford_TR_DOG,Ford_TR_GOK,Ford_TR_KCO,Ford_US_IGX,Ford_US_RDF,Ford_US_URI,Forsee_FR_MCR,G382-81-AS,G388-81-AS,G481-81-AS,G691-81-AS,GCV_CN_HGH,GEELY_CN_NGB,GM AS_US_BQN,GM AS_US_HZP,GM_CA_OSH,GM_CN_SHA,GM_KR_INC,GM_US_ABH,GM_US_BQN,GM_US_LRP,GM_US_MOI,GM_US_OMQ,GM_US_QBU,GM_US_WAM,GM_US_YPS,GM_WA_CA_OSH,Guangdonglihua_CN_DGG,Hanwha Aero_KR_CHW,Hengyuan EU_CN_JHA,Hengyuan_CN_JHA,HKI_KR_WJU,HKMC AS_KR_UWN,HKMC_CZ_NVS,HKMC_KR_ASA,HKMC_KR_HWS,HKMC_KR_USN,HKMC_KR_UWN,HKMC_WA_CZ_NVS,HLGP AS_KR_CHU,HLGP_KR_CHU,Honda Motor_JP_HG9,Honda Motor_KR_OCH,Humanhorizons_CN_YCG,Hyperstrong_CN_BJS,ICPT(OTS)_PL_WAW,IM_US_SPK,Irizar EM_ES_ADU,Irizar_ES_ADU,jemado_GB_LON,JIANGSU_CN_SZH,JJ Solstice_KR_YNG,JLR AS_GB_GAY,JLR(OTS)_GB_CVT,JLR_GB_CVT,JLR_GB_GAY,KAIST_KR_TJN,Karma(OTS)_US_IVN,KIA_KR_HWS,KIA_KR_KWJ,KIA_SK_TEP,kokam_KR_NSN,KTC_CN_SZX,Lamborghini_IT_SBN,Landsuccess_CN_SZX,LGCDJ_KR_TJN,LGCEG_DE_FRA,LGCGC_KR_GCN,LGCNA_CN_NKG,LGCOC_KR_OCH,LGCOC2_KR_OCH,LGCPI_US_TYM,LGCWA_PL_WRO,LGE_KR_INC,LGE_US_HZP,LGE_US_LRP,LGE_US_QGB,LGESMI_CA_WND,LGESMI_US_HLM,LGESMI_US_LLO,LGESOC_KR_OCH,LGESOC_PL_WRO,LGESWA_PL_BYW,LGESWA_PL_WRO,Lion Bus_CA_SJE,London Taxi_GB_CVT,Magna BMW_AT_GRZ,Magna_AT_GRZ,Magna_Renault_AT_GRZ,Magtec_GB_RTH,Mahindra_IN_PNE,Mahindra_IN_PNQ,Mahindra_KR_PYK,Man Truck & Bus_DE_AGB,Man Truck & Bus_DE_EFG,Man Truck & Bus_DE_MUC,Man Truck & Bus_DE_SCR,Man Truck & Bus_DE_STR,Maserati_DE_VBS,Maserati_IT_MOD,Maserati_IT_TRN,Maserati_US_CMH,Maxion_BR_CZI,MITSUBISHI_JP_TBM,Mitsui_FR_HSP,MOBIS_AS_KR_CHU,MOBIS_AS_KR_PTK,MOBIS_CZ_NVS,MOBIS_KR_CHU,MOBIS_SK_GBY,NANO IN TECH_KR_WJU,NANO IN TECH_WA_KR_WJU,Nissan_GB_SUN,Nissan_JP_FUK,Nissan_JP_YOK,Nivalis(OTS)_US_WIX,Nordresa_CA_LAV,Peopleworks_KR_SEL,Piston_US_NKY,Piston_US_RDF,Porsche AS_DE_KAS,Porsche AS_DE_SSN,Porsche AS_DE_STR,Porsche_CZ_OSR,Porsche_DE_AAH,Porsche_DE_BBI,Porsche_DE_DTN,Porsche_DE_SHM,Porsche_DE_SSN,Porsche_DE_STR,Porsche_DE_VBS,Porsche_DE_WDB,Porsche_DE_WSC,Porsche_SK_BTS,Porsche_SK_DNV,Porsche_SK_HST,Porsche_SK_KNM,PSA AS_FR_VEL,PSA_DE_EIS,PSA_DE_RUM,PSA_FR_CSP,PSA_FR_JKI,PSA_FR_MHS,PSA_FR_PAL,PSA_FR_POI,PSA_FR_RNS,PSA_FR_SHX,PSA_FR_SVD,PSA_FR_VEL,PSA_FR_VER,PSA_FR_VSL,PSA_KR_TJN,PSA_PL_WRO,PSA_SK_TNA,QEV_ES_BCN,Raymond_US_EEG,Rempus_KR_HWS,Renault AS HQ_FR_FNS,Renault AS_FR_FNS,Renault AS_FR_HRB,Renault AS_KR_HAN,Renault AS_KR_PUS,Renault_ES_VLL,Renault_FR_BAT,Renault_FR_CLE,Renault_FR_DOI,Renault_FR_HRB,Renault_GB_ABO,Renault_KR_PUS,Renault_SI_NMO,RVA_DE_NDH,SAIC_CN_SHA,Samsung SDI_AT_GRZ,Samsung SDI_CN_BJS,SEMIROAD_KR_HWS,SGM AS_CN_PDG,SGM_CN_PDG,Shinden Hihhtex_JP_SMZ,Shinden Hihhtex_KR_WJU,Siemens_NO_TRD,Sime Darby_MY_KKH,SKODA_CZ_MBV,Skyworth_CN_XUZ,Solaris_PL_OWA,Spear Power Systems_US_GVW,SYMC_KR_INC,SYMC_KR_PYK,SYMC_KR_TAE,Temsa bus & Coach_TR_ABK,TY_JP_7KA,VAL_DE_222,VAL_DE_FFO,VAL_DE_KRD,Valmet_DE_FRA,Valmet_DE_HAM,Valmet_DE_KRD,Vanderhall_US_PVU,VIA(OTS)_US_OEU,Volta PS_US_HLM,Volvo AS_AU_SYD,Volvo AS_CN_SZH,Volvo AS_FR_HRB,Volvo AS_IL_TLV,Volvo AS_IN_MUB,Volvo AS_JP_NGO,Volvo AS_MY_KUL,Volvo AS_SE_GO5,Volvo AS_SE_GOT,Volvo AS_TH_BKK,Volvo AS_US_ONT,Volvo_AU_SYD,Volvo_BE_GBU,Volvo_BE_GNE,Volvo_IL_TLV,Volvo_JP_NGO,Volvo_KR_SEL,Volvo_MY_KUL,Volvo_MY_SHA,Volvo_SE_GOT,Volvo_TH_BKK,Volvo_TW_TYN,Volvo_US_CHS,Volvo_US_HLM,Vremt AS_CN_SZH,Vremt_CN_SUZ,VW AS_DE_BWE,VW AS_DE_KAS,VW AS_DE_RSE,VW_CZ_MBV,VW_DE_74D,VW_DE_BDB,VW_DE_BWE,VW_DE_FAB,VW_DE_KAS,VW_DE_WOB,VW_DE_WVN,WATTPACK_CN_BJS,WRSE_DE_ZCH,XL_US_BOS,Yuntong_CN_NGB,ZeroEV(OTS)_US_TPE,Zhongjia_CN_CTU,Zhongjia_CN_DQG,Zhongjia_CN_SHA,Zhongjia_CN_TIZ,G741-A,G742-E,MOBIS_KR_SEL,Sebang_ID_KWA,Sebang_KR_ANY,VALEO_KR_TAE,G671-A,G672-E,G673-A,G674-E,GM_MX_RMA,GM_US_BQN,GM_US_DEL,GM_US_IR3,G380,G540,G690,A002_82-W,A050-A,CN003035-P,G184_82-W,G184-A,G634-A,G691_82-W,KR008147-P,KR012031-P,KR32625300_82-P,8minute Energy_KR_KUV,8minute Energy_US_EFS,8minute Energy_US_PQA,A002-82-AS,ABB USA_CN_NJG,ABB USA_US_CFC,ABB USA_US_NYC,ABB_BE_JUM,ABB_US_CFC,ABB_US_RIC,Acciona SA_CL_ANF,Acciona SA_ES_MAD,AEE Solar_CN_NJG,AEE Solar_US_SAC,AES ES_AU_VIC,AES ES_BR_SAO,AES ES_IN_DEL,AES ES_US_CBE,AES ES_US_CHD,AES ES_US_CNN,AES ES_US_LQF,AES ES_US_PCT,AES ES_US_TAZ,AES ES_US_WXN,AGL Energy_AU_ADL,AKA_CA_CRL,Akatsuki_JP_STM,AKUO ENERGY_ES_GRX,AKUO ENERGY_MU_RTS,AKUO ENERGY_RE_ZSE,ALBIOMA_GP_BBR,ALBIOMA_RE_REU,Aldustria_GB_FXT,Aldustria_GB_LON,Ampere_CN_NJG,Ampere_ES_PZU,Arlington Energy_GB_LON,Asset Engineering_US_WAG,AVK_GB_DBE,AVK_GB_GRC,Baywa_US_SCH,Baywa_US_XF7,BJ Power_KR_PUS,Blue sigma_KR_GYS,BOSCH_DE_STR,Bosung Power_KR_CHU,BYUCKSAN POWER_KR_JYG,BYUCKSAN POWER_KR_OKK,BYUCKSAN POWER_KR_SEL,Capital Energy_ES_MAD,CAT_US_CH2,CAT_US_CHI,CAT_US_IGX,CAT_US_LGB,CAT_US_PIA,CDN Energy_CA_ABT,CED_US_ABU,CED_US_RAL,CED_US_SAC,CED_US_SAN,CED_US_SNH,CED_US_STS,CED_US_TPE,CED_US_WCB,CED_US_WPH,Chint_CN_SHA,Chint_US_DAL,CHPP_TH_BKK,Chubutsu_JP_CHC,Chubutsu_JP_GIF,Chubutsu_JP_KOJ,CLOU_CN_SZP,CLOU_CN_SZX,CLOU_CN_WUX,Coenergia_IT_BON,Con Edison_PR_PTR,Con Edison_US_AYE,Con Edison_US_GEE,Con Edison_US_LAX,Con Edison_US_PIA,Controllis_GB_TFD,Cooltech_CN_SHA,Corvus Norway_CA_RBC,Corvus Norway_NO_BGO,Corvus Norway_US_BLI,Corvus_CA_RBC,CPH_DO_AZS,CPH_US_MSK,CSR_AU_NRE,Dasan Energy_KR_TJN,Delta_CN_WJA,Delta_JP_KOJ,Delta_TW_TPE,Delta_US_LVI,Demand Energy_US_GEG,Destin Power_KR_SEL,Destin Power_KR_SGM,Develop_JP_TGI,DM Energy_KR_SEL,DM GEC_KR_SEL,Doosan Heavy_AU_ABX,Doosan Heavy_KR_CHW,Dynapower_US_BZL,Dynapower_US_HKN,Dynapower_US_MRA,Dynapower_US_PCP,Dynapower_US_SFM,Dynapower_US_SOX,E3DC_DE_OSN,E3DC_DE_WTR,Eaton_NO_TRD,Eaton_US_RAG,ECO Power_KR_KWJ,Eco Stor_DE_HAM,Ecocoach_CH_WEI,EDF_CA_MTR,EDF_CA_TOR,EDF_DE_HAM,EDF_ES_VLC,EDF_ES_ZCO,EDF_FR_BPS,EDF_FR_ECI,EDF_FR_MRS,EDF_FR_PAR,EDF_PE_IQT,EDF_US_ABU,EDF_US_BSR,EDF_US_HOU,EDF_US_HQU,EDF_US_NYC,EDF_US_ZTZ,Edison Power_JP_CHB,EDPR_GB_ASS,EDPR_US_FAT,EGEM_CZ_PRG,Eguana_CA_CAL,Eguana_US_HNL,Element Energy_US_MKU,EN Tech_KR_KWJ,EN Technology_KR_SEL,Energon_CZ_PRG,Energy & HVAC_KR_CHC,Energy & HVAC_KR_JEO,Energy & HVAC_KR_KWJ,Energy & HVAC_KR_SYS,Energy Australia_AU_LVH,ENERGYGATE_KR_GJE,ENERGYGATE_KR_SEL,ENERGYGATE_KR_YJU,Enerzent_KR_HNM,Enerzent_KR_KMH,Enerzent_KR_YJU,Enodam_KR_CHO,EON_IN_ABN,EON_KR_SUO,EPS_IT_MIL,Facebook_IE_DUB,Facebook_SE_UME,Facebook_US_CLT,Facebook_US_DAL,Facebook_US_IOX,Facebook_US_PRZ,Facebook_US_QWB,Facebook_US_UFS,Fluence_AD_LAP,Fluence_AE_ABU,Fluence_AU_VIC,Fluence_CA_OAK,Fluence_CL_SCL,Fluence_GB_BOS,Fluence_GB_MBY,Fluence_GB_RUN,Fluence_GB_SHS,Fluence_IE_KIR,Fluence_IN_DEL,Fluence_PH_MNL,Fluence_SG_SIN,Fluence_US_AAI,Fluence_US_BSR,Fluence_US_CBE,Fluence_US_CNN,Fluence_US_FOR,Fluence_US_LB3,Fluence_US_LGB,Fluence_US_PHX,Fluence_US_RAL,Fluence_US_SAN,Fluence_US_TSE,Fluence_US_WDA,Fluence_US_WXN,Fluence_US_WYM,FMS_KR_ANY,Fuji Electric_JP_TMK,G184-82-AS,G691-82-AS,Gamesa_ES_ZAM,Gateway_US_SAN,GE Fuel Cells_AD_LAP,GE Fuel Cells_GB_CHV,GE Fuel Cells_US_NYC,GE Grid Solutions_US_ATL,Ginlong_CN_CN_SHA,Google_NL_AMS,Google_SG_SIN,Google_US_FBN,Google_US_NUQ,Google_US_UCG,GPD_JP_KUH,GPD_JP_SHB,GPD_JP_TMK,Gransolar_ES_MAD,Green Power Tech_GB_YEO,Green Power Tech_MX_LAP,GREENSMITH_GB_TIL,GREENSMITH_US_JEM,Gresham House_GB_LON,Growatt_CN_SZX,GS Neotek_KR_HSO,GS Neotek_KR_SEL,GSENR_KR_YYG,Hanwha Defense_KR_CHW,Hanwha Energy_KR_KUV,Hanwha Energy_KR_SJG,Hanwha Energy_US_PHA,Hanwha Q Cells_KR_SEL,Hanwha Q Cells_US_AAZ,Hanwha Q Cells_US_SAN,HOPPECKE_DE_BRI,HYbrid Energy Solutions_IE_KLK,Hybrid Energy_CN_WUX,Hybrid Energy_IE_KLK,Hybrid Systems_AU_PER,Hyosung H.I_KR_PUS,Hyosung H.I_KR_SEL,Hyosung_KR_SAN,Hyundai E.E.S_KR_SEL,Hyundai Global_KR_SEL,Hyundai H.I_KR_USN,Hyundai Hyms_KR_KWJ,I Power_KR_TAE,IES_US_SNH,IHI_CA_NWC,IHI_CA_SNI,IM_CN_SHA,IM_US_PAO,Ingeteam_ES_CDC,Ingeteam_ES_MAD,Ingeteam_ES_ZAM,Ingeteam_RE_REU,Ingeteam_US_ROC,Intilion_DE_HAM,Itochu_AU_ADL,Itochu_DE_DRS,Itochu_JP_YMG,Itochu_US_HNL,Itochu_US_SNA,Jabil_IT_MRC,Jabil_UG_KLA,Jabil_US_YFA,Jabil_ZA_JNB,JCI_US_HNL,JCI_US_LEX,JCI_US_OIO,Jeju electric vehicle_KR_CJU,JFE_JP_NGI,JFE_JP_TYO,JFE_KR_SUO,JH Energy_KR_INC,Jofemar SA_ES_PAA,K.E.W.Power_KR_CHA,KCS_KR_KWJ,kepco_KR_SEL,Kokam_KR_GCH,Kokam_KR_GSG,Kokam_KR_HNG,Kokam_KR_JDO,Kokam_KR_SCE,Kokam_KR_SEL,Kongsberg Maritime AS_NO_AGO,Kongsberg_NO_BGO,Krannich_US_OCN,Krannich_US_PPS,Kyocera_JP_NGO,L&T_IN_MAA,Leclanche_CA_KIN,Leclanche_CA_NWC,Leclanche_CH_YLB,Leclanche_DE_HAM,Leclanche_NL_HHW,Leclanche_NL_VSR,Leclanche_SK_SZS,Leclanche_US_AID,Leclanche_US_FLI,LG CNS_KR_PTK,LGCAU_AU_BNE,LGCAU_AU_VIC,LGCDJ_KR_TJN,LGCEG_DE_DAR,LGCEG_DE_MWA,LGCEG_DE_SUZ,LGCMI_US_JID,LGCMI_US_LGB,LGCNS_KR_GYS,LGCOC2_KR_OCH,LGE RESU_KR_KUM,LGE RESU_KR_PUS,LGE_KR_ANY,LGE_KR_BJG,LGE_KR_BOR,LGE_KR_CHU,LGE_KR_CJJ,LGE_KR_ESG,LGE_KR_HCN,LGE_KR_HDG,LGE_KR_HWS,LGE_KR_JEO,LGE_KR_KAN,LGE_KR_KWJ,LGE_KR_MAS,LGE_KR_MGG,LGE_KR_PJU,LGE_KR_PTK,LGE_KR_SCE,LGE_KR_SEL,LGE_KR_SGO,LGE_KR_TAN,LGE_KR_TJN,LGESMI_US_LUI,LGESVT_US_BOS,LGESVT_US_WRO,LG-Hitachi_KR_PTK,LGnsys_KR_ASN,LGnsys_KR_CUC,LGnsys_KR_PTK,LGU+_KR_SEL,LM_KW_KWI,LM_US_DAL,LM_US_TOP,Loccioni_IT_AOI,Loccioni_IT_TRN,looop_JP_TKX,LSis_KR_CHO,LSis_KR_GUN,LSis_KR_JAN,LSis_KR_JNJ,LSis_KR_NSN,LSis_KR_YAM,LSis_TH_PYX,Material in Motion_US_TYM,Material in Motion_US_UCG,MELCO_JP_ABI,Melfosur_CL_SCL,Memodo_DE_ODD,Merus Power_FI_NOK,METKA EGN_GB_BTH,METKA EGN_GB_IST,MHPS_JP_NGS,Microgrid Networks_US_NYC,MPOWER GROUP _AU_DTO,MPOWER GROUP_AU_IGN,NEC ES_GB_BAS,NEC ES_GB_TIL,NEC ES_JP_TYO,NEC ES_US_WRO,NEC_CN_YUN,NEC_US_SND,Neoen_AU_SYD,NextEra_US_CHI,NextEra_US_JB2,NextEra_US_MTP,NextEra_US_MYD,NIDEC_DE_BEX,NIDEC_DE_WLM,NIDEC_FI_HEL,NIDEC_FI_LPP,NIDEC_FR_AH3,NIDEC_FR_BGV,NIDEC_FR_ROC,NIDEC_GB_LIS,NIDEC_GB_RFO,NIDEC_GF_CAY,NIDEC_IT_MVO,NIDEC_NC_NOU,NIDEC_SE_DRT,NIDEC_SE_SLF,NIDEC_SV_LAP,NIDEC_SV_USU,NIDEC_US_CLE,NIDEC_US_TXT,NIPPONKOEI_JP_FKF,Noriker_GB_LON,Northern Reliability_US_ASC,NRG ENERGY_CA_OAK,NRG ENERGY_US_BSR,NRG ENERGY_US_MNH,NRG ENERGY_VG_VIJ,NW Energy_FR_EBU,NW Energy_FR_PAR,Omexom_FR_UIP,Omnisystem_KR_YJU,OMRON_JP_OOO,OMRON_JP_YAT,One Stop Warehouse_AU_BNE,Onesource_US_OCN,ORMAT_US_CR3,ORMAT_US_NYC,ORMAT_US_QSB,Panasonic NA_US_TXA,Peopleworks_KR_KUM,PESCA_CA_NWC,PG&E_US_FOU,PIXII_NO_KRS,PIXII_NO_SKD,PIXII_SK_LIM,POSCO International_KR_PTK,posco_KR_KPO,Power-Tech_AU_NWD,Qinous_DE_BER,QIT_KR_PUS,Quewave_EG_CAI,Raychem_IN_ICD,Red Earth_AU_BNE,RES America_CA_TOR,RNA Energy_GB_LON,Rosendin_US_BFL,RWE_AU_DNQ,RWE_GB_ELL,RWE_US_BFL,RWE_US_CJN,RWE_US_HQR,RWE_US_LAX,RWE_US_SGA,RWE_US_SLR,S&C_US_CHI,SAET_IT_SZZ,Schneider_TH_BAI,Schneider_US_CLT,SCLE_BE_AAB,SER_US_FAT,SER_US_MWL,SER_US_OSD,SER_US_SNK,SER_US_SPS,SER_US_SWW,Sharp_JP_37T,Sharp_JP_OSA,Shinden Hightex_JP_FUK,Shinden Hightex_JP_KGK,Shinden Hightex_JP_KMJ,Shinden Hightex_JP_KUH,Shinden Hightex_JP_SAK,Shinden Hightex_JP_SHO,Shinden Hightex_MN_AVK,Shinsegae-ENC_KR_HNM,Shinsegae-ENC_KR_PJU,Shinsegae-ENC_KR_SEL,Shinsegae-ENC_KR_TAE,Siemens AG_DE_ERL,Siemens_DE_ERL,Siemens_GB_MNC,Siemens_NO_OSL,SLB_KR_GUN,SLB_KR_KAN,SMA_AU_FR3,SMA_CZ_KDA,SMA_DE_KAS,SMA_IT_VCE,Smart solar_JP_KUH,Smart solar_JP_TKX,Socomec_FR_HTN,Socomec_SN_DKR,Socomec_US_LAX,Socomec_ZA_AAM,Softbank_JP_TYO,Solar Juice_AU_WEH,Solar Turbines_US_SAN,Solaray(IISS)_US_HNL,SolarEdge_IL_IHA,SolarEdge_IN_BLR,SolarEdge_IN_DEL,SolarEdge_US_FNC,SolarWiz_KR_GIN,SolaX_AU_BUW,SolaX_GB_LAN,SolaX_GB_LDY,SolaX_GB_NTN,Sonepar_AU_MEL,Spear Power Systems_US_GVW,Statera_GB_LCT,Steag_DE_WLM,Sumitomo_JP_CH1,SUNDS_JP_NRI,Sungrid_CA_GAL,Sungrow_KR_SEL,Sunnova_US_HOU,SunRun_US_CSL,SunRun_US_THV,Sunwoda_CN_CZX,Sunwoda_CN_SZX,Synerzen_KR_INC,Synerzen_KR_SEL,Taehyung_KR_BCN,TAI ENGINEERING_TW_TPE,Terra-Gen_US_BSR,Terra-Gen_US_CRU,Terra-Gen_US_ENL,Terra-Gen_US_EWA,Terra-Gen_US_HDO,Terra-Gen_US_MEM,Terra-Gen_US_MOJ,Terra-Gen_US_NYC,Terra-Gen_US_PUC,Terra-Gen_US_ZTZ,TGOOD_AU_PER,Tmeic_BE_KSR,Tmeic_GB_COL,Tmeic_JP_DAT,Tmeic_JP_FKU,Tmeic_JP_ITI,Tmeic_JP_NAH,Tmeic_JP_OSA,Tmeic_JP_TYO,Trinabess_CN_TAX,UBM_DE_BER,UniTest_KR_YNG,USDOE_US_GOE,VARTA RESU_DE_HGO,VARTA RESU_DE_NON,VARTA_DE_STR,Vector_AK_LAP,Vertiv Korea Ltd._KR_SEL,Vertiv_AU_SYD,Vertiv_IT_BLQ,Viridity_US_GTW,Vistra Energy_KR_SEL,Vistra Energy_US_MLG,Vistra Energy_US_OAK,VivintSolar_US_AIE,VivintSolar_US_TNS,WCP Solar_US_NPV,WEG_US_BSR,WEG_US_VBR,WESCO_US_PHX,Woojin_KR_PU0,Yamabishi_JP_TMK,YOUNICOS_BE_DRB,YOUNICOS_US_AUS';
	--DECLARE @p_incoterms	NVARCHAR(1000)	= N'A01,Z01,Z04,EXW,FCA,FAS,FOB,CFR,CIF,CIP,CPT,Z02,DAT,DAP,DDP,DDU';
	--DECLARE @p_trans_mode	NVARCHAR(1000)	= N'';
	--DECLARE @p_item_id		NVARCHAR(MAX)	= N'';
	--DECLARE @p_nick_name	NVARCHAR(100)	= N'';
	--DECLARE @p_valid        NVARCHAR(1)		= N'';
	--DECLARE @debug_mode     NVARCHAR(1)		= N'F';

	--DECLARE @p_division_id	NVARCHAR(100)	= N'82';
	--DECLARE @p_from_site    NVARCHAR(MAX)   = N'';
	--DECLARE @p_to_site		NVARCHAR(MAX)	= N'';
	--DECLARE @p_incoterms	NVARCHAR(1000)	= N'';
	--DECLARE @p_trans_mode	NVARCHAR(1000)	= N'';
	----DECLARE @p_item_id		NVARCHAR(MAX)	= N'EM048290P5B5';
	--DECLARE @p_item_id		NVARCHAR(MAX)	= N'';
	--DECLARE @p_nick_name	NVARCHAR(100)	= N'';
	--DECLARE @p_valid        NVARCHAR(1)		= N'';
	--DECLARE @debug_mode     NVARCHAR(1)		= N'F';


	DECLARE @arr_division_id	NVARCHAR(100)	= '';
	DECLARE @arr_from_site		NVARCHAR(MAX)   = '';
	DECLARE @arr_to_site		NVARCHAR(MAX)	= '';
	DECLARE @arr_incoterms		NVARCHAR(1000)	= '';
	DECLARE @arr_trans_mode		NVARCHAR(1000)	= '';
	DECLARE @arr_item_id		NVARCHAR(MAX)	= '';

	SELECT @arr_division_id		= ISNULL(@arr_division_id	+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@p_division_id,',')
	SELECT @arr_from_site		= ISNULL(@arr_from_site		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@p_from_site	,',')
	SELECT @arr_to_site			= ISNULL(@arr_to_site		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@p_to_site	,',')
	SELECT @arr_incoterms		= ISNULL(@arr_incoterms		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@p_incoterms	,',')
	SELECT @arr_trans_mode		= ISNULL(@arr_trans_mode	+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@p_trans_mode	,',')
	SELECT @arr_item_id			= ISNULL(@arr_item_id		+ ',''' + token +'''', ''''+token+'''')		FROM dbo.String_Split(@p_item_id	,',')

	SET @arr_division_id = RIGHT(@arr_division_id,	LEN(@arr_division_id)	-1);
	SET @arr_from_site	 = RIGHT(@arr_from_site,	LEN(@arr_from_site)		-1);
	SET @arr_to_site	 = RIGHT(@arr_to_site,		LEN(@arr_to_site)		-1);
	SET @arr_incoterms	 = RIGHT(@arr_incoterms,	LEN(@arr_incoterms)		-1);
	SET @arr_trans_mode  = RIGHT(@arr_trans_mode,	LEN(@arr_trans_mode)	-1);
	SET @arr_item_id	 = RIGHT(@arr_item_id,		LEN(@arr_item_id)		-1);


		-- 20230629 List = [company, div, item] 이 구분에 필요하지만 Item 기준으로 하나라도 N이면 active_flag = N  간주
	--DECLARE @v_sql NVARCHAR(MAX)	= N'
			--ACTIVE_FLAG 구분없이 전체
			--IF OBJECT_ID(''tempdb..#TblDynamicPivot_SCP0030_All'') IS NOT NULL
			--	DROP TABLE  #TblDynamicPivot_SCP0030_All;

			--SELECT    A.DIVISION_ID
			--		, A.ITEM_ID
			--		, A.ACTIVE_FLAG
			--INTO    #TblDynamicPivot_SCP0030_All
			--FROM	SCM_MST_ITEM_SN A WITH(NOLOCK)
			--		INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B (NOLOCK) ON
			--				A.ITEM_CLASS = B.CLASS_ID
			--WHERE	1=1
			--	AND B.USE_FLAG		= ''Y'''

		--IF NOT(@p_division_id IS NULL OR @p_division_id = '')
		--BEGIN
		--	SET @v_sql = @v_sql + N'
		--		AND ( A.DIVISION_ID IN ('+ @arr_division_id + '))';
		--END;

		--	SET @v_sql = @v_sql + N'
		--	GROUP BY  A.DIVISION_ID
		--			, A.ITEM_ID
		--			, A.ACTIVE_FLAG;

		--TESTING : NOK
		--select * from #TblDynamicPivot_SCP0030_All;return;

			--------------------------------------------------------------------------------------------------------------------------------------------------------
	DECLARE @v_sql NVARCHAR(MAX)	= N'
			IF OBJECT_ID(''tempdb..#TblDynamicPivot_SCP0030_Inactive'') IS NOT NULL
				DROP TABLE  #TblDynamicPivot_SCP0030_Inactive;

		--	SELECT    A.DIVISION_ID
		--			, A.ITEM_ID
		--			, A.ACTIVE_FLAG
		--	INTO    #TblDynamicPivot_SCP0030_Inactive
		--	FROM	#TblDynamicPivot_SCP0030_All A
		--	WHERE	1=1
		--		AND A.ACTIVE_FLAG	= ''N''
		--	GROUP BY  A.DIVISION_ID
		--			, A.ITEM_ID
		--			, A.ACTIVE_FLAG;

		----TESTING : NOK
		----select * from #TblDynamicPivot_SCP0030_Inactive;return;

		--	--20240115 DIVISION, ITEMID 그륩별 전체가 N 인 경우에만 N 간주, 즉 하나라도 Y 가 있으면 조회가능 by chaan (신재욱책임 요청)
		--	IF OBJECT_ID(''tempdb..#TblDynamicPivot_SCP0030_Active'') IS NOT NULL
		--		DROP TABLE  #TblDynamicPivot_SCP0030_Active;

		--	SELECT    A.DIVISION_ID
		--			, A.ITEM_ID
		--			, A.ACTIVE_FLAG
		--	INTO    #TblDynamicPivot_SCP0030_Active
		--	FROM	#TblDynamicPivot_SCP0030_All A
		--	WHERE	1=1
		--		AND A.ACTIVE_FLAG	= ''Y''
		--	GROUP BY  A.DIVISION_ID
		--			, A.ITEM_ID
		--			, A.ACTIVE_FLAG;

		--	DELETE  A
		--	FROM    #TblDynamicPivot_SCP0030_Inactive A JOIN #TblDynamicPivot_SCP0030_Active B ON
		--					A.DIVISION_ID   = B.DIVISION_ID
		--				AND A.ITEM_ID       = B.ITEM_ID

        SELECT  *
        INTO    #TblDynamicPivot_SCP0030_Inactive
        FROM    dbo.FN_GET_SCP_ITEM_INACTIVE(''' + @p_division_id + ''', ''' + @p_item_id + ''');


		--TESTING : NOK
		--select * from #TblDynamicPivot_SCP0030_Inactive;return;

		SELECT	  SEQ
				, A.DIVISION_ID
				, CUSTOMER
				, FROM_SITE_CODE
				, FROM_CITY
				, TO_SITE_CODE
				, TO_CITY
				, INCOTERMS
				, SAFETY_STOCK
				, TRANSPORT_MODE
				, A.ITEM_ID
				, NICK_NAME
				, FROM_YYYYMMDD
				, TO_YYYYMMDD
				, PRIORITY
				, BOD_ITEM_VALID
				, BOD_VALID
				, ROUTE_VALID
				, ROUTE_ID
				, DAYS_MON
				, DAYS_TUE
				, DAYS_WED
				, DAYS_THU
				, DAYS_FRI
				, DAYS_SAT
				, DAYS_SUN
				, LEAD_TIME
				, CREATED_BY
				, CREATION_DATE
				, LAST_UPDATED_BY
				, LAST_UPDATE_DATE
				, BOD_ID
				, ORG_FROM_YYYYMMDD
				, ORG_TO_YYYYMMDD
				, MERGE_DATE
				, Y = W.ACTIVE_FLAG
				, A.COMPANY_ID
		FROM	(
					SELECT  DISTINCT
							  A.SEQ
							, A.DIVISION_ID
							, ISNULL(NULLIF((SELECT END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = B.TO_SITE),''''),''-'') AS CUSTOMER
							, B.FROM_SITE																																	AS FROM_SITE_CODE
							, (SELECT MAX(COMPANY_ID) FROM SCM_MST_SITE WHERE SCM_SITE_ID = B.FROM_SITE) AS COMPANY_ID
							, (SELECT CITY FROM SCM_MST_SITE D WITH(NOLOCK) WHERE D.DIVISION_ID = A.DIVISION_ID AND D.SCM_SITE_ID = B.FROM_SITE) AS FROM_CITY
							, B.TO_SITE																																		AS TO_SITE_CODE
							, E.CITY TO_CITY
							, B.INCOTERMS
							, RANK() OVER(ORDER BY A.SEQ ASC)																												AS [RANK]
							, A.SAFETY_STOCK
							, C.TRANSPORT_MODE
							, A.ITEM_ID
							, ISNULL(NULLIF((SELECT TOP 1 NICK_NAME FROM SCM_MST_ITEM_SN WITH(NOLOCK) WHERE ITEM_ID = A.ITEM_ID AND NICK_NAME IS NOT NULL),''''),''-'')		AS NICK_NAME
							, CONVERT(DATE, A.FROM_YYYYMMDD, 112)																											AS FROM_YYYYMMDD
							, CONVERT(DATE, A.TO_YYYYMMDD, 112)																												AS TO_YYYYMMDD
							, A.PRIORITY
							, A.VALID_YN																																	AS BOD_ITEM_VALID
							, B.VALID_YN																																	AS BOD_VALID
							, C.VALID_YN																																	AS ROUTE_VALID
							, C.ROUTE_ID
							, C.DAYS_MON
							, C.DAYS_TUE
							, C.DAYS_WED
							, C.DAYS_THU
							, C.DAYS_FRI
							, C.DAYS_SAT
							, C.DAYS_SUN
							, (SELECT V.LT_TOTAL FROM SCP_MST_BOD_N_V V WITH(NOLOCK) WHERE V.DIVISION_ID = B.DIVISION_ID  AND V.BOD_ID = B.BOD_ID )							AS LEAD_TIME
							-- 2025.04.07 kimcd PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - LEAD TIME 조회 안 되어서 SCP_MST_BOD_V를 SCP_MST_BOD_N_V 로 변경
							, A.CREATED_BY
							, A.CREATION_DATE
							, A.LAST_UPDATED_BY
							, A.LAST_UPDATE_DATE
							, B.BOD_ID
							, A.FROM_YYYYMMDD																																AS ORG_FROM_YYYYMMDD
							, A.TO_YYYYMMDD																																	AS ORG_TO_YYYYMMDD
							, (A.FROM_YYYYMMDD + A.TO_YYYYMMDD)																												AS MERGE_DATE
					FROM	SCP_MST_BOD_ITEM A WITH(NOLOCK)
							INNER JOIN SCP_MST_BOD B WITH(NOLOCK) ON
									A.BOD_ID = B.BOD_ID
							LEFT OUTER JOIN SCP_MST_DISTRIBUTION_ROUTE C WITH(NOLOCK) ON
									B.ROUTE_ID = C.ROUTE_ID
							LEFT OUTER JOIN (
												SELECT DISTINCT
														  SCM_SITE_ID
														, CITY
												FROM	SCM_MST_SITE WITH(NOLOCK)) E ON
																B.TO_SITE = E.SCM_SITE_ID
				) A
				LEFT OUTER JOIN  #TblDynamicPivot_SCP0030_Inactive W ON

						W.ITEM_ID = A.ITEM_ID
		WHERE	1=1
			AND W.ACTIVE_FLAG IS NULL';

		IF NOT(@p_division_id IS NULL OR @p_division_id = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.DIVISION_ID IN ('+ @arr_division_id + '))';
		END;

		IF NOT(@p_from_site IS NULL OR @p_from_site = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.FROM_SITE_CODE	IN ('+ @arr_from_site +') )';
		END

		IF NOT(@p_to_site IS NULL OR @p_to_site = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.TO_SITE_CODE IN ('+ @arr_to_site +') )';
		END

		IF NOT(@p_incoterms IS NULL OR @p_incoterms = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.INCOTERMS IN ('+ @arr_incoterms +') )';
		END

		IF NOT(@p_trans_mode IS NULL OR @p_trans_mode = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.TRANSPORT_MODE	IN ('+ @arr_trans_mode +') )';
		END

		IF NOT(@p_item_id IS NULL OR @p_item_id = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.ITEM_ID IN ('+ @arr_item_id +') )';
		END

		IF NOT(@p_valid IS NULL OR @p_valid = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.BOD_ITEM_VALID	= '''+ @p_valid +''')';
		END

		IF NOT(@p_nick_name IS NULL OR @p_nick_name = '')
		BEGIN
			SET @v_sql = @v_sql + N'
				AND ( A.NICK_NAME LIKE ''%' + @p_nick_name +'%'')';
		END

		SET @v_sql = @v_sql + N'
		ORDER BY DIVISION_ID,A.ITEM_ID, FROM_SITE_CODE, TO_SITE_CODE,TRANSPORT_MODE';

	--TESTING : OK
	--exec debug_log @v_sql, 'T';return;

	EXEC (@v_sql);


	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0030_All') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0030_All;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0030_AllInactive') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0030_AllInactive;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0030_Inactive') IS NOT NULL
		DROP TABLE  #TblDynamicPivot_SCP0030_Inactive;
END

