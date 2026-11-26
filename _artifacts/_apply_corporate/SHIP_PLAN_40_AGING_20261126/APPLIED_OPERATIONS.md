# 사내 ZIOUI1 적용 기록 : SHIP_PLAN_40 1-6, 2-14 단계 보완 (2026-11-26)

| 시각 | 작업 | 결과 |
|---|---|---|
| 14:27 | a1.py : 1-6 SELECT 재현 | 사내 마지막 CUTOFF 2026-11-21 이라 SYSDATE 기준 0행. 계획에 원장 SCM_AGING_STOCK_H 전체 읽기 |
| 14:29 ~ 14:31 | a2.py : 원문, V1(바깥쪽 조건), V2(1회 읽기) | V1, V2 결과 같음. V1 적용 |
| 14:32:01 ~ 14:32:02 | build_aging.py fetch, apply | 기준본 LAST_DDL 14:11:29(OWMSMAX 적용본과 같음). VALID, 오류 0 |
| 14:34 ~ 14:46 | w2.py : 2-14 재현, 1행 추정 강제 비교 | NO_PUSH_PRED 안 선택 |
| 14:46 ~ 14:47 | s3.py : 3단계 재현 | 효과 10.68 → 9.31초. 보완 안 함 |
| 14:48:20 ~ 14:48:21 | build_whstk.py fetch, apply | 기준본 LAST_DDL 14:32:02(AGINGCUT 적용본과 같음). VALID, 오류 0 |
| 14:50 | w3.py : 2-14 INSERT 문 그대로 | 88.01 → 2.47초, 결과 같음 |
| 14:51:26 ~ 14:51:33 | rehearse2.py : 패키지 A, B 경로 | 기대대로. 최종 상태 = 최종본(3589줄) |

- 중간 시험 : 14:38 ~ 14:46 사이 GTT 세션 통계 수집 시험(g2.py, 실행 시각 기록 없음)에서 수집이 트랜잭션을 커밋함. 시험 세션의 GTT 행만 남았고 실제 테이블 변경 없음
- 생성 객체 : SCM_MGR.ZB_SSP40_SHIP_20261126C (보관 표)
- 원복 : `_artifacts/_deploy_packages/SSP_SHIP_PLAN_40_PERF2_CLOUD_20261126/A_DB/99_ROLLBACK.sql` 또는 PR_SSP_ANL_SHIP_PLAN_40.ASIS.sql(1-6 전), PR_SSP_ANL_SHIP_PLAN_40.W.ASIS.sql(2-14 전)
- 15:13 패치판 20, 15 진단 생성(build_patch_perf2.py). 리허설 rehearse3.py 결과 README 참조. 사내 원문 최종본 유지
- 15:39 ~ 15:43 2-3(6fv7933qvycp9) 측정 : INDEX_SS(@SEL$3 DPP IX01) 26.71 ~ 31.73초 → 1.75 ~ 3.29초, 결과 같음
- 15:43:59 build_post.py apply : E20261126-POSTSS, VALID, 오류 0(기준본 LAST_DDL 15:13:18 = PERF2 최종본)
- 15:44:53 ~ 15:45:04 rehearse4.py : PERF3 패키지 리허설. 보관 표 ZB_SSP40_SHIP_20261126D 생성. 사내 원문 = 최종본(3592줄)
