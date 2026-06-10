<script lang="ts" setup>
import type { IdentityVerification } from '#/api/haoke';

import { onMounted, reactive, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
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
  queryIdentityVerificationsApi,
  updateIdentityVerificationStatusApi,
} from '#/api/haoke';

const statusOptions = [
  { label: '未提交', value: 'NOT_SUBMITTED' },
  { label: '审核中', value: 'REVIEWING' },
  { label: '已认证', value: 'VERIFIED' },
  { label: '未通过', value: 'REJECTED' },
];

const query = reactive({
  keyword: '',
  pageNum: 1,
  pageSize: 10,
  status: '',
  userId: '',
});

const reviewForm = reactive({
  id: '',
  realName: '',
  rejectReason: '',
  status: 'VERIFIED',
});

const loading = ref(false);
const reviewVisible = ref(false);
const rows = ref<IdentityVerification[]>([]);
const total = ref(0);

async function fetchData() {
  loading.value = true;
  try {
    const data = await queryIdentityVerificationsApi({
      keyword: query.keyword || undefined,
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      status: query.status || undefined,
      userId: query.userId || undefined,
    });
    rows.value = data.records || [];
    total.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载身份认证失败');
  } finally {
    loading.value = false;
  }
}

function openReview(row: unknown, status: string) {
  const item = row as IdentityVerification;
  Object.assign(reviewForm, {
    id: item.id,
    realName: item.realName || '',
    rejectReason: '',
    status,
  });
  reviewVisible.value = true;
}

async function submitReview() {
  try {
    await updateIdentityVerificationStatusApi(reviewForm.id, {
      rejectReason: reviewForm.rejectReason || undefined,
      status: reviewForm.status,
    });
    ElMessage.success('认证状态已更新');
    reviewVisible.value = false;
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '认证状态更新失败');
  }
}

function maskIdCard(value?: string) {
  if (!value || value.length < 8) {
    return value || '-';
  }
  return `${value.slice(0, 4)}**********${value.slice(-4)}`;
}

function statusLabel(value?: string) {
  return statusOptions.find((item) => item.value === value)?.label || '未知';
}

function statusType(value?: string) {
  return value === 'VERIFIED'
    ? 'success'
    : value === 'REJECTED'
      ? 'danger'
      : 'warning';
}

onMounted(fetchData);
</script>

<template>
  <Page title="身份认证管理">
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
              placeholder="姓名/证件号"
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
          <ElTableColumn label="姓名" min-width="120" prop="realName" />
          <ElTableColumn label="用户ID" min-width="170" prop="userId" />
          <ElTableColumn label="证件号" min-width="170">
            <template #default="{ row }">{{
              maskIdCard(row.idCardNo)
            }}</template>
          </ElTableColumn>
          <ElTableColumn label="状态" width="110">
            <template #default="{ row }">
              <ElTag :type="statusType(row.status)">{{
                statusLabel(row.status)
              }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn label="提交时间" min-width="160" prop="submittedAt" />
          <ElTableColumn label="审核时间" min-width="160" prop="reviewedAt" />
          <ElTableColumn label="驳回原因" min-width="180" prop="rejectReason" />
          <ElTableColumn fixed="right" label="操作" width="170">
            <template #default="{ row }">
              <ElSpace>
                <ElButton
                  link
                  type="success"
                  @click="openReview(row, 'VERIFIED')"
                  >通过</ElButton
                >
                <ElButton
                  link
                  type="danger"
                  @click="openReview(row, 'REJECTED')"
                  >驳回</ElButton
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

    <ElDialog v-model="reviewVisible" title="认证审核" width="520px">
      <ElForm :model="reviewForm" label-width="88px">
        <ElFormItem label="用户姓名">
          <ElInput v-model="reviewForm.realName" disabled />
        </ElFormItem>
        <ElFormItem label="审核结果">
          <ElSelect v-model="reviewForm.status" style="width: 180px">
            <ElOption label="通过认证" value="VERIFIED" />
            <ElOption label="驳回认证" value="REJECTED" />
          </ElSelect>
        </ElFormItem>
        <ElFormItem v-if="reviewForm.status === 'REJECTED'" label="驳回原因">
          <ElInput
            v-model="reviewForm.rejectReason"
            :rows="3"
            type="textarea"
          />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="reviewVisible = false">取消</ElButton>
        <ElButton type="primary" @click="submitReview">提交</ElButton>
      </template>
    </ElDialog>
  </Page>
</template>
