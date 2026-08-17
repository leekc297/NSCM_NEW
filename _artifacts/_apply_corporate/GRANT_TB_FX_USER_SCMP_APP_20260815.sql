-- ============================================================================
-- [적용 이력]
--   사내 (100.65.143.121/OCGSCMD_P01) : 2026-08-15 적용 완료 (SCM_MGR 세션)
--     검증 — /admin/combo 실호출 rows: TeambyDivisionAuth 83 / SiteByEndCustomerAuth 2,532 /
--            EndCustomerByDivisionDeptAuth 706 / TeambyDivision 66 / TeambyDivision2 74
--            (적용 전 5종 모두 code=-9994 "Sql Error")
--     ui_http_e2e --menu DMF0003 → 종합 WARN (FAIL 0)
--   클라우드 (QA/DEV/운영)          : **미적용** — 앱 계정이 SCMP_APP 인 모든 환경에 동일 필요
-- ============================================================================

-- ============================================================================
-- GRANT_TB_FX_USER_SCMP_APP_20260815.sql
--   SCM_MGR.TB_FX_USER SELECT 권한 누락 정정 — 애플리케이션 계정 SCMP_APP
--
-- [증상] 화면 셀 콤보 3종이 BE 응답 `code=-9994 "Sql Error"` 로 조용히 실패 →
--        그리드가 CODE 를 raw 로 표시(명칭 매핑 소실). 화면상 "빈 콤보"로만 보인다.
--          · TeambyDivisionAuth            (DMF0003 TEAM_ID)
--          · SiteByEndCustomerAuth         (DMF0003 SCM_SITE_ID)
--          · EndCustomerByDivisionDeptAuth (DMF0003 END_CUSTOMER)
--        같은 원인으로 TeambyDivision / TeambyDivision2 (총 5 CMBO)도 영향권.
--
-- [원인] 2026-08-15 실측 (사내 100.65.143.121/OCGSCMD_P01)
--        SCM_MGR.TB_FX_USER 의 권한은 **SCMD_APP 에만** 부여돼 있다
--          DBA_TAB_PRIVS → [('SCMD_APP','SELECT'/'INSERT'/'UPDATE'/'DELETE')]
--        SCMP_APP 은 직접 권한 0 + 보유 롤(RL_FP_SEL/RL_DIC/RL_INF_SEL/RL_SES/
--        RL_SCM_DML/RL_SYN) 경유 권한도 0. 시노님(SCMP_APP.TB_FX_USER)은 있으나
--        시노님은 권한을 주지 않으므로 ORA-00942 → BE 가 -9994 로 감싼다.
--        ⚠ 사내 BE 가 예전처럼 SCM_MGR 로 직결하면 **절대 재현되지 않는다**.
--          config-local.yml 이 SCMP_APP 으로 바뀐 뒤에야 드러났다(= 클라우드와 동일 조건).
--
-- [조치] SCMD_APP 과 동일하게 SELECT 만 부여한다 (콤보는 읽기 전용).
-- [적용] 사내 + 클라우드(QA/DEV/운영) **양쪽 모두** 필요 — 계정이 SCMP_APP 인 모든 환경.
-- [실행] SCM_MGR 계정으로 실행.
-- ============================================================================

GRANT SELECT ON SCM_MGR.TB_FX_USER TO SCMP_APP;

-- ── 검증 ────────────────────────────────────────────────────────────────────
-- ① 권한 부여 확인 (SCMP_APP 행이 SELECT 로 나와야 한다)
SELECT GRANTEE, PRIVILEGE
  FROM DBA_TAB_PRIVS
 WHERE OWNER = 'SCM_MGR'
   AND TABLE_NAME = 'TB_FX_USER'
 ORDER BY GRANTEE, PRIVILEGE;

-- ② 화면 검증 — BE 기동 후 아래 3 콤보가 rows > 0 이어야 한다
--    POST /admin/combo  {"comboId":"TeambyDivisionAuth","mnuId":"'DMF0003'"}
--    POST /admin/combo  {"comboId":"SiteByEndCustomerAuth","mnuId":"'DMF0003'"}
--    POST /admin/combo  {"comboId":"EndCustomerByDivisionDeptAuth","mnuId":"'DMF0003'"}
--    (러너: python _artifacts/_diagnostics/ui_http_e2e.py --menu DMF0003 → D2 섹션 FAIL 0)

-- ③ 동일 계보 재발 방지 점검 — CMBO SQL 이 참조하는 SCM_MGR 객체 중
--    SCMP_APP 이 직접·롤 어느 쪽으로도 SELECT 를 못 받는 것 전수
SELECT DISTINCT o.OBJECT_NAME
  FROM DBA_OBJECTS o
 WHERE o.OWNER = 'SCM_MGR'
   AND o.OBJECT_TYPE = 'TABLE'
   AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M c
                WHERE UPPER(DBMS_LOB.SUBSTR(c.SQL_DTL_CTN, 4000, 1)) LIKE '%' || o.OBJECT_NAME || '%')
   AND NOT EXISTS (SELECT 1 FROM DBA_TAB_PRIVS p
                    WHERE p.OWNER = o.OWNER AND p.TABLE_NAME = o.OBJECT_NAME
                      AND p.PRIVILEGE = 'SELECT'
                      AND (p.GRANTEE IN ('SCMP_APP', 'PUBLIC')
                        OR p.GRANTEE IN (SELECT GRANTED_ROLE FROM DBA_ROLE_PRIVS
                                          WHERE GRANTEE = 'SCMP_APP')))
 ORDER BY 1;
