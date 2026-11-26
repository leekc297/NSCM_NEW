# SHIP_PLAN_40 배치 3개 SP 속도 보완 클라우드 이관 (2026-11-26 11:26 사내 적용)

- 대상 : SCM_MGR.PR_SSP_ANL_SHIP_PLAN_40, PR_SSP_ANL_SHIP_PLAN_40_BALANCE, PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40
- 표식 : E20261126-DS2 (3개 SP), E20261126-BALCUM (BALANCE)
- 기준본 : 사내 ZIOUI1 2026-11-26 11:05:59 조회. LAST_DDL SHIP_PLAN_40 2026-11-25 10:33:42, BALANCE 2026-11-25 10:33:41, MAIL 2026-11-25 16:29:53
- 실행 계정 : SCM_MGR. 파일마다 전체 실행(F5), 반복 실행 가능

## 실행 순서 (클라우드)

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | A_DB/00_PRECHECK.sql | 원문 판(SAME_AS_CORP_ASIS), 표식 수, 실행 중 세션. [P2] 0행일 때 진행 |
| 2 | A_DB/05_BACKUP.sql | 현재 3개 SP 원문을 ZB_SSP40_SHIP_20261126, ZB_SSP40_BAL_20261126, ZB_SSP40_MAIL_20261126 에 보관 |
| 3 | A_DB/10_PATCH_DS2_PR_SSP_ANL_SHIP_PLAN_40.sql | 본문 BEGIN 다음에 2줄 추가 |
| 4 | A_DB/11_PATCH_DS2_PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40.sql | 본문 BEGIN 다음에 2줄 추가 |
| 5 | A_DB/20_REPLACE_PR_SSP_ANL_SHIP_PLAN_40_BALANCE.sql | 사내 적용본으로 교체 |
| 6 | A_DB/90_VERIFY.sql | 기대값 : VALID, ERR_CNT 0, MARK_DS2 1, MARK_BALCUM BALANCE 7 |
| 문제 시 | A_DB/99_ROLLBACK.sql | 05 보관 원문으로 3개 SP 복원 |

## 바뀌는 것

| SP | 변경 |
|---|---|
| 3개 공통 | 본문 첫 줄에 `EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2'`. 클라우드 설정 0(2026-11-26 회신 [C13]), GT_* 18개 통계 없음 |
| BALANCE 1단계 INSP_WIP | 행마다 SSP_ANL_SHIP_PLAN_40 을 다시 읽던 스칼라 서브쿼리 2개 → Z CTE 의 SUM() OVER 누적합 |
| BALANCE 3단계 WH_STOCK | 같은 구조 서브쿼리 2개(THEN, ELSE 같은 문장) → 누적합. HOLD x 달력 스칼라 서브쿼리 → HD CTE 1회 집계 후 외부 조인 |

- 세션 설정은 SP 를 부른 세션에 남음. JOB 세션은 3개 SP 를 차례로 부르므로 같은 값으로 이어짐. DBeaver 로 직접 실행한 창도 dynamic_sampling 2 로 남음
- 그 밖의 줄, 컬럼, 저장 대상은 바꾸지 않음

## 클라우드 원문별 동작

| 파일 | 클라우드 원문 | 결과 |
|---|---|---|
| 10, 11 | 표식 E20261126-DS2 없음, 0열 BEGIN 줄 있음 | 2줄 추가 후 컴파일 |
| 10, 11 | 표식 있음 | SKIP |
| 10, 11 | 0열 BEGIN 줄 없음 | -20011 중단, 원문 무변경 |
| 20 | 줄 수 855, SUM(ORA_HASH(TEXT)) 1950206246293 (사내 기준본과 같음) | 교체 후 컴파일 |
| 20 | 표식 두 개 있음 | SKIP |
| 20 | 그 밖 | -20011 중단, 원문 무변경. 클라우드 원문 전달 필요 |
| 공통 | 컴파일 결과 VALID 아님 | 원문으로 되돌리고 -20012 |

- 클라우드 판 : 2026-11-26 1차 회신 [C1] 에서 SHIP_PLAN_40, BALANCE 는 사내와 같음(Y), MAIL 은 다름(N). MAIL 은 클라우드 원문 위에 2줄만 넣으므로 판 차이와 무관함

## 사내 ZIOUI1 확인 (2026-11-26)

| 시각 | 항목 | 결과 |
|---|---|---|
| 11:08 ~ 11:24 | BALANCE 1, 3단계 원문 vs 변경본 결과 대조(MINUS 양방향) | 계획 20261118, 20261119, 20261120, 20261121 모두 0건. 20261121 105,840행 일치 |
| 11:11 | HOLD 집계 대조(수량 있는 계획 40/20201102, 가상 Z 2,470행) | 합계 954,100, 0 아닌 행 29건, MINUS 0건 |
| 11:19 ~ 11:24 | 소요(전 행 fetch, 2회 측정) 20261121 | 1단계 20.3초 → 1.0초, 3단계 108.8초 → 1.7초 |
| 11:26:01 | 05 → 10 → 11 → 20 → 90 | APPLY 3건, VALID, 오류 0, 줄 3582 / 812 / 2251 |
| 11:26:3x | 10, 11, 20 재실행 | SKIP 3건 |
| 11:26:3x | 99 원복 | 3건 원문 == 착수 기준본 |
| 11:26:43 | 10, 11, 20 재적용 | 3건 원문 == 적용본, VALID, 오류 0 |
| 11:27 | PR_SSP_ANL_SHIP_PLAN_40('40', 'HQ00') 호출 | 세션 dynamic_sampling 0 → 2. I/F 점검 가드로 RETURN, 로그 증가 0 |

- 시험하지 않은 경로 : 20 의 -20011(원문 다름), 공통 -20012(컴파일 실패 복원). 사내에 해당 조건이 없음
- BALANCE 를 실제로 끝까지 실행하지 않음. SSP_ANL_SHIP_PLAN_40 을 UPDATE 후 COMMIT 하는 배치라 사내 데이터를 바꿈. 바뀐 두 문장은 위 결과 대조로 확인함
- 사내 SCM_MGR 에 보관 표 3개(ZB_SSP40_*_20261126) 생성됨

## 참고 : 11-25 1회차 2-4 단계 지연(16zd7hkh15tk1)

- 원인 문장은 FP_MGR.IF_SSP_FP_RELEASE_PLAN_V 를 읽는 GT_SSP_PLAN_FROZEN_POUCH 적재. 이 패키지와 별개로 SSP_FP_RELEASE_PLAN_V_PERF_CLOUD_20261125_1413 (E20261125-FPRELV-ITEMJOIN) 이 같은 뷰의 SCM_ITEM_M 카티션 조인을 고침
- 그 패키지의 클라우드 적용 여부 미확인. 2차 회신 [D7-1] 지금 계획에서 SCM_ITEM_M 은 PK_SCM_ITEM_M 단건 조회로만 나옴. [D8-3] 실제 조회 19.2초

## 생성
- `_artifacts/_apply_corporate/SHIP_PLAN_40_3SP_PERF_20261126/build_tobe.py` : 사내 적용본 생성, 적용
- `_artifacts/_apply_corporate/SHIP_PLAN_40_3SP_PERF_20261126/build_package.py` : 이 패키지 생성(FRESH-GATE, SOURCE-FRESH 스탬프)
