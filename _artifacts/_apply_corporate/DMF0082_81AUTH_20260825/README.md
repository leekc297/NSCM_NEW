# DMF0082 — 81 계열 권한별 메저 체계 수립 (2026-08-25, E20260825-81AUTH)

방향(사용자 확정): **GET_ADMIN_GROUP_MEASURE 등재로 통일** (방안 B). UI 상세(추가·편집·VMI)는
MKT_FCST_MEASURE 참조 축 유지. **본 작업은 GET_ADMIN_GROUP_MEASURE 에 한정** (사용자 명시).

## 룩업 최종 (SEGMENT2='DMF0082', 81 계열 72행 — 6 division 공통)
| 메저 | 그룹 | 속성 |
|---|---|---|
| MKT_FCST | ADMIN·DM ADMIN·DM Planner·DM Planner (W/S)·SCP Planner (5) | 없음 (40 패턴 — 일자·시간·LIMIT 제거, 사용자 지시) |
| LOC | ADMIN·DM ADMIN·DM Planner·SCM PI Admin (4) | 없음 (40 패턴 준용 — W/S·SCP 제외) |
| SCM_FCST | ADMIN·SCM PI Admin·SCP Planner (3) | **division 별 TUE 창** + LIMIT=MKT_FCST (창 중 MKT 잠금 — 40 MON 창 동형) |

division 별 SCM_FCST 창(사용자 지시 — 룩업 SCP/MKT 행의 AS-IS DMF0003 승계값 재사용):
81=0411~1100 / 81_HD=1006~1150 / 81_HG=1010~1140 / 81_HM=0401~1130 / 81_ST=0406~1135 / 81_UC=1001~1145

## SP (PKG_DMF0082 BODY, 마커 E20260825-81AUTH ×3)
1. **LIMIT_AUTH(그룹 잠금) 해석 신설** — GET/CURRENT 2곳. A4 가 그룹명이면 그 그룹 행의 시간창 안에서
   내 메저 잠금 (PKG_DMF0003 AUTHGATE 동형). AUTHUNION 합집합 보존. 40 LIMIT_MEASURE(메저 잠금)와 공존.
   ※ 현재 데이터는 A4=메저명뿐이라 휴면 — 그룹명 A4 재도입 시 즉시 동작.
2. **LOC 강제 개방을 81 계열 제외** — [E20260825-SCPPLOC] 조건 보강: 81 계열 = 룩업 전권.
   40 = 현행 유지(비 SCP 강제 개방, REQ:1ST-36-1 계보).

## 검증 (사내 실측)
- 실호출 매트릭스 5계정(ADMIN/DM ADMIN/DM Planner/W-S/SCP) × div 81·81_UC·40 — 기대 1:1 일치
- 창 모의: 81 TUE 10:30 = ADMIN/SCM PI/SCP SCM_FCST=Y·MKT=N(LIMIT), 타그룹 MKT=Y — **40 MON 16:00 과 완전 동형**
- 40 회귀 0 (15행 불변·판정 동일) · 컴파일 VALID
- DM_UI_EDITABLE_MEASURE 81 시딩 18행은 범위 정정으로 **원복 완료** (40 4행만 잔존)

## 파일
- `01_LOOKUP_81AUTH.sql` — 룩업 전체 변경분(시딩+수정) 멱등 재현본 → 클라우드 패키지 `22_LOOKUP_81AUTH.sql` 동봉
- `edits_sp.json` / `edits_scpploc2.json` — SP 치환 쌍
- `BACKUP_PKG_DMF0082_*.sql` — 각 패치 직전 원본 (실행=원복)
- 클라우드: `DMF0082_CLOUD_20260823_FULL` BODY 재동기(마커 4종) + 90_VERIFY 19종. **클라우드 미적용**
