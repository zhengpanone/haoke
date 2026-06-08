package com.zp.haoke.controller.common;

import com.zp.haoke.framework.core.domain.response.R;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@RestController
@RequestMapping("/api/file")
public class FileController {

    private static final long MAX_IMAGE_SIZE = 5 * 1024 * 1024;
    private static final Set<String> ALLOWED_EXTENSIONS =
            Set.of("jpg", "jpeg", "png", "webp");
    private static final Path UPLOAD_ROOT =
            Paths.get(System.getProperty("user.home"), "haoke", "uploads");

    @PostMapping(value = "/avatar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public R<String> uploadAvatar(@RequestPart("file") MultipartFile file) {
        if (file.isEmpty()) {
            return R.fail(400, "File is empty");
        }
        if (file.getSize() > MAX_IMAGE_SIZE) {
            return R.fail(400, "Image must be at most 5MB");
        }

        String extension = getExtension(file.getOriginalFilename());
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            return R.fail(400, "Only jpg, jpeg, png and webp images are allowed");
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
            return R.fail(400, "Invalid image file");
        }

        try {
            Path avatarDir = UPLOAD_ROOT.resolve("avatars");
            Files.createDirectories(avatarDir);

            String fileName = UUID.randomUUID() + "." + extension;
            Path target = avatarDir.resolve(fileName);
            file.transferTo(target);

            return R.ok("Upload successful", "avatars/" + fileName);
        } catch (IOException e) {
            return R.fail(500, "Upload failed: " + e.getMessage());
        }
    }

    private String getExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase(Locale.ROOT);
    }
}
