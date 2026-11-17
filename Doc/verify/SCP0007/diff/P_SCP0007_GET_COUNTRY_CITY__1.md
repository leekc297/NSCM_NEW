# SCP0007 · SCP0007_GET_COUNTRY_CITY ↔ PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY

- 실행 2026-11-14 09:25:35 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 PASS** — 공통 3033행 전 컬럼 일치 · 단독행 AS-IS 1 / TO-BE 64 · 키 원천 db_resultsets.csv is_nullable=0 · 키 division_id+scm_site_id+VMI_YN · golden 집합 판정 DIFF
- 호출 #1 sheet=countryCity btn=SEARCH user=minyonglee1 FE 응답 행 3098 · 원천 Doc\verify\SCP0007\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"divisionId": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "scmSiteId": ""}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}` · 같은 본문의 세션 조합 4종 중 최다(376회) 사용 — 나머지 [{'sesLangCd': 'KO', 'sesUserId': 'lucky-alex'}, {'sesLangCd': 'KO', 'sesUserId': 'jooyong026'}, {'sesLangCd': 'KO', 'sesUserId': 'jinseon_ahn'}]
- AS-IS 인자(번역): `{"p_division_id": "81,40,82,81_UC,81_HM,81_ST,81_HD,81_HG", "p_scm_site_id": "", "debug_mode": "F"}`

### 결과셋 1  As-is 3034행 ↔ To-Be O_RC 3097행
- 행수 불일치 3034 ↔ 3097
- 값 차이: As-is 전용 1행 / To-Be 전용 64행 (공통 컬럼 6)
| 측 | division_id | scm_site_id | country | city | VMI_YN | SITE_TYPE |
|---|---|---|---|---|---|---|
| A | 82 | LGESVT_US_WRO | US | USWRO | N | SALES |
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
- 데이터 기준: 공통 3033행 · AS-IS 전용 1행 · TO-BE 전용 64행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 3033행의 상대 순서): 불일치 — 첫 차이 r0: AS-IS=['40', '1X Technologies_US_P', 'US', 'USPAO', 'N', 'SALES'] ↔ TO-BE=['40', 'Anjin_CN_SHA', 'CN', 'CNSHA', 'N', 'SALES']
