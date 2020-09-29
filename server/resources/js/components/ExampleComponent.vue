<template>
    <div class="container">
        <div class="row justify-content-center">
            <div class="row col-md-12 mt-5">
                <div class="col-md-4">
                         <div class="card">
                    <div class="card-header">Notification</div>

                    <div class="card-body">
                        <button type="button" class="btn btn-primary" v-on:click.prevent="sendNotification">Send</button>
                    </div>
                </div>
                </div>
                 <div class="col-md-4">
                       <div class="card mb-4">
                    <div class="card-header">Public Chat</div>

                    <div class="card-body">
                         <div class="col-md-12">
                             <ul style="list-style-type:none">
                                <li v-for="message in public_messages" :key="message.message">
                                      <b>[{{ message.sender }}] says: </b> 
                                         {{ message.message }}
                                </li>
                            </ul>
                         </div>
                         <form>
                            <div class="form-group">
                            <textarea class="form-control" v-model="public_message" placeholder="message"></textarea>
                            </div>
                         <button  class="btn btn-primary" v-on:click.prevent="sendToAll">Send</button>
                         </form>
                    </div>
                </div>
                </div>
                 <div class="col-md-4">
                       <div class="card mb-4">
                    <div class="card-header">Private Chat</div>

                    <div class="card-body">
                         <div class="col-md-12">
                             <ul style="list-style-type:none">
                                <li v-for="message in messages" :key="message.message">
                                      <b v-if="message.sender != name">[{{ message.sender }}] says: </b> 
                                      <b v-if="message.sender == name"> Me: </b>
                                        {{ message.message }}
                                </li>
                            </ul>
                         </div>
                        <form>
                        <div class="form-group">
                     
                         <input type="text"  class="form-control"  v-model="email" placeholder="email">
                        </div>
                         <div class="form-group">
                          <textarea class="form-control" v-model="message" placeholder="message"></textarea>
                         </div>
                         <button  class="btn btn-primary" v-on:click.prevent="pmUser">Send</button>
                         </form>
                    </div>
                </div>
                </div>
            </div>

        </div>
    </div>
</template>

<script>
    export default {
        props:['user'],

        data() {
          return { 
               name: this.user.name,
               userID: null,
               email: null,
               message : "",
               messages : [],
               public_messages : [],
               public_message : null
          }  
        },
        mounted() {
            let userchannel =  Echo.private('user.' + this.user.id)
            userchannel.listen('UserEvent', (data) => this.messages.push(data))

            let chatchannel =  Echo.channel('chat-channel')
            chatchannel.listen('ChatEvent', (data) => this.public_messages.push(data))

            let notiication =  Echo.channel('notification-channel')
            notiication.listen('NotificationEvent', (data) =>{this.$toast.success(data.message, 'Notification');})
        },
        methods: {
            sendNotification(){
                 window.axios.post('/send-notification',{});
            },
            sendToAll(){
                window.axios.post('/send-public-message',{ message:this.public_message, sender: this.user.name});
                this.public_messages.push({message:this.public_message, sender: this.user.name})
            },
            pmUser(){
                window.axios.post('/send-private-message',{email: this.email, message:this.message, sender: this.user.name});
                this.messages.push({user:this.user.name, message:this.message, sender: this.user.name})
            }
        }
    }
</script>
