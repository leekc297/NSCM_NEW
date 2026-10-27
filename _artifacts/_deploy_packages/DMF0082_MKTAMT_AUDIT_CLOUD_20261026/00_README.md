# DMF0082 조회 — MKT FCST 금액 메저 LAST UPDATE DATE · LAST UPDATED BY 공란 보완 (클라우드 · 패치형)

> 마커 `[E20261026-DMF0082-MKTAMTAUDIT]` — PKG_DMF0082 BODY 의 금액 arm 4곳만 치환. 화면·BE·메타 무변경.

| 항목 | 값 |
|---|---|
| 증상 | DMF0082 조회에서 MKT_FCST_AMT(KRW) · MKT_FCST_AMT(LOC) 메저(코드 MKT_AMT_KRW / MKT_AMT_LOC) 선택 시 LAST UPDATE DATE · LAST UPDATED BY 공란 |
| 원인 | Division 81 계열 금액 arm 4곳이 두 컬럼을 `NULL` 로 고정 적재 (10-02 `[E20261002-DMF0082-81MKTAMT]` 신설 시) — `P_DMF0082_GET_MAIN_DATA` Current·MF·SF 3곳 + `P_DMF0082_GET_MAIN_DATA_CURRENT` 1곳 |
| 조치 | 다른 수요 메저와 같은 규칙 — 원천(`DM_PLN_SALES_PLAN` / `DM_PLN_SALES_PLAN_C`) 행의 `MAX(CREATION_DATE)` · 그 시점 `LAST_UPDATED_BY` 로 채움 (화면 표시는 기존 키별 MAX 그대로) |
| 값의 의미 | 금액 행은 매출계획 동기화·야간 배치가 생성하므로 수정자는 생성 주체 (사내 실측: `CUTOFF` · `SYSTEM` · 동기화 저장 사용자) |
| 사내 적용 | **완료** ZIOUI1 2026-10-26 23:48:51 · VALID · 오류 0 · 같은 날 23:46 의 다른 보완(`XLSNOTARGET`)과 공존 확인 |
| 클라우드 | **미적용** — QA · DEV 둘 다 실행 |
| 방식 | 패치형 — 대상 DB 의 USER_SOURCE 를 읽어 바뀐 줄만 치환 (사내 전체본 복사 아님). 치환 쌍은 사내 적용 전/후 원문 diff 에서 자동 생성 (`build_package.py`) |

## 실행 순서 (SCM_MGR, 각 파일 전체 F5, 값 입력 없음 · QA 와 DEV 각각)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | P1 앵커 4개 모두 `PASS` (기대 3·2·2·1) · P2 금액 행 수정 정보 공란 0 |
| 2 | [A_DB/10_APPLY_MKTAMTAUDIT_PATCH.sql](A_DB/10_APPLY_MKTAMTAUDIT_PATCH.sql) | `APPLIED - PKG_DMF0082 BODY VALID / MKTAMTAUDIT tag lines 9` (이미 적용이면 `SKIP`) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 BODY VALID · 오류 0 / V2 표식 9줄 PASS / V3 NULL 고정 잔존 0 PASS |
| 4 | 화면 | DMF0082 · Division 81 · 금액 메저 + LAST UPDATE DATE · LAST UPDATED BY 컬럼 선택 후 조회 → 값 표시 |

- P1 이 하나라도 `FAIL` 이면 10 은 스스로 중단하고 원문을 바꾸지 않는다 → 00 결과 회신.
- 10 은 컴파일 오류 시 원문을 자동 복원한다. `PKG_DMF0082 in use` 로 중단되면 잠시 뒤 재실행.
- 원복: [A_DB/99_ROLLBACK_MKTAMTAUDIT_PATCH.sql](A_DB/99_ROLLBACK_MKTAMTAUDIT_PATCH.sql) — 치환한 줄만 원래 문구로 되돌림 (멱등).

## 검증 (사내 ZIOUI1 · 2026-10-26)

| 검증 | 결과 |
|---|---|
| 실호출 비교 (Div 81 · Current · eunah.koo = 금액 메저 보유 / minyonglee1 = 미보유) | 금액 행 수정 정보 채움 **0 → 4,154 / 4,154** (KRW·LOC 각각, 최신 2026-09-30 19:44:30 CUTOFF) · 화면 출력 행·값 해시 동일 · 금액 외 메저 수정 정보 해시 동일 → **ALL PASS** |
| MF 버전 arm (원천 집계 단독 실행) | 금액 그룹 9,488 / 9,488 수정 정보 채움 **PASS** |
| SF 버전 arm | 사내 Div 81 SF 버전 0건 → 실행 대상 없음. 원천·집계식이 MF arm 과 동일 |
| GET_MAIN_DATA_CURRENT arm | 사내 Div 81 결과 0행(이 프로시저 경로 미사용) → 컴파일로 검증 |
| 패키지 리허설 (사내 복제 PKG_DMF0082_RH, 적용 전 원문) | 00 PASS → 10 APPLIED(적용본 == 사내 현재본) → 10 SKIP → 90 PASS → 99 ROLLED BACK(원복본 == 적용 전 원문) → 99 SKIP → 10 재적용 PASS → 복제 DROP |
| 하네스 결함으로 드러난 보호 동작 | 1차 리허설에서 복제본 END 라벨 미변경 → 10 이 컴파일 실패 감지 후 **원문 자동 복원** 동작 확인 |

⚠ 참고(별건): Current+MF/SF 버전 동시 조회 시 MF 금액 arm(`DM_PLN_SALES_PLAN_C`) INSERT 가 **수정 전 원본에서도** 30분 초과(사내, eunah.koo). 이번 수정(집계 2개 추가)과 무관한 기존 성능 문제로 별도 진단 필요.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| PKG_DMF0082 BODY 4곳 치환 · 컴파일 | `_apply_corporate/DMF0082_MKTAMT_AUDIT_20261026/apply_mktamt_audit.py` → 클라우드 = A_DB/10_APPLY_MKTAMTAUDIT_PATCH.sql |
| 권한·시노님·메타·화면 변경 | 없음 |
