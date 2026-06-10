package com.zp.haoke.controller.house;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.zp.haoke.framework.core.domain.response.PageVO;
import com.zp.haoke.framework.core.domain.response.R;
import com.zp.haoke.house.domain.dto.AdminProfileQueryDTO;
import com.zp.haoke.house.domain.dto.AdminStatusUpdateDTO;
import com.zp.haoke.house.domain.po.HouseContractPO;
import com.zp.haoke.house.domain.po.HouseFavoritePO;
import com.zp.haoke.house.domain.po.HouseOrderPO;
import com.zp.haoke.house.domain.po.HouseViewingRecordPO;
import com.zp.haoke.house.domain.po.UserIdentityVerificationPO;
import com.zp.haoke.house.domain.po.UserWalletPO;
import com.zp.haoke.house.domain.po.WalletRecordPO;
import com.zp.haoke.house.domain.vo.ContactChannelVO;
import com.zp.haoke.house.mapper.HouseContractMapper;
import com.zp.haoke.house.mapper.HouseFavoriteMapper;
import com.zp.haoke.house.mapper.HouseOrderMapper;
import com.zp.haoke.house.mapper.HouseViewingRecordMapper;
import com.zp.haoke.house.mapper.UserIdentityVerificationMapper;
import com.zp.haoke.house.mapper.UserWalletMapper;
import com.zp.haoke.house.mapper.WalletRecordMapper;
import com.zp.haoke.house.service.IProfileFeatureService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "Admin profile features")
@RequestMapping("/api/admin/profile")
public class AdminProfileController {

    private final HouseViewingRecordMapper viewingRecordMapper;
    private final HouseOrderMapper houseOrderMapper;
    private final HouseFavoriteMapper houseFavoriteMapper;
    private final UserIdentityVerificationMapper identityVerificationMapper;
    private final HouseContractMapper houseContractMapper;
    private final UserWalletMapper userWalletMapper;
    private final WalletRecordMapper walletRecordMapper;
    private final IProfileFeatureService profileFeatureService;

    @Operation(summary = "Query viewing records")
    @PostMapping("/viewing/page")
    public R<PageVO<HouseViewingRecordPO>> viewingPage(@RequestBody(required = false) AdminProfileQueryDTO queryDTO) {
        AdminProfileQueryDTO query = defaultQuery(queryDTO);
        LambdaQueryWrapper<HouseViewingRecordPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(query.getUserId()), HouseViewingRecordPO::getUserId, query.getUserId())
                .eq(StringUtils.isNotBlank(query.getStatus()), HouseViewingRecordPO::getStatus, query.getStatus())
                .and(StringUtils.isNotBlank(query.getKeyword()), item -> item
                        .like(HouseViewingRecordPO::getTitle, query.getKeyword())
                        .or()
                        .like(HouseViewingRecordPO::getAddress, query.getKeyword())
                        .or()
                        .like(HouseViewingRecordPO::getContactName, query.getKeyword())
                        .or()
                        .like(HouseViewingRecordPO::getContactPhone, query.getKeyword()))
                .orderByDesc(HouseViewingRecordPO::getAppointmentTime)
                .orderByDesc(HouseViewingRecordPO::getCreateTime);
        return R.ok(PageVO.of(viewingRecordMapper.selectPage(genericPage(query), wrapper)));
    }

    @Operation(summary = "Update viewing status")
    @PutMapping("/viewing/{id}/status")
    public R<Void> updateViewingStatus(
            @PathVariable String id,
            @Valid @RequestBody AdminStatusUpdateDTO statusDTO) {
        HouseViewingRecordPO po = new HouseViewingRecordPO();
        po.setId(id);
        po.setStatus(statusDTO.getStatus());
        viewingRecordMapper.updateById(po);
        return R.ok();
    }

    @Operation(summary = "Delete viewing record")
    @DeleteMapping("/viewing/{id}")
    public R<Void> deleteViewing(@PathVariable String id) {
        viewingRecordMapper.deleteById(id);
        return R.ok();
    }

    @Operation(summary = "Query orders")
    @PostMapping("/orders/page")
    public R<PageVO<HouseOrderPO>> orderPage(@RequestBody(required = false) AdminProfileQueryDTO queryDTO) {
        AdminProfileQueryDTO query = defaultQuery(queryDTO);
        LambdaQueryWrapper<HouseOrderPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(query.getUserId()), HouseOrderPO::getUserId, query.getUserId())
                .eq(StringUtils.isNotBlank(query.getStatus()), HouseOrderPO::getStatus, query.getStatus())
                .and(StringUtils.isNotBlank(query.getKeyword()), item -> item
                        .like(HouseOrderPO::getOrderNo, query.getKeyword())
                        .or()
                        .like(HouseOrderPO::getTitle, query.getKeyword())
                        .or()
                        .like(HouseOrderPO::getAddress, query.getKeyword()))
                .orderByDesc(HouseOrderPO::getOrderTime)
                .orderByDesc(HouseOrderPO::getCreateTime);
        return R.ok(PageVO.of(houseOrderMapper.selectPage(genericPage(query), wrapper)));
    }

    @Operation(summary = "Update order status")
    @PutMapping("/orders/{id}/status")
    public R<Void> updateOrderStatus(
            @PathVariable String id,
            @Valid @RequestBody AdminStatusUpdateDTO statusDTO) {
        HouseOrderPO po = new HouseOrderPO();
        po.setId(id);
        po.setStatus(statusDTO.getStatus());
        houseOrderMapper.updateById(po);
        return R.ok();
    }

    @Operation(summary = "Query favorites")
    @PostMapping("/favorites/page")
    public R<PageVO<HouseFavoritePO>> favoritePage(@RequestBody(required = false) AdminProfileQueryDTO queryDTO) {
        AdminProfileQueryDTO query = defaultQuery(queryDTO);
        LambdaQueryWrapper<HouseFavoritePO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(query.getUserId()), HouseFavoritePO::getUserId, query.getUserId())
                .and(StringUtils.isNotBlank(query.getKeyword()), item -> item
                        .like(HouseFavoritePO::getTitle, query.getKeyword())
                        .or()
                        .like(HouseFavoritePO::getAddress, query.getKeyword())
                        .or()
                        .like(HouseFavoritePO::getTags, query.getKeyword()))
                .orderByDesc(HouseFavoritePO::getFavoriteTime)
                .orderByDesc(HouseFavoritePO::getCreateTime);
        return R.ok(PageVO.of(houseFavoriteMapper.selectPage(genericPage(query), wrapper)));
    }

    @Operation(summary = "Delete favorite")
    @DeleteMapping("/favorites/{id}")
    public R<Void> deleteFavorite(@PathVariable String id) {
        houseFavoriteMapper.deleteById(id);
        return R.ok();
    }

    @Operation(summary = "Query identity verifications")
    @PostMapping("/identities/page")
    public R<PageVO<UserIdentityVerificationPO>> identityPage(@RequestBody(required = false) AdminProfileQueryDTO queryDTO) {
        AdminProfileQueryDTO query = defaultQuery(queryDTO);
        LambdaQueryWrapper<UserIdentityVerificationPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(query.getUserId()), UserIdentityVerificationPO::getUserId, query.getUserId())
                .eq(StringUtils.isNotBlank(query.getStatus()), UserIdentityVerificationPO::getStatus, query.getStatus())
                .and(StringUtils.isNotBlank(query.getKeyword()), item -> item
                        .like(UserIdentityVerificationPO::getRealName, query.getKeyword())
                        .or()
                        .like(UserIdentityVerificationPO::getIdCardNo, query.getKeyword()))
                .orderByDesc(UserIdentityVerificationPO::getSubmittedAt)
                .orderByDesc(UserIdentityVerificationPO::getCreateTime);
        return R.ok(PageVO.of(identityVerificationMapper.selectPage(genericPage(query), wrapper)));
    }

    @Operation(summary = "Update identity status")
    @PutMapping("/identities/{id}/status")
    public R<Void> updateIdentityStatus(
            @PathVariable String id,
            @Valid @RequestBody AdminStatusUpdateDTO statusDTO) {
        UserIdentityVerificationPO po = new UserIdentityVerificationPO();
        po.setId(id);
        po.setStatus(statusDTO.getStatus());
        po.setRejectReason("REJECTED".equals(statusDTO.getStatus()) ? statusDTO.getRejectReason() : null);
        po.setReviewedAt(LocalDateTime.now());
        identityVerificationMapper.updateById(po);
        return R.ok();
    }

    @Operation(summary = "Query contracts")
    @PostMapping("/contracts/page")
    public R<PageVO<HouseContractPO>> contractPage(@RequestBody(required = false) AdminProfileQueryDTO queryDTO) {
        AdminProfileQueryDTO query = defaultQuery(queryDTO);
        LambdaQueryWrapper<HouseContractPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(query.getUserId()), HouseContractPO::getUserId, query.getUserId())
                .eq(StringUtils.isNotBlank(query.getStatus()), HouseContractPO::getStatus, query.getStatus())
                .and(StringUtils.isNotBlank(query.getKeyword()), item -> item
                        .like(HouseContractPO::getContractNo, query.getKeyword())
                        .or()
                        .like(HouseContractPO::getTitle, query.getKeyword()))
                .orderByDesc(HouseContractPO::getCreateTime);
        return R.ok(PageVO.of(houseContractMapper.selectPage(genericPage(query), wrapper)));
    }

    @Operation(summary = "Update contract status")
    @PutMapping("/contracts/{id}/status")
    public R<Void> updateContractStatus(
            @PathVariable String id,
            @Valid @RequestBody AdminStatusUpdateDTO statusDTO) {
        HouseContractPO po = new HouseContractPO();
        po.setId(id);
        po.setStatus(statusDTO.getStatus());
        houseContractMapper.updateById(po);
        return R.ok();
    }

    @Operation(summary = "Query wallets")
    @PostMapping("/wallets/page")
    public R<PageVO<UserWalletPO>> walletPage(@RequestBody(required = false) AdminProfileQueryDTO queryDTO) {
        AdminProfileQueryDTO query = defaultQuery(queryDTO);
        LambdaQueryWrapper<UserWalletPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(query.getUserId()), UserWalletPO::getUserId, query.getUserId())
                .orderByDesc(UserWalletPO::getUpdateTime)
                .orderByDesc(UserWalletPO::getCreateTime);
        return R.ok(PageVO.of(userWalletMapper.selectPage(genericPage(query), wrapper)));
    }

    @Operation(summary = "Query wallet records")
    @PostMapping("/wallet-records/page")
    public R<PageVO<WalletRecordPO>> walletRecordPage(@RequestBody(required = false) AdminProfileQueryDTO queryDTO) {
        AdminProfileQueryDTO query = defaultQuery(queryDTO);
        LambdaQueryWrapper<WalletRecordPO> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StringUtils.isNotBlank(query.getUserId()), WalletRecordPO::getUserId, query.getUserId())
                .eq(StringUtils.isNotBlank(query.getStatus()), WalletRecordPO::getStatus, query.getStatus())
                .eq(StringUtils.isNotBlank(query.getRecordType()), WalletRecordPO::getRecordType, query.getRecordType())
                .eq(query.getIncome() != null, WalletRecordPO::getIncome, query.getIncome())
                .and(StringUtils.isNotBlank(query.getKeyword()), item -> item
                        .like(WalletRecordPO::getTitle, query.getKeyword())
                        .or()
                        .like(WalletRecordPO::getRecordType, query.getKeyword()))
                .orderByDesc(WalletRecordPO::getRecordTime)
                .orderByDesc(WalletRecordPO::getCreateTime);
        return R.ok(PageVO.of(walletRecordMapper.selectPage(genericPage(query), wrapper)));
    }

    @Operation(summary = "Query contact channels")
    @GetMapping("/contact-channels")
    public R<List<ContactChannelVO>> contactChannels() {
        return R.ok(profileFeatureService.queryContactChannels());
    }

    private AdminProfileQueryDTO defaultQuery(AdminProfileQueryDTO queryDTO) {
        return queryDTO == null ? new AdminProfileQueryDTO() : queryDTO;
    }

    private <T> Page<T> genericPage(AdminProfileQueryDTO queryDTO) {
        long pageNum = queryDTO.getPageNum() == null || queryDTO.getPageNum() < 1 ? 1 : queryDTO.getPageNum();
        long pageSize = queryDTO.getPageSize() == null || queryDTO.getPageSize() < 1 ? 10 : Math.min(queryDTO.getPageSize(), 100);
        return Page.of(pageNum, pageSize);
    }
}
