<script>
  import { onMount } from "svelte";
  let dataTarget;
// element, 
  function processText(text, timeout, iterations) {
    let processedText = '';
    while (processedText != text) {
      for (let l = 0; l < text.length; l++) {
        let original_letter = text[l][0];
        let index = l;
        for (let i = 0; i < iterations.length; i++) {
        //   setTimeout((text[l] = randomizeCharacter(text[l])), timeout);
        text[l][0] = randomizeCharacter(text[l])
        }
        text[l][0] = original_letter;
        processedText.concat(original_letter)
        console.log(processedText)
      }
    }
  }

  function randomizeCharacter(char) {
    const characters = [
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "x",
      "y",
      "x",
      "#",
      "%",
      "&",
      "-",
      "+",
      "_",
      "?",
      "/",
      "\\",
      "=",
    ];
    return characters[randomNumber(0, characters.length)];
  }

  function randomNumber(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  processText("Hello World", 10, 5)

  onMount(() => {});
</script>

<div class="container">
  <h1 class="heading" bind:this={dataTarget}>Hello</h1>
</div>

<style>
  * {
    box-sizing: border-box;
  }

  /* html,
  body {
    height: 100%;
    margin: 0;
    font-family: "Unica One", sans-serif;
    background: #111;
  } */

  .container {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    padding: 5rem;
    z-index: 15;
  }

  .heading {
    color: #eee;
    font-size: 5rem;
    font-weight: 300;
    text-transform: uppercase;
  }
</style>
