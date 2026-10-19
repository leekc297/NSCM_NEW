# DMF0082_GAP441_20261015 — 사내 ZIOUI1 적용 기록

- 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` O_RC5(월 → 주 배분 캘린더) `WEEK_DAY_CNT` 1식 (마커 `[GAP441 2026-10-15]`)
- 변경: `COUNT(*) OVER (PARTITION BY A.ISO_WEEK)` → `COUNT(*) OVER (PARTITION BY A.ISO_YYYYWW || A.PARTIAL_WEEK_NAME)` (AS-IS · 같은 PKG `_CURRENT` 동일식)
- DB: 59.19.252.148:2521/ZIOUI1 · 계정 SCM_MGR · 착수 기준본 LAST_DDL 2026-10-15 11:53:17 · FRESH-GATE 통과 후 적용 · VALID / 오류 0

## 검증 (minyonglee1, Div 81, Current)
| 항목 | 수정 전 | 수정 후 |
|---|---|---|
| RC5 WEEK_DAY_CNT ≠ AS-IS 식 (2026-09-01~2027-03-31, 212일) | 28일 | — |
| RC5 WEEK_DAY_CNT ≠ AS-IS 식 (2026-09-01~2027-04-30, 242일) | — | 0일 |
| 20260928 / 20261001 | 7 / 7 | 3 / 4 |
| 2027-03 3,100 입력 주별 배분 합계 (조회 ~2027-04-30, FLOOR(3100/31×일수)) | 3,500 (3/29 주 7일) | 3,100 (3/29 주 3일) |

## 이후 작업
| 시각 | 작업 | 결과 |
|---|---|---|
| 2026-10-15 12:47:11 | BODY LAST_DDL 갱신 확인 (본인 작업 아님) — 원문 전문 대조 결과 GAP441 적용본과 **동일**(diff 0, GAP439/440/441 마커 각 1) | 내용 변경 없는 재컴파일로 판단 |
| 2026-10-15 13:05~13:06 | 이관 패키지 리허설 (90 → 99 → 00 → 91 → 10 → 10 → 90 → 91 → 99 → 99 → 10) + 99 원복 == 수정 전 원문 / 10 재적용 == 적용본 전문 일치 | 최종 적용본 · VALID |

이관 패키지: `_artifacts/_deploy_packages/DMF0082_GAP441_WEEKDAYCNT_CLOUD_20261015/`
