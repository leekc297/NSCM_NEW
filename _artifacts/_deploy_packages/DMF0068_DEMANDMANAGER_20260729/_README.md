# DMF0068 Demand Manager — 이관 패키지 (2026-07-29)

AS-IS `DMF0068_DemandManager40`(소형 수주관리, Division 40 전용) → TO-BE DMF0068.
분석·설계 문서: `Doc/화면분석서/DMF0068_DemandManager_UI분석서_v1.0.xlsx` / `Doc/화면설계서/DMF0068_DemandManager_화면설계서_v1.0.xlsx`
선행 MD: `Doc/화면분석서/DMF0068_DemandManager_{주요이벤트_상세분석,제약매트릭스_상세}.md`

## ⛔ 이 패키지가 반드시 고쳐야 하는 것 — 조회 프로시저 차단성 결함 2건

사내에서 실제로 실행해 확인했고, AS-IS MSSQL 원문과 대조해 **변환 과정에서 생긴 결함**임을 확정했다.
정정 전에는 화면이 의미 있는 값을 표시하지 못한다.

| # | 증상 | 원인 | 정정 | 실측 |
|---:|---|---|---|---|
| D1 | 월별 수량·실적·계획·잔고가 전부 0 | `NVL(A.PROJECT_INFO,'') <> ''` 가 Oracle 에서 항상 거짓 → 작업 테이블 0행 | `A.PROJECT_INFO IS NOT NULL` | 현재 조건 0행 / 정정 조건 14,981행 |
| D2 | 월 컬럼 M1..Mn 이 수량 대신 연월 숫자(202501…)를 반환 | MSSQL 대괄호 식별자를 따옴표 없이 옮겨 숫자 상수가 됨 | PIVOT 목록·참조를 큰따옴표 식별자로 생성 | 실행으로 현상·정정 양쪽 확인 |
| D7 | 편집 권한 없는 사용자는 조회 결과·버전 목록이 통째로 0행 | 편집권한 뷰를 INNER JOIN | LEFT JOIN + `NVL(EDIT_YN,'N')` | 확정 권한 정책 반영 |

기존 5개 멤버의 **본문은 그대로 두고** CLOB(JSON) 래퍼 2종을 새로 추가했다
(`P_DMF0068_SAVE_ORDERLIST_JSON` / `P_DMF0068_DEL_ORDERLIST_JSON`).
표준 호출 방식으로는 컬렉션 타입 입력을 넘길 수 없기 때문이다.

## ⭐ 계정별 실행 구분 (2026-07-30 추가)

| 계정 | 파일 | 비고 |
|---|---|---|
| **SCM_MGR** (스키마 소유자) | `00_PRECHECK_CLOUD.sql` · `02_DB_SP/01,02,03,05` · `03_META/*` 전부 | 본 패키지의 **거의 전부** |
| ⛔ **어플 계정**<br>클라우드=**SCMP_APP**<br>사내=SCMD_APP | **`02_DB_SP/04_APP_SYNONYM_ONLY.sql`** — **이 1개 파일뿐** | SYNONYM 1건. **없으면 조회 시 PLS-00201 → -9994** |
| (DBA) | 없음 | 해당 계정 세션으로 돌리면 **DBA 불필요** |

⚠️ **계정 이름을 가정하지 말 것** — 클라우드 어플 계정이 **SCMP_APP 으로 변경**되었다(2026-07-30 확인).
사내 실측 `PKG_%` SYNONYM 소유자 = SCMP_APP 57 / SCMD_APP 56 (**두 계정 공존**).
엉뚱한 계정에 만들면 **SP 직접 호출은 성공하는데 화면만 PLS-00201** 이 계속 난다(SYS0017 실사고).
`03_GRANT.sql` 은 두 계정 중 **실제 존재하는 계정에만 동적 GRANT** 한다.

⛔ `04_APP_SYNONYM_ONLY.sql` 을 SCM_MGR 로 실행하지 말 것 — **ORA-01031**.
반대로 어플 계정 세션에서 다른 파일을 실행하지 말 것 — 객체 소유자가 어긋난다.

문제 진단:
- **조회 -9994 / PLS-00201** → `02_DB_SP/05_DIAG_9994.sql` (1순위 = SYNONYM OWNER ↔ 어플 계정 일치)
- **메뉴 클릭 Page Not Found** → 화면 해석 키는 `ROUTE_PATH` 가 아니라 **`MNU_URL` 마지막 세그먼트 = 페이지 폴더명**이다
  (`ROUTE_PATH` 는 `'<도메인>/<폴더>'` 2단만 유효 — 우리 값은 3단이라 매칭에 쓰이지 않는다).
  `12` 의 `99_ROUTE_PATH.sql` 이 `MNU_URL='demand-manager'` 를 함께 UPDATE 하므로 **반드시 실행**할 것.
  그래도 404 면 클라우드 `apps/web/src/mdi/viewRegistry.tsx` 세대 판별 —
  구판(`VIEW_REGISTRY` 정적 맵, **MNU_ID 키**)이면 `DMF0068: view(() => import('@demand/demand-manager')...)` **1줄 등록 필수**.

## 적용 순서

| 순서 | 계정 | 파일 | 내용 |
|---:|---|---|---|
| 0 | SCM_MGR | `00_PRECHECK_CLOUD.sql` | 선행 객체 / 채번 충돌 / 권한 원본 / 컬럼 메타 / 메뉴 현황 점검 |
| 1 | SCM_MGR | `02_DB_SP/01_PKG_DMF0068_SPEC.sql` | 패키지 명세 (래퍼 2종 선언 추가) |
| 2 | SCM_MGR | `02_DB_SP/02_PKG_DMF0068_BODY.sql` | 패키지 본문 (D1·D2·D7 정정 + 래퍼 2종 + 변환 함수) → VALID 확인 |
| 2-1 | SCM_MGR | `02_DB_SP/03_GRANT.sql` | 어플 계정에 EXECUTE 부여 (존재 계정 자동 판별) |
| **2-2** | ⛔ **어플 계정**<br>클라우드=**SCMP_APP** | **`02_DB_SP/04_APP_SYNONYM_ONLY.sql`** | **SYNONYM 생성 — 누락 시 조회 -9994 / PLS-00201** |
| 3 | SCM_MGR | `03_META/01_MSG.sql` | 신규 메시지 4종(MSG00699~00702) + 라벨 1종(LBL00783) × 3언어 |
| 4 | SCM_MGR | `03_META/02_API_M.sql` | API 12종 + API 설명 메시지 |
| 5 | SCM_MGR | `03_META/03_BTN_MPG.sql` | 버튼 배선 12건 (시트 3종 전부) |
| 6 | SCM_MGR | `03_META/04_PROC_M.sql` | 프로시저 파라미터 메타 5종 + 실제 시그니처 대조 검증 |
| 7 | SCM_MGR | `03_META/05_BTN_AUTH.sql` | 버튼 권한 (ADMIN·DM ADMIN 12 / DM Viewer 8) |
| 8 | SCM_MGR | `03_META/06_SHEET_COLUMNS_FIX.sql` | 중복 등록된 Result·Plan 컬럼 숨김 |
| 9 | SCM_MGR | `03_META/07_SHEET_COLUMNS_DIVISION.sql` | `DIVISION_ID` 공백(`Typ=1 Len=1: 32`) → `'40'` 정정 — ⚠️ `TRIM(DIVISION_ID) IS NULL` 조건 필수 (NULL 로 가정하면 0행 매칭) |
| 10 | SCM_MGR | `03_META/08_SHEET_COLUMNS_BINDING_TIER.sql` | 바인딩명 대문자화(SP alias 일치) + 헤더 단수 3단→2단 정리 (SMALL/LARGE 정리, 수주기간만 유지) |
| 11 | — | `04_FE/` | 화면 소스 배포 + **`04_FE/_configs/locales.DMF0068_PATCH.json` 의 5키를 locales KO/EN/CN 에 머지**(⚠️ 이것 없으면 검증 메시지 4개·Edit 라벨이 fallback 으로 표시) |
| 12 | SCM_MGR | `03_META/99_ROUTE_PATH.sql` | 메뉴 주소 정정 (`dmf0068` → `demand-manager`) — **FE 배포와 동시에** |
| **12-1** | SCM_MGR | **`03_META/98_MNU_URL_ALIGN.sql`** | ⭐ **MNU_URL NULL-safe 강제 정렬** — `99_ROUTE_PATH` 의 `MNU_URL <> '..'` 조건은 **NULL이면 0행 매칭**(조용한 미적용). 클라우드 Page Not Found 원인 — **반드시 이것을 실행해 VERDICT=OK 확인** |
| **12-2** | SCM_MGR | **`03_META/97_LBL00783_TYPE_FIX.sql`** | LBL00783 `MSG_TP_CD` 'MSG'→'LBL' 정정 (3행). 사내 적용 완료(2026-07-30) |

> 3~10 은 전부 멱등(중복 실행해도 같은 결과). 8·9·10·12 는 기존 행을 고치므로 각 파일 첫머리의 백업 SELECT 를 먼저 남길 것.
> ⚠️ FE 신규 폴더는 `viewRegistry` 의 `import.meta.glob` 이 **dev 서버 기동 시점에만** 스캔한다 → 배포 후 **재기동 필수**.

## 확정 정책

- **권한**: 조회는 메뉴 권한(ADMIN / DM ADMIN / DM Viewer)으로 열고, 편집·저장·삭제·행추가는 편집 권한 기준.
  AS-IS 는 조회에도 편집 권한을 요구했으나 완화한다(그래서 D7 정정이 필요하다).
- **사업부**: Division 40 전용 유지. 조회조건에 사업부를 두지 않는다.
- **메뉴 주소**: `demand-manager` (ROUTE_PATH `demand/demand-waterfall/demand-manager`).
- **메시지**: 사내 원장 774건을 명칭 기준으로 전수 대조해 **9종은 기존 코드를 재사용**하고 4종만 신규 채번.
  AS-IS 번호가 다른 문구로 점유된 4건(MSG00002/00004/00049/00284)은 같은 뜻의 기존 코드로 대체했다.

## FE 배포

`04_FE/demand-manager/` → `nscm-fe/features/demand/src/pages/demand-manager/` 로 폴더째 배치.
`04_FE/_configs/procedures.d.ts.DMF0068_BLOCK.ts` 의 블록을 `nscm-fe/configs/types/procedures.d.ts` 의
`COM0004` 블록 앞에 추가한다.

- 라우트는 **`MNU_URL` 마지막 세그먼트 = 폴더명(`demand-manager`)** 이면 자동 해석된다(신판 viewRegistry).
  ⚠️ `ROUTE_PATH`(3단)는 매칭에 사용되지 않는다 → **`98_MNU_URL_ALIGN.sql` 로 MNU_URL 을 반드시 확정**할 사항.
  구판 viewRegistry(`VIEW_REGISTRY` 정적 맵, MNU_ID 키)면 코드 1줄 등록 필수.
- 로컬 type-check 통과. lint 는 클라우드에서 수행.

## 적용 후 확인

1. 패키지 상태가 유효한지 (`ALL_OBJECTS` STATUS)
2. 프로시저 메타가 실제 시그니처와 일치하는지 (`04_PROC_M.sql` 하단 대조 쿼리 — 0행이어야 함)
3. 조회 실행 결과의 월 컬럼이 **수량**을 반환하는지 (연월 상수가 아니어야 함)
4. 화면 진입 → 조회 → 행추가(2행) → 저장 → 삭제 → 버전 팝업
