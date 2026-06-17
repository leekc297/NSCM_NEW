# DMF0043 / DMF0043_01 전체 클라우드 이관 패키지 (2026-06-17)

## 화면

| MNU_ID | 이름 | FE 폴더 |
|---|---|---|
| DMF0043 | 해외법인 기여율 등록 (Contribute Main) | `contribute-main/` |
| DMF0043_01 | 해외법인 기여율 조회 (Contribute View) | `contribute-view/` |

## 로컬 검증 완료

> "DMF0043 local 에서는 년월별 지역별 데이터 조회 됩니다." (사용자 2026-06-17 14:30 회신)

- 사내 Oracle SP cursor 129 컬럼 정상 (12 BASE + 9 Y# + 108 M#)
- 로컬 FE / BE 동작 완전 정상
- DataGrid `autoGenerateColumns={false}` 사고 fix 완료 (Wijmo 기본 동작 복원)

## 폴더 구조

```
DMF0043_FULL_DEPLOY_20260617/
├─ 00_README.md (이 파일)
├─ 01_SP_PATCH/                                       (사내 → 클라우드 SP 9 객체 — 멱등 CREATE OR REPLACE)
│  ├─ 00_ALL_DMF0043_patch.sql                        (통합 단일 실행 권장 — 3,794 lines)
│  ├─ 01_PKG_DMF0043_PACKAGE.sql                      (102 lines)
│  ├─ 02_PKG_DMF0043_PACKAGE_BODY.sql                 (1,780 lines)
│  ├─ 03_DMF0043_GET_CONTRIBUTE_MAIN_DATA_PROCEDURE.sql       (845 lines)
│  ├─ 04_DMF0043_GET_MAIN_SPREAD_TITLE_PROCEDURE.sql          (212 lines) ⭐ dynamic 컬럼 root
│  ├─ 05_DMF0043_GET_CONTRIBUTE_RATE_POPUP_PROCEDURE.sql      (60 lines)
│  ├─ 06_DMF0043_GET_CONTRIBUTE_YEAR_POPUP_PROCEDURE.sql      (79 lines)
│  ├─ 07_DMF0043_GET_CONT_VIEW_VERSIONPOPUP_PROCEDURE.sql     (100 lines)
│  ├─ 08_DMF0043_GET_SALES_LIST_SPREAD_TITLE_PROCEDURE.sql    (67 lines)
│  ├─ 09_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO_PROCEDURE.sql   (518 lines)
│  └─ 10_verify_compile.sql                          (사후 검증 7 query — INVALID/ERROR/권한/LAST_DDL/사용자권한/SHEET_COLUMNS/Cursor 컬럼)
├─ 02_META/
│  └─ 00_META_diff_check.sql                         (사내↔클라우드 메타 10 cross-check query)
└─ 03_FE/                                            (FE 14 변경 파일)
   ├─ contribute-main/                               (DMF0043 — 7 파일)
   │  ├─ ContributeMain.tsx
   │  ├─ contribute-main.constants.ts
   │  ├─ useContributeMainStore.ts
   │  └─ components/
   │     ├─ ContributeMainGrid.tsx                   ⭐ 동적 column merging + admin staticColumns override
   │     ├─ ContributeRatePopup.tsx
   │     ├─ SearchBar.tsx
   │     └─ VersionPopup.tsx
   ├─ contribute-view/                               (DMF0043_01 — 6 파일)
   │  ├─ ContributeView.tsx
   │  ├─ contribute-view.constants.ts                ⭐ META_MENU_ID='DMF0043' + META_SHEETS.MAIN='ContributeSalesList' (cross-screen)
   │  ├─ useContributeViewStore.ts
   │  └─ components/
   │     ├─ ContributeViewGrid.tsx
   │     └─ modals/
   │        ├─ ColumnTitleSetModal.tsx
   │        └─ ContributeVersionModal.tsx
   └─ shared/data-grid/
      └─ DataGrid.tsx                                ⭐ autoGenerateColumns 전역 변경 롤백 (Wijmo 기본 동작 복원)
```

## 적용 순서 (권장)

### Step 1 — SP patch (DBeaver / SQLcl / SQL*Plus, SCM_MGR 접속)

```sql
@01_SP_PATCH/00_ALL_DMF0043_patch.sql
@01_SP_PATCH/10_verify_compile.sql
```

기대값:
- Query 1 (INVALID): 0 row
- Query 2 (ALL_ERRORS): 0 row
- Query 3 (권한): 9 row × EXECUTE
- Query 4 (LAST_DDL): 9 객체 모두 SYSDATE 근처
- Query 5 (사용자 권한): UNIT_ID=40 + EDIT_YN=Y 포함
- Query 6 (SHEET_COLUMNS): DMF0043 + DMF0043_01 모두 등록
- Query 7 (Cursor): Total 129 / Y#=9 / M#=108 / GT=117

⚠ INVALID 잔존 시 fallback ALTER COMPILE 블록이 통합 SQL 끝에 동봉됨 (2 객체 의존 순서 사고 자동 해소).

### Step 2 — 메타 cross-check (이관 전 차이 식별)

```sql
@02_META/00_META_diff_check.sql
```

사내 + 클라우드 양쪽 모두 실행 → 결과 비교 → 클라우드에 누락된 row 만 추가 INSERT SQL 작성.

10 cross-check query 가 다음 메타 검증:
1. SCM_ADM_MNU_M (메뉴)
2. SCM_ADM_API_M (API)
3. SCM_ADM_PROC_M (SP 메타)
4. SCM_MST_SHEET_COLUMNS (column)
5. SCM_MST_SHEET_MEASURE (measure)
6. SCM_ADM_MNU_BTN_MPG_M (버튼)
7. SCM_ADM_USER_GR_MNU_MPG_M (메뉴 권한)
8. SCM_ADM_USER_GR_MNU_BTN_MPG_M (버튼 권한)
9. SCM_ADM_CMBO_SQL_M (콤보 SQL_ID)
10. Row count 요약

### Step 3 — FE 파일 배포

`03_FE/` 안 14 파일을 클라우드 nscm-fe 의 대응 경로에 복사:

| 본 폴더 | 클라우드 경로 |
|---|---|
| `03_FE/contribute-main/**` | `nscm-fe/features/master/src/pages/contribute-main/**` |
| `03_FE/contribute-view/**` | `nscm-fe/features/master/src/pages/contribute-view/**` |
| `03_FE/shared/data-grid/DataGrid.tsx` | `nscm-fe/packages/shared/src/components/organisms/data-grid/DataGrid.tsx` |

이후 클라우드 FE 빌드 (`pnpm build` — 클라우드 운영팀 실행).

### Step 4 — 브라우저 검증

DMF0043 화면 진입 → Version 선택 → 검색 → 다음 4 항목 확인:

- [ ] BASE 6 컬럼 (부문/팀/고객군/판매처/제품군/형태) 표시
- [ ] Y# 동적 컬럼 9개 (연도 총계 — `Y#2024#RBU_xxxx`) 표시
- [ ] M# 동적 컬럼 108개 (월별 — `M#202401#RBU_xxxx`) 표시
- [ ] 버전 변경 시 dynamic 컬럼 재조회 + 정상 표시

DMF0043_01 도 동일 검증.

## 핵심 변경 요약

### FE 측 fix 핵심

| 파일 | 변경 핵심 |
|---|---|
| ContributeMainGrid.tsx | v6 fix — staticColumns 빈 시 BASE fallback + admin 메타 전체 동기화 (header/width/align/format/inputTpCd/cellType/comboKey/modalKey) |
| useContributeMainStore.ts | META_SHEETS enum + fetchStaticColumns (admin 동기) |
| contribute-main.constants.ts | META_SHEETS.MAIN='ContributeMain' (PascalCase SHEET_COLUMNS key) |
| ContributeViewGrid.tsx | DMF0043_01 동일 패턴 + cross-screen META_MENU_ID='DMF0043' |
| contribute-view.constants.ts | META_MENU_ID='DMF0043' + META_SHEETS.MAIN='ContributeSalesList' |
| useContributeViewStore.ts | type-only MENU_ID import (lint fix) |
| **DataGrid.tsx** | **autoGenerateColumns 전역 변경 롤백** — Wijmo 기본 동작 (true) 복원 |

### SP 측 fix 핵심

DMF0043_GET_MAIN_SPREAD_TITLE — dynamic 컬럼 생성 root SP. 3rd UNION 의 GT_GMST_TEMP2_2 117 row → `FLAG#YYYYMM#CODE` 패턴 column 메타 생성. wrapper SP 가 PIVOT IN list 동적 조립.

## ⚠ 클라우드 BE 빌드 시점 확인

본 패키지는 **BE 변경 없음** (사용자 명시 — 2026-06-17). 그러나 동적 컬럼 표시는 BE 의 다음 설정에 의존:

```xml
<!-- nscm-be/src/main/resources/mybatis/mybatis-config.xml -->
<setting name="callSettersOnNulls" value="true"/>
```

사내 main commit `eb1686c` (2026-06-01) 에 포함. **클라우드 BE 가 이 commit 이전 빌드** 라면 dynamic 컬럼 응답 누락 가능.

→ 클라우드 BE 재빌드 시점 확인 후 필요 시 별도 BE 재배포 (본 패키지 외).

## 작성 정보

- 작성 일자: 2026-06-17
- 사내 환경: 121.162.245.167:2521/ESSCMD (SCM_MGR)
- SP patch 추출 도구: `_artifacts/_diagnostics/extract_dmf0043_patch.py`
- 메타 cross-check: 사내↔클라우드 비교 후 INSERT NOT EXISTS 패턴 권장
- FE 변경 파일: 14개 (DMF0043 7 + DMF0043_01 6 + shared 1)
- BE 변경: 0 파일 (정책)
