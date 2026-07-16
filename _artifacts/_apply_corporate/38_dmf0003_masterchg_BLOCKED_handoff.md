# DMF0003 MasterChgPopup (Incoterms 변경) — BE/SP 차단 handoff (2026-06-28)

> ⛔ **종결 (2026-07-13, 사용자 결정)**: Master Change 버튼·기능 **전체 삭제**로 확정.
> FE(MasterChgModal/버튼/컬럼상수/LBL00701/MSG00653) 제거 + 사내 메타(BTN_MPG/API_M/USER_GR/MSG_M 11행)
> 삭제 = `A3_dmf0003_masterchg_full_removal.py`. 아래 "필요 작업" 은 더 이상 진행하지 않음.
> (참고: 2026-07-13 실측 시 GET SP 는 SCM_MGR 에 VALID 로 이관돼 있었고, SAVE SP 는 hook #107
> FETCH_STATUS 무한루프 결함 보유 — SP 들은 AS-IS 자산으로 보존, 화면 기능만 제거.)

> Phase 2e 4번 MasterChgPopup. FE 모달 shell 은 작성되었으나 **SP 부재로 기능 미완**.
> SP/BE 수정은 본 작업 scope 밖 (제약: BE(Java)/SP 수정 금지). 사용자 검토 후 SP 작업 필요.

## AS-IS 호출 SP (DMF0003_MatsterChgPopup.cs)
| 용도 | AS-IS SP | 사내 Oracle 실측(2026-06-28) | 상태 |
|---|---|---|---|
| GET (조회) | `DM.DMF0000_GET_MASTER_CHG_POPUP` | **ALL_PROCEDURES 0행 (미존재)** | ❌ 차단 |
| Title (동적컬럼) | `DM.DMF0000_GET_COMMON_SPREAD_TITLE` | (미확인 — GET 부재로 보류) | ⏸ |
| SAVE | `DM.DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` | 존재(13 IN) — **OUT 커서 없음** | ⚠️ 부분 |
| Lookup | `SCM.SCM0001_GET_LOOKUP_VALUES` (INCOTERMS/SALES_TYPE_CODE/DOM_EXP) | 별도 (combo 로 대체 가능) | — |

## 차단 사유 (anti-simplification — 은폐 금지)
1. **GET SP 미존재**: `DMF0000_GET_MASTER_CHG_POPUP` 가 사내 Oracle 에 없음 → 모달 grid 조회 불가.
   AS-IS 는 DM0002 → DMF0003 으로 화면 ID 만 이관(주석 L22)되었고 GET SP 는 `DMF0000_` prefix
   (공통)로 남아 있으나 사내 migration 미적용. TO-BE SP 신규 작성 또는 이관 필요.
2. **SAVE SP OUT 커서 부재**: `DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` (13 IN, OUT 0).
   BE 공용 proc 프레임워크(GeneralServiceImpl.makeProcedure)는 결과 OUT (O_RESULT_CURSOR 등)
   기준으로 응답을 구성 → OUT 커서 추가(O_RESULT_CURSOR) SP body 보강 필요.

## 필요 작업 (사용자 승인 후)
- [ ] `DMF0000_GET_MASTER_CHG_POPUP` (또는 `DMF0003_GET_MASTER_CHG_POPUP`) SP 작성/이관
      — IN: division_id/team_id/customer/scm_site_id/project_code/created_by/user_group + O_RC1.
- [ ] `DMF0000_GET_COMMON_SPREAD_TITLE` (동적컬럼) SP 작성/이관 또는 정적 컬럼으로 대체.
- [ ] `DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` OUT 커서(O_RESULT_CURSOR) body 보강
      (sp-body-minimal-change: 원본 + END 직전 OPEN 1줄).
- [ ] 위 3 SP PROC_M + API_M + BTN_MPG (DMF0003 masterChg sheet, SEARCH/SAVE) 등록.

## FE 현황
- `MasterChgModal.tsx` shell 작성 (CustomDialog wrap + grid). `enabled=false` 로 SP 호출 보류.
- SubTitle customButton `MASTER_CHG` 트리거 wire-up 완료 (모달 open). SP 적용 시 enabled 전환.
