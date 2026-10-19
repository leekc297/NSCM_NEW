# DMF0082_GAP446_PASTVER_CLOUD_20261015 — 과거 버전(SF/MF/SP) 조회 AS-IS 파리티 (클라우드 패치, DB 만)

- 마커: `[GAP446 2026-10-15]` 9곳 · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA` 의 버전 분기
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(15:14, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0082_GAP446_20261015/APPLIED_OPERATIONS.md`
- **FE 무변경.** GAP 439~445 패키지와 서로 독립 — 어느 순서로 실행해도 된다(GAP 445 와는 MF/SF 분기를 함께 만지지만 서로의 표지를 건드리지 않음).

## 무엇이 바뀌나 (AS-IS `DMF0082_GET_MAIN_DATA` 실행 문장 기준)
| # | 내용 | AS-IS |
|---|---|---|
| C1 | 버전 기준일 `NOW_YYYYMMDD` = 버전일이 속한 주 월요일 (구: 버전일 − 7) | L256 |
| C2 | MF 계획(81·40) 에 '버전 주 월요일 이후' 조건 | L2775 |
| C3 | MF 판가(81·40) 에 같은 조건 | L3415 |
| C4 | SF 계획 = 확정 수요 컷오프(40 `DM_PLN_CFM_MKT_DEMAND_PLAN_C` / 81·82 `DM_PLN_MKT_FCST_C`) + 같은 조건. 구: AS-IS 에서 주석 처리된 실적 테이블(`DM_PLN_MKT_FCST_RESULT_C`)을 읽어 계획구간 MKT FCST·SCM FCST·RTF 가 빠짐 | L4262~4369 |
| C5 | SP 버전 Unit Price 계산 뒤 실적 3종(MKT_AMT_KRW/LOC · RTF_SYS_RP) 삭제. 구: RTF[R+P] 행이 화면에 남음 | L4235~4238 |
- 저장 · 원장 · 메타 · FE · 권한 · GTT 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, 40 · 2026-08-03~2026-12-31, 조회만 실행)
| 버전 | 수정 전 | 수정 후 | GAP 기재 AS-IS |
|---|---|---|---|
| SF_W_20260824_V001 | 1,476 (계획 수요 0) | **2,090** (MKT_FCST 233 · SCM_FCST 233 · RTF_SYS_RP 379 추가) | 2,164 |
| MF_W_20260824_V001 | 2,090 | 2,090 | 2,092 |
| SP_W_20260825_V001 | 1,459 (RTF_SYS_RP 231 포함) | **1,228** (판가만) | **1,228** |
- SF = MF 결과 동일 = 사내 원장의 두 스냅샷이 행 단위 동일. MF 무변화 = 버전일이 월요일이라 구/신 기준일 사이 행 0건.
- C1~C3: MF_W_20260921 에서 NOW = 09-21(신 산식) 확인. 단, 오늘 기준 계획구간 시작(10-12)이 과거 버전 NOW 보다 늦어 현재 날짜로는 단독 효과를 데이터로 분리 입증할 수 없음 — 구조는 AS-IS 와 일치.
- GAP 기재 AS-IS 수치와의 차이는 측정 DB 데이터 차이(직접 비교 불가).
- 패키지: 생성기 시뮬레이터(수정 전→적용 연산 == 적용본 · 적용본→원복 연산 == 수정 전) 통과 · 사내 리허설 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · **99 원복 == 수정 전 원문 · 10 재적용 == 사내 적용본**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 5줄 PASS · L2 마커 0 · L3 6줄 PASS · L4 0행 | L1·L3 FAIL이면 **10 실행 금지**, 결과 회신. L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP446_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 9곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 마커 9줄 · V2 VALID/오류 0/의존 INVALID 0 · V3 4줄 · V4 2줄 전부 PASS | 회신 |
| 4 | 화면: 40 에서 과거 SF·MF·SP 버전 조회 | SF 에 계획구간 MKT FCST·SCM FCST·RTF 표시 · SP 는 판가(KRW·USD·LOC)만 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP446_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 **ASCII 토큰으로만** 위치를 찾고 연산 7개를 순서대로 적용한다(한글 비교 없음):
  C1 NOW 산식 줄 치환 · C2 MF 계획 끝 조건 2곳 · C3 MF 판가 끝 조건 2곳(세미콜론 이동 + 줄 삽입) · C4 SF 분기 시작 줄 ~ `-- MKT_FCST_PP SF` 앞 구간 교체 · C5 SP Unit Price 끝 삽입.
  연산마다 대상 건수가 기대와 다르면 원문을 바꾸지 않고 중단한다.
- 99 원복은 역순 연산이다. C4 는 수정 전 SF 블록 원문(사내 기준본)을 되넣는다.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 원장·GTT·함수 | 기존 객체만 사용(00 L3 확인 — `FN_NEXT_DAY` 포함) |
| 메타 · GRANT/SYNONYM | 해당 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 (FE 무변경) |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기(FRESH-GATE · 시뮬레이터 포함). 블록 문구는 사내 원문에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과(`10_90_VERIFY_rerun` = V4 인용부호 정정 후 재실행).
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본·수정 전 md5.
