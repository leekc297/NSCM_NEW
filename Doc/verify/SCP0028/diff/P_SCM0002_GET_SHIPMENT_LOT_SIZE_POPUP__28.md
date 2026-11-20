# SCP0028 · SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP ↔ PKG_SCP0028.P_SCM0002_GET_SHIPMENT_LOT_SIZE_POPUP

- 실행 2026-11-20 12:55:29 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 ROWS_ONLY** — 공통행 0(키 DIVISION_ID+from_site+from_site_description+TO_SITE+to_site_description+ITEM_ID) — AS-IS 0행 ↔ TO-BE 8행 · 데이터 불일치(DEV MSSQL≠사내 Oracle) 또는 인자 불일치 → 판정필요 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+from_site+from_site_description+TO_SITE+to_site_description+ITEM_ID · golden 집합 판정 DIFF
- 호출 #28 sheet=popup btn=SEARCH user=minyonglee1 FE 응답 행 9 · 원천 Doc\verify\SCP0028\calls\eg_popup__eg-popup_MAIN_SCP0028_0_SCM0002_ShipmentLotSizePopup_BTN_bt_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81", "operationGroup": "", "fromSite": "", "toSite": "", "itemId": "PVCC517H-A", "actionFlag": "D"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "81", "p_operation_group": "", "p_from_site": "", "p_to_site": "", "p_item_id": "PVCC517H-A", "p_action_flag": "D"}`
- 재시도 ''→'ALL': AS-IS 0행 ← `{"p_division_id": "81", "p_operation_group": "ALL", "p_from_site": "ALL", "p_to_site": "ALL", "p_item_id": "PVCC517H-A", "p_action_flag": "D"}`

### 결과셋 1  As-is 0행 ↔ To-Be O_RC1 8행
- 행수 불일치 0 ↔ 8
- 값 차이: As-is 전용 0행 / To-Be 전용 8행 (공통 컬럼 9)
| 측 | DIVISION_ID | OPERATION_GROUP_ID | operation_group_name | from_site | from_site_description | TO_SITE | to_site_description | ITEM_ID | NICK_NAME |
|---|---|---|---|---|---|---|---|---|---|
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Audi_DE_ING | Audi_DE_ING | APVCC517H-A3-D02 | VCC-517H |
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Audi_DE_ING | Audi_DE_ING | APVCC517H-A4 | VCC-517H-A4 |
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Volvo_FR_HRB | Volvo_FR_HRB | APVCC517H-A3-D02 | VCC-517H |
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Volvo_MY_SHA | Volvo_MY_SHA | APVCC517H-A3-D02 | VCC-517H |
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Volvo_SE_GOT | Volvo_SE_GOT | APVCC517H-A3-D02 | VCC-517H |
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Zhongjia_CN_CTU | Zhongjia_CN_CTU | APVCC517H-A2 | VCC-517H-A2 |
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Zhongjia_CN_CTU | Zhongjia_CN_CTU | APVCC517H-A3 | VCC-517H |
| T | 81 | P | Pack | HQ07-P | LGESOC Pack HQ07 | Zhongjia_CN_DQG | Zhongjia_CN_DQG | APVCC517H-A3 | VCC-517H |
- 데이터 기준: 공통 0행 · AS-IS 전용 0행 · TO-BE 전용 8행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 0행의 상대 순서): 비교 불가(공통 행 2 미만)
