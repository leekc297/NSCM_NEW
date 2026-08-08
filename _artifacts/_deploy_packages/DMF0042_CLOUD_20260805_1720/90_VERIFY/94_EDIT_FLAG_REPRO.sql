-- ============================================================================
-- 94 편집 불가 재현 — 클라우드에서 조회 SP 를 화면 바인딩 그대로 실행해
--    커서1 의 EDIT_FLAG/MEASURE 컬럼 존재 + EDIT_FLAG 값 분포 + 커서2(유효구간) 출력
--    (조회 전용 — 저장 SP 아님). 실행: 클라우드 SCM_MGR, SQL*Plus/SQLcl/Developer.
--    ⚠ 바인딩은 91 [0-1] 로그의 실호출 값 그대로 (division 40 / minyonglee1 / 'ADMIN').
--    사내 기대값(2026-08-06 실측): CURSOR1 cols=26, EDIT_FLAG_COL=YES(#11), MEASURE_COL=YES(#14),
--      rows=15845 EDIT_FLAG Y=15845/N=0 (v_group_id='ADMIN' 경로 전행 Y),
--      CURSOR2: VALID_YN=Y 202101~203112 (LOOKUP 'DM_LONG_PLAN' div40×'Biz Plan' — 결측 시
--      Q_/Y_ 버킷 전면 잠금·M_ 은 개방. 이 lookup 도 이관 "기존재 전제" 목록)
--    판정: ①EDIT_FLAG_COL MISSING → sp/02 미반영(또는 titleset 경로) ②Y=0/N=전행 → 권한 판정
--      불성립(p_userinfo/lookup) ③전행 Y 인데 화면 잠금 → CURSOR2(DM_LONG_PLAN)·버킷·FE 배포본
-- ============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    rc1        SYS_REFCURSOR;
    rc2        SYS_REFCURSOR;
    c          INTEGER;
    ncols      INTEGER;
    dtab       DBMS_SQL.DESC_TAB;
    v_val      VARCHAR2(4000);
    pos_ef     INTEGER := 0;
    pos_ms     INTEGER := 0;
    n_rows     INTEGER := 0;
    n_y        INTEGER := 0;
    n_n        INTEGER := 0;
    n_other    INTEGER := 0;
    -- cursor2
    v_validyn  VARCHAR2(10);
    v_sm       VARCHAR2(20);
    v_em       VARCHAR2(20);
    v_sq       VARCHAR2(20);
    v_eq       VARCHAR2(20);
    v_sy       VARCHAR2(20);
    v_ey       VARCHAR2(20);
BEGIN
    SCM_MGR.PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA(
        p_division_id   => '40',
        p_dept_id       => 'ALL',
        p_end_customer  => 'ALL',
        p_scm_site_id   => 'ALL',
        p_project_code  => '',
        p_item_id       => '',
        p_item_type     => 'ALL',
        p_from_yyyymmdd => '20260801',
        p_now_yyyymmdd  => '20260803',
        p_to_yyyymmdd   => '20270228',
        p_created_by    => 'minyonglee1',
        p_plant_site_id => 'ALL',
        p_biztype       => 'ALL',
        p_userinfo      => 'ADMIN',
        p_owner         => '',
        p_qty_yn        => 'N',
        p_cursor1       => rc1,
        p_cursor2       => rc2 );

    -- 커서1 → DBMS_SQL 로 컬럼 목록/값 스캔
    c := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
    DBMS_SQL.DESCRIBE_COLUMNS(c, ncols, dtab);
    FOR i IN 1..ncols LOOP
        IF dtab(i).col_name = 'EDIT_FLAG' THEN pos_ef := i; END IF;
        IF dtab(i).col_name = 'MEASURE'   THEN pos_ms := i; END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('CURSOR1 cols='||ncols
        ||'  EDIT_FLAG_COL='||CASE WHEN pos_ef>0 THEN 'YES(#'||pos_ef||')' ELSE '*** MISSING ***' END
        ||'  MEASURE_COL='  ||CASE WHEN pos_ms>0 THEN 'YES(#'||pos_ms||')' ELSE '*** MISSING ***' END);

    IF pos_ef > 0 THEN
        DBMS_SQL.DEFINE_COLUMN(c, pos_ef, v_val, 4000);
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            n_rows := n_rows + 1;
            DBMS_SQL.COLUMN_VALUE(c, pos_ef, v_val);
            IF    v_val = 'Y' THEN n_y := n_y + 1;
            ELSIF v_val = 'N' THEN n_n := n_n + 1;
            ELSE  n_other := n_other + 1;
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('rows='||n_rows||'  EDIT_FLAG: Y='||n_y||' N='||n_n||' other='||n_other);
    ELSE
        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP n_rows := n_rows + 1; END LOOP;
        DBMS_OUTPUT.PUT_LINE('rows='||n_rows||'  (EDIT_FLAG 컬럼 부재 — FE 전행 잠금의 원인)');
    END IF;
    DBMS_SQL.CLOSE_CURSOR(c);

    -- 커서2 (40 유효구간 — Q_/Y_ 버킷 편집 게이트 원천 = LOOKUP 'DM_LONG_PLAN')
    BEGIN
        FETCH rc2 INTO v_validyn, v_sm, v_em, v_sq, v_eq, v_sy, v_ey;
        IF rc2%FOUND THEN
            DBMS_OUTPUT.PUT_LINE('CURSOR2: VALID_YN='||NVL(v_validyn,'(null)')
                ||' START_YYYYMM='||NVL(v_sm,'(null)')||' END_YYYYMM='||NVL(v_em,'(null)')
                ||' START_YYYYQQ='||NVL(v_sq,'(null)')||' END_YYYYQQ='||NVL(v_eq,'(null)')
                ||' START_YYYY='||NVL(v_sy,'(null)')||' END_YYYY='||NVL(v_ey,'(null)'));
        ELSE
            DBMS_OUTPUT.PUT_LINE('CURSOR2: 0 rows');
        END IF;
        CLOSE rc2;
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('CURSOR2 fetch err: '||SUBSTR(SQLERRM,1,200));
    END;

    ROLLBACK;   -- GTT 잔존 정리
END;
/
