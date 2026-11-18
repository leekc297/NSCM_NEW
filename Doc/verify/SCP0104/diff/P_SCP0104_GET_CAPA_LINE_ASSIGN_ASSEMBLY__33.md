# SCP0104 · SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY ↔ PKG_SCP0104.P_SCP0104_GET_CAPA_LINE_ASSIGN_ASSEMBLY

- 실행 2026-11-18 10:50:43 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 키 없이 판정 — 전 결과셋 행 집합 완전 일치(셋1 136행 · 한쪽 전용 0) · 키 원천 (행 집합) · 키  · golden 집합 판정 PASS
- 호출 #33 sheet=ASSEMBLY btn=SEARCH user=minyonglee1 FE 응답 행 137 · 원천 Doc\verify\SCP0104\calls\_verify_Division_컬럼_A5__0.json
- TO-BE 인자(FE 본문): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "82", "p_site_id": "A001,A002,A003,A004,A009", "p_plant_id": "HQ08,MI01,NB02,NJ02,VP_GM01,VP_HD00,VP_MI02,VP_ST00,WA01", "p_factory_id": "S2,S3,S4,S5,S7,S8,S9,VF_AE,VF_AG,VF_AH,VF_AJ", "p_line_id": "FP_S3E01L-1,FP_S3E01L-2,S5E03,S5EV3,S2E01,S3E01,S3E02,S3E03,S3EH1,S3EV1,S4E01,S4EB1,S4EB2,S4EH1,S4EH2,S4EL2,S7E10,S7E11,S7E12,S7EH1,S8E01,S8E02,S8E03,S8E04,S8E05,S8EH1,S9E01,S9E02,S9E03,S9EV1,VL_AEA01,VL_AEA02,VL_AEA03,VL_AEE01,VL_AEE02,VL_AEE03,VL_AGA01,VL_AGA02,VL_AGA03,VL_AGA04,VL_AHA02,VL_AJA04,VL_AJA05,VL_AJA06", "p_operation_id": "A5000,A7000,A7400,A8000,A8400,A9000,AFFFF", "p_electrode_type": "Anode,Cathode,A,C,Half,Mono,Folding,Stacking,AZS Stacking", "p_valid_flag": "", "p_program_id": "SCP0104", "debug_mode": "F", "p_item_id": "", "p_sheet_name": "ASSEMBLY"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_version": "202610", "p_version_seq": "1", "p_division_id": "82", "p_site_id": "A001,A002,A003,A004,A009", "p_plant_id": "HQ08,MI01,NB02,NJ02,VP_GM01,VP_HD00,VP_MI02,VP_ST00,WA01", "p_factory_id": "S2,S3,S4,S5,S7,S8,S9,VF_AE,VF_AG,VF_AH,VF_AJ", "p_line_id": "FP_S3E01L-1,FP_S3E01L-2,S5E03,S5EV3,S2E01,S3E01,S3E02,S3E03,S3EH1,S3EV1,S4E01,S4EB1,S4EB2,S4EH1,S4EH2,S4EL2,S7E10,S7E11,S7E12,S7EH1,S8E01,S8E02,S8E03,S8E04,S8E05,S8EH1,S9E01,S9E02,S9E03,S9EV1,VL_AEA01,VL_AEA02,VL_AEA03,VL_AEE01,VL_AEE02,VL_AEE03,VL_AGA01,VL_AGA02,VL_AGA03,VL_AGA04,VL_AHA02,VL_AJA04,VL_AJA05,VL_AJA06", "p_operation_id": "A5000,A7000,A7400,A8000,A8400,A9000,AFFFF", "p_item_id": "", "p_electrode_type": "Anode,Cathode,A,C,Half,Mono,Folding,Stacking,AZS Stacking", "p_valid_flag": "", "p_program_id": "SCP0104", "p_sheet_name": "ASSEMBLY", "p_user_id": "", "debug_mode": "F"}` · 번역 메모: p_user_id: 본문에 userId 없음 → default ''
- TO-BE 인자 중 값 없음(NULL 전달): P_USER_ID

### 결과셋 1  As-is 136행 ↔ To-Be O_RC1 136행
- 일치
- 데이터 기준: 공통 136행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 136행의 상대 순서): 일치
