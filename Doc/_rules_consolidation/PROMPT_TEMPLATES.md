# 신규/수정 화면 작업 프롬프트 템플릿 (룰 누락 0)

> 목적: 신규 화면(T01)·기존 화면 수정(T01M)·전수 룰 점검 시 RULESET_MASTER 의 모든 룰이 누락 없이 적용되도록 강제.
> 원리: 프롬프트가 ① 룰을 읽게 하고 ② 트리거를 선언하고 ③ 체크리스트·AS-IS 매핑·종료 게이트를 **보고로** 요구.
>
> ⭐ **사용법 (2026-06-18 변수화)**: 각 템플릿 **상단 `[변수]` 블록의 `{{ }}` 값만 채우면** 본문이 자동 참조한다.
> 본문은 손대지 말고 그대로 복사. `{{DOMAIN}}` 만 정하면 분석자료 경로·분석서 폴더가 자동 결정된다(아래 표).

### 도메인 → 경로 매핑 (변수 DOMAIN 이 자동 결정)

| {{DOMAIN}} | 분석 MD 폴더 | 분석서 xlsx 폴더 |
|---|---|---|
| DM | `Doc/_analysis/domain_DM/screens/{{ASIS_SCREEN}}/` | `_analysis/_screens/27_DM_Screens/` |
| Common | `Doc/_analysis/domain_Common/screens/{{ASIS_SCREEN}}/` | `_analysis/_screens/28_Common_Screens/` |
| SCM | `Doc/_analysis/domain_SCM/screens/{{ASIS_SCREEN}}/` | `_analysis/_screens/29_SCM_Screens/` |
| SCP | `Doc/_analysis/domain_SCP/screens/{{ASIS_SCREEN}}/` | `_analysis/_screens/30_SCP_Screens/` |
| SSP | `Doc/_analysis/domain_SSP/screens/{{ASIS_SCREEN}}/` | `_analysis/_screens/31_SSP_Screens/` |
| FP | `Doc/_analysis/domain_FP/screens/{{ASIS_SCREEN}}/` | `_analysis/_screens/32_FP_Screens/` |

---

## A. 기존 화면 수정 (T01M)

```
[변수 — 아래만 채우세요]
{{MENU_ID}}   = DMF0043
{{SCOPE}}     = (수정 범위를 구체적으로: 예) 메인 grid 에 '공급사' lookup 컬럼 추가 + 조회조건에 'Plant' 추가
{{REFERENCE}} = DMF0004(Tab) | DMF0005(Panel) | DMF0006(단일grid)   ← 미정이면 "시나리오 매칭"

[작업] {{MENU_ID}} 화면 수정 — {{SCOPE}}

[시작 전 필독]
- Doc/_rules_v2/anti-simplification.md
- Doc/_rules_consolidation/RULESET_MASTER.md  (§2 트리거 / §3 UI-MANDATORY 체크리스트 / §6 / §7)
- Doc/_rules_v2/00_INDEX.md

[적용 규칙 — 누락 0]
1. 이 작업은 트리거 T01M(기존 화면 수정)이다. RULESET_MASTER §2 에서 T01M + 해당 연관 트리거
   (T04 Grid·컬럼 / T05 조회조건·combo / T06 Modal / T07 Button) 를 모두 식별해 적용하라.
2. AS-IS 누락 0: {{MENU_ID}} 의 .cs / .Designer.cs 를 처음~끝 정밀 read 하고
   Event / API / Validation / Expression / Button 을 1:1 매핑하라. 기존 __asis-mapping__.md 있으면 cross-check.
3. RULESET_MASTER §3 UI-MANDATORY 체크리스트(PRE-WRITE)를 한 항목씩 통과하고 결과를 표로 보고하라
   (각 항목: 통과 / 해당없음 / 조치함 + 근거 hook).
4. 수정 특칙(T01M): regression-zero Hard Boundary 준수 —
   packages/shared, packages/foundation, packages/lges, 타 도메인, 타 화면, nscm-be 는 변경 금지.
   컬럼 변경이면 column-meta-rework-checklist 8 점검 + PIVOT 동적컬럼 NVL wrap 확인.
5. 작성 직후 §3.3 POST-WRITE grep 자가검증 (FlexGrid 직접 JSX / clsx·lodash·react-query 직접 import /
   window.alert / 인라인 dialog / set({}) 즉시교체 = 0).
6. 종료 전 screen-completion-gate 8 게이트 통과 + 보고 양식으로 제출.

[원칙] 단순화·생략·변환기 1회 통과 채택 금지. 적용 못 한 룰은 숨기지 말고 항목+보완안 명시.
       불확실하면 {{REFERENCE}} (또는 DMF0004/0005/0006)과 cross-check.
```

---

## B. 신규 화면 생성 (T01) — AS-IS 분석 cross-check + 전체 룰 적용

> 핵심: 착수 전 "적용대상 업무 분석"을 분석파일·원시소스·매트릭스 3-way cross-check 로 확정 →
> 그 인벤토리(카운트) 기준으로 전체 룰 적용. AS-IS 인벤토리 N건 = TO-BE 적용 N건(누락 0)이 머지 조건.

```
[변수 — 아래만 채우세요]
{{MENU_ID}}     = (신규 MENU_ID: 예 DMF0099)
{{DOMAIN}}      = DM | Common | SCM | SCP | SSP | FP        ← 분석 경로 자동 결정(상단 표)
{{ASIS_SCREEN}} = (AS-IS 화면 폴더/ID: 예 DMF0043)          ← 모르면 "분석자료에서 식별"
{{PURPOSE}}     = (화면 용도 1줄)
{{REFERENCE}}   = DMF0004(Tab) | DMF0005(Panel) | DMF0006(단일grid)   ← 미정이면 "시나리오 매칭"

[작업] {{MENU_ID}} 신규 화면 생성 — {{PURPOSE}} (도메인 {{DOMAIN}}, AS-IS {{ASIS_SCREEN}})

[시작 전 필독]
- Doc/_rules_v2/anti-simplification.md
- Doc/_rules_consolidation/RULESET_MASTER.md  (§2 / §3 / §4 / §5 전부)
- Doc/_rules_v2/00_INDEX.md

[1단계 — 적용대상 업무 분석 (분석파일 + 원시소스 cross-check, 누락 0)]
1. 분석 MD 8종 정밀 read: Doc/_analysis/domain_{{DOMAIN}}/screens/{{ASIS_SCREEN}}/
   (analysis / validation / expressions / web_components / tobe_design / oracle_migration / figma_link / source_links).
   ⭐ validation.md + expressions.md 는 필독.
2. 화면 분석서 xlsx: _analysis/_screens/{{DOMAIN 대응}}_Screens/ 의 {{ASIS_SCREEN}}.xlsx 중
   11_Validation + 12_Expression 시트.  ⚠️ 1~10 시트 신뢰 금지(오염 이력) — 상충 시 MD 폴더 1차 신뢰.
3. 통합 매트릭스: _analysis/Screen_POPUP_SP_Tables_Matrix.xlsx 에서 {{MENU_ID}}/{{ASIS_SCREEN}} 의
   POPUP / SP / Tables 추출.
4. 원시 AS-IS 소스: source_links.md 의 경로로 GSCM/ 의 .cs + .Designer.cs 처음~끝 정밀 read
   (block 200~500라인). 모든 Event / API(SP) / Validation(GMessageBox) / Expression(Lock/SetValue) /
   Button / POPUP(new XxxPopup) 추출.
5. ⭐ 3-way cross-check: [분석 MD] ↔ [원시 .cs] ↔ [매트릭스] 항목·카운트 일치 확인.
   불일치 시 원시 소스를 정답으로 삼고 차이를 보고하라.
6. 산출: "적용대상 업무 정의" + 인벤토리 표(Event/API/Validation/Expression/Button/POPUP/SP/Table 각 건수).

[2단계 — 배치 결정]
7. features 폴더 결정: SCM_ADM_MNU_M 트리 walk-up → 최상위 부모로 features/{layer} 매핑 (CLAUDE.md Step 3.5,
   Router.tsx import 검색으로 기존작성/cross-check 판정).
8. reference baseline = {{REFERENCE}} (미정이면 Tab=DMF0004 / Panel=DMF0005 / 단일grid=DMF0006 중 매칭).

[3단계 — 전체 룰 적용 개발 (누락 0)]
9. RULESET_MASTER §2 T01 의 필독 룰(_tobe/01~10 + _asis/00_framework/01~07)과 ⭐⭐⭐ mandatory hook 전부 적용.
10. §3 UI-MANDATORY 체크리스트(PRE-WRITE) 전 항목 통과 + 표 보고. 동적 속성 3종
    (ui-dynamic-property-management / menu-button-dynamic-fetch / ui-category-setup-column-meta) admin 데이터
    부재 시 신규 등록.
11. 신규 SP/메타 필요 시: be-infrastructure-reuse(기존 인프라 우선) + 메타 SQL 7-BLOCK + scmd-app-grant +
    proc-meta-signature-match (T08/T12).
12. __asis-mapping__.md 작성 — 1단계 인벤토리 카운트 = 코드 적용 건수 정확히 일치(모든 행 ✅).

[4단계 — 검증·보고]
13. §3.3 POST-WRITE grep 0 + screen-completion-gate 8 게이트 통과.
14. 카운트 일치 보고: AS-IS 인벤토리 N건 = TO-BE 적용 N건(Event/API/Validation/Expression/Button/POPUP 각각).
    필요 시 이관 패키지(deploy-package-completeness).

[원칙] 단순화·표본 분석·위반 은폐 금지. xlsx 1~10 시트 신뢰 금지. 카운트 불일치 = 재작업.
       불확실하면 {{REFERENCE}} (또는 DMF0004/0005/0006)와 cross-check.
```

---

## E. 전면 룰 준수 점검·교정 (전수 audit — 특정 기능 변경 아님)

> 용도: "이 화면에서 **룰을 안 지킨 모든 부분**을 찾아 전부 고친다." 기능 추가가 아니라 준수성 audit + 일괄 교정.

```
[변수 — 아래만 채우세요]
{{MENU_ID}} = DMF0043

[작업] {{MENU_ID}} 룰 전면 점검·교정 — 특정 기능 변경이 아니라, 현재 화면이 NSCM 룰을 따르지 않는
       모든 부분을 빠짐없이 찾아 전부 교정한다.

[시작 전 필독]
- Doc/_rules_v2/anti-simplification.md
- Doc/_rules_consolidation/RULESET_MASTER.md  (§2 / §3 / §4 / §5 / §6 / §7 전부)
- Doc/_rules_v2/00_INDEX.md

[1단계 — 전수 점검 (Audit)]
1. 이 작업은 T01M(기존 화면 수정)이자 "전면 룰 준수 점검"이다.
2. {{MENU_ID}} 의 모든 자원을 처음~끝 정밀 read:
   Page / Store / constants / types / utils / components / modals / *.module.scss / i18n(KO,EN,CN)
   + 관련 BE 메타(API_M/PROC_M/SHEET_COLUMNS) + SP.
3. RULESET_MASTER 와 한 항목도 빠짐없이 대조:
   · §3 UI-MANDATORY 체크리스트 전 항목
   · §4 hook 카탈로그 중 UI/공통 전부 — 특히 datagrid-shared-component / screen-shell-composition /
     screen-conventions / regression-zero / subtitle-button-actions / messaging-api-and-search-fields /
     popup-modal-and-routing / cascade-combo-filter / column-lookup-meta-standard / i18n-ko-en-alignment /
     react-query-foundation-reexport / relative-import-order / components-folder-pattern / wijmo-* 등
   · §5.1 _tobe 13 룰
4. AS-IS 누락 0: {{MENU_ID}} .cs / .Designer.cs 1:1 cross-check + __asis-mapping__.md 갱신(모든 행 ✅).
5. "룰 준수 점검표" 보고 — 컬럼: [룰/hook | 현재 상태 | 준수/위반/해당없음 | 위반 상세 | 조치안].
   ⚠️ 위반은 하나도 숨기지 말 것. 표본·일부만 점검 금지(anti-simplification).

[2단계 — 전면 교정 (Remediate)]
6. 점검표의 '위반'을 전부 수정(일부만 금지).
7. regression-zero Hard Boundary 준수: packages/shared, foundation, lges, 타 도메인, 타 화면, nscm-be 변경 금지.
   경계 때문에 화면 자체에서 못 고치는 위반은 '경계 외 조치 필요'로 분리 보고 + 분리 PR 제안.
8. 인라인 <FlexGrid> → @shared/components DataGrid + @foundation/utils(GridUtils/GridAction/EditTracker/
   CustomMergeManager) 변환 + grid 를 components/ 분리(Page ≤ 400라인).
9. 컬럼 관련 위반이면 column-meta-rework-checklist 8 점검 + PIVOT 동적컬럼 NVL wrap.

[3단계 — 검증·보고]
10. §3.3 POST-WRITE grep 전부 0.
11. screen-completion-gate 8 게이트 통과.
12. 최종 보고: 위반 건수(전/후) + 교정 완료 목록 + 잔여(경계 외) 항목 + 변경 파일 목록.

[옵션] 분량이 크면: "영역별(Grid → Form → Button → Popup → i18n → import 순)로 점검표를 먼저 완성한 뒤 교정".
[원칙] 단순화·표본 점검·위반 은폐 금지. 불확실하면 DMF0004/0005/0006 과 cross-check.
```

---

## C. 짧은 버전 (한 줄 — 변수만 치환)

수정:
```
{{MENU_ID}}={DMF0043}  {{SCOPE}}={내용}
→ {{MENU_ID}} 수정 — {{SCOPE}}. RULESET_MASTER.md 읽고 T01M 처리: §3 UI-MANDATORY 전 항목 통과(표 보고) →
  AS-IS .cs 1:1 매핑(누락 0) → regression-zero Hard Boundary → POST-WRITE grep → 8게이트 보고. 단순화 금지.
```

신규:
```
{{MENU_ID}}={DMF0099} {{DOMAIN}}={DM} {{ASIS_SCREEN}}={DMF0043} {{PURPOSE}}={용도}
→ {{MENU_ID}} 신규({{PURPOSE}}). RULESET_MASTER 읽고 T01 처리: ① domain_{{DOMAIN}}/screens/{{ASIS_SCREEN}} 8 MD
  (validation·expressions 필독) + 분석서 11/12 시트(1~10 신뢰금지) + Matrix + 원시 GSCM .cs 3-way cross-check
  로 인벤토리(카운트) 확정 → ② features 폴더 + reference 선정 → ③ §3 전 항목 통과(표) + 동적속성 3종 +
  __asis-mapping__ → ④ POST-WRITE grep 0 + 8게이트 + "AS-IS N건=TO-BE N건". 단순화·표본·은폐 금지.
```

전수 audit:
```
{{MENU_ID}}={DMF0043}
→ {{MENU_ID}} 룰 전면 점검·교정. RULESET_MASTER 전체 읽고 ① 전 자원을 §3+§4(UI/공통)+§5 와 전수 대조해
  "준수 점검표"(룰|상태|준수/위반/해당없음|조치안) 보고(은폐·표본 금지) → ② 모든 위반 교정(FlexGrid→DataGrid·
  components 분리 포함, Hard Boundary 밖은 분리 PR) → ③ grep 0 + 8게이트 + 위반 전/후 건수. 단순화 금지.
```

---

## D. 각 절이 막아주는 누락 (왜 필요한가)

| 프롬프트 절 | 막는 누락 | 근거 |
|---|---|---|
| "RULESET_MASTER 읽고 시작" | 룰 미로드 → 임의 코딩 | 진입점 단일화 (R-1) |
| "T01/T01M 선언 + 연관 트리거" | 잘못된 룰셋 적용 / Grid·Form 룰 누락 | §2 트리거 매트릭스 |
| "3-way cross-check + 카운트" | 분석/소스 한쪽 치우침, Event/Validation 누락 | anti-simplification 원칙 2 |
| "§3 체크리스트 표 보고" | 동적속성·권한·i18n·cascade 누락 | §3 UI-MANDATORY |
| "Hard Boundary 준수" | 공용/타화면 건드려 regression 발생 | regression-zero (#41) |
| "column-meta-rework 8점검" | 컬럼 수정 시 admin 동기·NVL 누락 | #8 / pivot-nvl (#32) |
| "POST-WRITE grep" | FlexGrid 직접 JSX·금지 import 잔존 | §3.3 |
| "8 게이트 보고" | 종료 선언만 하고 검증 누락 | screen-completion-gate (#46) |
| "위반 은폐 금지 / 단순화 금지" | 1회 통과·요약·표본 채택 | anti-simplification (최우선) |
