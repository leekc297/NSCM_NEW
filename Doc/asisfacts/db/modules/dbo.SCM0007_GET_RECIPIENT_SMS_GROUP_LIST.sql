
/*
 * Program ID   : SCM0007_GET_RECIPIENT_SMS_GROUP_LIST
 * Description  : SMS GROUP 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/11   hwyoon   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SCM0007_GET_RECIPIENT_SMS_GROUP_LIST]
  @p_group			NVARCHAR(MAX),    
  @p_phone			NVARCHAR(MAX)
AS
BEGIN
	
		SELECT
               m.sms_group_name
              ,m.sms_phone
        FROM
              scm_adm_recipient_sms_group m
        WHERE  1 = 1
		AND (@p_group IS NULL OR m.SMS_GROUP_NAME LIKE '%' + @p_group + '%')
	    AND (@p_phone IS NULL OR m.SMS_PHONE LIKE '%' + @p_phone + '%')
        ORDER BY m.sms_group_name
   ;
END

