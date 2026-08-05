# 클라우드 → 사내 Oracle 등록 대상 목록 (2026-07-28)

> 근거: TOBE_UI_DB객체_전수취합 v1.1 — UI 사용분 중 사내 OCGSCMD_P01 미존재 객체.
> 사용자 확정(2026-07-28): 클라우드에서 가져와 사내 등록 예정. xlsx 시트1 에 '미존재→클라우드 등록 예정' 연결경로로 편입됨.

## A. 클라우드에서 가져올 대상 — ⭐ 2026-07-29 최종 = C4 단독

> 클라우드 PRECHECK 실측(01_PRECHECK_CLOUD.sql) + 사용자 확정으로 범위 축소.

| # | 객체 | 클라우드 실측 | 최종 처리 |
|---|---|---|---|
| ~~C1~C3~~ | ~~P_SCM0008_ADD/REQUEST/DELETE_MY_AUTH~~ | **클라우드에도 실체 없음** (SCMD_APP/SCMP_APP dangling SYNONYM 만) | **제외 (사용자 확정: 불필요)** — SYS0011 버튼 3종 배선 정리는 별도 결정 |
| C4 | `PKG_SYS0014` SPEC+BODY | VALID 존재 → **추출 완료** | `_deploy_packages/CLOUD_DDL_FETCH_20260729/C4_PKG_SYS0014.sql` 사내 등록 |
| ~~C5~~ | ~~SCM_SYS_FILE~~ | **클라우드에도 미존재** | **제외 (사용자 확정)** — 필요 시 리포 baseline `_artifacts/G5_file_transfer_metadata.sql` |

등록 시 표준(C4): SPEC→BODY 순서, VALID 확인, SCMD_APP GRANT EXECUTE(+SYNONYM 확인), PROC_M positional 대조.

## B. 클라우드 불필요 — 사내 메타 조치 대상 (3건)

| # | 조치 | 상세 |
|---|---|---|
| B1 | `SCM_ADM_EXCEL_COLUMNS` UPDATE (DMF0082) | STORAGE_SQL_ID `DMF0082_EXCEL_UPLOAD` → `PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD` (PKG 취합 때 standalone DROP — 스테일) |
| B2 | `SCM_ADM_EXCEL_COLUMNS` UPDATE (DMF0003 Car Fcst) | STORAGE_SQL_ID `DMF0003_CAR_FCST_EXCEL_UPLOAD` → `PKG_DMF0003.P_DMF0003_CAR_FCST_EXCEL_UPLOAD` (동일 패턴) |
| B3 | SYS0016 API_M/BTN_MPG 등록 | notice-setup 배선 0건 — DB 실존 SP(SCM0010_GET/SAVE_NOTICE_* 등) 배선 필요 |

## C. 축외 참고 — 등록 불요 판단 (8건, legacy API_ID 만 잔존)

`P_SCM0005_SAVE_USER_GROUP` / `P_SCM0008_GET_AUTH_GROUP_INFO` / `P_SCM0008_GET_DIVISION_LIST` / `P_SCM0008_GET_MY_AUTH_LIST` / `P_SCM0008_GET_CURRENT_USER` / `P_SCM0009_GET_APPROVAL_LIST` / `P_SCM0009_APPROVE_AUTH` / `P_SCM0009_REJECT_AUTH`
— FE 미배선(BTN_MPG 없음), SYS0011/SYS0012 PKG 로 대체 구현 완료. API_M 의 legacy 행만 잔존.
