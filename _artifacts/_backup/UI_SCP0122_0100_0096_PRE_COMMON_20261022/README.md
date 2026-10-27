# SCP0122 · SCP0100 · SCP0096 — 신규 개발본 백업 후 공통소스 판 반영 (2026-10-22)

세 화면은 공통소스(eunjoo-hwang/nscm-fe)에 이미 반영된 UI 라, 로컬에서 새로 개발한 판을 백업하고 페이지 폴더를 공통소스 판으로 맞췄다(사용자 지시).
공통소스 기준 = `common/main` `061ecd0b2` (2026-10-22 12:11).

## 바뀐 것 (nscm-fe 페이지 폴더 3개만)
| 화면 | 페이지 폴더 | 공통 판 파일 | 그대로(이미 같음) | 공통 판으로 교체·추가 | 로컬 전용 삭제 |
|---|---|---:|---:|---:|---|
| SCP0122 | `features/supply/src/pages/plan-activity-mgmt` | 9 | 3 | 6 | `__tests__/PlanActivityMgmt.asis.spec.ts` · `utils/plan-activity-mgmt.util.test.ts` |
| SCP0100 | `features/supply/src/pages/global-psi-report` | 11 | 1 | 10 | `__tests__/GlobalPsiReport.spec.ts` · `utils/globalPsiReportCalendar.ts` |
| SCP0096 | `features/supply/src/pages/shipment-working-day-osp` | 11 | 1 | 10 | `__tests__/ShipmentWorkingDayOsp.spec.ts` · `hooks/useShipmentWorkingDayOspInputValue.ts` |

- SCP0096 은 공통 판에만 있는 `components/ShipmentWorkingDayOspInputModal.tsx`·`.module.scss` 가 추가됐다.
- `configs/types/procedures.d.ts`: SCP0122 블록은 공통과 동일, SCP0100·SCP0096 은 양쪽 모두 블록 없음 → 변경 없음.
- 파일 내용은 공통 판 그대로, 개행만 로컬 방식(CRLF).

## 검증
- 세 폴더의 파일 목록·내용(개행 정규화) = 공통 판 — 불일치 0
- 삭제한 로컬 전용 파일을 가리키는 import 잔존 0 (features·apps·packages)
- 정적검증(type-check) 미수행 — 사용자 지시(요청 시만). 공통 판 화면이 쓰는 공용 파일(shared/foundation 등)이 로컬에서 아직 공통 최신이 아닐 수 있어, ⬇️🔀 Source Download & Merge 적용 뒤 type-check 를 권장.

## 백업 · 원복
- `page/features/supply/src/pages/…` — 교체 직전 로컬 페이지 폴더 3개 전체(신규 개발본)
- `git_diff_before.patch` · `git_status_before.txt` — 교체 직전 nscm-fe 의 이 세 폴더 변경 상태
- 원복: `page/` 아래 폴더를 nscm-fe 의 같은 경로로 되돌려 복사(공통 판에만 있던 파일은 지운다)
- `apply_common_pages.py` — 이번 작업 스크립트 · `apply_log.json` — 파일별 결과

## 손대지 않은 것
- 사내 오라클 DB 객체(PKG·META) — 세 화면의 사내 PKG 는 현행 그대로(생성 파일 `Doc/gen/<ID>/<ID>_PKG.sql` 은 사내와 다르므로 META 커밋·PKG 변환 시 중단 판정 유지)
- `Doc/gen/<ID>` 의 개발 기록·E2E 스펙 — 새 개발본 기준이라, 이 화면들의 E2E 를 다시 돌리면 공통 판과 기대값이 다를 수 있다
