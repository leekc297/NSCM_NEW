-- ============================================================================
-- DMF0082 Excel 기능 — BODY 델타 스니펫 (수동 재적용용, 2026-08-14)
--   ⚠ 이 파일은 '실행 스크립트가 아니라 삽입할 조각' 이다.
--      기반(base) 본문이 백업 시점과 다르면 db/CURRENT_*.sql 통짜 덮어쓰기 대신
--      아래 조각을 각 앵커에 넣어야 타 세션 변경분을 지우지 않는다.
-- ============================================================================

-- [E1] 패키지 전역 — BODY 선두(첫 PROCEDURE 앞)에 삽입
    --[E20260813-UPLOADSAVE] Excel Upload 적재 경로 전용 플래그.
    --   P_DMF0082_SAVE_MAIN_DATA 의 '^' 파싱부를 건너뛰게 한다(본체는 무수정 재사용).
    --   시그니처를 바꾸지 않으므로 PROC_M/BE/FE 배선은 손댈 필요가 없다.
    g_skip_parse VARCHAR2(1 CHAR) := 'N';

-- [E2] P_DMF0082_SAVE_MAIN_DATA 선언부 — v_p_as_from_site_raw 선언 바로 뒤에 삽입
    --[E20260813-UPLOADSAVE] '^' 파싱부 skip 여부 (Excel Upload 적재 경로가 GT_PRDM1_T_MAIN 을 직접 적재)
    v_skip_parse        VARCHAR2(1 CHAR);

-- [E3] P_DMF0082_SAVE_MAIN_DATA 본문 — 원본의 'DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;' 1줄을 아래로 교체
    --[E20260813-UPLOADSAVE] 패키지 전역 플래그를 **1회용으로 소비**한다 (세션 누수 방지).
    --   화면 저장 경로는 g_skip_parse 를 세팅하지 않으므로 항상 'N' = 종전과 완전히 동일하게 동작.
    v_skip_parse := NVL(g_skip_parse, 'N');
    g_skip_parse := 'N';

    IF v_skip_parse = 'N' THEN
        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;
    END IF;

-- [E4] 파싱부 래핑 — '-- 마지막 데이터 처리를 위한 구분자 추가' 줄 앞에 여는 IF,
--      그 아래 'IF i_count > 0 THEN ... END IF;' 블록이 끝난 직후에 닫는 END IF 를 넣는다.
    IF v_skip_parse = 'N' THEN   --[E20260813-UPLOADSAVE] 파싱부 시작
    ...  (원본 '^' 파싱 블록 그대로 — 수정 없음)
    END IF;   --[E20260813-UPLOADSAVE] 파싱부 끝

-- [E5] P_DMF0082_EXCEL_UPLOAD — 검증분기(IF NVL(p_mode,0)=0 THEN ...) 의 END IF; 직전에 삽입
--      + 같은 SP 선언부에 v_rc_a/v_rc_b/v_rc_c/v_rc_save/v_save_code/v_save_msg/v_save_event/n_save_cnt 추가
    ELSE
        --================================================================================================
        -- [E20260813-UPLOADSAVE] p_mode > 0 : 검증 통과분을 **원장에 적재**한다.
        --   수신 원본에는 이 분기가 아예 없어 OK(2단계)가 원장에 아무것도 쓰지 않았다 (2026-08-13 실측).
        --   적재는 화면 저장과 **동일 경로**(P_DMF0082_SAVE_MAIN_DATA 본체)를 재사용한다 —
        --   MERGE 5종과 검증 게이트를 복제하지 않기 위해, 그 SP 의 '^' 파싱부만 건너뛰고(g_skip_parse)
        --   GT_PRDM1_T_MAIN 을 집합으로 채운 뒤 본체를 **1회** 호출한다.
        --   (행 단위 호출은 파싱 로컬이 VARCHAR2(4000) 이라 호출 폭증 — 사용자 확정: 본체 1회 호출)
        --================================================================================================
        SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'SUCCESS' THEN 1 END)
             , COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'ERROR'   THEN 1 END)
        INTO   n_success_cnt, n_error_cnt
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

        -- 전량 게이트 — 오류 1건이라도 남았거나 대상이 없으면 적재하지 않는다 (FE 전량 게이트와 이중 방어)
        IF n_error_cnt > 0 OR n_success_cnt = 0 THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS RESULT_CODE
                     , 'NOT_SAVABLE (SUCCESS=' || TO_CHAR(n_success_cnt)
                       || ', ERROR=' || TO_CHAR(n_error_cnt) || ')' AS RESULT_MSG
                     , TO_CHAR(NVL(p_mode, 0)) AS EVENT
                FROM   DUAL;
            RETURN;

-- [E6] 검증 확장 — 숫자/음수/0 3개 UPDATE 블록의 M12 항 뒤에 M13~M16(ATTRIBUTE20~23) 추가
--      (아래는 '숫자' 블록 예시. 음수는 '< 0', 0 은 '= 0' 비교로 동형 추가)
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 0) OR --M12
                   (ATTRIBUTE20 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE20 AS NUMBER) = 0) OR --M13
                   (ATTRIBUTE21 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE21 AS NUMBER) = 0) OR --M14
                   (ATTRIBUTE22 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE22 AS NUMBER) = 0) OR --M15
                   (ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23 AS NUMBER) = 0)    --M16  --[E20260813-UPLOADSAVE] M13~M16 검증 확장
