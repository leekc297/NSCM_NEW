# Hook — PIVOT / 동적 컬럼 화면 frozenColumns 자동 설정

> ⭐ **2026-06-01 신규.** 신규/수정 화면이 SP PIVOT 으로 동적 컬럼 생성 시 BASE 컬럼까지 좌측 고정 의무. 룰 12 §11.5 cross-ref.

작성: 2026-06-01 (DMF0043 작업 후 사용자 요구)

---

## §0. 트리거

다음 1개 이상 해당 시 본 hook 의 작업 의무:

| 트리거 | 예 |
|---|---|
| SP `PIVOT (... FOR col IN (...))` 사용 | DMF0043 `GET_CONTRIBUTE_MAIN_DATA` |
| FE Grid 에 BASE 정적 컬럼 + 동적 (Y#/M#/period × dim) 컬럼 함께 표시 | DMF0043 ContributeMainGrid |
| Cursor METADATA 컬럼 50개 이상 + 가로 스크롤 필수 | 129 컬럼 |

---

## §1. 의무 작업

### 1.1 BASE 컬럼 명세 분리

```tsx
// FE — 동적 컬럼 직전의 마지막 정적 컬럼까지 BASE_COLUMNS 배열로 분리
const BASE_COLUMNS = [
  { binding: 'DEPT_NAME', header: '부문', width: 180 },
  ...
  { binding: 'DM_BIZ_TYPE', header: '형태', width: 80 },  // 동적 직전
];
```

### 1.2 `frozenColumns` 명시

```tsx
<FlexGrid
  initialized={(g) => {
    g.frozenColumns = BASE_COLUMNS.length;
  }}
/>
```

### 1.3 동적 컬럼 빌더 분리

```tsx
const dynamicColumns = useMemo(() => {
  // SP cursor METADATA 또는 first row keys union 기반
  // BASE_COLUMNS 와 binding 중복 금지
}, [data]);
```

---

## §2. PR 머지 게이트 자기 점검

- [ ] BASE 컬럼이 별도 const 배열로 분리됨
- [ ] `g.frozenColumns = BASE_COLUMNS.length` 명시 (또는 명시적 숫자)
- [ ] BASE_COLUMNS 의 binding 과 동적 컬럼 binding 중복 X
- [ ] 가로 스크롤 시 BASE 컬럼 항상 좌측 표시 (시각 검증)

---

## §3. cross-check 명령

```bash
# PIVOT SP 사용 화면 식별
grep -rlE "PIVOT.*FOR.*COLUMN_NAME" To-be_v2_converted/06_Packages/

# 해당 화면 FE 코드에 frozenColumns 존재 확인
grep -nE "frozenColumns\s*=" nscm-fe/features/{domain}/src/pages/{screen}/components/*Grid.tsx

# 누락 화면 — PR Reject + 본 hook 작업
```

---

## §4. 사고 사례 (2026-06-01 DMF0043)

DMF0043 Contribute Main Grid:
- BASE 컬럼 13개 → 사용자 요구로 6개 (부문/팀/고객군/판매처/제품군/형태) 로 축소
- 동적 컬럼: 12 월 × 9 RBU = 108개
- 가로 스크롤 시 BASE 6컬럼 사라짐 → 어느 row 의 데이터인지 식별 불가
- `g.frozenColumns = 6` 추가로 해결

---

## §5. 관련 룰

- 룰 12 §11.5 — PIVOT frozen 표준 패턴
- 룰 10 — 동적 SP 호출 아키텍처
- 룰 25 — 신규 화면 자료 우선순위 (Figma / AS-IS 캡처 / Excel)
- 룰 24 — As-Is Cross-check (PIVOT 컬럼 수 = AS-Is 와 일치)
