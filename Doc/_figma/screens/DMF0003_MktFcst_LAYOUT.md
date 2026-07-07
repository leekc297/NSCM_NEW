# DMF0003 (MKT FCST, 시장예측) — TO-BE 디자인 상세 (객체별 오브젝트 정보)

> 출처: 사용자 제공 **Figma** `c9VYF8oleb9TczKeFWi4ka` node **4790:160812** (Demand > Demand Plan > MKT FCST) + **사용자 제공 캡쳐**(2026-06-28).
> ⚠️ Figma REST API 현재 **429(rate limit)** → 본 문서는 **캡쳐 기준 객체 인벤토리**(타입/라벨/배치/기능). 좌표·너비 **픽셀값**은 429 해제 시 `fetch-figma.ps1 -NodeId 4790:160812 -ImageExport` 로 보정.
> 동작/검증/SP 보강 = `Doc/_analysis/domain_DM/screens/DMF0003_MktFcst/` (validation 152 / expressions 130 / source_links 23 API) + AS-IS `DMF0003_MktFcst.cs`.
> 레이아웃 표준: DMF0020(pivot+measure-group+머지+동적컬럼) 최우선 참조.

## 1. 전체 골격
| 영역 | 구성 |
|---|---|
| **MainTitle** | ☆ "MKT FCST" + breadcrumb(Demand > Demand Plan > MKT FCST) + **조회영역 toggle**(우상단) |
| **SearchArea** | 조회조건 **4열 × 3행 + 체크박스행** (#94 4열 표준) + Search 버튼 + 접기(^) |
| **SubTitle** | 공통버튼 8(우측 정렬) |
| **Content** | 단일 Grid (좌측 고정 10컬럼 + 우측 동적 기간 PIVOT) |

## 2. SearchArea — 조회조건 13 + 체크박스 4 (* = 필수)
4열 배치(좌→우, 행 단위):

| 행 | 1열 | 2열 | 3열 | 4열 |
|---|---|---|---|---|
| 1 | **Div\*** (Dropdown, 기본 "40 Mobility & IT Battery") | **Team** (Dropdown, ALL) | **End Customer** (Dropdown, ALL) | **Sales Site** (Dropdown, ALL) + `☐ AS` 체크 |
| 2 | **Biz Type\*** (Dropdown, ALL) | **Sender Code** (Dropdown, ALL) | **Period\*** (DateRange, 2026.03.01–2026.08.31) | **Bucket\*** (Dropdown, Monthly) |
| 3 | **Project** (Input + 🔍popup) | **Model/Nickname** (Input + 🔍popup) | **Plant Site** (Dropdown, ALL) | **Item Type** (Dropdown, ALL) |
| 4 | **Owner** (Input + 🔍popup) | 체크박스: `☐ Sum` `☐ Color` `☐ Qty ≥ 0` `☐ Cell Qty` | | |

- 우측 상단: **Search** 버튼 + 접기 토글(^).
- 모든 객체 높이 36px(#94). DatePicker=.datePickerFix wrapper. Dropdown=CustomDropdown(searchFields 카탈로그 우선). Project/Model/Owner = InputField + FunctionSearchIcon → popup.
- 데이터 소스(조회): Div/Team/End Customer/Sales Site/Biz Type/Plant Site/Item Type = lookup combo(SCM0001_GET_* / 콤보). Bucket = DMF0003_GET_BUCKET_TYPE_CODE. (Phase 2 SP 검증)

## 3. SubTitle 공통버튼 8 (전부 활성, #97)
| 버튼 | hotkey | hotkeyConfig | 기능 |
|---|---|---|---|
| Insert | F8 | `insert` | 행 추가 (실 CRUD) |
| Delete | F9 | `delete` | 행 삭제 (실 CRUD) |
| Save | F7 | `save` | 저장 (실 CRUD, SAVE_MKT_FCST) |
| Sort | F3 | `sort`(기본) | 컬럼 정렬 |
| Filter | F4 | `filter`(기본) | 컬럼 필터 |
| Condition | F6 | `condition`(기본) | 조회조건 저장 |
| Reset Condition | F10 | `resetCondition`(기본) | 조회조건 초기화 |
| Excel | – | `excel`(기본) | 엑셀 다운로드 |
> Sort/Filter/Condition/Reset/Excel = 미명시 시 DefaultButtonActions 자동활성. Insert/Delete/Save = 핸들러 연결 의무(기능 있는데 버튼 누락 금지).

## 4. Grid — PIVOT + 세로머지 + measure-group
### 4.1 좌측 고정 컬럼 (10)
| # | 컬럼 | 비고 |
|---:|---|---|
| 1 | **No** | 행번호(rowHeader 또는 컬럼, #97) |
| 2 | Div | 세로머지 후보 |
| 3 | **End Customer** | **세로 hierarchical 머지** |
| 4 | **Sales Site** | **세로 hierarchical 머지** |
| 5 | Model | (모델 단위 measure-group) |
| 6 | Nickname | |
| 7 | Incoterms | DAP/CIF/FOB/DDP/FCA … |
| 8 | FCST Type | Mass / Sample (dev) |
| 9 | Customs Handbook | E … |
| 10 | **Measure** | measure 라벨: `MKT FCST{R+P}` / `RTF{R+P}` (모델당 다중 measure 행) |

### 4.2 우측 동적 PIVOT (기간)
- **Bucket(Monthly/Weekly/Daily) 별 기간 컬럼 동적 생성** — 캡쳐: `2026-03` … (Period 범위 × Bucket). 각 기간 = **2단 헤더**(상: `2026-03` / 하: `SUM`). 향후 R/P 등 measure 세분 가능.
- SUM 컬럼 하이라이트(연한 teal).
- 동적 컬럼 = `DMF0003_GET_SPREAD_TITLE` 결과 기반(DMF0020 동적 frozenColumns/PIVOT 패턴). 편집 가능 셀 = measure 값(조건부 행잠금 expressions 130 적용).

### 4.3 그리드 규칙 적용
- 공용 `@shared` DataGrid(인라인 FlexGrid 금지) + `@foundation/utils`(GridUtils/GridAction/EditTracker + HierarchicalMergeManager).
- 세로 머지 = viewport sticky(#38). 다단(2단) 헤더 높이 48(#93). cell backcolor 3색(#95, 편집=yellow/잠금=gray 특수만). frozenColumns = 좌측 10(PIVOT 동적 #pivot-frozen).
- staticColumns = admin 메타 동적 fetch(#42, 하드코딩 금지). align C/L/R(#96).

## 5. POPUP (6, AS-IS) — Phase 2
MasterChg / PR / PRHistory / SspSync / SspSyncCompare / VersionCutOff + 조회조건 popup(Project/Model/Owner). 공용 modal 재사용 우선.

## 6. 측정 신뢰도
| 항목 | 신뢰도 | 근거 |
|---|---|---|
| 객체 인벤토리(조회조건/버튼/그리드 컬럼/기능) | ✅ 높음 | 사용자 캡쳐 직접 판독 |
| 픽셀 좌표/너비 | 🟠 보류 | Figma 429 — 해제 후 node 4790:160812 fetch 보정 |
| 동적 pivot/measure 세부 | 🟡 | DMF0003_GET_SPREAD_TITLE + AS-IS expressions 로 Phase 2 확정 |
