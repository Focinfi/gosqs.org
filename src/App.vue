<template>
  <div id="app">
    <div class="header">
      <el-row>
        <el-col :span="4">
          <br>
        </el-col>
        <el-col :span="10">
          <a href="/" class="nav-home">
            <img class="nav-logo" src="http://on78mzb4g.bkt.clouddn.com/gosqs.org.logo.svg"></img> 
          </a>
        </el-col>
        <el-col :span="3">
        <br>
        </el-col>
        <el-col :span="3">
          <div class="header-right">
            <a href="https://github.com/Focinfi/gosqs" class="link" type="text">Github</a>          
            <a href="https://github.com/Focinfi/gosqs" class="link" type="text">V0.1.0</a>
          </div>
        </el-col>
        <el-col :span="4">
          <br>
        </el-col>
      </el-row>
    </div>
    <router-view class="router"></router-view>
  </div>
</template>

<script>
export default {
  name: 'app'
}
</script>

<style>
body {
  margin: 0; 
}

a {
  text-decoration: none;
}

#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
}

.header {
  width: 100%;
  line-height: 60px;
  background-color: #222;
  position: fixed;
  z-index: 100;
  box-shadow: 0 0 5px rgba(0,0,0,0.5);
}

.header .link {
  font-size: 1.1em;
  color: #ddd;
  margin-left: 10px;
}

.header .link:hover {
  color: #e9e9e9;
}

.header-right {
  float: right;
}

.router {
  padding-top: 60px;
}

.nav-home {
  line-height: 40px;
}

.nav-logo {
  vertical-align: middle;
  padding: 5px 0;
}
</style>
