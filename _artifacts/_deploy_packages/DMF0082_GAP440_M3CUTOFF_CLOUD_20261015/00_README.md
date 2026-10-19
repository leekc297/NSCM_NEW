# DMF0082_GAP440_M3CUTOFF_CLOUD_20261015 — 월 칸 잠금 경계 = 오늘 월 기준 (클라우드 패치)

- 마커: `[GAP440 2026-10-15]` · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` O_RC2
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15 11:42:34) · 리허설 재적용(11:52, 내용 동일 md5 `8e22cf1b…`) — `_artifacts/_apply_corporate/DMF0082_GAP440_20261015/APPLIED_OPERATIONS.md`
- GAP 439 패키지(`DMF0082_GAP439_VERPAREN_CLOUD_20261015`)와 **서로 독립** — 바꾸는 줄이 달라 어느 순서로 실행해도 된다.

## 무엇이 바뀌나
DMF0082 MKT FCST 월 칸 잠금 경계가 **조회 시작월을 따라 움직이던 문제**를 고친다.
- 경계는 조회 SP 의 O_RC2 `M3_CUTOFF_DATE` 첫 행(앞 6자리)이다. 지금은 조회 월마다 `그 달 1일 + 3개월` 이라, 시작월을 과거로 잡으면 공급 확정월이 편집되고 늦게 잡으면 입력할 달이 잠긴다.
- **오늘 월 + 3개월**로 고정한다(AS-IS 와 같게 조회 시작월 무관). 그 달까지 잠기고 다음 달부터 편집. 저장 행 선별도 같은 경계를 쓴다.
- 원장 · 저장 SP · 메타 · FE · 권한 · GTT 정의 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, 2026-10-15, Div 81, Current — O_RC2 첫 행 = FE 잠금 경계월)
| 조회 시작 | 수정 전 | 수정 후 |
|---|---|---|
| 2026-07-01 | 202610 | **202701** |
| 2026-09-01 | 202612 | **202701** |
| 2026-10-01 | 202701 | **202701** |
| 2026-11-01 | 202702 | **202701** |

- 리허설: 90 → 99(원복) → 00 → 91(수정 전 FAIL 2건 재현) → 10 → 10(SKIP) → 90 → 91(3건 PASS) → 99 → 99(SKIP) → 10 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문 (md5 `3611060d…`)** · **10 재적용 결과 == 사내 적용본 (md5 `8e22cf1b…`)**.
- 참고: GAP 문서의 "2027-01 부터 편집" 은 작성일(2026-09-18) 기준이다. 10월에는 2027-01 까지 잠기고 2027-02 부터 편집이 정상.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 PASS(1줄) · L2 마커 0 · L3 참고값(오늘 월+3) · L4 0행 | L1 FAIL이면 **10 실행 금지**, 결과 회신. L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP440_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 1곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 PASS · V4 참고(잠금 끝월·편집 시작월) | 회신 |
| 4 | (선택) `A_DB/91_VERIFY_FUNC.sql` | `F1 … PASS` 3줄 (조회 시작 -3/0/+1개월 모두 경계 = 오늘 월+3) | 회신. 조회 SP 를 3회 실행하므로 데이터량에 따라 시간이 걸릴 수 있음 |
| 5 | 화면: 조회 시작월을 과거/미래로 바꿔 조회 | MKT FCST 월 칸이 V4 의 잠금 끝월까지 잠기고 다음 달부터 편집 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP440_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 해당 1줄만 바꾼다.
- 치환 대상은 ASCII 한 줄: `             , TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(MIN(A.BASIS_YYYYMMDD), 'YYYYMMDD'), 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE` (GET_MAIN_DATA 구간 안 1건 — 같은 이름의 GTT 적재 식 2곳은 형태가 달라 대상 아님).
- 99 원복은 ASCII 마커 줄(`/* [GAP440 2026-10-15]`)부터 ASCII 끝 줄(`… TRUNC(SYSDATE, 'MM') … AS M3_CUTOFF_DATE`)까지를 구 줄로 되돌린다 — 한글 주석 비교에 의존하지 않는다.
- 가드: 마커 존재 → SKIP / 구 줄이 구간 안 1건이 아님 → 중단 / 조립 길이 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 — FE 는 O_RC2 첫 행을 그대로 읽음 |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 재조회 FRESH-GATE 포함, 블록 문구는 사내 적용본에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본 md5.
