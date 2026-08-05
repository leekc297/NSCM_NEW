# Hook #120 — ui-title-icon-buttons-standard (타이틀 아이콘 버튼 표준: 환율 아이콘화 + 복수 아이콘 순서)

> **Trigger**: T01 (신규 화면) / T01M (화면 수정) — SubTitle `customButtons` 에 기능 버튼을 배치하는 모든 화면
> **PR 차단 강도**: ⭐⭐ (디자인 일관성 — 사용자 명시)
> **신설일**: 2026-07-30 (사용자 명시 — "환율 버턴은 항상 아이콘 형태로 나오도록 rule 설정" + "아이콘이 복수 일 때 나오는 아이콘의 순서는 왼쪽부터 환율, GridColumnSet, Measure")
> **정본**: `features/demand/src/pages/sales-reports/SalesReports.tsx` (DMF0044) / `features/master/src/pages/sales-future-price/SalesFuturePrice.tsx` (DMF0020)

## §1. 환율(Exchange Rate) 버튼 = 항상 아이콘 (의무)

Exchange Rate 기능 버튼은 **어느 화면에서든 텍스트 버튼 금지 — 아이콘 버튼**으로만 노출한다.

```tsx
import { IcExchangeRate } from '@foundation/assets';

...(hasButton('EXCHANGE_RATE')
  ? [
      {
        label: t('LBL00661', 'Exchange Rate'),   // Tooltip 용 — LBL00661 고정 재사용
        title: t('LBL00661', 'Exchange Rate'),
        action: handleExchangeRate,
        iconComponent: <IcExchangeRate />,       // ⭐ 아이콘 의무
        buttonLabel: '',                          // ⭐ 텍스트 label 비움 의무
      },
    ]
  : []),
```

- 아이콘 자산 = `@foundation/assets` **`IcExchangeRate`** (`ic-exchange-rate.svg`) 단일 출처. 화면별 아이콘 임의 제작 금지.
- `label`/`title` 은 Tooltip 접근성용으로 유지 (LBL00661).

## §2. 복수 아이콘 버튼 순서 (의무)

아이콘 버튼이 2개 이상일 때 **왼쪽부터** 다음 순서로 고정한다:

```
① 환율 (IcExchangeRate) → ② Grid Column Set (IcGridColumnSetup) → ③ Measure (IcMeasureSelect)
```

- `customButtons` 배열 순서 = 화면 표시 순서 — 배열에서 위 순서를 지킨다.
- **텍스트 버튼은 아이콘 버튼 앞(왼쪽)에** 배치한다 (예: Set Price / Ver. Cutoff / Ver. Replace / Text → 그 뒤 아이콘 3종).
- 위 3종 외 아이콘 버튼이 추가되면 3종 순서를 깨지 않는 위치(뒤쪽)에 둔다.

## §3. 적용 현황 (2026-07-30 일괄 정렬)

| 화면 | 환율 아이콘 | 순서 |
|---|---|---|
| DMF0044 Sales Reports | ✅ (텍스트→아이콘 전환) | Text → 환율/Column/Measure |
| DMF0042 Business Plan | ✅ (텍스트→아이콘 전환) | Set Price/Ver. Cutoff/Ver. Replace → 환율/Column/Measure |
| DMF0082 Forecast&Price | (기존 아이콘) | Excel Form/Price Batch Input → 환율/Column/Measure (순서 교정) |
| DMF0020 Sales Future Price | (기존 아이콘) | 환율/Column → Price Batch Input(텍스트) ※ 2026-07-01 사용자 확정 순서 유지 |

> DMF0020 은 사용자가 2026-07-01 에 "Exchange Rate → Column Setting → Price Batch Input" 순서를 별도 확정한 화면 — 아이콘 상호 순서(환율→Column)는 본 룰과 일치하므로 유지.

## §4. POST-WRITE grep

```bash
# 환율 텍스트 버튼 잔존 = 0 (buttonLabel 에 Exchange 문구 금지)
grep -rn "buttonLabel: t('LBL00661'" features/ | wc -l   # 기대 0
# IcExchangeRate 사용처와 EXCHANGE_RATE 버튼 화면 수 일치 확인
```
