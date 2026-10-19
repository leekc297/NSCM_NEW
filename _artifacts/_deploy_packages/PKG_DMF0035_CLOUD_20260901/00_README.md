# PKG_DMF0035_CLOUD_20260901 — DMF0035 조회 누락(종속메저 포함) 대응

## 신고
클라우드 DMF0035 MKT FCST 조회: AS-IS 446 vs TO-BE 247 (버전 MF_W_20260825_V001) — **CUST_FCST 종속메저 미출력**.
추가: 40 division 기준 AS-IS 775 vs TO-BE 678 (종속메저 없는 조건인데도 97건 차이).

## 로컬(사내) 실측 결과 — 지시대로 AS-IS ↔ TO-BE 직접 비교
동일 조건(40 · CURRENT · 20260901~20261130 · MONTHLY · minyonglee1) 양쪽 SP 직접 실행:

| 항목 | AS-IS | TO-BE |
|---|---:|---:|
| 총 행수 | 518 | 515 |
| MKT_FCST | 259 | 257 |
| SCM_FCST | 259 | 258 |

**키 단위 차집합**(DIVISION/PROJECT/SITE/ITEM/MEASURE/FCST_TYPE/INCOTERMS/DOM_EXP):
- AS-IS 에만: **3행** (Airbus/MCCH129520B1 MKT_FCST · JRES/MCCM348014A3 MKT_FCST·SCM_FCST)
- TO-BE 에만: 0행

**종속메저는 사내 TO-BE 에서 정상 동작** — `GT_DM35_SEL_MEASURE` 실측 14행에 CUST_FCST 종속 11종
(CUST_FCST / Customer FCST / Cutomer FCST / CUST_FCST_EDI / Backorder / Commercial_Agreement / Firm_Temp /
Immidiate / Manumacturing_Material_Temp / Material_Temp / Planning_Forecast) 전부 적재됨.

## 구조 대조 (주석 제거 후 LIVE 코드 기준 — hook #138)
| 축 | 결과 |
|---|---|
| RAW_DATA 적재 arm 수 | AS-IS 18 = TO-BE 18 (동일) — 주석 포함 시 25 vs 18 로 보이나 전부 주석분 |
| 원장 소스 테이블 | **AS-IS ⊆ TO-BE** (AS-IS 에만 있는 원장 0) |
| 메저 보강 arm 4종 | 전부 이식 확인 (MKT_FCST_RP% / RTF_SYS_RP% / LOC / SCM_FCST 조건부 INSERT) |
| VMI_INV arm (40 포함 무분기 DM_PLN_MKT_FCST 읽기) | 이식 확인 |
| 스테이징 MEASURE_GROUP CASE | AS-IS L1018 ↔ TO-BE L801 **1:1 동일** |

→ **사내 TO-BE 에는 구조적 누락이 없다.** 클라우드에서만 나타나는 대량 차이(199건·97건)는
   **클라우드 PKG_DMF0035 버전 드리프트**가 유력하다(DMF0082 에서 동일 사례 선례: 클라우드 본문이 사내 정본보다 구본).

## 적용 순서
1. **`00_PRECHECK.sql`** — 마커 10종 대조. `CLOUD_CNT < EXPECTED` 인 마커가 하나라도 있으면 구본 확정
   (특히 `E20260828-ALLCOLS`, `E20260831-VERCASE`, `E20260831-W34`). titleset 'M' 의 CUST_FCST 보유 여부도 함께 확인
   — 사용자가 CUST_FCST 를 선택하지 않았으면 종속메저는 설계상 나오지 않는다.
2. `01_PKG_DMF0035_BODY.sql` — 사내 정본 전체본 (2026-08-31 21:57 VALID)
3. `02_POSTCHECK.sql` — VALID · 컴파일오류 0 · 마커 일치 확인 후 화면 재조회

## 잔여 (사내 3행 차이 — 별건 추적)
Airbus/JRES 2키 3행이 `GT_DM35_DM_PLN_MKT` 스테이징 단계에서 탈락. 원장에는 존재
(`DM_PLN_MKT_FCST` 현재 테이블 보유, CFM 에는 MKT_FCST 부재)하나 40 은 CFM 분기라 미수집.
AS-IS 도 동일 분기이므로 다른 arm 경로로 유입되는 것으로 보이며, 규모가 0.58% 라 별건으로 계속 추적한다.
