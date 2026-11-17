# SSP0014 · SSP0014_GET_SHIPMENT_MODEL_PIC ↔ PKG_SSP0014.P_SSP0014_GET_MODEL_PIC

- 실행 2026-11-14 21:02:03 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+FROM_SITE+ITEM_ID) — AS-IS 0행 ↔ TO-BE 10행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+FROM_SITE+ITEM_ID · golden 집합 판정 DIFF
- 호출 #26 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 11 · 원천 Doc\verify\SSP0014\calls\_verify_조회조건_텍스트_대소문자_무시_G8_콤마_다중값_G9__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "operationGroup": "", "fromSite": "", "validYn": "", "itemId": "AMM9314U0A1-01", "userId": "", "language": "KO"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_operation_group": "", "p_from_site": "", "p_valid_yn": "", "p_item_id": "AMM9314U0A1-01", "p_user_id": "", "p_language": "KO"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40", "p_operation_group": "ALL", "p_from_site": "ALL", "p_valid_yn": "ALL", "p_item_id": "AMM9314U0A1-01", "p_user_id": "ALL", "p_language": "KO"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 10행
- 행수 불일치 0 ↔ 10
- 값 차이: As-is 전용 0행 / To-Be 전용 10행 (공통 컬럼 21)
| 측 | DIVISION_ID | OPERATION_GROUP | FROM_SITE | ITEM_ID | NICK_NAME | USER_ID | USER_NAME | PART_LEADER | PART_LEADER_NAME | TEAM_LEADER | TEAM_LEADER_NAME | VALID_YN |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 | A | AZ00-A | MAMM9314U0A1-016 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | AZ00-A | MAMM9314U0A1-018 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-010 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-011 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-012 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-014 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-015 | N32S2 | insung_ho | 호인성 |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-016 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-017 | N32S2 |  |  |  |  |  |  | Y |
| T | 40 | A | HQ10-A | MAMM9314U0A1-019 | N32S2 |  |  |  |  |  |  | Y |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 10행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
