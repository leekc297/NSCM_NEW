# SCM0008 (Auth Request) — AS-IS 정밀 분석

> 신규 화면 작성 — 룰 v2 5종 자료 + 신규 화면 강제 체크리스트 (룰 25) 적용. 작성: 2026-06-04.

## §0 메타

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.SystemMgmt.UIL/SCM0008_Auth_Request.{cs,Designer.cs}` (2213 lines) |
| TO-BE MNU_ID | `SYS0011` |
| TO-BE MNU_URL | `auth-request` |
| TO-BE UPPR_MNU_ID | `Auth_Mgmt` (부모: Authority/Auth_Mgmt) |
| TO-BE 위치 | `nscm-fe/features/admin/src/pages/auth-request/` |
| 기능 요약 | 신규 사용자가 자기 권한 요청 (My Auth List 작성 → 권한 신청) |

## §1 Layout (.Designer.cs)

3 영역 + 1 form:
- **spdDivision** — Division 선택 grid (Code/Name)
- **spdMain** — Authority master grid (모든 그룹 권한 list, GROUP_ID/GrpName/GrpDescription/GrpMail)
- **spdMyAuthList** — 신청 권한 list (My selection)
- **UserInfo form** — txtUserId / txtUserName / txtDeptName / txtEMail / txtCellPhone / cboLanguage / cboTimeZone
- **3 button** — btnRequest (권한 신청) / btnAdd (My list 추가) / btnAuthDelete (My list 삭제)

## §2 CRUD 6대 Button

| Button | AS-IS 위치 | 본문 | TO-BE hotkeyConfig |
|---|---:|---|---|
| Search (F5) | L772 | FindData() | `search` (function) |
| Insert (F8) | L776 | 빈 본문 | `insert: false` |
| Delete (F9) | L779 | 빈 본문 | `delete: false` |
| Edit | L782 | 빈 본문 | (미지원) |
| Save (F7) | L785 | `//SaveData()` 주석 | `save: false` (대신 customButtons 의 Request) |
| Excel | (없음) | — | (생략 = 자동 활성) |

특화 customButtons:
- **Request** → btnRequest_Click (UP_FX_SaveReqAuthRequestMyList)
- **Add** → btnAdd_Click (UP_FX_SaveReqAuthAddMyList)
- **Delete** → btnAuthDelete_Click (UP_FX_DeleteReqAuthAddedMyList)

## §3 API / SP (7개)

| # | SP | 의도 | TO-BE sheetName | mnuBtnCd |
|---:|---|---|---|---|
| 1 | `UP_FX_GetReqAuthCurrentUser` (L802) | 로그인 사용자 정보 조회 | `userInfo` | `RETRIEVE` |
| 2 | `UP_FX_GetReqAuthGroupInfo` (L845) | 모든 Authority 그룹 list | `main` | `RETRIEVE` |
| 3 | `UP_FX_GetReqAuthMyListAdded` (L893) | My Auth list (신청 중 + 승인된) | `myAuth` | `RETRIEVE` |
| 4 | `UP_FX_GetNewUserAuthRequestList` (L944, L969) | Division list (신규 사용자용) | `division` | `RETRIEVE` |
| 5 | `UP_FX_SaveReqAuthAddMyList` (L700) | My list 권한 추가 | `myAuth` | `ADD` |
| 6 | `UP_FX_SaveReqAuthRequestMyList` (L514) | 권한 신청 최종 (status='요청') | `myAuth` | `REQUEST` |
| 7 | `UP_FX_DeleteReqAuthAddedMyList` (L423) | My list 항목 삭제 | `myAuth` | `DELETE` |

→ **MSSQL → Oracle 변환 의무** (NSCM 표준): `UP_FX_*` → `P_SCM0008_*` 또는 PKG_SCM0008.P_*. SystemManager 스키마 → NSCM 의 admin 스키마.

## §4 Validation (MessageHelper)

| MSG ID | 의미 | AS-IS 위치 |
|---|---|---:|
| MSG00031 | 삭제 항목 미선택 | L438 |
| MSG00002 | 필수 입력 | L462 |
| MSG00158 | 권한 신청 결과 | L538 |
| MSG00154 | PI 권한 자동 부여 | L1121 |

→ TO-BE i18n KO/EN/CN 등록 의무 (룰 13).

## §5 Cascade (DataModel.Changed)

> grep 결과 0 건. cascade 패턴 없음 — 단순 grid 선택 + button.

## §6 권한 (formauth)

| 항목 | 동작 |
|---|---|
| 사용자 정보 | UserInfoContext 에서 자동 조회 (로그인 사용자) |
| Division/Authority | grep 결과 권한 분기 없음 — 모든 사용자 동일 조회 |
| PI (Project Information) | MSG00154 — PI 권한은 자동 부여 (L1121) |

## §7 TO-BE 매핑 (룰 v2 적용 사양)

### §7.1 FE 표준 7 파일

```
nscm-fe/features/admin/src/pages/auth-request/
├─ auth-request.constants.ts          (MENU_ID / SHEETS 5종 / RESPONSE_SET)
├─ auth-request.types.ts              (SearchCondition / 5 sheet response type)
├─ useAuthRequestStore.ts             (Zustand + G1 GET)
├─ AuthRequest.tsx                    (main: 3 grid + UserInfo form)
├─ index.ts                           (export)
└─ components/
   ├─ AuthRequestForm.tsx             (UserInfo form — 7 input)
   ├─ AuthRequestDivisionGrid.tsx     (Division grid)
   ├─ AuthRequestMainGrid.tsx         (Authority master grid)
   └─ AuthRequestMyAuthGrid.tsx       (My Auth list grid)
```

### §7.2 BE 메타 SQL (7-BLOCK)

```
_artifacts/SCM0008_SYS0011_AuthRequest_meta.sql
- BLOCK 1: i18n 메시지 (MSG_API_SYS0011_* / LBL00 등)
- BLOCK 2: SCM_ADM_MNU_M (이미 등록 — verify only)
- BLOCK 3: SCM_ADM_SHEET (main / division / myAuth / userInfo)
- BLOCK 4: SCM_ADM_API_M (7 SP × API_ID)
- BLOCK 5: SCM_ADM_PROC_M (7 SP × parameter 매핑)
- BLOCK 6: SCM_ADM_SHEET_COLUMNS (4 grid column meta)
- BLOCK 7: SCM_ADM_USER_GR_MNU_BTN_MPG_M (GUEST 권한)
```

### §7.3 BE SP body (Oracle 변환)

- `P_SCM0008_GET_CURRENT_USER` (1 IN: userId, 1 OUT: cursor)
- `P_SCM0008_GET_AUTH_GROUP_INFO` (0 IN, 1 OUT)
- `P_SCM0008_GET_MY_AUTH_LIST` (1 IN: userId, 1 OUT)
- `P_SCM0008_GET_DIVISION_LIST` (0 IN, 1 OUT)
- `P_SCM0008_ADD_MY_AUTH` (5 IN: userId, groupId, divisionId, plant, customer, 1 OUT)
- `P_SCM0008_REQUEST_AUTH` (1 IN: userId, 1 OUT: result)
- `P_SCM0008_DELETE_MY_AUTH` (2 IN: userId, requestId, 1 OUT)

→ AS-IS MSSQL SP body 별도 변환 작업 필요 (룰 _analysis/db_migration/01_MSSQL_to_Oracle_Conversion_Rules.md).

## §8 reference 화면 (cross-check 의무)

| reference | 사유 |
|---|---|
| `features/admin/src/pages/user-management/` | admin 표준 패턴 (단일 grid + form) |
| `features/admin/src/pages/menu-management/` | admin 표준 (master-detail) |
| `features/admin/src/pages/group-management/` | 권한 관련 화면 (가장 유사) |
| **`features/admin/src/pages/lookup/`** | **SCM0003 = TO-BE 동등 — 본 4 화면 작업의 cross-check reference** |

## §9 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | SCM0008 정밀 분석 신규 작성 — 7 SP + 4 button + 3 grid + 1 form 매핑 |
