async function loadComponent(id,file){

    let res = await fetch(file)
    
    let html = await res.text()
    
    document.getElementById(id).innerHTML = html
    
    }