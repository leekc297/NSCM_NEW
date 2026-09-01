# DMF0014 Excel Upload Validation — 클라우드 확인 절차 (2026-08-31)

> 원장 REQ:CHAT-20260831-14 · 사내 실측 19/19 PASS (`사내_실측_리포트_20260831.md`)

## 파일

| 경로 | 용도 |
|---|---|
| `cases/00_OK.xlsx ~ 18_MDL.xlsx` (19본) | **실제 업로드용 단일 시트 파일** — 이것으로 순차 진행 |
| `DMF0014_ExcelUpload_ValidationCases_20260831.xlsx` | 00_INDEX(케이스·기대 메시지·비고) + 케이스별 시트 — 열람/대조용. ⚠ **업로드 금지** (BE 는 워크북의 첫 번째 시트만 읽으므로 이 통합본을 올리면 00_INDEX 가 파싱됨 — 구 시트에서 "다른 오류"로 보인 혼선의 한 원인) |

## 진행 방법 (순차)

1. Customer FCST Upload(DMF0014) 화면 → [Upload] → `cases/NN_XXX.xlsx` 선택 (00 → 18 순서)
2. 그리드 MESSAGE_TEXT 를 `00_INDEX` 의 **기대 메시지** 열과 대조 — 기대값은 **현행 SP 실측 기준**으로 정정본 (2026-08-31)
3. 일자 헤더 = 2026-09-07(월) 시작 4주 — **2026-09-06 까지 유효**. 그 후엔 `python _artifacts/_diagnostics/gen_excel_upload_testcases.py` 재실행으로 재생성

## 기대 결과 요약 (19케이스)

| 구분 | 케이스 | 기대 |
|---|---|---|
| 정상 | 00_OK | 오류 0 (SUCCESS) |
| 의도 오류 12건 | 01_DUP·02_DIV·03_BKT·04_MUOM·06_PLNT·08_CMDL·09_INCO·10_FTYP·12_MGRP·13_QSTR·14_QDEC + 07_CPRJ(Invalid Customer Model 로 검출) | INDEX 의 기대 메시지 1:1 |
| 순서 마스킹 3건 | 05_SITE·15_UOM·16_UOMC | 앞선 검증(BKT/MUOM) 메시지 — SP 조기종료 구조상 정상 |
| 규칙 사문 3건 | 11_CSTM·17_PRJ·18_MDL | **오류 없이 SUCCESS** — 라이브 SP 에서 규칙 주석 처리 상태. 부활 여부 = 의사결정 대기 |

## ⚠ 클라우드 전제

- 본 패키지 `A_DB` 적용 완료 후 테스트 (특히 `11_PKG_DMF0014_BODY`(08-27 16:51 본) + `14_PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40`(08-27 20:14 본 — 구 0827 패키지엔 구본) + `25_EXCEL_COLUMNS`(HEADER_CONTENT 파이프 수 — 불일치 시 기간 컬럼 전부 빈값 계보))
- 기준행 마스터 앵커: (81, GM_US_BQN, 'Customer FCST') = WEEKLY·CELL 등록, CUSTOMER_MODEL (SGM Modified, N2.2), PLANT EG01_81-W — 클라우드 원장에 이 조합이 없으면 00_OK 부터 마스터 오류가 나며, 그 경우 클라우드 데이터로 앵커 교체 필요 (90_VERIFY 말미 앵커 확인 쿼리 참조)
