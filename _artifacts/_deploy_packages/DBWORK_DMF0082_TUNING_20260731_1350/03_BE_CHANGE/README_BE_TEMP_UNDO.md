# 03 BE 변경 — TEMP_UNDO 커넥션풀 init (클라우드 BE 배포 시 포함)

> DB 스크립트 아님. 클라우드 BE 를 다음 배포할 때 함께 반영하는 코드 변경입니다.
> 이 변경 없이도 01(SP)·프루닝은 동작합니다 — TEMP_UNDO 는 redo 절감(−97%) 추가 이득.

## 변경 파일 (1지점)

`nscm-be/src/main/java/com/lgcns/nscm/framework/dao/NDBConnection.java`
— `hikariConfig.setDataSourceProperties(prop);` 직후:

```java
// 4. [성능 최적화] GTT(임시테이블) DML redo 제거 (TEMP_UNDO)
// 세션이 GTT 를 처음 사용하기 전에 설정되어야 유효하므로 커넥션 생성 시점에 1회 실행합니다.
if ("oracle".equalsIgnoreCase(sDbTp)) {
    hikariConfig.setConnectionInitSql("ALTER SESSION SET TEMP_UNDO_ENABLED = TRUE");
}
```

## 근거·검증 (사내 2026-07-31)

- redo 239MB → **7.6MB (−97%)** / 결과 행수 불변 / BE 기동 정상 (풀 11세션)
- init SQL 실패 시 Hikari 가 해당 커넥션을 폐기하므로 조용한 실패 없음
- 로그 전용 풀은 GTT 미사용이라 제외 (업무 풀만 적용)

## ⚠ 클라우드 셸 주의

클라우드 셸(mdi)은 신·구 세대 혼재 이력이 있으므로 **파일 단위 덮어쓰기 금지** — 폴더 전체 checkout 후 이 1지점을 diff 로 반영하십시오.
