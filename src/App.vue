<script setup lang="ts">
import type { MenuOption } from "naive-ui";
import { NEllipsis } from "naive-ui";
import { h, defineAsyncComponent, markRaw, reactive, ref } from "vue";

const active = ref("2");
const setActive = (key: string) => {
  console.log(key);

  active.value = key;
};

const options: MenuOption[] = [
  {
    label: () => h(NEllipsis, null, { default: () => "模型" }),
    key: "1",
  },
  {
    label: () => h(NEllipsis, null, { default: () => "换肤" }),
    key: "2",
  },
];
const componentsLeftData = reactive({
  "1": markRaw(defineAsyncComponent(() => import("./view/tint/index.vue"))),
  "2": markRaw(
    defineAsyncComponent(() => import("./view/skin-change/index.vue"))
  ),
});
</script>

<template>
  <n-layout has-sider>
    <n-layout-sider>
      <n-menu
        :options="options"
        style="width: 180px"
        default-value="1"
        @update:value="setActive"
      />
    </n-layout-sider>
    <n-layout>
      <n-layout-header>头部</n-layout-header>
      <n-layout-content>
        <div class="content">
          <component :is="componentsLeftData[active]" />
        </div>
      </n-layout-content>
      <n-layout-footer>尾部</n-layout-footer>
    </n-layout>
  </n-layout>
</template>

<style scoped>
.content {
  width: 100%;
  height: 500px;
  background-color: #e0e0e0;
  padding: 24px;
}
</style>
