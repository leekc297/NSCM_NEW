# FP_MGR.IF_SSP_FP_RELEASE_PLAN_V 조회 지연 보완 (E20261125-FPRELV-ITEMJOIN)

- 대상: FP_MGR.IF_SSP_FP_RELEASE_PLAN_V (VIEW). SCM_MGR.SSP_DNM_PLAN_FROZEN_V 가 시노님 SSP_DNM_FP_RELEASE_PLAN_V_SN 으로 읽는 하위 뷰
- 영향: PR_SSP_ANL_SHIP_PLAN_40 1754행 INSERT INTO GT_SSP_PLAN_FROZEN_POUCH
- 기준본: 사내 ZIOUI1, LAST_DDL 2026-11-17 17:17:28, 조회 2026-11-25 13:57
- 실행 계정: FP_MGR 또는 DBA. SCM_MGR 로는 FP_MGR 뷰를 다시 만들 수 없음(권한 미확인)
- 전체 F5, 반복 실행 가능

## 증상

- 클라우드 QA 2026-11-25 12:52 시작 회차에서 1754행 INSERT 가 45.1분째 실행 중이었음(sql_id 16zd7hkh15tk1)
- 같은 SQL 누적 CPU 2,697초, BUFFER_GETS 604,540,844, ROWS_PROCESSED 0, 대기 latch: cache buffers chains

## 원인

뷰는 UNION ALL 4갈래임. 사내 ZIOUI1 에서 40 사업부 조건으로 갈래별 측정함.

| 갈래 | 원천 | 보완 전 |
|---|---|---|
| 1 | FP_DAILY_PRODUCTIOIN_PLAN_H 계획 | 5.2초 |
| 2 | SCM_DAILY_PRODUCT_RESULT_H 실적 | 0.1초 |
| 3 | FP_DAILY_PRODUCTIOIN_PLAN_H 활성화 공정 변환 | 200초 안에 끝나지 않음 |
| 4 | SCM_DAILY_PRODUCT_RESULT_H 활성화 공정 변환 | 1.2초 |

- 3번째 갈래 실행 계획에서 옵티마이저가 조회 기준값(FORMATION_MMD_ROUTE_CONVERT, AUTO_PLAN_CALL_FLAG)을 1행으로 추정함
- 그 결과 SCM_ITEM_M 40 사업부 245K행과 MERGE JOIN CARTESIAN 을 만들고, 품목 행마다 IX01_FP_DAILY_PRODUCTIOIN_PLAN_H(DIVISION_ID, COMPANY_ID, PLAN_DATE) 범위를 다시 읽음
- 스칼라 서브쿼리(Aging, 수율, 라인 매핑)를 모두 뺀 조인 골격만으로도 200초를 넘음. 서브쿼리는 원인이 아님

## 변경 내용

3번째, 4번째 갈래에서 SCM_ITEM_M 을 FROM 에서 뺌.

| 위치 | 변경 전 | 변경 후 |
|---|---|---|
| SELECT OPERATION_ID | SI.FORMATION_FLOW_ID 끝 5자리 | SCM_ITEM_M PK 단건 조회로 같은 값 |
| FROM | , SCM_ITEM_M SI | 없음 |
| WHERE | DPP 와 SI 4컬럼 조인 | EXISTS(SCM_ITEM_M 4컬럼 일치) |

- SCM_ITEM_M PK = ITEM_ID, COMPANY_ID, DIVISION_ID, SITE_ID 이고 조인 컬럼 4개와 같음. 조인 1건당 품목 행은 0건 또는 1건이라 결과 행이 바뀌지 않음
- 다른 갈래, 다른 조건, 컬럼 목록 17개, 권한은 바꾸지 않음
- FORCE 없이 다시 만듦. 컴파일 오류면 문장이 실패하고 원래 뷰가 그대로 남음

## 실행 순서

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | A_DB/05_BACKUP_CLOUD.sql | 클라우드 뷰 원문을 표 FP_MGR.ZB_FPRELV_20261125_SRC 에 보관. 표가 있으면 건너뜀 |
| 2 | A_DB/20_VIEW_IF_SSP_FP_RELEASE_PLAN_V.sql | 치환 3종(각 2곳) 확인 후 뷰 다시 만들기 |
| 3 | A_DB/90_VERIFY.sql | 읽기 전용 확인. 기대값은 파일 머리말 |
| 문제 시 | A_DB/99_ROLLBACK.sql | 1번 백업 원문으로 복원 |

## 클라우드 원문별 동작

| 클라우드 원문 | 결과 |
|---|---|
| 치환 3종이 각 2곳씩 있음 | 치환 후 적용 |
| 표식 E20261125-FPRELV-ITEMJOIN 있음 | SKIP, 원문 무변경 |
| 그 외(공백, 줄바꿈이 다르거나 갈래 구성이 다름) | -20011 오류로 중단, 원문 무변경. 클라우드 뷰 원문 전달 필요 |

## 사내 ZIOUI1 적용 결과 (2026-11-25 14:17)

| 항목 | 결과 |
|---|---|
| 적용 | VALID, LAST_DDL 2026-11-25 14:17:01, 원문 11,972자 → 12,412자 |
| 재실행 | 20번 SKIP, 05번 SKIP |
| 99_ROLLBACK 리허설 | 14:19:34 원문 일치 복원 → 14:19:35 20번 재적용 VALID |
| 40 사업부 조건(어제 ~ 오늘 + 82일) | 보완 전 14,873건 = 보완 후 14,873건, 해시 합계 일치 |
| 전체 | 보완 전 239,027건 = 보완 후 239,027건, 해시 합계 일치 |
| 3번째 갈래 40 사업부 | 200초 초과 → 3.0초 |
| SSP_DNM_PLAN_FROZEN_V 1754행 조건 | 300초 초과 → 14,846건 4.4초 |
| 권한 | RL_FP_SEL SELECT, SCM_MGR SELECT(WITH GRANT OPTION) 유지 |
| 의존 객체 | SSP_DNM_PLAN_FROZEN_V(SCM_MGR, SCMP_APP 시노님), PR_SSP_ANL_SHIP_PLAN_40 VALID |

- 보완 전 3번째 갈래 결과값은 원본 SQL 에 조인 순서 힌트만 넣어 46.7초에 구함. 힌트는 실행 계획만 바꾸고 결과를 바꾸지 않음
- PR_SSP_ANL_SHIP_PLAN_40 전체 실행은 하지 않음. 프로시저 안에서 COMMIT 해 사내 자료가 바뀜. 1754행 뒤 단계 소요 시간은 미측정
