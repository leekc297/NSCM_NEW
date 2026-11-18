# SSP0020 · UP_FX_GetSSPUserUseInfoList ↔ PKG_SSP0020.P_USER_CHECK

- 실행 2026-11-18 09:48:12 · AS-IS As-is MSSQL (LGCE_SCMDEV) [mssql] scp_mgr_dev@222.110.191.243:2433/LGCE_SCMDEV (readOnly) · TO-BE To-Be Oracle (ZIOUI1 / system → CURRENT_SCHEMA SCM_MGR) [oracle] system@59.19.252.148:2521/ZIOUI1 (매 호출 rollback) · 호출 원천 calls
- **판정 DIFF** — 공통 7223행 중 불일치 셀 1 — diff/P_USER_CHECK__7.csv · 키 원천 db_resultsets.csv is_nullable=0 · 키 UserID+UserName+UseYN+RegtUserID · golden 집합 판정 DIFF
- 호출 #7 sheet=Delegate btn=USER_CHECK user=minyonglee1 FE 응답 행 7282 · 원천 Doc\verify\SSP0020\calls\_trace_W4_E4_업무_검증_메시지_AS-IS_저장_차단__0.json
- TO-BE 인자(FE 본문): `{"search": "", "language": "KO", "useYn": "Y"}`
- 세션 인자(호출 로그 SCM_COM_SQL_LOG): `{"sesLangCd": "KO", "sesUserId": "minyonglee1"}`
- AS-IS 인자(번역): `{"Search": "", "Language": "KO", "UseYN": "Y"}`

### 결과셋 1  As-is 7281행 ↔ To-Be O_RC1 7281행
- 값 차이: As-is 전용 59행 / To-Be 전용 59행 (공통 컬럼 25)
| 측 | UserID | UserName | UserName_E | Email | Dept_ID | Dept_Name | OfficePhoneNum | CellPhoneNum | Language | DefaultGroupID | GrpName | TimeZone |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A | A31NC017 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A31NC018 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A32DG001 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A32DG002 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A32FD008 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A33VD001 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A51LM016 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A51LM017 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A51LM018 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| A | A51LM019 |  |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A31NC017 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A31NC018 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A32DG001 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A32DG002 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A32FD008 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A33VD001 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A51LM016 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A51LM017 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A51LM018 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
| T | A51LM019 | / |  |  | GMES |  |  |  | EN | GMES Viewer | GMES Viewer | AM073 |
- 데이터 기준: 공통 7280행 · AS-IS 전용 1행 · TO-BE 전용 1행 (AS-IS dev MSSQL ≠ 사내 Oracle 데이터 · 센티널 ''·'-'·'/' 동일 취급)
- 실제 순서(공통·유일 7280행의 상대 순서): 불일치 — 첫 차이 r37: AS-IS=['M41PK002', '192.168.140.242, 포장 ', '192.168.140.242, 포장 ', '', 'GMES', ''] ↔ TO-BE=['A12LM021', 'A12LM021', 'A12LM021', '', 'GMES', ''] · 센티널 차이 컬럼 UserName(58행 AS-IS ''↔TO-BE '/') — 빈 값 표기가 달라 정렬 위치가 달라질 수 있음(TO-BE 센티널 정책 2026-10-15)

## 불일치 셀(≤50) — diff/P_USER_CHECK__7.csv
| 키 | 컬럼 | AS-IS | TO-BE |
|---|---|---|---|
| jaeuk.shin|신재욱|Y|REQ | LastLoginDateTime | 2026-11-17 20:03:08 | 2026-10-30 15:58:33 |
