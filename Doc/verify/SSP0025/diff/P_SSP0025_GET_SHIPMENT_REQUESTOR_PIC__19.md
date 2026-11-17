# SSP0025 · SSP0025_GET_SHIPMENT_REQUESTOR_PIC ↔ PKG_SSP0025.P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC

- 실행 2026-11-15 05:04:51 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 3행 전 컬럼 일치 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+TO_SITE+ITEM_ID+USER_ID · golden 집합 판정 PASS
- 호출 #19 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 4 · 원천 Doc\verify\SSP0025\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "plantSite": "", "itemId": "APCAN1146A,APCAN1257B", "nickName": "", "modelId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plant_site": "", "p_item_id": "APCAN1146A,APCAN1257B", "p_nick_name": "", "p_model_id": "", "p_language": "KO"}`
- TO-BE 인자 묶음(PROC_M 순서 = BE 방식): sesLangCd→P_LANGUAGE

### 결과셋 1  As-is 3행 ↔ To-Be O_RC1 3행
- 일치
- 데이터 기준: 공통 3행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 3행의 상대 순서): 일치
