# DMF0082 FCST Type 콤보 — 일반 그룹 + DM Planner (W/S) 겸직자는 81 에서 일반 유형 ∪ W/S 유형 (클라우드 · 패치형)

> 마커 `[E20261012-FCSTTYPEADM]` — 콤보 SQL 2종(`FcstTypeEditDMF0082` 편집 후보 · `FcstTypeByUserGroupDMF0082` 표시용)의 분기 2곳만 치환. 화면·SP·룩업 무변경.

| 항목 | 값 |
|---|---|
| 증상 (클라우드 QA 10-12) | Division 81 · minyonglee1(ADMIN) Insert Row 의 FCST Type 후보가 W/S 유형 6종(WS·WSF·AS·ASF·Recall·RMA)뿐 |
| 원인 | 콤보 SQL 이 81 에서 `DM Planner (W/S)` 보유 여부만 보고 W/S 유형만 준다. 관리자 그룹 보유는 판정에 없다. 등록(08-14) 이래 같은 규칙 — 08-31 이후 백업본 전수 대조에서 달라진 적 없음 |
| 조치 (사용자 확정 10-12) | 일반 그룹(`ADMIN` · `DM ADMIN` · `DM Planner` · `SCM PI Admin`)을 함께 가진 사용자는 81 에서 일반 유형 12종 + W/S 유형을 모두 받는다 = 14종 (겹치는 코드는 한 번만). "W/S + DM Planner 사용자도 DM Planner 가 할 수 있는 모든 것을 할 수 있어야 한다" |
| 달라지지 않는 것 | W/S 만 가진 사용자(81 = 6종) · 비 W/S 사용자(81 = 12종) · 40 조회(12종) |
| 사내 적용 | **완료** (ZIOUI1 2026-10-12 23:35) — 케이스 4종 × division 2 × 콤보 2 = 16건 PASS · 사내 대상 44명(일반 그룹 + W/S) · 불변 14명(W/S 단독) |
| 클라우드 | **미적용** |
| 왜 패치형인가 | 클라우드 등록 SQL(08-31 판)은 사내(10-12 판)와 줄바꿈·`TO_CHAR(G.USE_YN)`·정렬절이 다르다. 전체 교체하면 그 차이까지 덮으므로 정규식으로 분기 2곳만 바꾼다. 클라우드 동형본(사내 보관 08-31 판)에서 치환·역치환·케이스 검증 통과 |
| BE 재기동 | 콤보 SQL 을 BE 가 캐시하는지 확인하지 않았다 — 적용 뒤 화면에 반영되지 않으면 재로그인/재기동 후 확인 |

## 실행 순서 (SCM_MGR, 각 파일 전체 F5, 값 입력 없음)

| # | 파일 | 기대 |
|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | P1 2행 모두 `ANCHOR1=1 · ANCHOR2=1 · PASS` · P2 대상 사용자 목록 |
| 2 | [A_DB/10_APPLY_FCSTTYPE_ADMUNION.sql](A_DB/10_APPLY_FCSTTYPE_ADMUNION.sql) | `APPLIED` 2줄 · `DONE — 2건 적용 · COMMIT` (이미 적용이면 `SKIP`) |
| 3 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | 관리자+W/S · 81 = 14종 PASS · W/S+DM Planner · 81 = 14종 PASS · W/S 단독 · 81 = 6종 PASS · 중복 0 |

원복: [A_DB/99_ROLLBACK_FCSTTYPE_ADMUNION.sql](A_DB/99_ROLLBACK_FCSTTYPE_ADMUNION.sql) — 10 이 만든 보관 테이블 `SCM_ADM_CMBO_SQL_M_BAK20261012_FTADM` 의 원문으로 복원.

## 주의
- 10 은 보관 테이블을 1회 생성한다(테이블 생성 1건). 그 외 변경은 콤보 SQL 2행 UPDATE 뿐.
- P1 이 `FAIL` 이면 10 은 스스로 중단하고 아무것도 바꾸지 않는다 — 00 결과 회신.
- 90 의 기대 종수(14 / 6 / 12)는 룩업 건수가 사내와 같을 때의 값이다. 다르면 `CHECK` 로 나오며 중복 0 · 관리자+W/S 가 W/S 단독보다 많으면 정상.

## 리허설 (사내 ZIOUI1 2026-10-12 23:35, `_rehearsal_out/`)
00(PASS) → 90(관리자+W/S · W/S+DM Planner 81 = 6종 `적용 전 상태`) → 10(`APPLIED` 2건) → 90(둘 다 14종 PASS · 전 줄 PASS) → 99(2건 원문 복원) → 10(재적용) → 10(`SKIP` 멱등) → 00(`적용됨`).

처음에는 관리자 그룹 3종만 대상으로 23:26 에 적용했다가, 사용자 확정(DM Planner 겸직자 포함)에 따라 원복 후 4종으로 다시 적용했다.

## 작업 ↔ 파일 대조
| 사내에서 한 일 | 파일 |
|---|---|
| 콤보 SQL 2행 치환 | A_DB/10_APPLY_FCSTTYPE_ADMUNION.sql |
| 보관 테이블 생성 | 같은 파일 (자동) |
| 권한·시노님·화면 변경 | 없음 |
