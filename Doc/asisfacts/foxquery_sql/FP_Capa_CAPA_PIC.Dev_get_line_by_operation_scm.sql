--BEGIN
		    --    BEGIN TRAN
		    
			  SELECT 
				DISTINCT 
					 A.LINE_ID						  AS CODE
					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME
					,A.OPERATION_ID
					,B.SCM_SITE_ID AS SITE_ID
					,A.DIVISION_ID AS DIVISION_ID
					,A.PLANT_ID AS PLANT_ID
					,A.FACTORY_ID AS FACTORY_ID
					--,A.OPERATION_ID AS OPERATION_ID
				FROM [dbo].SCM_MST_LINE_SN A  WITH(NOLOCK) 
				JOIN [dbo].SCM_MST_SITE B  WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID
				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1
								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND    b.valid_yn    = 'Y'
								AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
							) f ON a.operation_id = f.segment4 --AND c.operation_group_id = f.segment3 -- operation group id 에 추가된 operation 만보이도록
				WHERE 1=1
				AND A.ACTIVE_FLAG ='Y'
				AND ( (@DIVISION_ID IS NULL OR @DIVISION_ID ='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@DIVISION_ID,',')) )
				AND ( (@PLANT_ID IS NULL OR @PLANT_ID ='') OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(SUBSTRING(@PLANT_ID,1,4),','))   )
				AND ( (@FACTORY_ID IS NULL OR @FACTORY_ID ='') OR A.FACTORY_ID IN ( SELECT token FROM dbo.String_Split(@FACTORY_ID,','))   )
				AND ( (@OPERATION_ID IS NULL OR @OPERATION_ID ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@OPERATION_ID,','))   )
				AND ( (@SITE_ID IS NULL OR @SITE_ID ='') OR B.SCM_SITE_ID IN ( SELECT token FROM dbo.String_Split(@SITE_ID,','))   )
				UNION
				SELECT 
					'-'  AS CODE
					,'-'  AS NAME
					,'-'  AS OPERATION_ID
					,'-'  AS SCM_SITE_ID
															,'-' AS DIVISION_ID
					,'-' AS PLANT_ID
					,'-' AS FACTORY_ID
					--,'-' AS OPERATION_ID
				ORDER BY NAME   
   		      --  COMMIT;
		     -- END;