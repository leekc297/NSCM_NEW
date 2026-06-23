# Hook — Combo Lookup + Date Validation + Message Code 정합 (화면 QA 이슈 도출)

> 작성 / Authored: 2026-06-23 (일일 이슈목록 `이슈목록_2026-06-23.md` 룰 후보 R-1·R-2·R-3·R-4·R-5 정식 승격)
> 출처 / Source: `issue-feed-rules.md` 2026-06-23 블록 (DMF0043_01 / DMF0072 / DMF0020 / DMF0043 / SYS0001 QA 이슈)
> 강도 / Strength: **PR 차단** — 위반 시 머지 거부 (콤보/검증/메시지 정합은 운영 데이터 신뢰성 직결)
> 적용 / Apply: T01 신규 화면 · T04 Grid/날짜 컬럼 · T05/T06 Form·Modal·Combo · T10 메시지/검증 사고

화면 QA(이슈목록관리.xlsx) 에서 처리·머지 완료된 이슈에서 도출한 **재사용 정합 룰 4종**. 모두 "운영 데이터/메타가 옳은데 화면 측 하드코딩·형식 불일치로 오작동" 패턴.

| 분류 | 출처 이슈 No. | 화면 | 한 줄 |
|---|---:|---|---|
| **L** (Lookup) | 5, 11 | DMF0043_01 / SYS0001 | 콤보박스/모달 옵션 = 룩업 조회 (`useTabLookupQueries`/`useTabComboQueries`), 하드코딩 금지 |
| **V** (Validation) | 6 | DMF0072 | 날짜 셀 **표시 형식 ↔ 유효성 검증 형식 일치** (`MM/DD/YYYY` 표시면 검증도 동일) |
| **M** (Message) | 9 | DMF0043 | 메시지 코드 **의미 충돌 금지** — 동일 코드를 화면마다 다른 문구로 재사용 금지 |
| **D** (Depth) | 8 | DMF0020 | 다단 헤더 depth = DB 라벨 메타가 결정 (`getColumnDepth`). 화면 하드코딩은 **임시방편**, 근본은 admin 메타 정비 |

---

## §1. L — 콤보박스/모달 옵션 = 룩업 조회 (하드코딩 금지)

> 출처: No.5 (DMF0043_01 Contribution Sales, 처리·머지 완료) + No.11 (SYS0001 Message, 처리 완료)

### 1.1 사실 (인프라 — 이미 존재)

`packages/shared/src/hooks/useCustomQueryClient.ts` 에 룩업/콤보 조회 hook 4종이 이미 존재:

| hook | 위치 | 용도 |
|---|---|---|
| `useTabComboQuery` | `useCustomQueryClient.ts:131` | 단일 콤보 SQL_ID 조회 |
| `useTabComboQueries` | `useCustomQueryClient.ts:151` | 다중 콤보 1 round-trip |
| `useTabLookupQuery` | `useCustomQueryClient.ts:180` | 단일 lookup 코드 조회 |
| `useTabLookupQueries` | `useCustomQueryClient.ts:200` | 다중 lookup 1 round-trip (G2 BigFilter) |

→ 모달/Form 의 `<select>` 옵션을 화면 상수로 하드코딩하지 말고 위 hook 으로 조회한다.

### 1.2 안티패턴

```tsx
// ❌ Version Modal 의 Type 콤보를 화면 상수로 하드코딩 (No.5 원래 사고)
const VERSION_TYPE_OPTIONS = [
  { value: 'A', label: 'A' },
  { value: 'B', label: 'B' },
];
<select value={versionType} onChange={...}>
  {VERSION_TYPE_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
</select>
```

→ admin 에서 코드값이 추가/변경돼도 화면에 반영 안 됨 → 운영 데이터 무효화.

### 1.3 표준 (No.5 처리내역)

```tsx
const [myMdfTypes] = useTabLookupQueries({ filters: ['MDF_TYPE'] });

const dmfTypeOptions = useMemo<Array<{ value: string; label: string }>>(() => {
  const arr = (myMdfTypes ?? []) as Array<{ CODE?: string; NAME?: string }>;
  if (arr.length === 0) return VERSION_TYPE_OPTIONS;   // ✅ 빈 결과 시 기본 옵션 fallback
  return arr.map(r => {
    const code = String(r.CODE ?? '');
    const name = String(r.NAME ?? code);
    const label = code === name || name === '' ? code : `${code} (${name})`;
    return { value: code, label };
  });
}, [myMdfTypes]);
```

**필수 4 요소**:
1. 옵션은 룩업/콤보 hook 으로 조회 (하드코딩 배열을 옵션 source 로 직접 사용 금지)
2. `CODE` / `NAME` 가공 — `String(r.CODE ?? '')` undefined guard (메모리 `feedback_fe_string_undefined_cast_guard`)
3. **빈 결과 fallback** — `arr.length === 0` 시 module-level 기본 옵션 (네트워크/권한 실패 시 빈 콤보 방지)
4. lookup 코드 (`MDF_TYPE` / `MSG_TP_CD` 등) 미등록 시 → 별도 룩업 등록 (No.11 — `SCM_ADM_LOOKUP_*` 메타, **AI 임의 생성 금지** — `ui-category-setup-no-arbitrary-data`)

### 1.4 Grid cell dropdown 과 구분

| 위치 | 표준 | hook |
|---|---|---|
| **Grid cell dropdown** | admin 메타 `CELL_COMBO_DATA_TYPE` → DataGrid wrapper 자동 fetch | `column-lookup-meta-standard` (직접 호출 금지) |
| **모달/Form `<select>`** | 화면에서 `useTabLookupQueries`/`useTabComboQueries` 직접 호출 + 가공 | 본 §1 |

⚠️ 둘을 혼동하지 말 것 — grid cell 은 wrapper 가 처리, 모달 form 콤보는 화면이 직접 조회.

---

## §2. V — 날짜 셀 표시 형식 ↔ 유효성 검증 형식 일치

> 출처: No.6 (DMF0072 N:n Master Mapping) — Validation 체크 오류

### 2.1 사고

- VALID_START / VALID_END 셀 **표시 형식 = `MM/DD/YYYY`** (사용자 입력·수정 시 보이는 값)
- 그런데 유효성 검증 로직은 여전히 **`YYYYMMDD` 고정 파싱** → "유효한 날짜가 아니다" 오탐
- + MDM Code / VALID_START / VALID_END 모두 입력했는데도 "입력되지 않았다" 오탐 (값 추출 경로가 표시 형식과 불일치)

### 2.2 룰

```
[필수 1] 날짜 셀의 표시 format 과 검증 시 파싱 format 을 단일 source 로 일치시킨다.
  - 셀이 MM/DD/YYYY 로 표시되면 검증·SP 전송 변환도 동일 형식 기준으로 파싱
  - YYYYMMDD 하드코딩 정규식/슬라이스 (예: substring(0,4)+substring(4,6)) 금지

[필수 2] "필수 입력 누락" 검증은 셀의 실제 binding 값을 읽는다.
  - 표시 형식 ↔ 내부 저장 형식이 다르면 빈 값 판정도 어긋난다
  - editTracker / row[binding] 의 실제 값으로 판정 (formatted display string 으로 판정 금지)

[필수 3] 날짜 파싱은 dayjs (foundation 표준) 사용, format 명시:
  - dayjs(value, 'MM/DD/YYYY', true) — strict 파싱으로 형식 검증
  - SP 전송 시 dayjs(...).format('YYYYMMDD') 등 변환은 검증 통과 후 1곳에서만
```

### 2.3 PRE-WRITE 체크

- [ ] 날짜 컬럼의 표시 format (column meta `format` / cell editor) 확인
- [ ] validation 의 날짜 파싱 format 이 표시 format 과 동일한지 cross-check
- [ ] 빈 값 판정이 formatted string 이 아닌 binding raw 값 기준인지 확인
- [ ] AS-IS `.cs` 의 날짜 검증 (`DateTime.TryParse` / format) 1:1 매핑 (`asis-coverage-check`)

---

## §3. M — 메시지 코드 의미 충돌 금지 (동일 코드 다른 문구 재사용 금지)

> 출처: No.9 (DMF0043 Contribution Rate Reg, Front-End+DB) — `MSG00004` 중복 사용

### 3.1 사고

- `MSG00004` 가 `useCustomQueryClient.ts:105` 에서 **"수정한 내용이 없습니다"** 로 사용
  ```ts
  if (!data.length) return Promise.reject(new Error(t('MSG00004', '_수정한 내용이 없습니다.')));
  ```
- 그러나 다른 화면에서는 동일 `MSG00004` 를 **"저장하시겠습니까?"** 로 사용
- 실제 메시지 테이블(`SCM_ADM_MSG_M`) 에는 "수정한 내용이 없습니다" 로 저장됨 → 충돌

### 3.2 룰

```
[필수 1] 하나의 메시지 코드(MSG_ID) = 하나의 의미/문구. 의미가 다르면 신규 코드 분리.
  - MSG00004 (수정한 내용 없음) vs 저장 확인 → 의미별 코드 분리 (MSG_NO_CHANGE 등)
  - 공통 호출 지점(useCustomQueryClient 등)은 의미가 고정된 전용 코드 사용

[필수 2] 메시지 코드 신규/변경 시 SCM_ADM_MSG_M 실 데이터를 single source 로 본다.
  - 테이블 문구 ≠ 코드 사용처 문구면 사용처를 테이블 기준으로 정정 (또는 신규 코드)
  - AI 임의 MSG INSERT/문구 추측 금지 (ui-category-setup-no-arbitrary-data + asis-msg-inventory)

[필수 3] 공통 hook/유틸 안의 메시지 코드는 화면별 재해석 금지.
  - useCustomQueryClient 같은 전역 hook 의 코드는 모든 화면에서 동일 의미여야 함
```

### 3.3 처리내역 (No.9 제안)

`useCustomQueryClient.ts` 의 `MSG00004` → 의미 전용 코드(`MSG_NO_CHANGE`)로 분리. 신규 코드는 `SCM_ADM_MSG_M` 등록(실 데이터 기준) + i18n 3언어(`i18n-ko-en-alignment`) 동반.

> ⚠️ BE 변경 금지 룰(`feedback_be_no_modification_rule`) — 메시지 정비는 SP/메타(`SCM_ADM_MSG_M`)/FE(i18n·hook) 한정.

### 3.4 POST-WRITE 검증

```sql
-- 동일 MSG_ID 가 의미 충돌 없이 단일 문구인지 (Docker/사내 동일)
SELECT MSG_ID, COUNT(DISTINCT MSG_CN) FROM SCM_ADM_MSG_M GROUP BY MSG_ID HAVING COUNT(DISTINCT MSG_CN) > 1;
-- 기대: 의미 충돌 코드 검토
```
```bash
# 공통 hook 안 메시지 코드 사용처 grep — 의미 일관성 수동 검토
grep -rn "t('MSG[0-9]" packages/shared/src/hooks/
```

---

## §4. D — 다단 헤더 depth = DB 라벨 메타 결정 (화면 하드코딩 임시방편)

> 출처: No.8 (DMF0020 Sales Price, 처리·머지 완료 — 단 근본 해결 미완)

### 4.1 사실

- 그리드 헤더 단(depth) 은 `getColumnDepth` (`packages/foundation/src/utils/columnMapping.ts:116`) 가 결정
- 판정 기준 = DB 저장 라벨 메타 **`sClsLblNm` / `lClsLblNm` / `colLblNm`** 의 조합:
  - small/large class label 이 비었거나 colLblNm 과 동일 → `ONE_DEPTH`
  - lClsLblNm 만 비거나 sClsLblNm 과 동일 → `TWO_DEPTH`
  - 그 외 → `THREE_DEPTH`
- depth 에 따라 `HEIGHT_BY_COLUMN_DEPTH` (1단=48 / 2단=24 / 3단=16) 자동 적용 (`columnMapping.ts:26`)

### 4.2 룰

- No.8 처리는 **화면 소스에서 depth 가 3으로만 나오도록 조건값을 임시 세팅** → **임시방편**.
- 근본 해결 = `SCM_MST_SHEET_COLUMNS` 의 `SMALL_CLASS_LABEL_NAME` / `LARGE_CLASS_LABEL_NAME` / `COLUMN_LABEL_NAME` 메타 정비 (admin UI Category Setup).
- ❌ 화면 측에서 depth/height 하드코딩으로 우회 = anti-simplification 위반 (운영 메타 무효화).
- ✅ admin 메타가 옳은 depth 를 표현하도록 라벨 메타 정비 → `getColumnDepth` 가 자동 정확.

### 4.3 cross-ref (중복 금지)

| 관련 | 내용 |
|---|---|
| `screen-runtime-pitfalls-mandatory` §6 (P6) | 다단 헤더 row **높이** 정합 (dynamicColumns 측 `height` 명시) |
| `ui-category-setup-no-arbitrary-data` | admin 라벨 메타 = 실 데이터만, AI 임의 생성 금지 |
| `ui-category-setup-column-meta` | admin column 메타 동적 fetch — 화면 하드코딩 금지 |

> 본 §4 는 위 hook 들과 **동일 방향 강화 (depth 결정의 근본은 DB 라벨 메타)**. 별도 신규 메커니즘 아님.

---

## §5. PRE-WRITE / POST-WRITE 통합

### 5.1 PRE-WRITE (작성 직전)
- [ ] **L**: 모달/Form `<select>` 옵션을 `useTabLookupQueries`/`useTabComboQueries` 로 조회 + `CODE/NAME` 가공 + 빈 결과 fallback (하드코딩 배열 옵션 금지)
- [ ] **V**: 날짜 컬럼 표시 format ↔ validation 파싱 format 일치 + 빈 값 판정은 binding raw 값
- [ ] **M**: 신규/사용 메시지 코드가 단일 의미인지 (`SCM_ADM_MSG_M` 기준) — 공통 hook 코드 화면별 재해석 금지
- [ ] **D**: 다단 헤더 depth 는 admin 라벨 메타로 결정 — 화면 depth/height 하드코딩 금지

### 5.2 POST-WRITE grep (0 hit 의무)
```bash
# L — 모달/Form 안 하드코딩 옵션 배열을 select source 로 직접 사용 검출 (수동 검토)
grep -rn "OPTIONS\s*=\s*\[" features/{domain}/src/pages/{screen}/ | grep -iv "fallback"

# V — 날짜 YYYYMMDD 하드코딩 슬라이스/정규식 검출
grep -rn "substring(0, *4)\|/[0-9]\{8\}/\|YYYYMMDD" features/{domain}/src/pages/{screen}/

# M — 공통 hook 외 화면이 MSG 코드 직접 문구 재정의 검출
grep -rn "t('MSG[0-9]\{5\}'," features/{domain}/src/pages/{screen}/
```

---

## §6. cross-ref

### Hook
- `column-lookup-meta-standard` — grid cell dropdown 메타 표준 (본 §1 과 위치 구분)
- `messaging-api-and-search-fields-mandatory` — apiClient 룩업 메서드 + useMessageStore
- `cascade-combo-filter` — combo cascade (Division→하위 reset)
- `ui-category-setup-no-arbitrary-data` — admin 메타(MSG/LOOKUP/SHEET_COLUMNS) AI 임의 생성 금지 (본 §1.3/§3.2/§4.2)
- `asis-msg-inventory` — AS-IS MSG 인벤토리 → To-Be 등록
- `i18n-ko-en-alignment` — 메시지 신규 코드 3언어 동반
- `screen-runtime-pitfalls-mandatory` §6 (P6) — 다단 헤더 높이 (본 §4 와 짝)

### 메모리
- `feedback_fe_string_undefined_cast_guard` — `String(r.CODE ?? '')` guard (본 §1.3)
- `feedback_ui_category_setup_no_arbitrary_data` — admin 메타 실 데이터만 (본 §1.3/§3.2)
- `feedback_be_no_modification_rule` — 메시지 정비 SP/메타/FE 한정 (본 §3.3)

### 원천
- `_analysis/이슈목록_2026-06-23.md` §4 룰 후보 R-1~R-5
- `issue-feed-rules.md` 2026-06-23 블록 (편입완료)

---

## §7. 변경 이력

- 2026-06-23: 신규 작성. 일일 이슈목록(`이슈목록_2026-06-23.md`) 처리·머지 완료 이슈 5건(R-1~R-5)을 정식 룰로 승격. `issue-feed-rules.md` 의 편입 절차("사람 검토 후 정식 룰 승격 → 피드 상태 편입완료")에 따라 사용자 명시 요청으로 편입.
