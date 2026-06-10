<script lang="ts" setup>
import type { HouseContract } from '#/api/haoke';

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

import {
  queryHouseContractsApi,
  updateHouseContractStatusApi,
} from '#/api/haoke';

const statusOptions = [
  { label: '待签署', value: 'PENDING_SIGN' },
  { label: '已签署', value: 'SIGNED' },
  { label: '已归档', value: 'ARCHIVED' },
  { label: '已终止', value: 'TERMINATED' },
];

const query = reactive({
  keyword: '',
  pageNum: 1,
  pageSize: 10,
  status: '',
  userId: '',
});

const detail = ref<HouseContract>();
const detailVisible = ref(false);
const loading = ref(false);
const rows = ref<HouseContract[]>([]);
const total = ref(0);

async function fetchData() {
  loading.value = true;
  try {
    const data = await queryHouseContractsApi({
      keyword: query.keyword || undefined,
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      status: query.status || undefined,
      userId: query.userId || undefined,
    });
    rows.value = data.records || [];
    total.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载合同失败');
  } finally {
    loading.value = false;
  }
}

function openDetail(row: unknown) {
  detail.value = row as HouseContract;
  detailVisible.value = true;
}

async function changeStatus(row: unknown, status: string) {
  const item = row as HouseContract;
  try {
    await updateHouseContractStatusApi(item.id, { status });
    ElMessage.success('合同状态已更新');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '合同状态更新失败');
  }
}

function statusLabel(value?: string) {
  return statusOptions.find((item) => item.value === value)?.label || '未知';
}

function statusType(value?: string) {
  return value === 'SIGNED' || value === 'ARCHIVED'
    ? 'success'
    : value === 'TERMINATED'
      ? 'info'
      : 'warning';
}

onMounted(fetchData);
</script>

<template>
  <Page title="电子合同管理">
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
              placeholder="合同号/标题"
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
          <ElTableColumn label="合同号" min-width="160" prop="contractNo" />
          <ElTableColumn label="合同标题" min-width="220" prop="title" />
          <ElTableColumn label="用户ID" min-width="170" prop="userId" />
          <ElTableColumn label="租期" min-width="190">
            <template #default="{ row }"
              >{{ row.periodStart || '-' }} 至
              {{ row.periodEnd || '-' }}</template
            >
          </ElTableColumn>
          <ElTableColumn label="状态" width="110">
            <template #default="{ row }">
              <ElTag :type="statusType(row.status)">{{
                statusLabel(row.status)
              }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn fixed="right" label="操作" width="280">
            <template #default="{ row }">
              <ElSpace>
                <ElButton link type="primary" @click="openDetail(row)"
                  >详情</ElButton
                >
                <ElButton
                  link
                  type="success"
                  @click="changeStatus(row, 'SIGNED')"
                  >已签</ElButton
                >
                <ElButton
                  link
                  type="warning"
                  @click="changeStatus(row, 'TERMINATED')"
                  >终止</ElButton
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

    <ElDialog v-model="detailVisible" title="合同详情" width="760px">
      <ElDescriptions v-if="detail" :column="2" border>
        <ElDescriptionsItem label="合同号">{{
          detail.contractNo
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="用户ID">{{
          detail.userId
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="房源ID">{{
          detail.houseId
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="订单ID">{{
          detail.orderId
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="租期开始">{{
          detail.periodStart
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="租期结束">{{
          detail.periodEnd
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="状态">{{
          statusLabel(detail.status)
        }}</ElDescriptionsItem>
        <ElDescriptionsItem label="PDF">{{
          detail.pdfUrl || '-'
        }}</ElDescriptionsItem>
        <ElDescriptionsItem :span="2" label="签署地址">{{
          detail.signUrl || '-'
        }}</ElDescriptionsItem>
      </ElDescriptions>
    </ElDialog>
  </Page>
</template>
