# DMF0040 (MKT FCST Comparison) — Cascade / Filter / 모달 전수 (hook #123·#124 ④ CRUD+모달 축)

> 작성: 2026-08-26. AS-IS 정본 = Forms.UIL 판 1,875행 (라인 = 정본 기준). 화면 성격 = **읽기 전용** (CRUD 저장 경로 없음 — 저장 SP 0건 실측).
> CRUD 축 판정: C/U/D = **해당없음** (Insert/Delete/Save override 빈 구현 L578/583/597·EditButton MSG00109 L588·ReadOnlySheetList L248·조회 후 전열 잠금 L760). R = FindData 단일.

## 1. 조회조건 인벤토리 (Designer 실측 — 컨트롤 22종, 표시 20)

| # | 컨트롤 | 타입 | 라벨 | 기본값 | 원천 (AS-IS → TO-BE CMBO 후보) |
|---|---|---|---|---|---|
| 1 | cboDivision | 단일 콤보 | Division* | 목록 2행 이상이면 index 1 (L361) | MyDivision (InnerTable) → 기존 'Division' 계열 CMBO |
| 2 | clbTeam | 다중 체크 | Team | ALL | UserTeamByDivision(division) |
| 3 | clbCustomer | 다중 체크 | End Customer | ALL | EndCustomerByDivision(division, team) — D-02 분기 |
| 4 | clbBizType | 다중 체크 | Biz Type | ALL | BizType(division) |
| 5 | clbSalesSite | 다중 체크 | Sales Site | ALL | UserSiteByEndCustomer(division, [team], customer) — D-06/D-08 분기 |
| 6 | clbPlantSite | 다중 체크 | Plant Site | ALL | UserPlantSiteByDivision(division) — 40 은 라벨 Disable (D-04) |
| 7 | txtProject + btnProject | 텍스트+검색버튼 | Project | '' | DMF000_ProjectbyDivisionPopupEx — 40 은 Disable (D-04) |
| 8 | txtItemId + btnItemId | 텍스트+검색버튼 | Model / Nickname | '' | DM0002_ItembyDivisionPopupEx |
| 9 | clbItemType | 다중 체크 | Item Type | ALL | SCM0001_GET_LOOKUP_VALUES('ITEM_TYPE_CODE') |
| 10 | txtOwner + btnOwner | 텍스트+검색버튼 | Owner | '' | DM0020_OwnerbyDivisionPopup |
| 11 | txtVersion + btnVersion | 텍스트(직접입력 차단)+버튼 | Version* | **최근 MF_W 2개 자동** (GetDefaultVersion L1832) | DMF0000_VersionByWaterfallPopup |
| 12 | drpPeriod | 기간(주차 표기 — UsrDateRangePickerWtWeek) | Period* | PR_GET_DAY_RANGE(p_month=6) — 당월1일~6개월 말일 | 공용 기간 콤포넌트 + 주차 표기 |
| 13 | cboBucketType | 단일 콤보 | Bucket | MONTHLY (L370) | DMF0003_GET_REPORT_BUCKET_TYPE_CODE |
| 14 | cboQTY | 단일 콤보 | QTY | index 0 (원단위) | DMF0003_GET_QTY_TYPE_CODE |
| 15 | chkSum | 체크박스 | Sum | false | — (표시 토글) |
| 16 | cboDiff | 체크박스 | Diff.Only | false | — (p_diff_only 파라미터) |
| 17 | cboCellQty | 체크박스 | Cell Qty | — | **미노출** (layoutControlItem10 Never L322) — TO-BE 제외 |
| (검색 보조) | btnColumn / btnMeasure | 버튼 | Column/Measure 설정 | — | UI Category Setup 공용 모달 (§4) |

## 2. Cascade 전수 (트리거 → 재적재 대상)

| 트리거 | 재적재/동작 | 라인 |
|---|---|---|
| **Division 변경** | ①InitSpread(동적 헤더 재질의 — division 파라미터) ②Team ③(40/81·82 분기) Customer ④SalesSite ⑤BizType ⑥PlantSite ⑦40 이면 Project·PlantSite Disable ⑧txtProject/ItemId/Version/Owner **클리어** ⑨기본 Version 재세팅(MF_W 최근 2) | 943~1042 |
| Team 변경 | Customer + SalesSite (division 계열 분기 파라미터) | 1044~1082 |
| End Customer 변경 | SalesSite | 1084~1110 |
| SalesSite/PlantSite/Project/ItemId 변경 | SetClbVersion (사문 no-op) — 실효 없음 | 1112~1129 |
| Bucket 변경 | ONLY_WEEKLY 경계에서만 헤더 재질의 + 컬럼 가시성(D_/W_/M_) 재계산 | 1141~1160 |
| Sum 체크 | 상위 집계 컬럼 가시성 토글 (DAILY: W_·M_ / WEEKLY: M_) | 1362~1415 |
| QTY 변경 | 표시 스케일 ÷1/1e3/1e6/1e8 (D_2*/W_2*/M_2* 컬럼) — 원본 dsOrigianlCopy 복원식 | 1749~1830 |
| 그리드 M_ 헤더 더블클릭 | 해당 월 W_ 토글 + 열린 D_ 접기 | 1179~1199 |
| 그리드 W_ 헤더 더블클릭 | 해당 주 D_ 토글 | 1200~1216 |

> ⭐ TO-BE 공통 룰 정합: Division 변경 = 하위 ALL reset + **Grid 데이터 초기화** (memory `feedback_division_change_grid_reset` — AS-IS 는 InitSpread 로 헤더만 재구성·데이터는 재조회 전까지 잔존하나, TO-BE 는 hook 상 Grid 초기화 의무. 재조회는 Search 버튼).

## 3. Filter/개인화 축

- 그리드 컬럼 표시 개인화 = TitleSet (Column: PROGRAM_ID **DMF0040** / Measure: PROGRAM_ID **DMF0035** — SHEET_NAME 'Mkt Fcst Waterfall' 공유, E16/E17)
- TO-BE: UI Category Setup 공용 모달 (master 정본 Column/Measure — #132 금지4호: 표시 변형 옵션 없음), 저장 후 = 설정 반영 위해 기존 조회 데이터 Reset (UC-03)
- 그리드 자체 필터: AS-IS 없음 (Spread 기본) → TO-BE 공용 DataGrid Filter(F4)/Sort(F3) 기본 활성 (§0 필수 2) + UC-07(재조회 시 필터 유지 rebindFilterColumns)·UC-01 은 Insert 없음이라 해당없음

## 4. 모달 전수 (6클래스 7개소 — 각 모달 = MAIN 동등 판정)

| 모달 | 호출 (라인) | 성격 | TO-BE 판정 |
|---|---|---|---|
| DMF0000_VersionByWaterfallPopup | btnVersion L1642 / txtVersion_KeyDown L1670 | 전용 — 버전 다중(≤2) 선택 | **신규 구현** (아래 §5) — TO-BE 공용 버전 모달 실존 여부는 demand-plan-waterfall(DMF0035 TO-BE) 확인 후 재사용/신규 확정 |
| DM0002_TitleSetForm_Popup (Column) | btnColumn L1338 | 공용 — 컬럼 개인화 | master 공용 **ColumnSelectModal 정본** 재사용 (PROGRAM_ID='DMF0040') |
| DM0002_TitleSetForm_Popup (Measure) | btnMeasure L1350 | 공용 — 메저 개인화 | master 공용 **MeasureSelectModal 정본** 재사용 — ⭐ PROGRAM_ID 축 판정 필요 ('DMF0035' 공유 vs 'DMF0040' 독립 시딩) |
| DMF000_ProjectbyDivisionPopupEx | btnProject L1280 | 공용 — Project 검색 | 공용 ProjectByDivisionModal (forecast-price 소비 계보) |
| DM0002_ItembyDivisionPopupEx | btnItemId L1305 | 공용 — Model 검색 | 공용 ItemByDivisionModal |
| DM0020_OwnerbyDivisionPopup | btnOwner L1720 | 공용 — Owner 검색 | 공용 Owner 모달 (기존 구현 실측 후 재사용/신규) |
| (사문) SCM0002_Project/ItembyDivisionPopup | 셀 더블클릭 L1228/1240 | Insert 행 전제 | 제외 — 읽기 전용 사문 |

## 5. 전용 모달 기능분석 5항 (hook #123 R1 — DMF0000_VersionByWaterfallPopup, 368행 전량)

| 항 | 내용 |
|---|---|
| ① 오픈 게이트 | 없음 (버튼/키다운 즉시 오픈). 부모가 (다중=true, code="MF", division, 기간) 전달 — division·기간 초기값 승계 |
| ② SP 바인딩 | 조회 1본 `SCM0002_GET_VERSIONBYWATERFALLPOPUP`(6p) — version_type = chkDay/Week/Month 조합("MF_D,MF_W,MF_M"), 버전명 like 필터(txtDes) |
| ③ 저장 후처리 | 저장 없음 (조회 전용). OK/더블클릭 → SetItem: 선택 VERSION_NO 콤마 연결 + sPeriod=팝업 기간 → 부모 txtVersion·drpPeriod 반영 |
| ④ MSG | MSG00255 (2개 초과 — 모달 내부 P-03 + 부모 반환부 P-02 이중) |
| ⑤ 부모 콜백 | sVersions/sPeriod public 필드 → 부모가 팝업 닫힘 후 읽음. 부모 GetDefaultVersion 도 동일 SP 로 기본값 세팅 (MF_W 최근 2, 'Current' 제외) |

## 6. 저장 경로 전수 (G9-C 선행 판정)

- 저장 SP 인벤토리 = **0건** (FoxDataRequest 13건 전부 조회 — SET/SAVE/DEL 계열 없음, TO-BE PKG_DMF0040 도 GET 1 프로시저 단일 실측)
- ⇒ CRUD 왕복 검증 축 = R(조회)만. E2E F축(SAVE 왕복) = 해당없음 (no-save 시나리오), G6-2/G6-3(저장 실증) = 해당없음 사유 기재.
- 개인화 저장(TitleSet)은 공용 모달 경로 (titleSet:SAVE) — 화면 고유 저장 아님.
