# DMF0035 ALLCOLS — UI CATEGORY 전체 컬럼 반환 (사내 적용 2026-08-28 20:14)

- 대상: SCM_MGR.PKG_DMF0035 / PKG_DMF0022 / PKG_DMF0051 BODY (마커 `[E20260828-ALLCOLS]`)
- 요구: 사용자 지시 2026-08-28 — COLUMN 은 UI CATEGORY 전체, ROWS 는 division DEFAULT 컬럼만(FE), MEASURE 는 VISIBLE 무관 상시
- 파일: `00_BACKUP_*` (적용 전 LIVE) → `01_PATCHED_*` (적용본) → `02_POSTAPPLY_*` (적용 후 LIVE 재추출)
- 결과: 정적 컬럼 22→55 / 20→52 / 25→51, 행수 761 / 2619 / 15897 **불변**
- ⚠ 1차 적용 사고: 감사컬럼(LAST_UPDATE_DATE·LAST_UPDATED_BY)이 집계 grain 을 쪼개 761→806 행 — 감사 4컬럼(CREATION_DATE/CREATED_BY/LAST_UPDATE_DATE/LAST_UPDATED_BY) 제외 후 재적용으로 복원(기간합 8,665,634,450 동일). 클라우드 이관 시 `01_PATCHED_*` 최종본 사용.
- 검증: `python _patch_apply.py apply` 가 before/after 컬럼·행수를 출력. HTTP E2E DMF0035 종합 PASS(20:12) · um12_browser_probe PASS.
