SELECT DISTINCT A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_GROUP_ID,
					A.OPERATION_ID    AS CODE
					, (A.OPERATION_ID + ' ' + B.OPERATION_NAME)  AS NAME, A.OPERATION_ID
		FROM SCM_LINE_HIERARCHY_V A  WITH(NOLOCK)
		JOIN (SELECT DISTINCT OPERATION_ID , OPERATION_NAME
				FROM SCM_OPERATION_M B  WITH(NOLOCK)
			) B
		ON  A.OPERATION_ID = B.OPERATION_ID
--WHERE 1=1
--AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID			IN ( SELECT token FROM dbo.String_Split(@Param1,',')))
--AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID			IN ( SELECT token FROM dbo.String_Split(@Param2,',')))
--AND ( (@Param3 IS NULL or @Param3='') OR A.FACTORY_ID			IN ( SELECT token FROM dbo.String_Split(@Param3,',')))
--AND ( (@Param4 IS NULL or @Param4='') OR A.LINE_ID				IN ( SELECT token FROM dbo.String_Split(@Param4,',')))
--AND ( (@Param5 IS NULL or @Param5='') OR A.OPERATION_GROUP_ID	IN ( SELECT token FROM dbo.String_Split(@Param5,',')))
			ORDER BY A.OPERATION_ID