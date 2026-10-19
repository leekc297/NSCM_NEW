
/*
 * Program ID   : SCM_ADM_GET_NOTICE_INFO
 * Description  : 공지사항 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/23   ygkim   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[SCM_ADM_GET_NOTICE_INFO]
  @p_user_id	    NVARCHAR(150)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @v_week_day  NVARCHAR(10);
	DECLARE @v_month_day  NVARCHAR(10);
	DECLARE @v_time  NVARCHAR(10);

	BEGIN
		SELECT @v_week_day = ([dbo].[FN_GET_WEEK_ENG](DATEPART(DW, GETDATE())))
			  ,@v_month_day = DATENAME(MM, GETDATE())
			  ,@v_time = DATEPART(HOUR, GETDATE())+'00';
	END

	IF @v_time = '05'
		BEGIN
			EXEC SCM_ADM_NOTICE_DELETE_CONFIRM;
		END

	SELECT snm.notice_id
         , snm.MODULE_CODE+' '+snm.SUB_MODULE_CODE system_title
         , suiv.UserID
         , suiv.UserName
         , suiv.Email
         , suiv.CellPhoneNum
         , snc.language_code
         , snc.notice_title
         , snc.notice_content
		 ,nList.cycle_class_code
		 ,nList.detail_class_code
    FROM   SCM_ADM_NOTICE_MASTER           snm
         , SCM_ADM_NOTICE_CONTENT_MASTER   snc
         , TB_FX_User                suiv
         , (SELECT notice_id
                 , MODULE_CODE
                 , cycle_class_code
                 , detail_class_code
                 , send_time_text
            FROM  (
						SELECT snm.notice_id
							 , snm.MODULE_CODE
							 , snm.cycle_class_code
							 , flv.SEGMENT4   detail_class_code
							 , flv1.SEGMENT4  send_time_text
						FROM   SCM_ADM_NOTICE_MASTER snm
							 , SCM_ADM_LOOKUP_MASTER_DETAIL flv
							 , SCM_ADM_LOOKUP_MASTER_DETAIL flv1
						WHERE  snm.VALID_YN = 'Y'
						AND    flv.LOOKUP_TYPE   = 'NOTICE_SEND_CYCLE_DETAIL'
						AND    snm.cycle_class_code   = flv.segment1
						AND    snm.detail_class_code  = flv.segment2
						AND    flv1.LOOKUP_TYPE  = 'NOTICE_SEND_CYCLE_DETAIL'
						AND    snm.send_time_text  = flv1.segment2
						AND    flv1.VALID_YN = 'Y'
						AND    flv.VALID_YN = 'Y'
						AND    snm.cycle_class_code NOT IN ( 'DAY', 'RT' )
						UNION ALL
						SELECT snm.notice_id
							 , snm.MODULE_CODE
							 , snm.cycle_class_code
							 , ''
							 , flv.SEGMENT3 send_time_text
						FROM   SCM_ADM_NOTICE_MASTER snm
							 , SCM_ADM_LOOKUP_MASTER_DETAIL flv
						WHERE  snm.VALID_YN = 'Y'
						AND    flv.LOOKUP_TYPE   = 'NOTICE_SEND_CYCLE_DETAIL'
						AND    snm.cycle_class_code   = flv.segment1
						AND    snm.detail_class_code  = flv.segment2
						AND    flv.VALID_YN = 'Y'
						AND    snm.cycle_class_code IN ( 'DAY', 'RT' )
                  ) A
			) nList
    WHERE  snm.notice_id        = snc.notice_id
    AND    snm.notice_id        = nList.notice_id
    AND    snm.VALID_YN      = 'Y'
    AND    suiv.UserID         = @p_user_id
    AND    snc.language_code = suiv.Language
    AND    (
            (nList.cycle_class_code = 'DAY'   AND nList.send_time_text = 'ALL') OR
           	(nList.cycle_class_code = 'DAY'   AND nList.send_time_text = @v_time) OR
            (nList.cycle_class_code = 'WEEK'  AND nList.detail_class_code = @v_week_day AND nList.send_time_text = @v_time) OR
            (nList.cycle_class_code = 'MONTH' AND nList.detail_class_code = @v_month_day AND nList.send_time_text = @v_time) OR
            (nList.cycle_class_code = 'RT'    AND ([dbo].[FN_GET_WEEK_ENG](DATEPART(DW, snm.CREATION_DATE))) = @v_week_day)
           )
    AND    NOT EXISTS ( SELECT 1
                        FROM   SCM_ADM_NOTICE_CONFIRM sncn
                        WHERE  sncn.notice_id = snm.notice_id
                        AND    sncn.user_id   = @p_user_id )
	;
END
