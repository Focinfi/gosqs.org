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
      <el-button class="link-button" size="large" type="primary" v-scroll-to="{el: '#get-started', offset: -80}"><strong>Get Started</strong></el-button>
      <el-button class="link-button" size="large" type="primary" v-scroll-to="{el: '#design-overview', offset: -80}"><strong>Look the Design</strong></el-button>
    </el-col>
    <el-col :span="8">
      <try :masterAddr="masterAddr" :accessKey="testAccessKey" :secretKey="testSecretKey"></try>
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
        While playing the golang programming language in distributed system.
        A queue service project called gosqs with focus on  
        <strong>reliability</strong>,
        <strong>scalability</strong> and
        <strong>ordered delivery</strong> was born.
        <br>
        <br>
        Compare with other message queue implementations, the currency performance is not the priority of gosqs. Furthermore, gosqs is designed for the more strict scenarios. 
      </p>
      <h2 id="design-overview"><strong>Design Overview</strong></h2>
      <p>
      gosqs uses the
        <a href="https://github.com/coreos/etcd" target="_blank">etcd</a>
        to store the meta data of cluster and queue, like the current available node servers.
      <br>
      <br>
      To decouple the dependency of underlying storage of message, gosqs uses the 
        <a href="https://github.com/Focinfi/oncekv" target="_blank">oncekv</a>
        which is a combination of groupcahe and raft-boltdb.
      </p>
      <img class="architeture" src="http://on78mzb4g.bkt.clouddn.com/gosqs_architeture.png" alt="architeture">
      <br>
      <p>
      Every message in a queue has its own sequence id, every queue has a number of squads, which is a record for the last processed message id in its coresponding queue.  
      </p>
      <img class="queue_and_squad" src="http://on78mzb4g.bkt.clouddn.com/gosqs_queue_squad.png" alt="architeture">
      <section>
        <h2 id="get-started"><strong>Get Started</strong></h2>
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
            <el-button type="text" @click="sendKeysToStagzar">Get your own keys</el-button>
          </div>
        </p>
        <p>
          2. Apply a server node:
          <pre class="code indent">
    <code>POST http://master.gosqs.org/applyNode
    Body:
      {
        "access_key": "test", 
        "secret_key": "secret.key.in.step.1",
        "queue_name": "foo",
        "squad_name": "bar"
      }</code>
          </pre>
          <p class="indent">
            You will get the response body like:
            <pre class="code">
    <code>{
        "code": 1000,
        "message": "",
        "data": {
            "node": "http://node-1.gosqs.org",
            "token": "token.token.token"
        }
    }</code>
            </pre>
            The "token" will be used in the subsequent requests.
          </p>
          </pre>
        </p>
        <p>
          3. Apply a message id:
          <p class="indent">
            Every new message need a sequence id.
            Specify the "size" parameter to determine the range of id.
            <pre class="code">
    <code>POST http://node-1.gosqs.org/messageID
    Body:
      {
        "queue_name": "foo",
        "token": "token.from.step.2",
        "size": 1
      }</code>
            </pre>
            Response as following which indicates the id is 5.
            <pre class="code">
    <code>{
      "code": 1000,
      "message": "",
      "data": {
          "message_id_begin": 5,
          "message_id_end": 5
      }
    }</code>
            </pre>
          </p>
        </p>        
        <p>
          4. Push a message:
          <p class="indent">
            <pre class="code">
    <code>POST http://node-1.gosqs.org/message
    Body:
      {
        "queue_name": "foo",
        "token": "token.from.step.2",
        "message_id": 5,
        "content": "hello gosqs"
      }</code>
            </pre>
            Check the value of "code" in the response body to detect if the message has been pushed, 1000 is ok.
            <pre class="code">
    <code>{
      "code": 1000,
      "message": "",
      "data": null
    }</code>
            </pre>
          </p>
        </p>
        <p>
          5. Pull messages:
          <p class="indent">
            <pre class="code">
    <code>POST http://node-1.gosqs.org/messages
    Body:
      {
        "queue_name": "foo",
        "squad_name": "bar",
        "token": "token.from.step.2",
      }</code>
            </pre>
            Messages will be in the "data" parameter.
            <pre class="code">
    <code>{
      "code": 1000,
      "message": "",
      "data": [
        {"message_id": 4, "content": "hello from china"},
        {"message_id": 5, "content": "hello gosqs"}
      ]
    }</code>
            </pre>
          </p
          </p>          
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
    let masterAddr = ''
    if (process.env.SQS_ADMIN_ADDR !== 'undefined') {
      masterAddr = process.env.SQS_ADMIN_ADDR
    }
    return {
      masterAddr: masterAddr,
      testAccessKey: 'test',
      testSecretKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2dpdGh1Yl9sb2dpbl9rZXkiOiJ0ZXN0In0.Rmg9qFF_9YwBpIYD_Utd4L89bbIP7Vl9yyzehdos1L8'
    }
  },
  methods: {
    sendKeysToStagzar () {
      this.$prompt('Then input your github.com login', 'Star the github.com/Focinfi/gosqs', {
        confirmButtonText: 'Send Keys',
        cancelButtonText: 'Cancel',
        inputValidator: function (content) {
          if (content === null || content === undefined || content === '') {
            return 'Empty login'
          }
          return true
        },

        beforeClose: (action, instance, done) => {
          if (action !== 'confirm') {
            done()
            return
          }
          instance.confirmButtonLoading = true
          this.$http.get(this.masterAddr + '/sendGithubEmailSecretKey/' + instance.inputValue).then(response => {
            let body = response.body
            if (body.code === 1000) {
              done()
              setTimeout(() => {
                instance.confirmButtonLoading = false
              }, 300)
              this.$notify({
                type: 'success',
                title: 'Notification',
                message: 'Sent to ' + body.data.email,
                duration: 0
              })
              return
            }

            this.$message({
              type: 'warning',
              message: '"' + instance.inputValue + '" is ' + body.message
            })
            instance.confirmButtonLoading = false
          }, response => {
            done()
            instance.confirmButtonLoading = false
            this.$message({
              type: 'info',
              message: 'Failed to send the keys'
            })
          })
        }
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

.code {
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
img {
  border-radius: 5px;
  box-shadow: 0px 0px 2px #888888;
}

.architeture {
  height: 70%;
  width: 70%;
}

.queue_and_squad {
  height: 90%;
  width: 90%;
}

.indent {
  margin-left: 5%;
}
.secret-key-input {
  width: 40%;
}
</style>
