package com.zp.haoke;

import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.Test;

import javax.crypto.SecretKey;
import java.util.Arrays;


public class ToolsTest {

    @Test
    public void generateKey() {
        SecretKey key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
    }

    @Test
    public void testDecodeBase64() {
        String base64Key = "bXktc3VwZXItc2VjcmV0LWtleS1hdC1sZWFzdC0zMi1ieXRlcw==";
        byte[] decode = Decoders.BASE64.decode(base64Key);
        System.out.println(Arrays.toString(decode));

    }
}
