# AS-IS MSG[숫자] 인벤토리 + To-Be 미등록 식별

## 추출 방법

11 화면의 `__asis-mapping__.md` 11개 파일에서 정규식 `MSG[0-9]{4,5}` grep → 33개 unique MSG ID 식별.

**Anti-simplification 명시**:
- 본 인벤토리는 `__asis-mapping__.md` 파일들의 **표 내용에서 추출한 본문 텍스트**입니다.
- 추출된 KO 본문이 **AS-IS 원본 메시지 카탈로그의 정확한 본문과 동일하다고 보장하지 않습니다** (매핑 표의 용도 설명 + 실제 본문 혼재).
- AS-IS DB (MSSQL 165.244.95.223:1433) 의 메시지 카탈로그 테이블 query 가 가능했다면 정확한 본문 추출 가능했으나 본 작업 시점 DB 접근 불가.
- EN/CN 본문은 KO 본문의 영문 fallback 으로 작성 (정확한 다국어 번역은 사용자/PM 결정 의무).
- "TODO" 표시된 4개 MSG (00085/00146/00361/00428) 는 본문 미상 — 추후 사용자 결정 후 갱신 필요.

## 33개 MSG ID 의 To-Be 등록 여부

### Docker DB 에 이미 등록 (4개) — 신규 등록 대상 외

| MSG ID | Docker 본문 (KO) | 비고 |
|---|---|---|
| MSG00002 | 성공적으로 저장되었습니다. | ⚠️ AS-IS 매핑은 "필수 입력" — 의미 충돌 |
| MSG00003 | 저장에 실패하였습니다. | |
| MSG00004 | 수정한 내용이 없습니다. | ⚠️ AS-IS 매핑은 "저장하시겠습니까?" 도 사용 — 의미 일부 충돌 |
| MSG00005 | 변경사항을 먼저 저장하세요. | |

### To-Be 미등록 (29개) — 신규 등록 대상

| # | MSG ID | KO 본문 (AS-IS 매핑 추출) | 출처 화면 |
|---:|---|---|---|
| 1 | MSG00034 | 일자 입력 검증 (YYYYMMDD 8자리) | mkt_forecast |
| 2 | MSG00043 | 저장시 중복 오류가 발생하였습니다. {0} | lookup / mkt_forecast |
| 3 | MSG00060 | 중복 SCM_SITE_ID | erp-edi-master / lookup |
| 4 | **MSG00085** | (본문 미상 — TODO) | sales-future-price |
| 5 | MSG00096 | 권한 없음 | erp-edi-master |
| 6 | MSG00097 | Division 을 선택하세요. | mkt_forecast / sales-monitoring / customer-fcst-upload |
| 7 | MSG00108 | 기간 시작 > 종료 검증 / 조회된 데이터 없음 | 다수 (mkt_forecast/sales-future-price/customer-fcst-upload 등) |
| 8 | MSG00109 | 읽기전용 | nn-master-mapping |
| 9 | MSG00113 | 필수 입력 컬럼이 없습니다. | nn-master-mapping |
| 10 | MSG00128 | sheet 별 Insert/Delete 안내 | erp-edi-master |
| 11 | MSG00129 | sheet 별 안내 (Edit toggle) | erp-edi-master |
| 12 | MSG00130 | sheet 변경 안내 (Tab 전환 dirty) | erp-edi-master |
| 13 | MSG00135 | Lock 가드 (Edit 모드) | sales-future-price |
| 14 | MSG00137 | 전 작업이 아직 실행 중입니다. | sales-monitoring / nn-master-mapping |
| 15 | MSG00142 | ExchangeRate Lock 가드 | sales-future-price |
| 16 | **MSG00146** | (본문 미상 — TODO) | sales-future-price |
| 17 | MSG00152 | 저장할 데이터 없음 | erp-edi-master |
| 18 | MSG00164 | 조회기간은 3년 이내로 입력해주세요. | 다수 (mkt_forecast/sales-future-price/customer-fcst-upload) |
| 19 | MSG00225 | Div 40 MKT_FCST_RP QTY < 0 검증 | mkt_forecast |
| 20 | MSG00227 | Insert 행이 있어 Bucket 변경 불가합니다. | mkt_forecast / sales-monitoring / sales-plan |
| 21 | MSG00255 | Version 2개 초과 선택 | sales-future-price |
| 22 | MSG00260 | Division/Project/Item/YYYYMMDD/Measure unique 검증 | mkt_forecast |
| 23 | MSG00265 | Excel Upload 결과 재조회 안내 | customer-fcst-upload |
| 24 | MSG00283 | 버전 선택 가드 | mkt_forecast |
| 25 | **MSG00361** | (본문 미상 — TODO) | sales-future-price |
| 26 | MSG00380 | insert 사용 불가 (Excel Upload 사용 권장) | erp-edi-master |
| 27 | MSG00408 | PriceBatch 추가 가드 | sales-future-price |
| 28 | **MSG00428** | (본문 미상 — TODO) | nn-master-mapping |
| 29 | MSG00429 | {0} 값은 필수 입력입니다. | nn-master-mapping |

## 등록 SQL 사양

- 테이블: `SCM_MGR.SCM_ADM_MSG_M`
- LANG_CD: KO / EN / CN (3 언어 × 29 MSG = **87 row**)
- MSG_TP_CD: `'MSG'` (Docker 표준 — validation 등 일반 메시지)
- 멱등: NOT EXISTS 가드 (MSG_ID + LANG_CD)
- NOT NULL 보강: 모든 컬럼 명시 (사내 DB schema 호환)

## SQL 파일 위치

- `200_AS_IS_MSG_codes_register.sql` (sqlplus 호환)
- `200_AS_IS_MSG_codes_register_DBeaver.sql` (DBeaver 호환)
- `200_AS_IS_MSG_codes_register_Verify.sql` (등록 결과 검증)

## 적용 제약

⚠️ 사내 DB 의 USERS tablespace quota 부족 (ORA-01653) 으로 즉시 적용 불가. DBA 측 tablespace 확장 후 적용 가능.

## 추후 작업 (사용자 결정 필요)

1. TODO 4개 (MSG00085/00146/00361/00428) 의 본문 결정
2. EN/CN 번역 정확성 검수
3. MSG00002 / MSG00004 의 As-Is vs Docker 의미 충돌 해소 (별도 To-Be 코드 부여 or 매핑 문서 정정)
