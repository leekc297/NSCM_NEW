# DMF0074 Excel Upload 결함 D4·D5 정정 — 사내 적용 대기 (2026-08-27)

원천: `Doc/화면분석서/DMF0074_MetalLinkPrice_ExcelUpload_Validation_v1.1.xlsx` [3_발견결함] — D1/D2/D3/D6/D7 은 2026-08-16 사내 적용 완료, **D4·D5 가 보류 상태**였던 것을 정정.

| 파일 | 내용 |
|---|---|
| `BACKUP_PKG_DMF0074_20260827_*.sql` | 정정 전 라이브 PKG_DMF0074 SPEC+BODY 전문 (ALL_SOURCE 덤프) — 원복 = 그대로 실행 |
| `PREVIEW_PKG_DMF0074_BODY.sql` | 정정 후 BODY 전문 (`CREATE OR REPLACE PACKAGE BODY` + `/`) — **배포 파일** |
| 생성 스크립트 | `_artifacts/_diagnostics/dmf0074_d4d5_apply.py` (앵커 검증 + 프리뷰 생성, `--apply` 시 직접 컴파일) |

## 정정 내용 (마커)
- **[E20260827-D4-NOLOADGUARD]** — `P_MODE>0` 인데 ①검증 오류 잔존(V_COUNT>0) → `CODE='-1' / EVENT='NOLOAD_ERRORS'` 반환·RETURN ②적재 후보(Metal Link=Y·Exception≠Y·Key 1종 이상)가 있는데 이력 적재 0건 → `CODE='-1' / EVENT='SAVE_VERIFY'`. Metal Link=N 만 있는 파일(후보 0)은 종전대로 SUCCESS/EVENT=0. 선언부 `V_LOAD_CAND` 추가. DMF0014 '허위성공 차단 ②' 계보.
- **[E20260827-D5-ORDER]** — C21(Sales Site)·C22(Currency)·C23(FCST type) 블록을 C19(Sales Plan Waterfall 조합 검증) 앞으로 이동. 판정 조건 무변경. ⚠ AS-IS(MSSQL `DMF0074_EXCEL_UPLOAD`, DDL L190308 vs L190396) 도 C19 선행 — 사용자 안내 목적의 순서 정정(사용자 요청 2026-08-27).

## ✅ 사내 적용 결과 (2026-08-27 16:17, 사용자 지시 "배포해주세요")
- `ora.py exec PREVIEW_PKG_DMF0074_BODY.sql` → OK · USER_ERRORS 0 · PACKAGE BODY VALID
- 라이브 순서 실측: C18(L1742) → **C21(L1766) → C22(L1788) → C23(L1811)** → C19(L1886) → C20 → C24 · 마커 D4 2곳(L928/L3954)·D5 1곳(L1749)
- **D5 실증**: `DMF0074_excel_upload_cases_20260827_1619.md` — 29_C21 'Invalid Sales Site.' / 30_C22 'Invalid CURRENCY.' / 31_C23 'Invalid FCST TYPE.' 로 구체화 (배포 전 1608 리포트에선 전부 C19 마스킹)
- **D4 실증**: `dmf0074_d4_gate_verify.py` — 오류 2건 잔존 배치에 [OK](P_MODE=1) 호출 → `{CODE:'-1', EVENT:'NOLOAD_ERRORS', MSG:'Validation errors remain (2 rows) - nothing loaded'}` · 원장 DM_BPS_METAL_LINK_PRICE/_H 36,873/1,551 delta 0
- 클라우드 ⛔ 미적용 — 이관 패키지 별도(본 PREVIEW 파일 = A_DB 후보)

## 적용 절차
1. `python _artifacts/_diagnostics/ora.py exec _artifacts/_apply_corporate/DMF0074_D4D5_20260827/PREVIEW_PKG_DMF0074_BODY.sql`
2. `python _artifacts/_diagnostics/ora.py errors PKG_DMF0074` → 0건 / `ALL_OBJECTS` STATUS VALID 확인
3. 재검증: `python _artifacts/_diagnostics/excel_upload_case_e2e.py DMF0074 --form DMF0074_40 --sheet "Metal Link Price"` → 29_C21/30_C22/31_C23 이 구체 메시지로 바뀌어야 함(D5), 53_GATE 는 [OK](P_MODE=1) 직접 호출 시 CODE='-1'(D4)

## ⚠ E2E 전제 (데이터 상태 — 규칙 결함 아님)
사내 DB 2026-08-27 실측: 금주 MRF(SP_W ATTRIBUTE7='Y') 버전 = 40 `SP_W_20260728_V002` / 81·82 `SP_W_20260731_V001` — **세 버전 모두 PLAN_C/RESULT_C 0행**. 데이터가 있는 40 버전은 `SP_W_20260820_V002`(MRF='N', PLAN_C 28,085행). 따라서 현재는 C19 가 전건을 'Invalid Sales Plan Waterfall MODEL.' 로 반려해 C20 이후 검증이 관측되지 않는다(배포 전 baseline: `_artifacts/_gate_reports/DMF0074_excel_upload_cases_20260827_1608.md` — C2~C18 24/24 PASS, C19 이후 마스킹). MRF 버전에 SPW 원장이 적재되면(또는 검증 창에서 `SP_W_20260820_V002` ATTRIBUTE7 을 'Y' 로 임시 전환 후 원복) 나머지 케이스가 관측된다.
