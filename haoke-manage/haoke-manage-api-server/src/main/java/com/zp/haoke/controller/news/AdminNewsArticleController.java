package com.zp.haoke.controller.news;

import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.NewsArticleCreateDTO;
import com.zp.haoke.house.domain.dto.NewsArticleQueryDTO;
import com.zp.haoke.house.domain.dto.NewsArticleStatusDTO;
import com.zp.haoke.house.domain.dto.NewsArticleUpdateDTO;
import com.zp.haoke.house.domain.vo.NewsArticleVO;
import com.zp.haoke.house.service.INewsArticleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "Admin news article")
@RequestMapping("/api/admin/news")
public class AdminNewsArticleController {

    private final INewsArticleService newsArticleService;

    @Operation(summary = "Query all news for admin")
    @PostMapping("/page")
    public R<PageVO<NewsArticleVO>> page(@RequestBody(required = false) NewsArticleQueryDTO queryDTO) {
        return R.ok(PageVO.of(newsArticleService.queryPageList(queryDTO)));
    }

    @Operation(summary = "Create news")
    @PostMapping("/create")
    public R<NewsArticleVO> create(@Valid @RequestBody NewsArticleCreateDTO createDTO) {
        return R.ok(newsArticleService.create(createDTO));
    }

    @Operation(summary = "Update news")
    @PutMapping("/update")
    public R<NewsArticleVO> update(@Valid @RequestBody NewsArticleUpdateDTO updateDTO) {
        return R.ok(newsArticleService.update(updateDTO));
    }

    @Operation(summary = "Update news status")
    @PutMapping("/{id}/status")
    public R<Void> updateStatus(
            @PathVariable String id,
            @Valid @RequestBody NewsArticleStatusDTO statusDTO) {
        newsArticleService.updateStatus(id, statusDTO.getStatus());
        return R.ok();
    }

    @Operation(summary = "Delete news")
    @DeleteMapping("/{id}")
    public R<Void> delete(@PathVariable String id) {
        newsArticleService.deleteById(id);
        return R.ok();
    }
}
