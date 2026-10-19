

CREATE VIEW [dbo].[NERP_CONV_OLD_NEW_REF_V] AS
/*
 * Program ID   : NERP_CONV_OLD_NEW_REF_V
 * Description  : 받드시 참조용으로 만 사용할 것. NERP_CONV_MASTER 중 매핑확정 NEW_VALUE1 UNIQUE 기준 OLD_VALUE1 값 참조(NEW기준 ROW 카운트에 사용)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.03.31   김준규         Initial Release : NERP_CONV_MASTER 중 매핑확정 NEW_VALUE1 UNIQUE 기준 OLD_VALUE1 값 참조
 * 2025.06.05   김준규         'PLANT_ID,SCP_SITE_ID 강제 매핑확정
 * 2025.06.09   김준규         'PLANT_ID,SCP_SITE_ID 강제 매핑확정 제외처리(별도 테이블에 바로 UPDATE 처리:프로그램 로직에 들어가면 안됨)
 * 2025.07.21   김준규         PLANT_ID "공통"도 매핑확정 처리
 * 2025.10.20   김준규         ROLLIN 4차 25년12월과 ROLLIN 4차 26년1월을 1개로 ROLLIN차수로 합친 것을 4N5로 하고 매핑확정 만 나오도록 처리
 * 2025.10.31   김준규         DM ROLLIN 5차 4N5차에 SCM_DNM_STOCK_SALES 테이블 STORAGE_NAME 필요하여 컬럼 추가
 *
 */


SELECT
    CODETYPE,
    NEW_VALUE1,
    NEW_VALUE2,
    STRING_AGG(ISNULL(OLD_VALUE1, ''), ', ') AS OLD_VALUE1,
    STRING_AGG(ISNULL(OLD_VALUE2, ''), ', ') AS OLD_VALUE2,
    --STRING_AGG(ISNULL(OLD_VALUE1, ''), ', ') WITHIN GROUP (ORDER BY OLD_VALUE1) AS OLD_VALUE1,
    --STRING_AGG(ISNULL(OLD_VALUE2, ''), ', ') WITHIN GROUP (ORDER BY OLD_VALUE2) AS OLD_VALUE2,
    DESC1=MAX(DESC1),
    DESC2=MAX(DESC2),
    ATTRIBUTE5
FROM
    (SELECT DISTINCT CMC.CODETYPE
       ,CMC.OLD_VALUE1
       ,CMC.OLD_VALUE2
       ,CMC.NEW_VALUE1
       ,CMC.NEW_VALUE2
       ,CMC.DESC1
       ,CMC.DESC2
       ,CMC.ATTRIBUTE5
     FROM (
          SELECT NCM.CODETYPE
                ,NCM.OLD_VALUE1
                ,NCM.OLD_VALUE2
                ,NCM.OLD_VALUE3
                ,NCM.OLD_VALUE4
                ,NCM.NEW_VALUE1
                ,NCM.NEW_VALUE2
                ,NCM.NEW_VALUE3
                ,NCM.NEW_VALUE4
                ,NCM.ELEMENT1
                ,NCM.ELEMENT2
                ,NCM.ELEMENT3
                ,NCM.ELEMENT4
                ,NCM.DESC1
                ,NCM.DESC2
                ,NCM.DESC3
                ,NCM.DESC4
                ,NCM.COMMENT1
                ,NCM.COMMENT2
                ,NCM.COMMENT3
                ,NCM.COMMENT4
                ,NCM.COMMENT5
                --,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL','PLANT_ID','SCP_SITE_ID') THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                --,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL') THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                ,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL') THEN N'매핑확정' WHEN NCM.CODETYPE = 'PLANT_ID' AND NCM.COMMENT6 = N'공통' THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                ,NCM.COMMENT7
                ,NCM.ACTIVE_FLAG
                ,NCM.ATTRIBUTE1
                ,NCM.ATTRIBUTE2
                ,NCM.ATTRIBUTE3
                ,NCM.ATTRIBUTE4
                ,NCM.ATTRIBUTE5
                ,NCM.INSERT_ID
                ,NCM.INSERT_DATE
                ,NCM.UPDATE_ID
                ,NCM.UPDATE_DATE
          FROM   NERP_CONV_MASTER AS NCM WITH(NOLOCK)
          UNION
          SELECT NCM.CODETYPE
                ,NCM.OLD_VALUE1
                ,NCM.OLD_VALUE2
                ,NCM.OLD_VALUE3
                ,NCM.OLD_VALUE4
                ,NCM.NEW_VALUE1
                ,NCM.NEW_VALUE2
                ,NCM.NEW_VALUE3
                ,NCM.NEW_VALUE4
                ,NCM.ELEMENT1
                ,NCM.ELEMENT2
                ,NCM.ELEMENT3
                ,NCM.ELEMENT4
                ,NCM.DESC1
                ,NCM.DESC2
                ,NCM.DESC3
                ,NCM.DESC4
                ,NCM.COMMENT1
                ,NCM.COMMENT2
                ,NCM.COMMENT3
                ,NCM.COMMENT4
                ,NCM.COMMENT5
                --,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL','PLANT_ID','SCP_SITE_ID') THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                --,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL') THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                ,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL') THEN N'매핑확정' WHEN NCM.CODETYPE = 'PLANT_ID' AND NCM.COMMENT6 = N'공통' THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                ,NCM.COMMENT7
                ,NCM.ACTIVE_FLAG
                ,NCM.ATTRIBUTE1
                ,NCM.ATTRIBUTE2
                ,NCM.ATTRIBUTE3
                ,NCM.ATTRIBUTE4
                ,ATTRIBUTE5='4N5'
                ,NCM.INSERT_ID
                ,NCM.INSERT_DATE
                ,NCM.UPDATE_ID
                ,NCM.UPDATE_DATE
          FROM   NERP_CONV_MASTER AS NCM WITH(NOLOCK)
          WHERE  NCM.ATTRIBUTE5 = '4TH'
          UNION
          SELECT NCM.CODETYPE
                ,NCM.OLD_VALUE1
                ,NCM.OLD_VALUE2
                ,NCM.OLD_VALUE3
                ,NCM.OLD_VALUE4
                ,NCM.NEW_VALUE1
                ,NCM.NEW_VALUE2
                ,NCM.NEW_VALUE3
                ,NCM.NEW_VALUE4
                ,NCM.ELEMENT1
                ,NCM.ELEMENT2
                ,NCM.ELEMENT3
                ,NCM.ELEMENT4
                ,NCM.DESC1
                ,NCM.DESC2
                ,NCM.DESC3
                ,NCM.DESC4
                ,NCM.COMMENT1
                ,NCM.COMMENT2
                ,NCM.COMMENT3
                ,NCM.COMMENT4
                ,NCM.COMMENT5
                --,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL','PLANT_ID','SCP_SITE_ID') THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                --,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL') THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                ,COMMENT6 = (CASE WHEN NCM.CODETYPE IN ('BKLAS','MATKL') THEN N'매핑확정' WHEN NCM.CODETYPE = 'PLANT_ID' AND NCM.COMMENT6 = N'공통' THEN N'매핑확정' ELSE NCM.COMMENT6 END)
                ,NCM.COMMENT7
                ,NCM.ACTIVE_FLAG
                ,NCM.ATTRIBUTE1
                ,NCM.ATTRIBUTE2
                ,NCM.ATTRIBUTE3
                ,NCM.ATTRIBUTE4
                ,ATTRIBUTE5='4N5'
                ,NCM.INSERT_ID
                ,NCM.INSERT_DATE
                ,NCM.UPDATE_ID
                ,NCM.UPDATE_DATE
          FROM   NERP_CONV_MASTER AS NCM WITH(NOLOCK)
          WHERE  NCM.ATTRIBUTE5 = '5TH'
      ) CMC
      WHERE CMC.COMMENT6 = N'매핑확정'
) X
WHERE 1=1
GROUP BY
    CODETYPE,NEW_VALUE1,NEW_VALUE2,ATTRIBUTE5
;
