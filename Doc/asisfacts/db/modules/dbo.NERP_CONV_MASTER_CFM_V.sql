



CREATE VIEW [dbo].[NERP_CONV_MASTER_CFM_V] AS
/*
 * Program ID   : NERP_CONV_MASTER_CFM_V
 * Description  : NERP_CONV_MASTER 중 매핑확정만 선택
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.03.28   김준규         Initial Release : NERP 컨버전시 BEFORE AFTER에서 매핑확정인 것만 선택
 * 2025.05.22   김준규         PLANT_ID,SCP_SITE_ID 강제 매핑확정
 * 2025.06.09   김준규         PLANT_ID,SCP_SITE_ID 강제 매핑확정 제외처리(별도 테이블에 바로 UPDATE 처리:프로그램 로직에 들어가면 안됨)
 * 2025.07.21   김준규         PLANT_ID "공통"도 매핑확정 처리
 * 2025.10.20   김준규         ROLLIN 4차 25년12월과 ROLLIN 4차 26년1월을 1개로 ROLLIN차수로 합친 것을 4N5로 하고 매핑확정 만 나오도록 처리
 * 2025.11.03   김준규         ROLLIN 4차 26년1월의 EG법인(이집트)에 STORAGE가 G690에 있는 것이 EG00과 EG01로 나누어짐에 따라 
                               EG01로 변경되는 STORAGE_ID CODETYPE의 OLD_VALUE1의 G690을 G691로 추가(변경)해서 보이게 함(4TH 및 4N5 및 5TH 대상)
 *
 */

 SELECT CMC.CODETYPE
       ,CMC.OLD_VALUE1
       ,CMC.OLD_VALUE2
       ,CMC.OLD_VALUE3
       ,CMC.OLD_VALUE4
       ,CMC.NEW_VALUE1
       ,CMC.NEW_VALUE2
       ,CMC.NEW_VALUE3
       ,CMC.NEW_VALUE4
       ,CMC.ELEMENT1
       ,CMC.ELEMENT2
       ,CMC.ELEMENT3
       ,CMC.ELEMENT4
       ,CMC.DESC1
       ,CMC.DESC2
       ,CMC.DESC3
       ,CMC.DESC4
       ,CMC.COMMENT1
       ,CMC.COMMENT2
       ,CMC.COMMENT3
       ,CMC.COMMENT4
       ,CMC.COMMENT5
       ,CMC.COMMENT6
       ,CMC.COMMENT7
       ,CMC.ACTIVE_FLAG
       ,CMC.ATTRIBUTE1
       ,CMC.ATTRIBUTE2
       ,CMC.ATTRIBUTE3
       ,CMC.ATTRIBUTE4
       ,CMC.ATTRIBUTE5
       ,CMC.INSERT_ID
       ,CMC.INSERT_DATE
       ,CMC.UPDATE_ID
       ,CMC.UPDATE_DATE
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
      -- EG법인 EG01로 분리되는 것은 G691을 추가한다.
      SELECT NCM.CODETYPE
            ,OLD_VALUE1='G691'
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
      WHERE 1=1
      AND   NCM.CODETYPE   = 'STORAGE_ID' 
      AND   NCM.OLD_VALUE1 = 'G690' 
      AND   NCM.ATTRIBUTE5 IN ('4TH','5TH')
      AND   NCM.NEW_VALUE1 = 'EG01'
  ) CMC
  WHERE CMC.COMMENT6 = N'매핑확정'
  --4N5 추가
  UNION
 SELECT CMC.CODETYPE
       ,CMC.OLD_VALUE1
       ,CMC.OLD_VALUE2
       ,CMC.OLD_VALUE3
       ,CMC.OLD_VALUE4
       ,CMC.NEW_VALUE1
       ,CMC.NEW_VALUE2
       ,CMC.NEW_VALUE3
       ,CMC.NEW_VALUE4
       ,CMC.ELEMENT1
       ,CMC.ELEMENT2
       ,CMC.ELEMENT3
       ,CMC.ELEMENT4
       ,CMC.DESC1
       ,CMC.DESC2
       ,CMC.DESC3
       ,CMC.DESC4
       ,CMC.COMMENT1
       ,CMC.COMMENT2
       ,CMC.COMMENT3
       ,CMC.COMMENT4
       ,CMC.COMMENT5
       ,CMC.COMMENT6
       ,CMC.COMMENT7
       ,CMC.ACTIVE_FLAG
       ,CMC.ATTRIBUTE1
       ,CMC.ATTRIBUTE2
       ,CMC.ATTRIBUTE3
       ,CMC.ATTRIBUTE4
       ,ATTRIBUTE5=CONC_ATTRIBUTE5
       ,CMC.INSERT_ID
       ,CMC.INSERT_DATE
       ,CMC.UPDATE_ID
       ,CMC.UPDATE_DATE
 FROM (
      SELECT NCM.CODETYPE
            ,NCM.CONC_ATTRIBUTE5
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
            ,RowNum = ROW_NUMBER() OVER (PARTITION BY NCM.CODETYPE
                                                     ,NCM.CONC_ATTRIBUTE5
                                                     ,NCM.OLD_VALUE1
                                                     ,NCM.OLD_VALUE2
                                                     ,NCM.OLD_VALUE3
                                                     ,NCM.OLD_VALUE4
                                                     ,NCM.NEW_VALUE1
                                                     ,NCM.NEW_VALUE2
                                                     ,NCM.NEW_VALUE3
                                                     ,NCM.NEW_VALUE4 ORDER BY NCM.CODETYPE,NCM.OLD_VALUE1,NCM.OLD_VALUE2,NCM.OLD_VALUE3,NCM.OLD_VALUE4,NCM.ATTRIBUTE5)
      FROM (
          SELECT NCM.CODETYPE
                ,CONC_ATTRIBUTE5='4N5'
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
          WHERE  NCM.ATTRIBUTE5 = '4TH'
          UNION
          SELECT NCM.CODETYPE
                ,CONC_ATTRIBUTE5='4N5'
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
          WHERE  NCM.ATTRIBUTE5 = '5TH'
      UNION
      -- EG법인 EG01로 분리되는 것은 G691을 추가한다.
      SELECT NCM.CODETYPE
            ,CONC_ATTRIBUTE5='4N5'
            ,OLD_VALUE1='G691'
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
      WHERE 1=1
      AND   NCM.CODETYPE   = 'STORAGE_ID' 
      AND   NCM.OLD_VALUE1 = 'G690' 
      AND   NCM.ATTRIBUTE5 IN ('4TH','5TH')
      AND   NCM.NEW_VALUE1 = 'EG01'
      ) NCM
  ) CMC
  WHERE CMC.COMMENT6 = N'매핑확정'  
  AND   CMC.RowNum = 1
  ;
