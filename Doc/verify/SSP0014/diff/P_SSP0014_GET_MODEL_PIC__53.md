# SSP0014 · SSP0014_GET_SHIPMENT_MODEL_PIC ↔ PKG_SSP0014.P_SSP0014_GET_MODEL_PIC

- 실행 2026-11-20 09:34:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 2행 전 컬럼 일치 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+FROM_SITE+ITEM_ID · golden 집합 판정 PASS
- 호출 #53 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SSP0014\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "operationGroup": "", "fromSite": "", "validYn": "", "itemId": "mamm9314u0a1-016", "userId": "", "language": "KO"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_operation_group": "", "p_from_site": "", "p_valid_yn": "", "p_item_id": "mamm9314u0a1-016", "p_user_id": "", "p_language": "KO"}`

### 결과셋 1  As-is 2행 ↔ To-Be O_RC1 2행
- 일치
- 데이터 기준: 공통 2행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2행의 상대 순서): 일치
