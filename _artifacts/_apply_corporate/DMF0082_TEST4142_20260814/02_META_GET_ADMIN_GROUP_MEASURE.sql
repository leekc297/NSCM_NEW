--------------------------------------------------------------------------------------------------
-- [E20260814-CURMEASURE] 통합테스트 1st No.41 — Current 버전 입력가능 Measure 정정 (메타 축)
--------------------------------------------------------------------------------------------------
-- 대상 룩업 : SCM_ADM_LOOKUP_MASTER_DETAIL / LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE'
--             SEGMENT1=권한그룹 / SEGMENT2=화면 / SEGMENT3=사업부 / SEGMENT4=Measure
--             ATTRIBUTE1=DAYS(요일) / ATTRIBUTE2=FROM_TIME / ATTRIBUTE3=TO_TIME / ATTRIBUTE4=LIMIT_MEASURE
--
-- 근거(전부 AS-IS 실측 — LGCE_SCMDEV):
--   (A) DMF0082 / 40 / SCM_FCST 요일·시간창
--       AS-IS = WED 0000~1700 (LAST_UPDATE 2026-07-08)  ↔  TO-BE = MON 1900~2000 (2026-04-13)
--       → AS-IS 가 최신. TO-BE 가 구 스냅샷을 들고 있어 수요일 외에는 SCM_FCST 가 전부 잠긴다.
--   (B) DMF0082 / 81 계열·82 grant 부재
--       AS-IS `DM_UI_EDITABLE_MEASURE` 는 DMF0082 × (81,81_HD,81_HG,81_HM,81_ST,81_UC,82) 에
--       LOC · MKT_FCST 를 편집 대상으로 등재(park.choyi 2026-02-02) 했는데,
--       `GET_ADMIN_GROUP_MEASURE` 에는 그 사업부 행이 **1건도 없다**(AS-IS·TO-BE 공통).
--       SP 는 `A.SEGMENT3 = p_division_id` 로 걸러 담으므로 → 81 계열은 전 measure EDIT_FLAG='N'
--       = 요구 원문 "Current 버전인데 모두 입력 불가" 의 직접 원인.
--       → 40 의 그룹셋(ADMIN / DM ADMIN / DM Planner / SCM PI Admin)을 동일 measure 에 준용.
--   (C) MKT_FCST × SCP Planner 요일제한
--       81 의 MKT FCST 화면(AS-IS DMF0003)이 TO-BE 에서 DMF0082 로 통합됐으므로
--       AS-IS DMF0003/81* 의 SCP Planner 행(81=SUN / 81_XX=THU, 0000~2300)을 그대로 이식.
--       (AS-IS DMF0003 에 82 행은 없음 → 82 는 SCP Planner 미이식.)
--   ⛔ 미이식 : 81 계열 SCM_FCST grant.
--       AS-IS `DM_UI_EDITABLE_MEASURE` 에 81 SCM_FCST 가 없다(TO-BE 만 AJS 2026-07-14 등재).
--       또한 40 의 SCM_FCST 행은 ATTRIBUTE4(LIMIT_MEASURE)='MKT_FCST' 라, 그대로 복제하면
--       **수요일마다 81 의 MKT_FCST 가 잠긴다**. 근거 없는 부작용이므로 사용자 결정 대기.
--
-- 감사컬럼은 'admin' 고정 (메타 감사컬럼 규약).
--------------------------------------------------------------------------------------------------

/* (A) 40 SCM_FCST 요일·시간창 AS-IS 동기화 */
UPDATE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
SET    ATTRIBUTE1 = 'WED'
     , ATTRIBUTE2 = '0000'
     , ATTRIBUTE3 = '1700'
     , LAST_UPDATED_BY = 'admin'
     , LAST_UPDATE_DATE = SYSDATE
WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
AND    SEGMENT2 = 'DMF0082'
AND    SEGMENT3 = '40'
AND    SEGMENT4 = 'SCM_FCST';

/* (B) 81 계열·82 — MKT_FCST / LOC grant (40 그룹셋 준용, INSERT-only 멱등) */
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  ( LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
  , DISPLAY_SEQ, VALID_YN, DESCRIPTION
  , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT 'GET_ADMIN_GROUP_MEASURE', S.GRP, 'DMF0082', S.DIV, S.MEASURE, '-'
     , S.SEQ, 'Y', '[E20260814-CURMEASURE] No.41 — DM_UI_EDITABLE_MEASURE(AS-IS) 등재 사업부 grant 보강'
     , 'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT G.GRP, D.DIV, M.MEASURE, M.SEQ
    FROM   (SELECT '81' DIV FROM DUAL UNION ALL SELECT '81_HD' FROM DUAL
            UNION ALL SELECT '81_HG' FROM DUAL UNION ALL SELECT '81_HM' FROM DUAL
            UNION ALL SELECT '81_ST' FROM DUAL UNION ALL SELECT '81_UC' FROM DUAL
            UNION ALL SELECT '82'    FROM DUAL) D
    CROSS JOIN (SELECT 'MKT_FCST' MEASURE, 6 SEQ FROM DUAL
                UNION ALL SELECT 'LOC', 7 FROM DUAL) M
    CROSS JOIN (SELECT 'ADMIN' GRP FROM DUAL UNION ALL SELECT 'DM ADMIN' FROM DUAL
                UNION ALL SELECT 'DM Planner' FROM DUAL
                UNION ALL SELECT 'SCM PI Admin' FROM DUAL
                UNION ALL SELECT 'DM Planner (W/S)' FROM DUAL) G
) S
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
    WHERE  X.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    X.SEGMENT1 = S.GRP AND X.SEGMENT2 = 'DMF0082'
    AND    X.SEGMENT3 = S.DIV AND X.SEGMENT4 = S.MEASURE );

/* (C) 81 계열 — MKT_FCST × SCP Planner 요일제한 (AS-IS DMF0003/81* 1:1) */
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  ( LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
  , DISPLAY_SEQ, VALID_YN, DESCRIPTION
  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
  , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT 'GET_ADMIN_GROUP_MEASURE', 'SCP Planner', 'DMF0082', S.DIV, 'MKT_FCST', '-'
     , 6, 'Y', '[E20260814-CURMEASURE] No.41 — AS-IS DMF0003/81* SCP Planner 요일제한 이식'
     , S.DAYS, '0000', '2300'
     , 'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT '81' DIV, 'SUN' DAYS FROM DUAL
    UNION ALL SELECT '81_HD', 'THU' FROM DUAL
    UNION ALL SELECT '81_HG', 'THU' FROM DUAL
    UNION ALL SELECT '81_HM', 'THU' FROM DUAL
    UNION ALL SELECT '81_ST', 'THU' FROM DUAL
    UNION ALL SELECT '81_UC', 'THU' FROM DUAL
) S
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
    WHERE  X.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    X.SEGMENT1 = 'SCP Planner' AND X.SEGMENT2 = 'DMF0082'
    AND    X.SEGMENT3 = S.DIV AND X.SEGMENT4 = 'MKT_FCST' );

COMMIT;
