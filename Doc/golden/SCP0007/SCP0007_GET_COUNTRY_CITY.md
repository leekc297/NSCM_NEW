# SCP0007 · SCP0007_GET_COUNTRY_CITY ↔ PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY

- 실행: 2026-11-02 03:09:09
- 파라미터: `{"p_division_id": "40", "p_scm_site_id": "", "debug_mode": "F"}`
- 종류: GET

### 결과셋 1  As-is 1418행 ↔ To-Be O_RC 1418행
- 일치
- 데이터 기준: 공통 1418행 · AS-IS 전용 0행 · TO-BE 전용 0행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 1418행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', '1X Technologies_US_P', 'US', 'USPAO', 'N', 'SALES'] ↔ TO-BE=['40', 'Boston Dynamics_US_W', 'US', 'USWLM', 'N', 'SALES']
