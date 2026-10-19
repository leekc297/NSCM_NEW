# DMF0003_VMIDIOJOIN_CLOUD_20261016 — 40 전체 Measure 조회 지연 (VMI DIO 조인) 클라우드 패치

- 마커: `[E20261016-VMIDIOJOIN]` · 대상: `SCM_MGR.PKG_DMF0003` PACKAGE BODY → `P_DMF0003_GET_MKT_FCST_DATA` 최종 동적 SQL
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-16 15:31:54) · 리허설 후 최종 재적용(15:45:30, 내용 동일 md5 `a83c2bd7…`) — `_artifacts/_apply_corporate/DMF0003_VMIDIOJOIN_20261016/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
40 조회 최종 동적 SQL 의 VMI DIO 임시표 조인이 아래처럼 등호 오른쪽이 `CASE` 로 감싸여 있었다.
```sql
LEFT JOIN SCM_MGR.GT_DMF0003_VMI_DIO VM
  ON  A.ITEM_ID = CASE WHEN '40' = '40' THEN VM.KEY_JOIN ELSE A.ITEM_ID END
  AND ( '40' = '40' OR A.SCM_SITE_ID = VM.KEY_JOIN )
```
Oracle 이 키 조인으로 인식하지 못해 해시 조인을 쓰지 못하고, 결과 행마다 임시표 전체를 다시 읽었다(NESTED LOOPS).
- **40**: `ON A.ITEM_ID = VM.KEY_JOIN` 으로 생성 — 의미는 기존과 같다(`A.ITEM_ID = VM.KEY_JOIN AND 참`).
- **40 외 사업부**: ELSE 분기에 원래 문구를 그대로 둬 생성 SQL 이 1바이트도 바뀌지 않는다(82 는 다른 분기 SQL 사용 — 영향 없음).
- 조회 행·값 · 원장 · 메타 · FE · 권한 · GTT 무변경. **BE 재기동 불필요.**
- 사용자 결정(2026-10-16): 40 VMI STD DIO 값은 현재 TO-BE 그대로 유지(AS-IS 는 이 조인이 40 에서 매칭되지 않아 항상 빈 값 — 원문 판정).

## 사내 검증 결과 (ZIOUI1, 40 · 2026-10-01~2027-03-31 · Measure 21종 전체, 진단 사용자 임시 설정 후 즉시 삭제)
| 항목 | 수정 전 | 수정 후 |
|---|---|---|
| 조회 전체 (SP 호출) | 41.7 ~ 43.8초 | **8.1 ~ 9.2초** |
| 최종 동적 SQL 1문장 | 34.1 ~ 36.4초 (ASH 69 표본 중 68 = 이 조인) | **0.8초** |
| 결과 | 3,065행 | 3,065행 · **원래 조인 SQL 결과와 전 행 동일** |
| 81 생성 SQL | — | 원래 문구 그대로 |

- 리허설: 99(SKIP 사본) → 90 → 99 → 99(SKIP) → 90(미적용 FAIL 검출) → 00 → 10 → 10(SKIP) → 90, 전 단계 기대대로.
- **99 원복 결과 == 수정 전 원문 (md5 `29aaaf4d…`)** · **10 재적용 결과 == 사내 적용본 (md5 `a83c2bd7…`)**.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 J1 1건 PASS · L2 마커 0 · L3 0행 | L1 FAIL 이면 **10 실행 금지**, 결과 회신. L3 에 세션이 있으면 끝난 뒤 실행 |
| 2 | `A_DB/10_APPLY_VMIDIOJOIN_PATCH.sql` | `APPLIED — PKG_DMF0003 BODY VALID · 마커 1곳` | `중단 — …` 이면 원문 무변경. 메시지 회신. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 적용 문구 1 · 수정 전 문구 0 PASS | 회신 |
| 4 | 화면 DMF0003 40 · Measure 전체 조회 | 이전보다 빨라지고 행·값은 같음 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_VMIDIOJOIN_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식 (왜 전체본이 아닌가)
- 클라우드 BODY 와 사내 BODY 는 적용 시점이 달라 **전체본 교체를 금지**한다. `10_APPLY` 는 그 DB 의 `USER_SOURCE` 를 읽어 J1 문구 1곳만 바꾼다. 문구는 모두 ASCII · 탭 없음.
- 99 원복은 적용 문구를 구 문구로 되돌린다 — 한글 비교 없음.
- 가드: 마커 존재 → SKIP / 대상 건수 불일치 → 중단 / 조립 마커 수 불일치 → 중단 / 컴파일 오류 → 원문 자동 복원(`EXECUTE IMMEDIATE` 를 `BEGIN…EXCEPTION` 으로 감쌈, ORA-24344 대응).
- 클라우드 BODY 의 해당 3줄 공백·문구가 사내와 다르면 00 의 L1 이 FAIL 로 알려준다 — 그때는 결과를 회신.

## 이관 축 점검
| 축 | 해당 |
|---|---|
| PKG BODY | ✅ 10_APPLY (패치) |
| PKG SPEC · 시그니처 · PROC_M | 무변경 |
| 메타(MNU/API/BTN/SHEET_COLUMNS/MSG/LBL) | 해당 없음 |
| GTT/TABLE DDL | 해당 없음 |
| GRANT/SYNONYM | 해당 없음 — 객체 신설 없음 |
| FE (`B_FE` / `FE_MERGE`) · BE | 해당 없음 |

## 파일
- `build_package.py` — 생성기. 치환 정의는 사내 적용 스크립트 `apply_corp.py` 의 `OPS` 를 import(단일 원천). FRESH-GATE + 시뮬레이터.
- `run_rehearsal.py` · `_rehearsal_out/`(A·B 두 묶음) · `_rehearsal_99_SKIPCOPY.sql` — 사내 리허설.
- `_md5_corporate_applied.txt` · `_md5now.py` — 사내 적용본/수정 전 md5.
