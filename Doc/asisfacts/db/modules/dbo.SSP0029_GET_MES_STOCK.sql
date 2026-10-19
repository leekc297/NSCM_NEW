
/*
 * Program ID   : SSP0029_GET_MES_STOCK
 * Description  : MES Stock
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022.09.01   SSP Pjt. 	    Created.
 *
 */

CREATE PROCEDURE [dbo].[SSP0029_GET_MES_STOCK]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_lot_id				NVARCHAR(MAX)
	,@p_myModelChk			NVARCHAR(MAX)
	,@p_partLeaderChk		NVARCHAR(MAX)
	,@p_teamLeaderChk		NVARCHAR(MAX)
	,@p_delegateeChk		NVARCHAR(MAX)
	,@p_nonChk				NVARCHAR(MAX)
	,@p_language			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	declare @v_division_id			nvarchar(100);
	declare @v_from_site			nvarchar(100);
	declare @v_plan_start_yyyymmdd	nvarchar(100);
	declare @v_item_id			    nvarchar(100);	
	declare @v_user_id				nvarchar(100);
	declare @v_lot_id				nvarchar(100);
	declare @v_myModelChk			nvarchar(100);
	declare @v_partLeaderChk		nvarchar(100);
	declare @v_teamLeaderChk		nvarchar(100);
	declare @v_delegateeChk			nvarchar(100);
	declare @v_nonChk				nvarchar(100);
	declare @v_language				nvarchar(100);

	set @v_division_id			= @p_division_id;
	set @v_from_site			= @p_from_site;
	set @v_plan_start_yyyymmdd  = @p_plan_start_yyyymmdd;
	set @v_item_id		        = @p_item_id;			    	    
	set @v_user_id				= @p_user_id;				
	set @v_lot_id				= @p_lot_id;			
	set @v_myModelChk			= @p_myModelChk;			
	set @v_partLeaderChk		= @p_partLeaderChk;		
	set @v_teamLeaderChk		= @p_teamLeaderChk;		
	set @v_delegateeChk			= @p_delegateeChk;			
	set @v_nonChk				= @p_nonChk;				
	set @v_language				= @p_language;				






	SELECT * 
	  FROM (
	 	   SELECT ROW_NUMBER() OVER(PARTITION BY T1.DIVISION_ID,T1.FROM_SITE,T1.ITEM_ID,T1.LOT_ID ORDER BY T1.LOT_TYPE DESC,T1.MES_CHANGE_STATUS DESC) AS ROWNUM
		        , T1.DIVISION_ID
			    , T1.FROM_SITE
			    , T1.ITEM_ID
			    , T1.NICK_NAME
			    , T1.LOT_ID
			    , T1.YYYYMMDD_LOT_ID_APPLIED_LT
			    , T1.MES_CHANGE_STATUS
			    , T1.LOT_TYPE
			    , T1.LOT_QTY_MES
			    , T1.LOT_QTY_MES_NG
			    , T1.LOT_QTY_FCS
		        , T1.FCS_SPECIAL_QTY
		        , T1.OWMS_STOCK_QTY
		        , T1.LOT_QTY_TOT
			    , T1.AVAILABLE_YN
			    , T1.MES_HOLD_YN
			    , T1.QMS_HOLD_YN
			    , T1.FCS_HOLD_YN
			    , T1.LONGTERM_HOLD_YN
			    , T1.JUDG_VLD_DATE
			    , T1.MES_HOLD_RELEASE
			    , T1.QMS_HOLD_RELEASE
			    , T1.USER_MOD_RELEASE_DATE
			    , T1.REMARKS
			    , T1.LAST_UPDATED_BY
			    , T1.LAST_UPDATE_DATE
		     FROM (
			 
			      SELECT
					     X.DIVISION_ID
					   , X.FROM_SITE
					   , X.ITEM_ID
					   , DBO.FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
					   , X.LOT_ID AS LOT_ID
					   , CONVERT(VARCHAR(10), CONVERT(DATE, CONVERT(VARCHAR(8),X.YYYYMMDD_LOT_ID_APPLIED_LT))) AS YYYYMMDD_LOT_ID_APPLIED_LT
					   , X.CHANGE_STATUS AS MES_CHANGE_STATUS
					   , X.LOT_TYPE
					   , X.LOT_QTY_MES
					   , ISNULL(X.ATTRIBUTE4,0)   AS LOT_QTY_MES_NG   -- 불량수량
					   , X.LOT_QTY_FCS
				       , X.FCS_SPECIAL_QTY
				       , X.OWMS_STOCK_QTY
					   , X.LOT_QTY_TOT   AS LOT_QTY_TOT
					   , X.AVAILABLE_YN
					   , X.MES_HOLD_YN
					   , X.QMS_HOLD_YN
					   , X.FCS_HOLD_YN
					   , X.LONGTERM_HOLD_YN
					   , CONVERT(VARCHAR(10),   CONVERT(DATETIME, CASE X.JUDG_VLD_DATE WHEN '-' THEN NULL ELSE X.JUDG_VLD_DATE END,112), 23) AS JUDG_VLD_DATE
					   , CONVERT(VARCHAR(10),   CONVERT(DATETIME, CASE X.MES_HOLD_RELEASE WHEN '-' THEN NULL ELSE X.MES_HOLD_RELEASE END,112), 23) AS MES_HOLD_RELEASE
					   , CONVERT(VARCHAR(10),   CONVERT(DATETIME, CASE X.QMS_HOLD_RELEASE WHEN '-' THEN NULL ELSE X.QMS_HOLD_RELEASE END,112 ), 23) AS QMS_HOLD_RELEASE
					   , CONVERT(VARCHAR(10),   CONVERT(DATETIME, CASE X.USER_MOD_RELEASE_DATE WHEN '' THEN NULL ELSE X.USER_MOD_RELEASE_DATE END ,112), 23) AS USER_MOD_RELEASE_DATE
					   , X.REMARKS
					   , CASE WHEN @v_language = 'KO' THEN U.UserName ELSE U.UserName_E END + '(' + X.LAST_UPDATED_BY + ')' as LAST_UPDATED_BY
					   , X.LAST_UPDATE_DATE
				    FROM SSP_ANL_MES_FCS_STOCK_40_C X WITH(nolock)
						 JOIN SCM_MST_SITE AS FS with(NOLOCK)
					  ON X.DIVISION_ID = FS.DIVISION_ID
					 AND X.FROM_SITE = FS.SCM_SITE_ID
					 AND FS.OPERATION_GROUP = 'P'
					 AND FS.OSP_YN = 'N'
					 AND FS.VALID_YN = 'Y'
				         LEFT OUTER JOIN TB_FX_User U  WITH(NOLOCK)  
					  ON X.LAST_UPDATED_BY = U.UserID 
					 AND U.UseYN = 'Y'
				         LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK)
					  ON M.DIVISION_ID = X.DIVISION_ID
					 AND M.FROM_SITE = X.FROM_SITE
					 AND M.ITEM_ID = X.ITEM_ID
					 AND M.VALID_YN = 'Y'
				   WHERE X.DIVISION_ID = @v_division_id
				     AND X.PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
				     AND X.PLAN_TYPE = 'SP'
				     AND X.SEQ = 1
				     AND ( ( @v_from_site   IS NULL OR @v_from_site ='')  OR X.FROM_SITE IN (SELECT token FROM dbo.String_Split(@v_from_site,',')) )
				     AND ( ( @v_item_id   IS NULL OR @v_item_id ='')  OR X.ITEM_ID IN (SELECT token FROM dbo.String_Split(@v_item_id,',')) )
				     AND ( ( @v_lot_id   IS NULL OR @v_lot_id ='')  OR X.LOT_ID IN (SELECT token FROM dbo.String_Split(@v_lot_id,',')) )
				     ----체크박스 체크 여부 조회 시작(@v_nonChk = 'Y' @ 체크박스 선택 안한 상태)

				     AND ((@v_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @v_myModelChk = 'Y' THEN @v_user_id ELSE 'X' END
													 		           UNION
													 		          SELECT CASE WHEN @v_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END
													 		            FROM SSP_MST_DELEGATE with(nolock) 
													 			       WHERE VALID_YN = 'Y' 
													 			         AND DELEGATEE_ID = @v_user_id 
													 			       GROUP BY USER_ID)
												     OR M.PART_LEADER = CASE WHEN @v_partLeaderChk = 'Y' THEN @v_user_id  ELSE 'X' END
												     OR M.TEAM_LEADER = CASE WHEN @v_teamLeaderChk = 'Y' THEN @v_user_id  ELSE 'X' END))

				   UNION ALL
				   
				  SELECT 
					     A.DIVISION_ID
					   , A.FROM_SITE 
					   , A.ITEM_ID
					   , DBO.FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID ) AS NICK_NAME
					   , SUBSTRING(A.LOT_ID,0,9) AS LOT_ID
					   , NULL   AS YYYYMMDD_LOT_ID_APPLIED_LT
					   , NULL	AS MES_CHANGE_STATUS
					   , NULL	AS LOT_TYPE
					   , 0		AS LOT_QTY_MES
					   , 0		AS LOT_QTY_MES_NG
					   , 0		AS LOT_QTY_FCS
					   , 0		AS FCS_SPECIAL_QTY
					   , SUM(A.STOCK_QTY) AS OWMS_STOCK_QTY
					   , 0		AS LOT_QTY_TOT
					   , '-'	AS AVAILABLE_YN
					   , '-'	AS MES_HOLD_YN
					   , '-'	AS QMS_HOLD_YN
					   , '-'	AS FCS_HOLD_YN
					   , '-'	AS LONGTERM_HOLD_YN
					   , NULL	AS JUDG_VLD_DATE
					   , NULL	AS MES_HOLD_RELEASE
					   , NULL	AS QMS_HOLD_RELEASE
					   , NULL	AS USER_MOD_RELEASE_DATE
					   , NULL	AS REMARKS
					   , NULL	AS LAST_UPDATED_BY
					   , NULL	AS LAST_UPDATE_DATE
				    FROM SSP_ANL_OWMS_STOCK_C A WITH(NOLOCK)
						 JOIN SCM_MST_SITE AS FS with(NOLOCK)
					  ON A.DIVISION_ID = FS.DIVISION_ID
					 AND A.FROM_SITE = FS.SCM_SITE_ID
					 AND FS.OPERATION_GROUP = 'P'
					 AND FS.OSP_YN = 'N'
					 AND FS.VALID_YN = 'Y'
					     LEFT OUTER JOIN SCM_MST_SLOC B 
					  ON B.DIVISION_ID = (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END) 
					 AND B.STORAGE_ID = A.STORAGE_ID 
					 AND B.PLANT_ID = A.PLANT_ID
					     LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
				      ON M.DIVISION_ID = A.DIVISION_ID 
				     AND M.FROM_SITE = A.FROM_SITE 
				     AND M.ITEM_ID = A.ITEM_ID 
				     AND M.VALID_YN = 'Y' 
				   WHERE A.DIVISION_ID = @v_division_id
		             AND A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				     AND ( ( @v_from_site   IS NULL OR @v_from_site ='')  OR A.FROM_SITE IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_from_site,',')) )
				     AND ( ( @v_item_id   IS NULL OR @v_item_id ='')  OR A.ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_item_id,',')) )
				     AND ( ( @v_lot_id   IS NULL OR @v_lot_id ='')  OR A.LOT_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_lot_id,',')) )

				     AND ((@v_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @v_mymodelchk = 'Y' THEN @v_user_id ELSE 'X' END 
																	   UNION 
																	  SELECT CASE WHEN @v_delegateechk = 'Y' THEN USER_ID ELSE 'X' END 
																	    FROM SSP_MST_DELEGATE WITH(NOLOCK) 
																	   WHERE VALID_YN = 'Y' 
																	     AND DELEGATEE_ID = @v_user_id 
																	   GROUP BY USER_ID)
												     OR M.PART_LEADER = CASE WHEN @v_partleaderchk = 'Y' THEN @v_user_id  ELSE 'X' END	
												     OR M.TEAM_LEADER = CASE WHEN @v_teamleaderchk = 'Y' THEN @v_user_id  ELSE 'X' END))

				   GROUP BY 
				        A.DIVISION_ID
					   ,A.ORIGIN_FROM_DIVISION_ID
					   ,A.FROM_SITE 
					   ,A.ITEM_ID
					   ,SUBSTRING(A.LOT_ID,0,9)

		          ) T1
	       ) T2
	 WHERE T2.ROWNUM = 1
	 ORDER BY 
	       T2.DIVISION_ID
		 , T2.ITEM_ID
		 , T2.LOT_ID	
		 , T2.MES_CHANGE_STATUS DESC
	
	 

END
