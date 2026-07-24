# DMF0049 (Etc Sales Reports) — AS-IS ↔ TO-BE 매핑 (2026-07-22 신규 생성)

> ⭐ AS-IS 정본 = **Forms.UIL `DMF0049_Sales_ETC_Reports.cs` 1,727행** (Plan.UIL 변형 1,648행 —
> diff 3덩어리: ExcelButton [E20240906]/YearSet SP화 [E20250121]. git diff 실측 — 주요이벤트 §0).
> 분석 정본(2026-07-20): `Doc/화면분석서/DMF0049_EtcSalesReports_{제약매트릭스_상세,주요이벤트_상세분석}.md`.
> **DMF0044(Sales Reports) 파생 형제** — United 버전 팝업·버전 SP 5종·Team 룩업 공유 / 고유 = ETC SP 4종.
> 사내 계약(2026-07-22 실측 적용): PROC_M 신규 4본 60행 / API 19 / BTN 19 / USER_GR 19·19·13 /
> CMBO 신규 1(DMF0049_DEPARTMENT_TEAM) / **MSG 신규 채번 0**(전부 기등록 재사용) / MNU_URL='etc-sales-reports'.

## 0. 원본 결함 교정 이력 (2026-07-22 채택)
| # | 결함 | 처리 |
|---|---|---|
| ① | InsertRow L997 — ETC_DESCR 잠금해제 가드가 CURRENCY 인덱스 검사(오기) | 컬럼 자기판정으로 자연 교정 (메타 42행에 ETC_DESCR 부재 — 실효 0) |
| ② | FindData L577 — REPORT_BP_M 기준월 '20180101' 8자리(잠금축 6자리와 불일치 → BP 회색 미적용) | `BP_BASE_YM='201801'` 단일 상수로 잠금·회색 통일 (BP 조회 시 AS-IS 에 없던 회색 표시 — 시각 차이만) |
| — | GET SP L201/204 `NVL(x,'')<>''` 상시 false(행 저장값 우선 로직 사문화) | 서버측 잠재결함 — BE 무수정, 인지만 |
| — | 분석서 이벤트 L150 SAVE 꼬리 5개 순서 | **오기 확정(기각)** — ALL_ARGUMENTS DB POSITION 이 정본 (…31 CELL_MODEL_INFO/32 CELL_MODEL/33 MEASURE/34 YYYYMMDD/35 QTY/36 CREATED_BY) |

## 1. 조회조건 (주요이벤트 L17 전수)
| AS-IS | TO-BE | 상태 |
|---|---|---|
| clbDivision (MyDivision) | DivisionField — 변경 시 Version 초기화+Grid reset | ✅ |
| clbType (MDF_TYPE) | CustomDropdown 'MDF_TYPE' | ✅ |
| clbPlanResult (정적, 기본 Plan L207) | 정적 콤보 Plan/Result (CMBO 불요) | ✅ |
| usrYear (CALENDAR_YYYY, 기본 올해 — [E20250121] SP화) | CustomDropdown 'CALENDAR_YYYY' | ✅ |
| txtSPVersion + btnSPVer | readonly + '...' → UnitedVersionModal 주입 (조회 MSG00283/저장 MSG00688) | ✅ |
| btnMeasure | TitleSet 'M' 모달 (customButtons) | ✅ |
| Company (캐시만) / clbDivision 이중구독 | 미노출 파리티 / **승계 금지** — 단일 핸들러 | ✅ |

## 2. 그리드 / 편집 매트릭스 (제약매트릭스 §2~§6 전수)
- 정적 42 = admin 'MDF Reports' 메타 100%(hook #113) / 동적 M_yyyymm + 연 span 2단 헤더 ✅
- **세트행**: 40=3(SalesAmt_LOC→KRW→RTF_SYS_RP)/81(startsWith)=2/82=1 — Insert/Delete 블록 단위(INSERT_GROUP_ID), 저장 = 세트×채택월×행 emit ✅
- **G0**: DM Planner && Div≠82 → MSG00096 (Insert/Save 진입 + 셀 전면 잠금 — L341~345) ✅
- **시점축**: baseYm = BP '201801' / SP_W 당월. Plan: 과거년도 전체 잠금[C20201223]·과거 구간 잠금·창 내 = 40 무관 개방·비40 = MEASURE===sEditMeasure(DM_LOOKUP_DIV×DM_SR_ETC_CURRENCY — 82='SalesAmt_KRW'뿐·81 빈값=전잠금). Result: 미래 잠금·과거 = 동일 개방·BP=전체 잠금(보수 확정) ✅
- ⚠ **EDIT_FLAG 동적 셀 미사용** (EditButton 루프 값 비교 없음 — DMF0044와 정반대. §2.3 비대칭 실측) ✅
- 신규행 정적 잠금 division 분기(공통 7 + 81: FCST_TYPE·CELL_MODEL_INFO / 82: ITEM_ID·CELL_MODEL_INFO / 40: SCM_SITE_ID) / 기존행 전량 잠금 ✅
- cascade 3종: C1 40 DEPARTMENT_ID→DEPT_ID(CMBO DMF0049_DEPARTMENT_TEAM — SEGMENT3 cascade)+하위 clear / C2 DEPT_ID→END_CUST_REPORT·ReportGroup3·DMF0005_REPORT_GROUP2(GRID_EDIT_COMBO) / C3 END_CUSTOMER→SiteByEndCustomer ✅
- 수량 빈값→'0'(L1416~1423) / PROJECT_CODE dblclick→ProjectByDivisionModal(**etc:'Y' — 공용 모달 1줄 확장** [PJ20200138]) / ITEM 팝업 dead(콤보로 변경) 승계 금지 ✅

## 3. 저장 (SaveData L633~915 — 단일 SP 36 IN)
- FE 35키 '^' bulk (sesUserId 36번 BE주입) — **키 바인딩 = PROC_M SORT_ORD = DB POSITION** ✅
- 채택 3분기(L739~744): Red 변경월 / 40+M+cnt≥2=전월 / 82+M=전월. I 세트=값 존재월 ✅
- resultMonth = Result 조회 시 전월 스냅샷(L602~609) / departmentEditFlag = DEPARTMENT_ID Red/신규 입력 시 'true'(L766~773) ✅
- 게이트: Version(MSG00688) → G0(MSG00096) → Department 공백(MSG00429 {0}) → 0건(MSG00676) → passthrough+MSG00002+재조회·스크롤 복원 ✅

## 4. 팝업 (활성 3 / dead 2)
| 팝업 | TO-BE | 상태 |
|---|---|---|
| DMF0044_United_VersionPopup(727 — 공유) | UnitedVersionModal 복제 (SP·PROC 재사용, API_ID 만 DMF0049_) | ✅ |
| SCM0002_ProjectbyDivisionPopupEx (ETC=true) | 공용 ProjectByDivisionModal + etc 파라미터 확장(하위호환 'N') | ✅ |
| DM0002_TitleSetForm_Popup (M 모드) | MeasureSelectModal 복제 (param DMF0049) | ✅ |
| DMF0044_Sales_VersionPopUp / DM0002_Item 팝업 | dead(주석) — **이관 제외**. sCUTOFF_YYYYMMDD 공급 경로 소실 = 항상 '' 파리티 | ✅ |

## 5. MSG 매핑 (hook #114 — 신규 채번 0, 전부 기등록 재사용)
00283(조회 전 버전)/00688(저장 전 — AS-IS 00281)/00096(권한)/00429(Department 필수 — AS-IS 00002 용법)/
00002(저장성공 — AS-IS 00004 용법)/00004(무변경)/00676·00618(0건·실패)/United 00682~687.

## 6. 검증 이력
- 2026-07-22: tsc(demand+web) 0 / eslint 0 errors / 메타 P1·P2 사내 적용·검증(MNU 'etc-sales-reports'·API 19·BTN 19·PROC 60행·권한 19/19/13·CMBO 1) / EDIT_AUTH_V DMF0049 49행 확인(INNER JOIN 0건 리스크 해소).
- 잔여: 브라우저 E2E V1~V5 (플랜 §6).
