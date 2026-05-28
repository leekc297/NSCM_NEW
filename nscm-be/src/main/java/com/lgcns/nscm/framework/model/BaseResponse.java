package com.lgcns.nscm.framework.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.experimental.SuperBuilder;

@Getter
@SuperBuilder
@AllArgsConstructor
public class BaseResponse<T> {
    private final String code;
    private final String message;
    private final T result;
}
