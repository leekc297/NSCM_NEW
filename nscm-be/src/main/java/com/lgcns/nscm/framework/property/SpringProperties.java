package com.lgcns.nscm.framework.property;

import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@ConfigurationProperties(prefix = "spring")
public class SpringProperties {
    private final Application application;
    private final Profiles profiles;

    @Getter
    @RequiredArgsConstructor
    public static class Application {
    	private final String name;
    }

    @Getter
    @RequiredArgsConstructor
    public static class Profiles {
    	private final String active;
    }

}
