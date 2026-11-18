# SCP0104 · SCP0104_GET_CAPA_LINE_ASSIGN_ELTR ↔ PKG_SCP0104.P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR

- 실행 2026-11-18 10:50:43 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 6행 전 컬럼 일치 · 키 원천 auto · 키 LINE_ID · golden 집합 판정 PASS
- 호출 #22 sheet=ELTR btn=SEARCH user=minyonglee1 FE 응답 행 7 · 원천 Doc\verify\SCP0104\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81", "p_site_id": "A001,A002,A003,A004", "p_plant_id": "HQ07,HQ11,MI00,MI02,MI03,NA00,NB01,WA00", "p_factory_id": "ET", "p_line_id": "ETD02,FP_ETM01_C,FP_ETM01_A,FP_ETM02_C,FP_ETM02_A,FP_ETM03_C,FP_ETM03_A,FP_ETM04_C,FP_ETM04_A,DMY_3801,DMY_3802,DMY_3803,DMY_3804,DMY_3805,DMY_3806,DMY_3807", "p_operation_id": "E2000", "p_electrode_type": "", "p_valid_flag": "", "p_program_id": "SCP0104", "debug_mode": "F", "p_item_id": "", "p_sheet_name": "ELTR"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "81", "p_site_id": "A001,A002,A003,A004", "p_plant_id": "HQ07,HQ11,MI00,MI02,MI03,NA00,NB01,WA00", "p_factory_id": "ET", "p_line_id": "ETD02,FP_ETM01_C,FP_ETM01_A,FP_ETM02_C,FP_ETM02_A,FP_ETM03_C,FP_ETM03_A,FP_ETM04_C,FP_ETM04_A,DMY_3801,DMY_3802,DMY_3803,DMY_3804,DMY_3805,DMY_3806,DMY_3807", "p_operation_id": "E2000", "p_item_id": "", "p_electrode_type": "", "p_valid_flag": "", "p_program_id": "SCP0104", "p_sheet_name": "ELTR", "p_user_id": "", "debug_mode": "F"}` · 번역 메모: p_user_id: 본문에 userId 없음 → default ''
- TO-BE 인자 중 값 없음(NULL 전달): P_USER_ID

### 결과셋 1  As-is 6행 ↔ To-Be O_RC1 6행
- 일치
- 데이터 기준: 공통 6행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 6행의 상대 순서): 일치
