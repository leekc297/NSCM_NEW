# SSP0200 · SSP0200_GET_SHIPMENT_CHANGE_REQUEST ↔ PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST

- 실행 2026-11-15 06:43:23 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 18행 중 불일치 셀 60 — diff/P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST__16.csv · 키 원천 cleanup_spec.json · 키 confirm_id · golden 집합 판정 DIFF
- 호출 #16 sheet=main btn=SEARCH user=minyonglee1 FE 응답 행 24 · 원천 Doc\verify\SSP0200\calls\_verify_Division_컬럼_A5__0.json
- TO-BE 인자(FE 본문): `{"divisionId": "82", "fromSite": "ALL", "erpSoNo": "", "itemId": "", "fromYyyymmdd": "20261115", "toYyyymmdd": "20261215", "status": "ALL", "changeType": "C", "language": "KO", "debugMode": "F", "toSite": "ALL", "confirmId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"p_division_id": "82", "p_from_site": "ALL", "p_erp_so_no": "", "p_item_id": "", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_status": "ALL", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "ALL", "p_confirm_id": ""}`
- 재시도 'ALL'→'': AS-IS 18행 ← `{"p_division_id": "82", "p_from_site": "", "p_erp_so_no": "", "p_item_id": "", "p_from_yyyymmdd": "20261115", "p_to_yyyymmdd": "20261215", "p_status": "", "p_change_type": "C", "p_language": "KO", "debug_mode": "F", "p_to_site": "", "p_confirm_id": ""}`

### 결과셋 1  As-is 18행 ↔ To-Be O_RC1 23행
- 행수 불일치 18 ↔ 23
- 값 차이: As-is 전용 12행 / To-Be 전용 17행 (공통 컬럼 69)
| 측 | division_id | erp_so_no | shipment_status | project_code | project_name | fcst_type | item_id | nick_name | shipment_date | before_qty | shipment_confirm_qty | remarks |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 82 |  | C | - |  | - | EP096603PFB1 | JF2 KR 150.8 | 2026-11-17 |  | 227 |  |
| A | 82 |  | C | - |  | - | ETD1550AFB32-CGB | JF2 DC LINK 5.0 | 2026-11-17 |  | 6 |  |
| A | 82 |  | C | - |  | - | ETD1550AFB34-CGB | JF2 DC LINK 5.0 | 2026-11-17 |  | 6 |  |
| A | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB31-CGB | JF2 DC LINK 5.0 | 2026-11-16 | 1 | 1 |  |
| A | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB31-CGB | JF2 DC LINK 5.0 | 2026-11-17 |  | 3 |  |
| A | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB32-CGB | JF2 DC LINK 5.0 | 2026-11-17 |  | 2 |  |
| A | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB33-CGB | JF2 DC LINK 5.0 | 2026-11-17 |  | 3 |  |
| A | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB33-CGB | JF2 DC LINK 5.0 | 2026-11-18 | 1 | 2 |  |
| A | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB34-CGB | JF2 DC LINK 5.0 | 2026-11-17 | 2 | 2 |  |
| A | 82 |  | C | G-26-106 | Zirgu Bess OÜ | MPS | ETD1550BGB33 | JF2S DC ESTONIA | 2026-11-17 |  | 12 |  |
| T | 82 |  | C | - |  | - | EP096603PFB1 | JF2 KR 150.8 | 2026-11-17 | 227 | 220 |  |
| T | 82 |  | C | - |  | - | ETD1550AFB32-CGB | JF2 DC LINK 5.0 | 2026-11-17 | 5 | 4 |  |
| T | 82 |  | C | - |  | - | ETD1550AFB34-CGB | JF2 DC LINK 5.0 | 2026-11-17 |  | 6 |  |
| T | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB31-CGB | JF2 DC LINK 5.0 | 2026-11-16 | 1 | 1 |  |
| T | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB31-CGB | JF2 DC LINK 5.0 | 2026-11-17 | 3 | 2 |  |
| T | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB32-CGB | JF2 DC LINK 5.0 | 2026-11-17 | 2 | 3 |  |
| T | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB33-CGB | JF2 DC LINK 5.0 | 2026-11-17 | 1 | 2 |  |
| T | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB33-CGB | JF2 DC LINK 5.0 | 2026-11-17 | 3 | 2 |  |
| T | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB33-CGB | JF2 DC LINK 5.0 | 2026-11-18 | 1 | 2 |  |
| T | 82 |  | C | G-25-175 | BS한양_2025년 1차 중앙계약시장_광양 | MPS | ETD1550AFB34-CGB | JF2 DC LINK 5.0 | 2026-11-17 | 2 | 2 |  |
- 데이터 기준: 공통 6행 · AS-IS 전용 12행 · TO-BE 전용 17행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 6행의 상대 순서): 일치

## 불일치 셀(≤50) — diff/P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST__16.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| C20261026215478 | before_qty |  | 2295 |
| C20261026215479 | before_qty |  | 227 |
| C20261026215472 | before_qty |  | 3 |
| C20261026215473 | before_qty |  | 5 |
| C20261026215474 | before_qty |  | 2 |
| C20261026215475 | before_qty |  | 3 |
| C20261026215786 | before_qty |  | 10 |
| C20261026215477 | before_qty |  | 190 |
| C20261026215478 | shipment_confirm_qty | 2295 | 2290 |
| C20261026215479 | shipment_confirm_qty | 227 | 220 |
| C20261026215472 | shipment_confirm_qty | 3 | 2 |
| C20261026215473 | shipment_confirm_qty | 6 | 4 |
| C20261026215474 | shipment_confirm_qty | 2 | 3 |
| C20261026215475 | shipment_confirm_qty | 3 | 2 |
| C20261026215786 | shipment_confirm_qty | 12 | 8 |
| C20261026215477 | shipment_confirm_qty | 190 | 180 |
| C20260928209243 | updated_by | 홍승표(spyohong) | 고원택(attackgo) |
| C20261026215478 | updated_by |  | 이의근(euigeun.lee) |
| C20261026215479 | updated_by |  | 고원택(attackgo) |
| C20261026215472 | updated_by |  | 고원택(attackgo) |
| C20261026215473 | updated_by |  | 고원택(attackgo) |
| C20261026215474 | updated_by |  | 고원택(attackgo) |
| C20261026215475 | updated_by |  | 고원택(attackgo) |
| C20261026215476 | updated_by |  | 이의근(euigeun.lee) |
| C20260928209314 | updated_by | 홍승표(spyohong) | 고원택(attackgo) |
| C20261026215786 | updated_by |  | 고원택(attackgo) |
| C20260928209290 | updated_by | 홍승표(spyohong) | 고원택(attackgo) |
| C20261026215477 | updated_by |  | 고원택(attackgo) |
| C20261026215478 | CHANGE_REQ_NO |  | R20261109543058 |
| C20261026215479 | CHANGE_REQ_NO |  | R20261113543154 |
| C20261026215472 | CHANGE_REQ_NO |  | R20261113543150 |
| C20261026215473 | CHANGE_REQ_NO |  | R20261113543146 |
| C20261026215474 | CHANGE_REQ_NO |  | R20261113543146 |
| C20261026215475 | CHANGE_REQ_NO |  | R20261113543148 |
| C20261026215786 | CHANGE_REQ_NO |  | R20261113543175 |
| C20261026215477 | CHANGE_REQ_NO |  | R20261113543152 |
| C20260928209243 | requestor | 홍승표(spyohong) | 고원택(attackgo) |
| C20261026215478 | requestor | System | 이의근(euigeun.lee) |
| C20261026215479 | requestor | System | 고원택(attackgo) |
| C20261026215472 | requestor | System | 고원택(attackgo) |
| C20261026215473 | requestor | System | 고원택(attackgo) |
| C20261026215474 | requestor | System | 고원택(attackgo) |
| C20261026215475 | requestor | System | 고원택(attackgo) |
| C20261026215476 | requestor | System | 이의근(euigeun.lee) |
| C20260928209314 | requestor | 홍승표(spyohong) | 고원택(attackgo) |
| C20261026215786 | requestor | System | 고원택(attackgo) |
| C20260928209290 | requestor | 홍승표(spyohong) | 고원택(attackgo) |
| C20261026215477 | requestor | System | 고원택(attackgo) |
| C20260928209243 | REQUEST_DATE | 2026-10-02 15:03:24 | 2026-11-13 09:34:03 |
| C20261026215478 | REQUEST_DATE | 2026-10-26 17:39:37 | 2026-11-09 11:13:14 |
