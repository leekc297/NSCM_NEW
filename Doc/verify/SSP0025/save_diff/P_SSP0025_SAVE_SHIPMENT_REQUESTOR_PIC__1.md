# SSP0025 저장 대조 · SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC ↔ PKG_SSP0025.P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC

- 실행 2026-11-11 16:31:19 · 본문 = 사내 호출 로그 #4398131 (2026-11-09 16:06:56 · minyonglee1)
- **판정 PASS** — SCM_SYS_LOG_BATCH: 로그 표 — 대조 제외(행 수 변화 AS-IS 2 / TO-BE None) | SSP_MST_MODEL_USER_EE: 쓴 행 1행 · 공통 컬럼 17개 값 일치 · 행 수 변화 0
- TO-BE 본문: `{"partLeader": "", "teamLeader": "", "userId": "kyb0716", "itemId": "APCAN1146A", "createId": "minyonglee1", "toSite": "HQ07-A", "validYn": "Y", "divisionId": "81", "activeFlag": "M", "sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_active_flag": "M", "p_division_id": "81", "p_to_site": "HQ07-A", "p_item_id": "APCAN1146A", "p_user_id": "kyb0716", "p_create_id": "minyonglee1", "p_part_leader": "", "p_team_leader": "", "p_valid_yn": "Y"}`
- TO-BE 방식: 실제 저장 후 복원 · 대상 표 ['SCM_SYS_LOG_BATCH', 'SSP_MST_MODEL_USER_EE'] · 복원 {"SSP_MST_MODEL_USER_EE": "삭제 1 · 재삽입 1 · 실행 전과 차이 0"}
- AS-IS: @@TRANCOUNT(EXEC 직후) 3 · 결과 [{"result_code": "S", "result_cnt": "1"}]
- TO-BE: 결과 [{"cursor": "O_RC1", "rows": [{"RESULT_CODE": "S", "RESULT_CNT": "1"}]}, {"cursor": "O_RESULT_CURSOR", "rows": [{"RESULT_CODE": "0", "RESULT_MESSAGE": "SUCCESS"}]}]
- 잔여(ROLLBACK 뒤 기준 수와 차이): 0 — 양쪽 모두 실행 전과 같음

## 표별 대조
- SCM_SYS_LOG_BATCH: 로그 표 — 대조 제외(행 수 변화 AS-IS 2 / TO-BE None)
- SSP_MST_MODEL_USER_EE: 쓴 행 1행 · 공통 컬럼 17개 값 일치 · 행 수 변화 0
