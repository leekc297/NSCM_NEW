# DMF0082_MFPERF_CUTOFFPRUNE_CLOUD_20261015 — 과거 버전(MF/SF/SP) 조회 속도 개선 (클라우드 패치, DB 만)

- 마커: `[MFPERF 2026-10-15]` 3곳 · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(15:53, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0082_MFPERF_20261015/APPLIED_OPERATIONS.md`
- **FE 무변경.** GAP 439~446 패키지와 서로 독립.

## 무엇이 바뀌나
DMF0082 에서 과거 버전(MF·SF·SP)을 조회하면 8~10분 걸리던 문제를 고친다.
- 원인(사내 ASH 실측): 조회 시간의 99% 가 '컷오프 최종수정자 적재' 3문장이다. 원장이 컷오프 일자(`CUTOFF_YYYYMMDD_DATE`)로 파티션돼 있는데 문장에 그 조건이 없어,
  버전·사이트품목 조합마다 **모든 파티션**을 훑었다(`PARTITION RANGE ALL`).
- 조치: 세 문장(81 수요 `DM_PLN_MKT_FCST_C` · 40 수요 `DM_PLN_CFM_MKT_DEMAND_PLAN_C` · 40 판가 `DM_PLN_CFM_SELLING_PRICE_C`)에
  선택 버전의 컷오프 범위 조건을 넣어 해당 파티션만 읽게 한다. 버전당 컷오프가 1개이고 그 날짜가 버전일이라 **결과 행은 바뀌지 않는다**.
- 저장 · 원장 · 메타 · FE · 권한 · GTT · 인덱스 무변경. **BE 재기동 불필요.**

## 사내 결과 (ZIOUI1, 조회 SP 실호출)
| 조회 | 전 | 후 | 결과 |
|---|---|---|---|
| 40 MF_W_20260824 (08-03~12-31) | 575.6초 | **3.5초** | 2,090행 동일 |
| 40 SF_W_20260824 | 486.6초 | **3.5초** | 동일 |
| 40 SP_W_20260825 | 129.3초 | **2.6초** | 1,228행 동일 |
| 81 MF_W_20260930 (10-01~12-31) | 532.6초 | **3.8초** | 627행 동일 |
- 리허설: 90 → 99(원복) → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · **99 원복 == 수정 전 원문 · 10 재적용 == 사내 적용본**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 4줄 PASS · L2 마커 0 · L3 3줄 PASS · **L4 3줄 PASS(이 DB 데이터에서도 조건이 행을 거르지 않음)** · L5 0행 | L1·L3·L4 FAIL이면 **10 실행 금지**, 결과 회신. L4 는 대형 원장 집계라 1~2분 걸릴 수 있음 |
| 2 | `A_DB/10_APPLY_MFPERF_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 3곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 마커 3줄 · V2 VALID/오류 0/의존 INVALID 0 · V3 3줄 PASS | 회신 |
| 4 | 화면: 40·81 과거 MF/SF/SP 버전 조회 | 수 초 안에 조회 · 행 수 적용 전과 동일 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_MFPERF_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 에서 각 원장의 GET_MAIN_DATA 첫 `FROM` 줄을 찾고,
  그것이 컷오프 최종수정자 적재 문장(`INSERT INTO GT_DMF0082_T_LAST_DATA_SETUP_*`) 안인지 확인한 뒤 `A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd` 줄 다음에 2줄을 넣는다.
- 99 원복은 ASCII 접두 줄부터 다음 줄 끝까지 3곳을 지운다(한글 비교 없음).

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 인덱스·파티션·통계 | 무변경 (00 L3 에서 파티션 키 확인) |
| 메타 · GRANT/SYNONYM · FE · BE | 해당 없음 |

## 파일
- `build_package.py` — 생성기(FRESH-GATE · 시뮬레이터 포함). 조건 문구는 사내 적용본에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본·수정 전 md5.
