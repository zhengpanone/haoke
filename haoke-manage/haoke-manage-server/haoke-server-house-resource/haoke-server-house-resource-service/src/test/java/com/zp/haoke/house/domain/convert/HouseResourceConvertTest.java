package com.zp.haoke.house.domain.convert;

import com.zp.haoke.house.domain.dto.HouseResourceCreateDTO;
import com.zp.haoke.house.domain.po.HouseResourcePO;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;


class HouseResourceConvertTest {

    private final HouseResourceConvert houseResourceConvert = HouseResourceConvert.INSTANCE;

    @Test
    void toEntity() {
        HouseResourceCreateDTO createDTO = new HouseResourceCreateDTO();
        createDTO.setRent(2000).setTitle("测试房源标题");
        HouseResourcePO convertEntity = houseResourceConvert.toEntity(createDTO);
        assertThat(convertEntity).isNotNull();
        assertThat(convertEntity.getContact()).isNull(); // 验证 id 被忽略
        assertThat(convertEntity.getTitle()).isEqualTo("测试房源标题");
        assertThat(convertEntity.getRent()).isEqualTo(2000);
    }
}