--------------------------------------------------------------------------------------------------
-- [E20260814-EXCELFORM-V2] DMF0014 Excel Form 조회 SP **재설계** (사용자 정정 2026-08-14)
--------------------------------------------------------------------------------------------------
-- ⛔ V1 설계 오류: `DM_PLN_CUSTOMER_PSI`(= **이미 업로드된 원장**)를 읽었다.
--    실측 반증 — PSI 는 div 81 에만 10 키 조합이 있고 div 40 은 0행인데, DMF0007 기준데이터에는
--    div 40 이 109행 있다. 즉 **최초 업로드용 양식이 가장 필요한 곳에서 0건**이 되는 구조였다.
--    사용자 원문: "Excel Form 으로 조회해야 할 데이터는 **EXCEL UPLOAD 를 위한 실제 데이터**.
--                 MAIN GRID 의 데이터와 항상 일치하지 않습니다."
--
-- ⭐ V2 설계 = **C안**(사용자 확정): DMF0007 기준데이터 × DMF0014 키 축 **합집합**
--    · MST  = DMF0007 기준(`DM_MST_CUSTOMER_FCST`) — Division/Sales Site/Measure Group/Measure/Upload UOM
--             VALID_YN='Y' + UPLOAD_BUCKET_TYPE = 조회 bucket
--    · KEYB = 기존 업로드 키(`DM_PLN_CUSTOMER_PSI`) — Plant/CustProject/CustModel/Incoterms/FcstType/
--             DomExp/Project/Model **8종이 채워진** 조합
--    · KEYA = 신규 대상(`SCM_MST_SITE_ITEM`) — Division/Site/Project/Model 만 확정, 나머지는 **빈칸**
--             (KEYB 에 이미 있는 div+site+project+item 은 제외 — B 가 더 상세하므로 B 우선)
--    · 양식 1행 = (KEYB ∪ KEYA) × MST(div+site 매칭)  → 실적 없는 measure 도 양식에 나온다
--
--  실측 카디널리티(2026-08-14, WEEKLY): KEYA×MST = div40 190행 / div81 3,997행 (폭발 없음)
--
--  ⭐ 컬러링 지원 — `UPLOAD_VALID_WEEKS`
--    DMF0007 은 `SUMMARY_BUCKET_VALUE`(주차 일자) 행마다 VALID_YN 을 관리한다. 조회 구간 안에서
--    VALID_YN='Y' 인 주차 일자를 콤마 목록으로 함께 내려, FE 가 **업로드 가능한 값 칸만 컬러링**할 수
--    있게 한다(사용자 요구 2026-08-14 — "DMF0007 에서 Y 로 표기한 부분만 COLORING").
--    ⚠ 양식 헤더의 `W27~W31` 은 **고정 문자열 토큰**이라 이 주차 일자와의 대응 규칙이 메타에 없다.
--       FE 컬러링 배선은 그 매핑이 확정된 뒤 연결한다(본 SP 는 원천 데이터만 제공).
--------------------------------------------------------------------------------------------------
SET DEFINE OFF

CREATE OR REPLACE PROCEDURE SCM_MGR.PR_DMF0014_FORM_V2_PLACEHOLDER AS BEGIN NULL; END;
/
-- ⚠ 위 placeholder 는 파일 단독 실행 방지용. 실제 반영은 PKG_DMF0014 BODY 교체로 수행한다
--   (본 파일의 본문 블록을 `P_DMF0014_GET_EXCEL_FORM_DATA` 로 치환) — `_t14_form_v2_build.py` 참조.
