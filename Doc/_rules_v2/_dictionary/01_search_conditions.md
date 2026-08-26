# 조회조건 지식사전 (항목 축)
> **스냅샷** 2026-08-21 · **AS-IS 원천** DEV / LGCE_SCMDEV
> **재생성** `_artifacts/_diagnostics/ui_meta_dictionary_20260821/` (01~05 실행 후 07_build_outputs.py)
> ⚠ 이 파일은 생성물이다. 직접 수정하지 말고 파이프라인을 고쳐 재생성한다.
>
> 신규/보완 화면의 조회조건 작성 전 해당 항목 행을 대조한다 (hook #112 와 병행).

## 0. 읽는 법
- **binding**: `ARG`=콤보 SQL 이 `@토큰` 요구(FE 전달 의무·미전달 시 조용한 0행) / `CASCADE`=상위 변경 시 하위 재조회·reset / `FILTER`=전량 fetch 후 클라 필터.
- **우선순위**: primary = ARG > CASCADE > FILTER (ARG 미전달은 조용한 0행이라 발견이 가장 늦다)
- **division**: MATRIX 원천이 40/81/82 3분기만 구분한다. 81_UC/81_HM 등 세부는 raw 서술에만 남는다.
- **근거**: 1차 DMF 13UI 조회조건 MATRIX v1.0 (extract/*.json 154조건) / 2차 search_conditions_scp_dm.md 953행/99화면 (2026-01-22 스냅샷) / 콤보 SCM_ADM_CMBO_SQL_M 167건 실덤프
- **TO-BE 공용 필드** 13종: BizTypeField, BucketField, DivisionField, EndCustomerField, ItemField, OwnerField, PeriodField, PlantSiteField, ProjectField, SalesSiteField, SearchOverRangeField, TeamField, VersionField

## 1. 항목 표준 (전 34종)

| # | 조회조건 | 사용 UI | TO-BE 필드 | binding | 콤보(CMBO) | @토큰 | div40 | div81 | div82 | 카탈로그 화면 |
|---:|---|---:|---|---|---|---|---|---|---|---:|
| 1 | **Div.** | 13 | DivisionField | `CASCADE` | MyDivision | @sesUserId | 화면별 상이(미사용,사용,조건부) | 사용 | 화면별 상이(사용,조건부) | 85 |
| 2 | **Team** | 13 | TeamField | `화면별 상이(ARG,미확인(cascade·filter·params 서술 부재))` | TeambyDivision, UserTeamByDivision | @Param1, @divisionId, @langCd, @sesUserId | 화면별 상이(사용,조건부,해당없음) | 화면별 상이(사용,해당없음) | 화면별 상이(사용,해당없음) | 20 |
| 3 | **End Customer** | 13 | EndCustomerField | `CASCADE` | EndCustomer, EndCustomerByDivision, EndCustomerByDivision40 | @sesUserId | 화면별 상이(미사용,사용,조건부) | 화면별 상이(사용,조건부) | 사용 | 19 |
| 4 | **Sold Customer** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `CASCADE` | SoldCustomer | - | 사용 | 사용 | 사용 | 0 |
| 5 | **Sales Site** | 13 | SalesSiteField | `화면별 상이(ARG,CASCADE,FILTER)` | SalesSite, ScmSitebyEndCustomer40, SiteByEndCustomer, UserSiteByEndCustomer | @deptId, @divisionId, @endCustomer, @sesUserId | 화면별 상이(사용,조건부) | 화면별 상이(사용,조건부) | 화면별 상이(사용,조건부) | 21 |
| 6 | **Plant Site** | 8 | PlantSiteField | `ARG` | PlantSitebyEndCustomer | @divisionId, @endCustomer | 화면별 상이(미사용,조건부) | 화면별 상이(사용,조건부) | 화면별 상이(미사용,사용,조건부) | 31 |
| 7 | **PJT** | 11 | ProjectField | `화면별 상이(CASCADE,FILTER)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 미사용 | 사용 | 사용 | 22 |
| 8 | **Model/Nickname** | 11 | ItemField | `화면별 상이(CASCADE,FILTER)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 63 |
| 9 | **Customer PJT** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `해당없음(텍스트)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 1 |
| 10 | **Customer Model** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `해당없음(텍스트)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 1 |
| 11 | **Item Type** | 4 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `화면별 상이(CASCADE,FILTER)` | ItemType | - | 사용 | 사용 | 사용 | 11 |
| 12 | **Biz. Type** | 6 | BizTypeField | `화면별 상이(ARG,CASCADE)` | BizType, BizTypeByDivision, BizTypebyDivision | @divisionId | 화면별 상이(사용,조건부) | 화면별 상이(사용,조건부) | 사용 | 13 |
| 13 | **Data Type** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `FILTER` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 2 |
| 14 | **Bucket** | 8 | BucketField | `CASCADE` | BucketType, BucketType2 | - | 사용 | 사용 | 화면별 상이(미사용,사용) | 34 |
| 15 | **Period** | 8 | PeriodField | `해당없음(달력)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 49 |
| 16 | **Ver.** | 3 | VersionField | `화면별 상이(CASCADE,FILTER)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 18 |
| 17 | **Owner** | 7 | OwnerField | `화면별 상이(CASCADE,FILTER)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 12 |
| 18 | **Sender Code** | 2 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `CASCADE` | SenderCode | - | 미사용 | 화면별 상이(사용,조건부) | 미사용 | 3 |
| 19 | **DOM/EXP** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `FILTER` | DOM_EXP | - | 사용 | 사용 | 사용 | 0 |
| 20 | **Active(YesOrNo)** | 4 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `FILTER` | YesOrNo | - | 사용 | 사용 | 사용 | 0 |
| 21 | **Search Over Range** | 1 | SearchOverRangeField | `해당없음(체크박스)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 0 |
| 22 | **Detail** | 2 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `해당없음(체크박스)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 화면별 상이(미사용,사용) | 사용 | 사용 | 0 |
| 23 | **End Customer(Report) Null** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `미확인(cascade·filter·params 서술 부재)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 해당없음 | 해당없음 | 해당없음 | 0 |
| 24 | **Project Null** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `미확인(cascade·filter·params 서술 부재)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 해당없음 | 해당없음 | 해당없음 | 0 |
| 25 | **Sum(체크)** | 5 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `화면별 상이(미확인(cascade·filter·params 서술 부재),해당없음(체크박스))` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 화면별 상이(사용,해당없음) | 화면별 상이(사용,해당없음) | 화면별 상이(사용,해당없음) | 0 |
| 26 | **Color(체크)** | 3 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `미확인(cascade·filter·params 서술 부재)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 해당없음 | 해당없음 | 해당없음 | 0 |
| 27 | **Qty≥0(체크)** | 2 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `해당없음(체크박스)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 0 |
| 28 | **Qty≠0(체크)** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `미확인(cascade·filter·params 서술 부재)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 해당없음 | 해당없음 | 해당없음 | 0 |
| 29 | **Cell Qty(체크)** | 3 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `화면별 상이(미확인(cascade·filter·params 서술 부재),해당없음(체크박스))` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 화면별 상이(사용,해당없음) | 화면별 상이(미사용,해당없음) | 화면별 상이(미사용,해당없음) | 0 |
| 30 | **Include Internal Txn(체크)** | 2 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `미확인(cascade·filter·params 서술 부재)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 해당없음 | 해당없음 | 해당없음 | 0 |
| 31 | **AS(체크)** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `FILTER` | MktFcstWsPlannerYn | @sesUserId | 사용 | 사용 | 사용 | 0 |
| 32 | **MKT FCST 미등록 제외(체크)** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `FILTER` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 사용 | 사용 | 사용 | 0 |
| 33 | **Price 미등록 제외(체크)** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `미확인(cascade·filter·params 서술 부재)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 해당없음 | 해당없음 | 해당없음 | 0 |
| 34 | **Closed(숨김)** | 1 | 미확인(공용 필드 미사용(화면 로컬 구현)) | `미확인(cascade·filter·params 서술 부재)` | 미확인(콤보 아님 또는 CMBO 미등록) | - | 해당없음 | 해당없음 | 해당없음 | 0 |

## 2. 항목별 화면 상세 (154 조건 전수)

### Div.  (13 UI · 실측(13UI)+카탈로그(85화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Div (LBL00501) | 콤보단일(DivisionField — CustomDropdown) | MyDivision | CASCADE | Y (DivisionField 내장 required) | session.div ?? '40'(DIVISION.MOBILITY) (store L136) | 조건부 | 사용 | 조건부 |
| DMF0004 | Div. (LBL00001) | 콤보단일(CustomDropdown) | MyDivision | CASCADE | Y(FormItem required) | session.div ?? '40' | 사용 | 사용 | 사용 |
| DMF0005 | Div. (LBL00001) | 콤보단일(CustomDropdown) | MyDivision | CASCADE | Y(FormItem required) | session.div ?? '40' | 미사용 | 사용 | 사용 |
| DMF0006 | Div. (LBL00001) | 콤보단일(CustomDropdown 인라인 — 카탈로그 DivisionField 미사용) | MyDivision | CASCADE | Y(암묵 — 단일콤보+기본값이라 공백 불가. AS-IS MSG00097 알림 로직은 미이식) | session.div ?? '40' | 미사용 | 사용 | 사용 |
| DMF0007 | Div. (LBL00001) | 콤보단일(CustomDropdown) | MyDivision | CASCADE | Y(FormItem required) | '81' (store 고정 초기값 — session.div 미사용) | 사용 | 사용 | 사용 |
| DMF0014 | Div. (LBL00001) | 콤보단일(CustomDropdown) | MyDivision | CASCADE | N (FormItem required 마크 없음 — SP 계약상 단일 필수. notes 참조) | session.div ?? '40' (store L47) | 사용 | 사용 | 사용 |
| DMF0020 | Div (LBL00501) | 콤보단일(DivisionField=CustomDropdown, required) | MyDivision | CASCADE | Y | DIVISION.MOBILITY='40' | 미사용 | 사용 | 조건부 |
| DMF0021 | Div (LBL00501) | 콤보단일(DivisionField→CustomDropdown) | MyDivision | CASCADE | Y (FormItem required) | session.div \|\| '40'(DIVISION.MOBILITY) + 미보유 division 자동보정(resolveDivisionAutoSelect) | 사용 | 사용 | 사용 |
| DMF0042 | Div (LBL00501) | 콤보단일(CustomDropdown) | MyDivision | CASCADE | Y (validateFind MSG00097) | DIVISION.MOBILITY='40' + resolveDivisionAutoSelect 미보유 division 자동 보정 | 조건부 | 사용 | 사용 |
| DMF0048 | Div. (LBL00001) | 콤보단일(CustomDropdown mandatory) | MyDivision | CASCADE | Y (mandatory + validateFind MSG00097 — SalesMonitoring.tsx L184-191) | session.div ?? '40' (store initSearch L97) | 사용 | 사용 | 사용 |
| DMF0072 | Div (LBL00663) | 콤보단일(CustomDropdown, required) | MyDivision | CASCADE | Y | '81' (store 초기값) — 권한 목록에 없으면 첫 옵션으로 자동 보정 | 미사용 | 사용 | 사용 |
| DMF0074 | Div. (LBL00001) | 콤보단일(CustomDropdown) | MyDivision | CASCADE | Y (FormItem required) | session.div ?? '40' (store L43) | 사용 | 사용 | 사용 |
| DMF0082 | Div (LBL00501, DivisionField) | 콤보단일(카탈로그 DivisionField — required, 미보유 division 자동보정) | MyDivision | CASCADE | Y — 빈값 MSG00667 alert(AS-IS MSG00097 대응) | '40' (initSearchParams) | 조건부 | 사용 | 조건부 |

### Team  (13 UI · 실측(13UI)+카탈로그(20화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Team (LBL00502) | 콤보다중(TeamField) | UserTeamByDivision | ARG | N | [] (store L137) | 사용 | 사용 | 사용 |
| DMF0004 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
| DMF0005 | Team (LBL00502, 카탈로그 TeamField) | 콤보다중(TeamField=CustomDropdown multiple+allOption) | TeambyDivision | ARG | N | ALL(빈 배열) | 사용 | 사용 | 사용 |
| DMF0006 | Team (LBL00044) | 콤보다중(CustomDropdown multiple allOption useClearIcon — 인라인) | TeambyDivision | ARG | N | 'ALL' | 사용 | 사용 | 사용 |
| DMF0007 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
| DMF0014 | Team (LBL00502) | 콤보다중(CustomDropdown, TeamField) | TeambyDivision | ARG | N | '' (store L48) | 사용 | 사용 | 사용 |
| DMF0020 | Team (LBL00502) | 콤보다중(TeamField=CustomDropdown multiple+allOption) | TeambyDivision | ARG | N | [](ALL) | 사용 | 사용 | 사용 |
| DMF0021 | Team (LBL00502) | 콤보다중(TeamField→CustomDropdown multiple+allOption) | TeambyDivision | ARG | N | [] (=ALL) | 사용 | 사용 | 사용 |
| DMF0042 | Team (LBL00502) | 콤보다중(CustomDropdown multiple allOption) | UserTeamByDivision | ARG | N | [] (빈 배열 → setFilter 'ALL' sentinel) | 조건부 | 사용 | 사용 |
| DMF0048 | Team (LBL00044) | 콤보다중(CustomDropdown multiple allOption) — 단일선택+ALL 운용 | TeambyDivision | ARG | N | [] (ALL) | 사용 | 사용 | 사용 |
| DMF0072 | Team (LBL00502, TeamField) | 콤보다중(TeamField=CustomDropdown multiple+allOption) | TeambyDivision | ARG | N | ALL | 사용 | 사용 | 사용 |
| DMF0074 | Team (LBL00502) | 콤보다중(CustomDropdown, TeamField) | TeambyDivision | ARG | N | '' (store L44) | 사용 | 사용 | 사용 |
| DMF0082 | Team (LBL00502, TeamField) | 콤보다중(카탈로그 TeamField — multiple allOption useClearIcon) | TeambyDivision | ARG | N | [] (=ALL) | 사용 | 사용 | 사용 |

### End Customer  (13 UI · 실측(13UI)+카탈로그(19화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple+allOption) | EndCustomerByDivision | CASCADE | N | [] (store L138) | 사용 | 사용 | 사용 |
| DMF0004 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple+allOption) | EndCustomer | CASCADE | Y(FormItem required — 값은 ALL 허용) | ALL | 미사용 | 사용 | 사용 |
| DMF0005 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple+allOption) | EndCustomer | CASCADE | N | ALL | 사용 | 사용 | 사용 |
| DMF0006 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple allOption useClearIcon — 인라인) | EndCustomer | CASCADE | N | 'ALL' | 사용 | 사용 | 사용 |
| DMF0007 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple+allOption) | EndCustomer | CASCADE | Y(FormItem required — 값은 ALL 허용) | ALL | 사용 | 사용 | 사용 |
| DMF0014 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple+allOption) | EndCustomer | CASCADE | N | '' (store L49) | 사용 | 사용 | 사용 |
| DMF0020 | End Customer (LBL00503) | 콤보다중(EndCustomerField=CustomDropdown multiple+allOption) | EndCustomer | CASCADE | N | ['ALL'](store 초기값 명시) | 사용 | 사용 | 사용 |
| DMF0021 | End Customer (LBL00080) | 콤보다중(인라인 CustomDropdown multiple+allOption) | EndCustomerByDivision40 | CASCADE | N | [] (=ALL) | 사용 | 조건부 | 사용 |
| DMF0042 | End Customer (LBL00503) | 콤보다중(CustomDropdown multiple allOption — 인라인, 카탈로그 필드 아님) | EndCustomerByDivision40 | CASCADE | N | [] ('ALL') | 사용 | 조건부 | 사용 |
| DMF0048 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple allOption) — 단일선택+ALL 운용 | EndCustomer | CASCADE | N | [] (ALL) | 조건부 | 조건부 | 사용 |
| DMF0072 | End Customer (LBL00616) | 콤보다중(CustomDropdown multiple+allOption) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | 'ALL' | 사용 | 사용 | 사용 |
| DMF0074 | End Customer (LBL00080) | 콤보다중(CustomDropdown multiple+allOption) | EndCustomer | CASCADE | N | '' (store L45 — 빈값=ALL sentinel) | 사용 | 사용 | 사용 |
| DMF0082 | End Customer (LBL00080) | 콤보다중(인라인 CustomDropdown multiple allOption useClearIcon limitTags=1 — 카탈로그 EndCustomerField 아님) | EndCustomer | CASCADE | N | [] (=ALL) | 사용 | 사용 | 사용 |

### Sold Customer  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0004 | Sold-To Customer (LBL00081) | 콤보다중(CustomDropdown multiple+allOption) | SoldCustomer | CASCADE | N | ALL | 사용 | 사용 | 사용 |

### Sales Site  (13 UI · 실측(13UI)+카탈로그(21화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple+allOption) | UserSiteByEndCustomer | ARG | N | [] (store L139) | 사용 | 사용 | 사용 |
| DMF0004 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple+allOption) | SalesSite | CASCADE | N | ALL | 사용 | 사용 | 사용 |
| DMF0005 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple+allOption) | SalesSite | FILTER | N | ALL | 사용 | 사용 | 사용 |
| DMF0006 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple allOption useClearIcon — 인라인) | SalesSite | CASCADE | N | 'ALL' | 사용 | 사용 | 사용 |
| DMF0007 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple+allOption) | SalesSite | CASCADE | N | ALL | 사용 | 사용 | 사용 |
| DMF0014 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple+allOption) | SalesSite | CASCADE | N | '' (store L50) | 사용 | 사용 | 사용 |
| DMF0020 | Sales Site (LBL00506) | 콤보다중(SalesSiteField=CustomDropdown multiple+allOption) | SalesSite | CASCADE | N | [](ALL) | 사용 | 사용 | 사용 |
| DMF0021 | Sales Site (LBL00011) | 콤보다중(인라인 CustomDropdown multiple+allOption) | SiteByEndCustomer | ARG | N | [] (=ALL) | 사용 | 사용 | 사용 |
| DMF0042 | Sales Site (LBL00506) | 콤보다중(CustomDropdown multiple allOption) | UserSiteByEndCustomer | ARG | N | [] ('ALL') | 조건부 | 조건부 | 조건부 |
| DMF0048 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple allOption) — 단일선택+ALL 운용 | ScmSitebyEndCustomer40 | CASCADE | N | [] (ALL) | 사용 | 사용 | 사용 |
| DMF0072 | Sales Site (LBL00619) | 콤보다중(CustomDropdown multiple+allOption) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | 'ALL' | 사용 | 사용 | 사용 |
| DMF0074 | Sales Site (LBL00011) | 콤보다중(CustomDropdown multiple+allOption) | SalesSite | CASCADE | N | '' (store L46) | 사용 | 사용 | 사용 |
| DMF0082 | Sales Site (LBL00506, SalesSiteField) | 콤보다중(카탈로그 SalesSiteField — 서버 바인드 opt-in 모드) | ScmSitebyEndCustomer40 | CASCADE | N | [] (=ALL) | 조건부 | 조건부 | 조건부 |

### Plant Site  (8 UI · 실측(13UI)+카탈로그(31화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Plant Site (LBL00509) | 콤보다중(PlantSiteField) — extraConditions 영역 | PlantSitebyEndCustomer | ARG | N | [] (store L148) | 미사용 | 사용 | 미사용 |
| DMF0014 | Plant Site (LBL00509) | 콤보다중(CustomDropdown, PlantSiteField) | PlantSitebyEndCustomer | ARG | N | '' (store L52) | 조건부 | 사용 | 조건부 |
| DMF0020 | Plant Site (LBL00509) | 콤보다중(PlantSiteField=CustomDropdown multiple+allOption) | PlantSitebyEndCustomer | ARG | N | [](ALL) | 미사용 | 사용 | 미사용 |
| DMF0021 | Plant Site (LBL00005) | 콤보다중(인라인 CustomDropdown multiple+allOption, disabled=div40) | PlantSitebyEndCustomer | ARG | N | [] (=ALL) | 미사용 | 사용 | 사용 |
| DMF0042 | Plant Site (LBL00509) | 콤보다중(CustomDropdown multiple allOption — 인라인, PlantSiteField 미사용) | PlantSitebyEndCustomer | ARG | N | [] ('ALL') | 조건부 | 사용 | 사용 |
| DMF0048 | Plant Site (LBL00509 — SearchFields 공용) | 콤보다중(PlantSiteField → CustomDropdown multiple allOption) | PlantSitebyEndCustomer | ARG | N | [] (ALL) | 미사용 | 사용 | 조건부 |
| DMF0074 | Plant Site (LBL00509) | 콤보다중(CustomDropdown, PlantSiteField — extraConditions 영역) | PlantSitebyEndCustomer | ARG | N | '' (store L47) | 미사용 | 사용 | 미사용 |
| DMF0082 | Plant Site (LBL00509, PlantSiteField) | 콤보다중(카탈로그 PlantSiteField — multiple allOption) | PlantSitebyEndCustomer | ARG | N | [] (=ALL) | 미사용 | 조건부 | 미사용 |

### PJT  (11 UI · 실측(13UI)+카탈로그(22화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Project (LBL00507) | 텍스트+팝업(ProjectField — ProjectByDivisionModal, multiCheckbox) — extraConditions 영역 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (store L145) | 미사용 | 사용 | 사용 |
| DMF0005 | PJT (LBL00617) | 텍스트+팝업(InputField endAdornment 🔍 → ProjectByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | 빈 문자열 | 미사용 | 사용 | 사용 |
| DMF0006 | Project (LBL00617) | 텍스트(InputField)+팝업버튼(FunctionSearchIcon)+더블클릭 팝업 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | '' | 미사용 | 사용 | 사용 |
| DMF0014 | Project (LBL00617) | 텍스트(InputField)+팝업버튼(PrjByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | '' (store L51) | 미사용 | 사용 | 사용 |
| DMF0020 | Project (LBL00507) | 텍스트+팝업(ProjectField=PopupSearchInput → ProjectByDivisionModal, multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | [] | 미사용 | 사용 | 사용 |
| DMF0021 | Project (LBL00507) | 텍스트+팝업버튼(ProjectField→PopupSearchInput+ProjectByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] ('') | 미사용 | 사용 | 사용 |
| DMF0042 | Project (LBL00507) | 텍스트+팝업(ProjectField — PopupSearchInput + ProjectByDivisionModal, multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (raw '' 전송 — 40 비활성 시 '') | 미사용 | 사용 | 사용 |
| DMF0048 | Project (LBL00507 — SearchFields 공용, 카탈로그 표준명 PJT) | 텍스트+팝업(ProjectField → PopupSearchInput + ProjectByDivisionModal multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] ('' 전송 — SP IS NOT NULL 가드 통과) | 미사용 | 사용 | 사용 |
| DMF0072 | Project (LBL00617) | 텍스트+팝업(InputField endAdornment 🔍 + 더블클릭 → ProjectByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | 빈 문자열 | 미사용 | 사용 | 사용 |
| DMF0074 | Project (LBL00617) | 텍스트(InputField)+팝업버튼(PrjByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | '' (store L48) | 미사용 | 사용 | 사용 |
| DMF0082 | Project (LBL00507, ProjectField) | 텍스트+팝업(PopupSearchInput → ProjectByDivisionModal, multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (=ALL) | 미사용 | 사용 | 사용 |

### Model/Nickname  (11 UI · 실측(13UI)+카탈로그(63화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Model / Nickname (LBL00508) | 텍스트+팝업(ItemField — ItemByDivisionModal, multiCheckbox) — extraConditions 영역 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (store L146) | 사용 | 사용 | 사용 |
| DMF0005 | Model / Nickname (LBL00508) | 텍스트+팝업(InputField endAdornment 🔍 → ItemByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | 빈 문자열 | 사용 | 사용 | 사용 |
| DMF0006 | Model / Nickname (LBL00508) | 텍스트(InputField)+팝업버튼+더블클릭 팝업 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | '' | 사용 | 사용 | 사용 |
| DMF0014 | Model/Nickname (LBL00003) | 텍스트(InputField)+팝업버튼(ModelByDivisionModal) — extraConditions 영역 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | '' (store L53) | 사용 | 사용 | 사용 |
| DMF0020 | Model / Nickname (LBL00508) | 텍스트+팝업(ItemField=PopupSearchInput → ItemByDivisionModal, multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | [] | 사용 | 사용 | 사용 |
| DMF0021 | Model / Nickname (LBL00508) | 텍스트+팝업버튼(ItemField→PopupSearchInput+ItemByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] ('') | 사용 | 사용 | 사용 |
| DMF0042 | Model / Nickname (LBL00508) | 텍스트+팝업(ItemField — PopupSearchInput + ItemByDivisionModal headerTitle='Model / Nickname', multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (raw '') | 사용 | 사용 | 사용 |
| DMF0048 | Model / Nickname (LBL00508 — SearchFields 공용) | 텍스트+팝업(ItemField → PopupSearchInput + ItemByDivisionModal multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] ('' 전송) | 사용 | 사용 | 사용 |
| DMF0072 | Model/Nickname (LBL00618, 라벨 2단 개행) | 텍스트+팝업(InputField endAdornment 🔍 + 더블클릭 → ItemByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | 빈 문자열 | 사용 | 사용 | 사용 |
| DMF0074 | Model/Nickname (LBL00003) | 텍스트(InputField)+팝업버튼(ModelByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | '' (store L49) | 사용 | 사용 | 사용 |
| DMF0082 | Model / Nickname (LBL00508, ItemField) | 텍스트+팝업(PopupSearchInput → ItemByDivisionModal headerTitle='Model / Nickname') | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] | 사용 | 사용 | 사용 |

### Customer PJT  (1 UI · 실측(13UI)+카탈로그(1화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0006 | Customer PJT (LBL00083) | 텍스트(InputField) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(텍스트) | N | '' | 사용 | 사용 | 사용 |

### Customer Model  (1 UI · 실측(13UI)+카탈로그(1화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0006 | Customer Model (LBL00084) | 텍스트(InputField) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(텍스트) | N | '' | 사용 | 사용 | 사용 |

### Item Type  (4 UI · 실측(13UI)+카탈로그(11화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Item Type (LBL00068) | 콤보다중(CustomDropdown multiple+allOption) — extraConditions 영역 | ItemType | CASCADE | N | [] (store L149) | 사용 | 사용 | 사용 |
| DMF0021 | Item Type (LBL00068) | 콤보다중(인라인 CustomDropdown multiple+allOption) | ItemType | FILTER | N | [] (=ALL) | 사용 | 사용 | 사용 |
| DMF0042 | Item Type (LBL00068) | 콤보단일(CustomDropdown allOption useClearIcon — multiple 아님. 값은 firstOr(sc.itemTypes) 단일) | ItemType | FILTER | N | [] ('ALL') | 사용 | 사용 | 사용 |
| DMF0048 | Item Type (LBL00068) | 콤보다중(CustomDropdown multiple allOption) — 단일선택+ALL 운용 | ItemType | FILTER | N | [] (ALL) | 사용 | 사용 | 사용 |

### Biz. Type  (6 UI · 실측(13UI)+카탈로그(13화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Biz.Type (LBL00504) | 콤보다중(BizTypeField) | BizTypebyDivision | CASCADE | N | [] (store L140) | 사용 | 사용 | 사용 |
| DMF0020 | Biz.Type (LBL00504) | 콤보다중(BizTypeField=CustomDropdown multiple+allOption) | BizType | CASCADE | N | [](ALL) | 사용 | 사용 | 사용 |
| DMF0021 | Biz. Type (LBL00085) | 콤보다중(인라인 CustomDropdown multiple+allOption) | BizTypeByDivision | ARG | N | [] (=ALL) | 조건부 | 조건부 | 사용 |
| DMF0042 | Biz.Type (LBL00504) | 콤보다중(CustomDropdown multiple allOption — 인라인) | BizTypeByDivision | ARG | N | [] ('ALL') | 사용 | 조건부 | 사용 |
| DMF0048 | Biz. Type (LBL00085) | 콤보다중(CustomDropdown multiple allOption) — 단일선택+ALL 운용 | BizType | CASCADE | N | [] (ALL) | 조건부 | 사용 | 사용 |
| DMF0082 | Biz.Type (LBL00504, BizTypeField) | 콤보다중(카탈로그 BizTypeField — multiple allOption) | BizType | CASCADE | N | [] (=ALL) | 사용 | 사용 | 사용 |

### Data Type  (1 UI · 실측(13UI)+카탈로그(2화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0072 | Data Type (LBL00614) | 콤보단일(CustomDropdown allOption) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | 'ALL' | 사용 | 사용 | 사용 |

### Bucket  (8 UI · 실측(13UI)+카탈로그(34화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Bucket (LBL00710) | 콤보단일(CustomDropdown isInput=false) | BucketType | CASCADE | Y | BUCKET_TYPE.WEEKLY (store L144) | 사용 | 사용 | 미사용 |
| DMF0007 | Bucket Type (LBL00032) | 콤보단일(CustomDropdown) | BucketType | CASCADE | Y(FormItem required) | 'WEEKLY' | 사용 | 사용 | 사용 |
| DMF0014 | Bucket (LBL00710) | 콤보단일(CustomDropdown) | BucketType | CASCADE | Y (단일 콤보) | BUCKET_TYPE.WEEKLY (store L58 — AS-IS L308 1:1) | 사용 | 사용 | 사용 |
| DMF0020 | Bucket (LBL00511) | 콤보단일(BucketField=CustomDropdown, W/M 필터) | BucketType | CASCADE | Y | BUCKET_TYPE.WEEKLY | 사용 | 사용 | 사용 |
| DMF0021 | Bucket (LBL00710) | 콤보단일(인라인 CustomDropdown isInput=false) | BucketType | CASCADE | Y | BUCKET_TYPE.MONTHLY | 사용 | 사용 | 사용 |
| DMF0042 | Bucket (LBL00710) | 콤보단일(CustomDropdown isInput=false) | BucketType2 | CASCADE | Y (단일 — 기본값 보유) | BUCKET_TYPE.MONTHLY('M') | 사용 | 사용 | 사용 |
| DMF0048 | Bucket (LBL00710) | 콤보단일(CustomDropdown isInput=false) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N (항상 값 존재) | BUCKET_TYPE.MONTHLY (store L110) | 사용 | 사용 | 사용 |
| DMF0082 | bucket (LBL00710) | 콤보단일(인라인 CustomDropdown isInput=false — 카탈로그 BucketField 미사용) | BucketType | CASCADE | Y(항상 값 존재) | 'W' | 사용 | 사용 | 사용 |

### Period  (8 UI · 실측(13UI)+카탈로그(49화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Period (LBL00505) | 일달력 2개(PeriodField date 모드) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y (PeriodField 내장) | 오늘~+180일(FE, toISOString UTC 기반) → 진입 후 applyDayRange 로 PR_GET_DAY_RANGE 구간 전체 교체(1회성) (store L131-133, L539-551) | 사용 | 사용 | 사용 |
| DMF0014 | Period (LBL00505) | 일달력 2개(PeriodField 기본 date 모드, DatePickerCalendar) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y (PeriodField 내장 required) | 오늘~+180일(FE 근사) → 진입 후 PR_GET_DAY_RANGE o_rc2 로 종료일 교체·시작일=당일 유지 (store L40-41, L147-161 applyDayRange, 1회성 persist) | 사용 | 사용 | 사용 |
| DMF0020 | Period (LBL00505) | 달력구간(PeriodField=DatePickerCalendar 2개, YYYYMMDD) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y(FormItem required) | 당월 1일 ~ (당월+5개월) 말일 | 사용 | 사용 | 사용 |
| DMF0021 | Period (LBL00505) | 달력 2필드(PeriodField→DatePickerCalendar×2, YYYYMMDD) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y (FormItem required) | 당월 1일~+6개월 말일(FE dayjs) → PR_GET_DAY_RANGE o_rc2 도착 시 서버값 교체(applyDayRange, dayRangeApplied 1회 가드) | 사용 | 사용 | 사용 |
| DMF0042 | Period (LBL00505) | 달력2개 분리(PeriodField — DatePickerCalendar date×2, 종료일 mindate=시작일) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y (PeriodField required 표시 + validateFind: 역전 MSG00108 / 6년 초과 MSG00677 신설+종료일 보정) | 당월 1일 ~ +7개월 말일 (FE dayjs 계산) → PR_GET_DAY_RANGE o_rc2 도착 시 서버값 교체 | 사용 | 사용 | 사용 |
| DMF0048 | Period (LBL00505 — PeriodField 공용, required 표기) | 달력구간(PeriodField → DatePickerCalendar 2개, mode='date' YYYYMMDD, 종료일 mindate=시작일) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y — FormItem required + validateFind MSG00108(역전)/MSG00164(3년 초과) (SalesMonitoring.tsx L192-208) | FE 근사 today~+180d → PR_GET_DAY_RANGE o_rc2 로 1회 교체 (store L93-94, L107-109, L385-399) | 사용 | 사용 | 사용 |
| DMF0074 | Period (LBL00505) | 월달력 2개(PeriodField mode='month', DatePickerCalendar usecase='month') | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y (FormItem required — PeriodField 내장) | 당월 ~ +6개월 (store L36-37, dayjs YYYYMM) | 사용 | 사용 | 사용 |
| DMF0082 | Period (LBL00505, PeriodField — required 표시) | 달력 2개(DatePickerCalendar date, 종료일 mindate=시작일) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(달력) | Y(검증) — from>to MSG00108 alert / 3년 이상 MSG00164 alert+endYyyymmdd=시작+2년 보정 | start=dayjs().startOf('month') / end=+6개월-1일 (AS-IS PR_GET_DAY_RANGE 1:1, 2026-08-10 -1일 정정) | 사용 | 사용 | 사용 |

### Ver.  (3 UI · 실측(13UI)+카탈로그(18화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0020 | Version (LBL00513) | 텍스트(readonly)+팝업(VersionField=PopupSearchInput → onVersionOpen 부모 팝업) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | Y(FormItem required) | 'CURRENT' (빈값 표시 문자열 'Current') | 사용 | 사용 | 사용 |
| DMF0074 | Version (LBL00653) | 텍스트(InputField 직접입력 허용)+팝업버튼(MetalLinkVersionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | Y (FormItem required) | 'Current' (store L52) | 사용 | 사용 | 사용 |
| DMF0082 | Version (LBL00513, VersionField — required 표시) | 텍스트+팝업(PopupSearchInput — 팝업 선택 전용, 직접입력 불가) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | Y — 공백 MSG00283 alert | 'Current' | 사용 | 사용 | 사용 |

### Owner  (7 UI · 실측(13UI)+카탈로그(12화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Owner (LBL00510) | 텍스트+팝업(OwnerField — OwnerByDivisionModal, multiCheckbox) — extraConditions 영역 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (store L150) | 사용 | 사용 | 사용 |
| DMF0005 | Owner (LBL00082) | 텍스트+팝업(InputField endAdornment 🔍 → OwnerByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | 빈 문자열 | 사용 | 사용 | 사용 |
| DMF0020 | Owner (LBL00510) | 텍스트+팝업(OwnerField=PopupSearchInput → OwnerByDivisionModal, multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | [] | 사용 | 사용 | 사용 |
| DMF0021 | Owner (LBL00510) | 텍스트+팝업버튼(OwnerField→PopupSearchInput+OwnerByDivisionModal) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] ('') | 사용 | 사용 | 사용 |
| DMF0042 | Owner (LBL00510) | 텍스트+팝업(OwnerField — PopupSearchInput + OwnerByDivisionModal, multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (raw '') | 사용 | 사용 | 사용 |
| DMF0048 | Owner (LBL00510 — SearchFields 공용) | 텍스트+팝업(OwnerField → PopupSearchInput + OwnerByDivisionModal multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] ('' 전송) | 사용 | 사용 | 사용 |
| DMF0082 | Owner (LBL00510, OwnerField) | 텍스트+팝업(PopupSearchInput → OwnerByDivisionModal, multiCheckbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | CASCADE | N | [] (=ALL) | 사용 | 사용 | 사용 |

### Sender Code  (2 UI · 실측(13UI)+카탈로그(3화면))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Sender Code (LBL00090) | 콤보단일(CustomDropdown allOption — multiple 아님, firstOr/toArr 단일값) | SenderCode | CASCADE | N | [] (store L141) | 미사용 | 사용 | 미사용 |
| DMF0082 | Sender Code (LBL00090) | 콤보단일(인라인 CustomDropdown allOption useClearIcon) | SenderCode | CASCADE | N | [] (=ALL) | 미사용 | 조건부 | 미사용 |

### DOM/EXP  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0014 | Customer Handbook (LBL00091) — extraConditions 영역 | 콤보단일(CustomDropdown allOption — multiple 아님) | DOM_EXP | FILTER | N | '' (store L54 — setFilters 시 'ALL' sentinel) | 사용 | 사용 | 사용 |

### Active(YesOrNo)  (4 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0004 | Active (LBL00007) | 콤보단일(CustomDropdown allOption, isInput=false) | YesOrNo | FILTER | N | ALL | 사용 | 사용 | 사용 |
| DMF0005 | Active (LBL00007) | 콤보단일(CustomDropdown allOption, isInput=false) | YesOrNo | FILTER | Y(FormItem required — 값은 ALL 허용) | ALL | 사용 | 사용 | 사용 |
| DMF0006 | Active (LBL00007) | 콤보단일(CustomDropdown isInput=false allOption — extraConditions 행) | YesOrNo | FILTER | N | 'Y' | 사용 | 사용 | 사용 |
| DMF0007 | Active (LBL00007) | 콤보단일(CustomDropdown allOption) | YesOrNo | FILTER | N | ALL | 사용 | 사용 | 사용 |

### Search Over Range  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0020 | Search over range (LBL00512) | 체크박스(SearchOverRangeField) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false | 사용 | 사용 | 사용 |

### Detail  (2 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0004 | Detail (LBL00316) | 체크박스(Checkbox+Label) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | 미확인(부모 SalesSite.tsx state — Form은 prop 수신) | 사용 | 사용 | 사용 |
| DMF0005 | Detail (LBL00316) | 체크박스(Checkbox+Label) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | true(openPurchaseGrid 초기값) | 미사용 | 사용 | 사용 |

### End Customer(Report) Null  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0005 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |

### Project Null  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0005 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |

### Sum(체크)  (5 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Sum (LBL00687) | 체크박스(Checkbox) — extraConditions 영역 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false (store L151) | 사용 | 사용 | 사용 |
| DMF0021 | Sum (LBL00687) | 체크박스(Checkbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false | 사용 | 사용 | 사용 |
| DMF0042 | Sum (LBL00687) | 체크박스(Checkbox) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false (⚠ AS-IS Designer 는 Checked=true — 기본값 상이. 코드 주석은 '기본 uncheck' 로 기재) | 사용 | 사용 | 사용 |
| DMF0048 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
| DMF0082 | Sum (LBL00687) | 체크박스(Checkbox — extraConditions Row4) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false | 사용 | 사용 | 사용 |

### Color(체크)  (3 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
| DMF0021 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
| DMF0048 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |

### Qty≥0(체크)  (2 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Qty ≥ 0 (LBL00689) | 체크박스(Checkbox) — extraConditions 영역 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false (store L154) | 사용 | 사용 | 사용 |
| DMF0082 | Qty ≥ 0 (LBL00689) | 체크박스(Checkbox — extraConditions Row4) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false | 사용 | 사용 | 사용 |

### Qty≠0(체크)  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0042 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |

### Cell Qty(체크)  (3 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | Cell Qty (LBL00690) | 체크박스(Checkbox) — extraConditions 영역 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 해당없음(체크박스) | N | false (store L155) | 사용 | 미사용 | 미사용 |
| DMF0021 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
| DMF0048 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |

### Include Internal Txn(체크)  (2 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0021 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
| DMF0048 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |

### AS(체크)  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | (UI 미노출) | 없음 — store 파생값 | MktFcstWsPlannerYn | FILTER | N | asYn=false (store L159) | 사용 | 사용 | 사용 |

### MKT FCST 미등록 제외(체크)  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0003 | (UI 미노출 — store 자동) | 없음 — Division onChange 파생 | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | FILTER | N | false (store L158) | 사용 | 사용 | 사용 |

### Price 미등록 제외(체크)  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0020 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |

### Closed(숨김)  (1 UI · 실측(13UI))

| UI | TO-BE 라벨 | 컨트롤 | 콤보 | binding | 필수 | 기본값 | div40 | div81 | div82 |
|---|---|---|---|---|---|---|---|---|---|
| DMF0042 | 미확인(TO-BE 미구현) | 미확인(TO-BE 미구현) | 미확인(CMBO 미해석(콤보 아님 또는 미등록)) | 미확인(cascade·filter·params 서술 부재) | 미확인(필수여부 서술 없음) | 미확인(기본값 서술 없음) | 해당없음 | 해당없음 | 해당없음 |
