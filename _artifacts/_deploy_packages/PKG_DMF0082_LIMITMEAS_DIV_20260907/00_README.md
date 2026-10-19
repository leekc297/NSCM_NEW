# PKG_DMF0082_LIMITMEAS_DIV_20260907 — SCM_FCST 편집시간창 중 LIMIT_MEASURE(MKT_FCST) 잠금 정정

## 신고 (사용자, 2026-09-07)

> DMF0082 의 SCM_FCST 편집가능일 때 LIMIT_MEASURE 는 수정불가이여야 합니다.
> 현재 설정된 LOOKUP 을 기준으로 40 DIVISION 의 경우 MON(월요일) 10:00 - 19:00 까지는
> SCM_FCST 편집가능시간으로 LIMIT_MEASURE 인 MKT_FCST는 수정불가여야 하는데,
> 40 DIVISION DM PLANNER 인 eunah.koo 사용자로 로그인해서 들어가면 현재도 MKT_FCST 가 수정 가능하도록 표기됨.

원 요건 = PKG 주석에 이미 명시된 `[E20250729-000433]_[공급/생산SCM PI팀] 월요일 SCM FCST 입력 시
MKT FCST 수정 불가하도록 시스템 개선`.

## 원인 (실측 2026-09-07 MON 16:35, 사내 ZIOUI1)

LIMIT_MEASURE 강제 'N' 판정의 **근거 범위가 "내 보유그룹 행"으로 좁았다.**

```
GTT_TEMP_INTO_GROUP_MEASURE  ← SEGMENT1(그룹) = 내 보유그룹 으로 필터해 적재
    ↓ (이 안에 LIMIT_MEASURE 가 있을 때만)
SELECT COUNT(A.LIMIT_MEASURE) INTO V_LIMIT_CNT ...    -- 0 이면 아래 UPDATE 미발동
IF V_LIMIT_CNT >= 1 THEN  UPDATE ... SET EDIT_AUTH_YN='N' WHERE A.MEASURE = B.LIMIT_MEASURE
```

40 division 의 `SCM_FCST`(MON 1000~1900, ATTRIBUTE4=`MKT_FCST`) 행은
**ADMIN / SCM PI Admin / SCP Planner 3그룹에만** 등록돼 있다.
그래서 `DM Planner`(eunah.koo)로 로그인하면 INTO 적재분 3행(LOC/MKT_FCST/VMI_In_Req)이 전부
ATTRIBUTE4 NULL → `V_LIMIT_CNT = 0` → 강제 'N' 이 **아예 발동하지 않아** MKT_FCST 가 열린 채 남았다.

실측 (정정 전, 실 SP `P_DMF0082_GET_MAIN_DATA_CURRENT` 호출 O_RC4):

| MEASURE | EDIT_AUTH_YN |
|---|---|
| LOC | Y |
| **MKT_FCST** | **Y** ← 잠겨야 함 |
| SCM_FCST | N |
| VMI_In_Req | Y |

## 정정 `[E20260907-LIMITMEAS-DIV]`

잠금의 주체는 '내 그룹'이 아니라 **'이 division 의 SCM_FCST 입력 시간창'** 이므로,
LIMIT 판정에서 **SEGMENT1(그룹) 조건만 제거**하고 `(SEGMENT2 프로그램, SEGMENT3 division)` 범위로 본다.
요일·시간창 판정식(빈값 = 제한 없음)은 기존 INTO 적재분과 **문자 그대로 동일**하다.

- 수정 지점 **2곳** — `P_DMF0082_GET_MAIN_DATA` (`GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE.EDIT_AUTH_YN`) /
  `P_DMF0082_GET_MAIN_DATA_CURRENT` (`GTT_TEMP_ADMIN_GROUP_MEASURE.EDIT_FLAG`)
- 시그니처·커서 규격·PROC_M/BE/FE 배선 **변경 없음** (DB 단독 적용분)
- ⚠ 81 계열의 `ATTRIBUTE4` 는 메저명이 아니라 **잠금 유발 그룹명**(`SCP Planner`, `[E20260825-81AUTH]`)이라,
  토큰이 같은 division 의 `SEGMENT1`(그룹명)과 일치하면 이 해석에서 **제외**한다 — 두 해석은 상호배타.
  (DMF0082 의 A4 보유행은 전 division 이 `SCM_FCST → MKT_FCST` 21행뿐이고 그룹명 토큰은 0건)

## 사내 검증 (2026-09-07 MON, ZIOUI1)

- 컴파일 **VALID / 에러 0** · 마커 2곳 · 구 판정 실행구문(`INTO V_LIMIT_CNT` / `IF V_LIMIT_CNT`) 잔존 **0**
- 권한판정 블록 BEFORE/AFTER 대사 (그룹 5 × division 2 × 프로시저 2):

| 사용자(그룹) | div | BEFORE MKT_FCST | AFTER MKT_FCST | 판정 |
|---|---|---|---|---|
| eunah.koo (DM Planner) | 40 | Y | **N** | ✅ 신고 해소 |
| DM_A_TEST (DM ADMIN) | 40 | Y | **N** | ✅ 동 규칙 |
| attackgo (ADMIN/SCM PI Admin) | 40 | N | N | 회귀 0 (원래 자기 행이 잠갔음) |
| bottle (SCP Planner) | 40 | N | N | 회귀 0 |
| DM_V_TEST (DM Viewer) | 40 | N | N | 회귀 0 |
| 위 전원 | 81 | Y/N 각각 | **동일** | 회귀 0 — 81 시간창은 TUE 라 MON 에는 미발동 |

⇒ 변경은 **"시간창이 열려 있는 division 의 LIMIT 대상 메저"** 에만 발생. 그 외 전부 동일.

## 적용 순서 (클라우드)

1. `01_PKG_DMF0082_BODY.sql`  — `CREATE OR REPLACE PACKAGE BODY` (사내 적용 동일본)
2. `02_POSTCHECK.sql`         — P1 VALID·에러0 / P2 마커 2 / P3 구 판정 실행구문 0 /
                                P4 잠금 유발 룩업 데이터 / P5 **지금 잠겨야 하는 (division, measure)**
3. 화면 확인 — 40 division DM Planner 계정으로 **월요일 10:00~19:00 사이** DMF0082 Current 조회 →
   `MKT FCST[R+P]` 행 수량 셀이 회색(편집 불가)

⚠ 라이브 재배포 = 라이브러리 캐시 배타락. 실행 중 세션이 있으면 대기하고, **대기 중에는 다른 세션의
  PKG_DMF0082 호출도 그 뒤에 줄을 선다**. 사내 적용 시 실측으로 BE 1대를 내려 락을 통과시켰다
  (한산한 시간대 적용 권장).

## 알려진 인접 사항 (이번 범위 밖 — 미조치)

- 잠긴 메저는 **조용히 잠긴다**(회색). 안내 메시지는 없다 — 기존 ADMIN/SCM PI Admin 동작과 동일하게 맞췄다.
  (`drop3` 'T' 로 내리면 MSG00477 이 뜨지만 그 문구가 *"SCP Planner 권한사용자의 수정 가능한 시간이
  아닙니다"* 라 DM Planner 에게는 사실과 다르다 → 채택하지 않음)
- 신규행 Measure **드롭다운 후보**는 CMBO `FcstPriceEditMeasure`(division|site|bucket)가 만들며
  시간창을 모른다 → 잠금 중에도 후보에는 `MKT_FCST` 가 남는다(선택해도 수량 셀은 잠김).
  ADMIN 계정에서 종전부터 동일했던 기존 동작이며, 이번 정정으로 생긴 것이 아니다.
