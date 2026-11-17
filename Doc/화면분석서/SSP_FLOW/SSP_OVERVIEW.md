# SSP 한눈에 보기 · 2026-11-16 18:43 생성

> 원천: ① `Standard Information SSP Manual 1.pptx`(기준정보 Master Flow 1장 · 화면 매뉴얼 10장) ② `SSP 프로세스 확인 내용.pptx`(2026-11-16 판 · 배치 9장) ③ 운영 잡 목록 `SCP_SSP_Batch List_261103.xlsx` ④ TO-BE `menu.csv` · AS-IS 화면 SP(endpoints) · SP 본문. 사본 `Doc/asisfacts/ref_ssp/src/` · 구조화 `manual_*.csv` · 생성기 `tools/Analysis/ssp_master.py`
> 전체 순서는 이 탭에서, 상세는 뒤 탭에서 본다. 업무 프로세스 탭에 PI 22 Seq, 통합테스트, 운영 잡, 배치 입출력이 있다. Shipment Plan 산출 흐름 탭에 사업부별 계산 순서, 화면별 상세 탭에 화면 → SP → 테이블이 있다.

## 1. 기준정보 → 출하계획 순서(SSP Manual Master Flow)

- 출처: Standard Information SSP Manual 1.pptx 1번 슬라이드. 단계 10, 연결선 9(도형 끝점 대조). 카드 색은 상자 채움 색과 가장 가까운 범례 색(5개 범례)

<div class="spf "><div class="spf-row"><div class="spf-card " style="--c:#b7860b"><div class="spf-h">1. Sales Site</div><ul><li>도착 도시</li><li>TO-BE DMF0004 Sales Site</li><li>담당: 마케팅팀</li><li>Key Point: Sales Site 필수 속성 관리, MKT FCST에 영향</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#b7860b"><div class="spf-h">2. Sales Site Project Model</div><ul><li>TO-BE DMF0005 Sales Site Project Model</li><li>담당: 마케팅팀</li><li>Key Point: Sales Site와 Project Model 매핑 관리, MKT FCST 입력에 사용할 직접적인 기준정보</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#b7860b"><div class="spf-h">3. Sales Price</div><ul><li>TO-BE DMF0020 Sales Price</li><li>담당: 마케팅팀</li><li>Key Point: Currency별 환율을 관리하고 Sales Plan 값의 생성의 기초가 되는 Master</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#b7860b"><div class="spf-h">4. MKT FCST</div><ul><li>도착지 설정</li><li>TO-BE DMF0003 MKT FCST</li><li>담당: 마케팅팀</li><li>Key Point: 신규 MKT FCST를 추가 입력이 가능함</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#c0602a"><div class="spf-h">5. Plant Site</div><ul><li>생산 도시</li><li>TO-BE SCP0001 Plant Site</li><li>담당: SCP PI</li><li>Key Point: 생산 Site가 신규로 생성되면은 반드시 본 화면에서 추가되어야 Project Route가 등록 가능함</li></ul></div></div><div class="spf-snake" style="--n:5"><i></i><u></u></div><div class="spf-row"><div class="spf-card " style="--c:#4e8f4a"><div class="spf-h">6. Project Route</div><ul><li>생산지 설정</li><li>TO-BE SCP0006 Project Route</li><li>담당: SCM팀</li><li>Key Point: Plant/Item 0/2 이면은 2개 등록을 하여야 하는데 0개만 등록된 것으로 미등록을 의미하고 BOM Not Exist는 BOM 미등록되어 있음을 의미함</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#3a6ea5"><div class="spf-h">7. Distribution Route</div><ul><li>출발도시/도착도시/ 운송수단/항차/LT</li><li>TO-BE SCP0005 Distribution Route</li><li>담당: 물류기획팀</li><li>Key Point: 물류 운송을 위한 Route 관리로서 생산/출하 Target를 생성하기 위하여 반드시 관리되어야 하며, 본 Route를 기준으로 우선 순위가 가장 높은 기준으로 BOD 관리하며, Lead Time를 감안하여 생산/출하 Target를 생성함</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#3a6ea5"><div class="spf-h">8. BOD</div><ul><li>생산 Site, 도착 Site, 운송수단, 인코텀즈</li><li>TO-BE SCP0007 BOD</li><li>담당: 물류기획팀</li><li>Key Point: Planning시에 BOD를 기준으로 생산/출하 Target를 생성함으로 사전에 먼저 확인하고 없을 것을 등록 후 Planning을 하여야 함</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#5b6770"><div class="spf-h">9. BOD ITEM</div><ul><li>Item별 BOD</li><li>TO-BE SCP0030 BOD ITEM</li><li>담당: 시스템 자동</li><li>Key Point: 모델 별 BOD 기준정보를 등록 관리 할 수 있는 화면</li><li>자동 생성: PR_SCP_MST_BOD_ITEM (매일 00:30~23:59:59 30분마다)</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#7b52b8"><div class="spf-h">10. SSP Shipment Plan</div><ul><li>TO-BE SSP0015 Shipment Plan(Mobility &amp; IT), SSP0023 Shipment Plan(Electrode), SSP0060 Shipment Plan(Auto &amp; ESS)-WA_UC, SSP0021 Shipment Plan(Auto &amp; ESS)</li><li>담당: 범례 없음</li></ul></div></div><div class="spf-leg"><span style="--c:#3a6ea5"><i></i>물류기획팀</span><span style="--c:#b7860b"><i></i>마케팅팀</span><span style="--c:#4e8f4a"><i></i>SCM팀</span><span style="--c:#c0602a"><i></i>SCP PI</span><span style="--c:#5b6770"><i></i>시스템 자동</span><span style="--c:#7b52b8"><i></i>담당 표시 없음</span></div></div>

<div class="spf "><div class="spf-note" style="--c:#c0602a"><b class="t">Manual 메모(원문)</b><b>Shipment Change Request의 New로 입력 필요 시</b><span>BOD 등록이 필수 임</span><span>From /To 신규 등록 건(Status : Required)에 대해서</span><span>물류기획팀에서 BOD를 등록 완료(Status : Completed) 가능</span></div></div>

- 연결선 9개 중 번호 순서(n → n+1)인 선 9개

| 단계 | 담당(채움 색 → 범례) | 매뉴얼 장 | TO-BE 화면 | 화면 판정 규칙 | AS-IS 화면 SP 수(출처별) |
|---|---|---|---|---|---|
| 1. Sales Site | 마케팅팀 관리 (FFC000, 색 거리 0) | 2 | DMF0004 Sales Site | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 13 (endpoints 11, actions 0, 매트릭스 13) |
| 2. Sales Site Project Model | 마케팅팀 관리 (FFC000, 색 거리 0) | 3 | DMF0005 Sales Site Project Model | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 19 (endpoints 9, actions 0, 매트릭스 19, 주석 호출 제외 2) |
| 3. Sales Price | 마케팅팀 관리 (FFC000, 색 거리 0) | 4 | DMF0020 Sales Price | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 41 (endpoints 31, actions 0, 매트릭스 39, 주석 호출 제외 2) |
| 4. MKT FCST | 마케팅팀 관리 (FFC000, 색 거리 0) | 5, 6 | DMF0003 MKT FCST | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 53 (endpoints 30, actions 0, 매트릭스 52, 주석 호출 제외 1) |
| 5. Plant Site | SCP PI 관리 (ED7D31, 색 거리 0) | 7 | SCP0001 Plant Site | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 8 (endpoints 8, actions 0, 매트릭스 8) |
| 6. Project Route | SCM팀 관리 (70AD47, 색 거리 0) | 8 | SCP0006 Project Route | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 14 (endpoints 0, actions 6, 매트릭스 8) |
| 7. Distribution Route | 물류기획팀 관리 (4472C4, 색 거리 50) | 9 | SCP0005 Distribution Route | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 5 (endpoints 5, actions 0, 매트릭스 4) |
| 8. BOD | 물류기획팀 관리 (4472C4, 색 거리 50) | 10 | SCP0007 BOD | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 5 (endpoints 5, actions 0, 매트릭스 4) |
| 9. BOD ITEM | 시스템 자동 설정 (44546A, 색 거리 0) | 11 | SCP0030 BOD ITEM | menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름 | 8 (endpoints 5, actions 0, 매트릭스 8) |
| 10. SSP Shipment Plan | - (채움 없음, 색 거리 -) | - | SSP0015 Shipment Plan(Mobility & IT), SSP0023 Shipment Plan(Electrode), SSP0060 Shipment Plan(Auto & ESS)-WA_UC, SSP0021 Shipment Plan(Auto & ESS) | TO-BE Shipping_Schedule 메뉴 중 이름이 'Shipment Plan('으로 시작하는 화면 | 127 (endpoints 107, actions 0, 매트릭스 127, 주석 호출 제외 4) |

### 1-1. 단계 화살표 검증(AS-IS SP 본문)

- 화살표 A → B 마다 A 화면 SP(시스템 자동 단계는 생성 배치)가 쓰는 테이블을 B 화면 SP 가 읽는지 대조함. 이력(_H), 로그 표 제외. 중첩 호출 깊이 3

| 화살표 | A 가 쓰고 B 가 읽는 테이블 | 판정 |
|---|---|---|
| 1. Sales Site → 2. Sales Site Project Model | DM_MST_BUCKET_CONVERSION, SCM_MST_SITE, SCM_MST_SITE_CUSTOMER | 데이터 연결 있음 |
| 2. Sales Site Project Model → 3. Sales Price | DM_PLN_MKT_FCST, SCM_MST_SITE_ITEM | 데이터 연결 있음 |
| 3. Sales Price → 4. MKT FCST | DM_MST_EXCHANGE_RATE, DM_MST_VERSION, DM_PLN_CFM_MKT_DEMAND_PLAN, DM_PLN_CFM_SELLING_PRICE, DM_PLN_SALES_ETC_PLAN, DM_PLN_SALES_PLAN, DM_PLN_SALES_PLAN_RESULT, SCM_ADM_EXCEL_UPLOAD, SCM_MST_FUTURE_PRICE, SCM_MST_SITE_ITEM, SCM_MST_TITLESET_USER | 데이터 연결 있음 |
| 4. MKT FCST → 5. Plant Site | SCM_MST_DIVISION | 데이터 연결 있음 |
| 5. Plant Site → 6. Project Route | SCM_MST_SITE | 데이터 연결 있음 |
| 6. Project Route → 7. Distribution Route | - | 직접 연결 테이블 없음(업무 순서 화살표) |
| 7. Distribution Route → 8. BOD | SCP_MST_DISTRIBUTION_ROUTE | 데이터 연결 있음 |
| 8. BOD → 9. BOD ITEM | SCP_MST_BOD, SCP_MST_BOD_ITEM | 데이터 연결 있음 |
| 9. BOD ITEM → 10. SSP Shipment Plan | SCP_MST_BOD_ITEM | 데이터 연결 있음 |

- 화살표 9 중 데이터 연결 확인 8

### 1-2. 두 단계 이상 뒤에서 읽는 앞 단계 표

| 앞 단계 | 뒤 단계 | 테이블 |
|---|---|---|
| 1. Sales Site | 3. Sales Price | DM_MST_BUCKET_CONVERSION, SCM_MST_SITE, SCM_MST_SITE_CUSTOMER |
| 1. Sales Site | 4. MKT FCST | DM_MST_BUCKET_CONVERSION, SCM_MST_SITE, SCM_MST_SITE_CUSTOMER |
| 1. Sales Site | 5. Plant Site | SCM_MST_LOCATION, SCM_MST_SITE, SCM_MST_SITE_CUSTOMER |
| 1. Sales Site | 6. Project Route | SCM_MST_SITE |
| 1. Sales Site | 8. BOD | SCM_MST_SITE |
| 1. Sales Site | 9. BOD ITEM | SCM_MST_SITE |
| 1. Sales Site | 10. SSP Shipment Plan | SCM_MST_SITE, SCM_MST_SITE_CUSTOMER |
| 2. Sales Site Project Model | 4. MKT FCST | DM_PLN_MKT_FCST, SCM_MST_SITE_ITEM |
| 2. Sales Site Project Model | 6. Project Route | DM_PLN_MKT_FCST, SCM_MST_SITE_ITEM |
| 2. Sales Site Project Model | 8. BOD | DM_PLN_MKT_FCST, SCM_MST_SITE_ITEM |
| 2. Sales Site Project Model | 9. BOD ITEM | SCM_MST_SITE_ITEM |
| 2. Sales Site Project Model | 10. SSP Shipment Plan | DM_PLN_MKT_FCST, SCM_MST_SITE_ITEM |
| 3. Sales Price | 6. Project Route | SCM_MST_SITE_ITEM |
| 3. Sales Price | 8. BOD | SCM_MST_SITE_ITEM |
| 3. Sales Price | 9. BOD ITEM | SCM_MST_SITE_ITEM |
| 3. Sales Price | 10. SSP Shipment Plan | SCM_MST_SITE_ITEM, SCM_MST_TITLESET_USER |
| 4. MKT FCST | 6. Project Route | DM_PLN_MKT_FCST, SCM_MST_DIVISION |
| 4. MKT FCST | 8. BOD | DM_PLN_MKT_FCST |
| 4. MKT FCST | 9. BOD ITEM | SCM_MST_DIVISION |
| 4. MKT FCST | 10. SSP Shipment Plan | DM_PLN_MKT_FCST, SCM_MST_DIVISION, SCM_MST_TITLESET_USER |
| 5. Plant Site | 8. BOD | SCM_MST_SITE |
| 5. Plant Site | 9. BOD ITEM | SCM_MST_SITE |
| 5. Plant Site | 10. SSP Shipment Plan | SCM_MST_SITE, SCM_MST_SITE_CUSTOMER |
| 6. Project Route | 8. BOD | SCM_MST_SITE_ITEM |
| 6. Project Route | 9. BOD ITEM | SCM_MST_SITE_ITEM |
| 6. Project Route | 10. SSP Shipment Plan | SCM_MST_SITE_ITEM |
| 7. Distribution Route | 9. BOD ITEM | SCP_MST_DISTRIBUTION_ROUTE |
| 7. Distribution Route | 10. SSP Shipment Plan | SCP_MST_DISTRIBUTION_ROUTE |
| 8. BOD | 10. SSP Shipment Plan | SCP_MST_BOD, SCP_MST_BOD_ITEM |

- 29쌍

## 2. 출하계획 입력 오류 시 확인 순서(BOD ITEM 오류)

- 출처 = Standard Information SSP Manual 1.pptx 11번 슬라이드 메모(원문 순서). 자동 생성 주기는 운영 잡 목록과 대조

<div class="spf "><div class="spf-row"><div class="spf-card " style="--c:#5b6770"><div class="spf-h">① BOD ITEM 조회</div><ul><li>SCP0030 BOD ITEM 에서 To Site · Item 입력 후 조회</li><li>Shipment Plan 입력값과 BOD Item 등록값이 다르면 오류</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#b7860b"><div class="spf-h">② MKT FCST 확인</div><ul><li>신규 고객일 경우</li><li>TO-BE DMF0003</li><li>담당: 마케팅팀</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#4e8f4a"><div class="spf-h">③ Project Route 확인</div><ul><li>신규 모델일 경우</li><li>TO-BE SCP0006</li><li>담당: SCM팀</li></ul></div></div><div class="spf-snake" style="--n:3"><i></i><u></u></div><div class="spf-row"><div class="spf-card " style="--c:#3a6ea5"><div class="spf-h">④ BOD 확인</div><ul><li>임시 운송수단, 인코텀즈일 경우</li><li>TO-BE SCP0007</li><li>담당: 물류기획팀</li></ul></div><div class="spf-ar">▶</div><div class="spf-card " style="--c:#5b6770"><div class="spf-h">⑤ BOD ITEM 자동 생성</div><ul><li>Manual: 30분마다</li><li>JOB.PR_SCP_MST_BOD_ITEM 매일 00:30~23:59:59 30분마다</li></ul></div><div class="spf-ar"></div><div class="spf-card spf-empty"></div></div></div>

- 자동 생성 주기 대조: Manual 30분, 운영 잡 00:30~23:59:59 30분마다. 결과 일치
- BOD Required 원천 대조(Manual 10번 슬라이드 'BOD는 MKT FCST와 Project Route가 등록되어 있어야 생성', 'Route Count 가 0인 경우는 Distribution Route가 없으므로'): SP SCP0007_GET_BOD 가 읽는 표 MKT FCST DM_PLN_MKT_FCST(읽기 파싱), Project Route SCM_MST_SITE_ITEM(본문 문자열(쉼표 조인)), Distribution Route SCP_MST_DISTRIBUTION_ROUTE(읽기 파싱). Required 행은 저장된 행이 아니고 BOD 조회 때 SP 가 계산함(SP 본문 주석 'BOD Requied - From Site : Project route , To Site : Mkt FCST')

## 3. 하루 배치 흐름(SSP CUTOFF · 배치별)

- 출처: SSP 프로세스 확인 내용.pptx 2~9번 슬라이드. 카드 1개가 슬라이드 1장, 줄 1개가 프로시저와 운영 잡 주기. [조건] 표시는 진행 조건이 있는 프로시저(아래 3-1 표)

<div class="spf "><div class="spf-grid" style="--n:2"><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 2. 2. SCP 계획 기준 출하계획, 1. FP 생산계획 및 SCM 재고</div><ul><li>PR_SSP_DNM_FP_PLAN_FROZEN (매일 종일 1시간마다)</li><li>PR_SSP_DNM_STOCK (매일 종일 1시간마다)</li><li>PR_SSP_DNM_FORMATION_POST_CELL (매일 종일 1시간마다)</li><li>PR_SSP_DNM_MES_WIP_HISTORY (매일 종일 1시간마다)</li><li>PR_SCP_PLN_INTERFACE_PLAN (배치 목록 잡 시트에 없음)</li><li>PR_SSP_ANL_SHIP_REQ_SEMI (배치 목록 잡 시트에 없음)</li><li>PR_SSP_ANL_SHIP_REQ_P (배치 목록 잡 시트에 없음)</li><li>PR_SSP_ANL_SHIP_REQ_FG (배치 목록 잡 시트에 없음)</li></ul></div><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 3. 3. SSP 용 추가 재고정보</div><ul><li>[조건] PR_SSP_XIF_MES_WIP_LOT_40_R (매일 06:05~11:00 10분마다)</li><li>[조건] PR_SSP_XIF_MES_WIP_LOT_8X_R (매일 종일 10분마다)</li><li>[조건] PR_SSP_XIF_MES_WIP_LOT_EE_R (매일 종일 30분마다)</li><li>PR_SSP_XIF_OWMS_SHIP_RESULT_R (매일 종일 10분마다)</li><li>PR_SSP_XIF_OWMS_SHIP_RETURN_R (매일 종일 10분마다)</li><li>[조건] PR_SSP_XIF_OWMS_STOCK_EE_R (매일 종일 10분마다)</li><li>[조건] PR_SSP_XIF_OWMS_STOCK_R (매일 종일 5분마다)</li><li>[조건] PR_SSP_XIF_OWMS_STOCK_REST_R (매일 종일 5분마다)</li><li>[조건] PR_SSP_XIF_IWMS_STOCK_EE_R (매일 종일 10분마다)</li></ul></div><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 4. 4-1. SSP 수립 - 81,82 사업부</div><ul><li>[조건] PR_SSP_PLN_SHIP_PLAN_CUTOFF (매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_ANL_SHIP_PLAN_CUTOFF (매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_ANL_SHIP_CONFIRM_BATCH_N (매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_ANL_SHIP_CONFIRM_ROUTE (월, 화, 수, 목, 금, 토, 일 08:00; 월, 화, 수, 목, 금, 토, 일 10:30; 월, 화, 수, 목, 금, 토, 일 11:00; 매일 종일 1시간마다; 매일 05:07~23:59:59 10분마다; 매일 종일 10분마다)</li><li>PR_SSP_PLN_FP_SHIP_TARGET_WA (매일 종일 3시간마다; 매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_MAIL_SEND_BATCH_N (매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_MAIL_SEND_SHIP_REQ_DELETE (매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO (매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_ANL_SHIP_CONFIRM_BATCH_N_FP_AUTO (매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_XIF_SCS_PACK_SHIP_PLAN_S_82 (매일 05:07~23:59:59 10분마다)</li></ul></div><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 5. 4-2. SSP 수립 – 전극</div><ul><li>[조건] PR_SSP_ANL_SHIP_PLAN_EE (매일 종일 10분마다)</li></ul></div><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 6. 4-3. SSP 수립 – 40 사업부</div><ul><li>PR_SSP_ANL_SHIP_PLAN_40_BALANCE (월, 화, 수, 목, 금, 토, 일 08:00)</li><li>PR_SSP_ANL_INVENTORY_RAW (월, 화, 수, 목, 금, 토, 일 11:00)</li><li>[조건] PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 (월, 화, 수, 목, 금, 토, 일 08:00; 월, 화, 수, 목, 금, 토, 일 10:30; 월, 화, 수, 목, 금, 토, 일 11:00)</li><li>PR_SSP_ANL_SHIP_CONFIRM_ROUTE (월, 화, 수, 목, 금, 토, 일 08:00; 월, 화, 수, 목, 금, 토, 일 10:30; 월, 화, 수, 목, 금, 토, 일 11:00; 매일 종일 1시간마다; 매일 05:07~23:59:59 10분마다; 매일 종일 10분마다)</li><li>[조건] PR_SSP_ANL_SHIP_PLAN_40 (월, 화, 수, 목, 금, 토, 일 08:00; 월, 화, 수, 목, 금, 토, 일 10:30; 월, 화, 수, 목, 금, 토, 일 11:00)</li><li>PR_SSP_MAIL_SHIP_REQ_MINUS_BALANCE_40 (월, 화, 수, 목, 금, 토, 일 08:00; 월, 화, 수, 목, 금, 토, 일 10:30; 월, 화, 수, 목, 금, 토, 일 11:00)</li></ul></div><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 7. 5. 외주 Packer 출하계획</div><ul><li>PR_SSP_XIF_SCS_PROD_PLAN_R (월, 화, 수, 목, 금, 토, 일 10:31, 11:31, 13:31, 16:11, 23:01)</li><li>PR_SSP_XIF_SCS_ASSY_RSLT_SUM_R (월, 화, 수, 목, 금, 토, 일 10:31, 11:31, 13:31, 15:31, 23:01)</li><li>PR_SSP_XIF_SCS_BOX_RSLT_SUM_R (월, 화, 수, 목, 금, 토, 일 10:31, 11:31, 13:31, 15:31, 23:01)</li><li>PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R (월, 화, 수, 목, 금, 토, 일 10:32, 11:32, 13:32, 15:32, 22:02)</li><li>PR_SSP_XIF_SCS_STOCK_RSLT_SUM_R (월, 화, 수, 목, 금, 토, 일 10:32, 11:32, 13:32, 15:32, 23:02)</li><li>[조건] PR_SSP_ANL_SHIP_PLAN_P (월, 화, 수, 목, 금, 토, 일 07:15)</li><li>[조건] PR_SSP_ANL_SHIP_CONFIRM_P (월, 화, 수, 목, 금, 토, 일 07:15)</li></ul></div><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 8. 7. 기타(1/2)</div><ul><li>PR_SSP_INT_SYSTEMEXEC_RUNJOB (매일 종일 1분마다)</li><li>PR_SSP_MST_WS_CALL_BATCH (월, 화, 수, 목, 금, 토, 일 01:00)</li><li>[조건] PR_SSP_ANL_SHIP_PLAN_ALL (매일 종일 30분마다)</li></ul></div><div class="spf-card " style="--c:#1f7a8c"><div class="spf-h">슬라이드 9. 7. 기타(2/2)</div><ul><li>PR_SSP_BI_SSP_RESULT_H (월, 화, 수, 목, 금, 토, 일 07:30)</li><li>PR_SSP_XIF_DW_SHIP_CHANGE_HISTORY_S (월, 화, 수, 목, 금, 토, 일 07:00)</li><li>PR_SSP_PLN_FP_SHIP_TARGET_ALL (매일 종일 1시간마다)</li><li>PR_SSP_PLN_FP_SHIP_TARGET_WA (매일 종일 3시간마다; 매일 05:07~23:59:59 10분마다)</li><li>PR_SSP_XIF_FP_AMEND_SHIPAVAL (매일 종일 2분마다)</li></ul></div></div></div>

### 3-1. 프로세스 진행 조건(계획을 만들기 전 확인, 2026-11-16 판 추가 내용)

| 슬라이드 | 프로시저 | 운영 잡 | 진행 조건(원문) |
|---|---|---|---|
| 3 | PR_SSP_XIF_MES_WIP_LOT_40_R | JOB.PR_SSP_XIF_MES_STOCK_40_R (매일 06:05~11:00 10분마다) | 1. 보낸데이터건수와 받은데이터건수가 일치하고<br/>2. 룩업 기준 동기화 이력이 없는 경우 |
| 3 | PR_SSP_XIF_MES_WIP_LOT_8X_R | JOB.PR_SSP_XIF_MES_STOCK_81_82_R (매일 종일 10분마다) | 1. 보낸데이터건수와 받은데이터건수가 일치하고<br/>2. 룩업 기준 동기화 이력이 없는 경우 |
| 3 | PR_SSP_XIF_MES_WIP_LOT_EE_R | JOB.PR_SSP_XIF_MES_STOCK_EE_R (매일 종일 30분마다) | 1. 보낸데이터건수와 받은데이터건수가 일치하고<br/>2. 룩업 기준 동기화 이력이 없는 경우 |
| 3 | PR_SSP_XIF_OWMS_STOCK_EE_R | JOB.PR_SSP_XIF_OWMS_STOCK_EE_R (매일 종일 10분마다) | 1. 보낸데이터건수와 받은데이터건수가 일치하고<br/>2. 룩업 기준 동기화 이력이 없는 경우 |
| 3 | PR_SSP_XIF_OWMS_STOCK_R | JOB.PR_SSP_XIF_OWMS_STOCK_R (매일 종일 5분마다) | 1. 보낸데이터건수와 받은데이터건수가 일치하고<br/>2. 룩업 기준 동기화 이력이 없는 경우<br/>※ 40 사업부 Look up 도 Update 함 |
| 3 | PR_SSP_XIF_OWMS_STOCK_REST_R | JOB.PR_SSP_XIF_OWMS_STOCK_R (매일 종일 5분마다) | ※ PR_SSP_XIF_OWMS_STOCK_R 호출 이후 바로 호출<br/>1. 보낸데이터건수와 받은데이터건수가 일치하고<br/>2. 룩업 기준 동기화 이력이 있는 경우<br/>3. 받은 데이터가 오늘데이터이면 (전일 <> 현재(Max Date)<br/>- I/F 받은 데이터 키 기준 Merge 처리 |
| 3 | PR_SSP_XIF_IWMS_STOCK_EE_R | JOB.PR_SSP_XIF_IWMS_STOCK_EE_R (매일 종일 10분마다) | 1. 보낸데이터건수와 받은데이터건수가 일치하고<br/>2. 룩업 기준 동기화 이력이 없는 경우 |
| 4 | PR_SSP_PLN_SHIP_PLAN_CUTOFF | JOB.PR_SSP_PLN_SHIP_PLAN_81_82 (매일 05:07~23:59:59 10분마다) | 1. 법인별 당일계획 수립이력 확인해서 수립하지 않은 법인확인<br/>2. View데이터 확인해서 ERP 재고 데이터 유무 확인<br/>※ CUTOFF_DATE 는 전일임<br/>3. 룩업 기준 당일 재고 I/F 완료 확인<br/>※ SSP_ANL_OWMS_STOCK_C2 데이터 없으면 여기서도 생성<br/>※ 앞서 PR_SSP_XIF_OWMS_STOCK_REST_R 에서 생성하는 테이블 / 차이점 / - PR_SSP_XIF_OWMS_STOCK_REST_R / : PLANT_ID 가 V_G673 = ‘GM01’ 인 경우만 생성 / - 여기서는 법인기준으로 확인하고 없으면 생성<br/>4. 2에서 ERP 재고가 있고 당일 SSP용 재고 I/F 가 온전하면 이후 프로세스 진행 |
| 5 | PR_SSP_ANL_SHIP_PLAN_EE | JOB.PR_SSP_PLN_SHIP_PLAN_EE (매일 종일 10분마다) | 1. 법인별 당일계획 수립이력 확인해서 수립하지 않은 법인확인<br/>2. 1에서 확인된 법인들 중 전극 재고 당일 유효한 법인확인<br/>3. 2에서 해당 법인이 있으면 진행, 없으면 종료 |
| 6 | PR_SSP_ANL_SHIP_CONFIRM_BATCH_40 | JOB.PR_SSP_PLN_SHIP_PLAN_40 (월, 화, 수, 목, 금, 토, 일 08:00)<br/>JOB.PR_SSP_PLN_SHIP_PLAN_40_AZ (월, 화, 수, 목, 금, 토, 일 10:30)<br/>JOB.PR_SSP_PLN_SHIP_PLAN_40_C (월, 화, 수, 목, 금, 토, 일 11:00) | 1. 당일기준 계획이 있으면 진행 X |
| 6 | PR_SSP_ANL_SHIP_PLAN_40 | JOB.PR_SSP_PLN_SHIP_PLAN_40 (월, 화, 수, 목, 금, 토, 일 08:00)<br/>JOB.PR_SSP_PLN_SHIP_PLAN_40_AZ (월, 화, 수, 목, 금, 토, 일 10:30)<br/>JOB.PR_SSP_PLN_SHIP_PLAN_40_C (월, 화, 수, 목, 금, 토, 일 11:00) | 1. 당일기준 계획이 유무 확인<br/>2. 당일기준 재고 I/F 확인<br/>3. 계획이 없고 재고가 있으면 진행 (둘 중 하나라도 없으면 진행 X)<br/>※ 사업부-법인별로 1회 호출하기 때문에 각 JOB 실행시엔 일반적으론 프로세스항상 진행할 것으로 보임 |
| 7 | PR_SSP_ANL_SHIP_PLAN_P | JOB.PR_SSP_PLN_SHIP_PLAN_P (월, 화, 수, 목, 금, 토, 일 07:15) | - 당일 계획된 Packer 출하계획이 있는경우엔 수행 X<br/>※ DIVISION_CD 는 변수선언부에서 40으로 지정됨 |
| 7 | PR_SSP_ANL_SHIP_CONFIRM_P | JOB.PR_SSP_PLN_SHIP_PLAN_P (월, 화, 수, 목, 금, 토, 일 07:15) | - 프로세스 진행 여부 체크 없음 |
| 8 | PR_SSP_ANL_SHIP_PLAN_ALL | JOB.PR_SSP_ANL_SHIP_PLAN_ALL (매일 종일 30분마다) | ※ V_PLAN_START_YYYYMMDD = 전일<br/>1. 한번 Snapshot 한 사업부-법인 은 제외 |

- 14묶음. 입출력 화살표와 본문 대조는 업무 프로세스 탭 5-0, 6-5

## 4. 자주 받는 문의(SSP Manual 원문)

| 화면 | 질문 | 답 |
|---|---|---|
| MKT FCST (5번) | 임시로 발생한 인코텀즈인데 등록해야 하나요? | 네 등록해야 BOD 생성이 됩니다. |
| MKT FCST (5번) | 지난주에 입력해놓은 MKT FCST인데 사라졌어요. | 다른 기준정보들은 미래구간만 봅니다. |
| MKT FCST (5번) | MKT FCST가 입력이 안되요. | 아래 Manual인 Sales Site Project Model과 Sales Site, Sales Price등을 확인해주세요 |
| MKT FCST (5번) | MKT FCST를 입력했는데, Project Route에서 검색할 수 없다고 해요. | Sales Site를 열어서 VMI Y인지 확인해봅니다. VMI가 Y이면 VMI In Request를 등록해줍니다. |
| Project Route (8번) | MKT FCST등록했는데 Project Route대상에 안나와요. | VMI 대상인지 확인합니다. VMI라면 VMI In Request가 있어야 합니다. BOM이 생성되어 있는지, 자재 확장이 되어 있는지 확인 부탁 드립니다. |

- 5건

## 5. 화면별 매뉴얼 원문(2~11번 슬라이드)

| 장 | 메뉴 | UI 명 | 작성자 · 날짜 | UI 정의 | Key Point | 설명 | 메모(자주 발생 사례) |
|---|---|---|---|---|---|---|---|
| 2 | Master > Demand Master > Sales Site | Sales Site | 최영태 · 2018.02.24 | Sales Site 정보 관리화면 | Sales Site 필수 속성 관리, MKT FCST에 영향 | Sales Site<br/>① Sales Site 생성<br/>- Division, Sold-To Customer, Country, City<br/>선택 후 저장. [Sales Site 자동 생성]<br/>- Division, Sold Customer의 구분으로 조직,<br/>그룹 별 권한 관리 가능<br/>② Sales Customer 매핑<br/>- Sales Site와 Sold-To, Ship-To 정보 매핑.<br/>- Sold-To : Ship-To = 1 : N 매핑시 Rep 컬럼을   통해 대표 Ship-To를 설정함<br/>③ Sales Location 매핑<br/>- Sales Site : Location Mapping 관리<br/>④ Sales Bucket<br/>- Sales Site의 Incoterms 조건 설정과 Bucket<br/>(주별 수요 수량 Split 단위) 정보 설정 | - |
| 3 | Master > Demand Master > Sales Site Project Model | Sales Site Model | 최영태 · 2018.02.24 | Sales Site와 Project Model 정보 매핑 화면 | Sales Site와 Project Model 매핑 관리, MKT FCST 입력에 사용할 직접적인 기준정보 | Sales Site Project Model<br/>① Sales Site Model 매핑 정보 생성<br/>- Cust Group, End Customer, Owner,<br/>Sales Site, Model, Cust Group Detail, Application,<br/>Channel, Currency, Active 입력 후 저장. | - |
| 4 | Master > Demand Master > Sales Price | Sales Price | 진준희 · 2018.02.24 | Sales Price 관리화면 | Currency별 환율을 관리하고 Sales Plan 값의 생성의 기초가 되는 Master | Sales Price<br/>② Sales Price 생성<br/>- Team, End Customer, Sales Site, Model<br/>Incoterms, FCST Type 등 노란색 활성화 부분         설정 후 저장<br/>③ Sales Price 재계산<br/>- Exchange Rate가 변경됐다면 Set Price를          Click하면 재 설정 기준으로 Currency별 값    재 계산됨.<br/>④ Sales Plan 반영<br/>- Sales Price가 Sales Plan의 매출액(Sales AMT)    산출 시 반영됨 | - |
| 5 | Demand > Demand Plan > MKT FCST | MKT FCST | 최영태 · 2018.02.24 | MKT FCST를 조회 및 추가/수정하는 화면 | 신규 MKT FCST를 추가 입력이 가능함 | MKT FCST 조회/수정<br/>① MKT FCST 관리단위 기준인 End Customer,<br/>Sales-Site, Model, Incoterms, 수책 구분,<br/>FCST Type 기준으로 값 조회 및 수정이 가능함.<br/>② Period : MKT FCST 조회/수정하고자 하는 구간을<br/>변경해서 조회 가능함. 과거구간에 대한 FCST는<br/>수정이 불가능함.<br/>③ Bucket : 결과 Data에 Bucket을 Daily–Weekly–<br/>Monthly로 조회 필요 없이 Grid 결과값이 변경됨.<br/>④ Sum : 결과값에 Sum Column을 숨기거나 표시하는<br/>기능을 수행<br/>⑤ Edit 기능으로 MKT FCST에 값을 수정 가능함.<br/>수정된 값은 Site 별 Bucket Conversion Rule에<br/>따라서 Daily로 자동 Split됨.<br/>※ RTF Measure는 SCP Open 전까지 Edit 가능하며,<br/>추후 불가능하게 변경 예정임. | MKT FCST가 입력이 안되어 있어서 발생하는Case가 많습니다.<br/>임시 출하라고 하더라도, 나머지 기준정보등을만들기 위해서 도착지에 대한 설정을 해야 하므로입력해줘야 합니다.<br/>자주 받는 문의는 다음과 같습니다. Q. 임시로 발생한 인코텀즈인데 등록해야 하나요?A. 네 등록해야 BOD 생성이 됩니다. Q. 지난주에 입력해놓은 MKT FCST인데 사라졌어요.A. 다른 기준정보들은 미래구간만 봅니다. Q. MKT FCST가 입력이 안되요.A. 아래 Manual인 Sales Site Project Model과      Sales Site, Sales Price등을 확인해주세요Q. MKT FCST를 입력했는데, Project Route에서     검색할 수 없다고 해요.A. Sales Site를 열어서 VMI Y인지 확인해봅니다.      VMI가 Y이면 VMI In Request를 등록해줍니다. |
| 6 | Demand > Demand Plan > MKT FCST | MKT FCST | 최영태 · 2018.02.24 | MKT FCST를 조회 및 추가/수정하는 화면 | MKT FCST를 Bucket, Period 기준으로 조회/수정 가능함 | MKT FCST 추가<br/>Edit Mode에서 Insert 기능을 사용하여 신규 MKT FCST 입력 가능함.<br/>① Team : 해당 소속팀 선택<br/>② End-Customer : End-Customer 선택.<br/>③ Sales-Site : Sales-Site 선택.<br/>④ Model : 더블 클릭 후 Pop-Up 창을 통해 모델 선택.<br/>⑤ Incoterms : EXW, FOB, DDP등 거래조건 선택.<br/>⑥ FCST Type : 양산, 유/무상 Sample, A/S 등 선택.<br/>⑦ Customs Handbook : 수책 여부 선택.<br/>⑧ Measure : CUST FCST, MKT FCST,<br/>RTF 선택 가능.<br/>※ RTF Measure는 SCP Open 전까지 Edit 가능하며,<br/>추후 불가능하게 변경 예정임. | - |
| 7 | Master > Supply Master > Plant Site | Plant Site | Admin · 2018.10 | Plant Site Master  정보 조회 및 수정하는 화면 | - 생산 Site가 신규로 생성되면은 반드시 본 화면에서 추가되어야 Project Route가 등록 가능함 | ● Plant Site Master 정보 조회 및 수정<br/>조회조건(Division, Plant/Vendor, Plant Site, Outsourcing, Valid) 선택 후 Plant Site 정보 조회<br/>그리드 목록을 더블클릭하여 Location, Customer, Location (OSP)목록을 조회<br/>Location : 상단 그리드 더블클릭으로 선택 시 하단 그리드 Location에 정보가 표시되고 사용자가 수작업으로 데이터 추가 할 수 있음. Storage 값 입력하면 앞 입력된 Building code ~ Elctrode Type에 기 입력된 값은 삭제된다.<br/>Edit버튼을 클릭하여 그리드를 수정 모드로 변경<br/>신규 입력이 필요할 경우 Insert버튼 클릭 (외주 Packer는 자동 생성이 되지 않으므로 수작업으로 Add 하여야 함)<br/>※ 필수조회 조건 : N/A | - |
| 8 | Master > Supply Master > Project Route | Project Route | Admin · 2018.10 | Project, Item 별로 대표 Plant Site 등록 관리하는 화면 | - Plant/Item 0/2 이면은 2개 등록을 하여야 하는데 0개만 등록된 것으로 미등록을 의미하고 BOM Not Exist는 BOM 미등록되어 있음을 의미함 | ● Project, Item별로 대표 Plant Site를 등록<br/>조회조건(Division, Project, Model, Period) 선택 후 Project별 Model 조회<br/>그리드 목록을 더블클릭하여 BOM Explosion 목록을 조회<br/>BOM Explosion목록을 더블 클릭하여 Plant Assign 정보를 조회<br/>Plant Assign 그리드에서 Plant Site, Valid, Priority, From, To 정보를 입력한 후 저장<br/>Input All 버튼 클릭하면 일괄 등록할 수 있는 Pop up창 표시됨<br/>※ 6) Priority, From, To 입력 규칙<br/>- Priority는 1부터 시작되고 Palnt Site중 반드시 1이<br/>존재해야 함.<br/>- 동일한 기간(From, To)에 Plant는 중복되면 안됨<br/>- 기간이 다를 경우 연속적으로 입력되어야 하며 중간에<br/>빈 기간이 생기면 안됨.<br/>- Plant/Item 0/2 이면은 0은 등록된 개수로 미등록을 의미     하고 BOM Not Exist는 BOM 미등록되어 있음을 의미함 | Project Route (신규 모델일 경우)발생하는 Case가 많습니다.<br/>Project Route는 MKT FCST와 자재와 BOM이 확장되어 있어야 합니다.<br/>MKT FCST의 경우, To-Site가 VMI일 경우에는 MKT FCST Measure가 아닌VMI In Request가 등록되어 있어야 합니다.<br/>등록 문의는 자동차/소형/ESS SCM팀담당자에 문의하세요.<br/>자주 받는 문의는 다음과 같습니다. Q. MKT FCST등록했는데     Project Route대상에 안나와요.A1. VMI 대상인지 확인합니다.      VMI라면 VMI In Request가 있어야      합니다.A2. BOM이 생성되어 있는지,      자재 확장이 되어 있는지      확인 부탁 드립니다. |
| 9 | Master > Master Data > Distribution Route | Distribution Route | 김광희 책임 · 2019.10 | 물류 Route별 소요 일자를 From City  ~ To City 기준으로 상세 구간별 L/T을 관리 하는 화면 | - 물류 운송을 위한 Route 관리로서 생산/출하 Target를 생성하기 위하여 반드시 관리되어야 하며, 본 Route를 기준으로    우선 순위가 가장 높은 기준으로 BOD 관리하며,  Lead Time를 감안하여 생산/출하 Target를 생성함 | ● From ~ To City 기준으로 수행되는 Port와 소요 기간을 등록<br/>조회조건(From Country, City, To City 등) 선택 후 조회<br/>수정 또는 입력이 필요할 경우 Edit Click 후 수정하고 입력 필요시 Insert(F8) 후 입력하고 Save한다.  출발 가능한 일자 관리<br/>운송 모드 (SEA, AIR, TRK 등)<br/>BOD 정보 수정 변경시 Mass Excel up-load 수정 가능<br/>※ 입력 규칙<br/>- Priority는 1부터 시작되고 동일 From ~ TO City내의   동일 조건에서는 우선 순위가 겹치지 않아야 함<br/>※ Distribution Route 가 등록된 건에 대해서 BOD Master를 설정 할 수 있으며, 해당 기준으로 Incoterms기준 L/T 계산됨<br/>※ 정보 관리 주관 : 전지 물류 기획팀 (이상달 선임) | - |
| 10 | Master > Supply Master > BOD | BOD | 김광희 책임 · 2019.10 | BOD (Bill Of Distribution)  정보 조회 및 등록/수정하는 화면 | Planning시에 BOD를 기준으로 생산/출하 Target를 생성함으로 사전에 먼저 확인하고 없을 것을 등록 후 Planning을 하여야 함 | ● BOD 정보 조회 및 등록,수정<br/>조회조건(Division, From Site, To Site, Incoterms, Trans Mode, Input Status, Valid) 선택 후 Distribution Route  정보 조회<br/>Edit버튼을 클릭하여 그리드를 수정 모드로 변경 (Priority, BOD Valid 수정 가능)<br/>신규 입력이 필요할 경우 Insert버튼 클릭 (Input Status 가 Completed 인 경우만 가능)<br/>4) Route Count 가 0인 경우는 Distribution Route가     없으므로 물류에 요청하여 등록하게 하여야 함<br/>5) Required 는 BOD를 등록하지 않은 것으로 반드시    Planning 전에 확인하고 없는 것은 사전 등록하여야 함<br/>(Required 대상은 MKT FCST의 신규 Sales Site에 대해서<br/>선정되며, 해당 From, To city에 대해 Distribution Route에     등록이 안되어 있는 경우 Distribution Route 등록이 선행     되어야 함)<br/>※ 필수조회 조건 : Division<br/>※ 정보 관리 주관 : 전지 물류 기획팀 (이상달 선임) | BOD (임시 운송수단, 인코텀즈일 경우)발생하는 Case가 많습니다.<br/>BOD는 MKT FCST와 Project Route가 등록되어 있어야 생성이 됩니다.<br/>MKT FCST의 경우, To-Site가 VMI일 경우에는 MKT FCST Measure가 아닌VMI In Request가 등록되어 있어야 합니다 .<br/>MKT FCST과 Project Route가 입력되어있으면 ④ Required에 자동 생성되며등록은 물류기획팀에서 확인 후 등록합니다.<br/>급한경우 물류기획팀에 문의하시기 바랍니다. |
| 11 | Master > Supply Master > BOD ITEM | BOD ITEM | Admin · 2018.09 | BOD ITEM 조회 및 수정 하는 화면 | 모델 별 BOD 기준정보를 등록 관리 할 수 있는 화면 | ● BOD ITEM 정보 조회 및 수정<br/>조회조건 선택 후 정보 조회<br/>Edit버튼을 클릭하여 그리드를 수정 모드로 변경<br/>From, To, Priority, BOD Item Valid 항목 수정가능<br/>Insert 버튼을 통해 신규 기간 추가<br/>※ From ~ To 신규 기간 추가시 기존에 등록된 기간과 연속해야 하고 중복되서는 안된다.<br/>( 기존 등록된 기간을 단축 후 신규 입력 가능 ) | 에러메시지가 발생하면 이 화면에목적지 (To Site)와 Item을 입력하셔서조회하세요.<br/>Shipment Plan에 입력한 값과 BOD Item에 등록되어 있는 값이 달라서 오류가 나는 Case가 많습니다.<br/>여기에 등록되지 않은 경우 대 부분이다음 문제로 인하여 발생하오니차례대로 확인해주 세요. MKT FCST (신규 고객일 경우)Project Route (신규 모델일 경우)BOD (임시 운송수단, 인코텀즈일 경우)를 차례대로 확인합니다.<br/>위의 내용이 모두 입력되어 있으면30분에 한번씩 자동생성 합니다. |

