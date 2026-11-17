# SCP0104 · SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ASSEMBLY ↔ PKG_SCP0104.P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ASSEMBLY

- 실행 2026-11-17 17:19:44 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+COMPANY_ID+SITE_ID+PLANT_ID+FACTORY_ID+LINE_ID+OPERATION_ID+ELTR_LN_TP_CD) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+COMPANY_ID+SITE_ID+PLANT_ID+FACTORY_ID+LINE_ID+OPERATION_ID+ELTR_LN_TP_CD · golden 집합 판정 PASS
- 호출 #31 sheet=SOP_MODEL_ASSEMBLY btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0104\calls\_verify_Division_컬럼_A5__0.json
- TO-BE 인자(FE 본문): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81_HG", "p_site_id": "A003", "p_plant_id": "HG00", "p_factory_id": "EV", "p_line_id": "FP_EVD01_C,FP_EVD01_A,DMY_9099,DMY_9100,DMY_9101,DMY_9102,DMY_9103,DMY_9104", "p_operation_id": "E2000", "p_item_id": "", "p_electrode_type": "", "p_program_id": "SCP0104", "p_sheet_name": "SOP_MODEL_ELTR", "debug_mode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81_HG", "p_site_id": "A003", "p_plant_id": "HG00", "p_factory_id": "EV", "p_line_id": "FP_EVD01_C,FP_EVD01_A,DMY_9099,DMY_9100,DMY_9101,DMY_9102,DMY_9103,DMY_9104", "p_operation_id": "E2000", "p_item_id": "", "p_electrode_type": "", "p_program_id": "SCP0104", "p_sheet_name": "SOP_MODEL_ELTR", "p_user_id": "", "debug_mode": "F"}` · 번역 메모: p_user_id: 본문에 userId 없음 → default ''
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81_HG", "p_site_id": "A003", "p_plant_id": "HG00", "p_factory_id": "EV", "p_line_id": "FP_EVD01_C,FP_EVD01_A,DMY_9099,DMY_9100,DMY_9101,DMY_9102,DMY_9103,DMY_9104", "p_operation_id": "E2000", "p_item_id": "ALL", "p_electrode_type": "ALL", "p_program_id": "SCP0104", "p_sheet_name": "SOP_MODEL_ELTR", "p_user_id": "ALL", "debug_mode": "F"}`
- TO-BE 인자 중 값 없음(NULL 전달): P_USER_ID

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
