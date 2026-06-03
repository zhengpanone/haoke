package com.zp.haoke.framework.core.domain.response;

import com.baomidou.mybatisplus.core.metadata.IPage;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.List;

/**
 * 分页响应VO
 *
 * @author zhengpanone
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PageVO<T> implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    /** 当前页数据 */
    private List<T> records;

    /** 总记录数 */
    private long total;

    /** 当前页码 */
    private long current;

    /** 每页条数 */
    private long size;

    /**
     * 从 MyBatis-Plus IPage 构建 PageVO
     *
     * @param page IPage 分页结果
     * @param <T>  数据类型
     * @return PageVO
     */
    public static <T> PageVO<T> of(IPage<T> page) {
        return new PageVO<>(page.getRecords(), page.getTotal(), page.getCurrent(), page.getSize());
    }
}
