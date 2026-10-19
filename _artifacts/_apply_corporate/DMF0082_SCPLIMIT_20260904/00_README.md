# DMF0082 — `[E20260904-SCPLIMIT]` LIMIT_MEASURE 시간창 = 전 권한자 편집 제한

> 2026-09-04 · 사내 Oracle 적용 완료 · 대상 = `PKG_DMF0082` PACKAGE BODY

## 요구 (사용자 지시)

- SCP 편집가능 시간일 때 **MKT_FCST 는 편집 불가**.
- 판정 원천 = `SCM_ADM_LOOKUP_MASTER_DETAIL`, `LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE'`,
  `SEGMENT2='DMF0082'` 행의 **요일(ATTRIBUTE1) · START(ATTRIBUTE2) · END(ATTRIBUTE3)** 시간창 안이면
  **LIMIT_MEASURE(ATTRIBUTE4)** 에 적힌 메저는 편집 불가.
- PKG 에서 대상일 때 **EDIT_FLAG='N'**.
- **자신만이 아니라 모든 권한자**에게 적용.
- **81 계열 그룹잠금 규칙보다 우선 적용**.

## 왜 필요했나 (실측)

기존 `[E20260819-LIMITMEAS]` 는 시간창 행을 `GTT_TEMP_INTO_GROUP_MEASURE` 에 담을 때
`SEGMENT1`(그룹)이 **내 보유그룹과 매칭될 때만** 담았다. 그래서 해당 그룹이 아닌 사용자에게는
잠금이 걸리지 않았다. 요구는 "그 시간대에는 어떤 권한자도 편집 불가" 이므로 **그룹 매칭 없이** 판정해야 한다.

AS-IS 계보 = `[E20250729-000433]` 월요일 SCM FCST 입력 시 MKT FCST 수정 불가.

## 변경 (순수 추가 66줄 · 삭제 0)

| 지점 | 프로시저 | 대상 |
|---|---|---|
| L3644 직전 | `P_DMF0082_GET_MAIN_DATA` | `GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE.EDIT_AUTH_YN` |
| L8883 부근 | `P_DMF0082_GET_MAIN_DATA_CURRENT` | `GTT_TEMP_ADMIN_GROUP_MEASURE.EDIT_FLAG` |

두 곳 모두 기존 LIMITMEAS 블록 **직후**, `[E20260825-81AUTH]` 그룹잠금 **직전**에 삽입(우선 적용).
`EDIT_FLAG='Y'` 인 행만 `'N'` 으로 바꾸므로 뒤따르는 81 규칙과 충돌하지 않는다(둘 다 단방향).

**대상 격리** — 시간창(ATTRIBUTE1/2/3)이 **모두 정의된 행만** 본다.
81 계열 행은 3칸 NULL + `ATTRIBUTE4='SCP Planner'`(그룹명)이라 이 문장에 걸리지 않는다.

## 실측 (적용 전후)

| 항목 | 값 |
|---|---|
| 규칙 대상 룩업 행 | `SEGMENT2='DMF0082'` 중 시간창 정의 행 = **3건** (ADMIN / SCM PI Admin / SCP Planner · div40 · SCM_FCST · MON 1500~1830 · LIMIT=MKT_FCST) |
| 적용 시점(2026-09-04 FRI 16:32) 발동 | **0건** → 동작 불변(회귀 0). 실조회 확인: `MKT_FCST → Y` |
| MON 16:00 가정 | div40 에서 **MKT_FCST 만 `N`**, LOC·SCM_FCST·VMI_In_Req 불변 |
| 배포 결과 | `PKG_DMF0082` BODY **VALID** · 컴파일 에러 0 · SCPLIMIT 마커 2곳(L3644 / L8883) |

## 파일

| 파일 | 내용 |
|---|---|
| `00_BACKUP_PKG_DMF0082_BODY_20260904.sql` | 적용 직전 사내 라이브 원문(15,107줄) — **원복본** |
| `01_PKG_DMF0082_BODY_SCPLIMIT_20260904.sql` | 적용본(15,173줄 = +66) |
| `90_VERIFY.sql` | V1 상태 / V2 마커·순서 / V3 대상 룩업 / V4 현재 발동 / V5 월 16:00 시뮬레이션 |

## 남은 확인

실제 시간창(월 15:00~18:30) 도래 시 화면에서 MKT_FCST 셀이 잠기는지 **사용자 실측**이 필요하다
(현재는 시간창 밖이라 코드 경로만 검증). 클라우드 이관은 별도 요청 시 진행.
