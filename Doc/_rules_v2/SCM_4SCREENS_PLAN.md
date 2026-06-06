# SCM 4 신규 화면 작업 계획 (2026-06-04)

> 사용자 요청 — SCM0008/0009/0003/0005 4 화면 순차 진행. 본 보고서 = Phase A (분석) 종합 + Phase B/C/D 진행 사양 + 우선순위.

## §0 4 화면 매핑 종합

| AS-IS 화면 | TO-BE MNU_ID | MNU_URL | UPPR_MNU_ID | AS-IS 라인 | TO-BE 상태 | 복잡도 |
|---|---|---|---|---:|---|---|
| SCM0008 Auth Request | SYS0011 | auth-request | Auth_Mgmt | 2213 | ❌ 미작성 | 中 (7 SP + 3 grid + 1 form + 3 button) |
| SCM0009 Auth Approval | SYS0012 | auth-approval | Auth_Mgmt | 1053 | ❌ 미작성 | 小 (2 SP + 1 grid + Approve/Reject) |
| SCM0003 Lookup | SYS0010 | lookup | Admin_Menu | 1212 | ✅ 작성됨 | (cross-check only) |
| SCM0005 Dynamic Query | ❓ | ❓ | ❓ | 2212 | ❌ 미작성 | 大 (9 SP + 5 sheet) |

## §1 본 turn 산출물 (Phase A 분석 완료)

| 파일 | 내용 |
|---|---|
| `_asis/02_screens/SCM0008/__analysis__.md` | 7 SP / 4 button / 4 sheet / 3 grid + 1 form |
| `_asis/02_screens/SCM0009/__analysis__.md` | 2 SP / Approve/Reject |
| `_asis/02_screens/SCM0003/__analysis__.md` | TO-BE 기존 작성 cross-check 절차 |
| `_asis/02_screens/SCM0005/__analysis__.md` | 9 SP / 5 sheet / TO-BE 매핑 결정 위임 |
| `_artifacts/SCM0008_SYS0011_AuthRequest_meta.sql` | 7-BLOCK 메타 SQL (BLOCK 1/2/4/5/6 완료) |
| `Doc/_rules_v2/SCM_4SCREENS_PLAN.md` (본 보고서) | 종합 계획 |

→ 산출물 **6 파일** (분석 4 + 메타 SQL 1 + 보고서 1).

## §2 진행 계획 — 4 화면별 phase

### §2.1 SCM0008 Auth Request (高 우선)

| Phase | 산출물 | 상태 |
|---|---|---|
| A. 분석 | `__analysis__.md` | ✅ 완료 |
| B. FE 7 파일 | constants/types/store/main + 4 grid/form components | ⏳ 다음 turn |
| C. 메타 SQL | `_artifacts/SCM0008_SYS0011_AuthRequest_meta.sql` BLOCK 1/2/4/5/6 | ✅ 완료 |
| C-bis. BE SP body | `_artifacts/SCM0008_SP_BODY.sql` — 7 SP Oracle 변환 (MSSQL → Oracle) | ⏳ 다음 turn |
| D. UI 테스트 | 사용자 진행 | (사용자) |

### §2.2 SCM0009 Auth Approval (高 우선, 단순)

| Phase | 산출물 |
|---|---|
| A. 분석 | ✅ 완료 |
| B. FE 5 파일 | constants/types/store/main + 1 grid + form |
| C. 메타 SQL | `_artifacts/SCM0009_SYS0012_AuthApproval_meta.sql` |
| C-bis. BE SP body | 2 SP Oracle 변환 |

### §2.3 SCM0003 Lookup (cross-check)

| Phase | 산출물 |
|---|---|
| A. 분석 | ✅ 완료 |
| B. cross-check | `LookupForm/MasterGrid/DetailGrid.tsx` Read + 4축 매핑 + `__asis-mapping__.md` 작성 |
| C. 격차 보강 | (격차 발견 시 사양 작성 — 사용자 결정) |

### §2.4 SCM0005 Dynamic Query (매핑 결정 필요)

⚠️ **사용자 결정 위임** — TO-BE 매핑 옵션 3:
- (A) SYS0005 procedure-management 재사용 (부적합)
- (B) 신규 MNU_ID 등록 (예: SYS0013) ⭐ 권장
- (C) 격차 유지 (현재 미사용 시)

진행 결정 후:
- 신규 MNU_ID + MNU_URL 등록
- FE 22 파일 (5 sheet × grid + parameter modal)
- BE 메타 SQL (9 SP × 5 sheet)

## §3 SCM0008 BE SP body 변환 사양 (다음 turn)

> AS-IS MSSQL `UP_FX_*` (SystemManager 스키마) → Oracle `P_SCM0008_*` 변환.

| AS-IS SP | Oracle 변환 후 SP | IN 파라미터 | OUT |
|---|---|---|---|
| UP_FX_GetReqAuthCurrentUser | P_SCM0008_GET_CURRENT_USER | sesUserId | o_rc1 (USERID/USERNAME/USERNAME_E/EMAIL/DEPT_ID/CELLPHONENUM/LANGUAGE/TIMEZONE/DEFAULTGROUPID/DEPT_NAME_KO/DEPT_NAME_EN/DEPT_NAME_CN) |
| UP_FX_GetReqAuthGroupInfo | P_SCM0008_GET_AUTH_GROUP_INFO | (없음) | o_rc1 (GROUP_ID/GRP_NAME/GRP_DESCRIPTION/GRP_MAIL) |
| UP_FX_GetReqAuthMyListAdded | P_SCM0008_GET_MY_AUTH_LIST | sesUserId | o_rc1 (REQUEST_ID/GROUP_ID/DIVISION_ID/PLANT/CUSTOMER/STATUS) |
| UP_FX_GetNewUserAuthRequestList | P_SCM0008_GET_DIVISION_LIST | sesUserId | o_rc1 (DIVISION_ID/DIVISION_NAME) |
| UP_FX_SaveReqAuthAddMyList | P_SCM0008_ADD_MY_AUTH | sesUserId/groupId/divisionId/plant/customer | o_rc1 (success/requestId) |
| UP_FX_SaveReqAuthRequestMyList | P_SCM0008_REQUEST_AUTH | sesUserId | o_rc1 (success/affectedCount) |
| UP_FX_DeleteReqAuthAddedMyList | P_SCM0008_DELETE_MY_AUTH | sesUserId/requestId | o_rc1 (success) |

→ SP body 정밀 변환 시 AS-IS MSSQL SP source 별도 확보 + Oracle 19c 호환성 검증 의무 (룰 `_analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md`).

## §4 권장 순차 진행 (5+ turn 예상)

| Turn | 작업 |
|---|---|
| 1 (본 turn) | 4 화면 분석 + SCM0008 메타 SQL |
| 2 | SCM0008 FE 7 파일 + BE SP body |
| 3 | SCM0009 풀스택 (FE 5 + 메타 SQL + SP body) |
| 4 | SCM0003 cross-check (`__asis-mapping__.md` + 격차) |
| 5 | SCM0005 매핑 결정 후 풀스택 |

## §5 결정 위임

| # | 항목 | 결정 옵션 |
|---:|---|---|
| 1 | SCM0005 매핑 (TO-BE MNU_ID) | (A) procedure-management 재사용 / (B) 신규 SYS0013 등록 ⭐ / (C) 격차 유지 |
| 2 | SCM0008 풀스택 진행 즉시 vs 다음 turn | 본 turn 사용된 토큰 고려 — 다음 turn 권장 |
| 3 | SCM0003 cross-check 격차 발견 시 보강 | 격차별 사용자 결정 (메타-룰 #4 사용자 작업물 우선) |
| 4 | BE SP body 변환 — AS-IS MSSQL source 위치 | `GSCM/02.DBL/` 또는 별도 .sql 파일 위치 확인 필요 |

## §6 다음 작업 (즉시 진행 가능)

→ **SCM0008 BE SP body Oracle 변환** + **FE 7 파일 작성** — 다음 turn.
→ **SCM0009 풀스택** — 단순, 즉시 진행 가능.
→ **SCM0003 cross-check** — `Lookup.tsx` Read + `__asis-mapping__.md` 작성.

## §7 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | 4 화면 분석 종합 + SCM0008 메타 SQL + 진행 계획 |
