

/*
 * Program ID   : PR_SCP_MST_DIO
 * Description  : BDP DIO 정보 수신/처리
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.07.01   KSG            Initial Release [전지 공급 대응력 향상을 위한 SCM 관리 체계 개선]
 *
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_DIO]
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE @v_opdv_cd      NVARCHAR(30); 
  DECLARE @v_yrqt         NVARCHAR(30); 

  -- LOG 용 변수 설정
  DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_DIO';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @v_ifseqno      NVARCHAR(30); 
  DECLARE @n_history_seq  BIGINT;
   
  -- 시작 LOG
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();

  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  BEGIN TRY
  --BEGIN TRANSACTION
    BEGIN
    
      -- 인터페이스 테이블 처리 ROW UPDATE
      UPDATE xif_bdp_dio_r_sn 
      SET    transfer_flag             = 'P'
      WHERE  ISNULL(transfer_flag,'N') = 'N';  

      UPDATE xif_bdp_mat_map_mst_r_sn 
      SET    transfer_flag             = 'P'
      WHERE  ISNULL(transfer_flag,'N') = 'N';  

      --------------------------------------------------------------------------------
      -- 1. DIO IF 처리
      --------------------------------------------------------------------------------        
      BEGIN

          MERGE INTO scp_mst_dio_bdp A
          USING (SELECT /* PR_SCP_MST_DIO */ 
                        std_ym, yrqt
                      , legp_div_cd,         MIN(legp_div_nm         ) legp_div_nm        
                      , ophd_cd,             MIN(ophd_nm             ) ophd_nm            
                      , opdv_cd,             MIN(opdv_nm             ) opdv_nm            
                      , rmph_div_cd,         MIN(rmph_div_nm         ) rmph_div_nm        
                      , dom_ovs_div_cd,      MIN(dom_ovs_div_nm      ) dom_ovs_div_nm     
                      , plnt_area_div_cd,    MIN(plnt_area_div_nm    ) plnt_area_div_nm   
                      , dm_exp_div_cd,       MIN(dm_exp_div_nm       ) dm_exp_div_nm      
                      , prct_cd,             MIN(prct_nm             ) prct_nm            
                      , opr_fld_cd,          MIN(opr_fld_nm          ) opr_fld_nm         
                      , wkpc_grp_cd,         MIN(wkpc_grp_nm         ) wkpc_grp_nm        
                      , cmpn_cd,             MIN(cmpn_nm             ) cmpn_nm            
                      , bas_div_cd,          MIN(bas_div_nm          ) bas_div_nm         
                      , rep_cust_cd,         MIN(rep_cust_nm         ) rep_cust_nm        
                      , sloc_cd,             MIN(sloc_nm             ) sloc_nm            
                      , stk_mng_mtrl_grp_cd, MIN(stk_mng_mtrl_grp_nm ) stk_mng_mtrl_grp_nm
                      , MIN(exch_unit        ) exch_unit       
                      , MIN(tot_yn           ) tot_yn          
                      , MIN(seq              ) seq             
                      , MIN(gro_std_dio_ds   ) gro_std_dio_ds  
                      , MIN(min_std_dio_ds   ) min_std_dio_ds  
                      , MIN(cycl_std_dio_ds  ) cycl_std_dio_ds 
                      , MIN(trnsp_std_dio_ds ) trnsp_std_dio_ds
                      , MIN(wkpc_std_dio_ds  ) wkpc_std_dio_ds 
                      , MIN(sft_std_dio_ds   ) sft_std_dio_ds  
                      , MIN(etc_std_dio_ds   ) etc_std_dio_ds  
                      , MIN(chg_rsn_nm       ) chg_rsn_nm      
                      , MIN(rmk              ) rmk             
                      , MIN(dh_lod_ts        ) dh_lod_ts       
                      , MAX(dh_mdf_ts        ) dh_mdf_ts       
                      , @v_batch_user AS created_by,     GETDATE() AS creation_date
                      , @v_batch_user AS last_updated_by, GETDATE() AS last_update_date
                 FROM   xif_bdp_dio_r_sn WITH(NOLOCK)
                 WHERE  transfer_flag = 'P'
                 GROUP BY std_ym, yrqt, legp_div_cd, ophd_cd, opdv_cd, rmph_div_cd, dom_ovs_div_cd, plnt_area_div_cd, dm_exp_div_cd
                        , prct_cd, opr_fld_cd, wkpc_grp_cd, cmpn_cd, bas_div_cd, rep_cust_cd, sloc_cd, stk_mng_mtrl_grp_cd
                ) B
          ON    A.std_ym              = B.std_ym
          AND   A.yrqt                = B.yrqt
          AND   A.legp_div_cd         = B.legp_div_cd
          AND   A.ophd_cd             = B.ophd_cd  
          AND   A.opdv_cd             = B.opdv_cd
          AND   A.rmph_div_cd         = B.rmph_div_cd
          AND   A.dom_ovs_div_cd      = B.dom_ovs_div_cd
          AND   A.plnt_area_div_cd    = B.plnt_area_div_cd
          AND   A.dm_exp_div_cd       = B.dm_exp_div_cd
          AND   A.prct_cd             = B.prct_cd 
          AND   A.opr_fld_cd          = B.opr_fld_cd
          AND   A.wkpc_grp_cd         = B.wkpc_grp_cd      
          AND   A.cmpn_cd             = B.cmpn_cd
          AND   A.bas_div_cd          = B.bas_div_cd
          AND   A.rep_cust_cd         = B.rep_cust_cd 
          AND   A.sloc_cd             = B.sloc_cd
          AND   A.stk_mng_mtrl_grp_cd = B.stk_mng_mtrl_grp_cd        
         
          WHEN MATCHED THEN
          
          UPDATE 
          SET    A.legp_div_nm          = B.legp_div_nm        
               , A.ophd_nm              = B.ophd_nm            
               , A.opdv_nm              = B.opdv_nm            
               , A.rmph_div_nm          = B.rmph_div_nm        
               , A.dom_ovs_div_nm       = B.dom_ovs_div_nm     
               , A.plnt_area_div_nm     = B.plnt_area_div_nm   
               , A.dm_exp_div_nm        = B.dm_exp_div_nm      
               , A.prct_nm              = B.prct_nm            
               , A.opr_fld_nm           = B.opr_fld_nm         
               , A.wkpc_grp_nm          = B.wkpc_grp_nm        
               , A.cmpn_nm              = B.cmpn_nm            
               , A.bas_div_nm           = B.bas_div_nm         
               , A.rep_cust_nm          = B.rep_cust_nm        
               , A.sloc_nm              = B.sloc_nm            
               , A.stk_mng_mtrl_grp_nm  = B.stk_mng_mtrl_grp_nm
               , A.exch_unit            = B.exch_unit          
               , A.tot_yn               = B.tot_yn             
               , A.seq                  = B.seq                
               , A.gro_std_dio_ds       = B.gro_std_dio_ds     
               , A.min_std_dio_ds       = B.min_std_dio_ds     
               , A.cycl_std_dio_ds      = B.cycl_std_dio_ds    
               , A.trnsp_std_dio_ds     = B.trnsp_std_dio_ds   
               , A.wkpc_std_dio_ds      = B.wkpc_std_dio_ds    
               , A.sft_std_dio_ds       = B.sft_std_dio_ds     
               , A.etc_std_dio_ds       = B.etc_std_dio_ds     
               , A.chg_rsn_nm           = B.chg_rsn_nm         
               , A.rmk                  = B.rmk                
               , A.dh_lod_ts            = B.dh_lod_ts          
               , A.dh_mdf_ts            = B.dh_mdf_ts          
               , A.last_updated_by      = B.last_updated_by    
               , A.last_update_date     = B.last_update_date              
                          
          WHEN NOT MATCHED THEN
          INSERT (
                        std_ym,              yrqt
                      , legp_div_cd,         legp_div_nm        
                      , ophd_cd,             ophd_nm            
                      , opdv_cd,             opdv_nm            
                      , rmph_div_cd,         rmph_div_nm        
                      , dom_ovs_div_cd,      dom_ovs_div_nm     
                      , plnt_area_div_cd,    plnt_area_div_nm   
                      , dm_exp_div_cd,       dm_exp_div_nm      
                      , prct_cd,             prct_nm            
                      , opr_fld_cd,          opr_fld_nm         
                      , wkpc_grp_cd,         wkpc_grp_nm        
                      , cmpn_cd,             cmpn_nm            
                      , bas_div_cd,          bas_div_nm         
                      , rep_cust_cd,         rep_cust_nm        
                      , sloc_cd,             sloc_nm            
                      , stk_mng_mtrl_grp_cd, stk_mng_mtrl_grp_nm
                      , exch_unit       
                      , tot_yn          
                      , seq             
                      , gro_std_dio_ds  
                      , min_std_dio_ds  
                      , cycl_std_dio_ds 
                      , trnsp_std_dio_ds
                      , wkpc_std_dio_ds 
                      , sft_std_dio_ds  
                      , etc_std_dio_ds  
                      , chg_rsn_nm      
                      , rmk             
                      , dh_lod_ts       
                      , dh_mdf_ts       
                      , created_by,      creation_date
                      , last_updated_by, last_update_date                   
                 )
          VALUES (
                        B.std_ym,              B.yrqt
                      , B.legp_div_cd,         B.legp_div_nm        
                      , B.ophd_cd,             B.ophd_nm            
                      , B.opdv_cd,             B.opdv_nm            
                      , B.rmph_div_cd,         B.rmph_div_nm        
                      , B.dom_ovs_div_cd,      B.dom_ovs_div_nm     
                      , B.plnt_area_div_cd,    B.plnt_area_div_nm   
                      , B.dm_exp_div_cd,       B.dm_exp_div_nm      
                      , B.prct_cd,             B.prct_nm            
                      , B.opr_fld_cd,          B.opr_fld_nm         
                      , B.wkpc_grp_cd,         B.wkpc_grp_nm        
                      , B.cmpn_cd,             B.cmpn_nm            
                      , B.bas_div_cd,          B.bas_div_nm         
                      , B.rep_cust_cd,         B.rep_cust_nm        
                      , B.sloc_cd,             B.sloc_nm            
                      , B.stk_mng_mtrl_grp_cd, B.stk_mng_mtrl_grp_nm
                      , B.exch_unit       
                      , B.tot_yn          
                      , B.seq             
                      , B.gro_std_dio_ds  
                      , B.min_std_dio_ds  
                      , B.cycl_std_dio_ds 
                      , B.trnsp_std_dio_ds
                      , B.wkpc_std_dio_ds 
                      , B.sft_std_dio_ds  
                      , B.etc_std_dio_ds  
                      , B.chg_rsn_nm      
                      , B.rmk             
                      , B.dh_lod_ts       
                      , B.dh_mdf_ts          
                      , B.created_by,      B.creation_date
                      , B.last_updated_by, B.last_update_date    
                 )
          ;

          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'APPEND';
          SET @v_log_message = '1. MERGE INTO scp_mst_dio_bdp';
          SET @v_description = 'BDP DIO Merge ';
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------

      END

      --------------------------------------------------------------------------------
      -- 2. Mat Map IF 처리
      --------------------------------------------------------------------------------
      BEGIN
      
          MERGE INTO scp_mst_dio_mat_map A
          USING (SELECT /* PR_SCP_MST_DIO */ 
                        plnt_cd, mtrl_cd, prdcls_cd, evcl_cd, cmpn_cd, legp_div_cd, ophd_cd, opdv_cd
                      , rmph_div_cd, dom_ovs_div_cd, plnt_area_div_cd, wkpc_grp_cd, dm_exp_div_cd, prct_cd, opr_fld_cd, stk_mng_mtrl_grp_cd

                      , MIN(qty_unit               ) AS qty_unit              
                      , MIN(legp_div_nm            ) AS legp_div_nm           
                      , MIN(ophd_nm                ) AS ophd_nm               
                      , MIN(opdv_nm                ) AS opdv_nm               
                      , MIN(rmph_div_nm            ) AS rmph_div_nm           
                      , MIN(dom_ovs_div_nm         ) AS dom_ovs_div_nm        
                      , MIN(plnt_area_div_nm       ) AS plnt_area_div_nm      
                      , MIN(wkpc_grp_nm            ) AS wkpc_grp_nm           
                      , MIN(dm_exp_div_nm          ) AS dm_exp_div_nm         
                      , MIN(prct_nm                ) AS prct_nm               
                      , MIN(opr_fld_nm             ) AS opr_fld_nm            
                      , MIN(stk_mng_mtrl_grp_nm    ) AS stk_mng_mtrl_grp_nm   
                      , MIN(exch_unit              ) AS exch_unit             
                      , MIN(exch_fig               ) AS exch_fig              
                      , MIN(stk_aggr_yn            ) AS stk_aggr_yn           
                      , MIN(sto_stk_aggr_yn        ) AS sto_stk_aggr_yn       
                      , MIN(nya_stk_aggr_yn        ) AS nya_stk_aggr_yn       
                      , MIN(wip_stk_aggr_yn        ) AS wip_stk_aggr_yn       
                      , MIN(gscm_mtrl_grp1_nm      ) AS gscm_mtrl_grp1_nm     
                      , MIN(gscm_mtrl_grp2_nm      ) AS gscm_mtrl_grp2_nm     
                      , MIN(gscm_mtrl_grp3_nm      ) AS gscm_mtrl_grp3_nm     
                      , MIN(scm_mtrl_grp1_nm       ) AS scm_mtrl_grp1_nm      
                      , MIN(scm_mtrl_grp2_nm       ) AS scm_mtrl_grp2_nm      
                      , MIN(scm_mtrl_grp3_nm       ) AS scm_mtrl_grp3_nm      
                      , MIN(scm_exch_fig           ) AS scm_exch_fig          
                      , MIN(mdm_class_cd           ) AS mdm_class_cd          
                      , MIN(mdm_mtrl_ctgr_hira1_cd ) AS mdm_mtrl_ctgr_hira1_cd
                      , MIN(mdm_mtrl_ctgr_hira2_cd ) AS mdm_mtrl_ctgr_hira2_cd
                      , MIN(mdm_mtrl_ctgr_hira3_cd ) AS mdm_mtrl_ctgr_hira3_cd
                      , MIN(mdm_mtrl_ctgr_hira4_cd ) AS mdm_mtrl_ctgr_hira4_cd
                      , MIN(mdm_wkpc_grp_dtl_nm    ) AS mdm_wkpc_grp_dtl_nm   
                      , MIN(mdm_tgt_cll_cd         ) AS mdm_tgt_cll_cd        
                      , MIN(mdm_proj_nm            ) AS mdm_proj_nm           
                      , MIN(mdm_mdl_nm             ) AS mdm_mdl_nm            
                      , MIN(mdm_proj_nck_nm        ) AS mdm_proj_nck_nm       
                      , MIN(enes_gplm_tgt_cll_cd   ) AS enes_gplm_tgt_cll_cd  
                      , MIN(enes_gplm_rqmt_qty     ) AS enes_gplm_rqmt_qty    
                      , MIN(enes_gplm_cll_exch_fig ) AS enes_gplm_cll_exch_fig
                      , MIN(dval_yn                ) AS dval_yn               
                      , MIN(dh_lod_ts              ) AS dh_lod_ts             
                      , MAX(dh_mdf_ts              ) AS dh_mdf_ts             
                      , @v_batch_user AS created_by,      GETDATE() AS creation_date
                      , @v_batch_user AS last_updated_by, GETDATE() AS last_update_date
                 FROM   xif_bdp_mat_map_mst_r_sn WITH(NOLOCK)
                 WHERE  transfer_flag = 'P'
                 GROUP BY plnt_cd, mtrl_cd, prdcls_cd, evcl_cd, cmpn_cd, legp_div_cd, ophd_cd, opdv_cd
                        , rmph_div_cd, dom_ovs_div_cd, plnt_area_div_cd, wkpc_grp_cd, dm_exp_div_cd, prct_cd, opr_fld_cd, stk_mng_mtrl_grp_cd
                ) B
          ON    A.plnt_cd             = B.plnt_cd
          AND   A.mtrl_cd             = B.mtrl_cd
          AND   A.prdcls_cd           = B.prdcls_cd  
          AND   A.evcl_cd             = B.evcl_cd
          AND   A.cmpn_cd             = B.cmpn_cd
          AND   A.legp_div_cd         = B.legp_div_cd
          AND   A.ophd_cd             = B.ophd_cd
          AND   A.opdv_cd             = B.opdv_cd
          AND   A.rmph_div_cd         = B.rmph_div_cd 
          AND   A.dom_ovs_div_cd      = B.dom_ovs_div_cd
          AND   A.plnt_area_div_cd    = B.plnt_area_div_cd      
          AND   A.wkpc_grp_cd         = B.wkpc_grp_cd
          AND   A.dm_exp_div_cd       = B.dm_exp_div_cd
          AND   A.prct_cd             = B.prct_cd 
          AND   A.opr_fld_cd          = B.opr_fld_cd
          AND   A.stk_mng_mtrl_grp_cd = B.stk_mng_mtrl_grp_cd      

          WHEN MATCHED THEN
          
          UPDATE 
          SET    A.qty_unit               = B.qty_unit                
               , A.legp_div_nm            = B.legp_div_nm             
               , A.ophd_nm                = B.ophd_nm                 
               , A.opdv_nm                = B.opdv_nm                 
               , A.rmph_div_nm            = B.rmph_div_nm             
               , A.dom_ovs_div_nm         = B.dom_ovs_div_nm          
               , A.plnt_area_div_nm       = B.plnt_area_div_nm        
               , A.wkpc_grp_nm            = B.wkpc_grp_nm             
               , A.dm_exp_div_nm          = B.dm_exp_div_nm           
               , A.prct_nm                = B.prct_nm                 
               , A.opr_fld_nm             = B.opr_fld_nm              
               , A.stk_mng_mtrl_grp_nm    = B.stk_mng_mtrl_grp_nm     
               , A.exch_unit              = B.exch_unit               
               , A.exch_fig               = B.exch_fig                
               , A.stk_aggr_yn            = B.stk_aggr_yn             
               , A.sto_stk_aggr_yn        = B.sto_stk_aggr_yn         
               , A.nya_stk_aggr_yn        = B.nya_stk_aggr_yn         
               , A.wip_stk_aggr_yn        = B.wip_stk_aggr_yn         
               , A.gscm_mtrl_grp1_nm      = B.gscm_mtrl_grp1_nm       
               , A.gscm_mtrl_grp2_nm      = B.gscm_mtrl_grp2_nm       
               , A.gscm_mtrl_grp3_nm      = B.gscm_mtrl_grp3_nm       
               , A.scm_mtrl_grp1_nm       = B.scm_mtrl_grp1_nm        
               , A.scm_mtrl_grp2_nm       = B.scm_mtrl_grp2_nm        
               , A.scm_mtrl_grp3_nm       = B.scm_mtrl_grp3_nm        
               , A.scm_exch_fig           = B.scm_exch_fig            
               , A.mdm_class_cd           = B.mdm_class_cd            
               , A.mdm_mtrl_ctgr_hira1_cd = B.mdm_mtrl_ctgr_hira1_cd  
               , A.mdm_mtrl_ctgr_hira2_cd = B.mdm_mtrl_ctgr_hira2_cd  
               , A.mdm_mtrl_ctgr_hira3_cd = B.mdm_mtrl_ctgr_hira3_cd  
               , A.mdm_mtrl_ctgr_hira4_cd = B.mdm_mtrl_ctgr_hira4_cd  
               , A.mdm_wkpc_grp_dtl_nm    = B.mdm_wkpc_grp_dtl_nm     
               , A.mdm_tgt_cll_cd         = B.mdm_tgt_cll_cd          
               , A.mdm_proj_nm            = B.mdm_proj_nm             
               , A.mdm_mdl_nm             = B.mdm_mdl_nm              
               , A.mdm_proj_nck_nm        = B.mdm_proj_nck_nm         
               , A.enes_gplm_tgt_cll_cd   = B.enes_gplm_tgt_cll_cd    
               , A.enes_gplm_rqmt_qty     = B.enes_gplm_rqmt_qty      
               , A.enes_gplm_cll_exch_fig = B.enes_gplm_cll_exch_fig  
               , A.dval_yn                = B.dval_yn                 
               , A.dh_lod_ts              = B.dh_lod_ts               
               , A.dh_mdf_ts              = B.dh_mdf_ts               
               , A.last_updated_by        = B.last_updated_by         
               , A.last_update_date       = B.last_update_date             
                          
          WHEN NOT MATCHED THEN
          INSERT (
                        plnt_cd, mtrl_cd, prdcls_cd, evcl_cd, cmpn_cd, legp_div_cd, ophd_cd, opdv_cd
                      , rmph_div_cd, dom_ovs_div_cd, plnt_area_div_cd, wkpc_grp_cd, dm_exp_div_cd, prct_cd, opr_fld_cd, stk_mng_mtrl_grp_cd

                      , qty_unit              
                      , legp_div_nm           
                      , ophd_nm               
                      , opdv_nm               
                      , rmph_div_nm           
                      , dom_ovs_div_nm        
                      , plnt_area_div_nm      
                      , wkpc_grp_nm           
                      , dm_exp_div_nm         
                      , prct_nm               
                      , opr_fld_nm            
                      , stk_mng_mtrl_grp_nm   
                      , exch_unit             
                      , exch_fig              
                      , stk_aggr_yn           
                      , sto_stk_aggr_yn       
                      , nya_stk_aggr_yn       
                      , wip_stk_aggr_yn       
                      , gscm_mtrl_grp1_nm     
                      , gscm_mtrl_grp2_nm     
                      , gscm_mtrl_grp3_nm     
                      , scm_mtrl_grp1_nm      
                      , scm_mtrl_grp2_nm      
                      , scm_mtrl_grp3_nm      
                      , scm_exch_fig          
                      , mdm_class_cd          
                      , mdm_mtrl_ctgr_hira1_cd
                      , mdm_mtrl_ctgr_hira2_cd
                      , mdm_mtrl_ctgr_hira3_cd
                      , mdm_mtrl_ctgr_hira4_cd
                      , mdm_wkpc_grp_dtl_nm   
                      , mdm_tgt_cll_cd        
                      , mdm_proj_nm           
                      , mdm_mdl_nm            
                      , mdm_proj_nck_nm       
                      , enes_gplm_tgt_cll_cd  
                      , enes_gplm_rqmt_qty    
                      , enes_gplm_cll_exch_fig
                      , dval_yn               
                      , dh_lod_ts             
                      , dh_mdf_ts             
                      , created_by,      creation_date
                      , last_updated_by, last_update_date            
                 )
          VALUES (
                        B.plnt_cd, B.mtrl_cd, B.prdcls_cd, B.evcl_cd, B.cmpn_cd, B.legp_div_cd, B.ophd_cd, B.opdv_cd
                      , B.rmph_div_cd, B.dom_ovs_div_cd, B.plnt_area_div_cd, B.wkpc_grp_cd, B.dm_exp_div_cd, B.prct_cd, B.opr_fld_cd, B.stk_mng_mtrl_grp_cd

                      , B.qty_unit              
                      , B.legp_div_nm           
                      , B.ophd_nm               
                      , B.opdv_nm               
                      , B.rmph_div_nm           
                      , B.dom_ovs_div_nm        
                      , B.plnt_area_div_nm      
                      , B.wkpc_grp_nm           
                      , B.dm_exp_div_nm         
                      , B.prct_nm               
                      , B.opr_fld_nm            
                      , B.stk_mng_mtrl_grp_nm   
                      , B.exch_unit             
                      , B.exch_fig              
                      , B.stk_aggr_yn           
                      , B.sto_stk_aggr_yn       
                      , B.nya_stk_aggr_yn       
                      , B.wip_stk_aggr_yn       
                      , B.gscm_mtrl_grp1_nm     
                      , B.gscm_mtrl_grp2_nm     
                      , B.gscm_mtrl_grp3_nm     
                      , B.scm_mtrl_grp1_nm      
                      , B.scm_mtrl_grp2_nm      
                      , B.scm_mtrl_grp3_nm      
                      , B.scm_exch_fig          
                      , B.mdm_class_cd          
                      , B.mdm_mtrl_ctgr_hira1_cd
                      , B.mdm_mtrl_ctgr_hira2_cd
                      , B.mdm_mtrl_ctgr_hira3_cd
                      , B.mdm_mtrl_ctgr_hira4_cd
                      , B.mdm_wkpc_grp_dtl_nm   
                      , B.mdm_tgt_cll_cd        
                      , B.mdm_proj_nm           
                      , B.mdm_mdl_nm            
                      , B.mdm_proj_nck_nm       
                      , B.enes_gplm_tgt_cll_cd  
                      , B.enes_gplm_rqmt_qty    
                      , B.enes_gplm_cll_exch_fig
                      , B.dval_yn               
                      , B.dh_lod_ts             
                      , B.dh_mdf_ts             
                      , B.created_by,      B.creation_date
                      , B.last_updated_by, B.last_update_date
                 )
          ;

          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'APPEND';
          SET @v_log_message = '2. MERGE INTO scp_mst_dio_mat_map';
          SET @v_description = 'BDP Mat Map Merge ';
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------

      END

      --------------------------------------------------------------------------------
      -- 3. SCP용 DIO 처리
      --------------------------------------------------------------------------------
      BEGIN
      	        
          MERGE INTO scp_mst_dio A
          USING (
                 SELECT d.std_ym, d.yrqt, m.prdcls_cd, '*' AS plnt_cd, m.mtrl_cd
                      , d.rmph_div_cd, d.plnt_area_div_cd, d.wkpc_grp_cd, d.rep_cust_cd, d.stk_mng_mtrl_grp_cd
					   
                      , MIN(d.rmph_div_nm        ) AS rmph_div_nm        
                      , MIN(d.plnt_area_div_nm   ) AS plnt_area_div_nm   
                      , MIN(d.wkpc_grp_nm        ) AS wkpc_grp_nm        
                      , MIN(d.rep_cust_nm        ) AS rep_cust_nm        
                      , MIN(d.stk_mng_mtrl_grp_nm) AS stk_mng_mtrl_grp_nm
                      , MIN(d.tot_yn             ) AS tot_yn             
                      , MIN(d.seq                ) AS seq                
                      , MIN(d.gro_std_dio_ds     ) AS gro_std_dio_ds     
                      , MIN(d.min_std_dio_ds     ) AS min_std_dio_ds     
                      , MIN(d.cycl_std_dio_ds    ) AS cycl_std_dio_ds    
                      , MIN(d.trnsp_std_dio_ds   ) AS trnsp_std_dio_ds   
                      , MIN(d.wkpc_std_dio_ds    ) AS wkpc_std_dio_ds    
                      , MIN(d.sft_std_dio_ds     ) AS sft_std_dio_ds     
                      , MIN(d.etc_std_dio_ds     ) AS etc_std_dio_ds     
                      , MIN(d.chg_rsn_nm         ) AS chg_rsn_nm         
                      , MIN(d.rmk                ) AS rmk                
                      , MIN(d.dh_lod_ts          ) AS dh_lod_ts          
                      , MAX(d.dh_mdf_ts          ) AS dh_mdf_ts          
					   
                      , @v_batch_user AS created_by,      GETDATE() AS creation_date
                      , @v_batch_user AS last_updated_by, GETDATE() AS last_update_date
                 FROM   scp_mst_dio_bdp  d WITH(NOLOCK)

                 INNER JOIN scp_mst_dio_mat_map m WITH(NOLOCK)

                   ON  d.legp_div_cd         = m.legp_div_cd
                   AND d.ophd_cd             = m.ophd_cd
                   AND d.opdv_cd             = m.opdv_cd
                   AND d.rmph_div_cd         = m.rmph_div_cd
                   --AND d.plnt_area_div_cd    = m.plnt_area_div_cd -- 총합만 가져오기 위함
                   AND d.wkpc_grp_cd         = m.wkpc_grp_cd
                   AND d.stk_mng_mtrl_grp_cd = m.stk_mng_mtrl_grp_cd
                   AND d.exch_unit           = m.exch_unit

                 INNER JOIN (
                             SELECT opdv_cd, MAX(yrqt) AS yrqt
                             FROM   scp_mst_dio_bdp  d WITH(NOLOCK)
                             GROUP BY opdv_cd
                            ) q

                   ON  d.opdv_cd = q.opdv_cd
                   AND d.yrqt    = q.yrqt

                 WHERE m.prdcls_cd In (SELECT division_id FROM scm_mst_division WITH(NOLOCK) WHERE valid_yn = 'Y')
                 AND   d.tot_yn   = 'Y' -- 총합만 가져오기 위함

                 GROUP BY d.std_ym, d.yrqt, m.prdcls_cd, m.mtrl_cd
                        , d.rmph_div_cd, d.plnt_area_div_cd, d.wkpc_grp_cd, d.rep_cust_cd, d.stk_mng_mtrl_grp_cd
                ) B
          ON    A.yyyymm                = B.std_ym
          AND   A.yyyyq                 = B.yrqt  
          AND   A.division_id           = B.prdcls_cd  
          AND   A.plant_id              = B.plnt_cd  
          AND   A.item_id               = B.mtrl_cd  
          AND   A.rmph_div_code         = B.rmph_div_cd  
          AND   A.plnt_area_div_code    = B.plnt_area_div_cd  
          AND   A.wkpc_grp_code         = B.wkpc_grp_cd  
          AND   A.rep_cust_code         = B.rep_cust_cd  
          AND   A.stk_mng_mtrl_grp_code = B.stk_mng_mtrl_grp_cd  

          WHEN MATCHED THEN
          
          UPDATE 
          SET    A.rmph_div_name         = B.rmph_div_nm                
               , A.plnt_area_div_name    = B.plnt_area_div_nm                         
               , A.wkpc_grp_name         = B.wkpc_grp_nm         
               , A.rep_cust_name         = B.rep_cust_nm
               , A.stk_mng_mtrl_grp_name = B.stk_mng_mtrl_grp_nm
               , A.total_yn              = B.tot_yn
               , A.seq                   = B.seq
               , A.gro_std_dio           = B.gro_std_dio_ds
               , A.min_std_dio           = B.min_std_dio_ds
               , A.cycl_std_dio          = B.cycl_std_dio_ds
               , A.trnsp_std_dio         = B.trnsp_std_dio_ds
               , A.wkpc_std_dio          = B.wkpc_std_dio_ds
               , A.sft_std_dio           = B.sft_std_dio_ds
               , A.etc_std_dio           = B.etc_std_dio_ds
               , A.change_reason         = B.chg_rsn_nm
               , A.description           = B.rmk
               , A.dh_lod_date           = B.dh_lod_ts
               , A.dh_mdf_date           = B.dh_mdf_ts
               , A.last_update_date      = B.last_update_date
               , A.last_updated_by       = B.last_updated_by
                          
          WHEN NOT MATCHED THEN
          INSERT (
                        yyyymm, yyyyq, division_id, plant_id, item_id
                      , rmph_div_code, rmph_div_name, plnt_area_div_code, plnt_area_div_name, wkpc_grp_code, wkpc_grp_name
                      , rep_cust_code, rep_cust_name, stk_mng_mtrl_grp_code, stk_mng_mtrl_grp_name
                      , total_yn, seq
                      , gro_std_dio, min_std_dio, cycl_std_dio, trnsp_std_dio, wkpc_std_dio, sft_std_dio, etc_std_dio
                      , change_reason, description, dh_lod_date, dh_mdf_date
                      , created_by, creation_date, last_updated_by, last_update_date      
                 )
          VALUES (
                        B.std_ym, B.yrqt, B.prdcls_cd, B.plnt_cd, B.mtrl_cd
                      , B.rmph_div_cd, B.rmph_div_nm, B.plnt_area_div_cd, B.plnt_area_div_nm, B.wkpc_grp_cd, B.wkpc_grp_nm        
                      , B.rep_cust_cd, B.rep_cust_nm, B.stk_mng_mtrl_grp_cd, B.stk_mng_mtrl_grp_nm
                      , B.tot_yn, B.seq                
                      , B.gro_std_dio_ds, B.min_std_dio_ds, B.cycl_std_dio_ds, B.trnsp_std_dio_ds, B.wkpc_std_dio_ds, B.sft_std_dio_ds, B.etc_std_dio_ds
                      , B.chg_rsn_nm, B.rmk, B.dh_lod_ts, B.dh_mdf_ts
                      , B.created_by,      B.creation_date, B.last_updated_by, B.last_update_date
                 )
          ;

          -----------------------------------------------------------
          -- Merge LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'APPEND';
          SET @v_log_message = '3. MERGE INTO scp_mst_dio';
          SET @v_description = 'BDP SCP DIO Merge ';
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------

      END	 
    
      -- 인터페이스 테이블 처리 ROW UPDATE
      UPDATE xif_bdp_dio_r_sn 
      SET    transfer_flag             = 'Y'
      WHERE  ISNULL(transfer_flag,'N') = 'P';  

      UPDATE xif_bdp_mat_map_mst_r_sn 
      SET    transfer_flag             = 'Y'
      WHERE  ISNULL(transfer_flag,'N') = 'P';  


      IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;

    END
    --COMMIT TRANSACTION
  END TRY

  BEGIN CATCH
    IF @@TRANCOUNT > 0
      BEGIN
        ROLLBACK;
      END;
    -- ERROR LOG
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END CATCH;

  -- 종료 LOG
  SET @v_log_type    = 'END';
  SET @v_log_message = '########## END of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  ----------------------------------------------------------------------------------------------------------------------
  -- IF 정보 삭제 : Start
  ----------------------------------------------------------------------------------------------------------------------
  
  -- 분기별 정보이므로 IF된지 6개월 이상된 Data 삭제
  DELETE xif_bdp_dio_r_sn 
  WHERE  transfer_flag  = 'Y'
  AND    transfer_date <= dateadd(D, -26*7, getdate())
  ;  
  
  -- IF된지 10주 이상된 Data 삭제
  DELETE xif_bdp_mat_map_mst_r_sn 
  WHERE  transfer_flag  = 'Y'
  AND    transfer_date <= dateadd(D, -10*7, getdate())
  ;  

  ----------------------------------------------------------------------------------------------------------------------
  -- IF 정보 삭제 : End
  ----------------------------------------------------------------------------------------------------------------------

END;
