# DMF0053_GAP377_ONLYWEEKLY_CLOUD_20261015 — Customer FCST Waterfall Bucket Only Weekly 주 합계 보완 (클라우드 패치)

- 마커: `[GAP377 2026-10-15]` · 대상: `SCM_MGR.PKG_DMF0053` PACKAGE BODY → `P_DMF0053_GET_SPREAD_TITLE` · `P_DMF0053_GET_CUST_FCST_WATERFALL`
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15 19:11:27) · 리허설 후 최종 재적용(19:16:45, 내용 동일 md5 `6e4dda26…`) — `_artifacts/_apply_corporate/GAP377_DMF0053_ONLYWEEKLY_20261015/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
Bucket = Only Weekly 에서 월이 바뀌는 주의 수요가 적게 나오고, 같은 주 번호 칸이 두 번(앞 칸은 항상 0) 나오며, 기간 표기가 없던 문제를 AS-IS 와 같게 고친다.
- **조회 SP**: 주 구분 키를 날짜별 월로 만들어(`W_20260940` + `W_20261040`) 앞달 쪽 수량이 표시 칸 목록에 없어 빠졌다 → AS-IS `#CALENDAR` 처럼 **그 ISO 주의 기간 내 마지막 날 월 + 주차** 한 키로 만든다.
- **머리글 SP**: Only Weekly 분기가 없어 월별 주 칸·월 칸까지 만들고 대분류에 월을 표시했다 → AS-IS 처럼 Only Weekly 는 **주 칸만**, 대분류 `MM.DD ~ MM.DD`, 폭 100. 사용자 칼럼 설정 유무 두 분기 모두.
- Monthly · Weekly · Daily 결과 · 원장 · 메타 · FE · 권한 · GTT 무변경. **BE 재기동 불필요.**

## 사내 검증 결과 (ZIOUI1, minyonglee1, FE 실전송값 형식)
| 조건 | 항목 | 수정 전 | 수정 후 |
|---|---|---|---|
| 81 · 2026-09-01~2027-02-28 · 입력일 0901~0930 | 머리글 기간 칸 | 36 (월 칸·앞달 주 칸 포함, 폭 50) | **26** (주 칸만, `09.28 ~ 10.04`, 폭 100) — AS-IS 26 |
| 〃 | W40 합계 | 3,462 | **42,888** (= Weekly W_20260940 39,426 + W_20261040 3,462) |
| 〃 | W44 / W49 | 0 / 2,634 | **26,314 / 7,256** |
| 〃 | Only Weekly 총합 | 167,913 | **238,771** (= Weekly 주 칸 총합, 누락 0) |
| 40 · 2023 · 입력일 0301~0831 | W13 / W26 / W39 | 0 / 0 / 0 (GAP 기재) | **41,540,000 / 79,420,000 / 111,660,000** (GAP 기재 AS-IS 값과 동일) |
| 81 Weekly | 결과 전체 | — | 수정 전후 출력 **완전 동일** |
| 81 Monthly / Daily | 정상 조회 | — | 총합 477,542 / 716,313 (Daily = 일+주+월 정합) |

- 리허설: 99(SKIP 사본) → 90 → 99 → 00 → 10 → 10(SKIP) → 90 → 99 → 99(SKIP) → 10, 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문 (md5 `3d82eb6c…`)** · **10 재적용 결과 == 사내 적용본 (md5 `6e4dda26…`)**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 T1~T3 각 2건 · G1~G2 각 1건 전부 PASS · L2 마커 0 · L3 0행 | L1 FAIL 이면 **10 실행 금지**, 결과 회신. L3 에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_GAP377_PATCH.sql` | `APPLIED — PKG_DMF0053 BODY VALID · 마커 10곳` | `중단 — …` 이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 26 / `09.28 ~ 10.04` PASS | 회신 |
| 4 | 화면 Bucket = Only Weekly 조회 | 주 칸만, 머리글 `MM.DD ~ MM.DD`, 월 걸친 주 합계 = Weekly 두 칸 합 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP377_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 5종 문구(T1~T3 각 2곳, G1~G2 각 1곳)만 바꾼다. 문구는 모두 ASCII.
- 99 원복은 적용 문구를 역순으로 구 문구로 되돌린다 — 한글 비교 없음.
- 가드: 마커 존재 → SKIP / 대상 건수 불일치 → 중단 / 조립 마커 수 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원(`EXECUTE IMMEDIATE` 를 `BEGIN…EXCEPTION` 으로 감쌈, ORA-24344 대응).

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 — 기간 칸은 SP 가 달력에서 생성 |
| GTT/TABLE DDL | 해당 없음 — `SCM_SYS_CALENDAR_M.ISO_YYYYWW` 기존 컬럼 사용 |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) · BE | 해당 없음 (재기동 불필요) |

## 파일
- `build_package.py` — 생성기. 치환 정의는 사내 적용 스크립트 `apply_corp.py` 의 `OPS` 를 import(단일 원천). FRESH-GATE + 시뮬레이터.
- `run_rehearsal.py` · `_rehearsal_out/` · `_rehearsal_99_SKIPCOPY.sql` — 사내 리허설.
- `_md5_corporate_applied.txt` · `_md5now.py` — 사내 적용본/수정 전 md5.
