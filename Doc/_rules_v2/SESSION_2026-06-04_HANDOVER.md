# 세션 인계 노트 — 2026-06-04

> 본 세션 종료 + 다음 세션 연결용 종합 노트.

## §0 세션 작업 흐름

| Phase | 작업 | 산출물 |
|---|---|---|
| 1 | 룰 04/07 §2 변형 보강 (a)+(b)+(c) | _tobe/04_store §2.6/§2.7 + _tobe/07_datagrid §2.7~§2.9 + DMF0008 fetchSearchConditions |
| 2 | Phase 7 PoC 보완 5~7 메타-룰 종합 | meta-rule-evolution.md (7 메타-룰) + 메모리 1건 |
| 3 | 보완 8 cascade 매핑 | DMF0008/cascade-mapping.md (5 handler) |
| 4 | 보완 9+10 G3/G4 검증 | DMF0008/g3-g4-validation.md |
| 5 | 룰 07 §2.10 cell cascade 변형 절 정형화 | §2.10.1~§2.10.8 + Hook 2건 + 메모리 1건 |
| 6 | DMF0007/0004 cascade cross-check | 2 cascade-mapping.md + §2.10.6 modal callback 신규 발견 |
| 7 | 자동 전체 진행 (B1~F5 + A2 G6 UI) | 22 파일 + Phase7 마감 보고서 |
| 8 | 사용자 결정 5건 자동 진행 (B4/A3/A1/B3) | 13 파일 + G5 BE 전체 + G3 enum + DMF0006/0007 cascade 보강 + B4 buildSalesSite fix |
| 9 | 적용 절차 (G5 메타 SQL / B4 검증 / BE 재기동) | Oracle SCM_SYS_FILE + SCM_ADM_API_M + BE PID 51556 + minyonglee1 재로그인 OK |
| 10 | 4 신규 화면 (SCM0008/0009/0003/0005) | 분석 4 + FE 21 파일 + 메타 SQL 3 + 라우팅 등록 + 권한 복제 |
| 11 | 메모리 룰 보강 | feedback_new_screen_features_location.md + 룰 v2 §1.3/§1.4 + CLAUDE.md Step 3.5 |

→ 본 세션 누적 산출물 **80+ 파일** (신규 60+ + 수정 20+).

## §1 현재 운영 상태

| 항목 | 상태 |
|---|---|
| Docker Oracle (nscm-oracle) | Up 33+ hours |
| BE (PID 51556) | LISTEN :8080 / local profile / G5 endpoint + G3 PERF enum 활성 |
| FE | Vite HMR — cascade fix / B3 / B4 buildSalesSite 자동 반영. 라우팅 변경 (SYS0012/0013 추가) 은 사용자 새로고침 필요 |
| 사용자 세션 | minyonglee1 04:18:49 재로그인 / 45 메뉴 권한 |
| Oracle DB | SCM_SYS_FILE 테이블 / SCM_ADM_API_M G5 3 row + SCM0008 7 row + SCM0009 3 row + SCM0005 9 row / SYS0011/0012/0013 메뉴 + 권한 복제 OK |

## §2 다음 세션 즉시 진행 가능 작업

### §2.1 우선순위 高 (사용자 검증 + 격차 마감)

| # | 작업 | 사유 |
|---:|---|---|
| 1 | **FE 새로고침 + 4 신규 화면 진입 검증** | 라우팅 (SYS0012 auth-approval / SYS0013 dynamic-query) 활성화 — 사용자 브라우저 확인 |
| 2 | **SCM0003 격차 #1 SP wire** | `SCM0003_AFTER_LOOKUP_MASTER_DETAIL` BE 메타 등록 + Lookup.tsx:90~93 TODO 해소 |
| 3 | **SCM 4 화면 BE SP body 변환 (19 SP)** | AS-IS MSSQL → Oracle 변환 (룰 _analysis/db_migration/) — 화면 동작 활성화 의무 |
| 4 | **DMF0004 City slice 사용자 검증** | DB 2936/2936 rows 5-char CITY 확정 + buildSalesSite slice(2,5) fix — UI 확인 |
| 5 | **B3 cascade 즉시 구현 2건 UI 테스트** | DMF0006 음수 보정 + DMF0007 MEASURE CUST_FCST 차단 |

### §2.2 잔존 격차 작업

| # | 작업 | 결정 |
|---:|---|---|
| 6 | cascade 격차 23건 보강 (DMF0004/0005/0007 위주) | 격차별 사용자 결정 |
| 7 | G6 yesNoCancel UI 사용자 테스트 (DMF0020 등 적용) | UI 테스트 |
| 8 | G3 PerfLog 실제 측정 메서드 `@SystemLog(LogType.PERF)` 부착 | 메서드 선정 |
| 9 | EditTracker `getOriginalValue` API 표준 정의 | 메모리 / 룰 v2 보강 |
| 10 | i18n MSG 신규 등록 (MSG00136/0149/0177/0379 등 5+) | 룰 13 절차 |

### §2.3 메타 작업

| # | 작업 |
|---:|---|
| 11 | F6/H1 룰셋 v2 → `_dev_rules/` 최종 rename (보류 중) |
| 12 | G1 메모리 50+ 분류 (룰 흡수 / archive) |
| 13 | Top 30 popup deep-dive (lazy) |
| 14 | Phase 5 도메인 화면 lazy 분석 (332 화면) |

## §3 활성 라우팅 (FE)

```typescript
// nscm-fe/apps/web/src/core/Router.tsx
/admin/admin-menu/lookup        → SYS0010 Lookup (기존)
/admin/admin-menu/dynamic-query → SYS0013 Dynamic Query (신규, 본 세션)
/authority/auth-mgmt/auth-request  → SYS0011 Auth Request (기존)
/authority/auth-mgmt/auth-approval → SYS0012 Auth Approval (신규, 본 세션)
```

## §4 메모리 보강 학습 (Phase 7 메타-룰)

| # | 메타-룰 | 발견 시점 |
|---:|---|---|
| 1 | 표준 (§1) 작성 전 reference 화면 cross-check 의무 | Phase 6 |
| 2 | PoC 가 결함이면 룰이 결함 | Phase 6 |
| 3 | 변형 절 (§2) 의 의무 | Phase 7 |
| 4 | 사용자 작업물 우선 (anti-simplification 의 반대편) | Phase 7 |
| 5 | 운영 룰의 일급 시민화 | Phase 7 |
| 6 | 기존 사용자 작성 화면도 PoC 가치 | Phase 7 |
| 7 | 메타-룰 자체의 룰화 | Phase 7 |
| 8 | 다중 reference 의 의무 (5+ sub-pattern × 2+ ref) | Phase 7 후속 |
| **9** | **features 폴더 결정 의무 (트리 walk-up + 인벤토리 grep)** | **본 세션 SCM0008 사고 학습** ⭐ |

## §5 본 세션 산출물 인벤토리 (요약)

- **룰 v2**: meta-rule-evolution.md, 7 cascade-mapping.md (DMF0004~8/SCM0008/9/3/5 분석), g3-g4-validation.md, 4 Hook, 3 메모리, SCM_4SCREENS_PLAN.md, PHASE7_FINAL_REPORT.md, SESSION_2026-06-04_HANDOVER.md
- **FE**: 4 신규 화면 (auth-request/approval + dynamic-query + 기존 lookup cross-check) + ROUTE_PATHS/Router.tsx + DMF0006/0007 cascade 보강 + DMF0004 buildSalesSite fix + DMF0008 G1 GET + G6 AlertModal yesNoCancel + G5 useFileTransfer hook
- **BE**: G5 FileController/Service/Impl + sql/general/File.xml + SystemLog enum PERF + SystemLogAspect 분기 + config-local.yml file.storage.path
- **Oracle DB**: SCM_SYS_FILE 테이블 + SCM_ADM_API_M 22 row (G5 3 + SCM0008 7 + SCM0009 3 + SCM0005 9) + SYS0013 메뉴 + 권한 복제 14 row
- **메타 SQL**: G5/SCM0008/0009/0005 4 파일

## §6 다음 세션 시작 시 권장 명령

1. 본 인계 노트 Read: `Doc/_rules_v2/SESSION_2026-06-04_HANDOVER.md`
2. Phase 7 최종 보고서 Read: `Doc/_rules_v2/PHASE7_FINAL_REPORT.md`
3. SCM 4 화면 계획 Read: `Doc/_rules_v2/SCM_4SCREENS_PLAN.md`
4. 진입점 3 파일 확인: anti-simplification.md + CLAUDE.md + 00_INDEX.md
5. 사용자 결정 항목 확인 (§2.1 5건 + §2.2 5건 + §2.3 4건)

## §7 변경 이력

| 일자 | 변경 |
|---|---|
| 2026-06-04 | 본 세션 종료 인계 노트 작성. 80+ 파일 산출. 다음 세션 14 작업 후보 명시 |
