# SSP 흐름 산출물 — 2026-11-23 13:44 · 생성기 `tools/Analysis/ssp_flow.py`

## 기존 분석 자료 반영(2026-11-11)
- `SSP_REF_PROCESS.md` = PI SSP CUTOFF Process 단계 박스 26개(Seq 1-1 ~ 22 · 흐름 간선 28 · 풀지 못한 줄기 0) · 통합테스트 112건 · 운영 SSP 잡 46 · 교차검증 789행(`ssp_ref_crosscheck.csv`) · 화면 연계 `ssp_ref_screen_links.csv` · 원천 사본 `Doc/asisfacts/ref_ssp/src/`

## 한눈에 보기(2026-11-16)
- `SSP_OVERVIEW.md` = SSP Manual Master Flow 단계 10 · 화살표 9(AS-IS SP 본문 데이터 연결 확인 8) · 매뉴얼 장 10 · 자주 받는 문의 5건 · 배치 진행 조건 14묶음 · `ssp_master_steps.csv` · `ssp_master_crosscheck.csv` · 원천 `Doc/asisfacts/ref_ssp/src/Standard Information SSP Manual 1.pptx`
- 프로세스 PPT = 2026-11-20 판(10장 · 8번 「SSP 각 사업부별 계획기준」·「재고별 I/F 기준 일자」 추가)으로 교체 · 11-16 판 사본 `src/SSP 프로세스 확인 내용_20261116.pptx` · 11-11 판 사본 `src/SSP 프로세스 확인 내용_20261111.pptx` · 진행 조건 표 `ssp_ref_run_conditions.csv` · 계획기준 표 본문 대조 = 업무 프로세스 탭 6-6

- `SSP_SHIPPLAN_FLOW.md` = 사업부별 Shipment Plan 산출 흐름(흐름도 슬라이드 10 · 단계 카드 28 · 단계별 상세 39행 · AS-IS 본문 대조 39행 중 일치 38) · `ssp_shipplan_steps.csv` · `ssp_shipplan_crosscheck.csv`

## 범위
- AS-IS SSP 화면 ∪ TO-BE Shipping 메뉴(Shipping Master · Shipping Schedule) 아래 전 화면 = 43화면(TO-BE 23) · 접두가 SSP 가 아닌 Shipping 메뉴 화면 포함: DMF0045, SCP0005, SCP0028, SCP0033 (11-10 사용자 지적으로 범위 보정)

## 원천·방법
- 화면→SP: `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx`(범위 내 637행) + `Doc/asisfacts/screens/<화면>/endpoints.csv`(Fact Pack 43) 합집합 · 둘의 차이는 `ssp_crosscheck.csv`
- SP→테이블: `Doc/asisfacts/db/modules/dbo.<SP>.sql` 본문 — 읽기 FROM/JOIN · 쓰기 INSERT/UPDATE/MERGE(sp_dml_check.writes)+DELETE/TRUNCATE · 중첩 EXEC 깊이 3 · 로그 SP(PR_SCM_SYS_LOG_*)는 호출만 기록
- TO-BE: `Doc/tobefacts/db/menu.csv` Shipping 메뉴 23 · `proc_meta.csv` PKG 배선

## 수치(이번 생성 실측)
- 화면 43(메인 41 · 팝업 전용 2 = AS-IS 파일이 전부 Popup 폴더인 화면 · 메인 화면 소속 팝업은 popups 열) · TO-BE 메뉴 화면 23 · AS-IS 전용 20
- 테이블 실존 검증: AS-IS 객체 카탈로그 `Doc/asisfacts/db/db_objects.csv`(U/V/SN 1953) 에 없는 이름 40종(332회) 은 흐름에서 제외 = 커서·임시 표·별칭·동적 SQL 조각: A, BAL, BOH, CONFIRM_LIST, CUR_ERP_S, CUR_M, CUR_PLAN_P, CUR_SEND, CUR_SPEED_CALL_SEND, DBO, DEDUPLICATION, DEDUPLICATION2, DESC, FROM, INV_ALLO, LD, LOOK, MST_LOCATION, MST_PR_COUNT, MST_STOCK, PACKER_STOCK, PLAN_SSP, P_INV_CONFIRM, P_INV_SIM, QTY, R, RESULT_CHILD_QTY, RESULT_ERP_C_EXIST, RESULT_ERP_C_NON, RESULT_OWMS, RESULT_SCS_EXIST, RETURN_OWMS, R_INV_SHIP_PLAN, R_INV_SHIP_REQ, SITE, SSP_ANL_OWMS_STOCK, SYSCURSORS, SYSOBJECTS, WH_STOCK, Z
- SP 308 · 본문 없음 22: GET_DATE_RANGE_1MONTH, SCM_SYS_GET_SITE_BY_DIVISION, SP_SEND_DBMAIL, SSP0007_SAVE_PRODUCTION_PLAN_LINE, SSP0008_SAVE_PRODUCTION_PLAN_LINE_ROW, SSP0021_SAVE_HOLD_STOCK_DATA, SSP0026_GET_REQUEST_DETAIL_CELL, SSP0026_SAVE_SHIP_REQ_DETAIL_CELL, SSP0027_GET_SHIPMENT_REQUEST_DRAFTING, SSP0029_GET_SCS_STOCK, SSP0029_GET_SHIPMENT_PSI_PACKER, SSP0029_GET_SHIPMENT_PSI_PACKER_PAST, SSP0029_GET_SHIPMENT_RESULT_PACKER, SSP0029_GET_STOCK_LOCATION_DETAIL, SSP0029_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER, SSP0029_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER, SSP0046_GET_BIZ_TYPE_BY_DIVISION, SSP0046_GET_DIVISION, SSP0046__GET_SITE_BY_DIVISION, SSP0060_SAVE_HOLD_STOCK_DATA …
- 테이블 170(SSP 79 · 공통 37 · 타 도메인/인터페이스/기타 54) · 로그/이력 21
- 교차검증: endpoints 에만 있는 SP 가 있는 화면 10 · 매트릭스에만 있는 화면 37(상세 ssp_crosscheck.csv)
- 데이터 의존 간선 358 · 위상 정렬 미결(사이클) 화면 22

## 한계(명시)
- 본문 없는 SP·동적 SQL 안의 테이블은 매트릭스 참조 테이블(R?)로만 표기 · 외부 DB/링크 서버·함수 내부 테이블은 미추출 · 배치(UI 외) 가 SSP 표를 쓰는 흐름은 범위 밖(화면 기준)
- 프로세스 순서는 데이터 의존에서 도출 — 운영 절차·승인 흐름은 담당자 확인 필요

## 화면 구성(2026-11-23 인식성 보완)
- `SSP_FLOW.html` = 왼쪽 목차(묶음 6 · 항목 48) + 절 단위 본문. 묶음 순서 = 전체 지도, 업무 순서, 계획 산출, 배치, 화면과 데이터, 근거와 대조. 목차 대응표 `tools/Analysis/ssp_shell.py` NAV, 화면 동작 `ssp_flow_shell.js`
- 새 그림(`tools/Analysis/ssp_svg.py`, baoyu-diagram skill 규칙 SVG): SSP 전체 지도, PI 프로세스 맵(슬라이드 배치), 운영 잡 하루 시간표. 격자 표: 단계 × 엔터티, 외부 ↔ SSP 데이터, 배치 그룹 ↔ 엔터티 ↔ 화면 2종, 외부 인터페이스, 쓰는 화면 × 읽는 화면. 기존 자동 배치 그래프는 각 절의 「그래프로 보기」 안에 있음
- `diagrams/` = 단독 SVG 3종 + 편집용 .drawio, PNG(이번 생성 7개: ssp_map.drawio, ssp_pi.drawio, ssp_stage_flow.drawio, ssp_batch_base.drawio, ssp_map@2x.png, ssp_pi@2x.png, ssp_time@2x.png). .drawio 는 drawio skill 변환 스크립트, PNG 는 baoyu-diagram skill main.ts 로 만듦

## 파일
- `SSP_FLOW.html` 뷰어(브라우저로 열기 · Mermaid · 배치 탭 포함) · `SSP_DATA_FLOW.md` · `SSP_DATA_FLOW_DETAIL.md` · `SSP_PROCESS_FLOW.md` · `ssp_screen_inventory.csv` · `ssp_screen_sp_table.csv` · `ssp_crosscheck.csv`
- 배치(`tools/Analysis/ssp_batch_flow.py` · 원천 `Doc/asisfacts/db/batch/*.csv` = `asis_batch_facts.py` 가 AS-IS msdb·SSP_INT_SYSTEMEXE 에서 추출): `SSP_BATCH_ANALYSIS.md` · `SSP_BATCH_FLOW.md` · `ssp_batch_inventory.csv` · `ssp_batch_sp_table.csv`
