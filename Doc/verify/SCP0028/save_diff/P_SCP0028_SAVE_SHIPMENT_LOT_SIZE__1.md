# SCP0028 저장 대조 · SCP0028_SAVE_SHIPMENT_LOT_SIZE ↔ PKG_SCP0028.P_SCP0028_SAVE_SHIPMENT_LOT_SIZE

- 실행 2026-11-11 16:30:14 · 본문 = 사내 호출 로그 #4453752 (2026-11-10 09:19:31 · minyonglee1)
- **판정 PASS** — SCM_SYS_LOG_BATCH: 로그 표 — 대조 제외(행 수 변화 AS-IS 2 / TO-BE None) | SCP_MST_SHIPMENT_LOT_SIZE: 쓴 행 2행 · 공통 컬럼 20개 값 일치 · 행 수 변화 0 | SCP_MST_SHIPMENT_LOT_SIZE_H: 쓴 행 2행 · 공통 컬럼 20개 값 일치 · 행 수 변화 2 · 대조 제외(일련번호·실행 시각) ['HISTORY_CREATION_DATE', 'HISTORY_SEQ']
- TO-BE 본문: `{"splitYn": "N^N", "lotSize": "12800^5760", "increment": "12800^288", "userId": "minyonglee1", "itemId": "ACEP2065I-B1^ACEN1053I-A1", "toSite": "Club Car_US_AGS^CS Enertech_KR_OSN", "transportMode": "SEA^TRK", "validYn": "Y^Y", "divisionId": "81^81", "operationGroup": "A^A", "debugMode": "N", "fromSite": "HQ07-A^HQ07-A", "activeFlag": "M^M", "sesLangCd": "EN", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_active_flag": "M^M", "p_division_id": "81^81", "p_operation_group": "A^A", "p_from_site": "HQ07-A^HQ07-A", "p_to_site": "Club Car_US_AGS^CS Enertech_KR_OSN", "p_item_id": "ACEP2065I-B1^ACEN1053I-A1", "p_transport_mode": "SEA^TRK", "p_lot_size": "12800^5760", "p_increment": "12800^288", "p_split_yn": "N^N", "p_valid_yn": "Y^Y", "p_user_id": "minyonglee1", "debug_mode": "N"}`
- TO-BE 방식: 실제 저장 후 복원 · 대상 표 ['SCM_SYS_LOG_BATCH', 'SCP_MST_SHIPMENT_LOT_SIZE', 'SCP_MST_SHIPMENT_LOT_SIZE_H'] · 복원 {"SCP_MST_SHIPMENT_LOT_SIZE": "삭제 2 · 재삽입 2 · 실행 전과 차이 0", "SCP_MST_SHIPMENT_LOT_SIZE_H": "삭제 2 · 재삽입 0 · 실행 전과 차이 0"}
- AS-IS: @@TRANCOUNT(EXEC 직후) 3 · 결과 [{"result_code": "S", "result_cnt": "2"}]
- TO-BE: 결과 [{"cursor": "O_RESULT_CURSOR", "rows": [{"RESULT_CODE": "S", "RESULT_CNT": "2"}]}]
- 잔여(ROLLBACK 뒤 기준 수와 차이): 0 — 양쪽 모두 실행 전과 같음

## 표별 대조
- SCM_SYS_LOG_BATCH: 로그 표 — 대조 제외(행 수 변화 AS-IS 2 / TO-BE None)
- SCP_MST_SHIPMENT_LOT_SIZE: 쓴 행 2행 · 공통 컬럼 20개 값 일치 · 행 수 변화 0
- SCP_MST_SHIPMENT_LOT_SIZE_H: 쓴 행 2행 · 공통 컬럼 20개 값 일치 · 행 수 변화 2 · 대조 제외(일련번호·실행 시각) ['HISTORY_CREATION_DATE', 'HISTORY_SEQ']
