<template>
  <div class="try">
    <el-card>
      <div slot="header" class="clearfix messages-header">
        <span class="header-text">
          Test Queue<br>
          <el-tag type="primary">{{testSquad}}</el-tag>
          <el-tag :type="testingTagType">{{testingStateString}}</el-tag>
        </span>
        <el-button :disabled="testingUnavailable" style="float: right;" type="primary" @click="pushMessage">Push Message</el-button>
      </div>
      <div v-for="o, i in messageLogs" class="text item">
        {{ o.time }} {{ messagesEntryFormat(o.messages) }}
      </div>
    </el-card> 
  </div>
</template>

<script>
export default {
  name: 'try',
  props: {
    masterAddr: String,
    accessKey: String,
    secretKey: String
  },
  data () {
    return {
      testSquad: 'gosqs.org',
      newMessage: '',
      messageLogs: [],
      servingNode: '',
      token: '',
      nextId: 0
    }
  },
  created () {
    this.applyNode()
  },
  mounted () {
    console.log('mounted')
    setInterval(this.pullMessage, 1000)
  },
  computed: {
    apiJSONparams () {
      return JSON.stringify({
        'queue_name': this.accessKey,
        'squad_name': this.testSquad,
        'token': this.token,
        'message_id': this.nextId,
        'content': this.newMessage,
        'size': 1
      })
    },
    testingTagType () {
      return this.servingNode === '' ? 'gray' : 'success'
    },
    testingUnavailable () {
      return this.servingNode === ''
    },
    testingStateString () {
      return this.servingNode === '' ? 'unavailabe' : 'availabe'
    }
  },
  methods: {
    applyNode () {
      let body = JSON.stringify({
        'access_key': this.accessKey,
        'secret_key': this.secretKey,
        'queue_name': this.accessKey,
        'squad_name': this.testSquad
      })
      this.$http.post(this.masterAddr + '/applyNode', body).then(response => {
        let body = response.body
        if (body.code !== 1000) {
          return
        }
        let data = body.data
        this.servingNode = data.node
        this.token = data.token
      })
    },
    pullMessage () {
      if (this.testingUnavailable) {
        return
      }
      this.$http.post(this.servingNode + '/messages', this.apiJSONparams).then(response => {
        let data = response.body.data
        let time = this.timeFormat(new Date())
        let entry = {time: time, messages: [{message_id: 0}]}
        if (data !== null && data.length > 0) {
          entry.messages = data
          this.reportReceived()
        }

        this.messageLogs.push(entry)
        if (this.messageLogs.length > 4) {
          this.messageLogs.shift()
        }
      }, response => {
        this.servingNode = ''
        console.log(response)
      })
    },
    pushMessage () {
      let _this = this
      this.$prompt('Input Message', 'Ready To Push', {
        confirmButtonText: 'Push it',
        cancelButtonText: 'Cancel',
        inputValidator: function (content) {
          if (content === null || content === undefined || content === '') {
            return 'Can not push empty message'
          } else if (content.length > 20) {
            return 'Content is too long'
          }
          console.log(content)
          _this.newMessage = content
          return true
        }
      }).then(({ value }) => {
        this.applyMessageID(function () {
          _this.$http.post(_this.servingNode + '/message', _this.apiJSONparams).then(response => {
            _this.newMessage = ''
            console.log(response.data)
            _this.$message({
              type: 'success',
              message: 'Message pushed'
            })
          }, response => {
            _this.$message({
              type: 'warning',
              message: 'Failed to push message'
            })
          })
        })
      })
    },
    applyMessageID (push) {
      this.$http.post(this.servingNode + '/messageID', this.apiJSONparams).then(response => {
        console.log(response.data)
        let data = response.body.data
        this.nextId = data['message_id_end']
        console.log('nextID', this.nextId)
        push()
      }, response => {
      })
    },
    reportReceived () {
      this.$http.post(this.servingNode + '/receivedMessageID', this.apiJSONparams).then(response => {
      }, response => {
        console.log(response)
      })
    },
    messagesLogsSlice (n) {
      console.log(this.messageLogs.length)
    },
    timeFormat (myDate) {
      return '[' + myDate.toLocaleTimeString('en-GB') + ']'
    },
    messagesEntryFormat (messages) {
      return '[' + messages.map(function (obj) {
        if (obj.message_id === 0) {
          return 'wait for new messages'
        }

        return obj.message_id + '-' + '"' + obj.content + '"'
      }).join(', ') + ']'
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

.try {
  margin: 0 auto;
}

.messages-header {
  text-align: left;
}

.header-text {
  font-size: 1.3em;
  line-height: 30px;
}

.item {
  text-align: left;
}
</style>
