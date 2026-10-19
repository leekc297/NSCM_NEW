# DMF0014 Excel Upload 케이스별 실측 — 20260914_1005 (form=DMF0014 sheet=FCST Upload user=minyonglee1 base=http://localhost:8080)

- 러너: `_artifacts/_diagnostics/excel_upload_case_e2e.py` · 파일: `Doc/단위테스트/_excel_upload_cases/DMF0014/`
- 판정: 기대 메시지(접미 제외)가 실측 ERROR MESSAGE_TEXT 에 포함되면 PASS · 기대가 '(정상…)' 이면 오류 0 일 때 PASS

| 케이스 | 제목 | 기대 | 실측 | 판정 |
|---|---|---|---|---|
| 00_OK | 정상 (WEEKLY · CELL · 4주 수량) | (정상 — Error 0) | (오류 없음 — SUCCESS:1) | **PASS** |
| 01_DUP | 키 10개 조합 동일 2행 | Duplication Key. | Duplication Key - 동일 키 행이 중복되었습니다. 중복 행을 하나로 합쳐주세요. | **FAIL** |
| 02_DIV | Division 미등재 | Invalid Division. | Invalid Division - 유효하지 않은 Division 입니다. [Division*] 확인 / Invalid Measure Upload Bucket - Measure 의 업로드 버킷 설정과 맞지 않습니다. [Measure*]/기간 컬럼 확인 / Invalid Measure Upload UOM - Measure 에 허용되지 않은 단위입니다. [Upload UOM*] 확인 / Invalid Sales Site - 등록되지 않은 Sales Site 입니다. [Sales Site*] 확인 / Invalid Customer Model - 등록되지 않은 Customer Model 입니다. [Customer Model*] 확인 / Invalid Upload UOM (Customer FCST) - 허용되지 않은 단위입니다. [Upload UOM*] 확인 | **FAIL** |
| 03_BKT | 헤더 일자 간격 DAILY (등록 WEEKLY) | Invalid Measure Upload Bucket. | Invalid Measure Upload Bucket - Measure 의 업로드 버킷 설정과 맞지 않습니다. [Measure*]/기간 컬럼 확인 | **FAIL** |
| 04_MUOM | Upload UOM 불일치 (등록 CELL) | Invalid Measure Upload UOM. | Invalid Measure Upload UOM - Measure 에 허용되지 않은 단위입니다. [Upload UOM*] 확인 | **FAIL** |
| 05_SITE | Sales Site 미등재 | Invalid Measure Upload Bucket. | Invalid Measure Upload Bucket - Measure 의 업로드 버킷 설정과 맞지 않습니다. [Measure*]/기간 컬럼 확인 / Invalid Measure Upload UOM - Measure 에 허용되지 않은 단위입니다. [Upload UOM*] 확인 / Invalid Sales Site - 등록되지 않은 Sales Site 입니다. [Sales Site*] 확인 / Invalid Customer Model - 등록되지 않은 Customer Model 입니다. [Customer Model*] 확인 / Invalid Upload UOM (Customer FCST) - 허용되지 않은 단위입니다. [Upload UOM*] 확인 | **FAIL** |
| 06_PLNT | Plant Site 미등재 | Invalid Plant Site. | Invalid Plant Site - 등록되지 않은 Plant Site 입니다. [Plant Site*] 확인 | **FAIL** |
| 07_CPRJ | Customer Project 미등재 | Invalid Customer Model. | Invalid Customer Model - 등록되지 않은 Customer Model 입니다. [Customer Model*] 확인 | **FAIL** |
| 08_CMDL | Customer Model 미등재 | Invalid Customer Model. | Invalid Customer Model - 등록되지 않은 Customer Model 입니다. [Customer Model*] 확인 | **FAIL** |
| 09_INCO | Incoterms 미등재 | Invalid Incoterms. | Invalid Incoterms - 등록되지 않은 Incoterms 입니다. [Incoterms*] 확인 | **FAIL** |
| 10_FTYP | FCST Type 미등재 | Invalid Sales Type. | Invalid FCST Type - 등록되지 않은 FCST Type 입니다. [FCST Type*] 확인 | **FAIL** |

## 종합: PASS 1 / FAIL 10 / 총 11
