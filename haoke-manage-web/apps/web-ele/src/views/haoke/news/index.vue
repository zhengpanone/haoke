<script lang="ts" setup>
import type { FormInstance } from 'element-plus';
import type { NewsArticle, NewsArticlePayload } from '#/api/haoke';

import { onMounted, reactive, ref } from 'vue';

import { Page } from '@vben/common-ui';

import {
  ElButton,
  ElCard,
  ElDialog,
  ElForm,
  ElFormItem,
  ElInput,
  ElInputNumber,
  ElMessage,
  ElOption,
  ElPagination,
  ElPopconfirm,
  ElSelect,
  ElSpace,
  ElTable,
  ElTableColumn,
  ElTag,
} from 'element-plus';

import {
  createNewsArticleApi,
  deleteNewsArticleApi,
  queryNewsArticlePageApi,
  updateNewsArticleApi,
  updateNewsArticleStatusApi,
} from '#/api/haoke';

const statusOptions = [
  { label: '草稿', value: 1 },
  { label: '已发布', value: 2 },
  { label: '已下架', value: 3 },
];

const query = reactive({
  pageNum: 1,
  pageSize: 10,
  status: undefined as number | undefined,
  title: '',
});

const formRef = ref<FormInstance>();
const loading = ref(false);
const dialogVisible = ref(false);
const dialogTitle = ref('新增资讯');
const rows = ref<NewsArticle[]>([]);
const total = ref(0);

const form = reactive<NewsArticlePayload>({
  content: '',
  coverUrl: '',
  source: '好客资讯',
  sort: 0,
  status: 2,
  summary: '',
  title: '',
});

function resetForm(row?: NewsArticle) {
  dialogTitle.value = row ? '编辑资讯' : '新增资讯';
  Object.assign(form, {
    content: row?.content || '',
    coverUrl: row?.coverUrl || '',
    id: row?.id,
    source: row?.source || '好客资讯',
    sort: row?.sort || 0,
    status: row?.status || 2,
    summary: row?.summary || '',
    title: row?.title || '',
  });
}

async function fetchData() {
  loading.value = true;
  try {
    const data = await queryNewsArticlePageApi({
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      status: query.status,
      title: query.title || undefined,
    });
    rows.value = data.records || [];
    total.value = data.total || 0;
  } catch (error) {
    ElMessage.error((error as Error).message || '加载资讯失败');
  } finally {
    loading.value = false;
  }
}

function openCreate() {
  resetForm();
  dialogVisible.value = true;
}

function openEdit(row: unknown) {
  resetForm(row as NewsArticle);
  dialogVisible.value = true;
}

async function submitForm() {
  await formRef.value?.validate();
  try {
    if (form.id) {
      await updateNewsArticleApi(form);
      ElMessage.success('资讯已更新');
    } else {
      await createNewsArticleApi(form);
      ElMessage.success('资讯已创建');
    }
    dialogVisible.value = false;
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '保存资讯失败');
  }
}

async function changeStatus(row: unknown, status: number) {
  const item = row as NewsArticle;
  try {
    await updateNewsArticleStatusApi(item.id, status);
    ElMessage.success('状态已更新');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '状态更新失败');
  }
}

async function removeRow(row: unknown) {
  const item = row as NewsArticle;
  try {
    await deleteNewsArticleApi(item.id);
    ElMessage.success('资讯已删除');
    await fetchData();
  } catch (error) {
    ElMessage.error((error as Error).message || '删除资讯失败');
  }
}

function statusLabel(value?: number) {
  return statusOptions.find((item) => item.value === value)?.label || '未知';
}

function statusType(value?: number) {
  return value === 2 ? 'success' : value === 3 ? 'info' : 'warning';
}

onMounted(fetchData);
</script>

<template>
  <Page title="最新资讯管理">
    <div class="p-5">
      <ElCard shadow="never">
        <ElForm :inline="true" :model="query">
          <ElFormItem label="标题">
            <ElInput
              v-model="query.title"
              clearable
              placeholder="输入标题关键词"
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
            <ElSpace>
              <ElButton type="primary" @click="fetchData">查询</ElButton>
              <ElButton @click="openCreate">新增资讯</ElButton>
            </ElSpace>
          </ElFormItem>
        </ElForm>

        <ElTable v-loading="loading" :data="rows" stripe>
          <ElTableColumn label="标题" min-width="220" prop="title" />
          <ElTableColumn label="来源" prop="source" width="120" />
          <ElTableColumn label="排序" prop="sort" width="90" />
          <ElTableColumn label="状态" width="110">
            <template #default="{ row }">
              <ElTag :type="statusType(row.status)">{{
                statusLabel(row.status)
              }}</ElTag>
            </template>
          </ElTableColumn>
          <ElTableColumn label="发布时间" min-width="160" prop="publishTime" />
          <ElTableColumn fixed="right" label="操作" width="260">
            <template #default="{ row }">
              <ElSpace>
                <ElButton link type="primary" @click="openEdit(row)"
                  >编辑</ElButton
                >
                <ElButton link type="success" @click="changeStatus(row, 2)"
                  >发布</ElButton
                >
                <ElButton link type="warning" @click="changeStatus(row, 3)"
                  >下架</ElButton
                >
                <ElPopconfirm
                  title="确认删除该资讯？"
                  @confirm="removeRow(row)"
                >
                  <template #reference>
                    <ElButton link type="danger">删除</ElButton>
                  </template>
                </ElPopconfirm>
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

    <ElDialog v-model="dialogVisible" :title="dialogTitle" width="760px">
      <ElForm ref="formRef" :model="form" label-width="88px">
        <ElFormItem label="标题" prop="title" required>
          <ElInput v-model="form.title" maxlength="100" />
        </ElFormItem>
        <ElFormItem label="摘要">
          <ElInput v-model="form.summary" maxlength="255" />
        </ElFormItem>
        <ElFormItem label="封面图">
          <ElInput v-model="form.coverUrl" placeholder="图片 URL" />
        </ElFormItem>
        <ElFormItem label="来源/排序">
          <ElInput v-model="form.source" style="width: 180px" />
          <ElInputNumber v-model="form.sort" class="ml-3" />
        </ElFormItem>
        <ElFormItem label="状态">
          <ElSelect v-model="form.status" style="width: 140px">
            <ElOption
              v-for="item in statusOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </ElSelect>
        </ElFormItem>
        <ElFormItem label="正文" prop="content" required>
          <ElInput v-model="form.content" :rows="10" type="textarea" />
        </ElFormItem>
      </ElForm>
      <template #footer>
        <ElButton @click="dialogVisible = false">取消</ElButton>
        <ElButton type="primary" @click="submitForm">保存</ElButton>
      </template>
    </ElDialog>
  </Page>
</template>
