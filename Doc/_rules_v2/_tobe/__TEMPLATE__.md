# TO-BE 룰 v2 작성 템플릿 — `{NN}_{rule_topic}.md`

> **사용 의무**: `_tobe/` 폴더의 각 룰 파일은 이 템플릿 구조 100% 준수. anti-simplification 동일 적용.
>
> **룰의 진리값**: 모든 표준 / 변형 / 금지 항목은 DMF0004 / DMF0005 / DMF0006 / DMF0007 4 화면의 실제 코드에서 추출. **추측/일반론 금지** — 항상 reference 화면의 file:line 근거 인용.

---

## §0 메타

| 항목 | 값 |
|---|---|
| 룰 # | NN |
| 토픽 | (예: DataGrid) |
| 추출 reference | DMF0004 + DMF0005 + DMF0006 + DMF0007 |
| 관련 AS-IS source | `_asis/00_framework/{X}.md` (있으면) |
| 관련 hook | `hooks/{X}.md` (있으면) |
| 적용 trigger | (예: "신규 화면 grid 생성") |

---

## §1 표준 (의무)

> **모든 신규 화면이 100% 동일하게 따라야 하는 패턴.**

### §1.1 표준 패턴 1: {이름}

**의무**:
- (1) ...
- (2) ...

**reference**:
- `nscm-fe/features/master/src/pages/sales-site/SalesSite.tsx:{line}`
- `nscm-fe/features/master/src/pages/customer-forecast-master/CustomerFcstMaster.tsx:{line}`

**예시**:
```typescript
// reference 에서 추출한 핵심 5~15 line 인용
```

**근거**: 4 화면 모두 동일 패턴 사용 (cross-check OK)

### §1.2 표준 패턴 2: {이름}
(동일 양식)

---

## §2 허용 변형 (선택)

> **특정 조건에서만 적용되는 변형. 변형 사용 시 조건 명시 의무.**

### §2.1 변형 1: {이름}

**조건**: (예: "동적 column 이 필요한 화면")

**근거 화면**: DMF0007 `customer-forecast-master`

**reference**:
- `CustomerFcstMaster.tsx:{line}` — `dynamicColumns` prop 전달
- `utils/CustomerFcstMasterDateColumns.ts` — 컬럼 생성 함수

**예시**:
```typescript
// 변형 패턴 핵심 라인
```

**자동 검증 grep**:
```bash
# 이 변형 사용 화면은 다음 조건도 충족해야 함
rg "dynamicColumns=" {page} && rg "dateColumns" {page}
```

---

## §3 금지 (anti-pattern)

> **위반 시 즉시 차단. 보통 과거 사고 기록이 있는 패턴.**

### §3.1 금지 1: {이름}

**금지 사유**: (예: "DMF0043 _setOwnerList 사고")

**금지 패턴**:
```typescript
// 절대 금지
<FlexGridColumnGroup>
  <FlexGridColumn binding="X" />  {/* single child = wijmo.react.grid 폭발 */}
</FlexGridColumnGroup>
```

**대안**:
```typescript
// 권장
<FlexGridColumn binding="X" header="Group: X" />
```

**자동 검출 grep**:
```bash
rg "FlexGridColumnGroup" {pages} -A 3 | grep -c "FlexGridColumn " # = group 별 leaf count
# 1 이하 시 차단
```

**근거**: `memory/feedback_wijmo_columngroup_jsx_avoid.md` / 룰 27 §F

---

## §4 자동 검증 (PR 머지 게이트)

> **이 룰이 위반되지 않았는지 자동 검증하는 grep / type-check / lint 명령.**

```bash
# 1. 표준 §1.1 위반 검출
rg "{pattern}" {scope}

# 2. 금지 §3.1 위반 검출
rg "{anti-pattern}" {scope}

# 3. 변형 §2.1 조건 일치 검증
# ...
```

위 명령이 0 건 / 적절한 카운트 = PASS.

---

## §5 관련 hook 적용

| Hook | 적용 시점 | 검증 항목 |
|---|---|---|
| `hooks/pre-write.md` | 파일 작성 직전 | §1 표준 인지 + §3 금지 회피 |
| `hooks/post-write.md` | 파일 작성 직후 | §4 grep 0 건 |
| `hooks/{topic-specific}.md` | (해당 시) | §3 금지 자동 검출 |

---

## §6 AS-IS 매핑 (있으면)

| AS-IS 요소 | TO-BE 대응 | 위치 (이 룰의 §) |
|---|---|---|
| `BaseForm.FindButton` | `handleSearch` + `useTabProcQuery` | §1.1 |
| `siMain.LockColumn` | column meta `_inputEditType: 'O'` | §1.2 |
| ... | | |

상세는 `_mapping/asis_to_tobe.md` 참조.

---

## §7 변경 이력

| 일자 | 변경 내용 | 이유 |
|---|---|---|
| YYYY-MM-DD | 초안 작성 | Phase 4 룰셋 v2 |
| YYYY-MM-DD | §3.X 추가 | (사고 기록 후 보강) |

---

> **이 룰 문서 작성 시 의무**:
> 1. 모든 §1/§2/§3 항목은 reference 화면의 file:line 인용 필수
> 2. 일반론 / 추측 금지 ("일반적으로 권장됨" 같은 표현 금지)
> 3. 변형 §2 는 어느 화면에서 왜 변형되었는지 명시 (변형 = 사고 가능성 = anti-simplification 위반 가능)
