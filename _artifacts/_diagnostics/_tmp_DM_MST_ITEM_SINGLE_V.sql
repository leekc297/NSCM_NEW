SELECT
/* --------------------------------------------------------------------------------------------------
 * Program ID   : DM_MST_ITEM_SINGLE_V
 * Description  : SCM_MST_ITEM_SN 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *
 * 2021-04-28 SJHAN  [CSR ID:C20210323-000420] GSCM SCP 시스템의 소형 사업부의 업무 효율 증가를 위한 제품별 형태별 구분 추가
 * 2021-10-18	hwi1993		[PJ20209643] 속도개선 -  셀프조인 로직 변경
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 * --------------------------------------------------------------------------------------------------
 */
       T1.DIVISION_ID
     , T1.ITEM_ID
     , MAX(T1.ITEM_NAME)                     AS ITEM_NAME             /* 해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일 */
     , MAX(T1.ITEM_CLASS)                    AS ITEM_CLASS            /* 해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일 */
     , MAX(T1.ITEM_CLASS_NAME)               AS ITEM_CLASS_NAME       /* 해당 컬럼이 NULL인 경우가 잇으므로 하나로 통일 */
     , MAX(T1.NICK_NAME)                     AS NICK_NAME             /* 닉네임이 NULL인 경우가 있으므로 하나로 통일 */
     , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1                   /* 타입이 사이트와 사업부, 법인에 따라 다양하게 존재 하므로 하나로 통일 */
                     WHEN T1.ITEM_TYPE = 'H' THEN 2                   /* 또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함 */
                     WHEN T1.ITEM_TYPE = 'Q' THEN 3
                     ELSE 4 END)
            WHEN 1 THEN 'P'
            WHEN 2 THEN 'H'
            WHEN 3 THEN 'Q'
            ELSE 'R' END                     AS ITEM_TYPE
     , MAX(T1.MATERIAL_CLASS_NAME)           AS MATERIAL_CLASS_NAME
     , MAX(T1.ITEM_UOM)                      AS ITEM_UOM
     , MAX(T1.SPEC)                          AS SPEC
     , MAX(T1.MDM_PROJECT_NAME)              AS MDM_PROJECT_NAME
     , MAX(T1.MIN_CAPACITY)                  AS MIN_CAPACITY
     , MAX(T2.FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
     , MAX(T2.FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
     , MAX(T2.FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
     , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
     , MAX(T2.FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
     , MAX(T2.FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
     , MAX(T1.ACTIVE_FLAG)                   AS ACTIVE_FLAG           /* 20180720 ADD 'Y'대상중 1건 추출 */
     , MAX(T2.CELL_TYPE)                     AS CELL_TYPE             /* 20180911 ADD cell_type */
     , MAX(T1.ENERGE)                        AS ENERGE                /* 20200116 khsong ADD ENERGE */
     , MAX(T1.CELL_QUANTITY)                 AS CELL_QUANTITY         /* 20200116 khsong ADD CELL_QUANTITY */
     , MAX(T1.SCP_EXTRA_SPEC)                AS SCP_EXTRA_SPEC        /* [20210428 SJHAN / CSR ID:C20210323-000420] */
  FROM SCM_MST_ITEM_SN T1
     , ( SELECT DIVISION_ID
              , SUBSTR(ITEM_ID, 1, 12)               AS ITEM_ID
              , MAX(FORECAST_INFO_BIZ_TYPE)          AS FORECAST_INFO_BIZ_TYPE
              , MAX(FORECAST_INFO_PRODUCT_GROUP)     AS FORECAST_INFO_PRODUCT_GROUP
              , MAX(FORECAST_INFO_CELL_MODEL)        AS FORECAST_INFO_CELL_MODEL
              , MAX(FORECAST_INFO_CELL_PACK_COUNT)   AS FORECAST_INFO_CELL_PACK_COUNT
              , MAX(FORECAST_INFO_SPEC)              AS FORECAST_INFO_SPEC
              , MAX(FORECAST_INFOR_VERSION)          AS FORECAST_INFOR_VERSION
              , MAX(CELL_TYPE)                       AS CELL_TYPE
           FROM SCM_MST_ITEM_SN T2
          GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
       ) T2
 WHERE 1=1
   AND T1.DIVISION_ID              = T2.DIVISION_ID
   AND SUBSTR(T1.ITEM_ID, 1, 12)   = T2.ITEM_ID
   /* WHERE ACTIVE_FLAG = 'Y'  -- 20180720 ADD 'Y'대상만 */
 GROUP BY T1.DIVISION_ID, T1.ITEM_ID