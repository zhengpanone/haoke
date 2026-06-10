package com.zp.haoke.controller.news;

import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.NewsArticleQueryDTO;
import com.zp.haoke.house.domain.vo.NewsArticleVO;
import com.zp.haoke.house.service.INewsArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "News article")
@RequestMapping("/api/news")
public class NewsArticleController {

    private final INewsArticleService newsArticleService;

    @Operation(summary = "Query published news")
    @PostMapping("/page")
    public R<PageVO<NewsArticleVO>> page(@RequestBody(required = false) NewsArticleQueryDTO queryDTO) {
        return R.ok(PageVO.of(newsArticleService.queryPublishedPageList(queryDTO)));
    }

    @Operation(summary = "Get news detail")
    @GetMapping("/{id}")
    public R<NewsArticleVO> detail(@PathVariable String id) {
        return R.ok(newsArticleService.queryById(id));
    }
}
