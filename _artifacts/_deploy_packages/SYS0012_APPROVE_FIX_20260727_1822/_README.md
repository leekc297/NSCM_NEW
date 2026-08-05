# SYS0012 Auth Approval — 승인 시 실제 권한 부여 보완 (DB 전용)

> 2026-07-27 | 사내 Oracle(OCGSCMD_P01) 적용·검증 완료. 클라우드는 `sql/01_p_sys0012_approve.sql` 1본 실행.

## 문제

`P_SYS0012_APPROVE`(기존 32행)가 `SCM_MST_AUTH_REQUEST` 상태만 `APPROVED` 로 UPDATE 하고, 권한 테이블에는 아무것도 쓰지 않았습니다. Group User 화면(SYS0014)은 `SCM_ADM_USER_GR_MPG_M` 을 읽으므로 승인해도 화면에 나타나지 않았습니다.

**실측**: `APPROVED` 312건 전수 중 그룹매핑 반영 **0건**.

## AS-IS 원본 (파리티 기준)

`UP_FX_SaveApprovalAuthRequest` (`AsIs_LGCE_SCMDEV_SP10_DDL.sql` L28081~) 의 APPROVED 분기:
1. 요청 상태 UPDATE (+ `APPROVAL_USER` 기록)
2. `UP_FX_SaveUserInfo` — 사용자 `DefaultGroupID` 가 `Guest` 이면 **승인 그룹으로 전환**
3. `UP_FX_SaveUserGroupInfo` — 그룹 매핑 MERGE (`UseYN='Y'`)
4. `UP_FX_SaveUserGroupAuthExtention` — 단위권한 `'D'` 등록
5. Plant 분기는 **주석(비활성)**

## 보완 내용

| # | 처리 | AS-IS 대응 | 비고 |
|---|---|---|---|
| ① | 요청 상태 UPDATE + `APPROVAL_USER` 기록 | 1 | **기존 SP 누락분** — 승인자 미기록이었음 |
| ② | `SCM_ADM_USER_GR_MPG_M` MERGE (`USE_YN='Y'`) | 3 | 그룹 마스터 미등록 그룹은 제외(예: `CAPA Planner`) |
| ③ | `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` INSERT (`UNIT_TP_CD='D'`, `UPPR_UNIT_ID='-'`) | 4 | `EDIT_YN` = 그룹명 Viewer 계열이면 `N`, 그 외 `Y` (기존 1,866행 관례와 100% 일치) |
| ④ | **GUEST 회수** — 실그룹을 갖게 된 사용자의 GUEST 매핑 `USE_YN='N'` | 2 의 등가 처리 | 아래 설계 판단 참조 |
| — | Plant 권한 | 5 | **미구현** — AS-IS 도 주석이고 요청 데이터 `PLANT_ID` 전 건 `'-'` (정직 표기) |

### ④ GUEST 처리 — 설계 판단

AS-IS는 GUEST **매핑을 삭제하지 않고** `TB_FX_User.DefaultGroupID` 를 `Guest` → 승인 그룹으로 바꿉니다. 그런데 TO-BE `SCM_ADM_USER_M` 에는 **DefaultGroupID 에 해당하는 컬럼이 없습니다**(실측). 그래서 등가 효과로 **GUEST 매핑을 `USE_YN='N'` 으로 회수**했습니다. 하드 삭제가 아닌 비활성화를 택한 이유는 AS-IS 회수(reject) 패턴과 동일하고 되돌릴 수 있기 때문입니다. 하드 삭제를 원하시면 바꿔 드립니다.

## 검증 (사내, 테스트 계정 후 정리)

```
결과: CODE=0, EVENT(승인)=2, GROUP_MAPPED=2, UNIT_AUTH_ADDED=2, GUEST_REVOKED=1
그룹매핑:      DM Viewer=Y / SCP Planner=Y / GUEST=N   ← GUEST 자동 회수
Division권한:  DM Viewer/D/81/-/EDIT_YN=N / SCP Planner/D/82/-/EDIT_YN=Y
요청상태:      APPROVED + APPROVAL_USER 기록
재실행(멱등):  GROUP_MAPPED=2(무변화), UNIT_AUTH_ADDED=0, GUEST_REVOKED=0 → 중복 0
```

## 수정 중 발견한 함정 (기록)

첫 배포본에서 Division 권한이 0건이었습니다. `TRIM(DIVISION_ID) NOT IN ('', '-')` 이 원인으로, Oracle 은 `''` 를 NULL 로 보기 때문에 `NOT IN (NULL,'-')` 이 항상 UNKNOWN(거짓)이 됩니다. `IS NOT NULL` + `<> '-'` 로 분리해 해결했습니다. (MSSQL→Oracle 변환 함정 유형)

---

# 2. P_SYS0012_REJECT — 반려 시 권한 회수 보완 (`sql/02_p_sys0012_reject.sql`)

## 문제 (기존 33행)

- 상태만 `REJECT` 로 UPDATE — **기존에 부여된 권한을 회수하지 않음**
- `APPROVAL_USER` 미기록
- **반려사유 결함**: `MAX(REJECT_REASON)` 을 전체 JSON 배열에서 하나만 뽑아 **선택한 모든 행에 같은 사유**가 기록됨

## 보완 내용 (AS-IS REJECT 분기 파리티)

| # | 처리 | AS-IS 대응 |
|---|---|---|
| ① | 상태 UPDATE + `APPROVAL_USER` + **행별** 반려사유 (MERGE 로 REQUEST_ID 매칭) | `UPDATE SCM_MST_AUTH_REQUEST` |
| ② | 단위권한 회수 — `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` DELETE (group+user+division, `UNIT_TP_CD='D'`) | `DELETE TB_FX_UserGroupAuthExtention` |
| ③ | 그룹매핑 비활성 — 남은 단위권한이 **하나도 없을 때만** `USE_YN='N'` | `UPDATE TB_FX_UserGroupInfo SET useyn='N' ... NOT EXISTS` |

- GUEST 복원은 AS-IS 에 없어 **하지 않음**(정직 표기).
- `''=NULL` 함정 회피 조건 동일 적용.

## 검증 (사내, 테스트 계정 후 정리)

```
[승인]  DM Viewer(81,82) + SCP Planner(40) → 그룹매핑 2, 단위권한 3
[반려1] DM Viewer/82 만 반려 → 단위권한 1건 회수, 그룹매핑 유지(Y)   ← 81 이 남아 있으므로
        그룹매핑: DM Viewer=Y, SCP Planner=Y / 단위권한: DMViewer-81, SCPPlanner-40
[반려2] DM Viewer/81 도 반려 → 단위권한 1건 회수, 그룹매핑 DM Viewer=N  ← 남은 권한 0
        SCP Planner 는 영향 없음(Y 유지)
행별 사유: 81=사유B / 82=사유A 각각 정확히 기록 (기존 MAX() 결함 해소)
멱등 재실행: 회수 0 / 비활성 0 → 추가 변경 없음
```

---

## 남은 과제 (미포함)

- **기존 APPROVED 312건 소급 반영(백필)** — 이번 범위 밖. 필요 시 대상 진단 후 별도 승인받아 적용.
- Plant 단위 권한(`UNIT_TP_CD='P'`) 정책 확정 시 추가 (AS-IS 도 주석·데이터 전 건 `'-'`).
