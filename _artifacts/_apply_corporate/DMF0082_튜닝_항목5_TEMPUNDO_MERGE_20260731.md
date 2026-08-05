# DMF0082 튜닝 [항목5] TEMP_UNDO 커넥션풀 init + MERGE 조인순서 고정 (2026-07-31)

> 상태: SP 패치 **사내 배포 완료** / BE 코드 수정·컴파일 완료 — **재기동 대기** / 클라우드 미적용

---

## 1. MERGE 조인순서 고정 (SP +1라인, 사내 배포 완료 ✅)

### 문제 (실측)
L2710 LOC 통화 MERGE — hash build 를 **355K 와이드행**(TEMP_FCST_N_PRICE 전체)으로 잡음:
- 원인: 동적샘플링이 9컬럼 GROUP BY 집계뷰 출력을 **133K 로 24배 과대추정** (실제 5,584)
- 결과: hash 메모리 206MB + **TEMP spill 159MB** (Reads/Writes 15,624), 1.38초

### 조치
```sql
MERGE /*+ LEADING(B) USE_HASH(A) */ INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
```
조인 **입력 순서만** 변경 (결과 불변). 적용 후 계획: build = 집계뷰(SORT GROUP BY), **Used-Mem 6MB / TEMP spill 0**.

### 게이트
`VALID` / `USER_ERRORS 0` / 라인 12,919 → 12,920 (+1 일치) / 결과 div40 **1,974** · div81 **422** 불변.
파일: `PKG_DMF0082_MERGE_SWAP_20260731.sql` / 백업 `BACKUP_PKG_DMF0082_pre_mergeswap_20260731.sql`

---

## 2. TEMP_UNDO_ENABLED — BE 커넥션풀 init (사용자 확정 스코프)

### 배경
- GTT DML(INSERT 292K + DELETE 297K + MERGE)이 **redo 239MB/회** 생성 — DELETE 4.63초 중 2.9초가 비-CPU(undo/redo I/O)
- **세션이 GTT 를 처음 쓰기 전에 설정돼야 유효** → SP 내부 `ALTER SESSION` 불가(커넥션풀 재사용), "이 화면만" 적용 기술적 불가
- 사용자 확정: **BE 커넥션풀 init 방식** (DB 전역 무영향)

### 변경 — `NDBConnection.java` 1지점 (Oracle 풀만)
```java
// 4. [성능 최적화] GTT(임시테이블) DML redo 제거 (TEMP_UNDO)
if ("oracle".equalsIgnoreCase(sDbTp)) {
    hikariConfig.setConnectionInitSql("ALTER SESSION SET TEMP_UNDO_ENABLED = TRUE");
}
```
- `compileJava` 통과. **BE 재기동 시 활성화** (Hikari 가 물리 커넥션 생성 시 1회 실행; init 실패 시 커넥션 자체가 거부되므로 조용한 실패 없음)
- ⚠ BE 변경 금지 원칙의 예외 — 사용자 명시 선택(2026-07-31). 로그 전용 풀은 GTT 미사용이라 제외.

### A/B 실측 (사내, MERGE 패치 후)
| | div40 | div81 |
|---|---|---|
| TEMP_UNDO OFF | 9.59초 / redo **239.0MB** | 5.63초 / redo 94.4MB |
| TEMP_UNDO ON | 9.65초 / redo **7.6MB (−97%)** | 5.55초 / redo 6.2MB (−93%) |

**정직한 평가**: 현재(저부하)는 wall 차이가 없음 — LGWR 가 비동기로 흡수 중. redo 절감은 **구조적 이득**으로, ①인스턴스 부하 시(앞서 15.4→11.5초 실측) ②다중 사용자 동시 조회 ③클라우드에서 효과가 발현됨. 결과 행수는 4회 모두 불변.

---

## 3. 현재 성적 (사내, 저부하 시점)

| division | 세션 시작 시점(항목1 전) | 현재 | 목표 |
|---|---:|---:|---:|
| 40 | 11~13초 (부하 시 31초) | **9.6초** | 5초 |
| 81 | 7.9~10초 | **5.6초** | 5초 ✅ 근접 |

남은 대형 비용(div40): 통계수집 40회+동적샘플링 약 4초(28%) / INSERT·DELETE CPU 약 3.5초. 통계 호출 합리화는 카디널리티 품질 리스크가 있어 별도 검토 항목.

---

## 4. 다음 액션

1. **BE 재기동** (사용자) → 재기동 후 재로그인 필요. 이후 UI 체감 측정.
2. 클라우드 이관 취합: 항목1(사전검증 [2] 40·82 회신 대기) + 파티션 프루닝 + MERGE 힌트 + BE 변경(클라우드 BE 배포 시 포함).
