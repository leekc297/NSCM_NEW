


/*
 * Program ID   : SCM0010_GET_NOTICE_CONTENT_MASTER
 * Description  : NOTICE MESSAGE 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/22   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 */

CREATE PROCEDURE [dbo].[SCM0010_GET_NOTICE_CONTENT_MASTER]
  @p_notice_id		NVARCHAR(MAX)
AS
BEGIN
	
		SELECT
              m.notice_id
              ,r.notice_title as notice_main_title
              ,m.language_code
			  ,ld.segment2 language
              ,m.notice_title
              ,m.notice_content
			  ,m.notice_image
			  ,m.notice_image_id
        FROM
              SCM_ADM_NOTICE_CONTENT_MASTER m WITH(NOLOCK)
			  INNER JOIN SCM_ADM_NOTICE_MASTER r WITH(NOLOCK) on r.notice_id = m.notice_id
			  INNER JOIN SCM_ADM_LOOKUP_MASTER lm WITH(NOLOCK) ON lm.lookup_type = 'LANGUAGE' AND lm.valid_yn = 'Y'
			  INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL ld WITH(NOLOCK) ON ld.lookup_type = lm.lookup_type and ld.segment1 = m.language_code and  ld.valid_yn = 'Y'
        WHERE  1 = 1
        AND   m.notice_id   = @p_notice_id
   ;
END


