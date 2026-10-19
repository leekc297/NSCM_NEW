# DMF0082 — Sales Price 삭제 가드 주차 판정 정정 (대상년월별 주차)

| 항목 | 값 |
|---|---|
| 대상 | `SCM_MGR.PKG_DMF0082` PACKAGE BODY |
| 적용 환경 | 사내 ZIOUI1 **적용 완료** (2026-09-17 14:29:21, STATUS=VALID, 컴파일 에러 0) |
| 적용 전 LAST_DDL | 2026-09-16 18:11:55 (15,948 lines) |
| 변경 라인 | **2행** — L13420(40 분기) · L13469(81 분기) |
| 클라우드 | **미적용** — 본 패키지로 이관 필요 |

## 1. 증상 (사용자 신고 2026-09-17)

> 주차별 단가여부 확인 후 단가 있어야 단가적용 메저 등록 가능, 단가적용 메저가 있을 때는 단가삭제 금지가
> 적용되어 있습니다. … **년월이 다른 동일 주차의 한쪽에 데이터가 존재하는 경우에 데이터가 존재해서
> 삭제가 불가하다는 오류 메세지가 발생**합니다.

## 2. 근본 원인 — ISO 주차는 월경계를 넘는다

`SCM_SYS_CALENDAR_M` 실측 (ISO 202636):

| BASIS_YYYYMMDD | BASIS_YYYYMM | ISO_YYYYWW | PARTIAL_YN | BASIS_START_DATE | BASIS_END_DATE |
|---|---|---|---|---|---|
| 20260831 | **202608** | 202636 | Y | 20260831 | 20260831 |
| 20260901~06 | **202609** | 202636 | Y | 20260901 | 20260906 |

`ISO_YYYYWW` 하나가 **서로 다른 두 년월 버킷**을 덮는다. 화면 주차 버킷 축은
`'W_' || BASIS_YYYYMM || ISO_WEEK` (동 패키지 L119·L3878) 이므로 축이 어긋난다.

### 결함 지점 (수정 전)

```sql
-- L13420 (40 분기, DM_PLN_CFM_MKT_DEMAND_PLAN)
-- L13469 (81 분기, DM_PLN_MKT_FCST)
AND B.ISO_YYYYWW = D.ISO_YYYYWW
```

→ 8/31 의 Sales Price 를 지우려 할 때 9/1~6 의 MKT FCST/RTF 가 같은 ISO 주차로 매칭되어
`'... 정보가 해당 주차에 존재하므로 Sales Price 삭제가 불가합니다.'` 오차단.

## 3. 정정 내용

```sql
-- 수정 후 (L13420 · L13469 동일)
AND B.BASIS_START_DATE = D.BASIS_START_DATE
```

### 이 식을 고른 근거

| 근거 | 내용 |
|---|---|
| 축 동등성 | `BASIS_START_DATE` ↔ (`BASIS_YYYYMM`,`ISO_YYYYWW`) **양방향 1:1** — 실측 2,624 조합 / 위반 0 |
| 월경계 처리 | 월경계 주차는 `BASIS_START_DATE` 가 잘려 적재(20260831 / 20260901) → 곧 "대상년월별 주차" |
| 기존 축과 일치 | 등록 가드(검증 10) L12994 `P.YYYYMMDD = M.BASIS_START_DATE`, Excel 업로드 검증 L5964 동일 |
| 단일 컬럼 | 2컬럼 결합보다 조인 술어가 단순하고 인덱스 친화적 |

## 4. 영향 범위 점검 (전수)

| 점검 | 결과 |
|---|---|
| `'삭제가 불가'` 메시지 전수 | 2건 (L13433 40 / L13482 81) — **둘 다 대상, 둘 다 수정** |
| 검증구간(L>13000) `ISO_YYYYWW` 등호 | 수정 전 2 → **수정 후 0** |
| 등록 가드(검증 10) | `BASIS_START_DATE` 기준 — **이미 정상, 변경 없음** |
| Excel 업로드 검증(L5964) | `BASIS_START_DATE` 기준 — **이미 정상, 변경 없음** |
| 그 외 `ISO_YYYYWW` 사용처 | 버전 라벨(L484~560) · 피벗/집계(L6xxx) · 제로주차 판정(L13356, 이미 `\|\| PARTIAL_WEEK_NAME` 병기) — **판정 축 아님, 미변경** |

> L13356 이 이미 `ISO_YYYYWW \|\| PARTIAL_WEEK_NAME` 로 월경계를 분리하고 있었다 —
> 같은 패키지 안에 "ISO 주차 단독은 모호하다"는 선례가 이미 있었고, #18 만 누락돼 있었다.

## 5. 동작 변화

| 상황 | 수정 전 | 수정 후 |
|---|---|---|
| 같은 년월·같은 주차에 FCST 존재 | 삭제 차단 | 삭제 차단 (**불변**) |
| **다른 년월·같은 ISO 주차**에만 FCST 존재 | 삭제 차단 (오탐) | **삭제 허용** |
| 월경계가 아닌 주차 | 불변 | 불변 (BASIS_START_DATE 1:1 대응) |

월경계 주차(PARTIAL_YN='Y')에서만 거동이 바뀌며, 그 외 주차는 결과가 수학적으로 동일하다.

## 6. 파일

| 파일 | 내용 |
|---|---|
| `01_PKG_DMF0082_BODY.sql` | 적용본 전체 (SOURCE-FRESH 스탬프 + `CREATE OR REPLACE` + 종결자 `/` + newline) |
| `build_and_apply.py` | 빌더 — ALL_SOURCE 재조회 · 기준본 동일성 assert · 적용 직전 LAST_DDL 재확인 (FRESH-GATE, hook #152) |

## 7. 클라우드 이관 절차

1. 클라우드에서 `PKG_DMF0082` BODY 의 L13420 / L13469 가 `AND B.ISO_YYYYWW = D.ISO_YYYYWW` 인지 먼저 확인
2. 같으면 `build_and_apply.py` 를 클라우드 접속으로 재실행(FRESH-GATE 가 클라우드 원문 기준으로 재빌드)
   — **사내 산출 `01_*.sql` 을 그대로 덮어쓰지 말 것** (클라우드 판본이 다를 수 있음)
3. 적용 후 `STATUS=VALID` · `ALL_ERRORS` 0 · 두 라인 재조회 확인

## 8. 잔여 확인 요청 (사용자)

- 신고하신 실제 케이스(년월/주차/Sales Site/Model)로 삭제가 정상 동작하는지 화면 재현 확인
- 등록 가드(단가 없으면 메저 등록 불가)는 이미 년월별 주차 축이라 변경하지 않았습니다 — 등록 쪽에서도
  같은 증상이 있으셨다면 알려주시면 재점검하겠습니다


---

# ⭐ 2차 보완 (2026-09-17 14:47) — 같은 저장에서 메저+단가 동시 삭제 허용

1차 적용 후에도 UI 에서 동일 메시지가 재현되어 로그로 실제 케이스를 특정했다.

## A. 실측 근거 — `SCM_SYS_LOG_BATCH`

| 시각 | 결과 | 비고 |
|---|---|---|
| 14:13:37 / 14:29:40 / 14:30:41 / 14:38:51 | 삭제 불가 메시지 | 14:29:21(1차 적용) **이후에도** 재현 |
| 14:39:52 | SUCCESS | 사용자가 2단계(메저 먼저 삭제·저장 → 단가 삭제)로 성공 |

입력 파라미터 실측(`IN_PARA_DATA`):

```
rows=2  p_active_flag="M^M"  p_division_id="40^40"  p_project_code="NT^NT"
p_scm_site_id="Luxshare Precision_VN_BGG^..."  p_item_id="MCSS22531-B2^..."
p_measure="MKT_FCST^LOC"   p_yyyymmdd="20260928^20260928"   p_qty="0^0"
```

→ **한 번의 저장에 단가필요 메저(MKT_FCST)=0 과 단가(LOC)=0 이 함께** 들어온다.

## B. 원인 — 가드가 '이번 저장분'을 차감하지 않는다

#18 은 원장(`DM_PLN_CFM_MKT_DEMAND_PLAN`)만 조회한다. 같은 저장이 지우는 중인 FCST 행은
검증 시점에 아직 원장에 옛 값으로 남아 있어 '존재'로 판정된다.
등록 가드 #10 은 이미 *"UI 입력값이든 DB 값이든"* 합집합을 보도록 되어 있어 **축이 비대칭**이었다.

## C. 정정 — 원장 행에서 '이번 저장이 0 으로 지우는 행' 차감

두 분기(40 L13428~13446 / 81 L13496~13513)의 `FETCH FIRST 1 ROWS ONLY` 직전에 삽입:

```sql
AND NOT EXISTS (
      SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN Z
       WHERE Z.DIVISION_ID = F.DIVISION_ID  AND Z.PROJECT_CODE = F.PROJECT_CODE
         AND Z.SCM_SITE_ID = F.SCM_SITE_ID  AND Z.PLANT_SITE_ID = F.PLANT_SITE_ID
         AND Z.ITEM_ID     = F.ITEM_ID      AND Z.DOM_EXP       = F.DOM_EXP
         AND Z.FCST_TYPE   = F.FCST_TYPE    AND Z.INCOTERMS     = F.INCOTERMS
         AND Z.MEASURE     = F.MEASURE      AND Z.YYYYMMDD      = F.YYYYMMDD
         AND Z.CELL_PROD_SITE_ID = F.CELL_PROD_SITE_ID   -- 40 분기만(81 은 키 8종)
         AND NVL(Z.QTY_PRICE, 0) = 0)
```

**행 단위(같은 일자·같은 메저) 매칭**이라 사용자 제약이 그대로 보존된다 —
*"삭제하지 않은 단가필요 메저에 값이 존재하면 삭제 불가(동일 년월/주차 기준)"*.
이번 저장이 건드리지 않은 원장 행은 차감되지 않아 그대로 차단 사유로 남는다.

## D. 기능 검증 — `verify_guard.py` (적용 판정식 실행)

전제: 원장 `MKT_FCST @20261004 QTY=777` 1건 (ISO 202640 의 **202610** 조각)

| 케이스 | 기대 | 실측 |
|---|---|---|
| A 같은 저장에 메저+단가 동시 삭제 | 통과 | **차단=0 PASS** |
| B 단가만 삭제(메저 값 잔존) | 차단 | **차단=1 PASS** |
| C 다른 년월 조각의 단가 삭제(20260928), 메저는 202610 | 통과 | **차단=0 PASS** |

케이스 C 가 1차 패치(주차 축)의 실효성을 함께 입증한다 —
`20260928`(월, `BASIS_END_DATE=20260930`)과 `20261004` 는 **같은 ISO 202640 이지만 다른 년월 조각**이다.

## E. 1차·2차 관계

| | 1차 (14:29) | 2차 (14:47) |
|---|---|---|
| 대상 | 주차 판정 축 | 같은 저장 삭제분 차감 |
| 변경 | `ISO_YYYYWW` → `BASIS_START_DATE` (2행) | `NOT EXISTS` 블록 삽입 (2곳 37행) |
| 해결 증상 | 년월 다른 동일 ISO 주차 오차단 | 메저+단가 1회 저장 시 오차단 |

**두 결함은 독립**이며 둘 다 실측으로 재현·검증했다.

## F. 적용 상태 / 파일 (갱신)

| 항목 | 값 |
|---|---|
| 사내 ZIOUI1 | **적용 완료** 2026-09-17 14:47:33 · STATUS=VALID · 컴파일 에러 0 |
| 검증 | `ISO_YYYYWW` 등호 잔존 **0** · `BASIS_START_DATE` 2곳 · `SAMESAVEDEL` 블록 2곳 |
| 클라우드 | **미적용** |

| 파일 | 내용 |
|---|---|
| `01_PKG_DMF0082_BODY.sql` | 1차 적용본 |
| `02_PKG_DMF0082_BODY_SAMESAVEDEL.sql` | **2차 적용본(최종, 15,985 lines)** — 클라우드 이관은 이 계보 |
| `patch2_same_save_delete.py` | 2차 빌더 (FRESH-GATE + 앵커 기반 삽입) |
| `verify_guard.py` | 3 케이스 기능 검증 |
