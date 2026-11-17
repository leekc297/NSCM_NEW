---
paths:
  - "Doc/_analysis/**"
  - "_analysis/**"
  - "Doc/화면분석서/**"
  - "Doc/화면설계서/**"
  - "Doc/단위테스트/**"
---
# 분석 산출물 규약 (분석서·설계서·테스트케이스를 만질 때 자동 로드) — 구 CLAUDE.md §11 / §12 / §13 승계

## A. 진입
- T02 (UI분석서·화면분석서·화면설계서 생성) → `hooks/screen-analysis-workbook-standard.md`(#105: UI분석서 10시트 / 설계서 8시트 / 단위테스트는 **별도 TestCases 산출물**) + `hooks/popup-asis-analysis.md`. 단위테스트는 `/단위테스트 <화면ID>` 커맨드.
- 모든 분석 작업은 anti-simplification 최우선: 원천 일부만 읽고 도출 ⛔, "대표 케이스만" 샘플링 ⛔, 추출 한계는 명시.

## B. ⭐ v7.4 룰 — 화면 분석서 정밀 작업 의무 (룰 19 §16 "메타 자동 생성도 일괄 자동화")
| # | 의무 | 위반 시 |
|---:|---|---|
| 1 | 화면별 `.cs` 전체 Read (처음~끝) | xlsx 빈칸 다수 = 즉시 재작업 |
| 2 | 화면별 `.Designer.cs` 전체 Read | 동일 |
| 3 | xlsx 13시트 모두 filled cells 30+ | 즉시 재작업 |
| 4 | Validation: 모든 `MessageHelper.GMessageBox` 추출 (Msg ID + 카테고리) | 누락 위반 |
| 5 | Expression: 모든 `LockColumn/LockRange` + `SetValue` Auto-Sync 추출 | 누락 위반 |
| 6 | 호출 POPUP: 모든 `new XxxPopup()` 추출 + 공통 영역 Link 또는 신규 분석서 | 누락 위반 |
| 7 | SP/Tables: 모든 호출 SP + 의존 테이블 인벤토리 (`_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx` 기준) | 누락 위반 |

## C. Cowork 분석 산출물 폴더 매핑 (상세 `_analysis/_FOLDER_MAP.md`)
| 폴더 | 내용 |
|---|---|
| `_analysis/_phase1/` | 개요·인벤토리·아키텍처 (`00_INDEX.md`, `01_Overview.md`) |
| `_analysis/_phase2/` | DB/화면/Endpoint 정밀 인벤토리 (`02_DB_Inventory.xlsx`, `02_Oracle_Compat.xlsx`) |
| `_analysis/_phase3/` | 도메인별 상세 분석 `{04~09}_*_Analysis.*` |
| `_analysis/_phase4/` | To-Be 상세 스펙 `{11~13}_*.xlsx` (Screen/Field/Event/IA/BPF/Arch) |
| `_analysis/_screens/` | 화면 13시트 분석서 `{27_DM|28_Common|29_SCM|30_SCP|31_SSP|32_FP}_Screens/{prefix}{화면ID}.xlsx` (302 화면) |
| `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx` | ⭐ 통합 매트릭스 3,318행 / 395 화면 / 710 SP / 355 Tables (Anti-Simplification 11개 원천) |
| `Doc/_analysis/INDEX.md` | 도메인 분석 자료 진입점 · `domain_*/screens/{ID}/` 8 MD |

## D. 통합 통계 (2026-05-22 기준 — 수치는 재집계 시 갱신)
DM 84 xlsx / 83 analysis.md / 8MD 완비 49 · SCP 66/70/66 · SSP 56/58/56 · FP 95/112/95 · Common 32/57 · SCM 16/16 — 합계 349 xlsx / 396 analysis.md.

## E. 산출물 기록 정책
- CLAUDE.md 에 변경 이력 직접 추가 금지 (hook #77). 월별 1-line = `Doc/_archive/CLAUDE_changelog_YYYY-MM.md`, 상세 = `Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md`.
