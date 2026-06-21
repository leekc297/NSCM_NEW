# NSCM 11 화면 클라우드 이관 — 마스터 README

> 작성일: **2026-06-21** · 구조: UI 별 단일 폴더 + README
> 대상 환경: 사내 NSCM 운영 — `10.34.220.81:2521:ESSCMD` / SCM_MGR

---

## §1. 이관 대상 11 화면

| # | MENU_ID | Domain | features 폴더 | README |
|---:|---|---|---|---|
| 1 | DMF0008 | master | `features/master/src/pages/erp-edi-master/` | [DMF0008/README.md](./DMF0008/README.md) |
| 2 | DMF0020 | master | `features/master/src/pages/sales-future-price/` | [DMF0020/README.md](./DMF0020/README.md) |
| 3 | DMF0043 | master | `features/master/src/pages/contribute-main/` | [DMF0043/README.md](./DMF0043/README.md) |
| 4 | DMF0043_01 | master | `features/master/src/pages/contribute-view/` | [DMF0043_01/README.md](./DMF0043_01/README.md) |
| 5 | DMF0072 | master | `features/master/src/pages/nn-master-mapping/` | [DMF0072/README.md](./DMF0072/README.md) |
| 6 | SYS0010 | admin | `features/admin/src/pages/lookup/` | [SYS0010/README.md](./SYS0010/README.md) |
| 7 | SYS0011 | authority | `features/authority/src/pages/auth-request/` | [SYS0011/README.md](./SYS0011/README.md) |
| 8 | SYS0012 | authority | `features/authority/src/pages/auth-approval/` | [SYS0012/README.md](./SYS0012/README.md) |
| 9 | SYS0013 | admin | `features/admin/src/pages/dynamic-query/` | [SYS0013/README.md](./SYS0013/README.md) |
| 10 | SYS0014 | admin | `features/admin/src/pages/group-user/` | [SYS0014/README.md](./SYS0014/README.md) |
| 11 | SYS0015 | admin | `features/admin/src/pages/program/` | [SYS0015/README.md](./SYS0015/README.md) |

---

## §2. 공통 항목 (선행 이관 의무 — 11 화면 모두 영향)

### A. packages/foundation/src/ (4 Modified)
- `constants/route-paths.ts` — 11 화면 라우팅 등록
- `apis/axios.ts` — 전 API 호출
- `assets/icon/index.ts` — 화면별 icon
- `models/common/session.ts` — 세션 모델

### B. features/master/src/components/ (5 Modified + 2 New — DMF0043/DMF0043_01/DMF0072/DMF0020 공유) ⭐

> ⚠️ **type-check 실패 root cause** (클라우드 2026-06-21):
> 본 영역 누락 시 `ContributeVersionModal export 없음` / `initialVisibleKeys prop 없음` 다수 발생.

| 파일 | 변경 | 영향 화면 |
|---|---|---|
| `components/columnSettingModal/ColumnSettingModal.tsx` + `.module.scss` | M | DMF0020, DMF0043_01 (initialVisibleKeys prop 추가) |
| `components/index.ts` | M | export 갱신 (ContributeVersionModal / ContributeRateModal 등) |
| `components/ownerByDivisionModal/OwnerByDivisionModal.tsx` | M | 다수 화면 |
| `components/projectByDivisionModal/ProjectByDivisionModal.tsx` | M | 다수 화면 |
| `components/searchFields/SearchFields.tsx` + `index.ts` | M | 다수 화면 |
| `components/contributeVersionModal/` | **N (신규)** | DMF0043 ContributeMain |
| `components/contributeRateModal/` | **N (신규)** | DMF0043 |

### C. packages/shared/src/ (5 M + 9 D + 1 N)
**Modified** (필수 이관):
- `components/organisms/alert/Alert.tsx`
- `components/organisms/search-area/SearchArea.tsx`
- `components/organisms/sub-title/SubTitle.tsx`
- `components/molecules/index.ts` + `hooks/index.ts`
- `stores/useMessageStore.ts` + `stores/useSessionStore.ts`

**Deleted** (9 파일 — 사용처 0 확인 ✅, 클라우드 측도 삭제):
- `components/molecules/{dateRangePicker,monthPicker,monthRangePicker}/`
- `hooks/{useBatchMutation,useConfirmYesNoCancel,useFileTransfer,usePerfTrace,useSearchConditionPersistence,useTabCombosMulti}.ts`

**New** (신규 추가):
- `components/molecules/columnSelectDualList/`

### D. BE — **변경 0건** ✅ (BE 변경 금지 룰 준수)

### E. 화면별 Deleted 파일 (클라우드도 삭제 의무) ⭐
> ⚠️ Deleted 파일 클라우드 미반영 시 → store prop 참조 fail (`versionPopupOpen` 등 type-check 에러)

| 화면 | Deleted 파일 |
|---|---|
| DMF0008 | `components/<2 deleted files>` |
| DMF0043 | `components/VersionPopup.tsx` + `.module.scss` + `components/ContributeRatePopup.tsx` (3개 → contributeVersionModal/contributeRateModal 로 대체) |
| DMF0043_01 | `components/<2 deleted files>` |
| DMF0072 | `components/<1 deleted file>` |

### F. type-check 검증 결과 + fix 진척 (2026-06-22) ⭐
| 화면 | errors | 원인 | 상태 |
|---|---:|---|---|
| DMF0020 | 1 → 0 | ColumnSettingModal `initialVisibleKeys` prop 없음 | ✅ §B 이관 완료 |
| DMF0043_01 | 1 → 0 | ColumnSettingModal `initialVisibleKeys` prop 없음 | ✅ §B 이관 완료 |
| DMF0043 | 3 → 2 | (해결: ContributeVersionModal export) + (남음: VersionPopup.tsx 미삭제 → store `versionPopupOpen` 참조) | ⚠ §E Deleted 미반영 — 클라우드 측 `git rm components/VersionPopup.tsx components/VersionPopup.module.scss components/ContributeRatePopup.tsx` |
| DMF0008 | 2 → 0 | applyReadOnlyColoring `<T=unknown>` generic + SspmGrid OwnerByDivisionModal preSearchParams 4 props | ✅ 코드 fix 완료 (2026-06-22) |
| DMF0072 | 5 → 0 | Form label JSX → string / Grid newValue cast / binding cast / GridAction.refresh → g.refresh / store 2단 cast | ✅ 코드 fix 완료 (2026-06-22) |
| **합계** | **12 → 2** | - | **§B 이관 + 코드 fix 완료 / 남은 2 = 클라우드 측 `git rm` 1 step** |

---

## §3. 적용 순서 (FE → DB)

```
[FE 측 — 클라우드 FE 엔지니어]
1. nscm-fe 일관 이관 (위 §1 11 화면 + §2 공통 packages)
2. nscm-fe post-import-setup (lru-cache + js-tokens + .env.local)
3. type-check + lint 통과 검증
4. (선택) regression-impact.ps1

[DB 측 — 사내 DBA — SCM_MGR 계정]
5. 각 화면별 README.md 의 "DB 적용 순서" 따라 진행
   (GRANT/SYNONYM → MNU_M → BTN_AUTH → SHEET_COLUMNS → PROC_M → SP body → i18n → VERIFY)
6. DMF0020 만 GTT 통계 추가 적용 (DMF0020/README.md 참조)

[검증]
7. 11 화면 진입 + 핵심 동작 검증 (사용자 직접)
```

---

## §4. 누락 위험 + 진단 SQL

| 증상 | 진단 SQL | 복구 |
|---|---|---|
| 화면 404 | `SELECT * FROM SCM_ADM_MNU_M WHERE MNU_ID=?` | MNU_M INSERT 재실행 |
| 조회 0 row | `SELECT * FROM SCM_ADM_PROC_M WHERE MENU_ID=?` | PROC_M INSERT 재실행 |
| ORA-00942 | `SELECT * FROM ALL_SYNONYMS WHERE SYNONYM_NAME=?` | GRANT + SYNONYM 재실행 |
| Combo dropdown 0 | `SELECT * FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID=?` | CMBO_SQL_M INSERT 재실행 |
| Button 0 | `SELECT * FROM SCM_ADM_USER_MNU_EDIT_AUTH_V WHERE MNU_ID=? AND USER_ID=?` | BTN_AUTH INSERT 재실행 |
| i18n undefined | DB MSG 테이블 또는 public/locales/*.json | 3 언어 동시 INSERT 재실행 |
| SP PLS-00306 | `SELECT * FROM ALL_ARGUMENTS WHERE OBJECT_NAME=?` | PROC_M parameter 재구성 |
| SP -9994 | `SELECT * FROM ALL_TAB_PRIVS WHERE GRANTEE='SCMD_APP' AND TABLE_NAME=?` | GRANT EXECUTE + SYNONYM |
| DMF0020 elapsed 비정상 | `SELECT * FROM ALL_TAB_STAT_PREFS WHERE OWNER='SCM_MGR' AND TABLE_NAME LIKE 'GT_FTPR_%'` | DMF0020 patch_B 적용 |

---

## §5. 실행 계정

| 계정 | 권한 | 용도 |
|---|---|---|
| **SCM_MGR** | DDL + DML + DBMS_STATS | 메타 INSERT, SP/PKG body CREATE OR REPLACE, GTT 설정, GRANT, SYNONYM |
| **SCMD_APP** | DML (EXECUTE/SELECT/INSERT/UPDATE/DELETE) | BE 사용 계정, DML 검증 |
| **minyonglee1** | 화면 로그인 | 진입 검증 user |

---

## §6. SQL 적용 의무 (각 화면 README 공통)

각 화면 README 의 SQL list 를 SCM_MGR 계정으로 순차 실행:

```bash
# DBeaver Run Script (Alt+X) / SQL Developer Run Script (F5) / SQLcl @file.sql
# 순서 의존: 04_GRANT → 03_META → 01_SP_BODY → i18n → 05_VERIFY
```

→ VERIFY SQL 결과 0 row 또는 expected 값 일치 시 PASS.

---

## §7. 검증 시각 (11 화면)

| 화면 | 진입 후 확인 |
|---|---|
| DMF0008 | ERP EDI 조회/저장/삭제 |
| DMF0020 | 헤더 정합 + sticky merge + LOC editable + elapsed (≤31.6초) |
| DMF0043 | drill-down (행 더블클릭 → DMF0043_01) |
| DMF0043_01 | DMF0043 에서 진입 후 조회 |
| DMF0072 | master mapping CRUD + 동적 column |
| SYS0010 | Lookup 코드 CRUD |
| SYS0011 | 권한 요청 → 상태 변경 |
| SYS0012 | 권한 승인/반려 popup |
| SYS0013 | 동적 쿼리 등록/실행/히스토리 |
| SYS0014 | 그룹별 사용자 + 메뉴 권한 |
| SYS0015 | 프로그램 등록/조회 |

---

## §8. SQL 파일 복원 (이전 작업 산출물)

본 폴더 11 화면 README 외 실제 SQL 파일들은 git 에 commit 되어 있음. 복원:

```bash
cd C:/Projects/NSCM
git checkout HEAD -- _artifacts/_deploy_packages/
```
→ 이전 commit (`25c583b`) 의 산출물 모두 복원. 단 이번 turn 의 untracked (DMF0020_PERF) 는 별도 작성 필요.

---

## §9. 사용자 룰 cross-ref

- `feedback_be_no_modification_rule` — BE 변경 금지
- `feedback_nscm_fe_post_import_local_setup` — 클라우드 post-import 자동화
- `feedback_scmd_app_grant_mandatory` — GRANT + SYNONYM 의무
- `feedback_fe_cloud_type_lint_readiness` — 클라우드 정합 5 패턴
- `feedback_screen_runtime_pitfalls_mandatory` — 7 pitfall 차단
- `feedback_i18n_ko_en_alignment` — 3 언어 동시
- `feedback_column_lookup_meta_standard` — CELL_COMBO_DATA_TYPE
- `feedback_asis_to_tobe_sp_no_omission` — SP 변환 누락 금지
