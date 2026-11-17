# SCP0007 · SCP0007_GET_COUNTRY_CITY ↔ PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY

- 실행: 2026-11-14 07:40:28
- 파라미터: `{"p_division_id": "40", "p_scm_site_id": "", "debug_mode": "F"}`
- 종류: GET

### 결과셋 1  As-is 1389행 ↔ To-Be O_RC 1418행
- 행수 불일치 1389 ↔ 1418
- 값 차이: As-is 전용 0행 / To-Be 전용 29행 (공통 컬럼 6)
| 측 | division_id | scm_site_id | country | city | VMI_YN | SITE_TYPE |
|---|---|---|---|---|---|---|
| T | 40 | ABS_US_BUX | US | USBUX | N | SALES |
| T | 40 | AC00-A | US | USAAZ | N | PLANT |
| T | 40 | AJ상사_AB_TES | AB | ABTES | Y | SALES |
| T | 40 | AJ상사_AC_TES | AC | ACTES | N | SALES |
| T | 40 | AJ상사_AE_AAN | AE | AEAAN | Y | SALES |
| T | 40 | AJ상사_AE_ABU | AE | AEABU | N | SALES |
| T | 40 | AT00-A | US | USAAZ | N | PLANT |
| T | 40 | Anjin_AA_TES | AA | AATES | N | SALES |
| T | 40 | Anjin_AK_TES | AK | AKTES | N | SALES |
| T | 40 | BMZ_DE_FRA | DE | DEFRA | N | SALES |
- 데이터 기준: 공통 1389행 · AS-IS 전용 0행 · TO-BE 전용 29행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1389행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', '1X Technologies_US_P', 'US', 'USPAO', 'N', 'SALES'] ↔ TO-BE=['40', 'Anjin_CN_SHA', 'CN', 'CNSHA', 'N', 'SALES']
