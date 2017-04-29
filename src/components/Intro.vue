<template>
  <div>
  <div class="intro">
  <el-row>
    <el-col :span="4">
      <br>
    </el-col>
    <el-col :span="8">
      <strong class="head">GoSQS</strong>
      <p class="desc">
        Simple Queue Service for
      </p>
      <p class="desc">
        Scalability and Ordered Delivery
      </p>
      <el-button class="link-button" size="large" type="primary"><strong>Get Started</strong></el-button>
      <el-button class="link-button" size="large" type="primary"><strong>Look the Design</strong></el-button>
    </el-col>
    <el-col :span="8">
      <try></try>
    </el-col>
    <el-col :span="4">
    </el-col>
  </el-row>
  </div>
  <br>
  <el-row>
    <el-col :span="4">
      <br>
    </el-col>
    <el-col :span="16">
      <h2><strong>Why another Queue Service?</strong></h2>
      <p>
        For practicing the golang programming language and distributed system.
        I choose to implement a queue service with focus on  
        <strong>simplicity</strong> and
        <strong>scalability</strong> and
        <strong>ordered delivery</strong>.
        <br>
        <br>
        To decouple the dependency of underlying storage of message, gosqs uses the 
        <a href="https://github.com/Focinfi/oncekv" target="_blank">oncekv</a>, 
        which is a combination of groupcahe and raft-boltdb.

      </p>
      <h2><strong>Design Overview</strong></h2>
      <img class="architeture" src="http://on78mzb4g.bkt.clouddn.com/gosqs_architeture.png" alt="architeture">
      <section>
        <h2><strong>Get Started</strong></h2>
        <p>
          1. Get the `accessKey=` and `secretKey`:
          <p class="indent">
            1. Star the <a href="http://github.com/Focinfi/gosqs">gosqs</a> project.
            2. 
          </p>
        </p>
        <p>
          1. Perpare the keys: 
          <div class="indent">
            Access Key:
            <code>"{{testAccessKey}}"</code> 
            <br>
            <br>
            Secret Key:
            <el-input class="secret-key-input" size="small" v-model="testSecretKey" @click.native="$event.target.select()"></el-input>
            <br>
            <br>
            Or, 
            <el-button type="text" @click="sendKeysToStagzar">Get my own keys</el-button>
          </div>
        </p>
        <p>
          2. Apply a server node.
        </p>
        <p>
          3. Apply a message id.
        </p>        
        <p>
          4. Push a message.
        </p>
        <p>
          5. Pull messages.
        </p>
      </section>
    </el-col>      
    <el-col :span="4">
      <br>
    </el-col>    
  </el-row>
  </div>
</template>

<script>
import Try from './Try.vue'

export default {
  name: 'intro',
  components: {
    Try
  },
  data () {
    return {
      testAccessKey: 'test',
      testSecretKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyIiOiJ0ZXN0In0.nrTjKRRFa2nuvqpwjNtpHYbWotxupYN6zf-S48XWxuY'
    }
  },
  methods: {
    sendKeysToStagzar () {
      // let _this = this
      this.$prompt('Then input your github.com login', 'First Star the github.com/Focinfi/gosqs', {
        confirmButtonText: 'Send Keys',
        cancelButtonText: 'Cancel',
        inputValidator: function (content) {
          if (content === null || content === undefined || content === '') {
            return 'Empty login'
          }
          console.log(content)
          return true
        }
      }).then(({ value }) => {
      }).catch(() => {
        this.$message({
          type: 'info',
          message: 'Canceled'
        })
      })
    }
  }

}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
  font-weight: normal;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}

code {
  padding: 0.2em;
  background-color: rgba(27,31,35,0.05);
  border-radius: 3px;
}

.head {
  color: rgb(97, 218, 251);
  font-size: 3.5em;
  text-shadow: 0 1px 3px rgba(0,0,0,0.3);
}

.intro {
  width: 100%;
  background: rgb(45, 45, 45);
  padding: 50px 0;
}

.desc {
  font-size: 1.2em;
  color: #e9e9e9;
}

.link-button {
  background-color: rgb(204, 122, 111);
  border-color: rgb(204, 122, 111);
  font-size: 1.2em;
  text-shadow: 0 1px 3px rgba(0,0,0,0.3);
}

.architeture {
  height: 70%;
  width: 70%;
  border-radius: 5px;
  box-shadow: 0px 0px 2px #888888;
}

.indent {
  margin-left: 5%;
}
.secret-key-input {
  width: 40%;
}
</style>
