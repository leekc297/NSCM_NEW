# DMF0014 Excel Upload 케이스별 실측 — 20260930_1352 (form=DMF0014 sheet=FCST Upload user=minyonglee1 base=http://localhost:8080)

- 러너: `_artifacts/_diagnostics/excel_upload_case_e2e.py` · 파일: `Doc/단위테스트/_excel_upload_cases/DMF0014/`
- 판정: 기대 메시지(접미 제외)가 실측 ERROR MESSAGE_TEXT 에 포함되면 PASS · 기대가 '(정상…)' 이면 오류 0 일 때 PASS

| 케이스 | 제목 | 기대 | 실측 | 판정 |
|---|---|---|---|---|
| 00_OK | 정상 (WEEKLY · CELL · 4주 수량) | (정상 — Error 0) | (오류 없음 — SUCCESS:1) | **PASS** |
| 01_DUP | 키 10개 조합 동일 2행 | Duplication Key [Sales Site*: GM_US_BQN, Customer Project*: SGM Modified, Customer Model*: N2.2] | Duplication Key [Sales Site*: GM_US_BQN, Customer Project*: SGM Modified, Customer Model*: N2.2] | **PASS** |
| 02_DIV | Division 미등재 | Invalid Division [Division*: 99] | Invalid Division [Division*: 99] | **PASS** |
| 03_BKT | 헤더 일자 간격 DAILY (등록 WEEKLY) | Invalid Measure Upload Bucket [Measure*: Customer FCST] | Invalid Measure Upload Bucket [Measure*: Customer FCST] | **PASS** |
| 04_MUOM | Upload UOM 불일치 (등록 CELL) | Invalid Measure Upload UOM [Upload UOM*: Pack] | Invalid Measure Upload UOM [Upload UOM*: Pack] | **PASS** |
| 05_SITE | Sales Site 미등재 | Invalid Sales Site [Sales Site*: ZZ_SITE] | Invalid Sales Site [Sales Site*: ZZ_SITE] | **PASS** |
| 06_PLNT | Plant Site 미등재 | Invalid Plant Site [Plant Site*: ZZ_PLANT] | Invalid Plant Site [Plant Site*: ZZ_PLANT] | **PASS** |
| 07_CPRJ | Customer Project 미등재 ([Project]/[Model] SITE_ITEM 유효 → 통과) | (정상 — Error 0) | (오류 없음 — SUCCESS:1) | **PASS** |
| 08_CMDL | Customer Model 미등재 ([Project]/[Model] SITE_ITEM 유효 → 통과) | (정상 — Error 0) | (오류 없음 — SUCCESS:1) | **PASS** |
| 09_INCO | Incoterms 미등재 | Invalid Incoterms [Incoterms*: ZZZ] | Invalid Incoterms [Incoterms*: ZZZ] | **PASS** |
| 10_FTYP | FCST Type 미등재 | Invalid FCST Type [FCST Type*: ZZ_TYPE] | Invalid FCST Type [FCST Type*: ZZ_TYPE] | **PASS** |
| 11_CSTM | Customs Handbook 미등재 | Invalid Customs Handbook [Customs Handbook*: X] | Invalid Customs Handbook [Customs Handbook*: X] | **PASS** |
| 12_MGRP | Measure Group ≠ CUST_FCST | Invalid Measure Group [Measure Group*: PSI] | Invalid Measure Group [Measure Group*: PSI] | **PASS** |
| 13_QSTR | 기간 칸 문자 혼입 | Please Input QTY [20261012: abc] | Please Input QTY [20261012: abc] | **PASS** |
| 14_QDEC | 기간 칸 소수점 | Invalid Decimal [20261012: 130.2] | Invalid Decimal [20261012: 130.2] | **PASS** |
| 15_UOM | Upload UOM 룩업 미등재 | Invalid Upload UOM [Upload UOM*: BOX] | Invalid Upload UOM [Upload UOM*: BOX] | **PASS** |
| 16_UOMC | (Division, Sales Site, Measure) 고객 FCST 미등재 | Invalid Measure [Sales Site*: GM_US_BQN, Measure*: ZZ_MEASURE] | Invalid Measure [Sales Site*: GM_US_BQN, Measure*: ZZ_MEASURE] | **PASS** |
| 17_PRJ | [Project] DMF0005 마스터(SITE_ITEM) 미등재 · [Model] 정상 | Invalid Project [Project: ZZ_PRJCODE] | Invalid Project [Project: ZZ_PRJCODE] | **PASS** |
| 18_MDL | Model 품목 마스터(ITEM_SN) 미등재 | Invalid Model [Model: DMAT_0000066] | Invalid Model [Model: DMAT_0000066] | **PASS** |
| 19_QEMPTY | 기간 칸 빈값 (입력가능 주차) | (정상 — Error 0) | (오류 없음 — SUCCESS:1) | **PASS** |
| 20_QGRAY | 회색(입력불가) 주차 빈값 = 통과 | (정상 — Error 0) | (오류 없음 — SUCCESS:1) | **PASS** |
| 21_MULTI | 복수 오류 누적 (Incoterms + 문자 + 빈값) | Invalid Incoterms [Incoterms*: ZZZ] / Please Input QTY [20261012: abc] | Invalid Incoterms [Incoterms*: ZZZ] / Please Input QTY [20261012: abc] | **PASS** |
| 22_PMEMPTY | [Project]/[Model] 빈칸 | Invalid Project [Project: (empty)] / Invalid Model [Model: (empty)] | Invalid Project [Project: (empty)] / Invalid Model [Model: (empty)] | **PASS** |
| 23_PMDL | [Model] SITE_ITEM 조합 미등재 ([Project] 유효) | Invalid Model [Model: ZZ_ITEM] | Invalid Model [Model: ZZ_ITEM] | **PASS** |
| 24_CPMX | Customer Project 미등재 + [Project] SITE_ITEM 미등재 (두 경로 모두 불일치) | Invalid Customer Model [Customer Model*: N2.2] / Invalid Project [Project: ZZ_PRJCODE] | Invalid Customer Model [Customer Model*: N2.2] / Invalid Project [Project: ZZ_PRJCODE] | **PASS** |
| 25_CMDLX | Customer Model 미등재 + [Model] SITE_ITEM 미등재 (두 경로 모두 불일치) | Invalid Customer Model [Customer Model*: ZZ_MODEL] / Invalid Model [Model: ZZ_ITEM] | Invalid Customer Model [Customer Model*: ZZ_MODEL] / Invalid Model [Model: ZZ_ITEM] | **PASS** |
| 26_AAABBB | [Project]=AAA · [Model]=BBB (사용자 실측 재현 — 고객모델 마스터 유효) | Invalid Project [Project: AAA] / Invalid Model [Model: BBB] | Invalid Project [Project: AAA] / Invalid Model [Model: BBB] | **PASS** |

## 종합: PASS 27 / FAIL 0 / 총 27
