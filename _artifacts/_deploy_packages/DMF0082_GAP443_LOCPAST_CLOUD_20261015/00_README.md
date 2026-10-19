# DMF0082_GAP443_LOCPAST_CLOUD_20261015 — 지난 주 판가 덮어쓰기 방지 (클라우드 패치, DB 만)

- 마커: `[GAP443 2026-10-15]` · 대상: `SCM_MGR.PKG_DMF0082` PACKAGE BODY → `P_DMF0082_SAVE_MAIN_DATA` (블록 1개 삽입)
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료 · 리허설 재적용(13:58, 사내 적용본과 원문 전체 일치) — `_artifacts/_apply_corporate/DMF0082_GAP443_20261015/APPLIED_OPERATIONS.md`
- **FE 무변경** (사용자 지시 — DB 객체 우선). GAP 439 / 440 / 441 / 442 패키지와 서로 독립 — 어느 순서로 실행해도 된다.

## 무엇이 바뀌나
DMF0082 Monthly 에서 당월 판가(LOC) 월 칸을 고치면 **이미 지난 주의 판가와 KRW·USD 환산까지 바뀌던 문제**를 고친다.
- 화면은 월 칸 LOC 를 당월 1일과 각 주 대표일에 나눠 보낸다. 지금 저장 SP 는 지난 일자도 그대로 저장한다.
- 저장 SP 가 요청을 읽은 직후, **화면·팝업 저장의 LOC 중 이번 주 월요일 이전 일자를 버린다**. KRW·USD·MKT_AMT 는 LOC 에서 만들어지므로 함께 빠진다.
- AS-IS 는 같은 규칙을 화면에서 적용한다(`DMF0082_FcstNPrice_Mgmt.cs` L7183~7199 — 이번 주 월요일 이전 일자 건너뜀).
- 그대로인 것: 행 삭제(ACTION='D') · Excel Upload(SKIP_PARSE='Y') · 조회 · 메타 · FE · 권한 · GTT. **BE 재기동 불필요.**
- Save Price 팝업은 FE 가 이미 이번 주 월요일 이전 시작을 막는다 → 영향 없음.

## 사내 검증 결과 (ZIOUI1, 2026-10-15 목 — 이번 주 월요일 10-12, 저장 SP 실호출)
- 키: 40 / Electrolux / Kwonnie_CN_DGG / MCCH125020A1 / E / MPS / DAP / '-' / NJ01-A (10월 판가·수요 행 없음 확인)
- 입력: 월 칸 편집이 보내는 형태 그대로 LOC 1.234 × 10/01·10/05·10/12·10/19·10/26

| | 생성된 판가 일자 (LOC·KRW·USD) |
|---|---|
| 수정 전 | 10/01, 10/05, 10/12, 10/19, 10/26 |
| 수정 후 | **10/12, 10/19, 10/26** |
| 지난 일자만 전송 | SUCCESS · 0행 |

- 테스트 행은 매번 삭제(잔여 0).
- 리허설: 90 → 99(원복) → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10 전 단계 기대대로 · **99 원복 == 수정 전 원문 · 10 재적용 == 사내 적용본** (원문 전체 일치).
- AS-IS 와 차이: ① 화면에는 지난 주 칸이 입력값으로 보이다가 저장 후 재조회하면 원값 ② 일요일 저장 시 기준 월요일(AS-IS FE = 다음 날 월요일 / 본 SP = 그 주 월요일).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 PASS(1줄) · L2 마커 0 · L3 5줄 PASS · L4 0행 | L1·L3 FAIL이면 **10 실행 금지**, 결과 회신(L3 v_skip_parse FAIL = 클라우드 BODY 가 구세대). L4에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP443_PATCH.sql` | `APPLIED — PKG_DMF0082 BODY VALID · 마커 1곳` | `중단 — …`이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 PASS · V4 참고(이번 주 월요일) | 회신 |
| 4 | 화면: Monthly 당월 LOC 월 칸 수정 → 저장 → 재조회 | V4 이전 주 판가·KRW·USD 그대로, 이후 주만 변경 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP443_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 ASCII 앵커(`    BEGIN` + `SELECT COUNT(1) INTO V_EDIT_CNT FROM SCM_MGR.GT_PRDM1_T_MAIN;`, SAVE_MAIN_DATA 구간 안 1건) 바로 앞에 블록을 넣는다.
- 99 원복은 ASCII 마커 줄(`    /* [GAP443 2026-10-15]`)부터 앵커 직전까지를 지운다 — 한글 주석 비교에 의존하지 않는다.
- 가드: 마커 존재 → SKIP / 앵커가 구간 안 1건이 아님 → 중단 / `v_skip_parse` 변수 없음(구세대 BODY) → 중단 / 조립 길이 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 함수 | 기존 `FN_NEXT_DAY` 사용 (00 L3 실존 확인) |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 — `GT_PRDM1_T_MAIN` 기존 컬럼만(00 L3 확인) |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) | 해당 없음 (FE 무변경) |
| BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 사내 BODY 재조회 FRESH-GATE 포함, 블록 문구는 사내 적용본에서 그대로 추출한다.
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 리허설 실행기와 결과.
- `_md5_corporate_applied.txt` — 생성 시점 사내 적용본 md5.
