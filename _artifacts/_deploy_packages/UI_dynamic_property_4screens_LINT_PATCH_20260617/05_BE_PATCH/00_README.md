# BE Patch — 클라우드 BE 의 callSettersOnNulls 미적용 fix (2026-06-17)

## 배경

| 항목 | 사내 | 클라우드 |
|---|---|---|
| Oracle SP cursor 컬럼 수 | 129 (12 BASE + 9 Y# + 108 M#) | 129 (동일) |
| 화면 응답 JSON `result.data[0]` keys | Y#/M# 포함 ✅ | **12 BASE 만 (Y#/M# 누락)** ❌ |

= Oracle layer 완전 정상. **BE 빌드 시점 차이로 인한 MyBatis 매핑 동작 차이**.

## Root cause

사내 main commit `eb1686c` (2026-06-01 18:45) — DMF0043 풀스택 commit 에 다음 2개 BE fix 포함:

1. `mybatis-config.xml` — `callSettersOnNulls=true` 설정 추가
2. `CustomMap.java` — `value == null` 가드 추가 (callSettersOnNulls 활성화 후 NPE 방지)

### MyBatis 동작 (callSettersOnNulls 미설정 시 — 클라우드 BE 현재 상태)

- 기본값 `callSettersOnNulls=false`
- cursor 첫 row 의 NULL column setter 호출 skip
- DMF0043 의 dynamic 컬럼 (`Y#YYYY#CODE`, `M#YYYYMM#CODE`) 의 값이 NULL 인 경우 result Map 에 key 자체가 들어가지 않음
- 결과: 응답 JSON 에 `Y#...`, `M#...` 키 누락 (= 사용자 보고 시나리오 정확히 일치)

### callSettersOnNulls=true 활성화 후 (사내 BE 현재 상태)

- NULL column 의 setter 도 호출
- 모든 cursor column 이 result Map 에 key 로 포함 (값이 NULL 여도)
- 부작용: 기존 CustomMap.put(key, value) 가 `value.getClass()` 호출 시 NPE
- → CustomMap.java 에 NPE 가드 추가 (commit eb1686c 동반)

## 적용 대상 파일

| 파일 | 클라우드 경로 |
|---|---|
| `mybatis-config.xml` | `nscm-be/src/main/resources/mybatis/mybatis-config.xml` |
| `CustomMap.java` | `nscm-be/src/main/java/com/lgcns/nscm/framework/model/CustomMap.java` |

→ 두 파일 모두 사내 main 의 commit `eb1686c` 본문 그대로.

## 적용 방법 — 클라우드 BE 재빌드 + 재배포

1. 클라우드 BE source 의 위 2 파일을 본 폴더 파일로 교체
2. `./gradlew build -x test` 또는 IDE 빌드
3. 생성된 jar 로 BE 재배포 + 재시작
4. 화면 검증 — DMF0043 진입 + 조회 → Network 탭 `call-proc` 응답의 `result.data[0]` keys 에 `Y#...`, `M#...` 포함 확인

## 변경 내용 diff 요약

### mybatis-config.xml — `<settings>` 블록 안 1줄 추가

```xml
<setting name="jdbcTypeForNull" value="NULL"/>
<setting name="defaultFetchSize" value="0"/>
+ <!-- callSettersOnNulls=true : cursor NULL 값도 result Map 에 포함 (DMF0043 PIVOT 전체 컬럼 보장, 2026-06-01) -->
+ <setting name="callSettersOnNulls" value="true"/>
```

### CustomMap.java — `put()` 메서드 안 NULL guard 추가

```java
public Object put(String key, Object value) {
+    // [Fix 2026-06-01] callSettersOnNulls=true 활성화 시 cursor NULL 컬럼이 들어옴.
+    // 아래 value.getClass() 호출이 NPE → null 은 그대로 저장하고 즉시 리턴.
+    if (value == null) {
+        return super.put(key, null);
+    }

    // CLOB 변환 로직
    if (value instanceof java.sql.Clob) { ... }
}
```

## 사고 영향 범위

본 BE fix 가 없으면 다음 화면도 동일 사고 가능:

- DMF0043 (해외법인 기여율 등록) ⭐ 본 사고 화면
- DMF0008 (Customer FCST Summary/Repair/SSPM) — PIVOT 사용
- DMF0072 (NN Master Mapping)
- 기타 PIVOT 또는 dynamic column 사용 화면

→ BE fix 후 위 화면 모두 dynamic column 정상 표시 기대.

## 작성 정보

- 작성 일자: 2026-06-17
- 사내 commit: `eb1686c` (2026-06-01 18:45 KST) "feat: DMF0043 풀스택 + Plan Stage 1-5"
- 파일 출처: 사내 main 의 위 2 파일 그대로 복사
