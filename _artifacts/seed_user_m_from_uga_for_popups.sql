-- =====================================================================
-- SCM_ADM_USER_M 시드 — UGA 매핑 사용자 보강
-- 작성일: 2026-05-27
-- 목적: COM0004 (Owner popup) 등 admin-group-based popup 결과 정상화
--
-- 현재 상태:
--   - SCM_ADM_USER_GR_UNIT_AUTH_MPG_M: 347 distinct USER_ID
--   - SCM_ADM_USER_M: minyonglee1 1명만 등록 (346명 누락)
--   - 누락 346명 모두 SCM_MST_SSO_USER_INFO 에 존재 (344명 valid dept)
--
-- COM0004 SP 최종 SELECT 가 admin/D/{div} UGA + USER_M JOIN → 0건 반환
-- 시드 후 admin UGA 매핑 사용자가 USER_M 에 존재 → SP 결과 양수
--
-- 패턴: minyonglee1 의 USER_M 값과 동일 (KO/Y/AS054/Y/N)
-- =====================================================================

WHENEVER SQLERROR EXIT SQL.SQLCODE

INSERT INTO SCM_ADM_USER_M (
    USER_ID, USER_NM, USER_ENG_NM, DEPT_ID, LANG_CD,
    ACNT_LOK_YN, TMZ_CD, USE_YN,
    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
    PERM_KEP_CNC_YN
)
SELECT
    SU.USER_ID,
    NVL(SU.USER_NAME, SU.USER_ID),
    SU.USER_NAME_EN,
    SU.DEPT_ID,
    'KO',
    'Y', 'AS054', 'Y',
    'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE,
    'N'
FROM (
    SELECT DISTINCT USER_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
) U
JOIN SCM_MST_SSO_USER_INFO SU ON SU.USER_ID = U.USER_ID
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_USER_M x WHERE x.USER_ID = SU.USER_ID
);

COMMIT;

EXIT
