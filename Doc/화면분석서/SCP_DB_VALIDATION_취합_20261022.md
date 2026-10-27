# SCP 화면 DB(SP/PKG) VALIDATION 취합 — AS-IS 기준 + TO-BE 비교 (20261022)

상세 = `SCP_DB_VALIDATION_취합_20261022.xlsx` (시트 0~10). 원천·분류 정의·추출 한계 = 0_기준 시트.

## 1. 요약

| 지표 | 값 |
|---|---:|
| UI 수 | 125 |
| DB 호출 있는 UI | 125 |
| 판독 SP/단위 수 | 859 |
| 원문 없음 단위 | 21 |
| 검증 행(고유, SP 기준) | 2058 |
| 항목ID 수 | 1298 |
| 공통 항목(2개 UI 이상) | 118 |
| 분류 A | 641 |
| 분류 B | 490 |
| 분류 C | 811 |
| 분류 D | 116 |
| 도달성 실행 | 2058 |
| 비교 판정 TO-BE 미개발(매핑 대상 없음) | 1118 |
| 비교 판정 TO-BE 미개발(전환본 없음) | 360 |
| 비교 판정 TO-BE 미이관 | 22 |
| 비교 판정 TO-BE 추가 | 384 |
| 비교 판정 누락 | 9 |
| 비교 판정 일치 | 788 |
| 비교 판정 일치(AS-IS 추출누락 보충) | 27 |
| 비교 판정 차이 | 190 |
| 비교 판정 차이(AS-IS 추출누락 보충) | 3 |

## 2. UI별 검증 건수 (상위 30, 체인 전체 기준)

| UI | 판독 단위 | 직접 SP | 검증 행 | A | B | C | D |
|---|---:|---:|---:|---:|---:|---:|---:|
| SCP0015 | 291 | 7 | 1323 | 393 | 317 | 604 | 9 |
| SCP0113 | 36 | 19 | 108 | 15 | 33 | 59 | 1 |
| SCP0123 | 23 | 7 | 82 | 27 | 17 | 38 | 0 |
| SCP0104 | 15 | 6 | 57 | 8 | 23 | 26 | 0 |
| SCP0039 | 28 | 15 | 49 | 0 | 4 | 8 | 37 |
| SCP0049 | 29 | 21 | 40 | 5 | 8 | 24 | 3 |
| SCP0126 | 25 | 22 | 32 | 26 | 0 | 6 | 0 |
| SCP0125 | 16 | 12 | 29 | 6 | 13 | 10 | 0 |
| SCP0201 | 16 | 10 | 27 | 3 | 6 | 15 | 3 |
| SCP0099 | 18 | 14 | 25 | 12 | 7 | 5 | 1 |
| SCP0010 | 22 | 12 | 23 | 4 | 11 | 4 | 4 |
| SCP0013 | 33 | 15 | 22 | 4 | 6 | 7 | 5 |
| SCP0057 | 31 | 13 | 22 | 4 | 6 | 7 | 5 |
| SCP0078 | 19 | 9 | 21 | 6 | 5 | 1 | 9 |
| SCP0059 | 22 | 12 | 18 | 3 | 8 | 3 | 4 |
| SCP0007 | 12 | 5 | 17 | 4 | 2 | 5 | 6 |
| SCP0009 | 24 | 12 | 16 | 3 | 9 | 1 | 3 |
| SCP0024 | 17 | 8 | 15 | 3 | 7 | 5 | 0 |
| SCP0061 | 18 | 9 | 15 | 3 | 7 | 5 | 0 |
| SCP0001 | 18 | 8 | 14 | 9 | 3 | 0 | 2 |
| SCP0083 | 13 | 12 | 14 | 10 | 2 | 0 | 2 |
| SCP0020 | 17 | 8 | 13 | 7 | 0 | 2 | 4 |
| SCP0029 | 27 | 9 | 13 | 4 | 3 | 4 | 2 |
| SCP0032 | 1 | 1 | 13 | 0 | 0 | 0 | 13 |
| SCP0058 | 25 | 13 | 13 | 3 | 6 | 1 | 3 |
| SCP0006 | 17 | 7 | 11 | 2 | 2 | 1 | 6 |
| SCP0011 | 24 | 10 | 9 | 3 | 1 | 4 | 1 |
| SCP0022 | 14 | 6 | 9 | 5 | 1 | 3 | 0 |
| SCP0060 | 25 | 11 | 9 | 3 | 1 | 4 | 1 |
| SCP0092 | 21 | 15 | 9 | 2 | 3 | 1 | 3 |

## 3. 공통 항목 (2개 UI 이상, 상위 40)

| 항목ID | 유형 | 대상 | UI 수 | UI | 대표 설명 |
|---|---|---|---:|---|---|
| V1128 | REQUIRED | P:V_TIME_ZONE | 28 | SCP0009, SCP0010, SCP0013, SCP0024, SCP0025, SCP0039, SCP0045, SCP0049, SCP0052, | 타임존 코드가 NULL 이면 기본 타임존 AS054 로 대체 |
| V0303 | EXCEPTION | PR_SCM_SYS_LOG_BATCH | 25 | SCP0009, SCP0010, SCP0013, SCP0024, SCP0025, SCP0045, SCP0046, SCP0047, SCP0049, | 로그 INSERT 실패 시 롤백 후 오류 내용을 별도 트랜잭션으로 재기록 |
| V1095 | REQUIRED | P:P_FROM_DATE | 21 | SCP0009, SCP0010, SCP0013, SCP0024, SCP0025, SCP0045, SCP0046, SCP0057, SCP0058, | 시작일 미입력 시 사용자 타임존 기준 오늘로 대체 |
| V1096 | REQUIRED | P:P_OFFSET_DAY | 21 | SCP0009, SCP0010, SCP0013, SCP0024, SCP0025, SCP0045, SCP0046, SCP0057, SCP0058, | 오프셋 일수 미입력 시 6일로 대체 |
| V0581 | EXCEPTION | SCM_SYS_LOG_BATCH | 13 | SCP0011, SCP0015, SCP0050, SCP0060, SCP0069, SCP0078, SCP0083, SCP0095, SCP0096, | 일반 예외 시 F 와 오류번호/메시지 반환 |
| V0823 | FORMAT | P:WEEK | 13 | SCP0007, SCP0013, SCP0015, SCP0020, SCP0029, SCP0042, SCP0045, SCP0046, SCP0053, | 요일 코드가 SUN~SAT 이 아니면 NULL 반환(계산 중단) |
| V0174 | DUP | SCM_MST_PLANT | 11 | SCP0010, SCP0011, SCP0013, SCP0024, SCP0025, SCP0029, SCP0057, SCP0059, SCP0060, | JV Real SCM Site : ESS Virtual SCM Site 를 1:1 로 강제 — 복수 매핑 시 |
| V1450 | STATUS | SCM_MST_PLAN_DETAIL | 11 | SCP0009, SCP0010, SCP0011, SCP0013, SCP0015, SCP0029, SCP0057, SCP0058, SCP0059, | 현재 수행이 전극 FN 이면 Cutoff 의 RTF_SYS_RP 계열은 덮어쓰지 않음 |
| V0029 | CONSISTENCY | FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP | 8 | SCP0011, SCP0013, SCP0015, SCP0024, SCP0029, SCP0057, SCP0060, SCP0061 | JV 실 Plant 의 ESS 혼용 라인 계획은 본 사업부 전송에서 제외(가상 Plant 사업부 계획으로 별 |
| V0172 | DUP | SCM_MST_LINE | 8 | SCP0011, SCP0013, SCP0015, SCP0024, SCP0029, SCP0057, SCP0060, SCP0061 | JV Real Line : ESS Virtual Line 을 1:1 로 강제 — 한쪽에 복수 매핑이 있으면  |
| V1453 | STATUS | SCM_MST_PLAN_DETAIL.PLAN_STATUS | 8 | SCP0009, SCP0010, SCP0013, SCP0015, SCP0057, SCP0058, SCP0059, SCP0123 | 정상 완료된(PLAN_STATUS='1') 주간 계획 버전 중 최신 SEQ 만 시뮬레이션 대상으로 사용 |
| V1108 | REQUIRED | P:P_YYYYWW | 7 | SCP0011, SCP0013, SCP0015, SCP0029, SCP0039, SCP0057, SCP0060 | 주차 파라미터가 NULL 이면 현재 주차의 시작일을 반환 |
| V1449 | STATUS | SCM_MST_PLAN | 7 | SCP0013, SCP0024, SCP0025, SCP0057, SCP0061, SCP0062, SCP0113 | 확정(CONFIRM_FLAG='Y')·완료·UI 표시된 최신 FN 버전 생산계획만 P 로 사용 |
| V0596 | EXCEPTION | SCP_ANL_PRODUCTION_PLAN | 6 | SCP0011, SCP0013, SCP0015, SCP0029, SCP0057, SCP0060 | 생산계획 ANL 적재 중 예외 시 로그 후 -1 반환 |
| V0739 | EXISTS | SCP_MST_BOD | 6 | SCP0007, SCP0010, SCP0015, SCP0028, SCP0039, SCP0059 | AS PLANT→SALES(MKT_FCST 기반) FG 생성 시 유효 BOD 가 없으면 제외 |
| V1454 | STATUS | SCM_MST_PLAN_DETAIL.PLAN_TYPE | 6 | SCP0009, SCP0010, SCP0013, SCP0057, SCP0058, SCP0059 | 해당 주차 최상위 플랜이 조회 플랜과 같고 그것이 Final(FN)이면 저장 불가 |
| V0723 | EXISTS | SCM_MST_SITE_ITEM_PRIORITY | 5 | SCP0015, SCP0020, SCP0037, SCP0039, SCP0042 | [2-2] 지정 경로(SITE_ITEM_PRIORITY)에 등록된 외주 Site·Item 만 RACK/DC/ |
| V0731 | EXISTS | SCP_ANL_PRODUCTION_PLAN_FIX | 5 | SCP0013, SCP0024, SCP0029, SCP0057, SCP0061 | 입력 데이터셋 중 Fix 테이블에 존재하는 행만 FIX_ID·FIX_REASON 을 붙여 이력 기록 |
| V0992 | RANGE | PLAN_NAME | 5 | SCP0011, SCP0013, SCP0029, SCP0057, SCP0060 | 계획시작일이 이번 주(월요일) 이전이면 날짜체크 N |
| V1182 | REQUIRED | SCP_ANL_PRODUCTION_PLAN_FIX.FIX_ID | 5 | SCP0013, SCP0024, SCP0029, SCP0057, SCP0061 | 신규 행은 FIX_ID 를 'F'+일자+11자리 시퀀스로 채번 |
| V0005 | AUTH | SCM_ADM_LOOKUP_MASTER_DETAIL | 4 | SCP0039, SCP0091, SCP0092, SCP0123 | @Param3 그룹이 관리자 그룹 Lookup 에 있으면 ADMIN 으로 판정해 팀 단위 콤보 제한을 해제 |
| V0447 | EXCEPTION | SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | 4 | SCP0013, SCP0024, SCP0057, SCP0061 | 예외 시 F 결과코드와 오류번호·메시지 반환 |
| V0601 | EXCEPTION | SCP_ANL_SHIPMENT_PLAN_FIX | 4 | SCP0009, SCP0010, SCP0058, SCP0059 | 예외 시 로그 후 F 와 오류메시지 반환 |
| V0717 | EXISTS | SCM_MST_SITE | 4 | SCP0015, SCP0099, SCP0113, SCP0123 | From/To 사이트가 모두 PLANT 면 Y, 하나만 PLANT 면 N, PLANT 사이트가 없으면 센티널 |
| V0920 | QTY | SCP_ANL_PRODUCTION_PLAN.QTY | 4 | SCP0099, SCP0113, SCP0123, SCP0125 | 0 이하 생산계획 수량은 PSI 에서 제외 |
| V1186 | REQUIRED | SCP_ANL_SHIPMENT_PLAN_FIX.FIX_ID | 4 | SCP0009, SCP0010, SCP0058, SCP0059 | UI 플래그와 무관하게 FIX 존재여부로 입력/수정 모드를 재판정하고 신규는 FIX_ID 채번 |
| V0015 | AUTH | TB_FX_GROUPMENUAUTH.BASICACLR | 3 | SCP0039, SCP0091, SCP0123 | 사용자 그룹(@GroupID, UseYN='Y')의 메뉴 권한 중 Read·Modify 가 모두 0 인 메뉴 |
| V0200 | DUP | SCP_MST_MODEL_ALLOCATION | 3 | SCP0015, SCP0046, SCP0123 | 모델 Allocation 이 중복(2건 이상)인 경우 공급 사이트를 우선순위 1 사이트로 대체 |
| V0302 | EXCEPTION | PR_SCM_MST_SITE_ITEM_HIST | 3 | SCP0006, SCP0027, SCP0048 | 이력 적재 오류 시 오류 로그만 남기고 커밋 |
| V0446 | EXCEPTION | SCP0024_SAVE_PRODUCTION_PLAN_FIX | 3 | SCP0024, SCP0029, SCP0061 | 예외 시 F 결과코드와 오류번호·메시지 1결과셋 반환 |
| V0688 | EXISTS | SCM_ADM_LOOKUP_MASTER_DETAIL | 3 | SCP0015, SCP0092, SCP0113 | GSCM 관리 대상 통화(KRW 기준, 룩업 유효 통화)만 환율 Cutoff 에 저장 |
| V0703 | EXISTS | SCM_MST_ITEM | 3 | SCP0006, SCP0015, SCP0099 | BOM 트리 전개 시 활성 Item 마스터에 존재하는 parent 만 포함 |
| V0704 | EXISTS | SCM_MST_ITEM.ITEM_ID | 3 | SCP0015, SCP0113, SCP0130 | 품목 마스터에 존재하는 품목만 Sales Plan 수량·금액 재생성 대상으로 사용 |
| V1171 | REQUIRED | SCM_MST_SITE_ITEM_PRIORITY.PRIORITY_SEQ | 3 | SCP0006, SCP0027, SCP0048 | Priority Seq 미입력(신규 행)이면 시퀀스로 채번 |
| V1352 | STATUS | PLAN_TYPE | 3 | SCP0013, SCP0029, SCP0057 | MA 는 확정(Y)·당주 이후, SE·PR 은 당주 이후일 때만 편집 가능, FN 및 과거 플랜은 불가 |
| V1447 | STATUS | SCM_MST_ITEM_LINE_ASSIGN.PRIORITY | 3 | SCP0015, SCP0049, SCP0201 | Line Assign 우선순위 0/9(미사용 라인) 구간은 Capa 미사용 처리 |
| V0001 | AUTH | CAPA_UI_LOSS_TYPE_DEFINIT.SEGMENT1 | 2 | SCP0049, SCP0201 | 권한이 Admin/SCP Planner/SCM PI Admin 이 아닌 사용자는 형교환 CAPA(XC031) |
| V0007 | AUTH | SCM_MASTER_MANAGER_M.USER_ID_1 | 2 | SCP0049, SCP0201 | Excel 조회 시 SCM PI Admin 이 아니면 본인이 담당자(USER_ID_1~10)로 등록된 기준정 |
| V0037 | CONSISTENCY | P:P_CHECK_LINE | 2 | SCP0049, SCP0201 | Needed(빈값) 조회 선택 시 Line Assign 데이터가 반드시 함께 조회되도록 체크값 자동 보정 |
| V0039 | CONSISTENCY | P:SCP0013 | 2 | SCP0013, SCP0057 | JV Real 라인은 ESS 가상 라인에서만 동기화되는 단방향 규칙이라, 화면에서 JV Real 라인을 직접 |

## 4. AS-IS↔TO-BE 비교 판정 분포

| 판정 | 행 |
|---|---:|
| TO-BE 미개발(매핑 대상 없음) | 1118 |
| TO-BE 미개발(전환본 없음) | 360 |
| TO-BE 미이관 | 22 |
| TO-BE 추가 | 384 |
| 누락 | 9 |
| 일치 | 788 |
| 일치(AS-IS 추출누락 보충) | 27 |
| 차이 | 190 |
| 차이(AS-IS 추출누락 보충) | 3 |

## 5. 추출 한계

- 판독은 SP 본문 전량 Read(56 배치·병렬 판독, 각 배치 단위 전원 summary·줄수 일치 기계 점검) — 단 판정(분류·도달성)은 판독자 판단이며, 배치 간 경계 사례(업무 범위 필터 vs C, 계산 보정 vs B) 기준 차이가 남을 수 있음(각 행 note 참조)
- 반복 검사 표기 단위가 배치마다 다름 — 일부는 위치마다 1행, 일부는 대표 1행 + note 에 라인 나열. 건수는 "검증 행" 기준이며 고유 규칙 수와 다를 수 있음
- 항목ID 묶음은 대상 객체명 기반 기계 정규화 — 같은 의미라도 대상 표기가 다르면 다른 항목, 같은 테이블의 다른 의미 검증이 한 항목에 묶일 수 있음(설명 변형 컬럼 참조)
- 원문 없음 단위(덤프 미존재: 타 DB ENG_SCP·시스템 SP·폐기 SP)는 판독 불가 — 8_제외근거 시트
- AS-IS 덤프는 DEV(2026-10-16) — 운영 원문과 다를 수 있음(판독 중 DEV 전용 임시 로직 발견 사례 note 기재)
- BIZ CommonData 공통 콤보(FP_Common.UI_FP_COMMON)·update-batch 는 검증 아님으로 제외(8_제외근거). FE/C# 측 검증(validation.md)은 범위 밖
- TO-BE 비교 판독 중 대형 블록 일부를 반복 컬럼 나열(QTY001~364 등) 접기·키워드 필터로 확인한 쌍 28개 / 전체 646개 (판정 근거는 각 쌍 read_note) · 표본검수 350건 정확도 약 91%(NG 대부분 과다기록 → 기준 통일 재판정으로 정리) · 사업부(division) 컬럼은 판독자 표기(일부 SP 명 접미 기준)
