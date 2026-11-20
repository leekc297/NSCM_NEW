# SSP0014 · SSP0014_GET_SHIPMENT_MODEL_PIC ↔ PKG_SSP0014.P_SSP0014_GET_MODEL_PIC

- 실행 2026-11-20 09:34:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 2736행 중 불일치 셀 195 — diff/P_SSP0014_GET_MODEL_PIC__12.csv · 키 원천 cleanup_spec.json · 키 DIVISION_ID+FROM_SITE+ITEM_ID · golden 집합 판정 DIFF
- 호출 #12 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 2737 · 원천 Doc\verify\SSP0014\calls\_trace_W4c_정밀_판정_판정필요_해소_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "40", "operationGroup": "", "fromSite": "", "validYn": "Y", "itemId": "", "userId": "", "language": "KO"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "40", "p_operation_group": "", "p_from_site": "", "p_valid_yn": "Y", "p_item_id": "", "p_user_id": "", "p_language": "KO"}`

### 결과셋 1  As-is 2736행 ↔ To-Be O_RC1 2736행
- 값 차이: As-is 전용 195행 / To-Be 전용 195행 (공통 컬럼 21)
| 측 | DIVISION_ID | OPERATION_GROUP | FROM_SITE | ITEM_ID | NICK_NAME | USER_ID | USER_NAME | PART_LEADER | PART_LEADER_NAME | TEAM_LEADER | TEAM_LEADER_NAME | VALID_YN |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | P | CN00732500_40-P | MPCACEASB81C | AS16B8J(C4/6) | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCDELASA81C | AS16A8K(C4/4) | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCDELIRC41C | IRIS(C4/4) | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCDELTURI1C | TURIS MLK | shenhuihui | 심혜휘 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCHHIMS4B1C | 2019MS BLACK110 | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCHHIMS4C1C | 2019MS WHITE110 | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCHHIMSBL1C | 2019MS BLACK210 | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCHHIMSWH1C | 2019MS WHITE210 | shenhuihui | 심혜휘 | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCHPPCA061C | CA06055 | liubowen1012 |  | liuxingxing | 유성성 | zhuqinghai |  | Y |
| A | 40 | P | CN00732500_40-P | MPCHPPCA062C | CA06055XL(C4/6) | liubowen1012 |  | liuxingxing | 유성성 | zhuqinghai |  | Y |
| T | 40 | P | CN00732500_40-P | MPCACEASB81C | AS16B8J(C4/6) | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCDELASA81C | AS16A8K(C4/4) | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCDELIRC41C | IRIS(C4/4) | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCDELTURI1C | TURIS MLK | shenhuihui | 심혜휘 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCHHIMS4B1C | 2019MS BLACK110 | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCHHIMS4C1C | 2019MS WHITE110 | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCHHIMSBL1C | 2019MS BLACK210 | hanbing | 한빙 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCHHIMSWH1C | 2019MS WHITE210 | shenhuihui | 심혜휘 | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCHPPCA061C | CA06055 | liubowen1012 |  | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
| T | 40 | P | CN00732500_40-P | MPCHPPCA062C | CA06055XL(C4/6) | liubowen1012 |  | liuxingxing | 유성성 | zhuqinghai | 주경해 | Y |
- 데이터 기준: 공통 2541행 · AS-IS 전용 195행 · TO-BE 전용 195행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 2541행의 상대 순서): 일치

## 불일치 셀(≤50) — diff/P_SSP0014_GET_MODEL_PIC__12.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 40|CN00732500_40-P|MPCACEASB81C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCDELASA81C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCDELIRC41C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCDELTURI1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHHIMS4B1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHHIMS4C1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHHIMSBL1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHHIMSWH1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPCA061C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPCA062C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPCA063C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPCA651C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPCA921C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPDB031C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPHS031C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPHS041C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPHS042C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPJC031C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPJC041C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPJC061C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPKI041C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPKI042C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPKI411C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPMA821C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPMA861C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPOA032C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPOA042C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPOA3C1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPOA4C1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPPEEX1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPPEIN1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPPV041C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPRI061C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPRO061C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPVH083C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPVH8X1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPVI041C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPVI044C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPCHPPVI421C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPACEAP161C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPACEAP181C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPACEAP191C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPACEEJ3C1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPACERX481C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPACEVN4C1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPDELARCH1C | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPDELAVEN1I | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPDELBEVC1I | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPDELBR4L1I | TEAM_LEADER_NAME |  | 주경해 |
| 40|CN00732500_40-P|MPPDELBRK31I | TEAM_LEADER_NAME |  | 주경해 |
