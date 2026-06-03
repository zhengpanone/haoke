package com.zp.haoke.config;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.autoconfigure.ConfigurationCustomizer;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.PaginationInnerInterceptor;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * MyBatis-Plus 配置
 */
@Configuration
@MapperScan("com.zp.haoke.**.mapper")
public class MybatisPlusConfig {

    /**
     * 注册 MyBatis-Plus 枚举类型处理器
     * 使 @EnumValue 注解生效
     */
    @Bean
    public ConfigurationCustomizer configurationCustomizer() {
        return configuration -> configuration.setDefaultEnumTypeHandler(
                com.baomidou.mybatisplus.core.handlers.MybatisEnumTypeHandler.class);
    }
}
