-- =====================================================================
-- DMF0021 P6 — CMBO_SQL_M 등록: SalesPlanUserAuthGroup (P_USERINFO 권한 그룹 해석) (2026-07-15)
-- 배경 (실측): TO-BE 세션에 권한 그룹 부재 — /user/login 응답·UserSession 모델·PR_GET_NSCM_USER 커서
--   전 계층에 그룹 필드 0건. 기존 FE(mkt-fcst/forecast-price 계보)의 `session.groupId || sesUserId` 는
--   groupId 가 유령 필드라 항상 USER_ID 전송 → DMF0021 DATAEX 의 GET_ADMIN_GROUP_MEASURE lookup
--   (SEGMENT1=그룹명) 미매칭 → EDIT_AUTH_* 전부 'N' → 편집가능 메저/셀 미표시 (사용자 보고 2026-07-15).
-- 해법: 사용자 보유 그룹(SCM_ADM_USER_GR_MPG_M) × lookup 등재 그룹 교집합 콤보 — FE 가 1행을
--   P_USERINFO 로 전송 (AS-IS NowGroupID 등가. ADMIN 우선, 그 외 이름순).
-- 파라미터: @sesUserId (BE getCombo 세션 치환 — CMBO 'TeambyDivision' 선례)
-- =====================================================================
MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (
  SELECT 'SalesPlanUserAuthGroup' SQL_ID, 'DM' MDU_DIVS_CD,
         'DMF0021 P_USERINFO 권한 그룹 (보유그룹 × GET_ADMIN_GROUP_MEASURE 교집합)' SQL_NM,
'SELECT M.USER_GR_ID AS CODE, M.USER_GR_ID AS NAME
FROM SCM_ADM_USER_GR_MPG_M M
WHERE M.USER_ID = @sesUserId
  AND M.USE_YN = ''Y''
  AND EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
              WHERE L.LOOKUP_TYPE = ''GET_ADMIN_GROUP_MEASURE'' AND L.VALID_YN = ''Y''
                AND L.SEGMENT1 = M.USER_GR_ID AND L.SEGMENT2 = ''DMF0021'')
ORDER BY DECODE(M.USER_GR_ID, ''ADMIN'', 1, 2), M.USER_GR_ID' SQL_DTL_CTN
  FROM DUAL
) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET t.MDU_DIVS_CD = s.MDU_DIVS_CD, t.SQL_NM = s.SQL_NM,
  t.SQL_DTL_CTN = s.SQL_DTL_CTN, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.SQL_ID, s.MDU_DIVS_CD, s.SQL_NM, s.SQL_DTL_CTN, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 검증: 등록 1건 + minyonglee1 치환 스모크 (기대: ADMIN 1행 선두)
SELECT SQL_ID, USE_YN, LENGTH(SQL_DTL_CTN) FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = 'SalesPlanUserAuthGroup';

-- 원복: DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='SalesPlanUserAuthGroup'; COMMIT;
