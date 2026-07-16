# 참고자료 — 고객/현업 전달 상세문서 → 화면별 개발참조 인덱스

> 고객·현업에서 전달받은 상세 xlsx(수정대상 식별·데이터 원천·단위테스트)를 **화면별 개발참조 MD** 로 추출한 폴더.
> **화면 개발/보완 착수 시 대상 화면의 개발참조 MD 를 원천에 포함할 것** — 회의록(`ui_analysis_meet/`)이 "무엇을/왜" 라면, 본 폴더는 **"어느 테이블/SP/컬럼/권한을 어떻게"** 의 구체 사양이다.

## 파일 ↔ 화면 매핑

| 화면 | 원천 xlsx | 성격 | 추출 MD |
|---|---|---|---|
| **DMF0082** FcstPrice MGMT | `(E20260706-000169)_FCSTPRICE MGMT 기준수요 기능 적용을 위한 수정 대상 식별 및 테스트케이스.xlsx` | 81 사업부 기준수요(MKT FCST+Sales Price+AS+Excel+배치) 이관 수정대상 식별 | [DMF0082_FcstPriceMGMT_기준수요적용_개발참조.md](DMF0082_FcstPriceMGMT_기준수요적용_개발참조.md) |
| **DMF0021** Sales Plan | `Sales Plan 화면 RTF 수정기능 추가 상세문서_수정내용+단위테스트 1.xlsx` | 81 RTF[R+P] 수정기능 추가 상세 + 단위테스트 128건 | [DMF0021_SalesPlan_RTF수정기능_개발참조.md](DMF0021_SalesPlan_RTF수정기능_개발참조.md) |
| **DMF0044** Sales Reports | `Sales Report 데이터 원천.xlsx` | 리포트 버전(Create/Copy) 저장·조회 테이블 원천 | [DMF0044_SalesReport_데이터원천_개발참조.md](DMF0044_SalesReport_데이터원천_개발참조.md) |

## 핵심 결정 하이라이트

- **DMF0082**: 40 전용 화면에 **81 MKT FCST(DMF0003)·Sales Price(DMF0020) 이관** / 모든 로직 **Div(40/81) 분기·하드코딩 금지** / 81 필수값=Plant Site ID·**Project Code**(40=End Customer) / Bucket 배분 81=단순 `입력값÷주차수` / 저장 테이블 6종 40↔81 매핑 / 81 Exchange Rate **Edit 불가** / SF_W CUTOFF 배치 신규
- **DMF0021**: **SCP Planner/SCM PI Admin 만 RTF[R+P] 수정** / **당주 월요일 이후 Sales Plan CUTOFF 존재 시에만 수정 RTF 적용**(이전엔 SCP RTF) / DM 계열은 **FCST Type=ETC 만** / 82 는 RTF_PR·RTF_BALANCE 메져 미노출 / 단위테스트 128건(권한×사업부×컷오프타이밍)
- **DMF0044**: Version Type **SP_W(Create)/REPORT_SP_W(Copy)** 분기 / ETC 원천=`DM_PLN_SALES_ETC_REPORT_C`(최신, DMF0049) — **Sales Plan 입력 ETC 제외** / 실적 기준일 설정여부가 실적구간 적재 좌우

## 연계 회의록 (같은 화면 "무엇을/왜")

- DMF0082 → [`ui_analysis_meet/DMF0082_FcstNPrice_회의참고_20260709.md`](../ui_analysis_meet/DMF0082_FcstNPrice_회의참고_20260709.md)
- DMF0021 → [`ui_analysis_meet/DMF0021_SalesPlan_회의참고_20260709.md`](../ui_analysis_meet/DMF0021_SalesPlan_회의참고_20260709.md)
- DMF0044 → [`ui_analysis_meet/DMF0044_SalesReports_회의참고_20260714.md`](../ui_analysis_meet/DMF0044_SalesReports_회의참고_20260714.md)

## 추출 원칙

- 원문 셀 그대로 보존(누락 0). 반복 순열(권한×사업부 등)은 매트릭스로 압축하되 원문 요지 유지.
- 스크린샷 이미지(빨간 네모 표기 등)·대용량 실행 로그(`TEST 결과` 5,065행)는 **원천 xlsx 참조**로 명시 — MD 에 미전재.
- SP/테이블/룩업/컬럼명은 **원문 식별자 그대로**(대소문자·언더스코어 포함).
