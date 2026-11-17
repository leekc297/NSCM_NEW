# SCP0111 ADMIN 저장 'M' 분기 AS-IS 복원 사내 적용 기록

- 대상 DB: 사내 ZIOUI1 (SERVER_HOST=localhost, SERVICE=zioui1)
- 대상: `SCM_MGR.PKG_SCP0111` PACKAGE BODY `P_SCP0111_SAVE_PSI_ADMIN`
- 지시: 2026-11-17 사용자. FE `buildAdminPayload` 를 AS-IS 절대값 전송으로 바꾸는 전제로 SP 'M' 분기를 AS-IS UPDATE 1문으로 되돌림
- AS-IS 근거: `Doc/asisfacts/db/modules/dbo.SCP0111_SAVE_INTEGRATION_PSI_ADMIN.sql` L191~214, `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Analysis/SCP0111_IntegrationPSI/SCP0111_IntegrationPSI.cs` L1283~1368
- FE 가이드: `Doc/verify/SCP0111/FE_GUIDE_20261117_1736.md`

| # | 시각 | 작업 | 결과 |
|---:|---|---|---|
| 1 | 17:19:22 | 원인 확인용 원문 조회 | BODY VALID, LAST_DDL 2026-11-12 09:55:07, 3,501줄 |
| 2 | 17:35:16 | 착수 기준본 조회 `apply_admin_m_asis.py fetch` | 1번 조회본과 같음. `PKG_SCP0111_BODY.ASIS.sql` 저장 |
| 3 | 17:35:22 | FRESH-GATE 통과 후 적용 `apply_admin_m_asis.py apply` | VALID, ALL_ERRORS 0, LAST_DDL 2026-11-17 17:35:22, 적용본 == DB 원문 |
| 4 | 17:35:24 | 의존 확인 | SCP0111 INVALID 객체 0, PROC_M 21행 == ALL_ARGUMENTS 21개 |
| 5 | 17:36:02 | 저장 시험 `smoke_admin_m.py` (PLAN_START=20991231, DIVISION_ID='ZZ' 전용 행) | S1~S5 PASS, 시험 행 6건 삭제, 잔존 0 |
| 6 | 17:36:44 | 클라우드 패키지 `cloud_pkg.py SCP0111 --mode db` | `_artifacts/_deploy_packages/SCP0111_CLOUD_DB_MOD_20261117_1736`, 리허설 OK, 경고 0 |

## 변경 구간

- 제거: `2026.11.03 SCP0111 BOH DB-ONLY (START)`~`(END)` 구간. INV 분기(전체 월 BOH 맞춤 + QTY 를 BOH 변경량만큼 가감)와 ELSE 분기(QTY 에 차이값 합산) 2문
- 추가: `2026.11.17 SCP0111 ADMIN-M ASIS (START)`~`(END)` 구간. `BOH_QTY = ROUND(V_BOH_QTY_N,0)`, `QTY = ROUND(V_MODI_QTY,0)` UPDATE 1문, WHERE 에 `YYYYMM` 포함. 11-03 이전 사내 원문의 'M' 분기와 같은 문장
- 그 밖의 원문 변경 없음(diff 51줄 → 24줄, 같은 위치)

## 저장 시험 결과(새 FE 전송 형태 = 절대값)

| 시나리오 | 전송 | 결과 |
|---|---|---|
| S1 INV BOH 100→150 | 3개 월, bohQty 150, modiQty 화면값 | 3개 월 BOH 150, QTY 그대로 |
| S2 INV 월 수량 210001 20→25 | 1개 월 | 그 월 QTY 25만 바뀜 |
| S3 PROD_PLAN BOH 0→5 | 3개 월 | 3개 월 BOH 5, QTY 그대로 |
| S4 PROD_PLAN 월 2개 | 209912=7, 210002=0 | 두 월만 바뀜 |
| S5 bohQty 빈 문자열 | 210001 modiQty 9 | BOH 0, QTY 9 (AS-IS '' → 0 변환과 같음) |

AS-IS 개발 DB 에서 같은 입력을 실행한 대조는 하지 않음(미실행). 판정 근거는 AS-IS SP L191~214 와 문장 대조임.

## 전환 기간 주의

- FE G1 반영 전까지 현재 FE 는 차이값을 보냄. 이 기간 ADMIN 저장은 QTY 에 차이값이 대입됨.
- 클라우드는 FE G1 과 DB 패키지를 같은 배포로 적용함.

## 원복

- `python apply_admin_m_asis.py rollback` (DB 원문 == 적용본일 때만 `PKG_SCP0111_BODY.ASIS.sql` 로 되돌림)
