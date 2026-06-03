package com.zp.haoke.house.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.zp.haoke.house.domain.dto.HouseCommunityCreateDTO;
import com.zp.haoke.house.domain.dto.HouseCommunityQueryDTO;
import com.zp.haoke.house.domain.dto.HouseCommunityUpdateDTO;
import com.zp.haoke.house.domain.po.HouseCommunityPO;
import com.zp.haoke.house.domain.vo.HouseEstateVO;

import java.util.List;

/**
 * @author : zhengpanone
 * Date : 2026/3/16 22:23
 * Version : v1.0.0
 * Description:
 */
public interface IHouseCommunityService extends IService<HouseCommunityPO> {

    /**
     * 创建楼盘
     *
     * @param createDTO
     * @return
     */
    HouseEstateVO create(HouseCommunityCreateDTO createDTO);

    /**
     * 查询楼盘
     *
     * @param id
     * @return
     */
    HouseEstateVO queryById(String id);

    /**
     * 更新楼盘
     *
     * @param estateUpdateDTO
     * @return
     */
    HouseEstateVO updateById(HouseCommunityUpdateDTO estateUpdateDTO);

    /**
     * 删除楼盘
     *
     * @param id
     * @return
     */
    boolean delete(String id);

    List<HouseEstateVO> queryPageList(HouseCommunityQueryDTO queryDTO);

}
