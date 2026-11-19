# SSP0014 · SSP0014_GET_SHIPMENT_MODEL_PIC ↔ PKG_SSP0014.P_SSP0014_GET_MODEL_PIC

- 실행 2026-11-19 16:07:06 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 1738행 중 불일치 셀 69 — diff/P_SSP0014_GET_MODEL_PIC__12.csv · 키 원천 cleanup_spec.json · 키 DIVISION_ID+FROM_SITE+ITEM_ID · golden 집합 판정 DIFF
- 호출 #12 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 1763 · 원천 Doc\verify\SSP0014\calls\_verify_Division_컬럼_A5__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "operationGroup": "", "fromSite": "", "validYn": "", "itemId": "", "userId": "", "language": "KO"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_operation_group": "", "p_from_site": "", "p_valid_yn": "", "p_item_id": "", "p_user_id": "", "p_language": "KO"}`

### 결과셋 1  As-is 1738행 ↔ To-Be O_RC1 1762행
- 행수 불일치 1738 ↔ 1762
- 값 차이: As-is 전용 69행 / To-Be 전용 93행 (공통 컬럼 21)
| 측 | DIVISION_ID | OPERATION_GROUP | FROM_SITE | ITEM_ID | NICK_NAME | USER_ID | USER_NAME | PART_LEADER | PART_LEADER_NAME | TEAM_LEADER | TEAM_LEADER_NAME | VALID_YN |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 | W | HQ05_82-W | EEA00574AA |  | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EEA00575AA |  | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048063P3S1 | RESU3.3 | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048063P3S1-K | RESU3.3 | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048126P3S1 | RESU6.5 | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048126P3S1-K | RESU6.5 | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048189P3S1 | RESU10 | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048189P3S1-K | RESU10 | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048252P3S1 | RESU13 | miyeong.lee |  |  |  |  |  | Y |
| A | 82 | W | HQ05_82-W | EH048252P3S2 | RESU12 | miyeong.lee |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD0D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD0D3 |  |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD1D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD1D3 |  |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD2D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD2D3 |  |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD3D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAD3D3 |  |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAE0D2 | JF2 4P30S US |  |  |  |  |  |  | Y |
| T | 82 | P | VP_ST00-P | EP096636PFBAE0D3 |  |  |  |  |  |  |  | Y |
- 데이터 기준: 공통 1669행 · AS-IS 전용 69행 · TO-BE 전용 93행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1669행의 상대 순서): 일치

## 불일치 셀(≤50) — diff/P_SSP0014_GET_MODEL_PIC__12.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| 82|HQ05_82-W|EEA00574AA | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EEA00575AA | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048063P3S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048063P3S1-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048126P3S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048126P3S1-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048189P3S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048189P3S1-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048252P3S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH048252P3S2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH103064P8S2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH103064P8S3 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH104063P3S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH104063P3S2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH111063P3S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH111063P3S1-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH111063P3S3 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH111063P3S3-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH111063P3S4 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH153064P8S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH153064P8S7 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH153064P8S8 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH153064P8S8-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH154064P8S2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH154064P8S3 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S1-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S2-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S3 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S6 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S7 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH155063P3S7-K | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH257064P8S1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH257064P8S2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH257064P8S3 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH257064P8S7 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EH257064P8S8 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048063P3N1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048063P3N2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048063P3N3 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048063P3S4 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048063P3S5 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048064P6B4 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048064P8N1 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048064P8N2 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048126P3B6 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048126P3B7 | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048126P3BA | USER_NAME |  | 이미영 |
| 82|HQ05_82-W|EM048126P3BB | USER_NAME |  | 이미영 |
