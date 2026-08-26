# DMF0082 — CAR/CELL 4종 SHEET_MEASURE 승계 등재 (E20260825-CARCELL, 2026-08-25)

사용자 지시: DMF0003 의 4메저(MKT FCST[R+P] CAR/CELL, RTF[R+P] CAR/CELL)를 DMF0082 에 없으면 등재.

## 적용 (사내 완료)
- 사전 실측: DMF0082(FcstNPrice) 22행 중 4종 부재 확인 → 4행 신규 MERGE
- 원값 = DMF0003/'Mkt Fcst' 행 **전 컬럼 승계** (라벨·division 토큰·DEFAULT='N'·USER_SELECTABLE='Y'·INPUT_TP_CD·ATTRIBUTE 전체)
- SORT 만 DMF0082 체계로: base 직후 — MKT_FCST(20)→CAR 21/CELL 22, RTF_SYS_RP(30)→CAR 31/CELL 32
- 논리키 MERGE (PROGRAM_ID+SHEET_NAME+COLUMN_NAME — 테이블 PK 미정의 실측) · 감사컬럼 'admin' · 멱등

## 검증 (사내)
- 원장 4행 실측 (위 값 그대로)
- Measure Setting 후보 SP `PR_GET_SHEET_MEASURE_LIST('…','DMF0082','FcstNPrice','81')` 실호출 → 후보 22종에 4종 전부 포함

## ⚠ 한계 (정직 보고)
등재 = **Measure Setting 후보 노출 + 선택 가능**까지다. `PKG_DMF0082` GET 에는 CAR/CELL **환산 산출 로직이 없어**
(그 로직은 PKG_DMF0003 전용 — LIVE 44건), 선택해도 현재는 **값 행이 산출되지 않는다**(0행).
값까지 나오게 하려면 DMF0003 의 환산 블록(ITEM_CLASS Cell/Module/Pack × CELL_PER_CAR·CELL_PER_MODULE·MODULE_PER_CAR)을
PKG_DMF0082 GET 에 이식하는 별도 작업 필요 — 사용자 지시 대기.

## 클라우드 적용
`01_SHEET_MEASURE_CARCELL.sql` 실행 (멱등 MERGE 4행 + COMMIT).
