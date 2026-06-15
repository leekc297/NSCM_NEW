# Doc/_dev_rules/hooks/ — 상태 안내 (2026-06-11 정리)

> ⚠️ **이 폴더는 룰 v1 레거시입니다. Hook 의 단일 진실 source 는 `Doc/_rules_v2/hooks/` 입니다.**

## 분류

### 1. 룰 v2 로 이동 완료 (스텁만 잔존 — 직접 참조 금지)
- oracle-cmbo-varname-quote.md → `_rules_v2/hooks/` (2026-06-11)
- db-error-asis-cross-check.md → `_rules_v2/hooks/` (2026-06-11)
- deploy-package-completeness.md → `_rules_v2/hooks/` (2026-06-11)
- screen-entry-asis-baseline.md → `_rules_v2/hooks/` (2026-06-11)
- wijmo-merge-sticky-content.md → `_rules_v2/hooks/` (2026-06-11)
- popup-dialog-layout.md → `_rules_v2/hooks/` (2026-06-11)

### 2. 룰 v2 에 동명/동등 hook 존재 — DEPRECATED (v2 버전 사용)
- pre-write.md / post-write.md / pre-submit.md
- asis-coverage-check.md / asis-button-mapping.md
- runtime-error-prevention.md / popup-asis-analysis.md
- menu-not-displayed-debug.md
- anti-simplification.md (→ `_rules_v2/anti-simplification.md`)
- grid-column-meta-mandatory.md (→ `_rules_v2/hooks/grid-column-meta.md`)

### 3. 룰 v2 미흡수 레거시 (참조 시 룰 v2 우선, 충돌 시 v2 적용)
- screen-analysis-pre-build.md / screen-analysis-post-build.md / screen-analysis-pre-submit.md (화면 분석서 v7.4 작업용)
- new-screen-pre-build.md (→ v2 screen-create-checklist 가 후속)
- fe-import-check.md (→ v2 `_tobe/02_imports.md` 가 후속)
- module-duplication-check.md / encoding-check.md / rule-md-organize.md
- figma-mapping-check.md (룰 31 보조) / pivot-frozen-columns.md (룰 v2 07_datagrid 보조)
