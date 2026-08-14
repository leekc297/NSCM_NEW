# Hook #120 — ui-title-icon-buttons-standard (타이틀 아이콘 버튼 표준: 환율 아이콘화 + 복수 아이콘 순서)

> ⭐ **2026-08-10 최종 확정** — 아이콘 순서 = **환율 → Column Set → Measure**. §2 참조.
> (같은 날 `Measure → Column → 환율` 로 한 차례 변경했다가 **사용자 재지시로 원복**했다 — 현행은 본 순서.)

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

## §2. 복수 아이콘 버튼 순서 (의무) — ⭐ 2026-08-10 최종 확정

아이콘 버튼이 2개 이상일 때 **왼쪽부터** 다음 순서로 고정한다:

```
① 환율 (IcExchangeRate) → ② Grid Column Set (IcGridColumnSetup) → ③ Measure (IcMeasureSelect)
```

> **변경 이력**: 2026-07-30 신설(본 순서) → 2026-08-10 오전 `Measure→Column→환율` 로 역전 →
> **2026-08-10 사용자 재지시로 본 순서 복귀**. 현행은 위 순서 하나뿐이며 역전판은 폐기.

- `customButtons` **배열 선언 순서** = 화면 표시 순서 — 배열에서 위 순서를 지킨다.
- **텍스트 버튼은 아이콘 버튼 앞(왼쪽)에** 배치한다 (예: Set Price / Ver. Cutoff / Ver. Replace / Text → 그 뒤 아이콘 3종).
- 3종 중 일부만 있는 화면도 **남은 것들의 상대 순서**를 그대로 지킨다
  (예: 환율 없는 DMF0049 = Column → Measure / 메저 없는 DMF0020 = 환율 → Column).
- 위 3종 외 아이콘 버튼이 추가되면 3종 순서를 깨지 않는 위치(뒤쪽)에 둔다.
- 권한(`hasButton`) 조건부 spread 를 써도 **선언 순서**만 지키면 일부가 빠져도 상대 순서가 유지된다.

## §3. 적용 현황 (2026-08-10 최종)

| 화면 | 환율 아이콘 | 순서 | 상태 |
|---|---|---|---|
| DMF0082 Forecast&Price | (기존 아이콘) | Excel Form/Price Batch Input → **환율/Column/Measure** | ✅ |
| DMF0044 Sales Reports | ✅ | Text → **환율/Column/Measure** | ✅ |
| DMF0042 Business Plan | ✅ | Set Price/Ver. Cutoff/Ver. Replace → **환율/Column/Measure** | ✅ |
| DMF0049 Etc Sales Reports | (환율 버튼 없음) | **Column/Measure** | ✅ |
| DMF0020 Sales Future Price | (기존 아이콘) | **환율/Column** → Price Batch Input(텍스트) | ✅ (2026-07-01 사용자 확정 순서 = 본 룰과 일치) |

> DMF0020 은 2026-07-01 에 사용자가 "Exchange Rate → Column Setting → Price Batch Input" 순서를
> 별도 확정한 화면이다. 본 룰과 **일치**하므로 그대로 유지 — 종전 '보류' 항목은 해소됐다.

## §4. POST-WRITE grep

```bash
# 환율 텍스트 버튼 잔존 = 0 (buttonLabel 에 Exchange 문구 금지)
grep -rn "buttonLabel: t('LBL00661'" features/ | wc -l   # 기대 0
# IcExchangeRate 사용처와 EXCHANGE_RATE 버튼 화면 수 일치 확인

# ⭐ 아이콘 순서 검사 — 각 화면 파일에서 3 아이콘의 **등장 라인 번호**가
#   ExchangeRate < ColumnSetup < Measure 오름차순인지 본다(있는 것끼리만 비교).
for f in $(grep -rl "IcGridColumnSetup" features/*/src/pages/*/*.tsx); do
  x=$(grep -n "IcExchangeRate />"    "$f" | head -1 | cut -d: -f1)
  c=$(grep -n "IcGridColumnSetup />" "$f" | head -1 | cut -d: -f1)
  m=$(grep -n "IcMeasureSelect />"   "$f" | head -1 | cut -d: -f1)
  echo "$f  exchange=$x column=$c measure=$m"
done
```

> ⚠️ 순서는 `customButtons` **배열 선언 순서**가 결정한다. `hasButton` 조건부 spread 를 쓰더라도
> 선언 순서만 지키면 권한으로 일부가 빠져도 상대 순서가 유지된다.

## §5. 조회(Search) 버튼 라벨 = `LBL00112` 고정 (의무 — ⭐ 2026-08-12 사용자 명시)

SearchArea 의 조회 버튼 라벨은 **어느 화면에서든 `LBL00112`**('Search(F5)') 로 고정한다.

```tsx
searchButtonLabel={t('LBL00112', '_Search')}
```

- ⛔ `LBL00691`('Search') **사용 금지** — 2026-08-12 전수 정정(이탈 6화면: sales-reports /
  etc-sales-reports / demand-manager / demand-plan-waterfall / sales-monitoring / production-plan-line).
- 신규 화면 복사-붙여넣기 시 원본이 어느 화면이든 이 라벨만 유지한다.

```bash
# POST-WRITE grep — LBL00691 잔존 = 0 (generated-keys.d.ts 는 생성물이라 제외)
grep -rn "LBL00691" features/ apps/ --include="*.tsx" | wc -l   # 기대 0
```
