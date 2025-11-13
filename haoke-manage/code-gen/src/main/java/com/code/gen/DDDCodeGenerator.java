//package com.code.gen;
//
//import com.baomidou.mybatisplus.generator.FastAutoGenerator;
//import com.baomidou.mybatisplus.generator.config.OutputFile;
//import com.baomidou.mybatisplus.generator.config.TemplateType;
//import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
//import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
//import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
//
//import java.util.Collections;
//import java.util.HashMap;
//import java.util.Map;
//
//public class DDDCodeGenerator {
//
//    public static void main(String[] args) {
//        String projectPath = System.getProperty("user.dir");
//        String moduleName = "house-system";
//
//        FastAutoGenerator.create(
//                new DataSourceConfig.Builder(
//                    "jdbc:mysql://localhost:30031/haoke?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8",
//                    "root",
//                    "root"
//                )
//        )
//        .globalConfig(builder -> {
//            builder.author("zhengpanone")
//                    .enableSwagger()
//                    .fileOverride()
//                    .outputDir(projectPath + "/src/main/java")
//                    .commentDate("yyyy-MM-dd");
//        })
//        .packageConfig(builder -> {
//            // DDD包结构
//            builder.parent("com.zp")
//                    .moduleName(moduleName)
//                    .entity("domain.model")
//                    .mapper("infrastructure.persistence.mapper")
//                    .service("application.service")
//                    .serviceImpl("application.service.impl")
//                    .controller("interfaces.controller")
//                    .pathInfo(getPathInfo(projectPath, moduleName));
//        })
//        .strategyConfig(builder -> {
//            builder.addInclude("estate", "house_resources")
//                    .addTablePrefix("t_", "c_")
//
//                    // Entity配置 - DDD领域模型
//                    .entityBuilder()
//                    .enableLombok()
//                    .enableTableFieldAnnotation()
//                    .naming(NamingStrategy.underline_to_camel)
//                    .columnNaming(NamingStrategy.underline_to_camel)
//                    .formatFileName("%sEntity")
//                    .enableChainModel()
//                    .disableSerialVersionUID()
//
//                    // Controller配置
//                    .controllerBuilder()
//                    .enableRestStyle()
//                    .formatFileName("%sController")
//                    .enableHyphenStyle()
//
//                    // Service配置
//                    .serviceBuilder()
//                    .formatServiceFileName("%sService")
//                    .formatServiceImplFileName("%sServiceImpl")
//
//                    // Mapper配置
//                    .mapperBuilder()
//                    .formatMapperFileName("%sMapper")
//                    .formatXmlFileName("%sMapper")
//                    .enableMapperAnnotation();
//        })
//        .injectionConfig(builder -> {
//            // 自定义输出DTO、VO、Query等
//            builder.customMap(Collections.singletonMap("domain", "com.zp." + moduleName + ".domain"))
//                   .beforeOutputFile((tableInfo, objectMap) -> {
//                       System.out.println("生成表: " + tableInfo.getEntityName());
//                   })
//                   .customFile(customFiles());
//        })
//        .templateConfig(builder -> {
//            // 禁用不需要的模板
//            builder.disable(TemplateType.CONTROLLER)
//                   .disable(TemplateType.SERVICE)
//                   .disable(TemplateType.SERVICE_IMPL)
//                   .disable(TemplateType.MAPPER)
//                   .disable(TemplateType.XML)
//                   .entity("/templates/entity.java");
//        })
//        .templateEngine(new FreemarkerTemplateEngine())
//        .execute();
//    }
//
//    private static Map<String, String> getPathInfo(String projectPath, String moduleName) {
//        Map<String, String> pathInfo = new HashMap<>();
//        pathInfo.put(String.valueOf(OutputFile.entity), projectPath + "/src/main/java/com/yourcompany/" + moduleName + "/domain/model");
//        pathInfo.put(String.valueOf(OutputFile.mapper), projectPath + "/src/main/java/com/yourcompany/" + moduleName + "/infrastructure/persistence/mapper");
//        pathInfo.put(String.valueOf(OutputFile.xml), projectPath + "/src/main/resources/mapper/" + moduleName);
//        pathInfo.put(String.valueOf(OutputFile.service), projectPath + "/src/main/java/com/yourcompany/" + moduleName + "/application/service");
//        pathInfo.put(String.valueOf(OutputFile.serviceImpl), projectPath + "/src/main/java/com/yourcompany/" + moduleName + "/application/service/impl");
//        pathInfo.put(String.valueOf(OutputFile.controller), projectPath + "/src/main/java/com/yourcompany/" + moduleName + "/interfaces/controller");
//        return pathInfo;
//    }
//
//    private static Map<String, String> customFiles() {
//        Map<String, String> customFiles = new HashMap<>();
//        customFiles.put("DTO.java", "/templates/dto.java.ftl");
//        customFiles.put("VO.java", "/templates/vo.java.ftl");
//        customFiles.put("Query.java", "/templates/query.java.ftl");
//        customFiles.put("Repository.java", "/templates/repository.java.ftl");
//        customFiles.put("Command.java", "/templates/command.java.ftl");
//        return customFiles;
//    }
//}