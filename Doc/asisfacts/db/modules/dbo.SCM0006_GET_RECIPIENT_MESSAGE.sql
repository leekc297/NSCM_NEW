

/*
 * Program ID   : SCM0006_GET_RECIPIENT_MESSAGE
 * Description  : MAIL SET MESSAGE 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/19   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SCM0006_GET_RECIPIENT_MESSAGE]
  @p_use_type		NVARCHAR(MAX),
  @p_categoryID		NVARCHAR(MAX)
AS
BEGIN
	
		SELECT
              m.use_type_code
              ,m.category_id
              ,r.CATEGORY_DESC as category_desc
              ,m.language_code
			  ,ld.segment2 language
              ,m.mail_title
              ,m.message_content
        FROM
              scm_adm_recipient_message m WITH(NOLOCK)
			  INNER JOIN scm_adm_recipient_list r WITH(NOLOCK) on r.category_id = m.category_id
			  INNER JOIN scm_adm_lookup_master lm WITH(NOLOCK) ON lm.lookup_type = 'LANGUAGE' AND lm.valid_yn = 'Y'
			  INNER JOIN scm_adm_lookup_master_detail ld WITH(NOLOCK) ON ld.lookup_type = lm.lookup_type and ld.segment1 = m.language_code and  ld.valid_yn = 'Y'
        WHERE  1 = 1
        AND    m.use_type_code = @p_use_type
        AND    m.category_id   = @p_categoryID
   ;
END


