# UI 분석 회의록 — 화면별 참고 자료 인덱스

> 음성인식 회의록(txt 원본)을 화면별 분석 참고 MD 로 추출한 폴더.
> **화면분석(hook #105) 착수 시 대상 화면의 회의참고 MD 를 원천에 포함할 것** — 확정 사항(㉮)·업무 규칙(㉯)은 분석서 시트 1/3/9 에, TODO(㉰)는 격차/후속에 반영.

## 회의록 ↔ 화면 매핑

| 회의 | 원본 | 주요 의제 | 추출 MD |
|---|---|---|---|
| 2026-07-07 (47분) | `UI_Meet_20260707.txt` | **DMF0003** Marketing FCST 설명 | [DMF0003_MktFcst_회의참고_20260707.md](DMF0003_MktFcst_회의참고_20260707.md) |
| 2026-07-09 (79분) | `UI_Meet_20260709.txt` | **DMF0082** Forecast&Price 관리 | [DMF0082_FcstNPrice_회의참고_20260709.md](DMF0082_FcstNPrice_회의참고_20260709.md) |
| 〃 | 〃 | **DMF0021** Sales Plan (+연관: 세일즈 리포트/ETC 세일즈/비즈니스 플랜) | [DMF0021_SalesPlan_회의참고_20260709.md](DMF0021_SalesPlan_회의참고_20260709.md) |
| 〃 | 〃 | 화면 무관 공통 (배포 절차/알림톡/공통 세팅) | [COMMON_공통사항_회의참고_20260709.md](COMMON_공통사항_회의참고_20260709.md) |
| 2026-07-14 (55분) | `UI_Meet_20260714.txt` | **DMF0044** Sales Reports (버전 SP/BP·카피·환율·ALL 조인) | [DMF0044_SalesReports_회의참고_20260714.md](DMF0044_SalesReports_회의참고_20260714.md) |
| 〃 | 〃 | **DMF0042** Business Plan (워터폴 measure·세일즈 프라이스 SP전용·환율 USD only) | [DMF0042_BizPlan_회의참고_20260714.md](DMF0042_BizPlan_회의참고_20260714.md) |
| 〃 | 〃 | **DMF0049** ETC Sales Reports (컷오프+ETC 조인·ETC=Insert 지점) | [DMF0049_SalesETCReports_회의참고_20260714.md](DMF0049_SalesETCReports_회의참고_20260714.md) |
| 〃 | 〃 | 공통·타화면 (81→Confirm Mkt Demand overwrite / Sales Site validation / 워터폴·템플릿·Customer FCST) | [COMMON_공통사항_회의참고_20260714.md](COMMON_공통사항_회의참고_20260714.md) |
| (문서) | `DM 프로세스 정리_rev1.0 1.pptx` (35슬라이드) | **DM 프로세스 전반** — 메저 정의(DB↔화면표기↔사업부별)·Cut off·Weekly Rolling 등 배치 프로시저 상세·ERP/재고/Customer Master/PROJECT/BPS 인터페이스·데이터 클렌징/Purge | [DM_프로세스정리_rev1.0_참고.md](DM_프로세스정리_rev1.0_참고.md) |

## 단락 커버리지 (누락 0 대사 — 2026-07-09)

- 0707 회의록 9단락 → DMF0003 MD 9단락 수록 ✓
- 0709 회의록 14단락 → DMF0082 5 + DMF0021 5 + COMMON 4 = 14단락 수록 ✓
- 0714 회의록 9단락 → DMF0044 2 + DMF0042 1 + DMF0049 (0044·0042 단락 내 ETC 귀속) + COMMON 5 = 9단락 수록 ✓ (00:01·07:58 단락은 리포트 3화면 공유 귀속)

## 핵심 결정 하이라이트

- **DMF0003**: 편집 권한 82만 / Initialize 버튼 제거(인터페이스 대체) / DMF0003·`_1`·`_T` 는 **별개 화면**(AS-IS 소스 혼재 — 분리 확인 중) / 데일리 합=위클리=먼슬리 롤업
- **DMF0082**: ⭐ 사용 사업부 40 → **40·81·81_ 확장 예정 — 하드코딩 없이 제약은 LOOKUP 데이터로 관리** (사용자 확정 2026-07-09) / 81 프로세스를 40과 동일하게 테이블 마이그레이션 / BPS 환율 인터페이스 1일 2회
- **DMF0021**: SCP 플래너가 RTF 수정 / **컷오프 전만 수정 가능** / 연관 화면(리포트/ETC 세일즈)은 별도 화면 — 분석 시 ID 확정
- **DMF0044 Sales Reports** (2026-07-14): 리포트 타입→**SP/BP 버전 접두 스탬프** / 권한=**Admin 전용** / 카피=버전 복제+신규 채번 / ⭐ **카피 환율=버전별 컷오프 시점 환율(최신 금지)** / 데이터타입 ALL=**컷오프+ETC 조인**
- **DMF0042 Business Plan** (2026-07-14): ⭐ **세일즈 프라이스 measure=SP 전용, BP엔 없음(추정)** / 워터폴 참고=Sales Amount LOC / **환율 환산=USD만**(LOC·KRW 그대로) / 세일즈 프라이스 LOC=**RTFCSRP 수량으로 나눈 단가** / measure 재삽입=원래 순서 복원 / 사용자별 저장
- **DMF0049 ETC Sales Reports** (2026-07-14): ETC=**컷오프와 조인되는 별도 원천**이자 **유일한 Insert 지점**(FCST Type='ETC'만) / DMF0044 와 POPUP·권한 공유 자매 화면
- **공통(0714)**: ⭐ **81=Cell Product Site 미사용→Confirm Marketing Demand Plan 테이블 overwrite** / 워터폴 자체엔 **컷오프·확정 기능 없음** / Sales Site Project Model **기준 validation** / 커스터머 포케스트 워터폴=**불필요**(다이나믹쿼리 raw+리포터 대체)

## 작성 원칙

- 음성인식 원문 보존 + 해석은 `(추정: …)` 병기 — 무근거 단정 금지. 각 MD 하단 **용어 정정표**(확신도 표기) 참조.
- 형식: ㉮ 확정 사항 / ㉯ 업무 규칙 / ㉰ TODO / ㉱ 단락별 원문 요지(전수) / 용어 정정표.
