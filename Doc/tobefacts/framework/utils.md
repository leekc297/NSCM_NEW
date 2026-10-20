# utils (270)

사용 수 내림차순. **신규 화면은 여기 있는 것만 쓴다** — 없으면 사전(map_control.csv) 보완 제안이 먼저(룰 23).

## app-shell

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **MAX_MOUNTED_TABS** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  | 동시에 마운트(keep-alive)로 살려두는 탭 상한. ViewContainer 는 활성화된 적 있는 탭을 keep-alive 로 계속 마운트해 두는데, 무거운 그리드 화면이 누적되면 CollectionView(행 데이터)가 JS 힙에 계속 상주해  |
| **MDI_TAB_MODE** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  |  |
| **resetView** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  | 캐시된 lazy 인스턴스를 폐기한다 — 재시도용. React.lazy 는 로더 promise 가 한 번 reject 되면 그 실패를 영구 캐시한다. dev 서버 재시작/중단, 일시적 500 등으로 모듈 fetch 가 실패하면 ('Failed to fe |
| **resolveView** | `apps/web/src/mdi (앱 셸 — 화면에서 직접 import 하지 않음)` | 0 |  | DB 메뉴 정보(routePath/mnuUrl)로 화면 컴포넌트를 조회. 매칭되는 페이지 모듈이 없으면 undefined (ViewContainer 가 빈 화면 처리). |

### resetView  <sub>apps/web/src/mdi/viewRegistry.tsx:107</sub>

```ts
(menu: { routePath?: string; mnuUrl?: string; }): void
```

props/params:

- `routePath?: string`
- `mnuUrl?: string`

### resolveView  <sub>apps/web/src/mdi/viewRegistry.tsx:82</sub>

```ts
(menu: { routePath?: string; mnuUrl?: string; }): any
```

props/params:

- `routePath?: string`
- `mnuUrl?: string`

## foundation

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **CRUD_TYPE** | `@foundation/constants` | 63 |  |  |
| **CRUD_MSG** | `@foundation/constants` | 16 |  | CRUD 흐름에서 공통으로 사용하는 메시지 정의입니다. |
| **API_CONFIG** | `@foundation/constants` | 1 |  |  |
| **CACHE_MAX_AGE** | `@foundation/lib` | 0 |  | 캐시 유지시간(8시간). gcTime 과 PersistQueryClientProvider 의 persist maxAge 를 동일하게 유지해야 영속화가 정상 동작한다(react-query: persist 하려면 gcTime >= maxAge 필요). P |
| **NEGATIVE_TEXT_COLOR** | `@foundation/utils` | 0 |  | 음수 셀 = 빨간 글자 — 그리드 공통 규약 (REQ:CHAT-20260820-6). mkt-fcst / demand-manager / contribute-view / sales-reports / etc-sales-reports 가 각자 같은 코드를  |
| **ROUTE_PATHS** | `@foundation/constants` | 0 |  | 라우트 경로 상수 화면(mnuId)별 경로 매핑은 DB 로 이관됨 — SCM_ADM_MNU_M.ROUTE_PATH (세션 메뉴 응답의 menu.routePath 를 viewRegistry.resolveView 가 해석). 여기에는 메뉴 데이터가 아닌  |
| **ROW_NO_BINDING** | `@foundation/utils` | 0 |  | No 컬럼/헤더 — SYS0011 그리드 공통 (사용자 요구 2026-06-28), 팝업(*Modal.tsx) 그리드 공통 적용 // (2026-09-03)으로 foundation 으로 승격. // · 체크박스 없는 그리드: rowHeader 인덱스  |
| **VOLATILE_QUERY_OPTIONS** | `@foundation/lib` | 0 |  | 콤보/룩업 전용 캐시 정책 — useCustomQueryClient 의 콤보/룩업 훅에서 스프레드한다. staleTime: 0 = 화면을 새로 열 때(fresh mount)마다 다시 받는다. MDI 는 keep-alive 라 이미 열린 탭은 리마운트되 |
| **CELL_INPUT_EDIT_TYPE** | `@foundation/constants` | 64 |  |  |
| **CELL_CONTROL_TYPE** | `@foundation/constants` | 39 |  |  |
| **BUTTON_TYPE** | `@foundation/constants` | 13 |  |  |
| **Hotkeys** | `@foundation/models` | 0 |  |  |
| **HTTP_STATUS** | `@foundation/constants` | 0 |  |  |
| **safeString** | `@foundation/utils` | 41 |  | unknown 값을 표시·비교용 문자열로 안전 변환. 왜 필요한가 — SP 커서 행의 값 타입은 `unknown`(또는 WijmoPrimitive) 이라 `String(v ?? '')` 를 쓰면 린트 규칙 `no-base-to-string` 이 막는다 |
| **attachRowNoHeader** | `@foundation/utils` | 22 |  | (체크박스 없는 그리드) 기존 rowHeader 순번(1,2,3…) 컬럼의 좌상단 코너 헤더(TopLeft 패널)에 // 'No' 라벨 추가. CellType.TopLeft 로 코너 셀 직접 타겟 (formatItem 1회 부착 가드 + invalid |
| **buildNoColumn** | `@foundation/utils` | 16 |  | (체크박스 그리드) No 데이터 컬럼 — itemsSource 의 ROW_NO 값 표시. |
| **withRowNo** | `@foundation/utils` | 16 |  | itemsSource 각 행에 ROW_NO(=index+1) 주입 (읽기전용 그리드라 무해). |
| **toGridNumber** | `@foundation/utils` | 12 |  | 셀 표시값 → 숫자. 콤마 제거, 숫자가 아니면 0 (문자/코드 컬럼은 자연히 음수 판정에서 빠진다). |
| **isInsertRow** | `@foundation/utils` | 10 |  | 신규 입력행(CRUD_TYPE='I') 판정 — 값이 같아도 인접 행과 병합하지 않기 위한 공통 가드. // 병합되면 owner(상단 행)가 편집을 대표해 기존 행이 함께 바뀌는 문제로 이어진다. // mkt-fcst/sales-plan 등 Hiera |
| **paintNegativeText** | `@foundation/utils` | 10 |  | 음수면 빨간 글자, 아니면 원복. 필수: 음수가 아닐 때 반드시 지운다 — Wijmo 는 셀 DOM 을 재사용하므로 칠하기만 하면 스크롤 뒤 엉뚱한 셀에 색이 남는다. 필수: important 로 넣는다 — 편집/잠금 셀 클래스(.wj-cell-edi |
| **keepRowVisibleUnderFilter** | `@foundation/utils` | 6 |  | 필터가 걸린 상태에서 추가한 신규행이 화면에서 사라지는 문제 보정. FlexGridFilter._filter 는 `grid._newAddedRowsSet`(WeakSet) 에 든 행을 조건 검사 없이 통과시킨다 — 편집한 행이 필터 때문에 눈앞에서 사 |
| **parseComboFilterBindings** | `@foundation/utils` | 4 |  | 셀 콤보 행 단위 필터 조건 (컬럼 메타 ATTRIBUTE2) 을 파싱한다. 문법: `'행컬럼:콤보컬럼'`, 조건이 여럿이면 콤마로 잇는다. 예) `'DIVISION_ID:DIVISION_ID,END_CUSTOMER:END_CUSTOMER'` 형식에  |
| **ensureTopLeftMergeManager** | `@foundation/utils` | 2 |  |  |
| **rebindFilterColumns** | `@foundation/utils` | 2 |  | columnGroups 재대입으로 버려진 Column 을 붙들고 있는 필터를 현재 컬럼에 다시 묶는다. wijmo 의 `set columnGroups(e){ this.columns.clear(); this._grpHdl.createColumnGroup |
| **stripRequiredMark** | `@foundation/utils` | 2 |  | 라벨 끝 필수표시(`*`)를 떼어낸 표시용 라벨. |
| **buildLeafColumnDataMap** | `@foundation/utils` | 1 |  | 콤보 컬럼의 DataMap 을 만든다 — 행 파라미터(PARAM10='D')면 getRowParamDataMap, 아니면 getDataMap. toLeafColumn 이 컬럼 config 에 dataMap 을 굽는 것과 같은 판정이다. 공용 DataG |
| **captureGridFilter** | `@foundation/utils` | 1 |  | 조회로 데이터가 다시 실리기 직전의 컬럼 필터를 떠 둔다 (restoreGridFilter 와 한 쌍). wijmo 는 `itemsSourceChanged` 에서 필터를 통째로 비운다(FlexGridFilter 생성자가 clear 를 직접 건다). 이 |
| **captureGridSort** | `@foundation/utils` | 1 |  | `itemsSource` 가 새 배열로 갈리기 직전, 사용자가 헤더 클릭으로 건 정렬을 떠 둔다 (`restoreGridSort` 와 한 쌍 — `captureGridFilter`/`restoreGridFilter` 의 정렬판). wijmo `Flex |
| **clearCellValue** | `@foundation/utils` | 1 |  | 상위 콤보 변경 등으로 하위 셀을 ''(빈값)으로 비우면서 수정상태(M)를 정확히 갱신한다 (DataGrid clearStaleComboCellsHandler 와 같은 규약 — 화면 cascade 에서 재사용). 이미 빈 셀은 건드리지 않는다(불필요한 |
| **filterComboRowsByRowItem** | `@foundation/utils` | 1 |  | 행 컨텍스트로 콤보 후보를 좁힌다 — 드롭다운 후보와 값 유효성 판정의 **단일 기준**. 표시(getDataMap)와 상위 변경 시 하위 값 정리(comboCascade)가 같은 함수를 써야 "드롭다운에 뜨는 값 = 셀에 남을 수 있는 값" 불변식이 |
| **getInsertAnchor** | `@foundation/utils` | 1 |  | `pinInsertedRow` 로 등록해 둔 앵커를 조회한다 — 이 행이 아직 저장 전 신규행이고 pin 이 걸려 있으면 그 앵커 객체를, 아니면 `undefined` 를 돌려준다. 용도: 화면이 자체적으로 행 배열을 재정렬해야 하는 경우(예: for |
| **isRowParamCombo** | `@foundation/utils` | 1 |  | 행 파라미터 콤보 판정 — 컬럼 메타 PARAM10(ATTRIBUTE10) 이 'D' 인 콤보 컬럼. D 면 PARAM2 오른쪽이 "콤보 결과 컬럼명" 이 아니라 "콤보 SQL 바인드명" 으로 해석된다. 같은 슬롯에 두 문법이 겹치므로 판정이 곧 해석 |
| **restoreGridFilter** | `@foundation/utils` | 1 |  | captureGridFilter 로 떠 둔 필터를 새로 실린 데이터 위에 다시 적용한다. 지금 그리드에 없는 컬럼의 필터는 버린다. wijmo 는 binding 으로 컬럼을 못 찾으면 화면에 없는 Column 을 즉석에서 만들어 필터를 붙이는데(set |
| **restoreGridSort** | `@foundation/utils` | 1 |  | `captureGridSort` 로 떠 둔 정렬을 새로 실린 데이터 위에 다시 적용한다. 지금 그리드에 없는 컬럼을 가리키는 정렬은 버린다 — division 전환처럼 컬럼 구성이 바뀌는 조회에서 존재하지 않는 컬럼을 정렬 대상으로 복원하면 보이지도  |
| **rowParamValues** | `@foundation/utils` | 1 |  | 행 파라미터 콤보의 SQL 바인드 값 — PARAM2 의 `행컬럼:바인드명` 을 바인드명 기준으로 접는다. 한 바인드명에 행 컬럼을 여러 개 걸 수 있다. 같은 뜻의 값이 division 에 따라 다른 컬럼으로 내려오는 경우가 있어서다 — End Cu |
| **sortComboDisplayNames** | `@foundation/utils` | 1 |  | 표시 목록 정렬 — 숫자 -> 영어 -> 한글 -> 그 외, 같은 갈래 안에서는 사전순. 주의: 공용 콤보(getDataMap/getRowParamDataMap)는 더 이상 이 정렬을 쓰지 않는다. AS-IS 처럼 콤보 SQL/서버 응답 순서를 그대로 |
| **camelCase** | `@foundation/utils` | 0 |  |  |
| **capitalize** | `@foundation/utils` | 0 |  | 문자열 유틸리티 |
| **clamp** | `@foundation/utils` | 0 |  |  |
| **clampNegativeCellToZero** | `@foundation/utils` | 0 |  | 편집 종료 시 음수가 들어온 수치셀을 '0' 으로 보정한다 (AS-IS Dsdm_Changed L1186~1193 파리티: CONVERT_QTY_PACK/MODULE/CELL 에 음수 입력 시 SetText(..., "0")). 입력 자체는 막지 않고 |
| **clearAllPersistedCaches** | `@foundation/lib` | 0 |  | 남아있는 모든 세션의 영속 캐시 레코드 삭제 — 로그인 시점(useSessionStore.login) 정리용. 현재 세션 키만 지우면 소용이 없다. 캐시 키의 시드(rq-session-id)는 탭별 sessionStorage 라 로그인하는 탭은 대개  |
| **clearPersistedCache** | `@foundation/lib` | 0 |  | 영속 캐시(IndexedDB) 레코드 삭제. 로그아웃 정리(useClearAppData)와 탭 종료 시 호출한다. 이 호출이 없으면 이전 계정의 그리드 데이터가 담긴 레코드가 디스크에 남는다 — queryClient.clear() 가 removed 이 |
| **collectLiveColumnExportMeta** | `@foundation/utils` | 0 |  | `grid.columns.clear()` 로 컬럼을 갈아끼우기 전에, 원본 컬럼에서 export 에 필요한 정보를 뜬다. ⭐ dataMap 스냅샷 (2026-08-11 사용자 요구 — 전체 화면 공통). 콤보의 CODE→NAME dataMap 이 붙는 |
| **comboCacheKey** | `@foundation/utils` | 0 |  | 콤보 캐시/조회 키 — 같은 comboId 라도 lookupType(PARAM1) 이 다르면 서로 다른 코드셋이므로 별개로 캐시해야 한다(한 그리드에 LookupCommon 을 Status·Change Status 가 각자 쓰는 경우). lookupT |
| **comboKeyOfColumn** | `@foundation/utils` | 0 |  | 컬럼의 콤보 캐시 키(cellCboDataTp + PARAM1). DataGrid 콤보 조회/적용이 같은 키를 쓴다. |
| **comboLookupType** | `@foundation/utils` | 0 |  | 콤보 lookupType — 컬럼 메타 PARAM1(ATTRIBUTE1). 범용 콤보(LookupCommon/LookupCommon3 등 SQL 이 `WHERE LOOKUP_TYPE=@lookupType`)의 코드셋을 지정한다(예: SHIPMENT_S |
| **fillEmptyCellWithZero** | `@foundation/utils` | 0 |  | 편집 종료 시 비어 있는 수치셀을 '0' 으로 채운다 (AS-IS spdMain_Changed L1295~1302 파리티). 빈 셀에 Delete/공백 커밋이 들어와도 저장 payload 가 빈 문자열이 아닌 '0' 을 보내게 하는 규약. 주의: 이  |
| **filterComboRowsByCascade** | `@foundation/utils` | 0 |  | 행 컨텍스트로 콤보 후보를 좁힌다 — 화면이 코드로 든 cascade 표를 적용하는 경로. 위 filterComboRowsByRowItem(컬럼 메타 attribute2 주도)과 규칙이 다르다. 여기에는 콤보 쪽 관대 통과가 있다 — 콤보 행에 그 컬 |
| **findStaleComboCells** | `@foundation/utils` | 0 |  | 상위 콤보 변경으로 더 이상 고를 수 없게 된 하위 셀을 찾는다. 불변식: 셀 값은 언제나 그 시점 드롭다운 후보 안에 있다. 후보 판정은 표시(getDataMap)와 똑같이 `filterComboRowsByRowItem` 을 쓴다 — 규칙이 갈리면  |
| **findStaleRowParamComboCells** | `@foundation/utils` | 0 |  | 재조회형(PARAM10='D') 상위 콤보를 바꾼 뒤, 새 후보 밖으로 밀려난 하위 셀을 찾는다. findStaleComboCells 의 재조회형 대응판이다. 그쪽은 콤보 결과 컬럼과 행 값을 클라에서 비교하는 필터형만 판정하고 행 파라미터 콤보는 제 |
| **formatCurrency** | `@foundation/utils` | 0 |  |  |
| **formatDate** | `@foundation/utils` | 0 |  | 날짜 포맷팅 유틸리티 |
| **formatDateTime** | `@foundation/utils` | 0 |  |  |
| **formatNumber** | `@foundation/utils` | 0 |  | 숫자 유틸리티 |
| **getUuid** | `@foundation/utils` | 0 |  |  |
| **hasRequiredMark** | `@foundation/utils` | 0 |  | 라벨 끝이 필수표시(`*`)인가. |
| **insertComboId** | `@foundation/utils` | 0 |  | 신규행 전용 콤보 ID — 컬럼 메타 PARAM9(ATTRIBUTE9). 값이 있으면 신규행(CRUD_TYPE='I')에서만 cellCboDataTp 대신 이 콤보를 본다. 조회로 내려온 행은 종전대로 cellCboDataTp 다. 방식(필터/재조회) |
| **installInsertPinConverter** | `@foundation/utils` | 0 |  | `pinInsertedRow` 로 등록해 둔 pin 을 지금 `grid.collectionView` 에 실제로 적용한다 (`sortConverter` 설치, 정렬 계산에만 쓰이는 값을 앵커 값으로 바꿔치기). CollectionView 가 바뀔 때마다 |
| **isNonEditableDateColumn** | `@foundation/utils` | 0 |  |  |
| **isTypingAllowed** | `@foundation/utils` | 0 |  | 타이핑 중인 문자열이 규칙 위반으로 굳어지는지 판정한다. `-`, `1.` 처럼 아직 완성되지 않은 입력은 통과시키고, 이미 규칙을 어긴 문자('-', '.', 초과 소수 자릿수)만 거부한다. |
| **isValueAllowed** | `@foundation/utils` | 0 |  | 편집 종료 또는 붙여넣기로 확정될 값이 규칙을 만족하는지 판정한다. 빈 문자열은 값 없음이므로 통과한다. 숫자로 변환되지 않는 문자열의 거부는 Wijmo `dataType: Number` 가 맡는다. |
| **kebabCase** | `@foundation/utils` | 0 |  |  |
| **mapRawColumnsToWijmoColumns** | `@foundation/utils` | 0 |  |  |
| **normalizeDynamicColumns** | `@foundation/utils` | 0 |  | Delete 키로 숫자 셀이 안 지워지던 문제 — Wijmo Column.isRequired 기본값 null 은 // "String 이 아닌 컬럼(숫자/날짜/불리언)은 필수" 로 해석된다(Column.getIsRequired). // 그리고 Delet |
| **orderComboDisplayNames** | `@foundation/utils` | 0 |  | 콤보 표시 순서 — 콤보 SQL 의 ORDER BY(= 서버 응답) 순서를 그대로 둔다. 클라 재정렬은 하지 않는다. AS-IS 는 SP/콤보 SQL 이 내려준 순서를 그대로 셀 콤보에 꽂으므로(SCP0128 PlanGroup 등 순서가 깨진다는 신고 |
| **parseDate** | `@foundation/utils` | 0 |  |  |
| **pinInsertedRow** | `@foundation/utils` | 0 |  | 정렬이 걸린 그리드에서 신규행이 앵커(삽입 위치 계산에 쓰인 인접 행) 옆에 "계속" 붙어 있도록 pin(신규행 → 앵커)을 등록한다. 실제 정렬 비교에 개입하는 sortConverter 설치는 `installInsertPinConverter` 가 별 |
| **quoteComboParams** | `@foundation/models` | 0 |  |  |
| **quoteComboValue** | `@foundation/models` | 0 |  | 공통 콤보 파라미터 값 자동 인용 (single source). // // 배경: BE BaseService.makeComboQuery 는 등록 SQL(SCM_ADM_CMBO_SQL_M)의 @키 를 bind 가 아니라 // raw 문자열로 치환한다.  |
| **requestErrorInterceptor** | `@foundation/apis` | 0 |  |  |
| **requestInterceptor** | `@foundation/apis` | 0 |  |  |
| **resolveMenuLabel** | `@foundation/models` | 0 |  | 메뉴 라벨 표시용 공통 해석기 — 다국어(mnuMsgId) → mnuDesc → mnuId 순으로 폴백한다. 탭(MDITabs)과 페이지 타이틀(MainTitle)이 공유한다. 두 곳은 원래 폴백이 프로그램 ID(mnuId)라 다국어 라벨이 없는 메뉴 |
| **responseErrorInterceptor** | `@foundation/apis` | 0 |  |  |
| **responseInterceptor** | `@foundation/apis` | 0 |  |  |
| **revertRowChanges** | `@foundation/utils` | 0 |  | 그리드 없이 **데이터만으로** 미저장 변경을 되돌린다 — 신규행 제거 · 삭제/수정 마킹 해제 · 수정 셀 원본값 복원. 언마운트 시점처럼 wijmo 컨트롤이 이미 파괴됐을 수 있는 경로에서 쓰라고 분리했다. rows 는 화면이 넘긴 배열 그 자체를 |
| **rowParamKey** | `@foundation/utils` | 0 |  | 행 파라미터 조합 키 — PARAM2 선언 순서대로 행 값을 이어 붙인다. 조회 대상을 모을 때와 결과를 찾을 때가 반드시 이 함수를 함께 써야 한다. 규칙이 갈리면 조회는 나갔는데 후보를 못 찾아 드롭다운이 영영 비는 상태가 된다. |
| **rowParamValue** | `@foundation/utils` | 0 |  | 행 파라미터 값 정규화 — 조회 파라미터와 조합 키가 같은 규칙을 쓰도록 한 곳에 둔다. |
| **setQueryErrorHandler** | `@foundation/lib` | 0 |  |  |
| **shouldPersistQuery** | `@foundation/lib` | 0 |  | IndexedDB 영속 대상 필터(PersistQueryClientProvider 의 dehydrateOptions). 기본 규칙(성공한 쿼리만 영속)은 유지하고, 콤보/룩업만 제외한다. 제외하지 않으면 새로고침해도 옛날 콤보가 복원돼 위 staleT |
| **apiClient** | `@foundation/apis` | 283 |  |  |
| **i18n** | `@foundation/lib` | 16 |  |  |
| **queryClient** | `@foundation/lib` | 9 |  |  |
| **mockApiClient** | `@foundation/apis` | 0 |  |  |
| **primary** | `@foundation/styles` | 0 |  |  |
| **secondary** | `@foundation/styles` | 0 |  |  |
| **supportedLngs** | `@foundation/lib` | 0 |  |  |

### safeString  <sub>packages/foundation/src/utils/string.ts:28</sub>

```ts
(v: unknown): string
```

### attachRowNoHeader  <sub>packages/foundation/src/utils/gridRowNo.ts:36</sub>

```ts
(grid: FlexGrid, label: string): void
```

### buildNoColumn  <sub>packages/foundation/src/utils/gridRowNo.ts:16</sub>

```ts
(label: string): RawFlexGridColumnConfig
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### withRowNo  <sub>packages/foundation/src/utils/gridRowNo.ts:31</sub>

```ts
<T extends object>(rows: T[]): (T & { ROW_NO: number; })[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => T — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: T[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<T>[]): T[]; (...items: (T`
- `ConcatArray<T>)[]): T[]; } — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => T[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => T — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => T[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: T, b: T) => number) => T[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): T[]; (start: number, deleteCount: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: T[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends T>(predicate: (value: T, index: number, array: T[]) => value is S,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: T, index: number, array: T[]) => unknown, thisArg?: any) =>  — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: T, index: number, array: T[]) => void, thisArg?: any) => vo — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: T, index: number, array: T[]) => U, thisArg?: any) => U[ — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends T>(predicate: (value: T, index: number, array: T[]) => value is S,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends T>(predicate: (value: T, index: number, obj: T[]) => value is S, th — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: T, index: number, obj: T[]) => unknown, thisArg?: any) => nu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: T, start?: number, end?: number) => T[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => T[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, T]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<T> — Returns an iterable of values in the array`
- `includes: (searchElement: T, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: T, index: number, array: T[] — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => T — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<T> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### toGridNumber  <sub>packages/foundation/src/utils/gridNegativeText.ts:19</sub>

```ts
(value: unknown): number
```

### isInsertRow  <sub>packages/foundation/src/utils/mergeManager.ts:15</sub>

```ts
(item: Record<string, unknown>): boolean
```

### paintNegativeText  <sub>packages/foundation/src/utils/gridNegativeText.ts:38</sub>

```ts
(cell: HTMLElement, value: number): void
```

props/params:

- `accessKey: string — The **`HTMLElement.accessKey`** property sets the keystroke which a user can press to jump to a given element. [MDN Reference](https://developer.mozilla.org/doc`
- `accessKeyLabel: string — The **`HTMLElement.accessKeyLabel`** read-only property returns a string containing the element's browser-assigned access key (if any); otherwise it returns an `
- `autocapitalize: string — The **`autocapitalize`** property of the HTMLElement interface represents the element's capitalization behavior for user input. [MDN Reference](https://develope`
- `autocorrect: boolean — The **`autocorrect`** property of the HTMLElement interface controls whether or not autocorrection of editable text is enabled for spelling and/or punctuation e`
- `dir: string — The **`HTMLElement.dir`** property indicates the text writing directionality of the content of the current element. [MDN Reference](https://developer.mozilla.or`
- `draggable: boolean — The **`draggable`** property of the HTMLElement interface gets and sets a Boolean primitive indicating if the element is draggable. [MDN Reference](https://deve`
- `hidden: boolean — The HTMLElement property **`hidden`** reflects the value of the element's `hidden` attribute. [MDN Reference](https://developer.mozilla.org/docs/Web/API/HTMLEle`
- `inert: boolean — The HTMLElement property **`inert`** reflects the value of the element's `inert` attribute. [MDN Reference](https://developer.mozilla.org/docs/Web/API/HTMLEleme`
- `innerText: string — The **`innerText`** property of the HTMLElement interface represents the rendered text content of a node and its descendants. [MDN Reference](https://developer.`
- `lang: string — The **`lang`** property of the HTMLElement interface indicates the base language of an element's attribute values and text content, in the form of a MISSING: RF`
- `offsetHeight: number — The **`offsetHeight`** read-only property of the HTMLElement interface returns the height of an element, including vertical padding and borders, as an integer. `
- `offsetLeft: number — The **`offsetLeft`** read-only property of the HTMLElement interface returns the number of pixels that the _upper left corner_ of the current element is offset `
- `offsetParent: Element — The **`HTMLElement.offsetParent`** read-only property returns a reference to the element which is the closest (nearest in the containment hierarchy) positioned `
- `offsetTop: number — The **`offsetTop`** read-only property of the HTMLElement interface returns the distance from the outer border of the current element (including its margin) to `
- `offsetWidth: number — The **`offsetWidth`** read-only property of the HTMLElement interface returns the layout width of an element as an integer. [MDN Reference](https://developer.mo`
- `outerText: string — The **`outerText`** property of the HTMLElement interface returns the same value as HTMLElement.innerText. [MDN Reference](https://developer.mozilla.org/docs/We`
- `popover: string — The **`popover`** property of the HTMLElement interface gets and sets an element's popover state via JavaScript (`'auto'`, `'hint'`, or `'manual'`), and can be `
- `spellcheck: boolean — The **`spellcheck`** property of the HTMLElement interface represents a boolean value that controls the spell-checking hint. [MDN Reference](https://developer.m`
- `title: string — The **`HTMLElement.title`** property represents the title of the element: the text usually displayed in a 'tooltip' popup when the mouse is over the node. [MDN `
- `translate: boolean — The **`translate`** property of the HTMLElement interface indicates whether an element's attribute values and the values of its Text node children are to be tra`
- `writingSuggestions: string — The **`writingSuggestions`** property of the HTMLElement interface is a string indicating if browser-provided writing suggestions should be enabled under the sc`
- `attachInternals: () => ElementInternals — The **`HTMLElement.attachInternals()`** method returns an ElementInternals object. [MDN Reference](https://developer.mozilla.org/docs/Web/API/HTMLElement/attach`
- `click: () => void — The **`HTMLElement.click()`** method simulates a mouse click on an element. [MDN Reference](https://developer.mozilla.org/docs/Web/API/HTMLElement/click)`
- `hidePopover: () => void — The **`hidePopover()`** method of the HTMLElement interface hides a popover element (i.e., one that has a valid `popover` attribute) by removing it from the top`
- `showPopover: () => void — The **`showPopover()`** method of the HTMLElement interface shows a Popover_API element (i.e., one that has a valid `popover` attribute) by adding it to the top`
- `togglePopover: (options?: boolean) => boolean — The **`togglePopover()`** method of the HTMLElement interface toggles a Popover_API element (i.e., one that has a valid `popover` attribute) between the hidden `
- `addEventListener: { <K extends keyof HTMLElementEventMap>(type: K, listener: (this: HTMLElement, e —  The **`addEventListener()`** method of the EventTarget interface sets up a function that will be called whenever the specified event is delivered to the target`
- `removeEventListener: { <K extends keyof HTMLElementEventMap>(type: K, listener: (this: HTMLElement, e —  The **`removeEventListener()`** method of the EventTarget interface removes an event listener previously registered with EventTarget.addEventListener() from th`
- `attributes: NamedNodeMap — The **`Element.attributes`** property returns a live collection of all attribute nodes registered to the specified node. [MDN Reference](https://developer.mozil`
- `classList: DOMTokenList — The **`Element.classList`** is a read-only property that returns a live DOMTokenList collection of the `class` attributes of the element. [MDN Reference](https:`
- `className: string — The **`className`** property of the of the specified element. [MDN Reference](https://developer.mozilla.org/docs/Web/API/Element/className)`
- `clientHeight: number — The **`clientHeight`** read-only property of the Element interface is zero for elements with no CSS or inline layout boxes; otherwise, it's the inner height of `
- `clientLeft: number — The **`clientLeft`** read-only property of the Element interface returns the width of the left border of an element in pixels. [MDN Reference](https://developer`
- `clientTop: number — The **`clientTop`** read-only property of the Element interface returns the width of the top border of an element in pixels. [MDN Reference](https://developer.m`
- `clientWidth: number — The **`clientWidth`** read-only property of the Element interface is zero for inline elements and elements with no CSS; otherwise, it's the inner width of an el`
- `currentCSSZoom: number — The **`currentCSSZoom`** read-only property of the Element interface provides the 'effective' CSS `zoom` of an element, taking into account the zoom applied to `
- `id: string — The **`id`** property of the Element interface represents the element's identifier, reflecting the **`id`** global attribute. [MDN Reference](https://developer.`
- `innerHTML: string — The **`innerHTML`** property of the Element interface gets or sets the HTML or XML markup contained within the element. [MDN Reference](https://developer.mozill`
- `localName: string — The **`Element.localName`** read-only property returns the local part of the qualified name of an element. [MDN Reference](https://developer.mozilla.org/docs/We`
- `namespaceURI: string — The **`Element.namespaceURI`** read-only property returns the namespace URI of the element, or `null` if the element is not in a namespace. [MDN Reference](http`
- `onfullscreenchange: (this: Element, ev: Event) => any — [MDN Reference](https://developer.mozilla.org/docs/Web/API/Element/fullscreenchange_event)`
- `onfullscreenerror: (this: Element, ev: Event) => any — [MDN Reference](https://developer.mozilla.org/docs/Web/API/Element/fullscreenerror_event)`
- `outerHTML: string — The **`outerHTML`** attribute of the Element DOM interface gets the serialized HTML fragment describing the element including its descendants. [MDN Reference](h`
- `ownerDocument: Document — The read-only **`ownerDocument`** property of the Node interface returns the top-level document object of the node. [MDN Reference](https://developer.mozilla.or`
- `part: DOMTokenList — The **`part`** property of the Element interface represents the part identifier(s) of the element (i.e., set using the `part` attribute), returned as a DOMToken`
- `prefix: string — The **`Element.prefix`** read-only property returns the namespace prefix of the specified element, or `null` if no prefix is specified. [MDN Reference](https://`
- `scrollHeight: number — The **`scrollHeight`** read-only property of the Element interface is a measurement of the height of an element's content, including content not visible on the `
- `scrollLeft: number — The **`scrollLeft`** property of the Element interface gets or sets the number of pixels by which an element's content is scrolled from its left edge. [MDN Refe`
- `scrollTop: number — The **`scrollTop`** property of the Element interface gets or sets the number of pixels by which an element's content is scrolled from its top edge. [MDN Refere`
- `scrollWidth: number — The **`scrollWidth`** read-only property of the Element interface is a measurement of the width of an element's content, including content not visible on the sc`
- `shadowRoot: ShadowRoot — The `Element.shadowRoot` read-only property represents the shadow root hosted by the element. [MDN Reference](https://developer.mozilla.org/docs/Web/API/Element`
- `slot: string — The **`slot`** property of the Element interface returns the name of the shadow DOM slot the element is inserted in. [MDN Reference](https://developer.mozilla.o`
- `tagName: string — The **`tagName`** read-only property of the Element interface returns the tag name of the element on which it's called. [MDN Reference](https://developer.mozill`
- `attachShadow: (init: ShadowRootInit) => ShadowRoot — The **`Element.attachShadow()`** method attaches a shadow DOM tree to the specified element and returns a reference to its ShadowRoot. [MDN Reference](https://d`
- `checkVisibility: (options?: CheckVisibilityOptions) => boolean — The **`checkVisibility()`** method of the Element interface checks whether the element is visible. [MDN Reference](https://developer.mozilla.org/docs/Web/API/El`
- `closest: { <K extends keyof HTMLElementTagNameMap>(selector: K): HTMLElementTagNameMap[K] — The **`closest()`** method of the Element interface traverses the element and its parents (heading toward the document root) until it finds a node that matches `
- `computedStyleMap: () => StylePropertyMapReadOnly — The **`computedStyleMap()`** method of the Element interface returns a StylePropertyMapReadOnly interface which provides a read-only representation of a CSS dec`
- `getAttribute: (qualifiedName: string) => string — The **`getAttribute()`** method of the element. [MDN Reference](https://developer.mozilla.org/docs/Web/API/Element/getAttribute)`
- `getAttributeNS: (namespace: string, localName: string) => string — The **`getAttributeNS()`** method of the Element interface returns the string value of the attribute with the specified namespace and name. [MDN Reference](http`
- `getAttributeNames: () => string[] — The **`getAttributeNames()`** method of the array. [MDN Reference](https://developer.mozilla.org/docs/Web/API/Element/getAttributeNames)`

### keepRowVisibleUnderFilter  <sub>packages/foundation/src/utils/gridAction.ts:49</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>, row: T): void
```

### parseComboFilterBindings  <sub>packages/foundation/src/utils/columnMapping.ts:137</sub>

```ts
(bindingString?: string): Record<string, string>
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### ensureTopLeftMergeManager  <sub>packages/foundation/src/utils/mergeManager.ts:38</sub>

```ts
(grid: FlexGrid): void
```

### rebindFilterColumns  <sub>packages/foundation/src/utils/gridAction.ts:91</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>, gridFilter?: any): boolean
```

### stripRequiredMark  <sub>packages/foundation/src/utils/columnMapping.ts:655</sub>

```ts
(label?: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### buildLeafColumnDataMap  <sub>packages/foundation/src/utils/columnMapping.ts:638</sub>

```ts
(column: RawFlexGridColumnConfig): any
```

### captureGridFilter  <sub>packages/foundation/src/utils/gridAction.ts:138</sub>

```ts
(gridFilter?: any): string
```

### captureGridSort  <sub>packages/foundation/src/utils/gridAction.ts:196</sub>

```ts
(grid: FlexGrid): GridSortSnapshot[]
```

### clearCellValue  <sub>packages/foundation/src/utils/editTracker.ts:197</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(row: T, binding: string, tracker: EditTracker<T>): void
```

### filterComboRowsByRowItem  <sub>packages/foundation/src/utils/columnMapping.ts:266</sub>

```ts
(comboRows: ComboResponse[], bindingString: string, rowItem: WijmoRowItem): ComboResponse[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ComboResponse — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ComboResponse[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ComboResponse>[]): ComboResponse[]; (...items: any[]):  — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ComboResponse[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ComboResponse — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ComboResponse[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ComboResponse, b: ComboResponse) => number) => ComboResponse[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ComboResponse[]; (start: number, delete — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ComboResponse[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ComboResponse, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ComboResponse, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ComboResponse>(predicate: (value: ComboResponse, index: number, arr — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ComboResponse, index: number, array: ComboResponse[]) => unk — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ComboResponse, index: number, array: ComboResponse[]) => vo — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ComboResponse, index: number, array: ComboResponse[]) => — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ComboResponse>(predicate: (value: ComboResponse, index: number, arr — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ComboResponse, currentValue: ComboResponse, curre — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ComboResponse, currentValue: ComboResponse, curre — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ComboResponse>(predicate: (value: ComboResponse, index: number, obj — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ComboResponse, index: number, obj: ComboResponse[]) => unkno — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ComboResponse, start?: number, end?: number) => ComboResponse[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ComboResponse[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ComboResponse]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ComboResponse> — Returns an iterable of values in the array`
- `includes: (searchElement: ComboResponse, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ComboResponse, index: number — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ComboResponse — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ComboResponse> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### getInsertAnchor  <sub>packages/foundation/src/utils/gridAction.ts:600</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>, row: T): T
```

### isRowParamCombo  <sub>packages/foundation/src/utils/columnMapping.ts:203</sub>

```ts
(column: RawFlexGridColumnConfig): boolean
```

### restoreGridFilter  <sub>packages/foundation/src/utils/gridAction.ts:158</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>, gridFilter: any, definition: string): boolean
```

### restoreGridSort  <sub>packages/foundation/src/utils/gridAction.ts:215</sub>

```ts
(grid: FlexGrid, snapshot: GridSortSnapshot[]): boolean
```

### rowParamValues  <sub>packages/foundation/src/utils/columnMapping.ts:227</sub>

```ts
(bindings: Record<string, string>, rowItem: any): Record<string, string>
```

### sortComboDisplayNames  <sub>packages/foundation/src/utils/columnMapping.ts:518</sub>

```ts
(names: string[]): string[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => string — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: string[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => string[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => string — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => string[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: string, b: string) => number) => string[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): string[]; (start: number, deleteCount:  — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: string[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: string[]) => unknown, thisArg? — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: string[]) => void, thisArg?:  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: string[]) => U, thisArg?:  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: string[]) => — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: string[]) => unknown, thisArg?:  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: string, start?: number, end?: number) => string[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => string[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### camelCase  <sub>packages/foundation/src/utils/string.ts:13</sub>

```ts
(str: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### capitalize  <sub>packages/foundation/src/utils/string.ts:5</sub>

```ts
(str: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### clamp  <sub>packages/foundation/src/utils/number.ts:19</sub>

```ts
(num: number, min: number, max: number): number
```

props/params:

- `toString: (radix?: number) => string — Returns a string representation of an object.`
- `toFixed: (fractionDigits?: number) => string — Returns a string representing a number in fixed-point notation.`
- `toExponential: (fractionDigits?: number) => string — Returns a string containing a number represented in exponential notation.`
- `toPrecision: (precision?: number) => string — Returns a string containing a number represented either in exponential or fixed-point notation with a specified number of digits.`
- `valueOf: () => number — Returns the primitive value of the specified object.`
- `toLocaleString: { (locales?: string`
- `string[], options?: NumberFormatOptions): string; (locales — Converts a number to a string by using the current or specified locale.`

### clampNegativeCellToZero  <sub>packages/foundation/src/utils/editTracker.ts:173</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(row: T, binding: string, tracker: EditTracker<T>): void
```

### clearAllPersistedCaches  <sub>packages/foundation/src/lib/query-client.ts:81</sub>

```ts
(): Promise<void>
```

### clearPersistedCache  <sub>packages/foundation/src/lib/query-client.ts:66</sub>

```ts
(): any
```

### collectLiveColumnExportMeta  <sub>packages/foundation/src/utils/gridAction.ts:270</sub>

```ts
(columns: readonly LiveColumnLike[]): LiveColumnExportMeta
```

props/params:

- `length: number — Gets the length of the array. This is a number one higher than the highest element defined in an array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `concat: { (...items: ConcatArray<LiveColumnLike>[]): LiveColumnLike[]; (...items: (LiveC — Combines two or more arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array separated by the specified separator string.`
- `slice: (start?: number, end?: number) => LiveColumnLike[] — Returns a section of an array.`
- `indexOf: (searchElement: LiveColumnLike, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array.`
- `lastIndexOf: (searchElement: LiveColumnLike, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array.`
- `every: { <S extends LiveColumnLike>(predicate: (value: LiveColumnLike, index: number, a — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: LiveColumnLike, index: number, array: readonly LiveColumnLik — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: LiveColumnLike, index: number, array: readonly LiveColumnLi — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: LiveColumnLike, index: number, array: readonly LiveColum — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends LiveColumnLike>(predicate: (value: LiveColumnLike, index: number, a — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: LiveColumnLike, currentValue: LiveColumnLike, cur — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: LiveColumnLike, currentValue: LiveColumnLike, cur — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends LiveColumnLike>(predicate: (value: LiveColumnLike, index: number, o — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: LiveColumnLike, index: number, obj: readonly LiveColumnLike[ — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `entries: () => ArrayIterator<[number, LiveColumnLike]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<LiveColumnLike> — Returns an iterable of values in the array`
- `includes: (searchElement: LiveColumnLike, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: LiveColumnLike, index: numbe — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => LiveColumnLike — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<LiveColumnLike> — Iterator of values in the array.`
- `__@unscopables@898: { readonly [x: number]: boolean; readonly length?: boolean; toString?: boolean;  — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### comboCacheKey  <sub>packages/foundation/src/utils/columnMapping.ts:186</sub>

```ts
(comboId: string, lookupType: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### comboKeyOfColumn  <sub>packages/foundation/src/utils/columnMapping.ts:190</sub>

```ts
(column: RawFlexGridColumnConfig): string
```

### comboLookupType  <sub>packages/foundation/src/utils/columnMapping.ts:178</sub>

```ts
(column: RawFlexGridColumnConfig): string
```

### fillEmptyCellWithZero  <sub>packages/foundation/src/utils/editTracker.ts:149</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(row: T, binding: string, tracker: EditTracker<T>): void
```

### filterComboRowsByCascade  <sub>packages/foundation/src/utils/columnMapping.ts:315</sub>

```ts
<T extends Record<string, unknown>>(comboRows: T[], row: Record<string, unknown>, rules: readonly ComboCascadeRule[]): T[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => T — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: T[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<T>[]): T[]; (...items: (T`
- `ConcatArray<T>)[]): T[]; } — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => T[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => T — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => T[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: T, b: T) => number) => T[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): T[]; (start: number, deleteCount: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: T[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends T>(predicate: (value: T, index: number, array: T[]) => value is S,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: T, index: number, array: T[]) => unknown, thisArg?: any) =>  — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: T, index: number, array: T[]) => void, thisArg?: any) => vo — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: T, index: number, array: T[]) => U, thisArg?: any) => U[ — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends T>(predicate: (value: T, index: number, array: T[]) => value is S,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends T>(predicate: (value: T, index: number, obj: T[]) => value is S, th — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: T, index: number, obj: T[]) => unknown, thisArg?: any) => nu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: T, start?: number, end?: number) => T[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => T[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, T]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<T> — Returns an iterable of values in the array`
- `includes: (searchElement: T, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: T, index: number, array: T[] — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => T — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<T> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### findStaleComboCells  <sub>packages/foundation/src/utils/columnMapping.ts:357</sub>

```ts
(columns: RawFlexGridColumnConfig[], comboRowsByComboId: Record<string, ComboResponse[]>, row: WijmoRowItem, changedBinding: string): StaleComboCell[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => RawFlexGridColumnConfig — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: RawFlexGridColumnConfig[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<RawFlexGridColumnConfig>[]): RawFlexGridColumnConfig[]; — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => RawFlexGridColumnConfig[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => RawFlexGridColumnConfig — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => RawFlexGridColumnConfig[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: RawFlexGridColumnConfig, b: RawFlexGridColumnConfig) => number) — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): RawFlexGridColumnConfig[]; (start: numb — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: RawFlexGridColumnConfig[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridCo — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridC — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGr — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: RawFlexGridColumnConfig, index: number, obj: RawFlexGridColu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: RawFlexGridColumnConfig, start?: number, end?: number) => RawFlexGridCol — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => RawFlexGridColumnConfig[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, RawFlexGridColumnConfig]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<RawFlexGridColumnConfig> — Returns an iterable of values in the array`
- `includes: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: RawFlexGridColumnConfig, ind — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => RawFlexGridColumnConfig — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<RawFlexGridColumnConfig> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### findStaleRowParamComboCells  <sub>packages/foundation/src/utils/columnMapping.ts:436</sub>

```ts
(columns: RawFlexGridColumnConfig[], rowParamByBinding: Record<string, Record<string, ComboResponse[]>>, insertRowParamByBinding: Record<string, Record<string, ComboResponse[]>>, row: WijmoRowItem, changedBinding: string): RowParamStaleResult
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => RawFlexGridColumnConfig — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: RawFlexGridColumnConfig[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<RawFlexGridColumnConfig>[]): RawFlexGridColumnConfig[]; — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => RawFlexGridColumnConfig[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => RawFlexGridColumnConfig — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => RawFlexGridColumnConfig[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: RawFlexGridColumnConfig, b: RawFlexGridColumnConfig) => number) — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): RawFlexGridColumnConfig[]; (start: numb — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: RawFlexGridColumnConfig[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridCo — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridC — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGr — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: RawFlexGridColumnConfig, index: number, obj: RawFlexGridColu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: RawFlexGridColumnConfig, start?: number, end?: number) => RawFlexGridCol — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => RawFlexGridColumnConfig[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, RawFlexGridColumnConfig]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<RawFlexGridColumnConfig> — Returns an iterable of values in the array`
- `includes: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: RawFlexGridColumnConfig, ind — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => RawFlexGridColumnConfig — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<RawFlexGridColumnConfig> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### formatCurrency  <sub>packages/foundation/src/utils/number.ts:12</sub>

```ts
(num: number, currency?: string): string
```

props/params:

- `toString: (radix?: number) => string — Returns a string representation of an object.`
- `toFixed: (fractionDigits?: number) => string — Returns a string representing a number in fixed-point notation.`
- `toExponential: (fractionDigits?: number) => string — Returns a string containing a number represented in exponential notation.`
- `toPrecision: (precision?: number) => string — Returns a string containing a number represented either in exponential or fixed-point notation with a specified number of digits.`
- `valueOf: () => number — Returns the primitive value of the specified object.`
- `toLocaleString: { (locales?: string`
- `string[], options?: NumberFormatOptions): string; (locales — Converts a number to a string by using the current or specified locale.`

### formatDate  <sub>packages/foundation/src/utils/date.ts:5</sub>

```ts
(date: Date): string
```

props/params:

- `toString: () => string — Returns a string representation of a date. The format of the string depends on the locale.`
- `toDateString: () => string — Returns a date as a string value.`
- `toTimeString: () => string — Returns a time as a string value.`
- `toLocaleString: { (): string; (locales?: string`
- `string[], options?: DateTimeFormatOptions): st — Returns a value as a string value appropriate to the host environment's current locale. Converts a date and time to a string by using the current or specified l`
- `toLocaleDateString: { (): string; (locales?: string`
- `string[], options?: DateTimeFormatOptions): st — Returns a date as a string value appropriate to the host environment's current locale. Converts a date to a string by using the current or specified locale.`
- `toLocaleTimeString: { (): string; (locales?: string`
- `string[], options?: DateTimeFormatOptions): st — Returns a time as a string value appropriate to the host environment's current locale. Converts a time to a string by using the current or specified locale.`
- `valueOf: () => number — Returns the stored time value in milliseconds since midnight, January 1, 1970 UTC.`
- `getTime: () => number — Returns the stored time value in milliseconds since midnight, January 1, 1970 UTC.`
- `getFullYear: () => number — Gets the year, using local time.`
- `getUTCFullYear: () => number — Gets the year using Universal Coordinated Time (UTC).`
- `getMonth: () => number — Gets the month, using local time.`
- `getUTCMonth: () => number — Gets the month of a Date object using Universal Coordinated Time (UTC).`
- `getDate: () => number — Gets the day-of-the-month, using local time.`
- `getUTCDate: () => number — Gets the day-of-the-month, using Universal Coordinated Time (UTC).`
- `getDay: () => number — Gets the day of the week, using local time.`
- `getUTCDay: () => number — Gets the day of the week using Universal Coordinated Time (UTC).`
- `getHours: () => number — Gets the hours in a date, using local time.`
- `getUTCHours: () => number — Gets the hours value in a Date object using Universal Coordinated Time (UTC).`
- `getMinutes: () => number — Gets the minutes of a Date object, using local time.`
- `getUTCMinutes: () => number — Gets the minutes of a Date object using Universal Coordinated Time (UTC).`
- `getSeconds: () => number — Gets the seconds of a Date object, using local time.`
- `getUTCSeconds: () => number — Gets the seconds of a Date object using Universal Coordinated Time (UTC).`
- `getMilliseconds: () => number — Gets the milliseconds of a Date, using local time.`
- `getUTCMilliseconds: () => number — Gets the milliseconds of a Date object using Universal Coordinated Time (UTC).`
- `getTimezoneOffset: () => number — Gets the difference in minutes between Universal Coordinated Time (UTC) and the time on the local computer.`
- `setTime: (time: number) => number — Sets the date and time value in the Date object.`
- `setMilliseconds: (ms: number) => number — Sets the milliseconds value in the Date object using local time.`
- `setUTCMilliseconds: (ms: number) => number — Sets the milliseconds value in the Date object using Universal Coordinated Time (UTC).`
- `setSeconds: (sec: number, ms?: number) => number — Sets the seconds value in the Date object using local time.`
- `setUTCSeconds: (sec: number, ms?: number) => number — Sets the seconds value in the Date object using Universal Coordinated Time (UTC).`
- `setMinutes: (min: number, sec?: number, ms?: number) => number — Sets the minutes value in the Date object using local time.`
- `setUTCMinutes: (min: number, sec?: number, ms?: number) => number — Sets the minutes value in the Date object using Universal Coordinated Time (UTC).`
- `setHours: (hours: number, min?: number, sec?: number, ms?: number) => number — Sets the hour value in the Date object using local time.`
- `setUTCHours: (hours: number, min?: number, sec?: number, ms?: number) => number — Sets the hours value in the Date object using Universal Coordinated Time (UTC).`
- `setDate: (date: number) => number — Sets the numeric day-of-the-month value of the Date object using local time.`
- `setUTCDate: (date: number) => number — Sets the numeric day of the month in the Date object using Universal Coordinated Time (UTC).`
- `setMonth: (month: number, date?: number) => number — Sets the month value in the Date object using local time.`
- `setUTCMonth: (month: number, date?: number) => number — Sets the month value in the Date object using Universal Coordinated Time (UTC).`
- `setFullYear: (year: number, month?: number, date?: number) => number — Sets the year of the Date object using local time.`
- `setUTCFullYear: (year: number, month?: number, date?: number) => number — Sets the year value in the Date object using Universal Coordinated Time (UTC).`
- `toUTCString: () => string — Returns a date converted to a string using Universal Coordinated Time (UTC).`
- `toISOString: () => string — Returns a date as a string value in ISO format.`
- `toJSON: (key?: any) => string — Used by the JSON.stringify method to enable the transformation of an object's data for JavaScript Object Notation (JSON) serialization.`
- `getVarDate: () => VarDate`
- `__@toPrimitive@2348: { (hint: "default"): string; (hint: "string"): string; (hint: "number"): number; — Converts a Date object to a string. Converts a Date object to a number. Converts a Date object to a string or number.`

### formatDateTime  <sub>packages/foundation/src/utils/date.ts:9</sub>

```ts
(date: Date): string
```

props/params:

- `toString: () => string — Returns a string representation of a date. The format of the string depends on the locale.`
- `toDateString: () => string — Returns a date as a string value.`
- `toTimeString: () => string — Returns a time as a string value.`
- `toLocaleString: { (): string; (locales?: string`
- `string[], options?: DateTimeFormatOptions): st — Returns a value as a string value appropriate to the host environment's current locale. Converts a date and time to a string by using the current or specified l`
- `toLocaleDateString: { (): string; (locales?: string`
- `string[], options?: DateTimeFormatOptions): st — Returns a date as a string value appropriate to the host environment's current locale. Converts a date to a string by using the current or specified locale.`
- `toLocaleTimeString: { (): string; (locales?: string`
- `string[], options?: DateTimeFormatOptions): st — Returns a time as a string value appropriate to the host environment's current locale. Converts a time to a string by using the current or specified locale.`
- `valueOf: () => number — Returns the stored time value in milliseconds since midnight, January 1, 1970 UTC.`
- `getTime: () => number — Returns the stored time value in milliseconds since midnight, January 1, 1970 UTC.`
- `getFullYear: () => number — Gets the year, using local time.`
- `getUTCFullYear: () => number — Gets the year using Universal Coordinated Time (UTC).`
- `getMonth: () => number — Gets the month, using local time.`
- `getUTCMonth: () => number — Gets the month of a Date object using Universal Coordinated Time (UTC).`
- `getDate: () => number — Gets the day-of-the-month, using local time.`
- `getUTCDate: () => number — Gets the day-of-the-month, using Universal Coordinated Time (UTC).`
- `getDay: () => number — Gets the day of the week, using local time.`
- `getUTCDay: () => number — Gets the day of the week using Universal Coordinated Time (UTC).`
- `getHours: () => number — Gets the hours in a date, using local time.`
- `getUTCHours: () => number — Gets the hours value in a Date object using Universal Coordinated Time (UTC).`
- `getMinutes: () => number — Gets the minutes of a Date object, using local time.`
- `getUTCMinutes: () => number — Gets the minutes of a Date object using Universal Coordinated Time (UTC).`
- `getSeconds: () => number — Gets the seconds of a Date object, using local time.`
- `getUTCSeconds: () => number — Gets the seconds of a Date object using Universal Coordinated Time (UTC).`
- `getMilliseconds: () => number — Gets the milliseconds of a Date, using local time.`
- `getUTCMilliseconds: () => number — Gets the milliseconds of a Date object using Universal Coordinated Time (UTC).`
- `getTimezoneOffset: () => number — Gets the difference in minutes between Universal Coordinated Time (UTC) and the time on the local computer.`
- `setTime: (time: number) => number — Sets the date and time value in the Date object.`
- `setMilliseconds: (ms: number) => number — Sets the milliseconds value in the Date object using local time.`
- `setUTCMilliseconds: (ms: number) => number — Sets the milliseconds value in the Date object using Universal Coordinated Time (UTC).`
- `setSeconds: (sec: number, ms?: number) => number — Sets the seconds value in the Date object using local time.`
- `setUTCSeconds: (sec: number, ms?: number) => number — Sets the seconds value in the Date object using Universal Coordinated Time (UTC).`
- `setMinutes: (min: number, sec?: number, ms?: number) => number — Sets the minutes value in the Date object using local time.`
- `setUTCMinutes: (min: number, sec?: number, ms?: number) => number — Sets the minutes value in the Date object using Universal Coordinated Time (UTC).`
- `setHours: (hours: number, min?: number, sec?: number, ms?: number) => number — Sets the hour value in the Date object using local time.`
- `setUTCHours: (hours: number, min?: number, sec?: number, ms?: number) => number — Sets the hours value in the Date object using Universal Coordinated Time (UTC).`
- `setDate: (date: number) => number — Sets the numeric day-of-the-month value of the Date object using local time.`
- `setUTCDate: (date: number) => number — Sets the numeric day of the month in the Date object using Universal Coordinated Time (UTC).`
- `setMonth: (month: number, date?: number) => number — Sets the month value in the Date object using local time.`
- `setUTCMonth: (month: number, date?: number) => number — Sets the month value in the Date object using Universal Coordinated Time (UTC).`
- `setFullYear: (year: number, month?: number, date?: number) => number — Sets the year of the Date object using local time.`
- `setUTCFullYear: (year: number, month?: number, date?: number) => number — Sets the year value in the Date object using Universal Coordinated Time (UTC).`
- `toUTCString: () => string — Returns a date converted to a string using Universal Coordinated Time (UTC).`
- `toISOString: () => string — Returns a date as a string value in ISO format.`
- `toJSON: (key?: any) => string — Used by the JSON.stringify method to enable the transformation of an object's data for JavaScript Object Notation (JSON) serialization.`
- `getVarDate: () => VarDate`
- `__@toPrimitive@2348: { (hint: "default"): string; (hint: "string"): string; (hint: "number"): number; — Converts a Date object to a string. Converts a Date object to a number. Converts a Date object to a string or number.`

### formatNumber  <sub>packages/foundation/src/utils/number.ts:5</sub>

```ts
(num: number, decimals?: number): string
```

props/params:

- `toString: (radix?: number) => string — Returns a string representation of an object.`
- `toFixed: (fractionDigits?: number) => string — Returns a string representing a number in fixed-point notation.`
- `toExponential: (fractionDigits?: number) => string — Returns a string containing a number represented in exponential notation.`
- `toPrecision: (precision?: number) => string — Returns a string containing a number represented either in exponential or fixed-point notation with a specified number of digits.`
- `valueOf: () => number — Returns the primitive value of the specified object.`
- `toLocaleString: { (locales?: string`
- `string[], options?: NumberFormatOptions): string; (locales — Converts a number to a string by using the current or specified locale.`

### getUuid  <sub>packages/foundation/src/utils/ulid.ts:3</sub>

```ts
(): string
```

### hasRequiredMark  <sub>packages/foundation/src/utils/columnMapping.ts:652</sub>

```ts
(label?: string): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### insertComboId  <sub>packages/foundation/src/utils/columnMapping.ts:170</sub>

```ts
(column: RawFlexGridColumnConfig): string
```

### installInsertPinConverter  <sub>packages/foundation/src/utils/gridAction.ts:629</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>): void
```

### isNonEditableDateColumn  <sub>packages/foundation/src/utils/gridColumns.ts:153</sub>

```ts
(colBinding: string, weekMap: Map<string, Set<string>>): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isTypingAllowed  <sub>packages/foundation/src/utils/numberInputRule.ts:18</sub>

```ts
(text: string, rule: NumberInputRule): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isValueAllowed  <sub>packages/foundation/src/utils/numberInputRule.ts:34</sub>

```ts
(text: string, rule: NumberInputRule): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### kebabCase  <sub>packages/foundation/src/utils/string.ts:9</sub>

```ts
(str: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### mapRawColumnsToWijmoColumns  <sub>packages/foundation/src/utils/columnMapping.ts:766</sub>

```ts
(sourceColumns: RawFlexGridColumnConfig[]): FlexGridColumnConfig[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => RawFlexGridColumnConfig — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: RawFlexGridColumnConfig[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<RawFlexGridColumnConfig>[]): RawFlexGridColumnConfig[]; — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => RawFlexGridColumnConfig[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => RawFlexGridColumnConfig — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => RawFlexGridColumnConfig[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: RawFlexGridColumnConfig, b: RawFlexGridColumnConfig) => number) — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): RawFlexGridColumnConfig[]; (start: numb — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: RawFlexGridColumnConfig[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridCo — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridC — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGr — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: RawFlexGridColumnConfig, index: number, obj: RawFlexGridColu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: RawFlexGridColumnConfig, start?: number, end?: number) => RawFlexGridCol — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => RawFlexGridColumnConfig[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, RawFlexGridColumnConfig]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<RawFlexGridColumnConfig> — Returns an iterable of values in the array`
- `includes: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: RawFlexGridColumnConfig, ind — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => RawFlexGridColumnConfig — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<RawFlexGridColumnConfig> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### normalizeDynamicColumns  <sub>packages/foundation/src/utils/columnMapping.ts:752</sub>

```ts
(columns: FlexGridColumnConfig[]): FlexGridColumnConfig[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => FlexGridColumnConfig — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: FlexGridColumnConfig[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<FlexGridColumnConfig>[]): FlexGridColumnConfig[]; (...i — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => FlexGridColumnConfig[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => FlexGridColumnConfig — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => FlexGridColumnConfig[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: FlexGridColumnConfig, b: FlexGridColumnConfig) => number) => Fl — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): FlexGridColumnConfig[]; (start: number, — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: FlexGridColumnConfig[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: FlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: FlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends FlexGridColumnConfig>(predicate: (value: FlexGridColumnConfig, inde — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: FlexGridColumnConfig, index: number, array: FlexGridColumnCo — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: FlexGridColumnConfig, index: number, array: FlexGridColumnC — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: FlexGridColumnConfig, index: number, array: FlexGridColu — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends FlexGridColumnConfig>(predicate: (value: FlexGridColumnConfig, inde — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: FlexGridColumnConfig, currentValue: FlexGridColum — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: FlexGridColumnConfig, currentValue: FlexGridColum — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends FlexGridColumnConfig>(predicate: (value: FlexGridColumnConfig, inde — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: FlexGridColumnConfig, index: number, obj: FlexGridColumnConf — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: FlexGridColumnConfig, start?: number, end?: number) => FlexGridColumnCon — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => FlexGridColumnConfig[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, FlexGridColumnConfig]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<FlexGridColumnConfig> — Returns an iterable of values in the array`
- `includes: (searchElement: FlexGridColumnConfig, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: FlexGridColumnConfig, index: — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => FlexGridColumnConfig — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<FlexGridColumnConfig> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### orderComboDisplayNames  <sub>packages/foundation/src/utils/columnMapping.ts:532</sub>

```ts
(names: string[]): string[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => string — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: string[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => string[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => string — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => string[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: string, b: string) => number) => string[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): string[]; (start: number, deleteCount:  — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: string[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: string[]) => unknown, thisArg? — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: string[]) => void, thisArg?:  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: string[]) => U, thisArg?:  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: string[]) => — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: string[]) => unknown, thisArg?:  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: string, start?: number, end?: number) => string[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => string[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### parseDate  <sub>packages/foundation/src/utils/date.ts:13</sub>

```ts
(dateStr: string): Date
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### pinInsertedRow  <sub>packages/foundation/src/utils/gridAction.ts:578</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(grid: FlexGrid<T>, newRow: T, anchorItem?: T): void
```

### quoteComboParams  <sub>packages/foundation/src/models/common/combo.ts:32</sub>

```ts
(params: ComboParam): ComboParam
```

props/params:

- `comboId: string`

### quoteComboValue  <sub>packages/foundation/src/models/common/combo.ts:26</sub>

```ts
(value: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### requestErrorInterceptor  <sub>packages/foundation/src/apis/axios-interceptors.ts:19</sub>

```ts
(error: AxiosError): Promise<never>
```

### requestInterceptor  <sub>packages/foundation/src/apis/axios-interceptors.ts:11</sub>

```ts
(config: InternalAxiosRequestConfig): InternalAxiosRequestConfig
```

### resolveMenuLabel  <sub>packages/foundation/src/models/common/menu.ts:23</sub>

```ts
(t: TFunction, menu: { mnuMsgId: string; mnuDesc?: string; mnuId?: string | number; }): string
```

### responseErrorInterceptor  <sub>packages/foundation/src/apis/axios-interceptors.ts:51</sub>

```ts
(error: AxiosError<ApiResponse<DefaultResponse>>): any
```

### responseInterceptor  <sub>packages/foundation/src/apis/axios-interceptors.ts:25</sub>

```ts
(response: AxiosResponse<ApiResponse<DefaultResponse>>): AxiosResponse
```

### revertRowChanges  <sub>packages/foundation/src/utils/gridAction.ts:302</sub>

```ts
<T extends WijmoRowItem = WijmoRowItem>(rows: T[], editTracker?: EditTracker<T>): boolean
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => T — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: T[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<T>[]): T[]; (...items: (T`
- `ConcatArray<T>)[]): T[]; } — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => T[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => T — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => T[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: T, b: T) => number) => T[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): T[]; (start: number, deleteCount: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: T[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends T>(predicate: (value: T, index: number, array: T[]) => value is S,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: T, index: number, array: T[]) => unknown, thisArg?: any) =>  — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: T, index: number, array: T[]) => void, thisArg?: any) => vo — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: T, index: number, array: T[]) => U, thisArg?: any) => U[ — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends T>(predicate: (value: T, index: number, array: T[]) => value is S,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends T>(predicate: (value: T, index: number, obj: T[]) => value is S, th — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: T, index: number, obj: T[]) => unknown, thisArg?: any) => nu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: T, start?: number, end?: number) => T[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => T[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, T]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<T> — Returns an iterable of values in the array`
- `includes: (searchElement: T, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: T, index: number, array: T[] — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => T — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<T> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### rowParamKey  <sub>packages/foundation/src/utils/columnMapping.ts:249</sub>

```ts
(bindings: Record<string, string>, rowItem: any): string
```

### rowParamValue  <sub>packages/foundation/src/utils/columnMapping.ts:210</sub>

```ts
(rowItem: any, binding: string): string
```

### setQueryErrorHandler  <sub>packages/foundation/src/lib/query-client.ts:139</sub>

```ts
(handler: QueryErrorHandler): void
```

### shouldPersistQuery  <sub>packages/foundation/src/lib/query-client.ts:127</sub>

```ts
(query: Query): boolean
```

## master-common

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **MSG** | `features/master/src/components` | 240 |  | AS-IS SaveData 검증 메시지(cs L1114/1128/1206/1213/1219 그대로). |
| **MSG** | `features/master/src/components` | 240 |  |  |
| **COMBO** | `features/master/src/components` | 103 |  | 조회조건 cascade 콤보(6단, DB 실측 확정 — 전부 이미 등록돼 있음, 2026-09-22 ora.py). // AS-IS Data_SCP.Common(...)="_SCP" / Data.Common(...)=무접미(scp-combo-sqlid |
| **REPORT_TYPE** | `features/master/src/components` | 6 |  |  |
| **MODAL_OWNER** | `features/master/src/components` | 2 |  |  |
| **DYN_MONTH_PREFIX** | `features/master/src/components` | 1 |  | 동적 PIVOT 월 컬럼 prefix(AS-IS 'M_' 접두, SP1 SELECT 'M_'+A.YYYYMM 그대로). |
| **ITEM_MODAL_CONDITION** | `features/master/src/components` | 1 |  | 팝업 검색조건 식별자 — visibleConditions prop 으로 호출 화면별 노출을 고른다. (문자열 리터럴 대신 이 상수를 쓸 것 — 오타는 "조건이 조용히 사라짐" 으로만 드러난다.) |
| **AUTH_GROUP** | `features/master/src/components` | 0 |  | PlannerTypeLogic(cs L936-995)이 비교하는 그룹명. AS-IS는 SCP_CAPA_bool 판정에 'SCP Planner'와 // 'CAPA Planner'를 OR로 동일 취급하나, TO-BE SCM_ADM_USER_GR_M에 'C |
| **CALENDAR_MONTHS_SPAN** | `features/master/src/components` | 0 |  | AS-IS SP1(@p_end_month = DATEADD(MM,41,today)) — 당월 포함 42개월(0~41개월 뒤까지) 조회. |
| **CASCADE_LEVELS** | `features/master/src/components` | 0 |  | 등록된 cascade 단계. code/name 은 그 단계가 콤보에서 읽는 컬럼이며, 몇 번째 단계로 쓰이든 항상 이 이름 그대로다. 마지막 단계만 CODE / NAME 으로 읽던 규약은 없앴다 - 콤보 SQL 은 전 단계를 풀네임 컬럼으로 내려준다. |
| **DEFAULT_ITEM_MODAL_CONDITIONS** | `features/master/src/components` | 0 |  | visibleConditions 미지정 시 기본 노출 세트 = 기존 동작 그대로(회귀 0). Item Type 은 신설 조건이라 기본 세트에서 빠진다 — 원하는 화면만 명시적으로 켠다. |
| **DEFAULT_ITEM_TYPE** | `features/master/src/components` | 0 |  | Item Type 조건의 기본 선택값 — AS-IS 'Model by DivisionPopup' 이 Product 로 열리는 것과 동등. ⚠ 'ItemType' 콤보가 이 값을 CODE 로 주는지 NAME 으로 주는지는 admin 메타에 달렸다. 둘  |
| **FP_INSTANCE_ENDPOINT** | `features/master/src/components` | 0 |  |  |
| **ITEM_BY_PLANT_SITE_COLUMNS** | `features/master/src/components` | 0 |  |  |
| **ITEM_TYPE_ALL** | `features/master/src/components` | 0 |  | Item Type 조건의 '전체' 값. CustomDropdown 의 allOption(단일 선택)은 value 가 빈 문자열이라 그 규약을 그대로 따른다. |
| **MNU_ID** | `features/master/src/components` | 0 |  | PKG_SCP0049 admin 등록 실측(2026-09-22, ora.py SCM_ADM_API_M/SCM_ADM_MNU_BTN_MPG_M) — // newModel(SEARCH/SAVE)·mailSend(SAVE) 모두 MNU_ID='SCP0049 |
| **MODAL_CUSTOMER** | `features/master/src/components` | 0 |  |  |
| **MODAL_ITEM_BY_DIVISION** | `features/master/src/components` | 0 |  |  |
| **MODAL_ITEM_BY_PLANT_SITE** | `features/master/src/components` | 0 |  | Item by Plant Site 공용 팝업 상수 (AS-IS GSCM.SCM.Popup.UIL.SCM0002_ItembyPlantSitePopup). 주의: ItemByDivisionModal(COM0008)·MaterialByDivisionModa |
| **MODAL_MATERIAL_BY_DIVISION** | `features/master/src/components` | 0 |  | Material by Division 공용 팝업 상수. AS-IS SCM0002_MaterialByDivisionPopup(SCP 27개 화면 공용)의 TO-BE 등가. 공용 팝업이라 COM 계열 신규 코드 COM0013 으로 등록되어 있다(COM00 |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  | 컬럼 메타(SCM_MST_SHEET_COLUMNS.SHEET_NAME) 시트명 = /column 요청의 sheetNm. |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_NAME** | `features/master/src/components` | 0 |  |  |
| **MODAL_OWNER_BY_DIVISION** | `features/master/src/components` | 0 |  |  |
| **MODAL_PROJECT** | `features/master/src/components` | 0 |  |  |
| **MODAL_PROJECT_BY_DIVISION** | `features/master/src/components` | 0 |  |  |
| **MODAL_RATE** | `features/master/src/components` | 0 |  | admin DB SCM_ADM_MNU_M 에 별도 popup MENU_ID 등재 없음 — DMF0043 의 sheet 'ratePopup' 재사용. // (regionModal/customerModal 등은 별도 COMxxxx MENU_ID 보유 —  |
| **MODAL_REGION** | `features/master/src/components` | 0 |  |  |
| **MODAL_SALES_VERSION** | `features/master/src/components` | 0 |  |  |
| **MODAL_SALES_VERSION_COLUMN_SHEET** | `features/master/src/components` | 0 |  |  |
| **MODAL_SALES_VERSION_SHEET** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_COLUMN_META** | `features/master/src/components` | 0 |  | column meta fetch sheet (admin SCM_MST_SHEET_COLUMNS 에 VER_SEQ/YYYY/... 5 컬럼 등재) |
| **MODAL_SHEET_CUSTOMER** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_DATA** | `features/master/src/components` | 0 |  | data fetch sheet (BE PROC_M 매핑 — DMF0043_GET_CONTRIBUTE_RATE_POPUP(yyyy)) |
| **MODAL_SHEET_ITEM_BY_DIVISION** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_ITEM_BY_PLANT_SITE** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_ITEM_BY_SMALL_DIVISION** | `features/master/src/components` | 0 |  | 그리드 셀 호출용 좁은 조회 시트. itemByDivision 은 team/end customer/site 축까지 펼친 목록이라, 팝업 컬럼을 좁혀 연 화면에서는 같은 Model 이 여러 줄로 보인다(구분 근거가 화면에서 빠지므로). AS-IS 는 그 |
| **MODAL_SHEET_MATERIAL_BY_DIVISION** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_OWNER** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_OWNER_BY_DIVISION** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_PROJECT** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_PROJECT_BY_DIVISION** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_RATE** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_REGION** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_SLOC** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_TEAM** | `features/master/src/components` | 0 |  |  |
| **MODAL_SHEET_YEAR** | `features/master/src/components` | 0 |  |  |
| **MODAL_SLOC** | `features/master/src/components` | 0 |  |  |
| **MODAL_TEAM** | `features/master/src/components` | 0 |  |  |
| **MODAL_VERSION** | `features/master/src/components` | 0 |  | admin DB SCM_ADM_MNU_M 에 별도 popup MENU_ID 등재 없음 — DMF0043 의 sheet 재사용. // AS-IS 의 RATE_POPUP SP (DMF0043_GET_CONTRIBUTE_RATE_POPUP(yyyy)) 가  |
| **MY_AUTH_LIST_ENDPOINT** | `features/master/src/components` | 0 |  | 권한판정 원본 2종의 실제 호출 경로(ora.py 실측 + DB 등록 2026-09-29, LoadAuthority cs L309-403). // SP #6(내 승인권한 목록)은 DB 팀 회신대로 기등록 SP PKG_SYS0011.P_SYS0011_G |
| **SEARCH_POPUP_WIDTH** | `features/master/src/components` | 0 |  | ⭐ 조회조건 팝업 3종(Owner / Model·Nickname / Project) 공통 가로 폭 (2026-08-06 사용자 요청 — "owner, model, project 세 개 사이즈 같도록"). 이전에는 1200 / 1000 / 1000 으로 |
| **SHEET_MAIL_SEND** | `features/master/src/components` | 0 |  |  |
| **SHEET_NEW_MODEL** | `features/master/src/components` | 0 |  |  |
| **SMALL_DIVISION_WILDCARD** | `features/master/src/components` | 0 |  | 좁은 조회에서 "조건 없음"을 뜻하는 값. 넓은 조회는 빈 문자열을 조건 없음으로 받지만 좁은 쪽은 규약이 다르다. project/item 조건이 AND (EXISTS (... WHERE D.PROJECT_CODE LIKE P.TOKEN \|\| '% |
| **VERSION_ACTION** | `features/master/src/components` | 0 |  |  |
| **SHEET_INDEX** | `features/master/src/components` | 50 |  |  |
| **buildComboOptions** | `features/master/src/components` | 16 |  | 콤보 행을 좁혀 드롭다운 옵션으로. 규칙은 이 파일 헤더 참조. division 은 축 이름이 고정이라 편의로 따로 받는다. 아예 안 넘기면 그 축이 없는 것으로 본다 - DIVISION_ID 컬럼을 내려주지 않는 FilterMyDivision 이 그 |
| **toSelectedCodes** | `features/master/src/components` | 9 |  | 실제로 고른 코드만 남긴다. 전체선택('ALL')과 전체해제는 필터상 같다 - 둘 다 빈 배열이 되어 그 축이 미적용된다 (GetDMInnerTable 진입부의 'ALL' -> '' 치환과 같은 결과). |
| **buildSalesSiteOptions** | `features/master/src/components` | 1 |  | 'SalesSite' 콤보 -> Sales Site 드롭다운 옵션. |
| **logSearchReset** | `features/master/src/components` | 1 |  | // [reset] 상위 조회조건 변경 -> 하위 값 재세팅 // |
| **blankValue** | `features/master/src/components` | 0 |  | 하위 단계 초기화 값 — 배열 필드면 빈 배열, 문자열 필드면 'ALL'. 둘 다 필터 미적용이다. |
| **buildCapaAuthContext** | `features/master/src/components` | 0 |  | LoadAuthority(cs L309-403) + PlannerTypeLogic(cs L936-995, division 스코프)를 합쳐 화면이 한 번에 // 쓸 컨텍스트로 만든다. divisionId 는 검색에 실제 사용된 division(폼의 현재 |
| **buildCapaMonthColumns** | `features/master/src/components` | 0 |  | 월 목록 → DataGrid dynamicColumns(binding=M_YYYYMM, PRIORITY 1~9 편집). |
| **buildCapaNewModelColumns** | `features/master/src/components` | 0 |  | InitSpread(cs L484-546) 고정 컬럼 그대로 — SP 미배포라 admin 메타 대신 이 파일에 직접 정의 // (ProjectRouteListSaveModal 의 buildProjectRouteListSaveColumns 와 동일한 e |
| **buildEndCustomerOptions** | `features/master/src/components` | 0 |  | 'EndCustomer' 콤보 -> End Customer 드롭다운 옵션. |
| **callTransfer** | `features/master/src/components` | 0 |  |  |
| **callVersionAction** | `features/master/src/components` | 0 |  |  |
| **callVersionActionBp** | `features/master/src/components` | 0 |  |  |
| **cell** | `features/master/src/components` | 0 |  | 콤보 셀 값 읽기. 콤보 응답은 컬럼에 따라 NUMBER 로 내려오기도 해서 문자열로 맞춰야 Set 비교가 성립한다 (SearchFields.cellValue 와 같은 사정). |
| **excludeEeDivision** | `features/master/src/components` | 0 |  | BLUtils.GetDivisionWithoutEE 화면측 후처리(SCP0006 project-route.constants.ts EXCLUDE_EE_DIVISION // 과 동일 규칙 — 화면이 달라 공유 유틸로 승격하지 않고 그대로 복제한다, Har |
| **hasLaneQtyCandidate** | `features/master/src/components` | 0 |  | dtLaneQtyOfLineAssign 존재검증(cs L629-635 등, EditButton 전용 — CODE 값 매칭 없이 "후보가 있는가"만 // 본다. SaveData 검증(handleSave 의 buildSaveEntries)은 CODE==현 |
| **isAlwaysEditableBinding** | `features/master/src/components` | 0 |  | Mail Req 체크박스 — 권한 무관 항상 편집가능(cs 전 분기 공통 LockRange(REQUEST_CHK,...,false)). |
| **isLockedIdentityBinding** | `features/master/src/components` | 0 |  |  |
| **logCascade** | `features/master/src/components` | 0 |  | // [cascade] 콤보 원본 -> 단계별 필터 -> 최종 옵션 // |
| **logFilterCombo** | `features/master/src/components` | 0 |  | Filter 콤보 목록이 이상할 때 축 단위로 몇 건이 잘렸는지 본다. 축마다 "적용 코드"와 "축 값 분포"를 함께 찍는다. 둘을 나란히 보면 원인이 갈린다. · 축 값 분포가 '(공란)' 위주 -> 그 컬럼이 NULL 이라 엄격 매칭에 전부 잘린다 |
| **logLevelCascade** | `features/master/src/components` | 0 |  | SearchFields 카탈로그와 달리 이쪽은 콤보 1건을 levels 순서대로 좁힌다. 가장 흔한 사고는 콤보 SQL 의 실제 컬럼명이 규약(_CODE / CODE)과 달라 첫 단계에서 전 행이 잘리는 경우라, 콤보 원본의 컬럼 목록을 먼저 찍는다. |
| **monthsFromToday** | `features/master/src/components` | 0 |  | 당월(todayYyyymm) ~ +span 개월(YYYYMM, inclusive) 목록. |
| **normalizeLevel** | `features/master/src/components` | 0 |  |  |
| **readValue** | `features/master/src/components` | 0 |  | 스토어 객체에서 한 단계 선택값 읽기. 제네릭 V 를 문자열 키로 인덱싱해야 해서 여기서만 캐스팅한다 — 밖으로는 FieldOf<V> 로 좁혀 둬서 호출부가 넘기는 field 이름 자체는 컴파일 단계에서 검증된다. 조회조건 값은 문자열이지만 스토어 타 |
| **resolveCapaRowEditability** | `features/master/src/components` | 0 |  | EditButton(cs L579-825) 행별 판정. isGroupElectrode = 조회조건 Group 에 'E' 포함 여부(그리드 LANE_QTY // 컬럼 표시조건 buildCapaNewModelColumns 와 동일 값 재사용, AS-IS  |
| **toCodeSet** | `features/master/src/components` | 0 |  | 선택값 문자열 -> 실제 코드 Set. 남는 값이 없으면 null = 필터 미적용. CustomDropdown 은 전체선택을 'ALL', 전체해제를 '' 로 내보내고 둘은 필터상 같다. |
| **writeValue** | `features/master/src/components` | 0 |  | 스토어 필드 타입에 맞춘 쓰기 값. 화면마다 조회조건을 문자열로 들기도 하고(SalesSiteProjectModel: deptId: string) 배열로 들기도 한다(MktFcst: deptIds: string[]). 읽을 때 join 으로 폈으니 쓸 |
| **yearBoundsOf** | `features/master/src/components` | 0 |  | 달력 마스터 콤보(CALENDAR_YYYY) 행에서 선택 가능 연도 경계를 뽑는다. CODE 가 연도 4자리다. 행이 없으면 undefined - 피커가 자기 기본 범위를 쓴다. |
| **yearToDayjs** | `features/master/src/components` | 0 |  | // YearField 값 변환 (SearchFields.tsx §11-1) // 조회조건 스토어의 yyyy 는 'YYYY' 4자리 문자열이고, 피커는 Dayjs 를 주고받는다. // 그 사이 변환만 모아 둔다 - 잘못된 값이 조회키로 새는 경로가 여 |
| **yearValueOf** | `features/master/src/components` | 0 |  | 피커가 준 날짜에서 조회키로 쓸 'YYYY' 를 뽑는다. 쓸 수 없는 값이면 null. 주의: 입력칸을 비우면 MUI DatePicker 가 null 로 onChange 를 부르고, design-system YearPicker 가 그것을 dayjs(n |
| **DefColumns** | `features/master/src/components` | 1 |  |  |

### buildComboOptions  <sub>features/master/src/components/searchFields/bigFilterCombo.ts:74</sub>

```ts
(rows: ComboResponse[], filters?: { division?: string; narrow?: ComboAxis | ComboAxis[]; }): ComboOption[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ComboResponse — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ComboResponse[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ComboResponse>[]): ComboResponse[]; (...items: any[]):  — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ComboResponse[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ComboResponse — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ComboResponse[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ComboResponse, b: ComboResponse) => number) => ComboResponse[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ComboResponse[]; (start: number, delete — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ComboResponse[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ComboResponse, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ComboResponse, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ComboResponse>(predicate: (value: ComboResponse, index: number, arr — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ComboResponse, index: number, array: ComboResponse[]) => unk — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ComboResponse, index: number, array: ComboResponse[]) => vo — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ComboResponse, index: number, array: ComboResponse[]) => — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ComboResponse>(predicate: (value: ComboResponse, index: number, arr — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ComboResponse, currentValue: ComboResponse, curre — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ComboResponse, currentValue: ComboResponse, curre — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ComboResponse>(predicate: (value: ComboResponse, index: number, obj — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ComboResponse, index: number, obj: ComboResponse[]) => unkno — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ComboResponse, start?: number, end?: number) => ComboResponse[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ComboResponse[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ComboResponse]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ComboResponse> — Returns an iterable of values in the array`
- `includes: (searchElement: ComboResponse, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ComboResponse, index: number — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ComboResponse — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ComboResponse> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### toSelectedCodes  <sub>features/master/src/components/searchFields/bigFilterCombo.ts:55</sub>

```ts
(values?: readonly string[]): string[]
```

props/params:

- `length: number — Gets the length of the array. This is a number one higher than the highest element defined in an array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array separated by the specified separator string.`
- `slice: (start?: number, end?: number) => string[] — Returns a section of an array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: readonly s — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: readonly string[]) => unknown, — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: readonly string[]) => void, t — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: readonly string[]) => U, t — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: readonly s — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: readonly str — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: readonly string[]) => unknown, t — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator of values in the array.`
- `__@unscopables@898: { readonly [x: number]: boolean; readonly length?: boolean; toString?: boolean;  — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### buildSalesSiteOptions  <sub>features/master/src/components/searchFields/SearchFields.utils.ts:111</sub>

```ts
(args: ComboOptionArgs): { label: string; value: string; }[]
```

props/params:

- `rows: ComboResponse[]`
- `divisionId?: string`
- `deptId?: string`
- `selected?: string — 현재 선택돼 있는 값. 목록에서 탈락하지 않도록 보존한다.`

### logSearchReset  <sub>features/master/src/components/searchFields/SearchFields.debug.ts:89</sub>

```ts
(opts: { label: string; changed: { field: string; from: string; to: string; }; resets: { field: string; from: string; to: string; }[]; }): void
```

props/params:

- `label: string`
- `changed: { field: string; from: string; to: string; } — 사용자가 직접 바꾼 항목.`
- `resets: { field: string; from: string; to: string; }[] — 그 때문에 같이 초기화되는 항목들.`

### blankValue  <sub>features/master/src/components/searchFields/CascadeFields.utils.ts:231</sub>

```ts
(source: object, field: string): FieldValue
```

### buildCapaAuthContext  <sub>features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts:52</sub>

```ts
(myAuthList: CapaAuthListRow[], fpInstanceRows: CapaFpInstanceRow[], myGroupIds: string[], operGroupList: string[], divisionId: string): CapaAuthContext
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => CapaAuthListRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: CapaAuthListRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<CapaAuthListRow>[]): CapaAuthListRow[]; (...items: (Cap — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => CapaAuthListRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => CapaAuthListRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => CapaAuthListRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: CapaAuthListRow, b: CapaAuthListRow) => number) => CapaAuthList — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): CapaAuthListRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: CapaAuthListRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: CapaAuthListRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: CapaAuthListRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends CapaAuthListRow>(predicate: (value: CapaAuthListRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: CapaAuthListRow, index: number, array: CapaAuthListRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: CapaAuthListRow, index: number, array: CapaAuthListRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: CapaAuthListRow, index: number, array: CapaAuthListRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends CapaAuthListRow>(predicate: (value: CapaAuthListRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: CapaAuthListRow, currentValue: CapaAuthListRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: CapaAuthListRow, currentValue: CapaAuthListRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends CapaAuthListRow>(predicate: (value: CapaAuthListRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: CapaAuthListRow, index: number, obj: CapaAuthListRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: CapaAuthListRow, start?: number, end?: number) => CapaAuthListRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => CapaAuthListRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, CapaAuthListRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<CapaAuthListRow> — Returns an iterable of values in the array`
- `includes: (searchElement: CapaAuthListRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: CapaAuthListRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => CapaAuthListRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<CapaAuthListRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### buildCapaMonthColumns  <sub>features/master/src/components/capaNewModelPopup/capaNewModelPopup.calendar.ts:29</sub>

```ts
(todayYyyymm: string): FlexGridColumnConfig[]
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### buildCapaNewModelColumns  <sub>features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts:126</sub>

```ts
(isGroupElectrode: boolean): RawFlexGridColumnConfig[]
```

props/params:

- `valueOf: () => boolean — Returns the primitive value of the specified object.`

### buildEndCustomerOptions  <sub>features/master/src/components/searchFields/SearchFields.utils.ts:107</sub>

```ts
(args: ComboOptionArgs): { label: string; value: string; }[]
```

props/params:

- `rows: ComboResponse[]`
- `divisionId?: string`
- `deptId?: string`
- `selected?: string — 현재 선택돼 있는 값. 목록에서 탈락하지 않도록 보존한다.`

### callTransfer  <sub>features/master/src/components/versionModal/versionModal.api.ts:65</sub>

```ts
(params: { divisionId: string; versionNo: string; versionType: string; actionType: string; }): Promise<CallProcResult>
```

props/params:

- `divisionId: string`
- `versionNo: string`
- `versionType: string`
- `actionType: string`

### callVersionAction  <sub>features/master/src/components/versionModal/versionModal.api.ts:48</sub>

```ts
(params: { divisionId: string; versionNo: string; versionDescription: string; resultDate: string; actionType: string; mvPlanYyyymm: string; updateYn: string; }): Promise<CallProcResult>
```

props/params:

- `divisionId: string`
- `versionNo: string`
- `versionDescription: string`
- `resultDate: string`
- `actionType: string`
- `mvPlanYyyymm: string`
- `updateYn: string`

### callVersionActionBp  <sub>features/master/src/components/versionModal/versionModal.api.ts:58</sub>

```ts
(params: { divisionId: string; versionNo: string; versionDescription: string; actionType: string; }): Promise<CallProcResult>
```

props/params:

- `divisionId: string`
- `versionNo: string`
- `versionDescription: string`
- `actionType: string`

### cell  <sub>features/master/src/components/searchFields/CascadeFields.utils.ts:180</sub>

```ts
(row: Row, column: string): string
```

### excludeEeDivision  <sub>features/master/src/components/capaNewModelPopup/capa-new-model-popup.constants.ts:88</sub>

```ts
(row: ComboResponse): boolean
```

### hasLaneQtyCandidate  <sub>features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts:77</sub>

```ts
(row: Record<string, unknown>, laneQtyRows: ComboResponse[]): boolean
```

### isAlwaysEditableBinding  <sub>features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts:153</sub>

```ts
(binding: string): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isLockedIdentityBinding  <sub>features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts:170</sub>

```ts
(binding: string): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### logCascade  <sub>features/master/src/components/searchFields/SearchFields.debug.ts:42</sub>

```ts
(opts: { label: string; comboId: string; param?: string; division?: string; steps: { column: string; filter: Set<string>; strict?: boolean; rows: Row[]; }[]; rawRows: Row[]; options: { label: string; value: string; }[]; }): void
```

props/params:

- `label: string — 호출 화면 식별자 (debugLabel prop).`
- `comboId: string — 실제 조회한 콤보 ID.`
- `param?: string — 콤보에 보낸 파라미터 (서버 바인드 경로에서만 값이 있다).`
- `division?: string`
- `steps: { column: string; filter: Set<string>; strict?: boolean; rows: Row[]; }[] — 단계별 스냅샷 — 순서대로 좁혀진 결과. strict = 공란 행도 잘랐는지.`
- `rawRows: Row[] — 콤보 원본 (필터 전).`
- `options: { label: string; value: string; }[] — CustomDropdown 에 최종으로 들어간 옵션.`

### logFilterCombo  <sub>features/master/src/components/searchFields/SearchFields.debug.ts:118</sub>

```ts
(opts: { label: string; comboId: string; rawRows: Record<string, unknown>[]; division?: string; axes?: { column: string; codes: readonly string[]; note?: string; }[]; options: { label: string; value: string; }[]; }): void
```

props/params:

- `label: string`
- `comboId: string`
- `rawRows: Record<string, unknown>[]`
- `division?: string`
- `axes?: { column: string; codes: readonly string[]; note?: string; }[]`
- `options: { label: string; value: string; }[]`

### logLevelCascade  <sub>features/master/src/components/searchFields/SearchFields.debug.ts:172</sub>

```ts
(opts: { label: string; comboId: string; rawRows: Record<string, unknown>[]; levels: { key: string; column: string; filter: Set<string>; remaining: number; options: { label: string; value: string; }[]; }[]; }): void
```

props/params:

- `label: string`
- `comboId: string`
- `rawRows: Record<string, unknown>[]`
- `levels: { key: string; column: string; filter: Set<string>; remaining: number; options: `

### monthsFromToday  <sub>features/master/src/components/capaNewModelPopup/capaNewModelPopup.calendar.ts:17</sub>

```ts
(todayYyyymm: string, span?: number): string[]
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### normalizeLevel  <sub>features/master/src/components/searchFields/CascadeFields.utils.ts:197</sub>

```ts
(input: "division" | "team" | "endCustomer" | "salesSite" | "soldToCustomer" | "plantSite" | "bizType" | "senderCode" | CascadeLevelSpec<string>): CascadeLevelSpec<string>
```

props/params:

- `toString: (() => string)`
- `(() => string) — Returns a string representation of a string. Returns a string representation of an object.`
- `valueOf: (() => string)`
- `(() => Object) — Returns the primitive value of the specified object.`

### readValue  <sub>features/master/src/components/searchFields/CascadeFields.utils.ts:207</sub>

```ts
(source: object, field: string): string
```

### resolveCapaRowEditability  <sub>features/master/src/components/capaNewModelPopup/capaNewModelPopup.editLock.ts:112</sub>

```ts
(row: Record<string, unknown>, sessionUserId: string, isGroupElectrode: boolean, ctx: CapaAuthContext, laneQtyCandidateExists: boolean): CapaRowEditability
```

### toCodeSet  <sub>features/master/src/components/searchFields/CascadeFields.utils.ts:189</sub>

```ts
(v?: string): Set<string>
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### writeValue  <sub>features/master/src/components/searchFields/CascadeFields.utils.ts:227</sub>

```ts
(source: object, field: string, raw: string): FieldValue
```

### yearBoundsOf  <sub>features/master/src/components/searchFields/yearField.util.ts:32</sub>

```ts
(rows: Record<string, unknown>[]): { minYear: number; maxYear: number; }
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => Record<string, unknown> — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: Record<string, unknown>[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<Record<string, unknown>>[]): Record<string, unknown>[]; — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => Record<string, unknown>[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => Record<string, unknown> — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => Record<string, unknown>[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: Record<string, unknown>, b: Record<string, unknown>) => number) — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): Record<string, unknown>[]; (start: numb — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: Record<string, unknown>[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: Record<string, unknown>, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: Record<string, unknown>, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends Record<string, unknown>>(predicate: (value: Record<string, unknown> — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: Record<string, unknown>, index: number, array: Record<string — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: Record<string, unknown>, index: number, array: Record<strin — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: Record<string, unknown>, index: number, array: Record<st — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends Record<string, unknown>>(predicate: (value: Record<string, unknown> — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: Record<string, unknown>, currentValue: Record<str — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: Record<string, unknown>, currentValue: Record<str — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends Record<string, unknown>>(predicate: (value: Record<string, unknown> — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: Record<string, unknown>, index: number, obj: Record<string,  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: Record<string, unknown>, start?: number, end?: number) => Record<string, — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => Record<string, unknown>[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, Record<string, unknown>]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<Record<string, unknown>> — Returns an iterable of values in the array`
- `includes: (searchElement: Record<string, unknown>, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: Record<string, unknown>, ind — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => Record<string, unknown> — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<Record<string, unknown>> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### yearToDayjs  <sub>features/master/src/components/searchFields/yearField.util.ts:11</sub>

```ts
(value: string): any
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### yearValueOf  <sub>features/master/src/components/searchFields/yearField.util.ts:23</sub>

```ts
(date: any): any
```

## shared

| 이름 | import | 사용 | As-is 대응 | 설명 |
|---|---|---|---|---|
| **DEFAULT_COL_WIDTH** | `@shared/components` | 0 |  |  |
| **GRID_COMBO_SRC** | `@shared/components` | 0 |  | 그리드 셀 콤보 요청 출처 표식. useTabComboQueries 의 src 로 넘기면 요청 URL 이 `admin/combo?src=grid` 가 되어 Network 탭에서 검색조건 콤보와 바로 구분된다. 본문에는 안 실린다 - 본문 키는 BE m |
| **POPUP_ID** | `@shared/components` | 0 |  |  |
| **POPUP_ID** | `@shared/components` | 0 |  |  |
| **POPUP_ID** | `@shared/components` | 0 |  |  |
| **STANDARD_COLORS** | `@shared/components` | 0 |  | 표준 색 (엑셀 "표준 색" 행). |
| **THEME_COLORS** | `@shared/components` | 0 |  | 개인화 색 선택 팔레트/hex 유틸 (ColorPickerButton 전용). // 테마 색 기준 행 (Office 유사 10색) — 각 열마다 명도(tint/shade) 변형을 생성한다. |
| **VARIANT_LEVELS** | `@shared/components` | 0 |  | 테마색 그리드 명도 레벨. 0 = 기준행, +값 = tint(밝게), -값 = shade(어둡게). |
| **SHEETS** | `@shared/components` | 599 |  |  |
| **SHEETS** | `@shared/components` | 599 |  |  |
| **SHEETS** | `@shared/components` | 599 |  |  |
| **RESPONSE_SET** | `@shared/components` | 94 |  |  |
| **RESPONSE_SET** | `@shared/components` | 94 |  |  |
| **RESPONSE_SET** | `@shared/components` | 94 |  |  |
| **MoveType** | `@shared/components` | 0 |  |  |
| **createPersistedStoreWithTab** | `@shared/stores` | 138 |  | 탭 내부 페이지 스토어 선언시 사용. 현재 오픈된 tabId에 따른 멀티톤 인스턴스 생성. use...Store.getState() 사용 불가. 영속화하지 않는다(sessionStorage 미저장). - 탭 전환 시 상태 유지는 MDI keep-ali |
| **confirmIfDirtyKey** | `@shared/stores` | 70 |  | dirty 면 상황에 맞는 confirm 을 띄우고 사용자의 선택을 반환한다. dirty 아니면 즉시 true. 사용처: 조회 실행 전(SubTitle/SearchArea), MDI 탭 닫기 전, 다이얼로그 닫기 전. 확인을 누르면 등록된 변경을 실제 |
| **tabDirtyKey** | `@shared/stores` | 70 |  | MDI 탭 단위 키 (TabIdContext 의 tabId) |
| **saveTitleSet** | `@shared/components` | 32 |  | 컬럼/Measure 개인화 영구 저장(SCM_MST_TITLESET_USER) — 공용 엔드포인트(POST /admin/menu/{mnuId}/titleset). ⚠️ 모든 값은 같은 길이의 '^' delim 문자열 — 순서가 곧 컬럼 대응 (SP 는 |
| **createPersistedStore** | `@shared/stores` | 21 |  | 전역 스토어 선언시 사용. 싱글톤 스토어 빌더 use...Store.getState() 사용 가능 |
| **toColumnLayoutSettings** | `@shared/components` | 20 |  | 화면 grid 메타(SHEET_COLUMNS) → 팝업 initialSettings/defaultSettings 변환. titleSet SP 계약(COLUMN_NAME/COLUMN_LABEL)에는 width/color 가 없으므로, 팝업의 Width  |
| **buildSavePayload** | `@shared/components` | 18 |  | 저장 payload 구성 — 표시 컬럼 1..n → 숨김 컬럼 후행 → 비표시 0. hiddenNames = 팝업 dual list 에서 감춘 컬럼(MEASURE 등). 사용자가 좌/우로 옮길 수 없으므로 USER_FLAG 를 항상 'Y' 로 고정한다 |
| **fetchTitleSet** | `@shared/components` | 4 |  | 컬럼/Measure 개인화 조회 — 공용 엔드포인트(POST /admin/menu/{mnuId}/titleset/search). ⭐ 화면별 `{menuId}/titleSet/SEARCH/call-proc` 을 쓰면 SCM_ADM_MNU_BTN_MPG_ |
| **applyGridLayout** | `@shared/components` | 3 |  | admin 컬럼 메타 위에 사용자 레이아웃(표시/순서/폭)을 덮어쓴다. sales-future-price `applyLayoutToColumns` 와 동일 계약을 공통화한 것: - 레이아웃에 있는 컬럼: visible = USER_FLAG, 폭 ove |
| **fetchGridLayout** | `@shared/components` | 3 |  | 저장된 레이아웃 조회 + 파싱. `null` = 없음/실패 → 적용하지 않음(admin 메타 그대로). |
| **isoWeeksOfMonth** | `@shared/lib` | 2 |  | yyyymm 의 ISO 주 분해 — 달력 순서, 월경계 주는 "월내 기여 일수"만 계상. 주 태그의 yyyymm 은 항상 입력 월 (GET_SPREAD_TITLE 월경계 분할 규약과 동일). |
| **distributeMonthToWeeks** | `@shared/lib` | 1 |  | 룰1 — 월 수량 → 주별 배분. perDay = trunc(monthQty / 월 총일수) → 주별 = perDay × 주 월내일수. 끝자리(monthQty − Σ주별)는 마지막 주에 +/- 가산 (음수 포함 — 총합 = monthQty 보존). u |
| **distributeWeekToDays** | `@shared/lib` | 1 |  | 룰2 — 주 수량 → 주내 일 배분. applicableMask(7bit SUN-first) 의 적용요일에 trunc 균등 배분 + 잔여 = 마지막 적용일. 적용요일이 하나도 없으면(마스크 없음·전부 0·주 범위 밖) 월요일(dow===1)에 전량 — |
| **applyLevel** | `@shared/components` | 0 |  |  |
| **attachGridContextMenu** | `@shared/components` | 0 |  | 그리드에 컨텍스트 메뉴를 설치한다. 반환 함수로 해제. 허용 영역: 컬럼 헤더(그룹 헤더 포함) / 데이터 셀. rowHeader(No·상태)·corner·빈 영역은 브라우저 기본 메뉴를 유지한다. |
| **buildDefaultRows** | `@shared/components` | 0 |  | Default(리셋) 버튼용 행 구성 — DB 의 컬럼 기본 셋팅(SCM_MST_SHEET_COLUMNS) 그대로. buildInitialRows 와의 차이: 저장된 개인화를 일절 반영하지 않는다. 금지: Default 경로에서 buildInitial |
| **buildInitialRows** | `@shared/components` | 0 |  | 팝업 초기 행 구성. ⭐ 우선순위 = DB(BE 응답) > 화면 상태(initialSettings) (2026-07-27 요청). 저장된 개인화가 있으면 그게 최우선으로 보여야 하므로, initialSettings 는 BE 가 값을 주지 않은 필드만  |
| **buildThemeGrid** | `@shared/components` | 0 |  | 테마색 그리드 (행 = 명도 레벨, 열 = 기준색). |
| **changeCellColor** | `@shared/components` | 0 |  |  |
| **changeTextColor** | `@shared/components` | 0 |  |  |
| **changeWidth** | `@shared/components` | 0 |  |  |
| **computeReorder** | `@shared/components` | 0 |  | 단일 리스트 D&D 재정렬 순수 유틸 (ColumnLayoutList 전용). |
| **confirmIfScopeDirty** | `@shared/stores` | 0 |  |  |
| **confirmIfTabDirty** | `@shared/stores` | 0 |  |  |
| **confirmIfTabsDirty** | `@shared/stores` | 0 |  | 여러 탭을 한 번에 닫을 때(모두 닫기/다른 탭 닫기) — 하나라도 dirty 면 confirm 1회. |
| **createStandardStore** | `@shared/stores` | 0 |  |  |
| **deriveIsKey** | `@shared/components` | 0 |  | 고정(이동 불가) 컬럼 판정 — USER_SELECTABLE_FLAG='N'. 값 미제공은 '변경 가능' 으로 본다. |
| **discardDirtyKey** | `@shared/stores` | 0 |  | 키에 등록된 미저장 변경을 전부 되돌린다. 되돌리기가 던져도 나머지 대상과 이탈을 막지 않는다. 호출 시점은 confirm "확인" 직후 — 그리드가 아직 살아 있을 때여야 한다. |
| **fetchColumnMeta** | `@shared/components` | 0 |  | admin 컬럼 메타 조회 (PR_GET_SHEET_COLUMN_LIST) — 팝업 목록에서 뺄 컬럼 판정용. ⚠️ 실패 시 `[]` — 필터가 no-op 이 되어 종전 동작(전 컬럼 표시)으로 떨어진다. 메타 조회 실패로 팝업이 통째로 비는 쪽이 훨 |
| **filterBySearch** | `@shared/components` | 0 |  | 목록 검색 필터. 검색어에 콤마가 있으면 여러 검색어로 갈라 OR 로 거른다(다중 조회 — 사용자 요구 2026-09-30). 콤마가 없으면 종전과 100% 동일한 단일 부분일치라 회귀가 없다. - 각 검색어는 위 listFilter 를 그대로 태운다 |
| **getRecentColors** | `@shared/components` | 0 |  |  |
| **getViewActions** | `@shared/stores` | 0 |  |  |
| **hexToRgb** | `@shared/components` | 0 |  |  |
| **isAnyDirty** | `@shared/stores` | 0 |  | 열린 모든 탭/스코프 중 dirty 존재 여부 — beforeunload 용 |
| **isDirtyKey** | `@shared/stores` | 0 |  | 키에 등록된 판정 중 하나라도 dirty 면 true. 판정 함수가 던져도 이탈이 막히지 않게 무시한다. |
| **isEditableForRow** | `@shared/hooks` | 0 |  | 그 행에서 사용자가 실제로 채울 수 있는 셀인가 — GridUtils.isEditableCell 과 같은 규칙을 // grid 대신 raw 메타/행 데이터로 판정한 것이다. // 필수 표시가 있어도 편집할 수 없는 셀은 검증하지 않는다. 막아봐야 사용 |
| **isMandatoryColumn** | `@shared/hooks` | 0 |  | 필수 컬럼 판정 — 헤더 빨간 점(dataGridUtils.formatEditableColumns)과 반드시 같은 조건이어야 한다. // 메타 등록 방식이 화면마다 둘로 갈린다: inputTpCd = M / IM, 또는 라벨(colLblNm) 끝의 ` |
| **isScopeDirty** | `@shared/stores` | 0 |  |  |
| **isTabDirty** | `@shared/stores` | 0 |  |  |
| **isValidHex** | `@shared/components` | 0 |  |  |
| **isVisibleColumn** | `@shared/components` | 0 |  | 팝업 목록에 올릴 컬럼인지 — admin 메타의 VISIBLE_FLAG(= 관리 노출 여부) 기준. ⭐ GET_TITLESET_POPUP 은 sheet 메타에 등록된 컬럼을 전부 내려주므로, 관리자가 노출 대상에서 뺀 컬럼(VISIBLE_FLAG='N |
| **mergeInsertedRows** | `@shared/hooks` | 0 |  | 조회결과(spRows)에 신규행(insertedRows)을 anchor 위치대로 끼워 넣어 그리드 소스를 만든다. 순수 함수 — 훅과 별개로 단위 테스트 대상. |
| **normalizeHex** | `@shared/components` | 0 |  |  |
| **overrideRows** | `@shared/components` | 0 |  | base 행에 settings 를 강제로 덮어쓴다 (Default 원복 등 — DB 값보다 우선시켜야 할 때). |
| **parseGridLayout** | `@shared/components` | 0 |  | TitleSet 응답 → 레이아웃 행 파싱. ⭐ 사용자 저장값(USER_* 별칭) 우선 — 관리자쪽(COLUMN_WIDTH/SORT_ORDER_NO)만 읽으면 저장한 값이 영원히 안 보인다 (ColumnLayoutModal mapBeRow 와 동일 계 |
| **parseWidth** | `@shared/components` | 0 |  |  |
| **pushRecentColor** | `@shared/components` | 0 |  |  |
| **registerDirtyCheck** | `@shared/stores` | 0 |  | dirty 판정 함수를 키들에 등록한다. 반환된 함수로 해제(그리드 언마운트 시). 같은 그리드가 tab 키와 scope 키(다이얼로그 안일 때)에 동시 등록될 수 있다 — 다이얼로그의 편집분도 "탭을 닫으면 사라지는 변경" 이므로 탭 집계에 포함하는 |
| **registerDirtyReset** | `@shared/stores` | 0 |  | 미저장 변경 되돌리기 함수를 키들에 등록한다. 등록 규약은 registerDirtyCheck 과 동일. confirm 에서 사용자가 "확인"(= 버리고 진행)을 누르면 이 함수들이 호출된다. 그리드는 DataGrid 가 자동 등록하므로, 화면은 그리드 |
| **registerStore** | `@shared/stores` | 0 |  | 스토어가 자신을 등록할 때 사용할 함수 |
| **registerViewActions** | `@shared/stores` | 0 |  |  |
| **reorderRows** | `@shared/components` | 0 |  |  |
| **resetAllStores** | `@shared/stores` | 0 |  | 모든 스토어를 한 번에 리셋하는 함수 |
| **rgbToHex** | `@shared/components` | 0 |  |  |
| **scopeDirtyKey** | `@shared/stores` | 0 |  | 다이얼로그 스코프 단위 키 (DialogScopeContext 의 scopeId) |
| **serializeSavePayload** | `@shared/components` | 0 |  | 저장 payload 를 값 기준 문자열로 직렬화 — 저장에 실제로 반영되는 축(표시 여부·순서·폭·색)만 본다. 라벨/isKey 는 사용자가 못 바꾸는 표시 메타라 제외한다. buildSavePayload 가 순서를 1..n 으로 정규화하므로, 초기  |
| **shade** | `@shared/components` | 0 |  | 검정과 factor(0..1) 비율로 섞어 어둡게. |
| **subscribeRecent** | `@shared/components` | 0 |  |  |
| **tint** | `@shared/components` | 0 |  | 흰색과 factor(0..1) 비율로 섞어 밝게. |
| **toggleDisplay** | `@shared/components` | 0 |  |  |
| **toHiddenColumnSet** | `@shared/components` | 0 |  | admin 메타에서 노출 금지된 컬럼명 집합 — `visible === false` (= VISIBLE_FLAG 'N') 또는 관리자 기본 폭이 0 (= COLUMN_WIDTH 0). 주의: `display === false` 는 넣지 않는다. 그건  |
| **toZeroWidthColumnSet** | `@shared/components` | 0 |  | **관리자 기본 폭이 0** 인 컬럼명 집합 — Column Setting 목록에서 감출 대상 (사용자 지시 2026-08-22: "GRID COLUMN SETTING 에서 WIDTH = 0 이면 목록에서 보이지 않도록"). ⚠️ `ColumnLayo |
| **unpivotWideRows** | `@shared/components` | 0 |  | wide(PIVOT 커서: 축 컬럼 + D_/W_/M_ 기간 컬럼들) → long(행당 기간 1값) 변환. waterfall SP 커서를 OLAP PivotEngine 계약(long-format)으로 바꾸는 표준 유틸. |
| **unregisterViewActions** | `@shared/stores` | 0 |  |  |
| **DialogScopeContext** | `@shared/stores` | 1 |  | 현재 서브트리가 속한 다이얼로그 스코프 id. 페이지 최상위(다이얼로그 밖)는 root 스코프로 취급하며 null. CustomDialog가 자신의 스코프 id로 Provider를 씌운다. |
| **listFilter** | `@shared/components` | 0 |  | MUI 기본 목록 필터(대소문자 무시, 부분일치). CustomDropdown 의 두 곳(filterOptions 와 // handleSelectAll)에서 같은 기준을 써야 '목록에 보이는 것'과 'SELECT ALL 이 고르는 것'이 // 어긋나지 |
| **MenuIdContext** | `@shared/stores` | 0 |  | 현재 탭 화면의 mnuId(= 화면 코드, 예 'DMF0003'). ViewContainer 가 탭마다 Provider 로 심는다. 콤보 SQL(SCM_ADM_CMBO_SQL_M)의 |
| **TabIdContext** | `@shared/stores` | 0 |  |  |

### createPersistedStoreWithTab  <sub>packages/shared/src/stores/createStore.ts:82</sub>

```ts
<T extends BaseTabState>(stateCreator: StateCreator<T, [["zustand/immer", never]], []>, _storageName: string): <U>(selector: (state: T) => U) => any
```

### confirmIfDirtyKey  <sub>packages/shared/src/stores/useDirtyRegistry.ts:125</sub>

```ts
(key: string, kind: "close" | "search"): Promise<boolean>
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### tabDirtyKey  <sub>packages/shared/src/stores/useDirtyRegistry.ts:26</sub>

```ts
(tabId: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### saveTitleSet  <sub>packages/shared/src/components/organisms/data-grid/titleSetApi.ts:76</sub>

```ts
(params: { menuId: string; sheetName: string; columnType: string; rows: TitleSetSaveRow[]; }): Promise<boolean>
```

props/params:

- `menuId: string`
- `sheetName: string`
- `columnType: string`
- `rows: TitleSetSaveRow[]`

### createPersistedStore  <sub>packages/shared/src/stores/createStore.ts:46</sub>

```ts
<T extends object>(stateCreator: StateCreator<T, [["zustand/immer", never]], []>, storageName: string): UseBoundStore<StoreApi<T>>
```

### toColumnLayoutSettings  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:56</sub>

```ts
(rawColumns: RawFlexGridColumnConfig[]): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => RawFlexGridColumnConfig — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: RawFlexGridColumnConfig[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<RawFlexGridColumnConfig>[]): RawFlexGridColumnConfig[]; — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => RawFlexGridColumnConfig[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => RawFlexGridColumnConfig — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => RawFlexGridColumnConfig[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: RawFlexGridColumnConfig, b: RawFlexGridColumnConfig) => number) — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): RawFlexGridColumnConfig[]; (start: numb — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: RawFlexGridColumnConfig[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridCo — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridC — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGr — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: RawFlexGridColumnConfig, index: number, obj: RawFlexGridColu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: RawFlexGridColumnConfig, start?: number, end?: number) => RawFlexGridCol — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => RawFlexGridColumnConfig[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, RawFlexGridColumnConfig]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<RawFlexGridColumnConfig> — Returns an iterable of values in the array`
- `includes: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: RawFlexGridColumnConfig, ind — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => RawFlexGridColumnConfig — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<RawFlexGridColumnConfig> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### buildSavePayload  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:356</sub>

```ts
(rows: ColumnLayoutRow[], hiddenNames: ReadonlySet<string>): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### fetchTitleSet  <sub>packages/shared/src/components/organisms/data-grid/titleSetApi.ts:31</sub>

```ts
(params: { menuId: string; sheetName: string; columnType: string; divisionId: string; }): Promise<Record<string, string>[]>
```

props/params:

- `menuId: string`
- `sheetName: string`
- `columnType: string — 'C' = 컬럼 / 'M' = measure (화면에 따라 'main' 등 자체 값).`
- `divisionId: string`

### applyGridLayout  <sub>packages/shared/src/components/organisms/data-grid/titleSetApi.ts:213</sub>

```ts
(columns: RawFlexGridColumnConfig[], layout: GridLayoutRow[]): RawFlexGridColumnConfig[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => RawFlexGridColumnConfig — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: RawFlexGridColumnConfig[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<RawFlexGridColumnConfig>[]): RawFlexGridColumnConfig[]; — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => RawFlexGridColumnConfig[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => RawFlexGridColumnConfig — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => RawFlexGridColumnConfig[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: RawFlexGridColumnConfig, b: RawFlexGridColumnConfig) => number) — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): RawFlexGridColumnConfig[]; (start: numb — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: RawFlexGridColumnConfig[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridCo — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGridC — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: RawFlexGridColumnConfig, index: number, array: RawFlexGr — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: RawFlexGridColumnConfig, currentValue: RawFlexGri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends RawFlexGridColumnConfig>(predicate: (value: RawFlexGridColumnConfig — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: RawFlexGridColumnConfig, index: number, obj: RawFlexGridColu — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: RawFlexGridColumnConfig, start?: number, end?: number) => RawFlexGridCol — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => RawFlexGridColumnConfig[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, RawFlexGridColumnConfig]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<RawFlexGridColumnConfig> — Returns an iterable of values in the array`
- `includes: (searchElement: RawFlexGridColumnConfig, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: RawFlexGridColumnConfig, ind — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => RawFlexGridColumnConfig — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<RawFlexGridColumnConfig> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### fetchGridLayout  <sub>packages/shared/src/components/organisms/data-grid/titleSetApi.ts:195</sub>

```ts
(key: GridLayoutKey): Promise<GridLayoutRow[]>
```

props/params:

- `menuId: string`
- `sheetName: string`
- `columnType?: string — 기본 'C'(컬럼). 자체 규약을 쓰는 기존 화면과 분리하려는 경우에만 변경.`
- `divisionId?: string`

### isoWeeksOfMonth  <sub>packages/shared/src/lib/bucket-distribution.ts:42</sub>

```ts
(yyyymm: string): WeekOfMonth[]
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### distributeMonthToWeeks  <sub>packages/shared/src/lib/bucket-distribution.ts:69</sub>

```ts
(monthQty: number, weeks: WeekOfMonth[], unit?: number): WeekDistribution[]
```

props/params:

- `toString: (radix?: number) => string — Returns a string representation of an object.`
- `toFixed: (fractionDigits?: number) => string — Returns a string representing a number in fixed-point notation.`
- `toExponential: (fractionDigits?: number) => string — Returns a string containing a number represented in exponential notation.`
- `toPrecision: (precision?: number) => string — Returns a string containing a number represented either in exponential or fixed-point notation with a specified number of digits.`
- `valueOf: () => number — Returns the primitive value of the specified object.`
- `toLocaleString: { (locales?: string`
- `string[], options?: NumberFormatOptions): string; (locales — Converts a number to a string by using the current or specified locale.`

### distributeWeekToDays  <sub>packages/shared/src/lib/bucket-distribution.ts:113</sub>

```ts
(weekQty: number, days: DayOfWeekCell[], applicableMask: string, unit?: number): DayDistribution[]
```

props/params:

- `toString: (radix?: number) => string — Returns a string representation of an object.`
- `toFixed: (fractionDigits?: number) => string — Returns a string representing a number in fixed-point notation.`
- `toExponential: (fractionDigits?: number) => string — Returns a string containing a number represented in exponential notation.`
- `toPrecision: (precision?: number) => string — Returns a string containing a number represented either in exponential or fixed-point notation with a specified number of digits.`
- `valueOf: () => number — Returns the primitive value of the specified object.`
- `toLocaleString: { (locales?: string`
- `string[], options?: NumberFormatOptions): string; (locales — Converts a number to a string by using the current or specified locale.`

### applyLevel  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:87</sub>

```ts
(hex: string, level: number): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### attachGridContextMenu  <sub>packages/shared/src/components/organisms/data-grid/gridContextMenu.ts:359</sub>

```ts
(grid: FlexGrid, options: GridContextMenuOptions): () => void
```

### buildDefaultRows  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:290</sub>

```ts
(beRows: Record<string, string>[], fallbackColumns: ColumnSettingFallback[], metaRows: Partial<ColumnMetaRow>[]): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => Record<string, string> — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: Record<string, string>[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<Record<string, string>>[]): Record<string, string>[]; ( — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => Record<string, string>[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => Record<string, string> — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => Record<string, string>[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: Record<string, string>, b: Record<string, string>) => number) = — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): Record<string, string>[]; (start: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: Record<string, string>[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: Record<string, string>, index: number, array: Record<string, — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: Record<string, string>, index: number, array: Record<string — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: Record<string, string>, index: number, array: Record<str — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: Record<string, string>, index: number, obj: Record<string, s — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: Record<string, string>, start?: number, end?: number) => Record<string,  — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => Record<string, string>[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, Record<string, string>]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<Record<string, string>> — Returns an iterable of values in the array`
- `includes: (searchElement: Record<string, string>, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: Record<string, string>, inde — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => Record<string, string> — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<Record<string, string>> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### buildInitialRows  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:223</sub>

```ts
(beRows: Record<string, string>[], fallbackColumns: ColumnSettingFallback[], initialSettings?: ColumnLayoutRow[]): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => Record<string, string> — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: Record<string, string>[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<Record<string, string>>[]): Record<string, string>[]; ( — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => Record<string, string>[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => Record<string, string> — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => Record<string, string>[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: Record<string, string>, b: Record<string, string>) => number) = — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): Record<string, string>[]; (start: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: Record<string, string>[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: Record<string, string>, index: number, array: Record<string, — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: Record<string, string>, index: number, array: Record<string — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: Record<string, string>, index: number, array: Record<str — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: Record<string, string>, index: number, obj: Record<string, s — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: Record<string, string>, start?: number, end?: number) => Record<string,  — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => Record<string, string>[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, Record<string, string>]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<Record<string, string>> — Returns an iterable of values in the array`
- `includes: (searchElement: Record<string, string>, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: Record<string, string>, inde — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => Record<string, string> — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<Record<string, string>> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### buildThemeGrid  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:95</sub>

```ts
(): string[][]
```

### changeCellColor  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:402</sub>

```ts
(rows: ColumnLayoutRow[], key: string, hex: string): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### changeTextColor  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:408</sub>

```ts
(rows: ColumnLayoutRow[], key: string, hex: string): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### changeWidth  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:396</sub>

```ts
(rows: ColumnLayoutRow[], key: string, width: number): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### computeReorder  <sub>packages/shared/src/components/molecules/columnLayoutList/columnLayoutList.utils.ts:2</sub>

```ts
(keys: string[], dragKey: string, targetKey: string): string[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => string — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: string[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => string[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => string — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => string[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: string, b: string) => number) => string[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): string[]; (start: number, deleteCount:  — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: string[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: string[]) => unknown, thisArg? — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: string[]) => void, thisArg?:  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: string[]) => U, thisArg?:  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: string[]) => — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: string[]) => unknown, thisArg?:  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: string, start?: number, end?: number) => string[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => string[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### confirmIfScopeDirty  <sub>packages/shared/src/stores/useDirtyRegistry.ts:136</sub>

```ts
(scopeId: string): Promise<boolean>
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### confirmIfTabDirty  <sub>packages/shared/src/stores/useDirtyRegistry.ts:135</sub>

```ts
(tabId: string): Promise<boolean>
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### confirmIfTabsDirty  <sub>packages/shared/src/stores/useDirtyRegistry.ts:142</sub>

```ts
(tabIds: string[]): Promise<boolean>
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => string — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: string[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => string[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => string — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => string[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: string, b: string) => number) => string[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): string[]; (start: number, deleteCount:  — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: string[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: string[]) => unknown, thisArg? — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: string[]) => void, thisArg?:  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: string[]) => U, thisArg?:  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: string[]) => — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: string[]) => unknown, thisArg?:  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: string, start?: number, end?: number) => string[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => string[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### createStandardStore  <sub>packages/shared/src/stores/createStore.ts:123</sub>

```ts
<T extends object>(stateCreator: StateCreator<T, [["zustand/immer", never]], []>, _storeName: string): UseBoundStore<StoreApi<T>>
```

### deriveIsKey  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:35</sub>

```ts
(row: Record<string, unknown>): boolean
```

### discardDirtyKey  <sub>packages/shared/src/stores/useDirtyRegistry.ts:85</sub>

```ts
(key: string): void
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### fetchColumnMeta  <sub>packages/shared/src/components/organisms/data-grid/titleSetApi.ts:126</sub>

```ts
(params: { menuId: string; sheetName: string; divisionId: string; }): Promise<ColumnMetaRow[]>
```

props/params:

- `menuId: string`
- `sheetName: string`
- `divisionId: string`

### filterBySearch  <sub>packages/shared/src/components/molecules/customDropdown/filterBySearch.ts:16</sub>

```ts
(opts: DropdownOption[], inputValue: string, getOptionLabel: (opt: DropdownOption) => string): DropdownOption[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => DropdownOption — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: DropdownOption[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<DropdownOption>[]): DropdownOption[]; (...items: any[]) — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => DropdownOption[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => DropdownOption — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => DropdownOption[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: DropdownOption, b: DropdownOption) => number) => DropdownOption — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): DropdownOption[]; (start: number, delet — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: DropdownOption[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: DropdownOption, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: DropdownOption, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends DropdownOption>(predicate: (value: DropdownOption, index: number, a — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: DropdownOption, index: number, array: DropdownOption[]) => u — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: DropdownOption, index: number, array: DropdownOption[]) =>  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: DropdownOption, index: number, array: DropdownOption[])  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends DropdownOption>(predicate: (value: DropdownOption, index: number, a — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: DropdownOption, currentValue: DropdownOption, cur — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: DropdownOption, currentValue: DropdownOption, cur — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends DropdownOption>(predicate: (value: DropdownOption, index: number, o — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: DropdownOption, index: number, obj: DropdownOption[]) => unk — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: DropdownOption, start?: number, end?: number) => DropdownOption[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => DropdownOption[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, DropdownOption]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<DropdownOption> — Returns an iterable of values in the array`
- `includes: (searchElement: DropdownOption, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: DropdownOption, index: numbe — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => DropdownOption — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<DropdownOption> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### getRecentColors  <sub>packages/shared/src/components/molecules/colorPickerButton/recentColors.ts:8</sub>

```ts
(): string[]
```

### getViewActions  <sub>packages/shared/src/stores/viewActionRegistry.ts:21</sub>

```ts
(tabId: string): Record<string, ViewAction>
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### hexToRgb  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:58</sub>

```ts
(hex: string): Rgb
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isAnyDirty  <sub>packages/shared/src/stores/useDirtyRegistry.ts:101</sub>

```ts
(): boolean
```

### isDirtyKey  <sub>packages/shared/src/stores/useDirtyRegistry.ts:68</sub>

```ts
(key: string): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isEditableForRow  <sub>packages/shared/src/hooks/useSaveWithValidation.ts:25</sub>

```ts
(column: RawFlexGridColumnConfig, row: WijmoRowItem): boolean
```

### isMandatoryColumn  <sub>packages/shared/src/hooks/useSaveWithValidation.ts:16</sub>

```ts
(column: RawFlexGridColumnConfig): boolean
```

### isScopeDirty  <sub>packages/shared/src/stores/useDirtyRegistry.ts:98</sub>

```ts
(scopeId: string): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isTabDirty  <sub>packages/shared/src/stores/useDirtyRegistry.ts:97</sub>

```ts
(tabId: string): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isValidHex  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:36</sub>

```ts
(s: string): boolean
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### isVisibleColumn  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:135</sub>

```ts
(r: Record<string, string>): boolean
```

### mergeInsertedRows  <sub>packages/shared/src/hooks/useInsertedRows.ts:119</sub>

```ts
<T>(spRows: readonly T[], insertedRows: readonly T[], anchors: ReadonlyMap<string, AnchorInfo>): T[]
```

props/params:

- `length: number — Gets the length of the array. This is a number one higher than the highest element defined in an array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `concat: { (...items: ConcatArray<T>[]): T[]; (...items: (T`
- `ConcatArray<T>)[]): T[]; } — Combines two or more arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array separated by the specified separator string.`
- `slice: (start?: number, end?: number) => T[] — Returns a section of an array.`
- `indexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array.`
- `lastIndexOf: (searchElement: T, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array.`
- `every: { <S extends T>(predicate: (value: T, index: number, array: readonly T[]) => val — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: T, index: number, array: readonly T[]) => unknown, thisArg?: — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: T, index: number, array: readonly T[]) => void, thisArg?: a — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: T, index: number, array: readonly T[]) => U, thisArg?: a — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends T>(predicate: (value: T, index: number, array: readonly T[]) => val — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array:  — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends T>(predicate: (value: T, index: number, obj: readonly T[]) => value — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: T, index: number, obj: readonly T[]) => unknown, thisArg?: a — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `entries: () => ArrayIterator<[number, T]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<T> — Returns an iterable of values in the array`
- `includes: (searchElement: T, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: T, index: number, array: T[] — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => T — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<T> — Iterator of values in the array.`
- `__@unscopables@898: { readonly [x: number]: boolean; readonly length?: boolean; toString?: boolean;  — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### normalizeHex  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:38</sub>

```ts
(s: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### overrideRows  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:194</sub>

```ts
(base: ColumnLayoutRow[], settings: ColumnLayoutRow[]): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### parseGridLayout  <sub>packages/shared/src/components/organisms/data-grid/titleSetApi.ts:180</sub>

```ts
(rows: Record<string, string>[]): GridLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => Record<string, string> — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: Record<string, string>[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<Record<string, string>>[]): Record<string, string>[]; ( — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => Record<string, string>[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => Record<string, string> — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => Record<string, string>[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: Record<string, string>, b: Record<string, string>) => number) = — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): Record<string, string>[]; (start: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: Record<string, string>[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: Record<string, string>, index: number, array: Record<string, — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: Record<string, string>, index: number, array: Record<string — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: Record<string, string>, index: number, array: Record<str — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: Record<string, string>, index: number, obj: Record<string, s — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: Record<string, string>, start?: number, end?: number) => Record<string,  — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => Record<string, string>[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, Record<string, string>]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<Record<string, string>> — Returns an iterable of values in the array`
- `includes: (searchElement: Record<string, string>, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: Record<string, string>, inde — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => Record<string, string> — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<Record<string, string>> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### parseWidth  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:75</sub>

```ts
(raw: string, fallback: number): number
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### pushRecentColor  <sub>packages/shared/src/components/molecules/colorPickerButton/recentColors.ts:10</sub>

```ts
(hex: string): void
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### registerDirtyCheck  <sub>packages/shared/src/stores/useDirtyRegistry.ts:54</sub>

```ts
(keys: string[], check: DirtyCheck): () => void
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => string — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: string[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => string[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => string — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => string[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: string, b: string) => number) => string[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): string[]; (start: number, deleteCount:  — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: string[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: string[]) => unknown, thisArg? — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: string[]) => void, thisArg?:  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: string[]) => U, thisArg?:  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: string[]) => — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: string[]) => unknown, thisArg?:  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: string, start?: number, end?: number) => string[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => string[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### registerDirtyReset  <sub>packages/shared/src/stores/useDirtyRegistry.ts:64</sub>

```ts
(keys: string[], reset: DirtyReset): () => void
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => string — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: string[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<string>[]): string[]; (...items: (string`
- `ConcatArray< — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => string[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => string — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => string[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: string, b: string) => number) => string[] — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): string[]; (start: number, deleteCount:  — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: string[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: string, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: string, index: number, array: string[]) => unknown, thisArg? — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: string, index: number, array: string[]) => void, thisArg?:  — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: string, index: number, array: string[]) => U, thisArg?:  — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends string>(predicate: (value: string, index: number, array: string[])  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: string, currentValue: string, currentIndex: numbe — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends string>(predicate: (value: string, index: number, obj: string[]) => — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: string, index: number, obj: string[]) => unknown, thisArg?:  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: string, start?: number, end?: number) => string[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => string[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, string]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<string> — Returns an iterable of values in the array`
- `includes: (searchElement: string, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: string, index: number, array — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => string — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<string> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### registerStore  <sub>packages/shared/src/stores/storeRegistry.ts:5</sub>

```ts
(resetFn: () => void): void
```

### registerViewActions  <sub>packages/shared/src/stores/viewActionRegistry.ts:13</sub>

```ts
(tabId: string, actions: Record<string, ViewAction>): void
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### reorderRows  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:414</sub>

```ts
(rows: ColumnLayoutRow[], orderedKeys: string[]): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### resetAllStores  <sub>packages/shared/src/stores/storeRegistry.ts:10</sub>

```ts
(): void
```

### rgbToHex  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:72</sub>

```ts
(r: number, g: number, b: number): string
```

props/params:

- `toString: (radix?: number) => string — Returns a string representation of an object.`
- `toFixed: (fractionDigits?: number) => string — Returns a string representing a number in fixed-point notation.`
- `toExponential: (fractionDigits?: number) => string — Returns a string containing a number represented in exponential notation.`
- `toPrecision: (precision?: number) => string — Returns a string containing a number represented either in exponential or fixed-point notation with a specified number of digits.`
- `valueOf: () => number — Returns the primitive value of the specified object.`
- `toLocaleString: { (locales?: string`
- `string[], options?: NumberFormatOptions): string; (locales — Converts a number to a string by using the current or specified locale.`

### scopeDirtyKey  <sub>packages/shared/src/stores/useDirtyRegistry.ts:28</sub>

```ts
(scopeId: string): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### serializeSavePayload  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:382</sub>

```ts
(rows: ColumnLayoutRow[]): string
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### shade  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:82</sub>

```ts
(hex: string, factor: number): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### subscribeRecent  <sub>packages/shared/src/components/molecules/colorPickerButton/recentColors.ts:16</sub>

```ts
(cb: () => void): () => void
```

### tint  <sub>packages/shared/src/components/molecules/colorPickerButton/colorUtils.ts:76</sub>

```ts
(hex: string, factor: number): string
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`

### toggleDisplay  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:391</sub>

```ts
(rows: ColumnLayoutRow[], key: string): ColumnLayoutRow[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => ColumnLayoutRow — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: ColumnLayoutRow[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<ColumnLayoutRow>[]): ColumnLayoutRow[]; (...items: (Col — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => ColumnLayoutRow[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => ColumnLayoutRow — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => ColumnLayoutRow[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: ColumnLayoutRow, b: ColumnLayoutRow) => number) => ColumnLayout — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): ColumnLayoutRow[]; (start: number, dele — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: ColumnLayoutRow[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: ColumnLayoutRow, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) => — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[]) = — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: ColumnLayoutRow, index: number, array: ColumnLayoutRow[] — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: ColumnLayoutRow, currentValue: ColumnLayoutRow, c — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends ColumnLayoutRow>(predicate: (value: ColumnLayoutRow, index: number, — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: ColumnLayoutRow, index: number, obj: ColumnLayoutRow[]) => u — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: ColumnLayoutRow, start?: number, end?: number) => ColumnLayoutRow[] — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => ColumnLayoutRow[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, ColumnLayoutRow]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<ColumnLayoutRow> — Returns an iterable of values in the array`
- `includes: (searchElement: ColumnLayoutRow, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: ColumnLayoutRow, index: numb — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => ColumnLayoutRow — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<ColumnLayoutRow> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### toHiddenColumnSet  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:157</sub>

```ts
(cols: Partial<ColumnMetaRow>[]): Set<string>
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => Partial<ColumnMetaRow> — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: Partial<ColumnMetaRow>[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<Partial<ColumnMetaRow>>[]): Partial<ColumnMetaRow>[]; ( — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => Partial<ColumnMetaRow>[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => Partial<ColumnMetaRow> — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => Partial<ColumnMetaRow>[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: Partial<ColumnMetaRow>, b: Partial<ColumnMetaRow>) => number) = — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): Partial<ColumnMetaRow>[]; (start: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: Partial<ColumnMetaRow>[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: Partial<ColumnMetaRow>, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: Partial<ColumnMetaRow>, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends Partial<ColumnMetaRow>>(predicate: (value: Partial<ColumnMetaRow>,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: Partial<ColumnMetaRow>, index: number, array: Partial<Column — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: Partial<ColumnMetaRow>, index: number, array: Partial<Colum — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: Partial<ColumnMetaRow>, index: number, array: Partial<Co — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends Partial<ColumnMetaRow>>(predicate: (value: Partial<ColumnMetaRow>,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: Partial<ColumnMetaRow>, currentValue: Partial<Col — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: Partial<ColumnMetaRow>, currentValue: Partial<Col — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends Partial<ColumnMetaRow>>(predicate: (value: Partial<ColumnMetaRow>,  — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: Partial<ColumnMetaRow>, index: number, obj: Partial<ColumnMe — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: Partial<ColumnMetaRow>, start?: number, end?: number) => Partial<ColumnM — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => Partial<ColumnMetaRow>[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, Partial<ColumnMetaRow>]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<Partial<ColumnMetaRow>> — Returns an iterable of values in the array`
- `includes: (searchElement: Partial<ColumnMetaRow>, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: Partial<ColumnMetaRow>, inde — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => Partial<ColumnMetaRow> — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<Partial<ColumnMetaRow>> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### toZeroWidthColumnSet  <sub>packages/shared/src/components/templates/modals/column-layout-modal/columnLayoutModal.utils.ts:176</sub>

```ts
(beRows: Record<string, string>[], fallbackColumns?: ColumnSettingFallback[]): Set<string>
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => Record<string, string> — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: Record<string, string>[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<Record<string, string>>[]): Record<string, string>[]; ( — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => Record<string, string>[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => Record<string, string> — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => Record<string, string>[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: Record<string, string>, b: Record<string, string>) => number) = — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): Record<string, string>[]; (start: numbe — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: Record<string, string>[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: Record<string, string>, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: Record<string, string>, index: number, array: Record<string, — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: Record<string, string>, index: number, array: Record<string — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: Record<string, string>, index: number, array: Record<str — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: Record<string, string>, currentValue: Record<stri — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends Record<string, string>>(predicate: (value: Record<string, string>,  — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: Record<string, string>, index: number, obj: Record<string, s — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: Record<string, string>, start?: number, end?: number) => Record<string,  — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => Record<string, string>[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, Record<string, string>]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<Record<string, string>> — Returns an iterable of values in the array`
- `includes: (searchElement: Record<string, string>, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: Record<string, string>, inde — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => Record<string, string> — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<Record<string, string>> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### unpivotWideRows  <sub>packages/shared/src/components/organisms/olap-pivot-grid/olapUtils.ts:12</sub>

```ts
(rows: Record<string, unknown>[], keyBindings: string[], periodTest: RegExp, periodField?: string, valueField?: string): Record<string, unknown>[]
```

props/params:

- `length: number — Gets or sets the length of the array. This is a number one higher than the highest index in the array.`
- `toString: () => string — Returns a string representation of an array.`
- `toLocaleString: { (): string; (locales: string`
- `string[], options?: NumberFormatOptions & DateT — Returns a string representation of an array. The elements are converted to string using their toLocaleString methods.`
- `pop: () => Record<string, unknown> — Removes the last element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `push: (...items: Record<string, unknown>[]) => number — Appends new elements to the end of an array, and returns the new length of the array.`
- `concat: { (...items: ConcatArray<Record<string, unknown>>[]): Record<string, unknown>[]; — Combines two or more arrays. This method returns a new array without modifying any existing arrays.`
- `join: (separator?: string) => string — Adds all the elements of an array into a string, separated by the specified separator string.`
- `reverse: () => Record<string, unknown>[] — Reverses the elements in an array in place. This method mutates the array and returns a reference to the same array.`
- `shift: () => Record<string, unknown> — Removes the first element from an array and returns it. If the array is empty, undefined is returned and the array is not modified.`
- `slice: (start?: number, end?: number) => Record<string, unknown>[] — Returns a copy of a section of an array. For both start and end, a negative index can be used to indicate an offset from the end of the array. For example, -2 r`
- `sort: (compareFn?: (a: Record<string, unknown>, b: Record<string, unknown>) => number) — Sorts an array in place. This method mutates the array and returns a reference to the same array.`
- `splice: { (start: number, deleteCount?: number): Record<string, unknown>[]; (start: numb — Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.`
- `unshift: (...items: Record<string, unknown>[]) => number — Inserts new elements at the start of an array, and returns the new length of the array.`
- `indexOf: (searchElement: Record<string, unknown>, fromIndex?: number) => number — Returns the index of the first occurrence of a value in an array, or -1 if it is not present.`
- `lastIndexOf: (searchElement: Record<string, unknown>, fromIndex?: number) => number — Returns the index of the last occurrence of a specified value in an array, or -1 if it is not present.`
- `every: { <S extends Record<string, unknown>>(predicate: (value: Record<string, unknown> — Determines whether all the members of an array satisfy the specified test.`
- `some: (predicate: (value: Record<string, unknown>, index: number, array: Record<string — Determines whether the specified callback function returns true for any element of an array.`
- `forEach: (callbackfn: (value: Record<string, unknown>, index: number, array: Record<strin — Performs the specified action for each element in an array.`
- `map: <U>(callbackfn: (value: Record<string, unknown>, index: number, array: Record<st — Calls a defined callback function on each element of an array, and returns an array that contains the results.`
- `filter: { <S extends Record<string, unknown>>(predicate: (value: Record<string, unknown> — Returns the elements of an array that meet the condition specified in a callback function.`
- `reduce: { (callbackfn: (previousValue: Record<string, unknown>, currentValue: Record<str — Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as `
- `reduceRight: { (callbackfn: (previousValue: Record<string, unknown>, currentValue: Record<str — Calls the specified callback function for all the elements in an array, in descending order. The return value of the callback function is the accumulated result`
- `find: { <S extends Record<string, unknown>>(predicate: (value: Record<string, unknown> — Returns the value of the first element in the array where predicate is true, and undefined otherwise.`
- `findIndex: (predicate: (value: Record<string, unknown>, index: number, obj: Record<string,  — Returns the index of the first element in the array where predicate is true, and -1 otherwise.`
- `fill: (value: Record<string, unknown>, start?: number, end?: number) => Record<string, — Changes all array elements from `start` to `end` index to a static `value` and returns the modified array`
- `copyWithin: (target: number, start: number, end?: number) => Record<string, unknown>[] — Returns the this object after copying a section of the array identified by start and end to the same array starting at position target`
- `entries: () => ArrayIterator<[number, Record<string, unknown>]> — Returns an iterable of key, value pairs for every entry in the array`
- `keys: () => ArrayIterator<number> — Returns an iterable of keys in the array`
- `values: () => ArrayIterator<Record<string, unknown>> — Returns an iterable of values in the array`
- `includes: (searchElement: Record<string, unknown>, fromIndex?: number) => boolean — Determines whether an array includes a certain element, returning true or false as appropriate.`
- `flatMap: <U, This = undefined>(callback: (this: This, value: Record<string, unknown>, ind — Calls a defined callback function on each element of an array. Then, flattens the result into a new array. This is identical to a map followed by flat with dept`
- `flat: <A, D extends number = 1>(this: A, depth?: D) => FlatArray<A, D>[] — Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.`
- `at: (index: number) => Record<string, unknown> — Returns the item located at the specified index.`
- `__@iterator@896: () => ArrayIterator<Record<string, unknown>> — Iterator`
- `__@unscopables@898: { [x: number]: boolean; length?: boolean; toString?: boolean; toLocaleString?: b — Is an object whose properties have the value 'true' when they will be absent when used in a 'with' statement.`

### unregisterViewActions  <sub>packages/shared/src/stores/viewActionRegistry.ts:17</sub>

```ts
(tabId: string): void
```

props/params:

- `toString: () => string — Returns a string representation of a string.`
- `charAt: (pos: number) => string — Returns the character at the specified index.`
- `charCodeAt: (index: number) => number — Returns the Unicode value of the character at the specified location.`
- `concat: (...strings: string[]) => string — Returns a string that contains the concatenation of two or more strings.`
- `indexOf: (searchString: string, position?: number) => number — Returns the position of the first occurrence of a substring.`
- `lastIndexOf: (searchString: string, position?: number) => number — Returns the last occurrence of a substring in the string.`
- `localeCompare: { (that: string): number; (that: string, locales?: string`
- `string[], options?:  — Determines whether two strings are equivalent in the current locale. Determines whether two strings are equivalent in the current or specified locale.`
- `match: { (regexp: string`
- `RegExp): RegExpMatchArray; (matcher: { [Symbol.match](string — Matches a string with a regular expression, and returns an array containing the results of that search. Matches a string or an object that supports being matche`
- `replace: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replaces text in a string, using a regular expression or search string. Passes a string and {@linkcode replaceValue} to the `[Symbol.replace]` method on {@linkc`
- `search: { (regexp: string`
- `RegExp): number; (searcher: { [Symbol.search](string: string — Finds the first substring match in a regular expression search.`
- `slice: (start?: number, end?: number) => string — Returns a section of a string.`
- `split: { (separator: string`
- `RegExp, limit?: number): string[]; (splitter: { [Symbol.s — Split a string into substrings using the specified separator and return them as an array.`
- `substring: (start: number, end?: number) => string — Returns the substring at the specified location within a String object.`
- `toLowerCase: () => string — Converts all the alphabetic characters in a string to lowercase.`
- `toLocaleLowerCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Converts all alphabetic characters to lowercase, taking into account the host environment's current locale.`
- `toUpperCase: () => string — Converts all the alphabetic characters in a string to uppercase.`
- `toLocaleUpperCase: { (locales?: string`
- `string[]): string; (locales?: LocalesArgument): string; } — Returns a string where all alphabetic characters have been converted to uppercase, taking into account the host environment's current locale.`
- `trim: () => string — Removes the leading and trailing white space and line terminator characters from a string.`
- `length: number — Returns the length of a String object.`
- `substr: (from: number, length?: number) => string — Gets a substring beginning at the specified location and having the specified length.`
- `valueOf: () => string — Returns the primitive value of the specified object.`
- `codePointAt: (pos: number) => number — Returns a nonnegative integer Number less than 1114112 (0x110000) that is the code point value of the UTF-16 encoded code point starting at the string element a`
- `includes: (searchString: string, position?: number) => boolean — Returns true if searchString appears as a substring of the result of converting this object to a String, at one or more positions that are greater than or equal`
- `endsWith: (searchString: string, endPosition?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `normalize: { (form: "NFC"`
- `"NFD"`
- `"NFKC"`
- `"NFKD"): string; (form?: string): string; } — Returns the String value result of normalizing the string into the normalization form named by form as specified in Unicode Standard Annex #15, Unicode Normaliz`
- `repeat: (count: number) => string — Returns a String value that is made from count copies appended together. If count is 0, the empty string is returned.`
- `startsWith: (searchString: string, position?: number) => boolean — Returns true if the sequence of elements of searchString converted to a String is the same as the corresponding elements of this object (converted to a String) `
- `anchor: (name: string) => string — Returns an `<a>` HTML anchor element and sets the name attribute to the text value`
- `big: () => string — Returns a `<big>` HTML element`
- `blink: () => string — Returns a `<blink>` HTML element`
- `bold: () => string — Returns a `<b>` HTML element`
- `fixed: () => string — Returns a `<tt>` HTML element`
- `fontcolor: (color: string) => string — Returns a `<font>` HTML element and sets the color attribute value`
- `fontsize: { (size: number): string; (size: string): string; } — Returns a `<font>` HTML element and sets the size attribute value`
- `italics: () => string — Returns an `<i>` HTML element`
- `link: (url: string) => string — Returns an `<a>` HTML element and sets the href attribute value`
- `small: () => string — Returns a `<small>` HTML element`
- `strike: () => string — Returns a `<strike>` HTML element`
- `sub: () => string — Returns a `<sub>` HTML element`
- `sup: () => string — Returns a `<sup>` HTML element`
- `padStart: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the start (left`
- `padEnd: (maxLength: number, fillString?: string) => string — Pads the current string with a given string (possibly repeated) so that the resulting string reaches a given length. The padding is applied from the end (right)`
- `trimEnd: () => string — Removes the trailing white space and line terminator characters from a string.`
- `trimStart: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimLeft: () => string — Removes the leading white space and line terminator characters from a string.`
- `trimRight: () => string — Removes the trailing white space and line terminator characters from a string.`
- `matchAll: (regexp: RegExp) => RegExpStringIterator<RegExpExecArray> — Matches a string with a regular expression, and returns an iterable of matches containing the results of that search.`
- `replaceAll: { (searchValue: string`
- `RegExp, replaceValue: string): string; (searchValue: st — Replace all instances of a substring in a string, using a regular expression or search string.`
- `at: (index: number) => string — Returns a new String consisting of the single UTF-16 code unit located at the specified index.`
- `__@iterator@896: () => StringIterator<string> — Iterator`
