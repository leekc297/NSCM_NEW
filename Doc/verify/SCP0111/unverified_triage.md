# SCP0111 미검증 분류 · 2026-11-19 13:16:40 · 라운드 3

- 원장 미검증(ERROR) 10 → 10행. 처리 대상(엔진·대조표·판단·미분류·자동 남음) 4 · 사람 확인 2 · 집계 3
- 집계 행 = 하위 행 판정을 따라감. 하위 행이 풀리면 같이 풀림(따로 고치지 않음).
- 자동 재측정: 없음

| 담당 | 유형 | 행 |
|---|---|---|
| 집계 | 집계 | 3 |
| 사람 | 저장보류 | 2 |
| 엔진 | 검사기공백 | 2 |
| 엔진 | 데이터전제 | 2 |
| 가이드 | 대조표사유 | 1 |

## 담당 엔진 (4행)

### 검사기공백 · 규칙 F4 · 2행
- 처리: 검사기 신설·보완(공용 엔진 · 화면 독립) 후 해당 규칙 재측정
- T-03071eab [TRACE] P_SCP0111_SAVE | [측정 경로 없음] P_SCP0111_SAVE: 이번 Save 는 main/SAVEDETAIL 로 저장(정상 호출) — 이 SP 경로 main/SAVE 는 다른 시트·버튼 저장이라 이 시험(메인 셀 수정·Save)에서 미측정(T210) · [세션 그룹 재현 T344] 'DM Administrator' 제외: 편집 가능 · 저장 호출 main/SAVEDETAIL | 'DM Planner' 제외
- T-ea67ed5b [TRACE] PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI | [측정 경로 없음] PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI: 이번 Save 는 main/SAVEDETAIL 로 저장(정상 호출) — 이 SP 경로 main/SAVE 는 다른 시트·버튼 저장이라 이 시험(메인 셀 수정·Save)에서 미측정(T210) · [세션 그룹 재현 T344] 'DM Administrator' 제외: 편집 가능 · 저장 호출 main/

### 데이터전제 · 규칙 B4 · 2행
- 처리: 검사기가 조회조건·Division·행 선택을 바꿔 측정 전제를 만족시키도록 보완(ensureRows 계열 · 전 후보 순회)
- T-18374ec4 [TRACE] cboPlanDate / Plan-date / Plan Date | [화면 초기(선택 Div=81)] AS-IS 13건 vs TO-BE 22건 · 차이 9건 설명 불가: 20261026: 설명 불가(조건 해석 검증 실패 — 공통 후보 '20260824' 가 AS-IS 마스터에서 조회 안 됨); 20261019: 설명 불가(조건 해석 검증 실패 — 공통 후보 '20260824' 가 AS-IS 마스터에서 조회 안 됨); 20261012: 설명 불가(조건 해석 검
- V-530425d0 [SEARCH] 조회조건 Plan Date | [화면 초기(선택 Div=81)] AS-IS 13건 vs TO-BE 22건 · 차이 9건 설명 불가: 20261026: 설명 불가(조건 해석 검증 실패 — 공통 후보 '20260824' 가 AS-IS 마스터에서 조회 안 됨); 20261019: 설명 불가(조건 해석 검증 실패 — 공통 후보 '20260824' 가 AS-IS 마스터에서 조회 안 됨); 20261012: 설명 불가(조건 해석 검

## 담당 가이드 (1행)

### 대조표사유 · 규칙 X-LOC · 1행
- 처리: DB MODE(repairScope DB_ONLY): 대조표(FE 폴더) 수정 불가, FE 가이드(FE_GUIDE_*.md)로 남기고 결정 목록에 적음 · 재수행으로 줄지 않아 처리 대상에서 뺌
- T-b8e710df [TRACE] ESS 파생검증 D1/D2 불일치 경고 · (경고, 저장 미차단) | 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 (행의 식별자 SCP0111_DERIV_MISMATCH 를 화면 소스·프로시저 목록에서 못 찾음) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7)

## 담당 사람 (2행)

### 저장보류 · 규칙 F1 · 2행
- 처리: 저장 시험 행을 지울 경로가 없는 화면(cleanup_spec mode=editonly) — 정리 키·삭제 경로 지정(gen_cleanup_spec) 또는 저장 시험 허용 여부 사용자 결정
- ES-9b3831e2 [RULE_SCREEN] SCP0111 E2E crud 저장 왕복(editonly) | [측정 전제 미충족: 시험 행 저장 요청 없음(saveCalls=0)] 화면 검증·필수 칸에 막혔을 수 있음 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N cleaned=Y restored=Y saveCalls=0 · Insert 행 추가 확인(그리드 행 1898 → 1899 · 화면
- ES-cd72403b [RULE_SCREEN] SCP0111 E2E authcrud 저장 왕복(editonly) jooyong026 | [측정 전제 미충족: 시험 행 저장 요청 없음(saveCalls=0)] 화면 검증·필수 칸에 막혔을 수 있음 · mode=insert save=Y insert=Y delete=Y editable=- inserted=Y saved=N found=N updated=N cleaned=Y restored=Y saveCalls=0 · Insert 행 추가 확인(그리드 행 1898 → 1899 · 화면

## 담당 집계 (3행)

### 집계 · 규칙 F1 · 1행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- V-7b04b710 [GENERAL] [SYS0004 결함 유형] Insert 저장 / Delete CRUD Status | 규칙 F1 판정 3행 중 FAIL 0 · 판정필요 0 · 미검증 2 — [ES-cd72403b] SCP0111 E2E authcrud 저장 왕복(editonly) jooyong026: [측정 전제 미충족: 시험 행 저장 요청 없음(saveCalls=0)] 화면 검증·필수 칸에 막혔을 수 있음 · mode=insert save=Y insert=Y delete=Y editable=- insert

### 집계 · 규칙 X-ROW · 2행
- 처리: 하위 행 판정을 따라감 · 하위 미검증이 풀리면 같이 풀림
- T-7f7f309f [TRACE] SCP0111_IntegrationPSI.BtnItemId_Click | 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1
- T-81c9a537 [TRACE] SCP0111_IntegrationPSI.BtnNickName_Click | 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1

