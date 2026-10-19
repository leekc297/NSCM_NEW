



/*
 * Program ID   : SCP0083_GET_DIO_AGING_LT
 * Description  : DIO AGING LT
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/12/28   hyerakim 			Query
 * 2021/12/28   vadabi3 			Initial Release
 ----------------------------------------------------------------------------------------------------
EXEC SCP0083_GET_DIO_AGING_LT @p_division_id ='81'
                            , @p_plan_start_yyyymmdd = '20220815'
							, @p_plan_type = 'FN'
							, @p_seq = '1'
							, @p_ver = '1'
							, @p_nick_name = N'E60A'
*/

CREATE PROCEDURE [dbo].[SCP0083_GET_DIO_AGING_LT]
    @p_division_id          NVARCHAR(30),--chaan
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type			NVARCHAR(5),
	@p_seq					NVARCHAR(2),
	@p_nick_name			NVARCHAR(50),
	--@p_plant_id				NVARCHAR(30),
	--@p_operation_group		NVARCHAR(10),
	--@p_from_site			NVARCHAR(max),
	--@p_to_site				NVARCHAR(max),
 	@p_ver					INT,
	@debug_mode				NVARCHAR(1) = 'T'

AS
BEGIN
    
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF

			----------------------------------------------------------------------------------------------------
			/*
			declare @P_DIVISION_ID		         	NVARCHAR(30) = '81' ; 
			declare @P_PLAN_START_YYYYMMDD			NVARCHAR(8)= '20220815' ; 
			declare	@P_PLAN_TYPE                    NVARCHAR(50) = 'FN' ;
			declare	@P_SEQ                     		NVARCHAR(8) = '1' ;
			declare @P_VER int						= 1; 
			declare @P_nick_name					nvarchar(60) = N'E60A' --  N'E76A' -- N'개발'  -- 'F2-1' --  N'개발' -- 'P2.7' -- 'LV15B' -- 'LV15A' -- 'F2' -- 'E76A' -- 'E64B' -- 'E63F' -- 'E61D' -- 'E60A' -- 'A7' -- 'H5.5A' -- 'F2-1' ; -- 'E54M' ;  -- 'E54M' -- 'E51_ESNB' -- 'F2-1' ; 
			*/
			---------------------------------------------------------------------------------------------------- 
			;WITH BASE_DATA AS (
			SELECT 
				   A.COMPANY_ID
				  ,A.DIVISION_ID
				  ,A.SITE_ID
				  ,A.NICK_NAME
				  ,A.LINE_ID
				  ,A.ITEM_ID
				  ,A.PLANT_ID
				  ,A.OPERATION_ID
				  ,A.FACTORY_ID 
				  ,A.CELL_AGING_LT	   
				  ,A.LINE_AVG_AGING_LT 
				  ,A.TOTAL  
				  ,A.M1	  ,A.M2	  ,A.M3	  ,A.M4	  ,A.M5	  ,A.M6
				  ,A.M7	  ,A.M8	  ,A.M9	  ,A.M10  ,A.M11  ,A.M12
				  ,SUM(TOTAL) OVER (PARTITION BY A.NICK_NAME) AS TOTAL_SUM 
			 FROM SCP_ANL_DIO_REPORT_DETAIL_AGING A WITH(NOLOCK)
			WHERE 1=1
			  AND A.DIVISION_ID			= @P_DIVISION_ID
			  AND A.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
			  AND A.PLAN_TYPE			= @P_PLAN_TYPE
			  AND A.SEQ					= @P_SEQ
			  AND A.VER					= @P_VER
			  AND A.NICK_NAME			= @P_NICK_NAME
			)
			,FDATA AS (
				SELECT BD.*
					  ,AVG(CASE WHEN FACTORY_ID = '' 
								THEN NULL 
								ELSE CELL_AGING_LT END)  
								OVER (PARTITION BY NICK_NAME) 											    AS NICKNAME_AVG_AGING_LT
					  ,CASE WHEN BD.TOTAL_SUM = 0 THEN 0 ELSE TOTAL / TOTAL_SUM							END AS RATIO
					  ,CASE WHEN BD.TOTAL_SUM = 0 THEN 0 ELSE TOTAL / TOTAL_SUM * LINE_AVG_AGING_LT 	END AS AGING_LT
					  ,CASE WHEN BD.TOTAL_SUM = 0 THEN 0 ELSE TOTAL / TOTAL_SUM							END
					   * 
					   AVG(CASE WHEN FACTORY_ID = '' 
								THEN NULL 
								ELSE CELL_AGING_LT END)  
								OVER (PARTITION BY NICK_NAME) 											AS AGING_LT_N
					  ,SUM(CASE WHEN BD.TOTAL_SUM = 0 
								THEN 0 
								ELSE TOTAL / TOTAL_SUM * LINE_AVG_AGING_LT END)
								OVER (PARTITION BY NICK_NAME)											AS AGING_LT_NICKNAME_SUM
				  FROM BASE_DATA BD
			)
			,LINE_NAME_INFO AS ( 
				SELECT L.COMPANY_ID
					  ,L.DIVISION_ID
					  ,L.SITE_ID
					  ,L.PLANT_ID
					  ,L.OPERATION_ID
					  ,L.LINE_ID
					  ,L.LINE_NAME 
					  ,ROW_NUMBER() OVER (PARTITION BY L.COMPANY_ID
													  ,L.DIVISION_ID
													  ,L.SITE_ID
													  ,L.PLANT_ID
													  ,L.OPERATION_ID
													  ,L.LINE_ID
											  ORDER BY CASE WHEN L.ACTIVE_FLAG = 'Y' THEN 1 ELSE 2 END 
													  ,L.LINE_NAME
													  ,L.ELECTRODE_TYPE
													  )	AS LINE_NAME_PRIORITY 
				 FROM SCM_MST_LINE_SN L WITH(NOLOCK)
				WHERE 1=1
			)
			SELECT F.COMPANY_ID
				  ,F.SITE_ID
				  ,F.PLANT_ID
				  ,P.PLANT_NAME		-- Plant Site 
				  ,F.FACTORY_ID		-- Bld.
				  ,F.LINE_ID
				  ,ISNULL(L.LINE_NAME, F.LINE_ID) AS LINE_NAME 	-- Line Name (값이 없으면 line_id로 ?) 
				  ,F.ITEM_ID		-- Material 
				  ,F.NICK_NAME
				  ,CASE WHEN ISNULL(F.OPERATION_ID, '') = '' 
						THEN IM.FLOW_ID 
						ELSE F.OPERATION_ID 
					END AS OPERATION_ID  -- Oper.
				  ,CASE WHEN IM.SCP_OPERATION_GROUP = 'A' THEN 'Cell'
						WHEN IM.SCP_OPERATION_GROUP = 'P' THEN 'Pack'
						ELSE IM.SCP_OPERATION_GROUP
				   END  AS ITEM_TYPE
				  ,F.CELL_AGING_LT	AS AGING_LT			--- Aging L/T 
				  ,F.LINE_AVG_AGING_LT	AS AGING_LT_LINE_AVG -- 20220823 추가
				  ,CASE WHEN F.AGING_LT_NICKNAME_SUM = 0
						THEN F.NICKNAME_AVG_AGING_LT    --- production이 없는 경우 nickname별로 avg aging lt 적용됨. 
						ELSE F.LINE_AVG_AGING_LT	    --- Aging L/T (실제 적용 Aging L/T - line단위 avg가 적용됨) -> ui항목에 추가 (line은 존재하고 item이 없는 경우도 적용을 위해?)
					END AS APPLY_AGING_LT			    --- Aging L/T(Aplly)	 실제적용 aging LT -> ui 설계서에는 없으나 추가 필요 !! 
				  ,Y.YIELD
				  ,S.SHORTER_LT
				  ,F.TOTAL								-- SUM(M1+~M12)
				  ,F.RATIO
				  ,CASE WHEN F.AGING_LT_NICKNAME_SUM = 0
						THEN F.AGING_LT_N
						ELSE F.AGING_LT
					END AS 	AGING_LT_RATIO				-- Aging L/T(적용) * Ratio
				  ,F.M1	  ,F.M2	  ,F.M3	  ,F.M4	  ,F.M5	  ,F.M6
				  ,F.M7	  ,F.M8	  ,F.M9	  ,F.M10  ,F.M11  ,F.M12
			 FROM FDATA F
				  LEFT JOIN SCM_MST_ITEM_SN IM WITH(NOLOCK)
						 ON IM.ITEM_ID		= F.ITEM_ID
						AND IM.COMPANY_ID	= F.COMPANY_ID
						AND IM.DIVISION_ID	= F.DIVISION_ID
						AND IM.SITE_ID		= F.SITE_ID
				  LEFT JOIN SCM_MST_PLANT_SN P WITH(NOLOCK)
						 ON P.COMPANY_ID	= F.COMPANY_ID
						AND P.DIVISION_ID	= F.DIVISION_ID
						AND P.SITE_ID		= F.SITE_ID
						AND P.PLANT_ID		= F.PLANT_ID
				  LEFT JOIN LINE_NAME_INFO L WITH(NOLOCK)
						 ON L.COMPANY_ID	  = F.COMPANY_ID
						AND L.DIVISION_ID	  = F.DIVISION_ID
						AND L.SITE_ID		  = F.SITE_ID
						AND L.PLANT_ID		  = F.PLANT_ID
						AND L.OPERATION_ID	  = CASE WHEN ISNULL(F.OPERATION_ID, '') = '' 
													 THEN IM.FLOW_ID 
													 ELSE F.OPERATION_ID 
												 END
						AND L.LINE_ID		  = F.LINE_ID
						AND L.LINE_NAME_PRIORITY = 1 
				  LEFT OUTER HASH JOIN SCM_MST_YIELD_SN Y WITH(NOLOCK)
						 ON  Y.COMPANY_ID   =  F.COMPANY_ID  
						AND  Y.DIVISION_ID  =  F.DIVISION_ID 
						AND  Y.SITE_ID      =  F.SITE_ID     
						AND  Y.PLANT_ID     =  F.PLANT_ID    
						AND  Y.FACTORY_ID   =  F.FACTORY_ID  
						AND  Y.OPERATION_ID =  F.OPERATION_ID
						AND  Y.LINE_ID      =  F.LINE_ID     
						AND  Y.ITEM_ID      =  F.ITEM_ID     
						AND  Y.MONTH        = SUBSTRING(@P_PLAN_START_YYYYMMDD, 1, 6)  
				  LEFT OUTER HASH JOIN FP_FORMATION_SHORTER_LT_M_SN S WITH(NOLOCK) 
						 ON  S.COMPANY_ID   =  F.COMPANY_ID  
						AND  S.DIVISION_ID  =  F.DIVISION_ID 
						AND  S.SITE_ID      =  F.SITE_ID     
						AND  S.PLANT_ID     =  F.PLANT_ID    
						AND  S.FACTORY_ID   =  F.FACTORY_ID  
						AND  S.OPERATION_ID =  F.OPERATION_ID
						AND  S.LINE_ID      =  F.LINE_ID     
						AND  S.ITEM_ID      =  F.ITEM_ID  
			WHERE 1=1
			ORDER BY P.PLANT_NAME
					,F.LINE_ID



	SELECT TOP 1
		   CONVERT(CHAR(7), DATEADD(MONTH,  1, @p_plan_start_yyyymmdd ), 23)	AS M1
		 , CONVERT(CHAR(7), DATEADD(MONTH,  2, @p_plan_start_yyyymmdd ), 23)	AS M2
		 , CONVERT(CHAR(7), DATEADD(MONTH,  3, @p_plan_start_yyyymmdd ), 23)	AS M3
		 , CONVERT(CHAR(7), DATEADD(MONTH,  4, @p_plan_start_yyyymmdd ), 23)	AS M4
		 , CONVERT(CHAR(7), DATEADD(MONTH,  5, @p_plan_start_yyyymmdd ), 23)	AS M5
		 , CONVERT(CHAR(7), DATEADD(MONTH,  6, @p_plan_start_yyyymmdd ), 23)	AS M6
		 , CONVERT(CHAR(7), DATEADD(MONTH,  7, @p_plan_start_yyyymmdd ), 23)	AS M7
		 , CONVERT(CHAR(7), DATEADD(MONTH,  8, @p_plan_start_yyyymmdd ), 23)	AS M8
		 , CONVERT(CHAR(7), DATEADD(MONTH,  9, @p_plan_start_yyyymmdd ), 23)	AS M9
		 , CONVERT(CHAR(7), DATEADD(MONTH, 10, @p_plan_start_yyyymmdd ), 23)	AS M10
		 , CONVERT(CHAR(7), DATEADD(MONTH, 11, @p_plan_start_yyyymmdd ), 23)	AS M11
		 , CONVERT(CHAR(7), DATEADD(MONTH, 12, @p_plan_start_yyyymmdd ), 23)	AS M12
		 , DATA_RANGE															AS DATA_RANGE
	  FROM SCP_ANL_DIO_REPORT_DETAIL WITH(NOLOCK)
	 WHERE PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
	   AND DIVISION_ID			= @p_division_id
	   AND PLAN_TYPE			= @p_plan_type
	   AND SEQ					= @p_seq 
	   AND VER					= @p_ver
	   AND NICK_NAME			= @p_nick_name


END


