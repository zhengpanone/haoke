<script lang="ts" setup>
import type { HouseOrder } from '#/api/haoke';

import { onMounted, reactive, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
  ElDescriptions,
  ElDescriptionsItem,
  ElDialog,
  ElForm,
  ElFormItem,
  ElInput,
  ElMessage,
  ElOption,
  ElPagination,
  ElSelect,
  ElSpace,
  ElTable,
  ElTableColumn,
  ElTag,
} from 'element-plus';

import { queryHouseOrdersApi, updateHouseOrderStatusApi } from '#/api/haoke';

const statusOptions = [
  { label: '待签约', value: 'PENDING_SIGN' },
  { label: '已支付', value: 'PAID' },
  { label: '已完成', value: 'COMPLETED' },
  { label: '已取消', value: 'CANCELLED' },
];

const query = reactive({
  keyword: '',
  pageNum: 1,
  pageSize: 10,
  status: '',
  userId: '',
});

const detail = ref<HouseOrder>();
const detailVisible = ref(false);
const loading = ref(false);
const rows = ref<HouseOrder[]>([]);
const total = ref(0);

async function fetchData() {
  loading.value = true;
  try {
    const data = await queryHouseOrdersApi({
      keyword: query.keyword || undefined,
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      status: query.status || undefined,
      userId: query.userId || undefined,
    });
    rows.value = data.records || [];
    total.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载订单失败');
  } finally {
    loading.value = false;
  }
}

function openDetail(row: unknown) {
  detail.value = row as HouseOrder;
  detailVisible.value = true;
}

async function changeStatus(row: unknown, status: string) {
  const item = row as HouseOrder;
  try {
    await updateHouseOrderStatusApi(item.id, { status });
    ElMessage.success('订单状态已更新');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '订单状态更新失败');
  }
}

function statusLabel(value?: string) {
  return statusOptions.find((item) => item.value === value)?.label || '未知';
}

function statusType(value?: string) {
  return value === 'COMPLETED'
    ? 'success'
    : value === 'CANCELLED'
      ? 'info'
      : 'warning';
}

onMounted(fetchData);
</script>

<template>
  <Page title="订单管理">
    <div class="p-5">
      <ElCard shadow="never">
        <ElForm :inline="true" :model="query">
          <ElFormItem label="用户ID">
            <ElInput
              v-model="query.userId"
              clearable
              placeholder="输入用户ID"
            />
          </ElFormItem>
          <ElFormItem label="关键词">
            <ElInput
              v-model="query.keyword"
              clearable
              placeholder="订单号/标题/地址"
            />
          </ElFormItem>
          <ElFormItem label="状态">
            <ElSelect
              v-model="query.status"
              clearable
              placeholder="全部"
              style="width: 140px"
            >
              <ElOption
                v-for="item in statusOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </ElSelect>
          </ElFormItem>
          <ElFormItem>
            <ElButton type="primary" @click="fetchData">查询</ElButton>
          </ElFormItem>
        </ElForm>

        <ElTable v-loading="loading" :data="rows" stripe>
          <ElTableColumn label="订单号" min-width="160" prop="orderNo" />
          <ElTableColumn label="订单标题" min-width="220" prop="title" />
          <ElTableColumn label="用户ID" min-width="170" prop="userId" />
          <ElTableColumn label="金额" width="110">
            <template #default="{ row }"> ¥{{ row.amount || 0 }} </template>
          </ElTableColumn>
          <ElTableColumn label="状态" width="110">
            <template #default="{ row }">
              <ElTag :type="statusType(row.status)">{{
                statusLabel(row.status)
              }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn label="下单时间" min-width="160" prop="orderTime" />
          <ElTableColumn fixed="right" label="操作" width="280">
            <template #default="{ row }">
              <ElSpace>
                <ElButton link type="primary" @click="openDetail(row)"
                  >详情</ElButton
                >
                <ElButton
                  link
                  type="success"
                  @click="changeStatus(row, 'COMPLETED')"
                  >完成</ElButton
                >
                <ElButton
                  link
                  type="warning"
                  @click="changeStatus(row, 'CANCELLED')"
                  >取消</ElButton
                >
              </ElSpace>
            </template>
          </ElTableColumn>
        </ElTable>

        <div class="mt-4 flex justify-end">
          <ElPagination
            v-model:current-page="query.pageNum"
            v-model:page-size="query.pageSize"
            :page-sizes="[10, 20, 50]"
            :total="total"
            layout="total, sizes, prev, pager, next"
            @change="fetchData"
          />
        </div>
      </ElCard>
    </div>

    <ElDialog v-model="detailVisible" title="订单详情" width="720px">
      <ElDescriptions v-if="detail" :column="2" border>
        <ElDescriptionsItem label="订单号">{{
          detail.orderNo
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="用户ID">{{
          detail.userId
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="房源ID">{{
          detail.houseId
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="金额"
          >¥{{ detail.amount || 0 }}</ElDescriptionsItem
        >
        <ElDescriptionsItem label="状态">{{
          statusLabel(detail.status)
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="下单时间">{{
          detail.orderTime
        }}</ElDescriptionsItem>
        <ElDescriptionsItem :span="2" label="标题">{{
          detail.title
        }}</ElDescriptionsItem>
        <ElDescriptionsItem :span="2" label="地址">{{
          detail.address || '-'
        }}</ElDescriptionsItem>
      </ElDescriptions>
    </ElDialog>
  </Page>
</template>
