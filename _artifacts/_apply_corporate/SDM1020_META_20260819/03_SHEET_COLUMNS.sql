-- =====================================================================================
-- SDM1020 Project List — [03] SHEET_COLUMNS 30행 (SHEET_NAME='Project List' 단일 시트)
-- 2026-08-19 · 원천 = 화면설계서 'UI컬럼 및 Measure정의' 시트 openpyxl 실측 30행(행4~33)
-- POP1_* 5시트는 SDM1010 소유 — 본 파일 미포함 (SDM1020 쪽 삭제/삽입 금지)
-- 정오표 확정 정정 반영:
--   D1 : 커서 2회 SELECT 중복 DPJT_AUTH_REQ_READ — 체크박스 1행만 유지, '권한요청' 링크 행은
--        DPJT_AUTH_REQ_LINK 로 개명(FE 파생 — 커서 미반환, SDM1010 PROCESS 관례 ATTRIBUTE1='REQ_ACTION')
--   D2 : PKG_SDM1020.P_SDM1020_GET_PJT_LIST O_CURSOR 실측 — DPJT_AUTH_REQ_STATUS(실존 유지),
--        _STATUS_NAME→DPJT_AUTH_REQ_WRITE_NAME, _STATUS_COLOR_TYPE→DPJT_AUTH_REQ_WRITE_COLOR_TYPE
--   D5 : INPUT_TP_CD — DIVISION_ID/DPJT_CLASS/END_CUSTOMER/DPJT_NAME=IM,
--        CELL_TYPE/STACK_METHOD/BIZ_TYPE/SOP_DATE/SOP_PLANT_ID/DPJT_AUTH_REQ_WRITE/READ=IO, 그 외=S
--   D6 : SORT_ORDER_NO — GRID 시트 목업 컬럼 순서 기준 10단위 재부여 (xlsx 중복 정정)
--   D7 : DPJT_AUTH_MGMT = SDM1010 권한관리 링크 관례 (FPModal + ATTRIBUTE1='ProjectAuthRegModal')
--   D11: 라벨 오타 정정 (Stock Method→Stack Method / Develoment→Development)
--   Biz Type 셀 콤보 = BizTypeByDivision (사용자 확정 — DmBizType 아님)
--   FPDate→FPDateText, TAG→CELL_CONTROL 'S'+ATTRIBUTE1 'TAG' (SDM1010 DB 실행분 관례)
--   라벨 '*' 4종(Division*/Project Class*/Customer*/Project Name*)은 편집필수 표기 → INPUT_TP_CD='IM' 로 흡수, 라벨에서 제거
-- 멱등: 대상 한정 DELETE 후 INSERT (hook #98 §9)
-- =====================================================================================
DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'SDM1020' AND SHEET_NAME = 'Project List';

INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS
    (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, FIXED_FLAG, COLUMN_WIDTH,
     CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG,
     VISIBLE_FLAG, DIVISION_ID, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, INPUT_TP_CD, ATTRIBUTE1,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SDM1020', 'Project List', T.CN, T.LB, T.SO, 'N', T.W, T.CT, T.CB, T.AL, 'N',
       T.VI, NULL, T.DF, T.SE, 'Y', T.IP, T.A1, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'DPJT_KEY' CN, 'Project Key' LB, 10 SO, 0 W, 'S' CT, NULL CB, 'L' AL, 'N' VI, 'Y' DF, 'N' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_SEQ' CN, 'Project Sequence' LB, 20 SO, 0 W, 'S' CT, NULL CB, 'L' AL, 'N' VI, 'Y' DF, 'N' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DIVISION_ID' CN, 'Division' LB, 30 SO, 30 W, 'FPComboBox' CT, 'Division' CB, 'L' AL, 'Y' VI, 'Y' DF, 'N' SE, 'IM' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_CLASS' CN, 'Project Class' LB, 40 SO, 80 W, 'FPComboBox' CT, 'DpjtClass' CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IM' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'END_CUSTOMER' CN, 'Customer' LB, 50 SO, 80 W, 'FPComboBox' CT, 'EndCustomerByDivisionDept' CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IM' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_NAME' CN, 'Project Name' LB, 60 SO, 100 W, 'FPTextBox' CT, NULL CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IM' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'CELL_TYPE' CN, 'Cell Type' LB, 70 SO, 80 W, 'FPComboBox' CT, 'CellTypeByDivision' CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IO' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'STACK_METHOD' CN, 'Stack Method' LB, 80 SO, 80 W, 'FPComboBox' CT, 'StackMethodByCellType' CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IO' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'BIZ_TYPE' CN, 'Biz Type' LB, 90 SO, 80 W, 'FPComboBox' CT, 'BizTypeByDivision' CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IO' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'SOP_DATE' CN, 'SOP Date' LB, 100 SO, 80 W, 'FPDateText' CT, 'YYYY.MM.DD' CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IO' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'SOP_PLANT_ID' CN, 'SOP Plant' LB, 110 SO, 80 W, 'FPComboBox' CT, 'PlantByDivisionCompany' CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IO' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_CODE' CN, 'Project Code' LB, 120 SO, 60 W, 'S' CT, NULL CB, 'L' AL, 'Y' VI, 'Y' DF, 'N' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DEPT_ID' CN, 'Department' LB, 130 SO, 100 W, 'S' CT, NULL CB, 'L' AL, 'N' VI, 'N' DF, 'Y' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DEPT_NAME' CN, 'Department' LB, 140 SO, 100 W, 'S' CT, NULL CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'MGMT_USER_ID' CN, 'User' LB, 150 SO, 0 W, 'S' CT, NULL CB, 'L' AL, 'N' VI, 'N' DF, 'Y' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'USER_NAME' CN, 'User' LB, 160 SO, 80 W, 'S' CT, NULL CB, 'L' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_TYPE' CN, 'Project Own Auth' LB, 170 SO, 40 W, 'S' CT, NULL CB, 'L' AL, 'N' VI, 'Y' DF, 'N' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_TYPE_NAME' CN, 'Project Own Auth' LB, 180 SO, 40 W, 'S' CT, NULL CB, 'L' AL, 'Y' VI, 'Y' DF, 'N' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_REG_STATUS' CN, 'Reg Status' LB, 190 SO, 80 W, 'S' CT, NULL CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, 'TAG' A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_REG_STATUS_NAME' CN, 'Reg Status' LB, 200 SO, 80 W, 'S' CT, NULL CB, 'C' AL, 'N' VI, 'N' DF, 'Y' SE, 'S' IP, 'TAG' A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_REG_STATUS_COLOR_TYPE' CN, 'Reg Status' LB, 210 SO, 80 W, 'S' CT, NULL CB, 'C' AL, 'N' VI, 'N' DF, 'Y' SE, 'S' IP, 'TAG' A1 FROM DUAL
    UNION ALL
    SELECT 'REG_COMP_DATE' CN, 'Reg Complete Date' LB, 220 SO, 80 W, 'FPDateText' CT, 'YYYY.MM.DD' CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_DEVELOP_STATUS' CN, 'Development Status' LB, 230 SO, 80 W, 'FPComboBox' CT, 'DpjtDevelopStatus' CB, 'C' AL, 'Y' VI, 'Y' DF, 'N' SE, 'S' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_MGMT' CN, 'Auth Management' LB, 240 SO, 80 W, 'FPModal' CT, NULL CB, 'L' AL, 'Y' VI, 'Y' DF, 'N' SE, 'S' IP, 'ProjectAuthRegModal' A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_REQ_STATUS' CN, 'Auth Request Status' LB, 250 SO, 80 W, 'S' CT, NULL CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, 'TAG' A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_REQ_WRITE_NAME' CN, 'Auth Request Status' LB, 260 SO, 80 W, 'S' CT, NULL CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, 'TAG' A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_REQ_WRITE_COLOR_TYPE' CN, 'Auth Request Status' LB, 270 SO, 80 W, 'S' CT, NULL CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, 'TAG' A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_REQ_WRITE' CN, 'Auth Request Write' LB, 280 SO, 30 W, 'FPCheckBox' CT, NULL CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IO' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_REQ_READ' CN, 'Auth Request Read' LB, 290 SO, 30 W, 'FPCheckBox' CT, NULL CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'IO' IP, NULL A1 FROM DUAL
    UNION ALL
    SELECT 'DPJT_AUTH_REQ_LINK' CN, 'Auth Request' LB, 300 SO, 40 W, 'S' CT, NULL CB, 'C' AL, 'Y' VI, 'N' DF, 'Y' SE, 'S' IP, 'REQ_ACTION' A1 FROM DUAL
  ) T;

COMMIT;
