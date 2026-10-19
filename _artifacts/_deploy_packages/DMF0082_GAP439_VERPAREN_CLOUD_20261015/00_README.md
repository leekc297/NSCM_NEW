# DMF0082_GAP439_VERPAREN_CLOUD_20261015 — Current 외 버전 조회 0건 보완 (클라우드 패치)

- 마커: `[GAP439 2026-10-15]` · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_GET_MAIN_DATA`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15 11:10:16) · 리허설 재적용(11:32:55, 내용 동일 md5 `3611060d…`) — `_artifacts/_apply_corporate/DMF0082_GAP439_20261015/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
DMF0082 조회조건 Version 에 Current 가 아닌 버전을 고르면 0건이던 문제를 고친다.
- 버전 팝업(`DMF0073_GET_VERSION_SALESPRICE`)은 `SP_W_20260923_V001(W39)` · `…(W39) (NO PLAN)` 처럼 **버전번호 뒤에 `(주차)` 를 붙여** 돌려주고, FE 는 이 값을 그대로 조회 SP 로 넘긴다.
- 조회 SP 는 이 값을 `DM_MST_VERSION.VERSION_NO` 와 정확히 비교해 0건이 됐다.
- 버전 토큰 적재 1문장에서 **Current 가 아닌 값은 첫 `(` 부터 뒤를 잘라** 순수 버전번호로 넣는다. Current 는 그대로.
- 원장 · 저장 SP · 메타 · FE · 권한 · GTT 정의 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, minyonglee1, Div 81, 2026-10-01~12-31)
| 조회 버전값 | 수정 전 | 수정 후 |
|---|---|---|
| `MF_W_20260930_V001(W40)` | 0건 | **498건** (수정 전 괄호 없는 값 498건과 동일) |
| `MF_W_…(W40),SP_W_…(W39) (NO PLAN)` (2개) | — | 498건 |
| `Current` | 7,148건 | 7,148건 (불변) |

- 리허설: 90 → 99(원복) → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문 (md5 `02263212…` 일치)** · **10 재적용 결과 == 사내 적용본 (md5 `3611060d…` 일치)**.
- 참고: 81 MF 버전 조회는 수정 전에도 1회 약 470~490초 걸렸다(이번 수정과 무관한 기존 성능 이슈 — 별도 보완 대상).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 PASS(1줄) · L2 마커 0 · L3 PASS · L4 0행 | L1·L3 FAIL이면 **10 실행 금지**, 결과 회신. L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP439_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 1곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 PASS · V4 4줄 PASS · V5 UNMATCHED 0 PASS | 회신 |
| 4 | 화면에서 Version 팝업으로 Current 외 버전 선택 → 조회 | 데이터 조회됨 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP439_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 해당 1문장만 바꾼다.
- 치환 대상은 ASCII 한 줄: `    SELECT 'p_version_type', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));` (GET_MAIN_DATA 구간 안 1건).
- 99 원복은 ASCII 마커 줄(`    /* [GAP439 2026-10-15]`)부터 ASCII 끝 줄(`    FROM TABLE(UF_FX_String_SplitForIN(p_version_type, ','));`)까지를 구 문장으로 되돌린다 — 한글 주석 비교에 의존하지 않아 실행 도구가 달라도 된다.
- 가드: 마커 존재 → SKIP / 구 문장이 구간 안 1건이 아님 → 중단 / 조립 길이 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 — 인자 그대로 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 — 기존 `GT_DMF0082_PARAM_TOKEN` 그대로 |
| 함수 | 기존 `UF_FX_String_SplitForIN` 그대로 (90 V4 가 이 DB 에서 실행 확인) |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 재조회 FRESH-GATE 포함, 블록 문구는 사내 적용본에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본 md5.
