# sdm-domain-development-standard — SDM 도메인 개발 표준 (hook #134)

> **신설**: 2026-08-12 (사용자 명시 — "SDM 개발관련은 SDM 으로 별도 RULE 생성")
> **적용**: SDM 대분류(SDM10xx 등 SPMS/샘플 수요 계열) 화면·DB·메타 작업 전부 (T01/T01M/T05/T06/T07)
> **첫 적용 정본**: SDM1010 Project Registration (2026-08-12)

## §0. SDM 도메인 정의 — 다른 도메인과 다른 3대 전제

| 전제 | 내용 | 파급 |
|---|---|---|
| **AS-IS 부재** | SDM 은 AS-IS GSCM 에 대응 화면이 없는 **순수 신규 도메인**(GSCM 전수 grep 실측 — Project 등록 계열 부재). | 대사표·게이트의 AS-IS 축 처리가 §2 로 대체됨 |
| **정본 원천 = 화면설계서 xlsx** | `Doc/화면설계서_SDM/{UI_ID}_{화면명}_화면설계서_{YYYYMMDD}.xlsx` 가 유일 정본. | 구현 전 설계서 **15시트급 전수 분석** 의무(일부 시트만 읽고 착수 금지 — anti-simplification) |
| **정오표 의무** | 설계서 오류·미결 발견 시 임의 판단으로 조용히 덮지 않는다 — **정정 구현 + `Doc/화면분석서/{UI_ID}_..._정오표.md` 기록**(설계자 확인용, 원문·실측 근거·적용 방침 3열). | 미결 항목은 "설계 미완" 사유로 대사표 제외 처리 가능(임의 완성 금지 — SDM1010 My Work 계보) |

## §1. 명명·배치 표준 (SDM 고정 규약)

| 축 | 규약 | 비고 |
|---|---|---|
| 메뉴 트리 | 대분류 `MNU_ID='SDM'`(UPPR NULL, MNU_LV_NO=1, MNU_TP_CD='MENU', MNU_URL='sdm') → 화면 `MNU_ID={UI_ID}`(UPPR='SDM', 'SCREEN') | 하위 중분류 필요 시 `SDM_Xxx` |
| FE 패키지 | `nscm-fe/features/sdm/` — alias `@sdm`(tsconfig.base paths + apps/web deps). 페이지 = `features/sdm/src/pages/{kebab-case}/` | viewRegistry glob 자동수집 — Router 수정 금지 |
| ROUTE_PATH | `'sdm/{페이지폴더}'` 2단 — 메타 SQL **마지막** 실행 | 페이지 폴더명은 전 도메인 유일 |
| PKG/SP | `PKG_{UI_ID}` + SP 명 = **설계서 기재명 그대로**(`P_{UI_ID}_...`). 설계서가 `P_` 접두를 누락한 SP 는 `P_` 통일 후 정오표 기록 | SDM1010 = 12본 정본 |
| 테이블 | `SDM_MST_*` — 설계서 기재 엔터티 컬럼 접두(예: DPJT)에서 파생. 감사컬럼 4종 + 수량/금액 NUMBER(30,10) 표준 | 예: SDM_MST_DPJT_M / _AUTH_M / _AUTH_REQ_M |
| Lookup | `SPMS_*` 접두(설계서 기재 p_lookup_type 그대로) — `SCM_ADM_LOOKUP_MASTER`/`_DETAIL` 등재 후 `SCM0001_GET_LOOKUP_VALUES` 소비 | 예: SPMS_DPJT_AUTH_TYPE / SPMS_DPJT_REG_STATUS |
| 권한그룹 | `SPMS Administrator` / `SPMS Planner` (SCM_ADM_USER_GR_M) + ADMIN 병행 매핑 | 메뉴 권한은 대분류·중분류·화면 3계층 모두 등재(부모 누락=트리 비노출) |
| 콤보 | 기존 공통 콤보(MyDivision/EndCustomer 계열 등) 재사용 우선 — 부재 시 신설(`SCM_ADM_CMBO_SQL_M`, SCM_MGR 접두+SCMP_APP GRANT 세트) | 공유 콤보 SQL 임의 수정 금지(hook #59 §5-G) |

## §2. AS-IS 부재 화면의 대사표·게이트 처리 (정당 예외의 단일 소스)

1. **분석 md 4종 = 설계서 재기술**: 주요이벤트(E번호 전수)/제약매트릭스(P-nn)/Cascade_Filter/정오표 — hook #105 E번호 양식으로 작성해야 `asis_mapping_gate --init` 추출 가능. 원천 헤더에 "정본 원천 = 화면설계서 xlsx (AS-IS 부재)" 명시.
2. **대사표**: `--init` 로 생성(COMMON:UC-01~06 자동 포함). **HANDLER 축 = AS-IS `.cs` 부재로 N/A(정당 제외)** — 대사표 헤더에 사유 명시.
3. **게이트 9섹션**: §8 콤보 호출지점 대사(combo_callsite_parity)는 AS-IS 정본 `.cs` 해석 전제 → **"AS-IS 부재" 사유 명시 SKIP** 처리(ERROR 방치 금지 — 리포트에 사유 행 기재). 나머지 8섹션은 전부 동일 적용.
4. **Figma MD 부재 시**: 설계서 레이아웃/GRID 목업 시트를 영역 매핑표로 대체하고 정오표(또는 분석 md)에 명시.
5. 그 외 **UI-MANDATORY 체크리스트(RULESET_MASTER §3)·완료 선언 3리포트(#125/#126)는 예외 없이 전부 적용** — AS-IS 부재는 "AS-IS 축"만 대체할 뿐 검증 강도를 낮추는 사유가 아니다.

## §3. SDM 이관·적용 표준

- 사내 Oracle 선적용·검증(로컬 직접 실행 표준) → 클라우드 이관 패키지 `_artifacts/_deploy_packages/{UI_ID}_CLOUD_{date}/` (DDL/META 멱등/PKG BODY/GRANT/i18n 5종 + 실행 순서서 — ROUTE_PATH 마지막).
- 신규 도메인 최초 화면은 **대분류 메뉴·권한그룹·features 패키지 신설분**을 이관 패키지에 반드시 동봉(후속 화면은 화면분만).
- i18n: `SCM_ADM_MSG_M` INSERT 후 `pnpm gen:i18n` (locales 직접 편집 금지 — hook #114 §5 3점 동시).

## §4. 체크 순서 (SDM 신규 화면 1본)

```
설계서 전수 분석 → 정오표 → 분석 md 4종 → 대사표 --init
→ DB(테이블/Lookup/콤보/PKG/GRANT) 사내 적용 → 메타 12스텝(ROUTE_PATH 마지막)
→ features/sdm 페이지 구현(§3 UI-MANDATORY) → procedures.d.ts → gen:i18n
→ 검증 4축(대사표 check / CRUD 왕복 / E2E 시나리오 등재+8축 / 게이트 9섹션[§8 사유 SKIP])
→ 이관 패키지 → 완료 선언(3리포트+신선도)
```
