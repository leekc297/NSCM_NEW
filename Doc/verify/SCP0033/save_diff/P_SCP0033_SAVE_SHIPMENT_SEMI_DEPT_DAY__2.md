# SCP0033 저장 대조 · SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY ↔ PKG_SCP0033.P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY

- 실행 2026-11-11 16:31:17 · 본문 = 사내 호출 로그 #4599870 (2026-11-10 11:50:35 · minyonglee1)
- **판정 PASS** — SCM_SYS_LOG_BATCH: 로그 표 — 대조 제외(행 수 변화 AS-IS 2 / TO-BE None) | SCP_MST_SHIPMENT_SEMI_DEPT_DAY: 쓴 행 1행 · 공통 컬럼 14개 값 일치 · 행 수 변화 0 | SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H: 쓴 행 1행 · 공통 컬럼 14개 값 일치 · 행 수 변화 1 · 대조 제외(일련번호·실행 시각) ['HISTORY_CREATION_DATE', 'HISTORY_SEQ']
- TO-BE 본문: `{"departureDay": "MON", "creationDate": null, "itemId": "APCAN0842A", "createdBy": null, "sValidYn": "N", "createId": "minyonglee1", "validYn": "Y", "divisionId": "40", "debugMode": null, "activeFlag": "M", "sesLangCd": "EN", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_active_flag": "M", "p_division_id": "40", "p_item_id": "APCAN0842A", "p_departure_day": "MON", "p_valid_yn": "Y", "p_s_valid_yn": "N", "p_created_by": "bpark416", "p_creation_date": "", "debug_mode": "", "p_user_id": "bpark416"}`
- TO-BE 방식: 실제 저장 후 복원 · 대상 표 ['SCM_SYS_LOG_BATCH', 'SCP_MST_SHIPMENT_SEMI_DEPT_DAY', 'SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H'] · 복원 {"SCP_MST_SHIPMENT_SEMI_DEPT_DAY": "삭제 1 · 재삽입 1 · 실행 전과 차이 0", "SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H": "삭제 1 · 재삽입 0 · 실행 전과 차이 0"}
- AS-IS: @@TRANCOUNT(EXEC 직후) 3 · 결과 [{"result_code": "S", "result_cnt": "1"}]
- TO-BE: 결과 [{"cursor": "O_RC1", "rows": [{"RESULT_CODE": "S", "RESULT_CNT": "1"}]}, {"cursor": "O_RESULT_CURSOR", "rows": [{"RESULT_CODE": "0", "RESULT_MESSAGE": "SUCCESS"}]}] · NULL 전달 인자 ['P_CREATED_BY', 'P_CREATION_DATE', 'P_DEBUG_MODE']
- 잔여(ROLLBACK 뒤 기준 수와 차이): 0 — 양쪽 모두 실행 전과 같음

## 표별 대조
- SCM_SYS_LOG_BATCH: 로그 표 — 대조 제외(행 수 변화 AS-IS 2 / TO-BE None)
- SCP_MST_SHIPMENT_SEMI_DEPT_DAY: 쓴 행 1행 · 공통 컬럼 14개 값 일치 · 행 수 변화 0
- SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H: 쓴 행 1행 · 공통 컬럼 14개 값 일치 · 행 수 변화 1 · 대조 제외(일련번호·실행 시각) ['HISTORY_CREATION_DATE', 'HISTORY_SEQ']
