# DMF0082 — SCP Planner LOC 편집권한 정정 (2026-08-25)

마커 `E20260825-SCPPLOC` · 대상 `PKG_DMF0082` PACKAGE BODY · 변경 지점 **1곳** (`P_DMF0082_GET_MAIN_DATA`)

## 문제
`P_DMF0082_GET_MAIN_DATA` L3330 `[E20260820-MEASRULE]` 이
`UPDATE GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE SET EDIT_AUTH_YN='Y' WHERE MEASURE='LOC'` 를
**그룹·요일·시간 조건 없이** 실행 → GET_ADMIN_GROUP_MEASURE 룩업에 LOC 행이 없는
**SCP Planner** 까지 Unit Price(LOC) 편집 가능.

AS-IS(`DMF0082_FcstNPrice_Mgmt.cs`) 는 룩업 통제:
- L9172 `bEDIT_AUTH_LOC` = Tables[3] `MEASURE='LOC'` 의 `EDIT_FLAG`
- L9229 `case "LOC": if (!bEDIT_AUTH_LOC) continue;` → 언락 안 함 = 셀 잠김
- L814 저장측 차단

룩업 실측(사내): SCP Planner 행은 `40 / SCM_FCST / MON 1500~1830 / LIMIT=MKT_FCST` **1건뿐** → LOC 없음.

## 조치 (문장 1개에 조건 1개 추가 — 다른 그룹·메저·division 불변)
개방을 **두 조건을 모두 만족할 때만** 제외한다:
1. 해당 division 에 `GET_ADMIN_GROUP_MEASURE` 룩업이 존재(현재 40) — 81/81_JV/82 는 룩업 0행이라 제외 대상 아님
2. 세션 보유그룹에 `SCP Planner` 포함 (AUTHUNION 동형 판정 — 타 그룹 겸유 시 룩업이 이미 'Y' 부여)

⚠ 1번이 없으면 `REQ:1ST-41-1` / `REQ:1ST-63-3` (81 에서 LOC 입력) 이 깨진다.

## 검증 (사내, 2026-08-25 TUE)
SP 실호출 `PKG_DMF0082.P_DMF0082_GET_MAIN_DATA` → O_RC4(메저별 편집권한)

| 계정 | 그룹 | Div | LOC | 판정 |
|---|---|---|---|---|
| dodae | SCP Planner | 40 | **N** | 정정 목표 달성 |
| bottle | SCP Planner | 40 | **N** | 동일 |
| bpark416 | DM Planner | 40 | Y | 불변 |
| bindy122678 | ADMIN | 40 | Y | 불변 |
| dodae | SCP Planner | 81 | Y | 불변(룩업 미프로비저닝) |

행 `EDIT_FLAG` 산식(L3439~3453) 재평가 — dodae LOC=N / DM Planner LOC=Y.
컴파일 STATUS=VALID · 라이브 마커 1행.

FE 무수정 — `forecast-price/utils/forecast-price.wsAuth.ts:281·317` 이 LOC 를 drop3 `measureAuth` 로 판정.

## 파일
- `02_PKG_DMF0082_BODY.sql` — 적용본 전문(CREATE OR REPLACE, 클라우드 이관용)
- `BACKUP_PKG_DMF0082_20260825_114722.sql` — 적용 직전 원본(그대로 실행하면 원복)
- `edits.json` — 치환 쌍(재현용)

## 적용 축
사내 **적용 완료** / 클라우드 QA·DEV **미적용**

원장: `Doc/단위테스트_보완대상/보완요청_원장.md` `REQ:CHAT-20260825-1`
