# GAP 요약 — 2026-10-20 (1화면)

| 화면 | 매핑표 | 엔드포인트 C/I/M | 이벤트 C/I/M/U | 컨트롤 C/I/M/U | 시트 미대사 | 하드컬럼 미대사 | 점수 |
|---|---|---|---|---|---|---|---|
| SCP0100 | - | 3/1/0 | 6/0/0/12 | 8/0/0/17 | 0/3 | 0/0 | 38 |

C=COVERED(대응 근거 있음) I=INTENDED(의도된 차이) M=MISSING(대응 없음) U=UNMAPPED(매핑표 없거나 DB 메타가 있어야 판단 가능). 점수 = (C+I)/(엔드포인트+이벤트+컨트롤 전체).

**주의** 엔드포인트 MISSING 의 상당수는 SP 가 Oracle 메타(SCM_ADM_PROC_M) 에만 등록되어 소스에 이름이 없는 경우다 — 클라우드에서 `PR_GET_PROCEDURES_METADATA` 결과(메뉴×시트×버튼×PKG.SP) 를 CSV 로 내려 `Doc/tobefacts/db/proc_meta.csv` 에 두면 gap.js 가 COVERED 로 재판정한다(다음 단계).
