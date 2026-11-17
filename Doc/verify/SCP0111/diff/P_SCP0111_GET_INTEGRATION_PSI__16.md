# SCP0111 · SCP0111_GET_INTEGRATION_PSI ↔ PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI

- 실행 2026-11-14 16:46:11 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 2행 전 컬럼 일치 · 키 원천 auto · 키 NICK_NAME · golden 집합 판정 PASS
- 호출 #16 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SCP0111\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "planStartYyyymmdd": "20260907", "planType": "", "seq": "", "fromYyyymm": "202609", "toYyyymm": "202702", "nickName": "", "cellItemId": "", "itemId": "AMDAU0098M,AMDAU0099M", "qtyYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_plan_start_yyyymmdd": "20260907", "p_plan_type": "", "p_seq": "", "p_from_yyyymm": "202609", "p_to_yyyymm": "202702", "p_nick_name": "", "p_cellitem_id": "", "p_item_id": "AMDAU0098M,AMDAU0099M", "p_qty_yn": "N"}`

### 결과셋 1  As-is 2행 ↔ To-Be O_RC 2행
- 일치
- 데이터 기준: 공통 2행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2행의 상대 순서): 일치
