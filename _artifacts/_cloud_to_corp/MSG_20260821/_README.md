# MSG 테이블 클라우드 → 사내 MERGE 스크립트 생성기 (2026-08-21)

대상 테이블 : `SCM_MGR.SCM_ADM_MSG_M` (메시지/라벨 다국어 원장)

| 파일 | 실행 위치 | 성격 |
|---|---|---|
| **`_PROCEDURE.md`** | — | ⭐ **절차 정본** — 명칭 충돌 적출 → 사용 UI 역추적 → 로컬 소스 보완 (P0~P5) |
| `01_GEN_MSG_MERGE.sql` | **클라우드** | SELECT 전용 — MERGE 스크립트를 *생성* (`P_EXCLUDE_MSG_IDS` 로 선별 적용) |
| `10_EXPORT_MSG_SNAPSHOT.sql` | **클라우드**(+사내) | SELECT 전용 — 이스케이프 TSV 스냅샷 덤프 |
| `msg_sync.py` | 로컬 | 차이 분류 + 사용처 역추적 + 판정표(xlsx) 생성 |
| `_selftest_make_fixture.py` | 로컬 | 검증 전용 합성 스냅샷 생성기 (실 데이터 아님) |
| `90_VERIFY_CORP.sql` | **사내 + 클라우드** | 적용 후 실측 대조 (SELECT 전용) |
| `out_corponly/` | — | P0 기준선 실행 결과 (2026-08-21) |

> **이관 전에 `_PROCEDURE.md` 를 먼저 읽을 것.** MERGE 는 사내 명칭을 경고 없이 덮어쓴다.

---

## 1. 사용 절차

```
[1] 클라우드에서 01_GEN_MSG_MERGE.sql 실행
      └ 필요 시 상단 PRM 의 3개 값만 수정 (NULL = 전체)
[2] 결과(LINE 컬럼) 전량 복사 → 예: MSG_MERGE_20260821.sql 로 저장
      └ DBeaver: 결과 그리드 전체 선택 → Advanced Copy → 값만(헤더 제외)
      └ SQL*Plus: SET PAGESIZE 0 LINESIZE 32767 TRIMSPOOL ON FEEDBACK OFF + SPOOL
[3] 사내 Oracle(SCM_MGR)에서 저장한 스크립트 실행
[4] 사내·클라우드 양쪽에서 90_VERIFY_CORP.sql 실행 → 수치 대조
```

`PRM` 필터 3종 (01 / 90 에서 **반드시 동일 값** 사용):

| 파라미터 | 예시 | 의미 |
|---|---|---|
| `P_MSG_ID_LIKE` | `'MSG01%'` / `'LBL%'` | MSG_ID 패턴 (NULL = 전체) |
| `P_LANG_CD` | `'KO'` | 언어 (NULL = 전 언어) |
| `P_CHANGED_SINCE` | `DATE '2026-08-01'` | 이 일자 이후 변경분만 (NULL = 전체) |

---

## 2. 설계 근거 (실측)

### 2.1 대상 테이블 실측 — 사내 `100.65.143.121:1521/OCGSCMD_P01`

| # | 컬럼 | 타입 | NULL |
|--:|---|---|---|
| 1 | MSG_ID | VARCHAR2(50) | N |
| 2 | LANG_CD | VARCHAR2(10) | N |
| 3 | MSG_NM | VARCHAR2(400) | Y |
| 4 | MSG_DESC | VARCHAR2(1000) | Y |
| 5 | MSG_TP_CD | VARCHAR2(20) | N |
| 6 | USE_YN | VARCHAR2(1) | N |
| 7 | CREATED_BY | VARCHAR2(120) | N |
| 8 | CREATION_DATE | DATE | N |
| 9 | LAST_UPDATED_BY | VARCHAR2(120) | N |
| 10 | LAST_UPDATE_DATE | DATE | N |

- **PK = `PK_TB_FX_MESSAGE_M (MSG_ID, LANG_CD)`** → MERGE `ON` 키로 그대로 사용 (추정 아님, `ALL_CONS_COLUMNS` 실측).
- 클라우드 미러 DDL(`_artifacts/cloud-to-local-mirror/clean/04_tables_05.sql:2884`)과 컬럼 구성 동일.
- 현재 사내 보유 : 2,634행 / 3언어(KO·EN·CN).

### 2.2 이스케이프 — 사내 데이터에 **실제로 존재**하는 것만 근거로 반영

| 케이스 | 실측 건수 | 처리 |
|---|---:|---|
| 작은따옴표 `'` | 6 | `''` 치환 |
| 개행 `CHR(10)` | 3 | `' \|\| CHR(10) \|\| '` 로 분해 |
| `CHR(13)` | 0 | (방어적으로 동일 처리) |
| `&` (SQL*Plus 치환변수) | 18 | 생성물 머리에 `SET DEFINE OFF` |
| `MSG_NM` NULL | 1 | `CAST(NULL AS VARCHAR2(400))` |
| `MSG_DESC` NULL | 2,012 | `CAST(NULL AS VARCHAR2(1000))` |
| DATE 2컬럼 | 전건 | `TO_DATE(..,'YYYY-MM-DD HH24:MI:SS')` 명시 마스크 (NLS 비의존) |

### 2.3 생성물 형태 — **1행 = MERGE 1문**

단일 거대 MERGE 가 아니라 행 단위 독립 문으로 생성한다.
→ 한 행이 실패해도 나머지가 살고, 실패 지점을 즉시 특정할 수 있으며, 재실행이 멱등이다.

---

## 3. 검증 실적 (2026-08-21, 사내 DB 대상 SELECT 전용)

생성기 자체를 사내 동일 구조 테이블에 걸어 다음을 실측했다.

| 검증 | 방법 | 결과 |
|---|---|---|
| 구문 유효성 | 생성된 MERGE 를 `EXPLAIN PLAN`(파싱 전용, 데이터 무변경)에 투입 | 따옴표 행·개행 행 **모두 파싱 성공** |
| 값 라운드트립 | 생성된 `USING` 리터럴 ↔ 원본 행을 NULL-safe 전컬럼 비교 | **12/12 OK / FAIL 0** |
| 출력 정합 | 12행 × 9라인 + 헤더 12 + 푸터 2 = **122라인** | 실제 122행 |
| 90 검증쿼리 | §1 총계·해시 / §3 키목록 실행 | CNT=2,634 / HASHSUM=5663215126204 / 키목록 2,634행 |

라운드트립 대상에는 따옴표 보유(`MSG00400`), 개행 보유(`MSG00710`), `MSG_NM` NULL(`LBL00097`), `MSG_DESC` NULL 행이 모두 포함된다.

---

## 4. 의미와 한계 (반드시 인지)

1. **UPSERT 전용이다.** 사내에만 존재하는 행은 삭제하지 않는다. 클라우드를 정본으로 삼아 사내를 완전 동기화하려면 `90_VERIFY_CORP.sql §3` 의 키+해시 목록을 양쪽에서 뽑아 diff 한 뒤, **사내 단독 보유 행의 삭제 여부는 사용자가 판단**해야 한다. (자동 DELETE 는 넣지 않았다)
2. **감사컬럼은 원본 값을 그대로 옮긴다.** `CREATED_BY / CREATION_DATE / LAST_UPDATED_BY / LAST_UPDATE_DATE` 를 클라우드 값으로 보존한다(복제이므로). 사내 신규 메타 작성 규칙(감사컬럼 `admin`)은 이 복제 경로에는 적용하지 않는다 — 적용을 원하면 생성기의 `QCBY/QUBY` 를 `'admin'` 리터럴로 바꾼다.
3. **`WHEN MATCHED` 는 `CREATED_BY / CREATION_DATE` 를 갱신하지 않는다.** 최초 생성 정보는 사내 값을 유지하는 것이 정상이다.
4. **§1 CNT/HASHSUM 불일치가 곧 실패는 아니다.** 사내 단독 보유 행이 있으면 정상 적용 후에도 어긋난다. 반드시 `§3` diff 로 원인을 가른 뒤 판정할 것.
5. 런타임 i18n 의 실제 원천은 `locales/*.json` 이므로, MSG/LBL 신규분을 옮긴 뒤에는 FE locales 동기화 여부를 별도로 확인해야 한다.
