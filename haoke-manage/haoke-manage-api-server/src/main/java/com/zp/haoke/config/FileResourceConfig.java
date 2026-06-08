package com.zp.haoke.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class FileResourceConfig implements WebMvcConfigurer {

    private static final Path UPLOAD_ROOT =
            Paths.get(System.getProperty("user.home"), "haoke", "uploads");

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String uploadLocation = UPLOAD_ROOT.toAbsolutePath().normalize().toUri().toString();
        registry.addResourceHandler("/files/**")
                .addResourceLocations(uploadLocation);
    }
}
