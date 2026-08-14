-- ============================================================================
-- [E20260813-EXCELFORM] DMF0082 Excel Form 조회 SP 신설 — SPEC 선언부
--
--  목적: Excel Form 이 "본인 최종 업로드분 재조회"(P_DMF0082_GET_EXCEL_UPLOAD_DATA)가 아니라
--        **화면 조회조건에 걸린 현재 데이터 전체**를 양식으로 내려주도록 한다 (사용자 요구 2026-08-13).
--
--  계약:
--   - IN 16종 = P_DMF0082_GET_MAIN_DATA 와 **동일 축·동일 명명**
--     (CURRENT SP 가 team/startDate/endDate/version 으로 어긋나 있는 전례를 반복하지 않는다)
--   - 1행 = (조회조건에 걸린 키 조합) × (입력 가능 measure 1종). 월 값 컬럼은 내리지 않는다
--     (M4~M16 빈칸은 FE 가 생성 — 사용자 확정: 입력 전용)
--   - 각 값은 **업로드 검증 SP(P_DMF0082_EXCEL_UPLOAD)가 기대하는 표기 그대로** 내린다.
--     즉 본 SP 는 검증 SP 의 역함수이며, 이로써 양식→업로드 왕복이 구조적으로 보장된다.
-- ============================================================================
PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA (
    p_division_id               IN  VARCHAR2
  , p_dept_id                   IN  VARCHAR2
  , p_end_customer              IN  VARCHAR2
  , p_biz_type                  IN  VARCHAR2
  , p_from_yyyymmdd             IN  VARCHAR2
  , p_to_yyyymmdd               IN  VARCHAR2
  , p_sales_site                IN  VARCHAR2
  , p_item_id                   IN  VARCHAR2
  , p_version_type              IN  VARCHAR2
  , p_qty_yn                    IN  VARCHAR2
  , p_ses_user_id               IN  VARCHAR2
  , p_user_group                IN  VARCHAR2
  , p_plant_site_id             IN  VARCHAR2 DEFAULT 'ALL'
  , p_project_code              IN  VARCHAR2 DEFAULT 'ALL'
  , p_owner                     IN  VARCHAR2 DEFAULT 'ALL'
  , p_sender_code               IN  VARCHAR2 DEFAULT 'ALL'
  , o_rc1                       OUT SYS_REFCURSOR
  , o_result_cursor             OUT SYS_REFCURSOR
);
