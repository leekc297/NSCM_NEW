# SSP 흐름 산출물 — 2026-11-09 11:16 · 생성기 `tools/Analysis/ssp_flow.py`

## 원천·방법
- 화면→SP: `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx`(SSP 608행) + `Doc/asisfacts/screens/SSP*/endpoints.csv`(39 팩트팩) 합집합 · 둘의 차이는 `ssp_crosscheck.csv`
- SP→테이블: `Doc/asisfacts/db/modules/dbo.<SP>.sql` 본문 — 읽기 FROM/JOIN · 쓰기 INSERT/UPDATE/MERGE(sp_dml_check.writes)+DELETE/TRUNCATE · 중첩 EXEC 깊이 3 · 로그 SP(PR_SCM_SYS_LOG_*)는 호출만 기록
- TO-BE: `Doc/tobefacts/db/menu.csv` SSP 메뉴 19 · `proc_meta.csv` PKG 배선

## 수치(이번 생성 실측)
- 화면 39(메인 37 · 팝업 전용 2 = AS-IS 파일이 전부 Popup 폴더인 화면 · 메인 화면 소속 팝업은 popups 열) · TO-BE 메뉴 화면 19 · AS-IS 전용 20
- 테이블 실존 검증: AS-IS 객체 카탈로그 `Doc/asisfacts/db/db_objects.csv`(U/V/SN 1953) 에 없는 이름 39종(321회) 은 흐름에서 제외 = 커서·임시 표·별칭·동적 SQL 조각: A, BAL, BOH, CONFIRM_LIST, CUR_ERP_S, CUR_M, CUR_PLAN_P, CUR_SEND, CUR_SPEED_CALL_SEND, DBO, DEDUPLICATION, DEDUPLICATION2, DESC, FROM, INV_ALLO, LD, LOOK, MST_LOCATION, MST_PR_COUNT, MST_STOCK, PACKER_STOCK, PLAN_SSP, P_INV_CONFIRM, P_INV_SIM, QTY, RESULT_CHILD_QTY, RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, RESULT_OWMS, RESULT_SCS_EXIST, RETURN_OWMS, R_INV_SHIP_PLAN, R_INV_SHIP_REQ, SITE, SSP_ANL_OWMS_STOCK, SYSCURSORS, SYSOBJECTS, WH_STOCK, Z
- SP 296 · 본문 없음 24: GET_DATE_RANGE_1MONTH, SCM_SYS_GET_SITE_BY_DIVISION, SP_SEND_DBMAIL, SSP0005_SAVE_SHIPMENT_WORKING_DAY, SSP0007_GET_PRODUCTION_PLAN_MODEL_TUNING3, SSP0007_SAVE_PRODUCTION_PLAN_LINE, SSP0021_SAVE_HOLD_STOCK_DATA, SSP0026_GET_REQUEST_DETAIL_CELL, SSP0026_SAVE_SHIP_REQ_DETAIL_CELL, SSP0027_GET_SHIPMENT_REQUEST_DRAFTING, SSP0029_GET_SCS_STOCK, SSP0029_GET_SHIPMENT_CONFIRM_DETAIL_PACKER, SSP0029_GET_SHIPMENT_PSI_PACKER, SSP0029_GET_SHIPMENT_PSI_PACKER_PAST, SSP0029_GET_SHIPMENT_RESULT_PACKER, SSP0029_GET_STOCK_LOCATION_DETAIL, SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER, SSP0046_GET_BIZ_TYPE_BY_DIVISION, SSP0046_GET_DIVISION …
- 테이블 162(SSP 79 · 공통 36 · 타 도메인/인터페이스/기타 47) · 로그/이력 16
- 교차검증: endpoints 에만 있는 SP 가 있는 화면 5 · 매트릭스에만 있는 화면 35(상세 ssp_crosscheck.csv)
- 데이터 의존 간선 309 · 위상 정렬 미결(사이클) 화면 21

## 한계(명시)
- 본문 없는 SP·동적 SQL 안의 테이블은 매트릭스 참조 테이블(R?)로만 표기 · 외부 DB/링크 서버·함수 내부 테이블은 미추출 · 배치(UI 외) 가 SSP 표를 쓰는 흐름은 범위 밖(화면 기준)
- 프로세스 순서는 데이터 의존에서 도출 — 운영 절차·승인 흐름은 담당자 확인 필요

## 파일
- `SSP_FLOW.html` 뷰어(브라우저로 열기 · Mermaid · 배치 탭 포함) · `SSP_DATA_FLOW.md` · `SSP_DATA_FLOW_DETAIL.md` · `SSP_PROCESS_FLOW.md` · `ssp_screen_inventory.csv` · `ssp_screen_sp_table.csv` · `ssp_crosscheck.csv`
- 배치(`tools/Analysis/ssp_batch_flow.py` · 원천 `Doc/asisfacts/db/batch/*.csv` = `asis_batch_facts.py` 가 AS-IS msdb·SSP_INT_SYSTEMEXE 에서 추출): `SSP_BATCH_ANALYSIS.md` · `SSP_BATCH_FLOW.md` · `ssp_batch_inventory.csv` · `ssp_batch_sp_table.csv`
