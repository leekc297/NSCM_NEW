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
6. 생성 후 openpyxl 재오픈 assert(시트 10 / 이미지 / 각 시트 카운트)
7. 자료별 차이 **병기**(은폐·임의 단일화 금지)

## §6. 안티패턴

1. ❌ 기존 분석 MD 요약 전재(AS-IS 원시 소스·DB 전수 생략)
2. ❌ MSG/컬럼/메뉴경로/제약 추측 기입
3. ❌ Lookup 부분 추출(전량 아님) / SP 제약 표본 추출
4. ❌ "등록 필요/미구현/편집제약" 격차 은폐 — 격차는 핵심 가치
5. ❌ 이미지 없는 LAYOUT / 상단 안내·쉬운 설명 열 누락(가독성 위반)
6. ❌ 개발용 상세동작 MD 미산출(이벤트 1줄 요약만)

마스터 견본: `Doc/화면설계서/DMF0003_MktFcst_UI분석서_v1.7.xlsx`(10시트) + `DMF0003_MktFcst_상세동작_개발용.md` + 생성 스크립트 패턴(소스덤프→DB실측→제약추출(병렬)→빌드→가독성보완→검증).
