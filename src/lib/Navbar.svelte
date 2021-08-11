<script>
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  function showDropdown() {
    var dropdown = document.getElementById("dropdown-content");
    if (dropdown.style.display === "none") {
        dropdown.style.display = "block";
    } else {
        dropdown.style.display = "none";
    }
  }
  onMount(() => {

  });
</script>

<nav>
  <a href="#" class="shine">Shine</a>
  <a id="centercamera" class="active shine"
    ><span class="material-icons"> light_mode </span></a
  >
  <a href="#" on:click={showDropdown} class="shine"
    ><span class="material-icons "> public </span></a
  >
  <div id="dropdown-content">
    <a href="#">Link 1</a>
    <a href="#">Link 2</a>
    <a href="#">Link 3</a>
  </div>
  <a href="#" class="shine"><i class="fa fa-fw fa-envelope" /> Contact</a>
  <a href="#" class="shine"><i class="fa fa-fw fa-user" /> Login</a>
</nav>

<style>
  nav {
    grid-column: 0;
    grid-row: 0;
    z-index: 105;
    display: inline-flex;
    width: fit-content;
    height: 3rem;
  }

  nav a {
    float: left;
    text-align: center;
    padding: 12px;
    color: yellow;
    text-decoration: none;
    font-size: 17px;
  }
  nav a:hover {
    /* color: red; */
  }
  .dropdown {
    float: left;
    overflow: hidden;
  }

  .dropdown .dropbtn {
    cursor: pointer;
    border: none;
    padding: 14px 16px;
    color: white;
    background-color: inherit;
    margin: 0;
  }

  #dropdown-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 160px;
    box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
    z-index: 1;
  }
  #dropdown-content a {
    float: none;
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
    text-align: left;
  }

  .show {
    display: unset;
  }

  .dropdown-content a {
    float: none;
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
    text-align: left;
  }

  .dropdown-content a:hover {
    background-color: #ddd;
  }

  a.shine {
    position: relative;
    display: inline-block;
    font-size: 2em;
    font-weight: 800;
    color: white;
    overflow: hidden;
    background: linear-gradient(to right, hsla(54, 100%, 71%, 1), whitesmoke);
    background-clip: text;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-size: 200% 100%;
    background-position: 100%;
    transition: background-position 275ms ease;
  }
  a.shine:hover {
    background-position: 0 100%;
  }
</style>
