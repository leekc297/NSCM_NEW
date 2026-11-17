# SSP0003 · SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM ↔ PKG_SSP0003.P_SSP0003_GET_CHG_REQ_CONFIRM

- 실행 2026-11-14 20:01:46 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 division_id+from_site+change_req_no+shipment_status+change_type) — AS-IS 0행 ↔ TO-BE 2행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 컬럼 집합 차이 AS-IS 전용 [] / TO-BE 전용 ['delegateedept1', 'delegateeuser1'] · 키 원천 db_resultsets.csv is_nullable=0 · 키 division_id+from_site+change_req_no+shipment_status+change_type · golden 집합 판정 DIFF
- 호출 #13 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\SSP0003\calls\_verify_선택_조회_복수_단일_전체_왕복_G2_B6__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40,82", "fromSite": "ALL", "requestId": "", "fromYyyymmdd": "20261031", "toYyyymmdd": "20261114", "status": "D", "language": "KO", "itemId": "", "changeType": "ALL"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40,82", "p_from_site": "", "p_request_id": "", "p_from_yyyymmdd": "20261031", "p_to_yyyymmdd": "20261114", "p_status": "D", "p_language": "KO", "p_item_id": "", "p_change_type": ""}` · 번역 메모: p_from_site: 'ALL'→''(all_semantics: 빈 값 = 전체) · p_change_type: 'ALL'→''(all_semantics: 빈 값 = 전체)
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "40,82", "p_from_site": "ALL", "p_request_id": "ALL", "p_from_yyyymmdd": "20261031", "p_to_yyyymmdd": "20261114", "p_status": "D", "p_language": "KO", "p_item_id": "ALL", "p_change_type": "ALL"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 2행
- As-is 에만 있는 컬럼: -
- To-Be 에만 있는 컬럼: DELEGATEE_USER_1, DELEGATEE_DEPT_1
- 행수 불일치 0 ↔ 2
- 값 차이: As-is 전용 0행 / To-Be 전용 2행 (공통 컬럼 22)
| 측 | division_id | from_site | change_req_no | shipment_status | item_id | nick_name | request_title | change_reason_code | request_user | request_dept | request_time | approval_user |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| T | 40 | HQ06-E | R20261113543180 | D | APCAN1650A | M50F | Change on | T07 | attackgo | 70010540 | 2026-11-13 11:10:26 | attackgo |
| T | 82 | KR00697200_82-P | R20261113543173 | D | ETD1550AFB33-CGB | JF2 DC LINK 5.0 | Change on Shipment Change Requ | T07 | attackgo | 70010540 | 2026-11-13 10:01:06 | attackgo |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 2행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
