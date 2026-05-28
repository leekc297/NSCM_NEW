package com.lgcns.nscm.framework.utils;


import java.util.List;
import java.util.Map;

import org.springframework.web.reactive.function.client.WebClient;

import reactor.core.publisher.Flux;

public class WebClientUtils {

    private final WebClient webClient;

    public WebClientUtils(String endPoint, List<Map<String, Object>> optionList) {

        this.webClient = WebClient.builder()
                .baseUrl(endPoint) // SOAP 서버 URL
                .defaultHeaders(httpHeaders -> {
                    for (Map<String, Object> entityObject : optionList) {
                        httpHeaders.add(entityObject.get("headerKey").toString(), entityObject.get("headerValue").toString());
                    }
                })
                .build();
    }

    public Flux<String> retrieveNonBlock(String requestData) {
        return this.webClient.post()
                .bodyValue(requestData)
                .retrieve()
                .bodyToFlux(String.class);
    }

    public String retrieveBlock(String requestData) {
        return this.webClient.post()
                .bodyValue(requestData)
                .retrieve()
                .bodyToMono(String.class)
                .block();
    }
}
