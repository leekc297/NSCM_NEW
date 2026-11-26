# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT

- 실행: 2026-11-25 02:48:58
- 파라미터: `{"p_division_id": "40", "p_operation_group": "A", "p_from_site": "HQ05-W", "p_to_site": "Audi_SK_BTS", "p_item_id": "MCCM134010A1", "p_user_id": "bpark416"}`
- 종류: GET
- 빈 인자 p_from_site, p_operation_group, p_to_site = TO-BE 호출 기록 sqllog_calls.json #7083192 실측 인자(2026-11-25 01:18:51)

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 0행
- 일치
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
