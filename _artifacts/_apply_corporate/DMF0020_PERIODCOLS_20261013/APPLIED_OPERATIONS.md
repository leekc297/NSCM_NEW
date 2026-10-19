# DMF0020 PERIODCOLS — 사내 적용 기록 (2026-10-13)

| 항목 | 값 |
|---|---|
| 대상 DB | 사내 ZIOUI1 — **59.19.252.148:2521** (SERVER_HOST=localhost / INSTANCE=ZIO · 2026-10-13 10:30 주소 변경 후) |
| 객체 | `SCM_MGR.PKG_DMF0020` PACKAGE BODY — `P_DMF0020_GET_SCM_MST_FUTURE_PRICE` |
| 변경 | PIVOT 컬럼 목록 루프 1문장 교체 (마커 `[E20261013-DMF0020PERIODCOLS]`) |
| 적용 전 | VALID · LAST_DDL 2026-10-12 19:18:20 · 앵커 1건 · 마커 0 |
| 적용 후 | VALID · LAST_DDL 2026-10-13 10:43:53 · 오류 0 · 종속 INVALID 0 · 마커 1 |
| 실행 방법 | `_deploy_packages/DMF0020_PERIODCOLS_CLOUD_20261013/build_package.py --apply` (클라우드 전달 SQL 을 그대로 실행) |
| 원복 | 같은 폴더 `A_DB/99_ROLLBACK_PERIODCOLS_PATCH.sql` 또는 `build_package.py --rollback` |

## 실행한 작업 (순서대로)

| # | 시각 | DB | 작업 | 결과 |
|---|---|---|---|---|
| 1 | 10:21 | 구 주소 222.110.191.243 (ol9-db) | 메타 삽입 — `SCM_ADM_MNU_BTN_MPG_M` 1행(DMF0020 / spreadTitleDate / SEARCH) + `SCM_ADM_USER_GR_MNU_BTN_MPG_M` 7행 | FE 수정을 전제로 한 배선. FE 를 고치지 않기로 해 #2 에서 원복 |
| 2 | 10:2x | 구 주소 (동일 DB) | #1 의 8행 삭제 | DMF0020 배선 24행 · 권한 159행으로 복귀 (순변화 0) |
| 3 | 10:43:53 | 신 주소 59.19.252.148 | `PKG_DMF0020` BODY 패치 적용 | `APPLIED — VALID · 마커 1곳` |

| 4 | 10:56:54 | 신 주소 | 패치 원복 (`--rollback`) — 클라우드 점검 SQL(01_DIAG) 리허설용으로 "미적용" 상태 재현 | `ROLLED BACK — VALID · 마커 0` |
| 5 | 10:57:08 | 신 주소 | 패치 재적용 (`--apply`) | `APPLIED — VALID · 마커 1곳` · 90_VERIFY V1~V3 PASS |

- **최종 상태 = 적용됨** (LAST_DDL 2026-10-13 10:57:08, 오류 0, 종속 INVALID 0).
- 신 주소 DB 에는 #1·#2 가 실행된 적이 없다 (적용 전 확인: 새 시트 0행 · 배선 24 · 권한 159).
- 권한·시노님·데이터 변경 없음.

## 검증
- 전/후 비교 10케이스 PASS — `_deploy_packages/DMF0020_PERIODCOLS_CLOUD_20261013/_equiv_before_after.out.txt`
- 적용 로그 — 같은 폴더 `_rehearsal_apply.out.txt`
- **미확인**: HTTP 응답·화면 표시 (로컬 BE 미기동)

## BE (로컬 작업 트리, 2026-10-13 11:1x — DB 작업 아님)
- `nscm-be/src/main/resources/mybatis/mybatis-config.xml` — `callSettersOnNulls=true` 를 주석 블록 밖으로 (활성화).
- `nscm-be/src/main/java/com/lgcns/nscm/framework/model/CustomMap.java` — `put` null 가드 추가.
- 사유: 클라우드 QA 에서 SP 는 Period 전체를 내려주는데 화면은 5개 주차 — BE 가 NULL 컬럼을 응답에서 뺀다. 사용자 결정 "BE 일괄 수정".
- **빌드·기동·화면 미확인.** 이관 사본 = 패키지 `C_BE/`.

## 클라우드
- QA: DB 패치 **적용됨** (LAST_DDL 2026-10-13 10:48:47 — 사용자 실행, 01_DIAG 회신으로 확인). BE 미배포.
- DEV: 미확인.
- 패키지 = `_deploy_packages/DMF0020_PERIODCOLS_CLOUD_20261013/` (DB 00 → 10 → 90 · BE C_BE 2개 파일).
