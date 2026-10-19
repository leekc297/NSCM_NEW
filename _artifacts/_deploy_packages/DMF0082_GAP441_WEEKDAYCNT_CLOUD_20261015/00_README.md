# DMF0082_GAP441_WEEKDAYCNT_CLOUD_20261015 — 월 칸 수량 주 배분 합계 초과 보완 (클라우드 패치)

- 마커: `[GAP441 2026-10-15]` · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` O_RC5
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15) · 리허설 재적용(13:06, 사내 적용본과 내용 동일) — `_artifacts/_apply_corporate/DMF0082_GAP441_20261015/APPLIED_OPERATIONS.md`
- GAP 439 / GAP 440 패키지와 **서로 독립** — 바꾸는 줄이 달라 어느 순서로 실행해도 된다.

## 무엇이 바뀌나
DMF0082 MKT FCST **월 칸에 넣은 수량보다 많이 저장되던 문제**(3,100 입력 → 3,500 저장)를 고친다.
- FE 는 월 수량을 주로 나눌 때 `절사(월 수량 ÷ 월 일수) × 그 주의 일수` 를 쓰고 남는 수량을 마지막 주에 더한다. 주 일수는 조회 SP 의 O_RC5 `WEEK_DAY_CNT` 다.
- 지금은 이 값을 **ISO 주 단위**로 세어 월 경계에 걸친 주를 7일로 계산한다 → 합계가 입력값을 넘는다.
- **ISO 주 + 월 경계 부분 주** 단위(`ISO_YYYYWW || PARTIAL_WEEK_NAME`)로 센다. AS-IS 와 같고 같은 패키지 `P_DMF0082_GET_MAIN_DATA_CURRENT` 에 이미 있는 식이다.
- 원장 · 저장 SP · 메타 · FE · 권한 · GTT 정의 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, 2026-10-15, Div 81, Current)
| 항목 | 수정 전 | 수정 후 |
|---|---|---|
| RC5 주 일수가 AS-IS 식과 다른 날 (2026-10-01~2027-04-30, 212일) | 28일 | **0일** |
| 20260928 / 20261001 주 일수 | 7 / 7 | **3 / 4** |
| 2027-03 에 3,100 입력 시 주별 배분 합계 (조회 ~2027-04-30) | 3,500 | **3,100** |

- 리허설: 90 → 99(원복) → 00 → 91(수정 전 MISMATCH 28 재현) → 10 → 10(SKIP) → 90 → 91(MISMATCH 0 PASS) → 99 → 99(SKIP) → 10 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문** · **10 재적용 결과 == 사내 적용본** (전문 일치 확인).
- 배분 합계는 SP 가 돌려준 주 일수에 화면 배분식을 적용해 계산한 값이다(화면 저장으로 직접 확인한 값 아님).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 PASS(1줄) · L2 마커 0 · L3 컬럼 2개 PASS · L4 0행 | L1·L3 FAIL이면 **10 실행 금지**, 결과 회신. L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP441_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 1곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 PASS · V4 참고(바뀌는 날 수) · V4 배분 PASS(구 3,500 / 신 3,100) | 회신 |
| 4 | (선택) `A_DB/91_VERIFY_FUNC.sql` | `F1 … MISMATCH 0 · PASS` | 회신. 조회 SP 를 1회 실행 |
| 5 | 화면: 2027-03 MKT FCST 월 칸에 3,100 입력 → 저장 | 저장 요청 주별 합계 3,100 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP441_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 해당 1줄만 바꾼다.
- 치환 대상은 ASCII 한 줄: `             , COUNT(*) OVER (PARTITION BY A.ISO_WEEK) AS WEEK_DAY_CNT` (GET_MAIN_DATA 구간 안 1건).
- 99 원복은 ASCII 마커 줄(`/* [GAP441 2026-10-15]`)부터 ASCII 끝 줄(`… PARTITION BY A.ISO_YYYYWW || A.PARTIAL_WEEK_NAME) AS WEEK_DAY_CNT`)까지를 구 줄로 되돌린다 — 한글 주석 비교에 의존하지 않는다.
- 가드: 마커 존재 → SKIP / 구 줄이 구간 안 1건이 아님 → 중단 / 조립 길이 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 — `SCM_SYS_CALENDAR_M` 기존 컬럼만 사용(00 L3 실존 확인) |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 — FE 는 O_RC5 WEEK_DAY_CNT 를 그대로 읽음 |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 재조회 FRESH-GATE 포함, 블록 문구는 사내 적용본에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본 md5.
