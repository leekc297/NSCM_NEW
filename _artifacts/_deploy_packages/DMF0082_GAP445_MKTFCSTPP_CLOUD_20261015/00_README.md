# DMF0082_GAP445_MKTFCSTPP_CLOUD_20261015 — MKT FCST[P+P] 계획구간 표시 (클라우드 패치, DB 만)

- 마커: `[GAP445 2026-10-15]` 2곳 · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` (블록 2개 삽입)
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(14:21, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0082_GAP445_20261015/APPLIED_OPERATIONS.md`
- **FE 무변경.** GAP 439 / 440 / 441 / 442 / 443 패키지와 서로 독립 — 어느 순서로 실행해도 된다.

## 무엇이 바뀌나
DMF0082 에서 Measure 로 **MKT FCST[P+P](MKT_FCST_PP)** 를 고르면 계획 수량이 거의 표시되지 않던 문제를 고친다.
- AS-IS `DMF0082_GET_MAIN_DATA` 는 Current · MF · SF 모두 계획구간 `MKT_FCST` 를 `MKT_FCST_PP` 로 복사해 보여 준다 (AS-IS DB 원문 확인 — Current L1798~1895 · MF L3008~3108 실행 문장).
- TO-BE 는 SF 분기에만 이 복사가 있었다 → Current · MF '계획구간 수요' 블록 바로 뒤에 SF 와 같은 형태의 복사 블록을 넣는다 (81·82 / 40 테이블 분기 포함).
- 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, 40 · Current · 2026-09-01~2027-02-28, 조회만 실행)
| 항목 | 수정 전 | 수정 후 |
|---|---|---|
| MKT_FCST_PP 행 (MKT_FCST_PP 를 화면 설정에 둔 사용자) | 29 | **309** |
| MKT_FCST 행 | 304 | 304 (불변) |
| 계획구간(2026-10-12~, 일자 310칸) MKT_FCST_PP ↔ MKT_FCST | — | **키 302건 · 전 칸 값 일치** |
| 다른 메저 행 수 | — | 불변 |

- 총 행 수 차이(309 ↔ 304)는 실적 구간 행에서만 난다(PP 에만 5 · MKT_FCST 에만 1) — 실적 arm 의 기존 메저 매핑 차이로 이번 변경과 무관(별도 확인 대상).
- 리허설: 90 → 99(원복) → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · **99 원복 == 수정 전 원문 · 10 재적용 == 사내 적용본** (원문 전체 일치).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 4줄 PASS · L2 마커 0 · L3 9줄 PASS · L4 0행 | L1·L3 FAIL이면 **10 실행 금지**, 결과 회신(L3 "SF 분기 복사" FAIL = 클라우드 BODY 가 구세대). L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP445_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 2곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 마커 2줄 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 PASS · V4 6 PASS | 회신 |
| 4 | 화면: Measure 에 MKT FCST[P+P] 를 둔 사용자로 Current 조회 | 계획구간 값이 MKT FCST 와 같다 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP445_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 ASCII 표지로 위치를 찾는다:
  Current 분기 시작 줄(`IF p_version_type LIKE '%Current%' OR … THEN`) / MF 분기 시작 줄(`IF p_version_type LIKE '%MF%' THEN`) → 각 분기 뒤 첫 `END IF;  --[DIV81]` 직후.
  그 사이에 계획구간 원장(`DM_PLN_CFM_MKT_DEMAND_PLAN` / `_C`) 적재가 없으면 중단한다.
- 99 원복은 각 블록을 '빈 줄 + ASCII 마커 줄(`/* [GAP445 2026-10-15] MKT_FCST [P+P] Current|MF`)'부터 블록 끝 `END IF;  --[DIV81]` 까지 지운다 — 한글 주석 비교에 의존하지 않는다.
- 가드: 마커 존재 → SKIP / 분기·삽입 위치 이상 → 중단 / 조립 길이·마커 수 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 원장·GTT | 기존 객체만 사용 (00 L3 실존 확인) |
| 메타(MNU/API/BTN/SHEET_COLUMNS/SHEET_MEASURE/MSG/LBL) | 해당 없음 — MKT_FCST_PP 메저 메타는 기존 |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 (FE 무변경) |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 재조회 FRESH-GATE 포함, 블록 문구는 사내 적용본에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본 md5.
