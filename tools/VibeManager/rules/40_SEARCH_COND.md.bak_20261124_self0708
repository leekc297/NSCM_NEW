# 조회조건 기준 — SCP·SSP (FE 생성 시 조회조건 순서·사용여부·명칭)

> 생성: 2026-10-23 · `python tools/Harness/refs/build_search_cond.py` 로 재생성(손편집 금지 — 원천 xlsx 를 고친 뒤 재실행).
> 원천: SCP = `SCP_화면별 조회조건 정리_260731_v0.5.xlsx` (RULE 시트 + List Lv0=SCP) · SSP = `SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx` (List Lv0=SSP 만 추출).
> 관계: 기존 카탈로그 `Doc/_rules_v2/_mapping/search_conditions_scp_dm.md`(v0.4 · SCP·DM · hook #112) 대비 **SCP·SSP 의 순서·사용여부·명칭은 본 문서가 우선**(룰 10_RULES_KEEP E11). DM 은 기존 카탈로그.
> 기계판독본: `tools/Harness/rules/search_cond.csv` — 하네스 gen.js 가 조회조건 **순서·사용여부·To-Be 명칭**에 적용하고, check.js SC1(순서)·SC2(제외 조건 잔존)가 검사한다.

## 1. 하네스 적용 규칙 (요약)

| 항목 | 규칙 |
|---|---|
| 대상 | 아래 §4 표에 MENU_ID 가 매핑된 SCP·SSP 화면. 표에 없는 화면/조건은 §2.1 정렬원칙 그룹 순서를 적용 |
| 순서 | 화면별 **하네스 적용 순서(tobe_order)**. **SCP = §2.1 정렬원칙 RULE**(그룹 1→5 · Div. 맨 앞 · 같은 그룹 안은 시트 행 순서 · From→To Site / Plant Site→Building→Line 고정 · 미분류는 앞 조건 그룹에 붙음). **SSP = 시트 행 순서(1차 완료 확정본)**. 같은 To-Be 명칭 여러 행(통합)은 첫 행 위치. 시트 원래 순서는 tobe_seq 로 보존 |
| 사용 | `USE` 만 조회조건으로 생성. `MERGED` 는 대상 조건 하나로 합침(예: Model + NickName → Model/Nickname) |
| 제외 | `DROP`·`SUNSET`·`NOT_MIGRATED` = 생성하지 않음(__asis-mapping__ 에 사유와 함께 기록 — AS-IS 근거는 남긴다) |
| 이동 | `BUTTON_AREA` = 조회조건 영역에서 빼고 버튼 영역(공통/화면 버튼)으로 · `IN_CALENDAR` = 기간 달력 기능에 포함 · `COLUMN_PERSONAL` = 컬럼 개인화 공통 기능 · `COMMON_BUTTON` = 하단 공통 버튼 |
| 보류 | `COMMON_REVIEW`·`REVIEW`·`SUNSET_REVIEW` = 확정 전 — AS-IS 그대로 생성하고 GEN_NOTES 에 “기준표 검토중” TODO |
| 명칭 | 라벨은 To-Be 명칭(§2.2 통일 규칙 반영본). LBL 코드는 기존 재사용·없으면 신규 채번(E5/i18n 규칙) |
| 유형 | To-Be 유형1(선택/텍스트/버튼/체크박스/라디오버튼)·유형2(단일/다중) · 기능(검색/팝업/달력) · 팝업구분 코드(§2.3) · 비고 `ALL버튼`(다중+ALL) / `ALL없음` |
| 필수 | To-Be 필수값 표기 우선, 없으면 As-Is 필수값(O) |
| Div 초기화 | `N` = Div. 변경 시 값 유지(초기화 안 함). 공란 = 기본 동작 |
| **판정(TO-BE 룰 · CR-071, 2026-10-26 사용자 지시)** | **SCP·SSP 조회조건 = 이 기준표에 USE 로 정의된 조건만, 기준표 순서대로, 기준표 라벨(To-Be 명칭)로 사용한다.** 기준표 라벨이 AS-IS 명칭과 달라도(Division→Div. · Input Status→Status · Valid→Active) **결함이 아니라 PASS**. 기준표가 제외·이동한 AS-IS 조건이 조회영역에 없는 것도 결함 아님(NA). 결함 = 기준표 조건 누락 · 기준표에 없는 조건 노출 · 라벨 다름 · EDIT 형태 다름. **⭐ CR-098(2026-11-09 사용자 지시): 조회조건 순서는 판정 대상 제외 — Excel 대조는 사용여부·EDIT 형태까지만(순서 차이 = NA, 아래 '하네스 적용 순서'는 생성 배치 기본값일 뿐 판정 기준 아님).** 하네스: judge STATIC H5(라벨)/G4(순서) ↔ `search_cond.csv` · check.js SC1(순서)/SC2(제외 잔존) · mapping_trace `sc_excl`(기준표 제외 AS-IS 조건 = NA) · `confirmed_requirements.csv CR-071` |
| **명칭 변경 룰(TO-BE 룰 · CR-092, 2026-10-30 사용자 지시)** | **SCP·SSP 의 'Valid' 는 조회조건·그리드·팝업 그리드 모두 'Active' 로 일괄 변경.** 기준표의 Valid→Active(16행)와 같은 결정을 그리드 컬럼 라벨까지 넓힌 것 — AS-IS Valid ↔ TO-BE Active = PASS · TO-BE 에 Valid 잔존 = CR-092 FAIL(보완 대상: 메타 `SHEET_COLUMNS.COLUMN_LABEL_NAME` UPDATE · Form 라벨). 정본 `tools/Harness/rules/label_alias.csv`(scope·asis_label·tobe_label — 복합 명칭 'Valid From/To' 등은 행 추가 전 대상 아님). 하네스: judge H5_CR092/CR092_LEFT · `_trace.spec` H5 · check.js LB1/LB2 · KEEP H21 |

## 2. 조회조건 RULE (SCP 파일 원문)

### 2.1 조회조건 정렬원칙 (시트 `조회조건 정렬원칙`)

| 그룹 | 검색조건 성격 | 예시 |
|---|---|---|
| 1. 데이터 기준 | 어떤 계획 데이터·버전을 조회할지 결정 | Div., Plan Date, Plan Type, Ver., Seq. |
| 2. 조직·거점·공정 | 조회 대상 범위를 단계적으로 축소 | Plan Group, Operation Group, SCM Site, From/To Site, Plant Site, Building, Line |
| 3. 제품·대상 | 실제 조회하려는 제품 또는 자재 | PJT, Model/Nickname, Material, Electrode, Cell Type |
| 4. 기간·집계 | 조회 범위와 시간 단위 지정 | Period, Month, From/To Date, Bucket |
| 5. 상태·표시 | 결과를 추가로 필터링하거나 표현 | Active, Status, Unit, Search Level, 조회구분 |

**규칙**
- Div.는 원칙적으로 첫 번째
- 상위 조직·사이트는 모델·자재보다 앞
- 모델·자재는 일반적으로 조회기간보다 앞
- Plan Date와 Period는 서로 다른 성격으로 분리
- Active, Status, 표시 옵션은 마지막
- From Site → To Site, Plant Site → Building → Line 같은 종속관계는 고정

> 하네스 그룹 사전(표에 없는 조건 배치용): 1.데이터 기준=[Div, Div., Plan Date, Plan Type, Plan Version, Ver., Version, Seq., Seq, Company, Data Type, Version Type, Plan Data] · 2.조직·거점·공정=[Plan Group, Operation Group, Operation group, Operation, SCM Site, Site, From Site, To Site, Plant Site, Plant, Plant/Vendor, Building, Line, Sales Site, Team, Warehouse, Biz. Type, Line Type] · 3.제품·대상=[PJT, Model/Nickname, Model, Nick Name, Material, Electrode, Cell Type, Cell Type Gr, Item Type, Material Type, Item, Parent Item, Child Item, Class1, Class2, Class ID, Class Name, Category, Model Attribute, Sold To Party, Ship to Party, Customer, Box ID, Lot ID, SO No, Confirm Id, 관리번호] · 4.기간·집계=[Period, Month, From/To Date, Bucket, Inventory Date, Cutoff Date, Shipment Date, Request Date, DOW, Day of the week, Sum, Year, Week] · 5.상태·표시=[Active, Status, Unit, UOM, Search Level, 조회구분, Type, Total PSI, Including Past Period, OSP, BOD Item Active, Detail, Inventory Type, Change Type]

### 2.2 명칭 통일 (시트 `Group, Type`)

| 사용 | As-Is 명칭 | 개수 | 예시 | To-Be 규칙 |
|---|---|---|---|---|
| O | Biz Type | 9 | Cell/Module/Pack(더 세분화 된것도 있음) | Biz에 마침표(.) 포함 통일 |
| O | Biz. Type | 3 |  | 유지 |
| O | Bucket Type | 2 |  | Bucket으로 통일 |
| O | Cell Type | 1 |  | 유지 |
| O | Cell Type Gr | 3 |  | 유지 |
| O | Data Type | 2 |  |  |
| O | Day Type | 1 |  | DOW로 변경 (Day of the week) |
| 유지 | Item Type | 12 | Semi Product/Product/Purchase/Material |  |
|  | Line Type | 1 |  |  |
|  | Long Term Type | 1 |  |  |
|  | Lookup Type | 1 |  |  |
|  | Material Type | 1 |  |  |
| O | Plan type | 1 |  | 유지 |
| O | Plan type* | 9 |  | 유지 |
|  | Report type | 2 |  |  |
|  | Report type* | 1 |  |  |
|  | Result Type | 1 |  | Type으로 변경 |
| O | Type | 2 |  | 유지 |

| 사용 | As-Is 명칭(Group 계열) | 개수 | 예시 | To-Be 규칙 |
|---|---|---|---|---|
|  | Cell Group | 1 |  |  |
|  | Group | 2 |  |  |
|  | Group Code | 1 |  |  |
|  | Group Name | 1 |  |  |
|  | Model Group | 1 |  |  |
| O | Operation group | 6 | Cell/Pack |  |
| O | Operation group* | 13 | Cell/Pack |  |
| O | Plan Group | 14 |  | 유지 |
|  | Product Group_하단 | 1 |  |  |

> 시트 `Sheet2` 는 As-Is(133)·To-Be(96) 명칭을 **각각 중복 제거한 독립 목록**(행끼리 짝이 아님 — 예: As-Is `Model` 옆이 To-Be `Period`). 대응 관계는 §4 화면별 표(행 단위)가 정본.

### 2.3 팝업 통일 (시트 `팝업 비교`)

- 용어는 Model/Nickname으로 통일하고, 팝업양식은 메1(SCP)/모3(DM)로 함
- <용어>
  - Model -> Model/Nickname으로 통일
  - Meterial은 유지
  - Project는 용어 유지
  - Item : Model은 메터리얼로, 베이직닉네임은 유지
- <팝업>
  - Model/Meterial팝업양식은 메1(SCP)/모3(DM)로 통일함
  - Project : 프2로 통일
  - Item : 팝업 유지
  - 버전 : 유지

| 팝업구분 코드 | 의미(시트 배치 기준) |
|---|---|
| 모1·모2·모3 | Model by DivisionPopup 양식 변형 (모3 = DM 통일 양식) |
| 메1 | Material by Division Popup — **SCP Model/Material 통일 양식** |
| 프1·프2 | Project by Division (프2 로 통일) |
| 오1 | Owner by DivisionPopup |
| 아1·아2 | Item by DivisionPopup (유지) |
| 버1·버2 | Version Popup (유지) |
| 버세1 | VersionBySalesPrice Popup |
| 세1 | Sales Report Popup |

### 2.4 To-Do (SCP 파일 원문 — 확정 전 검토 과제)

- 1. 화면에 따라 검색조건을 3줄까지 표시하고 4줄부터 접도록 하는 방식 검토
  - SCP 계획화면의 경우 2줄까지만 표시하면 주요 검색조건이 숨겨져서 비효율 발생
- 2. from/to 기간을 선택하는 달력은 주차가 표시되는 from/to 일자 선택하는 달력으로 통일 <As-is from/to 선택 달력>
  (단일 일자를 선택하는 경우는 DM 달력 그대로 사용)
  - W26/W52 선택 버튼은 달력에 해당 기능 넣는 방법으로 검토
- 3. Plan Data/Plan Type/Seq. 를 동시에 선택하는 화면은 해당 콤보를 1개로 합침
  - 통합 라벨명 : Plan Version
  - 참고사항
    - 1) Plan Data/Plan Type/Seq.가 세트로 있는 화면 5개
    - 2) Plan Date와 Plan Type만 있는화면 : 2개
    - 3) Plan Date만 있는 화면 4개

## 3. 판정·매핑 근거와 이상 행 (누락 0 확인용)

| 구분 | USE | MERGED | BUTTON | BUTTON_AREA | IN_CALENDAR | COLUMN_PERSONAL | COMMON_BUTTON | DROP | SUNSET | SUNSET_REVIEW | NOT_MIGRATED | COMMON_REVIEW | REVIEW | 계 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| SCP | 431 | 11 | 1 | 30 | 8 | 1 | 0 | 20 | 62 | 38 | 9 | 1 | 4 | 616 |
| SSP | 237 | 9 | 30 | 3 | 0 | 0 | 6 | 0 | 0 | 0 | 0 | 14 | 6 | 305 |

사용여부 판정식(변경내용 원문 → usage): `Sun-Set 검토`→SUNSET_REVIEW · `Sun-Set`→SUNSET · `미전환`→NOT_MIGRATED · `조회조건 삭제`→MERGED(추가검토에 ‘통합’)/DROP · `제거`·`삭제`→DROP · `버튼영역 이동`→BUTTON_AREA · `달력기능에 포함`→IN_CALENDAR · `컬럼 개인화`→COLUMN_PERSONAL · `하단에 공통`→COMMON_BUTTON · `공통기능화 검토`→COMMON_REVIEW · `용도 재확인`→REVIEW · To-Be 명칭 공란→REVIEW · To-Be 유형1=버튼→BUTTON · 그 외 USE.

**MENU_ID 미매핑 0 화면** (하네스 자동 적용 제외 — menu.csv 에 메뉴가 생기거나 이름이 맞으면 재생성 시 자동 연결):


**양쪽 파일 중복 화면 1건**:

- SSP0045 — SCP·SSP 양쪽 기재 → SSP 파일 행을 정본(primary=Y)으로 사용

**원문 이상 행 11건** (값 보존 · 위치만 보정 또는 제외):

- SCP SCP_화면별 조회조건 정리_260731_v0.5.xlsx 274행 [Shipment Plan SEMI] As-Is·To-Be 명칭 모두 공란 — 제외
- SCP SCP_화면별 조회조건 정리_260731_v0.5.xlsx 275행 [Shipment Plan SEMI] As-Is·To-Be 명칭 모두 공란 — 제외
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1109행 [Shipment Plan(Electrode)] 'Including Past Period' — To-Be 블록이 1칸 오른쪽에 기재 → 왼쪽으로 보정
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1144행 [Shipment Request(Electrode)] 'Including Past Period' — To-Be 블록이 1칸 오른쪽에 기재 → 왼쪽으로 보정
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1273행 [Shipment Plan Adjustment] As-Is·To-Be 명칭 모두 공란 — 제외 (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1274행 [Plan Problem (SSP)] As-Is·To-Be 명칭 모두 공란 — 제외 (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1275행 [Production Plan Line(SSP)] As-Is·To-Be 명칭 모두 공란 — 제외 (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1276행 [Shipment Plan FG(SSP)] As-Is·To-Be 명칭 모두 공란 — 제외 (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1277행 [Shipment Plan SEMI (SSP)] As-Is·To-Be 명칭 모두 공란 — 제외 (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1278행 [PSI (SSP)] As-Is·To-Be 명칭 모두 공란 — 제외 (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)
- SSP SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1279행 [Purchasing PSI(ESS)] As-Is·To-Be 명칭 모두 공란 — 제외 (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)

## 4. 화면별 조회조건 (To-Be 순번 순 · 원문 행 순서)

열: **#**=하네스 적용 순서(tobe_order) · **시트#**=시트 행 순서(tobe_seq) · **사용**=usage · **범위**=Lv4(시트/탭 한정, `-`=화면 전체) · As-Is(명칭/유형/기능/팝업/필수/비고) → To-Be(명칭/유형/기능/팝업구분/필수·ALL/비고) · 변경내용 · 추가검토 · Div초기화

### 4.1 SCP (74 화면)

#### SCP0039 · Master Validation  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Master Validation = SCP0039(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 4~6행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.Model/Nickname — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.Model/Nickname · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/다중 | 검색 |  |  | Plan Group | 선택/단일 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Model / Nickname | 텍스트/다중 | 팝업 Model by DivisionPopup 모3 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |

#### SCP0001 · Plant Site  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Plant Site = SCP0001(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 7~11행

**하네스 적용 순서**: 1.Div → 2.Plant/Vendor → 3.Plant Site → 4.OSP → 5.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant/Vendor → 3.Plant Site → 4.OSP → 5.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/다중 | 검색 |  | ALL(우) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 2 | USE | - | Plant/Vendor | 텍스트/단일 |  |  |  | Plant/Vendor | 선택/다중 | 검색 | ALL버튼 |  | 유형 |  |  |
| 3 | 3 | USE | - | Plant Site | 텍스트/단일 |  |  |  | Plant Site | 선택/다중 | 검색 | ALL버튼 |  | 유형 |  |  |
| 4 | 4 | USE | - | Outsourcing | 선택/단일 |  |  | ALL/Y/N | OSP | 선택/단일 |  |  |  | 명칭 |  | N |
| 5 | 5 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0002 · Line Master  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Line Master = SCP0002(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 12~17행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Building → 4.Operation → 5.Line → 6.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Building → 4.Operation → 5.Line → 6.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Plant, Packer | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Plant, Packer | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | Plant | Building | 선택/다중 | 검색 |  | ALL(우) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Plant | Operation | 선택/다중 | 검색 |  | ALL(우) | Operation | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | Plant, Packer | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | Plant, Packer | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0006 · Project Route  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Project Route = SCP0006(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 18~24행

**하네스 적용 순서**: 1.Div → 2.Sales Site → 3.PJT → 4.Model/Nickname → 5.Period → 6.Status — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Sales Site → 3.PJT → 4.Model/Nickname → 5.Period → 6.Status · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Sales Site | 선택/다중 |  |  | 비활성화_ALL | Sales Site | 선택/다중 | 검색 | ALL버튼 |  |  | 활성화 조건 확인, 조건확인후 필요 없으면 제거 |  |
| 3 | 3 | USE | - | Project | 텍스트/다중 | 팝업 Project by Division 프1 |  |  | PJT | 텍스트/다중 | 팝업 프2 |  |  | 명칭/팝업 |  |  |
| 4 | 4 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 5 | 5 | USE | - | Period | 선택/단일 | 달력 |  | YYYY-MM | Period | 텍스트/단일 | 달력 |  | YYYY-MM |  |  | N |
| 6 | 6 | USE | - | Status | 선택/단일 |  |  | ALL/Y/N | Status | 선택/단일 |  |  |  |  | Y/N 선택에 따라 조회 내용 차이 확인 필요 | N |
|  |  | BUTTON_AREA | - | Input All | 버튼/기타 | 팝업 Project Route List For Save |  |  | Input All | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |

#### SCP0008 · Item Master  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Item Master = SCP0008(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 25~32행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Div | 선택/단일 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Site | 텍스트/단일 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | SCM Site | 텍스트/단일 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Class | 텍스트/단일 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Class1 | 선택/다중 | 검색 |  | ALL(우) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Class2 | 선택/다중 | 검색 |  | ALL(우) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Material Type | 선택/다중 | 검색 |  | ALL(우) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Material ID/Name | 텍스트/다중 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0080 · Model Code Master  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Model Code Master = SCP0080(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 33~40행

**하네스 적용 순서**: 1.Div → 2.Operation → 3.Model/Nickname → 4.Model Attribute — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation → 3.Model/Nickname → 4.Model Attribute · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation | 선택/다중 | 검색 |  | ALL(좌) | Operation | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Model | 텍스트/다중 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 | Model/Nick Name 통합 |  |
| 3 | 3 | MERGED | - | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 4 | 4 | USE | - | FCST | 체크박스/기타 |  |  |  | Model Attribute | 선택/다중 |  | ALL버튼 |  | 명칭/유형 | FCST/Production/BOM/Active 체크박스를 선택으로 통합 | N |
| 4 | 4 | USE | - | Production | 체크박스/기타 |  |  |  | Model Attribute | 선택/다중 |  | ALL버튼 |  | 명칭/유형 | FCST/Production/BOM/Active 체크박스를 선택으로 통합 | N |
| 4 | 4 | USE | - | BOM | 체크박스/기타 |  |  |  | Model Attribute | 선택/다중 |  | ALL버튼 |  | 명칭/유형 | FCST/Production/BOM/Active 체크박스를 선택으로 통합 | N |
| 4 | 4 | USE | - | Active | 체크박스/기타 |  |  |  | Model Attribute | 선택/다중 |  | ALL버튼 |  | 명칭/유형 | FCST/Production/BOM/Active 체크박스를 선택으로 통합 | N |

#### SCP0026 · Demand Grouping  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Demand Grouping = SCP0026(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 41~43행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Div | 선택/단일 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Operation group | 선택/단일 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0007 · BOD  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›BOD = SCP0007(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 44~51행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.To Site → 4.Incoterms → 5.SSP Incoterms → 6.Trans Mode → 7.Status → 8.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.From Site → 3.To Site → 4.Incoterms → 5.SSP Incoterms → 6.Trans Mode → 7.Status → 8.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/다중 | 검색 |  | ALL(좌) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 2 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(좌) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Incoterms | 선택/다중 | 검색 |  | ALL(좌) | Incoterms | 선택/다중 | 검색 | ALL버튼 |  |  |  | N |
| 5 | 5 | USE | - | SSP Incoterms | 선택/다중 | 검색 |  | ALL(좌) | SSP Incoterms | 선택/다중 | 검색 | ALL버튼 |  | 순서 변경 |  | N |
| 6 | 6 | USE | - | Trans Mode | 선택/다중 | 검색 |  | ALL(좌) | Trans Mode | 선택/다중 | 검색 | ALL버튼 |  |  |  | N |
| 7 | 7 | USE | - | Input Status | 선택/단일 |  |  | Require/Completed | Status | 선택/단일 |  |  |  | 명칭 |  | N |
| 8 | 8 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0030 · BOD ITEM  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›BOD ITEM = SCP0030(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 52~60행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.To Site → 4.Incoterms → 5.Plan Group → 6.Trans Mode → 7.Model/Nickname → 8.BOD Item Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.From Site → 3.To Site → 4.Incoterms → 5.Plan Group → 6.Trans Mode → 7.Model/Nickname → 8.BOD Item Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/다중 | 검색 |  | ALL(우) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 2 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(우) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(우) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Incoterms | 선택/다중 | 검색 |  | ALL(우) | Incoterms | 선택/다중 | 검색 | ALL버튼 |  |  |  | N |
| 5 | 5 | USE | Excluded Item | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  | 표시 조건 | Excluded Item Sheet만 표시되도록변경 |  |
| 6 | 6 | USE | - | Trans Mode | 선택/다중 | 검색 |  | ALL(우) | Trans Mode | 선택/다중 | 검색 | ALL버튼 |  |  |  | N |
| 7 | 7 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 | Model/Nick Name 통합 |  |
| 7 | 7 | MERGED | - | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 8 | 8 | USE | - | BOD Item Valid | 선택/단일 |  |  | ALL/Y/N | BOD Item Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0019 · Work Calendar(OSP)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Work Calendar(OSP) = SCP0019(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 61~68행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Operation → 4.Line → 5.Period — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Operation → 4.Line → 5.Period · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Operation | 선택/다중 | 검색 |  | ALL(우) | Operation | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
|  |  | BUTTON_AREA | - | Day of the week | 선택/단일 |  |  | 일괄 입력기능_EveryDay/각요일 | Day of the week | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input Value | 텍스트/단일 |  |  | 일괄 입력기능 | Input Value | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input | 버튼/기타 |  |  |  | Input | 버튼/기타 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |

#### SCP0096 · Shipment Working Day(OSP)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Shipment Working Day(OSP) = SCP0096(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 69~74행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Period — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Period · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
|  |  | BUTTON_AREA | - | Day of the week | 선택/단일 |  |  | 일괄 입력기능_EveryDay/각요일 | Day of the week | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input Value | 선택/단일 |  |  | Y/N_일괄 입력기능 | Input Value | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input | 버튼/기타 |  |  |  | Input | 버튼/기타 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |

#### SCP0022 · Formation  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Formation = SCP0022(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 75~77행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Material — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Material · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 |  |  | ALL(X) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |

#### SCP0020 · Tact Time(OSP)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Tact Time(OSP) = SCP0020(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 78~82행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Operation group → 4.Line → 5.Model/Nickname — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Operation group → 4.Line → 5.Model/Nickname · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 4 | 4 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |

#### SCP0040 · Characteristic Capacity  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Characteristic Capacity = SCP0040(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 83~85행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Div | 선택/단일 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Plant Site | 선택/다중 |  |  | ALL(X) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0023 · Outsourcing Capacity  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Outsourcing Capacity = SCP0023(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 86~89행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Model/Nickname — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Model/Nickname · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 |  |  | ALL(X) | Plant Site | 선택/다중 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | MERGED | - | Nick Name | 텍스트/단일 |  |  |  | Nick Name | 텍스트/단일 |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |

#### SCP0027 · ProjectRoute (Electrode)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›ProjectRoute (Electrode) = SCP0027(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 90~94행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Operation group → 4.Model/Nickname → 5.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Operation group → 4.Model/Nickname → 5.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/다중 | 검색 |  | ALL(우) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Operation group | 선택/단일 |  |  |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 4 | 4 | USE | - | Model | 텍스트/단일 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 5 | 5 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0048 · ProjectRoute (Warranty)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›ProjectRoute (Warranty) = SCP0048(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 95~98행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Model/Nickname → 4.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Model/Nickname → 4.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/다중 | 검색 |  | ALL(우) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Model | 텍스트/단일 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 4 | 4 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0041 · Stock OSP  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Stock OSP = SCP0041(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 99~107행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Model/Nickname → 4.관리번호 → 5.Inventory Date → 6.Cutoff Date → 7.Status — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Model/Nickname → 4.Inventory Date → 5.Cutoff Date → 6.관리번호 → 7.Status · 원칙 대비: 차이 — 관리번호(그룹3) 가 Cutoff Date(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | OSP Stock, Pack Hold Stock | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | OSP Stock, Pack Hold Stock | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | OSP Stock, Pack Hold Stock | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 5 | 4 | USE | OSP Stock, Pack Hold Stock | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Inventory Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | 명칭 |  |  |
|  |  | BUTTON_AREA | OSP Stock | Upload | 버튼/기타 | 팝업 Osp Stock |  |  | Upload |  |  |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | OSP Stock | Excel Form | 버튼/기타 |  |  |  | Excel Form |  |  |  |  | 버튼영역 이동 | 업로드 양식 다운로드 방법 통일화 |  |
| 6 | 5 | USE | Pack Hold Stock | Cutoff Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Cutoff Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | 순서 변경 | - Pack Hold Stock Sheet에 관리되는 데이터 어디에 사용되는지 확인 후 필요없으면 삭제 ⏎ - 조건이 어떻게 사용되는지 확인 후 ⏎ 기존유지 or Inventory Date로 변경, ⏎ - Pack Hold Stock 만 표시 |  |
| 4 | 6 | USE | Pack Hold Stock | 관리번호 | 텍스트/다중 |  |  |  | 관리번호 | 텍스트/다중 |  |  |  |  | Pack Hold Stock 만 표시 |  |
| 7 | 7 | USE | Pack Hold Stock | Status | 선택/단일 |  |  | ALL/Hold/Release | Status | 선택/단일 |  |  |  |  | Pack Hold Stock 만 표시 | N |

#### SCP0046 · Model Allocation  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Model Allocation = SCP0046(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 108~113행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Div | 선택/단일 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | PKG Site | 선택/다중 | 검색 |  | ALL(우) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | PKG Line | 선택/다중 | 검색 |  | ALL(우) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Supply Site | 선택/다중 | 검색 |  | ALL(우) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD(달력형식 다름, 주차X) | - |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0037 · Operation LT  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Operation LT = SCP0037(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 114~118행

**하네스 적용 순서**: 1.Div → 2.Operation → 3.Plant Site → 4.Material → 5.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation → 3.Plant Site → 4.Material → 5.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | LT Operation | 선택/단일 |  |  |  | Operation | 선택/단일 |  |  |  | 명칭 |  |  |
| 3 | 3 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 5 | 5 | USE | - | Site Item Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0049 · CAPA  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›CAPA = SCP0049(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 119~144행

**하네스 적용 순서**: 1.Div → 2.Ver. → 3.Operation group → 4.Plant → 5.Building → 6.Line → 7.Operation → 8.Model/Nickname → 9.Material → 10.Period → 11.Bucket — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Ver. → 3.Operation group → 4.Plant → 5.Building → 6.Line → 7.Operation → 8.Model/Nickname → 9.Material → 10.Period → 11.Bucket · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Version | 선택/단일 |  |  |  | Ver. | 선택/단일 |  |  |  | 명칭, 순서 변경 |  |  |
| 3 | 3 | USE | - | Group | 선택/단일 |  |  |  | Operation group | 선택/단일 |  |  |  | 명칭 |  |  |
| 4 | 4 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Building | 선택/다중 | 검색 |  | ALL(좌) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
|  |  | DROP | - | NoName | 텍스트/기타 |  |  | 비활성화_Total/Small/Auto/Elec/PIC | - |  |  |  |  | 제거 |  |  |
| 6 | 6 | USE | - | Line | 선택/다중 | 검색 |  | ALL(좌) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 7 | USE | - | Operation | 선택/다중 | 검색 |  | ALL(좌) | Operation | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 8 | USE | - | Model | 텍스트/다중 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 9 | 9 | USE | - | Material | 텍스트/다중 |  |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  | 팝업 |  |  |
| 8 | 8 | MERGED | - | NickName | 텍스트/다중 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 10 | 10 | USE | - | Period | 선택/단일 | 달력 |  | YYYY-MM | Period | 텍스트/단일 | 달력 |  | YYYY-MM |  |  | N |
| 11 | 11 | USE | - | Bucket | 선택/다중 |  |  |  | Bucket | 선택/다중 |  |  |  |  |  |  |
|  |  | DROP | - | Loss | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | Measure 셋팅 기능 사용 |  |
|  |  | DROP | - | Line Assign | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | Measure 셋팅 기능 사용 |  |
|  |  | DROP | - | Tact Time | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | Measure 셋팅 기능 사용 |  |
|  |  | DROP | - | Yield | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | Measure 셋팅 기능 사용 |  |
|  |  | REVIEW | - | RESULT | 체크박스/기타 |  |  |  |  |  |  |  |  |  |  |  |
|  |  | REVIEW | - | Empty Value | 체크박스/기타 |  |  |  |  |  |  |  |  |  |  |  |
|  |  | DROP | - | New Version | 버튼/기타 | 팝업 CAAPA NewVersion Confirm |  |  |  |  |  |  |  | 제거 |  |  |
|  |  | DROP | - | New Model | 버튼/기타 | 팝업 CAPA New Model |  |  |  |  |  |  |  | 제거 |  |  |
|  |  | BUTTON | - | Version Info | 버튼/기타 | 팝업 CAPA Version Info |  |  | Version Info | 버튼/기타 | 팝업 CAPA Version Info |  |  |  |  |  |
|  |  | DROP | - | Upload | 버튼/기타 | 팝업 CAPA/CAPA_Day |  |  |  |  |  |  |  | 제거 |  |  |
|  |  | DROP | - | Excel Form | 버튼/기타 |  |  |  |  |  |  |  |  | 제거 |  |  |
|  |  | DROP | - | Mail Request | 버튼/기타 |  |  |  |  |  |  |  |  | 제거 |  |  |
|  |  | COLUMN_PERSONAL | - | Column | 버튼/기타 |  |  |  | Column | 버튼/기타 |  |  |  | 컬럼 개인화 기능 사용 |  |  |

#### SCP0050 · CAPA PIC  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›CAPA PIC = SCP0050(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 145~153행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | NOT_MIGRATED | - | Div | 선택/단일 |  |  |  | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Group | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Building | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Line | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Operation | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Category | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Key | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 미전환 메뉴(FP) |  |  |
|  |  | NOT_MIGRATED | - | Manager | 텍스트/다중 |  |  |  | - |  |  |  |  | 미전환 메뉴(FP) |  |  |

#### SCP0053 · SCP BOM (Cell~Pack)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›SCP BOM (Cell~Pack) = SCP0053(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 154~159행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Model/Nickname → 4.Parent Item → 5.Child Item → 6.Alter BOM — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Model/Nickname → 4.Parent Item → 5.Child Item → 6.Alter BOM · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 4 | 4 | USE | - | Parent Item | 텍스트/다중 |  |  |  | Parent Item | 텍스트/다중 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Child Item | 텍스트/다중 |  |  |  | Child Item | 텍스트/다중 |  |  |  |  |  |  |
| 6 | 6 | USE | - | Alter BOM | 체크박스/기타 |  |  |  | Alter BOM | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0087 · MDM Class Master  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›MDM Class Master = SCP0087(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 160~162행

**하네스 적용 순서**: 1.Class ID → 2.Class Name → 3.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Class ID → 2.Class Name → 3.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Class ID | 텍스트/단일 |  |  |  | Class ID | 텍스트/다중 |  |  |  | 유형 |  |  |
| 2 | 2 | USE | - | Class Name | 텍스트/단일 |  |  |  | Class Name | 텍스트/다중 |  |  |  | 유형 |  |  |
| 3 | 3 | USE | - | Use Flag | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0097 · SCP BOM(Elec)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›SCP BOM(Elec) = SCP0097(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 163~165행

**하네스 적용 순서**: 1.Div → 2.Parent Item → 3.Child Item — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Parent Item → 3.Child Item · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Parent Item | 텍스트/다중 |  |  |  | Parent Item | 텍스트/다중 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Child Item | 텍스트/다중 |  |  |  | Child Item | 텍스트/다중 |  |  |  |  |  |  |

#### SCP0098 · CAPA (Mobility IT)  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›CAPA (Mobility IT) = SCP0098(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 166~179행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Line → 4.Model/Nickname → 5.Period — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Line → 4.Model/Nickname → 5.Period · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O | 비활성화_40 Mobolity & IT Battery | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(좌) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Line | 선택/다중 | 검색 |  | ALL(좌) | Line | 선택/다중 | 검색 | ALL버튼 |  | 순서 변경 |  |  |
| 4 | 4 | USE | - | Material | 텍스트/단일 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | MERGED | - | Nick Name | 텍스트/단일 |  |  |  | Nick Name | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 5 | 5 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
|  |  | DROP | - | Bucket | 선택/단일 |  |  | 비활성화_Daily | Bucket | 선택/단일 |  |  |  | 조회조건 삭제 |  |  |
|  |  | DROP | - | Measure Setting | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | Measure Setting | 버튼/기타 | 팝업 Measure Setting |  |  | 삭제 |  |  |
|  |  | DROP | - | Detail | 체크박스/기타 |  |  |  | Detail | 체크박스/기타 |  |  |  | 삭제 |  |  |
|  |  | BUTTON_AREA | - | Copy Data | 버튼/기타 |  |  |  | Copy Data | 버튼/기타 |  |  |  | 버튼영역 이동 | 무슨 기능인지 분석 후 진행 ⏎ -> 필요없을 경우 제거 |  |
|  |  | BUTTON_AREA | - | Category | 선택/단일 |  |  | 일괄 입력기능 | Category | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Day Type | 선택/단일 |  |  | 일괄 입력기능 | Day Type | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input Value | 텍스트/단일 |  |  | 일괄 입력기능 | Input Value | 텍스트/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input | 버튼/기타 |  |  | 일괄 입력기능 | Input | 버튼/기타 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |

#### SCP0110 · Demand Group Master  <sub>Master › Supply Master</sub>

매핑: AS-IS 메뉴 Supply Master›Demand Group Master = SCP0110(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 180~184행

**하네스 적용 순서**: 1.Div → 2.Operation group → 3.Group Name → 4.PJT → 5.Model/Nickname — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.Group Name → 4.PJT → 5.Model/Nickname · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation Group | 선택/단일 |  |  |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Group Name | 텍스트/단일 |  |  |  | Group Name | 텍스트/단일 |  |  |  |  |  |  |
| 4 | 4 | USE | - | Project | 텍스트/다중 | 팝업 Project by Division 프1 |  |  | PJT | 텍스트/다중 | 팝업 프2 |  |  | 명칭/팝업 |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |

#### SCP0015 · Plan Management  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Plan Management = SCP0015(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 185~187행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Div | 선택/단일 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Year | 선택/단일 |  | O | 올해 포함 이전 2개년(26년/25년) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Plan Date | 선택/단일 |  | O | 당주 포함 이전 3주(W2/W3/W4) | - |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0011 · Production Plan  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Production Plan = SCP0011(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 188~202행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.Plan Type → 4.Seq. → 5.Operation group → 6.Plant Site → 7.Electrode → 8.Material → 9.Model/Nickname → 10.Period → 11.Bucket → 12.Sum — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.Electrode → 4.Plant Site → 5.Material → 6.Model/Nickname → 7.Plan Date → 8.Plan Type → 9.Seq. → 10.Period → 11.Bucket → 12.Sum · 원칙 대비: 차이 — Plant Site(그룹2) 가 Electrode(그룹3) 뒤 · Plan Date(그룹1) 가 Model/Nickname(그룹3) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 5 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 7 | 3 | USE | - | Electrode | 선택/다중 |  |  | 전극(EE*) 사업부만 활성화 | Electrode | 선택/다중 |  | ALL버튼 |  |  |  |  |
| 6 | 4 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 5 | USE | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 9 | 6 | USE | - | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 9 | 6 | MERGED | - | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 2 | 7 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  | 계획 조회 화면에 3개가 항상 세트로 들어가는데,  ⏎ 한칸에 표시할 방법 검토(다른 계획 조회 화면 모두 동일함) |  |
| 3 | 8 | USE | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  |  |  |  |
| 4 | 9 | USE | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 명칭 |  |  |
| 10 | 10 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 11 | 11 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 순서 변경 |  |  |
| 12 | 12 | USE | - | Sum | 체크박스/기타 |  |  |  | Sum | 체크박스/기타 |  |  |  | 순서 변경 |  |  |
|  |  | BUTTON_AREA | - | Calculat | 버튼/기타 |  |  |  | Calculat | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | DROP | - | ALL | 체크박스/기타 |  |  |  | ALL | 체크박스/기타 |  |  |  | 삭제 | 기본적으로 ALL로 조회하도록 변경 |  |

#### SCP0013 · Production Plan Line  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Production Plan Line = SCP0013(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 203~225행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.Plan Type → 4.Seq. → 5.Operation group → 6.Plant Site → 7.Line → 8.Model/Nickname → 9.Material → 10.Cell Type Gr → 11.Electrode → 12.Extra Spec → 13.Period → 14.Bucket — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.Plant Site → 4.Line → 5.Model/Nickname → 6.Material → 7.Plan Date → 8.Plan Type → 9.Seq. → 10.Period → 11.Bucket → 12.Cell Type Gr → 13.Electrode → 14.Extra Spec · 원칙 대비: 차이 — Plan Date(그룹1) 가 Material(그룹3) 뒤 · Cell Type Gr(그룹3) 가 Bucket(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 5 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 6 | 3 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(좌) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 4 | USE | - | Line | 선택/다중 | 검색 |  | ALL(좌) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 5 | USE | - | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 9 | 6 | USE | - | Material | 텍스트/단일 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  | 유형 |  |  |
| 8 | 5 | MERGED | - | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 2 | 7 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 3 | 8 | USE | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  |  |  |  |
| 4 | 9 | USE | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 명칭 |  |  |
| 13 | 10 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 14 | 11 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
| 10 | 12 | USE | - | Cell Type Gr | 선택/다중 |  |  | 40 사업부만 활성화 | Cell Type Gr | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 11 | 13 | USE | - | Electrode | 선택/다중 |  |  | EE* 사업부만 활성화 | Electrode | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 12 | 14 | USE | - | Extra Spec | 선택/다중 |  |  | 40 사업부만 활성화 | Extra Spec | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
|  |  | COMMON_REVIEW | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  | 공통기능화 검토 |  |  |
|  |  | DROP | - | Line Assign | 체크박스/기타 |  |  |  | Line Assign | 체크박스/기타 |  |  |  | 제거 |  |  |
|  |  | DROP | - | ALL | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | 기본적으로 ALL로 조회하도록 변경 |  |
|  |  | IN_CALENDAR | - | W26 | 버튼/기타 |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | 달력기능에 포함 |  |  |
|  |  | IN_CALENDAR | - | W52 | 버튼/기타 |  |  | Period 조회조건 변경 기능 |  |  |  |  |  | 달력기능에 포함 |  |  |
|  |  | BUTTON_AREA | - | New | 버튼/기타 | 팝업 Production Plan Insert |  | 화면 편집 기능 | New | 버튼/기타 | 팝업 Production Plan Insert |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | - | Fix | 버튼/기타 |  |  | 화면 편집 기능 | Fix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | - | Unfix | 버튼/기타 |  |  | 화면 편집 기능 | Unfix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |

#### SCP0024 · Production Plan Fix  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Production Plan Fix = SCP0024(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 226~237행

**하네스 적용 순서**: 1.Div → 2.Operation group → 3.Plant Site → 4.Line → 5.Material → 6.Electrode → 7.Period → 8.Bucket → 9.Sum — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.Plant Site → 4.Line → 5.Material → 6.Period → 7.Bucket → 8.Electrode → 9.Sum · 원칙 대비: 차이 — Electrode(그룹3) 가 Bucket(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  | 순서 변경 |  |  |
| 7 | 6 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 8 | 7 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 순서 변경 |  |  |
| 6 | 8 | USE | - | Electrode | 선택/다중 |  |  | EE* 사업부만 활성화 | Electrode | 선택/다중 | 검색 | ALL버튼 |  | 순서 변경 |  |  |
| 9 | 9 | USE | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  |  |  |  |
|  |  | BUTTON_AREA | - | Unfix | 버튼/기타 |  |  | 화면 편집 기능 | Unfix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | IN_CALENDAR | - | W26 | 버튼/기타 |  |  | Period 조회조건 변경 기능 | W26 | 버튼/기타 |  |  |  | 달력기능에 포함 |  |  |
|  |  | IN_CALENDAR | - | W52 | 버튼/기타 |  |  | Period 조회조건 변경 기능 | W52 | 버튼/기타 |  |  |  | 달력기능에 포함 |  |  |

#### SCP0009 · Shipment Plan FG  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Shipment Plan FG = SCP0009(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 238~257행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.Plan Type → 4.Seq. → 5.Operation group → 6.From Site → 7.To Site → 8.Team → 9.PJT → 10.Model/Nickname → 11.Electrode → 12.Period → 13.Bucket → 14.Sum — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.From Site → 4.To Site → 5.Team → 6.PJT → 7.Model/Nickname → 8.Plan Date → 9.Plan Type → 10.Seq. → 11.Period → 12.Bucket → 13.Electrode → 14.Sum · 원칙 대비: 차이 — Plan Date(그룹1) 가 Model/Nickname(그룹3) 뒤 · Electrode(그룹3) 가 Bucket(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 5 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 6 | 3 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 4 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(좌) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 5 | USE | - | Team | 선택/다중 |  |  |  | Team | 선택/다중 | 검색 | ALL버튼 |  | 순서 변경 |  |  |
| 9 | 6 | USE | - | Project | 텍스트/다중 | 팝업 Project by Division 프1 |  |  | PJT | 텍스트/다중 | 팝업 프2 |  |  | 명칭/팝업 |  |  |
| 10 | 7 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 8 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 3 | 9 | USE | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  |  |  |  |
| 4 | 10 | USE | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 명칭 |  |  |
| 12 | 11 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 13 | 12 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 순서 변경 |  |  |
| 11 | 13 | USE | - | Electrode | 선택/다중 |  |  | EE* 사업부만 활성화 | Electrode | 선택/다중 | 검색 | ALL버튼 |  | 순서 변경 |  |  |
| 14 | 14 | USE | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  |  |  |  |
|  |  | DROP | - | ALL | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | 기본적으로 ALL로 조회하도록 변경 |  |
|  |  | BUTTON_AREA | - | New | 버튼/기타 | 팝업 Shipment Plan Insert |  | 화면 편집 기능 | New | 버튼/기타 | 팝업 Shipment Plan Insert |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | - | Fix | 버튼/기타 |  |  | 화면 편집 기능 | Fix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | - | Unfix | 버튼/기타 |  |  | 화면 편집 기능 | Unfix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | IN_CALENDAR | - | W26 | 버튼/기타 |  |  | Period 조회조건 변경 기능 | W26 | 버튼/기타 |  |  |  | 달력기능에 포함 |  |  |
|  |  | IN_CALENDAR | - | W52 | 버튼/기타 |  |  | Period 조회조건 변경 기능 | W52 | 버튼/기타 |  |  |  | 달력기능에 포함 |  |  |

#### SCP0010 · Shipment Plan SEMI  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Shipment Plan SEMI = SCP0010(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 258~273행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.Plan Type → 4.Seq. → 5.Operation group → 6.From Site → 7.To Site → 8.Model/Nickname → 9.Electrode → 10.Period → 11.Bucket → 12.Sum — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.From Site → 4.To Site → 5.Model/Nickname → 6.Plan Date → 7.Plan Type → 8.Seq. → 9.Period → 10.Bucket → 11.Electrode → 12.Sum · 원칙 대비: 차이 — Plan Date(그룹1) 가 Model/Nickname(그룹3) 뒤 · Electrode(그룹3) 가 Bucket(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 5 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 6 | 3 | USE | - | From Site | 선택/다중 |  |  |  | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 4 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(우) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 6 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 3 | 7 | USE | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  |  |  |  |
| 4 | 8 | USE | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 명칭 |  |  |
| 10 | 9 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 11 | 10 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 순서 변경 |  |  |
| 9 | 11 | USE | - | Electrode | 선택/다중 |  |  | EE* 사업부만 활성화 | Electrode | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 12 | 12 | USE | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  |  |  |  |
|  |  | DROP | - | ALL | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | 기본적으로 ALL로 조회하도록 변경 |  |
|  |  | BUTTON_AREA | - | New | 버튼/기타 | 팝업 Shipment Plan Insert |  | 화면 편집 기능 | New | 버튼/기타 | 팝업 Shipment Plan Insert |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | - | Fix | 버튼/기타 |  |  | 화면 편집 기능 | Fix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | - | Unfix | 버튼/기타 |  |  | 화면 편집 기능 | Unfix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |

#### SCP0025 · Shipment Plan Fix  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Shipment Plan Fix = SCP0025(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 276~285행

**하네스 적용 순서**: 1.Div → 2.Operation group → 3.Model/Nickname → 4.Electrode → 5.Period → 6.Bucket → 7.Sum — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.Model/Nickname → 4.Period → 5.Bucket → 6.Electrode → 7.Sum · 원칙 대비: 차이 — Electrode(그룹3) 가 Bucket(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 5 | 4 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 6 | 5 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 순서 변경 |  |  |
| 4 | 6 | USE | - | Electrode | 선택/다중 |  |  | EE* 사업부만 활성화 | Electrode | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 7 | USE | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  |  |  |  |
|  |  | BUTTON_AREA | - | Unfix | 버튼/기타 |  |  | 화면 편집 기능 | Unfix | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | IN_CALENDAR | - | W26 | 버튼/기타 |  |  | Period 조회조건 변경 기능 | W26 | 버튼/기타 |  |  |  | 달력기능에 포함 |  |  |
|  |  | IN_CALENDAR | - | W52 | 버튼/기타 |  |  | Period 조회조건 변경 기능 | W52 | 버튼/기타 |  |  |  | 달력기능에 포함 |  |  |

#### SSP0045 · Shipment Request SEMI  <sub>Supply › Supply Plan · 참고본(정본은 다른 파일)</sub>

매핑: AS-IS 메뉴 Supply Plan›Shipment Request SEMI = SSP0045(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 286~292행

**하네스 적용 순서**: 1.Div → 2.Operation group → 3.From Site → 4.Model/Nickname → 5.Period → 6.Bucket — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.From Site → 4.Model/Nickname → 5.Period → 6.Bucket · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | From Site | 선택/다중 |  |  |  | From Site | 선택/다중 | 검색 | ALL버튼 |  | 순서 변경 |  |  |
| 4 | 4 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 5 | 5 | USE | - | Period | 텍스트/단일 | 달력 | O | 비활성화_YYYY-MM-DD(달력형식 다름, 주차X) | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 6 | 6 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 순서 변경 |  |  |
|  |  | REVIEW | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  |  |  |  |

#### SCP0012 · PSI  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›PSI = SCP0012(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 293~304행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET_REVIEW | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Operation Group | 선택/단일 |  |  |  | Operation group | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | From Site | 선택/다중 | 검색 |  | ALL(우) | From Site | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Cell Type Gr | 선택/다중 |  |  | 비활성화_ALL | Cell Type Gr | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Electrode | 선택/다중 |  |  | 비활성화_ALL | Electrode | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | 메뉴 Sun-Set 검토 |  | N |
|  |  | SUNSET_REVIEW | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 메뉴 Sun-Set 검토 |  |  |

#### SCP0031 · Global PSI  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Global PSI = SCP0031(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 305~316행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.Plan Type → 4.Seq. → 5.From Site → 6.To Site → 7.Material → 8.Model/Nickname → 9.Period → 10.Bucket — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Material → 3.Model/Nickname → 4.From Site → 5.To Site → 6.Plan Date → 7.Plan Type → 8.Seq. → 9.Period → 10.Bucket · 원칙 대비: 차이 — From Site(그룹2) 가 Model/Nickname(그룹3) 뒤 · Plan Date(그룹1) 가 To Site(그룹2) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 7 | 2 | USE | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 8 | 3 | USE | - | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 5 | 4 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 5 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(좌) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 6 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 3 | 7 | USE | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  |  |  |  |
| 4 | 8 | USE | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 명칭 |  |  |
| 9 | 9 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 10 | 10 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 순서 변경 |  |  |
|  |  | REVIEW | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  |  |  |  |
|  |  | DROP | - | ALL | 체크박스/기타 |  |  |  |  |  |  |  |  | 제거 | 기본적으로 ALL로 조회하도록 변경 |  |

#### SCP0034 · PSI Electrode  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›PSI Electrode = SCP0034(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 317~328행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET_REVIEW | - | Div | 선택/단일 |  | O | 비활성화_EE Electrode | Div | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Operation Group | 선택/단일 |  |  | 비활성화_Electrode | Operation group | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | From Site | 선택/다중 | 검색 |  | ALL(우) | From Site | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Electrode | 선택/다중 |  |  |  | Electrode | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Unit | 선택/다중 |  |  |  | Unit | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | 메뉴 Sun-Set 검토 |  | N |
|  |  | SUNSET_REVIEW | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 메뉴 Sun-Set 검토 |  |  |

#### SCP0038 · Global PSI(Mobility & IT)  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Global PSI(Mobility & IT) = SCP0038(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 329~342행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET_REVIEW | - | Div | 선택/단일 |  | O | 비활성화_40 Mobility & Battery | Div | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Operation Group | 선택/다중 |  |  |  | Operation group | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Cell Type | 선택/다중 |  |  |  | Cell Type | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | From Site | 선택/다중 | 검색 |  | ALL(우) | From Site | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | To Site | 선택/다중 | 검색 |  | ALL(우) | To Site | 선택/다중 | 검색 | ALL버튼 |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 |  |  |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Plan type | 선택/단일 |  | O |  | Plan Type | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Seq | 선택/단일 |  | O |  | Seq. | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  | 메뉴 Sun-Set 검토 |  |  |
|  |  | SUNSET_REVIEW | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | 메뉴 Sun-Set 검토 |  | N |
|  |  | SUNSET_REVIEW | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 메뉴 Sun-Set 검토 |  |  |

#### SCP0095 · Global PSI Elec  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Global PSI Elec = SCP0095(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 343~349행

**하네스 적용 순서**: 1.Div → 2.Company → 3.Meterial → 4.Plan Date → 5.Plan Type → 6.Period → 7.Bucket — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Company → 3.Meterial → 4.Plan Date → 5.Plan Type → 6.Period → 7.Bucket · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Company | 선택/다중 | 검색 |  | ALL(우) | Company | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Elec Material | 텍스트/다중 | 팝업 Model by DivisionPopup 모2 |  |  | Meterial | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 4 | 4 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Report type | 선택/단일 |  | O | 타메뉴는 Plan Type(용어 다름) *밑에 설명 달려있음 | Plan Type | 선택/단일 |  |  |  | 명칭 |  |  |
| 6 | 6 | USE | - | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 7 | 7 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |

#### SCP0100 · Global PSI New  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Global PSI New = SCP0100(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 350~364행

**하네스 적용 순서**: 1.Div → 2.Cell Group → 3.Plan Date → 4.Plan Type → 5.Scale → 6.Cell Qty → 7.A/S → 8.From Site → 9.To Site → 10.Search Mode → 11.PJT → 12.Model/Nickname → 13.Period → 14.Bucket → 15.Search Level — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Cell Group → 3.PJT → 4.Model/Nickname → 5.From Site → 6.To Site → 7.Search Mode → 8.Search Level → 9.Period → 10.Bucket → 11.Plan Date → 12.Plan Type → 13.Scale → 14.Cell Qty → 15.A/S · 원칙 대비: 차이 — From Site(그룹2) 가 Model/Nickname(그룹3) 뒤 · Period(그룹4) 가 Search Level(그룹5) 뒤 · Plan Date(그룹1) 가 Bucket(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/다중 | 검색 | O | ALL(좌) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 2 | USE | - | Cell Group | 텍스트/단일 |  |  |  | Cell Group | 텍스트/단일 |  |  |  |  |  |  |
| 11 | 3 | USE | - | Project | 텍스트/단일 | 팝업 Project by Division 프1 |  |  | PJT | 텍스트/다중 | 팝업 프2 |  |  | 명칭/유형/팝업 |  |  |
| 12 | 4 | USE | - | Model / Nick Name | 텍스트/단일 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 8 | 5 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 9 | 6 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(좌) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 10 | 7 | USE | - | NoName | 선택/단일 |  |  | 형식 다름_Search Level/Detail | Search Mode | 선택/단일 |  |  |  | 라벨명 변경 |  |  |
| 15 | 8 | USE | - | Search Level | 선택/단일 |  |  | 상단 NoName(Search Level/Detail)과 연동(활성화/비활성화) | Search Level | 선택/단일 |  |  |  |  |  |  |
| 13 | 9 | USE | - | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 14 | 10 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
| 3 | 11 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 4 | 12 | USE | - | Plan type | 선택/단일 |  |  | 비활성화_Final Plan | Plan Type | 선택/단일 |  |  |  |  |  |  |
| 5 | 13 | USE | - | Unit (Qty) | 선택/단일 |  |  | 숫자 단위 조정 | Scale | 선택/단일 |  |  |  | 명칭 |  |  |
| 6 | 14 | USE | - | Cell Qty | 체크박스/기타 |  |  |  | Cell Qty | 체크박스/기타 |  |  |  |  |  |  |
| 7 | 15 | USE | - | A/S | 체크박스/기타 |  |  |  | A/S | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0111 · Integration PSI  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Integration PSI = SCP0111(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 365~371행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.Model/Nickname → 4.Cell Model → 5.Period → 6.Qty ＜ 0 — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Model/Nickname → 3.Cell Model → 4.Plan Date → 5.Period → 6.Qty ＜ 0 · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 3 | 2 | MERGED | - | Nick Name | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  | Model과 같은 팝업 | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 3 | 2 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  | Nick Name과 같은 팝업 | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 4 | 3 | USE | - | Cell Model | 텍스트/다중 |  |  |  | Cell Model | 텍스트/다중 | 팝업 |  |  |  |  |  |
| 2 | 4 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Period | 선택/단일 | 달력 |  | YYYY-MM | Period | 텍스트/단일 | 달력 |  | YYYY-MM |  |  | N |
| 6 | 6 | USE | - | Qty ＜ 0 | 체크박스/기타 |  |  |  | Qty ＜ 0 | 체크박스/기타 |  |  |  |  |  |  |

#### SCM0014 · Intransit Inventory  <sub>Supply › Validation</sub>

매핑: AS-IS 메뉴 Validation›Intransit Inventory = SCM0014(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 372~378행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Sales Site → 4.PJT → 5.Model/Nickname → 6.Period → 7.Type — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plant Site → 3.Sales Site → 4.PJT → 5.Model/Nickname → 6.Period → 7.Type · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 텍스트/단일 |  |  |  | Plant Site | 선택/다중 | 검색 | ALL버튼 |  | 유형 |  |  |
| 3 | 3 | USE | - | Sales Site | 텍스트/단일 |  |  |  | Sales Site | 선택/다중 | 검색 | ALL버튼 |  | 유형 |  |  |
| 4 | 4 | USE | - | Project | 텍스트/다중 | 팝업 Project by Division 프1 |  |  | PJT | 텍스트/다중 | 팝업 프2 |  |  | 명칭/팝업 |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 6 | 6 | USE | - | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 7 | 7 | USE | - | Result Type | 선택/단일 |  |  |  | Type | 선택/단일 |  |  |  | 명칭 |  |  |

#### SCP0114 · CAPA LineMaster  <sub>Supply › Capa Plan</sub>

매핑: AS-IS 메뉴 Capa Plan›CAPA LineMaster = SCP0114(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 379~380행

**하네스 적용 순서**: 1.Div → 2.Operation group — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Product Group_하단 | 선택/단일 |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택/단일 |  |  |  |  |  |  |

#### SCP0104 · Line Assign  <sub>Supply › Capa Plan</sub>

매핑: AS-IS 메뉴 Capa Plan›Line Assign = SCP0104(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 381~390행

**하네스 적용 순서**: 1.Div → 2.Plan Month → 3.Ver. → 4.Operation group → 5.Site → 6.Plant → 7.Building → 8.Line → 9.Material → 10.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Month → 3.Ver. → 4.Operation group → 5.Site → 6.Plant → 7.Building → 8.Line → 9.Material → 10.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | 2개 | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | 2개 | Plan Month | 선택/단일 |  |  |  | Plan Month | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | 2개 | Version | 선택/단일 |  |  |  | Ver. | 선택/단일 |  |  |  | 명칭 |  |  |
| 4 | 4 | USE | 2개 | NoName | 선택/단일 |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택/단일 |  |  |  | 명칭 |  |  |
| 5 | 5 | USE | 2개 | Site | 선택/다중 | 검색 |  | ALL(우) | Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | 2개 | Plant | 선택/다중 | 검색 |  | ALL(우) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 7 | USE | 2개 | Building | 선택/다중 | 검색 |  | ALL(우) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 8 | USE | 2개 | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 9 | 9 | USE | 2개 | Model | 텍스트/단일 | 팝업 Item by DivisionPopup 아1 |  |  | Material | 텍스트/다중 | 팝업 아1 |  |  | 명칭/유형 |  |  |
| 10 | 10 | USE | 2개 | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0105 · Speed Plan  <sub>Supply › Capa Plan</sub>

매핑: AS-IS 메뉴 Capa Plan›Speed Plan = SCP0105(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 391~400행

**하네스 적용 순서**: 1.Div → 2.Plan Month → 3.Ver. → 4.Operation group → 5.Site → 6.Plant → 7.Building → 8.Line → 9.Material → 10.Status — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Month → 3.Ver. → 4.Status → 5.Operation group → 6.Site → 7.Plant → 8.Building → 9.Line → 10.Material · 원칙 대비: 차이 — Operation group(그룹2) 가 Status(그룹5) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Month | 선택/단일 |  |  |  | Plan Month | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Version | 선택/단일 |  |  |  | Ver. | 선택/단일 |  |  |  | 명칭 |  |  |
| 10 | 4 | USE | - | Status | 선택/단일 |  |  |  | Status | 선택/단일 |  |  |  |  |  | N |
| 4 | 5 | USE | - | NoName | 선택/단일 |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택/단일 |  |  |  | 명칭 |  |  |
| 5 | 6 | USE | - | Site | 선택/다중 | 검색 |  | ALL(우) | Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 7 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(우) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 8 | USE | - | Building | 선택/다중 | 검색 |  | ALL(우) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 9 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 9 | 10 | USE | - | Model | 텍스트/단일 | 팝업 Item by DivisionPopup 아1 |  |  | Material | 텍스트/다중 | 팝업 아1 |  |  | 명칭/유형 |  |  |

#### SCP0106 · Loss Plan  <sub>Supply › Capa Plan</sub>

매핑: AS-IS 메뉴 Capa Plan›Loss Plan = SCP0106(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 401~411행

**하네스 적용 순서**: 1.Div → 2.Plan Month → 3.Ver. → 4.Operation group → 5.Site → 6.Plant → 7.Building → 8.Line → 9.Material → 10.Show Rate Columns → 11.Status — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Month → 3.Ver. → 4.Status → 5.Operation group → 6.Site → 7.Plant → 8.Building → 9.Line → 10.Material → 11.Show Rate Columns · 원칙 대비: 차이 — Operation group(그룹2) 가 Status(그룹5) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Month | 선택/단일 |  |  |  | Plan Month | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Version | 선택/단일 |  |  |  | Ver. | 선택/단일 |  |  |  | 명칭 |  |  |
| 11 | 4 | USE | - | Status | 선택/단일 |  |  |  | Status | 선택/단일 |  |  |  |  |  | N |
| 4 | 5 | USE | - | NoName | 선택/단일 |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택/단일 |  |  |  | 명칭 |  |  |
| 5 | 6 | USE | - | Site | 선택/다중 | 검색 |  | ALL(우) | Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 7 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(우) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 8 | USE | - | Building | 선택/다중 | 검색 |  | ALL(우) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 9 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 9 | 10 | USE | - | Model | 텍스트/단일 | 팝업 Item by DivisionPopup 아1 |  |  | Material | 텍스트/다중 | 팝업 아1 |  |  | 명칭/유형 |  |  |
| 10 | 11 | USE | - | Show Rate Columns | 체크박스/기타 |  |  |  | Show Rate Columns | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0108 · LOB Report  <sub>Supply › Capa Plan</sub>

매핑: AS-IS 메뉴 Capa Plan›LOB Report = SCP0108(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 412~424행

**하네스 적용 순서**: 1.Div → 2.Plan Month → 3.Ver. → 4.Operation group → 5.Site → 6.Plant → 7.Building → 8.Line → 9.Operation → 10.Basic Nickname → 11.Bottleneck → 12.Line Type → 13.Status — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Month → 3.Ver. → 4.Status → 5.Operation group → 6.Site → 7.Plant → 8.Building → 9.Line → 10.Operation → 11.Basic Nickname → 12.Bottleneck → 13.Line Type · 원칙 대비: 차이 — Operation group(그룹2) 가 Status(그룹5) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Month | 선택/단일 |  |  |  | Plan Month | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Version | 선택/단일 |  |  |  | Ver. | 선택/단일 |  |  |  | 명칭 |  |  |
| 13 | 4 | USE | - | Status | 선택/단일 |  |  | 비활성화_Current | Status | 선택/단일 |  |  |  |  |  | N |
| 4 | 5 | USE | - | NoName | 선택/단일 |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택/단일 |  |  |  | 명칭 |  |  |
| 5 | 6 | USE | - | Site | 선택/다중 | 검색 |  | ALL(우) | Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 7 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(우) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 8 | USE | - | Building | 선택/다중 | 검색 |  | ALL(우) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 9 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 9 | 10 | USE | - | Operation | 선택/다중 | 검색 |  | ALL(우) | Operation | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 10 | 11 | USE | - | Basic Nickname | 텍스트/단일 | 팝업 Item by DivisionPopup 아1 |  |  | Basic Nickname | 텍스트/다중 | 팝업 아1 |  |  | 유형 |  |  |
| 11 | 12 | USE | - | Bottleneck | 선택/단일 |  |  | ALL/Y/N | Bottleneck | 선택/단일 |  |  |  |  |  |  |
| 12 | 13 | USE | - | Line Type | 선택/다중 | 검색 |  | ALL(우) | Line Type | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |

#### SCP0107 · TEEP Report  <sub>Supply › Capa Plan</sub>

매핑: AS-IS 메뉴 Capa Plan›TEEP Report = SCP0107(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 425~432행

**하네스 적용 순서**: 1.Div → 2.Plan Month → 3.Ver. → 4.Operation group → 5.Site → 6.Plant → 7.Building → 8.Line — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Month → 3.Ver. → 4.Operation group → 5.Site → 6.Plant → 7.Building → 8.Line · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/다중 | 검색 |  | ALL(우) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 2 | USE | - | Plan Month | 선택/단일 |  |  |  | Plan Month | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Version | 선택/단일 |  |  |  | Ver. | 선택/단일 |  |  |  | 명칭 |  |  |
| 4 | 4 | USE | - | NoName | 선택/단일 |  |  | 형식 다름_Electrode/Cell/Module.Pack | Operation group | 선택/단일 |  |  |  | 명칭 |  |  |
| 5 | 5 | USE | - | Site | 선택/다중 | 검색 |  | ALL(우) | Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(우) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 7 | USE | - | Building | 선택/다중 | 검색 |  | ALL(우) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 8 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |

#### SCP0120 · Constraint Mgmt  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Constraint Mgmt = SCP0120(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 433~435행

**하네스 적용 순서**: 1.Lookup Type → 2.Plan Group → 3.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Lookup Type → 2.Plan Group → 3.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Lookup Type | 텍스트/단일 |  |  |  | Lookup Type | 텍스트/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/다중 | 검색 |  | ALL(좌) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0123 · Plan Control  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Plan Control = SCP0123(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 436~438행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.Plan Group — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.Plan Date · 원칙 대비: 차이 — Plan Date(그룹1) 가 Plan Group(그룹2) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 3 | 2 | USE | - | Plan Group | 선택/단일 |  |  |  | Plan Group | 선택/단일 |  |  |  |  |  |  |
| 2 | 3 | USE | - | Plan Date | 선택/단일 |  |  |  | Plan Date | 선택/단일 |  |  |  |  |  |  |

#### SCP0124 · Plan Group Dashboard  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Plan Group Dashboard = SCP0124(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 439~443행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.Plant → 4.Period → 5.Completed — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.Plant → 4.Period → 5.Completed · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/단일 |  |  |  | Plan Group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 5 | 5 | USE | - | Completed | 선택/단일 |  |  | ALL/Y/N | Completed | 선택/단일 |  |  |  |  |  |  |

#### SCP0121 · Plan Group Master  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Plan Group Master = SCP0121(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 444~450행

**하네스 적용 순서**: 1.Div → 2.Operation group → 3.Plant → 4.Building → 5.Line → 6.Plan Group — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Operation group → 3.Plant → 4.Building → 5.Line → 6.Plan Group · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation Group | 선택/다중 | 검색 |  | ALL(좌) | Operation group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Building | 선택/다중 | 검색 |  | ALL(좌) | Building | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Line | 선택/다중 | 검색 |  | ALL(좌) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | - | Plan Group | 선택/다중 | 검색 |  | ALL(좌) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
|  |  | BUTTON_AREA | - | Plan Group Reg. | 버튼/기타 | 팝업 Plan Group Info |  |  | Plan Group Reg. | 버튼/기타 | 팝업 |  |  | 버튼영역 이동 |  |  |

#### SCP0122 · Plan Activity Mgmt  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Plan Activity Mgmt = SCP0122(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 451~453행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.Process — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.Process · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/단일 |  |  |  | Plan Group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | Process | 선택/단일 |  |  |  | Process | 선택/단일 |  |  |  |  |  |  |

#### SCP0125 · Workbench  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Workbench = SCP0125(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 454~458행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.MKT FCST Ver. → 4.Model/Nickname — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Date → 3.MKT FCST Ver. → 4.Model/Nickname · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | 전체 5개 | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | 전체 5개 | Plan Date | 선택/단일 |  |  |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | MKT FCST | MKT FCST Ver. | 선택/단일 |  |  | MKT FCST Sheet만 존재 | MKT FCST Ver. | 선택/단일 |  |  |  |  |  |  |
| 4 | 4 | MERGED | 전체 5개 | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 4 | 4 | USE | 전체 5개 | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |

#### SCP0126 · OPT CAPA  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›OPT CAPA = SCP0126(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 459~469행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.Plant → 4.Line → 5.Model/Nickname → 6.Period → 7.Bucket — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.Plant → 4.Line → 5.Model/Nickname → 6.Period → 7.Bucket · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | 전체 5개 | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | 전체 5개 | Plan Group | 선택/단일 |  |  |  | Plan Group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | 전체 5개 | Plant | 선택/다중 | 검색 |  | ALL(좌) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | 전체 5개 | Line | 선택/다중 | 검색 |  | ALL(좌) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | MERGED | 전체 5개 | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 5 | 5 | USE | 전체 5개 | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 6 | 6 | USE | 전체 5개 | Period | 텍스트/단일 | 달력 |  | YYYY-MM | Period | 텍스트/단일 | 달력 |  | YYYY-MM |  |  | N |
| 7 | 7 | USE | No Work | Bucket | 선택/단일 |  |  |  | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | BUTTON_AREA | No Work | Excel upload | 버튼/기타 | 팝업 No Work |  | No Work sheet에만 존재 | Excel upload | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | No Work | Excel Form | 버튼/기타 |  |  | No Work sheet에만 존재 | Excel Form | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |
|  |  | BUTTON_AREA | No Work | Batch Save | 버튼/기타 | 팝업 No Work Batch Save Popup |  | No Work sheet에만 존재 | Batch Save | 버튼/기타 |  |  |  | 버튼영역 이동 |  |  |

#### SCP0127 · Precede/Safety Stock Day  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Precede/Safety Stock Day = SCP0127(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 470~477행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.Model/Nickname → 6.Period → 7.Type → 8.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.Model/Nickname → 6.Type → 7.Period → 8.Active · 원칙 대비: 차이 — Period(그룹4) 가 Type(그룹5) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | SCM Site | 선택/다중 | 검색 |  | ALL(우) | SCM Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Stage | 선택/단일 |  |  |  | Stage | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭 |  |  |
| 7 | 6 | USE | - | Type | 선택/단일 |  |  | ALL/MIN/MAX | Type | 선택/단일 |  |  |  |  |  |  |
| 6 | 7 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 8 | 8 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0128 · Precede/Safety Stock Qty  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Precede/Safety Stock Qty = SCP0128(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 478~485행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.Model/Nickname → 6.Period → 7.Type → 8.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.Model/Nickname → 6.Type → 7.Period → 8.Active · 원칙 대비: 차이 — Period(그룹4) 가 Type(그룹5) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | SCM Site | 선택/다중 | 검색 |  | ALL(우) | SCM Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Stage | 선택/단일 |  |  |  | Stage | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭 |  |  |
| 7 | 6 | USE | - | Type | 선택/단일 |  |  | ALL/MIN/MAX | Type | 선택/단일 |  |  |  |  |  |  |
| 6 | 7 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 8 | 8 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0129 · Demand Exception  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Demand Exception = SCP0129(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 486~492행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.Model/Nickname → 6.Period → 7.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.Model/Nickname → 6.Period → 7.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | SCM Site | 선택/다중 | 검색 |  | ALL(우) | SCM Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Stage | 선택/단일 |  |  |  | Stage | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭 |  |  |
| 6 | 6 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 7 | 7 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0130 · Scheduled Reciept Information  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Scheduled Reciept Information = SCP0130(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 493~500행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.Plant Site → 4.Model/Nickname → 5.Material → 6.From Date → 7.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.Plant Site → 4.Model/Nickname → 5.Material → 6.From Date → 7.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Virtual BOM, Scheduled Reciept Information | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Virtual BOM, Scheduled Reciept Information | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | Virtual BOM, Scheduled Reciept Information | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Virtual BOM | Parent Model | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭 |  |  |
| 5 | 5 | USE | Virtual BOM | Child Material | 선택/다중 |  |  |  | Material | 선택/다중 | 검색 | ALL버튼 |  | 명칭 |  |  |
| 5 | 5 | USE | Scheduled Reciept Information | Material | 선택/다중 |  |  |  | Material | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | Virtual BOM, Scheduled Reciept Information | From Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD(달력형식 다름, 주차X) | From Date | 텍스트/단일 | 달력 |  |  |  |  |  |
| 7 | 7 | USE | Virtual BOM, Scheduled Reciept Information | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0131 · Sales Site Priority  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Sales Site Priority = SCP0131(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 501~506행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.SCM Site → 4.Model/Nickname → 5.Period → 6.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.SCM Site → 4.Model/Nickname → 5.Period → 6.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | SCM Site | 선택/다중 | 검색 |  | ALL(우) | SCM Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Model | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭 |  |  |
| 5 | 5 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 6 | 6 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0132 · Constraint Of Shipment Qty  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Constraint Of Shipment Qty = SCP0132(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 507~515행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.From Site → 4.To Site → 5.Stage → 6.Model/Nickname → 7.Model Group → 8.Period → 9.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.From Site → 4.To Site → 5.Stage → 6.Model/Nickname → 7.Model Group → 8.Period → 9.Active · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(우) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(우) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Stage | 선택/다중 |  |  |  | Stage | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | - | Model | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭 |  |  |
| 7 | 7 | USE | - | Model Group | 선택/다중 |  |  |  | Model Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 8 | 8 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 9 | 9 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0133 · Warehouse Capacity  <sub>Supply › OPT Plan</sub>

매핑: AS-IS 메뉴 OPT Plan›Warehouse Capacity = SCP0133(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 516~523행

**하네스 적용 순서**: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.WH Name → 6.Model/Nickname → 7.Period → 8.Active — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Plan Group → 3.SCM Site → 4.Stage → 5.WH Name → 6.Period → 7.Model/Nickname → 8.Active · 원칙 대비: 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Warehouse Capacity, Warehouse Item Mapping | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Warehouse Capacity, Warehouse Item Mapping | Plan Group | 선택/다중 | 검색 |  | ALL(우) | Plan Group | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | Warehouse Capacity, Warehouse Item Mapping | SCM Site | 선택/다중 | 검색 |  | ALL(우) | SCM Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Warehouse Capacity, Warehouse Item Mapping | Stage | 선택/단일 |  |  |  | Stage | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | Warehouse Capacity | Name | 선택/다중 |  |  |  | WH Name | 선택/다중 | 검색 | ALL버튼 |  | 명칭 |  |  |
| 7 | 6 | USE | Warehouse Capacity | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 6 | 7 | USE | Warehouse Item Mapping | Model | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭 |  |  |
| 8 | 8 | USE | Warehouse Capacity, Warehouse Item Mapping | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  | N |

#### SCP0017 · Production Plan Waterfall  <sub>Report › Waterfall</sub>

매핑: AS-IS 메뉴 Waterfall›Production Plan Waterfall = SCP0017(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 524~537행

**하네스 적용 순서**: 1.Div → 2.Ver. → 3.Operation group → 4.Plant Site → 5.Line → 6.Electrode → 7.Model/Nickname → 8.Material → 9.Period → 10.Bucket → 11.Sum → 12.ALL → 13.Gap — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Ver. → 3.Operation group → 4.Plant Site → 5.Line → 6.Electrode → 7.Model/Nickname → 8.Material → 9.Period → 10.Bucket → 11.Sum → 12.ALL → 13.Gap · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Version | 선택/다중 | 검색 | O | ALL(우) | Ver. | 선택/다중 | 검색 | ALL버튼 |  | 명칭 |  |  |
| 3 | 3 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 4 | 4 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Line | 선택/다중 | 검색 |  | ALL(우) | Line | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | - | Electrode | 선택/다중 |  |  | EE* 만 활성화 | Electrode | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 7 | USE | - | Model | 텍스트/다중 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 8 | 8 | USE | - | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 9 | 9 | USE | - | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 10 | 10 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly/Only Weekly | Bucket | 선택/단일 |  |  |  |  |  |  |
| 7 | 7 | MERGED | - | Nick Name | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 11 | 11 | USE | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  |  |  |  |
| 12 | 12 | USE | - | ALL | 체크박스/기타 |  |  |  | ALL | 체크박스/기타 |  |  |  |  | 속도가 따라준다면 기본적으로 ALL로 조회하도록 변경 |  |
| 13 | 13 | USE | - | Gap | 체크박스/기타 |  |  |  | Gap | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0016 · Shipment Plan FG Waterfall  <sub>Report › Waterfall</sub>

매핑: AS-IS 메뉴 Waterfall›Shipment Plan FG Waterfall = SCP0016(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 538~546행

**하네스 적용 순서**: 1.Div → 2.Ver. → 3.Operation group → 4.PJT → 5.Model/Nickname → 6.Electrode → 7.Period → 8.Bucket → 9.Sum — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Ver. → 3.Operation group → 4.PJT → 5.Model/Nickname → 6.Electrode → 7.Period → 8.Bucket → 9.Sum · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Version | 선택/다중 | 검색 | O | ALL(우) | Ver. | 선택/다중 | 검색 | ALL버튼 |  | 명칭 |  |  |
| 3 | 3 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 4 | 4 | USE | - | Project | 텍스트/다중 | 팝업 Project by Division 프1 |  |  | PJT | 텍스트/다중 | 팝업 프2 |  |  | 명칭/팝업 |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 6 | 6 | USE | - | Electrode | 선택/다중 |  |  | EE* 만 활성화 | Electrode | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 7 | 7 | USE | - | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 8 | 8 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly/Only Weekly | Bucket | 선택/단일 |  |  |  |  |  |  |
| 9 | 9 | USE | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0018 · Shipment Plan Semi Waterfall  <sub>Report › Waterfall</sub>

매핑: AS-IS 메뉴 Waterfall›Shipment Plan Semi Waterfall = SCP0018(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 547~554행

**하네스 적용 순서**: 1.Div → 2.Ver. → 3.Operation group → 4.Model/Nickname → 5.Electrode → 6.Period → 7.Bucket → 8.Sum — 정렬원칙 RULE 적용

시트 행 순서: 1.Div → 2.Ver. → 3.Operation group → 4.Model/Nickname → 5.Electrode → 6.Period → 7.Bucket → 8.Sum · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Version | 선택/다중 | 검색 | O | ALL(우) | Ver. | 선택/다중 | 검색 | ALL버튼 |  | 명칭 |  |  |
| 3 | 3 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 4 | 4 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 5 | 5 | USE | - | Electrode | 선택/다중 |  |  | 비활성화_ALL | Electrode | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 6 | 6 | USE | - | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  | N |
| 7 | 7 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly/Only Weekly | Bucket | 선택/단일 |  |  |  |  |  |  |
| 8 | 8 | USE | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0055 · Shipment(Allo) Report  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›Shipment(Allo) Report = SCP0055(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 555~566행

**하네스 적용 순서**: 1.Div → 2.Plan Date → 3.From Site → 4.Team → 5.Gap Date → 6.Operation group → 7.Model/Nickname → 8.Cell Type Gr → 9.Period → 10.FCST Pegging → 11.Bucket — 정렬원칙 RULE 적용

시트 행 순서: 1.Plan Date → 2.From Site → 3.Team → 4.Gap Date → 5.Model/Nickname → 6.Period → 7.FCST Pegging → 8.Div → 9.Operation group → 10.Cell Type Gr → 11.Bucket · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 2 | 1 | USE | - | Plan Date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 3 | 2 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 3 | USE | - | Team | 선택/다중 | 검색 |  | ALL(좌) | Team | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 4 | USE | - | Gap Date | 선택/단일 |  | O |  | Gap Date | 선택/단일 |  |  |  |  |  |  |
| 7 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  | Nick Name과 같은 팝업 | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | DROP | - | Nick Name | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  | Model과 같은 팝업 | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 조회조건 삭제 |  |  |
| 9 | 6 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM | Period | 텍스트/단일 | 달력 |  | YYYY-MM |  |  | N |
| 10 | 7 | USE | - | FCST Pegging | 체크박스/기타 |  |  |  | FCST Pegging | 체크박스/기타 |  |  |  |  |  |  |
| 1 | 8 | USE | - | Div | 선택/단일 |  | O | 비활성화_40 Mobility & IT Battery | Div | 선택/단일 |  |  |  |  |  |  |
| 6 | 9 | USE | - | Operation Group | 선택/단일 |  | O | 비활성화_Cell | Operation group | 선택/단일 |  |  |  |  |  |  |
| 8 | 10 | USE | - | Cell Type Gr | 선택/다중 |  |  | 비활성화_Cyl | Cell Type Gr | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 11 | 11 | USE | - | Bucket | 선택/단일 |  |  | 비활성화_Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |

#### SCP0084 · Long-term stock  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›Long-term stock = SCP0084(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 567~570행

**하네스 적용 순서**: 1.Div → 2.Plant → 3.Long Term Type → 4.Month — 정렬원칙 RULE 적용

시트 행 순서: 1.Month → 2.Div → 3.Plant → 4.Long Term Type · 원칙 대비: 차이 — Div(그룹1) 가 Month(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 4 | 1 | USE | - | Month | 텍스트/단일 | 달력 |  | YYYY-MM | Month | 텍스트/단일 | 달력 |  | YYYY-MM |  | 기존유지 or Period로 변경 |  |
| 1 | 2 | USE | - | Div | 선택/다중 | 검색 |  | ALL(좌) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 3 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 4 | USE | - | Long Term Type | 선택/다중 | 검색 |  | ALL(좌) | Long Term Type | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |

#### SCP0113 · Long-term stock MGMT  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›Long Term Stock MGMT = SCP0113(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 571~582행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Plan Date | 선택/단일 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Div | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | 발생유형 | 선택/단일 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Group Code | 텍스트/다중 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Item Type | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Material | 텍스트/다중 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | EOH Month | 텍스트/단일 | 달력 |  | YYYY-MM | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | NoName_이미지2 | 버튼/기타 | 팝업 Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Upload | 버튼/기타 | 팝업 Long Term Stock Management |  |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | PSI Export | 버튼/기타 | 팝업 LongTermStockMgmtViewPopup |  |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Process LongTerm | 버튼/기타 | 팝업 LongTermProcessPopup |  |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0115 · Policy-based Inv. Mgmt.  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›Policy-based Inv. Mgmt. = SCP0115(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 583~590행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Plan Date | 선택/단일 |  | O |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Div | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Category | 선택/단일 |  |  | ALL/입고계획/소진계획 | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Material | 텍스트/다중 |  |  |  | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Period | 텍스트/단일 |  | O | 날짜키인(달력X) | - |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | NoName_이미지2 | 버튼/기타 | 팝업 Column Setting |  | 컬럼 추가/제거 기능 |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Upload | 버튼/기타 | 팝업 Policy Inv Management |  |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0101 · Inventory Trend  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›Inventory Trend = SCP0101(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 591~595행

**하네스 적용 순서**: 1.Div → 2.Plant → 3.Meterial → 4.Month → 5.Detail — 정렬원칙 RULE 적용

시트 행 순서: 1.Month → 2.Div → 3.Plant → 4.Meterial → 5.Detail · 원칙 대비: 차이 — Div(그룹1) 가 Month(그룹4) 뒤

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 4 | 1 | USE | - | Month | 텍스트/단일 | 달력 |  | YYYY-MM | Month | 텍스트/단일 | 달력 |  | YYYY-MM |  | 기존유지 or Period로 변경 |  |
| 1 | 2 | USE | - | Div | 선택/다중 | 검색 |  | ALL(좌) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 3 | USE | - | Plant | 선택/다중 | 검색 |  | ALL(좌) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 4 | USE | - | Material | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Meterial | 텍스트/다중 | 팝업 메1 |  |  | 팝업 |  |  |
| 5 | 5 | USE | - | Detail | 체크박스/기타 |  |  | 컬럼 추가/제거 기능 | Detail | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0085 · Ending Inventory  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›Ending Inventory = SCP0085(UseYN=Y) · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 596~602행

**하네스 적용 순서**: 1.Div → 2.Plant → 3.Item Type → 4.Material → 5.Devaluation Age → 6.Month → 7.Date — 정렬원칙 RULE 적용

시트 행 순서: 1.Month → 2.Date → 3.Div → 4.Plant → 5.Item Type → 6.Material → 7.Devaluation Age · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 6 | 1 | USE | 월마감 기준 | Month | 텍스트/단일 | 달력 |  | YYYY-MM | Month | 텍스트/단일 | 달력 |  | YYYY-MM |  | 기존유지 or Period로 변경 |  |
| 7 | 2 | USE | 일별 기준 | Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  | 기존유지 or Period로 변경 |  |
| 1 | 3 | USE | 월마감 기준, 일별 기준 | Div | 선택/다중 | 검색 |  | ALL(좌) | Div | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 2 | 4 | USE | 월마감 기준, 일별 기준 | Plant | 선택/다중 | 검색 |  | ALL(좌) | Plant | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 5 | USE | 월마감 기준, 일별 기준 | Item Type | 선택/다중 | 검색 |  | ALL(좌) | Item Type | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 6 | USE | 월마감 기준, 일별 기준 | Material | 텍스트/다중 | 팝업 Material by Division Popup 메1 |  |  | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 5 | 7 | USE | 월마감 기준, 일별 기준 | Devaluation Age | 체크박스/기타 |  |  | 컬럼 추가/제거 기능 | Devaluation Age | 체크박스/기타 |  |  |  |  |  |  |

#### SCP0102 · BOD Validation Report  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›BOD Validation Report = SCP0102(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 603~616행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Div | 선택/단일 |  | O |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | From Site | 선택/다중 | 검색 |  | ALL(우) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | To Site | 선택/다중 | 검색 |  | ALL(우) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | From City | 선택/다중 | 검색 |  | ALL(우) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | To City | 선택/다중 | 검색 |  | ALL(우) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | 정확도 | 선택/단일 |  |  |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Exfactory Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD(달력형식 다름, 주차X) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | From Country | 선택/다중 | 검색 |  | ALL(우) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | To Country | 선택/다중 | 검색 |  | ALL(우) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | From 권역 | 선택/단일 |  |  |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | To 권역 | 선택/단일 |  |  |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | 조회구분 | 선택/다중 | 검색 |  | ALL(우) |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Exfactory Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD(달력형식 다름, 주차X)_하단 둘중 단일선택 |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | F.Dest A TA Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD(달력형식 다름, 주차X)_하단 둘중 단일선택 |  |  |  |  |  | 메뉴 Sun-Set |  |  |

#### SCP0112 · Cell Tray Simulation  <sub>Report › SCM Supply</sub>

매핑: AS-IS 메뉴 SCM Supply›Cell Tray Simulation = SCP0112(UseYN=Y) · TO-BE menu.csv 에 없음 · 원천 SCP_화면별 조회조건 정리_260731_v0.5.xlsx 617~621행

**하네스 적용 순서**: (없음) — 정렬원칙 RULE 적용

시트 행 순서: (없음) · 원칙 대비: 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|  |  | SUNSET | - | Div | 선택/단일 |  | O | 비활성화_82 ESS Battery |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Plan Date | 선택/단일 |  | O |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Plan type | 선택/단일 |  | O |  |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | To Site | 선택/단일 |  | O | 비활성화_PeopleWorks-KR-3 |  |  |  |  |  | 메뉴 Sun-Set |  |  |
|  |  | SUNSET | - | Period | 텍스트/단일 | 달력 | O | 비활성화_1년 |  |  |  |  |  | 메뉴 Sun-Set |  |  |

### 4.2 SSP (20 화면)

#### SSP0045 · Shipment Request SEMI  <sub>Supply › Supply Plan</sub>

매핑: AS-IS 메뉴 Supply Plan›Shipment Request SEMI = SSP0045(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 958~966행

**하네스 적용 순서**: 1.Div → 2.Operation group → 3.From Site → 4.To Site → 5.Model/Nickname → 6.Bucket → 7.Period — 시트 확정 순서

정렬원칙 대비(참고): 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | From Site | 선택/다중 |  |  |  | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | To Site | 선택/다중 |  |  | 추가 필요 | To Site | 선택/다중 | 검색 | ALL버튼 |  |  | As-Is에는 없는데 추가할 수 있도록 검토 필요 /단 UI의 속도가 느리면 제외 |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 6 | 6 | USE | - | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | - | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | NoName_이미지1 | 버튼/기타 | 팝업 |  |  | 공통기능화 검토 | As-Is에는 없는데 추가할 수 있도록 검토 필요 / 구현이 어려우면 제외 |  |
| 7 | 7 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
|  |  | COMMON_REVIEW | - | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 공통기능화 검토 |  |  |

#### SSP0005 · Shipment Working Day  <sub>Shipping › Shipping Master</sub>

매핑: AS-IS 메뉴 Shipping Master›Shipment Working Day = SSP0005(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 967~972행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Period — 시트 확정 순서

정렬원칙 대비(참고): 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
|  |  | BUTTON_AREA | - | Day of the week | 선택/단일 |  |  | 일괄 입력기능_EveryDay/각요일 | Day of the week | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input Value | 선택/단일 |  |  | Y/N_일괄 입력기능 | Input Value | 선택/단일 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |
|  |  | BUTTON_AREA | - | Input | 버튼/기타 |  |  |  | Input | 버튼/기타 |  |  |  | 버튼영역 이동 | Bulk Update 버튼 추가, 팝업호출하여 적용일과 value 입력받아서 동작하도록 변경 |  |

#### SCP0033 · Shipment Semi Dept Day  <sub>Shipping › Shipping Master</sub>

매핑: AS-IS 메뉴 Shipping Master›Shipment Semi Dept Day = SCP0033(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 973~975행

**하네스 적용 순서**: 1.Div → 2.Model/Nickname → 3.Active — 시트 확정 순서

정렬원칙 대비(참고): 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 3 | 3 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  |  |

#### SSP0014 · Shipment Model PIC  <sub>Shipping › Shipping Master</sub>

매핑: AS-IS 메뉴 Shipping Master›Shipment Model PIC = SSP0014(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 976~981행

**하네스 적용 순서**: 1.Div → 2.Operation group → 3.From Site → 4.Active → 5.Model/Nickname → 6.User ID(Name) — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Active(그룹5) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Operation group | 선택/단일 |  | O |  | Operation group | 선택/단일 |  |  |  |  |  |  |
| 3 | 3 | USE | - | From Site | 선택/다중 |  |  |  | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Valid | 선택/단일 |  |  | ALL/Y/N | Active | 선택/단일 |  |  |  | 명칭 |  |  |
| 5 | 5 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 6 | 6 | USE | - | User ID(Name) | 텍스트/다중 |  |  |  | User ID(Name) | 텍스트/다중 |  |  |  |  |  |  |

#### SSP0020 · Delegate  <sub>Shipping › Shipping Master</sub>

매핑: AS-IS 메뉴 Shipping Master›Delegate = SSP0020(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 982~988행

**하네스 적용 순서**: 1.Delegatee → 2.Div → 3.All → 4.Period — 시트 확정 순서

정렬원칙 대비(참고): 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Delegatee | 텍스트/단일 |  |  |  | Delegatee |  |  |  |  |  |  |  |
|  |  | BUTTON | - | 돋보기_이미지 | 버튼/기타 | 팝업 UserInfoPopup |  |  | 돋보기_이미지 | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |
| 2 | 2 | USE | - | Div | 체크박스/다중 |  |  | Div가 추가될 때마다 적용 | Div | 체크박스/다중 |  |  |  |  |  |  |
| 3 | 3 | USE | - | All | 체크박스/단일 |  |  |  | All | 체크박스/단일 |  |  |  |  |  |  |
|  |  | BUTTON | - | Save(이미지) | 버튼/기타 |  |  |  | Save(이미지) | 버튼/기타 |  |  |  |  |  |  |
|  |  | BUTTON | - | Unset(이미지) | 버튼/기타 |  |  |  | Unset(이미지) | 버튼/기타 |  |  |  |  |  |  |
| 4 | 4 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |

#### SSP0024 · Shipment Master Electrode  <sub>Shipping › Shipping Master</sub>

매핑: AS-IS 메뉴 Shipping Master›Shipment Master Electrode = SSP0024(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 989~993행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Material → 4.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) / 전극만 나옴 | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Material | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 4 | 4 | MERGED | - | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 4 | 4 | USE | - | Model | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 / | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |

#### SSP0025 · Shipment Requestor PIC  <sub>Shipping › Shipping Master</sub>

매핑: AS-IS 메뉴 Shipping Master›Shipment Requestor PIC = SSP0025(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 994~998행

**하네스 적용 순서**: 1.Div → 2.Plant Site → 3.Material → 4.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  | ALL(우) / 전극만 나옴 | Plant Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Material | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 4 | 4 | MERGED | - | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 4 | 4 | USE | - | Model | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 / | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |

#### SSP0021 · Shipment Plan(Auto & ESS)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Plan(Auto & ESS) = SSP0021(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 999~1020행

**하네스 적용 순서**: 1.Div → 2.Company → 3.From Site → 4.Bucket → 5.Plan Date → 6.Period → 7.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Plan Date(그룹1) 가 Bucket(그룹4) 뒤 · Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Shipment Plan Detail]**: 1.Period → 2.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Stock Location Detail]**: 1.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: oWMS Detail]**: 1.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: MES Stock]**: 1.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: MES Stock Detail]**: 1.Model/Nickname → 2.Box ID — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: Shipment Result]**: 1.Period → 2.Model/Nickname → 3.Request Type — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Main | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Main | Company | 선택/단일 | 검색 |  | ALL 없음 | Company | 선택/단일 | 검색 | ALL없음 |  |  |  |  |
| 3 | 3 | USE | Main | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Main | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | Main | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 공통기능화 검토 |  |  |
| 5 | 5 | USE | Main | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 6 | 6 | USE | Main | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 7 | 7 | USE | Main | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
|  |  | COMMON_REVIEW | Main | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | NoName_이미지1 | 버튼/기타 |  |  |  | 공통기능화 검토 |  |  |
|  |  | REVIEW | Main | NoName_이미지2 | 버튼/기타 |  |  | Simulation 기능 | NoName_이미지2 | 버튼/기타 |  |  |  | 용도 재확인 |  |  |
|  |  | COMMON_BUTTON | Main | NoName_이미지3 | 버튼/기타 |  |  | 하단 프레임 Search버튼 | NoName_이미지3 | 버튼/기타 |  |  |  | 하단에 공통으로 들어가는 버튼 |  |  |
| 1 | 1 | USE | Shipment Plan Detail | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Plan Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | REVIEW | Shipment Plan Detail | Requestor | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |  |  |  |  |  |
| 1 | 1 | USE | Stock Location Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | oWMS Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | MES Stock | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | MES Stock Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 2 | USE | MES Stock Detail | Box ID | 텍스트/단일 | 입력 |  |  | Box ID | 텍스트/단일 | 입력 |  |  |  |  |  |
| 1 | 1 | USE | Shipment Result | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Result | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 3 | 3 | USE | Shipment Result | Request Type | 텍스트/다중 | 검색 |  |  | Request Type | 텍스트/다중 | 검색 |  |  |  |  |  |

#### SSP0060 · Shipment Plan(Auto & ESS)-WA_UC  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Plan(Auto & ESS)-WA_UC = SSP0060(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1021~1051행

**하네스 적용 순서**: 1.Div → 2.Company → 3.From Site → 4.Bucket → 5.Plan Date → 6.Total PSI → 7.Period → 8.Model/Nickname → 9.Product Level1 — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Plan Date(그룹1) 가 Bucket(그룹4) 뒤 · Period(그룹4) 가 Total PSI(그룹5) 뒤 · Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Shipment Plan Detail]**: 1.Period → 2.Model/Nickname → 3.Product Level1 — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Stock Location Detail]**: 1.Model/Nickname → 2.Product Level1 — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: oWMS Detail]**: 1.Model/Nickname → 2.Product Level1 — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: MES Stock]**: 1.Model/Nickname → 2.Product Level1 — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: MES Stock Detail]**: 1.Model/Nickname → 2.Box ID → 3.Product Level1 — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: Shipment Result]**: 1.Period → 2.Model/Nickname → 3.Request Type → 4.Product Level1 — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Main | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Main | Company | 선택/단일 | 검색 |  | ALL 없음 | Company | 선택/단일 | 검색 | ALL없음 |  |  |  |  |
| 3 | 3 | USE | Main | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Main | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | Main | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 공통기능화 검토 |  |  |
| 5 | 5 | USE | Main | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 6 | 6 | USE | Main | Total PSI | 체크박스/단일 |  |  | 체크 시, 기능을 적용하여 재조회 | Total PSI | 체크박스/단일 |  |  |  |  |  |  |
| 7 | 7 | USE | Main | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 8 | 8 | USE | Main | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
| 9 | 9 | USE | Main | Product Level1 | 체크박스/다중 |  |  |  | Product Level1 | 체크박스/다중 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | Main | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  |  | 공통기능화 검토 |  |  |
|  |  | REVIEW | Main | NoName_이미지2 | 버튼/기타 |  |  | Simulation 기능 | NoName_이미지2 | 버튼/기타 |  |  |  | 용도 재확인 |  |  |
|  |  | COMMON_BUTTON | Main | NoName_이미지3 | 버튼/기타 |  |  | 하단 프레임 Search버튼 | NoName_이미지3 | 버튼/기타 |  |  |  | 하단에 공통으로 들어가는 버튼 |  |  |
| 1 | 1 | USE | Shipment Plan Detail | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Plan Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | BUTTON | Shipment Plan Detail | Requestor | 버튼/기타 | 팝업 UserInfoPopup |  |  | Requestor | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |
| 3 | 3 | USE | Shipment Plan Detail | Product Level1 | 체크박스/다중 |  |  |  | Product Level1 | 체크박스/다중 |  |  |  |  |  |  |
|  |  | BUTTON | Shipment Plan Detail | NoName_이미지4 | 버튼/기타 |  |  | Shipment Plan Detail의 Insert 버튼 | NoName_이미지4 | 버튼/기타 |  |  |  |  |  |  |
| 1 | 1 | USE | Stock Location Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 2 | USE | Stock Location Detail | Product Level1 | 체크박스/다중 |  |  |  | Product Level1 | 체크박스/다중 |  |  |  |  |  |  |
| 1 | 1 | USE | oWMS Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 2 | USE | oWMS Detail | Product Level1 | 체크박스/다중 |  |  |  | Product Level1 | 체크박스/다중 |  |  |  |  |  |  |
| 1 | 1 | USE | MES Stock | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 2 | USE | MES Stock | Product Level1 | 체크박스/다중 |  |  |  | Product Level1 | 체크박스/다중 |  |  |  |  |  |  |
| 1 | 1 | USE | MES Stock Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 2 | USE | MES Stock Detail | Box ID | 텍스트/단일 | 입력 |  |  | Box ID | 텍스트/단일 | 입력 |  |  |  |  |  |
| 3 | 3 | USE | MES Stock Detail | Product Level1 | 체크박스/다중 |  |  |  | Product Level1 | 체크박스/다중 |  |  |  |  |  |  |
| 1 | 1 | USE | Shipment Result | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Result | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 3 | 3 | USE | Shipment Result | Request Type | 텍스트/다중 | 검색 |  |  | Request Type | 텍스트/다중 | 검색 |  |  |  |  |  |
| 4 | 4 | USE | Shipment Result | Product Level1 | 체크박스/다중 |  |  |  | Product Level1 | 체크박스/다중 |  |  |  |  |  |  |

#### SSP0015 · Shipment Plan(Mobility & IT)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Plan(Mobility & IT) = SSP0015(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1052~1079행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.Bucket → 4.Total PSI → 5.Plan Date → 6.Period → 7.Model/Nickname → 8.My Model → 9.Part Leader → 10.Team Leader → 11.Delegatee Model — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Plan Date(그룹1) 가 Total PSI(그룹5) 뒤 · Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Shipment Plan Detail]**: 1.Period → 2.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: W/H stock]**: 1.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: W/H Stock Detail]**: 1.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: Hold Stock]**: 1.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: Hold Stock Detail]**: 1.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: Stock Detail]**: 1.Model/Nickname → 2.Lot ID — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: WH In Plan Detail]**: 1.Period → 2.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Shipment Result]**: 1.Period → 2.Model/Nickname → 3.Request Type — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Main | Div | 선택/단일 |  | O | 고정 (40) | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Main | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | Main | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | Main | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 | Sum | 체크박스/기타 |  |  |  | 공통기능화 검토 |  |  |
| 4 | 4 | USE | Main | Total PSI | 체크박스/단일 |  |  | 체크 시, 기능을 적용하여 재조회 | Total PSI | 체크박스/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | Main | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 6 | 6 | USE | Main | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 7 | 7 | USE | Main | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
|  |  | COMMON_REVIEW | Main | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  |  | 공통기능화 검토 |  |  |
| 8 | 8 | USE | Main | My Model | 체크박스/기타 |  |  | 조회 조건 Model PIC 담당자 | My Model | 체크박스/기타 |  |  |  |  |  |  |
| 9 | 9 | USE | Main | Part Leader | 체크박스/기타 |  |  | 조회 조건 Model PIC Part Leader | Part Leader | 체크박스/기타 |  |  |  |  |  |  |
| 10 | 10 | USE | Main | Team Leader | 체크박스/기타 |  |  | 조회 조건 Model PIC Team Leader | Team Leader | 체크박스/기타 |  |  |  |  |  |  |
| 11 | 11 | USE | Main | Delegatee Model | 체크박스/기타 |  |  | 조회 조건 Model PIC Delegatee Model | Delegatee Model | 체크박스/기타 |  |  |  |  |  |  |
|  |  | COMMON_BUTTON | Main | NoName_이미지3 | 버튼/기타 |  |  | 하단 프레임 Search버튼 | NoName_이미지3 | 버튼/기타 |  |  |  | 하단에 공통으로 들어가는 버튼 |  |  |
| 1 | 1 | USE | Shipment Plan Detail | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Plan Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | BUTTON | Shipment Plan Detail | Requestor | 버튼/기타 | 팝업 UserInfoPopup |  |  | Requestor | 버튼/기타 | 팝업 |  |  |  |  |  |
| 1 | 1 | USE | W/H stock | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | W/H Stock Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | Hold Stock |  |  |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 | 조회조건 추가 여부 검토 필요 |  |
| 1 | 1 | USE | Hold Stock Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | Stock Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 2 | USE | Stock Detail | Lot ID | 텍스트/단일 | 입력 |  |  | Lot ID | 텍스트/단일 | 입력 |  |  |  |  |  |
| 1 | 1 | USE | WH In Plan Detail | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | WH In Plan Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | Shipment Result | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Result | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 3 | 3 | USE | Shipment Result | Request Type | 텍스트/다중 | 검색 |  |  | Request Type | 텍스트/다중 | 검색 |  |  |  |  |  |

#### SSP0026 · Shipment Request(Mobility & IT)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Request(Mobility & IT) = SSP0026(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1080~1100행

**하네스 적용 순서**: 1.Div → 2.Team → 3.End Customer → 4.Sales Site → 5.Period → 6.PJT → 7.Model/Nickname → 8.From Site → 9.Bucket — 시트 확정 순서

정렬원칙 대비(참고): 차이 — PJT(그룹3) 가 Period(그룹4) 뒤 · From Site(그룹2) 가 Model/Nickname(그룹3) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Shipment Reuqest Detail]**: 1.Period → 2.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Shipment Request Result]**: 1.Period → 2.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Main | Div | 선택/단일 |  | O | 고정 (40) | Div | 선택/단일 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | Main | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 공통기능화 검토 |  |  |
| 2 | 2 | USE | Main | Team | 선택/다중 |  |  |  | Team | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | Main | End Customer | 선택/다중 |  |  |  | End Customer | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Main | Sales Site | 선택/다중 | 검색 |  | ALL(좌) End Customer와 연동 | Sales Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | Main | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 6 | 6 | USE | Main | Project | 텍스트/다중 |  |  |  | PJT | 텍스트/다중 | 팝업 프2 |  |  | 명칭 |  |  |
| 7 | 7 | USE | Main | Model | 텍스트/단일 |  |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/유형/팝업 |  |  |
|  |  | COMMON_REVIEW | Main | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  |  | 공통기능화 검토 |  |  |
| 8 | 8 | USE | Main | Plant Site | 선택/다중 | 검색 |  | Pack Tab과 Cell Tab에 따라 다른 결과 | From Site | 선택/다중 | 검색 | ALL버튼 |  |  | 명칭 Plant Site → From Site 검토 |  |
| 9 | 9 | USE | Main | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | BUTTON | Main | Upload (이미지) | 버튼/기타 |  |  | Excel 데이터 Upload | Upload (이미지) | 버튼/기타 |  |  |  |  |  |  |
|  |  | BUTTON | Main | Excel From (이미지) | 버튼/기타 |  |  | 업로드 데이터 양식 다운로드 | Excel From (이미지) | 버튼/기타 |  |  |  |  |  |  |
|  |  | COMMON_BUTTON | Main | NoName_이미지3 | 버튼/기타 |  |  | 하단 프레임 Search버튼 | NoName_이미지3 | 버튼/기타 |  |  |  | 하단에 공통으로 들어가는 버튼 |  |  |
| 1 | 1 | USE | Shipment Reuqest Detail | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Reuqest Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 2 | 2 | MERGED | Shipment Reuqest Detail | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
|  |  | REVIEW | Shipment Reuqest Detail | Requestor | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |  |  |  |  |  |
| 2 | 2 | USE | Shipment Reuqest Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | USE | Shipment Request Result | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Request Result | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |

#### SSP0023 · Shipment Plan(Electrode)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Plan(Electrode) = SSP0023(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1101~1134행

**하네스 적용 순서**: 1.Div → 2.Company → 3.From Site → 4.Bucket → 5.UOM → 6.Cell → 7.Pancake m → 8.Including Past Period → 9.Plan Date → 10.Period → 11.Material → 12.Model/Nickname → 13.My Model → 14.Part Leader → 15.Team Leader → 16.Delegatee Model — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Plan Date(그룹1) 가 Including Past Period(그룹5) 뒤 · Material(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Shipment Plan Detail]**: 1.Period → 2.Material → 3.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Material(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Stock Detail]**: 1.Model/Nickname → 2.Lot ID — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: Shipment Result]**: 1.Period → 2.Material → 3.Request Type — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Material(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Main | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Main | Company | 선택/단일 | 검색 | O | ALL 없음 | Company | 선택/단일 | 검색 | ALL없음 |  |  |  |  |
| 3 | 3 | USE | Main | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Main | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | Main | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 공통기능화 검토 |  |  |
| 5 | 5 | USE | Main | UOM | 라디오버튼/단일 |  |  | UOM Type 3중 택 1 | UOM | 라디오버튼/단일 |  |  |  |  |  |  |
| 6 | 6 | USE | Main | Cell | 라디오버튼/단일 |  |  | UOM Type 3중 택 1 | Cell | 라디오버튼/단일 |  |  |  |  |  |  |
| 7 | 7 | USE | Main | Pancake m | 라디오버튼/단일 |  |  | UOM Type 3중 택 1 | Pancake m | 라디오버튼/단일 |  |  |  |  |  |  |
| 8 | 8 | USE | Main | Including Past Period | 체크박스/단일 |  |  |  | Including Past Period | 체크박스/단일 |  |  | X |  |  |  |
| 9 | 9 | USE | Main | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 10 | 10 | USE | Main | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 11 | 11 | USE | Main | Material | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 12 | 12 | MERGED | Main | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 12 | 12 | USE | Main | Model | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 / | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | COMMON_REVIEW | Main | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  |  | 공통기능화 검토 |  |  |
| 13 | 13 | USE | Main | My Model | 체크박스/기타 |  |  | 조회 조건 Model PIC 담당자 | My Model | 체크박스/기타 |  |  |  |  |  |  |
| 14 | 14 | USE | Main | Part Leader | 체크박스/기타 |  |  | 조회 조건 Model PIC Part Leader | Part Leader | 체크박스/기타 |  |  |  |  |  |  |
| 15 | 15 | USE | Main | Team Leader | 체크박스/기타 |  |  | 조회 조건 Model PIC Team Leader | Team Leader | 체크박스/기타 |  |  |  |  |  |  |
| 16 | 16 | USE | Main | Delegatee Model | 체크박스/기타 |  |  | 조회 조건 Model PIC Delegatee Model | Delegatee Model | 체크박스/기타 |  |  |  |  |  |  |
|  |  | BUTTON | Main | Upload (이미지) | 버튼/기타 |  |  | Excel 데이터 Upload | Upload (이미지) | 버튼/기타 |  |  |  |  |  |  |
|  |  | BUTTON | Main | Excel From (이미지) | 버튼/기타 |  |  | 업로드 데이터 양식 다운로드 | Excel From (이미지) | 버튼/기타 |  |  |  |  |  |  |
|  |  | REVIEW | Main | NoName_이미지2 | 버튼/기타 |  |  | Simulation 기능 |  |  |  |  |  | 용도 재확인 |  |  |
|  |  | COMMON_BUTTON | Main | NoName_이미지3 | 버튼/기타 |  |  | 하단 프레임 Search버튼 | NoName_이미지3 | 버튼/기타 |  |  |  | 하단에 공통으로 들어가는 버튼 |  |  |
| 1 | 1 | USE | Shipment Plan Detail | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Plan Detail | Material | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 3 | 3 | MERGED | Shipment Plan Detail | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 3 | 3 | USE | Shipment Plan Detail | Model | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 / | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | REVIEW | Shipment Plan Detail | Requestor | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |  |  |  |  |  |
| 1 | 1 | USE | Stock Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | MERGED | Stock Detail | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 2 | 2 | USE | Stock Detail | Lot ID | 텍스트/단일 | 입력 |  |  | Lot ID | 텍스트/단일 | 입력 |  |  |  |  |  |
| 1 | 1 | USE | Shipment Result | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Result | Material | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 3 | 3 | USE | Shipment Result | Request Type | 텍스트/다중 | 검색 |  |  | Request Type | 텍스트/다중 | 검색 |  |  |  |  |  |

#### SSP0022 · Shipment Request(Electrode)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Request(Electrode) = SSP0022(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1135~1165행

**하네스 적용 순서**: 1.Div → 2.Company → 3.From Site → 4.Cell Type → 5.Bucket → 6.UOM → 7.Cell → 8.Pancake m → 9.Including Past Period → 10.Plan Date → 11.Period → 12.Material → 13.Model/Nickname → 14.My Model → 15.Part Leader → 16.Team Leader → 17.Delegatee Model — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Plan Date(그룹1) 가 Including Past Period(그룹5) 뒤 · Material(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

**하네스 적용 순서 [영역: Stock Detail]**: 1.Model/Nickname → 2.Lot ID — 시트 확정 순서

정렬원칙 대비(참고): 일치

**하네스 적용 순서 [영역: Shipment Plan Detail]**: 1.Period → 2.Material → 3.Model/Nickname — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Material(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | Main | Div | 선택/단일 |  | O |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | Main | Company | 선택/단일 | 검색 | O | ALL 없음 | Company | 선택/단일 | 검색 | ALL없음 |  |  |  |  |
| 3 | 3 | USE | Main | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | Main | Cell Type | 선택/단일 | 검색 |  |  | Cell Type | 선택/단일 | 검색 |  |  |  |  |  |
| 5 | 5 | USE | Main | Bucket | 선택/단일 |  |  | 조회화면 변경 기능_Daily/Weekly/Monthly | Bucket | 선택/단일 |  |  |  |  |  |  |
|  |  | COMMON_REVIEW | Main | Sum | 체크박스/기타 |  |  | 조회화면 변경 기능_Bucket 조회조건과 연동 |  |  |  |  |  | 공통기능화 검토 |  |  |
| 6 | 6 | USE | Main | UOM | 라디오버튼/단일 |  |  | UOM Type 3중 택 1 | UOM | 라디오버튼/단일 |  |  |  |  |  |  |
| 7 | 7 | USE | Main | Cell | 라디오버튼/단일 |  |  | UOM Type 3중 택 1 | Cell | 라디오버튼/단일 |  |  |  |  |  |  |
| 8 | 8 | USE | Main | Pancake m | 라디오버튼/단일 |  |  | UOM Type 3중 택 1 | Pancake m | 라디오버튼/단일 |  |  |  |  |  |  |
| 9 | 9 | USE | Main | Including Past Period | 체크박스/단일 |  |  |  | Including Past Period | 체크박스/단일 |  |  | X |  |  |  |
| 10 | 10 | USE | Main | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |
| 11 | 11 | USE | Main | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 12 | 12 | USE | Main | Material | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 13 | 13 | MERGED | Main | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 13 | 13 | USE | Main | Model | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 / | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | COMMON_REVIEW | Main | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  | Measure 추가/제거 기능 | NoName_이미지1 | 버튼/기타 | 팝업 Measure Setting |  |  | 공통기능화 검토 |  |  |
| 14 | 14 | USE | Main | My Model | 체크박스/기타 |  |  | 조회 조건 Model PIC 담당자 | My Model | 체크박스/기타 |  |  |  |  |  |  |
| 15 | 15 | USE | Main | Part Leader | 체크박스/기타 |  |  | 조회 조건 Model PIC Part Leader | Part Leader | 체크박스/기타 |  |  |  |  |  |  |
| 16 | 16 | USE | Main | Team Leader | 체크박스/기타 |  |  | 조회 조건 Model PIC Team Leader | Team Leader | 체크박스/기타 |  |  |  |  |  |  |
| 17 | 17 | USE | Main | Delegatee Model | 체크박스/기타 |  |  | 조회 조건 Model PIC Delegatee Model | Delegatee Model | 체크박스/기타 |  |  |  |  |  |  |
|  |  | BUTTON | Main | Upload (이미지) | 버튼/기타 |  |  | Excel 데이터 Upload | Upload (이미지) | 버튼/기타 |  |  |  |  |  |  |
|  |  | BUTTON | Main | Excel From (이미지) | 버튼/기타 |  |  | 업로드 데이터 양식 다운로드 | Excel From (이미지) | 버튼/기타 |  |  |  |  |  |  |
|  |  | COMMON_BUTTON | Main | NoName_이미지3 | 버튼/기타 |  |  | 하단 프레임 Search버튼 | NoName_이미지3 | 버튼/기타 |  |  |  | 하단에 공통으로 들어가는 버튼 |  |  |
| 1 | 1 | USE | Stock Detail | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 1 | 1 | MERGED | Stock Detail | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 2 | 2 | USE | Stock Detail | Lot ID | 텍스트/단일 | 입력 |  |  | Lot ID | 텍스트/단일 | 입력 |  |  |  |  |  |
| 1 | 1 | USE | Shipment Plan Detail | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 2 | 2 | USE | Shipment Plan Detail | Material | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 | Material | 텍스트/다중 | 팝업 메1 |  |  |  |  |  |
| 3 | 3 | MERGED | Shipment Plan Detail | NickName | 텍스트/다중 |  |  |  | Model/Nickname |  |  |  |  | 조회조건 삭제 | Model/Nick Name 통합 |  |
| 3 | 3 | USE | Shipment Plan Detail | Model | 텍스트/다중 | 팝업 Item by DivisionPopup 아2 |  | 전극만 나옴 / | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
|  |  | BUTTON | Shipment Plan Detail | Requestor | 버튼/기타 | 팝업 UserInfoPopup |  |  | Requestor | 버튼/기타 | 팝업 |  |  |  |  |  |

#### SSP0012 · Shipment Plan Detail  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Plan Detail = SSP0012(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1176~1180행

**하네스 적용 순서**: 1.Div → 2.Model/Nickname → 3.Period → 4.Sold To Party → 5.Ship to Party — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Sold To Party(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 3 | 3 | USE | - | Period | 텍스트/단일 | 달력 | O | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 4 | 4 | USE | - | Sold To Party | 텍스트/단일 | 입력 |  | ALL(우) | Sold To Party | 텍스트/단일 | 입력 |  |  |  |  |  |
| 5 | 5 | USE | - | Ship to Party | 텍스트/단일 | 입력 |  | ALL(우) | Ship to Party | 텍스트/단일 | 입력 |  |  |  |  |  |

#### SSP0019 · Shipment Change History  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Change History = SSP0019(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1181~1190행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.To Site → 4.Incoterms → 5.Period → 6.Model/Nickname → 7.SO No → 8.Confirm Id → 9.TransportMode → 10.Delegatee Model — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Period(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | From Site | 선택/다중 |  |  |  | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | To Site | 선택/다중 |  |  |  | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Incoterms | 선택/다중 | 선택 |  | ALL(좌) | Incoterms | 선택/다중 | 선택 | ALL버튼 |  |  |  |  |
| 5 | 5 | USE | - | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Period | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 6 | 6 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 7 | 7 | USE | - | SO No | 텍스트/단일 | 입력 |  |  | SO No | 텍스트/단일 | 입력 |  |  |  |  |  |
| 8 | 8 | USE | - | Confirm Id | 텍스트/단일 | 입력 |  |  | Confirm Id | 텍스트/단일 | 입력 |  |  |  |  |  |
| 9 | 9 | USE | - | TransportMode | 선택/다중 | 선택 |  |  | TransportMode | 선택/다중 | 선택 |  |  |  |  |  |
| 10 | 10 | USE | - | Current | 체크박스/기타 |  |  |  | Delegatee Model | 체크박스/기타 |  |  |  |  |  |  |

#### SSP0017 · Inventory Raw(Mobility  & IT)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Inventory Raw(Mobility  & IT) = SSP0017(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1191~1195행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.Model/Nickname → 4.Inventory Type → 5.Plan Date — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Plan Date(그룹1) 가 Inventory Type(그룹5) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  | 40 소형 고정 | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | Plant Site | 선택/다중 | 검색 |  |  | From Site | 선택/다중 | 검색 | ALL버튼 |  |  | 명칭 Plant Site → From Site 검토 |  |
| 3 | 3 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 4 | 4 | USE | - | Inventory Type | 선택/단일 |  |  |  | Inventory Type | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Plan date | 선택/단일 |  | O |  | Plan Date | 선택/단일 |  |  |  |  |  |  |

#### SSP0200 · Shipment Change Request  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Change Request = SSP0200(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1196~1216행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.To Site → 4.Status → 5.Single Process → 6.Shipment Date → 7.Model/Nickname → 8.SO No → 9.Confirm Id → 10.Requestor → 11.Dept Name → 12.Approval → 13.Title → 14.Change Reason → 15.Reason Detail — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Model/Nickname(그룹3) 가 Shipment Date(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(좌) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Status | 선택/단일 |  |  |  | Status | 선택/단일 |  |  |  |  |  |  |
|  |  | BUTTON | - | NoName_이미지1 (New버튼) | 버튼/기타 | 기능 |  | Insert 펑션은 선택했던 행의 내용을 복사를 함 / New버튼은 빈 행 삽입 | NoName_이미지1 | 버튼/기타 |  |  |  |  |  |  |
|  |  | BUTTON | - | NoName_이미지2 (Insert Multi 버튼) | 버튼/기타 | 기능 |  | Insert 펑션을 여러 개 반복 수행 입력함 | NoName_이미지2 (Insert Multi 버튼) | 버튼/기타 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Single Process | 체크박스/단일 | 기능 |  | 추가확인중 Request ID를 한번에 할건지 하나만 할 건지… | Single Process | 체크박스/단일 | 기능 |  |  |  |  |  |
| 6 | 6 | USE | - | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 7 | 7 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 8 | 8 | USE | - | SO No | 텍스트/단일 | 입력 |  |  | SO No | 텍스트/단일 | 입력 |  |  |  |  |  |
| 9 | 9 | USE | - | Confirm Id | 텍스트/단일 | 입력 |  |  | Confirm Id | 텍스트/단일 | 입력 |  |  |  |  |  |
| 10 | 10 | USE | - | Requestor | 텍스트/- | - |  | 본인 아이디 (자동입력) / 수정불가 | Requestor | 텍스트/- | - |  |  |  |  |  |
| 11 | 11 | USE | - | Dept Name | 텍스트/- | - |  | 본인 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
| 12 | 12 | USE | - | Approval | 텍스트/- | - | O | 승인 아이디(자동입력) / 수정불가 | Approval | 텍스트/- | - |  |  |  |  |  |
| 11 | 11 | USE | - | Dept Name | 텍스트/- | - |  | 승인 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
|  |  | BUTTON | - | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  | Approval과 Dept Name 입력대상 검색 | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |
| 13 | 13 | USE | - | Title | 텍스트/단일 | 입력 | O |  | Title | 텍스트/단일 | 입력 | O |  |  | 제거 검토 |  |
| 14 | 14 | USE | - | Change Reason | 텍스트/단일 | 입력 | O |  | Change Reason | 텍스트/단일 | 입력 | O |  |  | 제거 검토 |  |
| 15 | 15 | USE | - | Reason Detail | 선택/단일 |  | O |  | Reason Detail | 선택/단일 |  | O |  |  |  |  |
|  |  | BUTTON | - | Request Complete | 버튼/기타 | 기능 |  |  | Request Complete | 버튼/기타 | 기능 |  |  |  |  |  |
|  |  | BUTTON | - | Cancel | 버튼/기타 | 기능 |  |  | Cancel | 버튼/기타 | 기능 |  |  |  |  |  |

#### SSP0201 · Shipment Change Request(Packer)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Change Request(Packer) = SSP0201(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1217~1234행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.To Site → 4.Status → 5.Shipment Date → 6.Model/Nickname → 7.Confirm Id → 8.Requestor → 9.Dept Name → 10.Approval → 11.Title → 12.Change Reason → 13.Reason Detail — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Shipment Date(그룹4) 가 Status(그룹5) 뒤 · Model/Nickname(그룹3) 가 Shipment Date(그룹4) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  | 40 소형 고정 | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | From Site | 선택/다중 | 검색 |  | 40 소형 + 외주임가공만 (외주임가공 플래그) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | To Site | 선택/다중 | 검색 |  | ALL(좌) | To Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 4 | 4 | USE | - | Status | 선택/단일 |  |  |  | Status | 선택/단일 |  |  |  |  |  |  |
|  |  | BUTTON | - | NoName_이미지1 (New버튼) | 버튼/기타 | 기능 |  | Insert 펑션은 선택했던 행의 내용을 복사를 함 / New버튼은 빈 행 삽입 | NoName_이미지1 | 버튼/기타 |  |  |  |  | Insert 기능은 복사를 함 / New버튼은 빈 행 삽입 |  |
| 5 | 5 | USE | - | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Shipment Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 6 | 6 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 7 | 7 | USE | - | Confirm Id | 텍스트/단일 | 입력 |  |  | Confirm Id | 텍스트/단일 | 입력 |  |  |  |  |  |
| 8 | 8 | USE | - | Requestor | 텍스트/- | - |  | 본인 아이디 (자동입력) / 수정불가 | Requestor | 텍스트/- | - |  |  |  |  |  |
| 9 | 9 | USE | - | Dept Name | 텍스트/- | - |  | 본인 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
| 10 | 10 | USE | - | Approval | 텍스트/- | - |  | 승인 아이디(자동입력) / 수정불가 | Approval | 텍스트/- | - |  |  |  |  |  |
| 9 | 9 | USE | - | Dept Name | 텍스트/- | - |  | 승인 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
|  |  | BUTTON | - | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  | Approval과 Dept Name 입력대상 검색 | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |
| 11 | 11 | USE | - | Title | 텍스트/단일 | 입력 | O |  | Title | 텍스트/단일 | 입력 | O |  |  | 제거 검토 |  |
| 12 | 12 | USE | - | Change Reason | 텍스트/단일 | 입력 | O |  | Change Reason | 텍스트/단일 | 입력 | O |  |  | 제거 검토 |  |
| 13 | 13 | USE | - | Reason Detail | 선택/단일 |  | O |  | Reason Detail | 선택/단일 |  | O |  |  |  |  |
|  |  | BUTTON | - | Request Complete | 버튼/기타 | 기능 |  |  | Request Complete | 버튼/기타 | 기능 |  |  |  |  |  |
|  |  | BUTTON | - | Cancel | 버튼/기타 | 기능 |  |  | Cancel | 버튼/기타 | 기능 |  |  |  |  |  |

#### SSP0003 · Shipment Change Request Confirm  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Change Request Confirm = SSP0003(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1235~1253행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.Status → 4.Request Date → 5.Requestor → 6.Model/Nickname → 7.Change Type → 8.Dept Name → 9.Approval → 10.Title → 11.Change Reason → 12.Reason Detail → 13.Reject Reason — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Request Date(그룹4) 가 Status(그룹5) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  |  |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | From Site | 선택/다중 | 검색 |  | ALL(좌) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Status | 선택/단일 |  |  |  | Status | 선택/단일 |  |  |  |  |  |  |
|  |  | BUTTON | - | Approval | 버튼/기타 | 기능 |  | 기능 (승인아이디가 시스템을 켠 사람과 동일해야 나타남) | Approval | 버튼/기타 | 기능 |  |  |  |  |  |
|  |  | BUTTON | - | Reject | 버튼/기타 | 기능 |  | 기능 (승인아이디가 시스템을 켠 사람과 동일해야 나타남) | Reject | 버튼/기타 | 기능 |  |  |  |  |  |
|  |  | BUTTON | - | Self Reject | 버튼/기타 | 기능 |  | 기능 (요청아이디가 시스템을 켠 사람과 동일해야 나타남) | Self Reject | 버튼/기타 | 기능 |  |  |  |  |  |
| 4 | 4 | USE | - | Request Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Request Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 5 | 5 | USE | - | Requestor | 텍스트/- | - |  | 본인 아이디 (자동입력) / 수정불가 | Requestor | 텍스트/- | - |  |  |  |  |  |
|  |  | BUTTON | - | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  | Approval과 Dept Name 입력대상 검색 | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |
| 6 | 6 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 7 | 7 | USE | - | Change Type | 선택/단일 |  |  |  | Change Type | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Requestor | 텍스트/- | - |  | 요청 아이디 (자동입력) / 수정불가 | Requestor | 텍스트/- | - |  |  |  |  |  |
| 8 | 8 | USE | - | Dept Name | 텍스트/- | - |  | 요청 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
| 9 | 9 | USE | - | Approval | 텍스트/- | - |  | 승인 아이디(자동입력) / 수정불가 | Approval | 텍스트/- | - |  |  |  |  |  |
| 8 | 8 | USE | - | Dept Name | 텍스트/- | - |  | 승인 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
| 10 | 10 | USE | - | Title | 텍스트/단일 | - |  | 자동입력 표시 | Title | 텍스트/단일 | 입력 | O |  |  | 제거 검토 (둘 중 하나) |  |
| 11 | 11 | USE | - | Change Reason | 텍스트/단일 | - |  | 자동입력 표시 | Change Reason | 텍스트/단일 | 입력 | O |  |  | 제거 검토 (둘 중 하나) |  |
| 12 | 12 | USE | - | Reason Detail | 선택/단일 | - |  | 자동입력 표시 | Reason Detail | 선택/단일 |  | O |  |  |  |  |
| 13 | 13 | USE | - | Reject Reason | 텍스트/단일 | 입력 | O | Reject 버튼을 누를시 필수 | Reject Reason | 텍스트/단일 | 입력 | O |  |  |  |  |

#### SSP0202 · Shipment Change Request Confirm(Packer)  <sub>Shipping › Shipping Schedule</sub>

매핑: AS-IS 메뉴 Shipping Schedule›Shipment Change Request Confirm(Packer) = SSP0202(UseYN=Y) · 원천 SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx 1254~1272행

**하네스 적용 순서**: 1.Div → 2.From Site → 3.Status → 4.Request Date → 5.Requestor → 6.Model/Nickname → 7.Change Type → 8.Dept Name → 9.Approval → 10.Title → 11.Change Reason → 12.Reason Detail → 13.Reject Reason — 시트 확정 순서

정렬원칙 대비(참고): 차이 — Request Date(그룹4) 가 Status(그룹5) 뒤 (SSP 는 시트 순서가 확정본)

| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | USE | - | Div | 선택/단일 |  | 40 소형 고정 |  | Div | 선택/단일 |  |  |  |  |  |  |
| 2 | 2 | USE | - | From Site | 선택/다중 | 검색 | 40 소형 + 외주임가공만 표기 | 40 소형 + 외주임가공만 (외주임가공 플래그) | From Site | 선택/다중 | 검색 | ALL버튼 |  |  |  |  |
| 3 | 3 | USE | - | Status | 선택/단일 |  |  |  | Status | 선택/단일 |  |  |  |  |  |  |
|  |  | BUTTON | - | Approval | 버튼/기타 | 기능 |  | 기능 (승인아이디가 시스템을 켠 사람과 동일해야 나타남) | Approval | 버튼/기타 | 기능 |  |  |  |  |  |
|  |  | BUTTON | - | Reject | 버튼/기타 | 기능 |  | 기능 (승인아이디가 시스템을 켠 사람과 동일해야 나타남) | Reject | 버튼/기타 | 기능 |  |  |  |  |  |
|  |  | BUTTON | - | Self Reject | 버튼/기타 | 기능 |  | 기능 (요청아이디가 시스템을 켠 사람과 동일해야 나타남) | Self Reject | 버튼/기타 | 기능 |  |  |  |  |  |
| 4 | 4 | USE | - | Request Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD | Request Date | 텍스트/단일 | 달력 |  | YYYY-MM-DD |  |  |  |
| 5 | 5 | USE | - | Requestor | 텍스트/- | - |  | 본인 아이디 (자동입력) / 수정불가 | Requestor | 텍스트/- | - |  |  |  |  |  |
|  |  | BUTTON | - | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  | Approval과 Dept Name 입력대상 검색 | NoName_이미지3 (돋보기버튼) | 버튼/기타 | 팝업 UserInfoPopup |  |  |  |  |  |
| 6 | 6 | USE | - | Model | 텍스트/다중 | 팝업 Model by DivisionPopup 모1 |  |  | Model/Nickname | 텍스트/다중 | 팝업 메1 |  |  | 명칭/팝업 |  |  |
| 7 | 7 | USE | - | Change Type | 선택/단일 |  |  |  | Change Type | 선택/단일 |  |  |  |  |  |  |
| 5 | 5 | USE | - | Requestor | 텍스트/- | - |  | 요청 아이디 (자동입력) / 수정불가 | Requestor | 텍스트/- | - |  |  |  |  |  |
| 8 | 8 | USE | - | Dept Name | 텍스트/- | - |  | 요청 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
| 9 | 9 | USE | - | Approval | 텍스트/- | - |  | 승인 아이디(자동입력) / 수정불가 | Approval | 텍스트/- | - |  |  |  |  |  |
| 8 | 8 | USE | - | Dept Name | 텍스트/- | - |  | 승인 부서 (자동입력) / 수정불가 | Dept Name | 텍스트/- | - |  |  |  |  |  |
| 10 | 10 | USE | - | Title | 텍스트/단일 | - |  | 자동입력 표시 | Title | 텍스트/단일 | 입력 | O |  |  | 제거 검토 (둘 중 하나) |  |
| 11 | 11 | USE | - | Change Reason | 텍스트/단일 | - |  | 자동입력 표시 | Change Reason | 텍스트/단일 | 입력 | O |  |  | 제거 검토 (둘 중 하나) |  |
| 12 | 12 | USE | - | Reason Detail | 선택/단일 | - |  | 자동입력 표시 | Reason Detail | 선택/단일 |  | O |  |  |  |  |
| 13 | 13 | USE | - | Reject Reason | 텍스트/단일 | 입력 | O | Reject 버튼을 누를시 필수 | Reject Reason | 텍스트/단일 | 입력 | O |  |  |  |  |
