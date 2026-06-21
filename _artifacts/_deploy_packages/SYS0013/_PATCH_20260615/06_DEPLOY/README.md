# SYS0013 (Dynamic Query List) — 클라우드 이관 패키지

**빌드일자**: 2026-06-15T16:42:01.621114
**원본 환경**: 121.162.245.167:2521/ESSCMD (사내 검증 완료)

## 구조
- `01_FE/` — Frontend 5 파일 (수동 배포)
- `02_DB_DDL/` — PKG + 7 standalone SP (SCM_MGR)
- `03_GRANT_SYNONYM/` — SCMD_APP 권한 (Step 1: SCM_MGR / Step 2: SCMD_APP)
- `04_META/` — 8 메타 테이블 (멱등 NOT EXISTS)
- `06_DEPLOY/` — apply.sh + README

⚠ **DQ 데이터 (DQ_LIST/COLUMN/PARAMETER/USER_GROUP/EXECUTE_H) 는 본 패키지에서 제외** — 클라우드 환경에서 별도 관리/시드.

## 적용 순서 (수동)

### 1) DB — SCM_MGR user
```
sqlplus SCM_MGR/<PWD>@<DSN>
@02_DB_DDL/01_PKG_SYS0013_spec.sql
@02_DB_DDL/02_PKG_SYS0013_body.sql
@02_DB_DDL/03_SYS0013_GET_HISTORY.sql ~ 09_SYS0013_EXECUTE_HIST.sql (7개 순차)
@03_GRANT_SYNONYM/01_GRANT_SCMD_APP.sql
@04_META/01_MNU_M.sql ~ 08_SHEET_COLUMNS.sql (8개 순차)
```

### 2) DB — SCMD_APP user (SYNONYM 만)
```
sqlplus SCMD_APP/<PWD>@<DSN>
@03_GRANT_SYNONYM/02_SYNONYM_SCMD_APP.sql
```

### 3) FE — 4 파일 + 1 patch 수동 배포

⚠ **`index.ts` 통째 교체 금지** — 클라우드 측 export 목록과 로컬이 다르면 다른 hook resolve 실패.

| zip 파일 | 클라우드 배포 위치 | 방식 |
|---|---|---|
| `01_FE/useTabBtnPermissions.ts` | `nscm-fe/packages/shared/src/hooks/useTabBtnPermissions.ts` | ⭐ 신규 파일 (그대로 복사) |
| `01_FE/shared_hooks_index.PATCH.md` | (안내문 — 파일 복사 아님) | 클라우드 측 `nscm-fe/packages/shared/src/hooks/index.ts` 파일 끝에 한 줄 추가:<br>`export * from './useTabBtnPermissions';` |
| `01_FE/DynamicQuery.tsx` | `nscm-fe/features/admin/src/pages/dynamic-query/` | 교체 |
| `01_FE/DynamicQueryMainGrid.tsx` | `nscm-fe/features/admin/src/pages/dynamic-query/components/` | 교체 |
| `01_FE/dynamic-query.constants.ts` | `nscm-fe/features/admin/src/pages/dynamic-query/` | 교체 |

### 4) 검증
- 클라우드 FE 재빌드/배포
- F12 → Clear site data + 재로그인
- SYS0013 메뉴 진입 → main grid + columns/parameters/history tab 동작
