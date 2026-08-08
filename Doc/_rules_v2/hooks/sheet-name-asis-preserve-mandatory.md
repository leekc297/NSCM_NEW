# Hook — SHEET_NAME = AS-IS 원본 그대로 (개명 금지, 필수)

> 분류: 🆄/🅑 · 트리거: **T01(신규) · T01M(수정) · T04 · T08** · 등급: ⭐⭐⭐ PR 차단
> 신설: 2026-06-26 (SYS0014 Group User — AS-IS `SpdSheet`=GroupInfo/UserInfo/Division 인데 TO-BE 가 main/userInfo/division 으로 개명, 사용자 명시)

## §0. 배경
- AS-IS 화면의 시트 식별자(`SHEET_NAME`)는 **AS-IS DB `SCM_MST_SHEET_COLUMNS.SHEET_NAME`** 또는 (DB 미보유 시) **AS-IS 소스 `SpdSheet` struct 상수**로 정해진다.
- TO-BE 가 이를 **임의 개명**하면 (예: `ContributeMain`→`main`, `GroupInfo`→`main`) AS-IS↔TO-BE 정합이 깨지고, FE `SHEETS` ↔ SP ↔ `SCM_MST_SHEET_COLUMNS` ↔ `SCM_ADM_MNU_BTN_MPG_M.SHT_NM` ↔ 권한(`CustomAuthorizationManager` segments[2]) 전 구간 mismatch → **-9997/빈 grid/권한없음** 사고. (DMF0043 ContributeMain 사고와 동일 메커니즘)

## §1. 핵심 룰 (불변)
**SHEET_NAME 은 "기존에 등록된 (AS-IS 원본) 명칭"을 그대로 사용한다. 개명·축약·소문자화·신규 발명 금지.** *(2026-06-29 사용자 재명시 — "기존 등록 명칭 그대로 사용을 기본으로, rule 적용". DMF0003 'Mkt Fcst'→'main' 발명 사고)*
- 우선순위: ① 사내 권위 메타 `SCM_MST_SHEET_COLUMNS`/`SCM_MST_SHEET_MEASURE` 등록 `SHEET_NAME` → ② AS-IS DB SHEET_COLUMNS → ③ (DB 미보유 시) AS-IS 소스 `SpdSheet`/`shtXxx` 상수 값.
- ❌ **'main' 같은 generic 명칭 발명 금지** — 등록명이 실제로 'main' 일 때만 'main' 사용. 등록명 우선이 원칙([[feedback_sheet_name_main_standard]] 재정의: 'main' 은 한 사례일 뿐 무조건 표준 아님).
- FE `SHEETS` enum **value** = 위 등록 SHEET_NAME 과 **완전 동일** (열거자 이름은 자유, 값은 등록명 그대로). 공백 포함('Mkt Fcst')이면 라우팅 URL `%20` 인코딩 — BE 디코딩 동작 확인.
- 동일 SHEET_NAME 이 **5 구간 전부 일치**(case·공백 포함): FE `SHEETS` value · SP 내부(`SHT_NM`/`v_sheet_name`/`SHEET_NAME = 'xxx'` 리터럴) · `SCM_MST_SHEET_COLUMNS.SHEET_NAME` · `SCM_MST_SHEET_MEASURE.SHEET_NAME` · `SCM_ADM_MNU_BTN_MPG_M.SHT_NM` (+ `SCM_ADM_PROC_M` 해당 시).
- ⚠️ 발명명과 등록명이 **둘 다 존재**하면 measure/컬럼 메타 **이중 등록** 사고(DMF0003: 'main' 12 + 'Mkt Fcst' 47) → 발명명 삭제·등록명 단일화.

## §2. PRE-WRITE (의무)
- [ ] 화면의 AS-IS SHEET_NAME 확보: AS-IS DB SHEET_COLUMNS 조회(`WHERE PROGRAM_ID=...`) 또는 AS-IS `.cs` `SpdSheet` struct grep.
- [ ] FE `SHEETS` value = AS-IS SHEET_NAME 그대로 (개명 0).
- [ ] 메타 SQL(SHEET_COLUMNS/MNU_BTN/PROC_M) 의 SHEET_NAME/SHT_NM = 동일 값.

## §3. 기존 화면 보완 — **해당 화면 수정 시 적용** (mass audit 안 함, 사용자 명시 2026-06-26)
기 개발 화면의 SHEET_NAME 개명 차이는 **그 화면을 수정(T01M)할 때 함께 AS-IS 값으로 정정**한다. 전 화면 일괄 audit/refactor 하지 않는다(00_SCREEN_ANATOMY §0 정책 동일).
- 수정 작업 시 점검: 화면 `*.constants.ts` 의 `SHEETS` value ↔ AS-IS `.cs` `SpdSheet`(또는 AS-IS DB SHEET_COLUMNS) 대조 → 불일치면 5 구간 동시 정정.
- 알려진 차이(수정 시 정정): **SYS0014** (AS-IS GroupInfo/UserInfo/Division ↔ TO-BE main/userInfo/division). **DMF0043** (과거 fix 완료: main→ContributeMain). **DMF0003** (2026-06-29 정정: 발명 'main' → 등록명 **'Mkt Fcst'** 5계층 일괄 + 'main' 삭제 / handoff 42~45 + FE).

## §4. 안티패턴
- ❌ AS-IS `GroupInfo` 를 TO-BE `main` 으로 개명.
- ❌ FE 만 개명하고 SP/메타는 다른 값 (구간 mismatch).
- ❌ "더 짧으니까/관례상" 임의 소문자·축약.

> 짝: `sheet-columns-binding-match`(#54, SHEET_COLUMNS↔SP alias) / `screen-meta-and-permissions-mandatory`(#68) / `menu-not-displayed-debug`(SHT_NM mismatch 디버깅).

---

## [2026-08-07 사용자 재확정] 신규 생성(T01)에도 동일 적용 — 반드시 준수

> 사용자 지시 원문: "UI 신규생성 시 기존의 sheet name 을 변경하지 않고 동일 명칭으로 사용하는 것도 Rule 로 반드시 지켜지도록 해주세요."

- 신규 화면 작성 시 SHEET_NAME 은 **AS-IS 원본 명칭 그대로**(DB `SCM_MST_SHEET_COLUMNS.SHEET_NAME` 또는 `.cs` SpdSheet 명) — camelCase 화·번역·축약 등 어떤 개명도 금지.
- 적용 5구간 동시 일치: FE `SHEETS` enum value · SP(V_SHEET_NAME/PROC 배선) · `SCM_MST_SHEET_COLUMNS` · `SCM_MST_SHEET_MEASURE` · `SCM_ADM_MNU_BTN_MPG_M.SHT_NM`.
- PRE-WRITE 시 AS-IS sheet name 실측(메타 SELECT 또는 .cs) 후 시작 — 추측 명명 금지.
