const express = require('express')
const app = express()
const http = require('http')
const server = http.createServer(app)
const port = process.env.PORT || 3000
const socketio = require('socket.io')
const io = socketio(server)

app.get('/',(req,res)=>{
    res.send("Node server is running!!!")
})

io.on('connection',(socket)=>{
    socket.on('sendMessage',(message)=>{
        socket.broadcast.emit('receiveMessage',message)
    })
})

server.listen(port,()=>{
    console.log('Server is up and running on port '+port)
})