# NSCM RULESET MASTER — 통합 마스터 룰 / Consolidated Master Ruleset

> 작성일 / Date: 2026-06-18 · 짝 문서 / Companion: `00_DIAGNOSIS_진단보고서.md`
> 목적 / Purpose: **TO-BE UI 개발·수정 시 RULE 누락 0** — 전체 룰(UI/DB/SP/BE)의 단일 참조점.
> 형태 / Form: Claude Code 가 그대로 읽을 수 있는 `CLAUDE.md` 호환 구조 (트리거 매트릭스 + hook 카탈로그 + 체크리스트).
>
> **채택 방법 / How to adopt (택1)**:
> 1. 루트 `CLAUDE.md` 에서 본 파일을 1차 로드 대상으로 추가: `Read: Doc/_rules_consolidation/RULESET_MASTER.md`, 또는
> 2. 본 파일 내용을 검토 후 루트 `CLAUDE.md` 로 병합(권장 — 진입점 단일화 R-1).
>
> ⚠️ 본 파일은 **기존 룰의 재정합·인덱스**이며 룰 내용을 새로 만들지 않는다. 각 항목은 기존 `_rules_v2/` 파일을 가리킨다(단일 진실 소스 유지).

---

## §0. 진입 정책 (Entry Policy) — 단일 진입 / Single Entry

작업 시작 시 **아래 4개만 1차 로드**. 나머지는 §2 트리거 매트릭스가 작업 키워드로 분기한다.

```
1. Read: Doc/_rules_v2/anti-simplification.md        ⚠️ 최우선·불변 (단순화 절대 금지)
2. Read: Doc/_rules_consolidation/RULESET_MASTER.md   ← 이 파일 (트리거 + 카탈로그 + UI 체크리스트)
3. Read: Doc/_rules_v2/00_INDEX.md                    ← 상세 카탈로그 (hook 본문 위치)
4. (UI 작업 시) §3 UI-MANDATORY 체크리스트를 PRE-WRITE 로 통과
```

> **카운트 단일 소스**: hook 총수 = **114** (`Doc/_rules_v2/hooks/*.md` 실측, 2026-07-16 — **#114 msg-id-asis-tobe-conversion 신설**[AS-IS MSG_ID 그대로 사용 절대 금지 — AS-IS 문구 확보→대조표 매칭 컬럼→사내 실측으로 TO-BE ID EXACT 재사용/신규 채번/동일 유지 3분기 + 사용 ID 전수 실문구 대사. 공통 61코드 중 54(89%) 의미 재배정 실측. 사용자 명시]. 직전 2026-07-15: #113 ui-category-division-direct-compare 신설[Grid Column 하드코딩·화이트리스트·attr 우회 금지, DIVISION_ID 서버 직접 비교 — 사용자 명시]. 2026-07-13: #110~#112). 어떤 문서든 카운트를 별도 보유하지 말 것 — 본 파일 §4 와 00_INDEX 만 카운트를 가진다. (진단 R-2)
>
> ⚠️ 2026-07-13(저녁): 신규 **#112 `search-condition-asis-tobe-catalog`** (SCP·DM 화면 조회조건 AS-IS↔TO-BE 카탈로그 적용 의무 — 원천 `Doc/SCP_DM_화면별 조회조건 정리_260122_v0.4.xlsx` List 시트 **953행/99화면 전수** MD 변환 = `_rules_v2/_mapping/search_conditions_scp_dm.md`. 조회조건 작성 전 해당 화면 표 전 행 대조 + 명칭 표준화 rename 13쌍[Div→Div./Model→Model/Nickname/Project→PJT/Valid→Active 등] + 다중선택 표준=검색+ALL버튼 + 팝업 통합[모→메1/프1→프2] + 공통기능화 검토 203행=SearchArea 승계 금지 + Sun-Set 8화면 사전 보고 + 카운트 일치 보고 의무. 사용자 명시) = **112**.
>
> ⚠️ 2026-07-13(DMF0082 조회/SavePrice 최적화): 신규 **#110 `sp-multiselect-filter-and-conversion-pitfalls`** (멀티선택 필터 GTT+skip[값있음=INNER/ALL·빈값=조건skip, 멀티값=GTT 사전적재] + SP 변환 3대 폭발/오정합[①split-in-join decorrelate 184M카테시안→물리GTT ②조인키부재 LEFT JOIN=2만행 카테시안+GROUP BY N배뻥튀기 ③INSERT목록↔SELECT 오정렬 ORA-12899] + Oracle `''=NULL` 필터버그. DMF0082 SavePricePeriod 0행·594s→5966행·9s) + 신규 **#111 `oracle-sp-perf-correlated-setbased-and-live-redeploy`** (§A 상관→set-based[상관UPDATE→MERGE 사전집계 / per-row LATERAL FETCH FIRST 1→GROUP BY MAX...KEEP DENSE_RANK LAST / 상관 IN(split)→물리GTT] §B 진단[V$SQL 문장별→DISPLAY_CURSOR→SQL_MONITOR, hang=Free private memory to OS] §C 라이브 재배포[라이브러리캐시 배타락→BE프로세스종료+DDL_LOCK_TIMEOUT, SCM_MGR ALTER SYSTEM 없음] §D 집계 GTT NUMBER≥소스[ORA-01438] §E diminishing returns[와이드범위=큰 중간결과] §F FE[BE boolean vs 'Y'문자열/division-반응형 컬럼/폭0 숨김]. DMF0082 조회, 사용자 명시) = **111**.
> ⚠️ 2026-07-08(오후): 신규 **#108 `ui-grid-corner-no-header`** (사용자 지정 공통 표준 — ①그리드 No. 코너(TopLeft) 가로/세로 전체 단일 머지 + 'No.' 라벨(setCellData 재귀 가드) ②커스텀 MergeManager 설치 = nested 그룹 네이티브 span 무효 → 동적 1단(년/년월) 수평 머지 수동 구현 의무. 정본 DMF0020 ExchangeRateModal) + 신규 **#109 `oracle-nls-implicit-conversion`** (암묵 형변환=세션 NLS 의존 — DATE 파라미터 원시값/단일인자 TO_DATE 금지. "SP직접호출·로컬 BE OK + 클라우드 WAS 만 ORA-01861" 시그니처 1순위 + -9994/InvocationTargetException 래퍼 진단(SCM_COM_SYS_LOG.EXCT_MSG_CTN) + 사내·클라우드 동시배포. 부록 C-11 신설(함정 11종). DMF0014 저장) = **109**.
> ⚠️ 2026-07-08: 신규 **#107 `sp-hang-runaway-loop-diagnosis`** (SP hang·폭주 진단 — ①GTT `TRUNCATE`(DDL) 동시세션 library cache·cursor·row cache mutex 경합 hang→전량 `DELETE` 치환+잔존 0 검증 ②MSSQL `@@FETCH_STATUS` 변환 누락 `WHILE V_FETCH_STATUS=0` 무한루프(10건 업로드에 INSERT 1,278만회)→FETCH 직후 `%NOTFOUND` 재할당 의무+grep 게이트(할당수=FETCH수) ③멈춘 세션 library cache pin=`CREATE OR REPLACE` 재배포 차단→DBA kill 선행(ORA-01031/ORA-00026)+배포 대기열 기법. 진단=V$SESSION event 3분류+V$SQL EXECUTIONS. 부록 C-2 확장+**C-10 신설(함정 10종)**. DMF0014 Excel Upload Lock) = **107**.
> ⚠️ 2026-07-06: 신규 **#106 `oracle-bulk-clob-buffer`** (대량 조회/저장 CLOB 버퍼 — ①동적 PIVOT 누적 V_ITERATION/V_SQL_TEXT→CLOB ②'^' bulk 홀더 vp_*/V_P_*→CLOB(단일토큰 v_* 유지) ③진단 JSON_OBJECT=SELECT RETURNING CLOB INTO+DBMS_LOB.SUBSTR 4000 truncate, 23ai PL/SQL 대입 PLS-00684. DMF0014/0043/0048 3연발) = **106**.
> ⚠️ 2026-07-02: 신규 #99 `oracle-save-payload-integrity` (Oracle SAVE SP delete-then-insert 저장 4대 규칙 — ①편집=`'M'`/신규='I'로 서버 "존재+'I'" 검증 우회 ②FE payload dedup 키=배포 SP GROUP BY 키 정확일치(COUNT>1=그룹 행수 오탐) ③신규 insert NOT NULL 컬럼 division별 placeholder 기본값(PLANT_SITE_ID '-') ④저장오류 근본원인=BE로그 ORA코드+USER_SOURCE(ALL_SOURCE 동명객체 주의) 확인, 추측금지 + 행간 중복검증 PK=전체키+MEASURE. DMF0020 저장 4연발 사고 후, 사용자 명시) = **99**.
> ⚠️ 2026-06-28: 신규 #98 `corp-meta-integrity-and-wiring` (사내 메타 INSERT NOT NULL 전수[MSG_TP_CD/USE_YN 빈발] + LBL 동일명칭 재사용/권위DB max+1 신규[FE stray 회피] + BE Java 무변경 generic call-proc 메타배선[API_M+BTN_MPG_M+PROC_M, standalone SP도 API_URL] + SHEET_NAME case-sensitive 잔존 sheet 정리. SYS0011/0012/0013, 사용자 명시) = **98**.
> ⚠️ 2026-06-28: 신규 #97 `common-button-grid-routing` (공통버튼 hotkeyConfig 만으로 표시[권한 비gating] + 그리드 자체 Add/Delete toolbar 금지 → 공통 INSERT/DELETE 활성그리드 라우팅 + No 행번호 컬럼 2방식[비체크박스=rowHeader TopLeft 헤더 bold해제 / useCheckbox=컬럼주입] + CRUD pending 부모키 변경 시 즉시 reset. SYS0011/0012/0013, 사용자 명시) = **97**.
> ⚠️ 2026-06-28: 신규 #96 `column-align-code-standard` (컬럼 메타 HORIZONTAL_ALIGN_CODE 단일문자 C/L/R 표준 — 전체단어"Center" 비표준→FE alignMap 미매칭→정렬 미적용. SYS0013, 사용자 명시) = **96**.
> ⚠️ 2026-06-28: 신규 #95 `grid-cell-backcolor-standard` (⭐ 필수·공통 — grid cell 배경 3색 표준: 기본 White+홀짝 zebra(클래스 없음) / 편집가능 Yellow(`wj-cell-editable`) / 편집가능하나 잠금 Gray(`wj-cell-non-editable`, 특수셀만). 전체 회색·inline 배경 금지. DMF0020 정립 → DMF0008 적용, 사용자 명시) = **95**.
> ⚠️ 2026-06-27: 신규 #94 `search-condition-height-uniformity` (⭐ 디자인 필수 — 조회조건 모든 객체 높이 36px 동일화(Main UI+Popup) + DatePicker wrapper 전 레벨 36 강제 + Figma 1단 4개 gridSize override, DMF0020, 사용자 명시) = **94**.
> ⚠️ 2026-06-27: 신규 #93 `grid-multi-tier-header-height` (다단 2단/3단 헤더 높이=48px 고정, DMF0007/foundation 알고리즘, 사용자 명시) = **93**.
> ⚠️ 2026-06-27: 표기 90 → 실측 91 drift(#91 sheet-name-asis-preserve 등재 시 헤더 미갱신) + 신규 #92 `column-division-id-visibility` (DIVISION_ID 기반 컬럼 표시 FE 토큰 필터, 사용자 명시) = **92**.
> ⚠️ 2026-06-26: 신규 #90 `figma-layout-parity-mandatory` (SYS0014 사고 — Figma 디자인↔구현 레이아웃 정합 + 수정 시 레이아웃 교체 필수, 사용자 명시) = **90**.
> ⚠️ **2026-06-23 카운트 정합**: 표기 81 → 실측 87 drift(2026-06-20 DMF0072 fix 중 #82~#86 + 일일 이슈 인프라 #88 issue-log-daily-workflow 미등재) + 신규 #87 = 88 → **신규 #89** (이슈목록 2026-06-23 PM R-6~R-10 승격 `screen-grid-edit-merge-and-meta-mandatory`) = **89**.
> ⚠️ **CLAUDE.md §15 직접 entry 추가 금지** (hook #77 `claude-md-changelog-policy`): 변경 이력은 monthly archive 에 1-line / 상세는 `Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md`.

---

## §1. 핵심 원칙 3 / Three Core Principles

| # | 원칙 | 의미 |
|---|---|---|
| **0** | ⭐⭐⭐ **디자인 그대로 구현 (1순위)** / "Design fidelity first" | Figma 가 있으면 Figma 그대로, 없으면 캡쳐이미지/제공 디자인을 현재 UI 표준 지키며 **그대로** 재현. **분석만 하고 임의로 다르게 생성 = 신뢰 손상 = 금지.** 디자인에 없는 그리드/버튼/필드는 데이터 모델에 있어도 만들지 않는다. 원본 미확보 시 추정 대신 디자인 요청. (figma-layout-parity-mandatory #90, 사용자 명시 2026-06-26) |
| 1 | **한 사람이 개발한 것처럼** / "As if one developer" | 신규 코드 = reference 화면(DMF0004~0007) 의 폴더/import/명명/주석 스타일과 100% 동일 |
| 2 | **AS-IS 한 줄도 누락 없음** / "Zero AS-IS omission" | AS-IS `.cs/.Designer.cs` 정밀 read → Event/API/Validation/Expression/Button 1:1 매핑. 누락 1건 = anti-simplification 위반 |
| 3 | **공용으로 끌어올리기** / "Lift to shared" | 공용 후보는 `@shared/components` · `@foundation/*` 로 승격. 단, **shared default 변경은 절대 금지**(분리 PR) |

> 최상위 룰: `anti-simplification.md` 는 다른 모든 룰을 압도한다. "모두/전체/정밀/상세" 요청 = 다중 패턴 + Cross-check 의무.

---

## §2. 트리거 매트릭스 / Trigger Matrix (작업 키워드 → 룰 + Hook)

> ⭐⭐⭐ = PR 차단 강제 등급 / PR-blocking · ⭐⭐ = master 통합 진입 / integrated entry · ⭐ = 강조 / emphasized
> **UI 작업은 T01(신규)·T01M(수정)·T04·T05·T06·T07·T09 + §3 체크리스트가 핵심.**

| T# | 트리거 키워드 | 필독 룰 (`_tobe`,`_asis`) | 핵심 Hook |
|---:|---|---|---|
| **T01** | 신규 화면 / DMFxxxx 생성 / 화면 추가 / **"신규 생성"·"신규 UI"** | ⭐ **ui-work-entry-playbook §2 (트리거 시 플레이북 전문 = 요청문과 동등 적용)** + `_tobe/01~10` 전부 + `_asis/00_framework/01~07` + `_asis/02_screens/__TEMPLATE__` + **`Doc/03.Framework` 공식 FE 설계서/인수인계서** | ⭐⭐⭐ **framework-foundation-entry(아키텍처 진입)** · **mdi-tab-isolation-mandatory** · **procedure-dts-ssot-mandatory** · atomic-design-components + screen-conventions-mandatory · screen-shell-composition-mandatory · regression-zero-mandatory · datagrid-shared-component-mandatory · screen-meta-and-permissions-mandatory · screen-additional-skills-mandatory + ui-dynamic-property-management(master) + menu-button-dynamic-fetch + ui-category-setup-column-meta + screen-create-checklist + screen-entry-asis-baseline + components-folder-pattern + pre-write/post-write + **screen-completion-gate(종료)** |
| **T01M** | **기존 화면 수정 / column 재작업 / 속성 변경 / "보완"·"보완요청"** | ⭐ **ui-work-entry-playbook §1 (트리거 시 전면 점검·교정 플레이북 전문 = 요청문과 동등 적용 — 준수 점검표 의무)** + 해당 화면 룰 + `_tobe/08_column_meta` | ⭐⭐⭐ **regression-zero-mandatory**(Hard Boundary) + **column-meta-rework-checklist**(8 점검) + datagrid-shared-component-mandatory + pivot-dynamic-column-nvl + screen-completion-gate |
| **T02** | AS-IS 화면 분석 / .cs 분석 / **UI분석서·화면분석서 생성 / 화면설계서 생성** | `_asis/02_screens/__TEMPLATE__` + `_asis/00_framework/01_BaseForm` | popup-asis-analysis + ⭐⭐ **screen-analysis-workbook-standard(#105 — UI분석서=§1-C 10시트[전체흐름+제약매트릭스 내부구조, 단위테스트 제외] / 화면설계서=§1-A 8시트. 정본 DMF0003_UI분석서_v2.1)** |
| **T03** | Popup 분석 / popup 매핑 | `_asis/01_popups/__POPUP_TEMPLATE__` + `00_inventory` + `_tobe/10_popup_modal` | popup-asis-analysis |
| **T04** | Grid / DataGrid / 컬럼 메타 / dropdown / lookup / column setting popup / drill-down / **머지·편집 제어** | `_tobe/07_datagrid` + `08_column_meta` + `09 §12` + `Doc/wijmo-flexgrid-guide` + `-api-reference` | ⭐⭐⭐ datagrid-shared-component-mandatory · grid-cell-interaction-patterns-mandatory + grid-column-meta + ui-category-setup-column-meta + column-lookup-meta-standard + grid-column-setting-popup-pattern + grid-interaction-patterns + sheet-columns-binding-match + wijmo-flexgrid-entry(진입) + wijmo-insert-cell-dropdown + wijmo-merge-sticky-content + runtime-error-prevention + ⭐⭐⭐ **screen-grid-edit-merge-and-meta-mandatory** (#89 — G mergeManager=props 직접 세팅 + sameRow `CRUD_TYPE`/`INSERT_GROUP_ID` · E `INPUT_TP_CD`+조건부 `beginningEdit` 행잠금 · A `API_ID` JOIN 정합, 이슈목록 2026-06-23 PM R-6~R-10 승격) + ⭐⭐⭐ **column-division-id-visibility** (#92 — DIVISION_ID 콤마 토큰 기반 컬럼 표시, SP/BE 무변경=ATTRIBUTE3 복사+FE 토큰 필터, 2026-06-27) + ⭐⭐⭐ **grid-multi-tier-header-height** (#93 — 다단 헤더 높이 48px 고정, 1단×N 비대화 금지, foundation HEIGHT_BY_COLUMN_DEPTH+DMF0007 P-A/P-B, 2026-06-27) + ⭐⭐⭐ **grid-cell-backcolor-standard** (#95 — cell 배경 3색 표준: 기본 White+zebra / 편집 Yellow(wj-cell-editable) / 잠금 Gray(wj-cell-non-editable, 특수만). 전체 회색·inline 배경 금지, 2026-06-28) + ⭐⭐ **column-align-code-standard** (#96 — HORIZONTAL_ALIGN_CODE 단일문자 C/L/R, 전체단어 금지, 2026-06-28) + ⭐⭐ **common-button-grid-routing** (#97 — 공통버튼 hotkeyConfig 표시 + 자체 toolbar 금지 + 활성그리드 라우팅 + No 컬럼 2방식 + CRUD pending 부모키 reset, 2026-06-28) |
| **T05** | 조회조건 / SearchArea / Form / combo / cascade / dropdown reset / **모달 콤보 옵션** / **객체 높이·배치** | `_tobe/06_search_area` + searchFields 카탈로그 | ⭐⭐⭐ messaging-api-and-search-fields-mandatory · cascade-combo-filter · screen-shell-composition-mandatory + search-area-extra-conditions + search-button-when-no-searcharea + cascade-pattern-check + ⭐⭐⭐ **screen-combo-validation-message-mandatory** (§1 L — 콤보/모달 옵션 룩업 조회, 하드코딩 금지) + search-area-button-position-and-toggle + ⭐⭐⭐ **search-condition-height-uniformity** (#94 — 디자인 필수: 모든 조회조건 객체 높이 36px 동일 Main UI+Popup + DatePicker wrapper 36 강제 + Figma 1단 4개 gridSize, 2026-06-27) |
| **T06** | Modal / Popup / 공용 modal | `_tobe/10_popup_modal` + `01 §1.5(modals/)` | ⭐⭐⭐ popup-modal-and-routing-mandatory + popup-asis-analysis + popup-dialog-layout + modal-callback-cascade-check + components-folder-pattern + grid-column-setting-popup-pattern |
| **T07** | Button / CRUD / SubTitle hotkey / 추가·삭제·저장·sort·filter·condition·reset | `_tobe/09_subtitle_hotkey` + `_asis/00_framework/01_BaseForm` | ⭐⭐⭐ subtitle-button-actions-mandatory · screen-meta-and-permissions-mandatory(권한) + screen-shell-composition-mandatory + asis-button-mapping + search-button-when-no-searcharea |
| **T08** | BE / Controller / Service / SP / cursor / mutation / SAVE SP | `_tobe/11_be_controller_service` + `12_metadata_sql` + **`Doc/03.Framework` BE API javadoc** | ⭐⭐ **oracle-db-workflow(진입)** + ⭐⭐ **be-api-contract-ui(UI 호출 계약)** + be-infrastructure-reuse + asis-coverage-check + procedure-dts-ssot-mandatory + sp-dual-cursor-pattern + mutation-onsuccess-defaults + proc-meta-signature-match + sp-body-minimal-change + sp-utl-call-stack-safety + sp-exception-handler-debug-friendly + sp-no-fake-data-extraction + sp-json-table-array-pattern + sp-patch-file-deploy + scmd-app-grant-mandatory |
| **T09** | 메뉴 안 나옴 / MNU_URL / SHT_NM / 권한 없음 | `_tobe/13_routing_menu` | menu-not-displayed-debug + menu-button-dynamic-fetch |
| **T10** | DB 오류 / ORA-xxxxx / PLS-xxxxx / 데이터 0건 / **날짜·메시지 검증 오탐** / **대량 조회·저장 실패(ORA-06502/40478)** / **업로드·저장 무반응(hang)** | `_dev_rules/21_TROUBLESHOOTING` + `_tobe/12_metadata_sql` | ⭐⭐ oracle-db-workflow §3 + sp-exception-handler-debug-friendly + sp-substr-zero-index-audit + oracle-cmbo-varname-quote + ⭐⭐ **oracle-bulk-clob-buffer(#106 — 대량 CLOB 버퍼)** + ⭐⭐ **sp-hang-runaway-loop-diagnosis(#107 — 무반응 hang·GTT TRUNCATE mutex·FETCH_STATUS 무한루프·재배포 pin 차단)** + ⭐⭐ **oracle-nls-implicit-conversion(#109 — "클라우드만 실패"=세션 NLS 암묵변환 / -9994·InvocationTargetException 래퍼 진단)** + db-error-asis-cross-check + sp-no-fake-data-extraction + pivot-dynamic-column-nvl + ⭐⭐⭐ **screen-combo-validation-message-mandatory** (§2 V 날짜 표시↔검증 형식 / §3 M 메시지 코드 충돌) |
| **T11** | Figma URL | `_dev_rules/31_FIGMA_DESIGN_INTEGRATION` | (figma-mapping-check — v1) |
| **T12** | Git push / 백업 / 원복 | `_dev_rules/28_GIT_MULTI_REMOTE` + `30_LOCAL_BACKUP_RESTORE` | destructive-git-ops |
| **T13** | CSV 적재 / Oracle 적재 | `_dev_rules/29_LOCAL_DB_CSV_IMPORT` | (없음) |
| **T14** | 서버 기동 | (메모리 `feedback_start_server`) | (없음) |
| **T15** | BaseForm / DataService / 공통 framework | `_asis/00_framework/01~07` | (없음) |
| **T16** | deploy zip / 이관 패키지 | `_dev_rules/22_PACKAGE_ARTIFACTS` | deploy-package-completeness + scmd-app-grant-mandatory + fe-cloud-type-lint-readiness + pre-submit |
| **T17** | G1~G10 격차 신규 구현 | `_mapping/asis_to_tobe.md §2~§6` | pre-submit |
| **T18** | 사내 DB 적용 / 클라우드 동기화 / 메타 INSERT / LBL 등록 / SP 호출 배선 | (메모리 corporate) | oracle-db-workflow §0-F + db-corporate-apply + db-schema-divergence-check + asis-msg-inventory + scmd-app-grant-mandatory + fe-cloud-type-lint-readiness + i18n-ko-en-alignment + ⭐⭐ **corp-meta-integrity-and-wiring** (#98 — 메타 INSERT NOT NULL 전수[MSG_TP_CD/USE_YN] + LBL 동일명칭/권위 max+1 + BE 무변경 generic call-proc 배선 + SHEET_NAME case-sensitive 잔존정리) + column-align-code-standard(#96) |
| **T19** | MSSQL 변환 / SP 변환 / PKG 변환 | `Doc/_analysis/db_migration/01_*` + `02_SP_CONVERSION_PIPELINE` | oracle-db-workflow + sp-substr-zero-index-audit + sp-dual-cursor-pattern + proc-meta-signature-match + sp-no-fake-data-extraction + sp-json-table-array-pattern + oracle-sp-perf-anti-patterns + sp-patch-file-deploy |
| **T20** | 화면 완료 / 작업 종료 / 다 됐어 / PR 제출 | (해당 작업 룰) | ⭐⭐ **screen-completion-gate(8 게이트)** → pre-submit |
| **T00** | (모든 작업 공통) | — | pre-write · post-write · pre-submit · file-write-fallback · destructive-git-ops · type-check-error-patterns · react-query-foundation-reexport · relative-import-order |

> **진단 반영(C-3)**: 유지 룰 v1 표는 §5 1곳에서만 보유. T10~T19 의 `_dev_rules/NN` 참조는 §5 표를 단일 출처로 본다.

---

## §3. ⭐ UI-MANDATORY 통합 체크리스트 (TO-BE UI 누락 0 핵심) / UI Mandatory Checklist

> **사용자 핵심 요구 직결**: 신규 화면(T01) · 화면 수정(T01M) 시 **이 한 장만 통과하면 UI 룰 누락이 구조적으로 차단**된다.
> 각 항목 위반 = PR 차단(anti-simplification 동등). 출처 hook 을 괄호에 명시.

### 3.1 PRE-WRITE (작성 직전 — 반드시 먼저)
- [ ] ⭐ **아키텍처 적합성 (framework-foundation-entry)**: 4-Layer 의존방향(foundation←shared←features←web) 위반 0 + feature 간 직접 import 0 + Layer 1/2 는 2-depth alias(deep/relative import 0) + 고정 기술스택 외 라이브러리 임의 도입 0
- [ ] ⭐ **MDI 격리 (mdi-tab-isolation-mandatory)**: 페이지 store = `createPersistedStoreWithTab`(멀티톤, storageName=폴더명) + 데이터 fetch = `useTabProcQuery`(Query Key tabId 포함) + **store 에 조회 결과 data 저장 금지(SSOT — searchParams/filters/UI 상태만)**
- [ ] ⭐ **타입 SSOT (procedure-dts-ssot-mandatory)**: 화면 작성 전 `procedure.d.ts` IN/OUT 정확 작성 → constants 정합 → 제네릭 추론. SP 응답 로컬 재정의 / `any` / `as unknown as` 금지
- [ ] **컴포넌트 재사용 (atomic-design-components)**: `@lges/design-system` + `@shared/components` 카탈로그 우선 검색(중복 작성 금지) + `useDataGridStore`(DEPRECATED) 0
- [ ] **코드 Naming Rule (code-naming-convention-mandatory)**: 함수=동사 camelCase + boolean=`is/has/can` 접두 + 상수=SNAKE_CASE + 미사용 파라미터=`_` 접두 + 축약어 금지 + 파일/폴더 명명 표 준수 + 품질 게이트(Husky pre-push lint+type) 통과
- [ ] **reference baseline 선정**: Tab형=DMF0004 / Panel형=DMF0005 / 단일 grid=DMF0006 중 시나리오 매칭 (screen-conventions-mandatory)
- [ ] ⭐⭐⭐ **Figma 디자인 레이아웃 정합** (figma-layout-parity-mandatory): Figma MD(`Doc/_figma/screens/{ID}.md`) 존재 시 §5 레이아웃 구조 → 영역 매핑표 작성 후 **그 배치대로 구현(디자인-우선)**. MD 부재 시 Figma 추출 선행. geometry-only MD 금지(영역 의미 명시). ⚠️ **경계: Figma=디자인 참조 only — 정책(권한/편집/필수값/기능동작/Validation/콤보 값) 판단 금지, 정책 소스=AS-IS 원소스·DB 메타·분석서·사용자 확정** (#90 §1.5, 2026-07-14 사용자 명시)
- [ ] **폴더/명명 4 cross-check**: MENU_ID = 폴더명 = `route-paths.ts` = DB `MNU_URL` 동일 (screen-conventions-mandatory §1.2 / popup-modal-and-routing-mandatory)
- [ ] **동적 속성 3종 admin 데이터 확인** — 부재 시 신규 등록 의무 (ui-dynamic-property-management = master):
  - [ ] Menu Button Visible/Enable → SYS0009 매핑 (menu-button-dynamic-fetch)
  - [ ] Column Visible/Width/Lookup/CellType/Label/Scale → admin (ui-category-setup-column-meta)
  - [ ] Measure Code/Label/Sort/Valid → SYS0004
- [ ] **Grid = 공용 DataGrid 만** 사용, FlexGrid JSX 직접 금지 (datagrid-shared-component-mandatory)
- [ ] **Form = SearchArea/FormItem/CustomDropdown**, 2단(6필드) 초과 시 `extraConditions` 분리 (screen-shell-composition-mandatory / search-area-extra-conditions)
- [ ] ⭐⭐ **SCP·DM 조회조건 = AS-IS↔TO-BE 카탈로그 전 행 대조** (search-condition-asis-tobe-catalog #112): `_rules_v2/_mapping/search_conditions_scp_dm.md`(953행/99화면) 에서 해당 화면 표 확인 — To-Be 명칭·유형·기능·팝업 그대로(명칭 표준: Div→**Div.**/Valid→**Active**/Project→**PJT** 등 13쌍) + 다중선택=**검색+ALL버튼** + 공통기능화 검토 행 SearchArea 승계 금지 + Sun-Set 8화면 사전 보고 + 카운트 일치 보고
- [ ] **SubTitle hotkeyConfig 1 객체**로 11 버튼 자동 매핑 (subtitle-button-actions-mandatory)
- [ ] **권한 분기**: `useTabBtnPermissions` + `hasButton(BTN_CD)` 각 액션 (screen-meta-and-permissions-mandatory)
- [ ] **공용 popup = camelCase 폴더 + 5 파일 + MODAL_XXX(실제 MENU_ID)** (popup-modal-and-routing-mandatory)
- [ ] **cascade**: Division 변경 시 하위 'ALL' reset + Map dedup + useTabComboQueries 1RT (cascade-combo-filter) + ⭐ **Division 변경 시 Grid 데이터 초기화(비움)+CRUD pending reset 의무** (§1.4, 2026-07-14 사용자 명시 — 재조회는 Search 버튼)
  - [ ] ⭐ **Grid 셀 종속 combo/modal** (cascade-combo-filter §5-G): beginningEdit 행값 dataMap 스왑 + **cellEditEnded 전체 dataMap 원복 필수**(누락=타 행 명칭표시 사고) + 계단식 clear(oldVal 비교) + 관대 sentinel + modal preSearchParams=클릭 행값. 콤보 변경 시 사용처 역매핑 — **공유 콤보 SQL 컬럼 추가 금지**(중복표시), 필터 키 반환 콤보 재사용. cascade 정의=화면 constants (AS-IS 실측: 메타 PARAM 없음 — 화면 코드 결정 구조)
- [ ] **messaging**: `useMessageStore`(alert/confirm/yesNoCancel/toast) — `window.alert` 직접 금지 (messaging-api-and-search-fields-mandatory)
- [ ] **i18n 3언어 동시**(KO=EN 값 동일, CN fallback) + `LBL`+5자리 (screen-meta-and-permissions-mandatory / i18n-ko-en-alignment)
- [ ] **import 규약**: `@tanstack/react-query`→`@foundation/query-client` re-export, 상대경로 정렬, `@foundation/lodash` (react-query-foundation-reexport / relative-import-order)
- [ ] **타입 self-check 17 패턴** (type-check-error-patterns)
- [ ] ⭐ **런타임 사고 7종 사전 차단** (screen-runtime-pitfalls-mandatory):
  - [ ] zustand selector 의 `?? []` / `?? {}` fallback 사용 금지 — store 초기값에 stable 참조 명시
  - [ ] `<DataGrid initialized={...}>` 사용 금지 (wrapper 가 호출 안 함, deprecated). ⭐ **모든 wijmo 이벤트 핸들러** (`formatItem` / `cellEditEnded` / `beginningEdit` / `loadedRows` / `cellEditEnding` / `selectionChanged` / `gotFocus`) 등록은 `useEffect` + `gridRef.current` (`internalRef` 단독 금지) + dependency `[staticColumns, dynamicColumns]` (`[]` 1회 금지 — mount 시점 ref undefined → 미등록 사고) + cleanup 의무
  - [ ] Grid row interface 는 `extends WijmoRowItem` + 모든 fields non-optional + 인덱스 시그니처 `string | number` 만
  - [ ] dynamicColumns 의 group + 모든 leaf 객체에 `allowSorting:false`, `allowMerging:false` 명시 + DataGrid `allowMerging` prop 결정 매트릭스 따라 명시
  - [ ] ⭐⭐ **No. 코너 헤더 공통 표준** (ui-grid-corner-no-header #108): rowHeader(순번) 쓰는 모든 그리드 — TopLeft 패널 전체 **가로/세로 단일 머지 + 'No.' 라벨**(setCellData 재귀 가드+중앙 정렬). 커스텀 MergeManager 사용 시 **동적 1단(년/년월) 수평 머지 수동 구현**(nested 그룹 네이티브 span 가정 금지 — 설치 시 무효화됨)
  - [ ] admin 메타 INSERT 작성 전 `desc TABLE_NAME` 으로 NULLABLE='N' 컬럼 인벤토리 확인 + INSERT column list 매핑 (`VALID_YN` 등 누락 방지)
  - [ ] dynamicColumns 의 group + 모든 leaf 객체에 **`height`** 명시 — `HEIGHT_BY_COLUMN_DEPTH` 캐노니컬 정합 (1단=48 / **2단=24** / 3단=16). DataGrid wrapper 가 staticColumns 만 자동 처리 → dynamicColumns 누락 시 wijmo default 48 × N (cell 96 rowspan 사고). DMF0007 wrapper 동작 정합. (`packages/foundation/src/utils/columnMapping.ts:27-29`)
  - [ ] ⭐⭐⭐ **디자인 필수 — 조회조건 객체 높이 36px 동일화** (search-condition-height-uniformity #94): Dropdown/Popup InputField/Text/DatePicker/Date input **모든** 조회조건 객체 높이 = **36px** (Main UI + Popup 동일). Main UI=표준 searchFields/CustomDropdown(자동) / Popup raw `<select>`·`<input type=date>`=`height:36px; box-sizing:border-box` / **DatePicker=`.datePickerFix` wrapper 로 전 레벨(MuiBox/FormControl/OutlinedInput) 36 강제** (design-system small 28px overflow 보정 — `sx` forward 안 됨). 조회조건은 **Figma 기준 1단 4개** = 카탈로그 필드 `gridSize` additive prop(default 보존)로 `gridSize={3}`.
  - [ ] **동적 컬럼 편집 의도** + BE 응답 row 의 `EDIT_FLAG='N'` 환경 → 화면 측 `beginningEdit` 핸들러 등록 의무 (`useEffect` mount + dependency `[staticColumns, dynamicColumns]` + cleanup) + 의도 binding 만 `e.cancel = false` 강제 override. wrapper 의 `setEditableColumns` 가 `isEditableCell` (OPTIONAL/MANDATORY 분기 = `editFlag !== 'N'`) 결과로 cancel 처리 → 동적 컬럼 readonly 사고 (DMF0043 master)

### 3.2 화면 수정(T01M) 추가 점검
- [ ] ⭐⭐⭐ **Figma 디자인 레이아웃 교체 필수** (figma-layout-parity-mandatory): 화면 Figma MD(`Doc/_figma/screens/{ID}.md`) 의 영역 배치(상단조건/좌·우/상·하/영역별 컨텐츠)와 현재 구현이 **불일치하면 레이아웃을 디자인에 맞게 교체**한다. 기능(타입/권한/버튼)만 고치고 레이아웃 방치 금지. (사용자 명시 2026-06-26 SYS0014 사고)
- [ ] ⭐⭐⭐ **SHEET_NAME = AS-IS 원본 정정** (sheet-name-asis-preserve-mandatory): 수정 화면의 `SHEETS` value 가 AS-IS SHEET_NAME(AS-IS DB SHEET_COLUMNS 또는 `.cs` `SpdSheet`)과 다르게 개명돼 있으면 **AS-IS 값으로 정정** (FE SHEETS·SP·SHEET_COLUMNS·MNU_BTN.SHT_NM 5구간 동시). 수정 시 적용(일괄 audit 안 함). (사용자 명시 2026-06-26)
- [ ] **Hard Boundary 6종 변경 금지**: `packages/shared` · `foundation` · `lges` · 타도메인 · 타화면 · `nscm-be` (regression-zero-mandatory)
- [ ] **column 재작업 8 점검**: SP NVL / minimal change / patch 종결자 / admin 동기 / binding 매칭 / shared prop / anti-simplification / 사후검증 (column-meta-rework-checklist)
- [ ] **dynamic 컬럼 NVL wrap**: PIVOT NULL → 키 누락 사고 방지 (pivot-dynamic-column-nvl)
- [ ] **공용 prop 추가는 분리 PR** + 4 도메인 regression 0 (regression-zero-mandatory)
- [ ] ⭐ 런타임 사고 7종 (screen-runtime-pitfalls-mandatory) — 신규 화면 동일 적용

### 3.3 POST-WRITE grep (작성 직후 자동 검증)
- [ ] `<FlexGrid` / `<FlexGridColumn` 직접 JSX = 0 (datagrid-shared-component-mandatory)
- [ ] `from 'clsx'` / `from 'lodash'` / `from 'react-i18next'` / `from '@tanstack/react-query'` 직접 = 0
- [ ] `window.alert` / `window.confirm` / raw `alert(` = 0
- [ ] `set({` 즉시 객체 교체(immer draft 아님) = 0 (screen-additional-skills-mandatory)
- [ ] 인라인 `<dialog>` / MUI `<Dialog>` 직접 = 0 (popup-modal-and-routing-mandatory)
- [ ] 진입 Page ≤ 400 라인 (components-folder-pattern)
- [ ] ⭐ 런타임 사고 grep (screen-runtime-pitfalls-mandatory):
  - [ ] `useStore\(s => s\.\w+ \?\? ` = 0 (selector fallback 안티패턴)
  - [ ] `<DataGrid[^/]*initialized=` = 0 (deprecated prop 사용 금지)
  - [ ] Grid row interface 가 `extends WijmoRowItem` 누락된 곳 = 0

### 3.4 종료 게이트 (T20 — 종료 선언 전 8 게이트)
> `screen-completion-gate.md` 의 8 게이트 의무 + 보고 양식:
> ① AS-IS 4축 매핑 ② 버튼 매핑 ③ Grid/Column 메타 ④ 메타·라우팅 ⑤ 정적(type/lint) ⑥ 런타임 smoke ⑦ 표준 정합 ⑧ 이관 패키지
>
> ⭐ **G5 정적 검증 강화 (2026-06-19 DMF0043 회고 후)**: type/lint/build 3종 외 `_artifacts/_local_setup/regression-impact.ps1` 실행 → Hard Boundary 위반 0 / 영향 도메인 / `procedures.d.ts` 변경 여부 보고 의무. 사내 nexus 로컬 차단 환경에서 cross-screen 회귀를 commit 후 발견하는 사고 차단. (regression-zero-mandatory §9)

---

## §4. Hook 카탈로그 (전체 114 / Full Catalog) — 단일 카운트 소스

> 본문 위치: `Doc/_rules_v2/hooks/<name>.md`. 카운트 = 본 파일 상단 "카운트 단일 소스" 문단 참조 (**114**, 2026-07-16 실측 — 본 §4 내 중복 카운트 표기는 2026-07-03 정리로 제거, 갱신은 상단 문단+본 헤더+말미 SSOT 3곳 동시). 정렬: 파일명 알파벳순(진단 R-4) — 단 #70 이후는 등재 시점 순 표 끝 배치.
> 분류: 🅒 공통 · 🆄 UI/화면 · 🅖 Grid/Wijmo · 🅕 Search/Form · 🅟 Popup/Modal · 🅑 BE/SP/Oracle · 🅓 DB적용/Deploy · 🅖it Git/Infra

| # | Hook | 분류 | 트리거 | 한 줄 요약 |
|---:|---|:--:|---|---|
| 1 | asis-button-mapping | 🆄 | T07 | CRUD 6 + Aux 4 버튼 AS-IS 매핑 |
| 2 | asis-coverage-check | 🆄 | T01/T08 | AS-IS 4축(Event/API/Validation/Expression) 매핑 검증 |
| 3 | asis-msg-inventory | 🅓 | T18 | AS-IS MSG[n] 인벤토리 → To-Be 등록 SQL 절차 |
| 4 | be-infrastructure-reuse | 🅑 | T08/T01 | ⭐⭐ 신규 BE 작성 전 동적 SP 인프라 재사용 검색 의무 |
| 5 | cascade-combo-filter | 🅕 | T05/T04 | ⭐⭐⭐ Division→하위 reset + **§1.4 Div 변경 시 Grid 초기화(비움)+CRUD reset 의무(2026-07-14 사용자 명시)** / Map dedup / 1RT / modal callback 5단계 + **§5-G Grid 셀 cascade**(beginningEdit 스왑+원복/계단식 clear/modal 행값 — 2026-07-03 DMF0020) |
| 6 | cascade-pattern-check | 🅕 | T01/T04 | 조회조건·grid cascade 패턴 (룰 07 §2.10) |
| 7 | column-lookup-meta-standard | 🅖 | T04/T07 | ⭐⭐ dropdown=`CELL_COMBO_DATA_TYPE` 위치 / `INPUT_TP_CD` 5종(`MI` 금지) |
| 8 | column-meta-rework-checklist | 🅖 | T01M/T04 | ⭐⭐ 기존 column 재작업 8 점검 |
| 9 | components-folder-pattern | 🆄 | T01/T04/T06 | 진입 Page ≤400라인 + inline grid/dialog JSX 금지 + components/modals 폴더 |
| 10 | datagrid-shared-component-mandatory | 🅖 | T01/T04 | ⭐⭐⭐ 공용 DataGrid + foundation utils 4종 의무, FlexGrid 직접 금지 |
| 11 | db-corporate-apply | 🅓 | T18 | 사내 DB 적용 (docker sqlplus + CRLF 우회 + 카테고리 분류) |
| 12 | db-error-asis-cross-check | 🅑 | T10 | DB 오류 시 AS-IS MSSQL 직접 cross-check |
| 13 | db-schema-divergence-check | 🅓 | T18 | Docker vs 사내 Oracle 8 schema 차이 PRE-CHECK |
| 14 | deploy-package-completeness | 🅓 | T16 | PRE/POST deploy 인벤토리 + 사후 보강 |
| 15 | destructive-git-ops | 🅖it | 전체 | filter-branch/force-push/reset --hard 전 승인 의무 |
| 16 | fe-cloud-type-lint-readiness | 🅓 | T01/T18 | FE 클라우드 type/lint 통과 5 패턴 |
| 17 | file-write-fallback | 🅒 | 전체 | 파일 작성 실패 시 fallback 절차 |
| 18 | grid-cell-interaction-patterns-mandatory | 🅖 | T01/T04 | ⭐⭐⭐ Grid 3 시나리오(A/B/C) + drill-down + 다중 popup + CSV |
| 19 | grid-column-meta | 🅖 | T04 | Grid/Column 메타 14 ctrl + 5 edit type |
| 20 | grid-column-setting-popup-pattern | 🅟 | T01/T04/T06 | ⭐⭐ 사용자 column 표시설정 popup 5단계 + 재진입 복원 |
| 21 | grid-interaction-patterns | 🅖 | T04 | selectionMode + 자동체크 금지 + loadedRows 4 패턴 |
| 22 | i18n-ko-en-alignment | 🆄 | T01/T18 | ⭐ i18n KO=EN 전체 통일 (전 prefix) |
| 23 | localstorage-persist-pattern | 🆄 | T01/T04 | mount 1회 복원 + handleApply 직접 setItem |
| 24 | menu-button-dynamic-fetch | 🆄 | T01/T04/T07 | ⭐⭐ Menu Button Visible/Enable 동적 fetch (ui-dynamic child) |
| 25 | menu-not-displayed-debug | 🆄 | T09 | 메뉴 미표시 7단계 디버깅 |
| 26 | messaging-api-and-search-fields-mandatory | 🅕 | T01/T05/T07 | ⭐⭐⭐ useMessageStore 5 + apiClient 10 + searchFields 14 + CustomDialog 7 size |
| 27 | modal-callback-cascade-check | 🅟 | T06 | modal callback → cascade 전파 |
| 28 | mutation-onsuccess-defaults | 🅑 | T01/T08 | mutate onSuccess override 시 default invalidate+toast 명시 |
| 106 | oracle-bulk-clob-buffer | 🅑 | T08/T10/T19 | ⭐⭐ 대량 조회/저장 CLOB 버퍼 — 동적 PIVOT 누적(V_ITERATION/V_SQL_TEXT)+'^' bulk 홀더(vp_*/V_P_*)→CLOB / 진단 JSON_OBJECT=SELECT RETURNING CLOB INTO+DBMS_LOB.SUBSTR truncate(23ai PLS-00684). ORA-06502/40478. DMF0014/0043/0048 (2026-07-06) |
| 107 | sp-hang-runaway-loop-diagnosis | 🅑 | T08/T10/T19 | ⭐⭐ **SP hang·폭주 진단** — 업로드/저장 무반응(BE 무응답) 시 V$SESSION event 3분류(mutex 경합/무한루프 폭주/정상 락 대기). ①GTT `TRUNCATE`(DDL) 동시세션 library cache·cursor·row cache mutex 경합 hang → 전량 `DELETE FROM` 치환+DBA_SOURCE 잔존 0 검증(부록 C-2 확장) ②`@@FETCH_STATUS` 변환 누락 `WHILE V_FETCH_STATUS=0` 무한루프(10건 업로드에 INSERT 12,786,821회 — V$SQL EXECUTIONS 진단) → FETCH 직후 `%NOTFOUND` 재할당 의무+grep 게이트(할당수=FETCH수, 부록 C-10 신설) ③멈춘 세션 library cache pin = `CREATE OR REPLACE` 재배포 차단(LAST_DDL_TIME 미변경 신호) → DBA kill 선행(SCM_MGR ORA-01031 / stale SERIAL# ORA-00026)+배포 대기열 기법+구버전 SP 動作 중 사용자 재시도 금지 안내. DMF0014 Excel Upload Lock (2026-07-08) |
| 108 | ui-grid-corner-no-header | 🆄 | T01/T01M | ⭐⭐ **그리드 No. 코너 헤더 공통 표준 (사용자 지정)** — ①TopLeft 패널 전체(순번+상태 × 다단 헤더) **가로/세로 단일 머지** + **'No.' 라벨**(formatItem setCellData, 현재값 비교 재귀 가드) + 중앙 정렬 + `allowMerging=All` prop ②⚠️ **커스텀 MergeManager 설치 = nested columnGroups 네이티브 span 무효** → 동적 1단(년/년월/주차) 수평 머지를 binding 그룹키로 **수동 구현 의무**("네이티브 span" 가정 금지). 정본 DMF0020 ExchangeRateModal / 선례 ContributeViewGrid·PriceBatchInputModal (2026-07-08) |
| 109 | oracle-nls-implicit-conversion | 🅑 | T08/T10/T19 | ⭐⭐ **암묵 형변환 = 세션 NLS 의존 폭탄** — DATE 파라미터에 문자열/숫자 직접 전달·단일 인자 `TO_DATE(x)`·무마스크 `TO_CHAR(date)` 금지(항상 명시 마스크). 판정 시그니처: **SP 직접호출 OK + 로컬 BE OK + 클라우드 WAS 만 ORA-01861**(세션 NLS_DATE_FORMAT 차이 — 권한/BE빌드 단정 금지). -9994/`InvocationTargetException:null`=래퍼 → `SCM_COM_SYS_LOG.EXCT_MSG_CTN`/BE 콘솔 `Caused by:` 로 실오류 확보. fix=명시 마스크 최소 diff + 동종 전수 sweep + **사내·클라우드 동시 배포**. 부록 C-11. DMF0014 저장 PR_DM_PLN L1322 (2026-07-08) |
| 110 | sp-multiselect-filter-and-conversion-pitfalls | 🅑 | T08/T10/T19 | ⭐⭐ **멀티선택 필터 GTT+skip + SP 변환 3대 폭발/오정합** — 필터 표준: 값 있음=GTT 사전적재 후 INNER JOIN(또는 ALL)/빈값·'ALL'=조건 자체 skip('' = Oracle NULL — `=''` 필터는 전행 탈락 버그). 변환 3대: ①split-in-join decorrelate=카테시안 폭발(184M) → 물리 GTT 사전 분해 ②조인키 부재 LEFT JOIN=카테시안+GROUP BY N배 뻥튀기 ③INSERT 컬럼목록↔SELECT 오정렬(ORA-12899/조용한 컬럼 뒤섞임). DMF0082 SavePricePeriod 0행·594s→5,966행·9s (2026-07-13) |
| 111 | oracle-sp-perf-correlated-setbased-and-live-redeploy | 🅑 | T08/T10/T19 | ⭐⭐ **상관쿼리→set-based + 라이브 PKG 재배포 운영** — §A 상관 UPDATE→MERGE 사전집계 / per-row LATERAL `FETCH FIRST 1`→`GROUP BY MAX...KEEP(DENSE_RANK LAST)` / 상관 IN(split)→물리 GTT. §B 진단=V$SQL 문장별 귀속→DBMS_XPLAN.DISPLAY_CURSOR→SQL_MONITOR(hang 신호 'Free private memory to OS'). §C 라이브 재배포=라이브러리 캐시 배타락 → BE 프로세스 종료+DDL_LOCK_TIMEOUT(SCM_MGR 에 ALTER SYSTEM 권한 없음). §D 집계 GTT NUMBER 정밀도≥소스(ORA-01438). §E diminishing returns(와이드 범위=큰 중간결과 한계 명시). §F FE 짝=BE boolean vs 'Y' 문자열/division-반응형 정적컬럼(폭0 숨김 금지). DMF0082 조회 (2026-07-13) |
| 112 | search-condition-asis-tobe-catalog | 🅕 | T01/T01M/T03/T05 | ⭐⭐ **SCP·DM 조회조건 AS-IS↔TO-BE 카탈로그 적용 의무 (사용자 지정)** — 카탈로그 = `_rules_v2/_mapping/search_conditions_scp_dm.md`(원천 xlsx List 시트 **953행/99화면 전수** 변환). 조회조건 작성 전 해당 화면 표 **전 행 대조**: To-Be 명칭·유형·기능·팝업 그대로(임의 결정 금지) + 명칭 표준화 rename 13쌍(Div→**Div.**/Model→**Model/Nickname**/Project→**PJT**/Valid→**Active**/Version→**Ver.** 등) + 다중선택 표준=**검색+ALL버튼** + 팝업 통합(모1~3→메1/프1→프2) + **공통기능화 검토 203행=SearchArea 승계 금지**(버튼·체크박스 — 사용자 확인) + **Sun-Set 8화면 사전 보고** + 조회조건 삭제 11행 미구현 + 카운트 일치 보고(__asis-mapping__). To-Be 필수값 미확정 한계 명시. (2026-07-13) |
| 113 | ui-category-division-direct-compare | 🅕 | T01/T01M | ⭐⭐ **Grid 정적 컬럼 표시 표준 (사용자 지정 2026-07-15)** — DIVISION_ID 가시성 = PR_GET_SHEET_COLUMN_LIST/MEASURE_LIST 서버 직접 비교(divisionId 전송 + division 변경 재fetch). ❌ ATTRIBUTE1/3 클라 비교(#92 구방식) ❌ 컬럼·measure 하드코딩/화이트리스트/FALLBACK. FE 필터=visible&&display 2 boolean, ColumnSetting 로컬 반영=display. 정본 sales-plan(DMF0021). (§4 표 소급 등재 2026-07-16 — 상단 카운트만 있고 표 행 누락 drift 정정) |
| 114 | msg-id-asis-tobe-conversion | 🅕 | T01/T01M/T08/T18 (MSG 이관·등록·매핑) | ⭐⭐⭐ **AS-IS MSG_ID 그대로 사용 절대 금지 (사용자 지정 2026-07-16)** — AS-IS↔TO-BE 공통 61코드 중 **54(89%) 의미 재배정** 실측(예: AS-IS MSG00001 '필수 입력'↔TO-BE '저장 하시겠습니까?'). 의무 4단계: ①AS-IS 실문구 확보(ID만 금지) → ②대조표 `_artifacts/MESSAGE_ASIS_vs_TOBE_대조.xlsx` 'AS-IS 한글 일치 TO-BE MSG_ID' 컬럼 확인(재매핑 확정 14건: MSG00004→00672/00006→00003/00097→00667/00133→00004/00225→00666/00259→00662/00464→00671 등) → ③사내 `SCM_ADM_MSG_M` 실측 3분기(동일 문구 존재=**TO-BE ID EXACT 재사용** / 부재=**MAX 실측+1 신규 채번**+KO/EN/CN MERGE[#98 §7] / ID·문구 모두 일치[7건뿐]=유지) → ④POST-WRITE: 사용 MSG grep 전수 → 사내 실문구 대사 표 보고(fallback 텍스트 신뢰 금지). ❌ 기존 TO-BE ID 에 AS-IS 문구 UPDATE(전 화면 오염). `__asis-mapping__` 에 AS-IS→TO-BE 변환 관계 명시. DMF0003 재채번 사고(6/28→7/11 재정합) |
| 29 | oracle-cmbo-varname-quote | 🅑 | T08/T10 | CMBO_SQL_M `@varName` → `TO_CHAR()` wrap (ORA-01722 방지) |
| 30 | oracle-db-workflow | 🅑 | T08/T10/T18/T19 | ⭐⭐ Oracle SP/DB 단일 진입점 (8 타입 + 증상→원인) |
| 31 | oracle-sp-perf-anti-patterns | 🅑 | T08/T10/T19 | ⭐⭐ MSSQL→Oracle 6 성능 룰 (REGEXP/split/lookup/index/SARGable) |
| 32 | pivot-dynamic-column-nvl | 🅑 | T08/T10/T19 | ⭐⭐ PIVOT 동적컬럼 NVL wrap (NULL 키 누락 방지) |
| 33 | popup-asis-analysis | 🅟 | T03/T06 | Popup 9 category .cs deep read |
| 34 | popup-dialog-layout | 🅟 | T06 | CustomDialog 잘림·중앙 미표시 방지 |
| 35 | popup-modal-and-routing-mandatory | 🅟 | T01/T13 | ⭐⭐⭐ 공용 popup 5파일 + camelCase + Router 4 cross-check |
| 36 | post-write | 🅒 | 전체 | 작성 직후 grep 검증 |
| 37 | pre-submit | 🅒 | 전체 | PR 제출 직전 통합 검증 (PR 게이트 §6) |
| 38 | pre-write | 🅒 | 전체 | 작성 직전 체크리스트 |
| 39 | proc-meta-signature-match | 🅑 | T08 | PROC_M 행/SORT_ORD = SP ALL_ARGUMENTS positional 일치 |
| 40 | react-query-foundation-reexport | 🅒 | T01/T04 | `@tanstack/react-query` 직접 import 금지 → `@foundation/query-client` |
| 41 | regression-zero-mandatory | 🆄 | T01/T01M | ⭐⭐⭐ Hard Boundary 6종 + 사고 카탈로그 18 + type/lint 0 |
| 42 | relative-import-order | 🅒 | T01/T04 | 상대 import 알파벳/계층 정렬 (ESLint) |
| 43 | runtime-error-prevention | 🆄 | T01/T04/T06 | 사고 사례 사전 차단 |
| 44 | scmd-app-grant-mandatory | 🅑 | T08/T16/T18 | ⭐⭐ SCMD_APP GRANT+SYNONYM 즉시 의무 (-9994 방지) |
| 45 | screen-additional-skills-mandatory | 🆄 | T01 | ⭐⭐⭐ useTranslation/clsx/immer/atomic selector/preSearchParams 9 skill |
| 46 | screen-completion-gate | 🆄 | T01/T20 | ⭐⭐ 화면 종료 8 게이트 + 보고 양식 |
| 47 | screen-conventions-mandatory | 🆄 | T01 | ⭐⭐⭐ 폴더/명명/constants 5/utils/SCSS/ID 정합 (DMF0004~6 master) |
| 48 | screen-create-checklist | 🆄 | T01 | 신규 화면 작성 체크리스트 |
| 49 | screen-entry-asis-baseline | 🆄 | T01 | 신규 화면 진입 AS-IS baseline 4단계 |
| 50 | screen-meta-and-permissions-mandatory | 🆄 | T01/T20 | ⭐⭐⭐ 권한 hook + `__asis-mapping__` + i18n 3언어 + Modal mount |
| 51 | screen-shell-composition-mandatory | 🆄 | T01/T05/T07 | ⭐⭐⭐ Page/Form/Hook/Store 인프라 의무 (DMF0004~6) |
| 52 | search-area-extra-conditions | 🅕 | T01/T04/T05 | ⭐ SearchArea 2단 초과 시 `extraConditions` 분리 |
| 53 | search-button-when-no-searcharea | 🅕 | T05/T07 | SearchArea 부재 시 SubTitle `searchAction` prop |
| 54 | sheet-columns-binding-match | 🅖 | T04/T08 | SHEET_COLUMNS ↔ SP alias 일치, 하드코딩 staticColumns 금지 |
| 55 | sp-body-minimal-change | 🅑 | T08 | SP body 변경 시 원본 1바이트 변경 금지 + 3축 검증 |
| 56 | sp-dual-cursor-pattern | 🅑 | T08 | GET SP `O_RC` + `O_RESULT_CURSOR` dual OUT |
| 57 | sp-exception-handler-debug-friendly | 🅑 | T08/T10 | EXCEPTION OTHERS — 개발=SQLERRM 명시 / 운영=표준+로그 |
| 58 | sp-json-table-array-pattern | 🅑 | T08/T19 | ⭐⭐ SAVE SP `'$[*]'` + cursor + entry/HIST 동시 fix |
| 59 | sp-no-fake-data-extraction | 🅑 | T08/T19/T10 | ⭐⭐ 가짜 구현 18종 금지 + 실추출 교체 |
| 60 | sp-patch-file-deploy | 🅑 | T08/T19/T16 | ⭐⭐ patch 종결자 `END;`+별행 `/` + 의존순서 + fallback |
| 61 | sp-substr-zero-index-audit | 🅑 | T08/T10/T19 | `SUBSTR(s,0,n)` 정규화 결함 audit |
| 62 | sp-utl-call-stack-safety | 🅑 | T08 | `UTL_CALL_STACK.SUBPROGRAM(1)(N)` `.COUNT>=N` 안전체크 |
| 63 | subtitle-button-actions-mandatory | 🆄 | T01/T07 | ⭐⭐⭐ SubTitle 11 버튼 hotkeyConfig 1 객체 자동 매핑 |
| 64 | type-check-error-patterns | 🅒 | T01/T04/T06/T08 | ⭐ FE 17 패턴 self-check (pnpm 호출 없이 grep) |
| 65 | ui-category-setup-column-meta | 🆄 | T01/T04/T07 | ⭐⭐ admin column 메타 동적 fetch + 신규 등록 |
| 66 | ui-dynamic-property-management | 🆄 | T01/T04/T07 | ⭐⭐ **master** — Menu Button + Column + Measure 동적 속성관리 |
| 67 | wijmo-flexgrid-entry | 🅖 | T01/T04/T07 | ⭐⭐ Wijmo 작업 진입점 (가이드 2파일 + 안티패턴 10) |
| 68 | wijmo-insert-cell-dropdown | 🅖 | T04 | Insert cell ComboBox 12단계 1-pass |
| 69 | wijmo-merge-sticky-content | 🅖 | T01/T04 | ⭐⭐ 세로 merge + viewport sticky (CustomMergeManager) |
| 70 | screen-runtime-pitfalls-mandatory | 🆄 | T01/T01M/T04/T05 | ⭐⭐⭐ 런타임 사고 7종 통합 차단 (zustand selector fallback / DataGrid initialized deprecated / WijmoRowItem extends / AllowMerging.All + dynamicColumns 옵션 / admin 메타 NOT NULL / 다단 헤더 row 높이 정합 / **동적 컬럼 EDIT_FLAG='N' 환경에서 `beginningEdit` cancel 우회 (FIFO 마지막 override)** — DMF0043 master, 2026-06-19) |
| 71 | framework-foundation-entry | 🆄 | T01/전체 UI | ⭐⭐⭐ 공식 FE 설계서/인수인계서 준수 진입점 — 4-Layer 의존방향 + import 규율(deep/relative 금지, 2-depth alias) + YAGNI/SoC/SSOT + 고정 기술스택 (2026-06-19 03.Framework 룰화) |
| 72 | mdi-tab-isolation-mandatory | 🆄 | T01/T04/T05 | ⭐⭐⭐ MDI 탭 격리 3축 — UUID tabId 라우팅/unmount + Zustand 멀티톤(createPersistedStoreWithTab) + Query Key [tabId,menuId,params] + IndexedDB persister + store=searchParams only(SSOT) (2026-06-19) |
| 73 | procedure-dts-ssot-mandatory | 🆄 | T01/T07/T08 | ⭐⭐⭐ procedure.d.ts IN/OUT 단일 타입 SSOT — 타입 먼저 작성 후 화면 + constants 정합 + 제네릭 추론 + 로컬 재정의/any 금지 (2026-06-19) |
| 74 | atomic-design-components | 🆄 | T01/T04/T06 | ⭐⭐ 아토믹 디자인 계층(atoms/molecules/organisms) + @lges/design-system 우선 + 공통 컴포넌트·Store·Hooks·Utils 카탈로그 재사용(중복 작성 금지, useDataGridStore DEPRECATED) (2026-06-19) |
| 75 | be-api-contract-ui | 🅑 | T07/T08/T01 | ⭐⭐ BE API javadoc UI 호출 계약 — callProc/combo-muti/lookup-muti/menu auth·동적컬럼 endpoint ↔ apiClient 매핑 + 표준 응답 {code,message,result}/successResponseEntity + @AuthCheck/@SystemLog (2026-06-19) |
| 76 | code-naming-convention-mandatory | 🆄 | T01/전체 FE | ⭐⭐ 코드 Naming Convention + 품질 게이트 (인수인계서 §4 / 설계서 §3 누락 보강) — 변수/함수/상수 Naming Rule(함수=동사 camelCase / boolean=is·has·can / 상수=SNAKE_CASE / 미사용 파라미터=`_` 접두 / 축약어 금지) + 파일·폴더 명명 표 + 품질 자동화 게이트(Husky pre-push lint+type / Vitest / SonarLint / Branch Naming / GitLab CI Fail) (2026-06-19) |
| 77 | claude-md-changelog-policy | 📘 | 전체 (CLAUDE.md 갱신 시) | ⭐⭐ CLAUDE.md 사이즈 다이어트 정책 — §15 entry 직접 추가 금지 + monthly archive (`Doc/_archive/CLAUDE_changelog_YYYY-MM.md`) 1-line 작성 + 상세 = `Doc/_archive/work_reports/{YYYY-MM-DD}_{topic}.md` 별도 보고서 분리. §15 본문 ≤ 5 줄 pointer 만 강제 (2026-06-20) |
| 78 | ui-category-setup-no-arbitrary-data | 🅓 | 전체 (admin 메타 INSERT/UPDATE 시) | ⭐⭐⭐ **강력 룰 (anti-simplification 동급)** — admin UI Category Setup 관리 메타 8 테이블 (`SCM_MST_SHEET_COLUMNS`/`SCM_ADM_MNU_BTN_MPG_M`/`SCM_ADM_LOOKUP_MASTER_DETAIL`/`SCM_ADM_CMBO_SQL_M`/`SCM_ADM_MSG_M`/`SCM_ADM_API_M`/`SCM_ADM_PROC_M`/`SCM_ADM_MNU_M`) AI 임의 INSERT/UPDATE/추측 절대 금지. 허용: 사용자 명시 요청 / AS-IS 백업 실 데이터 그대로 복사 / 조회. 다국어 AI 번역 INSERT 금지. PRE-WRITE 4 점검 의무 (사용자 명시? 원천 실데이터? 메타 테이블? DDL grep?) (2026-06-22 사용자 명시) |
| 79 | local-server-startup-standard | 📘 | "서버 기동" / "FE 띄워" / "로컬 시작" 트리거 | ⭐ 로컬 BE/FE 기동 시 `pnpm` 금지 — BE `gradlew.bat bootRun --args="--spring.profiles.active=local"` + FE `apps/web` 안 `node_modules\.bin\vite.cmd --port 5173 --host 127.0.0.1`. CLAUDE.md §8 `pnpm local` 표 인용 금지. 단일 출처 `_artifacts/_local_setup/nscm-fe-post-import-setup.ps1` L126-127 (2026-06-22 사용자 명시) |
| 80 | sp-cursor-name-response-key | 🆄/🅑 | T07/T08 (FE cursor data 추출 시) | ⭐⭐⭐ SP OUT cursor 이름 ↔ FE response key 정합 — `salesSiteData?.o_rc1 ?? salesSiteData?.O_RESULT_CURSOR ?? []` fallback chain 의무 (단일 키 의존 금지). dead code 정리 시 BE log + git blame 검증 의무. DMF0008 V11→V12 회귀 사고 후 (2026-06-22) |
| 81 | tab-driven-lazy-fetch | 🆄 | T01/T07 (multi-tab + row-context 화면) | ⭐⭐ 다단 grid + 하단 multi-tab sub-grid 화면에서 tab 전환 시 lazy fetch 의무 — `useEffect([activeTab, context])` 로 해당 sheet `setXOnly()` 호출 → tanstack 캐시로 재방문 무호출. DMF0008 V13 사용자 명시 (2026-06-22) |

| 82 | feature-button-meta-completeness | 🆄 | T01/T07 | 기능 버튼 메타 등록 완전성 — AS-IS 기능 + FE handler 있는데 버튼 미표시(`hasButton()` false) 방지 (2026-06-20 DMF0072) |
| 83 | search-area-button-position-and-toggle | 🅕 | T05 | SearchArea 검색버튼 위치 + 3단↑ 조회조건 펼침/닫기 토글 의무 (2026-06-20 DMF0072) |
| 84 | sheet-columns-meta-completeness | 🅖 | T01M/T04 | SHEET_COLUMNS 메타 완전성 + obsolete sheet 정리 (admin 반영 누락 방지, 2026-06-20 DMF0072) |
| 85 | sp-inline-function-gtt-mandatory | 🅑 | T08/T19 | SP body inline scalar function row-by-row 호출 → GTT temp 사전 적재 의무 (성능) |
| 86 | issue-feed-rules | 🅒 | (일일 이슈목록) | 일일 이슈목록 → 룰 후보 append-only 누적 피드 + 편입 절차(사람 검토 후 정식 승격) 정의 |
| 87 | screen-combo-validation-message-mandatory | 🆄/🅕 | T01/T04/T05/T10 | ⭐⭐⭐ **L** 콤보/모달 옵션 = 룩업 조회(하드코딩 금지, 빈 결과 fallback) + **V** 날짜 셀 표시↔검증 형식 일치 + **M** 메시지 코드 의미 충돌 금지(MSG00004) + **D** 다단 헤더 depth=DB 라벨 메타(`getColumnDepth`, 화면 하드코딩 임시방편). 이슈목록 2026-06-23 R-1~R-5 승격 |
| 88 | issue-log-daily-workflow | 🅒 | (일일 이슈목록 정리) | 일일 이슈목록 정리·룰 후보 편입 절차 — "이슈목록 정리/이슈 룰 반영/**이슈목록 Rule 적용**" 요청 시 MD 정리(`_analysis/이슈목록_{날짜}.md`) → 룰 후보 `issue-feed-rules.md` 누적 → 사람 검토 후 정식 hook 승격. issue-feed-rules 짝 워크플로우 |
| 89 | screen-grid-edit-merge-and-meta-mandatory | 🆄/🅕 | T01/T01M/T04/T05/T08/T10 | ⭐⭐⭐ **G** mergeManager=DataGrid props 직접 세팅(useEffect 주입 무시) + sameRow 머지 기준 `CRUD_TYPE`+`INSERT_GROUP_ID` + **E** 컬럼 편집범위=`INPUT_TP_CD`('IM'/'M') 메타 + 조건부 행잠금 `beginningEdit` + **A** 프로시저 JOIN 키 `SCM_ADM_MNU_BTN_MPG_M.API_ID`↔`SCM_ADM_API_M.API_ID` 매칭 + **P** Div 변경 reset+disabled(40/82)+period default(당월1일~6개월말일) + **M+** 비규격 메시지코드→표준(MSG00002/3). 이슈목록 2026-06-23 PM R-6~R-10 승격 |
| 91 | sheet-name-asis-preserve-mandatory | 🆄/🅑 | T01/T01M/T04/T08 | ⭐⭐⭐ SHEET_NAME = AS-IS 원본 그대로 (개명 금지) — FE SHEETS value=AS-IS SHEET_NAME(DB SHEET_COLUMNS 또는 `.cs` SpdSheet) + SP/SHEET_COLUMNS/MNU_BTN.SHT_NM 5구간 일치. 개명 시 -9997/빈grid/권한없음(DMF0043 ContributeMain 사고 메커니즘). 기존 화면은 수정 시 정정(일괄 audit X). SYS0014(GroupInfo/UserInfo/Division↔main/userInfo/division) (2026-06-26 사용자 명시) |
| 90 | figma-layout-parity-mandatory | 🆄 | T01/T01M/T11 | ⭐⭐⭐ Figma 디자인↔구현 레이아웃 정합 — 화면 Figma MD 영역 배치(상단조건/좌·우/상·하/영역 컨텐츠) 와 구현 일치 의무. **수정(T01M) 시 불일치면 레이아웃 교체 필수**(기능만 고치고 방치 금지). 신규(T01) 는 디자인-우선. Figma 추출 MD 는 "레이아웃 구조" 섹션(영역 의미) 포함 의무(geometry-only 금지). **§1.5 경계: Figma=디자인 참조 only — 정책 판단 금지(2026-07-14 사용자 명시)**. SYS0014 사고 (2026-06-26 사용자 명시) |
| 92 | column-division-id-visibility | 🅖 | T01/T01M/T04 | ⭐⭐⭐ admin `SCM_MST_SHEET_COLUMNS.DIVISION_ID`(콤마 토큰 리스트) 기반 컬럼 표시 — 값 있으면 선택 division 토큰 포함 시만 노출, 공란=항상. **SP/BE 무변경**: DIVISION_ID→free attribute(관례 ATTRIBUTE3) 복사 + FE `visibleColumns` 정확 토큰 매칭(substring 금지)+`divisionId` deps. DMF0020 master (2026-06-27 사용자 명시) |
| 93 | grid-multi-tier-header-height | 🅖 | T01/T01M/T04 | ⭐⭐⭐ 다단(2단/3단) 헤더 높이 = **48px 고정** (1단48/2단24×2/3단16×3) — foundation `HEIGHT_BY_COLUMN_DEPTH`+Wijmo row=max(height). P-A matched(동적 height 미지정, DMF0007) / P-B mismatched(48/maxDepth 정규화+verticalSpan+rAF invalidate, DMF0020). 1단 높이 ×N 비대화 금지 (2026-06-27 사용자 명시) |
| 94 | search-condition-height-uniformity | 🅖 | T01/T01M/T03 | ⭐⭐⭐ **디자인 필수** — 조회조건 모든 객체(Dropdown/Popup InputField/Text/DatePicker/Date input) 높이 = **36px 동일** (Main UI+Popup). Main UI=표준 searchFields/CustomDropdown 자동 / Popup raw select·date=`height:36px` / DatePicker=`.datePickerFix` wrapper 전 레벨(MuiBox/FormControl/OutlinedInput) 36 강제(design-system small 28 보정, sx forward 안 됨). + Figma 1단 4개=`gridSize` additive override(default 보존). DMF0020 (2026-06-27 사용자 명시) |
| 95 | grid-cell-backcolor-standard | 🅖 | T01/T01M/T04 | ⭐⭐⭐ **필수·공통** — grid cell 배경 3색 표준: **기본 White+홀짝 zebra**(클래스 없음 → foundation `.wj-cell.wj-alt`, `alternatingRowStep=1`) / **편집가능 Yellow**(`wj-cell-editable`, 컬럼 메타 editable→공용 DataGrid `formatEditableColumns` 자동) / **편집가능하나 잠금 Gray**(`wj-cell-non-editable`, 특수셀만 예: DMF0020 LOC 과거주차). 안티: 전체 회색(`applyReadOnlyColoring` blanket)·inline `backgroundColor` 임의색·흰색 강제(zebra 제거)·`alternatingRowStep=0`. DMF0020 정립→DMF0008 적용 (2026-06-28 사용자 명시) |
| 96 | column-align-code-standard | 🅑/🅖 | T01/T01M/T04/T18 | ⭐⭐ `HORIZONTAL_ALIGN_CODE` = **단일문자 C/L/R** — 전체단어("Center") 비표준 → FE alignMap 미매칭 → 정렬 미적용(silent). 신규 메타 단일문자 의무 + 기존 화면 수정 시 교정. SYS0013 (2026-06-30) |
| 97 | common-button-grid-routing | 🅖 | T01/T01M | ⭐⭐ 공통버튼=hotkeyConfig 만(권한 비gating)/그리드 자체 toolbar 금지 → **활성그리드 라우팅**(focusedSheet) + No 컬럼 2방식 + 부모키 변경 시 CRUD reset. (2026-06-30) |
| 98 | corp-meta-integrity-and-wiring | 🅑 | T08/T10/T18/T19 | ⭐⭐ 사내 메타 INSERT **NOT NULL 전수**(MSG_TP_CD/USE_YN ORA-01400) + LBL 채번=권위 DB max+1 + **BE 무변경 generic 배선**(API_M+BTN_MPG_M+PROC_M 3종 세트). (2026-06-30) |
| 99 | oracle-save-payload-integrity | 🅑/🅖 | T08/T10/T19 | ⭐⭐ Oracle SAVE payload 무결성 4대 — 편집=`'M'`/신규=`'I'`(서버 "존재+'I'" 검증 우회) · FE dedup 키=SP GROUP BY 키 정확 일치 · 신규 NOT NULL placeholder('-') · 근본원인 = BE 로그 ORA + USER_SOURCE. DMF0020 저장 4연발 (2026-07-01) |
| 100 | get-zero-dup-invisible-diagnosis | 🅑/🅖 | T08/T10/T18/T19 | ⭐⭐⭐ **조회 이상 3증상 진단 플레이북** — ① 오류 없는 0행 = PROC_M **순서 뒤틀림**(silent, VARCHAR — 위치+이름 대조 SQL / SORT_ORD CASE 스왑·DELETE+INSERT, PK=(PROC_NM,COL_NM,COL_TP_CD) COL_NM UPDATE 금지) ② 'Current'류만 반환 = WHERE `NVL(x,NULL)` 잔재 ③ 동일 2행 중복 = PIVOT 암묵 GROUP BY 행 분열(placeholder '-'/'--'/' ' — GTT 세션 COUNT(DISTINCT)/F12 diff 진단, 적재부 정규화 + 가격합계 불변 회귀) ④ 저장 성공(EVENT=N)인데 미표시 = GET 마스터 EXISTS(SITE_ITEM) / 정렬 위치 이동(scroll+select). 오진 3건 안티패턴(API_URL LIKE 금지 등) 포함. DMF0020+SYS0012 (2026-07-02) |
| 101 | ui-work-entry-playbook | 🆄 | T01/T01M | ⭐⭐⭐ **UI 작업 진입 플레이북** — 트리거 단어 "**보완**"→§1 수정 UI 전면 점검·교정(전 자원 × §3+§4+§5 전수 대조 "준수 점검표" → 전 위반 교정 → 8게이트+전/후 건수 보고, Figma SVG/MD 상세 적용) / "**신규 생성**"→§2 신규 UI 14단계(분석 MD 8종+xlsx 11·12시트+매트릭스+원시 .cs **3-way cross-check** → features walk-up → 전체 룰 적용 → 카운트 일치 검증). **공통 필수 4대**: 공용 DataGrid 필수 / sort·filter 기본버튼 자동활성 / 기능(추가·삭제·저장) 있으면 기능버튼 필수 / UI Category Setup 실사용 데이터 정비(미사용 삭제). 질의는 rule 기반 자체 해결. attach-context.ps1 자동 첨부 배선 (2026-07-02 사용자 명시) |

| 102 | custom-context-menu-standard | 🅖 | T01/T01M/T04 | ⭐⭐ **커스텀 우클릭 메뉴 표준** — dismiss `mousedown {once:true}` 가 항목 click 의 mousedown 단계에서 메뉴 제거 → click 증발("우클릭 무반응"). 3종 세트: ①항목 실행=mousedown(좌클릭) ②dismiss=persistent+`contains` 가드 ③capture add/remove 플래그 일치(누적 방지). hitTest 조건 미충족 시 브라우저 기본 메뉴 유지 + 메뉴명 i18n. DMF0003 PR 메뉴 사고 (2026-07-03) |
| 103 | pivot-header-drilldown | 🅖 | T01/T01M/T04 | ⭐⭐ **PIVOT 헤더 드릴다운**(SUM/M_ 헤더 dblclick→해당 월 W_ 펼침·접힘 / W_ 헤더→해당 주 D_ 토글, AS-IS L3416 1:1) — 전 버킷 컬럼(D/W/M) **상시 렌더**(SP 는 전체 반환) + 표시 규칙 rank 분리(활성=표시/상위합계=sumYn/하위=숨김) + 드릴 오버라이드 Map + 통합 applyDynVisibility(updatedLayout 재적용) + bucket/Sum/조회 변경 시 리셋. DMF0003 (2026-07-03) |
| 104 | sp-side-effect-test-gate | 🅑 | T08/T10/T19 | ⭐⭐ **저장 SP 테스트 실행 게이트** — 실행 전 ALL_SOURCE 실측 3단(①내부 COMMIT ②DML 표면·채번 ③메일/연쇄 SP) → 판정: COMMIT 무 = rollback 검증 / 단순 INSERT = 정리 가능 시만 / **메일·연쇄·본테이블 UPDATE = 임의 실행 금지**(화면 E2E 위임 + 근거 라인 보고). DMF0003 SAVE_PRPOPUP (2026-07-03) |
| 105 | screen-analysis-workbook-standard | 📘 | (화면설계서/**UI분석서·화면분석서**/**As-is 소스분석** 요청 — T02) | ⭐⭐ **화면설계서·UI분석서 기본 룰 — ⭐2026-07-15 신포맷 개정(견본=DMF0043 v1.0) · ⭐2026-07-20 확장(사용자 확정)**: ① **전체흐름 시트 신설(§1-B, 둘째장 공통)** = 도메인 프로세스 단계표(DM=6단계) + 본 화면 위치 ★ + 하단 사용 PKG·SP / 주요 테이블(읽기·쓰기, SP grep 실측) / Measure 저장대상(LOOKUP·SAVE SP 실측 — Measure 없는 화면은 저장 대상 컬럼/엔터티로 대체) ② **단위테스트 시트 전면 제외**(별도 TestCases 산출물로) ③ **UI분석서(xlsx) = 전체흐름 + 제약매트릭스 내부구조(§1-C 10시트: 개요/전체흐름/VALIDATION취합/MATRIX 4축/가시성_LAYER종속/SP_LOOKUP_콤보/이전소스_차이점[baseline GSCM_20260512↔GSCM diff, 변경분 없으면 "변경분 없음" 명기]) + 생성 절차 5단계(원천 확보→전체흐름 실측→openpyxl 생성·renumber→재오픈 assert→카운트 대사) — 정본 `DMF0003_MktFcst_UI분석서_v2.1.xlsx`, 명칭 = "UI분석서"** ④ 화면설계서 = **8시트**(§1-A: 개요/전체흐름/LAYOUT/조회조건·버튼/GRID/EVENT/VALIDATION/API·SP). 공통: **전면 자연어 서술**(식별자만 원문) + "쉬운 설명"·"줄" 열 폐지 + 불변 3원칙(anti-simplification 전수·누락0 / §1.5 AS-IS DB 계층 전수분석 / §5 카운트 대사 — 재오픈 assert: 설계서 8·UI분석서 10 시트 / 단위테스트 0건). ⑤ **⭐ 0단계 선행 산출물 의무** — 분석서 작성 前 `{ID}_{화면명}_주요이벤트_상세분석.md` + `{ID}_{화면명}_제약매트릭스_상세.md` 를 상세 생성(병렬 에이전트 소스 전체 Read), MATRIX 시트는 요약 아닌 **승계** ⑥ **⭐ 신 포맷(2026-07-20)** — 각 시트 상단 = 타이틀 1행만(2·3행 부제·"읽는 방법" 안내 미기재), 개요 = 화면정의만(개정내역 표 폐지 — 버전은 파일명 v{N}+changelog), 잠김(PermissionError) 시 v+0.1 버전업 저장, VALIDATION취합에 "원본 결함(실측)" 섹션 + 배선(API_M·PROC_M·BTN_MPG) 0행 정직 표기 + diff 판정법(도구 재생성 vs 실변경 구분·설정만="기능 변경분 없음"). ⚠ 구 11시트·"쉬운설명 열"·데이터연결 마인드맵은 **대체**(선택 산출) — 구 견본 DMF0003 v1.7/DMF0082 는 참고·이관 대상. |

> ⚠️ 표 정렬은 파일명 알파벳순이지만 #70~#89 는 등재 시점 보존 위해 표 끝에 배치. 다음 정합 PR 시 알파벳순으로 재배치.

> **Retracted (참고)**: `screen-hooks-patterns-mandatory` (구 별도 번호) — 2026-06-18 철회. DMF0004~6 master 에 `hooks/` 폴더 부재. 신규 화면 hooks/ 폴더는 **권장**(필수 아님).

---

## §5. 정적 룰 인벤토리 / Static Rule Inventory

### 5.1 TO-BE 정밀 룰 13 (`Doc/_rules_v2/_tobe/`) + 00 골격 청사진
| # | 파일 | 핵심 |
|---:|---|---|
| **00** | **SCREEN_ANATOMY** | ⭐ 소스 내부 골격 단일 진입 — 유형 3종 매트릭스 + 파일별 코딩 순서 + 3종 스켈레톤 + 불변/가변 + 정준형(§8). UI 신규/수정 시 1차 로드. DMF0004/0005/0006 추출 |
| 01 | file_structure | 폴더/명명 표준 + components 분리 의무 |
| 02 | imports | alias 인벤토리 + 정확 export |
| 03 | main_component | 7 단계 구조 + 5 변형 + 7 금지 |
| 04 | store | createPersistedStoreWithTab + G1 GET |
| 05 | constants | MENU_ID/SHEETS/RESPONSE_SET + LBL 5자리 |
| 06 | search_area | SearchArea/FormItem/CustomDropdown + 카탈로그 13 |
| 07 | datagrid | DataGrid wrapper + EditTracker + 8 금지 |
| 08 | column_meta | `_inputEditType`/`_ctrlType`/`_modalKey` + dynamic util |
| 09 | subtitle_hotkey | 10 키 매핑 + 공통 버튼 표시 정책 |
| 10 | popup_modal | 공용 11종 + CustomDialog + 신규 표준 |
| 11 | be_controller_service | Spring Boot + 보안 + 5 격차 endpoint |
| 12 | metadata_sql | 7-BLOCK + 멱등 INSERT + MSSQL→Oracle |
| 13 | routing_menu | MNU_URL slug + 7단계 디버깅 + UPPR_MNU_ID |

### 5.2 AS-IS Framework 7 (`Doc/_rules_v2/_asis/00_framework/`)
01 BaseForm(6,329L/157method) · 02 DataService(5,261L/87method) · 03 MessageHelper(405L/23 MSG) · 04 Logging(SCM_SYS_LOG) · 05 Auth_FormAuth(보안 의무) · 06 UsrControls(36 컨트롤) · 07 FoxDataClient(WCF→REST)

### 5.3 격차 G1~G10 (`Doc/_rules_v2/_mapping/asis_to_tobe.md`)
신규 구현 8: G1 검색조건 저장/복원 · G2 BigFilter 캐싱 · G3 PerfLog · G4 Batch · G5 File transfer · G6 YesNoCancel · G9 DateRangePicker · G10 MonthPicker. 격차 유지 2: G7 Impersonation · G8 UsrColumnCombo.

### 5.4 유지 룰 v1 (`Doc/_dev_rules/`) — **단일 출처 (진단 C-3 반영)**
| 룰 | 토픽 | UI 관련? |
|---|---|---|
| 02_DEVELOPMENT_RULES | 브랜치/커밋/PR/리뷰 | 절차 |
| 21_TROUBLESHOOTING | Oracle/DBeaver/Wijmo/PowerShell | DB/infra |
| 22_PACKAGE_ARTIFACTS | 이관 패키지 | 절차 |
| 28_GIT_MULTI_REMOTE | 모노레포 + GitHub + GitLab | infra |
| 29_LOCAL_DB_CSV_IMPORT | Docker Oracle CSV 적재 | DB |
| 30_LOCAL_BACKUP_RESTORE | 백업/원복 | infra |
| 31_FIGMA_DESIGN_INTEGRATION | Figma → React | **UI** |
| **32_CLAUDE_ORACLE_DIRECT** | Claude Code Oracle 직결 (SQLcl/oracledb) | DB · ⚠️ 기존 인덱스 미등재 → **여기서 정식 등재**(진단 C-3) |

> 나머지 24 룰(00/01/03~20/23~27) → `_dev_rules/_archive/` (흡수 검증 완료).

---

## §6. 실행 강제 hook vs 문서 hook / Enforced vs Guide Hooks (진단 G-1·C-4 반영)

> **중요**: §4 의 hook(총수 = 상단 카운트 단일 소스) 중 **프로그램이 자동 차단하는 것은 5종뿐**. 나머지 전부는 "AI 가 읽고 지키는 가이드"다. 수동 편집은 강제되지 않는다 — 용어를 구분한다.

### 6.1 실행 hook (`.claude/settings.json` wiring — 실제 차단)
| 스크립트 | 이벤트 | 강제 | Exit |
|---|---|---|---|
| `attach-context.ps1` | UserPromptSubmit | 키워드→룰 자동 첨부 (비차단) | 0 |
| `block-dev-commands.ps1` | PreToolUse(Bash) | 로컬 pnpm/turbo/eslint 차단 (`ALLOW_PNPM=1` 우회) | deny |
| `check-dbeaver-sql.ps1` | PostToolUse(Write/Edit) | `*_DBeaver*.sql` SQL*Plus 토큰 차단 | 2 |
| `check-notnull-insert.ps1` | PostToolUse(Write/Edit) | 6 테이블 NOT NULL 누락 차단 | 2 |
| `check-fe-import.ps1` | PostToolUse(Write/Edit) | `@shared/*` 금지 import 차단 + `as unknown as` 경고 | 2/1 |

### 6.2 강제 승격 후보 (권고 R-3 — 문서 hook → 실행 hook)
UI mandatory 의 POST-WRITE grep 중 기계 검증 가능한 패턴을 `check-fe-import.ps1` 류로 확장 권장:
`<FlexGrid` 직접 JSX · `from 'clsx'`/`'lodash'`/`'react-i18next'` 직접 · `window.alert(` · `from '@tanstack/react-query'` · 인라인 `<dialog>`. → 수동 작업에도 자동 차단 적용.

### 6.3 OS 커버리지 (권고 R-7)
현재 wiring 은 ps1 전용(Windows). `block-dev-commands.sh` 부재 + sh 미연결 → Linux/클라우드 강제 0. 5종 모두 `.sh` 완비 + settings.json OS 분기 필요.

---

## §7. PR 머지 게이트 / PR Merge Gate (`pre-submit` §0)

```
1. anti-simplification 확인 (단순화 0)
2. UI-MANDATORY §3 체크리스트 통과 (신규 T01 / 수정 T01M)
3. AS-IS 4축 매핑 (__asis-mapping__.md 모든 행 ✅)
4. 메타 SQL 7-BLOCK 등록 + SCMD_APP GRANT
5. 4 파일 SQL 세트 (DBeaver 호환)
6. 격차 G1~G10 적용 (화면별)
7. 빌드/Lint/Type-check 0 + 기존 화면 regression 0 (Hard Boundary)
8. screen-completion-gate 8 게이트 보고
```

---

## §8. 채택·유지 가이드 / Adoption & Maintenance (진단 권고 반영)

1. **R-1 진입점 단일화**: 루트 `CLAUDE.md` 1차 로드에 본 파일 추가, `_rules_v2/CLAUDE.md` 는 포인터로 축소.
2. **R-2 카운트 SSoT**: 카운트는 본 §4 + 00_INDEX 만 보유. 사전 검증 스니펫:
   ```bash
   N=$(ls Doc/_rules_v2/hooks/*.md | wc -l)
   grep -q "= \*\*$N\*\*" Doc/_rules_consolidation/RULESET_MASTER.md || echo "⚠ hook count drift: disk=$N"
   ```
3. **R-4 재번호**: §4 는 파일명 알파벳순(고정) — 신규 hook 은 알파벳 위치 삽입(번호는 표시 순서일 뿐, 파일명이 키).
4. **R-5 v1 정리**: §5.4 가 유지 룰 단일 출처. v1 `hooks/` DEPRECATED 10종은 archive 권장.
5. **R-8 용어**: "문서 hook(guide)" 과 "실행 hook(enforced)" 을 §6 처럼 항상 분리 표기.

---

> 단일 진실 소스 / Single Source of Truth:
> - 진입 / Entry: 루트 `CLAUDE.md` → 본 파일 → `00_INDEX.md`
> - 카운트 / Count: 본 §4 (= 114) + `00_INDEX.md` (동기화 의무)
> - UI 누락 방지 / UI no-omission: 본 §3 체크리스트 (PR 게이트 §7 통합)
