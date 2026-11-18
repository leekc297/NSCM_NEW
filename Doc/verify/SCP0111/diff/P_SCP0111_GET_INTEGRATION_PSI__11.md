# SCP0111 · SCP0111_GET_INTEGRATION_PSI ↔ PKG_SCP0111.P_SCP0111_GET_INTEGRATION_PSI

- 실행 2026-11-18 11:01:32 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 키 없이 행 집합 대조 — 셋1 AS-IS 0행/TO-BE 0행(공통 0 · AS-IS 전용 0 · TO-BE 전용 0) · 행을 잇는 키 없음(key_map.csv 에 지정하면 셀 단위 대조) → 판정필요 · 키 원천 (행 집합) · 키  · golden 집합 판정 PASS
- 호출 #11 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SCP0111\calls\_verify_Division별_조회_오류_콤보_이름_F4_A2__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81_HD", "planStartYyyymmdd": "20261026", "planType": "", "seq": "", "fromYyyymm": "202610", "toYyyymm": "202703", "nickName": "", "cellItemId": "", "itemId": "", "qtyYn": "N"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81_HD", "p_plan_start_yyyymmdd": "20261026", "p_plan_type": "", "p_seq": "", "p_from_yyyymm": "202610", "p_to_yyyymm": "202703", "p_nick_name": "", "p_cellitem_id": "", "p_item_id": "", "p_qty_yn": "N"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81_HD", "p_plan_start_yyyymmdd": "20261026", "p_plan_type": "ALL", "p_seq": "ALL", "p_from_yyyymm": "202610", "p_to_yyyymm": "202703", "p_nick_name": "ALL", "p_cellitem_id": "ALL", "p_item_id": "ALL", "p_qty_yn": "N"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
