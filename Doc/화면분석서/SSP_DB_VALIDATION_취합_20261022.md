# SSP 화면 DB(SP/PKG) VALIDATION 취합 — AS-IS 기준 + TO-BE 비교 (20261022)

상세 = `SSP_DB_VALIDATION_취합_20261022.xlsx` (시트 0~10). 원천·분류 정의·추출 한계 = 0_기준 시트.

## 1. 요약

| 지표 | 값 |
|---|---:|
| UI 수 | 39 |
| DB 호출 있는 UI | 38 |
| 판독 SP/단위 수 | 355 |
| 원문 없음 단위 | 22 |
| 검증 행(고유, SP 기준) | 464 |
| 항목ID 수 | 254 |
| 공통 항목(2개 UI 이상) | 101 |
| 분류 A | 154 |
| 분류 B | 126 |
| 분류 C | 129 |
| 분류 D | 55 |
| 도달성 실행 | 464 |
| 비교 판정 TO-BE 미개발(매핑 대상 없음) | 133 |
| 비교 판정 TO-BE 추가 | 218 |
| 비교 판정 누락 | 14 |
| 비교 판정 일치 | 728 |
| 비교 판정 일치(AS-IS 추출누락 보충) | 18 |
| 비교 판정 차이 | 164 |
| 비교 판정 차이(AS-IS 추출누락 보충) | 2 |

## 2. UI별 검증 건수 (상위 30, 체인 전체 기준)

| UI | 판독 단위 | 직접 SP | 검증 행 | A | B | C | D |
|---|---:|---:|---:|---:|---:|---:|---:|
| SSP0015 | 72 | 38 | 113 | 33 | 27 | 45 | 8 |
| SSP0060 | 69 | 30 | 113 | 32 | 28 | 45 | 8 |
| SSP0027 | 59 | 22 | 103 | 32 | 30 | 35 | 6 |
| SSP0003 | 51 | 15 | 86 | 22 | 29 | 31 | 4 |
| SSP0021 | 60 | 23 | 84 | 25 | 20 | 34 | 5 |
| SSP0029 | 64 | 32 | 79 | 23 | 18 | 31 | 7 |
| SSP0200 | 49 | 19 | 76 | 25 | 28 | 19 | 4 |
| SSP0023 | 46 | 18 | 74 | 24 | 19 | 27 | 4 |
| SSP0013 | 40 | 11 | 73 | 20 | 20 | 29 | 4 |
| SSP0202 | 37 | 9 | 52 | 16 | 13 | 21 | 2 |
| SSP0201 | 37 | 12 | 43 | 17 | 14 | 7 | 5 |
| SSP0002 | 36 | 11 | 39 | 13 | 16 | 7 | 3 |
| SSP0026 | 28 | 18 | 18 | 9 | 0 | 6 | 3 |
| SSP0022 | 23 | 14 | 15 | 2 | 4 | 5 | 4 |
| SSP0045 | 13 | 5 | 10 | 3 | 5 | 2 | 0 |
| SSP0046 | 29 | 18 | 10 | 4 | 2 | 4 | 0 |
| SSP0001 | 19 | 7 | 7 | 3 | 4 | 0 | 0 |
| SSP0008 | 21 | 9 | 7 | 1 | 6 | 0 | 0 |
| SSP0007 | 21 | 11 | 6 | 2 | 4 | 0 | 0 |
| SSP0010 | 16 | 7 | 6 | 2 | 4 | 0 | 0 |
| SSP0030 | 9 | 5 | 5 | 0 | 4 | 0 | 1 |
| SSP0009 | 15 | 8 | 4 | 1 | 3 | 0 | 0 |
| SSP0016 | 11 | 7 | 4 | 2 | 2 | 0 | 0 |
| SSP0018 | 10 | 6 | 4 | 1 | 3 | 0 | 0 |
| SSP0005 | 7 | 4 | 3 | 1 | 2 | 0 | 0 |
| SSP0006 | 15 | 9 | 3 | 0 | 3 | 0 | 0 |
| SSP0011 | 11 | 6 | 3 | 0 | 3 | 0 | 0 |
| SSP0012 | 6 | 2 | 3 | 0 | 3 | 0 | 0 |
| SSP0017 | 7 | 3 | 3 | 0 | 3 | 0 | 0 |
| SSP0020 | 6 | 4 | 3 | 2 | 0 | 1 | 0 |

## 3. 공통 항목 (2개 UI 이상, 상위 40)

| 항목ID | 유형 | 대상 | UI 수 | UI | 대표 설명 |
|---|---|---|---:|---|---|
| V1128 | REQUIRED | P:V_TIME_ZONE | 26 | SSP0001, SSP0002, SSP0003, SSP0005, SSP0006, SSP0007, SSP0008, SSP0009, SSP0010, | 타임존 코드가 NULL 이면 기본 타임존 AS054 로 대체 |
| V1095 | REQUIRED | P:P_FROM_DATE | 21 | SSP0001, SSP0002, SSP0003, SSP0005, SSP0006, SSP0007, SSP0008, SSP0009, SSP0010, | 시작일 미입력 시 사용자 타임존 기준 오늘로 대체 |
| V1096 | REQUIRED | P:P_OFFSET_DAY | 20 | SSP0001, SSP0002, SSP0003, SSP0006, SSP0007, SSP0008, SSP0009, SSP0010, SSP0011, | 오프셋 일수 미입력 시 6일로 대체 |
| V0741 | EXISTS | SCP_MST_BOD_N | 17 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0016, SSP0021, SSP0022, SSP0023, SSP0026, | BOD/항차 정보로 ETA 를 산출하지 못하면 입력 출하일을 ETA 로 대체 |
| V0581 | EXCEPTION | SCM_SYS_LOG_BATCH | 15 | SSP0001, SSP0002, SSP0003, SSP0007, SSP0013, SSP0015, SSP0021, SSP0023, SSP0026, | 오류 시 로그 후 F 반환 |
| V0823 | FORMAT | P:WEEK | 15 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0026, SSP0027, SSP0029, | 요일 코드가 SUN~SAT 이 아니면 NULL 반환(계산 중단) |
| V0663 | EXCEPTION | TX_SH | 13 | SSP0001, SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, | 예외 시 롤백·로그 후 -1 |
| V1509 | STATUS | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.VALID_YN | 12 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | 변경요청 상세 중 유효(VALID_YN='Y') 행만 ERP 전송 |
| V0038 | CONSISTENCY | P:P_DIVISION_ID | 11 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0022, SSP0023, SSP0027, SSP0029, SSP0060, | 40(소형) 사업부가 아니면 동기화 없이 종료 |
| V0937 | QTY | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.NEW_QTY | 11 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | 신규확정(A) 전송 시 수량 0 인 행 제외 |
| V1503 | STATUS | SSP_ANL_SHIP_CONFIRM.SHIPMENT_STATUS | 11 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 확정(C) 상태·확정 변경유형 건만 동기화 |
| V0024 | CONSISTENCY | DM_PLN_MKT_FCST | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 이전 동기화 흔적이 있으면 원 MKT FCST 수량으로 원복 후 재동기화 |
| V0025 | CONSISTENCY | DM_PLN_MKT_FCST_CONFIRM.PLAN_QTY | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 출하실적이 있는 SO 는 확정 계획수량을 출하실적으로 보정 |
| V0096 | CONSISTENCY | SSP_ANL_SHIP_CONFIRM.BIZ_TYPE | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | Pack 등 BIZ_TYPE 'A' 외 건은 동기화 제외 |
| V0152 | DUP | DM_PLN_MKT_FCST | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | SYNC 반복 실행 시 캐리오버 수량이 중복 가산되지 않도록 보정 |
| V0274 | DUP | T_MKT_RESULT.CONFIRM_ID | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 일반 동기화에 포함된 CONFIRM_ID 는 캐리오버에서 제외(중복 반영 방지) |
| V0284 | EXCEPTION | PR_DM_SSP_CONFIRM_SYNC | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 오류 시 롤백 후 로그만 기록 |
| V0635 | EXCEPTION | SSP_ANL_SHIP_CONFIRM_ROUTE | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 예외 시 -1 반환 |
| V0669 | EXISTS | DM_MST_ITEM_SINGLE.FORECAST_INFO_BIZ_TYPE | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 품목 마스터에 없거나 FORECAST_INFO_BIZ_TYPE 이 없는(전극) 품목은 동기화 제외 |
| V0671 | EXISTS | DM_PLN_MKT_FCST.INCOTERMS | 10 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | 정확한 키로 MKT FCST INCOTERMS 를 못 찾으면 From/To 사이트 기준 첫 INCOTERMS |
| V0672 | EXISTS | DM_PLN_MKT_FCST_CONFIRM.SALES_RESULT_QTY | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | SO 번호로 매출실적을 못 찾은 확정건은 CONFIRM_ID 기준 실적으로 대체 |
| V0700 | EXISTS | SCM_MST_DIVISION | 10 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | 사업부 마스터에 존재하는 사업부 건만 전송(전송 사업부코드는 ATTRIBUTE3 로 변환) |
| V0720 | EXISTS | SCM_MST_SITE.VMI_YN | 10 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | 사이트가 없거나 VMI 여부가 비어 있으면 'N' 으로 간주 |
| V0840 | FORMAT | XIF_ERP_SHIP_PLAN_CONFIRM_S.CHANGE_CODE | 10 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | 변경사유코드가 화면 기본값 'Select' 이면 NULL 로 전송 |
| V0879 | QTY | DM_PLN_MKT_FCST_CONFIRM | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 매출실적이 이미 있는 확정건과 당주 이전 ETA 건은 MKT FCST 동기화 제외(네팅) |
| V0880 | QTY | DM_PLN_MKT_FCST_RESULT.QTY | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 수량 0 인 매출실적은 SO 분해·매출실적 반영 대상에서 제외 |
| V0936 | QTY | SSP_ANL_SHIP_CONFIRM.QTY | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 전극(BIZ_TYPE E) 확정·요청 출하 중 음수 수량은 FP 타겟에서 제외 |
| V0970 | RANGE | PR_DM_SSP_CONFIRM_SYNC | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 운영 DB 에서는 월요일 07:50~23:55 사이에만 MKT FCST 동기화 수행 |
| V1069 | REQUIRED | DM_PLN_MKT_FCST_RESULT.SO_QTY | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | SO 수량 분해값이 빈 행은 매출실적 반영 제외 |
| V1141 | REQUIRED | SCM_ADM_LOOKUP_MASTER_DETAIL | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 동기화 일수 룩업이 없거나 1 미만이면 동기화 중단 |
| V1256 | REQUIRED | SSP_ANL_SHIP_CONFIRM.FCST_TYPE | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | FCST Type 미지정('-') 확정 출하는 동기화 제외 |
| V1263 | REQUIRED | SSP_ANL_SHIP_CONFIRM_ROUTE.ROUTE_ID | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | Route ID 가 없으면 확정건의 BOD 기본 Route 로 보정 |
| V1318 | REQUIRED | XIF_ERP_SHIP_PLAN_CONFIRM_S.PROJECT_CODE | 10 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | ERP I/F 전송 시 프로젝트코드 미지정이면 TBD 로 대체 |
| V1430 | STATUS | SCM_DNM_EXFACTORY_RESULT | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | DO 삭제/생성 단계, 미등록 공정, ZKM/ZKN 오더유형 출하실적은 반영 제외 |
| V1501 | STATUS | SSP_ANL_SHIP_CONFIRM.ERP_STATUS | 10 | SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, SSP0200, | 전극(E): PO 생성(ERP_STATUS A/D) 건의 확정수량 변경 시에만 모델 PIC 에게 메일 |
| V1505 | STATUS | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.ATTRIBUTE1 | 10 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060, | 변경 Reject(D) 는 ATTRIBUTE1='Y' 로 표시된 기존 확정건만 전송하고 전송 후 플래그를 해 |
| V1508 | STATUS | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.NEW_YN | 9 | SSP0002, SSP0003, SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060 | 변경요청(C) 전송은 기존 확정건(NEW_YN='N')의 OLD 값만 대상 |
| V0098 | CONSISTENCY | SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE | 7 | SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060 | 실제 변경(일자/수량/운송모드)이 없는 행은 메일에서 제외 |
| V0137 | COUNT | SSP_ANL_SHIP_CONFIRM | 7 | SSP0003, SSP0015, SSP0021, SSP0023, SSP0027, SSP0060, SSP0200 | 삭제 처리 후 해당 변경요청에 연결된 Confirm 원장이 하나도 남지 않으면 'X' 반환 |
| V0140 | COUNT | TBLSSPADJUSTMAILSEND | 7 | SSP0013, SSP0015, SSP0021, SSP0023, SSP0027, SSP0029, SSP0060 | 메일 대상이 0건이면 발송 없이 종료 |

## 4. AS-IS↔TO-BE 비교 판정 분포

| 판정 | 행 |
|---|---:|
| TO-BE 미개발(매핑 대상 없음) | 133 |
| TO-BE 추가 | 218 |
| 누락 | 14 |
| 일치 | 728 |
| 일치(AS-IS 추출누락 보충) | 18 |
| 차이 | 164 |
| 차이(AS-IS 추출누락 보충) | 2 |

## 5. 추출 한계

- 판독은 SP 본문 전량 Read(56 배치·병렬 판독, 각 배치 단위 전원 summary·줄수 일치 기계 점검) — 단 판정(분류·도달성)은 판독자 판단이며, 배치 간 경계 사례(업무 범위 필터 vs C, 계산 보정 vs B) 기준 차이가 남을 수 있음(각 행 note 참조)
- 반복 검사 표기 단위가 배치마다 다름 — 일부는 위치마다 1행, 일부는 대표 1행 + note 에 라인 나열. 건수는 "검증 행" 기준이며 고유 규칙 수와 다를 수 있음
- 항목ID 묶음은 대상 객체명 기반 기계 정규화 — 같은 의미라도 대상 표기가 다르면 다른 항목, 같은 테이블의 다른 의미 검증이 한 항목에 묶일 수 있음(설명 변형 컬럼 참조)
- 원문 없음 단위(덤프 미존재: 타 DB ENG_SCP·시스템 SP·폐기 SP)는 판독 불가 — 8_제외근거 시트
- AS-IS 덤프는 DEV(2026-10-16) — 운영 원문과 다를 수 있음(판독 중 DEV 전용 임시 로직 발견 사례 note 기재)
- BIZ CommonData 공통 콤보(FP_Common.UI_FP_COMMON)·update-batch 는 검증 아님으로 제외(8_제외근거). FE/C# 측 검증(validation.md)은 범위 밖
- TO-BE 비교 판독 중 대형 블록 일부를 반복 컬럼 나열(QTY001~364 등) 접기·키워드 필터로 확인한 쌍 28개 / 전체 646개 (판정 근거는 각 쌍 read_note) · 표본검수 350건 정확도 약 91%(NG 대부분 과다기록 → 기준 통일 재판정으로 정리) · 사업부(division) 컬럼은 판독자 표기(일부 SP 명 접미 기준)
