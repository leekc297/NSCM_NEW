# SSP0020 · SSP0020_SAVE_UNSET ↔ PKG_SSP0020.P_SAVE_UNSET

- 실행 2026-11-17 10:05:42 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #3 sheet=Delegate btn=UNSET user=minyonglee1 FE 응답 행 2 · 원천 Doc\verify\SSP0020\calls\_formfix_정리_검증용_행_해제_합산_기록_formteardown_0.json
- TO-BE 인자(FE 본문): `{"fromDate": "20261117", "toDate": "20261117", "sheetName": "Delegate", "delegate": "jiangguoping", "lastUpdateBy": "minyonglee1", "lastUpdateDate": "2026-11-17 02:40:41", "language": "KO", "divisionId": "40^81^81_HD^81_HG^81_HM^81_ST^81_UC^82^EE_HD^EE_HG^EE_HM^EE_ST^EE_UC"}`
- SKIP: kind=SAVE — GET 만 실행(쓰기 SP 실행 금지) · 2026-11-16 수동 지정: ALL_ARGUMENTS 실측 인자명 일치(P_USER_ID·P_LANGUAGE 등) · __asis-mapping__.md §4 · kind 근거: DML 대상 ['SCM_SYS_L
