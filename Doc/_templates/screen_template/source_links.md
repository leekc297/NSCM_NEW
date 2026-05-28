# [SCREEN_ID] — Legacy 소스 링크 인덱스

> **이 파일의 역할**: 바이브 코딩 시 분석 .md만으로 부족할 때 **Legacy 원본을 직접 열어볼 수 있도록** 모든 관련 소스 파일 경로를 한곳에 정리.

작성일: YYYY-MM-DD | 매핑된 As-Is: [SCREEN_ID]

---

## 1. csproj 위치

```
Doc/_legacy_source/06_UIL/domain_<X>/[SCREEN_ID]/
└── [SCREEN_ID].csproj
```

## 2. 화면 .cs 파일 (partial class 1 화면 분량)

| 파일 | 역할 | 라인 수 |
|---|---|---|
| `[SCREEN_ID].cs` | 메인 코드 (이벤트 핸들러·비즈니스 룰) | ~500 |
| `[SCREEN_ID].Designer.cs` | 자동 생성 — 컨트롤 정의·레이아웃 | ~800 |
| `[SCREEN_ID].resx` | UI 리소스 (문자열·이미지) | - |

전체 경로: `Doc/_legacy_source/06_UIL/domain_<X>/[SCREEN_ID]/`

## 3. 의존 라이브러리 (도메인 Common / Framework)

| 라이브러리 | 위치 | 역할 |
|---|---|---|
| GSCM.App.Core | `Doc/_legacy_source/01_Framework/GSCM.App.Core/` | 프레임워크 코어 |
| GSCM.Windows.Forms | `Doc/_legacy_source/01_Framework/GSCM.Windows.Forms/` | WinForms 베이스 |
| GSCM.SCM.Popup.UIL | `Doc/_legacy_source/06_UIL/common/GSCM.SCM.Popup.UIL/` | 마스터 팝업 |
| GSCM.<Domain>.Common.UIL | `Doc/_legacy_source/06_UIL/domain_<X>/GSCM.<Domain>.Common.UIL/` | 도메인 공통 |

## 4. 호출 SP 본문 (DB DDL)

| SP 이름 | 위치 | 라인 수 |
|---|---|---|
| (도메인)0001_GET_DATA | `Doc/_legacy_source/DB_DDL/SP_<file>.sql` (line N~M) | 156 |
| (도메인)0001_SAVE_DATA | `Doc/_legacy_source/DB_DDL/SP_<file>.sql` (line N~M) | 320 |

(또는 분리 보관: `Doc/_legacy_source/DB_DDL/sps_by_name/(도메인)0001_GET_DATA.sql`)

## 5. 사용 테이블 DDL

| 테이블 | 위치 |
|---|---|
| (도메인)_PLN_xxx | `Doc/_legacy_source/DB_DDL/Table_DDL.sql` |
| SCM_MST_yyy | `Doc/_legacy_source/DB_DDL/Table_DDL.sql` |

## 6. 사용 View DDL

| View | 위치 |
|---|---|
| (도메인)_xxx_V | `Doc/_legacy_source/DB_DDL/View_DDL.sql` |

## 7. 참조하는 외부 어셈블리

| dll | 위치 | 비고 |
|---|---|---|
| TheOne.4.5.dll | (외부 — packages/) | 미들웨어 코어 |
| FarPoint.Win.Spread.dll | (외부 — packages/) | 메인 그리드 |
| DevExpress.XtraEditors.v17.1.dll | (외부 — packages/) | 입력 컴포넌트 |

## 8. 빠른 검색 명령 (참고)

```bash
# csproj 내 모든 .cs 라인 보기
ls Doc/_legacy_source/06_UIL/domain_<X>/[SCREEN_ID]/*.cs

# SP 본문 grep
grep -A 5 "CREATE PROC.*\[(도메인)0001_GET_DATA\]" Doc/_legacy_source/DB_DDL/*.sql

# 컨트롤 검색 (Designer.cs)
grep -n "FarPoint\|DevExpress" Doc/_legacy_source/06_UIL/domain_<X>/[SCREEN_ID]/[SCREEN_ID].Designer.cs
```

## 9. 참고

- 화면 분석: [`analysis.md`](./analysis.md)
- To-Be 설계: [`tobe_design.md`](./tobe_design.md)
