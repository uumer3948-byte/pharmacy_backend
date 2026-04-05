let medicines=[]
let cart=[]

async function loadMedicines(){

let res=await fetch("http://127.0.0.1:8010/medicines")

medicines=await res.json()

renderProducts(medicines)

}

function renderProducts(list){

    let html=""
    
    list.forEach(m=>{
    
    let badgeClass = m.quantity < 10 ? "low" : "good"
    
    html += `
    
    <div class="productCard">
    
    <img class="productImage" src="https://via.placeholder.com/80?text=Med">
    
    <div class="productName">${m.name}</div>
    
    <div class="productPrice">₹${m.selling_price}</div>
    
    <div class="badge ${badgeClass}">
    Stock: ${m.quantity}
    </div>
    
    <button class="quickAdd" onclick="addToCart(${m.id})">
    Add
    </button>
    
    </div>
    
    `
    
    })
    
    document.getElementById("productsGrid").innerHTML = html
    
    }

function addToCart(id){

let med=medicines.find(m=>m.id===id)

let existing=cart.find(c=>c.id===id)

if(existing){
existing.qty++
}else{
cart.push({...med,qty:1})
}

renderCart()

}

function renderCart(){

let html=""
let total=0

cart.forEach(c=>{

total+=c.qty*c.selling_price

html+=`

<div class="cartItem">

<div>${c.name} x ${c.qty}</div>

<div>₹${c.qty*c.selling_price}</div>

</div>

`

})

document.getElementById("cart").innerHTML=html
document.getElementById("total").innerText=total

}

function openCustomerModal(){

if(cart.length===0){
alert("Cart empty")
return
}

document.getElementById("customerModal").style.display="flex"

}

function openPayment(){

document.getElementById("customerModal").style.display="none"
document.getElementById("paymentModal").style.display="flex"

}

function setPayment(){

document.getElementById("paymentModal").style.display="none"

showInvoice()

}

function showInvoice(){

let html="<h3>Receipt</h3><hr>"

cart.forEach(c=>{
html+=`<p>${c.name} x ${c.qty} = ₹${c.qty*c.selling_price}</p>`
})

html+=`<hr><b>Total ₹${document.getElementById("total").innerText}</b>`

document.getElementById("invoiceContent").innerHTML=html

document.getElementById("invoiceModal").style.display="flex"

}

async function printInvoice(){

document.getElementById("invoiceModal").style.display="none"

let items=cart.map(c=>({id:c.id,quantity:c.qty}))

await fetch("http://127.0.0.1:8010/sale",{
method:"POST",
headers:{"Content-Type":"application/json"},
body:JSON.stringify({items:items})
})

window.print()

cart=[]
renderCart()

}

document.getElementById("searchInput").addEventListener("keyup",(e)=>{

let text=e.target.value.toLowerCase()

let filtered=medicines.filter(m=>m.name.toLowerCase().includes(text))

renderProducts(filtered)

})

window.onload=loadMedicines
// ---------- AI MEDICINE SCANNER ----------

function openAIScanner(){

    document.getElementById("aiImageUpload").click()
    
    }
    
    document
    .getElementById("aiImageUpload")
    .addEventListener("change", uploadAIImage)
    
    async function uploadAIImage(e){
    
    let file = e.target.files[0]
    
    if(!file){
    return
    }
    
    let formData = new FormData()
    
    formData.append("file", file)
    
    try{
    
    let res = await fetch("http://127.0.0.1:8010/detect-medicine",{
    
    method:"POST",
    body:formData
    
    })
    
    let data = await res.json()
    
    matchDetectedMedicine(data.detected)
    
    }catch(err){
    
    console.error(err)
    
    alert("AI scan failed")
    
    }
    
    }
    
    async function matchDetectedMedicine(text){

        let found=false
        let detectedName=""
        
        medicines.forEach(m=>{
        
        if(text.includes(m.name.toLowerCase())){
        
        addToCart(m.id)
        
        alert("Detected medicine: "+m.name)
        
        found=true
        
        }
        
        })
        
        if(!found){
        
        detectedName=text.split("\n")[0].trim()
        
        alert("Medicine not found.\nAdding to order list: "+detectedName)
        
        await fetch("http://127.0.0.1:8010/order-medicine",{
        
        method:"POST",
        headers:{
        "Content-Type":"application/json"
        },
        body:JSON.stringify({
        name:detectedName
        })
        
        })
        
        }
        
        }
    // AI IMAGE SCANNER

function openAIScanner(){

    document.getElementById("aiImageUpload").click()
    
    }
    
    document
    .getElementById("aiImageUpload")
    .addEventListener("change",uploadAIImage)
    
    async function uploadAIImage(e){
    
    let file=e.target.files[0]
    
    if(!file){
    return
    }
    
    let formData=new FormData()
    
    formData.append("file",file)
    
    try{
    
    let res=await fetch("http://127.0.0.1:8010/detect-medicine",{
    
    method:"POST",
    body:formData
    
    })
    
    let data=await res.json()
    
    matchDetectedMedicine(data.detected)
    
    }catch(err){
    
    console.error(err)
    
    alert("Scan failed")
    
    }
    
    }