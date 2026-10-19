DECLARE @v_time  NVARCHAR(10);
DECLARE @v_week_day  NVARCHAR(10);
DECLARE @v_month_day  NVARCHAR(10);

SELECT @v_week_day = (dbo.FN_GET_WEEK_ENG(DATEPART(DW, GETDATE())))
			  ,@v_month_day = DATENAME(DD, GETDATE())
			  ,@v_time = FORMAT(GETDATE(), 'HH00') 
	

SELECT @v_week_day AS WEEKDAY,@v_month_day AS MONTHDAY,@v_time AS HOUR, 		 nList.cycle_class_code
		 ,nList.detail_class_code
		 ,nList.send_time_text , snm.notice_id
     ,snm.MODULE_CODE AS MODULE
     ,snm.SUB_MODULE_CODE AS SUBMODULE
         , snm.MODULE_CODE+' '+snm.SUB_MODULE_CODE system_title
         , suiv.UserID
         , suiv.UserName
         , suiv.Email
         , suiv.CellPhoneNum
         , snc.language_code
         , snc.notice_title
         , snc.notice_content
         , snc.notice_image
         , snc.notice_image_id

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
							 , flv.SEGMENT4 send_time_text
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
    AND    suiv.UserID         = @user_id
    --AND    snc.language_code = suiv.Language
    AND    (
	--1=1 OR
			-- 일1회 항상
            (nList.cycle_class_code = 'DAY'   AND nList.send_time_text = 'ALL') OR
			-- 실시간 
			(nList.cycle_class_code = 'RT' ) OR

			-- 일1회 시간 지정
			(nList.cycle_class_code = 'DAY'   AND nList.send_time_text = @v_time) OR

			-- 주1회 항상
			(nList.cycle_class_code = 'WEEK'   
				AND nList.detail_class_code = @v_week_day
				AND nList.send_time_text = 'ALL') OR

			-- 주1회 시간 지정
			(nList.cycle_class_code = 'WEEK'   
				AND nList.detail_class_code = @v_week_day
				AND nList.send_time_text = @v_time) OR

			-- 월1회 항상
			(nList.cycle_class_code = 'MONTH'   AND 
						 nList.detail_class_code = @v_month_day
						 AND nList.send_time_text = 'ALL') OR

						 			-- 월1회 시간 지정
			(nList.cycle_class_code = 'MONTH'   AND 
						 nList.detail_class_code = @v_month_day
						 AND nList.send_time_text = @v_time) 
           )
    AND    NOT EXISTS ( SELECT 1
                        FROM   SCM_ADM_NOTICE_CONFIRM sncn
                        WHERE  sncn.notice_id = snm.notice_id
                        AND    sncn.user_id   = @user_id 
                        AND    datediff(DD, sncn.last_update_date, getdate()) =0
                        )