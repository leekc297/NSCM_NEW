# SCP0104 · SCP0104_GET_CAPA_LINE_ASSIGN_ELTR ↔ PKG_SCP0104.P_SCP0104_GET_CAPA_LINE_ASSIGN_ELTR

- 실행 2026-11-17 17:19:44 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 26행 전 컬럼 일치 · 키 원천 auto · 키 ITEM_ID+LINE_ID · golden 집합 판정 PASS
- 호출 #15 sheet=ELTR btn=SEARCH user=minyonglee1 FE 응답 행 27 · 원천 Doc\verify\SCP0104\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "82", "p_site_id": "A001,A002,A003,A004,A009", "p_plant_id": "HQ08,MI01,MI04,NB02,NJ02,VP_GM01,VP_HD00,VP_MI02,VP_ST00,WA01", "p_factory_id": "EW,EX,S6", "p_line_id": "FP_EWM01_C,FP_EWM01_A,FP_EWM02_C,FP_EWM02_A,FP_EWM03_C,FP_EWM03_A,FP_EWM05_C,FP_EWM05_A,FP_EXM01_C,FP_EXM01_A,FP_EXM02_C,FP_EXM02_A", "p_operation_id": "E2000", "p_electrode_type": "", "p_valid_flag": "", "p_program_id": "SCP0104", "debug_mode": "F", "p_item_id": "", "p_sheet_name": "ELTR"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 2종 중 최다(6회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'kang_huichan'}]
- AS-IS 인자(번역): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "82", "p_site_id": "A001,A002,A003,A004,A009", "p_plant_id": "HQ08,MI01,MI04,NB02,NJ02,VP_GM01,VP_HD00,VP_MI02,VP_ST00,WA01", "p_factory_id": "EW,EX,S6", "p_line_id": "FP_EWM01_C,FP_EWM01_A,FP_EWM02_C,FP_EWM02_A,FP_EWM03_C,FP_EWM03_A,FP_EWM05_C,FP_EWM05_A,FP_EXM01_C,FP_EXM01_A,FP_EXM02_C,FP_EXM02_A", "p_operation_id": "E2000", "p_item_id": "", "p_electrode_type": "", "p_valid_flag": "", "p_program_id": "SCP0104", "p_sheet_name": "ELTR", "p_user_id": "", "debug_mode": "F"}` · 번역 메모: p_user_id: 본문에 userId 없음 → default ''
- TO-BE 인자 중 값 없음(NULL 전달): P_USER_ID

### 결과셋 1  As-is 26행 ↔ To-Be O_RC1 26행
- 일치
- 데이터 기준: 공통 26행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 26행의 상대 순서): 일치
