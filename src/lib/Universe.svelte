<canvas bind:this={canvas} />
<main>
  <!-- <Hero /> -->
  <!-- <Navbar /> -->
  {#if selected}
    <h1 class="selected_planet">{$selected.name}</h1>
  {/if}
  <!-- {#if selected == sun}
    <
  {/if} -->
</main>

<script lang="ts">
  import * as THREE from "three";
  import { OrbitControls } from "three/examples/jsm/controls/OrbitControls";

  import earthimg from "../assets/textures/planets/earth.jpg";
  import sunimg from "../assets/textures/planets/sun.jpg";
  import marsimg from "../assets/textures/planets/mars.jpg";
  import mercuryimg from "../assets/textures/planets/mercury.jpg";
  import neptuneimg from "../assets/textures/planets/neptune.jpg";
  import uranusimg from "../assets/textures/planets/uranus.jpg";
  import venusimg from "../assets/textures/planets/venus.jpg";
  import jupiterimg from "../assets/textures/planets/jupiter.jpg";
  import saturnimg from "../assets/textures/planets/saturn.jpg";
  import spaceTexture from "../assets/textures/SpaceVoid.jpg";

  import { onMount } from "svelte";
  import { writable } from "svelte/store";

  import Navbar from "./Navbar.svelte"
  import Hero from "./Hero.svelte"

  // Initialize Three.js
  let canvas;
  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  );
  const loader = new THREE.TextureLoader();
  let renderer;
  let controls;

  const pointLight = new THREE.PointLight(0xffffff);
  pointLight.position.set(20, 20, 20);
  scene.add(pointLight)

  const mouse = new THREE.Vector2();
  const raycaster = new THREE.Raycaster();

  //  Initial Camera Config
  camera.position.set(12, 40, 85);
  $: raycaster.setFromCamera(mouse, camera);

  function onMouseMove(event) {
    // calculate mouse position in normalized device coordinates
    // (-1 to +1) for both components

    mouse.x = (event.clientX / window.innerWidth) * 2 - 1;
    mouse.y = -(event.clientY / window.innerHeight) * 2 + 1;
  }

  // Initialize Planets

  interface IPlanet {
    name: string;
    time: number;
    speed: number;
    rotation: {
      x: number;
      y: number;
      z: number;
    };
    position: {
      x: number;
      y: number;
      z: number;
    };
  }

  const default_planet: IPlanet = {
    name: "",
    time: 0,
    speed: 0,
    rotation: {
      x: 0,
      y: 0,
      z: 0,
    },
    position: {
      x: 0,
      y: 0,
      z: 0,
    },
  };

  let sun: IPlanet, mercury: IPlanet, venus: IPlanet, earth: IPlanet, mars: IPlanet, jupiter: IPlanet, saturn: IPlanet, uranus: IPlanet

  const planets = writable({
    sun: sun,
    mercury: mercury,
    venus: venus,
    earth: earth,
    mars: mars,
    jupiter: jupiter,
    saturn: saturn,
    uranus: uranus,
  });

  $: hovered = raycaster.intersectObjects(scene.children)[0];
  // $: hovered.object.material.transparent = true
  // $: hovered.object.material.opacity = 0.5

  let selected = writable<IPlanet>(default_planet);

  $: {
    if (hovered) {
      document.body.style.cursor = "pointer";
      hovered.object.material.visible = false;
    } else {
      document.body.style.cursor = "default";
    }
  }

  // function resetMaterials() {
  //   for (let i = 0; i < scene.children.length; i++) {
  //     if (scene.children[i].material) {
  //       scene.children[i].count = 1
  //       scene.children[i].count += 1
  //       scene.children[i].material.opacity =
  //         selected == scene.children[i] ? 0.5 : 1.0;
  //       // document.body.style.cursor = "default";
  //       scene.children[i].material.visible = true
  //     }

  //   }
  // }

  function handlePlanetClick(e) {
    // console.log($planets["sun"])
    // console.log(raycaster.intersectObjects(scene.children)[0].object.name)
    if (
      raycaster.intersectObjects(scene.children)[0] &&
      $planets.hasOwnProperty(
        raycaster.intersectObjects(scene.children)[0].object.name
      )
    ) {
      toggleSelected(raycaster.intersectObjects(scene.children)[0].object);
      //   if ($selected == raycaster.intersectObjects(scene.children)[0].object) {
      //     console.log("Select a new Planet");
      //   } else {
      //     toggleSelected(raycaster.intersectObjects(scene.children)[0].object)
      //     console.log(`New Planet Selected: ${$selected.name}`);
      //   }
      // }
    }
  }
  export function showDropdown() {
    document.getElementById("myDropdown").classList.toggle("show");
    console.log("show!");
  }

  function toggleSelected(toToggle) {
    if ($selected == toToggle) {
      $selected = default_planet;
      console.log($selected);
      // rerun animations
      $selected.classList.add("selected")!;
    } else {
      $selected = toToggle;
      console.log($selected.time);
      // remove animations off $selected and apply to toToggle
    }
  }

  function addStar() {
    const geometry = new THREE.SphereGeometry(0.25, 24, 24);
    const material = new THREE.MeshStandardMaterial({ color: 0xffffff });
    const star = new THREE.Mesh(geometry, material);

    const [x, y, z] = Array(3)
      .fill()
      .map(() => THREE.MathUtils.randFloatSpread(300));
    star.position.set(x, y, z);
    scene.add(star);
  }

  function onWindowResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();

    renderer.setSize(window.innerWidth, window.innerHeight);
  }

  window.addEventListener("resize", onWindowResize);
  window.addEventListener("mousemove", onMouseMove, false);
  window.addEventListener("click", handlePlanetClick);

  onMount(() => {
    // Initialize Renderer
    renderer = new THREE.WebGL1Renderer({
      canvas: canvas,
    });
    controls = new OrbitControls(camera, renderer.domElement);
    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setSize(window.innerWidth, window.innerHeight);

    // Background
    // const background = loader.load(spaceTexture);
    const background = "black"
    scene.background = background;

    Array(400).fill().forEach(addStar)

    
    //  Initialize planets

    //      - Sun -
    const sunGeometry = new THREE.SphereGeometry(12, 32, 16);
    const sunTexture = loader.load(sunimg);
    const sunMaterial = new THREE.MeshBasicMaterial({
      map: sunTexture,
    });
    sun = new THREE.Mesh(sunGeometry, sunMaterial);
    sun.time = 0;
    sun.speed = 0;
    sun.name = "sun";
    // sun.rotation = 0;
    $planets.sun = sun;
    scene.add(sun);

    //     - Mercury -
    const mercuryGeometry = new THREE.SphereGeometry(1.5, 32, 16);
    const mercuryTexture = loader.load(mercuryimg);
    const mercuryMaterial = new THREE.MeshBasicMaterial({
      map: mercuryTexture,
    });
    mercury = new THREE.Mesh(mercuryGeometry, mercuryMaterial);
    mercury.time = 0;
    mercury.speed = 0.035;
    mercury.name = "mercury";
    $planets.mercury = mercury;
    scene.add(mercury);

     //     - Venus -
    const venusGeometry = new THREE.SphereGeometry(2.5, 32, 16);
    const venusTexture = loader.load(venusimg);
    const venusMaterial = new THREE.MeshBasicMaterial({
      map: venusTexture,
    });
    venus = new THREE.Mesh(venusGeometry, venusMaterial);
    venus.time = 0;
    venus.speed = 0.03;
    venus.name = "venus";
    $planets.venus = venus;
    scene.add(venus);

     //     - Earth -
    const earthGeometry = new THREE.SphereGeometry(3, 32, 16);
    const earthTexture = loader.load(earthimg);
    const earthMaterial = new THREE.MeshBasicMaterial({
      map: earthTexture,
    });
    earth = new THREE.Mesh(earthGeometry, earthMaterial);
    earth.time = 0;
    earth.speed = 0.01;
    earth.name = "earth";
    $planets.earth = earth;
    scene.add(earth);

     //     - Mars -
    const marsGeometry = new THREE.SphereGeometry(2.2, 32, 16);
    const marsTexture = loader.load(marsimg);
    const marsMaterial = new THREE.MeshBasicMaterial({
      map: marsTexture,
    });
    mars = new THREE.Mesh(marsGeometry, marsMaterial);
    mars.time = 0;
    mars.speed = 0.005;
    mars.name = "mars";
    $planets.mars = mars;
    scene.add(mars);

     //     - Jupiter -
    const jupiterGeometry = new THREE.SphereGeometry(6, 32, 16);
    const jupiterTexture = loader.load(jupiterimg);
    const jupiterMaterial = new THREE.MeshBasicMaterial({
      map: jupiterTexture,
    });
    jupiter = new THREE.Mesh(jupiterGeometry, jupiterMaterial);
    jupiter.time = 0;
    jupiter.speed = 0.0125;
    jupiter.name = "jupiter";
    $planets.jupiter = jupiter;
    scene.add(jupiter);

     //     - Saturn -
    const saturnGeometry = new THREE.SphereGeometry(5.6, 32, 16);
    const saturnTexture = loader.load(saturnimg);
    const saturnMaterial = new THREE.MeshBasicMaterial({
      map: saturnTexture,
    });
    saturn = new THREE.Mesh(saturnGeometry, saturnMaterial);
    saturn.time = 0;
    saturn.speed = 0.025;
    saturn.name = "saturn";
    $planets.saturn = saturn;
    scene.add(saturn);

     //     - Uranus -
    const uranusGeometry = new THREE.SphereGeometry(4.2, 32, 16);
    const uranusTexture = loader.load(uranusimg);
    const uranusMaterial = new THREE.MeshBasicMaterial({
      map: uranusTexture,
    });
    uranus = new THREE.Mesh(uranusGeometry, uranusMaterial);
    uranus.time = 0;
    uranus.speed = 0.0085;
    uranus.name = "uranus";
    $planets.uranus = uranus;
    scene.add(uranus);

    for (const k in $planets) {
      const v = $planets[k];
      v.addEventListener("click", "handlePlanetClick");
    }
  });

  let frame = requestAnimationFrame(loop);

  function loop(t) {
    frame = requestAnimationFrame(loop);
    $planets.mercury.time += $planets.mercury.speed;
    $planets.venus.time += $planets.venus.speed;
    $planets.earth.time += $planets.earth.speed;
    $planets.mars.time += $planets.mars.speed;
    $planets.jupiter.time += $planets.jupiter.speed;
    $planets.saturn.time += $planets.saturn.speed;
    $planets.uranus.time += $planets.uranus.speed;

    $planets.sun.rotation.y += 0.005;
    $planets.mercury.rotation.y += 0.03;
    $planets.venus.rotation.y += 0.05;
    $planets.earth.rotation.y += 0.05;
    $planets.mars.rotation.y += 0.05;
    $planets.jupiter.rotation.y += 0.05;
    $planets.saturn.rotation.y += 0.05;
    $planets.uranus.rotation.y += 0.05;

    $planets.mercury.position.x = 40 * Math.cos($planets.mercury.time) + 0;
    $planets.mercury.position.z = 20 * Math.sin($planets.mercury.time) + 0;

    $planets.venus.position.x = 50 * Math.cos($planets.venus.time) + 0;
    $planets.venus.position.z = 30 * Math.sin($planets.venus.time) + 0;

    $planets.earth.position.x = 60 * Math.cos($planets.earth.time) + 0;
    $planets.earth.position.z = 40 * Math.sin($planets.earth.time) + 0;

    $planets.mars.position.x = 70 * Math.cos($planets.mars.time) + 0;
    $planets.mars.position.z = 50 * Math.sin($planets.mars.time) + 0;

    $planets.jupiter.position.x = 80 * Math.cos($planets.jupiter.time) + 0;
    $planets.jupiter.position.z = 60 * Math.sin($planets.jupiter.time) + 0;

    $planets.saturn.position.x = 90 * Math.cos($planets.saturn.time) + 0;
    $planets.saturn.position.z = 70 * Math.sin($planets.saturn.time) + 0;

    $planets.uranus.position.x = 100 * Math.cos($planets.uranus.time) + 0;
    $planets.uranus.position.z = 80 * Math.sin($planets.uranus.time) + 0;

    controls.update();
    renderer.render(scene, camera);

  }
</script>

<style>
  canvas {
    position: fixed;
    top: 0;
    left: 0;
    z-index: 1;
    width: 100vh;
    height: 100vh;
  }
  main {
    width: 100vw;
    height: 100vh;
    color: white;
    position: absolute;
    width: 100%;
    margin: 0px auto;

    grid-template-columns: repeat(20, 5vw);
    grid-template-rows: repeat(20, 5vh);
    display: grid;
  }

</style>
