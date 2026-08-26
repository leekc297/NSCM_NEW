-- ═══════════════════════════════════════════════════════════════════════════════
-- DMF0049_CLOUD_20260820 / A_DB/30_GRANT_SYNONYM.sql
--   앱 계정 권한 + 시노님 — **사내 실측 구성과 동일**하게 재현한다.
--   실행 계정: SCM_MGR (객체 소유자).  ⚠ 시노님 생성에는 CREATE ANY SYNONYM 이 필요하다.
--
--   ⭐ 메모리 계보 (feedback_scmd_app_grant_mandatory):
--      "앱계정 권한 = SP EXECUTE 축 + 테이블 SELECT 축" 둘 다 필요하다.
--      **시노님은 권한이 아니다** — 시노님만 만들고 GRANT 를 빼면 ORA-04043/PLS-00201 이 난다.
--      반대로 GRANT 만 하고 시노님을 빼면 앱이 무접두 호출에서 ORA-00904/PLS-00201 로 죽는다.
--
--   축 = ① PKG_DMF0049 (본 화면 소유 PKG)
--        ② DMF0049 버튼이 **직접 호출**하는 타 소유 SP 4종
--           (PKG_DMF0044 / PKG_DMF0000 / DMF0002_GET_TITLESET_POPUP / SCM0002_SET_TITLESET_POPUP)
--           — API_M 실측. 이들이 없으면 SP_VER·unitedVersion·titleSet 시트가 죽는다.
--           ⚠ 소관은 각 화면 패키지지만, 멱등이라 함께 수행해도 무해하다(누락이 훨씬 위험).
--        ③ 저장 대상 표 2본 + 시퀀스 1본
--   ⛔ SELECT/DDL 외 데이터 변경 없음.
-- ═══════════════════════════════════════════════════════════════════════════════
SET DEFINE OFF

-- ── ① / ② EXECUTE GRANT (사내 실측: SCMD_APP + SCMP_APP 각 EXECUTE) ───────────
DECLARE
  TYPE t_obj IS TABLE OF VARCHAR2(128);
  TYPE t_gr  IS TABLE OF VARCHAR2(30);
  v_obj t_obj := t_obj('PKG_DMF0049',
                       'PKG_DMF0044',
                       'PKG_DMF0000',
                       'PKG_SCM_USER_MNU',
                       'DMF0002_GET_TITLESET_POPUP',
                       'SCM0002_SET_TITLESET_POPUP',
                       'FN_GET_COUNTRY_KR_NAME',
                       'FN_GET_DM_MKT_OWNER_NAME',
                       'PR_DM_SYS_LOG_BATCH',
                       'PR_SCM_SYS_LOG_BATCH');
  v_gr  t_gr  := t_gr('SCMD_APP', 'SCMP_APP');
  v_cnt NUMBER;
BEGIN
  FOR i IN 1 .. v_obj.COUNT LOOP
    SELECT COUNT(*) INTO v_cnt FROM ALL_OBJECTS
     WHERE OWNER = 'SCM_MGR' AND OBJECT_NAME = v_obj(i)
       AND OBJECT_TYPE IN ('PACKAGE', 'PROCEDURE', 'FUNCTION');
    IF v_cnt = 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP(객체 부재 — 선행 배포 필요): ' || v_obj(i));
      CONTINUE;
    END IF;
    FOR g IN 1 .. v_gr.COUNT LOOP
      BEGIN
        EXECUTE IMMEDIATE 'GRANT EXECUTE ON SCM_MGR.' || v_obj(i) || ' TO ' || v_gr(g);
      EXCEPTION WHEN OTHERS THEN
        -- -1917 사용자/롤 부재 : 클라우드 계정 구성이 다르면 조용히 넘기지 말고 로그로 남긴다
        IF SQLCODE = -1917 THEN
          DBMS_OUTPUT.PUT_LINE('WARN(계정 부재): ' || v_gr(g));
        ELSE RAISE; END IF;
      END;
    END LOOP;
  END LOOP;
END;
/

-- ── ③ 저장 대상 표 / 시퀀스 (사내 실측) ────────────────────────────────────────
--    SCMD_APP = SELECT/INSERT/UPDATE/DELETE  ·  SCMP_APP = SELECT
--    ⚠ 사내에는 RL_SCM_DML / RL_SCM_SEL 롤 경유 권한도 있으나, 클라우드 롤 구성이 다를 수 있어
--      **앱 계정 직접 GRANT** 만 필수로 둔다(롤은 존재 시에만 부여).
DECLARE
  TYPE t_tb IS TABLE OF VARCHAR2(128);
  v_tb t_tb := t_tb('DM_PLN_SALES_ETC_REPORT_C', 'DM_PLN_SALES_ETC_REPORT_H');
  v_cnt NUMBER;
  PROCEDURE g(p_sql VARCHAR2) IS
  BEGIN
    EXECUTE IMMEDIATE p_sql;
  EXCEPTION WHEN OTHERS THEN
    IF SQLCODE IN (-1917, -1919) THEN
      DBMS_OUTPUT.PUT_LINE('WARN(계정/롤 부재): ' || p_sql);
    ELSE RAISE; END IF;
  END;
BEGIN
  FOR i IN 1 .. v_tb.COUNT LOOP
    SELECT COUNT(*) INTO v_cnt FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TABLE_NAME = v_tb(i);
    IF v_cnt = 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP(표 부재): ' || v_tb(i));
      CONTINUE;
    END IF;
    g('GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || v_tb(i) || ' TO SCMD_APP');
    g('GRANT SELECT ON SCM_MGR.' || v_tb(i) || ' TO SCMP_APP');
    -- 롤 (사내 실측 — 존재할 때만)
    FOR r IN (SELECT ROLE FROM DBA_ROLES WHERE ROLE IN ('RL_SCM_DML','RL_SCM_SEL')) LOOP
      IF r.ROLE = 'RL_SCM_DML' THEN
        g('GRANT SELECT, INSERT, UPDATE, DELETE ON SCM_MGR.' || v_tb(i) || ' TO RL_SCM_DML');
      ELSE
        g('GRANT SELECT ON SCM_MGR.' || v_tb(i) || ' TO RL_SCM_SEL');
      END IF;
    END LOOP;
  END LOOP;
  -- 시퀀스 (사내 실측: SCMP_APP SELECT 만)
  SELECT COUNT(*) INTO v_cnt FROM ALL_SEQUENCES
   WHERE SEQUENCE_OWNER='SCM_MGR' AND SEQUENCE_NAME='SEQ1_DM_PLN_SALES_ETC_REPORT_H';
  IF v_cnt > 0 THEN
    g('GRANT SELECT ON SCM_MGR.SEQ1_DM_PLN_SALES_ETC_REPORT_H TO SCMP_APP');
  END IF;
END;
/

-- ── 시노님 (사내 실측: SCMD_APP / SCMP_APP 소유, TABLE_OWNER=SCM_MGR) ──────────
--    ⚠ 사내 실측상 SEQ1_DM_PLN_SALES_ETC_REPORT_H 시노님은 **SCMP_APP 만** 존재한다
--      (SCMD_APP 는 없음). 실측을 그대로 재현한다 — 임의로 늘리지 않는다.
DECLARE
  TYPE t_pair IS RECORD (own VARCHAR2(30), obj VARCHAR2(128));
  TYPE t_list IS TABLE OF t_pair;
  v t_list := t_list();
  PROCEDURE add(p_own VARCHAR2, p_obj VARCHAR2) IS
  BEGIN
    v.EXTEND; v(v.COUNT).own := p_own; v(v.COUNT).obj := p_obj;
  END;
  v_cnt NUMBER;
BEGIN
  FOR o IN (SELECT COLUMN_VALUE obj FROM TABLE(SYS.ODCIVARCHAR2LIST(
              'PKG_DMF0049','PKG_DMF0044','PKG_DMF0000','PKG_SCM_USER_MNU',
              'DMF0002_GET_TITLESET_POPUP','SCM0002_SET_TITLESET_POPUP',
              'FN_GET_COUNTRY_KR_NAME','FN_GET_DM_MKT_OWNER_NAME',
              'PR_DM_SYS_LOG_BATCH','PR_SCM_SYS_LOG_BATCH'))) LOOP
    add('SCMD_APP', o.obj);
    add('SCMP_APP', o.obj);
  END LOOP;
  add('SCMP_APP', 'SEQ1_DM_PLN_SALES_ETC_REPORT_H');   -- 사내 실측 그대로 (SCMD_APP 없음)

  FOR i IN 1 .. v.COUNT LOOP
    SELECT COUNT(*) INTO v_cnt FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME = v(i).obj;
    IF v_cnt = 0 THEN
      DBMS_OUTPUT.PUT_LINE('SKIP(객체 부재): ' || v(i).obj);
      CONTINUE;
    END IF;
    BEGIN
      EXECUTE IMMEDIATE 'CREATE OR REPLACE SYNONYM ' || v(i).own || '.' || v(i).obj
                        || ' FOR SCM_MGR.' || v(i).obj;
    EXCEPTION WHEN OTHERS THEN
      IF SQLCODE = -1918 THEN     -- 계정 부재
        DBMS_OUTPUT.PUT_LINE('WARN(계정 부재): ' || v(i).own);
      ELSE RAISE; END IF;
    END;
  END LOOP;
END;
/
