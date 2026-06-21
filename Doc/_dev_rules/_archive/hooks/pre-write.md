# Pre-Write Hook — NSCM 코드 작성 직전 자기 점검

> ⚠️ **이 Hook 실행 전 반드시 Read**: `Doc/_dev_rules/hooks/anti-simplification.md` (2026-05-22 신규)
> 작업 단순화 절대 금지 — 다중 패턴, Cross-check, 기존 자료 활용 의무. 위반 시 신뢰성 손상.


> Claude/AI가 Edit 또는 Write 도구를 사용해 코드 파일을 생성/수정하기 직전 반드시 자문해야 할 항목.

## 1. 작업 영역 확인

```
[ ] 이 작업은 FE / BE / DB / 문서 중 어느 영역인가?
[ ] 신규 파일 작성인가, 기존 파일 수정인가?
[ ] 영향 받는 다른 영역이 있는가? (FE 변경 → BE API 변경 필요?)
```

## 2. 기존 코드 참조 (필수)

```
[ ] FE: features/admin/src/pages/user-management/ 를 Read 했는가?
[ ] BE: com.lgcns.nscm.admin.menu/ 를 Read 했는가?
[ ] 작업 화면의 분석 자료 (Doc/_analysis/domain_*/screens/{id}/) 확인했는가?
[ ] PKG_DMF*/PKG_SCM* 등 DB 변환 산출물 (To-be_v2_converted/) 확인했는가?
```

## 2.5. ⭐ As-Is Validation / Expression 자료 강제 읽기 (신규 화면 FE 작업 시 필수)

신규 화면을 FE 측에서 코드 작성하기 전, **반드시 다음을 Read 도구로 읽고 카운트를 메모리에 기록**:

```
[ ] Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/validation.md
    → 총 Validation 건수: ____ 건
[ ] Doc/_analysis/domain_{DM|Common|SCM}/screens/{화면ID}/expressions.md
    → 총 Expression 건수: ____ 건
[ ] {27|28|29}_*_Screens/*_{화면ID}.xlsx
    → 11_Validation 시트와 12_Expression 시트 데이터 확인
```

읽지 않고 코드 작성을 시작하면 As-Is 동작 누락 위험. 카운트 일치 검증은 post-write/pre-submit Hook이 자동 수행.

→ 상세 매핑 룰: `Doc/_dev_rules/09_WIJMO_VALIDATION_EXPRESSION.md`

## 2.6. ⭐ 빈 매핑 매트릭스 자동 생성 (필수 명령)

읽기 직후, To-Be FE 폴더에 빈 `__asis-mapping__.md` 매트릭스를 즉시 생성:

```bash
# 화면 1개 (자동 도메인 탐지)
python3 Doc/_analysis/scripts/gen_asis_mapping.py {화면ID}

# To-Be FE 폴더에 직접 출력 (권장)
python3 Doc/_analysis/scripts/gen_asis_mapping.py \
    --out C:/Projects/NSCM/nscm-fe/features/{domain}/src/pages/{kebab-page}/__asis-mapping__.md \
    {화면ID}
```

생성된 매트릭스의 모든 행은 ❌ 상태로 시작 — To-Be 코드 작성 후 각 행의 "To-Be 위치" 컬럼을 채우고 ✅ 로 마킹.

→ 스크립트 상세: `Doc/_analysis/scripts/README.md`

## 3. 명명 규약 확인

**FE**:
- 파일명: 컴포넌트 PascalCase / 폴더 kebab-case / 유틸 camelCase
- MENU_ID: `'XXX0000' as const` 형식
- Workspace alias 사용 (`@foundation`, `@shared`, `@demand` 등)
- Zustand store: `use{PageName}Store`

**BE**:
- 패키지: `com.lgcns.nscm.{domain}.{feature}`
- 클래스: `{Feature}Controller` / `{Feature}Service` / `{Feature}ServiceImpl`
- nameSpace: `"{domain}.{feature}."` (소문자 점표기)
- DTO 위치: `dto/` 서브패키지
- MyBatis XML: `src/main/resources/sql/{domain}/{Feature}.xml`

## 4. 의존 방향 검증

- FE: Foundation(`@foundation`) → Shared(`@shared`) → Application(`@admin`/`@demand` 등) 방향만
- FE: Feature 간 직접 import 없음
- BE: Controller → Service(interface) → ServiceImpl → BaseService 방향만
- BE: framework 패키지가 비즈니스 패키지를 import하지 않음

## 5. 작성 전 5초 룰

1. "이 파일은 user-management/menu와 같은 구조인가?"
2. "Layer 위반은 없는가?"
3. "기존 패턴과 다른 점이 있다면 정당한 이유가 있는가?"
4. "Doc/_dev_rules/07_DO_AND_DONT.md의 금지사항 위반이 없는가?"
5. "이 코드는 '한 사람이 짠 것처럼' 보이는가?"
6. ⭐ "신규 화면 FE 작업이라면 validation.md + expressions.md 카운트를 기록했는가?"

한 항목이라도 "아니오"라면 → 작업 멈추고 기존 패턴 다시 확인.

## 6. Foundation Layer 확인 (BE만)

신규 SP/Function 작성 시:
- `To-be_v2_converted/01_Foundation/`의 TYPE 객체 (T_STR_TAB 등) 활용 가능한가?
- `PR_SCM_SYS_LOG_BATCH` / `PR_DM_SYS_LOG_BATCH` 호출 적절한가?
- `$$PLSQL_UNIT` 사용 (`v_program_name` 하드코딩 X)

## 6.5 ⭐ 확장 패턴 분기 결정 (2026-05-22 신설 — DMF0020 작업 반영)

화면 폴더 생성 직전, 다음 조건을 평가하여 **기본 패턴** vs **확장 패턴** 결정:

```
조건 (1개 이상 충족 → 확장 패턴):
[ ] As-Is validation.md 의 행 수 ≥ 20
[ ] As-Is expressions.md 의 행 수 ≥ 5
[ ] As-Is 사업부 분기 (Division 40/81/82) ≥ 6건
[ ] As-Is POPUP `.cs` 파일 ≥ 1개
```

- **기본 패턴** → 7 파일 (TSX/store/constants/index/Form/Form.scss/Grid). 룰 05 §2.0.1.
- **확장 패턴** → 7 파일 + hooks/ (Validation/Expression) + components/modals/ (POPUP 별) + `__asis-mapping__.md`. 룰 05 §2.0.2.

확장 패턴 결정 시 추가 자료 확인:
```
[ ] POPUP `.cs` 파일 각각 Read → 전용 (A) / 공통 (B) 분류
    (A) 본 화면 전용 → components/modals/{ModalName}Modal.tsx 작성
    (B) 다른 화면도 호출 → 호출만, 매트릭스 ⚠ 표기 (룰 12 §11.1)
[ ] 동적 컬럼 (시간축 등) 사용 화면이면 별도 메타 SP (예: GET_SPREAD_TITLE_DATE) → 커스텀 BTN_CD 등록 (룰 08 §4.6.1)
[ ] 그룹 동시 선택 (As-Is Raw_CellClick 패턴) 있으면 GROUP_KEY_COLUMNS 상수 정의 (룰 12 §10)
```

→ 결정 근거 + As-Is 카운트는 매트릭스 (`__asis-mapping__.md`) 헤더에 기록.

## 6.6 ⭐ DB/서버 미연결 환경 결정 (2026-05-22 신설)

작업 환경이 DB / 서버 미연결이면 **`_artifacts` 이관 패키지** 모드:

```
[ ] 워크스페이스 root 에 _{screen_id}_artifacts/ 폴더 생성
[ ] fe/ 와 sql/ 하위 폴더 생성
[ ] FE 파일은 _artifacts/fe/features/{domain}/src/pages/{kebab}/ 에 직접 작성
    (nscm-fe 안에 직접 작성 X — 서버 미연결로 빌드 검증 불가)
[ ] SQL 은 _artifacts/sql/ 에 4-파일 세트
[ ] _README.md + _COMMON_FILES_GUIDE.md 동봉
[ ] 작업 완료 후 압축 → 클라우드 이관
```

→ 상세 룰: `22_PACKAGE_ARTIFACTS.md`

## 7. AI 측 도구 호출 사전 점검 ⭐ (2026-05-19 신설)

AI 가 도구를 호출하기 직전 다음을 확인:

```
[ ] PowerShell 도구 사용 시: 명령 첫 줄에 UTF-8 prelude prepend 했는가?
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $OutputEncoding = [System.Text.Encoding]::UTF8;
[ ] PowerShell 로 한글 파일 읽을 때: -Encoding UTF8 명시 했는가?
[ ] 신규 화면 등록 SQL 작성 시: 4-파일 세트 (SQL*Plus 1 + DBeaver 3) 계획 했는가?
    - .sql / _DBeaver.sql / _DBeaver_Verify.sql / _DBeaver_Diagnose.sql
[ ] DBeaver 용 SQL 에서 절대 금지 사항 인지:
    - SET DEFINE / DEFINE / &변수 / PROMPT / UNDEFINE / `/` 종결자 / PL+SELECT 혼재
[ ] 메타 등록 SQL 에서 PKG_NSCM_SCREEN_REGISTRATION 호출 금지 (폐기됨, 자기완결형만)
```

→ 상세: `Doc/_dev_rules/08_SCREEN_REGISTRATION.md` §7.1 + `21_TROUBLESHOOTING.md`
