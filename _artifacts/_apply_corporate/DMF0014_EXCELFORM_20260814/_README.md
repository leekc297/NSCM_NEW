# DMF0014 (Customer FCST Upload) — Excel Form 신설 (2026-08-14)

> 근거 룰: **hook #135 `excel-form-upload-standard`** (사용자 명시 2026-08-14 —
> "EXCEL UPLOAD 기능이 있는 경우 DMF0082 의 EXCEL FORM/EXCEL UPLOAD 양식을 기본 RULE 로").
> 정본 = DMF0082(Fcst&Price MGMT). **사내 적용 완료 · 클라우드 미적용.**

## 착수 전 실측 (구현 범위 확정)

| 항목 | DMF0014 현황 | 조치 |
|---|---|---|
| Excel Upload | ✅ 존재 | — |
| **Upload 2단 처리** | ✅ **이미 적용됨**(2026-07-10 — `FcstUploadModal onSave` → `UPLOAD_SAVE` call-proc, `P_MODE=1`) | 신설 없음(룰 §2 충족 확인만) |
| **Excel Form** | ⛔ **부재** — SP·API·버튼 배선 전무 | ⭐ **신설** |

⚠ AS-IS `DMF0014_CustFcstUpload.cs` 의 `ExcelButton()` 은 **단순 그리드 export**(`SimplexelService.ExportFpSpread`)이고
Excel Form 이 없다 → AS-IS 파리티가 아니라 **본 룰(TO-BE 표준)이 계약 원천**이다 (hook #135 §8).

## ⭐ 값 컬럼 토큰 = `W27~W31` **고정 유지** (사용자 A안 확정)

`SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT` = 정보 토큰 13 + **`W27|W28|W29|W30|W31`**.
상대 주차로 바꾸면 HEADER_CONTENT·업로드 SP 동반 변경 + **기존 업로드 파일 호환이 깨지므로** 현행 유지.
(DMF0082 의 `M4~M16` 은 상대 월 오프셋 — 화면 간 일반화 금지, hook #135 §4-2)

⚠ DMF0014 토큰은 **`*` 를 포함**한다(`Division*`/`Sales Site*` …) — SHEET_COLUMNS 라벨과 문자 그대로 동일.
DMF0082(`Div`/`Model`, `*` 없음)와 달라 `stripStar` 를 적용하면 매핑이 깨진다.

## 적용 순서

| # | 파일 | 내용 |
|---|---|---|
| 1 | `01_PKG_DMF0014_SPEC.sql` | SPEC — `P_DMF0014_GET_EXCEL_FORM_DATA` 선언 추가 |
| 2 | `02_PKG_DMF0014_BODY.sql` | BODY — 본문 추가 (`[E20260814-EXCELFORM]`) |
| 3 | `03_META_EXCEL_FORM.sql` | API_M / 버튼 배선 / 버튼 권한 / PROC_M |

> ⚠ `03` 의 PROC_M 블록은 SQL*Plus 로 실행할 것. 파이썬 단순 분할기로는 블록 주석 안의 `:` 가
> 바인드 변수로 오인된다(2026-08-14 실측) — 사내 적용은 `_diagnostics/_t14_procm_fix.py` 로 수행했다.

## SP 계약

```
P_DMF0014_GET_EXCEL_FORM_DATA (IN 15 + O_RC1 + O_RESULT_CURSOR)
  IN  = 메인 GET(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA) 과 **동일 축·동일 이름**
        → FE 가 store.filters 를 가공 없이 전달하면 그대로 성립 (hook #135 §3-1)
  OUT = 정보 컬럼 13종 (HEADER_CONTENT ATTRIBUTE1~13 과 1:1)
        값 컬럼 W27~W31 은 **입력 전용**이라 SP 가 내리지 않는다 — FE 가 빈칸으로 채움
  본문 = 메인 GET 의 FROM/WHERE 그대로 + **동적 기간 컬럼(v_iteration)만 제외**
```

## FE 변경

| 파일 | 내용 |
|---|---|
| `utils/customer-fcst-upload.excelForm.ts` | 신규 — 토큰 13(`*` 포함) + `W27~W31`, 컬럼/행/미리보기 순수함수 |
| `utils/customer-fcst-upload.api.ts` | 신규 — `fetchExcelFormData` (결과커서 CODE 이름 판정) |
| `components/CustomerFcstTemplateModal.tsx(.module.scss)` | 신규 — Excel Form 모달(정본 1:1) |
| `CustomerFcstUpload.tsx` | `customButtons` 신설(**Excel Form → Excel Upload** 순, §6) · 모달 배선 · `staticColumn` 구독 |
| `customer-fcst-upload.constant.ts` | `EXCEL_FORM_EMPTY: 'MSG00718'` 추가 |

> `upload` 표준 슬롯은 `false` 로 내리고 customButtons 로 옮겼다 — 표준 슬롯이 customButtons **뒤**에
> 렌더되어 "Excel Form → Excel Upload" 순서가 깨지기 때문(§6).

## 검증 실측 (2026-08-14)

| 축 | 결과 |
|---|---|
| PKG | SPEC/BODY **VALID**, 컴파일 오류 **0** |
| PROC_M ↔ SP positional | **17/17 일치** (IN 15 + OUT 2), 12~15 키 = `createdBy`/`userinfo`/`sesUserId`/`mnuId` — store payload 실측과 1:1 |
| 메타 5축 | EXCEL_COLUMNS 1 / 버튼배선 1 / 버튼권한 **4그룹** / API 1 / PROC_M 17 |
| Upload 2단 | `UPLOAD_SAVE` 배선 1 (기존재 — 룰 §2 충족) |
| SP 실행 | division=81 WEEKLY → **O_RC1 13컬럼** 실데이터 + `RESULT_CODE=0 SUCCESS` |
| FE | `tsc` **0** / `eslint` **error 0**(warning 1 = 기존재 `handleSave` 미사용) |

## 잔여 / 육안 확인 권장

1. 화면에서 **Excel Form → Excel Upload** 순으로 버튼이 뜨는지 (권한 4그룹 보유 계정)
2. Excel Form 오픈 시 메인 조회조건이 승계돼 자동조회되는지 / Search 재조회
3. 다운로드 파일 헤더가 `Division*`…`Model` + `W27~W31` **원형**인지, 그 파일을 그대로 Excel Upload 에 태워
   검증(①)·저장(②) 2단이 통과하는지 — **왕복 1회 실증 권장**(hook #135 §7)
