//package com.zp.haoke.dubbo.server;
//
//import io.swagger.v3.oas.annotations.media.ArraySchema;
//import io.swagger.v3.oas.annotations.media.Schema;
//
//public class CollectionExample {
//
//    @ArraySchema(
//        schema = @Schema(description = "标签", example = "优质房源"),
//        arraySchema = @Schema(description = "标签列表"),
//        minItems = 1,
//        maxItems = 10,
//        uniqueItems = true
//    )
//    private List<String> tags;
//
//    @Schema(
//        description = "房源图片",
//        content = @io.swagger.v3.oas.annotations.media.Content(
//            mediaType = "application/json",
//            schema = @Schema(implementation = String.class)
//        )
//    )
//    private List<String> images;
//}