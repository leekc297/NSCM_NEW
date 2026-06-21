# Doc/_dev_rules/hooks/ — 상태 안내 (2026-06-18 정리, R-5)

> ⚠️ **이 폴더는 룰 v1 레거시입니다. Hook 의 단일 진실 source 는 `Doc/_rules_v2/hooks/` (69) + `Doc/_rules_consolidation/RULESET_MASTER §4` 입니다.**

## 분류

### 1~2. 룰 v2 중복 16종 — `_archive/hooks/` 이동 완료 (2026-06-18, R-5)
> grep 노이즈 제거 위해 물리 이동. 모두 v2 동등 hook 존재 — 직접 참조 금지.
- (이동) anti-simplification / asis-button-mapping / asis-coverage-check / db-error-asis-cross-check / deploy-package-completeness / grid-column-meta-mandatory / menu-not-displayed-debug / oracle-cmbo-varname-quote / popup-asis-analysis / popup-dialog-layout / post-write / pre-submit / pre-write / runtime-error-prevention / screen-entry-asis-baseline / wijmo-merge-sticky-content
- 위치: `Doc/_dev_rules/_archive/hooks/` · v2 대응: `Doc/_rules_v2/hooks/<동명>.md` (anti-simplification 은 `_rules_v2/anti-simplification.md`, grid-column-meta-mandatory 는 `grid-column-meta.md`)

### 3. 룰 v2 미흡수 레거시 (이 폴더에 잔존 — 참조 시 룰 v2 우선, 충돌 시 v2 적용)
- screen-analysis-pre-build.md / screen-analysis-post-build.md / screen-analysis-pre-submit.md (화면 분석서 v7.4 작업용)
- new-screen-pre-build.md (→ v2 screen-create-checklist 가 후속)
- fe-import-check.md (→ v2 `_tobe/02_imports.md` 가 후속)
- module-duplication-check.md / encoding-check.md / rule-md-organize.md
- figma-mapping-check.md (룰 31 보조) / pivot-frozen-columns.md (룰 v2 07_datagrid 보조)
