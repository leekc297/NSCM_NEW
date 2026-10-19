# DMF0044_GAP313_CFSEND_CLOUD_20261015 — Cutoff 저장 후 전송 데이터 재생성 (클라우드 패치, DB 만)

- 마커: `[GAP313 2026-10-15]` 1곳
- 대상: `SCM_MGR.PKG_DMF0044` PACKAGE BODY의 `P_DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` 끝 TODO 주석 블록 1곳
- 실행 계정: SCM_MGR / 적용 순서: 클라우드 QA → DEV
- **FE·BE 무변경 · BE 재기동 불필요.** 원장·메타·권한도 바꾸지 않음.

## 무엇이 바뀌나
| 구분 | 동작 |
|---|---|
| AS-IS (`DMF0044_SAVE_SALES_PLAN_REPORT_C_CF` L2773~2781, LGCE_SCMDEV 2026-02-03) | Cutoff 저장 뒤 해당 버전이 전송 완료(`DM_MDF_VERSION.SEND_YN='Y'`)면 `DMF0044_MOBILE_REPORT_CREATE(.., 'T', ..)` 로 전송 데이터를 다시 만든다 |
| TO-BE 현재 | 같은 호출이 `/* TODO DMF0044_MOBILE_REPORT_CREATE … */` 주석으로 막혀 있다. 그래서 전송이 끝난 버전을 고쳐도 모바일·보고 자료에 반영되지 않는다 |
| 패치 후 | 주석을 풀고, 같은 패키지의 `P_DMF0044_MOBILE_REPORT_CREATE`(인자 6개)를 호출한다. 주석 안의 원래 호출은 존재하지 않는 standalone 5인자라 그대로 풀면 컴파일 오류가 난다 |

- 재생성이 실패하면 오류를 내고 저장 전체를 되돌린다. 검증 메시지만 돌아오는 경우(`TEAM정보가 존재하지 않아…`, ETC 병합 중복 등)도 실패로 본다. AS-IS 에서 안쪽 SP 의 ROLLBACK 이 바깥 저장까지 모두 취소하는 동작과 같다.
- `SEND_YN` 이 'Y' 가 아닌 버전은 종전과 같다(호출 안 함).
- ⚠ 한계(기존 TO-BE 구조, 이번 범위 밖)
  - `P_DMF0044_MOBILE_REPORT_CREATE` 안의 하위 3개 SP(PRODUCT/DEPT/EXCHANGE_RATE_CREATE)는 각자 COMMIT 한다. 그래서 재생성 **도중** 오류가 나면 이미 확정된 부분은 되돌아가지 않는다. Transfer 버튼도 같다.
  - 일반 저장 `P_DMF0044_SAVE_SALES_PLAN_REPORT_C` 의 같은 TODO(`26.03.23`)는 이번에 바꾸지 않았다.

## 검증 상태 (2026-10-15 18:55, 사내 ZIOUI1 59.19.252.148)
- ⚠ **사내 ZIOUI1 은 아직 미적용이다.** 적용 실행이 권한 분류기에 막혀 있다. 그래서 다음 두 가지는 **미검증**이다.
  - 사내 컴파일
  - 실제 Cutoff 저장으로 재생성되는지 확인
- 확인한 것 (모두 DB 무변경):
  - 생성 직전 사내 원문 재조회가 착수 조회본과 같음 (FRESH-GATE).
  - 시뮬레이터: 수정 전 → 적용 == 적용본 / 적용본 → 원복 == 수정 전.
  - **DRY-RUN**: 생성된 10/99 PL/SQL 블록을 사내에서 실행했다. 소스는 바인드로 넣고, 컴파일 대신 결과를 반환하게 했다. 결과:
    - 10 적용 == 적용본 전문
    - 10 재실행 = SKIP
    - 99 원복 == 수정 전 전문
    - 99 재실행 = SKIP
  - 00_PRECHECK 사내 실행: L1 2줄 PASS · L2 인자 6 PASS · L3 마커 0 · L4 0행.
  - 90_VERIFY 사내 실행: 문법 정상. 적용 전이라 V1/V3/V4 는 FAIL 이 맞다.
  - 결과 기록 위치: `_rehearsal_out/`
- 사내 적용기: `_artifacts/_apply_corporate/DMF0044_GAP313_20261015/apply_gap313.py apply`. 같은 문구를 쓰며, 적용 후 VALID·오류 0·의존 INVALID 0 을 확인한다.

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 2줄 PASS · L2 6 PASS · L3 마커 0 · L4 0행 | L1·L2 FAIL 이면 **10 실행 금지**, 결과 회신 |
| 2 | `A_DB/10_APPLY_GAP313_PATCH.sql` | `APPLIED — PKG_DMF0044 BODY VALID · 마커 1곳` | `중단 — …` 이면 원문은 바뀌지 않음. 컴파일 실패 시 원문 자동 복원 |
| 3 | `A_DB/90_VERIFY.sql` | V1 1 PASS · V2 VALID/오류 0/의존 INVALID 0 · V3 0 PASS · V4 1 PASS | 회신 |
| 4 | 화면 DMF0044 | 전송 완료 버전에서 Cutoff 저장 → 정상 저장, `DM_PLN_SALES_PLAN_REPORT_C` DATA_TYPE='2' 행 재생성(40 사업부) | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP313_PATCH.sql` | `ROLLED BACK — … 마커 0` | 회신 |

## 패치 방식
- 이 DB 의 `USER_SOURCE` 를 읽는다. CF 프로시저 구간(`PROCEDURE …_C_CF` ~ `END …_C_CF;`) 안의 ASCII 문구 블록만 정확 문자열로 치환한다. 원복은 그 역치환이다.
- 대상이 1건이 아니거나 호출 대상 인자가 6개가 아니면, 원문을 바꾸지 않고 중단한다.
- `CREATE OR REPLACE` 는 `BEGIN … EXCEPTION WHEN OTHERS THEN NULL; END;` 로 감쌌다. 그 뒤 STATUS/USER_ERRORS 로 판정하고, 실패면 원문을 되넣는다 (ORA-24344 대응).

## 파일
- `build_package.py` — 생성기 (FRESH-GATE · 시뮬레이터 · DRY-RUN 포함).
- `run_rehearsal.py` · `_rehearsal_out/` — 사내 조회 전용 실행 결과 (00·90).
- `_md5_corporate.txt` — 생성 시점 사내 수정 전·적용본 md5.
