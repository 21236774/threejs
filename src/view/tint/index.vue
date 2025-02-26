<script setup>
import { onMounted, ref } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import { DRACOLoader } from "three/examples/jsm/loaders/DRACOLoader.js"; // 模型解析
import { Reflector } from "three/examples/jsm/objects/Reflector.js";

const renderer = new THREE.WebGLRenderer({ antialias: true });
const scene = new THREE.Scene();
let camera = null;
let controls = null;
const cameraX = ref(0);
const cameraY = ref(0);
const cameraZ = ref(0);

onMounted(() => {
  const container = document.getElementById("Tint");
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

  // 点光源
  // const pointLight = new THREE.PointLight(0xffffff, 20, 100);
  // pointLight.position.set(5, 5, 5);
  // pointLight.castShadow = true; // 设置点光源投射阴影
  // scene.add(pointLight);

  // 添加平行光
  const directionalLight = new THREE.DirectionalLight(0xffffff, 1);
  directionalLight.position.set(5, 5, 5);
  directionalLight.castShadow = true; // 启用阴影
  scene.add(directionalLight);

  // 在加载模型的部分之前或之后添加地板
  const floorGeometry = new THREE.PlaneGeometry(100, 100); // 地板的宽度和高度
  const floorMaterial = new THREE.MeshStandardMaterial({
    color: 0xffffff, // 地板的颜色
    side: THREE.DoubleSide, // 双面渲染
  });
  const floor = new THREE.Mesh(floorGeometry, floorMaterial);
  floor.receiveShadow = true; // 设置地板接收阴影
  floor.rotation.x = -Math.PI / 2; // 将地板旋转到水平位置
  floor.position.y = 0; // 将地板向下移动，确保模型站在地板上
  scene.add(floor);

  // 创建添加镜面地板（反射平面）
  // const reflectorGeometry = new THREE.PlaneGeometry(10, 10);
  // const reflector = new Reflector(reflectorGeometry, {
  //   textureWidth: window.innerWidth * window.devicePixelRatio,
  //   textureHeight: window.innerHeight * window.devicePixelRatio,
  //   color: 0x888888, // 反射平面的颜色
  // });
  // reflector.position.y = -0.01; // 将反射平面放在地板下方
  // reflector.rotation.x = -Math.PI / 2; // 旋转反射平面到水平位置
  // scene.add(reflector);

  const dracoLoader = new DRACOLoader();
  dracoLoader.setDecoderPath(`gltf/`);

  const loader = new GLTFLoader();
  loader.setDRACOLoader(dracoLoader);
  loader.load(`modal/keqing.glb`, function (gltf) {
    const model = gltf.scene;
    model.position.set(0, 0, 0);
    // model.scale.set(1, 1, 1);
    console.log(model);
    model.traverse((child) => {
      //   console.log(child);
      child.castShadow = true; // 设置模型接收阴影
      if (child.isBone) {
        console.log("Bone Name:", child.name); // 打印骨骼名称
      }
    });

    const leftShou = model.getObjectByName("Right_arm_169"); // 正面左手
    leftShou.rotation.x = -250;

    scene.add(model);
    renderer.render(scene, camera);

    const bone = model.getObjectByName("Chest_193"); // 假设骨骼名称是 "BoneName"
    const rightLeg = model.getObjectByName("Left_leg_3"); // 正面右腿
    const leftLeg = model.getObjectByName("Right_leg_7"); // 正面左腿

    if (bone) {
      // 手动控制骨骼旋转
      let angle = 0; // 初始角度
      let direction = 1; // 方向（1 表示向上，-1 表示向下）
      let angleLegRight = 3.1; // 右腿初始旋转角度
      let angleLegLeft = 3.1; // 左腿初始旋转角度
      let directionLegRight = 1; // 右腿旋转方向
      let directionLegLeft = -1; // 左腿旋转方向，与右腿相反

      function animate() {
        requestAnimationFrame(animate);
        // 控制伸懒腰的动作
        angle += 0.001 * direction; // 每帧增加角度
        if (angle > 0.04) direction = -1; // 到达上限后反向
        if (angle < -0.04) direction = 1; // 到达下限后反向
        bone.rotation.z -= angle * 0.1; // 每帧绕 X 轴旋转

        // 控制走路的动作
        angleLegRight += 0.005 * directionLegRight; // 右腿每帧增加旋转角度
        angleLegLeft += 0.005 * directionLegLeft; // 左腿每帧增加旋转角度

        // 右腿角度边界检查
        if (angleLegRight > 3.3) directionLegRight = -1;
        if (angleLegRight < 2.9) directionLegRight = 1;
        if (angleLegLeft > 3.3) directionLegLeft = -1;
        if (angleLegLeft < 2.9) directionLegLeft = 1;

        rightLeg.rotation.z = angleLegRight;
        leftLeg.rotation.z = angleLegLeft;

        controls.update();
        renderer.render(scene, camera);
      }
      animate();
    }
  });

  controls = new OrbitControls(camera, renderer.domElement);
  controls.addEventListener("change", function () {
    const { x, y, z } = camera.position;
    cameraX.value = x;
    cameraY.value = y;
    cameraZ.value = z;
    renderer.render(scene, camera);
  });
  renderer.render(scene, camera); //执行渲染操作
});
</script>

<template>
  <div class="tint" id="Tint"></div>
</template>

<style scoped>
.tint {
  width: 1400px;
  height: 500px;
}
</style>
