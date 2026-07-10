# Hook #105 — 화면 UI 분석서 표준 (10시트 + AS-IS DB 소스분석 + 가독성 + 개발용 MD)

> 신설: 2026-07-03 (DMF0003 v1.0/v1.1) · **대폭 확장: 2026-07-07 (DMF0003 v1.7 — 화면별 분석 기본 룰로 승격)**
> 트리거: "화면 분석서 / UI 분석서 / 설계서 생성 / As-is 소스분석" 요청 시 — **모든 화면 분석의 기본 룰(의무)**
> 짝: anti-simplification(카운트 대사·전수) / #101 ui-work-entry-playbook / oracle-db-workflow(SP·메타 실측) / v7.4 룰(CLAUDE.md §12)

## §0. 원칙 (4대)

개발자가 **보고 바로 개발할 수 있고**, 현업/QA 가 **읽고 바로 이해할 수 있는** 문서.
1. **전수·실측** — 나열식 서술·요약 전재 금지. AS-IS 평문 정본 + 사내 DB 실측만. 추측 0 (anti-simplification).
2. **UI + DB 동시 분석** — 화면 UI 뿐 아니라 **AS-IS 소스가 쓰는 DB 계층(SP·PKG·Function·Lookup·Combo·권한·Division·일자/편집 제약)** 을 함께 전수 분석(§1.5).
3. **가독성** — 각 시트 상단 "이 시트 읽는 법" 안내 + 기술표에 **"쉬운 설명(업무 관점)" 열** 병기(§2). 정밀 데이터는 보존, 쉬운 설명은 추가만.
4. **개발용 MD 동시 산출** — 이벤트/액션의 **실제 발생 상세동작**을 소스 실측으로 별도 MD 생성(§3) → User 관점 가독본은 분석서에 반영.

원천 3원: ① AS-IS 평문 정본 전수(추측 금지) ② 사내 메타/SP **실데이터**(ora.py SELECT) ③ TO-BE 현재 구현 + 실측 효과.
제약이 **3계층에 분산**됨을 전제로 전수: (a) SP/PKG 소스(Division·일자·Lookup·검증·편집) (b) AS-IS .cs 클라이언트(권한·Division UI 분기·편집제약) (c) 실 DB 테이블(런타임 값).

## §1. 10시트 구성 (DMF0003 v1.7 = 마스터 견본)

| # | 시트 | 필수 내용 |
|---|---|---|
| 1 | 개요 | 화면정의(ID/명/도메인/**메뉴경로=MNU_M walk-up 실측**/AS-IS 폼/TO-BE 경로/division/버킷/주요 SP/제외) + 개정이력 + **동적데이터 인덱스(SP·PKG·Function·Lookup·Combo 카운트→상세시트 지정)** |
| 2 | LAYOUT | 메인 + **사용 팝업 전부** 이미지(Figma PNG 우선, 부재 시 Pillow 와이어프레임). 팝업명+진입경로 1줄 |
| 3 | 조회조건·버튼 | 조회조건 전수(유형/**데이터 원천 실명칭**/division 분기/**cascade 종속**/초기상태/소스라인) + 체크박스(효과 실측) + 버튼 전수(연결 SP·MSG·활성/권한 규칙) + **BTN_MPG 실측 전수** + **CMBO SQL 원천** |
| 4 | GRID | 그리드별 **PROGRAM_ID/SHEET_NAME** + SHEET_COLUMNS **실데이터 전수**(컬럼/라벨/INPUT_TP/CELL_CTRL/콤보키/정렬/너비/DIVISION_ID/편집플래그) + 동적 컬럼 규칙 + 콤보·cascade·색상 |
| 5 | EVENT | AS-IS 이벤트 **전수**(F-key 포함) — **상세 동작(사용자 관점)** + 트리거/컨트롤/MSG/소스라인/Division 분기 + TO-BE 상태. 우클릭 메뉴 상세 |
| 6 | VALIDATION | 메인+팝업 **전수**(개수 명시) — MSG ID 문구 **MSG_M 실측** + 발생조건 + TO-BE 구현여부 |
| 7 | API·SP | API_M 전수 + PROC_M SP·파라미터 + **AS-IS↔TO-BE 대응**(격차 정직) + CMBO 목록 + **Function·호출 PROC 인벤토리(FN_/PR_ + 호출 SP 매핑) + SP 역할 요약(쉬운 설명)** |
| 8 | **SQL제약_SP** ⭐신규 | 화면 실사용 SP별 **소스 제약 전수** — 유형(Division/일자·캘린더/Lookup/검증/**편집제약(EDIT_FLAG·과거잠금·버킷)**/NVL·기본값/PK·중복/Bulk(^)/커서/정렬) × 조건·로직 × **쉬운 설명** × 참조 테이블·함수 × 오류·MSG × 소스라인 × AS-IS↔TO-BE. `ALL_SOURCE` 전문 실측 + grep COUNT 대사 |
| 9 | **권한·Division·일자·편집 실측** ⭐신규 | 실 DB 값: 권한(USER_GR + 그룹×버튼 MNU_BTN_MPG + Division EDIT_YN) / Division(SCM_MST_DIVISION 전수 + 40/81/82/sub 분기 + **편집가능/제약 규칙**) / 일자(캘린더·버킷·cutoff) / **Lookup 전량(참조 LOOKUP_TYPE 전수 × 전체 코드행)** / 편집제약(SHEET_COLUMNS 편집플래그 + AS-IS 편집-lock 전수 + TO-BE 반영상태) |
| 10 | 단위테스트 | **Division별 분기 시나리오**(공통 + 사업부별 조회/편집/Insert/저장/side-effect) + 기능/PR/팝업/권한 — 전제+동작/Division/기대결과(MSG·side-effect)/근거 시트 |
| 11 | **데이터연결 분기·종속 맵** ⭐신규(2026-07-09) | FE 컨트롤→API_M→PROC_M→SP→Lookup/Table **데이터 연결(lineage)** 전수 + **4축 분기·종속**(Division/사용자권한/FCST_TYPE·유형/메저+하위메저) + **편집제어 매트릭스**(권한×Division×메저×일자·시간) + 각 분기값 **원천태그**(HARD/LOOKUP/DB/src:L/sp:). §7 참조 — **HTML 인터랙티브 마인드맵 동반 산출** |

## §1.5. AS-IS 소스 DB 계층 전수 분석 (의무 · 시트 7·8·9·10 원천)

화면이 실제 호출하는 DB 객체를 **전수 실측**(FE metadata-driven이면 `SCM_ADM_API_M`/`PROC_M` 경유 standalone SP 확정):
- **SP/PKG**: 화면 실사용 SP `ALL_SOURCE` 전문 덤프 → 제약 전수 추출(SP당 병렬 에이전트, grep COUNT 대사). PKG 멤버 별도 표기.
- **Function**: SP 소스 grep 으로 `FN_*` + 호출 `PR_*`(side-effect) 전수 + 호출 SP 매핑.
- **Lookup**: SP 참조 `LOOKUP_TYPE` **전수** → `SCM_ADM_LOOKUP_MASTER_DETAIL` **전체 코드행** 실측(부분 금지).
- **Combo**: `SCM_ADM_CMBO_SQL_M` 원천 SQL + 원천 테이블/Lookup.
- **권한/Division/일자/편집**: `SCM_ADM_USER_GR_*`(그룹·그룹×버튼·Division EDIT_YN) / `SCM_MST_DIVISION` / `SCM_SYS_CALENDAR_M` / `SHEET_COLUMNS` 편집플래그 실측.
- **교차(선택)**: AS-IS MSSQL(`.env.asis`) SP 원본 대조로 변환 전·후 제약 차이(ISNULL→NVL, RAISERROR 신설 등) 병기.

## §2. 가독성 의무

- **각 시트 상단**: "📖 이 시트 읽는 법" 안내(무엇을·어떻게 읽는지, 업무 언어). 빈 행(row3) 활용 — 행 삽입으로 머지/freeze 파손 금지.
- **기술 시트(3·7·8 등)**: **"쉬운 설명(업무 관점)" 열** 추가(초록 계열). 예) 제약 "선택 사업부에 맞는 데이터만 조회, 미등록 사업부 제외". 정밀 조건은 개발 참고용으로 별 열에 **보존**.
- 색 규약: 초록=업무 쉬운 설명 / 검정=개발 정밀. 서식 = Title14bold #1F4E79 / 섹션바 #1F4E79 / 헤더 #4472A8 thin border.

## §2.5. 데이터연결 상세 제약 (의무 · 2026-07-09 신설 — 시트11 + HTML 마인드맵)

> ⭐ 사용자 지시(2026-07-09): "DMF0003 마인드맵 작업 시와 같이 **데이터연결 상세한 제약까지** 분석서에 추가 — 분석서 생성 시 **Rule 로 상시 적용**."

모든 화면 분석서는 UI·SP 제약(시트3·8·9)에 더해, **데이터가 흐르는 연결(lineage)과 그 위의 분기·종속을 한눈에 보는 맵**을 시트11 + HTML 마인드맵으로 **이중 산출**한다.
1. **lineage 전수**: 각 조회조건/그리드컬럼/메저/편집에 대해 `FE 컨트롤 → SCM_ADM_API_M → SCM_ADM_PROC_M → SP(파라미터) → 참조 Lookup/Table` 사슬을 실측으로 추적.
2. **분기·종속 축(화면별 실측 — 고정 아님)**: 후보 4축 = (a) **Division**(40/81계열/82 + sub) (b) **사용자권한**(EDIT_AUTH·그룹×버튼) (c) **FCST_TYPE·유형**(BP_FCST_TYPE/SALES_TYPE_CODE 등) (d) **메저**(SHEET_MEASURE + 하위메저 자동추가 종속). ⚠ **이 4축은 고정 템플릿이 아님** — **화면별로 실제 분기 필요 항목만 실측 추출해 확정**(예: FCST_TYPE 분기는 전 화면 공통 아님 · 화면에 따라 축이 3개일 수도, 별도 축이 추가될 수도 있음). **없는 축은 목록·맵에서 제외**(lineage 실측 기준). 각 분기가 값을 어디서 얻는지 **원천태그**: `HARD`(하드코딩) / `LOOKUP`(LOOKUP_TYPE 명시) / `DB`(테이블) / `src:L###`(AS-IS 소스) / `sp:`(SP 소스 라인). 추측 0.
2.5. **⛓ CASCADE 필터(조회조건·GRID 콤보 종속 — 전 화면 필수, 콤보 있는 화면)**: 콤보 선택 → 하위 콤보 재조회/재필터 사슬(예: `Division → Team → End Customer → Sales Site`)을 **조회조건 + GRID 셀 콤보**(`SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE`) 전수로 추적. **종속 메커니즘 2종 실측 구분**(원천태그): **SQL @바인드**(`SCM_ADM_CMBO_SQL_M.SQL_DTL_CTN` 의 `@divisionId`/`@deptId`/`@endCustomer` 등 — EndCustomer/Site/PlantSite/Project/Item/Measure) vs **FE 필터**(`ByDivision` 콤보 = DIVISION_ID 반환열 클라이언트 필터 — Team/BizType/EndCustomer40) vs `static`. lineage 루트에 `⛓ CASCADE 필터` 노드로 추가 → 마인드맵 목록·시트11 자동 반영.
3. **편집제어 매트릭스**: 권한 × Division × 메저 × 일자·시간(시간락 GET_ADMIN_GROUP_MEASURE 등) → 편집가능/제한. 화면별 편집규칙(예: DMF0003=82만 편집 / DMF0082=40·81·81_ 편집·82 불가 / DMF0020=division-gate(DM_UI_EDITABLE_DIVISION) / DMF0021=시간락(RTF_SYS_RP) / DMF0042=EDIT_FLAG 행계산(GET_ADMIN_GROUP) / **DMF0044=⭐이중 게이트 하이브리드** — Layer A EDIT_FLAG 행계산(GET_ADMIN_GROUP) + Layer B division-gate(SCM_ADM_USER_MNU_EDIT_AUTH_V INNER JOIN, UNIT_TP_CD='D') / DMF0074=단일 division-gate(EDIT_AUTH_V INNER JOIN **단독** — EDIT_FLAG/GADM/시간락 全無·행 하드필터+EDIT_YN 이중 효과))을 실측+확정규칙 격차와 함께. ⚠ 편집 메커니즘은 **단일 방식 고정 아님** — 한 화면이 2계층을 동시 적용(DMF0044)하거나 뷰 1개만 단독 사용(DMF0074)할 수 있으므로 GET proc 소스에서 EDIT_FLAG CASE + 편집권한 뷰 JOIN 을 모두 실측 확인(grep 0건도 "全無" 근거로 기록). ⚠ CASCADE 도 화면별 실측 — 콤보 0 화면(DMF0074)은 "⛓CASCADE 없음" 으로 정직 표기(축 발명 금지).
4. **산출 이중화**: (a) Excel 시트11 표 + (b) `Doc/화면설계서/{ID}_데이터연결_마인드맵.html`(자립 HTML — 트리 렌더러+줌/이동+필터+원천태그, DMF0003 렌더러 재사용). 전 화면 통합본(`DM_분석_마인드맵.html`)이 있으면 해당 화면 페이지도 채운다.
5. **⭐ 마인드맵 페이지 양식(고정 — 全 화면 동일)** — 통합본 `DM_분석_마인드맵.html` 의 화면별 페이지는 **DMF0003 양식**을 그대로 따른다(정본=DMF0003·DMF0082):
   - **상단 콜아웃** `⚠ 정정·확인필요`(①②③… 번호식 격차·확인필요 나열).
   - **프로그램 정보 카드**(`infogrid`) — 고정 10항목: 화면 ID / 화면명 / 도메인 / AS-IS 원본(파일·줄수) / 주요 조회 SP / 프로세스 단계 / **입력 Division** / **편집 권한** / 분기 4축 / 원천.
   - **좌측 상세 목록(선택)** + **우측 상세영역** — 목록 클릭 시 해당 축 표시. 목록 항목 = `데이터연결 lineage(FE→API→PROC→SP→Lookup)` + **화면에 실제 존재하는 분기축만**(예: `①Division`·`②사용자권한`·`③FCST_TYPE`·`④메저` 중 실측된 것 — 없는 축 제외, §2.5-2) + `⛓CASCADE 필터`(§2.5-2.5) + `⭐편집제어 매트릭스`(표).
   - **각 MAP** = 박스+커넥터 수평 트리 + 확대/축소·이동·검색·전체펼침/접기 + 원천태그 배지(HARD/LOOKUP/DB/sp/src). 자립(외부의존 0)·JS 구문 검증.
6. **⭐ 전체 UI 편집제어 매트릭스 편입(의무)** — 화면 분석 완료 시 통합본 `DM_분석_마인드맵.html` 2번째 페이지 **`전체 UI 편집제어 매트릭스`** 에 반영:
   - **① 편집 규칙 통합표**에 해당 화면 행 추가 — 각 행 **PROGRAM 태그**(data-prog) + 권한(그룹) · Division · 메저 · 편집상태 · 시간락 · 근거.
   - **⑤ 인지표** 상태를 **★ 상세완료**로 갱신 + **④ 시간락 원본**(GET_ADMIN_GROUP_MEASURE)에 해당 화면 GADM 행 반영.
   - **⑥ CASCADE 필터 종속**(§2.5-2.5) 표에 해당 화면 cascade 행 추가 — 각 행 **PROGRAM 태그** + 대상(조회조건/GRID) · 콤보(컬럼→CMBO) · 종속 · 메커니즘(SQL@바인드/FE필터/static). PROGRAM 선택 시 해당 화면 cascade 만 표시.
   - 매트릭스는 **PROGRAM / 권한 / DIVISION 필터** — `ALL`=전 화면 / 특정 PROGRAM=해당 화면 행만. **화면이름이 고정된 섹션 금지**(모든 데이터 행에 PROGRAM 태그 — 화면 무관 공통 참조는 데이터 매트릭스 탭으로).

## §3. 개발용 상세동작 MD 산출 (의무)

- 산출: `Doc/화면설계서/{ID}_{화면명}_상세동작_개발용.md` — 이벤트/액션 **전수**, 각 항목 **①→②→③ 실제 발생 순서**(핸들러 + 호출메서드 본문 1-depth 실측) + 소스라인 + 호출메서드 + MSG + Division 분기. 버튼/조회조건 인벤토리 + 데이터접근(FoxData/Data.Type ↔ TO-BE SP) 각주.
- **2단 산출**: ① 개발용(기술 상세) MD → ② User 관점 언어로 변환(메서드·변수·라인 제거, 업무 규칙·MSG 의미 유지) → 분석서 시트 5 반영.
- InsertButton 수준의 상세(예: 잠금체크→행삽입→Division 분기 컬럼세팅→권한 콤보→기본값→키컬럼 잠금)를 **모든 이벤트**에.

## §4. 생성 기술 표준

- python **openpyxl**(+Pillow) — 스크립트 scratchpad, UTF-8. 대량 제약/상세동작 추출은 **병렬 에이전트**(SP당/이벤트 범위별) → JSON → 빌드 병합.
- 메타 컬럼명은 **ALL_TAB_COLUMNS 동적 발견**(추측 ORA-00904 방지). NOT NULL 전수 확인.
- 산출: `Doc/화면설계서/{ID}_{화면명}_UI분석서_v{N}.xlsx` — 잠김 시 버전업 저장 + 개정이력.
- 이미지 = OneCellAnchor + XDRPositiveSize2D(ext) (str anchor 크기 유실 금지).

## §5. 카운트 대사 (anti-simplification 게이트 — 보고 의무)

1. validation = AS-IS 인벤토리 / GRID 컬럼 = SHEET_COLUMNS / API = API_M 전수 / 조회조건·버튼·이벤트 전수
2. **SP 제약**: 화면 실사용 SP 전부 ≥1 제약 행 + 유형별 grep COUNT ↔ 추출 행수 일치 + RAISE 전건
3. **Lookup 전량**: 참조 LOOKUP_TYPE 전수 × 전체 코드행 수록
4. **편집제약/Division**: 편집가능/제약 규칙 + SHEET_COLUMNS 편집플래그 + Division EDIT_YN 실값
5. **이벤트 상세**: 이벤트 전수 각 ①→②③ 상세 + 개발용 MD 생성 확인
6. 생성 후 openpyxl 재오픈 assert(시트 **11** / 이미지 / 각 시트 카운트)
7. 자료별 차이 **병기**(은폐·임의 단일화 금지)
8. **데이터연결 lineage 전수**(§2.5): 4축 분기값 각 원천태그≥1(추측 0) + 편집제어 매트릭스 시간락 전행 + HTML 마인드맵 자립성(외부링크 0)·JS 구문 검증

## §6. 안티패턴

1. ❌ 기존 분석 MD 요약 전재(AS-IS 원시 소스·DB 전수 생략)
2. ❌ MSG/컬럼/메뉴경로/제약 추측 기입
3. ❌ Lookup 부분 추출(전량 아님) / SP 제약 표본 추출
4. ❌ "등록 필요/미구현/편집제약" 격차 은폐 — 격차는 핵심 가치
5. ❌ 이미지 없는 LAYOUT / 상단 안내·쉬운 설명 열 누락(가독성 위반)
6. ❌ 개발용 상세동작 MD 미산출(이벤트 1줄 요약만)
7. ❌ 데이터연결 맵(시트11)·HTML 마인드맵 미산출 / 분기값 원천태그 누락(§2.5 위반)

마스터 견본: `Doc/화면설계서/DMF0003_MktFcst_UI분석서_v1.7.xlsx`(10시트) + `DMF0003_MktFcst_상세동작_개발용.md` + `DM_분석_마인드맵.html`(데이터연결 마인드맵) + 생성 스크립트 패턴(소스덤프→DB실측→제약추출(병렬)→빌드→가독성보완→**데이터연결 lineage/마인드맵**→검증). 2번째 견본: DMF0082(11시트 + 전용 마인드맵).
