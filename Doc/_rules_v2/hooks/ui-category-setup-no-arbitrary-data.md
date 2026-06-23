# Hook — UI Category Setup 데이터 임의 생성 절대 금지 (강력 룰)

> ⚠️ **이 룰은 `anti-simplification.md` 와 동급 우선순위입니다.**
> AI 가 admin UI Category Setup 으로 관리되는 메타 테이블에 **임의 INSERT/UPDATE/추측 생성** 하는 행위를 **절대 금지**합니다.
> 위반 시 운영자가 결정한 화면 동작 규칙이 무효화되어 **운영 신뢰성 손상 → 도구 사용 중단** 으로 이어집니다.

작성: 2026-06-22 (사용자 명시 강력 룰 요청 — "강력한 RULE 로 적용해서 반드시 지켜지도록")
상위 룰: `anti-simplification.md`
짝 hook: `ui-category-setup-column-meta.md` (FE 동적 fetch 측), `ui-dynamic-property-management.md`
관련 메모리: `feedback_ui_category_setup_no_arbitrary_data.md`

---

## §0. 사용자 명시 (2026-06-22)

> "UI CATEGORY SETTUP 데이터는 임의로 생성하지 않습니다.
> 화면별로 생성되어 있는 데이터를 그대로 사용 합니다.
> 이부분은 강력한 RULE 로 적용해서 반드시 지켜지도록 해주세요."

---

## §1. 금지 대상 테이블 (운영 메타 — admin UI 가 관리)

| 테이블 | 관리 admin 화면 | 영향 |
|---|---|---|
| `SCM_MGR.SCM_MST_SHEET_COLUMNS` | SYS0004 UI Category Setup | 화면 컬럼 정의 (Visible/Width/Label/InputTp/CellCtrl/Lookup) |
| `SCM_MGR.SCM_ADM_MNU_BTN_MPG_M` | SYS0009 (or 유사) | 화면 버튼 매핑 (SEARCH/SAVE/INSERT/DELETE) |
| `SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 권한 관리 화면 | 그룹별 버튼 권한 |
| `SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL` | Lookup 관리 화면 | LOOKUP_TYPE 별 옵션 (combo 원천) |
| `SCM_MGR.SCM_ADM_CMBO_SQL_M` | Combo SQL 관리 | combo SQL_ID → SQL_DTL_CTN |
| `SCM_MGR.SCM_ADM_MSG_M` | SYS0001 Message Management | i18n 메시지 (KO/EN/CN) |
| `SCM_MGR.SCM_ADM_API_M` / `SCM_ADM_PROC_M` | API/PROC 등록 | API ↔ SP 매핑 |
| `SCM_MGR.SCM_ADM_MNU_M` | 메뉴 트리 관리 | 메뉴 등록 |

---

## §2. 절대 금지 행위 (Hard Rules)

| # | 금지 행위 | 위반 결과 |
|---:|---|---|
| 1 | ❌ 신규 화면 작성 시 "표준 default" / "임의 추정" 으로 `SCM_MST_SHEET_COLUMNS` row INSERT | 운영자 등록 데이터와 충돌 / 무효화 |
| 2 | ❌ "보통 이런 패턴이니" 라며 `SCM_ADM_MNU_BTN_MPG_M` / `SCM_ADM_API_M` / `SCM_ADM_PROC_M` 인서트 | 화면 동작 예측 불가 |
| 3 | ❌ FE 코드 분석해서 추측한 컬럼 메타로 INSERT | DDL/패턴 cross-check 없는 추측 (DMF0020 3중 단순화 사고 재현) |
| 4 | ❌ 다른 화면의 메타 복사 + `PROGRAM_ID` 만 변경해서 INSERT | 화면별 컨텍스트 무시 |
| 5 | ❌ 다국어 라벨 (`SCM_ADM_MSG_M`) 을 AI 가 번역해서 INSERT (특히 CN) | 번역 품질 불일치 / 운영자 의도 무시 |
| 6 | ❌ `LOOKUP_TYPE` 옵션을 "이게 맞을 것 같은데" 로 INSERT | 잘못된 옵션 노출 |
| 7 | ❌ admin UI 화면 (SYS0001~SYS0014 등) 에서 사용자가 등록할 데이터를 AI 가 선행 생성 | 사용자가 등록 흐름 차단 |

---

## §3. 허용 행위 (White List)

| 시나리오 | 행동 |
|---|---|
| 사용자가 명시 요청 한 INSERT/UPDATE (요청 내용 그대로) | ✅ 그대로 수행 |
| AS-IS / 백업 / 다른 환경 추출 실 데이터 그대로 복사 (변환·추측 없이) | ✅ 그대로 복사 (예: SHEET_COLUMNS_ASIS_SYNC) |
| 사용자가 등록한 데이터 조회 (분석·보고) | ✅ 조회만 |
| 누락 발견 시 사용자에게 보고 | ✅ 자동 생성 X, 결정 위임 |

---

## §4. 시나리오별 행동 (How to apply)

| 시나리오 | 잘못된 행동 | 올바른 행동 |
|---|---|---|
| 신규 화면 작성 중 `SCM_MST_SHEET_COLUMNS` 가 비어 있음 | ❌ AI 가 23 row INSERT 자동 작성 | ✅ 사용자에게 "UI Category Setup (SYS0004) 에서 등록 부탁드립니다" 보고 |
| FE 화면 동작 안 됨 → 메타 누락 발견 | ❌ AI 추정으로 메타 INSERT 작성 | ✅ 진단 보고 + 사용자가 admin 화면에서 등록 또는 명시 INSERT 요청 시 처리 |
| 다른 화면 메타 복사 유혹 | ❌ DMF0004 메타 → DMF0099 로 PROGRAM_ID 만 변경 | ✅ 거부. 화면별 메타 독립 — 같은 컬럼명도 화면 컨텍스트마다 다름 |
| AS-IS → 사내 / 사내 → 클라우드 데이터 이관 | ❌ 추가 변환 / "정리" / 일부 row 자동 보강 | ✅ MERGE 패턴 — 실 데이터 그대로 복사. 충돌 시 사용자 결정 우선 |
| 다국어 라벨 EN/CN 비어있음 | ❌ AI 가 자동 번역 INSERT | ✅ `i18n-ko-en-alignment.md` 룰 만 적용 (KO=EN 동일 — 사용자 명시 시) — CN 번역 AI 생성 X |
| LOOKUP_TYPE 신규 옵션 등록 | ❌ AI 가 가능한 값을 추측해서 INSERT | ✅ 사용자가 명시 요청 + 패턴 (예: 기존 LBL/MSG/MNU 표준 row 5+ 필드) cross-check 후 1:1 매핑 |

---

## §5. 사례 — 2026-06-22 적용 케이스

### 5.1 SHEET_COLUMNS_ASIS_SYNC (허용 — 사용자 명시)
- 사용자가 AS-IS MSSQL → 사내 Oracle 동기화 요청 (5 PROGRAM_IDs)
- AI: AS-IS 실 데이터 244 rows 그대로 추출 → Oracle MERGE
- ✅ "실 데이터 그대로 복사" 정책 준수 — 변환 / 추측 / 보강 없음

### 5.2 SYS0001 API type 옵션 추가 (허용 — 사용자 명시)
- 사용자가 `LOOKUP_TYPE='MSG_TP_CD'` 에 `API` 옵션 추가 요청
- AI: 기존 3 row (LBL/MSG/MNU) 패턴 cross-check → API row 1건 INSERT (DISPLAY_SEQ=4, 모든 필드 패턴 일치)
- ✅ 사용자 명시 + 기존 패턴 1:1 매핑

### 5.3 DMF0072 SHEET_COLUMNS 메타 (허용 — 사용자 명시)
- 사용자가 SHEET_COLUMNS_ASIS_SYNC 일환으로 DMF0072 23 rows 이관 요청
- AI: AS-IS 데이터 그대로 → MERGE
- ✅ 변환 없이 복사

---

## §6. PRE-WRITE 점검 (의무)

INSERT/UPDATE 작성 전 다음 4 질문 자가 검증:

1. [ ] **사용자가 명시 요청 했는가?** (NO → 작업 중단 + 보고)
2. [ ] **원천이 사용자가 제공한 실 데이터인가?** (AS-IS / 백업 / 명시 값 — NO → 추측 작성 금지)
3. [ ] **`SCM_MGR` 의 메타 테이블 (`SCM_MST_SHEET_COLUMNS` / `SCM_ADM_*`) 인가?** (YES → 본 hook 의무 적용)
4. [ ] **DDL grep + NOT NULL/DEFAULT cross-check 했는가?** (NO → `feedback_ddl_grep_before_sql.md` 위반)

위 4 점검 모두 ✅ 일 때만 진행. 1 건이라도 NO = 즉시 사용자에게 보고.

---

## §7. POST-WRITE 검증

- INSERT 직후 `SELECT COUNT(*) ... WHERE PROGRAM_ID/MNU_ID/SQL_ID/LOOKUP_TYPE='...'` 으로 적용 row 수 보고
- 사용자 측 검증 요청 (admin UI 에서 확인 가능한 형태)

---

## §8. 위반 시 처리

- 즉시 작업 중단 + 사용자에게 보고
- 잘못 INSERT 한 row → `DELETE WHERE` 로 원복 SQL 동시 제공
- 메모리 `anti-simplification` 와 동급 사고 카탈로그 등재

---

## §9. 짝 hook 과의 관계

| 관련 hook | 차이 |
|---|---|
| `ui-category-setup-column-meta.md` | **FE 측** 동적 fetch 의무 (admin 변경 즉시 반영) |
| `ui-dynamic-property-management.md` | **3 구성요소** (Menu Button + Column + Measure) 동적 fetch |
| **본 hook** | **DB 측** AI 임의 생성 금지 (사용자 명시 데이터 만 처리) |

3 hook 함께 적용 시 — 운영자가 admin UI 에서 등록한 데이터가 단일 진실 source → FE 가 그대로 fetch → AI 가 데이터를 임의로 만들지 않음 → 운영 신뢰성 확보.
