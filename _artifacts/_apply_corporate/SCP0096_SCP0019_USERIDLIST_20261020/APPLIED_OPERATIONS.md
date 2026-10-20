# SCP0096 · SCP0019 저장 ORA-01407 보완 [E20261020-USERIDLIST] — 사내 적용 2026-10-20 (클라우드 미적용)

## 증상
- SCP0096(Shipment Working Day OSP) 셀 수정 → Save(F7): HTTP 200 이지만 결과 커서 `ERR_CODE -1407 / ORA-01407: NULL로 ("SCM_MGR"."SCP_MST_SHIPMENT_WORKING_DAY_OSP"."LAST_UPDATED_BY")을 업데이트할 수 없습니다`, 화면 알림 표시, DB 미반영. E2E crud(실제 저장) 로 2026-10-20 실측.
- SCP0019(Working Time) 는 같은 구조(FE `userIdList` 전송 · PROC_M `userId` 등록) — 동일 결함 보유로 판단해 함께 보완.

## 원인
- FE(`features/supply/src/pages/shipment-working-day-osp/ShipmentWorkingDayOsp.tsx`, `working-time/WorkingTime.tsx`)는 사용자 파라미터를 `userIdList`('^' 다건 join) 로 보낸다(BE 가 `userId` 를 세션 단일값으로 덮어 배열이 깨지는 것을 피하려는 설계).
- 사내 `SCM_ADM_PROC_M` 에는 두 SAVE 프로시저의 8/11번 파라미터가 `userId`(VARCHAR, ZIONEX 2026-09-23/24 등록) → BE 가 이름으로 바인딩 못 해 `P_USER_ID = NULL`.
- SP 는 `P_USER_ID` 를 단일값으로 `LAST_UPDATED_BY/CREATED_BY` 에 그대로 대입.

## 적용(사내 ZIOUI1, run_sql.py --commit, 2026-10-20 21:xx KST)
| # | 작업 | 파일 |
|---|---|---|
| 1 | `UPDATE SCM_ADM_PROC_M SET COL_NM='userIdList'` — `PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` (SORT_ORD 8) · `PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW` (SORT_ORD 11), 감사컬럼 admin | 01_userIdList_scp0096_scp0019.sql |
| 2 | `PKG_SCP0096` PACKAGE BODY CREATE OR REPLACE — SAVE 프로시저에 `V_USER_ID := NVL(REGEXP_SUBSTR(P_USER_ID,'[^^]+',1,1), P_USER_ID)` 추가, 본문 6곳 `P_USER_ID` → `V_USER_ID` (마커 `[E20261020-USERIDLIST]`) | 같은 파일 (사내 live 원문 기준: `_before_PKG_SCP0096_BODY_live_20261020.sql`) |
| 3 | `PKG_SCP0019` PACKAGE BODY 동일(8곳) | 같은 파일 (`_before_PKG_SCP0019_BODY_live_20261020.sql`) |
| 4 | 검증 SELECT: PROC_M 2행 `userIdList` · 패키지 4객체 VALID · 컴파일 OK | 같은 파일 끝 |

## 클라우드 이관
- `01_userIdList_scp0096_scp0019.sql` 전체를 F5 로 실행(멱등: UPDATE 는 `COL_NM='userId'` 행만 · 패키지는 CREATE OR REPLACE). 클라우드 PROC_M 에 이미 `userIdList` 면 UPDATE 0행(정상).
- 전제: 클라우드 PKG_SCP0096/PKG_SCP0019 본문이 사내 2026-10-19/10-09 본과 같아야 한다(다르면 마커 줄만 이식).

## 검증
- E2E crud(SCP0096, jaeuk.shin): 적용 전 `ORA-01407` → 적용 후 **PASS 51s** — 행 [40|CN00254300_40-P|NEXCON_CN_NJ] D_20261020 'Y'→'N' 저장(RESULT_CODE S) → 재조회 'N' 반영 → 원복 'Y' 저장 → 재조회 'Y' 복원. DB 는 원래 값으로 돌아감.
- SCP0019 는 같은 구조라 함께 적용했으나 E2E 실측은 미수행(스펙 미생성 — 화면 e2e_plan 없음). 화면에서 Working Time 셀 저장 1회 확인 권장.
