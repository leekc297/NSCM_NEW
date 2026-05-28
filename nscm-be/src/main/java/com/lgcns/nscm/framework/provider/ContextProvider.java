package com.lgcns.nscm.framework.provider;


import java.util.Arrays;
import java.util.List;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class ContextProvider implements ApplicationContextAware {

    private static ApplicationContext appContext;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        appContext = applicationContext;
    }

    /**
     * ApplicationContextAware를 통해 Context를 변수에 저장
     *
     * @return ApplicationContext
     */
    public static ApplicationContext appContext() {
        return appContext;
    }

    /**
     * Spring Bean이름으로 BeanFactory에서 Bean을 찾는 메소드
     *
     * @param beanName String Spring에 등록된 Bean이름
     * @return T 찾은 Bean
     */
    @SuppressWarnings("unchecked")
    public static <T> T getBean(String beanName) {
        checkContext();
        return  (T) appContext.getBean(beanName);
    }

    /**
     * Spring Bean 클래스로 BeanFactory에서 Bean을 찾는 메소드
     *
     * @param clazz {@code Class<T>} 찾을 Bean 클래스
     * @return T 찾은 Bean
     */
    public static <T> T getBean(Class<T> clazz) {
        checkContext();
        String[] beanNames = appContext.getBeanNamesForType(clazz);
        return getBean(beanNames[0]);
    }

    /**
     * Spring Bean 클래스로 BeanFactory에서 Bean을 찾는 메소드
     *
     * @param clazz Class Bean class
     * @return {@code List<String>} 클래스로 찾은 Bean
     */
    public static List<String> getBeanName(Class<?> clazz) {
        checkContext();
        String[] beanNames = appContext.getBeanNamesForType(clazz);
        return Arrays.asList(beanNames);
    }

    /**
     * Classpath에 있는 Resource를 가져오는 메소드
     * @param location String location Resource location
     * @return Resource
     */
    public static Resource getResource(String location) {
        checkContext();
        return appContext.getResource(location);
    }

    private static void checkContext() {
        if (appContext == null) {
            throw new IllegalStateException("ApplicationContext not initialized");
        }
    }

}
