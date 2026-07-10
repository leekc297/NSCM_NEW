# GRANT/SYNONYM — 추가 작업 불필요 (근거)

- `_artifacts/_apply_corporate/63_sys0013_pkg_grant.sql` 이 **패키지 단위** `GRANT EXECUTE ON PKG_SYS0013 TO SCMD_APP` 를 이미 적용 — 이번에 추가된 신규 멤버 5종(P_SYS0013_GET_HISTORY / SAVE_USER_GROUP / DELETE_USER_GROUP / EXECUTE_HIST / VALIDATE_QUERY)은 **자동 커버**된다.
- SYNONYM `PKG_SYS0013` 도 `64_sys0013_synonym_scmd_app_user.sql` 로 기존 생성 완료 — 멤버 추가는 SYNONYM 영향 없음.
- standalone SP 신규 GRANT 불필요 — API_M 배선이 전부 PKG 경로로 갱신됨 (구 standalone 은 D3 결정으로 보존만, 앱 미참조).
