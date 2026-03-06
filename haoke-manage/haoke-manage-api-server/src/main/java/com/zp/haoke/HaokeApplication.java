package com.zp.haoke;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.zp.haoke.house.mapper")
public class HaokeApplication {
    public static void main(String[] args) {
        SpringApplication.run(HaokeApplication.class, args);
    }
}
