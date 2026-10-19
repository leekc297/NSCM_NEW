/*
-- KSK (240703), 실행기능 검증용
	exec [PR_XLS_TEST]
*/
CREATE PROCEDURE [dbo].[PR_XLS_TEST]
(       
       @P_1 AS NVARCHAR(100) = null
	   , @P_2 as   NVARCHAR(100) = null
)       
AS        
  BEGIN          
		
	SELECT OBJECT_NAME(@@PROCID) AS proc_name, @p_1


  END;       
  
