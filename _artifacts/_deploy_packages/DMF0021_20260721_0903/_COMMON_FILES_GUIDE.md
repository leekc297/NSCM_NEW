# DMF0021 전체 이관 — 공통 파일 patch 가이드 (신규 배포 기준)

> 신규 배포 시 아래 공통 파일에 DMF0021 진입점을 등록(기존 repo 에 이미 있으면 skip).
> 기존 화면 보완만 반영하면 = **공통 파일 patch 0**.

## 1. `apps/web/src/core/Router.tsx` — 라우트 + Lazy import
```tsx
const SalesPlanPageWithTab = LazyLoader(() =>
  import('@demand/sales-plan').then(m => ({ default: m.SalesPlan }))
);
// DEMAND_PLAN children:
{ path: 'sales-plan', element: <SalesPlanPageWithTab /> },
```
> ⚠ slug `sales-plan` = **route-paths.ts / Router.tsx / 사내 `SCM_ADM_MNU_M.MNU_URL`(01 SQL) 3-SET 동일** (feedback_route_slug_mnu_url_3set). DMF0021 은 route-paths 에 ROUTE_PATHS 등재분 존재(DMF0021 배선 4점).

## 2. `route-paths.ts` — DMF0021='sales-plan' 등재 확인 / workspace alias `@demand/sales-plan` → `features/demand/src/pages/sales-plan/index.ts`(barrel `export { SalesPlan }`).

## 3. `procedures.d.ts` (글로벌 type) — DMF0021 5시트 유니온
- DMF0021 은 **procedures.d.ts 배선 존재**(SHEETS: 'Sales Plan'/spreadTitle/measureInfo/dayRange/titleSet). 신규 repo 에 없으면 등록. (본 세션 보완은 글로벌 type 무변경.)

## 4. `public/locales/{ko,en,cn}.json` — MSG00085 / MSG00146 / MSG00361
- DB(06 SQL)로도 등록되나, FE fallback 문구용 3종 locale 반영(gitignore 대상 — DB 원천). 신규 배포 시 확인.

## 5. 변경 불필요 공통 파일

| 파일 | 사유 |
|---|---|
| BE Java | 동적 호출(GeneralController) — SP 배선은 PROC_M(02)·콤보 CMBO_SQL_M(05). BE 코드 0 |
| shared 컴포넌트 | 무수정 원칙 (merge 1단계 복제만) |

## 6. 필수 정합
- **02 PROC_M ↔ sp/ SP 시그니처**: DATAEX(17 IN + 3 커서), SAVE_ALL(16키 '^' bulk), MEASUREINFO, SPREAD_TITLE. positional 불일치 시 -9994.
- ⭐ **05 SalesPlanUserAuthGroup ↔ FE authGroup 주입** + **07 GET_ADMIN_GROUP_MEASURE(SEGMENT2='DMF0021')**: 편집권한 핵심. `session.groupId` 유령필드라 이 CMBO 미적용 시 EDIT_AUTH 전부 'N'.
- ⭐ **03 FROM_SITE_ID 81행(VISIBLE 'Y')** ↔ FE save.ts 81 치환(#1): 미적용 시 81 저장 손상/컬럼 미표시.
- ⭐ **sp/ DATAEX·SPREAD_TITLE = DEFAULT_FLAG NVL 교정본**: 구 SP(`DEFAULT_FLAG=''`) 배포 시 필수컬럼/행게이트 탈락 → 빈 그리드.
- 03 SHEET_COLUMNS DIVISION_ID = hook #113(서버 직접비교, 하드코딩·화이트리스트 금지) — SP `PR_GET_SHEET_COLUMN_LIST` 준수.
