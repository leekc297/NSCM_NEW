# SCM0009 (Auth Approval) — AS-IS 정밀 분석

> 신규 화면 작성. 작성: 2026-06-04.

## §0 메타

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.SystemMgmt.UIL/SCM0009_Auth_Approval.{cs,Designer.cs}` (1053 lines) |
| TO-BE MNU_ID | `SYS0012` |
| TO-BE MNU_URL | `auth-approval` |
| TO-BE UPPR_MNU_ID | `Auth_Mgmt` |
| TO-BE 위치 | `nscm-fe/features/admin/src/pages/auth-approval/` |
| 기능 | 관리자가 사용자 권한 신청 승인/반려 |

## §1 Button (CRUD)

| Button | AS-IS 위치 | 본문 | TO-BE hotkeyConfig |
|---|---:|---|---|
| Find | L412 | FindData() | `search` (function) |
| 나머지 | (override 없음) | — | 자동 활성 또는 false |

특화 customButtons:
- **Approve** → UP_FX_SaveApprovalAuthRequest (status='Y')
- **Reject** → UP_FX_SaveApprovalAuthRequest (status='N')

## §2 API / SP (2개)

| # | SP | TO-BE sheetName | mnuBtnCd |
|---:|---|---|---|
| 1 | `UP_FX_GetApprovalAuthRequest` (L437) | `main` | `RETRIEVE` |
| 2 | `UP_FX_SaveApprovalAuthRequest` (L269) | `main` | `APPROVE` / `REJECT` |
| (참고) | `SCP.GET_DATE_RANGE_1MONTH_BEFORE` (L337) | (Period default) | (서버 시간 조회) |

→ Oracle 변환: `P_SCM0009_GET_APPROVAL_LIST` / `P_SCM0009_APPROVE_AUTH` / `P_SCM0009_REJECT_AUTH`

## §3 Validation (MessageHelper)

| MSG ID | 의미 | AS-IS 위치 |
|---|---|---:|
| MSG00096 | 권한 없음 (2건) | L180, L213 |
| MSG00020 | 처리 완료 | L291 |
| MSG00005 | 변경 없음 | L478 |
| MSG00021 | 처리 실패 | L484 |

## §4 Layout (.Designer.cs)

- 단일 grid: 승인 대기 list (RequestId / UserId / UserName / GroupId / Division / Plant / RequestDate / Status 등)
- 검색조건: UserId / Period (기간)
- 2 button: Approve / Reject

## §5 TO-BE 매핑

### §5.1 FE 표준 7 파일

```
nscm-fe/features/admin/src/pages/auth-approval/
├─ auth-approval.constants.ts
├─ auth-approval.types.ts
├─ useAuthApprovalStore.ts
├─ AuthApproval.tsx (main: 1 grid + form)
├─ index.ts
└─ components/
   ├─ AuthApprovalForm.tsx (UserId + Period)
   └─ AuthApprovalGrid.tsx (승인 대기 list — checkbox 선택 + Approve/Reject)
```

### §5.2 BE 메타 SQL (7-BLOCK)

`_artifacts/SCM0009_SYS0012_AuthApproval_meta.sql`

### §5.3 권한

- MSG00096 (권한 없음) 분기 → 관리자만 접근 가능 메뉴 권한 (SCM_ADM_USER_GR_MNU_BTN_MPG_M)
- ADMIN 그룹만 활성화

## §6 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | SCM0009 정밀 분석 신규 작성 — 2 SP + 1 grid + Approve/Reject |
