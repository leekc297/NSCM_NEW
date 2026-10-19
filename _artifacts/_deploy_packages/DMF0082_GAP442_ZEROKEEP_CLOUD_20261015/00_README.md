# DMF0082_GAP442_ZEROKEEP_CLOUD_20261015 — 수량 0 저장 시 원장 행 유지 (클라우드 패치)

- 마커: `[GAP442 2026-10-15]` 4곳 · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_SAVE_MAIN_DATA` (40 경로)
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15 13:18:04) · 리허설 재적용(13:30, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0082_GAP442_20261015/APPLIED_OPERATIONS.md`
- GAP 439 / 440 / 441 패키지와 **서로 독립** — 바꾸는 줄이 달라 어느 순서로 실행해도 된다.

## 무엇이 바뀌나
DMF0082(40) 수량을 0 으로 고쳐 저장하면 **원장 행 자체가 지워져 누가 언제 0 으로 바꿨는지 남지 않던 문제**를 고친다.
- AS-IS(`DMF0082_SAVE_MAIN_DATA` L1917~1945) 는 MERGE 하나로 처리한다: 금액 2종(`MKT_AMT_KRW/LOC`) 0 → 삭제 / 그 밖의 기존 행 → 0 포함 수정(최종 변경자·일시 갱신) / 없는 행 → 0 이 아닐 때만 추가.
- TO-BE 는 0 저장 시 수요 3종(`MKT_FCST` · `VMI_In_Req` · `SCM_FCST`)까지 5종을 삭제하고, MERGE 는 0 을 걸러 수정도 하지 않았다.
- 바꾸는 4곳

| # | 위치 | 구 | 신 |
|---|---|---|---|
| D1 | Phase 1 DELETE 대상 | 5종 | 금액 2종 |
| D2 | Phase 1 DELETE 내부 | 5종 | 금액 2종 |
| M1 | MERGE 소스 | `QTY_PRICE <> 0` | `QTY_PRICE <> 0` 또는 수요 3종(0 포함) |
| M2 | MERGE INSERT | 조건 없음 | `WHERE B.QTY_PRICE <> 0` (0 은 신규 행 만들지 않음) |

- 81 경로 · 조회 · 메타 · FE · 권한 · GTT 정의 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, 2026-10-15 13:25, 저장 SP 실호출, minyonglee1)
- 키: 40 / EATON_01 / EATON_HK_YUE / MCCH335080B1T000 / E / MPS / DDP / '-' / HQ06-A · 2027-12-27 (판가 2.6 · 저장 대상 measure 행 없음 확인)

| 단계 | DM_PLN_CFM_MKT_DEMAND_PLAN |
|---|---|
| 시작 | 없음 |
| 100 저장 (`I`) | MKT_FCST 100 · MKT_AMT_KRW 361,400 · MKT_AMT_LOC 260 |
| 0 저장 (`M`) | **MKT_FCST 0 (행 유지, LAST_UPDATED_BY=minyonglee1 · 13:25:35)** · 금액 2종 삭제 — AS-IS 와 같음 |

- 테스트 행은 검증 후 삭제(CFM 1 · DM_PLN_MKT_FCST 1). 저장 후속 BALANCE 재계산으로 같은 품목 BALANCE 171행이 다시 계산됨(파생값).
- 리허설: 90 → 99(원복) → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문** · **10 재적용 결과 == 사내 적용본** (원문 전체 일치).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 4줄 PASS · L2 마커 0 · L3 참고값 · L4 0행 | L1 FAIL이면 **10 실행 금지**, 결과 회신. L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP442_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 4곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 마커 4줄 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 4줄 PASS | 회신 |
| 4 | 화면: 40 에서 기존 수량 칸을 0 으로 고쳐 저장 | `SELECT QTY, LAST_UPDATED_BY, LAST_UPDATE_DATE FROM DM_PLN_CFM_MKT_DEMAND_PLAN WHERE <저장 키·일자·MEASURE>` → 1행 · QTY 0 · 저장자/시각 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP442_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 SAVE_MAIN_DATA 구간의 ASCII 구 줄 4개만 바꾼다(각 구간 안 1건이 아니면 하나도 바꾸지 않고 중단).
- 99 원복은 각 신 블록을 ASCII 시작 토큰과 ASCII 마지막 줄 시작 토큰으로 찾아 구 줄로 되돌린다 — 한글 주석 비교에 의존하지 않는다.
- 가드: 마커 존재 → SKIP / 구 줄 4개 중 하나라도 1건이 아님 → 중단 / 조립 길이·마커 수 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 — 화면은 이미 0 을 `M` 으로 전송 |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 재조회 FRESH-GATE 포함, 신 블록 문구는 사내 적용본에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본 md5.
