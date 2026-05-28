package com.lgcns.nscm.framework.property;


import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@ConfigurationProperties(prefix = "jvm")
public class JvmProperties {
//    private final String jasyptEncryptorPassword;
}
