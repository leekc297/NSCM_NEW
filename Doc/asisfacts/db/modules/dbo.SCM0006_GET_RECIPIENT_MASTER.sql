

/*
 * Program ID   : SCM0006_GET_RECIPIENT_MASTER
 * Description  : MAIL SET MASTER 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/05   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/15	hwyoon	메일링 분단위 발송 추가
 */

CREATE PROCEDURE [dbo].[SCM0006_GET_RECIPIENT_MASTER]
  @p_use_type		NVARCHAR(MAX),
  @p_module			NVARCHAR(MAX),
  @p_submodule		NVARCHAR(MAX),    
  @p_active			NVARCHAR(MAX)
AS
BEGIN
	
		SELECT
               m.use_type_code
              ,m.module_code
              ,m.sub_module_code
              ,m.category_id
              ,m.category_desc
              ,m.cycle_class_code
              ,m.detail_class_code
              ,m.send_time_text
			  ,m.SEND_MIN_TIME_TEXT
              ,m.valid_yn active_flag
        FROM
              scm_adm_recipient_list m
        WHERE  1 = 1
        AND m.use_type_code = @p_use_type
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
        ORDER BY m.use_type_code
              ,m.module_code
              ,m.sub_module_code
              ,m.category_desc
              ,m.cycle_class_code
              ,m.detail_class_code
              ,m.send_time_text
			  ,m.SEND_MIN_TIME_TEXT
              ,m.valid_yn
   ;
END

