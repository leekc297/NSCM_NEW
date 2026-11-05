# DMF0049 같은 키 재저장 → 키 중복 메시지로 차단 — 클라우드 이관 패키지 (2026-10-28)

마커 `[E20261028-DUPKEYMSG]` · 사내 ZIOUI1 적용 완료(2026-10-28 17:11:20) · 클라우드 미적용
선행 패키지: `DMF0049_DUPROLLBACK_CLOUD_20261028` (MOBILE 검증 실패 ROLLBACK + 중복 정리) — 함께 적용 권장, 순서 무관

## 무엇이 바뀌나
| 상황 | 변경 전 | 변경 후 |
|---|---|---|
| 같은 키 세트를 두 번째 저장 (전송된 버전) | MOBILE 병합 메시지 "ETC Report데이터를 Sales Report 데이터와 병합하는 과정에서 중복…" | **키 중복 메시지** "…Sales Report 테이블 기준으로 중복되는 값이 발생했습니다." + 겹친 키 값 |
| 같은 키 세트를 두 번째 저장 (전송 전 버전) | 검증 없이 저장됨 | **키 중복 메시지로 차단** |
| 같은 키 세트 2개를 한 번에 신규 저장 | 저장됨 | 차단 |
| 기존 세트 삭제 + 같은 키 신규 세트를 한 번에 저장 | 차단 (삭제 행도 셈) | **통과** (저장 후 1건만 남음) — AS-IS 와 다른 유일한 지점 |
| 정상 수정·다른 키 신규 저장 | 통과 | 통과 (변화 없음) |

중복 판정 키(변경 없음, 그리드 라벨): Division · Department* · Team · Cust. (Report) · End Cust.(Report) · Product Gr.(Report) ·
Model · Currency · Company Id* · Country Name · Measure · 월 (+ Version). Sold-To · Sold-To Cust.(Report) · Product Details · Biz.Type ·
Application Gr · Application · Cell Model · Cell Model Info 는 키가 아니다.

## 원인과 변경 내용
- `PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C` 의 중복 검증은 "원장 × 이번 저장분" 을 12개 키로 조인해 COUNT>1 을 본다
  → 원장 1건 × 저장분 1건 = 1 이라 같은 세트 두 번째 저장을 통과시킨다(AS-IS 원문도 같은 식).
- 변경: 검증 2곳(건수 · 안내문 키 값)을 **저장 후 모습** 기준으로 센다.
  저장 후 모습 = 원장 행 중 이번 저장분이 같은 PK(DATA_SEQ·MEASURE·YYYYMMDD)로 바꾸거나 지우는 행은 빼고 + 저장분 중 삭제(D)가 아닌 행.
  12개 키(GAP358 빈 값 동일 취급 유지)로 묶어 2건 이상이고 이번 저장분이 낀 묶음 = 중복 → 기존 메시지·ROLLBACK·RETURN 그대로.
- 원래 줄은 `--[E20261028-DUPKEYMSG]ORIG ` 접두 주석으로 보존. 메시지 문구·저장 로직·메타·FE 무변경. BE 재기동 불필요.
- 참고: 안내문의 첫 겹친 묶음이 LOC(SP 가 계산해 넣는 파생 메저)로 표시될 수 있다 — 키 값은 같은 세트이다.

## 실행 순서 (클라우드)
1. `A_DB/00_PRECHECK_CLOUD` — P1 BODY VALID · P2 = 0 · **P3 = 2행**(건수 블록 · 안내문 블록) 확인
2. `A_DB/10_APPLY_DUPKEYMSG_PATCH` — `APPLIED … 블록1 a~b / 블록2 c~d` 출력 (재실행 시 `SKIP`)
3. `A_DB/90_VERIFY` — V1 VALID·오류 0 · V2 NEW_BEGIN 2 / NEW_END 2 / ORIG_LINES 50

원복: `A_DB/99_ROLLBACK_DUPKEYMSG_PATCH` (원래 줄 접두 제거 + 새 블록 삭제 → 적용 전 원문과 동일)

## 사내 리허설·시험 (2026-10-28, ZIOUI1)
- FRESH-GATE: 착수(16:52:21) 기준본 = 적용 직전 원문 동일 (LAST_DDL 2026-10-22 11:44:39)
- 패치: 99(SKIP) → 10(APPLIED, 블록 1016~1040 / 1061~1085) → 10(SKIP) → 90 → 99(원복) → **원문 = 기준본 동일** → 99(SKIP) → 10 → 90 PASS
- 시나리오(GT 만 채워 현재/신규 검증 비교, 원장 무변경) 7건 PASS — `_scenario_before_apply.out.txt`
- 저장 SP 직접 호출 (버전 R_S_20261002_V001_C, 전송 전):
  - T1 세트 174 와 같은 키 신규 저장 → 키 중복 메시지 · 원장 13,341 → 13,341 (저장 안 됨)
  - T2 Cust.(Report) 만 바꾼 신규 저장 → `success` · 37행 저장 → 시험 행 즉시 삭제(원장 13,341 복귀)
- 미실행: 화면 경유 저장(E2E) · 전송 버전(SEND_YN='Y')에서의 직접 호출(성공 시 Sales Report 재생성이 일어나 실데이터를 바꾸므로 생략)
