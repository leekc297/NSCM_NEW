# SCP0096 저장 SQL ERROR(ORA-01407) 보완 — 클라우드 이관 패키지 (2026-10-28)

## 증상 · 원인
- 증상: SCP0096 Shipment Working Day OSP 셀 수정 후 저장 → SQL ERROR.
- 실오류(SCM_SYS_LOG_BATCH, PROGRAM_NAME=PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP):
  `ORA-01407: NULL로 ("SCM_MGR"."SCP_MST_SHIPMENT_WORKING_DAY_OSP"."LAST_UPDATED_BY")을 업데이트할 수 없습니다` (2026-10-28 21:01:34 · 21:06:40)
- 원인: 계약 불일치
  - FE(공통소스 10-28 반영본 `ShipmentWorkingDayOsp.tsx` handleSave)는 `userId`(세션 단일값)로 전송
  - 사내 PROC_M SORT_ORD=8 COL_NM 은 `userIdList`(2026-10-20 21:35 admin 변경. 원래 등록값 `userId` — ZIONEX 09-24, `SCM_ADM_PROC_M_BAK20260930`)
  - BE `BaseService.makeProcedure`(L381)는 PROC_M COL_NM 키만 SP 로 넘김 → P_USER_ID = NULL → 감사 컬럼 NOT NULL 위반
- 보완: PROC_M 1행 COL_NM `userIdList` → `userId` (DB 메타만. PKG·FE·BE 무변경)
  - PKG 본문은 `NVL(REGEXP_SUBSTR(P_USER_ID,'[^^]+',1,1), P_USER_ID)` 라 단일값·'^' 배열 모두 처리 → 변경 불필요
  - 이 프로시저 호출처 = API `P_SCP0096_SAVE` → SCP0096 / Shipment Working Day OSP / SAVE 1곳뿐
  - 형제 SCP0019(`P_SCP0019_SAVE_WORKING_TIME_ROW`, COL_NM userIdList)는 FE 가 `userId`·`userIdList` 둘 다 보내 정상 → 대상 아님

## 파일 (A_DB, 전체 F5 기준 오류 0)
| 순서 | 파일 | 성질 |
|---|---|---|
| 1 | `00_PRECHECK_CLOUD.sql` | 읽기 전용 — PROC_M 9행 · ALL_ARGUMENTS · API 배선 |
| 2 | `10_APPLY_PROCM_USERID.sql` | 백업(SCM_ADM_PROC_M_BAK20261028_S096, 최초 1회) + UPDATE. 멱등(재실행 0건) · 비파괴 · 수정 전 값 WHERE 미사용 |
| 3 | `90_VERIFY.sql` | RESULT='PASS' 확인 |
| 롤백 | `99_ROLLBACK_PROCM_USERID.sql` | 백업값으로 되돌림. 백업 없음/백업값=userId 면 0건 |

## 사내 ZIOUI1 적용 기록 (2026-10-28 · 실행 로그 기준)
- 리허설: 99(백업 없음 0건) → 10(백업 생성·1건) → 10(0건) → 90 PASS → 99(1건 원복) → 99(0건) → 90 FAIL(원복 확인) → 10(1건) → 90 PASS
- 최종: SORT_ORD=8 COL_NM='userId' · PROC_M 9행 유지
- 기능 검증(BE makeProcedure 와 동일하게 PROC_M COL_NM 순서로 FE 실전송 payload 바인딩, 테스트 키 81/ZZ_S096_TEST/2099123x):
  - D_ 셀 2건 신규 → RESULT_CODE=S, CNT=2 · CREATED_BY/LAST_UPDATED_BY=minyonglee1
  - 같은 키 재저장(UPDATE 분기) → S, 2 · 값 반영
  - WORKING_TIME_DEFAULT(isSaveDefault=Y) → S, 1 · 7.5 저장
  - 테스트 행 삭제 OSP 2 · DEFAULT 1 → 잔존 0 (21:35:45)
- 사내 생성 객체: 백업 테이블 `SCM_ADM_PROC_M_BAK20261028_S096` (SAVE PROC_M 9행 사본)

## 클라우드 적용
00 → 10 → 90. 클라우드 SORT_ORD=8 이 이미 `userId`(원래 등록값)이면 10 은 0건이고 90 PASS 입니다.
