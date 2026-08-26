# Hook — UI 작업 진입 플레이북 (보완 = T01M 전면 점검·교정 / 신규 생성 = T01 전체 룰 적용)

> **트리거 (자동 첨부 — attach-context.ps1 배선)**:
> - "**보완**" / "보완요청" / "수정 UI" / "UI 교체" → **§1 수정 UI 플레이북 (T01M)**
> - "**신규 생성**" / "신규 UI" / "화면 생성" / "신규 화면" → **§2 신규 UI 플레이북 (T01)**
>
> **목적**: 트리거 단어만으로 아래 전체 절차가 기동되어 **필수 적용사항 누락 0** 을 보장한다.
> 사용자가 절차를 다시 나열하지 않아도 본 플레이북 전문이 요청문과 동등하게 적용된다. (사용자 명시 2026-07-02)

작성: 2026-07-02 (사용자 요청 원문 채록 — 과거 위반: DataGrid 미사용 / sort·filter 기본버튼 누락 /
기능버튼(추가·삭제·저장) 미노출 / UI Category Setup 미사용 데이터 방치)
상위 룰: `anti-simplification.md` / 진입: `RULESET_MASTER.md` §2 T01·T01M

---

## §0. 공통 필수 4대 (수정·신규 공통 — 위반 시 재작업, 과거 실제 위반분)

| # | 필수 사항 | 근거 hook |
|---:|---|---|
| 1 | **공용 DataGrid 사용 필수** — 인라인 `<FlexGrid>` JSX 직접 사용 금지 (`@shared` DataGrid + `@foundation/utils` GridUtils/GridAction/EditTracker) | #60 datagrid-shared-component-mandatory |
| 2 | **Sort/Filter/Condition/Reset 기본 버튼 자동 활성** — hotkeyConfig 에서 임의 false 금지 (생략=자동활성) | #64 subtitle-button-actions + feedback_search_aux_default_activation |
| 3 | **실제 기능(추가/삭제/저장)이 있으면 기능버튼 필수 노출** — 기능 구현하고 버튼 미추가 금지. hotkeyConfig insert/delete/save + 권한(hasButton) 배선 + BTN_MPG 메타 | #64/#68/#97 |
| 4 | **UI Category Setup(SHEET_COLUMNS 등 admin 메타)은 실사용 데이터로 정비** — 실제 사용하는 컬럼/속성으로 채우고 **미사용 데이터는 VALID_YN='N'/삭제 처리** (임의 생성은 여전히 금지 — 기존·실사용 기준) | #13 ui-category-setup-no-arbitrary-data + #65 ui-category-setup-column-meta |

> **질의 정책**: 추가 질의사항은 **rule 기반으로 자체 해결** (별도 문의 불필요 — 룰/reference/분석자료에서 답을 찾고, 룰에 답이 없을 때만 질문).

---

## §1. 수정 UI 플레이북 (T01M — "보완" 트리거 시 아래를 요청문과 동등 적용)

```
Target UI : {대상 화면}
Target UI 전면 점검·교정. 특정 기능 변경이 아니라 룰 미준수 부분을 전부 찾아 고친다.
(FIGMA 파일이 있으면 상세분석해서 객체별 오브젝트 정보 md 파일로 생성 후 작업 — §1.4)

⓪ ⭐ 보완요청 원장 선행 (hook #139, 2026-08-20 — 다른 무엇보다 먼저):
   지정된 요구 원문(문서 셀/대화) 전문 채록 → 하위문구 분해 → `Doc/단위테스트_보완대상/보완요청_원장.md`
   등재(전부 PENDING — 미적용 전제) → `asis_mapping_gate --init ... --menu {MNU_ID}` 로 대사표 REQ 축 편입.
   기존 등재분이 있으면 전 행 PENDING 전제로 재판정(실측 근거로만 전이·사전 판단 SKIP 금지).

시작 전 Doc/_rules_consolidation/RULESET_MASTER.md 전체를 읽고:
① Target UI 의 모든 자원(Page/Store/constants/types/utils/components/modals/SCSS/i18n + 관련 BE 메타·SP)을
   §3 UI-MANDATORY 체크리스트 + §4 hook 카탈로그(UI/공통) + §5 _tobe 13룰과 전수 대조해
   "준수 점검표"(룰/hook | 현재 상태 | 준수/위반/해당없음 | 위반 상세 | 조치안)로 보고하라.
   위반 은폐 금지, 표본 점검 금지(anti-simplification).
② 점검표의 모든 위반을 교정하라(인라인 <FlexGrid> → 공용 DataGrid + @foundation/utils 변환,
   components/ 분리 포함). 단 regression-zero Hard Boundary(shared/foundation/lges/타화면/타도메인/BE)
   밖이면 분리 PR 로 제안.
③ POST-WRITE grep 0 + screen-completion-gate 10게이트(G10=REQ 원장 축 포함) + 위반 전/후 건수·변경 파일 목록 보고.
   단순화 금지. 불확실하면 reference(DMF0004/0005/0006) cross-check.
④ FIGMA 에서 추출한 SVG 파일과 MD 파일을 기반으로 UI 디자인 상세 적용 (figma-layout-parity #90).
⑤ UI 개발 시 소스 구조를 분석한 RULE(_tobe 01~13 + reference 패턴)에 따라 기준을 지키며 진행.
```

특히 §0 필수 4대는 점검표에서 **개별 행으로 명시 검증** (과거 위반 재발 방지 — 사용자 재차 명시 2026-07-02).

## §2. 신규 UI 플레이북 (T01 — "신규 생성" 트리거 시 아래를 요청문과 동등 적용)

변수: `{{MENU_ID}}` / `{{DOMAIN}}`(DM|Common|SCM|SCP|SSP|FP) / `{{ASIS_SCREEN}}`(모르면 분석자료에서 식별) /
`{{PURPOSE}}` / `{{REFERENCE}}`(미정이면 Tab=DMF0004 / Panel=DMF0005 / 단일grid=DMF0006 매칭)

```
[시작 전 필독] anti-simplification.md / RULESET_MASTER.md (§2/§3/§4/§5 전부) / 00_INDEX.md

[1단계 — 적용대상 업무 분석 (분석파일 + 원시소스 cross-check, 누락 0)]
1. 분석 MD 8종 정밀 read: Doc/_analysis/domain_{{DOMAIN}}/screens/{{ASIS_SCREEN}}/
   (analysis/validation/expressions/web_components/tobe_design/oracle_migration/figma_link/source_links)
   ⭐ validation.md + expressions.md 필독.
2. 화면 분석서 xlsx: _analysis/_screens/{{DOMAIN 대응}}_Screens/{{ASIS_SCREEN}}.xlsx 의
   11_Validation + 12_Expression 시트. ⚠️ 1~10 시트 신뢰 금지(오염 이력) — 상충 시 MD 폴더 1차 신뢰.
3. 통합 매트릭스: _analysis/Screen_POPUP_SP_Tables_Matrix.xlsx 에서 POPUP/SP/Tables 추출.
4. 원시 AS-IS 소스: source_links.md 경로의 .cs + .Designer.cs 처음~끝 정밀 read (block 200~500라인).
   모든 Event/API(SP)/Validation(GMessageBox)/Expression(Lock·SetValue)/Button/POPUP(new XxxPopup) 추출.
5. ⭐ 3-way cross-check: [분석 MD] ↔ [원시 .cs] ↔ [매트릭스] 항목·카운트 일치 확인.
   불일치 시 원시 소스가 정답 — 차이를 보고.
6. 산출: "적용대상 업무 정의" + 인벤토리 표 (Event/API/Validation/Expression/Button/POPUP/SP/Table 각 건수).

[2단계 — 배치 결정]
7. features 폴더: SCM_ADM_MNU_M 트리 walk-up → 최상위 부모 매핑 (CLAUDE.md Step 3.5,
   Router.tsx import 검색으로 기존작성/cross-check 판정).
8. reference baseline = {{REFERENCE}}.

[3단계 — 전체 룰 적용 개발 (누락 0)]
9. RULESET_MASTER §2 T01 필독 룰(_tobe/01~10 + _asis/00_framework/01~07) + ⭐⭐⭐ mandatory hook 전부 적용.
10. §3 UI-MANDATORY 체크리스트(PRE-WRITE) 전 항목 통과 + 표 보고. 동적 속성 3종
    (ui-dynamic-property-management / menu-button-dynamic-fetch / ui-category-setup-column-meta)
    admin 데이터 부재 시 신규 등록.
11. 신규 SP/메타: be-infrastructure-reuse(기존 인프라 우선) + 메타 SQL 7-BLOCK + scmd-app-grant +
    proc-meta-signature-match (T08/T12) — PROC_M 은 위치+이름 대조(§3.4)·이관은 DELETE+INSERT.
12. __asis-mapping__.md — 1단계 인벤토리 카운트 = 코드 적용 건수 정확 일치 (모든 행 ✅).

[4단계 — 검증·보고]
13. §3.3 POST-WRITE grep 0 + screen-completion-gate 8 게이트.
14. 카운트 일치 보고 (Event/API/Validation/Expression/Button/POPUP 각각) + 필요 시 이관 패키지
    (deploy-package-completeness — "후속 보강" 잔류 금지).

[원칙] 단순화·표본 분석·위반 은폐 금지. xlsx 1~10 시트 신뢰 금지. 카운트 불일치 = 재작업.
       불확실하면 {{REFERENCE}} (또는 DMF0004/0005/0006) cross-check.
```

---

## §3. cross-ref

- 진입: `RULESET_MASTER.md` §2 T01/T01M (본 플레이북이 두 트리거의 실행 절차 원문)
- 자동 첨부: `.claude/hooks/attach-context.ps1` — "보완"/"신규 생성" 키워드 그룹이 본 파일 첨부
- 게이트: `screen-completion-gate.md` (8게이트) / `regression-zero-mandatory.md` (Hard Boundary)
- §0 필수 4대: #60/#64/#68/#97/#13/#65

## 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-07-02 | 초안 — 사용자 요청 원문 채록 (수정 UI ①~⑤ + 신규 UI 1~14단계 + 필수 4대) |
