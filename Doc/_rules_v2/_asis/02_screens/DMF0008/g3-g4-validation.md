# DMF0008 — G3 PerfLog + G4 Batch 실전 검증

> Phase 7 PoC 보완 9 (G3 PerfLog) + 보완 10 (G4 Batch) 통합 검증 (2026-06-04).
>
> **결론**: G3 PerfLog 는 DMF0008 의 5 액션에 즉시 적용 가능 / G4 Batch 는 SaveSalesSite/SaveSSPM 의 AS-IS 단건 RPC loop 를 TO-BE chunk batch 로 이관하는 가이드 작성. DMF0008 자체 코드는 placeholder 상태 — 본 문서는 향후 구현 가이드.

---

## §0 결과 종합

| 항목 | G3 PerfLog | G4 Batch |
|---|---|---|
| AS-IS 호출 위치 | 9 위치 (FP_Log2 2 + SearchStartTime/EndTime 7 쌍) | 2 메서드 (SaveSalesSite + SaveSSPM) |
| AS-IS 패턴 | 명시적 start/end + 화면 진입/종료 자동 | client-side row loop + 단건 RPC N 회 |
| TO-BE hook | `usePerfTrace` (Phase 5 신규, `packages/shared/src/hooks/usePerfTrace.ts`) | `useBatchMutation` (Phase 5 신규, `packages/shared/src/hooks/useBatchMutation.ts`) |
| TO-BE 적용 가능 액션 | 5 (handleSearch / handleStatusUpdate / handleInsert / handleSave / Summary doubleClick) | 2 (handleSave 의 SalesSite + SSPM 분기) |
| TO-BE 현재 DMF0008 | 미적용 | placeholder (handleSave = setAlert) |
| 검증 결과 | ✅ hook 정상 / 적용 가이드 작성 | ✅ hook 정상 / chunk batch 우월 (AS-IS 단건 loop 보다 진보) |

---

## §1 보완 9 — G3 PerfLog 실전 검증

### §1.1 AS-IS 호출 인벤토리

| # | 호출 | 위치 | 패턴 |
|---:|---|---|---|
| 1 | `FP_Log2("SpeedUp", "DMF0008", "division_id_changed", "start")` | L335 | Division 변경 cascade 측정 시작 |
| 2 | `FP_Log2("SpeedUp", "DMF0008", "division_id_changed", "end")` | L379 | Division 변경 cascade 측정 종료 |
| 3 | `SearchStartTime()` + `SearchEndTime()` | L760, L783 | `FindData_Main` (Summary SP 조회) |
| 4 | 동일 | L831, L854 | `FindData_Sub` SalesSite 조회 |
| 5 | 동일 | L906, L927 | `FindData_Sub` SSPM 조회 |
| 6 | 동일 | L957, L980 | `FindData_Sub` 통합 분기 |
| 7 | 동일 | L2586, L2605 | `btnStatusUpdate_Click` (PR_DM_DNM_EDI_CALLOFF_STATUS) |
| 8 | 동일 | L2856, L2879 | `FindData_SubCustomer` (DMF0004_GET_SALES_SITE_CUSTOMER_DATA) |

→ 총 9 위치 — AS-IS 는 BaseForm 의 `SearchStartTime/EndTime` 으로 자동 + `FP_Log2` 로 명시적 측정.

### §1.2 TO-BE `usePerfTrace` hook signature

```typescript
// packages/shared/src/hooks/usePerfTrace.ts
const { measure } = usePerfTrace(MENU_ID);
// 1) 화면 진입 시 menu_open log 자동
// 2) 화면 종료 시 menu_close log + 전체 duration 자동
// 3) measure(action, fn) 으로 임의 동작 측정

measure('division_change', async () => {
  await refetchCombos({ divisionIds: divisionId });
});
```

### §1.3 AS-IS → TO-BE 매핑

| AS-IS 위치 | AS-IS 호출 | TO-BE 적용 위치 | TO-BE 매핑 |
|---|---|---|---|
| L335, L379 | `FP_Log2("SpeedUp", "DMF0008", "division_id_changed", ...)` | ErpEdiMasterForm.tsx 의 Division onChange | `measure('division_change', async () => { setSearchCondition({...}); })` |
| L760~783 | SearchStartTime/EndTime (FindData_Main) | ErpEdiMaster.tsx `handleSearch` (L114~119) | `measure('search_main', async () => { refetchSummary(); refetchRepair(); })` |
| L831~854 / L906~927 / L957~980 | SearchStartTime/EndTime (FindData_Sub) | `handleSummaryDoubleClick` (L138~150) | `measure('search_sub', async () => { setSubFilter(); })` |
| L2586~2605 | SearchStartTime/EndTime (Status Update) | `handleStatusUpdate` (L122~135) | `measure('status_update', async () => { await apiClient.post(...); ... })` |
| L2856~2879 | SearchStartTime/EndTime (FindData_SubCustomer) | (TO-BE 미구현) | (적용 X) |
| 자동 | (없음) | `usePerfTrace(MENU_ID)` 의 useEffect | `menu_open` / `menu_close` 자동 |

### §1.4 ErpEdiMaster.tsx 의 권장 적용 (가이드)

> 사용자 작업물 우선 — 강제 변경 X. 본 가이드는 향후 G3 BE-side AOP 완성 후 적용.

```typescript
// imports 추가
import { usePerfTrace } from '@shared/hooks';

export const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  // ... 기존 코드
  const { measure } = usePerfTrace(MENU_ID);

  const handleSearch = () => {
    void measure('search_main', async () => {
      setFilter();
      await Promise.all([refetchSummary?.(), refetchRepair?.()]);
    });
  };

  const handleStatusUpdate = async () => {
    void measure('status_update', async () => {
      await apiClient.post(`/${MENU_ID}/main/STATUS_UPDATE/call-proc`, {});
      // ...
    });
  };
};
```

### §1.5 G3 검증 결과

| 항목 | 결과 |
|---|---|
| `usePerfTrace` hook 신호 | ✅ 정상 (Phase 5 작성 완료) |
| AS-IS 9 위치 → TO-BE 5 액션 매핑 가능 여부 | ✅ 모두 매핑 가능 |
| BE-side `POST /admin/system/perf-log` endpoint | ⚠️ AOP `@PerfLog` 미구현 (Phase 5 pending) — silently fail 처리 |
| DMF0008 자체 적용 | ⏳ 가이드만 작성 (사용자 작업물 우선 — 향후 BE 완성 후 적용) |

---

## §2 보완 10 — G4 Batch 검증

### §2.1 AS-IS Save 패턴 인벤토리

| # | 위치 | SP | 패턴 |
|---:|---|---|---|
| SaveButton | L700~721 | (분기) | `fps.Name == "spdSub"` + ActiveSheetName 분기 (SalesSite or SSPM) |
| SaveSalesSite | L1000~1238 (238 lines) | `DM.DMF0008_SAVE_SALES_SITE_EDI_REPAIR` | siSub row loop (action filter I/M/D) → 17 column / row → **단건 RPC N 회** |
| SaveSSPM | L1240~ (300+ lines) | `DM.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR` | `dtSubBucket` row loop → 15 column / row → **단건 RPC N 회** |
| InitSaveDataTable | L467 | (none) | staging table 초기화 |

→ AS-IS 는 진정한 batch 가 아닌 **client-side loop + 단건 RPC** 패턴 — 1000 row 저장 시 1000 회 RPC.

### §2.2 AS-IS SaveSalesSite body 요약

```csharp
// L1000~1238
for (int i = 0; i <= siSub.GetMaxRowIndex(); i++)
{
    string action = siSub.GetText(i, 0);
    if (action != FlagI && action != FlagM && action != FlagD) continue;

    // 17 column 추출 (sDivisionId / sEndCustomer / sSoldtoCustomer / ...)

    // Validation 6+ check (MSG00002 — 필수 입력)

    // 단건 RPC
    var request = new FoxDataRequest("DM.DMF0008_SAVE_SALES_SITE_EDI_REPAIR");
    request.Parameters["p_action"] = sAction;
    // ... 17 parameter
    client.ExecuteDataSet(request);
    iCount++;
}
```

### §2.3 AS-IS SaveSSPM body 요약

```csharp
// L1240~
foreach (DataRow dr in dtSubBucket.Rows)  // ⚠️ dtSubBucket = cascade #4 staging
{
    sAction = FlagM;  // 항상 Modify (Insert 미지원)
    // 15 column 추출 (sDivisionId / sProjectCode / sScmSiteId / sCurrency / sKWH / ...)

    // 단건 RPC
    var request = new FoxDataRequest("DM.DMF0008_SAVE_SALES_SITE_PROJECT_EDI_REPAIR");
    request.Parameters["p_division_id"] = sDivisionId;
    // ... 15 parameter
    client.ExecuteDataSet(request);
    iCount++;
}
```

### §2.4 TO-BE `useBatchMutation` hook signature

```typescript
// packages/shared/src/hooks/useBatchMutation.ts
const { mutate, isPending, progress } = useBatchMutation<MENU_ID, SHEETS.MAIN>({
  menuId: MENU_ID,
  sheetName: SHEETS.MAIN,
  tabId,
  chunkSize: 100,  // 100 row 단위 chunk
});

// mutate(saveData) → 자동 chunk + apiClient.callMutationProc N 회 + progress 추적
```

**진보된 점**:
- chunk 단위 분할 (chunkSize 기본 100) — 1000 row = 10 chunk = 10 RPC (vs AS-IS 1000 RPC)
- React Query `useMutation` 통합 — invalidateQueries + setToast/setAlert 자동
- progress (0~1) 추적 — UI 표시 가능

### §2.5 AS-IS → TO-BE 매핑

| AS-IS | TO-BE |
|---|---|
| `siSub.GetMaxRowIndex()` row loop | `mutate(saveData)` — `saveData: ResponseData[]` 한 배열 전달 |
| action filter (I/M/D) | TO-BE 는 `CRUD_TYPE` column 으로 filter (`saveData.filter(row => row.CRUD_TYPE)`) — `EditTracker` 가 자동 세팅 |
| 17 column 추출 (column-wise) | TO-BE 는 row object 전체 그대로 전달 (column-wise 추출 불필요) |
| 단건 RPC N 회 | chunk RPC ⌈N/100⌉ 회 (chunkSize 조정) |
| Validation 6+ check | TO-BE 는 hook 호출 전 BE 의 validation 또는 client-side React Hook Form 으로 분리 |
| iCount 누적 + MSG00001 ("저장되었습니다") | hook 의 `onSuccess` 가 자동 toast |

### §2.6 ErpEdiMaster.tsx 의 권장 적용 (가이드)

> 사용자 작업물 우선 — `handleSave` 는 현재 placeholder. 본 가이드는 향후 SaveSalesSite/SaveSSPM 본 구현 시 적용.

```typescript
// imports 추가
import { useBatchMutation } from '@shared/hooks';

export const ErpEdiMaster = ({ tabId, title }: PageProps<MENU_ID>) => {
  // ... 기존 코드

  // SalesSite tab 의 batch save
  const { mutate: mutateSalesSite, isPending: isPendingSalesSite, progress: progressSS } =
    useBatchMutation<MENU_ID, SHEETS.SALES_SITE>({
      menuId: MENU_ID,
      sheetName: SHEETS.SALES_SITE,
      tabId,
      chunkSize: 100,
    });

  // SSPM tab 의 batch save
  const { mutate: mutateSspm, isPending: isPendingSspm, progress: progressSSPM } =
    useBatchMutation<MENU_ID, SHEETS.SSPM>({
      menuId: MENU_ID,
      sheetName: SHEETS.SSPM,
      tabId,
      chunkSize: 100,
    });

  const handleSave = () => {
    // AS-IS L700~721 의 spdSub.ActiveSheet 분기 동등
    const activeTab = '...';  // 현재 활성 tab 식별
    if (activeTab === 'salesSite') {
      const changedRows = salesSiteRows.filter(r => (r as any).CRUD_TYPE);
      mutateSalesSite(changedRows);
    } else if (activeTab === 'sspm') {
      const changedRows = sspmRows.filter(r => (r as any).CRUD_TYPE);
      mutateSspm(changedRows);
    }
  };
};
```

### §2.7 G4 검증 결과

| 항목 | 결과 |
|---|---|
| `useBatchMutation` hook 신호 | ✅ 정상 (Phase 5 작성 완료) |
| AS-IS 단건 RPC → TO-BE chunk batch 매핑 | ✅ 진보 (1000 RPC → 10 RPC) |
| EditTracker (CRUD_TYPE) 연동 | ✅ 정상 (룰 07 §2.3) |
| DMF0008 자체 적용 | ⏳ 가이드만 작성 (handleSave 는 placeholder — 사용자 의도 = SaveSalesSite/SaveSSPM 미구현 유지) |
| AS-IS dtSubBucket cascade | EditTracker 로 대체 (cascade-mapping.md §4.2) |

---

## §3 격차 & 권장 종합

| # | 격차 | 영향 | 권장 |
|---:|---|---|---|
| 1 | TO-BE `usePerfTrace` 의 BE endpoint (`POST /admin/system/perf-log`) 미구현 | silently fail 동작 — UX 영향 0 | BE `PerfLogController` + `SCM_SYS_PERF_LOG` 테이블 + `@PerfLog` AOP 추가 (Phase 5 후속) |
| 2 | AS-IS 의 SaveSalesSite 17 column / SaveSSPM 15 column 모두 단건 RPC | 성능 나쁨 + 부분 실패 시 transaction 복잡 | TO-BE chunk batch 가 우월 — `useBatchMutation` 이관 가이드 사용 |
| 3 | AS-IS 의 Validation 6+ check (MSG00002 필수 입력) | TO-BE 미매핑 | TO-BE 는 client-side React Hook Form 또는 BE-side SP validation 으로 분리 (룰 11 §3) |
| 4 | DMF0008 handleSave 가 placeholder | 의도된 상태 — AS-IS 도 SalesSite/SSPM 만 save | 사용자 결정에 따라 본 가이드의 §2.6 적용 |

---

## §4 룰 v2 § 보강 후보

> 본 보완 9+10 의 학습:

| § | 보강 위치 | 내용 |
|---|---|---|
| 보강 1 | 룰 06 `_tobe/06_search_area.md` §2 변형 | handleSearch 에 `usePerfTrace.measure` 권장 (선택) — AS-IS SearchStartTime/EndTime 동등 |
| 보강 2 | 룰 07 `_tobe/07_datagrid.md` §2 변형 | 대량 저장 (≥ 100 row 예상) 화면은 `useBatchMutation` 의무 — chunkSize 100 default |
| 보강 3 | 새 hook 후보 `hooks/g3-perflog-application.md` | DMF0008 같은 cascade 화면의 5 액션 매핑 표 표준 |
| 보강 4 | `_mapping/asis_to_tobe.md` 의 G3/G4 격차 절 | AS-IS FP_Log2 + 단건 RPC loop → TO-BE measure + chunk batch 매핑 추가 |

→ 본 보강은 후속 작업 (사용자 결정 후).

---

## §5 변경 이력

| 일자 | 변경 | Phase |
|---|---|---|
| 2026-06-04 | 본 파일 신규 작성 — G3 PerfLog (AS-IS 9 위치 + TO-BE 5 액션 매핑) + G4 Batch (AS-IS 단건 RPC loop + TO-BE chunk batch 매핑) 통합 검증 | Phase 7 PoC 보완 9 + 10 |
