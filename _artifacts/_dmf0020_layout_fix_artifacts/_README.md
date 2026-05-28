# DMF0020 Layout Fix — AS-IS 기반 조건 영역 보완

작성: 2026-05-22
적용 화면: **DMF0020 SalesFuturePrice** (`/master/demand-master/sales-future-price`)

## 1. 무엇을 고치는가

AS-IS WinForms `DMF0020_SalesFuturePrice.cs` (3,970줄) + `.Designer.cs` 의 **정적 레이아웃** 과 **동적 배치 로직** 을 분석하여 신규 화면의 검색 조건 영역을 보완.

### AS-IS 분석 결과 (근거)

**정적 레이아웃 (`Designer.cs`)**:
- 검색 영역: 1350×143px / 22 컨트롤 / 3 row 압축
- 입력 표준 폭: **100px**
- Popup 버튼: **119~136 × 25~26 px**
  - btnBatch L272/287 (Designer 119×26)
  - btnExchangeRate L310/325 (Designer 136×26)
  - btnSavePricePeriod L917/932 (Designer 136×25)
  - btnTemplate L1068/1084 (Designer 90×64, 2-row span)
  - btnExcelUpload L1025/1041 (Designer 80×21)

**동적 배치 (`.cs` Form_Load L198~214 / ChangedDivisions L2575~2591)**:
```cs
if (clbDivisions.ControlValues.Substring(0, 2) == "81") {
    btnExcelUpload.Visible = btnTemplate.Visible = true;     // ESS 사업부만 표시
} else {
    btnExcelUpload.Visible = btnTemplate.Visible = false;
}
```

→ **AS-IS 는 `Sales Price Template` 버튼을 사업부 81 (ESS) 일 때만 표시**. 신규 화면 기존 코드는 항상 표시 (Cross-check 위반).

## 2. 변경 파일 (3건)

| # | 파일 | 종류 | 변경 요약 |
|---|---|---|---|
| 1 | `features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.tsx` | 수정 | 5 popup 버튼 모두 `size='small'` + Sales Price Template 을 `{isEss && ...}` 조건부 렌더링 + AS-IS 라인 주석 추가 |
| 2 | `features/master/src/pages/sales-future-price/components/SalesFuturePriceForm.module.scss` | 수정 | `.popupButtonGroup` gap 8→4px / `justify-content: flex-end` / `margin-left:8px` 제거 (AS-IS 우측 인접 배치 모방) |
| 3 | `features/master/src/pages/sales-future-price/__asis-mapping__.md` | 수정 | Expression 매핑 #74 신규 (btnTemplate.Visible Division 81 분기) + 총 매핑 건수 83→84 / section header 갱신 |

## 3. 클라우드 적용 절차 (2 step)

```
[Step 1] 압축 해제 후 fe/ 내부 파일을 nscm-fe/ 위에 덮어쓰기
  Windows:
    Expand-Archive DMF0020_LayoutFix_20260522.zip -DestinationPath <CLOUD_ROOT>
    Copy-Item -Recurse <CLOUD_ROOT>\fe\features\* <CLOUD_ROOT>\nscm-fe\features\ -Force

  Unix:
    unzip DMF0020_LayoutFix_20260522.zip
    cp -r fe/features/* <CLOUD_ROOT>/nscm-fe/features/

[Step 2] dev 서버는 Vite HMR 이 변경 감지 → 자동 reload
  (재시작 불필요. 다만 module.scss 변경이 적용 안 될 시 dev 서버 재기동)
```

## 4. 검증

브라우저에서 DMF0020 (`/master/demand-master/sales-future-price`) 오픈 후:

| 케이스 | 기대 동작 |
|---|---|
| 사업부 = **40 Automotive** | `Sales Price Template` 버튼 **사라짐**, 나머지 4 버튼만 표시 (Exchange Rate / Sales Price Range / Price 일괄입력 / Batch) |
| 사업부 = **81 ESS** | `Sales Price Template` 포함 **5 버튼 모두 표시** |
| 사업부 = **82 Power** | `Sales Price Template` 버튼 **사라짐**, 4 버튼만 표시 |
| 모든 사업부 | Popup 버튼들이 `size='small'` 압축 사이즈로 렌더, **우측 정렬**, gap **4px** |

## 5. BE / DB 영향

없음. 본 fix 는 FE 레이아웃/조건부 렌더링 변경만 포함.

## 6. 사전 의존성

본 fix 는 `_dayjs-locale-fix_artifacts` (2026-05-22 동시 작업) 와 독립적입니다. 순서 무관하게 적용 가능.

## 7. 미적용 / 후속 작업 (정직 보고)

- **조회조건 입력 필드 폭**: AS-IS 100px 강제 시 MUI 12-column 반응형 깨짐. `Grid size={3}` 유지 (nscm-fe 표준). dense 레이아웃 요청 시 별도 작업으로 `size={2}` (6 fields/row) 검토 가능.
- **기능 버튼 (Search/Save/Excel)**: 공통 `SearchArea` + `SubTitle` 처리로 본 화면 단독 변경 불필요.
- **`checkInvalidExec` 체크박스 동적 enable** (AS-IS L341, 2521 — div 81 일 때만 활성화): 신규 화면에 미구현 → 별도 작업 권장.
- **`btnExcelUpload.Visible`**: 신규 화면은 Excel Upload 를 F12 hotkey 로만 제공 (popup 버튼 부재) — Visibility 분기 N/A.

## 8. 변경 파일 구조

```
fe/
└── features/
    └── master/
        └── src/
            └── pages/
                └── sales-future-price/
                    ├── __asis-mapping__.md          (수정 — Expression #74 추가)
                    └── components/
                        ├── SalesFuturePriceForm.tsx          (수정 — popup 버튼 size/isEss)
                        └── SalesFuturePriceForm.module.scss  (수정 — gap 4px / 우측 정렬)
```
