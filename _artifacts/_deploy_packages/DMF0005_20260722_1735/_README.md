# DMF0005 조회 성능 개선 이관 패키지 (2026-07-22)

## 배경 (원인 — 실측 확정)

DMF0005(Sales Site Project Model) '81' DIVISION 조회가 **300초+ 타임아웃** (사내 실측, V$SQL 49.7M buffer gets).

| # | 원인 | 근거 |
|---|---|---|
| 1 | **`FN_GET_MULTI_OWNER_NAME` 행별 호출 폭발** — BASE 52,526행마다 호출, 호출당 `SCM_MST_SSO_USER_INFO`(128,610행)를 `UPPER(USER_ID)=UPPER(...)` 비-SARGable 풀스캔 | ASH 300샘플 중 298 |
| 2 | 인라인 `FN_SPLITSTRING` 컬렉션 필터 (행별 pickler 재평가) | 실행계획 COLLECTION ITERATOR ×7 |
| 3 | `DM_MST_ITEM_SINGLE_V` 조인 — 뷰 내부 prefix self-join(옵티마이저 230M행 추정), BASE 사용 5컬럼은 SP 내 ITEM_AGG 와 등가 | 실행계획 Id 32~38 / ASH |

## 변경 내용

| 파일 | 내용 |
|---|---|
| `00_GTT_DDL_DMF0005.sql` | **GT_GGET_SPLIT_* 7종** 멱등 생성 (TEAM_ID/CUSTOMER/SCM_SITE_ID/VALID_YN/ITEM_ID/PROJECT_CODE/OWNER — TOK VARCHAR2(1600), PRESERVE ROWS). 클라우드 기존재 가정 금지 원칙으로 전부 동봉 |
| `01_INDEX_FBI_SSO_USER_INFO.sql` | `IDX02_SCM_MST_SSO_USER_INFO ON (UPPER(USER_ID))` FBI 멱등 생성 — 이것만으로 300s+ → 4.9s |
| `02_PKG_DMF0005_body.sql` | PKG_DMF0005 body (마커 `[PERF-DMF0005 20260722]` 12행, P1~P6) |
| `03_VERIFY.sql` | 배포 후 검증 (VALID/errors/마커/GTT/FBI/smoke) |
| `99_ROLLBACK_PKG_DMF0005_body_original.sql` | 원본 body 복원용 |
| `_backup/` | 원본 body 사본 |

### SP 패치 6점 (원본 앵커 exact-match 프로그램 패치 — `_artifacts/DMF0005_20260722_1710/02_make_tuned_body.py`)

- **P1**: 필터 7종 GTT 사전 적재 — 값 있을 때만 INSERT, 없음/'ALL' 이면 미적재
- **P2**: `OWNER_NM` CTE — OWNER_NAME 을 행별(52,526회) 함수 호출 대신 **DISTINCT OWNER(367건)만 1회씩** 호출
- **P3/P4**: BASE 행별 `FN_GET_MULTI_OWNER_NAME` → `OWNER_NM` LEFT JOIN
- **P5**: 인라인 `FN_SPLITSTRING` IN/EXISTS → `(파라미터 없음/'ALL' OR EXISTS(GT_GGET_SPLIT_*))` — 조건 없으면 실행계획 FILTER 단락으로 GTT 미접근 (PKG_DMF0003 선례 동일 패턴)
- **P6**: `DM_MST_ITEM_SINGLE_V` 조인 제거 — ITEM_AGG 등가 대체 (ACTIVE_FLAG 집계 추가)

### 의도된 동작 정합 (보고)

구판은 필터 파라미터가 **NULL** 이면 `IN (split(NULL))` = 0행 전멸(empty-filter wipe 결함 계보, DMF0042 P0c 동일 유형).
신판은 사용자 확정 룰대로 **없음(NULL)/'ALL' = 필터 미적용(전체 통과)**. FE 는 항상 'ALL'/값을 보내므로 화면 동작 변화 없음.

## 적용 순서 (의존 순서 — 반드시 이 순서)

```
Step 1: 00_GTT_DDL_DMF0005.sql        (GTT 7종 — SP 컴파일 선행 조건)
Step 2: 01_INDEX_FBI_SSO_USER_INFO.sql
Step 3: 02_PKG_DMF0005_body.sql
Step 4: 03_VERIFY.sql                  (VALID / errors 0 / 마커 12 / GTT 7 / FBI VALID)
```

전제(기존재 필요, 미동봉): `FN_SPLITSTRING`, `FN_GET_MULTI_OWNER_NAME`, `FN_GET_DEPT_LIST`, 참조 마스터 테이블 일체.
확인: `SELECT object_name, status FROM user_objects WHERE object_name IN ('FN_SPLITSTRING','FN_GET_MULTI_OWNER_NAME','FN_GET_DEPT_LIST');`

## 검증 결과 (사내 OCGSCMD_P01, 2026-07-22 적용 완료)

- 회귀: 10개 시나리오(81/40/82 기본 + 81 필터 7분기) **행수·SHA-256 전부 원본과 일치** (P1~P5 후 1회 + P6 후 1회, 2중 확인)
- 성능 ('81' 기본, python thin client — 38,183행 fetch 포함):

| 단계 | 시간 |
|---|---|
| 원본 | **300s+ 타임아웃** (V$SQL 49.7M gets) |
| FBI 만 | 4.87s |
| + SP P1~P5 | 3.79~3.98s |
| + P6 (최종) | **3.62s** (SP 실행 ~1.9s + 38K행 전송 ~1.7s) / 필터 시나리오 0.3~0.4s |

> 잔여 개선 여지 (필수 아님 — 사용자 결정으로 중단): 결과 38K행 wide-row 전송 자체가 ~1.7s.
