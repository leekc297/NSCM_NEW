# SYS0014_GAP467_GROUPMST_CLOUD_20261015 — Group User 그룹 원장 누락 그룹 보완 (클라우드 데이터 패치)

- 대상: `SCM_ADM_USER_GR_M`(그룹 원장) · `SCM_ADM_USER_GR_MPG_M`(사용자-그룹 매핑) · 기록용 `ZZ_GAP467_MPG_ADDED`(신설, 원복 근거)
- 실행 계정: SCM_MGR · 대상: 클라우드 QA → DEV 순
- 사내 ZIOUI1: 적용 완료(2026-10-15 20:49) — `_artifacts/_apply_corporate/GAP467_SYS0014_GROUPMST_20261015/APPLIED_OPERATIONS.md`

## 무엇이 바뀌나
AS-IS 에 있던 그룹이 TO-BE 그룹 원장에 없어 SYS0014 화면 목록에 안 나오고, 그 그룹의 사용자·사업부 권한을 다룰 수 없던 문제를 고친다.
GAP 의 AS-IS 수치 원천 = TO-BE 이관 사본 `TB_FX_GROUPINFO` / `TB_FX_USERGROUPINFO` (Guest 2,346 · CAPA Planner 220 · System Monitor 1 · '-' 34 — 실측 일치).

| 그룹 | 원장 추가 값 | 사용자 매핑 이관 | 근거·결정 |
|---|---|---|---|
| CAPA Planner | 이름 CAPA Planner · 사용 Y | 220 | 사본 USEYN Y (사용자 결정) — 사업부 권한 709행이 이 그룹을 가리킴 |
| System Monitor | 이름 System Monitor · 사용 Y | 1 | 사업부 권한 22행 |
| SSP ADMIN | 이름 SSP ADMIN · 사용 N | 0 (사본에 없음) | GAP 밖 · AS-IS 원장 누락분 (사용자 결정 추가) — 권한요청 5행 |
| `-` | 이름 `-` · 사용 `/` | 34 | 사본 원래 값 '-' 유지 (사용자 결정). 사용여부는 원천 값이 없어 NULL 초기값 '/' |
| Guest | — | — | **변경 없음**(사용자 결정): TO-BE 표준 대문자 GUEST 유지. 사본 Guest 매핑은 이미 GUEST 로 이관돼 있음 |

- 사용자 매핑은 기존 이관과 같게 **감사컬럼까지 1:1**. NULL 은 문자 '/' · 일자 SYSDATE 초기값.
- 그룹 원장 감사컬럼 = 'admin'. 기존 행 무변경(없는 키만 INSERT). 화면 SP · FE · BE · 메타 무변경.

## 사내 검증 결과 (ZIOUI1)
| 항목 | 수정 전 | 수정 후 |
|---|---|---|
| 그룹 목록(P_SYS0014_GET_GROUP_LIST_M) | 19 | **23** (CAPA Planner · System Monitor · SSP ADMIN · '-' 추가) |
| 그룹별 사용자(P_SYS0014_GET_USER_BY_GROUP_M) | 목록에 그룹 없음 | CAPA Planner 220 · System Monitor 1 · '-' 34 |
| 사업부 권한 조회(P_SYS0014_GET_AUTH_LIST_M) | 접근 불가 | 예: CAPA Planner / autory8th 14행 = 원장 14행 |
| 원장에 없는 그룹을 가리키는 사업부 권한 | 732 (CAPA 709 · System Monitor 22 · Guest 1) | **1** (Guest — 유지 결정) |

- 리허설: 00 → 10 → 10(재실행 0건) → 90 → 99 → 99(0건) → 10 → 90 전 단계 기대대로. 원복은 기록 테이블 기준으로 이번 추가분만 지운다.
- 참고(변경 안 함): System Monitor 사업부 권한 중 4명 16행(hwayoung.lim · hyerakim · jaeuk.shin · ohsun)은 사본에서도 그 그룹 소속이 아니라 화면 사용자 목록에 안 나온다 — AS-IS 잔존 데이터(전체 그룹 기준 동일 유형 301행).
- 참고(범위 밖): 원장에 없는 그룹을 가리키는 다른 행 — 버튼 매핑 `DEMAND_USER` 26 · `DM VIEWER` 5, 메뉴 매핑 `SCP ADMIN` 2 (AS-IS 그룹 원장에도 없는 이름).

## 실행 순서 (전부 전체 F5, 값 입력 없음, 치환변수·바인드 없음)
| 순서 | 파일 | 기대 결과 | 다르면 |
|---|---|---|---|
| 1 | `A_DB/00_PRECHECK_CLOUD.sql` | L1 0행 · L2 사본 2테이블 존재 + 사본 행 [-] · [CAPA Planner] · [System Monitor] 수 · L3 0행 | **L2 사본 없음**이면 10 은 그룹만 적용하고 매핑은 SKIP — 결과 회신. L1·L3 에 행이 있으면 그 키는 건너뜀(회신) |
| 2 | `A_DB/10_APPLY_GAP467_GROUP_M.sql` | `APPLIED [B] — 사용자 매핑 N건 추가` (N = L2 사본 행 합 − L3) · POST 그룹 4행 | `중단 — …` 이면 매핑 전부 취소됨. 메시지 회신 |
| 3 | `A_DB/90_VERIFY.sql` | V1 4 PASS · V2 미이관 0 PASS · V3 Guest 1행만(참고) | 회신 |
| 4 | SYS0014 화면 | 그룹 목록에 4개 그룹 · 선택 시 사용자 · 사용자 선택 시 사업부 권한 표시 | 회신 |
| 원복 | `A_DB/99_ROLLBACK_GAP467_GROUP_M.sql` | `ROLLED BACK — 사용자 매핑 N건 · 그룹 M건 삭제` | 회신 |

## 이관 축 점검
| 축 | 해당 |
|---|---|
| 데이터 | ✅ 그룹 원장 4행 · 사용자 매핑(사본 기준) |
| TABLE DDL | ✅ `ZZ_GAP467_MPG_ADDED` (10 이 없을 때만 생성 — 원복 근거. 원복 후에도 남김) |
| PKG/SP · 메타 · MSG/LBL · GRANT/SYNONYM · FE · BE | 해당 없음 |
