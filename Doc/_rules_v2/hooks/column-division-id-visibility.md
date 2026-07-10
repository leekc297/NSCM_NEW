# Hook — UI Category Setup `DIVISION_ID` 기반 컬럼 표시 (DIVISION_ID 직접 사용)

> ⚠ **Grid 가 admin 컬럼 메타를 동적 fetch 하는 신규/수정 화면 작업 시 적용**
> `SCM_MST_SHEET_COLUMNS.DIVISION_ID` 에 값이 있으면 **선택한 division 이 그 리스트에 포함될 때만** 컬럼 표시,
> 공란/NULL 이면 **항상 표시**. division 무관 하드코딩 컬럼 노출 금지.

> ⭐ **개정 (2026-07-10 · 사용자 명시 — DMF0074 기준)**: `DIVISION_ID` 를 **직접 사용**한다.
> 현행 `PKG_NSCM_UI_COM_MENU` 컬럼 목록 SP 가 **P_DIVISION_ID 서버측 토큰 필터를 지원**
> (BODY L164/214 `AND (P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL OR INSTR(','||C.DIVISION_ID||',', ','||P_DIVISION_ID||',') > 0)`)
> — FE 는 `/admin/menu/{ID}/column` body 에 `divisionId` 를 **전달만** 하면 된다 (조회 division, 미선택 시 null=전체).
> **§3-1 의 ATTRIBUTE3 복사 방식은 DEPRECATED** — 신규 화면에서 ATTRIBUTE3 복사·FE attribute3 필터 금지.
> 로컬 토큰 필터는 **fallback 하드코딩 스냅샷 경로에만** 유지(§3-2 의 정확 토큰 일치 규칙 동일).
> Division 변경 후 조회 시 컬럼 재fetch 필수 (handleSearch 에서 fetchStaticColumns 재호출 — divisionId 반영).
> 정본 구현 = DMF0074 `useMetalLinkPriceStore.fetchStaticColumns` + `MetalLinkPriceGrid`.

작성: 2026-06-27 (사용자 명시 요구 — DMF0020 기준 룰화) · 개정: 2026-07-10 (DIVISION_ID 직접 사용)
상위 룰: `anti-simplification.md` / `ui-category-setup-no-arbitrary-data.md` (#78)
관련 룰: `ui-category-setup-column-meta.md` (#65) / `_tobe/08_column_meta.md`
관련 메모리:
- `feedback_be_attribute1_empty_division_all.md` (division 공란 = 전체 허용 의미)
- `feedback_fe_grid_visible_no_fallback_loss.md` (admin visible 결정 무효화 금지)
- `feedback_be_no_modification_rule.md` (BE Java 무변경)

---

## §0. 트리거 (작업 키워드 매칭 시 자동 적용)

| 트리거 | 적용 시점 |
|---|---|
| 신규 화면 작성 (T01 신규화면) | PRE-WRITE + POST-WRITE |
| 화면 수정 (T01M) | PRE-WRITE + POST-WRITE |
| Grid 컴포넌트 / 컬럼 메타 (T04 Grid·컬럼메타) | PRE-WRITE + POST-WRITE |
| `DIVISION_ID` / `divisionId` + 컬럼 표시 키워드 등장 | POST-WRITE 검증 |

⚠ 본 hook 은 `ui-category-setup-column-meta` (#65) 의 **확장**. 동적 컬럼 메타 fetch 가 전제이며, 그 위에 division 필터를 얹는다.

---

## §1. WHY — `DIVISION_ID` 의 의미와 미구현 현황

`SCM_MST_SHEET_COLUMNS.DIVISION_ID` (VARCHAR2(200)) 는 **콤마 구분 division 토큰 리스트**다. 화면별 컬럼이 어느 division 에서 보여야 하는지를 admin 이 관리한다.

예 (DMF0020 'Sales Price' 실측, 2026-06-27):

| DIVISION_ID | 컬럼수 | 의미 |
|---|---|---|
| `40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG` | 57 | 전 division 노출 |
| `82,81,81_UC,81_HM,81_ST,81_HD,81_HG` | 13 | **40 제외** (40 선택 시 숨김) |
| `40` | 3 | 40 전용 |
| `82` | 2 | 82 전용 |
| 공란/NULL | (다수) | division 무관 = 항상 표시 |

**그러나 이 의미는 화면 어디에도 구현돼 있지 않았다**:
- SP `PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST` 는 `P_DIVISION_ID` 를 **sheet 명 변형 선택**(`SHEET_NAME||'_'||division`)에만 사용 — `DIVISION_ID` 컬럼 토큰 매칭 필터 없음. SELECT 목록에도 `DIVISION_ID` 미포함.
- BE `GridColumn` DTO 에 `divisionId` 필드 없음 → `DIVISION_ID` 값이 FE 로 전달 안 됨.
- FE `visibleColumns` 는 `c.visible` 만으로 필터 (division 무관).

→ DIVISION_ID 가 채워져 있어도 모든 division 에서 동일 컬럼이 노출되어 **admin 운영 결정이 무효화**되는 상태였다.

---

## §2. 구현 제약 (반드시 준수)

| 제약 | 사유 |
|---|---|
| ❌ 공유 SP `PKG_NSCM_UI_COM_MENU` 변경 금지 | 전 화면 공용 → 회귀 위험. (`feedback_be_no_modification_rule`) |
| ❌ BE `GridColumn` DTO / Java 변경 금지 | BE 무변경 룰. |
| ✅ DIVISION_ID 값을 free attribute 로 **복사** (관례 `ATTRIBUTE3`) | `attribute1~10` 은 이미 DTO 노출 → FE 전달 가능. 화면별 attribute 매핑 확인 후 free 선택 (DMF0020: attribute1=modalKey / attribute2=comboKey / attribute3=free). |
| ✅ 메타 복사는 **기존 DIVISION_ID 실데이터만** | 임의 division 값 생성 금지 (#78). 공란은 그대로 공란. |
| ✅ FE **클라이언트 측 토큰 필터** | division 변경 시 재fetch 없이 즉시 재필터. |

---

## §3. 의무 패턴 (2단계)

### 3-1. 메타 — DIVISION_ID → 무료 attribute 복사 (멱등 배포 SQL)
```sql
-- _artifacts/_deploy_packages/{화면}/03_META/0NN_ATTRIBUTE3_DIVISION_COPY.sql
UPDATE SCM_MST_SHEET_COLUMNS
   SET ATTRIBUTE3 = DIVISION_ID, LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = '{화면ID}' AND SHEET_NAME = '{admin sheet 명}';
COMMIT;
```
- 멱등(재실행 안전). 공란 DIVISION_ID → ATTRIBUTE3 도 공란(= 항상 표시).
- 적용 전 대상 건수 보고 + 롤백 SQL(`SET ATTRIBUTE3 = NULL`) 동봉.
- ⚠ DIVISION_ID 가 admin 에서 바뀌면 ATTRIBUTE3 도 재복사 필요(멱등 SQL 재실행). 동기화 책임 명시.

### 3-2. FE — `visibleColumns` 토큰 필터
```ts
// mergedColumns (staticColumns 분기): free attribute → _divisionAllow 매핑
_divisionAllow: sc.attribute3,
// (fallback 하드코딩 분기는 undefined = 항상 표시)

// visibleColumns: c.visible 필터에 division 토큰 매칭 추가
const visibleColumns = useMemo(
  () =>
    mergedColumns.filter(c => {
      if (!c.visible) return false;
      const allow = c._divisionAllow?.trim();
      if (!allow) return true;          // DIVISION_ID 공란 = 항상 표시
      if (!divisionId) return true;     // 선택 division 없음 = 필터 안 함
      return allow
        .split(',')
        .map(s => s.trim())
        .includes(divisionId);          // ⭐ 정확 토큰 일치 (substring 금지)
    }),
  [mergedColumns, divisionId]           // ⭐ divisionId deps 필수
);
```
- `fixedBindings` / `mainStaticColumns` / mergeManager 가 `visibleColumns` 파생이면 자동 정합.
- merge/format useEffect deps 에 `visibleColumns` 포함 → division 변경 시 재실행(컬럼 재계산).

---

## §4. PRE-WRITE 자기 점검

- [ ] `SCM_MST_SHEET_COLUMNS.DIVISION_ID` 실제 데이터 **실측**(`ora.py query` GROUP BY) — 값 형식·토큰·공란 분포 확인 (추측 금지).
- [ ] 해당 화면의 free attribute 확인(attribute1~10 중 화면 매핑에서 미사용분). DMF0020=ATTRIBUTE3.
- [ ] 메타 복사 SQL = 기존 DIVISION_ID 실데이터만. 임의 division 값 생성 0.
- [ ] FE `visibleColumns` 에 **공란=항상표시** 분기 포함.
- [ ] FE 필터 = **정확 콤마 토큰 일치**(`includes(token)` on split array). substring 매칭(`allow.includes('81')`) 금지 — '81' 이 '81_HD' 에 오탐.
- [ ] `divisionId` 가 useMemo deps 에 포함.

---

## §5. POST-WRITE 자동 검증 (grep)

```bash
# (1) division 토큰 필터 존재
grep -n "_divisionAllow" features/**/components/*Grid.tsx
# (2) visibleColumns deps 에 divisionId 포함
grep -nA12 "visibleColumns = useMemo" features/**/components/*Grid.tsx | grep "divisionId"
# (3) 하드코딩 division 분기 부재 (안티패턴)
grep -nE "divisionId\s*===\s*'(40|81|82)'" features/**/components/*Grid.tsx   # 0 기대 (필터는 메타 기반)
# (4) SP / DTO 변경 0
git status nscm-be/ | wc -l                                                   # 0 기대
git diff --name-only | grep -E "PKG_NSCM_UI_COM_MENU|GridColumn"             # 0 기대
```

---

## §6. 안티패턴 (사고 사례)

| # | 안티패턴 | 결과 |
|---|---|---|
| 6.1 | DIVISION_ID 공란을 "숨김"으로 처리 | 대부분 컬럼(공란)이 전부 사라짐 |
| 6.2 | substring 매칭 `allow.includes(divisionId)` | '81' 선택 시 '81_HD' 전용 컬럼 오탐 노출 / '8' 같은 부분 오탐 |
| 6.3 | `divisionId` deps 누락 | division 변경해도 컬럼 재필터 안 됨 |
| 6.4 | 공유 SP / GridColumn DTO 변경으로 DIVISION_ID 직접 노출 시도 | BE 무변경 룰 위반 + 전 화면 회귀 위험 |
| 6.5 | DIVISION_ID 없는 컬럼에 임의 division 값 INSERT | #78 임의 데이터 생성 위반 |
| 6.6 | 하드코딩 `if (divisionId==='40') 컬럼배열` | admin 메타 무효화 — 운영 변경 미반영 |

---

## §7. 적용 이력

| 화면 | attribute | 적용일 | 비고 |
|---|---|---|---|
| DMF0020 (Sales Future Price) | ATTRIBUTE3 | 2026-06-27 | master reference. 'Sales Price' sheet. |

---

## Cross-ref
- `ui-category-setup-column-meta.md` (#65) — 동적 컬럼 메타 fetch (전제)
- `ui-category-setup-no-arbitrary-data.md` (#78) — 임의 메타 생성 금지
- `wijmo-direct-static-columns` 계열 — 동적 컬럼 visible 필터 패턴
- 메모리 `feedback_be_attribute1_empty_division_all` / `feedback_fe_grid_visible_no_fallback_loss`
