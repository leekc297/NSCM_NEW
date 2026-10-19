BEGIN
  		  BEGIN TRAN
          UPDATE SCM_ITEM_M SET
                 UPDATE_ID 		    = @USER_ID
                ,UPDATE_TIME 	    = DBO.SYSDATE1()
                ,DEMAND_LOT_SIZE  = @DEMAND_LOT_SIZE
                ,ITEM_ATTRIBUTE   = @ITEM_ATTRIBUTE
                ,SETUP_ATTRIBUTE  = @SETUP_ATTRIBUTE
                ,FORM_ATTRIBUTE   = @FORM_ATTRIBUTE
                ,SCP_EXTRA_SPEC   = @SCP_EXTRA_SPEC
                ,FP_EXTRA_SPEC    = @FP_EXTRA_SPEC
          WHERE  COMPANY_ID	      = @COMPANY_ID
          AND    DIVISION_ID	    = @DIVISION_ID
          AND    SITE_ID			    = @SITE_ID
          AND    ITEM_ID			    = @ITEM_ID
    			;
  			
  			COMMIT;
  			
        BEGIN TRAN
          INSERT INTO HIS_ITEM_M (
                 COMPANY_ID, DIVISION_ID, SITE_ID
                ,ITEM_ID, ITEM_NAME, NICK_NAME
                ,ITEM_TYPE
                ,ITEM_CLASS, ITEM_CLASS_NAME
                ,MATERIAL_CLASS, MATERIAL_CLASS_NAME
                ,ELECTRODE_TYPE, SIDE_TYPE, ITEM_GROUP_ID
                ,SETUP_GROUP_ID_1, SETUP_GROUP_ID_2, SETUP_GROUP_ID_3
                ,FLOW_ID
                ,ERP_EOL, SCP_EOL
                ,ITEM_UOM, SPEC, DEMAND_LOT_SIZE
                ,ITEM_ATTRIBUTE, SETUP_ATTRIBUTE
                ,OUTSOURCING_FACTORY
                ,FINITE_TERM, FINITE_TERM_UOM
                ,DESCRIPTION, ACTIVE_FLAG
                ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                ,JOB_USER_ID,JOB_TIME,JOB_TYPE
				        ,BATCH_RATIO_ID
				        ,FORM_ATTRIBUTE
				        ,SCP_EXTRA_SPEC
				        ,FP_EXTRA_SPEC
          )
          SELECT COMPANY_ID, DIVISION_ID, SITE_ID
                ,ITEM_ID, ITEM_NAME, NICK_NAME
                ,ITEM_TYPE
                ,ITEM_CLASS, ITEM_CLASS_NAME
                ,MATERIAL_CLASS, MATERIAL_CLASS_NAME
                ,ELECTRODE_TYPE, SIDE_TYPE, ITEM_GROUP_ID
                ,SETUP_GROUP_ID_1, SETUP_GROUP_ID_2, SETUP_GROUP_ID_3
                ,FLOW_ID
                ,ERP_EOL, SCP_EOL
                ,ITEM_UOM, SPEC, DEMAND_LOT_SIZE
                ,ITEM_ATTRIBUTE, SETUP_ATTRIBUTE
                ,OUTSOURCING_FACTORY
                ,FINITE_TERM, FINITE_TERM_UOM
                ,DESCRIPTION, ACTIVE_FLAG
                ,INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME
                ,@USER_ID as JOB_USER_ID,dbo.sysdate1() as JOB_TIME,'UPDATE' as JOB_TYPE
				        ,BATCH_RATIO_ID
				        ,FORM_ATTRIBUTE
				        ,SCP_EXTRA_SPEC
				        ,FP_EXTRA_SPEC
          FROM   SCM_ITEM_M A WITH(NOLOCK)
          WHERE  A.COMPANY_ID  = @COMPANY_ID
          AND    A.DIVISION_ID = @DIVISION_ID
          AND    A.SITE_ID     = @SITE_ID
          AND    A.ITEM_ID     = @ITEM_ID
          ;
        
        COMMIT;
  			
  		END;