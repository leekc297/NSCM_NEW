# DMF0014 Excel Upload 케이스별 실측 — 20260827_1606 (form=DMF0014 sheet=FCST Upload user=minyonglee1 base=http://localhost:8080)

- 러너: `_artifacts/_diagnostics/excel_upload_case_e2e.py` · 파일: `Doc/단위테스트/_excel_upload_cases/DMF0014/`
- 판정: 기대 메시지(접미 제외)가 실측 ERROR MESSAGE_TEXT 에 포함되면 PASS · 기대가 '(정상…)' 이면 오류 0 일 때 PASS

| 케이스 | 제목 | 기대 | 실측 | 판정 |
|---|---|---|---|---|
| 00_OK | 정상 (WEEKLY · CELL · 4주 수량) | (정상 — Error 0) | (오류 없음 — SUCCESS:1) | **PASS** |
| 01_DUP | 키 10개 조합 동일 2행 | Duplication Key. | Duplication Key. | **PASS** |
| 02_DIV | Division 미등재 | Invalid Division. | Invalid Division. | **PASS** |
| 03_BKT | 헤더 일자 간격 DAILY (등록 WEEKLY) | Invalid Measure Upload Bucket. | Invalid Measure Upload Bucket. | **PASS** |
| 04_MUOM | Upload UOM 불일치 (등록 CELL) | Invalid Measure Upload UOM. | Invalid Measure Upload UOM. | **PASS** |
| 05_SITE | Sales Site 미등재 | Invalid Scm Site. | Invalid Measure Upload Bucket. | **FAIL** |
| 06_PLNT | Plant Site 미등재 | Invalid Plant Site. | Invalid Plant Site. | **PASS** |
| 07_CPRJ | Customer Project 미등재 | Invalid Customer Project. | Invalid Customer Model. | **FAIL** |
| 08_CMDL | Customer Model 미등재 | Invalid Customer Model. | Invalid Customer Model. | **PASS** |
| 09_INCO | Incoterms 미등재 | Invalid Incoterms. | Invalid Incoterms. | **PASS** |
| 10_FTYP | FCST Type 미등재 | Invalid Sales Type. | Invalid Sales Type. | **PASS** |
| 11_CSTM | Customs Handbook 미등재 | Invalid Customs Handbook | (오류 없음 — SUCCESS:1) | **FAIL** |
| 12_MGRP | Measure Group ≠ CUST_FCST | Invalid Measure Group. | Invalid Measure Group. | **PASS** |
| 13_QSTR | 수량 문자 혼입 | This file contains invalid quantity data such as 'Alphabet', 'NUMBER', etc. (e.g. a, b, c, 130.2, 50.4 ...). | This file contains invalid quantity data such as 'Alphabet', 'NUMBER', etc. (e.g. a, b, c, 130.2, 50.4 ...). | **PASS** |
| 14_QDEC | 수량 소수점 | This file contains invalid quantity data such as 'Alphabet', 'Decimal', etc. (e.g. a, b, c, 130.2, 50.4 ...). | This file contains invalid quantity data such as 'Alphabet', 'Decimal', etc. (e.g. a, b, c, 130.2, 50.4 ...). | **PASS** |
| 15_UOM | Upload UOM 룩업 미등재 | Invalid Upload UOM. | Invalid Measure Upload UOM. | **FAIL** |
| 16_UOMC | (Division, Sales Site, Measure) 고객 FCST 미등재 | Invalid Upload UOM Costomer FCST. | Invalid Measure Upload Bucket. | **FAIL** |
| 17_PRJ | Project 조합 미등재 | Invalid Project. | (오류 없음 — SUCCESS:1) | **FAIL** |
| 18_MDL | Model 조합 미등재 | Invalid Model. | (오류 없음 — SUCCESS:1) | **FAIL** |

## 종합: PASS 12 / FAIL 7 / 총 19
