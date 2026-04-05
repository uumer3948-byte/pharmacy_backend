const { app, BrowserWindow } = require("electron")

function createWindow(){

const win = new BrowserWindow({

width:1300,
height:850,

webPreferences:{
nodeIntegration:true,
contextIsolation:false
}

})

// disable cache
win.webContents.session.clearCache()

// load frontend from FastAPI
win.loadURL("http://127.0.0.1:8010/frontend/index.html")

// open dev tools
win.webContents.openDevTools()

}

app.whenReady().then(createWindow)