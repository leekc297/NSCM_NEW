# SCP0007 · SCP0007_GET_BOD ↔ PKG_SCP0007.P_SCP0007_GET_BOD

- 실행: 2026-10-28 02:06:20
- 파라미터: `{"p_division_id": "40", "p_from_site": "", "p_to_site": "", "p_incoterms": "", "p_incoterms_ssp": "", "p_trans_mode": "", "p_input_status": "C", "p_valid": "Y", "debug_mode": "F"}`
- 종류: GET
- To-Be 인자 중 값 없음(NULL 전달): P_VALID_YN

### 결과셋 1  As-is 5000행 ↔ To-Be O_RC 5000행
- 값 차이: As-is 전용 395행 / To-Be 전용 395행 (공통 컬럼 40)
| 측 | DIVISION_ID | BOD_ID | CUSTOMER | INCOTERMS | INCOTERMS_SSP | FROM_SITE_CODE | TO_SITE_CODE | FROM_COUNTRY | FROM_CITY | TO_COUNTRY | TO_CITY | TRANSPORT_MODE_CODE |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | 40 | 10430 |  | EXW | EXW | NJ01-A | NJ01-P | CN | CNNKG | CN | CNNKG | TRK |
| A | 40 | 10431 |  | DAP | DAP | NJ01-P | VN00188600_40-P | CN | CNNKG | VN | VNBTN | AIR |
| A | 40 | 10995 | - | EXW | EXW | HQ06-A | JS Tech_JP_HIU | KR | KRCOJ | JP | JPHIU | AIR |
| A | 40 | 10996 | - | EXW | EXW | HQ06-A | JS Tech_JP_HIU | KR | KRCOJ | JP | JPHIU | SEA |
| A | 40 | 11182 | - | EXW | EXW | HQ06-A | Dualtron_CN_JHA | KR | KRCOJ | CN | CNJHA | AIR |
| A | 40 | 11183 | - | EXW | EXW | HQ06-A | Dualtron_CN_JHA | KR | KRCOJ | CN | CNJHA | FRY |
| A | 40 | 11184 | - | EXW | EXW | HQ06-A | Dualtron_CN_JHA | KR | KRCOJ | CN | CNJHA | SEA |
| A | 40 | 11185 | - | EXW | EXW | HQ06-A | GWKC_CN_SZP | KR | KRCOJ | CN | CNSZP | AIR |
| A | 40 | 11186 | - | EXW | EXW | HQ06-A | GWKC_CN_SZP | KR | KRCOJ | CN | CNSZP | SEA |
| A | 40 | 11188 | - | EXW | EXW | HQ06-A | Elite Electronic_CN_YCG | KR | KRCOJ | CN | CNYCG | AIR |
| T | 40 | 10000 | - | DAP | DAP | CN00732500_40-P | HP_MX_MTM | CN | CNCKG | MX | MXMTM | SEA |
| T | 40 | 10290 | - | A01 | A01 | NJ01-A | Hanwha Defense_KR_SGM | CN | CNNKG | KR | KRSGM | FRY |
| T | 40 | 10291 | - | A01 | A01 | NJ01-A | Hanwha Defense_KR_SGM | CN | CNNKG | KR | KRSGM | SEA |
| T | 40 | 10696 | - | DAP | DAP | HQ06-A | CS Enertech_KR_OSN | KR | KRCOJ | KR | KROSN | TRK |
| T | 40 | 10697 | - | A01 | A01 | NJ01-A | CS Enertech_KR_OSN | CN | CNNKG | KR | KROSN | FRY |
| T | 40 | 10698 | - | A01 | A01 | NJ01-A | CS Enertech_KR_OSN | CN | CNNKG | KR | KROSN | SEA |
| T | 40 | 10745 | - | A01 | A01 | NJ01-A | Toyota Tsusho KR_KR_SEL | CN | CNNKG | KR | KRSEL | FRY |
| T | 40 | 10746 | - | A01 | A01 | NJ01-A | Toyota Tsusho KR_KR_SEL | CN | CNNKG | KR | KRSEL | SEA |
| T | 40 | 10825 | - | A01 | A01 | NJ01-A | Hanwha Aerospace_KR_CHU | CN | CNNKG | KR | KRCHU | FRY |
| T | 40 | 10826 | - | DAP | DAP | HQ06-A | Hanwha Aerospace_KR_CHU | KR | KRCOJ | KR | KRCHU | TRK |
