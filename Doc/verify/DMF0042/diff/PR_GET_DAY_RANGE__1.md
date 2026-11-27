# DMF0042 · PR_GET_DAY_RANGE ↔ PR_GET_DAY_RANGE

- 실행 2026-11-26 22:25:49 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #1 sheet=dayRange btn=SEARCH user=minyonglee1 FE 응답 행 3 · 원천 Doc\verify\DMF0042\calls\_snap__snap_그리드_헤더_텍스트_모델_시트_0.json
- TO-BE 인자(FE 본문): `{"createdBy": "", "month": "7"}`
- AS-IS 인자(번역): `{"p_created_by": "", "p_month": "7"}`
- ERR: DPY-4024: call timeout of 300000 ms exceeded
