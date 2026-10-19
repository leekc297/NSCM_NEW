

/*
 * Program ID   : SCM0010_GET_NOTICE_MASTER
 * Description  : NOTICE SET MASTER 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/22   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SCM0010_GET_NOTICE_MASTER]
  @p_module			NVARCHAR(MAX),
  @p_submodule		NVARCHAR(MAX),    
  @p_active			NVARCHAR(MAX)
AS
BEGIN
	
		SELECT
               m.notice_id
              ,m.module_code
              ,m.sub_module_code
              ,m.notice_title notice_main_title
              ,m.cycle_class_code
              ,m.detail_class_code
              ,m.send_time_text
              ,m.valid_yn active_flag
        FROM
              SCM_ADM_NOTICE_MASTER m with(nolock)
        WHERE  1 = 1
        AND (@p_module IS NULL OR m.Module_Code IN 
				(SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_module, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
		)
		AND (@p_submodule IS NULL OR m.sub_module_code IN 
				(SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_submodule, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
		)
		AND (@p_active IS NULL OR m.valid_yn IN 
				(SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_active, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
		)
        ORDER BY m.module_code
              ,m.sub_module_code
			  ,m.NOTICE_ID
              ,m.cycle_class_code
              ,m.detail_class_code
              ,m.send_time_text
              ,m.valid_yn
   ;
END


