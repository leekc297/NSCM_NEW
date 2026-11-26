# SCP0028 · SCP0028_GET_SHIPMENT_LOT_SIZE ↔ PKG_SCP0028.P_SCP0028_GET_SHIPMENT_LOT_SIZE

- 실행 2026-11-25 01:47:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 100행 전 컬럼 일치 · 단독행 AS-IS 180 / TO-BE 40 · 키 원천 db_resultsets.csv is_nullable=0 · 키 DIVISION_ID+OPERATION_GROUP_ID+from_site+from_site_description+to_site+to_site_description+ITEM_ID+NICK_NAME+trans_mode_name+trans_mode_code+VALID_YN+SPLIT_YN · golden 집합 판정 DIFF
- 호출 #8 sheet=main btn=SEARCH user=brightboy FE 응답 행 141 · 원천 Doc\verify\SCP0028\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "operationGroup": "", "fromSite": "", "toSite": "", "transMode": "", "itemId": "", "valid": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "kang_huichan"}` · 같은 본문의 세션 조합 4종 중 최다(1회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'bindy122678'}, {'sesLangCd': 'KO', 'sesUserId': 'brightboy'}, {'sesLangCd': 'KO', 'sesUserId': 'donghoon.lee'}]
- AS-IS 인자(번역): `{"p_division_id": "82", "p_operation_group": "", "p_from_site": "", "p_to_site": "", "p_trans_mode": "", "p_item_id": "", "p_valid": ""}`

### 결과셋 1  As-is 280행 ↔ To-Be O_RC1 140행
- 행수 불일치 280 ↔ 140
- 값 차이: As-is 전용 180행 / To-Be 전용 40행 (공통 컬럼 18)
| 측 | DIVISION_ID | OPERATION_GROUP_ID | from_site | from_site_description | to_site | to_site_description | ITEM_ID | NICK_NAME | trans_mode_name | trans_mode_code | LOT_SIZE | INCREMENT |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-FF0 | JF2 4P30S US | AIR | AIR |  |  |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-FF0 | JF2 4P30S US | FERRY | FRY |  |  |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-FF0 | JF2 4P30S US | RAIL | RAI | 40 | 40 |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-FF0 | JF2 4P30S US | SEA | SEA | 40 | 40 |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-FF0 | JF2 4P30S US | TRUCK | TRK | 40 | 40 |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-HF0 | JF2 4P30S US | AIR | AIR |  |  |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-HF0 | JF2 4P30S US | FERRY | FRY |  |  |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-HF0 | JF2 4P30S US | RAIL | RAI | 40 | 40 |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-HF0 | JF2 4P30S US | SEA | SEA | 40 | 40 |
| A | 82 | P | US02562600_82-P | Sebang Lithium Battery Ohio LL | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBA-HF0 | JF2 4P30S US | TRUCK | TRK | 40 | 40 |
| T | 82 | A | VP_GM01-A | virtual plant(GM01)-Cell | US02279100_82-P | PeopleWorks-US CHI | ECE1592F1-01-H00 | JF2-H00 | AIR | AIR |  |  |
| T | 82 | A | VP_GM01-A | virtual plant(GM01)-Cell | US02279100_82-P | PeopleWorks-US CHI | ECE1592F1-01-H00 | JF2-H00 | FERRY | FRY |  |  |
| T | 82 | A | VP_GM01-A | virtual plant(GM01)-Cell | US02279100_82-P | PeopleWorks-US CHI | ECE1592F1-01-H00 | JF2-H00 | RAIL | RAI |  |  |
| T | 82 | A | VP_GM01-A | virtual plant(GM01)-Cell | US02279100_82-P | PeopleWorks-US CHI | ECE1592F1-01-H00 | JF2-H00 | SEA | SEA | 5488 | 5488 |
| T | 82 | A | VP_GM01-A | virtual plant(GM01)-Cell | US02279100_82-P | PeopleWorks-US CHI | ECE1592F1-01-H00 | JF2-H00 | TRUCK | TRK | 5488 | 5488 |
| T | 82 | P | MI01-P | MI ESS Assy/Pack-Pack | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBAA7A0 | JF2 4P30S US | AIR | AIR |  |  |
| T | 82 | P | MI01-P | MI ESS Assy/Pack-Pack | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBAA7A0 | JF2 4P30S US | FERRY | FRY |  |  |
| T | 82 | P | MI01-P | MI ESS Assy/Pack-Pack | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBAA7A0 | JF2 4P30S US | RAIL | RAI |  |  |
| T | 82 | P | MI01-P | MI ESS Assy/Pack-Pack | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBAA7A0 | JF2 4P30S US | SEA | SEA | 39 | 39 |
| T | 82 | P | MI01-P | MI ESS Assy/Pack-Pack | MI04-P | MI Arizona Phoenix ESS Prod-Pa | EP096636PFBAA7A0 | JF2 4P30S US | TRUCK | TRK | 39 | 39 |
- 데이터 기준: 공통 100행 · AS-IS 전용 180행 · TO-BE 전용 40행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 100행의 상대 순서): 일치
