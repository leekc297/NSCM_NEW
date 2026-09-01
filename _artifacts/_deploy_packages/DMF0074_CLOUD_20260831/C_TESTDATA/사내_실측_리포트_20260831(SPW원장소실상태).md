# DMF0074 Excel Upload 케이스별 실측 — 20260831_1342 (form=DMF0074_40 sheet=Metal Link Price user=minyonglee1 base=http://localhost:8080)

- 러너: `_artifacts/_diagnostics/excel_upload_case_e2e.py` · 파일: `Doc/단위테스트/_excel_upload_cases/DMF0074/`
- 판정: 기대 메시지(접미 제외)가 실측 ERROR MESSAGE_TEXT 에 포함되면 PASS · 기대가 '(정상…)' 이면 오류 0 일 때 PASS

| 케이스 | 제목 | 기대 | 실측 | 판정 |
|---|---|---|---|---|
| 00_OK-N | 정상 (Metal Link=N) | (정상 — Error 0) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 00_OK-Y | 정상 (Metal Link=Y, Ni 1종 완전입력) | (정상 — Error 0) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 01_C2 | Div 공란 | (SKIP 1건 — 오류 아님) | (오류 없음 — SKIP:1) | **PASS** |
| 02_C2 | Plan Date 공란 | NULL PLAN DATE. | NULL PLAN DATE. | **PASS** |
| 03_C2 | End Customer 공란 | NULL END CUSTOMER. | NULL END CUSTOMER. | **PASS** |
| 05_C2 | Sales Site 공란 | NULL SALES SITE. | NULL SALES SITE. | **PASS** |
| 06_C2 | Currency 공란 | NULL CURRENCY. | NULL CURRENCY. | **PASS** |
| 07_C2 | FCST type 공란 | NULL FCST TYPE. | NULL FCST TYPE. | **PASS** |
| 08_C2 | Metal Link 공란 | NULL Metal Link. | NULL Metal Link. | **PASS** |
| 09_C2 | Team 공란 (체크 제외) | (정상 — Team 은 필수 체크 제외) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 11_C4 | Metal Link=Y + Key 7종 전부 공란 | NULL APPLY PRICE TYPE CODE. | NULL APPLY PRICE TYPE CODE. | **PASS** |
| 12_C5 | Key_Ni 미등재 코드 | Invalid KEY CODE : Ni | Invalid KEY CODE : Ni | **PASS** |
| 13_C6 | Key_Co 미등재 코드 | Invalid KEY CODE : Co | Invalid KEY CODE : Co | **PASS** |
| 14_C7 | Key_Li2CO3 미등재 코드 | Invalid KEY CODE : Li2CO3 | Invalid KEY CODE : Li2CO3 | **PASS** |
| 15_C8 | Key_LIOH 미등재 코드 | Invalid KEY CODE : LIOH | Invalid KEY CODE : LIOH | **PASS** |
| 16_C9 | Key_Al 미등재 코드 | Invalid KEY CODE : Al | Invalid KEY CODE : Al | **PASS** |
| 17_C10 | Key_Mn 미등재 코드 | Invalid KEY CODE : Mn | Invalid KEY CODE : Mn | **PASS** |
| 18_C11 | Key_Cu 미등재 코드 | Invalid KEY CODE : Cu | Invalid KEY CODE : Cu | **PASS** |
| 19_C12 | 8키 동일 중복 2행 | Duplication Model. | Duplication Model. | **PASS** |
| 20_C13 | Plan Date 형식 오류 | Invalid Date Format. | Invalid Date Format. | **PASS** |
| 21_C14 | Plan Date 과거월 | Past Date. | Past Date. | **PASS** |
| 22_C15 | End Customer 미등재 | Invalid END CUSTOMER. | Invalid END CUSTOMER. | **PASS** |
| 24_C16 | Model 미등재 | Invalid MODEL. | Invalid MODEL. | **PASS** |
| 26_C18 | 제품(P) 아닌 모델 | Invalid MODEL : TYPE P. | Invalid MODEL : TYPE P. | **PASS** |
| 27_C19 | SPW 조합 불일치 (Currency 만 다름) | Invalid Sales Plan Waterfall MODEL. | Invalid Sales Plan Waterfall MODEL. | **PASS** |
| 28_C20 | Metal Link 코드 오류 | Invalid Metal Link. | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 29_C21 | Sales Site 미등재 | Invalid Sales Site. | Invalid Sales Site. | **PASS** |
| 30_C22 | Currency 미등재 | Invalid CURRENCY. | Invalid CURRENCY. | **PASS** |
| 31_C23 | FCST type 미등재 | Invalid FCST TYPE. | Invalid FCST TYPE. | **PASS** |
| 32_C24 | Exception 코드 오류 | Invalid EXCEPTION. | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 34_C26 | Key_Ni 미연동인데 값 입력 | NEED EMPTY VALUE - Ni : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 35_C27 | Key_Co 미연동인데 값 입력 | NEED EMPTY VALUE - Co : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 36_C28 | Key_Li2CO3 미연동인데 값 입력 | NEED EMPTY VALUE - Li2CO3 : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 37_C29 | Key_LIOH 미연동인데 값 입력 | NEED EMPTY VALUE - LIOH : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 38_C30 | Key_Al 미연동인데 값 입력 | NEED EMPTY VALUE - Al : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 39_C31 | Key_Mn 미연동인데 값 입력 | NEED EMPTY VALUE - Mn : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 40_C32 | Key_Cu 미연동인데 값 입력 | NEED EMPTY VALUE - Cu : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 41_C33 | Key_Ni 유효인데 5값 공란 | NULL Ni : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 42_C34 | Key_Co 유효인데 5값 공란 | NULL Co : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 43_C35 | Key_Li2CO3 유효인데 5값 공란 | NULL Li2CO3 : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 44_C36 | Key_LIOH 유효인데 5값 공란 | NULL LIOH : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 45_C37 | Key_Al 유효인데 5값 공란 | NULL Al : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 46_C38 | Key_Mn 유효인데 5값 공란 | NULL Mn : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 47_C39 | Key_Cu 유효인데 5값 공란 | NULL Cu : Period(Fr) | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 48_C40 | Period 비숫자 | Invalid NUMERIC. | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 49_C41 | Period 음수 | Negative Number. | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 50_C42 | Period 12 초과 | Invalid INTEGER 0 ~ 12. | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 51_C43 | Period(Fr) <= Period(To) | From Value must be larger than To Value. | Invalid Sales Plan Waterfall MODEL. | **FAIL** |
| 53_GATE | 오류 잔존 시 [OK] 적재 차단 | NULL PLAN DATE. | Invalid Sales Plan Waterfall MODEL. | NULL PLAN DATE. | **PASS** |

## 종합: PASS 26 / FAIL 23 / 총 49
