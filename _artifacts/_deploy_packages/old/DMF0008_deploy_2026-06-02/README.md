# DMF0008 — ERP EDI Master 클라우드 이관 패키지

작성: 2026-06-02
대상 환경: NSCM 클라우드 (Oracle 19c + Spring Boot + React)

---

## 1. 개요

DMF0008 (ERP EDI Master) 화면 3단 구조 (Summary + Repair + Sub 2-tab) + Update History + Status Update Button.

### 1.1 적용 범위

| 영역 | 변경 |
|---|---|
| FE | 신규 화면 `erp-edi-master` (8 파일) |
| DB 메타 | API_M / BTN_MPG / PROC_M / GUEST 권한 (summary/repair/site/project/salesSite/sspm + updateHistory + STATUS_UPDATE) |
| SP / PKG | (As-Is 변환분은 별도 deploy — 본 패키지는 메타 중심) |

---

## 2. 폴더 구조

```
DMF0008/
├── README.md
├── 01_FE/
│   └── erp-edi-master/                 ← 화면 파일 (8 파일)
├── 02_DB_Meta_SQL/                     ← DB 메타 등록
│   ├── 43_DMF0008_meta.sql             ← 초기 메타 (6 SP)
│   ├── 49_DMF0008_meta.sql             ← Phase 1 SUMMARY sheet
│   ├── 50_DMF0008_phase2_meta.sql      ← Phase 2 REPAIR + SALES_SITE + SSPM
│   └── 51_DMF0008_status_update_meta.sql ← Status Update Button
├── 03_SP_PKG/                          ← (As-Is 변환 SP 는 별도 관리)
└── 04_Verify/                          ← Verify SQL (각 메타 SQL 의 BLOCK 5/6 사후 카운트)
```

---

## 3. 적용 순서

### Step 1. DB 메타 등록 (02_DB_Meta_SQL/) — 순서 의무

```
1) @43_DMF0008_meta.sql        → 초기 메타 (MSG_M 6 / API_M 6 / BTN_MPG 6 / PROC_M 6 SP × 인자 / GUEST 권한)
2) @49_DMF0008_meta.sql        → Phase 1 SUMMARY sheet (멱등 NOT EXISTS)
3) @50_DMF0008_phase2_meta.sql → Phase 2 REPAIR + SALES_SITE + SSPM (멱등)
4) @51_DMF0008_status_update_meta.sql → Status Update Button (멱등)
```

각 BLOCK 사후 카운트 PASS 확인.

### Step 2. FE 파일 배포 (01_FE/)

```
erp-edi-master/ → nscm-fe/features/master/src/pages/erp-edi-master/  (디렉토리 전체)
```

### Step 3. BE 재시작

PROC_M 메타 추가 → WAS 재기동 권장 (안전).

### Step 4. 브라우저 검증

1. 메뉴 DMF0008 (ERP EDI Master) 진입
2. Division 콤보 → MyDivision 권한 기반 동적 lookup 동작 확인
3. 조회 → Summary grid 표시, row 더블클릭 → Sub 영역 (Sales Site / SSPM) 표시
4. Repair 영역 표시 + 합계 수량 카운트
5. **Status Update** 버튼 클릭 → `PR_DM_DNM_EDI_CALLOFF_STATUS` 호출 → Summary + Repair 재조회 + Update History 갱신
6. Update History (Start/End/Updated By) 표시 확인

---

## 4. 의존성

| 항목 | 위치 |
|---|---|
| As-Is `.cs` | `Doc/_legacy_source/06_UIL/domain_DM/.../DMF0008_ErpEdiMaster/` |
| As-Is SP | `Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP*_DDL.sql` (`DMF0008_GET_*` 검색) |
| To-Be SP (전제) | `DMF0008_GET_EDI_MST_SUMMARY/REPAIR`, `DMF0008_GET_SALES_SITE`, `DMF0008_GET_SALES_SITE_PROJECT_MODEL`, `DMF0008_GET_MY_DIVISION_LIST`, `DMF0008_GET_UPDATE_HISTORY`, `PR_DM_DNM_EDI_CALLOFF_STATUS` |

---

## 5. 영향 분석

| 테이블 | 신규 row |
|---|---|
| `SCM_ADM_MSG_M` | 6+1+3+1 (KO) |
| `SCM_ADM_API_M` | 6+1+3+1 |
| `SCM_ADM_MNU_BTN_MPG_M` | 6+1+3+1 |
| `SCM_ADM_PROC_M` | 50+ row |
| `SCM_ADM_USER_GR_MNU_BTN_MPG_M` (GUEST) | 6+1+3+1 |

---

## 6. 변경 이력

- 2026-06-02: 본 패키지 작성 (DMF0008 ERP EDI Master 메타 + FE 통합)
