# DMF0082 — SCM_FCST 메저 81 DIVISION 개방 (메타 전용)

- **마커**: `E20260902-81SCMFCST`
- **요구**: "DMF0082 에서 SCM_FCST 메저도 81 DIVISION 에서 사용가능 하도록" (사용자 2026-09-02)
- **성격**: AS-IS 에 없는 **TO-BE 신규 기능** (사용자 확정) → AS-IS 파리티 요건 없음
- **변경 범위**: 메타 3축만. **SP·FE 변경 없음**

---

## 1. 적용 순서 (순서 지킬 것)

| # | 파일 | 대상 | 행수 | 사내 | 클라우드 |
|---|---|---|---:|---|---|
| 0 | `00_SCM_MST_SHEET_MEASURE_SCM_FCST_81.sql` | `SCM_MST_SHEET_MEASURE` | 1행 UPDATE | **적용완료** (2026-09-02 17:46 / `minyonglee1`) | 필요 |
| 1 | `01_GET_ADMIN_GROUP_MEASURE_SCM_FCST_81.sql` | `SCM_ADM_LOOKUP_MASTER_DETAIL` | 18행 | 미적용 | 필요 |
| 2 | `02_DM_UI_EDITABLE_MEASURE_SCM_FCST_81.sql` | `SCM_ADM_LOOKUP_MASTER_DETAIL` | 6행 | 미적용 | 필요 |
| 3 | `03_PKG_DMF0082_SAVE_81_SCM_FCST.sql` | `PKG_DMF0082` (PACKAGE BODY) | 6줄 변경 | 미적용 | 필요 |

0~2 는 **멱등**(PK 기준 MERGE / 값 확정 UPDATE)이라 재실행 안전. 각 파일에 검증 SELECT 와 원복문 포함.
3 은 라이브 PKG 전체본 `CREATE OR REPLACE` 다.

---

## 1-1. `03_` SP 패치 — 81 저장 경로 개방

**배경**: 메타 3축(0~2)은 "메저가 뜨고 셀이 열리는" 것까지만 한다. 저장은 SP 가 막고 있었다.
`v_is_81='Y'` 분기의 대상 메저 목록에 `SCM_FCST` 가 없어 **편집해도 저장되지 않고, 저장이 안 되니 조회할 데이터도 생기지 않는** 구조였다.

생성 방식: 라이브 `ALL_SOURCE`(15,107줄)를 받아 **라인 앵커로 6줄만 치환**하고 전체본을 재작성했다.
앵커는 각 라인에서 정확히 1회 출현함을 검증했고(0회/2회면 생성 중단), 변경 라인 전부에 `--[E20260902-81SCMFCST]` 마커를 남겼다.

**범위 (사용자 지시 2026-09-02)**: "UI 에서 81 DIVISION 의 SCM_FCST 값 수정 시 저장되도록" **저장 경로만**.
배치(SCM_FCST 시딩)는 별도 진행. 권한은 사용자가 별도 관리.

| # | LINE | 위치 | 변경 |
|---|---:|---|---|
| 1 | 14211 | `DELETE FROM DM_PLN_MKT_FCST` 대상 메저 | `+ 'SCM_FCST'` |
| 2 | 14216 | 위 DELETE 의 `EXISTS` 조건 | `+ 'SCM_FCST'` |
| 3 | 14237 | `MERGE INTO DM_PLN_MKT_FCST` USING 필터 | `+ 'SCM_FCST'` |
| 4 | 14529 | 이력 `INSERT INTO DM_PLN_MKT_FCST_H` | `+ 'SCM_FCST'` |

40 대응 라인(L14110·L14175·L14513)에는 이미 `'SCM_FCST'` 가 들어 있다 — 본 패치는 81 을 40 과 같은 상태로 맞추는 것이다.

**저장 경로가 성립하는 근거 (실측)**
- FE 페이로드 적재(L11982)는 **메저 무필터** — `v_measure` 를 그대로 넣으므로 81 SCM_FCST 편집분도 `GT_PRDM1_T_MAIN` 까지 이미 도달하고 있었다. 위 4곳이 DML 단계에서 걸러낸 것이 전부.
- SAVE 측 시간창 검증(L12117~12148)은 `B.ATTRIBUTE4 IS NOT NULL` 인 룩업 행만 대상 = **LIMIT_MEASURE 로 지정된 메저를 그 창에 수정 금지**하는 반대 방향 게이트다. 신규 행은 `A4=NULL` 이라 대상이 아니다.
  (40 처럼 `A4='MKT_FCST'` 를 넣었다면 화요일 창에 81 MKT_FCST 수정이 차단됐을 것 — 01_ 의 A4=NULL 결정이 여기서도 맞았다.)

**QTY=0 취급 차이(설계 그대로 유지)**: 40 MERGE 는 `QTY_PRICE <> 0` 조건이 있고(L14176) 81 은 없다 — 81 은 QTY=0 행을 물리 저장하는 설계다(L14204 주석). 본 패치는 이 차이를 건드리지 않았다. 즉 81 에서 SCM_FCST 를 0 으로 고치면 0 행이 물리 저장된다(81 의 기존 MKT_FCST 와 동일 거동).

**INSERT 도 열린다**: 81 MERGE 는 `WHEN NOT MATCHED THEN INSERT`(L14256~14266)를 갖는다. 현재 81 SCM_FCST 원천이 0행이므로 사용자 입력은 전부 INSERT 로 들어간다. 40 도 동일하게 INSERT 를 허용한다(L14175 목록 + L14195).
> ⚠ L14165 주석 "SCM_FCST 는 수정만 된다. (INSERT 불가능)" 은 **실제 코드와 어긋난 낡은 주석**이다. 코드가 기준.

**범위에서 제외한 것 (별건, 미적용)**: L13309·L13350 단가삭제 검증. 40 은 잔존 FCST 확인 대상에 `SCM_FCST` 를 포함하지만(L13212·L13259) 81 은 제외되어 있다. 저장과 무관하고, 넣으면 **SCM_FCST 가 남아 있을 때 Sales Price 삭제가 막히는** 동작 변경이 되므로 지시 범위 밖으로 두었다.

**참고 — 원문 주석과 실제 코드 불일치**: L14165 는 "SCM_FCST 는 수정만 된다. (INSERT 불가능)" 이라 적혀 있으나, 실제 40 MERGE(L14175 목록 + L14195 `WHEN NOT MATCHED THEN INSERT`)는 SCM_FCST 를 INSERT 한다. 주석이 낡은 것이며 코드가 기준이다.

### 배포 방법

```
sqlplus / SQLcl 에서 03_PKG_DMF0082_SAVE_81_SCM_FCST.sql 실행 (CREATE OR REPLACE PACKAGE BODY 전체본)
후 반드시 컴파일 상태 확인:
  SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
    FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082';
  SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
   WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' ORDER BY LINE;
```

⚠ 라이브 PKG 교체이므로 **BE 기동 중이면 DDL 락**이 걸린다. 필요 시 BE 종료 후 적용.
⚠ 배포 후 마커 확인: `SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TEXT LIKE '%E20260902-81SCMFCST%';` → **6** 이어야 한다.

---

## 1-2. ⚠ 아직 남은 축 — SCM_FCST 시딩 배치 (별건, 미착수)

`03_` 까지 적용하면 **사용자가 직접 입력한 SCM_FCST 는 저장·조회된다.** 그러나 요구하신
"SCM_FCST 가 SCP 확정 물량을 담는" 구조는 아직 완성되지 않는다.

40 에서 SCM_FCST 를 최초 생성하는 주체는 사용자가 아니라 배치다:

```
PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING  L236
  IF ( V_DIVISION_ID = '40' AND P_VER_TYPE = 'MF_W' ) THEN     ← ⛔ 40 하드코딩
      DELETE FROM DM_PLN_MKT_FCST            ... MEASURE='SCM_FCST';
      INSERT INTO DM_PLN_MKT_FCST            ... 'SCM_FCST' ← MKT_FCST 복사   (L247~281)
      DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN ... MEASURE='SCM_FCST';
      INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN ... 'SCM_FCST' ← MKT_FCST 복사   (L283~327)
  END IF;
```

주석 L233~234: *"화.00시(MKT_FCST) 일 때는 SCM_FCST Delete ==> Insert 처리 / 화.14시(SCM_FCST) 일 때는 SCM_FCST CUTOFF 처리"*.
즉 **화요일 MF_W 컷오프에 MKT_FCST 스냅샷을 SCM_FCST 로 시딩**하고, 그 뒤 플래너가 창 안에서 수정, SF_W 컷오프로 확정하는 흐름이다.

81 배치 잡은 **이미 존재한다** (`JOB.PR_DM_PLN_MKT_FCST_WEEKLY_ROLLING_TUE_81` — `PR_DM_CHECK_JOB_ERROR_SMS_SEND` L21~22 실측). 잡은 도는데 위 블록만 `'40'` 으로 막혀 있다.

⇒ 이 조건을 81 계열까지 여는 변경이 별도로 필요하다. 적용 범위(81 만 / 81+82)와 `FN_NEXT_DAY` 기준 주차 산식이 81 에도 동일한지 확인이 필요해 **본 패키지에 포함하지 않았다.**

---

## 2. 왜 축이 3개인가 — 기계 전수 스윕 결과

`SCM_ADM_LOOKUP_MASTER_DETAIL` 에서 `DMF0082` 를 참조하는 `LOOKUP_TYPE` 을 전수 조회한 결과 3종:

| LOOKUP_TYPE | 역할 | SCM_FCST 개방에 필요? |
|---|---|---|
| — (`SCM_MST_SHEET_MEASURE`) | 메저가 목록에 **뜨는가** | ✅ 필요 (00_) |
| `GET_ADMIN_GROUP_MEASURE` | **어느 권한그룹이 언제**(요일·시간창) 편집 가능한가 | ✅ 필요 (01_) |
| `DM_UI_EDITABLE_MEASURE` | 그 메저 셀이 애초에 **편집 대상인가**(EDIT_YN) | ✅ 필요 (02_) |
| `MENU_AUTH_BY_DIVISION` | division/부서 메뉴 권한 (메저 무관, 40 1행뿐) | ❌ 불필요 |

> 손으로 나열했다면 `DM_UI_EDITABLE_MEASURE` 축을 놓쳤을 것이다. 실제로 최초 판단에서는 2축으로 봤고, 스윕에서 3번째 축이 드러났다.

---

## 3. 결정 사항과 근거

### 3-1. 권한그룹 = 40 패턴 3그룹 (사용자 확정)

`ADMIN` / `SCM PI Admin` / `SCP Planner` — div40 의 SCM_FCST 구성과 동일. (`DM ADMIN`·`DM Planner` 는 40 에서도 SCM_FCST 없음)

### 3-2. 요일·시간창 = 81 SCP Planner 창 준용 (사용자 확정)

`ATTRIBUTE1='TUE'` 고정, 시각은 **division 마다 다르다**:

| DIV | FROM~TO | DIV | FROM~TO |
|---|---|---|---|
| 81 | 0411~1100 | 81_HD | 1006~1150 |
| 81_UC | 1001~1145 | 81_HM | 0401~1130 |
| 81_ST | 0406~1135 | 81_HG | 1010~1140 |

기존 `SCP Planner / MKT_FCST` 행의 창을 그대로 미러링한 값이다.

### 3-3. ⭐ `GET_ADMIN_GROUP_MEASURE.ATTRIBUTE4` = **NULL** (회귀 방지)

`ATTRIBUTE4` 는 의미가 **둘 공존**한다 (PKG_DMF0082 L3644~3650):

| 해석 | 발동 조건 | 효과 | 실데이터 |
|---|---|---|---|
| (a) 메저명 | L3629~3640 | 그 이름의 메저를 강제 `'N'` | `DMF0082/SCM_FCST/A4='MKT_FCST'` (div40 3행) |
| (b) 그룹명 | L3651~3672 | 그 그룹 창이 열린 동안 내 메저를 `'N'` | `DMF0082/MKT_FCST/A4='SCP Planner'` (81 계열 18행) |

div40 의 `A4='MKT_FCST'` 를 그대로 복제했다면 **(a)** 가 발동해 **화요일 창 시간대에 81 의 MKT_FCST 편집이 잠기는 회귀**가 났다. 81 기존 행이 전부 `A4 IS NULL` 인 것과도 일치하므로 NULL 로 둔다.

### 3-4. `DM_UI_EDITABLE_MEASURE` = **div40 행 전 컬럼 복제** (사용자 지시)

"다른 조건은 40 을 복사해서 동일하게" — 리터럴을 쓰지 않고 **div40 행 자체를 `SELECT` 해서 `SEGMENT2`(DIVISION)만 치환**한다. `ATTRIBUTE1~15` 전량이 자동 일치하며, 40 이 바뀌면 재실행만으로 따라간다.

| 컬럼 | 값 | 의미 (실측 근거) |
|---|---|---|
| `ATTRIBUTE1` | `'N'` | INSERT_YN — Insert/엑셀양식 후보 아님 (L14853·L5415) |
| `ATTRIBUTE2` | `'Y'` | **EDIT_YN — 본 개방의 실체** (L9001) |
| `ATTRIBUTE3` | `'ALL'` | VMI_COND (L14843·L5419) |
| `SEGMENT4` | `'SCM_FCST'` | 표시명 자리 (L14687). 40 은 라벨 대신 코드가 들어가 있으나 "40 복사" 지시대로 유지 |
| `DISPLAY_SEQ` | `402` | 81 의 LOC 와 번호 중복이나 SP 미소비(L14844 는 `ROW_NUMBER()`)라 무해 |

---

## 4. 회귀 영향 분석 (신규 행이 건드리는 곳 0)

PKG_DMF0082 편집게이트 전 분기를 원문 실측:

| 위치 | 분기 | 판정 |
|---|---|---|
| L3576~3603 | LOC 강제개방 | `MEASURE='LOC'` 한정 → 무관 |
| L3605~3611 | AS_In_Req | 해당 메저 한정 → 무관 |
| L3613~3627 | VMI_In_Req | 해당 메저 한정 → 무관 |
| L3629~3640 | (a) 메저명 잠금 | 신규 `A4=NULL` → 미발동 |
| L3651~3672 | (b) 그룹명 잠금 | `L2.SEGMENT4 = MKT_FCST` 로 조회 → `SCM_FCST` 행은 대상 아님 |
| L12093~12115 | `SELECT INTO` (시간창 변수) | `A4 IS NOT NULL` 필터 → 신규 행 제외 |

**SP 변경 불필요**: `SCM_FCST` LIVE 리터럴 35건 전수 확인 결과 전부 메저코드 기반이며 division 분기가 없다 (L3000·L3021·L3341·L7968·L9077·L12297·L12856·L12912·L13075·L13212·L14110·L14175·L14364·L14513 …). 메저 강제포함(L1136~1146)·FCST_GAP 파생(L7686~7697)도 `SCM_MST_SHEET_MEASURE` 구동이라 division 필터가 없다.

> 참고(신규 아님): L3551~3555 는 `SEGMENT3` 필터 없이 `GROUP BY SEGMENT4, ATTRIBUTE1` 이라 `SCM_FCST` 가 `MON`(40)+`TUE`(81) 두 행으로 O_RC4 에 실린다. `MKT_FCST` 가 이미 `NULL`/`TUE` 2행으로 동일하게 동작 중이다.

---

## 5. 적용 후 확인 (3축 커버리지)

`02_` 파일의 **검증 ③** 을 실행. 6 division 전부 아래여야 한다:

```
DIV     메저마스터  권한룩업  편집룩업
81      Y           3         1
81_UC   Y           3         1
81_ST   Y           3         1
81_HD   Y           3         1
81_HM   Y           3         1
81_HG   Y           3         1
```

이후 **화면 실측**: 81 division 조회 → 메저 모달에 `SCM FCST[R+P]` 노출 → **화요일 해당 시간창 안**에서 셀 편집 가능. 창 밖이면 잠기고 `MSG00477` 이 표기된다(정상 동작).

---

## 6. 범위 밖 — 별건으로 발견한 기존 불일치

`DM_UI_EDITABLE_MEASURE` 의 81 계열 커버리지가 메저별로 고르지 않다 (본 작업 이전부터):

| 메저 | 81 | 81_UC | 81_ST | 81_HD | 81_HM | 81_HG |
|---|---|---|---|---|---|---|
| `MKT_FCST` / `LOC` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `AS_In_Req` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `VMI_In_Req` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

메저 마스터에는 `AS_In_Req` 가 81 계열 6종 전부 등록되어 있으므로, `81_ST`/`81_HD`/`81_HM`/`81_HG` 에서는 메저는 뜨는데 편집이 안 될 수 있다. **본 요구 범위 밖이라 손대지 않았다** — 확인·보완 여부는 지시 필요.

---

## 7. 검증 이력

사내 Oracle(`OCGSCMD_P01`)에서 전 구문 검증 완료 (2026-09-02).
DML 은 `DBMS_SQL.PARSE` 로 **무실행 구문·객체·컬럼 검증**, SELECT 는 실제 실행 — **데이터 변경 없음**.

| 파일 | 결과 |
|---|---|
| `00_` | OK=4 FAIL=0 |
| `01_` | OK=7 FAIL=0 |
| `02_` | OK=6 FAIL=0 |
