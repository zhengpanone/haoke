package com.zp.haoke.controller.common;

import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.vo.ContactChannelVO;
import com.zp.haoke.house.service.IProfileFeatureService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/support")
public class SupportController {
    private final IProfileFeatureService profileFeatureService;

    @GetMapping("/contact")
    public R<List<ContactChannelVO>> contactChannels() {
        return R.ok(profileFeatureService.queryContactChannels());
    }
}
