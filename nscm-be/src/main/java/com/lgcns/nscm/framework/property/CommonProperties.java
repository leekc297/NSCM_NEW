package com.lgcns.nscm.framework.property;

import java.util.List;
import java.util.Vector;

import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
@ConfigurationProperties(prefix = "config")
public class CommonProperties {
    private final Async async;
    private final Security security;
    private final File file;
    private final Mail mail;
    private final Mybatis mybatis;
    private final List<Datasource> datasources;
    private final Domain domain;
    private final Sso sso;

    @Getter
    @RequiredArgsConstructor
    public static class Async {
    	private final int corePoolSize;
    	private final int maxPoolSize;
    	private final int queueCapacity;
    	private final String threadNamePrefix;
    }

    @Getter
    @RequiredArgsConstructor
    public static class Security {
    	private final List<String> skipUris;
    }

    @Getter
    @RequiredArgsConstructor
    public static class File {
    	private final String path;
    	private final String uploadPath;
    	private final String downloadPath;
    }

    @Getter
    @RequiredArgsConstructor
    public static class Mail {
    	private final String host;
    	private final String port;
    	private final String user;
    	private final String testUser;
    	private final String password;
    	private final String smtpAuth;
    	private final String smtpStarttlsEnable;
    	private final String smtpSslEnable;
    	private final String smtpSslTrust;
    }

    @Getter
    @RequiredArgsConstructor
    public static class Mybatis {
    	private final boolean loggingEnabled;
    	private final boolean loggingOnlyError;
    	private final int queueCapacity;
    	private final int batchSize;
    	private final int logPoolSize;
    	private final long flushIntervalMs;
    }

    @Getter
    @RequiredArgsConstructor
    public static class Datasource {
    	private final String databaseName;
    	private final String databaseType;
    	private final String driverClassName;
    	private final String jdbcUrl;
    	private final String username;
    	private final String password;
    	private final int maxPoolSize;
    	private final int minIdel;
    	private final String connectionTestQuery;
    	private final String mapperLocations;
    	private final String configLocations;
    }

    @Getter
    @RequiredArgsConstructor
    public static class Domain {
    	private final String fe;
    	private final String be;
    }

    @Getter
    @RequiredArgsConstructor
    public static class Sso {
    	private final String serviceName;
    	private final String serverUrl;
    	private final String serverPort;
    	private final String nlsUrl;
    	private final String nlsPort;
    	private final String nlsLoginUrlSuffix;
    	private final String nlsLogoutUrlSuffix;
    	private final String nlsErrorUrlSuffix;
    	private final String ascpUrlSuffix;
    	private final String ndUrl;
    	private final String ssoDomain;
    	private final String toa;
    	private final String redirectSuffix;
    	private final int cookieSessionTimeout;
    	private final int timeout;
    	private final Vector<String> providerList;
    }
}
