# SCP0007 · SCP0007_GET_COUNTRY_CITY ↔ PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY

- 실행: 2026-10-28 02:06:58
- 파라미터: `{"p_division_id": "40", "p_scm_site_id": "", "debug_mode": "F"}`
- 종류: GET

### 결과셋 1  As-is 1415행 ↔ To-Be O_RC 1394행
- 행수 불일치 1415 ↔ 1394
- 값 차이: As-is 전용 25행 / To-Be 전용 4행 (공통 컬럼 6)
| 측 | division_id | scm_site_id | country | city | VMI_YN | SITE_TYPE |
|---|---|---|---|---|---|---|
| A | 40 | ABS_US_BUX | US | USBUX | N | SALES |
| A | 40 | AC00-A | US | USAAZ | N | PLANT |
| A | 40 | AJ상사_AC_TES | AC | ACTES | N | SALES |
| A | 40 | AJ상사_AE_AAN | AE | AEAAN | Y | SALES |
| A | 40 | AJ상사_AE_ABU | AE | AEABU | N | SALES |
| A | 40 | BMZ_DE_FRA | DE | DEFRA | N | SALES |
| A | 40 | DDC_US_DET | US | USDET | N | SALES |
| A | 40 | DMS_ID_JKT | ID | IDJKT | N | SALES |
| A | 40 | Elentec_VN_HAP | VN | VNHAP | N | SALES |
| A | 40 | Futaihua Shenzhen_CN_SZX | CN | CNSZX | N | SALES |
| T | 40 | 1X Technologies_AG_FAM | AG | AGFAM | Y | SALES |
| T | 40 | CN004481_40-P | AG | AGSJO | N | PLANT |
| T | 40 | E00L00300_40-P | EG | EGCAI | N | PLANT |
| T | 40 | US01983800_40-P | EG | EGCAI | N | PLANT |
