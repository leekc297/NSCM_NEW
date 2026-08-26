-- =====================================================================================================
-- 95_DIAGNOSE_AUTH.sql — DMF0035 "전 TYPE 0행" **원인 확정용** (SELECT 전용 · 즉시 완료)
--
--   [3차(93) 결과 — 데이터 축은 전부 정상으로 판명]
--     · BIZ 선택 버전 `BP_M_20260807_V002` = **79,268행 실재**       (버전 문제 아님)
--     · BIZ measure 교집합 9종 중 **7 HIT**                          (measure 문제 아님)
--     · MKT div40 기간 내 **116,533행** / measure 2 HIT, SALES **20,092행** (데이터 문제 아님)
--     · 캘린더·메타·PROC_M·PKG본문·GTT·콤보 전부 정상(91/92 차수)
--   ⇒ 입력이 다 정상인데 0행이면, 원인은 **SP 안에서 행을 걸러내는 축** 하나뿐이다.
--
--   ⭐ 그 축 = 권한 뷰 INNER JOIN (3 SP 공통 — 그래서 3 TYPE 이 동시에 죽는다)
--       PKG_DMF0035 L3454 / PKG_DMF0022 L108·L149·L3512 / PKG_DMF0051 L1621·L1661:
--         INNER JOIN SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
--            ON EDY.USER_ID = <로그인> AND EDY.MNU_ID = <DMF0035> AND EDY.UNIT_ID = A.DIVISION_ID
--       뷰가 0행이면 **조회 결과도 0행**이 된다(권한 게이트가 아니라 사실상 필터).
--
--   ⭐⭐ 뷰 정의 실측 (사내 `ALL_VIEWS`) — 메뉴 한 칸이 전체를 좌우한다:
--         FROM SCM_ADM_USER_GR_MPG_M GRP
--         JOIN SCM_ADM_USER_GR_UNIT_AUTH_MPG_M AUTH ON AUTH.USER_GR_ID=GRP.USER_GR_ID AND AUTH.USER_ID=GRP.USER_ID
--         JOIN SCM_ADM_MNU_M MNU  **ON MNU.UNIT_TP_CD = AUTH.UNIT_TP_CD**
--        WHERE GRP.USE_YN='Y' AND AUTH.USE_YN='Y' AND **MNU.USE_YN='Y'**
--      ⇒ `SCM_ADM_MNU_M(DMF0035).UNIT_TP_CD` 가 'D' 가 아니거나 USE_YN 이 'N' 이면 **뷰 0행 → 전 TYPE 0행**.
--      사내 실측: DMF0035 = D-레벨 8개 division('40','81','81_UC','81_HM','81_ST','81_HD','81_HG','82'),
--                DMF0044(정상 화면)도 동일하게 8.
--      ※ `20_MENU_META_SYNC.sql` 은 `UNIT_TP_CD='D'` 를 세팅하므로, 미적용/부분적용이면 여기서 드러난다.
-- =====================================================================================================
SET LINESIZE 200
SET PAGESIZE 100

PROMPT ===== A1. ⭐⭐ 메뉴 행 한 칸 대조 — DMF0035 가 정상 화면(DMF0044)과 같은가 =====
SELECT MNU_ID, NVL(UNIT_TP_CD,'(NULL)') AS UNIT_TP_CD, USE_YN, MNU_TP_CD, MNU_LV_NO,
       CASE WHEN NVL(UNIT_TP_CD,'x') <> 'D' OR USE_YN <> 'Y'
            THEN '*** FAIL — 권한 뷰가 0행이 되어 전 TYPE 0행 ***' ELSE 'OK' END AS VERDICT
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0035','DMF0044')      -- DMF0044 = 정상 동작 대조군
 ORDER BY MNU_ID;

PROMPT ===== A2. ⭐⭐ 권한 뷰 실제 반환 행 (사내 기준선: 각 8행) =====
SELECT MNU_ID, COUNT(*) AS AUTH_ROWS,
       LISTAGG(UNIT_ID, ',') WITHIN GROUP (ORDER BY UNIT_ID) AS UNITS
  FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
 WHERE USER_ID = 'minyonglee1'
   AND MNU_ID IN ('DMF0035','DMF0044')
 GROUP BY MNU_ID ORDER BY 1;
--  DMF0044 는 8행인데 DMF0035 가 0행이면 → A1 의 메뉴 한 칸이 원인 (확정)
--  둘 다 0행이면 → 사용자 그룹의 조직 권한(A3) 자체가 없음

PROMPT ===== A3. 사용자 그룹-조직 권한 원천 (둘 다 0행일 때만 의미) =====
SELECT AUTH.UNIT_TP_CD, COUNT(*) CNT,
       LISTAGG(AUTH.UNIT_ID, ',') WITHIN GROUP (ORDER BY AUTH.UNIT_ID) UNITS
  FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M GRP
  JOIN SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M AUTH
    ON AUTH.USER_GR_ID = GRP.USER_GR_ID AND AUTH.USER_ID = GRP.USER_ID
 WHERE GRP.USER_ID = 'minyonglee1' AND GRP.USE_YN = 'Y' AND AUTH.USE_YN = 'Y'
 GROUP BY AUTH.UNIT_TP_CD ORDER BY 1;

PROMPT ===== 정정 (A1 이 FAIL 일 때) =====
PROMPT   방법1(권장) : 20_MENU_META_SYNC.sql 재적용 — UNIT_TP_CD='D' / USE_YN='Y' 를 세팅한다
PROMPT   방법2(최소) : UPDATE SCM_MGR.SCM_ADM_MNU_M
PROMPT                    SET UNIT_TP_CD='D', USE_YN='Y',
PROMPT                        LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
PROMPT                  WHERE MNU_ID='DMF0035';  COMMIT;
PROMPT   적용 후 화면 재조회 → 3 TYPE 모두 정상화되어야 한다(A2 가 8행이 되는지로 선확인 가능)
