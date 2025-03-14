<script setup>
import { onMounted, ref } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import { DRACOLoader } from "three/examples/jsm/loaders/DRACOLoader.js";
import { Reflector } from "three/examples/jsm/objects/Reflector.js";

const renderer = new THREE.WebGLRenderer({ antialias: true });
const scene = new THREE.Scene();
let camera = null;
let controls = null;
const cameraX = ref(0);
const cameraY = ref(0);
const cameraZ = ref(0);

// 封装初始化场景的函数
const initScene = (container) => {
  renderer.setSize(container?.offsetWidth, container?.offsetHeight);
  renderer.shadowMap.enabled = true;
  container.appendChild(renderer.domElement);

  camera = new THREE.PerspectiveCamera(
    40,
    container?.offsetWidth / container?.offsetHeight || 0,
    1,
    100
  );
  camera.position.set(0, 0, 5);
  scene.background = new THREE.Color(0xbfe3dd);

  // 添加光源
  const ambientLight = new THREE.AmbientLight(0x404040, 0.5);
  scene.add(ambientLight);

  const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
  directionalLight.position.set(5, 5, 5);
  directionalLight.castShadow = true;
  scene.add(directionalLight);

  // 添加地板
  const floorGeometry = new THREE.PlaneGeometry(100, 100);
  const floorMaterial = new THREE.MeshStandardMaterial({
    color: 0xffffff,
    side: THREE.DoubleSide,
  });
  const floor = new THREE.Mesh(floorGeometry, floorMaterial);
  floor.receiveShadow = true;
  floor.rotation.x = -Math.PI / 2;
  floor.position.y = 0;
  scene.add(floor);

  controls = new OrbitControls(camera, renderer.domElement);
  controls.addEventListener("change", () => {
    const { x, y, z } = camera.position;
    cameraX.value = x;
    cameraY.value = y;
    cameraZ.value = z;
    renderer.render(scene, camera);
  });
};

// 封装加载模型的函数
const loadModel = () => {
  const dracoLoader = new DRACOLoader();
  dracoLoader.setDecoderPath(`gltf/`);

  const loader = new GLTFLoader();
  loader.setDRACOLoader(dracoLoader);

  loader.load(
    `modal/keqing.glb`,
    (gltf) => {
      const model = gltf.scene;
      model.position.set(0, 0, 0);
      model.traverse((child) => {
        child.castShadow = true;
      });

      scene.add(model);
      renderer.render(scene, camera);
    },
    undefined,
    (error) => {
      console.error("模型加载失败:", error);
    }
  );
};

onMounted(() => {
  const container = document.getElementById("Skin-Change");
  if (container) {
    initScene(container);
    loadModel();
    renderer.render(scene, camera);
  }
});
</script>

<template>
  <div class="tint" id="Skin-Change"></div>
</template>

<style scoped>
.tint {
  width: 1400px;
  height: 500px;
}
</style>
