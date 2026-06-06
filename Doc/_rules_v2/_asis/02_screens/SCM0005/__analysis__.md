# SCM0005 (Dynamic Query List) — AS-IS 정밀 분석

> 신규 화면 작성. 작성: 2026-06-04.

## §0 메타

| 항목 | 값 |
|---|---|
| AS-IS source | `GSCM.SCM.Master.UIL/SCM0005_DynamicQueryList.{cs,Designer.cs}` (2212 lines) |
| TO-BE MNU_ID | **❓ 매핑 결정 필요** — SYS0005 procedure-management 와 별개? 또는 동일? |
| 기능 | 사용자 정의 Dynamic Query (SQL) 생성 / 조회 / 실행 / Parameter / Column 메타 관리 |

## §1 AS-IS Button (CRUD)

| Button | AS-IS 위치 | TO-BE 매핑 |
|---|---:|---|
| Find | L285 | `search` |
| Insert | L291 | `insert` |
| Delete | L296 | `delete` |
| Edit | L301 | (toggle lock) |
| Save | L318 | `save` |

특화: Execute (Query 실행 — `PR_DM_ADM_DQ_EXECUTE_HIST` 호출 후 결과 grid 표시)

## §2 API / SP (9개)

| # | SP | 의도 | sheetName |
|---:|---|---|---|
| 1 | `DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST` (L346) | Query master list | `main` |
| 2 | `DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2` (L505) | 실행 결과 | `result` |
| 3 | `PR_DM_ADM_DQ_EXECUTE_HIST` (L527) | 실행 history 저장 | `history` |
| 4 | `DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS` (L612) | 동적 column 메타 | `columns` |
| 5 | `DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS` (L628) | parameter 메타 | `parameters` |
| 6 | `PR_DM_ADM_DQ_CREATE` (L785) | Query 생성 | `main` (mnuBtnCd=CREATE) |
| 7 | `PR_DM_ADM_DQ_CREATE_USER_GROUP` (L832) | 사용자 그룹 권한 | `main` |
| 8 | `PR_DM_ADM_DQ_CREATE_COLUMN` (L863) | column 정의 저장 | `columns` |
| 9 | `PR_DM_ADM_DQ_CREATE_PARAMETER` (L900) | parameter 정의 저장 | `parameters` |

→ 매우 복잡 화면. 9 SP × 5 sheet (main / result / columns / parameters / history).

## §3 Validation

| MSG ID | 의미 |
|---|---|
| MSG00004 | Save 결과 (N rows) |

## §4 TO-BE 매핑 — ⚠️ 결정 필요

### §4.1 옵션 A: SYS0005 procedure-management 재사용

- TO-BE 의 `procedure-management` (SYS0005) 가 SP 메타 관리 화면.
- SCM0005 Dynamic Query 와 의도 다름 (NSCM 의 동적 SP 라우팅과 별개).
- **매핑 부적합** — procedure-management 는 SCM_ADM_PROC_M 의 SP 메타만 관리.

### §4.2 옵션 B: 신규 메뉴 ID 등록

- 신규 MNU_ID 등록 (예: `SYS0013` Dynamic Query / `DMF00xx` 같은 도메인 ID)
- 신규 MNU_URL = `dynamic-query-list` 또는 `dynamic-query`
- 부모 = `Admin_Menu` 또는 `System`
- 별도 메뉴 트리 등록 의무

### §4.3 옵션 C: 격차 유지 (현재 미사용)

- AS-IS 의 SCM0005 가 실제 운영에 사용되는지 확인 필요
- 미사용 시 격차 유지 결정

→ **사용자 결정 위임**: 옵션 A/B/C 중 어느 것?

## §5 TO-BE 매핑 (옵션 B 가정)

### §5.1 FE 표준 22 파일 (대규모)

```
nscm-fe/features/admin/src/pages/dynamic-query/
├─ dynamic-query.constants.ts (MENU_ID / 5 SHEETS / RESPONSE_SET)
├─ dynamic-query.types.ts
├─ useDynamicQueryStore.ts (5 sheet filter + Query state)
├─ DynamicQuery.tsx (main: 2 grid + 2 tab + Execute button)
├─ index.ts
└─ components/
   ├─ DynamicQueryForm.tsx (조회조건)
   ├─ DynamicQueryMainGrid.tsx (Query master list)
   ├─ DynamicQueryResultGrid.tsx (실행 결과)
   ├─ DynamicQueryColumnsGrid.tsx (column 메타 — editable)
   ├─ DynamicQueryParametersGrid.tsx (parameter 메타 — editable)
   ├─ DynamicQueryExecuteModal.tsx (parameter 입력 + 실행)
   └─ DynamicQueryUserGroupModal.tsx (사용자 그룹 권한)
```

### §5.2 BE 메타 SQL (7-BLOCK 대규모)

`_artifacts/SCM0005_DynamicQuery_meta.sql`
- BLOCK 4: 9 API
- BLOCK 5: 9 PROC
- BLOCK 6: 5 sheet × column meta

## §6 우선순위 — 4 화면 비교

| 화면 | 복잡도 | 노력 | 우선순위 |
|---|---|---|---|
| SCM0008 Auth Request | 中 (7 SP + 3 grid) | 중 | 高 (보안 권한) |
| SCM0009 Auth Approval | 小 (2 SP + 1 grid) | 소 | 高 (보안 권한 + 단순) |
| SCM0003 Lookup | (cross-check only) | 소 | 中 (검증 작업) |
| SCM0005 Dynamic Query | 大 (9 SP + 5 sheet) | 대 | 低 (매핑 결정 필요) |

## §7 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | SCM0005 분석 — 9 SP + 5 sheet + TO-BE 매핑 결정 위임 |
