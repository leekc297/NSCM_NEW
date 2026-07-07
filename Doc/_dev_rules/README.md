# Doc/_dev_rules — NSCM 룰셋 (룰 v1 archive + 유지)

> ⚠️ **2026-06-03 룰 v2 전환**: 룰 v1 (구) 24 룰이 `_archive/` 로 이동되었습니다.
> **신규 작업은 룰셋 v2 (`Doc/_rules_v2/`) 진입점 사용 의무**.

---

## 0. 룰셋 진입점 (의무 — 2026-06-18 단일화 R-1)

```
1. Read: Doc/_rules_v2/anti-simplification.md          ⚠️ 최우선
2. Read: Doc/_rules_consolidation/RULESET_MASTER.md    ← ⭐ 단일 진입 (트리거 + hook 카탈로그 + UI 체크리스트)
3. Read: Doc/_rules_v2/00_INDEX.md                      ← 상세 카탈로그
```

상세는 루트 `CLAUDE.md` → `Doc/_rules_consolidation/RULESET_MASTER.md` 참조.

---

## 1. 현재 유지되는 룰 v1 (8 룰) — 2026-06-18 룰 32 등재 (R-5)

> Phase 4 결정 (2026-06-03): 절차/환경 표준은 룰 v2 와 별도로 유지. 단일 출처 = `RULESET_MASTER §5.4`.

| 룰 # | 토픽 | 사유 |
|---:|---|---|
| `02_DEVELOPMENT_RULES.md` | 브랜치/커밋/PR/리뷰 | 절차 표준 |
| `21_TROUBLESHOOTING.md` | Oracle/DBeaver/Wijmo/PowerShell 종합 | 트러블슈팅 — 룰 v2 와 cross-ref |
| `22_PACKAGE_ARTIFACTS.md` | 이관 패키지 (`_artifacts`) | 절차 표준 |
| `28_GIT_MULTI_REMOTE.md` | NSCM 모노레포 + GitHub + GitLab | 절차 표준 |
| `29_LOCAL_DB_CSV_IMPORT.md` | Docker Oracle CSV 적재 | 환경 표준 |
| `30_LOCAL_BACKUP_RESTORE.md` | 백업/원복 표준 | 환경 표준 |
| `31_FIGMA_DESIGN_INTEGRATION.md` | Figma → React 매핑 | 절차 표준 |
| `32_CLAUDE_ORACLE_DIRECT.md` | ⭐ Claude Code Oracle 직결 (SQLcl/oracledb/docker sqlplus) | DB · 2026-06-11 신설, 2026-06-18 정식 등재 |

→ 룰 v2 의 `00_INDEX.md §A` 트리거 T10~T13 / T16 에서 자동 분기.

---

## 2. `_archive/` 의 룰 v1 (24 룰)

> 룰 v2 안에 흡수됨. **신규 작업 시 직접 참조 금지**. 과거 자료 보존용.

| Archived 룰 # | 흡수 위치 (룰 v2) |
|---:|---|
| `00_INDEX.md` | `Doc/_rules_v2/00_INDEX.md` (재작성) |
| `01_CLAUDE.md` | `Doc/_rules_v2/CLAUDE.md` (재작성) |
| `03_FE_RULES.md` | `_tobe/01~10.md` |
| `04_BE_RULES.md` | `_tobe/11_be_controller_service.md` |
| `05_SCREEN_TEMPLATE.md` | `_tobe/03_main_component.md` + `_tobe/04_store.md` |
| `06_HOOKS.md` | `_rules_v2/hooks/*.md` (10 hook 재작성) |
| `07_DO_AND_DONT.md` | `_tobe/*.md` 각 룰의 §3 (금지) |
| `08_SCREEN_REGISTRATION.md` | `_tobe/12_metadata_sql.md` |
| `09_WIJMO_VALIDATION_EXPRESSION.md` | `_tobe/07_datagrid.md` + `_tobe/08_column_meta.md` |
| `10_API_DYNAMIC_PROC.md` | `_tobe/11_be_controller_service.md` §4 + `_tobe/12_metadata_sql.md` |
| `11_AUTH_SECURITY.md` | `_tobe/11.md` §5~6 + `_asis/00_framework/05_Auth_FormAuth.md` |
| `12_GRID_COMMON.md` | `_tobe/07_datagrid.md` + `_tobe/08_column_meta.md` |
| `13_I18N_MESSAGES.md` | `_tobe/05_constants.md` + `_asis/00_framework/03_MessageHelper.md` |
| `14_ERROR_HANDLING.md` | (Phase 5 신규 룰 14 작성 예정) |
| `15_ROUTING_MDI.md` | `_tobe/13_routing_menu.md` |
| `16_LOGGING_AUDIT.md` | `_asis/00_framework/04_Logging.md` + G3 신규 구현 |
| `17_NEW_SCREEN_QUICKSTART.md` | `_rules_v2/hooks/screen-create-checklist.md` |
| `18_CODE_REVIEW_CHECKLIST.md` | `_rules_v2/hooks/pre-submit.md` |
| `19_MOCKUP_SVG_RULES.md` | (Mockup 작성 시 별도 — `_asis/02_screens/__TEMPLATE__.md` 참조) |
| `20_SCREEN_ANALYSIS_PIPELINE.md` | `_asis/02_screens/__TEMPLATE__.md` (13 category) |
| `23_FE_IMPORT_INVENTORY.md` | `_tobe/02_imports.md` |
| `24_ASIS_CROSSCHECK.md` | `_rules_v2/hooks/asis-coverage-check.md` |
| `25_NEW_SCREEN_MANDATORY_CHECKLIST.md` | `_rules_v2/hooks/screen-create-checklist.md` |
| `26_VITE_DAYJS_LOCALE.md` | (메모리 `feedback_vite_dayjs_locale.md`) |
| `27_WIJMO_PIVOT_AND_MODULE.md` | `_tobe/07_datagrid.md` §2.2 + 메모리 `feedback_wijmo_*.md` |
| `_INTEGRITY_REPORT_2026-05-22.md` | (시점 기록) |

---

## 3. `hooks/` 폴더 처분 (2026-06-18 R-5 정리)

> 룰 v2 중복 16종 → `_archive/hooks/` 물리 이동 완료 (grep 노이즈 제거). 미흡수 유니크 10종만 `hooks/` 에 잔존.
> 상세 = `Doc/_dev_rules/hooks/README.md`.

- 잔존 10종 (v2 미흡수): screen-analysis-pre/post/pre-submit · new-screen-pre-build · fe-import-check · module-duplication-check · encoding-check · rule-md-organize · figma-mapping-check · pivot-frozen-columns
- 이동 16종 위치: `Doc/_dev_rules/_archive/hooks/` · v2 대응: `Doc/_rules_v2/hooks/`

신규 작업 시: 룰 v2 hooks (69) 우선. v1 hooks 는 참고용만.

---

## 4. 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-03 | Phase 4 룰 v2 전환: 24 룰 `_archive/` 이동, 7 룰 유지, README 재작성 |
| 2026-06-18 | 정합 정비 (R-1/R-5): 진입점 단일화(RULESET_MASTER), 룰 32 정식 등재(7→8), v1 중복 hook 16종 `_archive/hooks/` 이동 |

> Plan 파일: `C:\Users\ejene\.claude\plans\effervescent-beaming-donut.md`
