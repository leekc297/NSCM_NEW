# DMF0005 조회 속도 보완 2차 — 클라우드 패치 [E20261014-DMF0005SCONM]

## 무엇을 고치나
1차 패치(NOPUSH) 뒤 QA 조회 시간은 82 39.8초 · 81 36.8초 · 40 16.3초였다. 남은 시간은 두 구간이 결과 행마다 반복되는 데서 나왔다.
- Sold-To(대표 고객) 조회 — 82 23.8초
- Owner 이름 — 82 22.4초 · 81 32.4초

조회 프로시저의 BASE 에서 2줄을 바꾼다.
1. Sold-To 조인 ON 절의 `AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')` 를 주석 처리한다.
   바로 위 `SC.VALID_YN = 'Y'` 때문에 항상 참인 조건이라 결과는 같다. 이 조건이 조인을 행별 실행 형태로 바꾸고 있었다.
2. BASE 의 SELECT 에 힌트 `/*+ NO_PUSH_PRED(ONM) */` 를 넣는다(사용자 승인). Owner 이름은 Owner 종류마다 한 번만 구한다.

## 방식
**패치형** — 클라우드 현재 BODY 원문(USER_SOURCE)을 읽어 앵커 2곳만 바꾼다. 사내 전체본으로 덮어쓰지 않는다.
선행 패치 NOPUSH 가 없거나 앵커가 각 1곳이 아니면 아무것도 바꾸지 않고 멈춘다. 컴파일 오류가 나면 원문으로 자동 복원한다.

## 실행 순서 (계정 SCM_MGR · 각 파일 전체 F5 · 값 입력 없음)

| 순서 | 파일 | 확인할 것 |
|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | [L1] 선행 NOPUSH `PASS` · [L2] 앵커 ① ② 모두 `PASS` · [L3] 마커 0 · [L4] 실행 중 세션 (있으면 끝나거나 멈춘 뒤 진행) |
| 2 | `A_DB/10_APPLY_SCONM_PATCH.sql` | `APPLIED — PKG_DMF0005 BODY VALID · 마커 2곳` |
| 3 | 화면에서 DMF0005 다시 조회 | 이미 돌고 있던 조회는 옛 계획으로 계속 돈다 |
| 4 | `A_DB/90_VERIFY.sql` | [V1] VALID · 마커 2 · [V1b] NOPUSH 1 · [V3] 82 · 81 · 40 시간 · [V4] PATCHED_TXT = Y 줄의 VW_DCL 0 |
| 5 | `_artifacts/_diagnostics/DMF0005_CLOUD_PERF_CHECK_20261014/C06_PROFILE_AFTER_PATCH.sql` | 계획 줄별 실측 — 결과 파일을 `C:\TRANFILE\RECEIVE\` 로 |
| 원복 | `A_DB/99_ROLLBACK_SCONM_PATCH.sql` | `ROLLED BACK` (NOPUSH 는 그대로 남는다) |

## 사내 기준 (ZIOUI1, 2026-10-14)
- 사내 적용 12:11:30 · 리허설 00 → 99 → 00 → 10 → 10(재실행 SKIP) → 90 전부 오류 0 (`_rehearsal_out/`)
- 결과 동등성: 시나리오 96 × 674,518행 행 · 값 · 순서 동일
- 90_VERIFY [V3] 사내: 82 0.64s · 81 0.77s · 40 0.61s / QA 조건 모사: 82 2.08s · 81 1.82s · 40 0.91s
- ⚠ 사내는 이 두 구간을 처음부터 해시 조인으로 처리해 QA 의 행별 반복이 재현되지 않는다 — QA 에서 얼마나 줄었는지는 5번 C06 으로 확인
