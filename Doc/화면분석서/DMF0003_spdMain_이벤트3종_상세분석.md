# DMF0003 (MktFcst) — spdMain 그리드 이벤트 3종 상세 분석 (개발용)

> 작성: 2026-07-14 · 요청: "spdMain_ComboSelChange / spdMain_Changed / spdMain_CellClick 별도 상세 정리"
> **AS-IS 정본**: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/DMF0003_MktFcst.cs` (`__asis-mapping__.md` 정본 선언과 동일 파일)
> 분석 방식: 함수 본문 **전체 정독**(생략 0) + 피호출 메서드(②③단) 실측 + MSG 는 기존 실측본(`DMF0003_MktFcst_상세동작_개발용.md`) 대사
> 짝 문서: `DMF0003_MktFcst_UI분석서_v1.7.xlsx` / `DMF0003_MktFcst_상세동작_개발용.md` (화면 전체) — 본 문서는 **3 이벤트 심층판**

---

## §0. 위치·배선 요약

| 이벤트 | 정본 라인 | 규모 | 배선 위치 | 발생 시점 |
|---|---|---:|---|---|
| `spdMain_ComboSelChange` | L2311~2519 | 209줄 | Designer.cs L1401 `spdMain.ComboSelChange +=` | **콤보 셀에서 항목을 선택**한 직후 (FarPoint EditorNotify) |
| `spdMain_Changed` | L2883~4330 | 1,448줄 | .cs L573 (`DefineProperty()` 말미) — `DefaultSheetDataModel.Changed +=` | **셀 데이터 모델 값이 바뀔 때마다** (타이핑 확정·SetText 포함) |
| `spdMain_CellClick` | L5451~5488 | 38줄 | Designer.cs L1399 `spdMain.CellClick +=` | **셀 좌클릭** 시 |

- `spdMain_Changed` 는 UI 이벤트가 아니라 **데이터 모델 이벤트** → 코드가 `SetText` 해도 재발화한다. 이를 제어하는 2중 가드:
  - `CanModelChange` 플래그 (L2885 진입 가드; 조회 적재 중 L1201 false → L1447 true; 원복 시 임시 false)
  - 합계 기록 시 **핸들러 detach → SetText → re-attach** (L4142/4145, L4170/4172 — 주/월버킷 D_ 편집 분기만)
- 관련 보조 이벤트(참고): `spdMain_EditChange` L5407 (Measure 우측 컬럼 편집 시 `bPasteContinue=true` — MSG 표시 허용 플래그), `spdMain_ClipboardPasted` L5416 (붙여넣기 후 콤보 재구성 — §4).

**공통 어휘**: `siMain`=메인 시트 wrapper · `DefColumns.*`=프레임워크 공통 컬럼 태그 상수 · 동적 수량 컬럼 태그=`D_yyyyMMdd`/`W_n`(주)/`M_yyyyMM` · `clbDivision.ControlValues`=조회조건 Division 체크리스트 값 · Division 대분기=**81계열(`81*`)·82 vs 40** (81/82 는 Project/ScmSiteId/ItemId 컬럼, 40 은 Customer40/ScmSiteId40/ItemId40 컬럼 사용).

---

## §1. `spdMain_ComboSelChange` (L2311~2519) — 그리드 셀 콤보 선택 시 **행 단위 cascade**

**쉬운 설명**: 신규/편집 행에서 키 콤보(Division→Team→Customer→Sales Site→Measure)를 고르면, **같은 행의 하위 콤보 목록을 상위 선택값으로 다시 조회해서 갈아끼우는** 이벤트. TO-BE 의 `GRID_CASCADE_FILTERS`(beginningEdit dataMap 스왑) 에 해당하는 AS-IS 원천.

### 1.1 분기 전수 (7분기 — `e.Column` 이 어느 콤보인가로 판정)

| # | 선택한 콤보 | 라인 | 하위 재구성 (같은 행 `e.Row`) | 데이터 원천 (파라미터) | 쉬운 설명 |
|---|---|---|---|---|---|
| 1 | **Division** | 2317~2393 | ① Team 콤보 ② Customer 콤보 ③ Customer40 콤보 ④ Sales Site 콤보(81·82=`ScmSiteId`/40=`ScmSiteId40`) ⑤ 조회조건 BizType 리스트 갱신 ⑥ PlantSiteId 잠금 토글 ⑦ Measure 콤보 | ① `Data.UserTeamByDivisionAuth(그룹, 사용자, div)` ② `Data.UserEndCustomerByDivisionDeptAuth(그룹, 사용자, div, team)` ③ `Data.Common(EndCustomerByDivision40, div, team, 그룹, 사용자)` — team 공란이면 조회조건 Team 값 차용 ④ 81·82=`Data.UserSiteByEndCustomerAuth(...)` / else=`Data.UserSiteByEndCustomer(...)` ⑤ `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION(p_division_id=조회조건 Div)` ⑥ `LockRange` — **div 가 81계열일 때만 PlantSiteId 편집 해제**, 그 외 잠금 ⑦ `Data.Common(MktFcstEditMeasure, div, site, project, 사용자)` — 81·82 경로와 40 경로 각각 | Division 을 바꾸면 그 행의 담당 Team/고객/Site/측정치 후보가 전부 달라지므로 연쇄 재조회. Plant Site 는 81계열 전용 입력 |
| 2 | **Team** | 2394~2429 | ① Customer(81·82) 또는 Customer40(40) ② Sales Site(각각 짝 컬럼) | ① `UserEndCustomerByDivisionDeptAuth(그룹, 사용자, div, team)` / 40=`Common(EndCustomerByDivision40, …)`(team 공란=조회조건 차용) ② `UserSiteByEndCustomerAuth` / 40=`UserSiteByEndCustomer` | Team 변경 → 그 팀 권한의 고객·Site 로 좁힘 |
| 3 | **Customer** (81·82) | 2430~2436 | Sales Site(`ScmSiteId`) | `UserSiteByEndCustomerAuth(그룹, 사용자, div, endCustomer)` | 고객 변경 → 그 고객의 Site 만 |
| 4 | **Customer40** (40) | 2438~2445 | Sales Site(`ScmSiteId40`) | `UserSiteByEndCustomer(그룹, 사용자, div, endCustomer)` (Auth 버전 아님 — 주석으로 교체 이력) | 〃 (40 사업부 경로) |
| 5 | **ScmSiteId** (81·82) | 2447~2473 | ① 하위 표시값 **clear**: Project/ProjectName/ProjectStatus/BizType = `''` ② Measure 콤보 ③ Incoterms 콤보 | ② `Common(MktFcstEditMeasure, div, site, project, 사용자)` ③ `GetIncotermsType(div, site)` = `DM.UP_FX_GetCommonDataList_DM(CODE='AS_INCOTERMS', PARAM1=div, PARAM2=site)` | Site 를 바꾸면 프로젝트 파생값은 무효 → 비우고, 그 Site 에서 입력 가능한 Measure/Incoterms 재산출 |
| 6 | **ScmSiteId40** (40) | 2475~2486 | Measure 콤보 | `Common(MktFcstEditMeasure, div40, site40, '', 사용자)` | 〃 (40 경로 — Incoterms 재조회 없음) |
| 7 | **Measure** | 2490~2517 | 신규행(`Action='I'`)에서 Measure≠`AS_In_Req`·`BNPIn` 이면 Item 계열 clear: ItemId40/ItemId/ItemName/ItemType/NickName = `''` | (조회 없음 — 2023-12 추가) | AS/BNP 메저만 DP 입력 Item 허용(MDM.ACTIVE_FLAG 제약) → 다른 메저로 바꾸면 Item 정보 무효화 |

### 1.2 구현 특성 (TO-BE 이관 시 주의)

1. **행 좌표 혼용**: 분기 1·5·6 의 Measure/Incoterms 재구성은 `e.Row` 가 아닌 **`siMain.ActiveRowIndex`** 를 사용 (L2369/2381/2390/2463~2471/2480~2484). 통상 동일하지만 프로그램적 변경 시 다를 수 있음 — TO-BE 는 행 컨텍스트(클릭 행) 고정이 정답.
2. **콤보 데이터 권한 필터**: `User*Auth` 계열은 사용자 그룹·ID 로 필터된 권한 콤보 (hook: 그리드 콤보도 권한 필터 대상).
3. **계단식 clear 는 분기 5(Site 변경)와 7(Measure 변경)에만** 존재 — Division/Team/Customer 변경은 하위 콤보 목록만 갈고 기존 셀 값은 남긴다(값이 새 목록에 없으면 표시 불일치 가능 — AS-IS 허용 동작).
4. 분기 1 의 ⑤(BizType)는 **행이 아닌 조회조건 리스트**(`clbBizType`)를 갱신 — 행 이벤트가 조회조건을 건드리는 특이 지점.
5. PlantSite 콤보 재구성은 여기 없음(주석 처리, L2360~2363) — **CellClick(§3)과 Changed(§2.C) 로 이동** (`[C20200525-000296]` Div/Project/Item 조건 추가 때문).

---

## §2. `spdMain_Changed` (L2883~4330) — 셀 값 변경 시 검증·중복차단·**일↔주↔월 재계산**·저장버퍼 적재

**쉬운 설명**: 수량 셀을 고치면 ① 행 필수키 검증 ② 신규행 중복 차단 ③ 버킷(일/주/월)에 따라 합계 재계산 또는 일자 분배 ④ 변경분을 메모리 저장버퍼(`dtSave`)에 적재까지 한 번에 수행하는 **화면의 심장부**. `e.Type == CellsUpdated` 만 처리(단일 switch-case).

### 2.A 진입 가드·컨텍스트 수집 (L2885~2917)

- `!CanModelChange → return` (조회 적재/원복 중 재진입 차단).
- 컨텍스트: `sBucketType`(조회조건 Bucket), `sColName = GetColumnTag(e.Column)`, `AS_FROM_SITE`(있으면, `[C20220328-000205]`).

### 2.B Validation (L2919~3080) — 수량 컬럼 편집 시 필수 키 전수 검사

**대상 판정** (L2920~2924): `(Daily & D_) or (Weekly & W_) or (Monthly & M_) or (Weekly·Monthly & D_)` — 즉 **수량 컬럼을 고쳤을 때만**.

행 값 수집: 81·82 → Division/Project/ScmSiteId/ItemId, 40 → Division40/Customer40/ScmSiteId40/ItemId40 (+공통 DomExp/FcstType/Incoterms/Measure/PlantSiteId).

**검사 순서와 조건** (하나라도 걸리면 `ValidationCheck(e, 라벨)` 후 `return` — §2.H):

| 순서 | 공란 검사 대상 | 추가 조건 | Alert 라벨 |
|---|---|---|---|
| 1 | Division | — | `Division ID` |
| 2 | Project | 컬럼 존재 & div 81계열·82 | `Project Code` |
| 3 | Customer40 | 컬럼 존재 & div=40 | `End Customer` |
| 4·5 | ScmSiteId / ScmSiteId40 | 각 컬럼 존재 | `Sales Site ID` |
| 6·7 | ItemId / ItemId40 | 각 컬럼 존재 | `Item ID` |
| 8 | DomExp | 컬럼 존재 | `Customs Handbook(D: Domestic, E : Export)` (`[C20200420-000162]` 명칭 변경) |
| 9 | FcstType | 컬럼 존재 | `FCST Type` |
| 10 | Incoterms | (항상) | `Incoterms` |
| 11 | Measure | (항상) | `Measure` |
| 12 | PlantSiteId | div 81계열 | `Plant Site ID` |

**키 컬럼을 고친 경우** (L3030~3079, `sColName ∈ {Division, ScmSiteId, Division40, Project}`):
- Division+Site 둘 다 있으면 **Measure 콤보 재구성** — 40=`Common(MktFcstEditMeasure, div, site, '', 사용자)` / 그 외=project 포함.
- `[C20201103-000114]` **div82 + ScmSiteId 변경**: `Common(DM_VMI_YN, div, site)` 조회 → `VMI_VAL`(형식 `Y^DIO일수`) split 하여 **VMI_YN / VMI_STD_DIO 셀 자동 세팅** (없으면 N/'').

### 2.C div81 Plant Site cascade (L3082~3112)

행 div 가 81계열이고 편집 컬럼이 **Project 또는 ItemId** 면: `Common(SalesPlant, '', div, project, item)` 으로 **PlantSiteId 콤보 재구성** (`[C20200525-000296]`).

### 2.D 신규행 중복 차단 (L3114~3258)

`Action='I'` 행 편집 시, 그리드 **전 행을 스캔**해 다른 `'I'` 행과 키 전체 일치 개수(`iDouble`) 산출. **키가 하나라도 공란인 행은 스킵**(미완성 행 관대). `iDouble>=2` → `CanModelChange` 토글로 편집 셀 clear + **MSG00260**(중복 모델) 후 return.

| Division(조회조건) | 중복 판정 키 |
|---|---|
| 40 | EndCustomer40+ScmSiteId40+Item40+DomExp+FcstType+Incoterms+Measure (7키) |
| 81계열 | Project+SiteId+ItemId+DomExp+FcstType+Incoterms+Measure+**PlantSiteId** (8키) |
| 82 | Project+SiteId+ItemId+DomExp+FcstType+Incoterms+Measure (7키) |

### 2.E 요일 버킷 로드 (L3260~3272)

행 `BUCKET` 컬럼 = **7자리 요일 비트열**(일~토, `'1'`=배분 대상). 공란이면 `"0000010"`(**금요일만**) 디폴트 → `dBucket[0..6]`. (`getDayOfWeek(iCol)` = D_ 태그 날짜의 요일 index — L5766.)

### 2.F 수량 재계산 4분기 — "숫자 관련 Change 이벤트는 여기부터" (L3274 주석)

#### F-1. Daily 버킷에서 D_ 수정 (L3282~3421)
1. (VMI_In_Req 자동배치 로직은 `[C20201015-000200]` 원복으로 **전체 주석** — 죽은 코드 ~75줄)
2. **주합 재계산**: 편집 셀에서 왼쪽으로 첫 `W_` 를 찾고(그 다음 칸부터 시작) 다음 `W_`/`M_` 전까지 `D_` 합산 → 왼쪽 `W_` 셀에 기록.
3. **월합 재계산**: 같은 방식으로 첫 `M_` 기준 `W_` 합산 → `M_` 셀 기록.
4. `SetSaveData(..., 해당일자, 입력값)` 1건 적재.

#### F-2. Weekly 버킷에서 W_ 수정 → **일자 분배(Split)** (L3423~3769)
1. `iWeeklySum` = 입력 주값.
2. **SSP Sync 하한** (`div40 & Measure='MKT_FCST_RP'`): 해당 주 구간의 **PaleGreen(연두)** 셀 합 `iWkSum_Sync` 산출 — 주값이 그보다 작으면 **주값을 Sync 합으로 강제 교정 후 return** (교정 SetText 가 이벤트 재진입해 정상 경로 재수행 — 의도된 재귀).
3. 배분 대상 일수 `iDaycnt` = 주 구간 내 `dBucket` 해당 요일의 D_ 수 (PaleGreen 제외 카운트는 `iDaySyncCnt`). **bucket 일수 0 → `bWeekAll=true`, iDaycnt=1** (특정일 몰빵 모드).
4. 몫 `iDailyQty` = 주값/일수, 나머지 `iRemnant` 는 **마지막 배분일에 가산**. Sync 있으면 주값에서 Sync 합 차감 후 잔여만 배분(잔여 음수면 0).
5. **배분 실행** (`!bWeekAll`): 주 구간 D_ 순회 — bucket 요일 & 非PaleGreen → 몫 기록+`SetSaveData` / bucket 아닌 요일 & 非PaleGreen → `''` 기록+`SetSaveData(qty=0)`. **PaleGreen(동기화 실적) 셀은 건드리지 않음**.
6. **bucket 없음** (`bWeekAll`): 주 구간 비-PaleGreen D_ 전부 `''`+qty 0 적재 후, `sDefaultDay`(§2.H) 요일에 전량 기록 — 해당 요일이 구간에 없으면 주 마지막 D_ 에 기록.
7. 월합 재계산 (F-1 의 3과 동일).

#### F-3. Monthly 버킷에서 M_ 수정 → 일자 분배 (L3770~4115)
1. `sResultDate` = **이번주 월요일** — 그 이전 D_ 는 **실적 구간**으로 보존하고 합만 `iLastWeeklySum` 에 적산.
2. **월값-실적 ≤ 0 → MSG00225**("실적 수량보다 작은 숫자 불가") 후 return.
3. 잔여(월값-실적)를 월 구간 내 미래 bucket 요일 수로 분배 (몫/나머지 F-2 와 동일). bucket 없으면(`bMonthAll`) `sDefaultDay` 요일들에 분배.
4. 배분 후 **월 구간 전체의 W_ 를 D_ 합으로 재계산** (L4098~4114 — 주 단위 리셋 누적).
5. 각 기록 일자마다 `SetSaveData` (bucket 밖 요일은 qty 0).

#### F-4. Weekly/Monthly 버킷에서 D_ 수정 (드릴다운 일자 직접 수정, L4117~4266)
- **div=40 만** 처리 (81·82 는 이 분기 없음 — 드릴 수정 미반영 주의).
- 주합·월합 재계산 — 이때는 **핸들러 detach→SetText→attach** 로 재귀 차단 (`[C20210827-000411]`).
- `SetSaveData(해당일자, 입력값)`.

#### F-else. 신규행 키값 변경 시 수량 리셋 (L4267~4327)
수량/COLMERGE/Action 외 컬럼(=키 컬럼)을 **신규행(`I`)** 에서 바꾸면: Measure 우측의 D_/W_/M_ 값 **전부 `''`** + `SetSaveDataRemove` 로 저장버퍼에서 그 키의 적재분 **일괄 제거**. (주석: "키값이 바뀌었는데 수량이 남아있어도 의미 없음 — 수량을 다시 입력해야 SetSaveData 를 탄다.")

### 2.G 저장버퍼 helpers (②단 실측)

| 메서드 | 라인 | 동작 |
|---|---|---|
| `SetSaveData(액션, 키13종, YYYYMMDD, qty, AS_FROM_SITE)` | 4343~4470 | ① division 분기별 필수키 공란이면 **조용히 return**(MSG 주석 처리 — Validation 은 §2.B 가 담당) ② `YYYYMMDD.Length != 8` 이면 하드코딩 `MessageBox("YYYYMMDD형식이 맞지 않습니다.")` ③ `dtSave`(메모리 DataTable `"MktFcstSave"`, L727 정의)에서 **Action+전체키+일자** 로 Select → 없으면 신규행 추가 / 있으면 **Qty 만 갱신** (멱등 upsert) |
| `SetSaveDataRemove(액션, 키13종)` | 4472~4567 | 같은 필터(단 **일자 제외** — 키 전체)로 Select 후 일치 행 **전부 제거** |
| `ValidationCheck(e, col)` | 4332~4341 | `bPasteContinue` 면 **MSG00002**(`{0}` = 컬럼 라벨, "필수 입력") 표시 → `CanModelChange` 토글로 **편집 셀 `''` 원복** → `bPasteContinue=false` (붙여넣기 다건 시 alert 폭주 방지 — EditChange/Paste 에서 재활성) |

### 2.H 연계 상태값

- `sDefaultDay`: 조회 시 `Data.Common(DefaultBucketDay, div, bucketType)` 1행 (L1449) — bucket 없는 주/월 분배의 기본 요일(예: `FRI`).
- `dtSave` 라이프사이클: 조회(FindData) 시 `Clear()`(L1359) → 본 이벤트로 적재 → **Save 시** 그리드와 대조(그리드에 없는 잔재 제거, L4996~)해 `dtSaveFinal` 구성 → `'^'` 구분 bulk 문자열 14개 파라미터로 **`DM.DMF0003_SAVE_MKT_FCST`** 호출 (L1470/1583~1597, `p_active_flag='M^M^…'`) → 응답 테이블 있으면 그 MSG + `DMF0003_SspSyncPopUp`(동기화수량 미달 내역) / 없으면 MSG00004(+건수) 후 재조회.
- PaleGreen(연두 배경) = SSP 동기화 실적 셀 — F-2/F-4 의 보호 대상이자 하한(`iWkSum_Sync`) 기준.

---

## §3. `spdMain_CellClick` (L5451~5488) — 클릭 시점 lazy 콤보 구성 (2분기)

**쉬운 설명**: 콤보 목록을 미리 만들 수 없는 두 케이스를 **셀을 클릭하는 순간** 그 행 값으로 조회해 구성한다.

| # | 조건 | 동작 | 데이터 원천 | 비고 |
|---|---|---|---|---|
| 1 | 시트 잠금 아님 & (**PlantSiteId 컬럼 클릭** or 조회조건 div 81계열) | 행의 Division/Project/ItemId 로 **PlantSiteId 콤보 재구성** | `Common(PlantSiteByItem, '', div, project, item)` | `[C20200525-000296]`. **행 0열(Action) 값이 있는 행만** 수행 — "Cell Click 시 Merge 수정되는 버그 개선" 가드 (L5467) |
| 2 | 시트 잠금 아님 & 조회조건 div=**82** & **Measure 컬럼 클릭** & 행 `NewFlag='Y'` | 행 Division/ScmSiteId/Project 로 **Measure 콤보 재구성** | `Common(MktFcstEditMeasure, div, site, project, 사용자)` | `[C20200702-000136]` ESS 기준정보 자동완성 — 자동 생성된 신규행(NewFlag)에서 Measure 선택 가능하게 |

주의: 분기 1 의 판정이 `or` 라서 **div 81계열이면 어느 셀을 클릭해도** PlantSite 콤보 재조회가 돈다 (클릭마다 1콜 — AS-IS 비효율, TO-BE 는 편집 진입 시점(beginningEdit)으로 최적화가 등가).

---

## §4. 참고 — 형제 이벤트 (콤보 cascade 의 나머지 경로)

| 이벤트 | 라인 | 요지 |
|---|---|---|
| `spdMain_ClipboardPasted` | 5416~5448 | 붙여넣기 범위 순회 — `ScmSiteId40` 열이 포함되면 그 행 Measure 콤보 재구성(`MktFcstEditMeasure`), `ScmSiteId` 열이면 Incoterms 콤보 재구성(`GetIncotermsType`) (`[C20200306-000306]` 40 사업부 붙여넣기 대응). 단 Incoterms 는 **`e.Row` 가 아닌 `ActiveRowIndex`** 에 세팅 — §1.2-1 과 같은 좌표 혼용 |
| `spdMain_EditChange` | 5407~5413 | Measure 우측(수량 영역) 편집 시작 시 `bPasteContinue=true` → ValidationCheck 의 MSG00002 재활성 |
| `cboBucketType_Click` | 5395~5405 | 신규행(FlagI) 존재 시 **MSG00227**("삽입 행 존재 시 Bucket 변경 불가") 차단 |

---

## §5. 데이터 원천 인벤토리 (3 이벤트가 실제 호출하는 것 전수)

| 원천 (Data.Type / SP) | 실체 | 사용처 |
|---|---|---|
| `UserTeamByDivisionAuth` / `UserEndCustomerByDivisionDeptAuth` / `UserSiteByEndCustomerAuth` / `UserSiteByEndCustomer` | `UP_FX_GetCommonDataList` 계열 (권한 파라미터 포함) | §1 분기 1~4 |
| `Common(EndCustomerByDivision40)` | `DM.UP_FX_GetCommonDataList_DM(CODE='EndCustomerByDivision40')` | §1 분기 1·2 (40) |
| `Common(MktFcstEditMeasure)` | 〃 `CODE='MktFcstEditMeasure'` (div, site, project, userId) | §1 분기 1·5·6 / §2.B 키변경 / §3 분기 2 / §4 Paste |
| `GetIncotermsType()` | 〃 `CODE='AS_INCOTERMS'` (div, site) — L5803 | §1 분기 5 / §4 Paste |
| `GetBizTypebyDivision()` | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` — L5346 | §1 분기 1 ⑤ |
| `Common(SalesPlant)` | 〃 `CODE='SalesPlant'` (div, project, item) | §2.C |
| `Common(PlantSiteByItem)` | 〃 `CODE='PlantSiteByItem'` (div, project, item) | §3 분기 1 |
| `Common(DM_VMI_YN)` | 〃 `CODE='DM_VMI_YN'` (div, site) → `VMI_VAL='Y^일수'` | §2.B (div82 Site 변경) |
| `Common(DefaultBucketDay)` | 〃 `CODE='DefaultBucketDay'` (div, bucketType) | §2.F 기본 요일 (조회 시 선적재) |
| `DM.DMF0003_SAVE_MKT_FCST` | 저장 SP — `dtSave`→`dtSaveFinal`→`'^'` bulk 14 파라미터 | §2.H (Save 버튼 체인) |

## §6. MSG 인벤토리 (3 이벤트 + 직결 체인)

| MSG | 발생 지점 | 의미 (기존 실측본 대사) |
|---|---|---|
| **MSG00002** `{0}` | ValidationCheck (§2.B 12종 라벨) | 필수 입력 누락 — 입력 취소 원복 동반 |
| **MSG00260** | §2.D | 신규행 키 중복 (중복 모델) |
| **MSG00225** | §2.F-3 | 실적 수량보다 작은 숫자 입력 불가 |
| MSG00227 | §4 cboBucketType_Click | 신규행 있으면 Bucket 변경 불가 |
| MSG00034 / MSG00004 / MSG00366 | 저장 체인 (§2.H) | 저장할 변경 없음 / 저장 완료(건수) / AS 체크 시 Sales Site 'ALL' 불가 |
| (하드코딩 4종) | SetSaveData L4412 · PR 우클릭 메뉴 L5519/5594/5620/5638/5644/5652/5699/5706/5713 | `MessageBox.Show` 원문 — MSG_M 미등록 (TO-BE 는 표준 MSG 코드화 대상) |

## §7. TO-BE 대응 포인터 (nscm-fe `features/demand/src/pages/mkt-fcst/`)

| AS-IS | TO-BE 등가 (구현 존재 실측) |
|---|---|
| §1 ComboSelChange cascade | `MktFcstGrid.tsx` beginningEdit dataMap 스왑 + `GRID_CASCADE_FILTERS`/`GRID_CASCADE_CLEAR`/`MEASURE_MODEL_CLEAR_COLS`(constants) — hook `cascade-combo-filter §5-G` 표준 |
| §2.F 일↔주↔월 재계산 | `utils/mkt-fcst.recalc.ts` — `recalcDailyToWeekMonth`/`recalcWeeklyToDaily`/`recalcMonthlyToDaily`/`recalcDailyEditUnderWeekMonth`/`dispatchRecalc` (F-1~F-4 1:1) |
| §2.B Validation / §2.D 중복 | `utils/mkt-fcst.validate.ts` |
| §2.G dtSave 버퍼·저장 | `utils/mkt-fcst.save.ts` (+ `'^'` bulk SAVE) |
| PaleGreen Sync 보호 | `utils/mkt-fcst.sspSync.ts` + editLock |
| §3 lazy 콤보 | beginningEdit 시점 스왑으로 흡수 (클릭당 재조회 없음) |

> 세부 정합(파라미터·분기 단위 1:1 카운트)은 `__asis-mapping__.md` 가 정본 — 본 표는 위치 포인터.

## §7.5 (한계 해소) 그룹별 FCST_TYPE — AS-IS DB 실측 (2026-07-14, LGCE_SCMDEV)

`dbo.UP_FX_GETCOMMONDATALIST_DM` `@CODE='FCST_TYPE'` 분기(SP L68~105) 원문 확보 — **그룹 분기는 `@PARAM1 = N'DM Planner (W/S)'` 정확일치 단 1개** (+ 특수 `'EDIT_MODE'`). ADMIN/DM ADMIN/DM Planner/DM Viewer 등 나머지 전 그룹은 동일 결과.

| 분기 | 대상 | 원천 | 결과셋 (실측) |
|---|---|---|---|
| `IF 'DM Planner (W/S)'` | W/S 플래너만 | `SALES_TYPE_CODE2` | **4종**: WS·WSF·AS·ASF (SEQ 1~4) |
| `ELSE` (일반) | 그 외 전 그룹 | `SALES_TYPE_CODE` + **`ISNULL(ATTRIBUTE2,'')<>'Y'`** | **12종**: AS·ASF·ETC·MPS·Recall·RMA·SDC·SDF·SMC·SMF·SPF·TST — **WS·WSF 는 ATTRIBUTE2='Y' 로 제외** (일반 그룹은 W/S 유형 선택 불가) |
| `ELSE IF 'EDIT_MODE'` (특수) | FE 콤보 아님 — `[E20260211-001189]` AS FROM SITE 수정범위 판정 | `SALES_TYPE_CODE2 ∪ SALES_TYPE_CODE2_ADD` | 6종 (WS·WSF·AS·ASF + Recall·RMA) |

→ 데이터 연계 Excel **시트6 (FCST_TYPE_실측)** 에 행 단위 수록 (`DMF0003_spdMain_이벤트3종_분석_v1.1.xlsx`).

**Measure 축 제약 실측 (2026-07-14 추가 — Excel 시트7)** — 3계층:
1. **저장 시간창 (권한×사업부)**: `GET_ADMIN_GROUP_MEASURE`(DMF0003) 30행 + SAVE SP L597~686 `[E20260604-000994]`(2026-06 신설) — **SCP Planner 는 81=일요일/81_계열=목요일 00:00~23:00 에만 저장 가능**, 같은 창이 열려 있는 동안 **DM ADMIN/DM Planner/DM Planner (W/S)는 저장 차단**(LIMIT_AUTH 상호배타), ADMIN=상시, 40·82=행 없음(게이트 미적용). lookup 의 MEASURE='MKT_FCST' 기재이나 게이트 쿼리는 measure 필터 없이 division 단위 적용.
2. **콤보 노출 (division×site×사용자)**: `MktFcstEditMeasure`(UP_FX_GetCommonDataList L2909~3001) 3-UNION — 일반(`MKT_FCST_MEASURE` INSERT_YN=Y, VMI 메저는 site VMI_YN=Y 만) + CUST_FCST 하위(`' └ '` 동적 — 계층 indent 원천) + TMM(`TMM_MEASURE_ADMIN` div+project+**사용자ID** 등재 시만). **권한그룹 파라미터 없음** — 그룹 축 제약은 저장 시간창·EDIT_FLAG 가 담당.
3. **가격 필수검증 (FCST_TYPE×Measure)**: `MKT_FCST_VALIDATION_PRICE` — 대상 measure 4종(MKT_FCST/RTF/SCM_FCST/VMI_In_Req) 저장 시 FCST 주차 판가 필수, **Free 계열 FCST_TYPE 6종(ASF/SDF/SMF/SPF/TST/WSF)은 면제** (+82 제외모델 84행). 부수 실측: `AS_INCOTERMS` 분기(SP L107~137) = `AS_SITE_PLANT`(division+site 등재) 여부로 AS 전용 `AS_INCOTERMS` / 일반 `INCOTERMS` 를 택일 — §4·AW-8 서술과 일치 확인.

## §8. 추출 한계 (anti-simplification §2.1 [필수 4])

1. 함수 3종 + 직접 피호출 메서드(②단)는 전량 정독했으나, `Data.Common`/`User*Auth` 의 **SP 내부 SQL** 은 본 문서 범위 밖 (UI분석서 v1.7 시트 8 참조). *(단 FCST_TYPE·AS_INCOTERMS 분기는 §7.5 에서 AS-IS DB 실측 완료 — 2026-07-14)*
2. MSG 실문구는 기존 실측본(`상세동작_개발용.md`) 대사 기준 — MSG_M 재실측은 하지 않음.
3. `DefColumns.*` 는 프레임워크 공통 상수 — 실제 컬럼 태그 문자열 값은 프레임워크 정의 파일 기준 (본 문서는 논리명으로 표기).
4. 주석 처리된 죽은 코드(VMI_In_Req 자동배치 2곳 ~150줄, Bucket-없음 구식 split 2곳)는 "존재+원복 이력"만 기록하고 동작 분석 제외.
