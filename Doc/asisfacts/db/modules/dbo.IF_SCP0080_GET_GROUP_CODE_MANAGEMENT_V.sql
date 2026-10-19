


CREATE VIEW [dbo].[IF_SCP0080_GET_GROUP_CODE_MANAGEMENT_V]
AS
/*=====================================================================================================
 * VIEW NAME     : IF_SCP0080_GET_GROUP_CODE_MANAGEMENT_V
 * DESCRIPTION   : Master > SCP Master > Model Code Master(SCP0080) 데이터 제공(표준리포트 제공용)
 * PROGRAM HISTORY
 *=====================================================================================================
 *  DATE        IN CHARGE			DESCRIPTION
 *=====================================================================================================
 * 2025.12.04	park.choyi          [E20251105-001148]Initial Release.
=====================================================================================================*/

    --40 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , SCP_EXTRA_SPEC	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , NULL                    AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , NULL            	    AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , CELL_TYPE_GROUP_NAME	AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , BASIC_NICKNAME_CELL40	AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , NICKNAME_40	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , GROUP_CODE9	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '40'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )
    UNION ALL
    --82 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , NULL          	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , GROUP_CODE5             AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , LEVEL2_CODE	            AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , GROUP_CODE6	            AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , GROUP_CODE7	            AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , GROUP_CODE4	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , NULL    	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '82'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )
    UNION ALL
    --81 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , NULL          	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , NULL                    AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , CELL_MODEL_NICKNAME     AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , GROUP_CODE6	            AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , GROUP_CODE7	            AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , GROUP_CODE5	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , NULL      	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '81'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )
    UNION ALL
    --81_HD 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , NULL          	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , NULL                    AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , CELL_MODEL_NICKNAME     AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , GROUP_CODE6	            AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , GROUP_CODE7	            AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , GROUP_CODE5	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , NULL      	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '81_HD'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )
    UNION ALL
    --81_HG 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , NULL          	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , NULL                    AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , CELL_MODEL_NICKNAME     AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , GROUP_CODE6	            AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , GROUP_CODE7	            AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , GROUP_CODE5	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , NULL      	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '81_HG'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )
    UNION ALL
    --81_HM 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , NULL          	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , NULL                    AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , CELL_MODEL_NICKNAME     AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , GROUP_CODE6	            AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , GROUP_CODE7	            AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , GROUP_CODE5	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , NULL      	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '81_HM'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )
    UNION ALL
    --81_ST 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , NULL          	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , NULL                    AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , CELL_MODEL_NICKNAME     AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , GROUP_CODE6	            AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , GROUP_CODE7	            AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , GROUP_CODE5	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , NULL      	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '81_ST'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )
    UNION ALL
    --81_UC 사업부
    SELECT  DIVISION_ID             AS DIVISION_ID
          , OPERATION_ID            AS OPERATION_ID
          , BIZ_TYPE	            AS MODEL_TYPE           --Model Type
          , ITEM_ID                 AS PRODUCTION_MODEL     --[Model]Production Model
          , NICK_NAME               AS NICK_NAME            --[Model]NickName
          , ITEM_ID_ASSY	        AS ASSY_CODE            --[Model]Assy Code
          , NULL          	        AS EXTRA_SPEC           --[Manage Code]Extra spec(40사업부 전용)
          , NULL                    AS APPLICATION          --[Manage Code]Application(82사업부 전용)
          , CELL_MODEL_NICKNAME     AS CELL_NICK_NAME       --[Manage Code]Cell Nickname(40사업부 제외)
          , GROUP_CODE6	            AS PRODUCT_LEVEL1       --[Manage Code]Product level1
          , GROUP_CODE7	            AS PRODUCT_LEVEL2       --[Manage Code]Product level2
          , GROUP_CODE5	            AS PRODUCT_LEVEL3       --[Manage Code]Product level3
          , NULL      	            AS PRODUCT_LEVEL4       --[Manage Code]Product level4(40사업부 전용)
    FROM    DBO.FN_SCP0080_GET_GROUP_CODE_MANAGEMENT_TABLE
            (
                  '81_UC'              --@p_division_id
                , ''                --@p_operation_id
                , ''                --@p_model_id
                , ''                --@p_nickname
                , 'N'               --@p_check_fcst
                , 'N'               --@p_check_production
                , 'N'               --@p_check_active
                , 'N'               --@p_check_bom
                , 'IF_GDW'          --@p_user_id
                , 'F'               --@debug_mode
            )


