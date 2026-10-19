

/*================================================================================================================================================================================
 * Program ID   : [SCM0002_GET_MATERIAL_BY_DIVISION]
 * Description  : 기존 Model 조회용 팝업을 Material 조회용으로 변경하면서 분리
 * Program History
 *================================================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================================================
 * 2023/09/05   chaan                               Initial Release                                                    - Model을 Material 로 바꾸면서 SCP 전용으로 분리
 * 2023/09/11   chaan		            V1.1.1      PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2            - Operation Group 예외처리
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


--CREATE PROCEDURE [dbo].[SCM0002_GET_MATERIAL_BY_DIVISION]
CREATE PROCEDURE [dbo].[SCM0002_GET_MATERIAL_BY_DIVISION]
      @p_division_id                NVARCHAR(30)
    , @p_operation_group	        NVARCHAR(MAX)
    , @p_item_id                    NVARCHAR(50)
    , @p_scp_module_type            NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

    --SCP0011_ProductionPlan
    --SCP0012_PSI
    --SCP0013_ProductionPlanLine
    --SCP0014_Problem_Report
    --SCP0017_WaterfallProductionPlan
    --SCP0024_ProductionPlanFix
    --SCP0031_GlobalPSI
    --SCP0034_PSI_Electrode
    --SCP0038_GlobalPSI_small
    --SCP0044_GlobalPSI_ESS
    --SCP0051_ProductionPlanTarget
    --SCP0022_Formation
    --SCP0037_OperationLT
    --SCP0040_CharacteristicCapacity
    --SCP0046_ModelAllocation
    --SCP0085_EndingInventory



    --DECLARE @p_division_id                NVARCHAR(30)      = N'81';
    --DECLARE @p_operation_group	          NVARCHAR(MAX)     = N'';
    --DECLARE @p_item_id                    NVARCHAR(50)      = N'';
    --DECLARE @p_scp_module_type            NVARCHAR(50)      = N'SCP0022';


    IF  @p_operation_group IS NULL OR @p_operation_group = ''
    BEGIN
        SET @p_operation_group = 'ALL';
    END

    IF         @p_scp_module_type = 'SCP0022'--SCP0022_Formation
            OR @p_scp_module_type = 'SCP0040'--SCP0040_CharacteristicCapacity
            OR @p_scp_module_type = 'SCP0046'--SCP0046_ModelAllocation
    BEGIN
        SET @p_operation_group = 'A';
    END

    PRINT CONCAT('@p_scp_module_type : ', @p_scp_module_type);

    IF         @p_scp_module_type = 'SCP0011'--SCP0011_ProductionPlan
            OR @p_scp_module_type = 'SCP0013'--SCP0013_ProductionPlanLine
            OR @p_scp_module_type = 'SCP0017'--SCP0017_WaterfallProductionPlan
            OR @p_scp_module_type = 'SCP0022'--SCP0022_Formation
            OR @p_scp_module_type = 'SCP0024'--SCP0024_ProductionPlanFix
            OR @p_scp_module_type = 'SCP0040'--SCP0040_CharacteristicCapacity
            OR @p_scp_module_type = 'SCP0046'--SCP0046_ModelAllocation

    BEGIN
        PRINT N'--Operation Group = ''A'' 일때 ATTRIBUTE8 가 CA% 만 표시--------------------------------------------------------------------------------';

	    SELECT DISTINCT
			      D.DIVISION_ID
			    , D.DIVISION_NAME
			    , I.ITEM_ID
			    , T.ITEM_NAME
			    , T.NICK_NAME
			    , T.ITEM_CLASS_NAME
--test original columns begin--------------------------------------------------
			    --, I.OPERATION_GROUP
			    --, I.ATTRIBUTE8
--test original columns end----------------------------------------------------
	    FROM	[dbo].[SCP_MST_FINAL_ITEM] I WITH(NOLOCK)
			    JOIN [SCM_MST_DIVISION] D WITH(NOLOCK) ON
					    I.DIVISION_ID  = D.DIVISION_ID
			    JOIN [SCM_MST_ITEM_SN] T WITH(NOLOCK) ON
					    I.DIVISION_ID  = T.DIVISION_ID
				    AND I.ITEM_ID      = T.ITEM_ID
	    WHERE	1=1
		    AND CASE WHEN @p_division_id     = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID     END IN (SELECT token FROM dbo.String_Split(@p_division_id      ,','))
		    AND CASE WHEN @p_operation_group = 'ALL' THEN 'ALL' ELSE I.OPERATION_GROUP END IN (SELECT token FROM dbo.String_Split(@p_operation_group  ,','))
		    AND CASE 
                    WHEN I.OPERATION_GROUP = 'A' AND I.ATTRIBUTE8 LIKE 'CA%' THEN 1
                    WHEN I.OPERATION_GROUP <> 'A' THEN 1
                    ELSE 0
                END = 1
		    AND (      I.ITEM_ID   LIKE '%' + @p_item_id + '%'
				    OR T.ITEM_NAME LIKE '%' + @p_item_id + '%'
				    OR T.NICK_NAME LIKE '%' + @p_item_id + '%'
			    )
	    ORDER BY D.DIVISION_ID, I.ITEM_ID, T.ITEM_NAME;
    END
    ELSE
    BEGIN
        IF     @p_scp_module_type = 'SCP0014'--SCP0014_Problem_Report
            OR @p_scp_module_type = 'SCP0031'--SCP0031_GlobalPSI
            OR @p_scp_module_type = 'SCP0037'--SCP0037_OperationLT
            OR @p_scp_module_type = 'SCP0038'--SCP0038_GlobalPSI_small
            OR @p_scp_module_type = 'SCP0044'--SCP0044_GlobalPSI_ESS
            OR @p_scp_module_type = 'SCP0051'--SCP0051_ProductionPlanTarget
            OR @p_scp_module_type = 'SCP0085'--SCP0085_EndingInventory
        BEGIN
            PRINT N'--Operation Group 고정(A,P,E)--------------------------------------------------------------------------------';

            SET @p_operation_group = 'A,P,E';
        END

        PRINT N'--선택한 Operation Group 기준--------------------------------------------------------------------------------';

	    SELECT DISTINCT
			      D.DIVISION_ID
			    , D.DIVISION_NAME
			    , I.ITEM_ID
			    , T.ITEM_NAME
			    , T.NICK_NAME
			    , T.ITEM_CLASS_NAME
--test original columns begin--------------------------------------------------
			    --, I.OPERATION_GROUP
			    --, I.ATTRIBUTE8
--test original columns end----------------------------------------------------
	    FROM	[dbo].[SCP_MST_FINAL_ITEM] I WITH(NOLOCK)
			    JOIN [SCM_MST_DIVISION] D WITH(NOLOCK) ON
					    I.DIVISION_ID  = D.DIVISION_ID
			    JOIN [SCM_MST_ITEM_SN] T WITH(NOLOCK) ON
					    I.DIVISION_ID  = T.DIVISION_ID
				    AND I.ITEM_ID      = T.ITEM_ID
	    WHERE	1=1
		    AND CASE WHEN @p_division_id     = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID     END IN (SELECT token FROM dbo.String_Split(@p_division_id      ,','))
		    AND CASE WHEN @p_operation_group = 'ALL' THEN 'ALL' ELSE I.OPERATION_GROUP END IN (SELECT token FROM dbo.String_Split(@p_operation_group  ,','))
		    AND (      I.ITEM_ID   LIKE '%' + @p_item_id + '%'
				    OR T.ITEM_NAME LIKE '%' + @p_item_id + '%'
				    OR T.NICK_NAME LIKE '%' + @p_item_id + '%'
			    )
	    ORDER BY D.DIVISION_ID, I.ITEM_ID, T.ITEM_NAME;
    END
END