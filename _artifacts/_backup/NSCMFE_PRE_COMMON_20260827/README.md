# 공통소스 다운로드 백업/보고 — 2026-08-27

원천 : `common/main` = `08326f42` (2026-08-27 14:07, eunjoo-hwang/nscm-fe) / 직전 기준선 `d2d7c282` (08-24 22:45)
대상 : `nscm-fe/{apps,features,packages,public}` 4폴더 — 증분 156 파일(+5,405/-3,212)

## 판정 방식 (직전 08-25 와 동일)
내용 대조(개행 CRLF/LF 정규화) · 로컬이 공통 이력 어느 blob 과도 불일치할 때만 "내 편집본" · 양쪽 변경은 `git merge-file`(base=d2d7c282) 3-way.
mtime 판정 ⛔. 스크립트 = `%TEMP%\common_classify.py` / `common_apply.py` (Python 바이너리 I/O — PowerShell 리다이렉션은 BOM·개행 오염으로 부적합).

## 결과
| 구분 | 건수 | 처리 |
|---|---:|---|
| 동일 | 918 | - |
| 공통 최신 채택 | 126 | 덮어씀 (원본 `files/`) — forecast-price 08-26 AUTHVIEW 마커 공통본에 보존 확인(6/6·6/6·5/5·2/2) |
| 공통 신규 | 21 (+1 skip) | 추가. skip = `business-plan/화면설계서_DMF0042_BizPlan_v1.xlsx`(소스 폴더 내 설계서, 한글 인용경로) |
| 3-way 병합 | 2 | `PriceBatchInputModal.tsx`(base→common 22/11, base→mine 15/3) · `dataGridUtils.ts`(base→common 3/52, base→mine 10/2) 충돌 0 |
| **로컬 유지(내 편집·공통 무변경)** | **6** | DynamicQuery.tsx / forecast-price `__asis-mapping__.md` · groupMeasure.test.ts / sales-reports.api.ts / ColumnLayoutModal.tsx / useDirtyRegistry.ts |
| 로컬 고유 | 121 | 보존 (cust-fcst-waterfall · mkt-fcst-comparison · demand-plan-waterfall 등) |
| 공통 삭제 반영 | 4 | ContributeMainGrid.dirty.test.tsx / customer-model-mapping.{constants,gridCombos}.test.ts / overRange.test.ts (원본 `files/`) |

## 공통 HEAD 결함 — 채택 거부/정합 (컴파일 깨는 공통 파일은 채택하지 않는다)
- 공통 신규 stale 테스트 3본 삭제: `lookup.utils.test.ts`(toDetailSaveRow 부재) · `sales-reports.editLock.test.ts`(currentYyyymm 등 부재) · `sales-reports.save.test.ts`(buildEtcInsertRows 부재)
- `apps/web/src/pages/TestPage.tsx`: 공통 `Templates.tsx`(08-25) 가 `embedded` prop 제거 → 공통 HEAD 자체 TS2322. 로컬 TestPage 를 `<Templates />` 로 정합(1줄).

## 검증
`fe-check.ps1 type-check` → **13/13 successful** (error 0). locales `public/locales/KO.json` 1,006키(gen:i18n 덮어쓰기 없음).

## 원복
`apps/ features/ packages/ public/` = 다운로드 직전 4폴더 전체 사본 · `nscm_fe_worktree.patch` = 직전 작업트리 diff · `files/` = 덮어쓴 원본 · `00_manifest_dry.json` / `02_final_state.json` 분류표