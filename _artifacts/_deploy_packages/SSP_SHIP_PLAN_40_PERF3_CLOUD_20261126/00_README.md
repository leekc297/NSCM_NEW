# SHIP_PLAN_40 3차 속도 보완 클라우드 이관 (2026-11-26 15:43 사내 적용)

- 대상 : SCM_MGR.PR_SSP_ANL_SHIP_PLAN_40 1개
- 이번 보완 : E20261126-POSTSS (2-3 POSTP_PLAN, GT_SSP_FORMATION_POST_CELL 적재, SQL_ID 6fv7933qvycp9)
- 패치판 : 클라우드 원문 위에 보완 위치만 바꿈. OWMSMAX, AGINGCUT, WHSTKHD 위치도 들어 있으며 표식이 있으면 SKIP. 클라우드에 PERF2 가 적용돼 있으면 POSTSS 1곳만 바뀜
- 사내 최종본 : 3592줄, LAST_DDL 2026-11-26 15:45:03(리허설 뒤 복원)
- 실행 계정 : SCM_MGR. 파일마다 전체 실행(F5), 반복 실행 가능

## 실행 순서 (클라우드)

| 순서 | 파일 | 내용 |
|---|---|---|
| 1 | A_DB/00_PRECHECK.sql | 표식 5종 수. M_POSTSS 0 이면 진행. [P2] 실행 중 세션 0행일 때 진행 |
| 2 | A_DB/05_BACKUP.sql | 현재 원문을 ZB_SSP40_SHIP_20261126D 에 보관 |
| 3 | A_DB/15_DIFF_SOURCE.sql | 진단(조회만). PERF2 사내 최종본(3589줄)과 다른 줄 출력. 클라우드는 1752줄 공백 1건이 기대값(사내 PERF2 최종본 번호로 1756줄) |
| 4 | A_DB/20_PATCH_PR_SSP_ANL_SHIP_PLAN_40.sql | 보완 위치 패치. 기대 출력 : SKIP 3, PATCH 위치 3(POSTSS), APPLY VALID 바꾼 위치 1 |
| 5 | A_DB/90_VERIFY.sql | 기대값 : VALID, ERR_CNT 0, LINE_CNT 3592, 표식 5종 각 1, SAME_AS_CORP_FINAL N(1752줄 공백 차이) |
| 문제 시 | A_DB/99_ROLLBACK.sql | 05 보관 원문으로 복원 |

## 바뀌는 것

2-3 단계 첫 INSERT 의 SELECT 에 힌트 1개.

```
SELECT  /*+ INDEX_SS(@SEL$3 DPP IX01_FP_DAILY_PRODUCTIOIN_PLAN_H) */
```

- 원인 : 이 문장이 읽는 FP_MGR.SCM_FORMATION_POST_CELL_V 가 FP_DAILY_PRODUCTIOIN_PLAN_H 를 IX01(DIVISION_ID, COMPANY_ID, PLAN_DATE)로 읽는데 COMPANY_ID 조건이 없어 사업부 전체 이력을 범위 스캔함(클라우드 2차 회신 [C12] 계획 266886705 24, 25줄, 1차 [C10] 이 줄 80초). 사내 40 사업부 3,179,539행 중 기준일(11-20) 이후 약 7만 행
- 힌트 : 같은 인덱스를 회사별로 건너뛰며 PLAN_DATE 범위만 읽음. 결과는 같고 읽는 방법만 바뀜
- @SEL$3 = FP_MGR 뷰 본문 블록. 뷰 구조가 바뀌어 블록 이름이 달라지면 힌트는 무시되고 원래 계획으로 돌아감(결과 영향 없음)
- FP_MGR 뷰는 바꾸지 않음(다른 스키마 소유)

## 사내 ZIOUI1 확인 (2026-11-26)

| 시각 | 항목 | 결과 |
|---|---|---|
| 15:39 | 원문 SELECT 재현(HQ00, NJ00) | HQ00 553.83초 0행, NJ00 35.55초 13행. AZ00 는 600초 제한으로 스크립트 끊김(남은 세션 없음 확인) |
| 15:40 | EXPLAIN 힌트 형식 3종 | INDEX_SS(@SEL$3 DPP ...) 만 반영(INDEX SKIP SCAN, 비용 20154 → 29). INSERT 문 EXPLAIN 도 반영 |
| 15:41 ~ 15:43 | INSERT 문 원문 vs 힌트(3개 법인) | NJ00 31.73 → 2.17초, AZ00 30.55 → 3.29초, HQ00 26.71 → 1.75초. 결과 같음(NJ00 13행, 수량 72,521, 해시 같음. AZ00, HQ00 0행) |
| 15:43:59 | 사내 적용(build_post.py) | VALID, 오류 0 |
| 15:44:53 ~ 15:45:04 | 리허설 : PERF2 최종본 + 공백 1줄 다름 → 00, 05, 15, 20, 90 → 20 → 99 → 사내 최종본 복원 | 15 다른 줄 1건. 20 SKIP 3, PATCH 1, VALID. 재실행 SKIP. 원복 = 이전 원문. 90 기대값 일치 |

- HQ00 553.83초와 26.71초 차이 원인 미확인(같은 원문 SELECT/INSERT)
- 클라우드 효과 미측정. 적용 뒤 재실행 스크립트 [R1] [R2] [R3] 로 확인(2-3 단계, 6fv7933qvycp9 는 힌트로 SQL_ID 바뀜)
- 사내 SCM_MGR 에 보관 표 ZB_SSP40_SHIP_20261126D 생성됨

## 생성
- `_artifacts/_apply_corporate/SHIP_PLAN_40_AGING_20261126/build_post.py`(사내 적용), build_package_perf3.py(이 패키지), p3.py ~ p8.py(측정), rehearse4.py(리허설)
