# SCP0104 · SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR ↔ PKG_SCP0104.P_SCP0104_GET_CAPA_LINE_ASSIGN_MDL_ELTR

- 실행 2026-11-18 10:50:43 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+COMPANY_ID+SITE_ID+PLANT_ID+FACTORY_ID+LINE_ID+OPERATION_ID+ELTR_LN_TP_CD) — AS-IS 0행 ↔ TO-BE 0행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+COMPANY_ID+SITE_ID+PLANT_ID+FACTORY_ID+LINE_ID+OPERATION_ID+ELTR_LN_TP_CD · golden 집합 판정 PASS
- 호출 #7 sheet=SOP_MODEL_ELTR btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0104\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81_HG", "p_site_id": "A003", "p_plant_id": "HG00", "p_factory_id": "AK", "p_line_id": "AKA02_01,AKA02_02,AKA01,DMY_9429,DMY_9430,DMY_9431,DMY_9432,DMY_9433,DMY_9434,DMY_9435,DMY_9436,DMY_9437", "p_operation_id": "A5000,A7000,A7400,A8000,A8400,A9000,AFFFF", "p_item_id": "", "p_electrode_type": "Anode,Cathode,A,C,Half,Mono,Folding,Stacking,AZS Stacking", "p_program_id": "SCP0104", "p_sheet_name": "SOP_MODEL_ASSEMBLY", "debug_mode": "F"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81_HG", "p_site_id": "A003", "p_plant_id": "HG00", "p_factory_id": "AK", "p_line_id": "AKA02_01,AKA02_02,AKA01,DMY_9429,DMY_9430,DMY_9431,DMY_9432,DMY_9433,DMY_9434,DMY_9435,DMY_9436,DMY_9437", "p_operation_id": "A5000,A7000,A7400,A8000,A8400,A9000,AFFFF", "p_item_id": "", "p_electrode_type": "Anode,Cathode,A,C,Half,Mono,Folding,Stacking,AZS Stacking", "p_program_id": "SCP0104", "p_sheet_name": "SOP_MODEL_ASSEMBLY", "p_user_id": "", "debug_mode": "F"}` · 번역 메모: p_user_id: 본문에 userId 없음 → default ''
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81_HG", "p_site_id": "A003", "p_plant_id": "HG00", "p_factory_id": "AK", "p_line_id": "AKA02_01,AKA02_02,AKA01,DMY_9429,DMY_9430,DMY_9431,DMY_9432,DMY_9433,DMY_9434,DMY_9435,DMY_9436,DMY_9437", "p_operation_id": "A5000,A7000,A7400,A8000,A8400,A9000,AFFFF", "p_item_id": "ALL", "p_electrode_type": "Anode,Cathode,A,C,Half,Mono,Folding,Stacking,AZS Stacking", "p_program_id": "SCP0104", "p_sheet_name": "SOP_MODEL_ASSEMBLY", "p_user_id": `
- TO-BE 인자 중 값 없음(NULL 전달): P_USER_ID

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
