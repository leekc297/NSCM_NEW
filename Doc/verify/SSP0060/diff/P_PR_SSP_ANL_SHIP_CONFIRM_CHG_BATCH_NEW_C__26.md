# SSP0060 · PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH ↔ PKG_SSP0060.P_PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW_C

- 실행 2026-11-15 05:23:58 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- 호출 #26 sheet=main btn=SHIP_CONFIRM_CHG_BATCH_NEW_C user=minyonglee1 FE 응답 행 1 · 원천 Doc\verify\SSP0060\calls\_verify_저장_세부_F1_F6_컬럼별_왕복_0_값_저장_0.json
- TO-BE 인자(FE 본문): `{"changeType": "C", "changeReqNo": "R20261115543224", "confirmId": "C20261115201071"}`
- SKIP: kind=SAVE — GET 만 실행(쓰기 SP 실행 금지) ·  · kind 근거: DML 대상 ['SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE', 'XIF_ERP_SHIP_PLAN_CONFIRM_S_SN']
