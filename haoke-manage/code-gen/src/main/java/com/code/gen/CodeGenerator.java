package com.code.gen;

import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CodeGenerator {

    public static void main(String[] args) {
        // 数据库配置
        String url = "jdbc:mysql://localhost:30031/haoke?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8";
        String username = "root";
        String password = "root";
        String parentPackageName = "com.zp.haoke";
        String moduleName = "house";
        List<String> tableList = new ArrayList<>(List.of("estate", "house_resources"));

        // 项目配置
        String projectPath = System.getProperty("user.dir");
        String outputDir = projectPath + "/src/main/java";
        String xmlOutputDir = projectPath + "/src/main/resources/mapper";
        System.out.println("项目路径: " + projectPath);
        FastAutoGenerator.create(url, username, password)
                .globalConfig(builder -> {
                    builder.author("zhengpanone") // 设置作者
                            .enableSwagger() // 开启 swagger 模式
                            .commentDate("yyyy-MM-dd") // 注释日期
                            .outputDir(outputDir); // 指定输出目录
                })
                .packageConfig(builder -> {
                    builder.parent(parentPackageName) // 设置父包名
                            .moduleName(moduleName) // 设置父包模块名
                            .entity("domain.model")    // 实体类包名
                            .mapper("infrastructure.persistence.mapper") // mapper包名
                            .service("application.service") // service包名
                            .serviceImpl("application.service.impl") // serviceImpl包名
                            .controller("interfaces.controller") // controller包名
                            .pathInfo(Collections.singletonMap(OutputFile.xml, xmlOutputDir)); // 设置mapperXml生成路径
                })
                .strategyConfig(builder -> {
                    builder.addInclude(tableList) // 设置需要生成的表名
                            .addTablePrefix("t_", "c_") // 设置过滤表前缀
                            // 实体类配置
                            .entityBuilder().entityBuilder()
                            .enableLombok() // 开启Lombok
//                            .superClass()
                            .enableTableFieldAnnotation() // 开启字段注解
                            .naming(NamingStrategy.underline_to_camel) // 数据库表映射到实体的命名策略
                            .columnNaming(NamingStrategy.underline_to_camel) // 数据库表字段映射到实体的命名策略
                            .formatFileName("%sEntity") // 实体类文件名称格式
                            .enableFileOverride() // 覆盖已有文件（新版本移到这里）

                            // Controller配置
                            .controllerBuilder()
                            .enableRestStyle() // 开启生成@RestController控制器
                            .formatFileName("%sController") // 控制器文件名称格式
                            .enableFileOverride() // 覆盖已有文件

                            // Service配置
                            .serviceBuilder()
                            .formatServiceFileName("%sService") // 服务接口命名格式
                            .formatServiceImplFileName("%sServiceImpl") // 服务实现类命名格式
                            .enableFileOverride() // 覆盖已有文件

                            // Mapper策略配置
                            .mapperBuilder()
                            .formatMapperFileName("%sMapper") // mapper接口文件名称格式
                            .formatXmlFileName("%sMapper") // mapper xml文件名称格式
                            .enableFileOverride(); // 覆盖已有文件
                })
                .templateEngine(new FreemarkerTemplateEngine()) // 使用Freemarker引擎模板，默认的是Velocity引擎模板
                .execute();
    }
}