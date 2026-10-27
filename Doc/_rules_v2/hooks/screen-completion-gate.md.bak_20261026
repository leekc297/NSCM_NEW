# Hook — screen-completion-gate (UI 화면 완성도 통합 게이트) ⭐ 2026-06-11 신설

> **트리거**: 신규 화면 작성 완료 직전 / 화면 수정 작업 종료 직전 / "화면 다 됐어?" / PR 제출 전
> **목적**: 화면 개발 시 누락·미구현·런타임 오류가 반복되는 문제 해소.
> 개별 hook 은 작성 "중" 체크인 반면, 본 게이트는 작업 **종료 선언 전 마지막 관문**이다.
> ⚠️ **아래 G1~G10 중 1개라도 미수행 상태로 "완료" 보고 금지.** 각 게이트는 증거(카운트/grep 결과/캡쳐)와 함께 보고한다.
> ⛔ **2026-08-11 사용자 지적** — "POPUP 디자인부터 기능 미구현 / MAIN GRID 에 UI Category Setup 데이터 미사용 /
> CRUD 완료라 했는데 실제로는 오류가 다 발생" 이 **G1~G8 종합 PASS 상태에서** 나왔다.
> ⇒ **G9 신설(§0.4)**. 게이트 통과 = 완료가 아니라, **축별 커버리지 표(안 본 축 = ERROR)** 를 붙여야 완료다.

---

## §0 게이트 매트릭스 (10 게이트 — 전부 의무. **G9 = 2026-08-11 · G10 = 2026-08-20 신설**)

| # | 게이트 | 판정 기준 | 근거 룰/Hook |
|---|---|---|---|
| G1 | AS-IS 매핑 완전성 | `__asis-mapping__.md` 4축 (Event/API/Validation/Expression) 카운트 = AS-IS 분석 자료 행 수와 **정확 일치, 누락 0** + ⭐ **이벤트 ID(E01~) 1:1 대사표 — 빈 칸 0** (총합 비교 폐지, 2026-08-06 SYS0017 감사 계기) | asis-coverage-check §0.0/§0.1 + CLAUDE.md §4-11 |
| G2 | 버튼 10대 매핑 + **동적 권한 fetch** | CRUD 6 + Search Aux 4 전수 판정 (구현/숨김/자동활성 명시) + `() => undefined` 빈 핸들러 0건 + ⭐ **`useTabBtnPermissions` + `hasButton(BTN_CD)` 조건부 사용** (hotkeyConfig 하드코딩 금지) + **신규 화면은 `SCM_ADM_MNU_BTN_MPG_M` + `USER_GR_MNU_BTN_MPG_M` 멱등 INSERT** | asis-button-mapping + ⭐⭐ **ui-dynamic-property-management §3** (master) + **menu-button-dynamic-fetch** (child) |
| G3 | Grid 메타 완전성 + **동적 Column/Measure fetch** | 전 grid: DataGrid 래퍼 + `_inputEditType`/`_ctrlType`/`_modalKey` + SHEET_COLUMNS ↔ SP alias 일치 + selectionMode 명시 + ⭐ **store `staticColumns` + `fetchStaticColumns` + mount/Search 호출 + DataGrid prop 5 단계** + (PIVOT/measure 화면) **`staticMeasures` + `fetchStaticMeasures`** + **신규 화면은 `SCM_MST_SHEET_COLUMNS` + `SCM_MST_SHEET_MEASURE` 멱등 INSERT** + **컬럼 lookup = `CELL_COMBO_DATA_TYPE` 위치 (ATTRIBUTE1 금지)** + **INPUT_TP_CD 'IM' 표준 ('MI' typo 금지)** | grid-column-meta + sheet-columns-binding-match + grid-interaction-patterns + ⭐⭐ **ui-dynamic-property-management §4/§5** (master) + **ui-category-setup-column-meta** (child) + **column-lookup-meta-standard** |
| G4 | 메타/라우팅 정합 | MNU_M (UPPR 대소문자/MNU_DESC/MNU_TP_CD) + SHT_NM FE↔DB 일치 + PROC_M positional + 권한 (MNU_BTN_MPG_M ↔ USER_GR — G2 master 와 cross-ref) | menu-not-displayed-debug 7단계 + proc-meta-signature-match |
| G5 | 정적 검증 + **regression 0 보고** | `pnpm lint:fix` + `pnpm type-check` + `pnpm build` 3종 PASS (출력 첨부) + type-check-error-patterns 17종 grep 0건 + ⭐ **`_artifacts/_local_setup/regression-impact.ps1` 실행** → Hard Boundary 위반 / 영향 도메인 / `procedures.d.ts` 변경 인벤토리 보고 (룰 #62 §9) | type-check-error-patterns + post-write + ⭐ **regression-zero-mandatory §9** |
| G6 | 런타임 smoke (실행 증명) | ⭐ **§0.5 명시 체크리스트 5항 전수** (모달 OK/Cancel · 저장 SYS_LOG 실증 · DB SELECT 왕복 · 콤보 NAME · cascade 1회) + 브라우저 콘솔 에러 0건. "alert 떴으니 됨" 금지 (2026-08-06 SYS0017 감사 계기 정량화) | oracle-db-workflow §2.5 + runtime-error-prevention + screen-runtime-pitfalls P9 |
| G7 | 표준 패턴 정합 + **Figma 레이아웃 정합** | 자매 화면(동일 features 폴더) 1개와 구조 비교: SearchArea/FormItem/Store/Constants/components 폴더 — 임의 작성 0건 + ⭐ **Figma MD(`Doc/_figma/screens/{ID}.md`) 존재 시 영역 배치 6축(상단조건/좌·우/상·하/영역 컨텐츠/버튼/라벨) 정합 — 불일치 0 (수정 작업이면 레이아웃 교체 수행) + `Figma 영역↔구현` 매핑표 보고** | _tobe/01~10 + components-folder-pattern + screen-create-checklist + ⭐⭐⭐ **figma-layout-parity-mandatory** |
| G8 | 이관 완전성 | deploy package 5종 인벤토리 (DDL/META/SP body/GRANT/i18n) + 멱등 SQL + 공용/wrapper SP 포함 | deploy-package-completeness |
| **G9** | ⭐⭐⭐ **메타 실소비 · 셀 컨트롤 3요소 · 저장 경로 전수** | **§0.4 G9-A~G9-D 전수 판정** — ①컬럼명 하드코딩 0건 + 메타↔실동작 모순 질문 ②팝업/콤보 3요소(메타·트리거·파라미터) ③저장 SP 수 = 왕복 수(신규행 C·조회 R 독립) + 원장 delta ④harness = FE 실 payload·다행. **G1~G8 을 전부 통과하고도 터진 3종을 막는 게이트** | ⭐⭐⭐ **#130 ui-meta-consumption-and-crud-path-coverage** (2026-08-11 사용자 지정) |
| **G10** | ⭐⭐⭐ **지정 보완요청 원장 축 (미적용 전제)** | `보완요청_원장.md` 의 이 화면 대상 행 전수 — 러너 **섹션 10** (`asis_mapping_gate --check --requests-only --menu`) PASS: 원장 미편입 0 / **PENDING 0** / 비-PENDING 근거 공란 0 / 판정신호 실측 불일치 0 / 원장↔대사표 상태 정합. **보류(USER-DECISION/VISUAL)·클라우드 N 목록을 완료 보고에 전기** (PASS 여도 생략 금지). 하위문구 단위 판정 — 행 단위 "완료" 금지 | ⭐⭐⭐ **#139 request-ledger-and-subclause-mapping** (2026-08-20 사용자 지정 "미적용 전제") + #126 §2 (F) |

## §0.4 ⭐⭐⭐ G9 신설 — 메타 실소비 · 셀 컨트롤 3요소 · 저장 경로 전수 (2026-08-11 사용자 지정, hook #130)

> 배경: 아래 3종이 **G1~G8 + 러너 9섹션을 "종합 PASS" 로 통과한 채** 사용자 화면에서 터졌다(DMF0044).
> 게이트가 본 것은 "메타가 존재하는가/타입이 맞는가/대사표 칸이 찼는가" 였고,
> **"화면이 그 메타대로 실제로 동작하는가" 와 "저장 경로를 전부 왕복했는가" 는 아무도 보지 않았다.**

| # | 게이트 | 판정 기준 | 실패 시 |
|---|---|---|---|
| **G9-A** | **메타 실소비** | 화면 코드에 **컬럼명 배열 상수**로 표시/편집/잠금을 정하는 코드 **0건**. 판정은 공용 `GridUtils.isEditableCell` **동일 규약**(IM/IO=신규행만·M/O=전 행·S=불가), 색(formatItem)·편집(beginningEdit)이 **같은 함수** 참조. ⭐ **모순 질문 필수** — "이 화면에서 편집되는 컬럼이 메타에서도 편집 가능인가?" (전 컬럼 `'S'` 인데 편집되면 둘 중 하나가 틀린 것) | BLOCK |
| **G9-B** | **셀 컨트롤 3요소** | 팝업/콤보 각각 ①메타 등재(`FPModal`/`FPComboBox`+`CELL_COMBO_DATA_TYPE`) ②트리거 배선 ③파라미터·반환 계약(AS-IS 인자 1:1) — **3요소 모두** 충족해야 대사표 '구현'. ①없음 = 아이콘 미표시 = **사용자가 기능 존재를 모름**. ③이 `'ALL'`/공백 하드코딩 = FAIL | FAIL |
| **G9-C** | **저장 경로 전수** | 화면 저장 SP **인벤토리 수 = 왕복 검증 수**. 축 4종 각각 독립: 기존행 U / **신규행 C**(⛔ 기존행 `activeFlag='I'` 로 대체 불가) / 삭제 D / **조회 R**(⛔ "저장 성공" 으로 대체 불가 — 읽는 표≠쓰는 표 가능). 성공 판정 = **원장 SELECT + 영향행수 delta**(0 이면 FAIL). 토스트·`CODE='0'` 은 증거 아님 | FAIL / 미실행은 **ERROR** |
| **G9-D** | **harness 형태 정합** | 검증 harness 파라미터 = **FE 가 실제로 보내는 값**(빈값·센티널 포함). `'^'` bulk 화면은 **다행 payload**(단일행은 "2행부터 NULL" 계열 결함을 구조적으로 놓침) | FAIL |
| **G9-E** | **저장 멱등성** (2026-08-11 추가, hook #131) | 조회가 PIVOT/GROUP BY 인 화면: ①그룹 축 컬럼 목록 산출 ②저장 기입값 ↔ 원장 분포 대조(`'' AS` 전수 grep — Oracle `''`=NULL) ③**저장 전후 조회 행수 동일 + 화면 식별자 조합 중복 0 실측**(행수 증가 = 유령 행) | FAIL |

⚠ **분기 skip 무동작**: payload 의 구분자 컬럼(예: `CUTOFF_TYPE`)이 비면 SP 의 `IF <구분자>='...'` 분기가
통째로 건너뛰어져 **아무것도 안 써도 SUCCESS** 가 나온다 — G9-C 의 delta 판정이 이것을 잡는 유일한 장치다.

⇒ 상세·실사고 계보·자동 검사 grep = **hook #130 `ui-meta-consumption-and-crud-path-coverage.md`**

## §0.5 ⭐ G6 명시 체크리스트 (2026-08-06 SYS0017 감사 계기 신설 — 서술이 아닌 항목별 판정)

> 배경: SYS0017 13건 재작업 당시 "8게이트 통과" 주장이 type-check 0·메타 건수·PKG VALID 만으로 구성 —
> SYS_LOG 실증 결과 **사용자 검증 세션에 SAVE 호출 0건**(저장 요청이 BE 에 도달한 적 없음)이었다.
> **런타임 왕복 없는 완료 선언 금지.** 아래 5항 각각에 증거 1줄(캡쳐/SQL 결과) 없이 G6 PASS 금지.

- [ ] **G6-1 모달 전수 OK/Cancel 표시** — 화면의 모든 모달을 실제로 열어 footer 버튼(OK/Cancel 또는 자체 footer) 렌더 확인. `customContentArea` 지정 모달은 공통 footer 가 **미렌더**되므로 특히 (screen-runtime-pitfalls **P9**)
- [ ] **G6-2 편집→저장→성공 toast + `SCM_COM_SQL_LOG` 에 SAVE 호출 실증** — 실제 셀 편집/Insert 후 저장하고, `SELECT * FROM SCM_COM_SQL_LOG WHERE MNU_ID='{ID}' AND MNU_BTN_CD='SAVE' ORDER BY CREATION_DATE DESC` 로 **호출이 찍힌 것까지** 확인 (toast 는 증거가 아님 — false success). 성공 toast 문구의 placeholder(`{n}`/`{{var}}`) 실치환 확인
- [ ] **G6-3 저장 후 DB SELECT 왕복** — 저장한 값·감사컬럼(CREATED_BY/LAST_UPDATED_BY=세션 사용자, 빈값 금지)을 대상 테이블 SELECT 로 확인
- [ ] **G6-4 콤보 NAME 표시** — 콤보 셀이 코드 원문이 아닌 명칭(NAME)으로 표시되는지 (CTRL='FPComboBox'+CMBO 배선 — hook #98 §6 값 단언과 짝)
- [ ] **G6-5 cascade 1회 조작** — 종속 콤보/셀 cascade 를 실제 1회 조작해 하위 갱신·잠금 확인 (util 정의만으로는 불통 — post-write §0.1-B 정의-참조 게이트와 짝)
- [ ] ⭐ **G6-6 모달별 CRUD 왕복 (2026-08-07 신설 — 사용자 요구 "MAIN UI 와 모달의 CRUD 누락 0")** — MAIN UI 가 여는 **모달 전수** 각각에 대해 **열기 → 편집/입력 → OK → DB 반영 확인** 1왕복 실증 (예: SYS0017 SQL VIEW 모달 = 열기→SQL 편집→OK→`SCM_ADM_RECIPIENT_LIST.SQL_LONG_TEXT` SELECT 왕복). 조회 전용 모달은 "해당없음+사유" 로 대사표(`__asis-mapping__.md` CRUD·모달 매트릭스)에 기재. 정적 짝 = check-ui-gates **G-E**(모달 확정버튼 부재 의심) + wiring_chain_check **L2A**(모달 파일 call-proc 체인) + asis_mapping_gate `--check --matrix-only`

## §0.6 ⭐⭐⭐ 완료 선언 3-상태 계약 (2026-08-08 신설 — 사용자 명시, hook #126 본문)

> 사용자 요구: "**실제 검증완료까지 되지 않으면 검증완료로 회신하지 않고 반드시 오류로 표기하고 보완**해주세요."

보고 상태는 PASS/FAIL 2 값이 아니라 **PASS / ERROR / FAIL 3 값**이다.

| 상태 | 의미 | 회신 |
|---|---|---|
| PASS | 검증 축이 **실행되어** 통과 | "검증 완료" 허용 |
| **ERROR** | **미실행·미확인·환경파손·미적용** (결함 여부 **불명**) | ⛔ 완료 금지 — ERROR 표기 + 보완 |
| FAIL | 실행되었고 **결함 확인** | ⛔ 완료 금지 — 결함 명시 + 보완 |

- ⛔ **검증하지 못한 것을 문제 없는 것으로 회신 금지.** 환경 오류로 못 돌린 테스트는 PASS 가 아니라 **ERROR** 이며, **환경 복구까지가 작업 범위**다.
- ⛔ **ERROR 섹션이 남은 러너 리포트를 첨부한 완료 선언 금지** (2026-08-08 DMF0082 실사고: 섹션 9 ERROR(jsdom 파손) 상태에서 완료 선언 직전까지 갔다 — 복구 후 재실행 24/24 PASS).
- ⛔ **사내 적용 ≠ 적용 완료.** 클라우드 QA·DEV 미적용은 **ERROR 행으로 명시**한다.
- WARN 은 **사유가 `__asis-mapping__.md` 에 기재된 것만** 허용 — 기재 없는 WARN = ERROR.
- 상세 계약·금지표현표·ERROR 표기 5칸 양식·도구 자기검증 의무 = **hook #126 `verification-completion-honesty.md`**

## §1 누락 다발 지점 (사고 통계 기반 — 우선 점검)

> 2026-05~06 사고 이력에서 반복 빈도 상위:

1. **validation.md / expressions.md 매핑 누락** (G1) — 카운트 불일치 = PR 머지 불가
2. **메타 1글자 불일치** (G4) — UPPR_MNU_ID 대소문자 / SHT_NM / COL_NM camelCase / COLUMN_NAME alias → 화면 미표시·빈 grid·권한없음
3. **silent fail** (G6) — 컴파일 PASS·alert 표시·DB 미반영. DB SELECT 검증 없이는 발견 불가.
   ⭐ **실행 조항 (2026-08-06 SYS0017 감사 계기 — 서술→의무 승격)**:
   - **인터셉터 규약 (명문)**: axios `responseErrorInterceptor`(`packages/foundation/src/apis/axios-interceptors.ts:47`)는 **HTTP 500/403 응답도 reject 가 아니라 resolve** 로 반환한다 (`case 403: case 500: return error.response`). 따라서 `try/catch` 는 저장 실패를 잡지 못하고, `await apiClient.post(...)` 가 정상 리턴한 뒤 성공 alert 가 뜬다 (**false success** — SYS0017 #3 실사고: 저장 실패에도 MSG00004 성공 alert).
   - **의무**: `apiClient.post`(call-proc) **직후** `if (res.status >= 400 || Number(res.data.code))` 실패 분기. 정본 = `features/demand/src/pages/business-plan/utils/business-plan.api.ts:71` (`callProc` — ok/message 반환 + 첫 커서 값 오류문 passthrough).
   - **POST-WRITE grep** (post-write §0.1 #19): 판정 없는 `apiClient.post(.*call-proc` 검출 —
     ```bash
     # call-proc 호출부 후속 5줄에 실패 분기(res.status>=400 / .code 판정)가 없으면 위반
     grep -rnA 5 "apiClient\.post(.*call-proc" features/{domain}/src/pages/{screen}/ \
       | grep -cE "res\.status *>= *400|\.code\)"   # = call-proc 호출 수와 일치해야 함 (0 이면 전건 무검증)
     ```
   - `useProcMutation` 경유 저장은 wrapper 가 code 판정 — 본 조항은 **`apiClient.post` 직접 호출('^' bulk 등)** 대상.
4. **빈 버튼 핸들러 / hotkeyConfig 일괄 false / 하드코딩** (G2) — 기능 자체가 조용히 사라짐. ⭐ 추가 root cause: **`useTabBtnPermissions` 미사용** = admin USE_YN='N' 무시 → 운영 결정 무효화 (master `ui-dynamic-property-management §3` 필독)
5. **자매 화면 미참조 임의 작성** (G7) — DMF0020 조회조건 사고: label+input 임의 작성 → 전면 재작성
6. **lookup combo / popup SP / i18n 키 이관 누락** (G8) — 화면은 되는데 배포처에서 깨짐
7. ⭐ **UI 동적 속성관리 3 구성요소 누락** (G2 + G3) — Menu Button (SCM_ADM_MNU_BTN_MPG_M) / Column (SCM_MST_SHEET_COLUMNS) / Measure (SCM_MST_SHEET_MEASURE) 중 1개라도 admin UI 데이터 부재 + 신규 INSERT 누락 + 하드코딩 → admin 변경 영영 미반영. **사용자 명시 요구 — 절대 누락 금지**. master `ui-dynamic-property-management.md` §6 PRE-WRITE 체크리스트 + §7 grep 5종 의무.
8. ⭐ **컬럼 lookup 메타 위치 오등록** (G3) — `CELL_COMBO_DATA_TYPE` (FE `cellCboDataTp`) 표준 위치 대신 **`ATTRIBUTE1` 위치 등록 시 DataGrid wrapper 인식 안 함** → dropdown 미동작. INPUT_TP_CD 도 `'IM'` 표준, **`'MI'` typo 절대 금지** (FE enum mismatch → cell editor 영원히 미동작). hook `column-lookup-meta-standard.md`.

## §2 게이트 실행 절차

```
0. ⭐ ui_gate_runner 실행 (2026-08-07 신설 — 의무):
   python _artifacts/_diagnostics/ui_gate_runner.py --menu {MNU_ID} --page <페이지폴더> [--analysis <분석md>]
   → _artifacts/_gate_reports/{MNU_ID}_{YYYYMMDD_HHMM}.md 자동 생성
     (① check-ui-gates.ps1 G-A~G-G 전 파일 ② asis_mapping_gate --check EID 1:1
      **+ AS-IS 이벤트 핸들러 인벤토리**(2026-08-08 — `--handlers <MNU> <폴더>` 선생성 의무.
       분석서가 놓친 핸들러 차단. DMF0082 실측 25개 중 대사표 참조는 6개뿐이었다)
      ③ wiring_chain_check --menu FE→BE→SP 체인 + v2 액션·권한 축 L2A/L2P
      ④ SHEET_COLUMNS 값 단언 ⑤ CRUD·모달 매트릭스 --matrix-only
      ⑥ HTTP 셀프 E2E 리포트 검사(hook #125 §2)
      ⑦ UP_FX 콤보 파라미터 정합 — 셀 콤보 @토큰↔FE 전달 대조·quoting·빈 catch·토큰 대사표
         (2026-08-08 신설, hook #117 §5.5~§5.10 — "콤보가 열린다"≠이식 완료)
      ⑧ 콤보 호출 지점(트리거) 대사 — AS-IS 이벤트 핸들러 수 ↔ TO-BE 트리거 수
         (hook #117 §5.12 — InsertRow 누락 검출. "제때 부르는가")
      ⑨ 단위테스트 — 배분/편집판정 등 순수 함수의 **값**을 AS-IS 산식과 1:1 대사
         (asis-coverage-check §0.4 — "값이 맞는가". 환경 오류는 FAIL 아닌 ERROR 로 구분))
1. 작업 종료 선언 전, 본 파일 §0 표를 그대로 복사하여 보고서 작성
2. 각 게이트에 PASS/FAIL + 증거 1줄 (카운트, grep 0건, 캡쳐 경로, SELECT 결과)
3. FAIL 1건이라도 있으면: 보완 → 해당 게이트 재실행 (전체 재실행 불요)
4. ⭐ **ERROR(미실행·환경파손) 섹션이 있으면 환경을 복구해 재실행** — 건너뛰고 완료 선언 금지 (§0.6)
5. 러너 종합 ∈ {PASS, WARN(사유 기재분)} 이고 G1~G8 전수 판정 후에만 "완료" 보고 + pre-submit hook 진입
   → 남은 ERROR/미적용/미확인 축은 **§0.6 3-상태로 별도 표기** (hook #126 §3 5칸 양식)
```

> ⛔ **완료 선언 = ui_gate_runner 리포트 경로 첨부 의무** (2026-08-07 사용자 확인 규약 — SYS0017 감사 §1
> "8게이트 통과 기록 실존하지 않음" 재발 방지): 완료 보고에 `_artifacts/_gate_reports/{MNU_ID}_{ts}.md`
> 경로가 없으면 **미완료로 간주**한다. 러너 종합 FAIL 상태의 완료 선언 금지 (제외/SKIP 은 사유 명시).

### 보고 양식 (복사용)

```md
## screen-completion-gate 보고 — {MENU_ID} ({날짜})
| G | 결과 | 증거 |
|---|---|---|
| G1 AS-IS 매핑 | PASS | validation 23/23, expression 14/14 |
| G2 버튼 10대 + 동적 권한 | PASS | CRUD 3 구현 + 3 숨김, Aux 4 자동활성, `useTabBtnPermissions` 적용, MNU_BTN_MPG_M 7 row + USER_GR 3 그룹 INSERT |
| G3 Grid 메타 + 동적 Col/Measure | PASS | 2 grid, SHEET_COLUMNS 17/17 alias 일치, `staticColumns`+`fetchStaticColumns` OK, (PIVOT 화면) SHEET_MEASURE 4 row, INPUT_TP_CD 'IM' OK |
| G4 메타/라우팅 | PASS | MNU_DESC OK, SHT_NM='xxx' FE=DB |
| G5 정적 검증 + regression 0 | PASS | lint/type-check/build 3종 (로그 경로) + regression-impact.ps1 → Hard Boundary 위반 0, 영향 도메인=master, procedures.d.ts NO |
| G6 런타임 smoke | PASS | §0.5 5항: 모달 3/3 footer OK, SQL_LOG SAVE 1건, SELECT 3 row+감사키 OK, 콤보 NAME OK, cascade 1회 OK, 콘솔 0 |
| G7 표준 정합 | PASS | 자매 DMF0007 대비 구조 동일 |
| G8 이관 완전성 | PASS | 5종 인벤토리 (zip 경로) |
```

## §3 부분 수정 작업 시 축소 적용

화면 전체가 아닌 부분 수정(버그 fix, 컬럼 1개 추가 등)은 **영향 게이트만** 적용하되, **G5(정적) + G6(런타임 smoke)은 항상 의무**:

| 수정 범위 | 의무 게이트 |
|---|---|
| Grid/컬럼 | G3 + G5 + G6 |
| 버튼/이벤트 | G2 + G5 + G6 |
| 조회조건 | G7 + G5 + G6 |
| SP/메타 | G4 + G6 + oracle-db-workflow §2 |
| 단순 스타일 | G5 + G6(진입 확인만) |

---

> Cross-ref: pre-submit.md (본 게이트 8/8 PASS 가 선행 조건) | 00_INDEX §A T01 | anti-simplification.md (게이트 생략 = 위반)
