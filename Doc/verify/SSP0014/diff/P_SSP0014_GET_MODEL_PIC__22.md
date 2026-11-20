# SSP0014 · SSP0014_GET_SHIPMENT_MODEL_PIC ↔ PKG_SSP0014.P_SSP0014_GET_MODEL_PIC

- 실행 2026-11-20 09:34:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 31행 전 컬럼 일치 · 단독행 AS-IS 0 / TO-BE 24 · 키 원천 cleanup_spec.json · 키 DIVISION_ID+FROM_SITE+ITEM_ID · golden 집합 판정 DIFF
- 호출 #22 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 56 · 원천 Doc\verify\SSP0014\calls\_verify_Division별_조회_오류_콤보_이름_F4_A2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_ST", "operationGroup": "", "fromSite": "", "validYn": "", "itemId": "", "userId": "", "language": "KO"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81_ST", "p_operation_group": "", "p_from_site": "", "p_valid_yn": "", "p_item_id": "", "p_user_id": "", "p_language": "KO"}`

### 결과셋 1  As-is 31행 ↔ To-Be O_RC1 55행
- 행수 불일치 31 ↔ 55
- 값 차이: As-is 전용 0행 / To-Be 전용 24행 (공통 컬럼 21)
| 측 | DIVISION_ID | OPERATION_GROUP | FROM_SITE | ITEM_ID | NICK_NAME | USER_ID | USER_NAME | PART_LEADER | PART_LEADER_NAME | TEAM_LEADER | TEAM_LEADER_NAME | VALID_YN |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 81_ST | P | ST00-P | EP096636PFBAD0D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAD0D3 |  |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAD1D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAD1D3 |  |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAD2D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAD2D3 |  |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAD3D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAD3D3 |  |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAE0D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 81_ST | P | ST00-P | EP096636PFBAE0D3 |  |  |  |  |  |  |  | Y |
- 데이터 기준: 공통 31행 · AS-IS 전용 0행 · TO-BE 전용 24행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 31행의 상대 순서): 일치
