<script setup>
import * as dat from "dat.gui";

import { onMounted, ref } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import { DRACOLoader } from "three/examples/jsm/loaders/DRACOLoader.js";
import { Reflector } from "three/examples/jsm/objects/Reflector.js";
import { NTag, NSpace } from "naive-ui";

const gui = new dat.GUI();
const renderer = new THREE.WebGLRenderer({ antialias: true });
const scene = new THREE.Scene();
let camera = null;
let controls = null;
const cameraX = ref(0);
const cameraY = ref(0);
const cameraZ = ref(0);
let model = null;

// 封装初始化场景的函数
const initScene = (container) => {
  renderer.setSize(container?.offsetWidth, container?.offsetHeight);
  renderer.shadowMap.enabled = true;
  container.appendChild(renderer.domElement);

  camera = new THREE.PerspectiveCamera(
    55,
    container?.offsetWidth / container?.offsetHeight || 0,
    1,
    100
  );
  camera.position.set(20, 8, 10);
  scene.background = new THREE.Color(0xbfe3dd);

  // 添加光源
  const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
  directionalLight.position.set(1, 1, 1);
  directionalLight.castShadow = true;
  scene.add(directionalLight);

  // 添加环境光
  const ambientLight = new THREE.AmbientLight(0xffffff, 1);
  scene.add(ambientLight);

  // 添加半球光
  const hemisphereLight = new THREE.HemisphereLight(0xffffff, 0x444444, 0.6);
  scene.add(hemisphereLight);

  // 点光源
  const pointLight = new THREE.PointLight(0xffffff, 1, 100, 2);
  pointLight.position.set(5, 5, 5);
  scene.add(pointLight);

  // const pointLightFolder = gui.addFolder("pointLight Light");
  // pointLightFolder.add(pointLight, "intensity", 0, 18).name("Intensity");
  // pointLightFolder.add(pointLight.position, "x", -10, 100).name("X Position");
  // pointLightFolder.add(pointLight.position, "y", -10, 100).name("Y Position");
  // pointLightFolder.add(pointLight.position, "z", -10, 100).name("Z Position");

  // // 创建一个文件夹来组织灯光相关的控制器
  // const lightFolder = gui.addFolder("Directional Light");
  // // 添加强度控制器
  // lightFolder.add(directionalLight, "intensity", 0, 2).name("Intensity");
  // lightFolder.add(directionalLight.position, "x", -10, 10).name("X Position");
  // lightFolder.add(directionalLight.position, "y", -10, 10).name("Y Position");
  // lightFolder.add(directionalLight.position, "z", -10, 10).name("Z Position");

  // 添加地板
  const floorGeometry = new THREE.PlaneGeometry(100, 100);
  const floorMaterial = new THREE.MeshStandardMaterial({
    color: 0x444444,
    side: THREE.DoubleSide,
  });
  const floor = new THREE.Mesh(floorGeometry, floorMaterial);
  floor.receiveShadow = true;
  floor.rotation.x = -Math.PI / 2;
  floor.position.y = 0;
  scene.add(floor);

  // const gridHelper = new THREE.GridHelper(40, 60, 0xc1c1c1, 0x8d8d8d);
  // gridHelper.position.y = 0.01; // 确保网格辅助线在地板上方
  // scene.add(gridHelper);

  controls = new OrbitControls(camera, renderer.domElement);
  controls.addEventListener("change", () => {
    const { x, y, z } = camera.position;
    cameraX.value = x;
    cameraY.value = y;
    cameraZ.value = z;
    renderer.render(scene, camera);
  });
};

const API = {
  directionalLightIntensity: 0.6,
  envMapIntensity: 1,
};
const setModalMaterial = (color = "#fff", color1 = "#e0e0e0") => {
  const material = new THREE.MeshPhysicalMaterial({
    color,
    metalness: 0.5,
    roughness: 0.5,
    clearcoat: 1,
    envMapIntensity: API.envMapIntensity,
  });
  const material1 = material.clone();
  const material2 = material.clone();
  const materialb = material.clone();
  material1.color = new THREE.Color(color1);
  material2.color = new THREE.Color("#BF3131");
  materialb.color = new THREE.Color("#fff");
  if (!model) return;
  const type1 = [
    "Object_32",
    "Object_33",
    "Object_36",
    "Object_38",
    "Object_37",
    "Object_39",
    "Object_40",
    "Object_41",
    "Object_43",
    "Object_44",
    "Object_45",
    "Object_46",
    "Object_47",
    "Object_42",
    "Object_64",
    "Object_63",
    "Object_61",
    "Object_58",
    "Object_56",
  ];
  const type2 = [
    "Object_25",
    "Object_26",
    "Object_27",
    "Object_28",
    "Object_29",
    "Object_30",
    "Object_31",
    "Object_34",
    "Object_35",
    "Object_48",
    "Object_49",
  ];
  const type3 = ["Object_65"];
  const type4 = [];
  model.traverse((child) => {
    child.castShadow = true;
    child.receiveShadow = true;
    if (child.isMesh) {
      const { name } = child;
      if (type1.includes(name)) child.material = material;
      if (type2.includes(name)) child.material = material1;
      if (type3.includes(name)) child.material = material2;
      if (type4.includes(name)) child.material = materialb;
    }
  });
};

// 封装加载模型的函数
const loadModel = () => {
  const dracoLoader = new DRACOLoader();
  dracoLoader.setDecoderPath(`gltf/`);

  const loader = new GLTFLoader();
  loader.setDRACOLoader(dracoLoader);
  loader.load(
    `modal/scene.gltf`,
    (gltf) => {
      model = gltf.scene;
      model.position.set(80, 0, 10);
      setModalMaterial();
      scene.add(model);
      renderer.render(scene, camera);
    },
    undefined,
    (error) => {
      console.error("模型加载失败:", error);
    }
  );
};
const animate = () => {
  requestAnimationFrame(animate);
  renderer.render(scene, camera);
};
const colorList = [
  {
    id: 0,
    color: "#C5BAFF",
    name: "淡紫色",
  },
  {
    id: 1,
    color: "#FEA1BF",
    name: "淡粉色",
  },
  {
    id: 2,
    color: "#40cce7",
    name: "淡蓝色",
  },
];

onMounted(() => {
  const container = document.getElementById("Skin-Change");
  if (container) {
    initScene(container);
    loadModel();
    renderer.render(scene, camera);
    animate();
  }
});
</script>

<template>
  <div class="mb-12 pointer">
    <n-space>
      <n-tag
        :bordered="false"
        v-for="item in colorList"
        :key="item.id"
        @click="setModalMaterial(item.color)"
        :color="{ color: item.color }"
      >
        {{ item.name }}
      </n-tag>
    </n-space>
  </div>
  <div class="tint" id="Skin-Change"></div>
</template>

<style scoped>
.tint {
  width: 1400px;
  height: 500px;
}
</style>
