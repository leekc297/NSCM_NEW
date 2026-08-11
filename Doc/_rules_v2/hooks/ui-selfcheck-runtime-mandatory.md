# Hook #125 — ui-selfcheck-runtime-mandatory (신규 UI 완료 선언 전 셀프 런타임 검증 의무 — 권한별 + 모달 전 기능)

> **트리거**: 신규 화면 생성(T01) / 기존 UI 보완(T01M) — **완료 선언 직전**
> **신설**: 2026-08-07 사용자 명시 ("개발은 로컬에서 클로드코드로 진행하고, 전체 기능 구현 후 테스트를 제가 진행" / "러너로 권한별 테스트까지 진행" / "MAIN UI 의 CRUD 및 BUTTON 기능과 모달이 있는 경우 모달의 모든 기능이 AS-IS 기준으로 동일하게 구현되어 있고 실행되는지도 반드시 확인")
> **위상**: #124(4영역 선행 분석 md) 의 **출구 게이트** — 분석·구현 후 "실제로 도는가"를 클로드가 스스로 증명한다. 사용자는 **시각/조작 최종 테스트만** 수행.

---

## §0. 왜 (이번 세션 실측 근거)

분석 md 3종(주요이벤트·Cascade·제약)이 있고 배선·코드·정적 게이트가 모두 통과했는데도 다음이 잠복했다:
- `P_DMF0082_GET_MAIN_DATA_CURRENT` **상시 ORA-00904**(전 사용자 Current 조회 불능) — 실행 전까지 무증상
- SAVE 검증 게이트(판가 52주·BIZ_TYPE·중장기 구간) 미발견 — 저장 실행 전까지 무증상
- 센티널 변형 3형 분열로 "판가 실존인데 Not Found" — 데이터 실행 전까지 무증상
- 모달이 "형태만" 구현돼도 정적 게이트는 통과

⇒ **실행이 유일한 증명.** 로컬은 저장 포함 전 액션 직접 실행이 표준([[feedback_local_save_sp_direct_execution]]).

---

## §1. SP 직접 CRUD 왕복 (DB 축)

`_artifacts/_diagnostics/crud_roundtrip_{UI}.py` 패턴:
- **U(M)**: 원값+1 → 원장 SELECT → 원복 → 원장 재확인
- **C(I)**: 빈 키·일자 신규 → 원장 확인 → **D** → 원장 확인 → 사전 부재분 한정 정리(잔존 0)
- **조회 전용 division**: 저장 거부 + 원장 불변 실증
- 각 단계 원장 SELECT 근거 + 재조회 일치. 실증 원장 = `_apply_corporate/CRUD_ROUNDTRIP_{UI}_{날짜}.txt`
- 검증 게이트에 막히면 **결함 아님** — 게이트 작동 실증으로 기록하고 §3 으로 전제조건 충족 키 재선정

## §2. BE HTTP 셀프 E2E — `ui_http_e2e.py` (FE 동일 경로)

```
python _artifacts/_diagnostics/ui_http_e2e.py --menu {MNU_ID}
```
`SCENARIOS` 에 화면 시나리오 등록 후 실행(신규 화면 = 등록 의무). 검증 축:

| 축 | 내용 | 실패 판정 |
|---|---|---|
| A 로그인 | `POST /user/login {userId}` → **`result.guest === false` + groups 비어있지 않음 단언**(⚠️키는 `guest`, `isGuest` 아님 — 함정 2) | 게스트 폴백 = FAIL |
| B 권한 | `/admin/menu/{id}/access`·`/auth` — 버튼 목록 | 접근 불가 = FAIL |
| C 메타 | `/admin/menu/{id}/column`·`/measure` × division | 필수 키 컬럼 부재 = FAIL |
| D 콤보 | `/admin/combo-muti` 전 키 | 0행 = WARN(조용한 빈콤보) |
| E 조회 | FE 실사용 버튼 + 부가 배선 × division | 500/오류 = FAIL, 조회전용 division EDIT_FLAG≠'N' = FAIL |
| F 저장 | SAVE 왕복(+1→재조회→원복) + 조회전용 거부 | 미반영/미원복 = FAIL |
| G 모달 | **모달 시트 API 전수**(§4) | 오류/0커서 = FAIL |
| H **권한별** | **Division×역할 로스터 전 계정**(§5) | auth 목록 ↔ 실호출 불일치 = FAIL |

⚠️ 함정 4종(전부 실측 2026-08-07):
1. 로그인 Content-Type 은 정확히 `application/json` (`equals` 비교 — charset 붙이면 실패)
2. **미등록 ID 도 로그인 200 + 게스트 폴백** → 권한 검증이 통째로 무의미해짐. ⚠️ 응답 키는 **`guest`(불리언)** — `isGuest` 는 **존재하지 않는다**. `isGuest` 로 단언하면 `None`(falsy)이라 **무력 단언**(실제로 겪음) → `info.get("guest") is not False` + `groups` 비어있지 않음 2중 단언 의무
3. `/sso/dev-login` 은 302 (`-L` 금지)
4. `/admin/menu/{id}/auth` 실측 스키마 = `{"mnuBtnAuth": ["SEARCH","SAVE",...](문자열 배열), "unitAuth":[{unitTpCd,unitId,editYn,editable}]}` — dict 리스트로 가정하면 파싱 0건이 되어 권한 축이 조용히 비활성화됨

**권한 판정 2축(필수)**: ①`mnuBtnAuth` 버튼 유무 ↔ 실호출 200/403 ②**`unitAuth[].editable`(Division 편집권한) ↔ 조회 결과 행 `EDIT_FLAG` 분포** — Viewer/조회전용이면 'N' 전량, Admin/Planner 면 'Y' 포함. DMF0082 실증: yooah.chung(Viewer/40)=editable false·EDIT_FLAG 'N' / eunah.koo(Planner/40)=true·'Y' / wonqthanq(82)=조회전용 'N'.

## §3. 데이터 전제조건 실측 선정 의무

검증 게이트를 통과할 수 있는 **테스트 키·계정을 실측 SQL 로 선정**해 리포트에 기록한다
(예: 판가 52주 커버리지 보유 키, BIZ_TYPE NULL 행 부재 아이템, 권한 보유 사이트).
충족 데이터가 없으면 **"데이터 대기"로 명시** — 코드 결함과 반드시 구분(무단 "정상" 판정 금지).

## §4. ⭐ 모달 = MAIN UI 동등 검증 — **7축 전수** (2026-08-07 명시 · **2026-08-10 2차 강화**)

> 사용자 지시(2026-08-10 ①): **"각 UI 와 UI 에 사용되는 MODAL 에 대해서도 DESIGN 부터, 기능,
> VALIDATION, EXPRESSION, CRUD 까지의 모든 검증을 진행하여야 한다. 반드시"**
> 사용자 지시(2026-08-10 ②): **"권한이나 CASCADE FILTER 의 경우에도 MAIN UI 와 동일하게 적용되도록"**
> ⇒ 5축 → **7축**(권한 · Cascade Filter 추가).

**MAIN UI 와 그 화면이 여는 모든 모달**을 **동일한 검증 단위**로 본다.
`__asis-mapping__.md` 의 `MODAL:{이름}` 행마다 아래 **7축 전부**를 실증 근거와 함께 기입 — 빈 칸 1개 = 미완료.

| # | 축 | 확인 내용 | 근거 형식 |
|---|---|---|---|
| 1 | **DESIGN** | AS-IS 레이아웃 1:1 — **조회조건 항목 누락 0**(AS-IS 에 있는 조건은 전부 존재) · 표준 컴포넌트 사용(Division/Period/일자/년월 = `@master/searchFields` 카탈로그, raw InputField 금지) · 36px · P9 footer · No. 코너 · 3색 · 아이콘 순서 | 파일:라인 + AS-IS `.cs`/캡쳐 대조 |
| 2 | **기능(OPERATION)** | AS-IS 버튼·액션 **전수**를 **각각 1회 이상 실행**. 분기(Type/모드/division)가 있으면 **분기별로** 실행 | 실행 로그(HTTP status + 결과) |
| 3 | **VALIDATION** | AS-IS 검증 메시지 전수(MSG ID·발동 조건) ↔ TO-BE 1:1, **실제 발동 확인** | MSG ID + 발동 지점 파일:라인 |
| 4 | **EXPRESSION** | 잠금/활성·표시조건·자동세팅(LockRange·SetValue·ControlDisplay 계열) 1:1 | AS-IS 라인 + TO-BE 판정 함수 |
| 5 | **CRUD** | C/U/D 각각 왕복 실행(원복 포함) + 부모 화면 반영. 없으면 "조회 전용" **사유 명시** | 실행 로그 · 원장 검증 |
| 6 | ⭐ **권한(AUTH)** | §4.1 — MAIN UI 와 **동일 메커니즘**으로 버튼 노출·편집·저장이 갈리는지 | `useTabBtnPermissions` 호출 라인 + 권한별 실행 로그 |
| 7 | ⭐ **CASCADE FILTER** | §4.2 — 상위 선택 변경 시 하위 콤보/그리드가 MAIN UI 와 **동일 규칙**으로 재필터·초기화 | 종속 매트릭스 + 실행 근거 |

### §4.1 권한 축 — 모달도 MAIN UI 와 동일 메커니즘 (2026-08-10 신설)

- ✅ **정본 메커니즘 = `useTabBtnPermissions({ menuId })` 의 `hasButton(MNU_BTN_CD)`** — MAIN UI 가 쓰는 그것을
  모달도 **그대로** 쓴다. 모달만 다른 판정식(그룹명 하드코딩, prop 로 내려받은 boolean 등)을 쓰면 위반.
- ⛔ **그룹명 하드코딩 금지** (`'ADMIN'`, `'DM ADMIN'` 문자열 비교). AS-IS 가 그룹명을 하드코딩했더라도
  TO-BE 이관 vehicle 은 **버튼 권한 메타**(`SCM_ADM_MNU_BTN_M` + `SCM_ADM_USER_GR_BTN_MPG_M`)다.
  ⇒ AS-IS 의 "ADMIN·DM ADMIN 만 Edit/Insert/Save" 는 **그 버튼 코드를 해당 그룹에만 부여**하는 메타로 이관한다.
- ⛔ **`session.groupId` 로 판정 금지** — 유령 필드다. 그룹 판정이 불가피하면 **보유 권한그룹 합집합**
  (AUTHUNION, 2026-08-04 확정)만 사용한다. [[feedback_session_groupid_ghost_field]]
- ⚠ **AS-IS 팝업의 `IsPopup = true` 를 "권한 없음"으로 오독 금지.** AS-IS 에서 이 플래그는
  *프레임워크 표준 버튼권한 체크를 건너뛴다*는 뜻이지 **권한이 없어도 된다**는 뜻이 아니다.
  실제로 같은 프로젝트의 `DMF0044_SalesReportExchangePopup` 은 `IsPopup=true` 이면서도
  `DefineProperty()`/`SaveButton()` 에서 그룹을 직접 검사한다(2중). 팝업별로 **원문을 읽어** 판정한다.
- **검증**: §5 로스터 계정으로 **권한 있는 계정 = 버튼 보임·실행 성공** / **없는 계정 = 버튼 숨김·직접 호출 403**
  둘 다 실측한다. 한쪽만 확인 = 미완료.

### §4.2 Cascade Filter 축 — 모달도 MAIN UI 와 동일 규칙 (2026-08-10 신설)

- 모달 안의 조회조건·셀 콤보도 MAIN UI 와 **동일한 종속 규칙**을 따른다:
  Division 변경 → 하위 콤보 재조회 + **Grid 초기화 + CRUD reset** ([[feedback_division_change_grid_reset]]),
  셀 콤보 파라미터(`param1`/`param2`)는 AS-IS `SpreadInfo` 계약대로 전달([[feedback_meta_cell_combo_param_contract]]),
  상위 셀 편집 시 하위 셀 값 클리어(hook #59 §5-G 표준).
- ⛔ 모달이라는 이유로 **콤보 파라미터 무전달**(조용한 0행 → CODE raw 표시) 금지 — MAIN UI 와 동일 검사 대상.
- **검증**: 상위 값을 **최소 2개 값**으로 바꿔가며 하위 행수가 실제로 달라짐을 근거로 남긴다.

- ⛔ **SEARCH 만 호출하고 "모달 검증 완료" 선언 금지.** 2026-08-10 실사고: DMF0044 `unitedVersion` 을
  `modal_sheets` 의 **SEARCH 만** 돌려 PASS 처리했는데, 사용자가 화면에서 **Version Create 시 SQL ERROR** 를
  발견했다. ACTION / ACTION_BP / TRANSFER 는 **한 번도 실행되지 않았다**.
  ⇒ `ui_http_e2e` 의 `modal_sheets` 는 **버튼 전수**(`btn` 목록)를 돌려야 하며,
  조회 전용이 아닌 모달은 §4-5 CRUD 축이 비면 **FAIL**로 판정한다.
- MAIN UI 도 동일: **CRUD 6종 + 공통/특화 버튼 전수**가 실행 근거를 가져야 한다(hotkeyConfig 표시 버튼 = 각각 1회 이상 실행 또는 정당 사유).
- "형태만 만든 모달" 차단 = 위 표의 **기능·CRUD 축 실행 로그**가 핵심이다.

## §5. ⭐ 권한별(Division×역할) 테스트 의무 — 공식 로스터 (사용자 지정 2026-08-07)

러너 `ROSTER` 상수에 등재된 **Division별 5역할 계정 전수**로 실행한다(기본 `--users` 값):

| Division | DM Admin | DM Planner | DM Planner(W/S) | DM Viewer | SCP Planner |
|---|---|---|---|---|---|
| **40** | hongjae.kim | eunah.koo | — | yooah.chung | dodae |
| **81** | jiwon.park | bpark416 | jaehyeok | park6151 | bottle |
| **82** | wonqthanq | ys_cho | miyeong.lee | yeonjusung | coeogus |

- 각 계정: 로그인(`guest === false`) → 해당 division 조회 → 버튼 권한 목록 ↔ 실호출 응답 대조(권한 없는 버튼 = 403 기대).
- **Viewer/SCP Planner 계정의 저장 차단**과 **Admin/Planner 의 편집 허용**이 실제로 갈리는지 확인(EDIT_FLAG·hasButton·403).
- 계정 추가/변경 시 러너 `ROSTER` 갱신 = 본 hook 갱신과 동시.

## §6. 부속 확인 (누락 상습 지점)

- **개인화 이중 경로**: 신규 사용자(titleset 시드) + 기존 사용자(오버레이/재시드) 양 경로
- **i18n**: 신규 MSG/LBL 은 `public/locales/{KO,EN,CN}.json` 실값 확인(DB 만 = fallback 표시 — #114 §5)
- **회귀**: 공용 콤보/컴포넌트 수정 시 소비자 전수 grep(#117 §3) + 대표 타화면 1개 조회 실행

## §7. 완료 선언 형식 (의무)

```
[완료] {MNU_ID} — 게이트 리포트: _artifacts/_gate_reports/{MNU}_{ts}.md
                  HTTP E2E: _artifacts/_gate_reports/{MNU}_http_e2e_{ts}.md (종합 PASS/WARN)
                  CRUD 왕복: _apply_corporate/CRUD_ROUNDTRIP_{MNU}_{날짜}.txt
                  잔여(사용자 최종 테스트): 화면 렌더링·조작감·레이아웃
```
위 3 산출물 경로가 없는 완료 보고 = **미완료 간주**.

관련: #124(선행 분석 md 우산) · screen-completion-gate(8 게이트·G6) · asis-coverage-check(EID·CRUD·모달 매트릭스) · #104(클라우드/파급 SP 는 여전히 실행 게이트) · [[feedback_local_save_sp_direct_execution]]

---

## §8. ⭐ 런타임 무효화(ORA-04063) 선행 점검 — 2026-08-07 실사고 반영

E2E/검증 실행 전과 FAIL 발생 시 **오브젝트 유효성부터 확인**한다. 코드·메타·정적 게이트가 모두 정상인데 화면만 죽는 대표 유형이다.

```sql
-- (1) 대상 PKG/SP 유효성
SELECT OBJECT_TYPE, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_{UI}';
-- (2) 의존 객체 중 INVALID (연쇄 원인)
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM USER_OBJECTS
 WHERE STATUS='INVALID' AND OBJECT_NAME IN (SELECT REFERENCED_NAME FROM USER_DEPENDENCIES WHERE NAME='PKG_{UI}');
-- (3) 스키마 전역 무효화 이벤트 여부 (대량 = 외부 배포/재컴파일 정황)
SELECT COUNT(*) TOT, SUM(CASE WHEN LAST_DDL_TIME > SYSDATE-30/1440 THEN 1 ELSE 0 END) RECENT30M
  FROM USER_OBJECTS WHERE STATUS='INVALID';
```

**복구 순서**: 의존 함수/프로시저 → PKG BODY 순으로 `ALTER ... COMPILE` (역순이면 재무효화).

**판정 규칙**:
- BE 로그(`SCM_COM_SYS_LOG.EXCT_MSG_CTN`)에 `ORA-04063` + `ORA-06508` = **무효화 연쇄**(코드 결함 아님) — 재컴파일 후 재실행.
- 최근 30분 무효화가 수백 건이면 **스키마 전역 이벤트**(외부 배포·자동 재컴파일). 이때는 재컴파일해도 재발할 수 있으므로 **이벤트 종료 후 재검증**하고, INVALID 총수 추이(감소=재컴파일 진행 중)를 함께 본다.
- 실사고(2026-08-07): 30분간 820개 INVALID → `UF_FX_STRING_SPLIT` 무효화 연쇄로 `PKG_DMF0082` BODY INVALID → 전 계정 조회 HTTP 500. 두 차례(19:24·19:35) 재발, 재컴파일로 복구. **정적 게이트 6섹션은 전부 PASS 상태였다 — E2E 실행만이 검출**.
