# DMF0014_VALIDATION_MSG_20260923 — Excel Upload 검증 메시지 시인성 보완 [E20260923-DMF0014VALMSG]

## 요청 (사용자 2026-09-23)
- 실제 입력값 기준으로 오류 지점을 정확히 표기 — 컬럼별 문제 발생 시 문제 컬럼을 지정
- 동적(기간) 구간: 숫자 아닌 문자 → 정확한 메시지, 값 없음 → **"Please Input QTY"** (사용자 지정 문구)
- **FE/BE 무변경 — DB 객체(PKG_DMF0014 BODY 메인 프로시저) 수정만**. `_SM` 프로시저는 미배선(PROC_M·DB 소스·BE 참조 0) → 무변경

## 메시지 규격
`<규칙명> [<헤더 라벨>: <입력값>]` — 헤더 라벨 = 사용자 파일 헤더행(V_TITLE) 실측값, 빈값 = `(empty)`.
기간 칸은 `[YYYYMMDD: 값]`. 한 행의 사유는 실행 순서대로 ` / ` 누적(MESSAGE_TEXT 4000 보호 — 기간 칸 31개 이상이면 30개 + `... (+N more)`).
연쇄 오류 가드: 상위 검증(Division → Sales Site → Customer Project → Customer Model …) 통과 행에만 하위 검증을 적용해 **1행 = 근본 원인만** 표기 (반려 집합 불변).

## 작업 전 / 작업 후 Validation 목록 비교
| # | ID | 검증 | 대상 컬럼 | 작업 전 메시지 (2026-09-15 21:01 라이브) | 작업 후 메시지 (2026-09-23) | 변경 | 비고 |
|--:|---|---|---|---|---|---|---|
| 1 | FORM | 양식(헤더) 불일치 | 헤더행 1~13열 | Invalid Excel Form. | Invalid Excel Form. | 무변경 | 즉시 반려(ERR_RTN) 구조 그대로 |
| 2 | DUP | 키 중복 | ATTRIBUTE1~10 | Duplication Key - 동일 키 행이 중복되었습니다. 중복 행을 하나로 합쳐주세요. | Duplication Key [Sales Site*: 값, Customer Project*: 값, Customer Model*: 값] | 규격 통일 | 중복 행 전부 표기 |
| 3 | DIV | Division | Division* | Invalid Division - 유효하지 않은 Division 입니다. [Division*] 확인 | Invalid Division [Division*: 값] | 규격 통일 |  |
| 4 | BKT | Measure 업로드 버킷 | Measure* + 헤더 일자 간격 | Invalid Measure Upload Bucket - Measure 의 업로드 버킷 설정과 맞지 않습니다. [Measure*]/기간 컬럼 확인 | Invalid Measure Upload Bucket [Measure*: 값] | 규격 통일 + 가드 | Sales Site·(Site,Measure) 마스터 통과 행만 — 종전엔 Sales Site 오류가 이 메시지로 먼저 잡혔음(마스킹) |
| 5 | MUOM | Measure 업로드 UOM | Upload UOM* | Invalid Measure Upload UOM - Measure 에 허용되지 않은 단위입니다. [Upload UOM*] 확인 | Invalid Measure Upload UOM [Upload UOM*: 값] | 규격 통일 + 가드 | 룩업 등재 UOM 만 대상(미등재는 #18 이 담당) |
| 6 | SITE | Sales Site | Sales Site* | Invalid Sales Site - 등록되지 않은 Sales Site 입니다. [Sales Site*] 확인 | Invalid Sales Site [Sales Site*: 값] | 규격 통일 + 가드 | Division 통과 행만 |
| 7 | PLNT | Plant Site (Div 81) | Plant Site* | Invalid Plant Site - 등록되지 않은 Plant Site 입니다. [Plant Site*] 확인 | Invalid Plant Site [Plant Site*: 값] | 규격 통일 + 가드 | Division 통과 행만 |
| 8 | CPRJ | Customer Project (Div≠40) | Customer Project* | (전용 메시지 없음 — Customer Model 조합 검증에 흡수되어 'Invalid Customer Model' 로 표기) | Invalid Customer Project [Customer Project*: 값] | 신설(분리) | 반려 집합은 종전과 동일 — 메시지만 분리. (Division,Site,Customer Project) 가 고객모델 마스터에 없고 [Project]/[Model] 품목경로로도 구제 안 되는 행 |
| 9 | CMDL | Customer Model (Div≠40) | Customer Model* | Invalid Customer Model - 등록되지 않은 Customer Model 이거나 [Project]/[Model] 이 품목 마스터(Site Item)에 없습니다. [Customer Model*]/[Project]/[Model] 확인 | Invalid Customer Model [Customer Model*: 값] | 규격 통일 + 가드 | Sales Site·Customer Project 통과 행만 |
| 10 | MDL | Model 품목 마스터 (Div≠40) | Model (또는 Customer Model 의 품목) | Invalid Model - 품목 마스터(Item)에 없는 Model 입니다. [Model] 확인 | Invalid Model [Model: 실제 대조한 품목] | 규격 통일 + 가드 | Customer Model 또는 품목경로 통과 행만 |
| 11 | CSTM | Customs Handbook (Div≠40) | Customs Handbook* | Invalid Customs Handbook - 등록되지 않은 Customs Handbook 입니다(D/E). [Customs Handbook*] 확인 | Invalid Customs Handbook [Customs Handbook*: 값] | 규격 통일 |  |
| 12 | INCO | Incoterms | Incoterms* | Invalid Incoterms - 등록되지 않은 Incoterms 입니다. [Incoterms*] 확인 | Invalid Incoterms [Incoterms*: 값] | 규격 통일 |  |
| 13 | FTYP | FCST Type | FCST Type* | Invalid FCST Type - 등록되지 않은 FCST Type 입니다. [FCST Type*] 확인 | Invalid FCST Type [FCST Type*: 값] | 규격 통일 |  |
| 14 | MGRP | Measure Group | Measure Group* | Invalid Measure Group - 등록되지 않은 Measure Group 입니다. [Measure Group*] 확인 | Invalid Measure Group [Measure Group*: 값] | 규격 통일 |  |
| 15 | QSTR | 기간 칸 — 문자 | 동적 기간 칸(YYYYMMDD 헤더) | Invalid Quantity - 수량 칸에 숫자가 아닌 값이 있습니다. 문자/기호를 지우고 숫자만 입력해주세요. (행 1건 — 어느 칸인지 미표기) | Invalid Numeric [YYYYMMDD: 값]  ← 문제 칸마다 | 셀 단위 전환 | 기간(헤더 일자) + 입력값 표기 |
| 16 | QDEC | 기간 칸 — 소수점 | 동적 기간 칸 | Invalid Quantity - (문자 검증과 같은 문구 — 구분 불가) | Invalid Decimal [YYYYMMDD: 값]  ← 문제 칸마다 | 셀 단위 전환 | 정수만 허용(E20230119-000186) 유지 |
| 17 | QEMPTY | 기간 칸 — 빈값 | 동적 기간 칸(입력가능 주차) | (검증 없음 — 빈 칸은 적재에서 제외되어 조용히 통과) | Please Input QTY [YYYYMMDD]  ← 빈 칸마다 | 신설 | 사용자 지정 문구(2026-09-23). 회색(입력불가) 주차는 GRAYZERO 정책상 0 적재라 검사 제외 |
| 18 | UOM | Upload UOM 룩업 | Upload UOM* | Invalid Upload UOM - 등록되지 않은 Upload UOM 입니다. [Upload UOM*] 확인 | Invalid Upload UOM [Upload UOM*: 값] | 규격 통일 | 종전엔 #5 가 먼저 잡아 'Invalid Measure Upload UOM' 으로 표기(마스킹) — 해소 |
| 19 | UOMC | (Division, Sales Site, Measure) 고객 FCST 마스터 | Sales Site* + Measure* | Invalid Upload UOM (Customer FCST) - 허용되지 않은 단위입니다. [Upload UOM*] 확인 | Invalid Measure [Sales Site*: 값, Measure*: 값] | 개명 + 가드 | UOM 오류로 오독되던 명칭 정정. 종전엔 #4 가 먼저 잡음(마스킹) — 해소. Sales Site 통과 행만 |
| 20 | PRJ | Project 조합 (AS-IS 주석) | Project | (사문 — AS-IS /* */ 파리티) | (사문 유지) | 무변경 | 부활 = 명세 변경, 사용자 의사결정 대기 |
| 21 | RTN | 검증 결과 반환 | O_RESULT_CURSOR | ERR_RTN: - Validation Check | ERR_RTN: - Validation Check | 무변경 | 행별 사유는 MESSAGE_TEXT 에 ' / ' 누적(E20260911-DMF0014MULTI 유지) |

## 적용·검증 (사내 ZIOUI1 · 2026-09-23 10:58:50)
- FRESH-GATE 통과 → PKG_DMF0014 BODY **VALID · USER_ERRORS 0 · 적용본 == DB** · 마커 `E20260923-DMF0014VALMSG` 29곳 · INVALID 총 34 = 기존분(타 작업 PKG_SSP0023 09:06 외 전부 이전 — 이번 적용과 무관)
- 메인 프로시저 3,399 → 3,303 줄 (UNPIVOT 집계 2블록 → MERGE 1블록)
- **E2E 22/22 PASS** (`_artifacts/_gate_reports/DMF0014_excel_upload_cases_20260923_1059.md`, 러너 `excel_upload_case_e2e.py`, 로컬 BE + 실계정 minyonglee1)
  - 신규 케이스: 19_QEMPTY(Please Input QTY 2칸) · 20_QGRAY(회색 주차 빈값 = 통과) · 21_MULTI(Incoterms + 문자 + 빈값 3건 누적) · 18_MDL(SITE_ITEM 경로 품목 미등재)
  - 정정 케이스: 07_CPRJ/08_CMDL — 기준행 Project/Model 이 SITE_ITEM 유효라 품목 경로로 구제되므로 함께 무효화(09-15 MSTCHK 이후 현행 규칙)
- 회귀: 정상 샘플 10건 `DMF0014_Upload_Sample10_20260915.xlsx` → Success 10 / Error 0
- 저장 경로(P_MODE=1 적재·MKT FCST 반영)는 **무변경 코드** — 이번 회차 재실행하지 않음(사내 원장 오염 회피)

## 파일
- `00_BACKUP_ASIS/PKG_DMF0014_BODY.ASIS.sql` — 적용 전 원문(SOURCE-FRESH 스탬프) · 원복 = `python apply_valmsg.py restore`
- `01_APPLY/PKG_DMF0014_BODY.sql` — 적용본
- `apply_valmsg.py` — backup(원문 재조회+패치 생성) / apply(FRESH-GATE+컴파일 검증) / restore
- 케이스: `Doc/단위테스트/_excel_upload_cases/DMF0014/*.xlsx` (22본, 생성기 `gen_excel_upload_testcases.py` — 일자 동적, 시효 = 생성 주 +1주)
- 비교표 xlsx: `Doc/화면분석서/DMF0014_Excel_Upload_Validation_Rules_v3_20260923.xlsx`
- 클라우드 이관: `_artifacts/_deploy_packages/DMF0014_VALMSG_CLOUD_20260923/`
