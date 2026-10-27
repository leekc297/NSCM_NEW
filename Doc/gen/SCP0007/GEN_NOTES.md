# GEN_NOTES — SCP0007 BOD (TobeGen 2026-10-26)

생성 대상: `features/supply/src/pages/bod/` (To-Be 메뉴 메타 확정: 상위 Supply_Master, MNU_URL bod, USE_YN=Y)
As-is grid_mode: HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경) · 시트 2 (+팝업 0) · 조회조건 8 · 버튼 0 · 이벤트 11 · 엔드포인트 7

## 기계가 끝낸 것 (손대지 말 것 — 사전 규칙)
- constants(MENU_ID/SHEETS/RESPONSE_SET/DIVISION), store(검색 파라미터·메타 컬럼·저장 조회조건), Page 조합, Form 필드 8개, Grid(DataGrid + HARD_COLUMNS), __asis-mapping__.md 초기본, register.json, 단위테스트 it.todo 56건

## Claude Code 가 채울 것 (TODO(이식) 표시 지점만)
1. 라벨 코드: 자동 매칭 8/8 (To-Be 코드 사용 빈도 사전 rules/lbl_codes.csv). 미확정 `LBL?????` 0곳: 없음 → 메시지 마스터(SCM_ADM_MSG_M) 조회 후 코드 기입, 없으면 신규 채번 요청. Doc/tobefacts/db/msg_master.csv 가 있으면 생성기가 자동 조회
2. 콤보ID 8개: clbDivision→'Div', clbFromSite→'FromSite', clbToSite→'ToSite', clbIncoterms→'Incoterms', clbIncotermsSSP→'SSPIncoterms', clbTransMode→'TransMode', cboInputStatus→'Status', cboValidYN→'Active' — As-is 소스는 Fact Pack endpoints 의 UP_FX_GetCommonDataList_* / meta_reads 참조
3. 이벤트 핸들러 로직 10개 (flow.csv 의 호출 체인 그대로)
4. 팝업/모달: 없음 · As-is 팝업 클래스 SCP0007_DistributionRoutePopup → components/modals/
5. 스프레드 1개 → spdMain→Grid(BOD/Distribution Route)
6. division 변형: 40, 81, 82, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC — grid_effective 의 division 열이 비어있지 않은 컬럼은 표시 조건 분기
7. 검증/표현식: hooks/useBodValidation.ts V-마커 8건(+팝업 0) · useBodExpression.ts E-마커 15건 — apply 본문 채우기 (마커 수 = validation.md 행 수, 게이트 V01)
8. register.json → P_REGISTER_SCREEN (클라우드) → `pnpm gen:procedures` → procedures.d.ts 반영 후 타입 느슨 구간 제거
9. 동적 헤더(기간 컬럼): 없음
10. 메시지 ID: AS-IS ID 를 그대로 쓰지 않는다(같은 ID 가 TO-BE 에서 다른 문구) — 문구로 찾은 TO-BE ID 를 쓴다(Doc/gen/SCP0007/msg_map.json). MSG00043→MSG00043, MSG00006→MSG00003, MSG00165→MSG00165, MSG00219→MSG01230, MSG00355→MSG01349, MSG00253→MSG01263, MSG00004→MSG00672. 이벤트·SP 결과 메시지 등 검증 표 밖에서 쓰는 AS-IS MSG 도 같은 방법으로 찾는다
11. VALIDATION 취합 대조(SCP·SSP — 2026-10-23): Doc/화면분석서/SCP_화면_VALIDATION_취합_20261022/SCP0007.md (차단 21행 · 보정_필터 21행 · 제외 3행) — TO-BE 적용여부: 미적용 2 · 적용 19 / 적용 TAG: [판정 결과 차이] 6 · [메시지 불일치] 5 · [AS-IS 결함 교정] 2 · [예외 전파 변경] 1. 차단 시트의 이 화면 행 = 검증 이식 체크리스트(validation.md 와 합집합) — 미적용 행 이식 · [메시지 불일치]/[메시지 미등록] 행은 '(참고) 메시지 의미 대조' 의 같은 의미 ID 로 · [판정 결과 차이] 행은 '[적용 TAG 사유]' 확인 · [AS-IS 결함 교정] 은 되돌리지 않음 · DB 행은 PKG 이식(port_pkg.md 3-2). 판정 기준 = Doc/화면분석서/SCP_화면_VALIDATION_취합_20261022.md "작성기준" (prompts/new_screen.md 6-2, 게이트 VR1·VR2)
12. 조회조건 기준표(SCP·SSP — 2026-10-23, 참고자료 tools/VibeManager/rules/40_SEARCH_COND.md `#### SCP0007`): SCP 기준표 BOD(SCP_화면별 조회조건 정리_260731_v0.5.xlsx 44~51행) — 적용 8 · 제외 0 · 통합 0 · 검토중 0 · 기준표에 없음 0 · AS-IS 컨트롤 없음 0. 순서는 정렬원칙 RULE로 **이미 재배치됨** — 손으로 바꾸지 말 것(게이트 SC1)
   - 명칭 변경: 'Valid' → 'Active' (LBL00007)
   - 명칭 변경: ' To Country' → 'Status' (LBL00014)
   - Div: ALL 버튼(다중)
   - SSP Incoterms: ALL 버튼(다중) · Div. 변경 시 값 유지
   - Trans Mode: ALL 버튼(다중) · Div. 변경 시 값 유지
   - Incoterms: ALL 버튼(다중) · Div. 변경 시 값 유지
   - To Site: ALL 버튼(다중)
   - From Site: ALL 버튼(다중)
   - Active: Div. 변경 시 값 유지
   - Status: Div. 변경 시 값 유지


## 사전에 없던 것 (룰 보완 후보 — rules/*.csv 에 추가)
- 없음

