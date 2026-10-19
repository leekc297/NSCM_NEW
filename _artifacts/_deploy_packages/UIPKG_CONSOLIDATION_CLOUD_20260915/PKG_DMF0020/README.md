# PKG_DMF0020 — standalone SP → PKG 취합 이관 (2026-09-15)

> 원천: 사내 ZIOUI1 적용·검증본 · 전체 순서/공통 주의 = `../00_README.md` · 로컬 검증 = 사내 `UIPKG_CONSOLIDATION_20260915/LOCAL_VERIFY_GUIDE.md`

## 대상 SP
| standalone SP | PKG 멤버 | 처리 | 화면 API (META) |
|---|---|---|---|
| PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE | PKG_DMF0020.P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE | add | (내부 호출) PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL·_POPUP (Sales Price 저장 → 금액 재계산) |

## 파일
| 파일 | 실행 계정 | 내용 | 기대 결과 |
|---|---|---|---|
| `00_PRECHECK.sql` | SCM_MGR | 조회 전용 — 판정표 확인(아래 §판정) | - |
| `10_SPEC.sql` | SCM_MGR | PKG SPEC 교체 (멤버 선언 추가/교체) | SHOW ERRORS 0 · 실패 시 적용 직전 백업한 클라우드 원문으로 원복(§원복 요약) |
| `11_BODY.sql` | SCM_MGR | PKG BODY 교체 (standalone 본문 → 멤버, 내부 호출 → 멤버) | SHOW ERRORS 0 |
| `12_CALLER_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL.sql · 12_CALLER_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP.sql` | SCM_MGR | PKG 밖 호출부 본문 교체 (대상 SP 호출 → PKG.멤버) | VALID |
| `20_GRANT_SCM_MGR.sql` | SCM_MGR | GRANT EXECUTE → SCMP_APP (멱등) | 오류 없음 |
| `21_SYNONYM_SCMP_APP.sql` | **SCMP_APP** | CREATE OR REPLACE SYNONYM (멱등) | 오류 없음 |
| `90_VERIFY.sql` | SCM_MGR | 적용 확인 — STATUS VALID · SOURCE_CHK SAME · USER_ERRORS 0 · 멤버 N행 | - |
| `40_DROP_STANDALONE_SCM_MGR.sql` | SCM_MGR | 미사용 standalone 삭제 (가드 통과 SP 만 · 기존 PROC_M 행 삭제 + DROP) | DROPPED N · SKIP 0 |
| `41_DROP_SYNONYM_SCMP_APP.sql` | **SCMP_APP** | 삭제된 SP 의 SCMP_APP 시노님 정리 | DROPPED SYNONYM N |
| `49_RESTORE.sql` | SCM_MGR (+SCMP_APP 주석분) | 40·41 원복 — standalone·GRANT·PROC_M 복원 | - |

## 적용 순서

### ① 사전 점검
1. `@00_PRECHECK.sql` (SCM_MGR) — 결과를 아래 판정표로 해석
   | [A] VERDICT | 조치 |
   |---|---|
   | PRE | 해당 파일 적용 |
   | POST | 이미 적용됨 — 해당 파일 SKIP |
   | ABSENT → 신규 생성 대상 | 적용 (PKG_SYS0012 등 신규) |
   | ABSENT → ⚠ 기존 객체 부재 | **중단** — 선행 이관 누락. 결과 공유 |
   | DIFF | **중단 · 전체교체 금지** — 클라우드 본문이 사내와 다름. 결과 공유 후 차이 병합 |
   - [B] standalone VERDICT 가 DIFF → 클라우드에만 있는 수정이 standalone 에 있음 → 멤버에 반영돼야 하므로 **중단·결과 공유**
   - [C] MISSING 행 → 의존 객체 부재 → 컴파일 실패 조건 → **중단·결과 공유**
   - [D] META 현재값 확인(전환 전 = API_URL 이 standalone 이름) · [E] SCMP_APP 권한/시노님 현황

### ② DB 객체 (SCM_MGR)
2. 공통 선처리 `../00_COMMON/00_RECOMPILE_INVALID_STANDALONE.sql` (전체에서 1회 · 이미 실행했으면 생략)
3. `@10_SPEC.sql` → SHOW ERRORS 0 확인
4. `@11_BODY.sql` → SHOW ERRORS 0 확인
5. `@12_CALLER_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL.sql` → VALID 확인
6. `@12_CALLER_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP.sql` → VALID 확인
7. 공통 후처리 `../00_COMMON/90_RECOMPILE_DEPENDENTS.sql` (전체에서 1회)

### ③ 앱계정 권한·시노님
8. `@20_GRANT_SCM_MGR.sql` (SCM_MGR) (기존 보유 시 무해)
9. `@21_SYNONYM_SCMP_APP.sql` (**SCMP_APP 로 접속**)

### ④ 적용 확인
10. `@90_VERIFY.sql` — STATUS VALID · SOURCE_CHK=SAME · USER_ERRORS 0행 · 멤버 1행(PKG_DMF0000 은 기존 멤버 1행)
11. 화면 실측 — META 전환 **전** 이므로 화면은 아직 standalone 호출. 내부 호출 전환분(아래 §실측)만 영향

### ⑥ 미사용 standalone 삭제 (화면 실측 완료 후)
12. (선택) 판정만: `40_DROP_STANDALONE_SCM_MGR.sql` 머리 `c_execute := FALSE` 로 실행 → 전부 PASS 확인
13. `@40_DROP_STANDALONE_SCM_MGR.sql` (SCM_MGR, c_execute=TRUE) — `DROPPED` 1 · `SKIP 0` 기대. SKIP 이 있으면 사유 확인(META 미전환/의존 잔존)
14. `@41_DROP_SYNONYM_SCMP_APP.sql` (**SCMP_APP**)
   - 원복: `@49_RESTORE.sql` (SCM_MGR, 파일 내 시노님 주석분은 SCMP_APP 로)

## 실측 (화면)
| 메뉴 | 화면 | 동작 | 기대 |
|---|---|---|---|
| DMF0020 | Sales Price (`/sales-future-price`) | 내부 호출: PKG_DMF0020.P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL·_POPUP (Sales Price 저장 → 금액 재계산) | 저장 성공 · SQL ERROR 없음 |

## 원복 요약
| 단계 | 원복 |
|---|---|
| ② PKG/호출부 | 적용 전 클라우드 원문을 **적용 직전에 반드시 백업**: `SELECT TEXT FROM USER_SOURCE WHERE NAME='<객체>' AND TYPE='<타입>' ORDER BY LINE;` → 그 원문으로 CREATE OR REPLACE |
| ③ 권한·시노님 | 신규분만 `REVOKE EXECUTE ON SCM_MGR.<PKG> FROM SCMP_APP;` · SCMP_APP `DROP SYNONYM <PKG>;` |
| ⑤ META | `39_META_ROLLBACK.sql` |
| ⑥ DROP | `49_RESTORE.sql` |
