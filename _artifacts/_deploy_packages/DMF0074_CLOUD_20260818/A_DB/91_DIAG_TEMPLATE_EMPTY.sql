-- 91_DIAG_TEMPLATE_EMPTY.sql — "Excel Form 조회 시 MSG00656" 이 계속 뜰 때 원인 가르기
--   (클라우드 QA / DEV **각각** 실행. 위에서부터 순서대로 — 먼저 걸리는 곳이 원인)
--
-- 배경: MSG00656 은 SP 가 던지는 오류가 아니라 **템플릿 조회 결과가 0행일 때 FE 가 띄우는 안내**다.
--       따라서 "메시지가 뜬다" = "0행이다" 이며, 0행의 원인은 아래 D1~D5 중 하나다.

PROMPT ============================================================
PROMPT D1) 적용본이 MRFPARITY 반영본인가  ← 가장 흔한 원인
PROMPT     기대: MRFPARITY_MARK=1 / TEMPLATE_ACTIVE=0 / UPLOAD_ACTIVE=1
PROMPT     ⚠ 2026-08-18 14:06 이전에 받아둔 02_PKG_DMF0074_BODY.sql 은 **미반영본**이다.
PROMPT ============================================================
SELECT (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074'
          AND TYPE='PACKAGE BODY' AND TEXT LIKE '%MRFPARITY 2026-08-18%')            AS MRFPARITY_MARK,
       (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074'
          AND TYPE='PACKAGE BODY'
          AND TEXT LIKE '              AND    NVL(ATTRIBUTE7, ''N'') = ''Y''%')      AS TEMPLATE_ACTIVE,
       (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074'
          AND TYPE='PACKAGE BODY'
          AND TEXT LIKE '            AND    NVL(ATTRIBUTE7, ''N'') = ''Y''%')        AS UPLOAD_ACTIVE
  FROM DUAL;

PROMPT ============================================================
PROMPT D2) 컴파일 상태 — 기대: BODY VALID / 오류 0행
PROMPT     (INVALID 면 화면은 ORA-04063 을 만나지 구 로직으로 도는 게 아니다)
PROMPT ============================================================
SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0074' ORDER BY OBJECT_TYPE;
SELECT LINE, POSITION, SUBSTR(TEXT,1,120) TXT FROM ALL_ERRORS
 WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0074' ORDER BY SEQUENCE;

PROMPT ============================================================
PROMPT D3) 화면이 부르는 객체가 패키지가 맞는가 (배선)
PROMPT     기대: PROC_NM 이 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEM…' (standalone 이면 본문 교체 무의미)
PROMPT ============================================================
SELECT DISTINCT PROC_NM FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE '%DMF0074%' ORDER BY 1;
-- standalone 잔존본이 있으면 함께 확인 (사내에는 INVALID 로 5종 남아 있다 — 이관 대상 아님)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE '%DMF0074%' ORDER BY OBJECT_TYPE, OBJECT_NAME;

PROMPT ============================================================
PROMPT D4) 데이터 축 — 기준 버전이 존재하는가  ← 코드가 맞아도 여기서 0행이면 메시지는 **정상 안내**
PROMPT     기대: division 별 금주 SP_W 1행 + 그 버전의 PLAN_C/RESULT_C > 0
PROMPT ============================================================
SELECT DIVISION_ID, VERSION_NO, YYYYMMDD, NVL(ATTRIBUTE7,'(null)') MRF,
       TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI') CRE
  FROM SCM_MGR.DM_MST_VERSION
 WHERE VERSION_TYPE='SP_W' AND CREATION_DATE >= TRUNC(SYSDATE,'IW')
 ORDER BY DIVISION_ID;

SELECT V.DIVISION_ID, V.VERSION_NO,
       (SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_C C
         WHERE C.DIVISION_ID=V.DIVISION_ID AND C.VERSION_NO=V.VERSION_NO)        AS PLAN_C,
       (SELECT COUNT(*) FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C R
         WHERE R.DIVISION_ID=V.DIVISION_ID AND R.VERSION_NO=V.VERSION_NO)        AS RESULT_C
  FROM (SELECT DIVISION_ID, MAX(VERSION_NO) VERSION_NO
          FROM SCM_MGR.DM_MST_VERSION WHERE VERSION_TYPE='SP_W' GROUP BY DIVISION_ID) V
 ORDER BY 1;
-- PLAN_C/RESULT_C 가 0 이면 → Sales Plan Waterfall Cutoff 적재부터 해결해야 한다(코드 문제 아님)

PROMPT ============================================================
PROMPT D5) 최종 — SP 직접 호출로 행수 확인 (FE/BE 경유 없이)
PROMPT     0행이면 D4 가 원인, 행이 나오는데 화면만 0이면 FE/BE 축(권한·배선)을 본다
PROMPT ============================================================
SET SERVEROUTPUT ON
DECLARE
  v_rc1 SYS_REFCURSOR; v_rc2 SYS_REFCURSOR; v_cnt PLS_INTEGER; v_dummy PLS_INTEGER;
BEGIN
  FOR d IN (SELECT COLUMN_VALUE AS DV FROM TABLE(SYS.ODCIVARCHAR2LIST('40','81','81_UC','82'))) LOOP
    BEGIN
      SCM_MGR.PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE(d.DV, USER, 'DMF0074', v_rc1, v_rc2);
      v_cnt := 0;
      LOOP
        FETCH v_rc1 INTO v_dummy;   -- 컬럼 수가 달라 실패하면 아래 EXCEPTION 으로
        EXIT WHEN v_rc1%NOTFOUND;
        v_cnt := v_cnt + 1;
      END LOOP;
      CLOSE v_rc1;
      DBMS_OUTPUT.PUT_LINE(d.DV || ' → ' || v_cnt || ' 행');
    EXCEPTION WHEN OTHERS THEN
      -- FETCH 형 불일치는 정상(컬럼 다수) — 행 유무만 보려면 아래 대안 쿼리 사용
      DBMS_OUTPUT.PUT_LINE(d.DV || ' → 호출 OK / 행수는 도구로 확인 (' || SQLERRM || ')');
    END;
  END LOOP;
END;
/
-- ※ SQL 도구에서 행수를 바로 보려면 사내와 동일하게 python 러너 사용:
--    _artifacts/_diagnostics/_dmf0074_tpl_measure.py  (접속정보만 클라우드로 교체)
