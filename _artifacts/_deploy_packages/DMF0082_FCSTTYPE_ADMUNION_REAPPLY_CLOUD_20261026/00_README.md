# DMF0082 FCST Type 콤보 — 클라우드 재적용 (2026-10-26)

> 마커 `[E20261012-FCSTTYPEADM]` (10-12 수정과 동일 마커 — 이미 적용된 DB 에서는 무동작)
> 10-12 에 클라우드에 반영했던 수정이 이후 원복되어, 같은 수정을 다시 넣는 패키지다. 화면·SP·룩업 무변경, 콤보 SQL 2행만 치환.

| 항목 | 값 |
|---|---|
| 증상 | Division 81 에서 ADMIN 과 `DM Planner (W/S)` 를 함께 가진 사용자의 Insert Row FCST Type 후보가 W/S 유형 6종뿐 |
| 조치 | 일반 그룹(`ADMIN` · `DM ADMIN` · `DM Planner` · `SCM PI Admin`) 겸직자는 81 에서 일반 유형 + W/S 유형 = 14종 (중복 0) |
| 변하지 않는 것 | W/S 단독 사용자 81 = 6종 · 비 W/S 81 = 12종 · 40 = 12종 |
| 대상 콤보 | `FcstTypeEditDMF0082` (Insert 편집 후보) · `FcstTypeByUserGroupDMF0082` (표시용) |
| 로컬(사내 ZIOUI1) | 적용 상태 유지 확인 — 2026-10-12 23:35:45 적용분, 26일 재검증 16건 PASS |
| 10-12 패키지와 차이 | 보관 테이블명 `SCM_ADM_CMBO_SQL_M_BAK20261026_FTADM` (오늘 원복 상태 보관) · 00 에 [P0] 현재 원문 덤프 · [P4] 이전 적용 흔적 추가 |
| 적용 대상 | 클라우드 **QA · DEV 둘 다** (각각 실행) |
| BE | 콤보 SQL 캐시 여부 미확인 — 화면에 반영되지 않으면 재로그인 후 확인 |

## 실행 순서 (SCM_MGR, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | P1 2행 `PASS → 10 적용 가능` (이미 적용이면 `적용됨`) · P4 이전 보관 테이블 생성 시각 · P0 현재 원문 |
| 2 | [A_DB/10_APPLY_FCSTTYPE_ADMUNION.sql](A_DB/10_APPLY_FCSTTYPE_ADMUNION.sql) | `BACKUP — … 생성` · `APPLIED` 2줄 · `DONE — 2건 적용 · COMMIT` |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | 관리자+W/S 81 = 14종 · W/S+DM Planner 81 = 14종 · W/S 단독 81 = 6종 · 비 W/S 81 = 12종 · 40 = 12종 · 전 줄 PASS |

- P1 이 `FAIL` 이면 10 은 스스로 중단하고 아무것도 바꾸지 않는다 → 00 결과(특히 P0 원문) 회신 → 앵커 보정.
- 원복: [A_DB/99_ROLLBACK_FCSTTYPE_ADMUNION.sql](A_DB/99_ROLLBACK_FCSTTYPE_ADMUNION.sql) — 10 이 오늘 만든 보관 테이블의 원문으로 복원.
- 90 의 기대 종수는 룩업 건수가 사내와 같을 때 값. 다르면 `CHECK` — 중복 0 이고 관리자+W/S 가 W/S 단독보다 많으면 정상.

## 검증 (사내 ZIOUI1 · 2026-10-26, `_rehearsal_out/`)

| 단계 | 결과 |
|---|---|
| 01 · 03 PRECHECK (로컬) | 로컬은 이미 적용 상태 → `적용됨` (10 재실행 무동작) |
| 05 · 08 · 09 APPLY (로컬) | `SKIP` 2건 — 멱등 확인 |
| 10 VERIFY (로컬) | 16건 PASS |
| ⭐ 11 무변경 모의 적용 (클라우드 동형본 08-31 판 `SCM_ADM_CMBO_SQL_M_BK20260907`) | 동일 치환식 적용: 관리자+W/S 81 = **적용 전 6종 → 적용 후 14종** (증상 재현 + 해소) · W/S 단독 6 → 6 · 비 W/S 12 → 12 · 40 = 12 · 중복 0 · 4000B 이하 · 역치환 = 원문 일치 → **16건 ALL PASS** |

⚠ 리허설 한계: 로컬에는 10-12 보관 테이블이 이미 삭제돼 있어(삭제 주체·시각 미확인) "실테이블 원복 → 재적용" 왕복은 로컬에서 재현하지 못했다. 적용 경로는 클라우드 동형본에 대한 무변경 모의 적용(11)으로 검증했다.
리허설 중 로컬에 생긴 `SCM_ADM_CMBO_SQL_M_BAK20261026_FTADM`(수정본 내용 — 원복용으로 부적합)은 즉시 DROP 했다. 로컬 콤보 SQL 자체는 리허설 전후 동일(수정본).

## 작업 ↔ 파일 대조
| 클라우드에서 할 일 | 파일 |
|---|---|
| 적용 전 상태 확인 · 원문 확보 | A_DB/00_PRECHECK_CLOUD.sql |
| 보관 테이블 생성 + 콤보 SQL 2행 치환 | A_DB/10_APPLY_FCSTTYPE_ADMUNION.sql |
| 케이스 검증 | A_DB/90_VERIFY.sql |
| 원복 | A_DB/99_ROLLBACK_FCSTTYPE_ADMUNION.sql |
