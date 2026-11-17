package com.lgcns.nscm.framework.security.sqlguard;

/** 주입 위반 1건. field=위반 발생 필드 경로(예: data[1].itemId), signature=매칭된 시그니처. */
public record SqlInjectionViolation(String field, String signature) {
}
